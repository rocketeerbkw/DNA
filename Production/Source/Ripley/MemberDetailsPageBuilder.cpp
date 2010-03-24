#include "stdafx.h"
#include ".\memberdetailspagebuilder.h"
#include ".\user.h"
#include ".\usertags.h"
#include ".\modreasons.h"
#include ".\userstatuses.h"
#include ".\moderationclasses.h"
#include ".\basicsitelist.h"


CMemberDetailsPageBuilder::CMemberDetailsPageBuilder(CInputContext& inputContext):
	CXMLBuilder(inputContext)
{
}

CMemberDetailsPageBuilder::~CMemberDetailsPageBuilder(void)
{
}


/*********************************************************************************

	bool CMemberDetailsPageBuilder::Build(CWholePage* pPage)

		Author:		David Williams
		Created:	17/08/2005
		Inputs:		-
		Outputs:	-
		Returns:	-
		Purpose:	-
		
		*********************************************************************************/
/*virtual*/
bool CMemberDetailsPageBuilder::Build(CWholePage* pPage)
{
	CUser* pViewingUser = m_InputContext.GetCurrentUser();

	InitPage(pPage, "USER-DETAILS-PAGE", true);

	if (!pViewingUser)
	{
		SetDNALastError("CMemberDetailsPageBuilder", "NotLoggedIn", "User is not logged in");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}

	if (!(pViewingUser->GetIsSuperuser() || pViewingUser->GetIsEditorOnAnySite()))
	{
		SetDNALastError("CMemberDetailsPageBuilder", "NotValidUser", "User has insufficient priveleges");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}
	
	int iUserID = 0;
	iUserID = m_InputContext.GetParamInt("UserID");

	int iSiteID = 0;
	iSiteID = m_InputContext.GetParamInt("SiteID");

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);
	
	if (m_InputContext.ParamExists("update"))
	{
		int iPrefStatus = m_InputContext.GetParamInt("status");
		int iPrefDuration = m_InputContext.GetParamInt("duration");
		bool bApplyToAltIDs = m_InputContext.GetParamInt("applytoaltids") != 0;
		CTDVString sAllProfiles;
		m_InputContext.GetParamString("allprofiles", sAllProfiles);
		bool bAllProfiles = sAllProfiles.CompareText("on");
			
		CTDVString sUserTags;
		//m_InputContext.GetParamString("usertags", sUserTags);

		int iTagsCount = m_InputContext.GetParamCount("usertag");
		for (int i = 0; i < iTagsCount; ++i)
		{
			CTDVString sTag(m_InputContext.GetParamInt("usertag", i));
			sUserTags += sTag;
			if (i < iTagsCount-1)
			{
				sUserTags += ',';
			}
		}
		
		////banned works differently to the other statuses
		////so we need to use the user object to update this
		//CUser user(m_InputContext);
		//user.CreateFromIDForSite(iUserID, iSiteID);

		//// if user if being banned update the membership of 
		//if (iPrefStatus == 4)
		//{
		//	user.SetIsGroupMember("RESTRICTED", true);
		//}
		//else
		//{
		//	user.SetIsGroupMember("RESTRICTED", false);
		//}
		//user.UpdateDetails();

		if ( SP.UpdateTrackedMemberProfile(iUserID, iSiteID, iPrefStatus, iPrefDuration, sUserTags, bApplyToAltIDs, bAllProfiles) )
			pPage->AddInside("H2G2","<FEEDBACK PROCESSED='1'/>");
		else
		{
			pPage->AddInside("H2G2","<FEEDBACK PROCESSED='0'/>");
			SetDNALastError("CMemberDetailsPageBuilder", "MemberNotUpdated", "Member not updated.");
			pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		}
	}
	
	SP.GetTrackedMemberDetails(iSiteID, iUserID);
	CTDVString sMemberDetails;
	CDBXMLBuilder xml;
	xml.Initialise(&sMemberDetails, &SP);

	xml.OpenTag("USERS-DETAILS", true);

	xml.AddIntAttribute("SITEID", iSiteID, false);
	xml.AddIntAttribute("ID", iUserID, true);
	
	bool bHaveID = false;
	bool bClosedMainID = false;
	xml.OpenTag("MAIN-IDENTITY");
	int iPrevUserID = iUserID;
	if (!SP.IsEOF())
	{
		bHaveID = true;
		xml.DBAddTag("USERNAME", "USERNAME", false);
		xml.DBAddTag("EMAIL", "EMAIL", false);
		xml.DBAddTag("FIRSTNAMES", "FIRSTNAMES", false);
		xml.DBAddTag("LASTNAME", "LASTNAMES", false);
		xml.OpenTag("STATUS", true);
		xml.DBAddIntAttribute("PREFSTATUS", "STATUS", false);
		xml.DBAddIntAttribute("PREFSTATUSDURATION", "DURATION", false, true);
		xml.DBAddDateTag("PREFSTATUSCHANGEDDATE", "STATUSCHANGEDDATE", false);
		xml.CloseTag("STATUS");
		xml.DBAddTag("USERTAGID", "USER-TAG");

		while (SP.MoveNext())
		{
			//SP.MoveNext();
			iUserID = SP.GetIntField("UserID");
			xml.DBAddTag("USERTAGID", "USER-TAG");
		}

		xml.CloseTag("MAIN-IDENTITY");
		bClosedMainID = true;
		xml.OpenTag("ALT-IDENTITIES");
		
		int iUserIDLocal = 0;
		int iPrevUserIDLocal = 0;
		while (!SP.IsEOF())
		{
			iUserIDLocal = SP.GetIntField("UserID");
			//if (iUserIDLocal == iPrevUserIDLocal)
			//{
			//	SP.MoveNext();
			//	continue;
			//}
			xml.OpenTag("IDENTITY", true);
			xml.DBAddIntAttribute("UserID", "USERID", false, false);
			xml.DBAddIntAttribute("SiteID", "SITEID", false, false);
            CTDVString sUserName;
			SP.GetField("UserName", sUserName);
			xml.DBAddAttribute("UserName", "USERNAME", false, true, true);
			xml.CloseTag("IDENTITY");
			iPrevUserIDLocal = iUserIDLocal;
			SP.MoveNext();
		}
		xml.CloseTag("ALT-IDENTITIES");
	}
	if (bHaveID == true)
	{
		if (!bClosedMainID)
		{
			xml.CloseTag("MAIN-IDENTITY");
		}
	}
	else
	{
		SetDNALastError("CMemberDetailsPageBuilder", "NoMemberDetails", "No member details found");
		pPage->AddInside("H2G2", GetLastErrorAsXMLString());
		return true;
	}
	iUserID = m_InputContext.GetParamInt("UserID");
	
	SP.GetTrackedMemberSummary(iUserID, iSiteID);
	
	xml.OpenTag("USER-POST-HISTORY-SUMMARY");
	bool bOpenedReasonList = false;
	while (!SP.IsEOF())
	{
		int iReasonID = SP.GetIntField("ReasonID");
		if (iReasonID != -1)
		{
			if (!bOpenedReasonList)
			{
				bOpenedReasonList = true;
				xml.OpenTag("REASONS-LIST");
			}
			xml.OpenTag("REASON", true);
			xml.DBAddIntAttribute("REASONID", "REASONID", false, false);
			xml.DBAddIntAttribute("COUNT", "COUNT", false, true);
			xml.CloseTag("REASON");
		}
		else
		{
			xml.OpenTag("SUMMARY", true);
			int iPostsSubmitted = SP.GetIntField("POSTSSUBMITTED");
			xml.AddIntAttribute("POSTCOUNT", iPostsSubmitted, false);
			int iArticlesSubmitted = SP.GetIntField("ARTICLESSUBMITTED");
			xml.AddIntAttribute("ENTRYCOUNT", iArticlesSubmitted, true);
			CTDVDateTime dtFirstActivity = SP.GetDateField("FIRSTACTIVITY");
			xml.AddDateTag("FIRSTACTIVITY", dtFirstActivity, false);
			xml.CloseTag("SUMMARY");
		}
		SP.MoveNext();
	}
	if (bOpenedReasonList == true)
	{
		xml.CloseTag("REASONS-LIST");
	}
	xml.CloseTag("USER-POST-HISTORY-SUMMARY");
	xml.CloseTag("USERS-DETAILS");

	pPage->AddInside("H2G2", sMemberDetails);

	CUserTags userTags(m_InputContext);
	userTags.GetUserTags();
	pPage->AddInside("H2G2", &userTags);

	CUserStatuses userStatuses(m_InputContext);
	userStatuses.GetUserStatuses();
	pPage->AddInside("H2G2", &userStatuses);

	CModReasons modReasons(m_InputContext);
	modReasons.GetModReasons(0);
	pPage->AddInside("H2G2", &modReasons);
	
	CModerationClasses moderationClasses(m_InputContext);
	moderationClasses.GetModerationClasses();
	pPage->AddInside("H2G2", &moderationClasses);

	CBasicSiteList sitedetails(m_InputContext);
	if ( sitedetails.PopulateList() )
		pPage->AddInside("H2G2", sitedetails.GetAsXML2());
	else
		pPage->AddInside("H2G2",sitedetails.GetLastErrorAsXMLString());
	
	return true;
}