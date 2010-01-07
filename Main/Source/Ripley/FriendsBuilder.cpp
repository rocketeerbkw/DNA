// FriendsBuilder.cpp: implementation of the CFriendsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "GuideEntry.h"
#include "FriendsBuilder.h"
#include "WatchList.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFriendsBuilder::CFriendsBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{

}

CFriendsBuilder::~CFriendsBuilder()
{

}

bool CFriendsBuilder::Build(CWholePage* pPageXML)
{
	if (!InitPage(pPageXML, "WATCHED-USERS",true))
	{
		return false;
	}

	int iUserID = m_InputContext.GetParamInt("UserID");
	
	
	CWatchList WatchList(m_InputContext);
	
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	CTDVString command = "";
	if (m_InputContext.ParamExists("delete"))
	{
		command = "delete";
	}
	else if (m_InputContext.ParamExists("add"))
	{
		command = "add";
	}
	if (command.GetLength() > 0)
	{
		// Got a command, so do something...
		// Limit access:
		//   If "add", only allow if viewer is user
		//   If "delete", allow if viewer is user or editor/superuser

		bool bHasPermission = false;
		if (pViewingUser && pViewingUser->GetUserID() == iUserID)
		{
			bHasPermission = true;
		}
		else if (
			pViewingUser 
			&& command.CompareText("delete")
			&& (pViewingUser->GetIsEditor() || pViewingUser->GetIsSuperuser())
			)
		{
			bHasPermission = true;
		}

		if (!bHasPermission)
		{
			CTDVString sXML = "<WATCH-USER-RESULT TYPE='error' REASON='wronguser'>You can't perform that operation because you are not the specified user</RESULT>";
		}
		else
		{
			if (command.CompareText("add"))
			{
				WatchList.WatchUser(pViewingUser->GetUserID(), m_InputContext.GetParamInt("adduser"), m_InputContext.GetSiteID());
				pPageXML->AddInside("H2G2", &WatchList);
			}
			else if (command.CompareText("delete"))
			{
				// TODO: Delete user(s) from the list
				int iUserCount = m_InputContext.GetParamCount("duser");
				if (iUserCount > 0)
				{
					WatchList.StartDeleteUsers(iUserID);
					for(int iIndex = 0; iIndex < iUserCount; iIndex++)
					{
						int iDelUser = m_InputContext.GetParamInt("duser", iIndex);
						WatchList.AddDeleteUser(iDelUser);
					}
					WatchList.DoDeleteUsers();
					pPageXML->AddInside("H2G2", &WatchList);
				}
			}
		}
	}
	
	bool bSuccess = true;
	if (m_InputContext.ParamExists("full"))
	{
		int iSkip = m_InputContext.GetParamInt("skip");
		int iShow = m_InputContext.GetParamInt("show");
		if (iSkip < 0)
		{
			iSkip = 0;
		}
		if (iShow <= 0)
		{
			iShow = 20;
		}
		else if (iShow > 100)
		{
			iShow = 100;
		}
		bSuccess = bSuccess && WatchList.FetchJournalEntries(iUserID, iSkip, iShow);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &WatchList);
	}
	else
	{
		WatchList.Initialise(iUserID);
		pPageXML->AddInside("H2G2", &WatchList);
		int iSiteID = m_InputContext.GetSiteID();
		WatchList.WatchingUsers(iUserID, iSiteID);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &WatchList);
	}

	CTDVString sSiteXML;
	m_InputContext.GetSiteListAsXML(&sSiteXML);
	bSuccess = bSuccess && pPageXML->AddInside("H2G2", sSiteXML);
	if (bSuccess)
	{
		CUser PageOwner(m_InputContext);
		bSuccess = PageOwner.CreateFromID(iUserID);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", "<PAGE-OWNER></PAGE-OWNER>");
		bSuccess = bSuccess && pPageXML->AddInside("PAGE-OWNER", &PageOwner);

		int iMasthead = PageOwner.GetMasthead();
		CGuideEntry Masthead(m_InputContext);
		Masthead.Initialise(iMasthead,m_InputContext.GetSiteID(), pViewingUser, true,true,true,true);
		bSuccess = bSuccess && pPageXML->AddInside("H2G2", &Masthead);
	}

	return true;
}
