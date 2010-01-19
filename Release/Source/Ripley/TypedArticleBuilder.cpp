// TypedArticleBuilder.cpp: implementation of the CTypedArticleBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "User.h"
#include "MultiStep.h"
#include "ExtraInfo.h"
#include "TypedArticleBuilder.h"
#include "GuideEntry.h"
#include "tdvassert.h"
#include "XMLTree.h"
#include "ReviewSubmissionForum.h"
#include "ProfanityFilter.h"
#include "Category.h"
#include "TagItem.h"
#include ".\typedarticlebuilder.h"
#include "EventQueue.h"
#include "CurrentClubs.h"
#include "profanityfilter.h"
#include "club.h"
#include "DnaUrl.h"
#include "MediaAsset.h"
#include "MediaAssetModController.h"
#include "mediaAssetSearchPhrase.h"
#include "ArticleSearchPhrase.h"
#include "EmailAddressFilter.h"
#include "URLFilter.h"
#include "DateRangeValidation.h"
#include "XMLObject.h"

#include <algorithm>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

class CArticleDateRange
{
public:
	int iStartDay;
	int iStartMonth;
	int iStartYear;

	int iEndDay;
	int iEndMonth;
	int iEndYear;

	int iTimeInterval;

	CArticleDateRange()
	{
		iStartDay = 0;
		iStartMonth = 0;
		iStartYear = 0;
		iEndDay = 0;
		iEndMonth = 0;
		iEndYear = 0;
		iTimeInterval = -1;
	}
};


CTypedArticleBuilder::CTypedArticleBuilder(CInputContext& inputContext)
:
CXMLBuilder(inputContext),
m_pPage(NULL), m_pViewer(NULL)
{
	m_pDateRangeVal = new CDateRangeValidation(inputContext);
}

CTypedArticleBuilder::~CTypedArticleBuilder()
{

}

/*********************************************************************************

	bool CTypedArticleBuilder::Build(CWholePage* pPage)

	Author:		Dharmesh Raithatha
	Created:	8/18/2003
	Inputs:		-
	Outputs:	-
	Returns:	created page or NULL if unsuccessful	
	Purpose:	Manages the creation, previewing and editing of typedarticlepages

*********************************************************************************/

bool CTypedArticleBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	InitPage(m_pPage, "TYPED-ARTICLE",true);
	
	m_pViewer = m_InputContext.GetCurrentUser();
	
	//This builder can only be used by a logged in user
	
	if (m_pViewer == NULL)
	{
		return ErrorMessage("UNREGISTERED","You cannot add or edit Guide Entries unless you are registered as a researcher and currently logged on.");
	}

	// Check to see if the site is closed, if so then only editors can do anything at this point!	
	bool bSiteClosed = false;
	if (!m_InputContext.IsSiteClosed(m_InputContext.GetSiteID(),bSiteClosed))
	{
		// Report back to the user
		return ErrorMessage("SITEDETAILS","Failed to get the sites open / close status.");
	}
	if (bSiteClosed && !m_pViewer->GetIsEditor())
	{
		// Report back to the user
		return ErrorMessage("SITECLOSED","You cannot add or edit Guide Entries while the site is closed.");
	}

	/*
	bool bIsBanned = false;
	if (m_pForm == NULL || !m_pForm->IsMasthead() || (m_InputContext.GetSiteID() == m_pForm->GetSiteID()))
	{
		bIsBanned = m_pViewer->GetIsBannedFromPosting();
	}
	else
	{
		CUser user(m_InputContext);
		user.SetSiteID(m_pForm->GetSiteID());
		user.CreateFromID(m_pViewer->GetUserID());
		bIsBanned = user.GetIsBannedFromPosting();
	}

	if (bIsBanned)
	{
		// pointer should be NULL, but delete it just in case anyhow
		bSuccess = InitPage(m_pPage, "ERROR",true);
		
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='RESTRICTED-USEREDIT'>You are restricted from adding or editing Guide Entries.</ERROR>");
		
		return bSuccess;
	}
	*/
	if (m_InputContext.ParamExists("acreate") || m_InputContext.ParamExists("acreatecancelled"))
	{
		return CreateTypedArticle();
	}
	
	if (m_InputContext.ParamExists("apreview"))
	{
		int iH2G2ID = 0;

		if (m_InputContext.ParamExists("h2g2id"))
		{
			iH2G2ID = m_InputContext.GetParamInt("h2g2id");
		}

		return PreviewTypedArticle(iH2G2ID);
	}
	
	if (m_InputContext.ParamExists("aedit"))
	{
		
		if (m_InputContext.ParamExists("h2g2id"))
		{
			int iH2G2ID = 0;
			iH2G2ID = m_InputContext.GetParamInt("h2g2id");
			return EditTypedArticle(iH2G2ID);
		}
		else
		{
			return ErrorMessage("INVALID-PARAMETER","The page you requested was supplied with invalid parameters");
		}
	}
	
	if(m_InputContext.ParamExists("aupdate") || m_InputContext.ParamExists("aupdatecancelled"))
	{
		if (m_InputContext.ParamExists("h2g2id"))
		{
			int iH2G2ID = 0;
			iH2G2ID = m_InputContext.GetParamInt("h2g2id");
			
			return UpdateTypedArticle(iH2G2ID);
		}
		else
		{
			return ErrorMessage("INVALID-PARAMETER","The page you requested was supplied with invalid parameters");
		}
	}

	
	if(m_InputContext.ParamExists("adelete"))
	{
		if (m_InputContext.ParamExists("h2g2id"))
		{
			int iH2G2ID = 0;
			iH2G2ID = m_InputContext.GetParamInt("h2g2id");
			
			return DeleteTypedArticle(iH2G2ID);
		}
		else
		{
			return ErrorMessage("INVALID-PARAMETER","The page you requested was supplied with invalid parameters");
		}
	}

	if ( m_InputContext.ParamExists("aundelete") )
	{
		//Allow Article to be UnHidden where it was user-hidden.
		if (m_InputContext.ParamExists("h2g2id"))
		{
			return UnDeleteTypedArticle(m_InputContext.GetParamInt("h2g2id"));
		}
		else
		{
			return ErrorMessage("INVALID-PARAMETER","The page you requested was supplied with invalid parameters");
		}
	}

	if(m_InputContext.ParamExists("asetresearchers"))
	{
		if (m_InputContext.ParamExists("h2g2id"))
		{
			return SetResearchers( m_InputContext.GetParamInt("h2g2id") );
		}
		else
		{
			return ErrorMessage("INVALID-PARAMETER","The page you requested was supplied with invalid parameters");
		}
	}

	return ErrorMessage("INVALID-PARAMETER","The page you requested was supplied with invalid parameters");
}

/*********************************************************************************

	bool CTypedArticleBuilder::CreateTypedArticle()

	Author:		Dharmesh Raithatha
	Created:	8/18/2003
	Inputs:		-
	Outputs:	-
	Returns:	Wholepage or NULL in exceptional Error
	Purpose:	Uses the MultiStep process to create a typedarticle. 

*********************************************************************************/

bool CTypedArticleBuilder::CreateTypedArticle()
{
	if (CheckIsUserBanned(0))
	{
		bool bSuccess = true;
		// pointer should be NULL, but delete it just in case anyhow
		bSuccess = InitPage(m_pPage, "ERROR", true);
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='RESTRICTED-TYPEDARTICLE'>You are restricted from adding or editing Guide Entries.</ERROR>");
		return bSuccess;
	}

	CMultiStep Multi(m_InputContext, "TYPED-ARTICLE-CREATE");
	CExtraInfo ExtraInfo;
	CTDVString sNewBodyXML,sTitle;
	int iSubmittable = 0, iType=1, iStatus=3, iHideArticle = 0;
	int iSiteID = m_InputContext.GetSiteID();
	bool bSiteUsesGuestBookStyle = m_InputContext.DoesSiteUseArticleGuestBookForums(iSiteID);
	int iArticleForumStyle = 0;
	if (bSiteUsesGuestBookStyle)
		iArticleForumStyle = 1;
	
	bool bArchive = false;
	bool bUpdateDateCreated = false;
	CTDVString sWhoCanEdit = ARTICLE_CANEDIT_MEONLY;

	// Vector of poll types user wants to create for this article
	std::vector< POLLDATA > vecPollTypes;
	
	// Autoclip
	int iLinkClub;
	CTDVString sLinkClubRelationship;

	/****************************************************************************
	 New for Media Assets
	****************************************************************************/
	CTDVString sCaption;
	CTDVString sFilename;
	CTDVString sMimeType;
	int iContentType;
	CTDVString sKeyPhrases;
	CTDVString sDescription;
	const char *pFileBuffer; 
	int iFileLength=0;
	int iMediaAssetID = 0;
	CTDVString sMultiElementsXML = "";
	CTDVString sExternalLinkURL ="";
	CTDVString sNamespacedKeyPhrases;
	CTDVString sNamespaces;

	CTDVString sReturnedXML;
						   
	bool bManualUpload = false;
	bool bHasAsset = false;
	bool bAddToLibrary = false;
	bool bHasKeyPhrases = false;
	bool bExternalLink = false;

	if (m_InputContext.ParamExists("hasasset"))
	{
		if (m_InputContext.GetParamInt("hasasset") == 1)
		{
			bHasAsset = true;
		}
	}
	if (m_InputContext.ParamExists("manualupload"))
	{
		if (m_InputContext.GetParamInt("manualupload") == 1)
		{
			bManualUpload = true;
		}
	}
	if (m_InputContext.ParamExists("addtolibrary"))
	{
		if (m_InputContext.GetParamInt("addtolibrary") == 1)
		{
			bAddToLibrary = true;
		}
	}
	if (m_InputContext.ParamExists("haskeyphrases"))
	{
		if (m_InputContext.GetParamInt("haskeyphrases") == 1)
		{
			bHasKeyPhrases = true;
		}
	}

	// Site Optionable Allow External Links on Media Assets
	if (m_InputContext.DoesCurrentSiteAllowedMAExternalLinks())
	{
		if (m_InputContext.ParamExists("externallink"))
		{
			if (m_InputContext.GetParamInt("externallink") == 1)
			{
				bExternalLink = true;
			}
		}
	}

	// Check User is not exceeding article creation limit.
	if ( !m_pViewer->GetIsEditor() )
	{
		// Article Limit of 0 is presumed to be not set.
		int articledailylimit = m_InputContext.GetCurrentSiteOptionInt("GuideEntries", "ArticleDailyLimit");
		if ( articledailylimit > 0 )
		{
			int userarticlecount = 0;
			CStoredProcedure SP;
			if ( !m_InputContext.InitialiseStoredProcedureObject(&SP) || !SP.GetMemberArticleCount(m_InputContext.GetCurrentUser()->GetUserID(), m_InputContext.GetSiteID(),userarticlecount ) )
			{
				Multi.SetToCancelled();
				SetDNALastError("TypedArticle::Create","Create","Unable to retrieve ArticleDailyLimit " + SP.GetLastError());
				m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
			}

			if ( userarticlecount >= articledailylimit )
			{
				Multi.SetToCancelled();
				SetDNALastError("TypedArticle::Create","Create","Article Daily Limit of " + CTDVString(articledailylimit) + " exceeded." );
				m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
				return true;
			}
		}
	}

	/****************************************************************************/


	if (!GetMultiStepInput(Multi,
						   sTitle,
						   sNewBodyXML,
						   ExtraInfo,
						   iSubmittable,
						   iType, 
						   iStatus, 
						   iHideArticle, 
						   bArchive, 
						   sWhoCanEdit, 
						   iArticleForumStyle,
						   iLinkClub,
						   sLinkClubRelationship,
						   bUpdateDateCreated,
						   &vecPollTypes,
						   bHasAsset,
						   bManualUpload,
						   bHasKeyPhrases,
						   bExternalLink,
						   &sCaption,
						   &sFilename, 
						   &sMimeType, 
						   &iContentType,
						   &sMultiElementsXML,
						   &sKeyPhrases, 
						   &sDescription,
						   &pFileBuffer, 
						   &iFileLength,
						   &sExternalLinkURL,
						   &sNamespacedKeyPhrases,
						   &sNamespaces))
	{
		//there were errors in the input
		//so want don't want to create the entry but go back to where we were

		if (ErrorReported())
		{
			Multi.SetToCancelled();
			m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		else
		{
			return true;
		}
	}

	// Check the input to see if we are required to tag the new article to any nodes
	CDNAIntArray NodeArray;
	CheckAndInsertTagNodes(NodeArray);

	if (m_InputContext.ParamExists("acreatecancelled"))
	{
		// The UI wants to do everything acreate does, but don't actually act on the data
		// By using SetToCancelled(), the UI gets a CANCEL="YES" attribute so it can differentiate
		// between a real create command and the "cancelled" version
		Multi.SetToCancelled();
	}

	// Are we ready to use?
	if (Multi.ReadyToUse())
	{
		CStoredProcedure SP;
		if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
		{
			return ErrorMessage("DBERROR","Database Error");
		}

		int iH2G2ID = 0;
		//int iSiteID = m_InputContext.GetSiteID();
		CUser* pUser = m_InputContext.GetCurrentUser();
		int iViewingUserID = pUser->GetUserID();

		bool bPreProcessed = false; // Same as default value in StoredProcedure.h

		// Will also need to set permissions on new article
		bool bDefaultCanRead = true;
		bool bDefaultCanWrite = false;
		bool bDefaultCanChangePermissions = false;
		int iClubID = 0;
		if (sWhoCanEdit.CompareText( ARTICLE_CANEDIT_ALL ))
		{
			bDefaultCanWrite = true;
		}
		else if (sWhoCanEdit.CompareText( ARTICLE_CANEDIT_MEONLY )) 
		{
			bDefaultCanWrite = false;
		}
		else 
		{
			CCurrentClubs CurrentClubs(m_InputContext);
			std::vector<int> clubs;
			CurrentClubs.VerifyUsersClubMembership(m_pViewer, sWhoCanEdit, clubs);
			if (clubs.size() != 0)
				iClubID = clubs[0];
		}

		//take the text part of the guide ml - strip out other GUIDE ML tags
		CTDVString sGuideMLBody = sNewBodyXML; 
		CXMLObject::GuideMLToPlainText(&sGuideMLBody);
		//check content for profanities.
		CTDVString sCheckText = sTitle + " " + sGuideMLBody + " " + sKeyPhrases;
		CProfanityFilter profanityFilter(m_InputContext);
        CTDVString sProfanity;
		CProfanityFilter::FilterState filterState = profanityFilter.CheckForProfanities(sCheckText, &sProfanity);
		bool bProfanitiesFound = false;
		if (filterState == CProfanityFilter::FailBlock)
		{
			bProfanitiesFound = true;
			//check if the filter has been triggered previously
			int iProfanityTriggered = m_InputContext.GetParamInt("profanitytriggered");
			if (iProfanityTriggered > 0)
			{
				//return to user page.
				CTDVString sRedirect("U");
				int iUserID;
				pUser->GetUserID(&iUserID);
				sRedirect << iUserID;			
				m_pPage->Redirect(sRedirect);		
				return true;			
			}
			iProfanityTriggered = 1;
			int iH2G2ID = 0;
			iH2G2ID = m_InputContext.GetParamInt("h2g2id");

			m_pPage->AddInside("H2G2", "<PROFANITYERRORINFO>A Blocked Profanity has been found.</PROFANITYERRORINFO>");

			CTDVString sXML;
			Multi.GetAsXML(sXML);
			m_pPage->AddInside("H2G2", sXML);

			return true;

		}
		else if (filterState == CProfanityFilter::FailRefer)
		{
			bProfanitiesFound = true;
			//put the article into moderation
		}


		if(m_InputContext.IsCurrentSiteURLFiltered() && !(pUser->GetIsEditor() || pUser->GetIsNotable()))
		{
			//check content for not allowed urls.
			CTDVString sCheckText = sTitle + " " + sNewBodyXML + " " + sKeyPhrases;
			CURLFilter oURLFilter(m_InputContext);
			CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sCheckText);

			if (URLFilterState == CURLFilter::Fail)
			{

				m_pPage->AddInside("H2G2", "<NONALLOWEDURLERRORINFO>A Non-Allowed url has been found.</NONALLOWEDURLERRORINFO>");

				CTDVString sXML;
				Multi.GetAsXML(sXML);
				m_pPage->AddInside("H2G2", sXML);

				return true;
			}
		}

		//Filter for email addresses.
		if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(pUser->GetIsEditor() || !pUser->GetIsNotable()))
		{
			CEmailAddressFilter emailfilter;
			CTDVString sCheckText = sTitle + " " + sNewBodyXML;
			if ( emailfilter.CheckForEmailAddresses(sCheckText) )
			{
				m_pPage->AddInside("H2G2", "<NONALLOWEDEMAILERRORINFO>An Email has been found.</NONALLOWEDEMAILERRORINFO>");

				CTDVString sXML;
				Multi.GetAsXML(sXML);
				m_pPage->AddInside("H2G2", sXML);
				return true;
			}
		}

		/****************************************************************************
		//New for Media Assets
		****************************************************************************/
		if (bHasAsset)
		{
			bool bOK = true;
			//If a super user or moderator then put the image up directly and not in moderation form
			bool bSkipModeration = false;
			if (pUser != NULL && pUser->GetIsEditor())
			{
				bSkipModeration = true;
			}

			CMediaAsset oMediaAsset(m_InputContext);
			bOK = oMediaAsset.ExternalCreateMediaAsset(iMediaAssetID, 
														m_InputContext.GetSiteID(), 
														sCaption, 
														sFilename, 
														sMimeType, 
														iContentType, 
														sMultiElementsXML, 
														iViewingUserID, 
														sKeyPhrases, 
														sDescription, 
														bAddToLibrary,
														bManualUpload,
														pFileBuffer,
														iFileLength,
														bSkipModeration,
														sExternalLinkURL,
														sReturnedXML);

			//Wanted to added an asset with this article ..it failed, so fail the article
			if (!bOK)
			{
				CopyDNALastError("CTypedArticleBuilder", oMediaAsset);
				m_pPage->AddInside("H2G2", &oMediaAsset);
				return ErrorMessage("Create Media Asset Failed", GetLastErrorAsXMLString());
			}
			m_pPage->AddInside("H2G2", sReturnedXML);
		}
		/****************************************************************************/
		if ( SP.CreateNewArticle(iViewingUserID,sTitle,sNewBodyXML,ExtraInfo,1,iSiteID,
				iSubmittable,iType,iStatus,&iH2G2ID, bPreProcessed, bDefaultCanRead, 
				bDefaultCanWrite, bDefaultCanChangePermissions, iArticleForumStyle, iClubID) )
		{
			SetArticleDateRangeFromMultiStep(SP, iH2G2ID, *m_pDateRangeVal);

			//Users subscribed to this author should have their subscribed content updated.
			if ( pUser->GetAcceptSubscriptions() )
				SP.AddArticleSubscription(iH2G2ID);
		}

		// Check to see if we're an editor, if so check to make see if we want to hide the article
		if (iH2G2ID > 0 && pUser != NULL && pUser->GetIsEditor())
		{
			// Do we want to hide it?
			if (iHideArticle > 0)
			{
				// Hide the article
				if (!SP.HideArticle(iH2G2ID/10,iHideArticle,0,0,iViewingUserID))
				{
					// Report the error
					SetDNALastError("TypedArticleBuilder::CreateTypedArticle","FailedToHideArticle","Failed to hide the article");
				}
				else if ( bHasAsset )
				{
					CMediaAssetModController mediaassetmod(m_InputContext);
					if ( !mediaassetmod.Reject(iMediaAssetID,sMimeType,false) )
					{
						SetDNALastError("TypedArticleBuilder::CreateTypedArticle","FailedToHideArticle","Failed to hide the article's media asset");
					}
					else
					{
						//Hide Media Asset in DB.
						SP.HideMediaAsset(iMediaAssetID,1);
					}
				}
			}
			else
			{
				// Unhide the article
				if (!SP.UnhideArticle(iH2G2ID/10,0,0,iViewingUserID))
				{
					// Report the error
					SetDNALastError("TypedArticleBuilder::CreateTypedArticle","FailedToUnhideArticle","Failed to unhide the created article!");
				}
				else if ( bHasAsset )
				{
					CMediaAssetModController mediaassetmod(m_InputContext);
					if ( !mediaassetmod.Approve(iMediaAssetID,sMimeType,false) )
					{
						SetDNALastError("TypedArticleBuilder::CreateTypedArticle","FailedToHideArticle","Failed to hide the article's media asset");
					}
					else
					{
						//Unhide Media Asset in DB.
						SP.HideMediaAsset(iMediaAssetID,0);
					}
				}
			}
		}

		CGuideEntry GuideEntry(m_InputContext);

		if (GuideEntry.Initialise(iH2G2ID,m_InputContext.GetSiteID(), pUser, true,true,true,true, false, bProfanitiesFound))
		{
			// set the archive status first
			// Only if the archive flag is true
			if (bArchive && m_pViewer != NULL && m_pViewer->GetIsEditor())
			{
				SP.SetArticleForumArchiveStatus(iH2G2ID, bArchive);
			}
			//put the article into moderation if necessary
			ModerateArticle(GuideEntry, bProfanitiesFound, bHasAsset, sProfanity );

			// redirect here.
			// create a very simple page since it should redirect immediately anyhow
			// Check for the redirect param
			if (iH2G2ID > 0 && m_InputContext.ParamExists("redirect"))
			{
				// Get the redirect
				CTDVString sRedirect;
				m_InputContext.GetParamString("redirect",sRedirect);

				// Make sure we unescape it!
				sRedirect.Replace("%26","&");
				sRedirect.Replace("%3F","?");

				// Check to see if we're trying to go to the tagitem page, if so add the club info
				int iTagItem = sRedirect.FindText("tagitem");
				if (iTagItem > -1)
				{
					// Now add the new threadid on the end of the redirect, so the page knows!
					// check for the question mark. If it has then use the '&' before adding the params
					((sRedirect.GetLength() - iTagItem) > 7 && sRedirect[iTagItem + 7] == '?') ? sRedirect << "&" : sRedirect << "?";
					sRedirect << "tagitemid=" << iH2G2ID << "&s_h2g2id=" << iH2G2ID;
				}

				// Do the redirect
				m_pPage->Redirect(sRedirect);
			}
			else
			{
				// Do the default redirect stuff here
				CTDVString sRedirect;
				sRedirect << "A" << iH2G2ID << "?s_fromedit=1";
				m_pPage->Redirect(sRedirect);
			}

			CTDVString sExtra;
			sExtra << "<ARTICLE H2G2ID='" << iH2G2ID << "'/>";
			m_pPage->AddInside("H2G2", sExtra);
			//need to add the classification stuff here

			// Check to see if we've been asked to tag this article to any nodes?
			if ( NodeArray.GetSize() )
			{
				// Get the tagitem object to do the tagging!
				CTagItem TagItem(m_InputContext);
				TagItem.InitialiseItem(iH2G2ID,iType,iSiteID,pUser);
				bool bOk = true;
				for (int i = 0; i < NodeArray.GetSize() && bOk; i++ )
				{
					//Inefficient - refresh reference count for nodes this item is tagged to.
					bOk = bOk && TagItem.GetAllNodesTaggedForItem(false);

					// Tag the nodes, but don't fail if it already exists / exceeds limit.
					bOk = bOk && TagItem.AddTagItemToNode(NodeArray.GetAt(i),false);
				}

				// Check the ok flag
				TDVASSERT(bOk,"Failed to tag items to selected nodes");
			}

			// Create polls and link them to this page
			for ( std::vector< POLLDATA >::iterator it = vecPollTypes.begin(); it != vecPollTypes.end(); ++it)
			{
				// Get poll	
				CPolls polls(m_InputContext);
				CPoll *pPoll = polls.GetPoll(-1, it->m_Type);
				CAutoDeletePtr<CPoll> autodelpoll(pPoll);

				if( !pPoll )
				{
					TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() polls.GetPoll failed");
				}
				else
				{
					//Set poll attributes.
					pPoll->SetResponseMinMax(it->m_ResponseMin, it->m_ResponseMax);

					//set anonymous rating poll attribute.
					pPoll->SetAllowAnonymousRating(it->m_AllowAnonymousRating);

					if(pPoll->CreateNewPoll())	// Create it
					{
						if(!pPoll->LinkPollWithItem(iH2G2ID, CPoll::ITEMTYPE_ARTICLE))	// Link it
						{
							TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() Failed to link poll to types article");
							if ( pPoll->ErrorReported() )
							{
								m_pPage->AddInside("H2G2",pPoll->GetLastErrorAsXMLString());
							}
						}
					}
					else
					{
						TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() Failed to create poll for typed article");
					}
				}
			}

			// Link to club if we have a club id
			if(iLinkClub)
			{
				if(!LinkToClub(iH2G2ID, iLinkClub, sLinkClubRelationship))
				{
					TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() LinkToClub failed");
				}
			}

			/****************************************************************************
			//New for Media Assets - Link the the article to the asset and add the 
			//asset xml to the page
			****************************************************************************/
			if (bHasAsset)
			{
				bool bOK = false;
				bOK = LinkArticleAndMediaAsset(iH2G2ID, iMediaAssetID);
				if (bOK)
				{
					//Think the typed article redirects to the actual article view url
					//m_pPage->AddInside("H2G2", sReturnedXML);
				}
				else
				{
					TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() LinkArticleAndMediaAsset failed.");
				}
			}
			
			//Add Any KeyPhrases that have been specified.
			if (iH2G2ID > 0 && !sKeyPhrases.IsEmpty())
			{
				CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
				CArticleSearchPhrase ArticleKeyPhrase(m_InputContext,delimit);
				ArticleKeyPhrase.ParsePhrases(sKeyPhrases);
				if ( ArticleKeyPhrase.AddKeyPhrases(iH2G2ID) )
				{
					m_pPage->AddInside("H2G2", &ArticleKeyPhrase);
				}
				else
				{
					TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() Adding Key phrases to Articles failed.");
				}
			}

			if (iH2G2ID > 0 && !sNamespacedKeyPhrases.IsEmpty())
			{
				CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
				CArticleSearchPhrase ArticleKeyPhrase(m_InputContext, delimit);
				ArticleKeyPhrase.ParsePhrases(sNamespacedKeyPhrases, false, sNamespaces);
				
				if ( ArticleKeyPhrase.AddKeyPhrases(iH2G2ID))
				{
					m_pPage->AddInside("H2G2", &ArticleKeyPhrase);
				}
				else
				{
					TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() Adding Key phrases to Articles failed.");
				}
			}


			/****************************************************************************/

			// Return the page
			return true;
		}
	}

	CTDVString sXML;
	Multi.GetAsXML(sXML);
	m_pPage->AddInside("H2G2", sXML);

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::PreviewTypedArticle(int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	8/27/2003
	Inputs:		iH2G2ID - h2g2 ID of current article
	Outputs:	-
	Returns:	the created page
	Purpose:	creates the article data using the multistep process but does not
				actually create it. Rather it just returns the data in the right 
				format so that it can be previewed.

*********************************************************************************/

bool CTypedArticleBuilder::PreviewTypedArticle(int iH2G2ID)
{
	CMultiStep Multi(m_InputContext, "TYPED-ARTICLE-PREVIEW");
	if (iH2G2ID > 0)
	{
		Multi.SetType("TYPED-ARTICLE-EDIT-PREVIEW");
	}
	
	CExtraInfo ExtraInfo;
	CTDVString sNewBodyXML,sTitle;
	int iSubmittable = 0, iType=1, iStatus=3, iHideArticle = 0;
	int iSiteID = m_InputContext.GetSiteID();
    int iArticleForumStyle = 0; 
	bool bSiteUsesGuestBookStyle = m_InputContext.DoesSiteUseArticleGuestBookForums(iSiteID);
	if (bSiteUsesGuestBookStyle)
		iArticleForumStyle = 1;

	bool bArchive = false;
	bool bUpdateDateCreated = false;
	CTDVString sWhoCanEdit = ARTICLE_CANEDIT_MEONLY;

	int iLinkClub;
	CTDVString sLinkClubRelationship;

	/****************************************************************************
	 New for Media Assets
	****************************************************************************/
	CTDVString sCaption;
	CTDVString sFilename;
	CTDVString sMimeType;
	int iContentType;
	CTDVString sMediaAssetKeyPhrases;
	CTDVString sDescription;
	const char *pFileBuffer; 
	int iFileLength;
	int iMediaAssetID = 0;
	CTDVString sMultiElementsXML = "";
	CTDVString sExternalLinkURL ="";
	CTDVString sNamespacedKeyPhrases;
	CTDVString sNamespaces;

	CTDVString sReturnedXML;
						   
	bool bManualUpload = false;
	bool bHasAsset = false;
	bool bAddToLibrary = false;
	bool bHasKeyPhrases = false;
	bool bExternalLink = false;

	if (m_InputContext.ParamExists("hasasset"))
	{
		if (m_InputContext.GetParamInt("hasasset") == 1)
		{
			bHasAsset = true;
		}
	}
	if (m_InputContext.ParamExists("manualupload"))
	{
		if (m_InputContext.GetParamInt("manualupload") == 1)
		{
			bManualUpload = true;
		}
	}
	if (m_InputContext.ParamExists("addtolibrary"))
	{
		if (m_InputContext.GetParamInt("addtolibrary") == 1)
		{
			bAddToLibrary = true;
		}
	}
	if (m_InputContext.ParamExists("haskeyphrases"))
	{
		if (m_InputContext.GetParamInt("haskeyphrases") == 1)
		{
			bHasKeyPhrases = true;
		}
	}

	// Site Optionable Allow External Links on Media Assets
	if (m_InputContext.DoesCurrentSiteAllowedMAExternalLinks())
	{
		if (m_InputContext.ParamExists("externallink"))
		{
			if (m_InputContext.GetParamInt("externallink") == 1)
			{
				bExternalLink = true;
			}
		}
	}

	/****************************************************************************/


	if (!GetMultiStepInput(Multi,
							sTitle,
							sNewBodyXML,
							ExtraInfo,
							iSubmittable,
							iType, 
							iStatus, 
							iHideArticle,
							bArchive, 
							sWhoCanEdit, 
							iArticleForumStyle, 
							iLinkClub, 
							sLinkClubRelationship, 
							bUpdateDateCreated,
							0,
							bHasAsset,
							bManualUpload,
							bHasKeyPhrases,
							bExternalLink,
							&sCaption,
							&sFilename, 
							&sMimeType, 
							&iContentType,
							&sMultiElementsXML,
							&sMediaAssetKeyPhrases, 
							&sDescription,
							&pFileBuffer, 
							&iFileLength,
							&sExternalLinkURL,
							&sNamespacedKeyPhrases,
							&sNamespaces))
	{
		if (ErrorReported())
		{
			Multi.SetToCancelled();
			m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		else
		{
			return true;
		}
	}
	
	if (Multi.ReadyToUse())
	{
		// Create the article from the new data
		CGuideEntry GuideEntry(m_InputContext);
		//int iSiteID = m_InputContext.GetSiteID();
		CUser Author(m_InputContext);
		bool bValidAuthor = false;

		// Make sure we get the original author if we're given a h2g2id
		if (iH2G2ID > 0)
		{
			// Get the author instead of the current user!!!
			GuideEntry.Initialise(iH2G2ID,iSiteID,0,false,true,true,false,true);
			int iEditorID = GuideEntry.GetEditorID();
			bValidAuthor = Author.CreateFromID(iEditorID);
		}
		else
		{
			// Just use the current user as they are currently creating this entry
			bValidAuthor = Author.CreateFromID(m_InputContext.GetCurrentUser()->GetUserID());
		}

		TDVASSERT(bValidAuthor,"PreviewTypedArticle(int iH2G2ID) - Failed to get a valid author for guideentry");

		// Make sure we destroy the tree before we try to recreate it from actual data.
		GuideEntry.Destroy();

		// Now create the new entry from the given data
		if (bValidAuthor && GuideEntry.CreateFromData(&Author,iH2G2ID,sTitle,sNewBodyXML,ExtraInfo,1,iSiteID,iSubmittable,true,true,true,false,m_pDateRangeVal))
		{
			m_pPage->AddInside("H2G2",&GuideEntry);
		}
		/****************************************************************************
		New for Media Assets
		****************************************************************************/
		if (bHasAsset)
		{
			bool bOK = true;

			CMediaAsset oMediaAsset(m_InputContext);
			bOK = bOK && oMediaAsset.ExternalPreviewMediaAsset(m_InputContext.GetSiteID(), 
								sCaption, 
								sFilename, 
								sMimeType, 
								iContentType, 
								sMultiElementsXML, 
								Author.GetUserID(), 
								sMediaAssetKeyPhrases, 
								sDescription, 
								bAddToLibrary,
								sReturnedXML);

			//Wanted to preview an asset with this article ..it failed, so fail the article
			if (!bOK)
			{
				CopyDNALastError("CTypedArticleBuilder", oMediaAsset);
				return ErrorMessage("Preview Media Asset Failed", GetLastErrorAsXMLString());
			}
			m_pPage->AddInside("H2G2", sReturnedXML);
		}
		/****************************************************************************/
	}
	else
	{
		// something went wrong so supply the original article data
		CGuideEntry GuideEntry(m_InputContext);
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		if (GuideEntry.Initialise(iH2G2ID,m_InputContext.GetSiteID(), pViewingUser, true, true, true, true))
		{
			m_pPage->AddInside("H2G2",&GuideEntry);
		}
	}

	CTDVString sXML;
	Multi.GetAsXML(sXML);
	m_pPage->AddInside("H2G2", sXML);

	return true;
}


/*********************************************************************************

	bool CTypedArticleBuilder::UpdateTypedArticle(int iH2G2ID, bool bForceNoUpdate = false, bool bUseCachedArticle = true)

	Author:		Dharmesh Raithatha
	Created:	8/29/2003
	Inputs:		iH2G2ID - the h2g2id of the article you want to update
				bForceNoUpdate - true to stop any updates going through
				bool bUseCachedArticle - true to use cached article if available
	Outputs:	-
	Returns:	the page at the end or NULL in catastrophic circumstances
	Purpose:	Updates the article using the same method as for creating them.

*********************************************************************************/

bool CTypedArticleBuilder::UpdateTypedArticle(int iH2G2ID, bool bForceNoUpdate, bool bUseCachedArticle)
{
	//get the article from the database.
	CGuideEntry GuideEntry(m_InputContext);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	if (!GuideEntry.Initialise(iH2G2ID,m_InputContext.GetSiteID(), pViewingUser, true,true,true, bUseCachedArticle))
	{
		return ErrorMessage("BAD-H2G2ID","The article you requested does not exist");
	}

	if (CheckIsUserBanned(GuideEntry.GetSiteID()))
	{
		bool bSuccess = true;
		// pointer should be NULL, but delete it just in case anyhow
		bSuccess = InitPage(m_pPage, "ERROR", true);
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='RESTRICTED-TYPEDARTICLE'>You are restricted from adding or editing Guide Entries.</ERROR>");
		return bSuccess;
	}

	int iStatus=GuideEntry.GetStatus();

	CArticleEditForm EditForm(m_InputContext);
			
	if(!EditForm.HasEditPermission(m_pViewer, iH2G2ID, true, GuideEntry.GetStatus(), GuideEntry.GetCanWrite()))
	{
		return ErrorMessage("EDIT-PERMISSION","You do not have permission to edit or update this entry");
	}


	CMultiStep Multi(m_InputContext, "TYPED-ARTICLE-EDIT");
	CExtraInfo ExtraInfo;
	GuideEntry.GetExtraInfo(ExtraInfo);
	CTDVString sNewBodyXML,sTitle,sParseErrors, sWhoCanEdit;
	int iSubmittable = 0, iType=1, iHideArticle = 0;
	int iSiteID = m_InputContext.GetSiteID();
	bool bSiteUsesGuestBookStyle = m_InputContext.DoesSiteUseArticleGuestBookForums(iSiteID);
	int iArticleForumStyle = 0;
	if (bSiteUsesGuestBookStyle)
		iArticleForumStyle = 1;
	bool bArchive = false;
	bool bUpdateDateCreated = false;
	
	int iLinkClub;
	CTDVString sLinkClubRelationship;

	bool bHasAsset = false;
	if (m_InputContext.ParamExists("hasasset"))
	{
		if (m_InputContext.GetParamInt("hasasset") == 1)
		{
			bHasAsset = true;
		}
	}
	
	bool bHasKeyPhrases = false;
	CTDVString sKeyPhrases;
	if (m_InputContext.ParamExists("haskeyphrases"))
	{
		if (m_InputContext.GetParamInt("haskeyphrases") == 1)
		{
			bHasKeyPhrases = true;
		}
	}

	//Initialise Multi Step from Input Parameters
	if (!GetMultiStepInput(Multi,sTitle,sNewBodyXML,ExtraInfo,iSubmittable,iType, iStatus,iHideArticle, bArchive, sWhoCanEdit, iArticleForumStyle, iLinkClub, sLinkClubRelationship, bUpdateDateCreated, NULL, false, false, bHasKeyPhrases, false, NULL, NULL, NULL, NULL, NULL, &sKeyPhrases) )
	{
		if (ErrorReported())
		{
			Multi.SetToCancelled();
			m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		else
		{
			return true;
		}
	}

	//check content for profanities.
    CTDVString sProfanity;
	//take the text part of the guide ml - strip out other GUIDE ML tags
	CTDVString sGuideMLBody = sNewBodyXML; 
	CXMLObject::GuideMLToPlainText(&sGuideMLBody);
	//check content for profanities.
	CTDVString sCheckText = sTitle + " " + sGuideMLBody + " " + sKeyPhrases;
	//removed and replaced with check for only text data and not full GUIDEML
	//CTDVString sCheckText = sTitle + " " + sNewBodyXML + " " + sKeyPhrases;
	CProfanityFilter profanityFilter(m_InputContext);
	CProfanityFilter::FilterState filterState = profanityFilter.CheckForProfanities(sCheckText, &sProfanity);
	bool bProfanitiesFound = false;
	if (filterState == CProfanityFilter::FailBlock)
	{
		bProfanitiesFound = true;
		//check if the filter has been triggered previously
		int iProfanityTriggered = m_InputContext.GetParamInt("profanitytriggered");
		if (iProfanityTriggered > 0)
		{
			//return to user page.
			CTDVString sRedirect("U");
			int iUserID;
			pViewingUser->GetUserID(&iUserID);
			sRedirect << iUserID;			
			m_pPage->Redirect(sRedirect);		
			return true;			
		}
		iProfanityTriggered = 1;
		int iH2G2ID = m_InputContext.GetParamInt("h2g2id");
		return EditTypedArticle(iH2G2ID, iProfanityTriggered?true:false);

	}
	else if (filterState == CProfanityFilter::FailRefer)
	{
		bProfanitiesFound = true;
		//put the article into moderation
	}

	if(m_InputContext.IsCurrentSiteURLFiltered() && !(pViewingUser->GetIsEditor() || pViewingUser->GetIsNotable()))
	{
		//check content for not allowed urls.
		CURLFilter oURLFilter(m_InputContext);
		CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sCheckText);

		if (URLFilterState == CURLFilter::Fail)
		{
			//check if the filter has been triggered previously
			if ( m_InputContext.GetParamInt("nonallowedurltriggered") > 0)
			{
				//return to user page.
				CTDVString sRedirect("U");
				int iUserID;
				pViewingUser->GetUserID(&iUserID);
				sRedirect << iUserID;			
				m_pPage->Redirect(sRedirect);		
				return true;	
			}

			m_pPage->AddInside("H2G2", "<NONALLOWEDURLERRORINFO>A Non-Allowed url has been found.</NONALLOWEDURLERRORINFO>");
			int iH2G2ID = m_InputContext.GetParamInt("h2g2id");
			return EditTypedArticle(iH2G2ID);
		}
	}

	//Filter for email addresses.
	if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(pViewingUser->GetIsEditor() || pViewingUser->GetIsNotable()))
	{
		CEmailAddressFilter emailfilter;
		if ( emailfilter.CheckForEmailAddresses(sCheckText) )
		{
			//check if the filter has been triggered previously
			if ( m_InputContext.GetParamInt("nonallowedemailtriggered") > 0)
			{
				//return to user page.
				CTDVString sRedirect("U");
				int iUserID;
				pViewingUser->GetUserID(&iUserID);
				sRedirect << iUserID;			
				m_pPage->Redirect(sRedirect);		
				return true;	
			}
			m_pPage->AddInside("H2G2", "<NONALLOWEDEMAILERRORINFO>An Email has been found.</NONALLOWEDEMAILERRORINFO>");
			int iH2G2ID = m_InputContext.GetParamInt("h2g2id");
			return EditTypedArticle(iH2G2ID);
		}
	}

	if (bForceNoUpdate)
	{
		// Don't do an update - ie just pass the multistep back to the page
		// This may happen if we've just updated researchers
		Multi.SetToCancelled(); // Make sure ReadyToUse will fail
	}

	// Is user trying to change permissions but isn't allowed to?
	// Also get current permissions in case we need to update later
	//
	const bool bCanChangePermissions		= GuideEntry.GetCanChangePermissions(); // User
	const bool bDefaultCanRead				= GuideEntry.GetDefaultCanRead(); // Article
	const bool bDefaultCanWrite				= GuideEntry.GetDefaultCanWrite(); // Article
	const bool bDefaultCanChangePermissions = GuideEntry.GetDefaultCanChangePermissions(); // Article
	CTDVString sOldWhoCanEdit = EditForm.DivineWhoCanEdit(iH2G2ID, bDefaultCanWrite);

	if ( CheckIsChangingPermissionsIllegally(bCanChangePermissions, sWhoCanEdit, sOldWhoCanEdit) )
	{
		Multi.SetToCancelled(); // Make sure ReadyToUse will fail
		m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	if (m_InputContext.ParamExists("aupdatecancelled"))
	{
		// The UI wants to do everything aupdate does, but don't actually act on the data
		// By using SetToCancelled(), the UI gets a CANCEL="YES" attribute so it can differentiate
		// between a real update command and the "cancelled" version
		Multi.SetToCancelled();
	}

	if (Multi.ReadyToUse())
	{
		// update existing article
		bool bSuccess = true;
		CStoredProcedure SP;
		bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);
		bSuccess = bSuccess && SP.BeginUpdateArticle(iH2G2ID);

		//Now Allow Hidden Articles to be updated SPF 15/08/07
		//if (iHideArticle == 0)
		//{
			bSuccess = bSuccess && SP.ArticleUpdateSubject(sTitle);
			bSuccess = bSuccess && SP.ArticleUpdateBody(sNewBodyXML);
			bSuccess = bSuccess && SP.ArticleUpdateExtraInfo(ExtraInfo);
		//}
		bSuccess = bSuccess && SP.ArticleUpdateType(iType);
		bSuccess = bSuccess && SP.ArticleUpdateSubmittable(iSubmittable);

		// Check to see if we're updating a plaintext entry.
		if (GuideEntry.IsPlainText())
		{
			// We are, make it guideml!
			bSuccess = bSuccess && SP.ArticleUpdateStyle(1);
		}

		if (CanSetStatus())
		{
			bSuccess = bSuccess && SP.ArticleUpdateStatus(iStatus);
		}

		if ( bUpdateDateCreated && m_pViewer && (m_pViewer->GetIsEditor() || m_pViewer->GetIsSuperuser()) )
		{
			bSuccess = bSuccess && SP.ArticleUpdateDateCreated();
		}

		// Update article default permissions
		// Simple now, if we start dealing with user lists maybe move to separate function
		if (!sWhoCanEdit.IsEmpty())
		{
			if (sWhoCanEdit.CompareText(ARTICLE_CANEDIT_MEONLY))
			{
				bSuccess = bSuccess && SP.ArticleUpdatePermissions(bDefaultCanRead, false, bDefaultCanChangePermissions);
			}
			else if (sWhoCanEdit.CompareText(ARTICLE_CANEDIT_ALL))
			{
				bSuccess = bSuccess && SP.ArticleUpdatePermissions(bDefaultCanRead, true, bDefaultCanChangePermissions);
			}
		}

		// Typed articles are always post processed
		bSuccess = bSuccess && SP.ArticleUpdatePreProcessed(false);
		bSuccess = bSuccess && SP.DoUpdateArticle(1, pViewingUser->GetUserID());

		SetArticleDateRangeFromMultiStep(SP, iH2G2ID, *m_pDateRangeVal);

		if ( bSuccess && m_InputContext.DoesCurrentSiteHaveSiteOptionSet("General","ArticleKeyPhrases") )
		{
			if ( bHasKeyPhrases )
			{	
				//Update Articles Key Phrases if they have been edited.
				CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
				CArticleSearchPhrase ArticleKeyPhrase(m_InputContext,delimit);
				bool bKeyPhraseSuccess = ArticleKeyPhrase.ParsePhrases(sKeyPhrases);
				
				CArticleSearchPhrase DBPhrases(m_InputContext,delimit);
				DBPhrases.GetKeyPhrasesFromArticle(iH2G2ID);
				if ( DBPhrases.GetPhraseListAsString() != ArticleKeyPhrase.GetPhraseListAsString() )
				{
					bKeyPhraseSuccess = ArticleKeyPhrase.RemoveAllKeyPhrasesFromArticle(iH2G2ID);
					bKeyPhraseSuccess = bKeyPhraseSuccess && ArticleKeyPhrase.AddKeyPhrases(iH2G2ID);

					if ( bHasAsset )
					{
						//Update associated assets key phrases too.
						int iMediaAssetID = 0;
						CTDVString sMimeType;
						int iHidden = 0;
						CMediaAsset mediaAsset(m_InputContext);
						if ( mediaAsset.GetArticlesAssets(iH2G2ID,iMediaAssetID,sMimeType,iHidden) && iMediaAssetID > 0  )
						{
							CMediaAssetSearchPhrase assetPhrases(m_InputContext,delimit);
							bKeyPhraseSuccess = bKeyPhraseSuccess && assetPhrases.ParsePhrases(sKeyPhrases);
							bKeyPhraseSuccess = bKeyPhraseSuccess && assetPhrases.RemoveAllKeyPhrasesFromAsset(iMediaAssetID);
							bKeyPhraseSuccess = bKeyPhraseSuccess && assetPhrases.AddKeyPhrases(iMediaAssetID);
						}
					}
				}

				if ( !bKeyPhraseSuccess )
				{
					SetDNALastError("CTypedArticle", "CTypedArticle::UpdateArticle","Unable to update key phrases for article/media asset");
				}
			}
			else
			{

				//Process Auto / Derived Key Phrases for Article - These are fields marked as KeyPhrase fields.
				//Create a multi step and configure with values before edit.
				//Compare key phrases b4 and after edit.
				CMultiStep MultiCompare(m_InputContext,"TYPED-ARTICLE-EDIT");
				GetMultiStepInput(MultiCompare,sTitle,sNewBodyXML,ExtraInfo,iSubmittable,iType, iStatus,iHideArticle, bArchive, sWhoCanEdit, iArticleForumStyle, iLinkClub, sLinkClubRelationship, bUpdateDateCreated);
				
				//Reset values.
				int index = 0;
				bool bfound = true;
				while ( bfound )
				{
					bfound = false;
					CTDVString sParam, sAction;
					if ( MultiCompare.GetRequiredParameterAction(index,sParam,sAction) )
					{
						MultiCompare.SetRequiredValue(sParam,"");
						bfound = true;
					}
					if ( MultiCompare.GetElementParameterAction(index,sParam,sAction) )
					{
						MultiCompare.SetElementValue(sParam,"");
						bfound = true;
					}
					index++;
				}

				InitialiseMultiStepFromGuideEntry(MultiCompare, GuideEntry);

				//Update with new keyphrase values and remove any old derived/auto key phrases.
				UpdateDerivedKeyPhrases(iH2G2ID,MultiCompare,Multi);
			}
		}

		if(bSuccess)
		{
			// Get all the nodes
			bSuccess = m_InputContext.InitialiseStoredProcedureObject(&SP);
			if (!SP.GetAllNodesThatItemBelongsTo(iH2G2ID, iType))
			{
				//return SetDNALastError("CTagItem","FailedToFindNodes","Failed finding tagged nodes");
				return ErrorMessage("TAG-ITEM", "FailedToFindNodes: Failed finding tagged nodes");
			}
			while(!SP.IsEOF())
			{
				//get the nodes article is attached to
				int iNodeID = SP.GetIntField("NodeID");
				
				//notify subscribers -AddCategoryArticleEdit
				CEventQueue EQ(m_InputContext);
				bSuccess = bSuccess && EQ.AddToEventQueue(EQ.ET_CATEGORYARTICLEEDITED, pViewingUser->GetUserID(), iH2G2ID, CEmailAlertList::IT_H2G2, iNodeID, CEmailAlertList::IT_NODE);

				SP.MoveNext();
			}
		}

		// Now check to see if we are required to hide the article? This can only be done by editors
		CUser* pUser = m_InputContext.GetCurrentUser();
		if (bSuccess && pUser != NULL && pUser->GetIsEditor())
		{
			if (iHideArticle == 0)
			{
				// Try to hide the article
				bSuccess = bSuccess && GuideEntry.MakeUnhidden(0, 0);
			}
			else
			{
				// Try to hide the article
				bSuccess = bSuccess && GuideEntry.MakeHidden(iHideArticle, 0, 0);
			}

			//Find out if article has a media asset.
			CMediaAsset mediaAsset(m_InputContext);
			int iMediaAssetID = 0;
			int iHidden = 0;
			CTDVString sMimeType;
			if ( bHasAsset && bSuccess && mediaAsset.GetArticlesAssets(iH2G2ID,iMediaAssetID,sMimeType,iHidden) && iMediaAssetID > 0 )
			{
				CMediaAssetModController mediaassetmod(m_InputContext);

				//Only need to unHide Media Asset if it is currently hidden.
				if ( iHideArticle == 0 && iHidden != 0)
				{
					mediaassetmod.Approve(iMediaAssetID,sMimeType,false);
					bSuccess = bSuccess && SP.HideMediaAsset(iMediaAssetID, 0);
				}

				// Only need to hide media asset if it isn't already hidden.
				if ( iHideArticle != 0 && iHidden == 0 )
				{
					mediaassetmod.Reject(iMediaAssetID,sMimeType,false);
					bSuccess = bSuccess && SP.HideMediaAsset(iMediaAssetID, 1);
				}
			}
		}

		if (m_pViewer != NULL && m_pViewer->GetIsEditor())
		{
			SP.SetArticleForumArchiveStatus(iH2G2ID, bArchive);
		}

		if (bSuccess)
		{
			//put the article into moderation if necessary
			ModerateArticle(GuideEntry, bProfanitiesFound,false, sProfanity);

			//redirect here.
			// create a very simple page since it should redirect immediately anyhow
			CTDVString sRedirect;
			sRedirect << "A" << iH2G2ID << "?s_fromedit=1";
			m_pPage->Redirect(sRedirect);
			CTDVString sExtra;
			sExtra << "<ARTICLE H2G2ID='" << iH2G2ID << "'/>";
			m_pPage->AddInside("H2G2", sExtra);

			//need to add the classification stuff here
			return true;
		}
	}

	m_pPage->AddInside("H2G2",&GuideEntry);

	CTDVString sXML;
	Multi.GetAsXML(sXML);
	m_pPage->AddInside("H2G2", sXML);

	return true;
}

/*********************************************************************************

bool CTypedArticleBuilder::GetEditFormDataFromGuideEntry(CGuideEntry& GuideEntry,
														 CTDVString& sSubject,
														 CTDVString& sEditFormData)
	Author:		Mark
	Created:	21/10/2003
	Inputs:		GuideEntry Object to get the data from
	Outputs:	sSubject a return string to take the subject.
				sEditFormData - A return string to hold the parsed result for the form.
	Returns:	True if everything ok, false if not.
	Purpose:	Tries to to get the body text in a form suitable for editing.
				Replaces <BR/> tags with returns.
				Escapes all text.
				Side effect - Also gets the Subject text escaped.

*********************************************************************************/

bool CTypedArticleBuilder::GetEditFormDataFromGuideEntry(CGuideEntry& GuideEntry,
														 CTDVString& sSubject,
														 CTDVString& sEditFormData)
{
	// Check to see if we're plain text
	if (GuideEntry.IsPlainText())
	{
		 ErrorMessage("PLAINTEXT","The article you are trying to edit is in the wrong format");
		 return false;
	}

	// Try to get the body from the guideentry
	CTDVString sBody;
	if (!GuideEntry.GetBody(sBody))
	{
		ErrorMessage("NO-BODY","The article appears to have no text associated with it");
		return false;
	}

	// Create a tree from the body text
	CXMLTree* pRoot = CXMLTree::Parse(sBody);
	if (pRoot == NULL)
	{
		ErrorMessage("NO-BODY","The article appears to have no text associated with it");
		return false;
	}

	// Find the first Node called GUIDE
	CXMLTree* pTree = pRoot->FindFirstTagName("GUIDE");
	if (pTree == NULL)
	{
		delete pRoot;
		ErrorMessage("NO-BODY","The article appears to have no text associated with it");
		return false;
	}

	// Finally get the subject and escape it
	GuideEntry.GetSubject(sSubject);
	CXMLObject::EscapeXMLText(&sSubject);

	// Delete the root and return ok.
	delete pRoot;
	return true;

}

/*********************************************************************************

	bool CTypedArticleBuilder::EditTypedArticle(int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	8/29/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	This handles all steps in editing an article except the actual update.
				ie It fetches the article to fill values in the form and handles 
				multi-step pages until the person is ready to update.

*********************************************************************************/

bool CTypedArticleBuilder::EditTypedArticle(int iH2G2ID, bool bProfanityTriggered /* = false */ )
{
	CMultiStep Multi(m_InputContext, "TYPED-ARTICLE-EDIT");
	
	// Get the article from the database.
	CGuideEntry GuideEntry(m_InputContext);
	GuideEntry.SetEditMode(true);
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (!GuideEntry.Initialise(iH2G2ID,m_InputContext.GetSiteID(), pViewingUser, true,true,true,false,true, bProfanityTriggered))
	{
		return ErrorMessage("BAD-H2G2ID","The article you requested does not exist");
	}

	if (CheckIsUserBanned(GuideEntry.GetSiteID()))
	{
		bool bSuccess = true;
		// pointer should be NULL, but delete it just in case anyhow
		bSuccess = InitPage(m_pPage, "ERROR", true);
		bSuccess = bSuccess && m_pPage->AddInside("H2G2", "<ERROR TYPE='RESTRICTED-TYPEDARTICLE'>You are restricted from adding or editing Guide Entries.</ERROR>");
		return bSuccess;
	}

	// Find the status of the GuideEntry and check to make sure the user has the correct permissions
	int iStatus=GuideEntry.GetStatus();
	CArticleEditForm EditForm(m_InputContext);
	if(!EditForm.HasEditPermission(m_pViewer,iH2G2ID, true, GuideEntry.GetStatus(), GuideEntry.GetCanWrite()))
	{
		return ErrorMessage("EDIT-PERMISSION","You do not have permission to edit or update this entry");
	}

	// Now setup the Multistep and get the edit info
	CExtraInfo ExtraInfo;
	CTDVString sNewBodyXML,sTitle;
	int iSubmittable = 0, iType=1;
	int iHideArticle = GuideEntry.GetOriginalHiddenStatus();
	//GuideEntry.GetArticleForumStyle();
	int iArticleForumStyle = 0; // should be the set value - cf. above
	bool bArchive = false;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetArticleForumArchiveStatus(iH2G2ID, bArchive);
	CTDVString sWhoCanEdit = EditForm.DivineWhoCanEdit(iH2G2ID, GuideEntry.GetDefaultCanWrite());

	CTDVString sBodyXML;
	GuideEntry.GetBody(sBodyXML);
	// Need to "seed" the MultiStep object with the body text, so that if an _msxml param is not
	// supplied on the URL, it can generate one from a combination of the required fields and
	// the contents of the guide's body
	Multi.SetMSXMLSeed(sBodyXML);

	int iLinkClub;
	CTDVString sLinkClubRelationship;

	bool bUpdateDateCreated = false;

	if (!GetMultiStepInput(Multi,sTitle,sNewBodyXML,ExtraInfo,iSubmittable,iType,iStatus,iHideArticle, bArchive, sWhoCanEdit, iArticleForumStyle, iLinkClub, sLinkClubRelationship, bUpdateDateCreated))
	{
		if (ErrorReported())
		{
			Multi.SetToCancelled();
			m_pPage->AddInside("H2G2",GetLastErrorAsXMLString());
		}
		else
		{
			return true;
		}
	}

	InitialiseMultiStepFromGuideEntry(Multi, GuideEntry);


	CTDVString sXML;
	Multi.GetAsXML(sXML);

	
	m_pPage->AddInside("H2G2", sXML);
	m_pPage->AddInside("H2G2",&GuideEntry);

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::InitialiseMultiStepFromGuideEntry

	Author:		Martin Robb
	Created:	01/08/2006
	Inputs:		- Multi, GuideEntry
	Outputs:	- Multi
	Returns:	-
	Purpose:	Initialises MultiStep values from Guide Entry XML.
				MultiStep needs to have its maps setup from the Input Parameters.

*********************************************************************************/
bool CTypedArticleBuilder::InitialiseMultiStepFromGuideEntry(CMultiStep& Multi, CGuideEntry& GuideEntry)
{
	CTDVString sBodyXML;
	GuideEntry.GetBody(sBodyXML);

	// Check to see if we're playing with plain text. If we are we need to convert it back into GuideML
	if (GuideEntry.IsPlainText())
	{
		GuideEntry.PlainTextToGuideML(&sBodyXML);
	}

	bool ok =  Multi.FillElementsFromXML(sBodyXML);
	ok = ok && Multi.FillRequiredFromXML(sBodyXML);

	if (GuideEntry.HasDateRange())
	{
		CTDVDateTime ds = GuideEntry.GetDateRangeStart();
		CTDVDateTime de = GuideEntry.GetDateRangeEnd();
		int iTimeInterval = GuideEntry.GetTimeInterval();

		Multi.SetRequiredValue("STARTDAY",CTDVString(ds.GetDay()));
		Multi.SetRequiredValue("STARTMONTH",CTDVString(ds.GetMonth()));
		Multi.SetRequiredValue("STARTYEAR",CTDVString(ds.GetYear()));
		Multi.SetRequiredValue("ENDDAY",CTDVString(de.GetDay()));
		Multi.SetRequiredValue("ENDMONTH",CTDVString(de.GetMonth()));
		Multi.SetRequiredValue("ENDYEAR",CTDVString(de.GetYear()));
		Multi.SetRequiredValue("TIMEINTERVAL",CTDVString(iTimeInterval));
	}

	CTDVString sTitle;
	GuideEntry.GetSubject(sTitle);
	CXMLObject::EscapeAllXML(&sTitle);
	ok = ok && Multi.SetRequiredValue("Title",sTitle);
	return ok;
}

/*********************************************************************************

	bool CTypedArticleBuilder::DeleteTypedArticle(int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	9/2/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	deletes the article and removes it from a review forum if is in 
				1.

*********************************************************************************/

bool CTypedArticleBuilder::DeleteTypedArticle(int iH2G2ID)
{
	CArticleEditForm EditForm(m_InputContext);

	if(!EditForm.HasEditPermission(m_pViewer,iH2G2ID))
	{
		return ErrorMessage("EDIT-PERMISSION","You do not have permission to edit or update this entry");
	}

	CStoredProcedure	SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return ErrorMessage("DBERROR","Database Error");
	}
	
	int iReviewForumID = 0;
	
	if ( SP.IsArticleInReviewForum(iH2G2ID, m_InputContext.GetSiteID(), &iReviewForumID))
	{
		CReviewSubmissionForum mSubmitForum(m_InputContext);
		
		int iThreadID = 0;
		int iForumID = 0;
		bool bSuccess = false;
		
		if (!mSubmitForum.RemoveThreadFromForum(*(m_InputContext.GetCurrentUser()),iReviewForumID,iH2G2ID,&iThreadID,&iForumID,&bSuccess))
		{
			return ErrorMessage("NOREVIEW","Unable to remove from review forum");
		}
	}
	

	// just need to update the Entrys status to be 7 for a deleted entry
	bool bSuccess = true;
	bool bRecacheGroups = false;
	bSuccess = bSuccess && SP.BeginUpdateArticle(iH2G2ID);
	bSuccess = bSuccess && SP.ArticleUpdateStatus(7);
	bSuccess = bSuccess && SP.DoUpdateArticle();

	if (bSuccess)
	{
		CTDVString sDeleted = "<DELETED TYPE='OK'><H2G2ID>";
		sDeleted << iH2G2ID << "</H2G2ID></DELETED>";

		m_pPage->AddInside("H2G2",sDeleted);
		return true;
	}
	else
	{
		return ErrorMessage("UPDATE","Failed to delete the article on the update");
	}

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::UnDeleteTypedArticle(int iH2G2ID)

	Author:		Martin Robb
	Created:	15/06/2006
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Undeletes a previously deleted article.

*********************************************************************************/

bool CTypedArticleBuilder::UnDeleteTypedArticle(int iH2G2ID)
{
	CArticleEditForm EditForm(m_InputContext);

	if(!EditForm.HasEditPermission(m_pViewer,iH2G2ID))
	{
		return ErrorMessage("EDIT-PERMISSION","You do not have permission to edit or update this entry");
	}

	CStoredProcedure	SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return ErrorMessage("DBERROR","Database Error");
	}
	

	if ( !EditForm.CreateFromArticle(iH2G2ID,m_InputContext.GetCurrentUser()) )
	{
		ErrorMessage("UPDATE","Failed to undelete the article on the update");
		return false;
	}

	if ( EditForm.UndeleteArticle(m_InputContext.GetCurrentUser()) )
	{
		CTDVString sDeleted = "<UNDELETED TYPE='OK'><H2G2ID>";
		sDeleted << iH2G2ID << "</H2G2ID></UNDELETED>";

		m_pPage->AddInside("H2G2",sDeleted);
		return true;
	}
	else
	{
		return ErrorMessage("UPDATE","Failed to delete the article on the update");
	}

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)

	Author:		Dharmesh Raithatha
	Created:	5/23/2003
	Inputs:		sType - type of error
				sMsg - Defualt message
	Outputs:	-
	Returns:	whole xml page with error
	Purpose:	default error message

*********************************************************************************/

bool CTypedArticleBuilder::ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg)
{
	if (sType == NULL || sMsg == NULL)
	{
		return false;
	}

	CTDVString Type(sType);
	CTDVString Msg(sMsg);
	CXMLObject::EscapeEverything(&Type);
	CXMLObject::EscapeXMLText(&Msg);

	CTDVString sError = "<ERROR TYPE='";
	sError << Type << "'>";

	int iType = m_InputContext.GetParamInt("type");
	if (iType > 0)
	{
		sError << "<ARTICLETYPE>" << iType << "</ARTICLETYPE>";
	}

	sError << Msg;
	sError << "</ERROR>";

	m_pPage->AddInside("H2G2", sError);

	return true;
}


/*********************************************************************************

	bool CTypedArticleBuilder::GetMultiStepInput(CMultiStep& Multi,
											 CTDVString& sTitle, 
											 CTDVString& sNewBodyXML,
											 CExtraInfo& ExtraInfo, 
											 int& iSubmittable, 
											 int& iType, 
											 int& iStatus, 
											 int& iHideArticle, 
											 bool &bArchive, 
											 CTDVString& sWhoCanEdit, 
											 int& iArticleForumStyle,
											 int& iLinkClub,
											 CTDVString& sLinkClubRelationship,
											 std::vector<CPoll::VoteType> * pvecPollTypes)

	Author:		Dharmesh Raithatha
	Created:	8/29/2003
	Inputs:		-
	
	Outputs:	pvecPollTypes: Vector of poll types to create with article. Can be null
				iLinkClub: ID of club to autoclip this article to
				sLinkClubRelationship: Relationship for club link (see iLinkClub)

	Returns:	-
	Purpose:	This method uses the given multistep to process the input. The 
				information is then captured and processed such that we have a
				title and a body xml like this
				<GUIDE>
				<ROLE>asdasd</ROLE> - where role is an element defined in the input
				others elements here
				<BODY>
					body text here with <BR/> tags replacing line breaks
				</BODY>
				</GUIDE>
				The method also returns an ExtraInfo with the type set according to
				what has been passed.

*********************************************************************************/

bool CTypedArticleBuilder::GetMultiStepInput(CMultiStep& Multi,
											 CTDVString& sTitle, 
											 CTDVString& sNewBodyXML,
											 CExtraInfo& ExtraInfo, 
											 int& iSubmittable, 
											 int& iType, 
											 int& iStatus, 
											 int& iHideArticle, 
											 bool &bArchive, 
											 CTDVString& sWhoCanEdit, 
											 int& iArticleForumStyle,
											 int& iLinkClub,
											 CTDVString& sLinkClubRelationship,
											 bool& bUpdateDateCreated,
											 std::vector< POLLDATA >* pvecPollTypes,
											 bool bHasAsset,
											 bool bManualUpload,
											 bool bHasKeyPhrases,
											 bool bExternalLink,
											 CTDVString *pCaption,
											 CTDVString *pFilename, 
											 CTDVString *pMimeType, 
											 int *iContentType,
											 CTDVString *pMultiElementsXML,
											 CTDVString *pKeyPhrases, 
											 CTDVString *pFileDescription,
											 const char **pFileBuffer, 
											 int *iFileLength,
											 CTDVString *pExternalLinkURL,
											 CTDVString* pNamespacedKeyPhrases,
											 CTDVString* pNamespaces
											 )
{
	//things that we must have for TypedArticles

	CTDVString sStatus(iStatus);
	
	CTDVString sHidden = iHideArticle;
	Multi.AddRequiredParam("title","",true);
	Multi.AddRequiredParam("type","1");
	Multi.AddRequiredParam("status",sStatus);
	Multi.AddRequiredParam("classifynode","0");
	Multi.AddRequiredParam("body");
	Multi.AddRequiredParam("submittable","0");
	Multi.AddRequiredParam("hidearticle",sHidden);
	Multi.AddRequiredParam("whocanedit",sWhoCanEdit);
	Multi.AddRequiredParam("linkclub", "0");
	Multi.AddRequiredParam("linkclubrelationship", "");

	// Date Range params - using "REQUIRED with default" params instead of ELEMENT params so they 
	// are optional and yet do NOT automatically get added to the GUIDE tag!
	Multi.AddRequiredParam("startdate","");
	Multi.AddRequiredParam("startday","0");
	Multi.AddRequiredParam("startmonth","0");
	Multi.AddRequiredParam("startyear","0");
	Multi.AddRequiredParam("enddate","");
	Multi.AddRequiredParam("endday","0");
	Multi.AddRequiredParam("endmonth","0");
	Multi.AddRequiredParam("endyear","0");
	Multi.AddRequiredParam("timeinterval","-1");

	/****************************************************************************
	//New for Media Assets
	****************************************************************************/

	if (bHasAsset)
	{
		if (bManualUpload)
		{
			Multi.AddRequiredParam("contenttype");
			//Multi.AddRequiredParam("filename");
			Multi.AddRequiredParam("mimetype");
			
			if (bExternalLink)
			{
				Multi.AddRequiredParam("externallinkurl");
			}
		}
		else
		{
			*iContentType = 1;
			Multi.AddRequiredParam("file", "", false, true);
			Multi.AddRequiredParam("filename");
		}

		//Multi.AddRequiredParam("caption");
		//Multi.AddRequiredParam("description");
		Multi.AddRequiredParam("termsandconditions");

		if (bHasKeyPhrases)
		{
			Multi.AddRequiredParam("mediaassetkeyphrases");
		}
	}

	/****************************************************************************/

	iLinkClub = 0;

	if (bArchive)
	{
		Multi.AddRequiredParam("archive","1");
	}
	else
	{
		Multi.AddRequiredParam("archive","0");
	}

	
	if (iArticleForumStyle == 1) 
	{
		//This forum style corresponds to the style guestbook 
		//otherwise known as comments.
		Multi.AddRequiredParam("articleforumstyle", "1");
	}
	else 
	{
		//This forum style corresponds to the discussion style.
		Multi.AddRequiredParam("articleforumstyle", "0");
	}
	
	if (!Multi.ProcessInput())
	{
		return SetDNALastError("TypedArticle","BAD-INPUT","There was bad input parameters in createing the typed article");
	}
	
	if (GetDateRangeFromMultiStep(Multi, *m_pDateRangeVal))
	{
		CDateRangeValidation::ValidationResult res = m_pDateRangeVal->GetLastValidationResult();
		if (res != CDateRangeValidation::VALID)
		{
			Multi.AppendRequiredCustomErrorXML("STARTDAY",m_pDateRangeVal->GetLastErrorAsXMLString());
			Multi.AppendRequiredCustomErrorXML("STARTDAY",GetLastErrorAsXMLString());
		}
	}

	if (Multi.ReadyToUse())
	{
		Multi.GetRequiredValue("title",sTitle);
		Multi.GetRequiredValue("type",iType);
		Multi.GetRequiredValue("status",iStatus);
		Multi.GetRequiredValue("submittable",iSubmittable);
		Multi.GetRequiredValue("hidearticle",iHideArticle);
		Multi.GetRequiredValue("whocanedit",sWhoCanEdit);
		int iArchive = 0;
		Multi.GetRequiredValue("archive", iArchive);
		if (0 == iArchive)
		{
			bArchive = false;
		}
		else
		{
			bArchive = true;
		}

		Multi.GetRequiredValue("articleforumstyle", iArticleForumStyle);
		// If the user can't set the status, force it to a default value
		if (!CanSetStatus())
		{
			iStatus = 3; // 3 = standard user page
		}

		bool bOK = true;
		sNewBodyXML = "<GUIDE>";
		bOK = bOK && Multi.GetRequiredAsXML("BODY", sNewBodyXML);
		bOK = bOK && Multi.GetAllElementsAsXML(sNewBodyXML);
		sNewBodyXML << "</GUIDE>";

		if (!bOK)
		{
			CopyDNALastError("TypedArticle",Multi);
		}

		// Removing this for now - David van Zijl 15/07/2004
		// Shouldn't need to restrict types of entries TypedArticle can edit
		// Watch for strange behaviour
		//		if (!CGuideEntry::IsTypeOfArticle(iType))
		//		{
		//			return SetDNALastError("TypedArticle","BAD-TYPE","The given type is not valid for articles");
		//		}

		if (ExtraInfo.IsCreated())
		{
			ExtraInfo.SetType(iType);
		}
		else
		{
			ExtraInfo.Create(iType);
		}

		CTDVString sDescription;
		Multi.GetElementValue("description",sDescription);
		if (!sDescription.IsEmpty())
		{
			CTDVString sXML;
			if (Multi.GetElementAsXML("description",sXML))
			{
				ExtraInfo.AddUniqueInfoItem("DESCRIPTION",sXML);
			}
		}
		else
		{
			ExtraInfo.RemoveInfoItem("DESCRIPTION");
		}
		
		ExtraInfo.GenerateAutoDescription(sNewBodyXML);

		ProcessExtraInfoActions(Multi,ExtraInfo);


		// Populate pollTypes vector with required polls for this article
		// Multistep does not support multiple parameters of the same name
		// therefore get multiple poll types by checking for "polltype1".."polltypeN"

		if(pvecPollTypes)
		{
			CTDVString sPollParamName("polltype1");
			CTDVString sPollParamVal;
			int nPollParamIndex = 1;
			CTDVString sPollResponseMin;
			CTDVString sPollResponseMax;
			CTDVString sPollAllowAnonymousRating;

			CPolls	pollbuilder(m_InputContext);
			while( Multi.GetElementValue(sPollParamName, sPollParamVal ) 
				&& nPollParamIndex < 100) // limit to 100 per page for safety
			{
				if(!sPollParamVal.IsEmpty())
				{
					POLLDATA polldata;
					CPoll::PollType nPollType = static_cast<CPoll::PollType>(atoi(sPollParamVal));
					polldata.m_Type = nPollType;
				
					int iResponseMin = -1;
					if ( Multi.GetElementValue(sPollParamName + "minresponse", sPollResponseMin) && !sPollResponseMin.IsEmpty() )
					{
						polldata.m_ResponseMin = atoi(sPollResponseMin);
					}

					int iResponseMax = -1;
					if ( Multi.GetElementValue(sPollParamName + "maxresponse", sPollResponseMax) && !sPollResponseMax.IsEmpty() )
					{
						polldata.m_ResponseMax = atoi(sPollResponseMax);
					}

					if ( Multi.GetElementValue(sPollParamName + "allowanonymousrating", sPollAllowAnonymousRating) && !sPollAllowAnonymousRating.IsEmpty() )
					{
						if (sPollAllowAnonymousRating == "1" || sPollAllowAnonymousRating == "true")
						{
							polldata.m_AllowAnonymousRating = true;
						}
						else
						{
							polldata.m_AllowAnonymousRating = false;
						}
					}

					pvecPollTypes->push_back(polldata);
				}

				sPollParamName = "polltype";
				sPollParamName += CTDVString(++nPollParamIndex);
			}
		}

		// Get LinkClub (club to clip this article to)
		if(!Multi.GetRequiredValue("linkclub", iLinkClub))
		{
			iLinkClub = 0;
			sLinkClubRelationship = "";
		}
		else
		{
			// Since we have a link club id, get the link relationship
			Multi.GetRequiredValue("linkclubrelationship", sLinkClubRelationship);
		}

		CTDVString sUpdateDateCreated;
		if ( Multi.GetElementValue("updatedatecreated", sUpdateDateCreated) )
		{
			bUpdateDateCreated = atoi(sUpdateDateCreated) != 0;
		}

		/****************************************************************************
		//New for Media Assets
		****************************************************************************/
		if (bHasAsset)
		{
			bool bEscaped = true;

			if (bManualUpload)
			{
				//It's going to be a manual upload so get values entered from the form
				Multi.GetRequiredValue("contenttype", *iContentType);
				//Multi.GetRequiredValue("filename", *pFilename, &bEscaped);
				Multi.GetRequiredValue("mimetype", *pMimeType, &bEscaped);
				*iFileLength = 0;

				if (bExternalLink)
				{
					Multi.GetRequiredValue("externallinkurl", *pExternalLinkURL, &bEscaped);
				}
			}
			else
			{

				if (!Multi.GetRequiredFileData("file", pFileBuffer, *iFileLength, *pMimeType, pFilename))
				{
					//Problems with the file details so back out
					//Check what to do whether to just jump ship or set multi step to error somehow
					//maybe just drop out and check before doing the create and upload
					return SetDNALastError("TypedArticle","BAD-INPUT-FILE","There was bad input or missing media asset file in creating the typed article");
				}

				int iFilesContentType = 0;

				if (!CMediaAsset::IsMimeTypeSupported(*pMimeType, iFilesContentType))
				{
					return SetDNALastError("TypedArticle", "MIMETYPE NOT SUPPORTED", "The mimetype of the media asset file is not supported.");
				}

				//Check that the selected Content type
				if (iFilesContentType != *iContentType)
				{
					return SetDNALastError("TypedArticle", "ProcessCreateUpdate - ContentTypeMismatch", "Format of the file doesn't match the Content Type selected. " + *pMimeType);
				}		

				CTDVString sContentType(*iContentType);
				Multi.SetRequiredValue("contenttype", sContentType);
				Multi.SetRequiredValue("filename", *pFilename);
			}

			Multi.GetAllElementsAsXML(*pMultiElementsXML);

			Multi.GetElementValue("caption", *pCaption, &bEscaped);
			if (*pCaption == "")
			{
				if(sTitle == "")
				{
					*pCaption = "No Caption.";
				}
				else
				{
					*pCaption = sTitle;
				}
			}
			Multi.GetElementValue("mediaassetdescription", *pFileDescription, &bEscaped);
			if (*pFileDescription == "")
			{
				CTDVString sEscapedRawBodyText;
				Multi.GetRequiredValue("BODY", sEscapedRawBodyText, &bEscaped);

				if(sEscapedRawBodyText == "")
				{
					*pFileDescription = "No Media Asset Description.";
				}
				else
				{
					*pFileDescription = sEscapedRawBodyText;
				}
			}

			if (bHasKeyPhrases)
			{
				Multi.GetRequiredValue("mediaassetkeyphrases", *pKeyPhrases);
			}
		}

		
		//Get Any derived keyphrases - keyphrases that are derived from declared article fields.
		//Preserve any manually entered phrases.
		if ( pKeyPhrases )
		{
			CTDVString sDerivedPhrases;
			ProcessDerivedKeyPhraseActions(Multi, sDerivedPhrases);
			CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
			CArticleSearchPhrase akp(m_InputContext,delimit);
			akp.ParsePhrases(*pKeyPhrases);
			akp.ParsePhrases(sDerivedPhrases,true);
			*pKeyPhrases = akp.GetPhraseListAsString();

			if (pNamespacedKeyPhrases && pNamespaces)
			{
				// This check was put in becuase we can get here from update typed article where these params were not passed it. 
				// This was causing RipleyTests TestTypedArticleEditWithDateRange; TestTypedArticleEditWithDateRangeUsingFreeTextDates and TestTypedArticleUpdateCancelled to fail. 
				// TODO: Ensure update of keyphrases works. 
				CTDVString sNamespacedPhrases, sNamespaces;
				ProcessNamespacedKeyPhrases(Multi, sNamespacedPhrases, sNamespaces);
				*pNamespacedKeyPhrases = sNamespacedPhrases;
				*pNamespaces = sNamespaces;
			}
		}
	}

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::ModerateArticle(CGuideEntry& GuideEntry)

	Author:		Mark Neves
	Created:	26/09/2003
	Inputs:		GuideEntry object
	Outputs:	-
	Returns:	true if GuideEntry was placed in Moderation queue
	Purpose:	Looks to see if GuideEntry needs to be put in the moderation queue,
				and if so, puts it in.

*********************************************************************************/

bool CTypedArticleBuilder::ModerateArticle(CGuideEntry& GuideEntry, bool bProfanitiesFound /* = false */, bool bHasAssets /* = false */, CTDVString sProfanity)
{
	if (m_pViewer != NULL && !m_pViewer->GetIsImmuneFromModeration(GuideEntry.GetH2G2ID()))
	{
		bool bSiteModerated = !(m_InputContext.IsSiteUnmoderated(GuideEntry.GetSiteID()));
		bool bUserModerated  = m_pViewer->GetIsPreModerated() || m_pViewer->GetIsPostModerated();
		bool bArticleModerated = GuideEntry.IsArticleModerated();
		bool bArticleInModeration = GuideEntry.IsArticleInModeration() != 0;
		bool bAutoSinBin = m_pViewer->GetIsAutoSinBin();

		if (bSiteModerated || bUserModerated || bArticleModerated || bArticleInModeration || bProfanitiesFound || bHasAssets || bAutoSinBin)
		{
			CTDVString sTemp;
            if (bProfanitiesFound)
			{
                sTemp << "Profanity: '" << sProfanity << "'\r\n";
			}
            sTemp <<  "Created/Edited by user U" << m_InputContext.GetCurrentUser()->GetUserID();

			int iModId;
			GuideEntry.QueueForModeration(
				bProfanitiesFound ? CStoredProcedure::MOD_TRIGGER_PROFANITY 
				: CStoredProcedure::MOD_TRIGGER_AUTO, sTemp, &iModId);
/*
			if (bNeedHide)
			{
				GuideEntry.MakeHidden(3, iModId, 
					bProfanitiesFound ? CStoredProcedure::MOD_TRIGGER_PROFANITY 
						: CStoredProcedure::MOD_TRIGGER_AUTO);
			}
*/
			return true;
		}
	}

	return false;
}


/*********************************************************************************

	bool CTypedArticleBuilder::CanSetStatus()

	Author:		Mark Neves
	Created:	17/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if yes, false if no
	Purpose:	Only privilaged users can change the status of an article
				This tells you if the viewing user is privileged enough
*********************************************************************************/

bool CTypedArticleBuilder::CanSetStatus()
{
	bool bCanSetStatus = false;
	if (m_pViewer != NULL)
	{
		bCanSetStatus = m_pViewer->GetIsBBCStaff() || m_pViewer->GetIsEditor() || m_pViewer->GetIsSuperuser();
	}
	return bCanSetStatus;
}

/*********************************************************************************

	bool CTypedArticleBuilder::SetResearchers(int iH2G2ID)

	Author:		David van Zijl
	Created:	25/05/2004
	Inputs:		iH2G2ID - h2g2id of article user is editing
				bHasPermission - true if you've already checked that the user has permission
	Outputs:	-
	Returns:	the created page
	Purpose:	Sets list of researchers for the current article.
				Acts like 'preview' in that it passes article parameters back 
				to the browser

*********************************************************************************/

bool CTypedArticleBuilder::SetResearchers(int iH2G2ID)
{
	CArticleEditForm editForm(m_InputContext);

	// Make sure current viewer can edit
	//
	if(!editForm.HasEditPermission(m_pViewer, iH2G2ID))
	{
		return ErrorMessage("EDIT-PERMISSION","You do not have permission to edit or update this entry");
	}

	// Update list of researchers
	//
	if (!PerformSetResearchers(editForm, iH2G2ID))
	{
		return ErrorMessage("SETRESEARCHER_FAILED", "Failed to update list of researchers");
	}

	// pass multistep and article back to form
	// also make sure that the article is reloaded (cached version not used)
	return UpdateTypedArticle(iH2G2ID, true, false);
}


/*********************************************************************************

	bool CTypedArticleBuilder::PerformSetResearchers(CArticleEditForm& editForm, int iH2G2ID)

	Author:		David van Zijl
	Created:	24/09/2004
	Inputs:		-
	Outputs:	-
	Returns:	false if update fails, true otherwise
	Purpose:	Takes a form or url parameter and updates the set of researchers 
				for the current article.

*********************************************************************************/

bool CTypedArticleBuilder::PerformSetResearchers(CArticleEditForm& editForm, int iH2G2ID)
{
	CTDVString sNote = "Set Researchers:";
	CTDVString sResearcherListParam;
	bool bGotList = m_InputContext.GetParamString("ResearcherList", sResearcherListParam);

	if (bGotList) // do nothing if no IDs given
	{
		bool bSuccess = true;

		// We need the editor id :(
		CGuideEntry GuideEntry(m_InputContext);
		GuideEntry.Initialise(iH2G2ID, m_InputContext.GetSiteID(), 0,false,true,true,false,true);
		int iEditorID = GuideEntry.GetEditorID();

		editForm.InitialiseResearcherList(iH2G2ID, iEditorID); // Won't work without this
		bSuccess = bSuccess && editForm.SetNewResearcherList(sResearcherListParam);
		bSuccess = bSuccess && editForm.CommitResearcherList();

		// update the edit history
		sNote << sResearcherListParam;
		bSuccess = bSuccess && editForm.AddEditHistory(m_pViewer, 18, sNote);

		if (!bSuccess)
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::CheckAndInsertTagNodes(CDNAIntArray& NodeArray)

		Author:		Mark Howitt
        Created:	09/06/2004
        Inputs:		-
        Outputs:	NodeArray - An Int array that will take the node ids from the input
        Returns:	true if ok, false if not
        Purpose:	Gets a list of node ids from the input and puts the node info into the xml
					adding the ids to the given array.

*********************************************************************************/

bool CTypedArticleBuilder::CheckAndInsertTagNodes( CDNAIntArray& NodeArray )
{
	// Check to see if we've got at least one node id. Just return if we don't
	if (m_InputContext.ParamExists("node"))
	{
		// Get the list of nodes from the Input
		int iNodeID = 0;
		for (int i = 0; i < m_InputContext.GetParamCount("node"); i++)
		{
			iNodeID = m_InputContext.GetParamInt("node",i);
			if (iNodeID > 0)
			{
				// Add the node to the array
				NodeArray.Add(iNodeID);
			}
		}

		// Get the tagitem object to get the node details and add them to the XML
		CCategory Cat(m_InputContext);
		Cat.GetDetailsForNodes(NodeArray,"TAGGINGNODES");
		m_pPage->AddInside("H2G2",&Cat);
	}
	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::CheckIsChangingPermissionsIllegally(bool bCanChangePermissions, 
						const TDVCHAR* pNewWhoCanEdit, const TDVCHAR* pOldWhoCanEdit)

	Author:		David van Zijl
    Created:	06/10/2004
    Inputs:		bCanChangePermissions - user's permissions for this article
				pNewWhoCanEdit - new value from form
				pOldWhoCanEdit - current value for article
    Outputs:	-
    Returns:	true if user trying to change permissions but not allowed to
    Purpose:	Checks if the intended permissions for the article are different from
				the current ones, if they are it checks that the user is allowed to change them.
				If returns true it also sets DNALastError

*********************************************************************************/

bool CTypedArticleBuilder::CheckIsChangingPermissionsIllegally(bool bCanChangePermissions, 
						const TDVCHAR* pNewWhoCanEdit, const TDVCHAR* pOldWhoCanEdit)
{
	if (pNewWhoCanEdit == NULL || pNewWhoCanEdit[0] == 0)
	{
		// This feature probably not implemented in the skin yet
		// Assume no change
		return false;
	}

	if (strcmp(pNewWhoCanEdit, pOldWhoCanEdit) != 0 && !bCanChangePermissions)
	{
		// Trying to change permissions without permission
		SetDNALastError("TypedArticleBuilder", "PERMISSIONS", "Sorry, you can't change permissions on this article");
		return true;
	}

	return false; // everything ok!
}


/*********************************************************************************

	void CTypedArticleBuilder::ProcessDerivedKeyPhraseActions(CMultiStep& Multi, CTDVString& KeyPhrases )

		Author:		Martin Robb
        Created:	28/07/2006
        Inputs:		Multi = the multistep object
					KeyPhrases string.
        Outputs:	- Auto / Derived KeyPhrase values.
        Returns:	-
        Purpose:	Goes through all the Required and Element params.
					Looks for autokeyphrase actions and collects the field value(s) from fields with autokeyphrase attributes.
					AutoKeyPhrases / Derived KeyPhrases are not explicit KeyPhrases, rather the KeyPhrases are derived from nominated Guide Entry fields.
*********************************************************************************/

void CTypedArticleBuilder::ProcessDerivedKeyPhraseActions(CMultiStep& Multi, CTDVString& sKeyPhrases )
{
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CArticleSearchPhrase akp(m_InputContext,delimit);

	int iIndex=0;
	bool bRequiredFound = true, bElementFound = true;
	while (bRequiredFound || bElementFound )
	{
		CTDVString sRequiredParamName, sElementParamName, sNamespacedElement;
		CTDVString sRequiredAction = 0, sElementAction = 0, sElementNamespace;
		bRequiredFound = bRequiredFound && Multi.GetRequiredParameterAction(iIndex,sRequiredParamName,sRequiredAction);
		bElementFound  = bElementFound  && Multi.GetElementParameterAction( iIndex,sElementParamName, sElementAction);

		CTDVString sValue;
		if (bRequiredFound && sRequiredAction == "KEYPHRASE" && Multi.GetRequiredValue(sRequiredParamName,sValue) )
		{
			akp.ParsePhrases(sValue,true);
		}

		if (bElementFound && sElementAction == "KEYPHRASE" && Multi.GetElementValue(sElementParamName,sValue) )
		{
			akp.ParsePhrases(sValue,true);
		}
		iIndex++;
	}

	sKeyPhrases = akp.GetPhraseListAsString();
}

void CTypedArticleBuilder::ProcessNamespacedKeyPhrases(CMultiStep& Multi, CTDVString& sKeyPhrases, CTDVString& sNamespaces)
{
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CArticleSearchPhrase akp(m_InputContext, delimit);
	int iIndex=0;
	bool bElemNamespaceFound = true;
	bool bReqNamespaceFound = true;

	while (bElemNamespaceFound && bReqNamespaceFound)
	{
		CTDVString sNamespacedElement;
		CTDVString sElementNamespace;
		CTDVString sValue;

		// Check the Elements first
		bElemNamespaceFound = bElemNamespaceFound && Multi.GetElementNamespace(iIndex, sNamespacedElement, sElementNamespace);
		if (bElemNamespaceFound && sElementNamespace.GetLength() && Multi.GetElementValue(sNamespacedElement, sValue))
		{
			int pos = 0;
			sNamespaces += sElementNamespace + delimit;
			while ((pos = sValue.Find(delimit, pos)) > 0)
			{
				sNamespaces += sElementNamespace + delimit;
				pos++;
			}
			akp.ParsePhrases(sValue, true, sNamespaces);
		}

		// Now check the required
		bReqNamespaceFound = bReqNamespaceFound && Multi.GetRequiredNamespace(iIndex, sNamespacedElement, sElementNamespace);
		if (bReqNamespaceFound && sElementNamespace.GetLength() && Multi.GetRequiredValue(sNamespacedElement, sValue))
		{
			int pos = 0;
			sNamespaces += sElementNamespace + delimit;
			while ((pos = sValue.Find(delimit, pos)) > 0)
			{
				sNamespaces += sElementNamespace + delimit;
				pos++;
			}
			akp.ParsePhrases(sValue, true, sNamespaces);
		}

		iIndex++;
	}
	
	sKeyPhrases = akp.GetPhraseListAsString();
}

/*********************************************************************************

	void CTypedArticleBuilder::UpdateDerivedKeyPhrases(CGuideEntry, CMultiStep)

		Author:		Martin Robb
        Created:	28/07/2006
        Inputs:		Multi = the multistep before editing
					EditMulti - multistep with edits
        Outputs:	-
        Returns:	-
        Purpose:	Analyses the edits and updates deerived key phrases. 
					Derived KeyPhrases are derived from other fields.
					This means a user does not explcitly declare key phrases th ekey phrases are derived from the 
					guide entry details.

*********************************************************************************/
bool CTypedArticleBuilder::UpdateDerivedKeyPhrases( int iH2G2ID, CMultiStep& Multi, CMultiStep& EditMulti )
{
	//Examine Auto-KeyPhrase fields - dissasociate old auto-phrases and add new. 
	bool bRequiredParamFound = true;
	bool bElementParamFound = true;
	CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
	CArticleSearchPhrase asp(m_InputContext,delimit);
	CArticleSearchPhrase aspedit(m_InputContext,delimit);
	int index = 0;
	while ( bRequiredParamFound || bElementParamFound )
	{
		CTDVString sParam, sAction;
		bRequiredParamFound = EditMulti.GetRequiredParameterAction(index,sParam,sAction);
		bElementParamFound = EditMulti.GetElementParameterAction(index,sParam,sAction);
		if ( sAction == "KEYPHRASE" )
		{
			//Get Current Value 
			if ( bRequiredParamFound )
			{
				CTDVString sValue = Multi.GetRequiredValue(sParam);
				if ( !sValue.IsEmpty() )
					asp.ParsePhrases(sValue,true);

				sValue = EditMulti.GetRequiredValue(sParam);
				if ( !sValue.IsEmpty() )
					aspedit.ParsePhrases(sValue,true);
			}
			if ( bElementParamFound )
			{
				CTDVString sValue = Multi.GetElementValue(sParam);
				if ( !sValue.IsEmpty() )
					asp.ParsePhrases(sValue,true);

				sValue = EditMulti.GetElementValue(sParam);
				if ( !sValue.IsEmpty() )
					aspedit.ParsePhrases(sValue,true);
			}
		}
		index++;
	}

	//Get Key Phrases before edits.
	SEARCHPHRASELIST currentautophrases = asp.GetPhraseList();

	//Get Key Phrases after edit.
	SEARCHPHRASELIST autophrases = aspedit.GetPhraseList();

	//Verify if auto phrases exist and have been edited.
	if ( currentautophrases.size() != autophrases.size() || !equal(currentautophrases.begin(),currentautophrases.end(),autophrases.begin() ) )
	{
		//Remove autophrases from article.
		if ( !asp.RemoveAllKeyPhrasesFromArticle(iH2G2ID) )
	{
		m_pPage->AddInside("H2G2",asp.GetLastErrorAsXMLString());
		return false;
	}

		//Add auto key phrases
	asp.SetPhraseList(autophrases);
	if ( !asp.AddKeyPhrases(iH2G2ID) )
	{
		m_pPage->AddInside("H2G2",asp.GetLastErrorAsXMLString());
		return false;
	}
	}
	return true;
}

/*********************************************************************************

	void CTypedArticleBuilder::ProcessExtraInfoActions(CMultiStep& Multi,CExtraInfo& ExtraInfo)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		Multi = the multistep object
					ExtraInfo = the extra info object to apply actions to
        Outputs:	-
        Returns:	-
        Purpose:	Goes through all the Required and Element params, and applies any extrainfo
					actions that may have been specified

*********************************************************************************/

void CTypedArticleBuilder::ProcessExtraInfoActions(CMultiStep& Multi,CExtraInfo& ExtraInfo)
{
	int iIndex=0;
	bool bRequiredFound = true, bElementFound = true;
	while (bRequiredFound || bElementFound)
	{
		CTDVString sRequiredParamName, sElementParamName;
		int nRequiredAction = 0, nElementAction = 0;
		bRequiredFound = bRequiredFound && Multi.GetRequiredExtraInfoAction(iIndex,sRequiredParamName,nRequiredAction);
		bElementFound  = bElementFound  && Multi.GetElementExtraInfoAction( iIndex,sElementParamName, nElementAction);

		if (bRequiredFound)
		{
			ProcessExtraInfoAction(ExtraInfo,nRequiredAction,sRequiredParamName,Multi.GetRequiredValue(sRequiredParamName));
		}

		if (bElementFound)
		{
			ProcessExtraInfoAction(ExtraInfo,nElementAction, sElementParamName, Multi.GetElementValue(sElementParamName));
		}
		iIndex++;
	}
}

/*********************************************************************************

	void CTypedArticleBuilder::ProcessExtraInfoAction(CExtraInfo& ExtraInfo,int nAction,const TDVCHAR* pName, const TDVCHAR* pValue)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		ExtraInfo = the object to apply the action to
					nAction = the action to apply
					pName = the name of the param to apply action to
					pValue = the value of param pName
        Outputs:	-
        Returns:	-
        Purpose:	Applies the given action using the params supplied.

					MULTISTEP_EI_ADD:
						Adds an XML tag to ExtraInfo of the form:
							<[pName]>[pValue]</[pName]>
						It makes sure there's only one tag with the name pName

					MULTISTEP_EI_REMOVE:
						Removes all tags in ExtraInfo with the name pName

*********************************************************************************/

void CTypedArticleBuilder::ProcessExtraInfoAction(CExtraInfo& ExtraInfo,int nAction,const TDVCHAR* pName, const TDVCHAR* pValue)
{
	switch (nAction)
	{
		case CMultiStep::MULTISTEP_EI_ADD:
		{
			ExtraInfo.AddUniqueInfoItem(pName,CXMLObject::MakeTag(pName,CTDVString(pValue)));
		}
		break;

		case CMultiStep::MULTISTEP_EI_REMOVE:
		{
			ExtraInfo.RemoveAllInfoItems(pName);
		}
		break;
	}
}

/*********************************************************************************

	bool CTypedArticleBuilder::LinkToClub(int iArticleID, int iClubID, const TDVCHAR* pRelationship)

		Author:		James Pullicino
        Created:	01/06/2005
        Inputs:		iArticleID		- h2g2 ID of article
					iClubID			- ID of club
					pRelationship	- Link relationship 
        Outputs:	-
        Returns:	-
        Purpose:	Link an article to a club

*********************************************************************************/

bool CTypedArticleBuilder::LinkToClub(int iArticleID, int iClubID, const TDVCHAR* pRelationship)
{
	TDVASSERT(iClubID, "CTypedArticleBuilder::AddClubLink() invalid parameter iClubID");

	CClub club(m_InputContext);
	if (!club.InitialiseViaClubID(iClubID))
	{
		TDVASSERT(false, "CTypedArticleBuilder::CreateTypedArticle() club.InitialiseViaClubID() failed");
		return false;
	}

	// Must be logged in
	CUser *pCurrentUser = m_InputContext.GetCurrentUser();
	if(!pCurrentUser)
	{
		TDVASSERT(false, "Cannot link article to club if user is not logged in");
		return false;
	}
	
	// Use CDnaUrl to get link information
	CTDVString sArticleUrl; 
	sArticleUrl << "A" << iArticleID;

	CDnaUrl url(m_InputContext);
	url.Initialise(sArticleUrl);
    
	// Sanity check
	TDVASSERT(url.IsArticle(), "Expected URL to be of type article");

	// Do linking
	if(!club.AddLink(pCurrentUser, url.GetTypeName(), iArticleID, pRelationship, url.GetUrl(), "", ""))
	{
		TDVASSERT(false, "Failed to add club link");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CTypedArticleBuilder::LinkArticleAndMediaAsset(int ih2g2ID, int iMediaAssetID)

	Author:		Steven Francis
	Created:	18/11/2005
	Inputs:		ih2g2ID - the article id
				iMediaAssetID - the media asset id
	Outputs:	
	Returns:	bool if the link entry added ok
	Purpose:	Creates a record that links an article id to a media asset id
*********************************************************************************/
bool CTypedArticleBuilder::LinkArticleAndMediaAsset(int iH2G2ID, int iMediaAssetID)
{
	bool bOK = false;
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CTypedArticleBuilder", "LinkArticleAndMediaAsset", "InitialiseStoredProcedureObject Failed.");
	}
	if ( SP.LinkArticleAndMediaAsset(iH2G2ID, iMediaAssetID))
	{
		bOK = true;
	}
	return bOK;
}

bool CTypedArticleBuilder::CheckIsUserBanned(int iArticleSiteID)
{
	bool bIsBanned = false;
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if (iArticleSiteID != 0)
	{
		CUser user(m_InputContext);
		user.SetSiteID(iArticleSiteID);
		user.CreateFromID(pViewingUser->GetUserID());
		bIsBanned = user.GetIsBannedFromPosting();
	}
	else
	{
		bIsBanned = pViewingUser->GetIsBannedFromPosting();
	}
	return bIsBanned;
}

/*********************************************************************************

	bool CTypedArticleBuilder::GetDateRangeFromMultiStep(CMultiStep& Multi, CDateRangeValidation& dateRangeVal)

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		Multi = the multistep object to use
					dateRangeVal = ref to a DateRangeValidation object

		Outputs:	dateRangeVal contains the validated date and the validation result
		Returns:	true if a date range has been provided in the Muli object, false otherwise
		Purpose:	Looks in the Multi object for a date range specification, and validates it if there is one.

					No date range has been given in the Multi object if either STARTDATE is undefined, or set it "0".

					If STARTDATE has been specified, it assumes the other params have also been defined, and dateRangeVal
					is used to validate the date.

*********************************************************************************/

bool CTypedArticleBuilder::GetDateRangeFromMultiStep(CMultiStep& Multi, CDateRangeValidation& dateRangeVal)
{
	CTDVString sElVal;

	CTDVString sStartDate = Multi.GetRequiredValue("STARTDATE");
	int iStartDay   = atoi(Multi.GetRequiredValue("STARTDAY"));
	int iStartMonth = atoi(Multi.GetRequiredValue("STARTMONTH"));
	int iStartYear  = atoi(Multi.GetRequiredValue("STARTYEAR"));

	CTDVString sEndDate = Multi.GetRequiredValue("ENDDATE");
	int iEndDay   = atoi(Multi.GetRequiredValue("ENDDAY"));
	int iEndMonth = atoi(Multi.GetRequiredValue("ENDMONTH"));
	int iEndYear  = atoi(Multi.GetRequiredValue("ENDYEAR"));

	int iTimeInterval = atoi(Multi.GetRequiredValue("TIMEINTERVAL"));

	bool bValidateTimeInterval = false; 
	if (iTimeInterval != -1) // default value for timeinterval is -1 (see GetMultiStepInput)
	{
		// timeinterval has been submitted because default value has been changed
		bValidateTimeInterval = true;
	}

	// Check to see what we've been given. If we have a Start day > 0 then use the day, month, year call. If not, use the parse date method.
	if (iStartDay > 0)
	{
		CTDVDateTime newStartDate(iStartYear, iStartMonth, iStartDay, 0, 0, 0);
		if (!newStartDate.GetStatus())
		{
			// The start date is invalid, so no point going any further!
			SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateInvalid","Start date is invalid");
			dateRangeVal.SetLastValidationResult(CDateRangeValidation::STARTDATE_INVALID);
			return true;
		}

		if (iEndDay > 0)
		{
			CTDVDateTime newEndDate(iEndYear, iEndMonth, iEndDay, 0, 0, 0);
			if (!newEndDate.GetStatus())
			{
				// The start date is invalid, so no point going any further!
				SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","EndDateInvalid","End date is invalid");
				dateRangeVal.SetLastValidationResult(CDateRangeValidation::ENDDATE_INVALID);
				return true;
			}

			// Check to make sure that the start date is before the end date
			if (newStartDate > newEndDate)
			{
				SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateGreaterThanEndDate","Start date greater than end date");
				dateRangeVal.SetLastValidationResult(CDateRangeValidation::STARTDATE_GREATERTHAN_ENDDATE);
				return true;
			}

			// If an end date has been passed in by the user add a day to it to reflect their intentions - I.e. they mean midnight on the date specified.
			// E.g. User inputs start date = '01/09/1975' end date = '02/09/1975' and means 01/09/1975 00:00 to 03/09/1975 00:00
			COleDateTimeSpan DayInterval(1, 00, 00, 00);
			newEndDate += DayInterval;

			// validate date range.
			dateRangeVal.ValidateDateRange(newStartDate, newEndDate, iTimeInterval, true, true, bValidateTimeInterval);
			return true;
		}
		else
		{
			// No end date passed in by user so create one using the start date.
			// Check to make sure that the start date params are valid
			CTDVDateTime newEndDate(iStartYear, iStartMonth, iStartDay, 0, 0, 0);
			if (!newEndDate.GetStatus())
			{
				// The start date is invalid, so no point going any further!
				SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateInvalid","Start date is invalid");
				dateRangeVal.SetLastValidationResult(CDateRangeValidation::STARTDATE_INVALID);
				return true;
			}

			// End date defaults to start date + 1
			COleDateTimeSpan dDayInterval(1, 0, 0, 0);
			newEndDate += dDayInterval;

			dateRangeVal.ValidateDateRange(newStartDate, newEndDate, iTimeInterval, true, true, bValidateTimeInterval);
			return true;
		}
	}
	else if (!sStartDate.IsEmpty())
	{
		// Check if start date is of valid format. 
		if (!CTDVDateTime::IsStringValidDDMMYYYYFormat(sStartDate))
		{
			SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateInvalid","Start date is invalid");
			dateRangeVal.SetLastValidationResult(CDateRangeValidation::STARTDATE_INVALID);
			return true; 
		}

		COleDateTime parsedStartDate(2000,1,1,0,0,0);

		if (!parsedStartDate.ParseDateTime(sStartDate,0,0x0809)) //0x0409 - USEnglish, 0x0809 - UKEnglish
		{
			// The start date is invalid, so no point going any further!
			SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateInvalid","Start date is invalid");
			dateRangeVal.SetLastValidationResult(CDateRangeValidation::STARTDATE_INVALID);
			return true;
		}

		if (!sEndDate.IsEmpty())
		{
			// Check if end date is of valid format. 
			if (!CTDVDateTime::IsStringValidDDMMYYYYFormat(sEndDate))
			{
				SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateInvalid","End date is invalid");
				dateRangeVal.SetLastValidationResult(CDateRangeValidation::ENDDATE_INVALID);
				return true; 
			}

			COleDateTime parsedEndDate(2000,1,1,0,0,0);

			if (!parsedEndDate.ParseDateTime(sEndDate,0,0x0809)) //0x0409 - USEnglish, 0x0809 - UKEnglish
			{
				// The end date is invalid, so no point going any further!
				SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","EndDateInvalid","End date is invalid");
				dateRangeVal.SetLastValidationResult(CDateRangeValidation::ENDDATE_INVALID);
				return true;
			}

			// Check to make sure that the start date is before the end date
			if (parsedStartDate > parsedEndDate)
			{
				SetDNALastError("CTypedArticleBuilder::GetDateRangeFromMultiStep","StartDateGreaterThanEndDate","Start date greater than end date");
				dateRangeVal.SetLastValidationResult(CDateRangeValidation::STARTDATE_GREATERTHAN_ENDDATE);
				return true;
			}

			// If an end date has been passed in by the user add a day to it to reflect their intentions - I.e. they mean midnight on the date specified.
			// E.g. User inputs start date = '01/09/1975' end date = '02/09/1975' and means 01/09/1975 00:00 to 03/09/1975 00:00
			COleDateTimeSpan DayInterval(1, 00, 00, 00);
			parsedEndDate += DayInterval;

			// validate date range.
			dateRangeVal.ValidateDateRange(parsedStartDate, parsedEndDate, iTimeInterval, true, true, bValidateTimeInterval);
			return true;
		}
		else 
		{
			COleDateTimeSpan DayInterval(1, 00, 00, 00);
			COleDateTime parsedEndDate = parsedStartDate + DayInterval;

			dateRangeVal.ValidateDateRange(parsedStartDate, parsedEndDate, iTimeInterval, true, true, bValidateTimeInterval);
			return true;
		}
	}

	return false;
}


/*********************************************************************************

	void CTypedArticleBuilder::SetArticleDateRangeFromMultiStep(CStoredProcedure& SP, int iH2G2ID, CDateRangeValidation& dateRangeVal)

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		SP = an initialised stored procedure object
					iH2G2ID = the id of the article to add/update the date range of
					dateRangeVal = contains a validated date range
		Outputs:	-
		Returns:	-
		Purpose:	This will set or update the date range info for the given article, but only if 
					dateRangeVal contains a validated date range.
					Or if the date range has been removed.

*********************************************************************************/

void CTypedArticleBuilder::SetArticleDateRangeFromMultiStep(CStoredProcedure& SP, int iH2G2ID, CDateRangeValidation& dateRangeVal)
{
	if (iH2G2ID > 0 && dateRangeVal.GetLastValidationResult() == CDateRangeValidation::VALID)
	{
		CTDVDateTime dStartDate = dateRangeVal.GetStartDate();
		CTDVDateTime dEndDate   = dateRangeVal.GetEndDate();
		int iTimeInterval	    = dateRangeVal.GetTimeInterval();

		SP.SetArticleDateRange(iH2G2ID/10,dStartDate,dEndDate,iTimeInterval);
	}
	else if (iH2G2ID > 0 && dateRangeVal.GetLastValidationResult() == CDateRangeValidation::NOTVALIDATEDYET)
	{
		//The date range validation is set to NOTVALIDATEDYET meaning it's been removed
		SP.RemoveArticleDateRange(iH2G2ID/10);
	}
}

