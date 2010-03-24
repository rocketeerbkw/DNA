// WatchList.cpp: implementation of the CWatchList class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "WatchList.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CWatchList::CWatchList(CInputContext& inputContext) : CXMLObject(inputContext)
{
	m_pDelSP = NULL;
	m_iDelUserCount = 0;
}

CWatchList::~CWatchList()
{
	if (m_pDelSP != NULL)
	{
		delete m_pDelSP;
		m_pDelSP = NULL;
	}
}

bool CWatchList::BuildUserXML( CTDVString& sXML , int bUsageType /* = 0 */ )
{
	bool bOk = true;
	int iThisUserID = 0;
	bOk = bOk && OpenXMLTag("USER");		
	bOk = bOk && AddDBXMLIntTag("USERID", 0, true, &iThisUserID);
	bOk = bOk && AddDBXMLTag("USERNAME");
	bOk = bOk && AddDBXMLTag("FIRSTNAMES",NULL,false);
	bOk = bOk && AddDBXMLTag("LASTNAME",NULL,false);
	bOk = bOk && AddDBXMLTag("AREA",NULL,false);
	bOk = bOk && AddDBXMLIntTag("STATUS", NULL, false);
	bOk = bOk && AddDBXMLIntTag("TAXONOMYNODE", NULL, false);
	bOk = bOk && AddDBXMLIntTag("ACTIVE");
	bOk = bOk && AddDBXMLTag("SITESUFFIX",NULL,false);	
	bOk = bOk && AddDBXMLTag("TITLE",NULL,false);				

	//get the groups to which this user belongs to 		
	CTDVString sGroupXML;		
	bOk = bOk && m_InputContext.GetUserGroups(sGroupXML, iThisUserID);
	sXML = sXML + sGroupXML;

	if ( bUsageType != 0 )
	{
		bOk = bOk && AddDBXMLIntTag("SITEID");
		if ( bUsageType == 1 )
		{	
			bOk = bOk && AddDBXMLIntTag("ForumID","JOURNAL");
		}
		else
		{
			bOk = bOk && AddDBXMLIntTag("ForumID");
		}
	}
	else
	{
		bOk = bOk && AddDBXMLIntTag("JOURNAL", NULL, false);	
	}

	bOk = bOk && CloseXMLTag("USER");
	return bOk;
}

bool CWatchList::Initialise(int iUserID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
	SP.FetchWatchedJournals(iUserID);

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, &SP);
	bool bOk = OpenXMLTag("WATCHED-USER-LIST",true);
	bOk = bOk && AddXMLIntAttribute("USERID",iUserID,true);
	while (!SP.IsEOF() && bOk)
	{
		bOk = bOk && BuildUserXML(sXML, 1 );
		SP.MoveNext();
	}

	bOk = bOk && CloseXMLTag("WATCHED-USER-LIST");
	TDVASSERT(bOk,"CWatchList::Initialise - Problems getting watch user details from database!");
	if (bOk)
	{
		CreateFromXMLText(sXML);
	}

	return bOk;
}

bool CWatchList::WatchUser(int iUserID, int iWatchedUserID, int iSiteID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
	
	SP.WatchUserJournal(iUserID, iWatchedUserID, iSiteID);

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, &SP);

	bool bOk = OpenXMLTag("WATCH-USER-RESULT",true);
		bOk = bOk && AddXMLAttribute("TYPE","add", true);
		bOk = bOk && BuildUserXML(sXML );
	bOk = bOk && CloseXMLTag("WATCH-USER-RESULT");
	
	TDVASSERT(bOk,"WatchUser - Problems getting watch user details from database!");
	if (bOk)
	{
		CreateFromXMLText(sXML);
	}

	return bOk;	
}

bool CWatchList::StopWatchingUser(int iUserID, int iWatchedUserID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return false;
	}
	
	SP.StopWatchingUserJournal(iUserID, iWatchedUserID);

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, &SP);

	bool bOk = OpenXMLTag("WATCH-USER-RESULT",true);
		bOk = bOk && AddXMLAttribute("TYPE","remove", true);
		bOk = bOk && BuildUserXML(sXML );
	bOk = bOk && CloseXMLTag("WATCH-USER-RESULT");
	
	TDVASSERT(bOk,"WatchUser - Problems getting watch user details from database!");
	if (bOk)
	{
		CreateFromXMLText(sXML);
	}

	return bOk;	
}

bool CWatchList::StartDeleteUsers(int iUserID)
{
	if (m_pDelSP != NULL)
	{
		delete m_pDelSP;
		m_pDelSP = NULL;
	}
	m_pDelSP = m_InputContext.CreateStoredProcedureObject();
	if (m_pDelSP == NULL)
	{
		return false;
	}

	m_iDelUserCount = 0;
	m_sDeleteXML = "<WATCH-USER-RESULT TYPE='delete' USERID='";
	m_sDeleteXML << iUserID << "'>";
	m_pDelSP->StartDeleteWatchUser(iUserID);
	return true;
}

bool CWatchList::AddDeleteUser(int iWatchedUserID)
{
	if (m_pDelSP == NULL)
	{
		return false;
	}
	m_pDelSP->AddDeleteWatchUser(iWatchedUserID);
	m_iDelUserCount++;
	
	// stored procedure only handles 20 at a time
	if (m_iDelUserCount == 20)
	{
		m_pDelSP->DoDeleteWatchUsers();
		GetDeletedUserDetails();
		m_iDelUserCount = 0;
		delete m_pDelSP;
		m_pDelSP = m_InputContext.CreateStoredProcedureObject();
		m_pDelSP->StartDeleteWatchUser(iWatchedUserID);
	}
	return true;
}

bool CWatchList::GetDeletedUserDetails()
{
	if (m_pDelSP == NULL)
	{
		return false;
	}

	CTDVString sXML;
	bool bOk = true;
	InitialiseXMLBuilder(&sXML, m_pDelSP);
	while (!m_pDelSP->IsEOF() && bOk)
	{
		bOk = bOk && BuildUserXML(sXML, 2 );
		m_pDelSP->MoveNext();
	}
	
	TDVASSERT(bOk,"CWatchList::GetDeletedUserDetails - Problems getting deleted user details from database!");
	if (bOk)
	{
		m_sDeleteXML << sXML;
	}

	return bOk;
}

bool CWatchList::DoDeleteUsers()
{
	if (m_pDelSP == NULL)
	{
		return false;
	}

	if (m_iDelUserCount > 0)
	{
		m_pDelSP->DoDeleteWatchUsers();
		GetDeletedUserDetails();
	}
	m_sDeleteXML << "</WATCH-USER-RESULT>";
	delete m_pDelSP;
	m_pDelSP = NULL;
	return CreateFromXMLText(m_sDeleteXML);
}
	

bool CWatchList::FetchJournalEntries(int iUserID, int iSkip, int iShow)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.FetchWatchedJournalPosts(iUserID);

	int ThreadCount = 0;
	if (!SP.IsEOF())
	{
		ThreadCount = SP.GetIntField("ThreadCount");
	}
	
	CTDVString sXML;
	sXML << "<WATCHED-USER-POSTS USERID='" << iUserID << "' SKIPTO='" << iSkip << "' COUNT='" << iShow << "' TOTAL='" << ThreadCount << "'>";

	if (iSkip > 0)
	{
		SP.MoveNext(iSkip);
	}
	int iNumToShow = iShow;

	while (!SP.IsEOF() && iNumToShow > 0 && (SP.IsNULL("Hidden")))
	{
		sXML << "<WATCHED-USER-POST";
		int iWUserID = SP.GetIntField("USERID");
		int iForumID = SP.GetIntField("ForumID");
		int iThreadID = SP.GetIntField("ThreadID");
		int iPostID = SP.GetIntField("EntryID");
		
		sXML << " FORUMID='" << iForumID << "' THREADID='" << iThreadID << "' POSTID='" << iPostID << "'>";
		
		CTDVString sUserName;
		CTDVString sFirstNames;
		CTDVString sLastName;
		CTDVString sArea;		
		CTDVString sSiteSuffix;
		CTDVString sTitle;
		int iStatus=0;
		int iTaxonomyNode=0;
		int iJournal = 0;
		int iActive = 0;

		CTDVString sSubject;
		CTDVString sBody;
		CTDVDateTime dDatePosted;
		CTDVString sDatePosted;
		CTDVString sLastPosted;
		CTDVDateTime dLastPost;
		int iPostCount;

		iPostCount = SP.GetIntField("Count");
		dLastPost = SP.GetDateField("LastReply");
		dLastPost.GetAsXML(sLastPosted, true);

		SP.GetField("UserName", sUserName);
		SP.GetField("FirstNames", sFirstNames);
		SP.GetField("LastName", sLastName);
		SP.GetField("Area", sArea);
		SP.GetField("SiteSuffix", sSiteSuffix);
		SP.GetField("Title", sTitle);

		iStatus = SP.GetIntField("Status");
		iTaxonomyNode = SP.GetIntField("TaxonomyNode");
		iJournal = SP.GetIntField("Journal");
		iActive = SP.GetIntField("Active");

		SP.GetField("Subject", sSubject);
		SP.GetField("text", sBody);

		EscapeAllXML(&sUserName);
		EscapeAllXML(&sFirstNames);
		EscapeAllXML(&sLastName);
		EscapeAllXML(&sArea);
		EscapeAllXML(&sSiteSuffix);
		EscapeAllXML(&sTitle);
	
		EscapeAllXML(&sSubject);
		if (SP.GetIntField("PostStyle") != 1) 
		{
			DoPlainTextTranslations(&sBody);
		}
		else
		{
			CTDVString sTemp = "<RICHPOST>";
			sTemp << sBody << "</RICHPOST>";
		}

		dDatePosted = SP.GetDateField("DatePosted");
		dDatePosted.GetAsXML(sDatePosted, true);

		//get the groups to which this user belongs to 		
		CTDVString sGroupXML;		
		m_InputContext.GetUserGroups(sGroupXML, iWUserID);		

		

		sXML << "<POSTCOUNT>" << iPostCount << "</POSTCOUNT>";

		sXML << "<USER>";
			sXML << "<USERID>" << iWUserID << "</USERID>";
			sXML << "<USERNAME>" << sUserName << "</USERNAME>";
			sXML << "<FIRSTNAMES>" << sFirstNames << "</FIRSTNAMES>";
			sXML << "<LASTNAME>" << sLastName << "</LASTNAME>";
			sXML << "<AREA>" << sArea << "</AREA>";
			sXML << "<STATUS>" << iStatus << "</STATUS>";
			sXML << "<TAXONOMYNODE>" << iTaxonomyNode << "</TAXONOMYNODE>";
			sXML << "<ACTIVE>" << iActive << "</ACTIVE>";
			sXML << "<JOURNAL>" << iJournal << "</JOURNAL>";
			sXML << "<SITESUFFIX>" << sSiteSuffix << "</SITESUFFIX>";
			sXML << "<TITLE>" << sTitle << "</TITLE>";
			sXML << sGroupXML;
		sXML << "</USER>";

		sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
		sXML << "<DATEPOSTED>" << sDatePosted << "</DATEPOSTED>";
		sXML << "<LASTPOSTED>" << sLastPosted << "</LASTPOSTED>";
		sXML << "<BODY>" << sBody << "</BODY>";

		sXML << "</WATCHED-USER-POST>";
		SP.MoveNext();
		iNumToShow--;
	}

	sXML << "</WATCHED-USER-POSTS>";
	CreateFromXMLText(sXML);
	if (!SP.IsEOF() && (SP.IsNULL("Hidden")))
	{
		// Get the node and add a MORE attribute
		CXMLTree* pFNode = m_pTree->FindFirstTagName("WATCHED-USER-POSTS");
		TDVASSERT(pFNode != NULL, "Can't find WATCHED-USER-POSTS node");
		
		if (pFNode != NULL)
		{
			pFNode->SetAttribute("MORE","1");
		}
	}
	UpdateRelativeDates();
	return true;
}

bool CWatchList::WatchingUsers(int iUserID, int iSiteID)
{
	// List of users who are watching this user
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.FetchWatchingUsers(iUserID, iSiteID);

	CTDVString sXML;
	InitialiseXMLBuilder(&sXML, &SP);
	bool bOk = OpenXMLTag("WATCHING-USER-LIST",true);
	bOk = bOk && AddXMLIntAttribute("USERID",iUserID,true);
	while (!SP.IsEOF() && bOk)
	{		
		bOk = bOk && BuildUserXML(sXML, 1 );
		SP.MoveNext();
	}

	bOk = bOk && CloseXMLTag("WATCHING-USER-LIST");
	TDVASSERT(bOk,"CWatchList::Initialise - Problems getting watch user details from database!");
	if (bOk)
	{
		CreateFromXMLText(sXML);
	}

	return bOk;
}
