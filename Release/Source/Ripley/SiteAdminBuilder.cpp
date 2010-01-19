// SiteAdminBuilder.cpp: implementation of the CSiteAdminBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "SiteAdminBuilder.h"
#include "Forum.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteAdminBuilder::CSiteAdminBuilder(CInputContext& inputContext) :
	CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CSiteAdminBuilder::~CSiteAdminBuilder()
{

}

bool CSiteAdminBuilder::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "SITEADMIN-EDITOR", true);
	int iSiteID = m_InputContext.GetSiteID();
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pPageXML->SetPageType("ERROR");
		pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot administer a site unless you are logged in as an Editor.</ERROR>");
		return true;
	}
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CTDVString sURLName;
	CTDVString sSSOService;
	CTDVString sShortName;
	CTDVString sDescription;
	CTDVString sDefaultSkin;
    CTDVString sSkinSet;
	CTDVString sModeratorsEmail;
	CTDVString sEditorsEmail;
	CTDVString sFeedbackEmail;
	CTDVString sThreadOrder;
	CTDVString sModMode;
	CTDVString sEventEmailSubject;
	int iThreadOrder = 0;
	int iAutoMessageUserID = 0;
	int iThreadEditTimeLimit = 0;
	int iEventAlertMessageUserID = 0;
	int iAllowRemoveVote = 0;
	int iIncludeCrumbtrail = 0;
	int iAllowPostCodesInSearch = 0;
	bool bPreModeration = true;
	bool bUnmoderated = true;
	bool bNoAutoSwitch = true;
	bool bCustomTerms = true;
	bool bUseFrames = true;
	bool bPassworded = true;
	bool bQueuePostings = false;
	int iTopicsClosed = 0;
	


	bool bArticleGuestBookForums;
	CTDVString sResult;

	if (m_InputContext.ParamExists("update"))
	{
		bool bDoUpdate = true; // set to false if error occurs

		m_InputContext.GetParamString("shortname", sShortName);
		m_InputContext.GetParamString("ssoservice", sSSOService);
		m_InputContext.GetParamString("description", sDescription);
		m_InputContext.GetParamString("defaultskin", sDefaultSkin);
        m_InputContext.GetParamString("skinset", sSkinSet);
		m_InputContext.GetParamString("ModeratorsEmail", sModeratorsEmail);
		m_InputContext.GetParamString("EditorsEmail", sEditorsEmail);
		m_InputContext.GetParamString("FeedbackEmail", sFeedbackEmail);
		m_InputContext.GetParamString("ThreadOrder", sThreadOrder);
		m_InputContext.GetParamString("EventEmailSubject",sEventEmailSubject);
		iThreadOrder = CForum::GetThreadOrderID(sThreadOrder);
		iAllowRemoveVote = m_InputContext.GetParamInt("AllowRemoveVote");
		iIncludeCrumbtrail = m_InputContext.GetParamInt("IncludeCrumbtrail");
		iAllowPostCodesInSearch = m_InputContext.GetParamInt("AllowPostCodesInSearch");
		bQueuePostings = (1 == m_InputContext.GetParamInt("QueuePostings"));
		iTopicsClosed = m_InputContext.GetParamInt("TopicsClosed");

		if(m_InputContext.ParamExists("modmode"))
		{
			m_InputContext.GetParamString("modmode", sModMode);
			
			// new mod mode functionality

			if(sModMode.CompareText("postmod"))
			{
				bPreModeration	= 0;
				bUnmoderated	= 0;
			}
			else
			{
				bPreModeration	= sModMode.CompareText("premod");
				bUnmoderated	= sModMode.CompareText("unmod");
			}
		}
		else
		{
			bPreModeration	= (m_InputContext.GetParamInt("premoderation") != 0);
			bUnmoderated	= (m_InputContext.GetParamInt("unmoderated") != 0);
		}

		bNoAutoSwitch	= (m_InputContext.GetParamInt("crosslink") != 0);
		bCustomTerms	= (m_InputContext.GetParamInt("customterms") != 0);
		bPassworded		= (m_InputContext.GetParamInt("passworded") != 0);

		bArticleGuestBookForums = (m_InputContext.GetParamInt("articleguestbookforums") != 0);
		iAutoMessageUserID   = m_InputContext.GetParamInt("AutoMessageUserID");
		iEventAlertMessageUserID = m_InputContext.GetParamInt("EventAlertMessageUserID");
		bDoUpdate = bDoUpdate && GetAndCheckThreadEditTimeLimit(iThreadEditTimeLimit);

		if (bDoUpdate)
		{
			CTDVString sError;
			int iResult = SP.UpdateSiteDetails(iSiteID, sShortName, sSSOService, sDescription, 
				sDefaultSkin, sSkinSet, bPreModeration, bNoAutoSwitch, bCustomTerms, &sError,
				sModeratorsEmail, sEditorsEmail, sFeedbackEmail,iAutoMessageUserID, 
				bPassworded, bUnmoderated, bArticleGuestBookForums, iThreadOrder, iThreadEditTimeLimit,
				sEventEmailSubject, iEventAlertMessageUserID, iAllowRemoveVote, iIncludeCrumbtrail, 
				iAllowPostCodesInSearch, bQueuePostings, iTopicsClosed);
			if (iResult == 0 && pViewer->GetIsEditor() && m_InputContext.GetParamInt("setdefaults") == 1) 
			{
				// Set the default settings for things like club permissions
				int iClubCanAutoJoinMember = m_InputContext.GetParamInt("ClubCanAutoJoinMember");
				int iClubCanAutoJoinOwner = m_InputContext.GetParamInt("ClubCanAutoJoinOwner");
				int iClubCanBecomeMember = m_InputContext.GetParamInt("ClubCanBecomeMember");
				int iClubCanBecomeOwner = m_InputContext.GetParamInt("ClubCanBecomeOwner");
				int iClubCanApproveMembers = m_InputContext.GetParamInt("ClubCanApproveMembers");
				int iClubCanApproveOwners = m_InputContext.GetParamInt("ClubCanApproveOwners");
				int iClubCanDemoteOwners = m_InputContext.GetParamInt("ClubCanDemoteOwners");
				int iClubCanDemoteMembers = m_InputContext.GetParamInt("ClubCanDemoteMembers");
				int iClubCanViewActions = m_InputContext.GetParamInt("ClubCanViewActions");
				int iClubCanView = m_InputContext.GetParamInt("ClubCanView");
				int iClubCanPostJournal = m_InputContext.GetParamInt("ClubCanPostJournal");
				int iClubCanPostCalendar = m_InputContext.GetParamInt("ClubCanPostCalendar");
				int iClubCanEdit = m_InputContext.GetParamInt("ClubCanEdit");

				int iClubOwnerCanAutoJoinMember = m_InputContext.GetParamInt("ClubOwnerCanAutoJoinMember");
				int iClubOwnerCanAutoJoinOwner = m_InputContext.GetParamInt("ClubOwnerCanAutoJoinOwner");
				int iClubOwnerCanBecomeMember = m_InputContext.GetParamInt("ClubOwnerCanBecomeMember");
				int iClubOwnerCanBecomeOwner = m_InputContext.GetParamInt("ClubOwnerCanBecomeOwner");
				int iClubOwnerCanApproveMembers = m_InputContext.GetParamInt("ClubOwnerCanApproveMembers");
				int iClubOwnerCanApproveOwners = m_InputContext.GetParamInt("ClubOwnerCanApproveOwners");
				int iClubOwnerCanDemoteOwners = m_InputContext.GetParamInt("ClubOwnerCanDemoteOwners");
				int iClubOwnerCanDemoteMembers = m_InputContext.GetParamInt("ClubOwnerCanDemoteMembers");
				int iClubOwnerCanViewActions = m_InputContext.GetParamInt("ClubOwnerCanViewActions");
				int iClubOwnerCanView = m_InputContext.GetParamInt("ClubOwnerCanView");
				int iClubOwnerCanPostJournal = m_InputContext.GetParamInt("ClubOwnerCanPostJournal");
				int iClubOwnerCanPostCalendar = m_InputContext.GetParamInt("ClubOwnerCanPostCalendar");
				int iClubOwnerCanEdit = m_InputContext.GetParamInt("ClubOwnerCanEdit");

				int iClubMemberCanAutoJoinMember = m_InputContext.GetParamInt("ClubMemberCanAutoJoinMember");
				int iClubMemberCanAutoJoinOwner = m_InputContext.GetParamInt("ClubMemberCanAutoJoinOwner");
				int iClubMemberCanBecomeMember = m_InputContext.GetParamInt("ClubMemberCanBecomeMember");
				int iClubMemberCanBecomeOwner = m_InputContext.GetParamInt("ClubMemberCanBecomeOwner");
				int iClubMemberCanApproveMembers = m_InputContext.GetParamInt("ClubMemberCanApproveMembers");
				int iClubMemberCanApproveOwners = m_InputContext.GetParamInt("ClubMemberCanApproveOwners");
				int iClubMemberCanDemoteOwners = m_InputContext.GetParamInt("ClubMemberCanDemoteOwners");
				int iClubMemberCanDemoteMembers = m_InputContext.GetParamInt("ClubMemberCanDemoteMembers");
				int iClubMemberCanViewActions = m_InputContext.GetParamInt("ClubMemberCanViewActions");
				int iClubMemberCanView = m_InputContext.GetParamInt("ClubMemberCanView");
				int iClubMemberCanPostJournal = m_InputContext.GetParamInt("ClubMemberCanPostJournal");
				int iClubMemberCanPostCalendar = m_InputContext.GetParamInt("ClubMemberCanPostCalendar");
				int iClubMemberCanEdit = m_InputContext.GetParamInt("ClubMemberCanEdit");

				int iClosedClubCanAutoJoinMember = m_InputContext.GetParamInt("ClosedClubCanAutoJoinMember");
				int iClosedClubCanAutoJoinOwner = m_InputContext.GetParamInt("ClosedClubCanAutoJoinOwner");
				int iClosedClubCanBecomeMember = m_InputContext.GetParamInt("ClosedClubCanBecomeMember");
				int iClosedClubCanBecomeOwner = m_InputContext.GetParamInt("ClosedClubCanBecomeOwner");
				int iClosedClubCanApproveMembers = m_InputContext.GetParamInt("ClosedClubCanApproveMembers");
				int iClosedClubCanApproveOwners = m_InputContext.GetParamInt("ClosedClubCanApproveOwners");
				int iClosedClubCanDemoteOwners = m_InputContext.GetParamInt("ClosedClubCanDemoteOwners");
				int iClosedClubCanDemoteMembers = m_InputContext.GetParamInt("ClosedClubCanDemoteMembers");
				int iClosedClubCanViewActions = m_InputContext.GetParamInt("ClosedClubCanViewActions");
				int iClosedClubCanView = m_InputContext.GetParamInt("ClosedClubCanView");
				int iClosedClubCanPostJournal = m_InputContext.GetParamInt("ClosedClubCanPostJournal");
				int iClosedClubCanPostCalendar = m_InputContext.GetParamInt("ClosedClubCanPostCalendar");
				int iClosedClubCanEdit = m_InputContext.GetParamInt("ClosedClubCanEdit");

				int iClosedClubOwnerCanAutoJoinMember = m_InputContext.GetParamInt("ClosedClubOwnerCanAutoJoinMember");
				int iClosedClubOwnerCanAutoJoinOwner = m_InputContext.GetParamInt("ClosedClubOwnerCanAutoJoinOwner");
				int iClosedClubOwnerCanBecomeMember = m_InputContext.GetParamInt("ClosedClubOwnerCanBecomeMember");
				int iClosedClubOwnerCanBecomeOwner = m_InputContext.GetParamInt("ClosedClubOwnerCanBecomeOwner");
				int iClosedClubOwnerCanApproveMembers = m_InputContext.GetParamInt("ClosedClubOwnerCanApproveMembers");
				int iClosedClubOwnerCanApproveOwners = m_InputContext.GetParamInt("ClosedClubOwnerCanApproveOwners");
				int iClosedClubOwnerCanDemoteOwners = m_InputContext.GetParamInt("ClosedClubOwnerCanDemoteOwners");
				int iClosedClubOwnerCanDemoteMembers = m_InputContext.GetParamInt("ClosedClubOwnerCanDemoteMembers");
				int iClosedClubOwnerCanViewActions = m_InputContext.GetParamInt("ClosedClubOwnerCanViewActions");
				int iClosedClubOwnerCanView = m_InputContext.GetParamInt("ClosedClubOwnerCanView");
				int iClosedClubOwnerCanPostJournal = m_InputContext.GetParamInt("ClosedClubOwnerCanPostJournal");
				int iClosedClubOwnerCanPostCalendar = m_InputContext.GetParamInt("ClosedClubOwnerCanPostCalendar");
				int iClosedClubOwnerCanEdit = m_InputContext.GetParamInt("ClosedClubOwnerCanEdit");

				int iClosedClubMemberCanAutoJoinMember = m_InputContext.GetParamInt("ClosedClubMemberCanAutoJoinMember");
				int iClosedClubMemberCanAutoJoinOwner = m_InputContext.GetParamInt("ClosedClubMemberCanAutoJoinOwner");
				int iClosedClubMemberCanBecomeMember = m_InputContext.GetParamInt("ClosedClubMemberCanBecomeMember");
				int iClosedClubMemberCanBecomeOwner = m_InputContext.GetParamInt("ClosedClubMemberCanBecomeOwner");
				int iClosedClubMemberCanApproveMembers = m_InputContext.GetParamInt("ClosedClubMemberCanApproveMembers");
				int iClosedClubMemberCanApproveOwners = m_InputContext.GetParamInt("ClosedClubMemberCanApproveOwners");
				int iClosedClubMemberCanDemoteOwners = m_InputContext.GetParamInt("ClosedClubMemberCanDemoteOwners");
				int iClosedClubMemberCanDemoteMembers = m_InputContext.GetParamInt("ClosedClubMemberCanDemoteMembers");
				int iClosedClubMemberCanViewActions = m_InputContext.GetParamInt("ClosedClubMemberCanViewActions");
				int iClosedClubMemberCanView = m_InputContext.GetParamInt("ClosedClubMemberCanView");
				int iClosedClubMemberCanPostJournal = m_InputContext.GetParamInt("ClosedClubMemberCanPostJournal");
				int iClosedClubMemberCanPostCalendar = m_InputContext.GetParamInt("ClosedClubMemberCanPostCalendar");
				int iClosedClubMemberCanEdit = m_InputContext.GetParamInt("ClosedClubMemberCanEdit");

				SP.UpdateDefaultPermissions( 
						iSiteID, 
						iClubCanAutoJoinMember, 
						iClubCanAutoJoinOwner, 
						iClubCanBecomeMember, 
						iClubCanBecomeOwner, 
						iClubCanApproveMembers, 
						iClubCanApproveOwners, 
						iClubCanDemoteOwners, 
						iClubCanDemoteMembers, 
						iClubCanViewActions, 
						iClubCanView, 
						iClubCanPostJournal, 
						iClubCanPostCalendar, 
						iClubCanEdit, 

						iClubOwnerCanAutoJoinMember, 
						iClubOwnerCanAutoJoinOwner, 
						iClubOwnerCanBecomeMember, 
						iClubOwnerCanBecomeOwner, 
						iClubOwnerCanApproveMembers, 
						iClubOwnerCanApproveOwners, 
						iClubOwnerCanDemoteOwners, 
						iClubOwnerCanDemoteMembers, 
						iClubOwnerCanViewActions, 
						iClubOwnerCanView, 
						iClubOwnerCanPostJournal, 
						iClubOwnerCanPostCalendar, 
						iClubOwnerCanEdit, 

						iClubMemberCanAutoJoinMember, 
						iClubMemberCanAutoJoinOwner, 
						iClubMemberCanBecomeMember, 
						iClubMemberCanBecomeOwner, 
						iClubMemberCanApproveMembers, 
						iClubMemberCanApproveOwners, 
						iClubMemberCanDemoteOwners, 
						iClubMemberCanDemoteMembers, 
						iClubMemberCanViewActions, 
						iClubMemberCanView, 
						iClubMemberCanPostJournal, 
						iClubMemberCanPostCalendar, 
						iClubMemberCanEdit, 

						iClosedClubCanAutoJoinMember, 
						iClosedClubCanAutoJoinOwner, 
						iClosedClubCanBecomeMember, 
						iClosedClubCanBecomeOwner, 
						iClosedClubCanApproveMembers, 
						iClosedClubCanApproveOwners, 
						iClosedClubCanDemoteOwners, 
						iClosedClubCanDemoteMembers, 
						iClosedClubCanViewActions, 
						iClosedClubCanView, 
						iClosedClubCanPostJournal, 
						iClosedClubCanPostCalendar, 
						iClosedClubCanEdit, 

						iClosedClubOwnerCanAutoJoinMember, 
						iClosedClubOwnerCanAutoJoinOwner, 
						iClosedClubOwnerCanBecomeMember, 
						iClosedClubOwnerCanBecomeOwner, 
						iClosedClubOwnerCanApproveMembers, 
						iClosedClubOwnerCanApproveOwners, 
						iClosedClubOwnerCanDemoteOwners, 
						iClosedClubOwnerCanDemoteMembers, 
						iClosedClubOwnerCanViewActions, 
						iClosedClubOwnerCanView, 
						iClosedClubOwnerCanPostJournal, 
						iClosedClubOwnerCanPostCalendar, 
						iClosedClubOwnerCanEdit, 

						iClosedClubMemberCanAutoJoinMember, 
						iClosedClubMemberCanAutoJoinOwner, 
						iClosedClubMemberCanBecomeMember, 
						iClosedClubMemberCanBecomeOwner, 
						iClosedClubMemberCanApproveMembers, 
						iClosedClubMemberCanApproveOwners, 
						iClosedClubMemberCanDemoteOwners, 
						iClosedClubMemberCanDemoteMembers, 
						iClosedClubMemberCanViewActions, 
						iClosedClubMemberCanView, 
						iClosedClubMemberCanPostJournal, 
						iClosedClubMemberCanPostCalendar,
						iClosedClubMemberCanEdit 
					);

				// update the site threadordering 

			}
			sResult = "<UPDATERESULT RESULT='";
			sResult << iResult << "'>" << sError << "</UPDATERESULT/>";
			m_InputContext.SiteDataUpdated();
			m_InputContext.Signal("/Signal?action=recache-site");

		} // end if (bDoUpdate)
		else
		{
			pPageXML->AddInside("H2G2", GetLastErrorAsXMLString());
		}
	}
	else if (m_InputContext.ParamExists("newsite"))
	{
		bool bDoUpdate = true;

		CTDVString sSkinDescription;
		m_InputContext.GetParamString("urlname", sURLName);
		m_InputContext.GetParamString("shortname", sShortName);
		m_InputContext.GetParamString("ssoservice", sSSOService);
		m_InputContext.GetParamString("description", sDescription);
		m_InputContext.GetParamString("defaultskin", sDefaultSkin);
        m_InputContext.GetParamString("skinset",sSkinSet);
		m_InputContext.GetParamString("skindescription", sSkinDescription);
		m_InputContext.GetParamString("ModeratorsEmail", sModeratorsEmail);
		m_InputContext.GetParamString("EditorsEmail", sEditorsEmail);
		m_InputContext.GetParamString("FeedbackEmail", sFeedbackEmail);
		m_InputContext.GetParamString("ThreadOrder", sThreadOrder);
		m_InputContext.GetParamString("EventEmailSubject",sEventEmailSubject);
		iThreadOrder = CForum::GetThreadOrderID(sThreadOrder);
		iAllowRemoveVote = m_InputContext.GetParamInt("AllowRemoveVote");
		iIncludeCrumbtrail = m_InputContext.GetParamInt("IncludeCrumbtrail");
		iAllowPostCodesInSearch = m_InputContext.GetParamInt("AllowPostCodesInSearch");
		bDoUpdate = bDoUpdate && GetAndCheckThreadEditTimeLimit(iThreadEditTimeLimit);

		//mod mode functionality
		if(m_InputContext.ParamExists("modmode"))
		{
			m_InputContext.GetParamString("modmode", sModMode);
			
			// new mod mode functionality

			if(sModMode.CompareText("postmod"))
			{
				bPreModeration	= 0;
				bUnmoderated	= 0;
			}
			else
			{
				bPreModeration	= sModMode.CompareText("premod");
				bUnmoderated	= sModMode.CompareText("unmod");
			}
		}else{
			bPreModeration	= (m_InputContext.GetParamInt("premoderation")!= 0);
			bUnmoderated	= (m_InputContext.GetParamInt("unmoderated")	!= 0);
		}

		bNoAutoSwitch = (m_InputContext.GetParamInt("crosslink") != 0);
		bCustomTerms = (m_InputContext.GetParamInt("customterms") != 0);
		bPassworded = (m_InputContext.GetParamInt("passworded") != 0);
		bArticleGuestBookForums = (m_InputContext.GetParamInt("articleguestbookforums") != 0);
		bUseFrames = (m_InputContext.GetParamInt("useframes") != 0);
		iAutoMessageUserID = m_InputContext.GetParamInt("AutoMessageUserID");
		iEventAlertMessageUserID = m_InputContext.GetParamInt("EventAlertMessageUserID");
		// CTDVString sLeafName = m_InputContext.GetParamString("leafname",sLeafName);
		CTDVString sErrors;
		
		if (bDoUpdate && SP.CreateNewSite(sURLName, sShortName, sSSOService, sDescription, sDefaultSkin, 
			sSkinDescription, sSkinSet, bUseFrames, bPreModeration, bNoAutoSwitch, 
			bCustomTerms, sModeratorsEmail, sEditorsEmail, sFeedbackEmail,iAutoMessageUserID, 
			bPassworded, bUnmoderated, bArticleGuestBookForums, iThreadOrder, iThreadEditTimeLimit,
			sEventEmailSubject, iEventAlertMessageUserID, iIncludeCrumbtrail, iAllowPostCodesInSearch))
		{
			sResult = "<CREATERESULT RESULT='SUCCESS' URLNAME='";
			sResult << sURLName << "'/>";
			m_InputContext.SiteDataUpdated();
			m_InputContext.Signal("/Signal?action=recache-site");
		}
		else
		{
			sResult = "<CREATERESULT RESULT='FAILED'/>";
		}
		m_InputContext.SiteDataUpdated();
		m_InputContext.Signal("/Signal?action=recache-site");
		
	}
	else if (m_InputContext.ParamExists("renameskin"))
	{
		CTDVString sSkinName;
		CTDVString sSkinDescription;
		m_InputContext.GetParamString("skinname",sSkinName);
		m_InputContext.GetParamString("skindescription",sSkinDescription);
		bUseFrames = (m_InputContext.GetParamInt("useframes") != 0);
		SP.UpdateSkinDescription(iSiteID, sSkinName, sSkinDescription, bUseFrames);
		sResult = "<UPDATESKINRESULT RESULT='0'>Skin description successfully updated</UPDATESKINRESULT>";
		m_InputContext.SiteDataUpdated();
		m_InputContext.Signal("/Signal?action=recache-site");
	}
	else if (m_InputContext.ParamExists("uploadskin"))
	{
        // Feature no longer supported - Handled by Skin Manager
		sResult = "<UPLOADRESULT>";
        sResult << "<NOTALLOWED/>";
		/*CTDVString sType;
		int iLength;
		int iStatus;
		pViewer->GetStatus(&iStatus);
		m_InputContext.GetParamString("file_type", sType);
		iLength = m_InputContext.GetParamInt("file_size");
		CXMLObject::EscapeXMLText(&sType);
		CTDVString skinname;
		m_InputContext.GetParamString("skinname",skinname);
		CTDVString sLeafName;
		m_InputContext.GetParamString("leafname",sLeafName);
		CTDVString sDescription;
		m_InputContext.GetParamString("description",sDescription);
		bUseFrames = (m_InputContext.GetParamInt("useframes") != 0);
		bool bCreateNew = false;
		if ((m_InputContext.GetParamInt("create") == 1) && (iStatus > 1))
		{
			bCreateNew = true;
		}
		if (iStatus == 1 && skinname.GetLength() == 0)
		{
			sResult << "<NOTALLOWED/>";
		}
		//else if (!bCreateNew && skinname.GetLength() > 0 && !m_InputContext.DoesSkinExistInSite(m_InputContext.GetSiteID(), skinname))
		//{
		//	sResult << "<NOSUCHSKIN/>";
		//}
		else
		{
			CTDVString sErrors;
			if (m_InputContext.SaveUploadedSkin(skinname, sLeafName, "file", bCreateNew, &sErrors))
			{
				if (bCreateNew)
				{
					SP.AddSkinToSite(m_InputContext.GetSiteID(), skinname, sDescription, bUseFrames);
				}
				sResult << "<SAVED/>";
				m_InputContext.SiteDataUpdated();
				
				m_InputContext.Signal("/Signal?action=recache-site");
			}
			else
			{
				sResult << sErrors;
			}
		}*/
		sResult << "</UPLOADRESULT>";
	}
	
	SP.FetchSiteData(m_InputContext.GetSiteID());
	CTDVString sXML;

	sXML = "<SITEADMIN>";
	sXML << sResult;
	SP.GetField("URLName", sURLName);
	SP.GetField("SSOService", sSSOService);
	SP.GetField("ShortName", sShortName);
	SP.GetField("Description", sDescription);
	SP.GetField("DefaultSkin", sDefaultSkin);
    SP.GetField("SkinSet", sSkinSet);
	SP.GetField("ModeratorsEmail", sModeratorsEmail);
	SP.GetField("EditorsEmail", sEditorsEmail);
	SP.GetField("FeedbackEmail", sFeedbackEmail);
	SP.GetField("EventEmailSubject", sEventEmailSubject);
	bPreModeration = SP.GetBoolField("PreModeration");
	bUnmoderated = SP.GetBoolField("Unmoderated");
	bNoAutoSwitch = SP.GetBoolField("NoAutoSwitch");
	bCustomTerms = SP.IsNULL("AgreedTerms");
	iAutoMessageUserID = SP.GetIntField("AutoMessageUserID");
	iEventAlertMessageUserID = SP.GetIntField("EventAlertMessageUserID");
	bPassworded = SP.GetBoolField("Passworded");

	bArticleGuestBookForums = (SP.GetIntField("articleforumstyle") == 1);
	CXMLObject::EscapeAllXML(&sShortName);
	CXMLObject::EscapeAllXML(&sDescription);
	CXMLObject::EscapeAllXML(&sDefaultSkin);
    CXMLObject::EscapeAllXML(&sSkinSet);
	CXMLObject::EscapeAllXML(&sModeratorsEmail);
	CXMLObject::EscapeAllXML(&sEditorsEmail);
	CXMLObject::EscapeAllXML(&sFeedbackEmail);
	CXMLObject::EscapeXMLText(&sURLName);
	CXMLObject::EscapeXMLText(&sSSOService);

	sXML << "<URLNAME>" << sURLName << "</URLNAME>";
	sXML << "<SHORTNAME>" << sShortName << "</SHORTNAME>";
	sXML << "<SSOSERVICE>" << sSSOService << "</SSOSERVICE>";
	sXML << "<DESCRIPTION>" << sDescription << "</DESCRIPTION>";
	sXML << "<DEFAULTSKIN>" << sDefaultSkin << "</DEFAULTSKIN>";
    sXML << "<SKINSET>" << sSkinSet << "</SKINSET>";
	sXML << "<MODERATORSEMAIL>" << sModeratorsEmail << "</MODERATORSEMAIL>";
	sXML << "<EDITORSEMAIL>" << sEditorsEmail << "</EDITORSEMAIL>";
	sXML << "<FEEDBACKEMAIL>" << sFeedbackEmail << "</FEEDBACKEMAIL>";
	sXML << "<AUTOMESSAGEUSERID>" << iAutoMessageUserID << "</AUTOMESSAGEUSERID>";
	sXML << "<EVENTALERTMESSAGEUSERID>" << iEventAlertMessageUserID << "</EVENTALERTMESSAGEUSERID>";
	sXML << "<EVENTEMAILSUBJECT>" << sEventEmailSubject << "</EVENTEMAILSUBJECT>";

	if (bPreModeration)
	{
		sXML << "<PREMODERATION>1</PREMODERATION>";
	}
	else
	{
		sXML << "<PREMODERATION>0</PREMODERATION>";
	}

	if (bUnmoderated)
	{
		sXML << "<UNMODERATED>1</UNMODERATED>";
	}
	else
	{
		sXML << "<UNMODERATED>0</UNMODERATED>";
	}

	if (bPassworded)
	{
		sXML << "<PASSWORDED>1</PASSWORDED>";
	}
	else
	{
		sXML << "<PASSWORDED>0</PASSWORDED>";
	}



	if (bArticleGuestBookForums)
	{
		sXML << "<ARTICLEFORUMSTYLE>1</ARTICLEFORUMSTYLE>";
	}
	else
	{
		sXML << "<ARTICLEFORUMSTYLE>0</ARTICLEFORUMSTYLE>";
	}

	if (bNoAutoSwitch)
	{
		sXML << "<NOCROSSLINKING>1</NOCROSSLINKING>";
	}
	else
	{
		sXML << "<NOCROSSLINKING>0</NOCROSSLINKING>";
	}

	if (bCustomTerms)
	{
		sXML << "<CUSTOMTERMS>1</CUSTOMTERMS>";
	}
	else
	{
		sXML << "<CUSTOMTERMS>0</CUSTOMTERMS>";
	}

	// Do all the default permission stuff here.

	sXML << "<PERMISSIONS>";

	sXML << "<OPENCLUB>";

	sXML << "<USER ";
	sXML << "CANAUTOJOINMEMBER='" << SP.GetIntField("ClubCanAutoJoinMember") << "' ";
	sXML << "CANAUTOJOINOWNER='" << SP.GetIntField("ClubCanAutoJoinOwner") << "' ";
	sXML << "CANBECOMEMEMBER='" << SP.GetIntField("ClubCanBecomeMember") << "' ";
	sXML << "CANBECOMEOWNER='" << SP.GetIntField("ClubCanBecomeOwner") << "' ";
	sXML << "CANAPPROVEMEMBERS='" << SP.GetIntField("ClubCanApproveMembers") << "' ";
	sXML << "CANAPPROVEOWNERS='" << SP.GetIntField("ClubCanApproveOwners") << "' ";
	sXML << "CANDEMOTEOWNERS='" << SP.GetIntField("ClubCanDemoteOwners") << "' ";
	sXML << "CANDEMOTEMEMBERS='" << SP.GetIntField("ClubCanDemoteMembers") << "' ";	
	sXML << "CANVIEWACTIONS='" << SP.GetIntField("ClubCanViewActions") << "' ";
	sXML << "CANVIEW='" << SP.GetIntField("ClubCanView") << "' ";
	sXML << "CANPOSTJOURNAL='" << SP.GetIntField("ClubCanPostJournal") << "' ";
	sXML << "CANPOSTCALENDAR='" << SP.GetIntField("ClubCanPostCalendar") << "' ";	
	sXML << "CANEDIT='" << SP.GetIntField("ClubCanEdit") << "' ";

	sXML << "/>";

	sXML << "<MEMBER ";
	sXML << "CANAUTOJOINMEMBER='" << SP.GetIntField("ClubMemberCanAutoJoinMember") << "' ";
	sXML << "CANAUTOJOINOWNER='" << SP.GetIntField("ClubMemberCanAutoJoinOwner") << "' ";
	sXML << "CANBECOMEMEMBER='" << SP.GetIntField("ClubMemberCanBecomeMember") << "' ";
	sXML << "CANBECOMEOWNER='" << SP.GetIntField("ClubMemberCanBecomeOwner") << "' ";
	sXML << "CANAPPROVEMEMBERS='" << SP.GetIntField("ClubMemberCanApproveMembers") << "' ";
	sXML << "CANAPPROVEOWNERS='" << SP.GetIntField("ClubMemberCanApproveOwners") << "' ";
	sXML << "CANDEMOTEOWNERS='" << SP.GetIntField("ClubMemberCanDemoteOwners") << "' ";
	sXML << "CANDEMOTEMEMBERS='" << SP.GetIntField("ClubMemberCanDemoteMembers") << "' ";
	sXML << "CANVIEWACTIONS='" << SP.GetIntField("ClubMemberCanViewActions") << "' ";
	sXML << "CANVIEW='" << SP.GetIntField("ClubMemberCanView") << "' ";
	sXML << "CANPOSTJOURNAL='" << SP.GetIntField("ClubMemberCanPostJournal") << "' ";
	sXML << "CANPOSTCALENDAR='" << SP.GetIntField("ClubMemberCanPostCalendar") << "' ";
	sXML << "CANEDIT='" << SP.GetIntField("ClubMemberCanEdit") << "' ";
	sXML << "/>";
	
	sXML << "<OWNER ";
	sXML << "CANAUTOJOINMEMBER='" << SP.GetIntField("ClubOwnerCanAutoJoinMember") << "' ";
	sXML << "CANAUTOJOINOWNER='" << SP.GetIntField("ClubOwnerCanAutoJoinOwner") << "' ";
	sXML << "CANBECOMEMEMBER='" << SP.GetIntField("ClubOwnerCanBecomeMember") << "' ";
	sXML << "CANBECOMEOWNER='" << SP.GetIntField("ClubOwnerCanBecomeOwner") << "' ";
	sXML << "CANAPPROVEMEMBERS='" << SP.GetIntField("ClubOwnerCanApproveMembers") << "' ";
	sXML << "CANAPPROVEOWNERS='" << SP.GetIntField("ClubOwnerCanApproveOwners") << "' ";
	sXML << "CANDEMOTEOWNERS='" << SP.GetIntField("ClubOwnerCanDemoteOwners") << "' ";
	sXML << "CANDEMOTEMEMBERS='" << SP.GetIntField("ClubOwnerCanDemoteMembers") << "' ";
	sXML << "CANVIEWACTIONS='" << SP.GetIntField("ClubOwnerCanViewActions") << "' ";
	sXML << "CANVIEW='" << SP.GetIntField("ClubOwnerCanView") << "' ";
	sXML << "CANPOSTJOURNAL='" << SP.GetIntField("ClubOwnerCanPostJournal") << "' ";
	sXML << "CANPOSTCALENDAR='" << SP.GetIntField("ClubOwnerCanPostCalendar") << "' ";
	sXML << "CANEDIT='" << SP.GetIntField("ClubOwnerCanEdit") << "' ";
	sXML << "/>";

	sXML << "</OPENCLUB>";

	sXML << "<CLOSEDCLUB>";

	sXML << "<USER ";
	sXML << "CANAUTOJOINMEMBER='" << SP.GetIntField("ClosedClubCanAutoJoinMember") << "' ";
	sXML << "CANAUTOJOINOWNER='" << SP.GetIntField("ClosedClubCanAutoJoinOwner") << "' ";
	sXML << "CANBECOMEMEMBER='" << SP.GetIntField("ClosedClubCanBecomeMember") << "' ";
	sXML << "CANBECOMEOWNER='" << SP.GetIntField("ClosedClubCanBecomeOwner") << "' ";
	sXML << "CANAPPROVEMEMBERS='" << SP.GetIntField("ClosedClubCanApproveMembers") << "' ";
	sXML << "CANAPPROVEOWNERS='" << SP.GetIntField("ClosedClubCanApproveOwners") << "' ";
	sXML << "CANDEMOTEOWNERS='" << SP.GetIntField("ClosedClubCanDemoteOwners") << "' ";
	sXML << "CANDEMOTEMEMBERS='" << SP.GetIntField("ClosedClubCanDemoteMembers") << "' ";
	sXML << "CANVIEWACTIONS='" << SP.GetIntField("ClosedClubCanViewActions") << "' ";
	sXML << "CANVIEW='" << SP.GetIntField("ClosedClubCanView") << "' ";
	sXML << "CANPOSTJOURNAL='" << SP.GetIntField("ClosedClubCanPostJournal") << "' ";
	sXML << "CANPOSTCALENDAR='" << SP.GetIntField("ClosedClubCanPostCalendar") << "' ";
	sXML << "CANEDIT='" << SP.GetIntField("ClosedClubCanEdit") << "' ";
	sXML << "/>";

	sXML << "<MEMBER ";
	sXML << "CANAUTOJOINMEMBER='" << SP.GetIntField("ClosedClubMemberCanAutoJoinMember") << "' ";
	sXML << "CANAUTOJOINOWNER='" << SP.GetIntField("ClosedClubMemberCanAutoJoinOwner") << "' ";
	sXML << "CANBECOMEMEMBER='" << SP.GetIntField("ClosedClubMemberCanBecomeMember") << "' ";
	sXML << "CANBECOMEOWNER='" << SP.GetIntField("ClosedClubMemberCanBecomeOwner") << "' ";
	sXML << "CANAPPROVEMEMBERS='" << SP.GetIntField("ClosedClubMemberCanApproveMembers") << "' ";
	sXML << "CANAPPROVEOWNERS='" << SP.GetIntField("ClosedClubMemberCanApproveOwners") << "' ";
	sXML << "CANDEMOTEOWNERS='" << SP.GetIntField("ClosedClubMemberCanDemoteOwners") << "' ";
	sXML << "CANDEMOTEMEMBERS='" << SP.GetIntField("ClosedClubMemberCanDemoteMembers") << "' ";
	sXML << "CANVIEWACTIONS='" << SP.GetIntField("ClosedClubMemberCanViewActions") << "' ";
	sXML << "CANVIEW='" << SP.GetIntField("ClosedClubMemberCanView") << "' ";
	sXML << "CANPOSTJOURNAL='" << SP.GetIntField("ClosedClubMemberCanPostJournal") << "' ";
	sXML << "CANPOSTCALENDAR='" << SP.GetIntField("ClosedClubMemberCanPostCalendar") << "' ";
	sXML << "CANEDIT='" << SP.GetIntField("ClosedClubMemberCanEdit") << "' ";
	sXML << "/>";
	
	sXML << "<OWNER ";
	sXML << "CANAUTOJOINMEMBER='" << SP.GetIntField("ClosedClubOwnerCanAutoJoinMember") << "' ";
	sXML << "CANAUTOJOINOWNER='" << SP.GetIntField("ClosedClubOwnerCanAutoJoinOwner") << "' ";
	sXML << "CANBECOMEMEMBER='" << SP.GetIntField("ClosedClubOwnerCanBecomeMember") << "' ";
	sXML << "CANBECOMEOWNER='" << SP.GetIntField("ClosedClubOwnerCanBecomeOwner") << "' ";
	sXML << "CANAPPROVEMEMBERS='" << SP.GetIntField("ClosedClubOwnerCanApproveMembers") << "' ";
	sXML << "CANAPPROVEOWNERS='" << SP.GetIntField("ClosedClubOwnerCanApproveOwners") << "' ";
	sXML << "CANDEMOTEOWNERS='" << SP.GetIntField("ClosedClubOwnerCanDemoteOwners") << "' ";
	sXML << "CANDEMOTEMEMBERS='" << SP.GetIntField("ClosedClubOwnerCanDemoteMembers") << "' ";
	sXML << "CANVIEWACTIONS='" << SP.GetIntField("ClosedClubOwnerCanViewActions") << "' ";
	sXML << "CANVIEW='" << SP.GetIntField("ClosedClubOwnerCanView") << "' ";
	sXML << "CANPOSTJOURNAL='" << SP.GetIntField("ClosedClubOwnerCanPostJournal") << "' ";
	sXML << "CANPOSTCALENDAR='" << SP.GetIntField("ClosedClubOwnerCanPostCalendar") << "' ";
	sXML << "CANEDIT='" << SP.GetIntField("ClosedClubOwnerCanEdit") << "' ";
	sXML << "/>";

	sXML << "</CLOSEDCLUB>";

	sXML << "</PERMISSIONS>";

	iThreadOrder = SP.GetIntField("ThreadOrder");
	CForum::GetThreadOrderDesc(iThreadOrder, sThreadOrder);
	sXML << "<THREADORDER>" << sThreadOrder << "</THREADORDER>";

	iAllowRemoveVote = SP.GetIntField("AllowRemoveVote");
	sXML << "<ALLOWREMOVEVOTE>" << iAllowRemoveVote << "</ALLOWREMOVEVOTE>";

	iIncludeCrumbtrail = SP.GetIntField("IncludeCrumbtrail");
	sXML << "<INCLUDECRUMBTRAIL>" << iIncludeCrumbtrail << "</INCLUDECRUMBTRAIL>";

	iAllowPostCodesInSearch = SP.GetIntField("AllowPostCodesInSearch");
	sXML << "<ALLOWPOSTCODESINSEARCH>" << iAllowPostCodesInSearch << "</ALLOWPOSTCODESINSEARCH>";

	bQueuePostings = SP.GetBoolField("QueuePostings");
	if (bQueuePostings)
	{
		sXML << "<QUEUEPOSTINGS>1</QUEUEPOSTINGS>";
	}
	else
	{
		sXML << "<QUEUEPOSTINGS>0</QUEUEPOSTINGS>";
	}

	iTopicsClosed = SP.GetBoolField("QueuePostings");
	if (iTopicsClosed == 1)
	{
		sXML << "<TOPICSCLOSED>1</TOPICSCLOSED>";
	}
	else
	{
		sXML << "<TOPICSCLOSED>0</TOPICSCLOSED>";
	}

	iThreadEditTimeLimit = SP.GetIntField("ThreadEditTimeLimit");
	sXML << "<THREADEDITTIMELIMIT>" << iThreadEditTimeLimit << "</THREADEDITTIMELIMIT>";

	sXML << "<SKINS>";

	while (!SP.IsEOF())
	{
		bool bUseFrames;
		CTDVString sSkinName;
		CTDVString sSkinDescription;
		SP.GetField("SkinName", sSkinName);
		SP.GetField("SkinDescription", sSkinDescription);
		bUseFrames = SP.GetBoolField("UseFrames");
		CXMLObject::EscapeXMLText(&sSkinName);
		CXMLObject::EscapeXMLText(&sSkinDescription);
		sXML << "<SKIN><NAME>" << sSkinName << "</NAME>";
		sXML << "<DESCRIPTION>" << sSkinDescription << "</DESCRIPTION>";
		sXML << "<USEFRAMES>";
		if (bUseFrames)
		{
			sXML << 1;
		}
		else
		{
			sXML << 0;
		}
		sXML << "</USEFRAMES>";
		sXML << "</SKIN>";
		SP.MoveNext();
	}
	sXML << "</SKINS></SITEADMIN>";

	pPageXML->AddInside("H2G2", sXML);

	CTDVString sSiteXML;
	if (m_InputContext.GetSiteListAsXML(&sSiteXML))
	{
		pPageXML->AddInside("H2G2", sSiteXML);
	}

	return true;
}


/*********************************************************************************

	bool CSiteAdminPageBuilder::GetAndCheckThreadEditTimeLimit(int& iThreadEditTimeLimit)
																			 ,
	Author:		David van Zijl
	Created:	19/10/2004
	Inputs:		-
	Outputs:	iThreadEditTimeLimit - value taken from form
	Returns:	true if value ok to use, false otherwise
	Purpose:	Gets the value of ThreadEditTimeLimit from input params and checks it 
				matches pre-set limits. If it is too high then an error is set using 
				SetDNALastError()

*********************************************************************************/

bool CSiteAdminBuilder::GetAndCheckThreadEditTimeLimit(int& iThreadEditTimeLimit)
{
	iThreadEditTimeLimit = m_InputContext.GetParamInt("ThreadEditTimeLimit");

	// Impose some reasonable restrictions on iThreadEditTimeLimit
	if (iThreadEditTimeLimit < 0)
	{
		iThreadEditTimeLimit = 0;
	}
	else if (iThreadEditTimeLimit > UPPERLIMIT_THREADEDITTIMELIMIT)
	{
		CTDVString sErrorMsg;
		sErrorMsg << "Sorry but your time limit for editing threads exceeds the maximum of " 
			<< UPPERLIMIT_THREADEDITTIMELIMIT << ". Please alter the value and re-submit";
		SetDNALastError("SiteAdminPageBuilder", "INPUTPARAMS", sErrorMsg);
		return false;
	}

	return true;
}
