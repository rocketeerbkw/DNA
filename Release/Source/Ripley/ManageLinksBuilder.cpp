// ManageLinksBuilder.cpp: implementation of the CManageLinksBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ManageLinksBuilder.h"
#include "Link.h"
#include "Club.h"
#include "TDVAssert.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CManageLinksBuilder::CManageLinksBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CManageLinksBuilder::~CManageLinksBuilder()
{

}

bool CManageLinksBuilder::Build(CWholePage* pPage)
{
	InitPage(pPage, "MANAGELINKS", true);
	
	CUser* pViewer = m_InputContext.GetCurrentUser();

	if (pViewer == NULL)
	{
		pPage->AddInside("H2G2", "<ERROR TYPE='1' REASON='notregistered'/>");
	}
	else
	{
		//cater for new ican functionality for editing existitng links.
		//The code could have been placed in CXMLBuilder where
		//the bulk of link-related code resides in . However in order to 
		//comply with new DNA guidelines on Builders and XML objects,
		//the new functionality that realtes to input context wil be 
		//in this builder class which is Link specific. see file:\\C:\Projects\Ripley\xmlbuilder.cpp
		if (m_InputContext.ParamExists("action"))
		{
			#define LINE_TO_STRING(x)				 #x
			#define LINE_TO_STRING_EXPANDED(x)		LINE_TO_STRING(x)
			#define COMPILE_MESSAGE(description)		  __FILE__"("LINE_TO_STRING_EXPANDED(__LINE__) ") :" ##description
			#pragma message (COMPILE_MESSAGE("Delete these four lines later"))

			CTDVString sAction;		
			m_InputContext.GetParamString("action",sAction);
			if ( sAction.CompareText("view") || sAction.CompareText("edited"))
			{
				CUser* pViewingUser = m_InputContext.GetCurrentUser();
				int iUserID = pViewingUser->GetUserID();
				int iSiteID = m_InputContext.GetSiteID();
				int iLinkID = m_InputContext.GetParamInt("linkid");
				CTDVString sCmd;		
				m_InputContext.GetParamString("cmd",sCmd);
				if ( sCmd.IsEmpty() )
				{
					CLink Link(m_InputContext);		
					if (Link.GetClubLinkDetails(iLinkID)==false)
					{
						pPage->AddInside("H2G2", Link.GetLastErrorAsXMLString());
						return true;
					}
					pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
					pPage->AddInside("H2G2/MANAGELINK", "<ACTION>VIEW</ACTION>");
					if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
					{
						pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
					}
					else
					{
						pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
					}
					pPage->AddInside("H2G2/MANAGELINK", &Link);
					return true;
				}
				else if (sCmd.CompareText("save"))
				{
					CLink Link(m_InputContext);		
					CTDVString sTitle, sURL, sDesc;
					m_InputContext.GetParamString("title", sTitle);
					if (sTitle.IsEmpty( ))
					{
						SetDNALastError("CManageLinksBuilder::Build","NoTitleValue","The Title parameter was supplied, but with an invalid value");
						pPage->AddInside("H2G2", GetLastErrorAsXMLString());
						if (Link.GetClubLinkDetails(iLinkID)==true)
						{
							pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
							pPage->AddInside("H2G2/MANAGELINK", "<ACTION>VIEW</ACTION>");
							if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
							}
							else
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
							}
							pPage->AddInside("H2G2/MANAGELINK", &Link);
						}
						return true;
					}
					m_InputContext.GetParamString("url", sURL);
					if (sURL.IsEmpty( ))
					{
						SetDNALastError("CManageLinksBuilder::Build","NoURLValue","The URL parameter was supplied, but with an invalid value");
						pPage->AddInside("H2G2", GetLastErrorAsXMLString());
						if (Link.GetClubLinkDetails(iLinkID)==true)
						{
							pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
							pPage->AddInside("H2G2/MANAGELINK", "<ACTION>VIEW</ACTION>");
							if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
							}
							else
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
							}
							pPage->AddInside("H2G2/MANAGELINK", &Link);
						}
						return true;
					}
					m_InputContext.GetParamString("desc", sDesc);
					if (sDesc.IsEmpty( ))
					{
						SetDNALastError("CManageLinksBuilder::Build","NoDescriptionValue","TheDescription parameter was supplied, but with an invalid value");
						pPage->AddInside("H2G2", GetLastErrorAsXMLString());
						if (Link.GetClubLinkDetails(iLinkID)==true)
						{
							pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
							pPage->AddInside("H2G2/MANAGELINK", "<ACTION>VIEW</ACTION>");
							if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
							}
							else
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
							}
							pPage->AddInside("H2G2/MANAGELINK", &Link);
						}
						return true;
					}

					// Check to make sure we have a logged in user or editor /if unable to do so then report error 
					if (pViewingUser == NULL)
					{
						// this operation requires a logged on user
						SetDNALastError("CManageLinksBuilder::Build", "UserNotLoggedIn", "User Not Logged In");
						pPage->AddInside("H2G2",GetLastErrorAsXMLString());
						if (Link.GetClubLinkDetails(iLinkID)==true)
						{
							pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
							pPage->AddInside("H2G2/MANAGELINK", "<ACTION>VIEW</ACTION>");
							if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
							}
							else
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
							}
							pPage->AddInside("H2G2/MANAGELINK", &Link);
						}
						return true;
					}
					
					if (Link.EditClubLinkDetails(pViewingUser, iLinkID, sTitle, sURL, sDesc)==false)
					{																
						pPage->AddInside("H2G2", Link.GetLastErrorAsXMLString());
							if (Link.GetClubLinkDetails(iLinkID)==true)
						{
							pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
							pPage->AddInside("H2G2/MANAGELINK", "<ACTION>VIEW</ACTION>");
							if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
							}
							else
							{
								pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
							}
							pPage->AddInside("H2G2/MANAGELINK", &Link);
						}
						return true;
					}
					pPage->AddInside("H2G2", "<MANAGELINK></MANAGELINK>");
					pPage->AddInside("H2G2/MANAGELINK", "<ACTION>EDITED</ACTION>");
					if ( Link.IsLinkEditableByUser(iLinkID, pViewingUser))
					{
						pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>1</EDITABLEBYUSER>");
					}
					else
					{
						pPage->AddInside("H2G2/MANAGELINK", "<EDITABLEBYUSER>0</EDITABLEBYUSER>");
					}
					pPage->AddInside("H2G2/MANAGELINK", &Link);
					return true;
				}				
			}
			else
			{
				//TDVASSERT(false, "The Action paramter is invalid in CManageLinksBuilder::Build");
				//#pragma message (COMPILE_MESSAGE("Need to complete what happens when action parameter is supplied, but with an invalid value"))
				SetDNALastError("CManageLinksBuilder::Build","NoActionValue","The Action parameter was supplied, but with an invalid value");
				pPage->AddInside("H2G2", GetLastErrorAsXMLString());
				return true;
			}
		}
		else
		{
			//maintain existing behaviour
			int iClubID = m_InputContext.GetParamInt("clubid");
			int iSkip = m_InputContext.GetParamInt("skip");
			int iShow = m_InputContext.GetParamInt("show");
			CTDVString sLinkGroup;
			m_InputContext.GetParamString("linkgroup", sLinkGroup);
			ManageClippedLinks(pPage);
			CLink Link(m_InputContext);
			bool bShowPrivate = true;
			Link.GetUserLinks(pViewer->GetUserID(), sLinkGroup, bShowPrivate, iSkip, iShow);
			CTDVString sXML;
			sXML << "<USERLINKS USERID='" << pViewer->GetUserID() << "'/>";
			pPage->AddInside("H2G2", sXML);
			sXML.Empty();
			pPage->AddInside("USERLINKS", &Link);
			Link.GetUserLinkGroups(pViewer->GetUserID());
			pPage->AddInside("USERLINKS", &Link);
			CClub Club(m_InputContext);
			Club.GetAllEditableClubs(pViewer->GetUserID());
			pPage->AddInside("H2G2", &Club);
			Club.GetEditableClubLinkGroups(pViewer->GetUserID());
			pPage->AddInside("H2G2", &Club);

			if (iClubID > 0)
			{
				bool bShowPrivateClubLinks = false;
				if (pViewer != NULL)
				{
					bShowPrivateClubLinks = pViewer->GetIsEditor() || Club.IsUserInTeamMembersOfClub(pViewer->GetUserID(),iClubID);
				}
				m_InputContext.GetParamString("clubgroup", sLinkGroup);
				Link.GetClubLinks(iClubID, sLinkGroup, bShowPrivateClubLinks);
				pPage->AddInside("H2G2", &Link);
			}
		}
	}
	return true;
}
