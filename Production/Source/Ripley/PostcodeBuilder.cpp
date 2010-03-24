// PostcodeBuilder.cpp: implementation of the CPostcodeBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "PostcodeBuilder.h"
#include "Postcoder.h"
#include "User.h"
#include "postcodeparser.h"
#include "xmlcookie.h"
#include "Config.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CPostcodeBuilder::CPostcodeBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CPostcodeBuilder::~CPostcodeBuilder()
{
}

bool CPostcodeBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "POSTCODE", true);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (m_InputContext.ParamExists("place")) 
	{
		CPostcoder Postcoder(m_InputContext);
		bool bGotPostcode;
		CTDVString sPlace;
		m_InputContext.GetParamString("place", sPlace);
		if (sPlace.GetLength() > 0)
		{
			Postcoder.MakePlaceRequest(sPlace, bGotPostcode);
			if (bGotPostcode) 
			{
				CTDVString sPostcode;
				CTDVString sArea;
				CTDVString sAuthID;
				int iNode = 0;
				Postcoder.PlaceHitPostcode(sPostcode, sAuthID, sArea, iNode);

				if (pViewingUser != NULL)
				{
					// Update the users details
					Postcoder.UpdateUserPostCodeInfo(sPostcode,sArea,iNode);
					pPage->RemoveTag("USER");
					pPage->AddInside("H2G2", "<POSTCODEADD/>");
				}
				pPage->AddInside("VIEWING-USER", pViewingUser);
			}
			else
			{
				pPage->AddInside("H2G2", &Postcoder);
			}
		}
	}
	else if (m_InputContext.ParamExists("postcode") || m_InputContext.ParamExists("viewpostcode")) 
	{
		CPostcoder Postcoder(m_InputContext);
		CTDVString sPlace;
		if (m_InputContext.ParamExists("postcode"))
		{
			// Check to see if the site is closed. If it is, then you can't change your postcode, as it will try to auto tag afterwards.
			bool bSiteClosed = true;
			if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
			{
				// Report the error
				SetDNALastError("CPostcodeBuilder::Build","FailedToCheckSiteOpen","Failed checking if site is closed");
				return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
			if (bSiteClosed && (pViewingUser == NULL || !pViewingUser->GetIsEditor()))
			{
				// Report the error
				SetDNALastError("CPostcodeBuilder::Build","SiteClosed","Cannot change postcode when the site is closed!!!");
				return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}
            m_InputContext.GetParamString("postcode", sPlace);
		}
		else
		{
			m_InputContext.GetParamString("viewpostcode", sPlace);
		}

		if (sPlace.GetLength() > 0)
		{
			bool bGotPostcode = false;
			Postcoder.MakePlaceRequest(sPlace, bGotPostcode);
			if (bGotPostcode) 
			{
				CTDVString sPostcode, sArea, sAuthID;
				int iNode = 0;
				if (Postcoder.PlaceHitPostcode(sPostcode, sAuthID, sArea, iNode))
				{
					// If we've got a valid user and we're setting the postcode, update the users details a
					if (pViewingUser != NULL && m_InputContext.ParamExists("postcode"))
					{
						// Update the users details
						Postcoder.UpdateUserPostCodeInfo(sPostcode,sArea,iNode);
						pPage->RemoveTag("USER");
						pPage->AddInside("VIEWING-USER", pViewingUser);
						pPage->AddInside("H2G2", "<POSTCODEADD/>");
					}

					// Add the civic data to the returning page
					CTDVString sXML = "<CIVICDATA POSTCODE='";
					sXML << sPostcode << "'/>";
					pPage->AddInside("H2G2", sXML);
					pPage->AddInside("CIVICDATA", &Postcoder);
				}
				else
				{
					// Report the error
					SetDNALastError("CPostcodeBuilder::Build","FailedPlaceHitPostcode","Failed to place hit given postcode");
					return pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				}
			}
			else
			{
				pPage->AddInside("H2G2", "<BADPOSTCODE/>");
			}
		}
	}
	else if (m_InputContext.ParamExists("civic"))
	{
		CTDVString sPostcode;
		if (m_InputContext.ParamExists("civicpostcode")) 
		{
			m_InputContext.GetParamString("civicpostcode", sPostcode);
		}
		else
		{
			if (pViewingUser != NULL)
			{
				pViewingUser->GetPostcode(sPostcode);
			}
		}
		if (sPostcode.GetLength() > 0) 
		{
			CPostcoder Postcoder(m_InputContext);
			bool bGotPostcode = false;
			Postcoder.MakePlaceRequest(sPostcode, bGotPostcode);
			if (bGotPostcode) 
			{
				CTDVString sXML = "<CIVICDATA POSTCODE='";
				sXML << sPostcode << "'/>";
				pPage->AddInside("H2G2", sXML);
				pPage->AddInside("CIVICDATA", &Postcoder);
			}
		}
	}
	else  if (m_InputContext.ParamExists("set_postcode"))
	{
		//allows non-logged on users to specify a postcode 
		CTDVString sXML = "";						
		
		//must be provided
		CTDVString sRedirect = "";
		//if ( (m_InputContext.ParamExists("s_returnto") == false, m_InputContext.GetParamString("s_returnto", sRedirect) ) && ( sRedirect.IsEmpty( )))
		if ( (m_InputContext.ParamExists("s_returnto") == false) || (m_InputContext.GetParamString("s_returnto", sRedirect) ==false) || (sRedirect.IsEmpty( )==true) )
		{
			//the returnto param must be provided
			SetDNALastError("CPostcodeBuilder::Build", "ReturnToPageNotSupplied", "Return-To page was not not supplied");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			return true;
		}

		//incase something goes wrong, an error message may be displayed on the postcode builder derived page
		//if the user is prompted to retry again from this page, we would have a note of whether the oroginal 
		//request came from should that request pass 
		sXML	=		"";	
		sXML <<	"<RETURN_TO>";
		sXML <<	"\n"; 
		sXML <<	sRedirect;
		sXML <<	"</RETURN_TO>";
		sXML <<	"\n"; 
		pPage->AddInside("H2G2", sXML);
		
		CTDVString sPostcode;
		if  ( (m_InputContext.GetParamString("set_postcode", sPostcode) ==false) ||  ( sPostcode.IsEmpty( ) ==true) )
		{			
			SetDNALastError("CPostcodeBuilder::Build", "PostcodeNotSupplied", "Postcode was not not supplied");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			return true;
		}
				
		//detect if string is a postcode
		CPostCodeParser oPostCodeParser ;		
		if (oPostCodeParser.IsPostCode(sPostcode) == false)
		{
			SetDNALastError("CPostcodeBuilder::Build", "PostcodeNotValid", "Postcode is not valid");
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			return true;
		}

		//Get Standardised BBC Postcoder cookie from postcode
		CTDVString sBBCPostcode;
		if ( m_InputContext.PostcoderPlaceCookieRequest(sPostcode,sBBCPostcode) )
		{
		
			//declare container for cookie objects
			CXMLCookie::CXMLCookieList oCookieList;
		
			//declare cookie instance (can be more than one)
			CXMLCookie oXMLCookie (m_InputContext.GetPostcoderCookieName(), sBBCPostcode, "", true);	
		
			//add to list
			oCookieList.push_back(oXMLCookie);		
		
			pPage->RedirectWithCookies(sRedirect, oCookieList);
		}
		else
		{
			SetDNALastError("CPostcodeBuilder::Build", "Unable to create Postcode", sBBCPostcode);
			pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
	}

	return true;
}