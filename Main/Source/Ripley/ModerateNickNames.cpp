#include "stdafx.h"
#include ".\moderatenicknames.h"
#include "user.h"

#include <set>

CModerateNickNames::CModerateNickNames( CInputContext& InputContext) : CXMLObject(InputContext)
{
}

CModerateNickNames::~CModerateNickNames(void)
{
}

/*********************************************************************************

	bool		CModerateNickNames::GetNickNames
	Author:		Martin Robb
	Created:	05/12/2005
	Inputs:		iUserId - viewing userid
				bAlerts - Include Complaints
				bHeldItems - Include Items that have held status
				bLockedItems - Fetch locked items - editors / superusers only.
				ModClass - Moderation Class - filter users on moderation class of their mastheads site.
				Show - Number of items to show.
	Outputs:	-
	Returns:	false on error.
	Purpose:	Fetches NickNames from the moderation queue and creates XML.

*********************************************************************************/
bool CModerateNickNames::GetNickNames( int iUserId, bool bAlerts, bool bHeldItems, bool bLockedItems, int iModClass, int iShow )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(SP);

	bool bSuperUser = m_InputContext.GetCurrentUser() && m_InputContext.GetCurrentUser()->GetIsSuperuser();

	if ( !SP.GetModerationNickNames(iUserId, bSuperUser, bAlerts, bHeldItems, bLockedItems, iModClass, iShow ) )
	{
		SetDNALastError("CModerateNicknames::GetNickNames","GetNicknames","Error fetching Nicknames");
		return false;
	}

	// now build the form XML
	CTDVString sXML;
	InitialiseXMLBuilder(&sXML,&SP);
	OpenXMLTag("MODERATENICKNAMES", true );

	if ( bAlerts )
		AddXMLIntAttribute("ALERTS",1, false);

	if ( bLockedItems )
		AddXMLIntAttribute("LOCKEDITEMS", 1, false);

	AddXMLIntAttribute("MODID", m_InputContext.GetParamInt("modclassid"), false);
	AddXMLIntAttribute("FASTMOD", m_InputContext.GetParamInt("fastmod"), false);
	AddXMLIntAttribute("COUNT",SP.IsEOF() ? 0 : SP.GetIntField("Count"),true);


	// create an appropriate message if there are no results
		//bSuccess = bSuccess && XML.OpenTag("MESSAGE",true);
		//bSuccess = bSuccess && XML.AddAttribute("TYPE","EMPTY-QUEUE",true);
		//bSuccess = bSuccess && XML.CloseTag("MESSAGE");

	// Get each nickname in turn if there are any
	int iSiteID = 0;
	while ( !SP.IsEOF() )
	{
		OpenXMLTag("NICKNAME");
		AddDBXMLIntTag("ModID","MODERATION-ID");
		AddDBXMLIntTag("STATUS","MODERATION-STATUS");
		AddDBXMLIntTag("SiteID");
		AddDBXMLDateTag("DateQueued","DATEQUEUED");
		OpenXMLTag("USER");
		AddDBXMLIntTag("UserId");
		AddDBXMLTag("UserName");
		AddDBXMLTag("FirstNames",NULL,false);
		AddDBXMLTag("LastName",NULL,false);

		//User Moderation Status
		if ( !SP.IsNULL("PrefStatus") )
		{
			OpenXMLTag("STATUS", true);
			AddDBXMLIntAttribute("PrefStatus", "StatusID", false, false);
			AddDBXMLIntAttribute("PrefStatusDuration", "Duration", false, true);
			AddDBXMLDateTag("PrefStatusChangedDate","StatusChangedDate", false);
			CloseXMLTag("STATUS");	
		}

		//Get Alert Information.
		CTDVString sComplaint;
		CTDVString sComplainant;
		CTDVString sComplainantFirstNames;
		CTDVString sComplainantLastName;
		CTDVDateTime dComplainantUserStatusDate;
		int iComplainantID = 0;
		int iComplainantUserStatus = 0;
		int iComplainantUserStatusDuration = 0;
		if ( bAlerts )
		{
			SP.GetField("ComplaintText", sComplaint );
			SP.GetField("ComplainantUserName",sComplainant);
			SP.GetField("ComplainantFirstNames", sComplainantFirstNames);
			SP.GetField("ComplainantLastName", sComplainantLastName);
			
			if ( !SP.IsNULL("ComplainantPrefStatusChangedDate") ) 
				SP.GetDateField("ComplainantPrefStatusChangedDate");
			iComplainantID = SP.GetIntField("ComplainantUserID");
			iComplainantUserStatus = SP.GetIntField("ComplainantPrefStatus");
			iComplainantUserStatusDuration = SP.GetIntField("ComplainantPrefStatusDuration");
		}

		//Get Additional multi-row info member teags / alternate ids etc. 
		std::set<CTDVString> membertags;
		std::map<int,CTDVString> alternateusers;
		int iModID = SP.GetIntField("ModID");
		while ( !SP.IsEOF() && (SP.GetIntField("ModID") == iModID) )
		{
			if ( !SP.IsNULL("UserMemberTag") ) 
			{
				CTDVString sTag;
				if ( SP.GetField("UserMemberTag",sTag) && membertags.find( sTag ) == membertags.end() )
					membertags.insert(sTag);
			}

			if ( !SP.IsNULL("altuserid") )
			{
				CTDVString altusername;
				SP.GetField("altusername",altusername);
				alternateusers[SP.GetIntField("altuserid")] = altusername;
			}
			SP.MoveNext();
		}

		//Get Moderation User Tags.
		OpenXMLTag("USERMEMBERTAGS");
		for ( std::set<CTDVString>::iterator iter = membertags.begin(); iter != membertags.end(); ++iter )
				AddXMLTag("USERMEMBERTAG",*iter);
		CloseXMLTag("USERMEMBERTAGS");
		CloseXMLTag("USER");
		
		if ( bAlerts )
		{
			OpenXMLTag("ALERT");
			AddXMLTag("TEXT",sComplaint);
			OpenXMLTag("USER");
			AddXMLIntTag("USERID", iComplainantID);
			AddXMLTag("FIRSTNAMES", sComplainantFirstNames);
			AddXMLTag("LASTNAMES", sComplainantLastName);
			AddXMLTag("USERNAME", sComplainant);

			//Complainant Moderation Status
			if ( !SP.IsNULL("ComplainantPrefStatus") )
			{
				OpenXMLTag("STATUS", true);
				AddXMLIntAttribute("STATUSID", iComplainantUserStatus, false);
				AddXMLIntAttribute("DURATION", iComplainantUserStatusDuration, true);
				AddXMLDateTag("STATUSCHANGEDDATE",dComplainantUserStatusDate, false);
				CloseXMLTag("STATUS");
			}

			//Add the member tags.
			//if ( !complainantmembertags.empty() ) 
			//{
			//	OpenXMLTag("USERMEMBERTAGS");
			//	for ( std::vector<CTDVString>::iterator iter = complainantmembertags.begin(); iter != complainantmembertags.end(); ++iter )
			//		AddXMLTag("USERMEMBERTAG",*iter);
			//	CloseXMLTag("USERMEMBERTAGS");
			//}
			CloseXMLTag("USER");
			CloseXMLTag("ALERT");
		}

		if ( alternateusers.size() > 0 )
		{
			OpenXMLTag("ALTERNATEUSERS");
			for ( std::map<int,CTDVString>::iterator iter = alternateusers.begin(); iter != alternateusers.end(); ++iter )
			{
				OpenXMLTag("USER");
				AddXMLIntTag("USERID",iter->first);
				AddXMLTag("USERNAME",iter->second);
				CloseXMLTag("USER");
			}
			CloseXMLTag("ALTERNATEUSERS");
		}
		
		CloseXMLTag("NICKNAME");
	}

	CloseXMLTag("MODERATENICKNAMES");

	return CreateFromXMLText(sXML);
}

/*********************************************************************************

	bool		CModerateNickNames::Update
	Author:		Martin Robb
	Created:	05/12/2005
	Inputs:		iModId - Id of moderation item
				iStatus - new status
	Outputs:	sUsersEmail - email for notification.
	Returns:	false on error.
	Purpose:	Updates status of moderation item

*********************************************************************************/
bool CModerateNickNames::Update( int iModID, int iStatus, CTDVString& sUsersEmail )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if ( !SP.UpdateNicknameModeration(iModID, iStatus) )
	{
		CTDVString sErr = "failed to update Nickname ";
		sErr << iModID;
		SetDNALastError("CModerateNickames::Update","Update",sErr);
		return false;
	}
	SP.GetField("EmailAddress",sUsersEmail);
	return true;
}

/*********************************************************************************

	bool		CModerateNickNames::UnlockNickNamesForUser
	Author:		Martin Robb
	Created:	05/12/2005
	Inputs:		iUserId - viewing userid
	Outputs:	-
	Returns:	false on error.
	Purpose:	Unlocks nicknames for the specified user.

*********************************************************************************/
bool CModerateNickNames::UnlockNickNamesForUser( int iUserID, int iModClassID )
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	return SP.UnlockAllNicknameModerations(iUserID, iModClassID);
}