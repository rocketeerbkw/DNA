// StoredProcedure.cpp: implementation of the CStoredProcedure class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"
#include "RipleyServer.h"
#include ".\storedprocedure.h"
#include "TDVAssert.h"
#include "md5.h"
#include "ExtraInfo.h"
#include "GuideEntry.h"
#include "VotePageBuilder.h"
#include "ArticleList.h"
#include "FrontPageElement.h"
#include "Forum.h"
#include "ModeratePosts.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


const int CStoredProcedure::MOD_TRIGGER_PROFANITY = 2;
const int CStoredProcedure::MOD_TRIGGER_AUTO = 3;
const int CStoredProcedure::MOD_TRIGGERED_BY_NOUSER = 0;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////


CStoredProcedure::CStoredProcedure()
{

}

CStoredProcedure::CStoredProcedure(DBO* pDBO, int iSiteID, CGI* pCGI) 
	: 
	m_SiteID(iSiteID), 
	m_iUpdateBits(0)
{
	CStoredProcedureBase::Initialise(pDBO, pCGI);
}

CStoredProcedure::~CStoredProcedure()
{
}

/*********************************************************************************

	bool CStoredProcedure::FetchTextOfArticle(int h2g2ID, CTDVString& sResult)

	Author:		Jim Lynn
	Created:	29/02/2000
	Inputs:		h2g2ID - ID of article (including checksum digit)
	Outputs:	sResult - XML text of the <ARTICLE> block
	Returns:	true if succeeded, false otherwise
	Purpose:	Test function to return the text of an article without any other
				gubbins around it. It returns the following XML data:
				<H2G2>
				  <ARTICLE>
					<SUBJECT>This is the subject</SUBJECT>
					<GUIDE>
						<BODY>
							...
						</BODY>
					</GUIDE>
				  </ARTICLE>
				</H2G2>

				Please note: The <H2G2> is currently a bodge.
*********************************************************************************/

bool CStoredProcedure::FetchTextOfArticle(int h2g2ID, CTDVString& sResult)
{
	// stub implementation
	
	int EntryID = h2g2ID / 10;

	m_pDBO->StartStoredProcedure("getarticlecomponents");
	m_pDBO->AddParam(EntryID);
	m_pDBO->ExecuteStoredProcedure();

	CTDVString DateCreated = "";
	int EditorID = 0;
	CTDVString Subject = "";
	CTDVString Text = "";
	CTDVString EditorName = "";
	while (!m_pDBO->IsEOF())
	{
		// Only care if IsMainArticle field is 1
		if (m_pDBO->GetLongField("IsMainArticle") == 1)
		{
			DateCreated = m_pDBO->FormatDateField("DateCreated","%#d %B %Y");
			EditorID = m_pDBO->GetLongField("Editor");
			Subject = m_pDBO->GetField("Subject");
			Text = m_pDBO->GetField("text");
		}
		m_pDBO->MoveNext();
	}


//	CTDVString sQuery = "SELECT UserName FROM Users WHERE UserID = ";
//	sQuery << EditorID;
//	m_pDBO->ExecuteQuery(sQuery);
//	if (!m_pDBO->IsEOF())
//	{
//		EditorName = m_pDBO->GetField("UserName");
//	}
	sResult = "\
<H2G2>\
<ARTICLE>\
";
	sResult << "<SUBJECT>" << Subject << "</SUBJECT>\n";
	sResult << Text;
	sResult << "</ARTICLE>\n</H2G2>";
	//Now we've filled in a result, return true
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchSimpleArticle(int h2g2ID, CTDVString& sResult)

	Author:		Jim Lynn
	Created:	29/02/2000
	Inputs:		h2g2ID - ID of article to fetch
	Outputs:	sResult - XML string representing article
	Returns:	true if succeeded, false otherwise
	Purpose:	Gets just the text of the article, in an <ARTICLE> block, to
				be inserted into an <H2G2> block by a builder.
				It does *not* return the <ARTICLEINFO> section.
				It returns the following XML data:
				  <ARTICLE>
					<SUBJECT>This is the subject</SUBJECT>
					<GUIDE>
						<BODY>
							...
						</BODY>
					</GUIDE>
				  </ARTICLE>

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::FetchSimpleArticle(int h2g2ID, CTDVString& sResult)
{
	// stub implementation
	
	int EntryID = h2g2ID / 10;
	CTDVString sQuery;
	sQuery <<  "SELECT g.EntryID, \
	g.blobid, \
	g.DateCreated, \
	g.DateExpired, \
	g.Subject, \
	g.ForumID, \
	g.h2g2ID, \
	g.Editor, \
	g.Status,\
	g.Style,\
	g.Hidden,\
	g.SiteID,\
	g.Submittable,\
	1 as IsMainArticle,\
	b.text\
	FROM GuideEntries g, blobs b\
	WHERE g.blobid = b.blobid AND g.EntryID  = " << EntryID;
	m_pDBO->ExecuteQuery(sQuery);

	CTDVString DateCreated = "";
	int EditorID = 0;
	CTDVString Subject = "";
	CTDVString Text = "";
	CTDVString EditorName = "";
	bool bHidden = false;
	while (!m_pDBO->IsEOF())
	{
		// Only care if IsMainArticle field is 1
		if (m_pDBO->GetLongField("IsMainArticle") == 1)
		{
			DateCreated = m_pDBO->FormatDateField("DateCreated","%#d %B %Y");
			EditorID = m_pDBO->GetLongField("Editor");
			Subject = m_pDBO->GetField("Subject");
			Text = m_pDBO->GetField("text");
			bHidden = !IsNULL("Hidden");
		}
		m_pDBO->MoveNext();
	}


	sResult = "<ARTICLE>\n";
	if (bHidden)
	{
		sResult << "Article hidden\n";
	}
	else
	{
		sResult << "<SUBJECT>" << Subject << "</SUBJECT>\n";
		sResult << Text;
	}
	sResult << "</ARTICLE>";
	//Now we've filled in a result, return true
	return true;
}

#else

bool CStoredProcedure::FetchSimpleArticle(int h2g2ID, CTDVString& sResult)
{
	// stub implementation
	
	int EntryID = h2g2ID / 10;
	m_pDBO->StartStoredProcedure("getarticlecomponents2");
	m_pDBO->AddParam(EntryID);
	m_pDBO->ExecuteStoredProcedure();

	CTDVString DateCreated = "";
	int EditorID = 0;
	CTDVString Subject = "";
	CTDVString Text = "";
	CTDVString EditorName = "";
	CTDVString sExtrainfo;
	bool bHidden = false;
	while (!m_pDBO->IsEOF())
	{
		// Only care if IsMainArticle field is 1
		if (m_pDBO->GetLongField("IsMainArticle") == 1)
		{
			DateCreated = m_pDBO->FormatDateField("DateCreated","%#d %B %Y");
			EditorID = m_pDBO->GetLongField("Editor");
			Subject = m_pDBO->GetField("Subject");
			Text = m_pDBO->GetField("text");
			sExtrainfo = m_pDBO->GetField("ExtraInfo");
			bHidden = !IsNULL("Hidden");
		}
		m_pDBO->MoveNext();
	}


	sResult = "<ARTICLE>\n";
	if (bHidden)
	{
		sResult << "Article hidden\n";
	}
	else
	{
		sResult << "<SUBJECT>" << Subject << "</SUBJECT>\n";
		sResult << Text;
		sResult << sExtrainfo;
	}
	sResult << "</ARTICLE>";
	//Now we've filled in a result, return true
	return true;
}

#endif

#ifdef __MYSQL__

bool CStoredProcedure::FetchSimpleArticle(const TDVCHAR *pArticleName, int iSiteID, CTDVString &sResult)
{
	// stub implementation
	
//	int EntryID = h2g2ID / 10;
	m_sQuery.Empty();
	m_sQuery << "SELECT @entryid := EntryID FROM KeyArticles\
  WHERE ArticleName = '" << pArticleName << "' AND DateActive <= NOW() AND SiteID = " << iSiteID << "\
  ORDER BY DateActive DESC\
  LIMIT 0,1";
	m_pDBO->ExecuteQuery(m_sQuery);
	m_sQuery = "SELECT g.EntryID,\
	g.blobid,\
	g.DateCreated,\
	g.DateExpired,\
	g.Subject,\
	g.ForumID,\
	g.h2g2ID,\
	g.Editor,\
	g.Status,\
	g.Style,\
	g.Hidden,\
	g.SiteID,\
	g.Submittable,\
  CASE WHEN EntryID = @entryid THEN 1\
    ELSE 0\
  END as IsMainArticle,\
	b.text\
	FROM GuideEntries g, blobs b\
	WHERE g.blobid = b.blobid AND g.EntryID = @entryid";
	m_pDBO->ExecuteQuery(m_sQuery);

	CTDVString	DateCreated = "";
	int			EditorID = 0;
	CTDVString	Subject = "";
	CTDVString	Text = "";
	CTDVString	EditorName = "";
	int			ih2g2ID = 0;

	while (!IsEOF())
	{
		// Only care if IsMainArticle field is 1
		if (GetIntField("IsMainArticle") == 1)
		{
			FormatDateField("DateCreated","%#d %B %Y", DateCreated );
			EditorID = GetIntField("Editor");
			GetField("Subject", Subject );
			GetField("text", Text);
			ih2g2ID = GetIntField("h2g2ID");
		}
		MoveNext();
	}


	sResult = "<ARTICLE>\n";
	sResult << "<ARTICLEINFO><H2G2ID>" << ih2g2ID << "</H2G2ID></ARTICLEINFO>\n";
	sResult << "<SUBJECT>" << Subject << "</SUBJECT>\n";
	sResult << Text;
	sResult << "</ARTICLE>";
	//Now we've filled in a result, return true
	return true;

}



#else
bool CStoredProcedure::FetchSimpleArticle(const TDVCHAR *pArticleName, int iSiteID, CTDVString &sResult)
{
	// stub implementation
//	int EntryID = h2g2ID / 10;
	StartStoredProcedure("getkeyarticlecomponents");
	AddParam(pArticleName);
	AddParam(iSiteID);
	ExecuteStoredProcedure();

	CTDVString	DateCreated = "";
	int			EditorID = 0;
	CTDVString	Subject = "";
	CTDVString	Text = "";
	CTDVString	EditorName = "";
	int			ih2g2ID = 0;
	CTDVString	sEditKey;
	CTDVString	sExtraInfo;

	while (!IsEOF())
	{
		// Only care if IsMainArticle field is 1
		if (GetIntField("IsMainArticle") == 1)
		{
			FormatDateField("DateCreated","%#d %B %Y", DateCreated );
			EditorID = GetIntField("Editor");
			GetField("EditKey", sEditKey);
			GetField("Subject", Subject );
			GetField("text", Text);
			GetField("extrainfo", sExtraInfo);
			ih2g2ID = GetIntField("h2g2ID");
		}
		MoveNext();
	}

	sResult = "<ARTICLE>\n";
	sResult << "<ARTICLEINFO><H2G2ID>" << ih2g2ID << "</H2G2ID>";
	sResult << "<EDIT-KEY>" << sEditKey << "</EDIT-KEY></ARTICLEINFO>\n";
	sResult << "<SUBJECT>" << Subject << "</SUBJECT>\n";
	sResult << Text; 
	sResult << sExtraInfo;
	sResult << "</ARTICLE>";

	// Now we've filled in a result, return true
	return true;
}

#endif

bool CStoredProcedure::GetTopFive(const TDVCHAR *pName)
{
	StartStoredProcedure("topfivearticles");
	AddParam(pName);
	ExecuteStoredProcedure();
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetTopFiveForums(const TDVCHAR *pName)

	Author:		Jim Lynn
	Created:	02/03/2000
	Inputs:		pName - name of forum group to fetch
	Outputs:	-
	Returns:	true if any records found
				Fields returned:
					ForumID, Title, Rank
	Purpose:	Fetches the top five forums of the given name. Will have the
				first row of the results ready to be read if it returns true.

*********************************************************************************/

bool CStoredProcedure::GetTopFiveForums(const TDVCHAR *pName)
{
	StartStoredProcedure("topfiveforums");
	AddParam(pName);
	ExecuteStoredProcedure();
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetUserFromCookie(const TDVCHAR *pCookie)

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		pCookie - cookie value
	Outputs:	-
	Returns:	true if user details fetched, false if not
	Fields:		int UserID
				string Cookie
				string email
				string UserName
				string Password
				string FirstNames
				string LastName
				int Active
				int Masthead
				date DateJoined
				int Status
				int Anonymous
				int Journal
				int PrefForumStyle
				int PrefForumThreadStyle
				int PrefForumShowMaxPosts
				bool PrefReceiveWeeklyMailshot
				bool PrefReceiveDailyUpdates
	Purpose:	Gets the user details. Call the standard fetch methods to get
				the fields you want.

*********************************************************************************/

#ifndef __MYSQL__
bool CStoredProcedure::GetUserFromCookie(const TDVCHAR *pCookie, int iSiteID)
{
	StartStoredProcedure("findcookie");
	AddParam(pCookie);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	return !IsEOF();
}
#else

bool CStoredProcedure::GetUserFromCookie(const TDVCHAR *pCookie, int iSiteID)
{
	CTDVString sQuery;
	sQuery << "(SELECT      u.*,      AgreedTerms,\
	PrefSkin,\
	PrefUserMode,\
	PrefForumStyle,\
	PrefForumThreadStyle,\
	PrefForumShowMaxPosts,\
	PrefReceiveWeeklyMailshot,\
	PrefReceiveDailyUpdates,\
	PrefXML\
	FROM Users u\
	INNER JOIN Preferences p  ON (p.UserID = u.UserID/* OR p.UserID = 0*/)\
	  AND (SiteID = " << iSiteID << " OR SiteID IS NULL)\
	  WHERE u.cookie = '" << pCookie << "'  AND Status <> 0\
	  )\
	  UNION\
	(SELECT\
	u.*,\
		  AgreedTerms,\
	PrefSkin,\
	PrefUserMode,\
	PrefForumStyle,\
	PrefForumThreadStyle,\
	PrefForumShowMaxPosts,\
	PrefReceiveWeeklyMailshot,\
	PrefReceiveDailyUpdates,\
	PrefXML\
	FROM Users u\
	INNER JOIN Preferences  p ON p.UserID = 0\
	\
  WHERE p.UserID = 0 AND p.SiteID = " << iSiteID << " AND u.Cookie = '" << pCookie << "'\
  )";

//	StartStoredProcedure("findcookie");
//	AddParam(pCookie);
//	AddParam(iSiteID);
//	ExecuteStoredProcedure();
	m_pDBO->ExecuteQuery(sQuery);
	return !IsEOF();
}
#endif

/*********************************************************************************

	bool CStoredProcedure::GetUserFromID(int iUserID)

	Author:		Jim Lynn
	Created:	03/03/2000
	Inputs:		iUserID - integer user ID
	Outputs:	-
	Returns:	true if user details fetched, false if not
	Fields:		int UserID
				string Cookie
				string email
				string UserName
				string Password
				string FirstNames
				string LastName
				int Active
				int Masthead
				date DateJoined
				int Status
				int Anonymous
				int Journal
				int PrefForumStyle
				int PrefForumThreadStyle
				int PrefForumShowMaxPosts
				bool PrefReceiveWeeklyMailshot
				bool PrefReceiveDailyUpdates
	Purpose:	Gets the user details based on the user ID. Call the standard 
				fetch methods to get the fields you want.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::GetUserFromID(int iUserID, int iSiteID)
{
	m_sQuery.Empty();
	m_sQuery << "(SELECT      u.*,      AgreedTerms,\
  PrefSkin,\
  PrefUserMode,\
  PrefForumStyle,\
  PrefForumThreadStyle,\
  PrefForumShowMaxPosts,\
  PrefReceiveWeeklyMailshot,\
  PrefReceiveDailyUpdates,\
  PrefXML\
  FROM Users u\
  INNER JOIN Preferences p  ON (p.UserID = u.UserID/* OR p.UserID = 0*/)\
    AND (SiteID = " << iSiteID << " OR SiteID IS NULL)\
    WHERE u.UserID = " << iUserID << "  AND Status <> 0\
    )\
    UNION\
  (SELECT\
  u.*,\
      AgreedTerms,\
  PrefSkin,\
  PrefUserMode,\
  PrefForumStyle,\
  PrefForumThreadStyle,\
  PrefForumShowMaxPosts,\
  PrefReceiveWeeklyMailshot,\
  PrefReceiveDailyUpdates,\
  PrefXML\
  FROM Users u\
  INNER JOIN Preferences  p ON p.UserID = 0\
 \
  WHERE p.UserID = 0 AND p.SiteID = " << iSiteID << " AND u.UserID = " << iUserID << ")";
	m_pDBO->ExecuteQuery(m_sQuery);
	return !IsEOF();
}

#else

bool CStoredProcedure::GetUserFromID(int iID, bool bIDIsUserID, int iSiteID)
{
	StartStoredProcedure("finduserfromid");
	if (bIDIsUserID)
	{
		AddParam("userid",iID);
	}
	else
	{
		AddParam("h2g2id",iID);
	}
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

bool CStoredProcedure::GetUserFromIDWithOrWithoutMasthead(int iUserID, int iSiteID)
{
	StartStoredProcedure("finduserfromidwithorwithoutmasthead");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

bool CStoredProcedure::GetUserFromIDAndLogSession(int iID, int iSiteID)
{
	StartStoredProcedure("finduserfromidandlogsession");
	AddParam("userid",iID);
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();

	if (HandleError("GetUSerFromIDAndLogSession"))
	{
		return false;
	}

	return !IsEOF();

}

/*********************************************************************************

	bool CStoredProcedure::GetUserFromUserID(int iUserID, int iSiteID)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Get user via the UserID

*********************************************************************************/

bool CStoredProcedure::GetUserFromUserID(int iUserID, int iSiteID, bool bLogUserSession)
{
	if (bLogUserSession)
	{
		return GetUserFromIDAndLogSession(iUserID,iSiteID);
	}
	else
	{
		return GetUserFromID(iUserID, true, iSiteID);
	}
	
}

/*********************************************************************************

	bool CStoredProcedure::GetUserFromH2G2ID(int iH2G2ID, int iSiteID)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Get user via H2G2ID and SiteID

*********************************************************************************/

bool CStoredProcedure::GetUserFromH2G2ID(int iH2G2ID, int iSiteID)
{
	return GetUserFromID(iH2G2ID, false, iSiteID);
}

#endif

bool CStoredProcedure::ForumGetMostRecent(int iForumID, CTDVString &sResult)
{
	// Do the stored procedure
	StartStoredProcedure("mostrecentthreads");
	AddParam(iForumID);
	ExecuteStoredProcedure();

	// Are there any results?
	if (IsEOF())
	{
		// No!
		sResult = "<ARTICLEFORUM>\n<FORUMID>";
		sResult << iForumID << "</FORUMID></ARTICLEFORUM>\n";
		return true;
	}
	else
	{
		// Goody - we've got a result set, let's use it.
		sResult = "<ARTICLEFORUM>\n<FORUMID>";
		sResult << iForumID << "</FORUMID>\n";

		//MoveNext(30);
		
		// Now put in the threads
		while (!IsEOF())
		{
			CTDVString sSubject = "";
			GetField("FirstSubject",sSubject);
			sSubject.Replace("&","&amp;");
			sSubject.Replace("<","&lt;");
			sSubject.Replace(">", "&gt;");
			CTDVString sDate = "";
			CTDVDateTime dDate = GetDateField("LastPosted");
			dDate.GetAsXML(sDate);
			int ThreadID = GetIntField("ThreadID");
			
			sResult << "<THREAD><THREADID>" << ThreadID << "</THREADID>\n"
				<< "<SUBJECT>" << sSubject << "</SUBJECT>\n"
				<< "<DATEPOSTED>" << sDate << "</DATEPOSTED>\n"
				<< "</THREAD>\n";
			MoveNext();
		}
		sResult << "</ARTICLEFORUM>";
		return true;
	}
}

#ifdef __MYSQL__

bool CStoredProcedure::FetchGuideEntry(int h2g2ID, int &oh2g2ID, int &oEntryID, int& oEditor, int &oForumID, int &oStatus, int &oStyle, CTDVDateTime &oDateCreated, CTDVString &oSubject, CTDVString& oText, int& iHidden, int& iSiteID, int& iSubmittable, int& iTypeID)
{
	int iEntryID = h2g2ID / 10;

	CTDVString sQuery;
	sQuery <<  "SELECT g.EntryID, \
	g.blobid, \
	g.DateCreated, \
	g.DateExpired, \
	g.Subject, \
	g.ForumID, \
	g.h2g2ID, \
	g.Editor, \
	g.Status,\
	g.Style,\
	g.Hidden,\
	g.SiteID,\
	g.Submittable,\
	g.Type,\
	1 as IsMainArticle,\
	b.text\
	FROM GuideEntries g, blobs b\
	WHERE g.blobid = b.blobid AND g.EntryID  = " << iEntryID;
	m_pDBO->ExecuteQuery(sQuery);
	bool bSuccess = false;
	
	// Maybe we've got some article stuff, let's fetch it out
	while (!IsEOF())
	{
		if (GetIntField("IsMainArticle") == 1)
		{
			bSuccess = true;
			oh2g2ID = GetIntField("h2g2ID");
			oEntryID = GetIntField("EntryID");
			oForumID = GetIntField("ForumID");
			oStatus = GetIntField("Status");
			oStyle = GetIntField("Style");
			oEditor = GetIntField("Editor");
			iSiteID = GetIntField("SiteID");
			iSubmittable = GetIntField("Submittable");
			iTypeID = GetIntField("Type");
			GetField("Subject",oSubject);
			GetField("text",oText);
			if (IsNULL("Hidden"))
			{
				iHidden = 0;
			}
			else
			{
				iHidden = GetIntField("Hidden");
			}

			oDateCreated = GetDateField("DateCreated");
		}
		MoveNext();
	}
	return bSuccess;
}

#else


/*********************************************************************************

	bool CStoredProcedure::FetchGuideEntry(int h2g2ID, int &oh2g2ID, int &oEntryID, int& oEditor, int &oForumID, int &oStatus,
											int &oStyle, CTDVDateTime &oDateCreated, CTDVString &oSubject, CTDVString& oText,
											int& iHidden, int& iSiteID, int& iSubmittable, CExtraInfo& sExtraInfo, int& iTypeID,
											bool& bDefaultCanRead, bool& bDefaultCanWrite, bool& bDefaultCanChangePermissions,
											int& iTopicID, int& iBoardPromoID)

	Author:		
	Created:	
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Fetches all the elements of the guidentry given the h2g2id

*********************************************************************************/

bool CStoredProcedure::FetchGuideEntry(int h2g2ID, int &oh2g2ID, int &oEntryID, int& oEditor, int &oForumID, int &oStatus, int &oStyle,
									   CTDVDateTime &oDateCreated, CTDVString &oSubject, CTDVString& oText, int& iHidden, int& iSiteID,
									   int& iSubmittable, CExtraInfo& ExtraInfo, int& iTypeID, int& iModerationStatus,
									   CTDVDateTime& oLastUpdated, bool& bPreProcessed, bool& bDefaultCanRead, bool& bDefaultCanWrite,
									   bool& bDefaultCanChangePermissions, int& iTopicID, int& iBoardPromoID,
									   CTDVDateTime& oDateRangeStart, CTDVDateTime& oDateRangeEnd, int& iRangeInterval, int& iLocationCount)
{
	int iEntryID = h2g2ID / 10;

	StartStoredProcedure("getarticlecomponents2");
	AddParam(iEntryID);
	ExecuteStoredProcedure();
	
	bool bSuccess = false;
	
	// Maybe we've got some article stuff, let's fetch it out
	while (!IsEOF())
	{
		if (GetIntField("IsMainArticle") == 1)
		{
			bSuccess = true;
			oh2g2ID		= GetIntField("h2g2ID");
			oEntryID	= GetIntField("EntryID");
			oForumID	= GetIntField("ForumID");
			oStatus		= GetIntField("Status");
			oStyle		= GetIntField("Style");
			oEditor		= GetIntField("Editor");
			iSiteID		= GetIntField("SiteID");	
			iSubmittable= GetIntField("Submittable");
			iTypeID		= GetIntField("Type");
			iModerationStatus = GetIntField("ModerationStatus");
			GetField("Subject",oSubject);
			GetField("text",oText);
			CTDVString sExtraInfo;
			GetField("ExtraInfo",sExtraInfo);
			ExtraInfo.Create(iTypeID,sExtraInfo);

			if (IsNULL("Hidden"))
			{
				iHidden = 0;
			}
			else
			{
				iHidden = GetIntField("Hidden");
			}

			oDateCreated = GetDateField("DateCreated");
			oLastUpdated = GetDateField("LastUpdated");
			bPreProcessed = (GetIntField("PreProcessed") > 0);
			bDefaultCanRead				 = (GetIntField("CanRead") > 0);
			bDefaultCanWrite			 = (GetIntField("CanWrite") > 0);
			bDefaultCanChangePermissions = (GetIntField("CanChangePermissions") > 0);

			if (IsNULL("TopicID"))
			{
				iTopicID = 0;
			}
			else
			{
				iTopicID = GetIntField("TopicID");
			}

			if (IsNULL("BoardPromoID"))
			{
				iBoardPromoID = 0;
			}
			else
			{
				iBoardPromoID = GetIntField("BoardPromoID");
			}

			if (!IsNULL("StartDate"))
			{
				oDateRangeStart = GetDateField("StartDate");
			}
			if (!IsNULL("EndDate"))
			{
				oDateRangeEnd = GetDateField("EndDate");
			}

			if (IsNULL("TimeInterval"))
			{
				iRangeInterval = - 1; // default value
			}
			else
			{
				iRangeInterval = GetIntField("TimeInterval");
			}

			iLocationCount = GetIntField("LocationCount");
		}
		MoveNext();
	}
	return bSuccess;
}

#endif


/*********************************************************************************

	bool CStoredProcedure::FetchGuideEntryExtraInfo(int h2g2ID, CExtraInfo& ExtraInfo)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		h2g2ID = the ID of the article
				ExtraInfo = ref to the object to fill in with the result
	Outputs:	-
	Returns:	true if it successfully retrieved the ExtraInfo data
	Purpose:	Does what it says on the tin

*********************************************************************************/

bool CStoredProcedure::FetchGuideEntryExtraInfo(int h2g2ID, CExtraInfo& ExtraInfo)
{
	StartStoredProcedure("getarticleextrainfo");
	AddParam("h2g2id",h2g2ID);
	ExecuteStoredProcedure();
	
	if (!IsEOF())
	{
		CTDVString sExtraInfo;
		GetField("ExtraInfo",sExtraInfo);
		ExtraInfo.Create(GetIntField("type"),sExtraInfo);
		return true;
	}

	return false;
}

/*********************************************************************************

	bool CStoredProcedure::FetchArticleSummary(int iEntryID, int* pih2g2ID, CTDVString* psSubject, CTDVString* psEditorName, int* piEditorID, int* piStatus, bool* pbIsSubCopy, int* piOriginalEntryID, bool* pbHasSubCopy, int* piSubCopyID, int* piRecommendationStatus, bool* pbScountRecommendationStatus, CTDVString* psComments)

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		iEntryID - entry to fetch
	Outputs:	pih2g2ID - the h2g2ID for the entry
				psSubject - the entry subject
				psEditorName - the editors username
				piEditorID - ID of the author
				piStatus - status of the entry
				pbIsSubCopy - true if this is the subs copy of a recommended entry
				piOriginalEntryID - Entry ID of the original entry if this is a subs copy
				pbHasSubCopy - true if this entry has a copy made for a sub
				piSubCopyID - ID of the subs copy of this entry if one exists
				piRecommendationStatus - status of the recommendation of this entry, or
					of the recommendation for which this is the subs copy, or null if neither.
				piRecommendedBy - ID of scount who has already recommended this entry
				psScoutName - username of scount who recommended this entry
				psComments - any comments on this Entrys recommendation
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Extracts basic info on the entry specified, for use when all data
				is not required. If any output parameters are NULL then discards
				those values.

*********************************************************************************/

bool CStoredProcedure::FetchArticleSummary(int iEntryID, int* pih2g2ID, CTDVString* psSubject, CTDVString* psEditorName, int* piEditorID, int* piStatus, bool* pbIsSubCopy, int* piOriginalEntryID, bool* pbHasSubCopy, int* piSubCopyID, int* piRecommendationStatus, int* piRecommendedBy, CTDVString* psScoutName, CTDVString* psComments)
{
	TDVASSERT(iEntryID > 0, "iEntryID <= 0 in CStoredProcedure::FetchEntryBasics(...)");

	StartStoredProcedure("FetchArticleSummary");
	AddParam("EntryID", iEntryID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		// set all the output parameters which are non-NULL
		if (pih2g2ID != NULL)
		{
			*pih2g2ID = GetIntField("h2g2ID");
		}
		if (psSubject != NULL)
		{
			GetField("Subject", *psSubject);
		}
		if (psEditorName != NULL)
		{
			GetField("EditorName", *psEditorName);
		}
		if (piEditorID != NULL)
		{
			*piEditorID = GetIntField("EditorID");
		}
		if (piStatus != NULL)
		{
			*piStatus = GetIntField("Status");
		}
		if (pbIsSubCopy != NULL)
		{
			*pbIsSubCopy = GetBoolField("IsSubCopy");
		}
		if (piOriginalEntryID != NULL)
		{
			*piOriginalEntryID = GetIntField("OriginalEntryID");
		}
		if (pbHasSubCopy != NULL)
		{
			*pbHasSubCopy = GetBoolField("HasSubCopy");
		}
		if (piSubCopyID != NULL)
		{
			*piSubCopyID = GetIntField("SubCopyID");
		}
		if (piRecommendationStatus != NULL)
		{
			*piRecommendationStatus = GetIntField("RecommendationStatus");
		}
		if (piRecommendedBy != NULL)
		{
			*piRecommendedBy = GetIntField("RecommendedByScoutID");
		}
		if (psScoutName != NULL)
		{
			GetField("RecommendedByUserName", *psScoutName);
		}
		if (psComments != NULL)
		{
			if (!GetField("Comments", *psComments))
			{
				// if couldn't get field then set comments to empty
				*psComments = "";
			}
		}
		return true;
	}
}

/*********************************************************************************

	bool CStoredProcedure::FetchRecommendationDetails(int iRecommendationID)

	Author:		Kim Harries
	Created:	26/11/2000
	Inputs:		iRecommendationID - ID of the recommendation we wish to fetch
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Fetches all the necessary details on a particular scout recommendation.

*********************************************************************************/

bool CStoredProcedure::FetchRecommendationDetails(int iRecommendationID)
{
	StartStoredProcedure("FetchRecommendationDetails");
	AddParam("RecommendationID", iRecommendationID);
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchRecommendationDetailsFromEntryID(int iEntryID)

	Author:		Kim Harries
	Created:	26/11/2000
	Inputs:		iEntryID - ID of the recommendation we wish to fetch
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Fetches all the necessary details on a particular scout recommendation.

*********************************************************************************/

bool CStoredProcedure::FetchRecommendationDetailsFromEntryID(int iEntryID)
{
	StartStoredProcedure("FetchRecommendationDetailsFromEntryID");
	AddParam("EntryID", iEntryID);
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchUndecidedRecommendations()

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Fetches all the currently recommended articles from scouts, i.e. all
				the articles that scouts have recommended but have had no decision
				yet.

*********************************************************************************/

bool CStoredProcedure::FetchUndecidedRecommendations()
{
	StartStoredProcedure("FetchUndecidedRecommendations");
	AddParam("siteid", m_SiteID);	// Current viewing site
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchUnallocatedAcceptedRecommendations()

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Fetches all the current accepted recommended articles that have
				not yet been allocated to a sub editor.

*********************************************************************************/

bool CStoredProcedure::FetchUnallocatedAcceptedRecommendations()
{
	StartStoredProcedure("FetchUnallocatedAcceptedRecommendations");
	AddParam("siteid", m_SiteID);	// Current viewing site id
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchAllocatedUnreturnedRecommendations()

	Author:		Kim Harries
	Created:	22/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Fetches all the recommended entries that have been allocated to a
				sub editor but not yet returned.

*********************************************************************************/

bool CStoredProcedure::FetchAllocatedUnreturnedRecommendations()
{
	StartStoredProcedure("FetchAllocatedUnreturnedRecommendations");
	AddParam("siteid", m_SiteID);	// Current viewing site id
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchSubEditorsDetails()

	Author:		Kim Harries
	Created:	20/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		???

	Purpose:	Fetches the details on all the sub editors.

*********************************************************************************/

bool CStoredProcedure::FetchSubEditorsDetails()
{
	StartStoredProcedure("FetchSubEditorsDetails");
	AddParam("currentsiteid", m_SiteID);	// Current viewing siteid
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchEntriesResearchers(int iEntryID, int iSiteID)

	Author:		Kim Harries
	Created:	04/01/2001
	Inputs:		iEntryID - the ID of the entry whose researcher list we want
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		???

	Purpose:	Fetches the details on all researchers for a particular entry.

*********************************************************************************/

bool CStoredProcedure::FetchEntriesResearchers(int iEntryID, int iSiteID)
{
	StartStoredProcedure("FetchEntriesResearchers");
	AddParam("EntryID", iEntryID);
	AddParam("SiteID",iSiteID);
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchAndUpdateSubsUnnotifiedAllocations(int iSubID)

	Author:		Kim Harries
	Created:	28/11/2000
	Inputs:		iSubID - the sub whose allocations we want
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		???

	Purpose:	Fetches details on all the entry allocations for this sub
				which they have not yet been notified of and also sets those
				allocations notified bit and updates the subs last notified date.

*********************************************************************************/

bool CStoredProcedure::FetchAndUpdateSubsUnnotifiedAllocations(int iSubID)
{
	StartStoredProcedure("FetchAndUpdateSubsUnnotifiedAllocations");
	AddParam("SubID", iSubID);
	AddParam("currentsiteid", m_SiteID);	// Current viewing siteid
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedurebool::AcceptScoutRecommendation(int iRecommendationID, int iUserID, const TDVCHAR* pcComments)

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		iRecommendationID - ID of the scout recommendation being accepted
				iUserID - I Dof the user making the decision
				pcComments - any additional comments to add to the recommendation
	Outputs:	-
	Returns:	true if successful, false if not
	Purpose:	Updates the status of a recommendation to 'accepted'.

	Fields:		Success	bit => 1 for success, 0 for failure

*********************************************************************************/

bool CStoredProcedure::AcceptScoutRecommendation(int iRecommendationID, int iUserID, const TDVCHAR* pcComments)
{
	StartStoredProcedure("AcceptScoutRecommendation");
	AddParam("RecommendationID", iRecommendationID);
	AddParam("AcceptorID", iUserID);
	AddParam("Comments", pcComments);
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedurebool::RejectScoutRecommendation(int iRecommendationID, int iUserID, const TDVCHAR* pcComments)

	Author:		Kim Harries
	Created:	24/11/2000
	Inputs:		iRecommendationID - ID of the scout recommendation being rejected
				iUserID - ID of the user making the decision => not currently stored
				pcComments - any additional comments to add to the recommendation
	Outputs:	-
	Returns:	true if successful, false if not
	Purpose:	Updates the status of a recommendation to 'rejected'.

	Fields:		Success	bit => 1 for success, 0 for failure

*********************************************************************************/

bool CStoredProcedure::RejectScoutRecommendation(int iRecommendationID, int iUserID, const TDVCHAR* pcComments)
{
	StartStoredProcedure("RejectScoutRecommendation");
	AddParam("RecommendationID", iRecommendationID);
//	AddParam("RejectorID", iUserID);
	AddParam("Comments", pcComments);
	ExecuteStoredProcedure();
	// not likely to have errors, but check anyway
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::AllocateEntriesToSub(int iSubID, int iAllocatorID, const TDVCHAR* pComments, int* piEntryIDs, int iTotalEntries)

	Author:		Kim Harries
	Created:	21/11/2000
	Inputs:		iSubID - ID of sub editor to allocate the entries to
				iAllocatorID - ID of user doing the allocating
				pComments - comments to be applied to all allocations, or NULL if
					to be left unchanged from existing comments
				piEntryIDs - ptr to an array of entry IDs to allocate
				iTotalEntries - total number of IDs in the array
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Allocates all the entries in the given array to the specified
				sub editor.

*********************************************************************************/

bool CStoredProcedure::AllocateEntriesToSub(int iSubID, int iAllocatorID, const TDVCHAR* pComments, int* piEntryIDs, int iTotalEntries)
{
	TDVASSERT(piEntryIDs != NULL, "NULL piEntryIDs in CStoredProcedure::AllocateEntriesToSub(...)");
	TDVASSERT(iTotalEntries > 0, "TotalEntries <= 0 in CStoredProcedure::AllocateEntriesToSub(...)");

	// fail if inappropriate data provided
	if (piEntryIDs == NULL || iTotalEntries == 0)
	{
		return false;
	}

	CTDVString	sTemp;
	StartStoredProcedure("AllocateEntriesToSub");
	AddParam("SubID", iSubID);
	AddParam("AllocatorID", iAllocatorID);
	if (pComments != NULL)
	{
		AddParam("Comments", pComments);
	}
	for (int i = 0; i < iTotalEntries; i++)
	{
		sTemp = "id";
		sTemp << i;
		AddParam(sTemp, piEntryIDs[i]);
	}
	ExecuteStoredProcedure();
	// return error status
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::AutoAllocateEntriesToSub(int iSubID, int iNumberToAllocate, int iAllocatorID, const TDVCHAR* pComments = NULL, int* piTotalAllocated = NULL)

	Author:		Kim Harries
	Created:	23/11/2000
	Inputs:		iSubID - ID of sub editor to allocate the entries to
				iNumberToAllocate - number of entries to allocate to them
				iAllocatorID - ID of user doing the allocating
				pComments - comments to be applied to all allocations, or NULL if
					to be left unchanged from existing comments
				piTotalAllocated - optional output parameter to store the actual
					number of entries allocated
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Automatically allocated the next iNumberToAllocate entries in the
				accepted recommendations queue to the sub.

*********************************************************************************/

bool CStoredProcedure::AutoAllocateEntriesToSub(int iSubID, int iNumberToAllocate, int iAllocatorID, const TDVCHAR* pComments, int* piTotalAllocated)
{
	StartStoredProcedure("AutoAllocateEntriesToSub");
	AddParam("SubID", iSubID);
	AddParam("AllocatorID", iAllocatorID);
	AddParam("NumberOfEntries", iNumberToAllocate);
	if (pComments != NULL)
	{
		AddParam("Comments", pComments);
	}
	ExecuteStoredProcedure();
	// if an error then don't try to get the total allocated
	CTDVString	sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		return false;
	}
	else
	{
		// if no error and we have been given an output variable, then
		// get the total no. of entries allocated and assign it to this variable
		if (piTotalAllocated != NULL)
		{
			*piTotalAllocated = GetIntField("TotalAllocated");
		}
		return true;
	}
}

/*********************************************************************************

	bool CStoredProcedure::DeallocateEntriesFromSubs(int iDeallocatorID, int* piEntryIDs, int iTotalEntries)

	Author:		Kim Harries
	Created:	23/11/2000
	Inputs:		iDeallocatorID - ID of the person doing the dealocating
				piEntryIDs - ptr to an array of entry IDs
				iTotalEntries - total number of items in the array
				piTotalDeallocated - optional output parameter containing the number
					of entries that was successfully deallocated
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Deallocates the specified entries from whichever sub they have currently
				been allocated to, unless they have already been returned.

*********************************************************************************/

bool CStoredProcedure::DeallocateEntriesFromSubs(int iDeallocatorID, int* piEntryIDs, int iTotalEntries)
{
	TDVASSERT(piEntryIDs != NULL, "NULL piEntryIDs in CStoredProcedure::DeallocateEntriesFromSubs(...)");
	TDVASSERT(iTotalEntries > 0, "TotalEntries <= 0 in CStoredProcedure::DeallocateEntriesFromSubs(...)");

	// fail if inappropriate data provided
	if (piEntryIDs == NULL || iTotalEntries == 0)
	{
		return false;
	}

	CTDVString	sTemp;

	StartStoredProcedure("deallocateentriesfromsubs");
	AddParam("deallocatorid", iDeallocatorID);
	for (int i = 0; i < iTotalEntries; i++)
	{
		sTemp = "id";
		sTemp << i;
		AddParam(sTemp, piEntryIDs[i]);
	}

	// Current viewing siteid
	AddParam("currentsiteid", m_SiteID);	

	ExecuteStoredProcedure();
	// return error status
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::GetUserStats(int iUserID)

	Author:		Jim Lynn
	Created:	07/03/2000
	Inputs:		iUserID - ID of the user whose stats should be fetched
	Outputs:	-
	Returns:	true if fields are found, false otherwise
	Fields:		Category  - either 'Guide Entries', 'User Pages' or 'Forum Entries'
				h2g2ID int,
				ForumID int,
				ThreadID int,
				Subject varchar(255),
				Date datetime,
				Newer datetime,
				Replies int,
				Status int,
				OrdNum int

	Purpose:	This stored procedure returns the data for a user page. It returns
				three sections, two concerning guide entries and one concerning
				forums. Since they are two distinct things, not all fields have
				a meaning. If the category is 'Guide Entries' or 'User Pages' then
				the h2g2ID is the ID of the article, and the ForumID and ThreadID
				fields are null. If it's 'Forum Entries' then the h2g2ID field is NULL
				and the ForumID and ThreadID fields are useful.

				The Subject and Date fields are common, and the Newer field is only
				there for forums, giving the date of the newest post.
				Replies is non-zero if there are newer replies.

				Status is the GuideEntry status, which gives you an idea if the user
				is allowed to edit the page.

*********************************************************************************/

bool CStoredProcedure::GetUserStats(int iUserID)
{
	StartStoredProcedure("getuserstats2");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#ifdef __MYSQL__

bool CStoredProcedure::GetThreadList(int ForumID)
{
	CTDVString sQuery;
	sQuery << "SELECT @threadcount := COUNT(*) FROM Threads WHERE ForumID = " << ForumID << " AND VisibleTo IS NULL";
	m_pDBO->ExecuteQuery(sQuery);
	sQuery.Empty();

	sQuery << "SELECT  ThreadID,\
    FirstSubject,\
    JournalOwner,\
    t.LastPosted,\
    @threadcount as ThreadCount,\
    f.SiteID\
	FROM Threads t, Forums f\
	WHERE f.ForumID = t.ForumID\
	AND t.ForumID = " << ForumID << "\
	AND VisibleTo IS NULL\
	ORDER BY t.LastPosted DESC";
	m_pDBO->ExecuteQuery(sQuery);

	return !IsEOF();
}

#else

bool CStoredProcedure::GetThreadList(int ForumID, int iFirstIndex, int iLastIndex, int iThreadOrder)
{
	StartStoredProcedure("forumgetthreadlist");
	AddParam(ForumID);
	AddParam(iFirstIndex);
	AddParam(iLastIndex);
	AddParam(iThreadOrder);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#endif

#ifdef __MYSQL__

bool CStoredProcedure::ForumGetThreadPosts(int ForumID, int ThreadID)
{
	CTDVString sQuery = "SELECT @numposts := COUNT(*) FROM ThreadEntries t\
	INNER JOIN Threads th ON th.ThreadID = t.ThreadID\
	WHERE t.ThreadID = ";
	sQuery << ThreadID << " AND th.VisibleTo IS NULL";
	m_pDBO->ExecuteQuery(sQuery);
	m_pDBO->ExecuteQuery("select @editgroup := GroupID FROM Groups WHERE Name = 'Editor'");
	sQuery.Empty();
	sQuery <<	"SELECT \
			t.ForumID, \
			t.ThreadID, \
			t.UserID as UserID, \
			u.FirstNames, \
			u.LastName, \
			CASE WHEN LTRIM(u.UserName) = '' THEN  CONCAT('Researcher ', u.UserID) ELSE u.UserName END as UserName, \
			CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END as Subject, \
			NextSibling, \
			PrevSibling, \
			Parent, \
			FirstChild, \
			EntryID, \
			DatePosted, \
			Hidden,\
			f.SiteID as SiteID,\
			NULL as Interesting,\
			@numposts as Total,\
			CASE WHEN gm.UserID IS NOT NULL THEN 1 ELSE 0 END as Editor,\
			text \
	FROM ThreadEntries t\
		INNER JOIN blobs b ON t.blobid = b.blobid \
		INNER JOIN Users u ON t.UserID = u.UserID\
		INNER JOIN Threads th ON t.ThreadID = th.ThreadID\
		INNER JOIN Forums f on f.ForumID = t.ForumID\
		LEFT JOIN GroupMembers gm ON gm.UserID = t.UserID AND gm.SiteID = f.SiteID AND gm.GroupID = @editgroup\
	WHERE t.ThreadID = " << ThreadID << " AND th.VisibleTo IS NULL \
	ORDER BY DatePosted";
	m_pDBO->ExecuteQuery(sQuery);
	return !IsEOF();
}

#else

bool CStoredProcedure::ForumGetThreadPosts(int ThreadID, int iFirstIndex, int iLastIndex, bool bOrderByDatePostedDesc/*=false*/)
{
	if (bOrderByDatePostedDesc==true)
	{
		StartStoredProcedure("threadlistposts2_desc");
	}
	else
	{
		StartStoredProcedure("threadlistposts2");
	}	

	AddParam(ThreadID);
	AddParam(iFirstIndex);
	AddParam(iLastIndex);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#endif

bool CStoredProcedure::ForumGetThreadPostHeaders(int ThreadID, int iFirstIndex, int iLastIndex)
{
	StartStoredProcedure("threadlistpostheaders2");
//	StartStoredProcedure("threadlistpostheaders");
	AddParam(ThreadID);
	AddParam(iFirstIndex);
	AddParam(iLastIndex);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#ifdef __MYSQL__

bool CStoredProcedure::FetchGuideEntry(const TDVCHAR* pName, int &oh2g2ID, int &oEntryID, int& oEditor, int &oForumID, int &oStatus, int &oStyle, CTDVDateTime &oDateCreated, CTDVString &oSubject, CTDVString& oText, int& iHidden, int& iSiteID, int& iSubmittable, int& iTypeID)
{
	CTDVString sQuery = "SET @articlename = '";
	sQuery << pName << "', @siteid  = " << iSiteID;
	m_pDBO->ExecuteQuery(sQuery);
	sQuery = "SELECT @entryid := EntryID FROM KeyArticles\
  WHERE ArticleName = @articlename AND DateActive <= NOW() AND SiteID = @siteid\
  ORDER BY DateActive DESC\
  LIMIT 0,1";
	m_pDBO->ExecuteQuery(sQuery);
	sQuery = "SELECT g.EntryID,\
	g.blobid,\
	g.DateCreated,\
	g.DateExpired,\
	g.Subject,\
	g.ForumID,\
	g.h2g2ID,\
	g.Editor,\
	g.Status,\
	g.Style,\
	g.Hidden,\
	g.SiteID,\
	g.Type
	g.Submittable,\
	  1 as IsMainArticle,\
	b.text\
	FROM GuideEntries g, blobs b\
	WHERE g.blobid = b.blobid AND g.EntryID = @entryid";

	m_pDBO->ExecuteQuery(sQuery);
	
	bool bSuccess = false;
	
	// Maybe we've got some article stuff, let's fetch it out
	while (!IsEOF())
	{
		if (GetIntField("IsMainArticle") == 1)
		{
			bSuccess= true;
			oh2g2ID = GetIntField("h2g2ID");
			oEntryID= GetIntField("EntryID");
			oForumID= GetIntField("ForumID");
			oStatus = GetIntField("Status");
			oStyle	= GetIntField("Style");
			oEditor = GetIntField("Editor");
			iSiteID = GetIntField("SiteID");
			iTypeID	= GetIntField("Type");
			iSubmittable = GetIntField("Submittable");
			GetField("Subject",oSubject);
			GetField("text",oText);
			if (IsNULL("Hidden"))
			{
				iHidden = 0;
			}
			else
			{
				iHidden = GetIntField("Hidden");
			}

			oDateCreated = GetDateField("DateCreated");
		}
		MoveNext();
	}
	return bSuccess;
}


#else

bool CStoredProcedure::FetchGuideEntry(const TDVCHAR* pName, int &oh2g2ID, int &oEntryID, int& oEditor, int &oForumID, int &oStatus, int &oStyle, CTDVDateTime &oDateCreated, CTDVString &oSubject, CTDVString& oText, int& iHidden, int& iSiteID, int& iSubmittable, CExtraInfo& ExtraInfo, int& iTypeID,int& iModerationStatus, CTDVDateTime& oLastUpdated, bool& bPreProcessed, bool& bDefaultCanRead, bool& bDefaultCanWrite, bool& bDefaultCanChangePermissions,
									   CTDVDateTime& oDateRangeStart, CTDVDateTime& oDateRangeEnd, int& iRangeInterval, int& iLocationCount)
{
	StartStoredProcedure("getkeyarticlecomponents");
	AddParam(pName);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	
	bool bSuccess = false;
	
	// Maybe we've got some article stuff, let's fetch it out
	while (!IsEOF())
	{
		if (GetIntField("IsMainArticle") == 1)
		{
			bSuccess	= true;
			oh2g2ID		= GetIntField("h2g2ID");
			oEntryID	= GetIntField("EntryID");
			oForumID	= GetIntField("ForumID");
			oStatus		= GetIntField("Status");
			oStyle		= GetIntField("Style");
			oEditor		= GetIntField("Editor");
			iSiteID		= GetIntField("SiteID");
			iSubmittable= GetIntField("Submittable");
			iTypeID		= GetIntField("Type");
			iModerationStatus = GetIntField("ModerationStatus");
			GetField("Subject",oSubject);
			GetField("text",oText);
			CTDVString sExtraInfo;
			GetField("ExtraInfo",sExtraInfo);
			ExtraInfo.Create(iTypeID,sExtraInfo);

			if (IsNULL("Hidden"))
			{
				iHidden = 0;
			}
			else
			{
				iHidden = GetIntField("Hidden");
			}

			oDateCreated = GetDateField("DateCreated");
			oLastUpdated = GetDateField("LastUpdated");
			bPreProcessed = (GetIntField("PreProcessed") > 0);
			bDefaultCanRead				 = (GetIntField("CanRead") > 0);
			bDefaultCanWrite			 = (GetIntField("CanWrite") > 0);
			bDefaultCanChangePermissions = (GetIntField("CanChangePermissions") > 0);

			if (!IsNULL("StartDate"))
			{
				oDateRangeStart = GetDateField("StartDate");
			}
			if (!IsNULL("EndDate"))
			{
				oDateRangeEnd = GetDateField("EndDate");
			}
			if (!IsNULL("TimeInterval"))
			{
				iRangeInterval = GetIntField("TimeInterval");
			}
		}
		MoveNext();
	}
	return bSuccess;
}

#endif

/*********************************************************************************

	bool CStoredProcedure::BeginFetchArticleSubjects()

	Author:		Jim Lynn
	Created:	09/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true
	Purpose:	Tells the stored procedure object that we are going to start
				sending it article IDs so that it can supply the subjects.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::BeginFetchArticleSubjects()
{
	m_sQuery = "SELECT EntryID, CASE\
      WHEN Hidden IS NOT NULL THEN CONCAT('A',h2g2ID) ELSE\
      CASE Subject WHEN '' THEN 'No Subject' ELSE Subject END\
      END as Subject, h2g2ID FROM GuideEntries\
		WHERE h2g2ID IN (";
	//4041, 180343, 134876)
	//AND Status <> 7

	return true;
}

#else

bool CStoredProcedure::BeginFetchArticleSubjects()
{
	StartStoredProcedure("fetcharticles");
	return true;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::AddArticleID(int h2g2ID)

	Author:		Jim Lynn
	Created:	09/03/2000
	Inputs:		h2g2ID - ID of the article whose subject you want to look up
	Outputs:	-
	Returns:	true
	Purpose:	Gives another ID to the stored procedure. You must have called
				BeginFetchArticleSubjects before calling this function, and once
				you have given it all the IDs you should call GetArticleSubject
				to fetch the results.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::AddArticleID(int h2g2ID)
{
	if (m_sQuery[m_sQuery.GetLength()-1] != '(')
	{
		m_sQuery << ",";
	}
	m_sQuery << h2g2ID;
	return true;
}

#else

bool CStoredProcedure::AddArticleID(int h2g2ID)
{
	AddParam(h2g2ID);
	return true;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::GetArticleSubjects(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	09/03/2000
	Inputs:		-
	Outputs:	sResult = string to contain the XML text result
	Returns:	-
	Purpose:	After a call to BeginFetchArticleSubjects and multiple
				calls to AddArticleID, this does the query and wraps up
				the result as multiple <ENTRYLINK> objects which you can then
				wrap up as necessary.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::GetArticleSubjects(CTDVString &sResult)
{
	m_sQuery << ") AND Status <> 7";
	// Fire off the SP and await the result
	m_pDBO->ExecuteQuery(m_sQuery);

	// If you didn't get any results, return false
	if (IsEOF())
	{
		return false;
	}
	
	// start building the XML block
//	sResult << "<ENTRIES>";
	
	// Keep looping until we get EOF
	while (!IsEOF())
	{
		// Get the h2g2ID field
		sResult << "<ENTRYLINK H2G2=\"A" << GetIntField("h2g2ID") 
				<< "\"><H2G2ID>" << GetIntField("h2g2ID") << "</H2G2ID>";
		
		// Fetch the subject field
		CTDVString subject = "";
		GetField("Subject", subject);

		CXMLObject::EscapeXMLText(&subject);
		
		// add it to the XML and close off this ENTRYLINK section
		sResult << "<SUBJECT>" << subject << "</SUBJECT></ENTRYLINK>";
		
		// fetch the next row
		MoveNext();
	}
	
	// Close the H2G2LINKS section
//	sResult << "</ENTRIES>\n";
	return true;
}

#else

bool CStoredProcedure::GetArticleSubjects(CTDVString &sResult)
{
	// Fire off the SP and await the result
	ExecuteStoredProcedure();
	// If you didn't get any results, return false
	if (IsEOF())
	{
		return false;
	}
	
	// start building the XML block
//	sResult << "<ENTRIES>";
	
	// Keep looping until we get EOF
	while (!IsEOF())
	{
		// Get the h2g2ID field
		sResult << "<ENTRYLINK H2G2=\"A" << GetIntField("h2g2ID") 
				<< "\"><H2G2ID>" << GetIntField("h2g2ID") << "</H2G2ID>";
		
		// Fetch the subject field
		CTDVString subject = "";
		GetField("Subject", subject);

		CXMLObject::EscapeXMLText(&subject);
		
		// add it to the XML and close off this ENTRYLINK section
		sResult << "<SUBJECT>" << subject << "</SUBJECT></ENTRYLINK>";
		
		// fetch the next row
		MoveNext();
	}
	
	// Close the H2G2LINKS section
//	sResult << "</ENTRIES>\n";
	return true;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::GetResearchersFromH2G2id(int ih2g2ID)

	Author:		Oscar Gillespie
	Created:	04/04/2000
	Inputs:		ih2g2ID - the id of an article
	Outputs:	- 
	Returns:	true for success or false for failure
	Purpose:	fetch a list of researchers that worked on the article

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::GetResearchersFromH2G2id(int ih2g2ID)
{
	CTDVString sQuery;
	sQuery << "SELECT DISTINCT u.UserName, u.UserID\
	FROM GuideEntries g LEFT JOIN Researchers r ON r.EntryID = g.EntryID\
	LEFT JOIN Users u ON u.UserID = r.UserID OR u.UserID = g.Editor\
	WHERE g.h2g2ID = " << ih2g2ID;
	m_pDBO->ExecuteQuery(sQuery);
	return !IsEOF();
}

#else

bool CStoredProcedure::GetResearchersFromH2G2id(int ih2g2ID)
{
	StartStoredProcedure("getauthorsfromh2g2id");
	AddParam("h2g2id",ih2g2ID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#endif


/*********************************************************************************

	bool CStoredProcedure::GetGroupsFromUserAndSite(int iUserID, int iSiteID)

	Author:		Mark Neves
	Created:	06/10/2003
	Inputs:		iUserID
				iSiteID
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetGroupsFromUserAndSite(int iUserID, int iSiteID)
{
	StartStoredProcedure("getgroupsfromuserandsite");
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetEntrySubjectFromh2g2ID(int ih2g2ID, CTDVString& sResult)

	Author:		Oscar Gillespie
	Created:	22/03/2000
	Inputs:		ih2g2ID - the h2g2 ID number of a GuideEntry
	Outputs:	sResult = string to contain the XML text result
	Returns:	-
	Purpose:	if ih2g2ID is valid, the function lets the user know what the subject
				of that entry is.

*********************************************************************************/

bool CStoredProcedure::GetEntrySubjectFromh2g2ID(int ih2g2ID, CTDVString& sResult)
{
	StartStoredProcedure("getsubjectfromh2g2id");
	AddParam(ih2g2ID);
	ExecuteStoredProcedure();
	
	bool bSuccess = false;
	
	// look for the subject
	if (!IsEOF())
	{
		bSuccess = GetField("Subject", sResult);
	}
	return bSuccess;

}

/*********************************************************************************

	int CStoredProcedure::GetEntryStatusFromh2g2ID(int ih2g2ID)

	Author:		Oscar Gillespie
	Created:	22/03/2000
	Modified:	10/07/2000
	Inputs:		ih2g2ID - the h2g2 ID number of a GuideEntry
	Outputs:	-
	Returns:	the status of this article if it exists (otherwise 0)
	Purpose:	if ih2g2ID is valid, the function lets the user know what the status
				of that entry is.
				I daren't try to explain the various status numbers and their meanings
				since this list may grow or change.

*********************************************************************************/

int CStoredProcedure::GetEntryStatusFromh2g2ID(int ih2g2ID)
{
	StartStoredProcedure("getstatusfromh2g2id");
	AddParam(ih2g2ID);
	ExecuteStoredProcedure();
	
	int iStatusOfArticle = 0;

	// look for the status
	if (!IsEOF())
	{
		iStatusOfArticle = GetIntField("status");
	}	

	return iStatusOfArticle;
}


/*********************************************************************************

	bool CStoredProcedure::BeginFetchUserNames()

	Author:		Jim Lynn
	Created:	09/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true
	Purpose:	Tells the stored procedure object that we are going to start
				sending it User IDs so that it can supply the usernames.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::BeginFetchUserNames()
{
	m_sQuery = "	SELECT UserName, UserID FROM Users\
		WHERE UserID IN (";
		return true;
}

#else

bool CStoredProcedure::BeginFetchUserNames()
{
	StartStoredProcedure("getusernames");
	return true;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::AddUserID(int iUserID)

	Author:		Jim Lynn
	Created:	09/03/2000
	Inputs:		iUserID - ID of the user whose Username you want to look up
	Outputs:	-
	Returns:	true
	Purpose:	Gives another ID to the stored procedure. You must have called
				BeginFetchUserNames before calling this function, and once
				you have given it all the IDs you should call GetUserNames
				to fetch the results.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::AddUserID(int iUserID)
{
	if (m_sQuery[m_sQuery.GetLength()-1] != '(')
	{
		m_sQuery << ",";
	}
	m_sQuery << iUserID;
	return true;
}

#else

bool CStoredProcedure::AddUserID(int iUserID)
{
	AddParam(iUserID);
	return true;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::GetUserNames(CTDVString &sResult)

	Author:		Jim Lynn
	Created:	09/03/2000
	Inputs:		-
	Outputs:	sResult = string to contain the XML text result
	Returns:	-
	Purpose:	After a call to BeginFetchUserNames and multiple
				calls to AddUserID, this does the query and wraps up
				the result as multiple <USERLINK> objects which you can then
				wrap up as necessary.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::GetUserNames(CTDVString &sResult)
{
	m_sQuery << ")";
	m_pDBO->ExecuteQuery(m_sQuery);

	// If you didn't get any results, return false
	if (IsEOF())
	{
		return false;
	}

	// start building the XML block
//	sResult << "<USERS>";
		
	// Keep looping until we get EOF
	while (!IsEOF())
	{
		// Get the h2g2ID field
		sResult << "<USERLINK H2G2=\"U" << GetIntField("UserID") 
				<< "\"><USERID>" << GetIntField("UserID") << "</USERID>";
		
		// Fetch the UserName field
		CTDVString UserName = "";
		GetField("UserName", UserName);

		// add it to the XML and close off this ENTRYLINK section
		sResult << "<USERNAME>" << UserName << "</USERNAME></USERLINK>";
		
		// fetch the next row
		MoveNext();
	}
	
	// Close the USERLINKS section
//	sResult << "</USERS>\n";

	return true;
}

#else

bool CStoredProcedure::GetUserNames(CTDVString &sResult)
{
	// Fire off the SP and await the result
	ExecuteStoredProcedure();

	// If you didn't get any results, return false
	if (IsEOF())
	{
		return false;
	}

	// start building the XML block
//	sResult << "<USERS>";
		
	// Keep looping until we get EOF
	while (!IsEOF())
	{
		// Get the h2g2ID field
		sResult << "<USERLINK H2G2=\"U" << GetIntField("UserID") 
				<< "\"><USERID>" << GetIntField("UserID") << "</USERID>";
		
		// Fetch the UserName field
		CTDVString UserName = "";
		GetField("UserName", UserName);

		// add it to the XML and close off this ENTRYLINK section
		sResult << "<USERNAME>" << UserName << "</USERNAME></USERLINK>";
		
		// fetch the next row
		MoveNext();
	}
	
	// Close the USERLINKS section
//	sResult << "</USERS>\n";

	return true;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::GetUsersMostRecentEntries(int iUserID, int iMaxNumber)

	Author:		Kim Harries
	Created:	09/03/2000
	Modified:	08/04/2000
	Inputs:		iUserID - ID of the user whose guide entries should be fetched
				bApprovedOnly - set to true to only get approved entries
				iMaxNumber - the max number of entries to get
	Outputs:	-
	Returns:	true if executed successfully, false if an error occurred
	Fields:		h2g2ID int,
				Subject varchar(255),
				Status int,
				DateCreated datetime

	Purpose:	Fetches a list of the users most recent guide entries, in order of
				most recent first. Only gets the minimal data on these, i.e. ID,
				subject, and date created. Primarily used to supply a list of links
				to a users guide entries on their home page.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::GetUsersMostRecentEntries(int iUserID, int iWhichType, int iSiteID)
{
	m_sQuery.Empty();
	if (iWhichType == 1)
	{
		m_sQuery << "(SELECT DISTINCT\
	  g.h2g2ID as h2g2ID,\
	   CASE\
		  WHEN g.Hidden IS NOT NULL THEN '' ELSE\
		  CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END\
		  END as Subject,\
	   g.Status as Status,\
	   g.DateCreated as DateCreated,\
	   g.SiteID,\
	   g.Editor,\
	   u.UserID,\
	   u.UserName\
	FROM GuideEntries g\
	INNER JOIN Users u ON u.UserID = g.Editor\
	LEFT JOIN Researchers r ON r.EntryID = g.EntryID\
	WHERE (((Editor = "<< iUserID << ")\
	  AND g.Status = 1)) ";
		if (iSiteID != 0)
		{
			m_sQuery << "AND (g.SiteID = " << iSiteID << ") ";
		}
		m_sQuery << "\
	)\
	UNION\
	(\
	SELECT DISTINCT\
	  g.h2g2ID as h2g2ID,\
	   CASE\
		  WHEN g.Hidden IS NOT NULL THEN '' ELSE\
		  CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END\
		  END as Subject,\
	   g.Status as Status,\
	   g.DateCreated as DateCreated,\
	   g.SiteID,\
	   g.Editor,\
	   u.UserID,\
	   u.UserName\
	FROM GuideEntries g\
	INNER JOIN Researchers r ON r.EntryID = g.EntryID\
	INNER JOIN Users u ON u.UserID = r.UserID\
	WHERE (((r.UserID = " << iUserID << " AND r.UserID <> g.Editor)\
	  AND g.Status = 1)) ";
		if (iSiteID != 0)
		{
			m_sQuery << "AND (g.SiteID = " << iSiteID << ") ";
		}
		m_sQuery << "\
	)\
	ORDER BY DateCreated DESC";
	}
	else if (iWhichType == 2)
	{
		m_sQuery << "(SELECT DISTINCT\
	  g.h2g2ID as h2g2ID,\
	   CASE\
		  WHEN g.Hidden IS NOT NULL THEN '' ELSE\
		  CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END\
		  END as Subject,\
	   g.Status as Status,\
	   g.DateCreated as DateCreated,\
	   g.SiteID,\
	   g.Editor,\
	   u.UserID,\
	   u.UserName\
	FROM GuideEntries g\
	INNER JOIN Users u ON u.UserID = g.Editor\
	LEFT JOIN Researchers r ON r.EntryID = g.EntryID\
	WHERE (((Editor = "<< iUserID << ")\
	  AND g.Status IN (3,4,5,6,11,12,13,4))) ";
		if (iSiteID != 0)
		{
			m_sQuery << "AND (g.SiteID = " << iSiteID << ") ";
		}
		m_sQuery << "\
	)\
	UNION\
	(\
	SELECT DISTINCT\
	  g.h2g2ID as h2g2ID,\
	   CASE\
		  WHEN g.Hidden IS NOT NULL THEN '' ELSE\
		  CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END\
		  END as Subject,\
	   g.Status as Status,\
	   g.DateCreated as DateCreated,\
	   g.SiteID,\
	   g.Editor,\
	   u.UserID,\
	   u.UserName\
	FROM GuideEntries g\
	INNER JOIN Researchers r ON r.EntryID = g.EntryID\
	INNER JOIN Users u ON u.UserID = r.UserID\
	WHERE (((r.UserID = " << iUserID << " AND r.UserID <> g.Editor)\
	  AND g.Status IN (3,5,6,11,12,13))) ";
		if (iSiteID != 0)
		{
			m_sQuery << "AND (g.SiteID = " << iSiteID << ") ";
		}
		m_sQuery << "\
	)\
	ORDER BY DateCreated DESC";
	}
	else
	{
		m_sQuery << "SELECT DISTINCT\
	  g.h2g2ID as h2g2ID,\
	   CASE\
		  WHEN g.Hidden IS NOT NULL THEN '' ELSE\
		  CASE g.Subject WHEN '' THEN 'No Subject' ELSE g.Subject END\
		  END as Subject,\
	   g.Status as Status,\
	   g.DateCreated as DateCreated,\
	   g.SiteID,\
	   g.Editor,\
	   u.UserID,\
	   u.UserName\
	FROM GuideEntries g\
	INNER JOIN Users u ON u.UserID = g.Editor\
	WHERE (((Editor = "<< iUserID << ")\
	  AND g.Status = 7)) ";
		if (iSiteID != 0)
		{
			m_sQuery << "AND (g.SiteID = " << iSiteID << ") ";
		}
		m_sQuery << "\
	ORDER BY DateCreated DESC";
	}

	m_pDBO->ExecuteQuery(m_sQuery);
//	AddParam(iUserID);
//	AddParam(iSiteID);
//	ExecuteStoredProcedure();
	CTDVString temp;
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

#else

bool CStoredProcedure::GetUsersMostRecentEntries(int iUserID, int iWhichType, int iSiteID, int iGuideType)
{
	// Check to see which procedures to call
	// This depends on the iWhichType and iGuideType parameters
	if (iGuideType > 0)
	{
		// We've been given a GuideType to filter on, call the relavent procedure depending on the status type
		if (iWhichType == CArticleList::ARTICLELISTTYPE_APPROVED)
		{
			StartStoredProcedure("getuserrecentapprovedentrieswithguidetype");
		}
		else if (iWhichType == CArticleList::ARTICLELISTTYPE_NORMAL)
		{
			StartStoredProcedure("getuserrecententrieswithguidetype");
		}
		else if (iWhichType == CArticleList::ARTICLELISTTYPE_NORMALANDAPPROVED)
		{
			StartStoredProcedure("getuserrecentandapprovedentrieswithguidetype");
		}
		else
		{
			StartStoredProcedure("getusercancelledentrieswithguidetype");
		}

		// Now add the guide type as a parameter
		AddParam("guidetype",iGuideType);
	}
	else
	{
		// Just call the relavent procedure depending on the status type
		if (iWhichType == CArticleList::ARTICLELISTTYPE_APPROVED)
		{
			StartStoredProcedure("getuserrecentapprovedentries");
		}
		else if (iWhichType == CArticleList::ARTICLELISTTYPE_NORMAL)
		{
			StartStoredProcedure("getuserrecententries");
		}
		else if (iWhichType == CArticleList::ARTICLELISTTYPE_NORMALANDAPPROVED)
		{
			StartStoredProcedure("getuserrecentandapprovedentries");
		}
		else
		{
			StartStoredProcedure("getusercancelledentries");
		}
	}

	// add the common procedure paramters!
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	AddParam("currentsiteid", m_SiteID);	// Current viewing siteid
	ExecuteStoredProcedure();
	CTDVString temp;
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);}

#endif
/*********************************************************************************

	bool CStoredProcedure::GetUsersMostRecentPosts(int iUserID)

	Author:		Kim Harries
	Created:	09/03/2000
	Inputs:		iUserID - ID of the user whose guide entries should be fetched
				iMaxNumber - the max number of entries to get
	Outputs:	-
	Returns:	true if fields are found, false otherwise
	Fields:		ForumID		int,
				ThreadID	int,
				Subject		varchar(255),
				Date		datetime,
				Newer		datetime,
				Replies		bool

	Purpose:	Fetches a list of the users most recent thread entries, in order of
				most recent first. Also returns if there has been a reply in this
				thread and how recent it is.

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::GetUsersMostRecentPosts(int iUserID)
{
	m_sQuery.Empty();
	m_sQuery << "    SELECT t.ThreadID, f.FirstSubject, t.ForumID, u.UserName, t.LastUserPosting as MostRecent, t.LastPosting as LastReply, t.Replies, t.LastUserPostID as YourLastPost, fo.SiteID, fo.Title, u1.UserID as Journal, u1.UserName as JournalName\
    FROM ThreadPostings t\
    INNER JOIN Users u\
      ON u.UserID = t.UserID\
    INNER JOIN Threads f\
      ON f.ThreadID = t.ThreadID\
    INNER JOIN Forums fo\
      ON fo.ForumID = t.ForumID\
    LEFT JOIN Users u1 ON fo.JournalOwner = u1.UserID\
    WHERE t.UserID = " << iUserID << " AND f.VisibleTo IS NULL\
    ORDER BY LastReply DESC";
	m_pDBO->ExecuteQuery(m_sQuery);
	return !IsEOF();
}

#else

/*********************************************************************************

	bool CStoredProcedure::GetUsersMostRecentPosts(int iUserID, int iPostType)

	Author:		Mark Howitt
    Created:	20/05/2005
    Inputs:		iUserID - The Id of the user you want to get the posts for
				iPostType - The type of post you want to look for. If this
							is 0 then it gets all posts
				iSiteId - Apply a filter for the given siteid.

    Outputs:	-
    Returns:	true if ok, false if not
    Purpose:	Fetches all the post for a given user. Optionaly gets posts of a given type

*********************************************************************************/

bool CStoredProcedure::GetUsersMostRecentPosts(int iUserID, int iPostType, int iMaxResults,bool bShowUserHidden, int iSiteId )
{
	// Check to see what type of post we're looking for!
	if (iPostType == 1)
	{
		// We want all the users notices
		StartStoredProcedure("getallusernoticepostings");
		AddParam("showuserhidden", bShowUserHidden);
	}
	else if (iPostType == 2)
	{
		// We want all the users events
		StartStoredProcedure("getallusereventpostings");
		AddParam("showuserhidden",bShowUserHidden);
	}
	else
	{
		// Just get all the posts in order
		if (m_pCGI->IsCurrentSiteMessageboard())
		{
			StartStoredProcedure("getalluserpostingstatsbasic");
		}
		else
		{
			StartStoredProcedure("getalluserpostingstats3");
		}
		AddParam("maxresults",iMaxResults);
	}

	AddParam("siteid",iSiteId);
	AddParam("userid",iUserID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#endif

/*********************************************************************************

	int CStoredProcedure::ForumGetLatestThreadID(int iForumID)

	Author:		Jim Lynn
	Created:	19/09/2000
	Inputs:		iForumID - ID of the forum
	Outputs:	-
	Returns:	ID of the thread which was most recently updated
	Purpose:	Used in the forum code when only a forum has been specified 
				in the URL. The most recent thread is displayed in this case.

*********************************************************************************/

int CStoredProcedure::ForumGetLatestThreadID(int iForumID)
{
	StartStoredProcedure("getmostrecentforumthread");
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return 0;
	}
	else
	{
		return GetIntField("ThreadID");
	}
}

/*********************************************************************************

	bool CStoredProcedure::ForumGetSource(int& iForumID, int &iType, int &ID, CTDVString &sTitle, int &iSiteID, int &iUserID, int &iReviewForumID)

	Author:		Jim Lynn
	Created:	10/03/2000
	Inputs:		iForumID - ID of forum to fetch details for
	Outputs:	iType - 0 if it's a user journal, 1 if it's an article, 2 if it's a user page
	Returns:	-
	Purpose:	-

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::ForumGetSource(int& iForumID, int iThreadID, int &iType, int &ID, CTDVString &sTitle, int &iSiteID, int &iUserID, int &iReviewForumID)
{
	CTDVString sQuery;
	if (iThreadID == 0)
	{
	sQuery = "SELECT JournalOwner, u.UserName as JournalUserName, u1.UserID, u1.UserName as UserName, CASE WHEN g.h2g2ID IS NOT NULL THEN g.h2g2ID ELSE u.Masthead END as h2g2ID, g.Subject, f.SiteID, r.ReviewForumID, r.ForumName as ReviewForumName\
	FROM Forums f\
	LEFT JOIN GuideEntries g ON g.ForumID = f.ForumID\
	LEFT JOIN Users u1 ON g.h2g2ID = u1.Masthead\
	LEFT JOIN Users u ON u.UserID = f.JournalOwner\
	LEFT JOIN ReviewForums r ON r.h2g2ID = g.h2g2ID\
	WHERE f.ForumID = ";
	sQuery << iForumID << " LIMIT 0,1";
	}
	else
	{
	sQuery = "SELECT JournalOwner, u.UserName as JournalUserName, u1.UserID, u1.UserName as UserName, CASE WHEN g.h2g2ID IS NOT NULL THEN g.h2g2ID ELSE u.Masthead END as h2g2ID, g.Subject, f.SiteID, r.ReviewForumID, r.ForumName as ReviewForumName\
	FROM Forums f\
	INNER JOIN Threads t ON f.ForumID = t.ForumID\
	LEFT JOIN GuideEntries g ON g.ForumID = f.ForumID\
	LEFT JOIN Users u1 ON g.h2g2ID = u1.Masthead\
	LEFT JOIN Users u ON u.UserID = f.JournalOwner\
	LEFT JOIN ReviewForums r ON r.h2g2ID = g.h2g2ID\
\
	WHERE t.ThreadID = ";
	sQuery << iThreadID << " LIMIT 0,1";
	}
	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}
	else
	{
		iSiteID = GetIntField("SiteID");

		if (GetIntField("JournalOwner") > 0)
		{
			ID = GetIntField("h2g2ID");
			GetField("JournalUserName",sTitle);
			iType = 0;
			iUserID = GetIntField("JournalOwner");
			iReviewForumID = 0;
			return true;
		}
		else if (GetIntField("UserID") > 0)
		{
			ID = GetIntField("h2g2ID");
			iUserID = GetIntField("UserID");
			GetField("UserName", sTitle);
			iReviewForumID = 0;
			iType = 2;
			return true;
		}
		else if (!IsNULL("ReviewForumID"))
		{
			ID = GetIntField("h2g2ID");
			iReviewForumID = GetIntField("ReviewForumID");
			GetField("ReviewForumName", sTitle);
			iUserID = 0;
			iType = 3;
			return true;
		}
		else
		{
			ID = GetIntField("h2g2ID");
			GetField("Subject", sTitle);
			iUserID = 0;
			iReviewForumID = 0;
			iType = 1;
			return true;
		}
	}

}

#else

bool CStoredProcedure::ForumGetSource(int& iForumID, int iThreadID, int &iType, int &ID, CTDVString &sTitle, int &iSiteID, int &iUserID, int &iReviewForumID, int &iClubID, int &iAlertInstantly, CTDVString & sFirstNames, CTDVString & sLastName, CTDVString & sArea, int & nStatus, int & nTaxonomyNode, int & nJournal, int & nActive, CTDVString & sSiteSuffix, CTDVString & sSiteTitle, int& iHiddenStatus, int& iArticleStatus, CTDVString& sUrl)
{
	StartStoredProcedure("getforumsource");
	AddParam(iForumID);
	AddParam(iThreadID);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		nStatus = 0;
		nTaxonomyNode = 0;
		nJournal = 0;
		nActive = 0;
		sFirstNames = "";
		sLastName = "";
		sArea = "";
		sSiteSuffix = "";
		sSiteTitle = "";

		iSiteID = GetIntField("SiteID");
		iForumID = GetIntField("ForumID");
		iHiddenStatus = GetIntField("Hidden");

		if (GetIntField("JournalOwner") > 0)
		{
			ID = GetIntField("h2g2ID");
			iAlertInstantly = GetIntField("AlertInstantly");
			GetField("JournalUserName",sTitle);
			iType = GetIntField("Type");
			iUserID = GetIntField("JournalOwner");
			iReviewForumID = 0;
			GetField("JournalFirstNames", sFirstNames);
			GetField("JournalLastName", sLastName);
			GetField("JournalArea", sArea);
			GetField("JournalSiteSuffix", sSiteSuffix);
			GetField("JournalTitle", sSiteTitle);
			nStatus = GetIntField("JournalStatus");
			nTaxonomyNode = GetIntField("JournalTaxonomyNode");
			nJournal = GetIntField("JournalJournal");
			nActive = GetIntField("JournalActive");
			iHiddenStatus = GetIntField("HiddenStatus");
			iArticleStatus = GetIntField("ArticleStatus");

			return true;
		}
		else if (GetIntField("UserID") > 0)
		{
			ID = GetIntField("h2g2ID");
			iAlertInstantly = GetIntField("AlertInstantly");
			iUserID = GetIntField("UserID");
			GetField("UserName", sTitle);
			iReviewForumID = 0;
			iType = GetIntField("Type");
			GetField("FirstNames", sFirstNames);
			GetField("LastName", sLastName);
			GetField("Area", sArea);
			GetField("SiteSuffix", sSiteSuffix);
			GetField("Title", sSiteTitle);
			nStatus = GetIntField("Status");
			nTaxonomyNode = GetIntField("TaxonomyNode");
			nJournal = GetIntField("Journal");
			nActive = GetIntField("Active");
			iHiddenStatus = GetIntField("HiddenStatus");
			iArticleStatus = GetIntField("ArticleStatus");

			return true;
		}
		else if (!IsNULL("ReviewForumID"))
		{
			ID = GetIntField("h2g2ID");
			iAlertInstantly = GetIntField("AlertInstantly");
			iReviewForumID = GetIntField("ReviewForumID");
			GetField("ReviewForumName", sTitle);
			iHiddenStatus = GetIntField("HiddenStatus");
			iArticleStatus = GetIntField("ArticleStatus");
			iUserID = 0;
			iType = GetIntField("Type");
			return true;
		}
		else if (!IsNULL("ClubID"))
		{
			iClubID = GetIntField("ClubID");
			iAlertInstantly = GetIntField("AlertInstantly");
			ID = GetIntField("ClubH2G2ID");
			GetField("ClubName", sTitle);
			iUserID = 0;
			iType = GetIntField("Type");
			iReviewForumID = 0;
			iHiddenStatus = GetIntField("ClubHiddenStatus");
			iArticleStatus = GetIntField("ClubArticleStatus");
			return true;
		}
		else if (!IsNULL("URL"))
		{
			iType = GetIntField("Type");
			GetField("URL", sUrl);
			return true;
		}
		else
		{
			ID = GetIntField("h2g2ID");
			iAlertInstantly = GetIntField("AlertInstantly");
			GetField("Subject", sTitle);
			iUserID = 0;
			iReviewForumID = 0;
			iType = GetIntField("Type");
			iHiddenStatus = GetIntField("HiddenStatus");
			iArticleStatus = GetIntField("ArticleStatus");
			return true;
		}
	}

}

#endif

	
/*********************************************************************************

	bool CStoredProcedure::GetForumSiteID(int iForumID, int iThreadID,int &iSiteID)

	Author:		Dharmesh Raithatha
	Created:	5/22/2003
	Inputs:		iForumID - Forum that you are looking for
				iThreadID - Thread to find its owning forum (takes precedence)
	Outputs:	iSiteID - SiteID of the forum, 0 if forum not found
	Returns:	true is storedprocedure successful, false otherwise
	Purpose:	Finds the siteId from the given forum or threadid

*********************************************************************************/

bool CStoredProcedure::GetForumSiteID(int& iForumID, int iThreadID,int &iSiteID)
{
	StartStoredProcedure("GetForumSiteID");
	AddParam(iForumID);
	AddParam(iThreadID);
	ExecuteStoredProcedure();

	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetForumSiteID "; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	if (IsEOF())
	{
		iSiteID = 0;
	}
	else
	{
		iSiteID = GetIntField("SiteID");
		iForumID = GetIntField("ForumID");
	}

	return true;

}


/*********************************************************************************

	bool CreateNewClub(const TDVCHAR* sClubTitle, int iCreator, 
					   int iOpenMembership, int iSiteID,const TDVCHAR* sBody,
					   CExtraInfo& ExtraInfo, int &oClubID, int &oH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	5/29/2003
	Inputs:		sClubTitle - Title of the club
				iCreator - Creator of the club
				iOpenMembership - 1 for open, 0 for closed membership
				iSiteID - site in which the club is created
				sBody - the text for the club that will go in the clubs internal
						entry
				ExtraInfo - a create extrainfo object to be stored with the body
							text
	Outputs:	oClubID - Id of the created club
				oH2G2ID - ID of the guide entry used within the club
	Returns:	true if successful, false otherwise
	Purpose:	Creates a new club

*********************************************************************************/

bool CStoredProcedure::CreateNewClub(const TDVCHAR* sClubTitle, int iCreator, 
									 int iOpenMembership, int iSiteID,const TDVCHAR* sBody,
									 CExtraInfo& ExtraInfo,int &oClubID, int &oH2G2ID, 
									 int &oOwnerTeam)
{
	TDVASSERT(ExtraInfo.IsCreated(),"CStoredProcedure::CreateNewClub() ExtraInfo is not created");

	CTDVString sInfo;
	
	if (!ExtraInfo.GetInfoAsXML(sInfo))
	{
		CTDVString sMessage = "Info Error occurred in CStoredProcedure::CreateNewClub "; 
		TDVASSERT(false, sMessage);
		return false;
	}

	StartStoredProcedure("createnewclub");
	AddParam(sClubTitle);
	AddParam(iCreator);
	AddParam(iOpenMembership);
	AddParam(iSiteID);
	AddParam(sBody);
	AddParam(sInfo);

	// MarkH 10/11/03 - Create a hash value for this entry. This enables us to check to see if we've
	//					already submitted any duplicates
	CTDVString sHash;
	CTDVString sSource;
	sSource << sClubTitle << "<:>" << sBody << "<:>" << iCreator << "<:>" << iSiteID << "<:>" << iOpenMembership;
	GenerateHash(sSource, sHash);

	// Add the UID to the param list
	if (!AddUIDParam("hash",sHash))
	{
		return false;
	}

	ExecuteStoredProcedure();
	
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CreateNewClub "; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	oClubID		= GetIntField("ClubID");
	oH2G2ID		= GetIntField("h2g2id");
	oOwnerTeam	= GetIntField("OwnerTeam");

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchCurrentUsers(CTDVString &sResult, int iSiteID)

	Author:		Oscar Gillespie
	Created:	10/03/2000
	Modified:	14/03/2000
	Inputs:		-
	Outputs:	sResult carries an XML representation of the results
				back to the caller.
	Returns:	true if fields are found, false otherwise
	Fields:		int UserID
				varchar(255) UserName
				datetime datejoined
	Purpose:	Fetches a list of users that are currently online

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::FetchCurrentUsers(CTDVString &sResult, int iSiteID, bool bSiteOnly)
{
	CTDVString sQuery;
	sQuery << "SELECT DISTINCT u.* , CASE WHEN g.groupid IS NOT NULL THEN 1 ELSE 0 END as editor\
	FROM Users u\ 
	INNER JOIN Sessions s ON u.UserID = s.UserID AND UNIX_TIMESTAMP(DateLastLogged) > (UNIX_TIMESTAMP() - 15*60)"
	if ( bSiteOnly )
	{
		sQuery << " AND SiteID =" << iSiteID;
	}
	sQuery << " INNER JOIN Groups gr ON gr.name = 'editor' and USERINFO = 1\
	LEFT JOIN GroupMembers g ON g.userid = u.UserID AND g.GroupID = gr.GroupID AND g.siteid = " << iSiteID;
	
	m_pDBO->ExecuteQuery(sQuery);

	// If you didn't get any results, return false
	if (IsEOF())
	{
		return false;
	}
	
	// Keep looping until we get EOF
	// generate XML for each online user as we go
	while (!IsEOF())
	{
		sResult << "<ONLINEUSER><USER>";
		
		// add his/her user id
		int iUserID = 0;
		iUserID = GetIntField("UserID");

		sResult << "<USERID>" << iUserID << "</USERID>";

		int iEditor = GetIntField("Editor");
		sResult << "<EDITOR>" << iEditor << "</EDITOR>";
		
		// add his/her user name
		CTDVString sUserName = "";
		GetField("UserName", sUserName);
		CXMLObject::EscapeXMLText(&sUserName);
		if (sUserName.GetLength() == 0)
		{
			sUserName << "Member " << iUserID;
		}
		sResult << "<USERNAME>";
		
		sResult << sUserName;

		sResult << "</USERNAME></USER>";

		// get a representation of the date a user joined and the current date
		CTDVDateTime dtDateJoined = GetDateField("DateJoined");
		CTDVDateTime dtCurrentTime = dtCurrentTime.GetCurrentTime();

		// and subtract the date joined from the current time giving a date span
		COleDateTimeSpan dtsHowLongAgo = dtCurrentTime - dtDateJoined;

		// add the information about how long it is since they joined to the block
		sResult << "<DAYSSINCEJOINED>";

		sResult << dtsHowLongAgo.GetTotalDays();

		sResult << "</DAYSSINCEJOINED>";


		sResult << "</ONLINEUSER>";
		
		// fetch the next row
		MoveNext();
	}
	
	// no problems encountered so we return success
	return true;
}


#else

bool CStoredProcedure::FetchCurrentUsers(CTDVString &sResult, int iSiteID, bool bSiteOnly)
{
	StartStoredProcedure("currentusers");
	AddParam(iSiteID);

	if ( bSiteOnly )
	{
		AddParam("currentsiteonly",bSiteOnly);
	}

	// Fire off the SP and await the result
	ExecuteStoredProcedure();

	if ( HandleError("FetchCurrentUsers") )
	{
		return false;
	}

	// If you didn't get any results, return false
	if (IsEOF())
	{
		return false;
	}
	
	// Keep looping until we get EOF
	// generate XML for each online user as we go
	while (!IsEOF())
	{
		sResult << "<ONLINEUSER><USER>";
		
		// add his/her user id
		int iUserID = 0;
		iUserID = GetIntField("UserID");

		sResult << "<USERID>" << iUserID << "</USERID>";

		int iEditor = GetIntField("Editor");
		sResult << "<EDITOR>" << iEditor << "</EDITOR>";
		
		// add his/her user name
		CTDVString sUserName = "";
		GetField("UserName", sUserName);
		CXMLObject::EscapeXMLText(&sUserName);
		if (sUserName.GetLength() == 0)
		{
			sUserName << "Member " << iUserID;
		}
		sResult << "<USERNAME>";
		
		sResult << sUserName;

		sResult << "</USERNAME></USER>";

		// get a representation of the date a user joined and the current date
		CTDVDateTime dtDateJoined = GetDateField("DateJoined");
		CTDVDateTime dtCurrentTime = dtCurrentTime.GetCurrentTime();

		// and subtract the date joined from the current time giving a date span
		COleDateTimeSpan dtsHowLongAgo = dtCurrentTime - dtDateJoined;

		// add the information about how long it is since they joined to the block
		sResult << "<DAYSSINCEJOINED>";

		sResult << dtsHowLongAgo.GetTotalDays();

		sResult << "</DAYSSINCEJOINED>";


		sResult << "</ONLINEUSER>";
		
		// fetch the next row
		MoveNext();
	}
	
	// no problems encountered so we return success
	return true;
}

#endif

/*********************************************************************************

	bool CStoredProcedure::FetchBlobServerPath(int iBlobID, const TDVCHAR* sBGColour, CTDVString &sResult)

	Author:		Oscar Gillespie
	Created:	14/03/2000
	Inputs:		-
	Outputs:	sResult will hold the xml with the url where the specified binary file can be found
	Returns:	true if the blob is found, false otherwise
	Fields:		blobid int,
				mimetype varchar(255),
				ServerName varchar(255),
				Path varchar(255)
  
	Purpose:	Function to use a StoredProcedure to get the path pointing to the 
				specified BLOb and its MimeType wrapped up in a piece of XML

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::FetchBlobServerPath(int iBlobID, const TDVCHAR* pBGColour, CTDVString &sResult)
{
	CTDVString sBGColour = pBGColour;

	m_sQuery.Empty();
	m_sQuery << "SELECT blobid, mimetype, ServerName,\
   CASE\
    WHEN bitfield IS NOT NULL\
    AND (Colourbits & bitfield) = bitfield\
     AND (LOCATE('\\\\',Path)>0)\
     THEN INSERT(Path, LOCATE('\\\\',Path) ,1 ,CONCAT('\\\\', '" << pBGColour << "' ,'\\\\'))\
       ELSE Path\
  END as Path\
	FROM blobs LEFT JOIN SkinColours s ON s.Name = '" << pBGColour << "'\
	WHERE blobid = " << iBlobID;
	m_pDBO->ExecuteQuery(m_sQuery);

	bool bSuccess = true; // success bit

	// If you didn't get any results, return false
	if (IsEOF())
	{
		bSuccess = false;
	}
	
	int iConfirmBlobID = 0;
	if (bSuccess)
	{
		iConfirmBlobID = GetIntField("blobid");
		if (iConfirmBlobID == 0) bSuccess = false;
		TDVASSERT(iConfirmBlobID == iBlobID, "CStoredProcedure::FetchBlobServerPath went wrong... got the blob ID wrong :)");
	}

	CTDVString sMimeType;
	if (bSuccess)
	{
		bSuccess = GetField("mimetype", sMimeType);
	}

	if (bSuccess)
	{
		// check that something is actually registered as being the mime type
		bSuccess = (!sMimeType.IsEmpty());
	}
	
	CTDVString sServerName;
	if (bSuccess)
	{
		bSuccess = GetField("ServerName", sServerName);
	}

	CTDVString sPath;
	if (bSuccess)
	{
		// get the path of the binary file
		bSuccess = GetField("Path", sPath);
	}

	if (bSuccess)
	{
		// build up the picture XML
		CTDVString sBlobXML = "";
		sBlobXML << "<PICTURE><SERVERNAME>";
		sBlobXML << sServerName;
		sBlobXML << "</SERVERNAME><PATH>";
		sBlobXML << sPath;
		sBlobXML << "</PATH><MIMETYPE>";
		sBlobXML << sMimeType;
		sBlobXML << "</MIMETYPE></PICTURE>";

		// put the block into the string we've got handy
		sResult << sBlobXML;
	}

	return bSuccess;
}

#else

bool CStoredProcedure::FetchBlobServerPath(int iBlobID, const TDVCHAR* pBGColour, CTDVString &sResult)
{
	CTDVString sBGColour = pBGColour;

	StartStoredProcedure("getbinarypath");

	AddParam(iBlobID);

	// add the background colour
	AddParam(sBGColour);

	// Fire off the SP and await the result
	ExecuteStoredProcedure();

	bool bSuccess = true; // success bit

	// If you didn't get any results, return false
	if (IsEOF())
	{
		bSuccess = false;
	}
	
	int iConfirmBlobID = 0;
	if (bSuccess)
	{
		iConfirmBlobID = GetIntField("blobid");
		if (iConfirmBlobID == 0) bSuccess = false;
		TDVASSERT(iConfirmBlobID == iBlobID, "CStoredProcedure::FetchBlobServerPath went wrong... got the blob ID wrong :)");
	}

	CTDVString sMimeType;
	if (bSuccess)
	{
		bSuccess = GetField("mimetype", sMimeType);
	}

	if (bSuccess)
	{
		// check that something is actually registered as being the mime type
		bSuccess = (!sMimeType.IsEmpty());
	}
	
	CTDVString sServerName;
	if (bSuccess)
	{
		bSuccess = GetField("ServerName", sServerName);
	}

	CTDVString sPath;
	if (bSuccess)
	{
		// get the path of the binary file
		bSuccess = GetField("Path", sPath);
	}

	if (bSuccess)
	{
		// build up the picture XML
		CTDVString sBlobXML = "";
		sBlobXML << "<PICTURE><SERVERNAME>";
		sBlobXML << sServerName;
		sBlobXML << "</SERVERNAME><PATH>";
		sBlobXML << sPath;
		sBlobXML << "</PATH><MIMETYPE>";
		sBlobXML << sMimeType;
		sBlobXML << "</MIMETYPE></PICTURE>";

		// put the block into the string we've got handy
		sResult << sBlobXML;
	}

	return bSuccess;
}

#endif
/*********************************************************************************

	bool CStoredProcedure::FetchKeyBlobServerPath(const TDVCHAR* pBlobName, const TDVCHAR* pBGColour, CTDVString &sResult)

	Author:		Oscar Gillespie
	Created:	30/08/2000
	Inputs:		-
	Outputs:	sResult will hold the xml with the url where the specified binary file can be found
	Returns:	true if the blob is found, false otherwise
	Fields:		=== blobs table: ===
				blobid int,
				mimetype varchar(255),
				ServerName varchar(255),
				Path varchar(255)
				=== keyblobs table ===
				blobname varchar(20),
				blobid int,
				dateactive datetime
	Purpose:	Function to use a StoredProcedure to get the path pointing to the 
				specified key (named) BLOb and its MimeType wrapped up in a piece of XML

*********************************************************************************/

bool CStoredProcedure::FetchKeyBlobServerPath(const TDVCHAR* pBlobName, const TDVCHAR* pBGColour, CTDVString& sResult)
{
	// turn the TDVCHAR pointers into proper CTDVStrings
	CTDVString sBlobName = pBlobName;
	CTDVString sBGColour = pBGColour;

	StartStoredProcedure("getkeybinarypath");

	// add the blobname to the stored procedure argument list
	AddParam(sBlobName);

	// add the background colour to the stored procedure argument list
	AddParam(sBGColour);

	// Fire off the SP and await the result
	ExecuteStoredProcedure();

	bool bSuccess = true; // success bit

	// If you didn't get any results, return false
	if (IsEOF())
	{
		bSuccess = false;
	}

	// in the above function we verify the blobid but in this case we don't know it in advance
	// so we have no way of making sure that this number is accurate. It was a luxury anyway :)

	CTDVString sMimeType;
	if (bSuccess)
	{
		bSuccess = GetField("mimetype", sMimeType);
	}

	if (bSuccess)
	{
		// check that something is actually registered as being the mime type
		bSuccess = (!sMimeType.IsEmpty());
	}
	
	CTDVString sServerName;
	if (bSuccess)
	{
		bSuccess = GetField("ServerName", sServerName);
	}

	CTDVString sPath;
	if (bSuccess)
	{
		// get the path of the binary file
		bSuccess = GetField("Path", sPath);
	}

	if (bSuccess)
	{
		// build up the picture XML
		CTDVString sBlobXML = "";
		sBlobXML << "<PICTURE><SERVERNAME>";
		sBlobXML << sServerName;
		sBlobXML << "</SERVERNAME><PATH>";
		sBlobXML << sPath;
		sBlobXML << "</PATH><MIMETYPE>";
		sBlobXML << sMimeType;
		sBlobXML << "</MIMETYPE></PICTURE>";

		// put the block into the string we've got handy
		sResult << sBlobXML;
	}

	return bSuccess;
}

/*********************************************************************************

	bool CStoredProcedure::TotalRegisteredUsers()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the number of registered users or -1 for failure
	Fields:		none... just counts the number of records in the table
	Purpose:	Find out how many users are on our rocking site

*********************************************************************************/

int CStoredProcedure::TotalRegisteredUsers()
{
	// fire off the sp to count the registered users
	StartStoredProcedure("totalregusers");
	ExecuteStoredProcedure();

	if (!IsEOF())
	{
		// return the count generated by the stored procedure
		return GetIntField("cnt");
	}
	else
	{
		// it screwed up so return an error value
		return -1;
	}
}

/*********************************************************************************

	bool CStoredProcedure::SubmittedQueueSize()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the number of submitted entries or -1 for failure
	Fields:		none... just counts the number of records in the table
	Purpose:	Find out how many articles are waiting to be approved on our rocking site :)

*********************************************************************************/

int CStoredProcedure::SubmittedQueueSize()
{
	// fire off the sp to count the submitted entries waiting to get approved (or not)
	StartStoredProcedure("submittedqueuesize");
	ExecuteStoredProcedure();

	if (!IsEOF())
	{
		// return the count generated by the stored procedure
		return GetIntField("cnt");
	}
	else
	{
		// it screwed up so return an error value
		return -1;
	}
}

/*********************************************************************************

	bool CStoredProcedure::TotalApprovedEntries()

	Author:		Oscar Gillespie
	Created:	20/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	the number of approved entries or -1 for failure
	Fields:		none... just counts the number of records in the table
	Purpose:	Find out how many approved entries are on our rocking site

*********************************************************************************/

int CStoredProcedure::TotalApprovedEntries(int iSiteID)
{
	// fire off the sp to count the approved entries
	StartStoredProcedure("totalapprovedentries");

	AddParam(iSiteID);

	ExecuteStoredProcedure();

	if (!IsEOF())
	{
		// return the count generated by the stored procedure
		return GetIntField("cnt");
	}
	else
	{
		// it screwed up so return an error value
		return -1;
	}
}

/*********************************************************************************

	bool CStoredProcedure::FetchProlificPosters()

	Author:		Oscar Gillespie
	Created:	21/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	success of operation (were there any results?)
	Fields:		c.cnt int, 
				c.UserID int, 
				c.totlength int, 
				'ratio' = c.totlength / c.cnt, 
				'UserName' varchar(255)
	Purpose:	Find out what the longest posts in the last 24 hours were

*********************************************************************************/

bool CStoredProcedure::FetchProlificPosters(CTDVString& sResult, int iSiteID)
{
	// start the stored procedure to see which posters have posted the most times in the last 24 hours
	StartStoredProcedure("prolificposters");

	AddParam(iSiteID);

	ExecuteStoredProcedure();

	// set the increment integer (the number of users we've pulled out of the query result set) to 0
	int iUserCount = 0;

	// loop while the database query hasn't flopped and we haven't read more than 10
	while (!IsEOF() && iUserCount <= 10)
	{
		// start building up a prolific poster block of xml
		sResult << "<PROLIFICPOSTER>";

		sResult << "<USER>";

			sResult << "<USERNAME>";

			CTDVString sUserName = "";
			// pull the username out of the query result set
			GetField("UserName", sUserName);
			// turn any nasty characters into nice polite xml-safe ones
			CXMLObject::EscapeXMLText(&sUserName);
			// output the name of the user
			sResult << sUserName;

			sResult << "</USERNAME>";

			// pull out the user id and output it
			sResult << "<USERID>";
			sResult << GetIntField("UserID");
			sResult << "</USERID>";

		sResult << "</USER>";

		// pull out the number of posts this user has made and output it
		sResult << "<COUNT>";
		sResult << GetIntField("cnt");
		sResult << "</COUNT>";

		// pull out the average size of this users posts
		sResult << "<AVERAGESIZE>";
		sResult << GetIntField("ratio");
		sResult << "</AVERAGESIZE>";

		sResult << "</PROLIFICPOSTER>";

		// step onto the next row of results
		MoveNext();
		// increment the number of users we've found
		iUserCount++;
	}

	return (iUserCount > 0);
}


/*********************************************************************************

	bool CStoredProcedure::FetchEruditePosters()

	Author:		Oscar Gillespie
	Created:	21/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	success of operation (were there any results?)
	Fields:		c.cnt int, 
				c.UserID int, 
				c.totlength int, 
				'ratio' = c.totlength / c.cnt, 
				'UserName' varchar(255)
	Purpose:	Find out what the longest posts in the last 24 hours were

*********************************************************************************/

bool CStoredProcedure::FetchEruditePosters(CTDVString& sResult, int iSiteID)
{
	// start the stored procedure to see which posters have posted the plumpest posts in the last 24 hours
	StartStoredProcedure("eruditeposters");

	AddParam(iSiteID);

	ExecuteStoredProcedure();

	// set the increment integer (the number of users we've pulled out of the query result set) to 0
	int iUserCount = 0;

	// loop while the database query hasn't flopped and we haven't read more than 10
	while (!IsEOF() && iUserCount <= 10)
	{
		// start building up a erudite poster block of xml
		sResult << "<ERUDITEPOSTER>";

		sResult << "<USER>";

			sResult << "<USERNAME>";

			CTDVString sUserName = "";
			// pull the username out of the query result set
			GetField("UserName", sUserName);
			// turn any nasty characters into nice polite xml-safe ones
			CXMLObject::EscapeXMLText(&sUserName);
			// output the name of the user
			sResult << sUserName;

			sResult << "</USERNAME>";

			// pull out the user id and output it
			sResult << "<USERID>";
			sResult << GetIntField("UserID");
			sResult << "</USERID>";

		sResult << "</USER>";

		// pull out the number of posts this user has made and output it
		sResult << "<COUNT>";
		sResult << GetIntField("cnt");
		sResult << "</COUNT>";

		// pull out the average size of this users posts
		sResult << "<AVERAGESIZE>";
		sResult << GetIntField("ratio");
		sResult << "</AVERAGESIZE>";

		sResult << "</ERUDITEPOSTER>";

		// step onto the next row of results
		MoveNext();
		// increment the number of users we've found
		iUserCount++;
	}

	return (iUserCount > 0);
}



/*********************************************************************************

	bool CStoredProcedure::FetchMightyPosts()

	Author:		Oscar Gillespie
	Created:	21/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	success of operation (were there any results?)
	Fields:		t.UserID int,
				t.Subject varchar(255),
				t.ForumID int,
				t.ThreadID int,
				t.EntryID int,
				'totlength' = DATALENGTH(text),
				'UserName' varchar(255)
	Purpose:	Find out what the longest posts in the last 24 hours were

*********************************************************************************/

bool CStoredProcedure::FetchMightyPosts(CTDVString& sResult)
{
	// fire off the stored procedure to get the plumpest posts
	StartStoredProcedure("mightyposts");
	ExecuteStoredProcedure();

	// set the increment integer (the number of posts we've pulled out of the query result set) to 0
	int iPostCount = 0;

	// loop while the database query hasn't flopped and we haven't read more than 10
	while (!IsEOF() && iPostCount <= 10)
	{
		// start building up a long post post block of xml
		sResult << "<LONGPOST>";

		sResult << "<USERNAME>";

		CTDVString sUserName = "";
		// pull the username out of the query result set
		GetField("UserName", sUserName);
		// turn any nasty characters into nice polite xml-safe ones
		CXMLObject::EscapeXMLText(&sUserName);
		// output the name of the user
		sResult << sUserName;

		sResult << "</USERNAME>";

		// pull out the user id and output it
		sResult << "<USERID>";
		sResult << GetIntField("UserID");
		sResult << "</USERID>";

		sResult << "<POSTSUBJECT>";

		CTDVString sPostSubject = "";
		// pull the subject of the post out of the query result set
		GetField("Subject", sPostSubject);
		// turn any nasty characters into nice polite xml-safe ones
		CXMLObject::EscapeXMLText(&sPostSubject);
		// output the subject of the post
		sResult << sPostSubject;
		sResult << "</POSTSUBJECT>";

		// pull out the length of the long post and output it
		sResult << "<TOTALLENGTH>";
		sResult << GetIntField("totlength");
		sResult << "</TOTALLENGTH>";

		// pull out the forum id
		sResult << "<FORUMID>";
		sResult << GetIntField("ForumID");
		sResult << "</FORUMID>";

		// pull out the forum id
		sResult << "<THREADID>";
		sResult << GetIntField("ThreadID");
		sResult << "</THREADID>";

		int iPostID = GetIntField("EntryID");
		if (iPostID != 0)
		{
			sResult << "<POSTID>";
			sResult << iPostID;
			sResult << "</POSTID>";
		}

		sResult << "</LONGPOST>";

		// step onto the next row of results
		MoveNext();
		// increment the number of users we've found
		iPostCount++;
	}

	return (iPostCount > 0);
}


/*********************************************************************************

	bool CStoredProcedure::FetchFreshestArticles()

	Author:		Igor Loboda
	Created:	17/01/2002
	Inputs:		-
	Outputs:	-
	Returns:	success of operation (were there any results?)
	Fields:		h2g2ID, 
				Status, 
				Subject,
				LastUpdated
	Purpose:	Find out what the most recently updated articles in the last 
				24 hours have been

*********************************************************************************/

bool CStoredProcedure::FetchFreshestArticles(CTDVString& sResult, int iSiteID, int iSkip, int iShow)
{
	// fire off the stored procedure to get the freshest articles
	StartStoredProcedure("freshestarticles");

	AddParam(iSiteID);

	ExecuteStoredProcedure();

	// set the increment integer 
	// the number of articles we've pulled out of the query result set) to 0
	int iArticlesCount = 0;

	if (!IsEOF() && iSkip > 0)
	{
		MoveNext(iSkip);
	}
	
	// loop while the database query hasn't flopped
	while (!IsEOF() && iArticlesCount < iShow)
	{
		sResult << "<RECENTARTICLE>";

		sResult << "<H2G2ID>" << GetIntField("h2g2ID") << "</H2G2ID>";

		sResult << "<STATUS>" << GetIntField("Status") << "</STATUS>";

		// get the LastUpdated date and convert it to a string
		CTDVDateTime dtDateUpdated = GetDateField("DateCreated");
		CTDVString sDateUpdated = "";
		dtDateUpdated.GetAsXML(sDateUpdated, true);
		sResult << "<DATEUPDATED>" << sDateUpdated << "</DATEUPDATED>";

		// pull the subject of the article
		CTDVString sSubject = "";
		GetField("Subject", sSubject);
		// turn any nasty characters into nice polite xml-safe ones
		CXMLObject::EscapeXMLText(&sSubject);
		// output the subject of the first post in the conversation
		sResult << "<SUBJECT>" << sSubject << "</SUBJECT>";

		sResult << "</RECENTARTICLE>";

		// step onto the next row of results
		MoveNext();
		// increment the number of articles we've found
		iArticlesCount++;
	}

	// return true if we found some articles
	return iArticlesCount > 0;
}

/*********************************************************************************

	bool CStoredProcedure::FetchFreshestConversations()

	Author:		Oscar Gillespie
	Created:	21/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	success of operation (were there any results?)
	Fields:		ThreadID int, 
				ForumID int, 
				'FirstSubject' varchar(255),
				LastPosted DateTime
	Purpose:	Find out what the most recently updated conversations in the last 24 hours have been

*********************************************************************************/

bool CStoredProcedure::FetchFreshestConversations(CTDVString& sResult, int iSiteID, int iSkip, int iShow)
{
	// fire off the stored procedure to get the plumpest posts
	StartStoredProcedure("freshestconversations");

	AddParam(iSiteID);

	ExecuteStoredProcedure();

	// set the increment integer (the number of posts we've pulled out of the query result set) to 0
	int iConvCount = 0;


	if (!IsEOF() && iSkip > 0)
	{
		MoveNext(iSkip);
	}
	
	// loop while the database query hasn't flopped and we haven't read more than 20 bits
	while (!IsEOF() && iConvCount < iShow)
	{
		sResult << "<RECENTCONVERSATION>";

		sResult << "<FIRSTSUBJECT>";

		CTDVString sFirstSubject = "";
		// pull the subject of the first post in the conversation out of the query result set
		GetField("FirstSubject", sFirstSubject);
		// turn any nasty characters into nice polite xml-safe ones
		CXMLObject::EscapeXMLText(&sFirstSubject);
		// output the subject of the first post in the conversation
		sResult << sFirstSubject;
		sResult << "</FIRSTSUBJECT>";

		sResult << "<DATEPOSTED>";

		// pull the date of the first post in the conversation out of the query result set
		CTDVDateTime dtDatePosted = GetDateField("LastPosted");

		CTDVString sDatePosted = "";
		// convert the date to a string
		dtDatePosted.GetAsXML(sDatePosted, true);
		// output the time that the first post in the conversation was posted
		sResult << sDatePosted;

		sResult << "</DATEPOSTED>";

		// pull out the forum id
		sResult << "<FORUMID>";
		sResult << GetIntField("ForumID");
		sResult << "</FORUMID>";

		// pull out the forum id
		sResult << "<THREADID>";
		sResult << GetIntField("ThreadID");
		sResult << "</THREADID>";

		sResult << "</RECENTCONVERSATION>";

		// step onto the next row of results
		MoveNext();
		// increment the number of users we've found
		iConvCount++;
	}

	// return true if we found some posts
	return (iConvCount > 0);
}


/*********************************************************************************

	bool CStoredProcedure::SearchForums(const TDVCHAR* sSearchString, CTDVString& sResult, int iSkip, int iShow, int* piBestPostID, double* pdBestScore)

	Author:		Oscar Gillespie, Kim Harries
	Created:	24/03/2000
	Modified:	31/10/2000
	Inputs:		const TDVCHAR* sSearchString - the word(s) we're looking for
				const CTDVString* psUserGroups - restricts author to groups provided - comma separated list.
	Outputs:	sResult will hold the xml with any results of the search
				piBestPostID - post ID of the best matching post, or zero if none
				pdBestScore - score of the best matching post, or zero if none
	Returns:	true if it worked, false otherwise
	Fields:		PostID int,
				Subject varchar(255),
				ThreadID int,
				ForumID int,
  
	Purpose:	Fetch the forums that contain the search word(s) in the most
				optimal fashion.

*********************************************************************************/

bool CStoredProcedure::SearchForums(const TDVCHAR* sSearchString, CTDVString& sResult, const CTDVString* psUserGroups, int iSkip, int iShow, int iSiteID, int iForumID, int iThreadID, int* piBestPostID, double* pdBestScore)
{
	TDVASSERT(piBestPostID != NULL, "NULL piBestPostID in CStoredProcedure::SearchForums(...)");
	TDVASSERT(pdBestScore != NULL, "NULL pdBestScore in CStoredProcedure::SearchForums(...)");

	StartStoredProcedure("SearchForumsAdvanced");
	AddParam("Condition", sSearchString);
	AddParam("primarysite", iSiteID);
	if (iForumID > 0) 
	{
		AddParam("forumid", iForumID);
	}
	if (iThreadID) 
	{
		AddParam("threadid", iThreadID);
	}

	if ( psUserGroups && !psUserGroups->IsEmpty() )
	{
		AddParam("usergroups",*psUserGroups);
	}

	//fire off the stored procedure	
	ExecuteStoredProcedure();

	// success tracking boolean
	bool bSuccess = true;

	// check best match before doing the skip
	if (IsEOF())
	{
		*piBestPostID = 0;
		*pdBestScore = 0.0;
	}
	else
	{
		*piBestPostID = GetIntField("PostID");
		*pdBestScore = GetDoubleField("Score");
	}
	// if iSkip is more than 0 then there's some skippin' to do
	if (iSkip > 0)
	{
		// skip however many results we need to skip to get to iIndex	
		MoveNext(iSkip);
	}

	if (IsEOF())
	{
		// if we've just dashed past any of the matching results we've failed
		bSuccess = false;
	}

	int iResultCount = 0;

	// Keep looping until we get EOF
	// generate XML for each matching user as we go
	while (!IsEOF() && bSuccess == true && iResultCount < iShow)
	{
		// start building up a section of xml for this chunk of information about a specific article
		sResult << "<FORUMRESULT>";
		
		// add the PostID of the post matching the search string
		int iPostID = 0;
		iPostID = GetIntField("PostID");

		sResult << "<POSTID>";
		sResult << iPostID;
		sResult << "</POSTID>";

		// add the subject of the post
		CTDVString sPostSubject = "";
		GetField("Subject", sPostSubject);

		// fix any sickness in the subject of the page
		CXMLObject::EscapeXMLText(&sPostSubject);

		sResult << "<SUBJECT>";		
		sResult << sPostSubject;
		sResult << "</SUBJECT>";

		// add the PostID of the post matching the search string
		int iThreadID = 0;
		iThreadID = GetIntField("ThreadID");

		sResult << "<THREADID>" << iThreadID << "</THREADID>";
	
		// add the PostID of the post matching the search string
		int iForumID = 0;
		iForumID = GetIntField("ForumID");

		sResult << "<FORUMID>" << iForumID << "</FORUMID>";

		// add the relevancy score for this article

		double dScore = 0.0;
		TDVCHAR cTemp[30];
		dScore = GetDoubleField("Score");
		// turn score into a percentage and cut off the decimal point
		sprintf(cTemp, "%.0f", 100 * dScore);

		sResult << "<SCORE>" << cTemp << "</SCORE>";
		int iArtSiteID = GetIntField("SiteID");
		bool bPrimarySite = GetBoolField("PrimarySite");
		sResult << "<SITEID>" << iArtSiteID << "</SITEID>";
		sResult << "<PRIMARYSITE>";
		if (bPrimarySite)
		{
			sResult << "1";
		}
		else
		{
			sResult << "0";
		}
		sResult << "</PRIMARYSITE>";

		// finish building the block of info about the post
		sResult << "</FORUMRESULT>";
	
		// increment the search result counter
		iResultCount++;
		// fetch the next row
		MoveNext();
	}

	sResult << "<SKIP>";
	sResult << iSkip;
	sResult << "</SKIP>";
	sResult << "<COUNT>";
	sResult << iShow;
	sResult << "</COUNT>";
	sResult << "<MORE>";
	if (iResultCount < iShow)
	{
		// we didn't show a full quote of results so there are no more results
		sResult << "0";
	}
	else
	{
		// we got all we asked for so there's a good chance theres a few more there
		sResult << "1";
	}
	sResult << "</MORE>";

	if (iForumID > 0) 
	{
		sResult << "<FORUM ID='" << iForumID << "'/>";
	}
	if (iThreadID > 0) 
	{
		sResult << "<THREAD ID='" << iThreadID << "'/>";
	}

	// no problems encountered so we return success
	return bSuccess;

	// no problems encountered so we return success
	return bSuccess;
}


/*********************************************************************************

	bool CStoredProcedure::SearchArticles(const TDVCHAR* sSearchString, int iShowApproved, int iShowNormal, int iShowSubmitted, CTDVString& sResult, int* piBestEntryID, double* pdBestScore, int iSkip, int iShow, int iSiteID, int iCategory, int iShowContentRatingData)

	Author:		Oscar Gillespie, Kim Harries
	Created:	24/03/2000
	Modified:	14/09/2000
				08/03/2005 (Jamesp, content rating data)
	Inputs:		const TDVCHAR* sSearchString - the word(s) we're looking for
				iSiteID - ID of the primary site, although results are returned across all sites
				iCategoryID - ID of the node in the hierarchy within which we want to search
				psUserGroups - Restrict author to groups provided - comma separated list.
				iShowContentRatingData - set to 1 to add content rating data

	Outputs:	sResult will hold the xml with any results of the search
				piBestEntryID - entry ID of the best matching entry, or zero if no matches
				pdBestScore - score of the best match, or zero if none
	Returns:	true if it worked, false otherwise
	Fields:		EntryID int,
				Subject varchar(255),
				h2g2ID int,

	Purpose:	Fetch the articles that contain the search word(s) in the most
				optimal fashion.

*********************************************************************************/

bool CStoredProcedure::SearchArticles(const TDVCHAR* sSearchString, 
									  int iShowApproved, 
									  int iShowNormal, 
									  int iShowSubmitted, 
									  const CTDVString* psUserGroups, 
									  CTDVString& sResult, 
									  int* piBestEntryID, 
									  double* pdBestScore, 
									  int iSkip, 
									  int iShow, 
									  int iSiteID, 
									  int iCategory,
									  int iShowContentRatingData,
									  int iArticleType,
									  int iArticleStatus)
{
	TDVASSERT(piBestEntryID != NULL, "piBestEntryID NULL in CStoredProcedure::SearchArticles(...)");
	TDVASSERT(pdBestScore != NULL, "pdBestScore NULL in CStoredProcedure::SearchArticles(...)");

	StartStoredProcedure("SearchArticlesAdvanced");
	AddParam("SubjectCondition", sSearchString);
	AddParam("BodyCondition", sSearchString);
	AddParam("Showapproved", iShowApproved);
	AddParam("Showsubmitted", iShowSubmitted);
	AddParam("Shownormal", iShowNormal);
	AddParam("primarysite", iSiteID);
	AddParam("showcontentratingdata", iShowContentRatingData);

	if ( psUserGroups && !psUserGroups->IsEmpty() )
	{
		AddParam("UserGroups", *psUserGroups);
	}
	
	if (iCategory != 0)
	{
		AddParam("withincategory", iCategory);
	}
	if (iArticleType > 0)
	{
		AddParam("articletype", iArticleType);
	}
	if (iArticleStatus > 0)
	{
		AddParam("articlestatus", iArticleStatus);
	}

	//fire off the stored procedure	
	ExecuteStoredProcedure();
	if (HandleError("SearchArticlesAdvanced"))
	{
		return false;
	}

	// success tracking boolean
	bool bSuccess = true;

	// check for best match before doing any skipping
	if (IsEOF())
	{
		*piBestEntryID = 0;
		*pdBestScore = 0.0;
	}
	else
	{
		*piBestEntryID = GetIntField("EntryID");
		*pdBestScore = GetDoubleField("Score");
	}
	// if iSkip is more than 0 then there's some skippin' to do
	if (iSkip > 0)
	{
		// skip however many results we need to skip to get to iIndex	
		MoveNext(iSkip);
	}

	if (IsEOF())
	{
		// if we've just dashed past any of the matching results we've failed
		bSuccess = false;
	}

	// no problems encountered so we return success
	return bSuccess;
}

/*********************************************************************************

	bool CStoredProcedure::SearchArticlesFast(const TDVCHAR* sSearchString, 

		Author:		Mark Neves
		Created:	12/06/2007
		Inputs:		sSearchString = the search string passed to CONTAINSTABLE 
					iShowApproved = 1 if you want approved articles 
					iShowNormal = 1 if you want normal articles 
					iShowSubmitted = 1 if you want submitted articles 
					psUserGroups = If not empty, only articles in this list of groups are returned
					sResult = not used
					iSkip = how many to skip 
					iShow = how many to show
					iSiteID = the site to restrict the results to
					iCategory = if > 0, restricts articles to the given category
					iShowContentRatingData = if 1, include content rating
					iArticleType = if > 0, restrict to only articles of this type
		Outputs:	piBestEntryID = the entry with the top score
					pdBestScore = the best score
		Returns:	false if failed, or there's no results
		Purpose:	Does a free text search using the fast free text search proc

*********************************************************************************/

bool CStoredProcedure::SearchArticlesFast(const TDVCHAR* sSearchString, 
									  int iShowApproved, 
									  int iShowNormal, 
									  int iShowSubmitted, 
									  const CTDVString* psUserGroups, 
									  CTDVString& sResult, 
									  int* piBestEntryID, 
									  double* pdBestScore, 
									  int iSkip, 
									  int iShow, 
									  int iSiteID, 
									  int iCategory,
									  int iShowContentRatingData,
									  int iArticleType)
{
	TDVASSERT(piBestEntryID != NULL, "piBestEntryID NULL in CStoredProcedure::SearchArticles(...)");
	TDVASSERT(pdBestScore != NULL, "pdBestScore NULL in CStoredProcedure::SearchArticles(...)");

	StartStoredProcedure("SearchArticlesFast");
	AddParam("top", iSkip+iShow);
	AddParam("Condition", sSearchString);

	AddParam("Showapproved", iShowApproved);
	AddParam("Showsubmitted", iShowSubmitted);
	AddParam("Shownormal", iShowNormal);
	AddParam("primarysite", iSiteID);
	AddParam("showcontentratingdata", iShowContentRatingData);

	if ( psUserGroups && !psUserGroups->IsEmpty() )
	{
		AddParam("UserGroups", *psUserGroups);
	}
	
	if (iCategory != 0)
	{
		AddParam("withincategory", iCategory);
	}
	if (iArticleType > 0)
	{
		AddParam("articletype", iArticleType);
	}

	//fire off the stored procedure	
	ExecuteStoredProcedure();
	if (HandleError("SearchArticlesAdvanced"))
	{
		return false;
	}

	// success tracking boolean
	bool bSuccess = true;

	// check for best match before doing any skipping
	if (IsEOF())
	{
		*piBestEntryID = 0;
		*pdBestScore = 0.0;
	}
	else
	{
		*piBestEntryID = GetIntField("EntryID");
		*pdBestScore = GetDoubleField("Score");
	}
	// if iSkip is more than 0 then there's some skippin' to do
	if (iSkip > 0)
	{
		// skip however many results we need to skip to get to iIndex	
		MoveNext(iSkip);
	}

	if (IsEOF())
	{
		// if we've just dashed past any of the matching results we've failed
		bSuccess = false;
	}

	// no problems encountered so we return success
	return bSuccess;
}


bool CStoredProcedure::SearchArticlesFreetext(const TDVCHAR* sSearchString, 
									  int iShowApproved, 
									  int iShowNormal, 
									  int iShowSubmitted, 
									  const CTDVString* psUserGroups, 
									  CTDVString& sResult, 
									  int* piBestEntryID, 
									  double* pdBestScore, 
									  int iSkip, 
									  int iShow, 
									  int iSiteID, 
									  int iCategory,
									  int iShowContentRatingData,
									  int iArticleType,
									  int iArticleStatus)
{
	TDVASSERT(piBestEntryID != NULL, "piBestEntryID NULL in CStoredProcedure::SearchArticlesFreetext(...)");
	TDVASSERT(pdBestScore != NULL, "pdBestScore NULL in CStoredProcedure::SearchArticlesFreetext(...)");

	StartStoredProcedure("SearchArticlesAdvancedfreetext");
	AddParam("SubjectCondition", sSearchString);
	AddParam("BodyCondition", sSearchString);
	AddParam("Showapproved", iShowApproved);
	AddParam("Showsubmitted", iShowSubmitted);
	AddParam("Shownormal", iShowNormal);
	AddParam("primarysite", iSiteID);
	AddParam("showcontentratingdata", iShowContentRatingData);

	if ( psUserGroups && !psUserGroups->IsEmpty() )
	{
		AddParam("UserGroups", *psUserGroups);
	}
	
	if (iCategory != 0)
	{
		AddParam("withincategory", iCategory);
	}
	if (iArticleType > 0)
	{
		AddParam("articletype", iArticleType);
	}
	if (iArticleStatus > 0)
	{
		AddParam("articlestatus", iArticleStatus);
	}

	//fire off the stored procedure	
	ExecuteStoredProcedure();
	if (HandleError("SearchArticlesAdvancedfreetext"))
	{
		return false;
	}

	// success tracking boolean
	bool bSuccess = true;

	// check for best match before doing any skipping
	if (IsEOF())
	{
		*piBestEntryID = 0;
		*pdBestScore = 0.0;
	}
	else
	{
		*piBestEntryID = GetIntField("EntryID");
		*pdBestScore = GetDoubleField("Score");
	}
	// if iSkip is more than 0 then there's some skippin' to do
	if (iSkip > 0)
	{
		// skip however many results we need to skip to get to iIndex	
		MoveNext(iSkip);
	}

	if (IsEOF())
	{
		// if we've just dashed past any of the matching results we've failed
		bSuccess = false;
	}

	// no problems encountered so we return success
	return bSuccess;
}


/*********************************************************************************

	bool CStoredProcedure::SearchUsers(const TDVCHAR* pUserNameOrEmail, CTDVString& sResult, int iSkip, int iShow, int* piBestUserID, double* pdBestScore, int iSiteID)

	Author:		Oscar Gillespie, Kim Harries
	Created:	24/03/2000
	Modified:	31/10/2000
	Inputs:		const TDVCHAR* sUserNameOrEmail - the word(s) we're looking for
				piBestUserID - the user ID of the best matching user, or zero if none
				pdBestScore - the score of the best match, or zero if none
				iSiteID - The site to look for users in. If 0 (Default) it checks all sites
	Outputs:	sResult will hold the xml with any results of the search
	Returns:	true if it worked, false otherwise
	Fields:		todo

	Purpose:	Fetch all users with this name or email address.

	Note:		Current search SP doesn't provide a score

*********************************************************************************/

bool CStoredProcedure::SearchUsers(const TDVCHAR* pUserNameOrEmail, bool bAllowEmailSearch, CTDVString& sResult, int iSkip, int iShow, int* piBestUserID, double* pdBestScore, int iSiteID)
{
	// success tracking boolean
	bool bSuccess = true;

	CTDVString sUserNameOrEmail = pUserNameOrEmail;
	
	// if the search term has length 0 we can't hope to find an appropriate user
	if (sUserNameOrEmail.GetLength() == 0) bSuccess = false;

	if (bSuccess)
	{
		StartStoredProcedure("SearchUsersByNameOrEmail");
		AddParam("NameOrEmail", sUserNameOrEmail);
		if (bAllowEmailSearch)
		{
			AddParam("searchemails",1);
		}
		else
		{
			AddParam("searchemails",0);
		}

		// Add the site to look in
		AddParam("SiteID",iSiteID);

		//fire off the stored procedure
		ExecuteStoredProcedure();

		// get details of best match before skipping
		if (IsEOF())
		{
			*piBestUserID = 0;
			*pdBestScore = 0.0;
		}
		else
		{
			*piBestUserID = GetIntField("UserID");
			// current SP does not provide a score, so give a nominal value
			// TODO: improve the SP to make it give a score
			*pdBestScore = 0.1;
//			*pdBestScore = GetDoubleField("Score");
		}
		// if iSkip is more than 0 then there's some skippin' to do
		if (iSkip > 0)
		{
			// skip however many results we need to skip to get to iIndex	
			MoveNext(iSkip);
		}

		if (IsEOF())
		{
			// if we've just dashed past any of the matching results we've failed
			bSuccess = false;
		}
	}
	// start building up a section of xml for this chunk of information about a specific article
	
	int iResultCount = 0;

	// Keep looping until we get EOF
	// generate XML for each matching user as we go
	while (!IsEOF() && bSuccess == true && iResultCount < iShow)
	{
		sResult << "<USERRESULT>";

		// add the UserID of the user if they exist
		int iUserID = 0;
		iUserID = GetIntField("UserID");

		sResult << "<USERID>";
		sResult << iUserID;
		sResult << "</USERID>";

		// add the users name
		CTDVString sUserName = "";
		GetField("UserName", sUserName);

		// fix any sickness in the subject of the page
		CXMLObject::EscapeXMLText(&sUserName);

		sResult << "<USERNAME>";
		sResult << sUserName;
		sResult << "</USERNAME>";

		// Add the extra info for the user. Taxonomy node, title
		// Get the users title
		CTDVString sUserTitle;
		if (!IsNULL("Title"))
		{
			GetField("Title",sUserTitle);
			CXMLObject::EscapeXMLText(&sUserTitle);
			sResult << "<TITLE>" << sUserTitle << "</TITLE>";
		}

		CTDVString sFirstNames;
		if (!IsNULL("FirstNames"))
		{
			GetField("FirstNames",sFirstNames);
			CXMLObject::EscapeXMLText(&sFirstNames);
			sResult << "<FIRSTNAME>" << sFirstNames << "</FIRSTNAME>";
		}

		CTDVString sLastName;
		if (!IsNULL("LastName"))
		{
			GetField("LastName",sLastName);
			CXMLObject::EscapeXMLText(&sLastName);
			sResult << "<LASTNAME>" << sLastName << "</LASTNAME>";
		}

		CTDVString sSiteSuffix;
		if (!IsNULL("SiteSuffix "))
		{
			GetField("SiteSuffix ",sSiteSuffix);
			CXMLObject::EscapeXMLText(&sSiteSuffix);
			sResult << "<SITESUFFIX >" << sSiteSuffix << "</SITESUFFIX>";
		}

		// Get the users Area
		CTDVString sArea;
		if (!IsNULL("Area"))
		{
			GetField("Area",sArea);
			CXMLObject::EscapeXMLText(&sArea);
			sResult << "<AREA>" << sArea << "</AREA>";
		}

		// Get the users Tax Node
		if (!IsNULL("TaxonomyNode"))
		{
			int iTaxNode = GetIntField("TaxonomyNode");
			sResult << "<TAXONOMYNODE>" << iTaxNode << "</TAXONOMYNODE>";
		}

		sResult << "</USERRESULT>";

		// increment the search result counter
		iResultCount++;
		// fetch the next row
		MoveNext();
	}
	// finish building the block of info about the post

	sResult << "<SKIP>";
	sResult << iSkip;
	sResult << "</SKIP>";
	sResult << "<COUNT>";
	sResult << iShow;
	sResult << "</COUNT>";
	sResult << "<MORE>";
	if (iResultCount < iShow)
	{
		// we didn't show a full quote of results so there are no more results
		sResult << "0";
	}
	else
	{
		// we got all we asked for so there's a good chance theres a few more there
		sResult << "1";
	}
	sResult << "</MORE>";
	// no problems encountered so we return success
	return bSuccess;
}

/*********************************************************************************

	bool CStoredProcedure::RecentSearches( int iSiteID, int iCount )

	Author:		Martin Robb
	Created:	6/12/2004
	Inputs:		iSiteID - The relevant site for recent searches
	Returns:	true if it worked, false otherwise
	Purpose:	Return recent searches for a site
*********************************************************************************/
bool CStoredProcedure::GetRecentSearches( int iSiteID )
{
	StartStoredProcedure("GetRecentSearches");
	AddParam("SiteID", iSiteID );

	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::UpdateRecentSearch( CTDVString& search )

	Author:		Martin Robb
	Created:	6/12/2004
	Inputs:		Search Query
	Returns:	true if row updated/inserted
	Purpose:	Return recent searches for a site
*********************************************************************************/
bool CStoredProcedure::UpdateRecentSearch( int iSiteID, int iType, const CTDVString& sSearch )
{
	StartStoredProcedure("updateRecentSearch");
	AddParam("siteID", iSiteID);
	AddParam("type", iType);
	AddParam("searchterm", sSearch );

	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::AddNewArticleSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID,
													bool bApprovedEntries, bool bSubmittedEntries, bool bNormalEntries,
													int iBestEntryID, double dBestScore)

	Author:		Kim Harries
	Created:	30/10/2000
	Inputs:		pcSearchString - the original search string as entered by the user
				pcSearchType - the type of search, e.g. article, forum, or user search
				pcSearchCondition - the search condition constructed from this search string
				iSearcherID - the user ID of the user doing the search, or zero if unregistered
				bApprovedEntries - search includes approved (edited) entries?
				bSubmittedEntries - search includes submitted (recommended) entries?
				bNormalEntries - search includes normal entries?
				iBestEntryID - EntryID of the best match found, or zero if none at all
				dBestScore - best score found, or zero if none at all
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Adds the specified search to the SearchActions table. If the search itself is
				new then also adds this to the Searches table. Also addes the best result found
				from this search to the SearchResults table. Should be called every time
				a new article search is performed, but NOT when simply skipping through
				the list of matches generated by a previous search.

	Fields:		SearchActionID - the unique ID assigned to this search action
				SearchID - the unique ID of this particular search
				SearchResultID - the unique ID assigned to this result

*********************************************************************************

bool CStoredProcedure::AddNewArticleSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID,
												bool bApprovedEntries, bool bSubmittedEntries, bool bNormalEntries,
												int iBestEntryID, double dBestScore)
{
	// other fields can be left out and will be given NULL values automatically
	StartStoredProcedure("AddNewSearchAction");
	AddParam("SearchString", pcSearchString);
	AddParam("SearchType", pcSearchType);
	AddParam("SearchCondition", pcSearchCondition);
	AddParam("SearcherID", iSearcherID);
	AddParam("ApprovedEntries", bApprovedEntries);
	AddParam("SubmittedEntries", bSubmittedEntries);
	AddParam("NormalEntries", bNormalEntries);
	AddParam("EntryID", iBestEntryID);
	AddParam("Score", dBestScore);
// treat all searches as failed searches for testing
AddParam("ActiveSearch", 1);
AddParam("NotifyUser", 1);
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);
}


/*********************************************************************************

	bool CStoredProcedure::AddNewForumSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID,
													int iBestPostID, double dBestScore)

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		pcSearchString - the original search string as entered by the user
				pcSearchType - the type of search, e.g. article, forum, or user search
				pcSearchCondition - the search condition constructed from this search string
				iSearcherID - the user ID of the user doing the search, or zero if unregistered
				iBestPostID - PostID (EntryID) of the best match found, or zero if none at all
				dBestScore - best score found, or zero if none at all
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Adds the specified search to the SearchActions table. If the search itself is
				new then also adds this to the Searches table. Also adds the best result found
				from this search to the SearchResults table. Should be called every time
				a new forum search is performed, but NOT when simply skipping through
				the list of matches generated by a previous search.

	Fields:		SearchActionID - the unique ID assigned to this search action
				SearchID - the unique ID of this particular search
				SearchResultID - the unique ID assigned to this result

*********************************************************************************

bool CStoredProcedure::AddNewForumSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID,
												int iBestPostID, double dBestScore)
{
	// other fields can be left out and will be given NULL values automatically
	StartStoredProcedure("AddNewSearchAction");
	AddParam("SearchString", pcSearchString);
	AddParam("SearchType", pcSearchType);
	AddParam("SearchCondition", pcSearchCondition);
	AddParam("SearcherID", iSearcherID);
	AddParam("Forums", 1);
	AddParam("PostID", iBestPostID);
	AddParam("Score", dBestScore);
// treat all searches as failed searches for testing
AddParam("ActiveSearch", 1);
AddParam("NotifyUser", 1);
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::AddNewUserSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID, int iBestUserID, double dBestScore)

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		pcSearchString - the original search string as entered by the user
				pcSearchType - the type of search, e.g. article, forum, or user search
				pcSearchCondition - the search condition constructed from this search string
					=> currently none for suer searches
				iSearcherID - the user ID of the user doing the search, or zero if unregistered
				iBestUserID - UserID of the best match found, or zero if none at all
				dBestScore - best score found, or zero if none at all
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Adds the specified search to the SearchActions table. If the search itself is
				new then also adds this to the Searches table. Also adds the best result found
				from this search to the SearchResults table. Should be called every time
				a new forum search is performed, but NOT when simply skipping through
				the list of matches generated by a previous search.

	Fields:		SearchActionID - the unique ID assigned to this search action
				SearchID - the unique ID of this particular search
				SearchResultID - the unique ID assigned to this result

*********************************************************************************

bool CStoredProcedure::AddNewUserSearchAction(const TDVCHAR* pcSearchString, const TDVCHAR* pcSearchType, const TDVCHAR* pcSearchCondition, int iSearcherID, int iBestUserID, double dBestScore)
{
	// other fields can be left out and will be given NULL values automatically
	StartStoredProcedure("AddNewSearchAction");
	AddParam("SearchString", pcSearchString);
	AddParam("SearchType", pcSearchType);
	AddParam("SearchCondition", pcSearchCondition);
	AddParam("SearcherID", iSearcherID);
	AddParam("Users", 1);
	AddParam("UserID", iBestUserID);
	AddParam("Score", dBestScore);
// treat all searches as failed searches for testing
AddParam("ActiveSearch", 1);
AddParam("NotifyUser", 1);
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUsersActiveSearches(int iUserID);

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		iUserID - the ID of user whose active searches we want to update
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Updates all the currently active searches for this user.

	Fields:		???

*********************************************************************************

bool CStoredProcedure::UpdateUsersActiveSearches(int iUserID)
{
	TDVASSERT(iUserID > 0, "CStoredProcedure::UpdateUsersActiveSearches(...) called with non-positive UserID");
	// fail if called with invalid user ID
	if (iUserID <= 0)
	{
		return false;
	}
	// other fields can be left out and will be given NULL values automatically
	StartStoredProcedure("UpdateUsersActiveSearches");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchUsersActiveSearches(int iUserID);

	Author:		Kim Harries
	Created:	31/10/2000
	Inputs:		iUserID - the ID of user whose active searches we want to fetch
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Fetches info on all the seaches that are currently activated
				for this user.

	Fields:		SearchString string
				sSearchType string
				bApprovedEntries bit
				bSubmittedEntries bit
				bNormalEntries bit
				bForums bit
				bCategories bit
				bUsers bit
				iEntryID int
				iPostID int
				iUserID int
				dScore double
				dtOriginalSearch date
				dtResultDate date
				bNotifyUser bit

*********************************************************************************

bool CStoredProcedure::FetchUsersActiveSearches(int iUserID)
{
	TDVASSERT(iUserID > 0, "CStoredProcedure::FetchUsersActiveSearches(...) called with non-positive UserID");
	// fail if called with invalid user ID
	if (iUserID <= 0)
	{
		return false;
	}
	// other fields can be left out and will be given NULL values automatically
	StartStoredProcedure("FetchUsersActiveSearches");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);
}


/*********************************************************************************

	bool CStoredProcedure::FetchActiveSearchNotifications()

	Author:		Kim Harries
	Created:	14/11/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Fetches info on all the  active seaches that need the searcher
				to be notified of a better match.

	Fields:		???

*********************************************************************************

bool CStoredProcedure::FetchActiveSearchNotifications()
{
	StartStoredProcedure("FetchActiveSearchNotifications");
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);	
}

/*********************************************************************************

	bool CStoredProcedure::FetchActiveSearchNotificationsSummary(int* piTotalSearchers, int* piTotalSearches, int* piTotalCategoryMatches, int* piTotalEntryMatches, int* piTotalPostMatches, int* piTotalUserMatches, int* piTotalURLMatches)

	Author:		Kim Harries
	Created:	14/11/2000
	Inputs:		-
	Outputs:	piTotalSearchers		- various totals
				piTotalSearches
				piTotalCategoryMatches
				piTotalEntryMatches
				piTotalPostMatches
				piTotalUserMatches
				piTotalURLMatches
	Returns:	true if it worked, false otherwise
	Purpose:	Fetches summary info on all the  active seaches that need the searcher
				to be notified of a better match.

	Fields:		???

*********************************************************************************

bool CStoredProcedure::FetchActiveSearchNotificationsSummary(int* piTotalSearchers, int* piTotalSearches, int* piTotalCategoryMatches, int* piTotalEntryMatches, int* piTotalPostMatches, int* piTotalUserMatches, int* piTotalURLMatches)
{
	StartStoredProcedure("FetchActiveSearchNotificationsSummary");
	ExecuteStoredProcedure();

	if (piTotalSearchers != NULL)
	{
		*piTotalSearchers = GetIntField("Searchers");
	}
	if (piTotalSearches != NULL)
	{
		*piTotalSearches = GetIntField("Searches");
	}
	if (piTotalCategoryMatches != NULL)
	{
		*piTotalCategoryMatches = GetIntField("Category Matches");
	}
	if (piTotalEntryMatches != NULL)
	{
		*piTotalEntryMatches = GetIntField("Entry Matches");
	}
	if (piTotalPostMatches != NULL)
	{
		*piTotalPostMatches = GetIntField("Post Matches");
	}
	if (piTotalUserMatches != NULL)
	{
		*piTotalUserMatches = GetIntField("User Matches");
	}
	if (piTotalURLMatches != NULL)
	{
		*piTotalURLMatches = GetIntField("URL Matches");
	}
	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);	
}

/*********************************************************************************

	bool CStoredProcedure::UpdateSearchNotificationDates(int iUserID, const CTDVDateTime& dtDateOfNotification)

	Author:		Kim Harries
	Created:	15/11/2000
	Inputs:		iUserID - ID of user whose active searches we are updating
				dtDateOfNotifiaction - the date they were last notified
	Outputs:	-
	Returns:	true if it worked, false otherwise
	Purpose:	Updates all the users active searches notification dates to the
				one given, unless they were notified more recently.

	Fields:		???

*********************************************************************************

bool CStoredProcedure::UpdateSearchNotificationDates(int iUserID, const CTDVDateTime& dtDateOfNotification)
{
	StartStoredProcedure("UpdateSearchNotificationDates");
	AddParam("UserID", iUserID);
	AddParam("DateOfNotification", (LPCSTR)dtDateOfNotification.Format("%Y-%m-%d %H:%M:%S"));
	ExecuteStoredProcedure();

	// discard the error message but return false if anything has gone wrong
	CTDVString temp;
	return !GetLastError(&temp, iErrorCode);	
}
*/

/*********************************************************************************

	bool CStoredProcedure::FetchIndexEntries(const TDVCHAR* sLetter, CTDVString &sResult)

	Author:		Oscar Gillespie
	Created:	14/03/2000
	Modified:	17/03/2000
	Inputs:		const TDVCHAR* sLetter - the letter the user is interested in (first letter of entries)
				int iSiteID - ID of the site whose index we want
				bool bShowApproved - show approved entries?
				bool bShowSubmitted - show submitted entries?
				bool bShowUnapproved - show unapproved entries?
				CTDVString& sGroupFilter - Group name to filter on
				const int iTypesCount - Number of type values to filter against
				int* pTypesList - A list of types to filter on
				int iOrderBy - A Variable to determine the ordering of the results.
					0 (Default)	= Sort By Subject
					1			= Sort by date created
					2			= Sort by last updated
	Outputs:	sResult will hold the xml with article entries from the index
	Returns:	true if it worked, false otherwise
	Fields:		Subject varchar(255), 
				EntryID int, 
				h2g2ID int, 
				Status int, 
				UserID int
  
	Purpose:	Fetch a bunch of specified articles and create some xml describing the
				ones that match the query and also describe where they live

*********************************************************************************/

bool CStoredProcedure::FetchIndexEntries(const TDVCHAR* sLetter, int iSiteID, CTDVString& sResult,
										 bool bShowApproved, bool bShowSubmitted, bool bShowUnapproved,
										 CTDVString& sGroupFilter, const int iTypesCount, int* pTypesList,
										 int iOrderBy )
{

	StartStoredProcedure("articlesinindex");
	
	// add the letter they asked for and the kinds of status we want to show
	AddParam(sLetter);
	AddParam(iSiteID);

	AddParam(bShowApproved);
	AddParam(bShowSubmitted);
	AddParam(bShowUnapproved);

	// Check to see if we've been given any types to filter
	if (iTypesCount > 0 && pTypesList != NULL)
	{
		CTDVString sType;
		for (int i = 0; i < iTypesCount; i++)
		{
			sType.Empty();
			sType << "Type" << i+1;
			if (pTypesList[i] > 0)
			{
				AddParam(sType,pTypesList[i]);
			}
		}
	}
	
	// Check to see if we're looking for results with users in a specific group
	if (!sGroupFilter.IsEmpty())
	{
		AddParam("Group",sGroupFilter);
	}

	// If we've been given a sort value, add it
	if (iOrderBy > 0)
	{
		AddParam("OrderBy",iOrderBy);
	}

	//fire off the stored procedure	
	ExecuteStoredProcedure();

	return true;
	
}
#ifdef __MYSQL__

bool CStoredProcedure::FetchJournalEntries(int iForumID)
{
	m_sQuery.Empty();
	m_sQuery << "SELECT  Subject,\
      DatePosted,\
      EntryID,\
      t.ThreadID,\
      t1.LastPosting as LastReply,\
      t1.CountPosts as Cnt,\
      t.UserID,\
      t.Hidden,\
      b.text\
    FROM ThreadEntries t\
    INNER JOIN  blobs b ON b.blobid = t.blobid\
    INNER JOIN ThreadPostings t1\
      ON t.ThreadID = t1.ThreadID AND t.UserID = t1.UserID\
    WHERE  t.ForumID = " << iForumID << "\
        AND t.Parent IS NULL\
    ORDER BY t.DatePosted DESC";
	m_pDBO->ExecuteQuery(m_sQuery);
	return !IsEOF();
}

#else

bool CStoredProcedure::FetchJournalEntries(int iForumID)
{
	StartStoredProcedure("forumlistjournalthreadswithreplies");
	AddParam(iForumID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

#endif
/*********************************************************************************

	bool CStoredProcedure::UpdateUsersGroupMembership(int iUserID, const map<CTDVString, int>& Groups)

	Author:		Kim Harries
	Created:	30/03/2001
	Inputs:		iUserID - the ID of the user whose details are to be updated
				Groups - a map containing the info on which groups they are to be members of
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		???
	Purpose:	Provides a single method for updating a users group membership regardless of the
				number of groups or their names, hence continueing to work however many user groups
				are added to the DB.

*********************************************************************************/

bool CStoredProcedure::UpdateUsersGroupMembership(int iUserID, int iSiteID, const map<CTDVString, int>& Groups)
{
	TDVASSERT(iUserID > 0, "CStoredProcedure::UpdateUsersGroupMembership(...) called with non-positive user ID");

	if (iUserID <= 0)
	{
		return false;
	}

	CTDVString								sTemp;
	map<CTDVString, int>::const_iterator	it;
	CTDVString								sGroupName;
	int										iIsMember = 0;
	int										iCount = 0;
	bool									bSuccess = true;
	// first remove all the users current groups, then add all the one we wish them
	// to be members of
	StartStoredProcedure("clearusersgroupmembership");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	ExecuteStoredProcedure();
	// check for errors
	int iErrorCode;
	bSuccess = bSuccess && !GetLastError(&sTemp, iErrorCode);
	// if all okay and list isn't empty then proceed
	if (bSuccess && !Groups.empty())
	{
		// now go through our list of groups, adding them in batches of ten
		StartStoredProcedure("AddUserToGroups");
		AddParam(iUserID);
		AddParam(iSiteID);
		for (it = Groups.begin(); it != Groups.end(); it++)
		{
			sGroupName = it->first;
			iIsMember = it->second;
			if (iIsMember == 1)
			{
				// if we have reached the max number per batch then execute the SP and start again
				if (iCount > 0 && iCount % 10 == 0)
				{
					ExecuteStoredProcedure();
					// check for errors and break from loop if there are any
					bSuccess = bSuccess && !GetLastError(&sTemp, iErrorCode);
					if (!bSuccess)
					{
						break;
					}
					StartStoredProcedure("AddUserToGroups");
					AddParam(iUserID);
					AddParam(iSiteID);
				}
				// make sure group name is in upper case for XML output
				sGroupName.MakeUpper();
				iCount++;
				AddParam(sGroupName);
			}
		}
		if (bSuccess)
		{
			// do the final execution of the SP
			ExecuteStoredProcedure();
			bSuccess = bSuccess && !GetLastError(&sTemp, iErrorCode);
		//	StartStoredProcedure("SyncUserGroupsToPreferences");
		//	AddParam(iUserID);
		//	AddParam(iSiteID);
		//	ExecuteStoredProcedure();
		//	bSuccess = bSuccess && !GetLastError(&sTemp, iErrorCode);
		}
	}
	if (!bSuccess)
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::UpdateUsersGroupMembership(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::BeginUpdateUser(int iUserID)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		iUserID - the ID of the user whose details are to be updated
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Prepares to call a SP to update a users details. Must call each ot
				the appropriate update methods (e.g. UserUpdateUsername,
				UserUpdateFirstNames, etc.) and then finally call DoUserUpdate
				before the SP is actually executed.

*********************************************************************************/

bool CStoredProcedure::BeginUpdateUser(int iUserID, int iSiteID)
{
	TDVASSERT(iUserID > 0, "CStoredProcedure::BeginUpdateUser(...) called with non-positive user ID");

	// do sanity check on user ID
	if (iUserID <= 0)
	{
		return false;
	}
	StartStoredProcedure("updateuser2");
//	StartStoredProcedure("updateuser3");
	AddParam("UserID", iUserID);
	AddParam("SiteID", iSiteID);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateIsModerator(bool bIsModerator)

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		bIsModerator - new setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users group entry will be updated
				appropriately.

*********************************************************************************

bool CStoredProcedure::UserUpdateIsModerator(bool bIsModerator)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsModerator(...) uses unimplemented features of stored procedure");
	AddParam("IsModerator", bIsModerator);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateIsSub(bool bIsSub)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsSub - new setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users group entry will be updated
				appropriately.

*********************************************************************************

bool CStoredProcedure::UserUpdateIsSub(bool bIsSub)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsSub(...) uses unimplemented features of stored procedure");
	AddParam("IsSub", bIsSub);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateIsAce(bool bIsAce)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsAce - new setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users group entry will be updated
				appropriately.

*********************************************************************************

bool CStoredProcedure::UserUpdateIsAce(bool bIsAce)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsAce(...) uses unimplemented features of stored procedure");
	AddParam("IsAce", bIsAce);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateIsFieldResearcher(bool bIsFieldResearcher)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsFieldResearcher - new setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users group entry will be updated
				appropriately.

*********************************************************************************

bool CStoredProcedure::UserUpdateIsFieldResearcher(bool bIsFieldResearcher)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsFieldResearcher(...) uses unimplemented features of stored procedure");
	AddParam("IsFieldResearcher", bIsFieldResearcher);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateIsSub(bool bIsSectionHead)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsSectionHead - new setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users group entry will be updated
				appropriately.

*********************************************************************************

bool CStoredProcedure::UserUpdateIsSectionHead(bool bIsSectionHead)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsSectionHead(...) uses unimplemented features of stored procedure");
	AddParam("IsSectionHead", bIsSectionHead);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateIsArtist(bool bIsArtist)

	Author:		Kim Harries
	Created:	09/05/2000
	Inputs:		bIsArtist - new setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users group entry will be updated
				appropriately.

*********************************************************************************

bool CStoredProcedure::UserUpdateIsArtist(bool bIsArtist)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsArtist(...) uses unimplemented features of stored procedure");
	AddParam("IsArtist", bIsArtist);
	return true;
}

bool CStoredProcedure::UserUpdateIsGuru(bool bIsGuru)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsGuru(...) uses unimplemented features of stored procedure");
	AddParam("IsGuru", bIsGuru);
	return true;
}

bool CStoredProcedure::UserUpdateIsScout(bool bIsScout)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsScout(...) uses unimplemented features of stored procedure");
	AddParam("IsScout", bIsScout);
	return true;
}

bool CStoredProcedure::UserUpdateIsGroupMember(const TDVCHAR* pcGroupName, bool bIsMember)
{
	TDVASSERT(false, "Method CStoredProcedure::UserUpdateIsGroupMember(...) uses unimplemented features of stored procedure");

	CTDVString	sParamName = "Is";
	sParamName << pcGroupName;
// strip the trailing s???
//	sParamName = sParamName.Left(sParamName.GetLength() - 1);
	AddParam(sParamName, bIsMember);
	return true;
}
*/

/*********************************************************************************

	bool CStoredProcedure::UserUpdateUsername(const TDVCHAR* pUsername)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pUsername - the new username for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users username will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateUsername(const TDVCHAR* pUsername)
{
	AddParam("Username", pUsername);
	return true;
}

bool CStoredProcedure::UserUpdateTitle(const TDVCHAR* pTitle)
{
	AddParam("Title",pTitle);
	return true;
}

void CStoredProcedure::UserUpdateSiteSuffix(const TCHAR* pSiteSuffix)
{
	AddParam("SiteSuffix",pSiteSuffix);
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateFirstNames(const TDVCHAR* pFirstNames)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pFirstNames - the new first names for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users first names will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateFirstNames(const TDVCHAR* pFirstNames)
{
	AddParam("FirstNames", pFirstNames);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateLastName(const TDVCHAR* pLastName)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pLastName - the new last name for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users last name will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateLastName(const TDVCHAR* pLastName)
{
	AddParam("LastName", pLastName);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateEmail(const TDVCHAR* pEmail)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pEmail - the new email for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users email will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateEmail(const TDVCHAR* pEmail)
{
	AddParam("Email", pEmail);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdatePassword(const TDVCHAR* pPassword)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		pPassword - the new password for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users password will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdatePassword(const TDVCHAR* pPassword)
{
	AddParam("Password", pPassword);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateMasthead(int iMasthead)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		iMasthead - the new masthead for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users masthead will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateMasthead(int iMasthead)
{
	AddParam("Masthead", iMasthead);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateStatus(int iStatus)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		iStatus - the new status for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users status will be updated to
				the one provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateStatus(int iStatus)
{
	AddParam("Status", iStatus);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateActive(bool bActive)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		bActive - the new active setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users active flag will be updated to
				the value provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateActive(bool bActive)
{
	AddParam("Active", bActive);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UserUpdateAnonymous(bool bAnonymous)

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		bAnonymous - the new anonymous setting for this user
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and before a call to DoUserUpdate
				it adds a parameter so that the users anonymous flag will be updated to
				the value provided.

*********************************************************************************/

bool CStoredProcedure::UserUpdateAnonymous(bool bAnonymous)
{
	AddParam("Anonymous", bAnonymous);
	return true;
}

bool CStoredProcedure::UserUpdateCookie(const TDVCHAR* pCookie)
{
	AddParam("Cookie", pCookie);
	return true;
}

bool CStoredProcedure::UserUpdateDateJoined(const CTDVDateTime& rDateJoined)
{
	AddParam("DateJoined", rDateJoined);
	return true;
}

bool CStoredProcedure::UserUpdateDateReleased(const CTDVDateTime& rDateReleased)
{
	AddParam("DateReleased", rDateReleased);
	return true;
}

bool CStoredProcedure::UserUpdateJournal(int iJournal)
{
	AddParam("Journal", iJournal);
	return true;
}

bool CStoredProcedure::UserUpdateTaxonomyNode(int iNode)
{
	AddParam("TaxonomyNode", iNode);
	return true;
}

bool CStoredProcedure::UserUpdateSinBin(int iSinBin)
{
	AddParam("SinBin", iSinBin);
	return true;
}

bool CStoredProcedure::UserUpdateLatitude(double dLatitude)
{
	AddParam("Latitude", dLatitude);
	return true;
}

bool CStoredProcedure::UserUpdateLongitude(double dLongitude)
{
	AddParam("Longitude", dLongitude);
	return true;
}

bool CStoredProcedure::UserUpdatePrefSkin(const TDVCHAR* pPrefSkin)
{
	AddParam("PrefSkin", pPrefSkin);
	return true;
}

bool CStoredProcedure::UserUpdatePrefUserMode(int iPrefUserMode)
{
	AddParam("PrefUserMode", iPrefUserMode);
	return true;
}

bool CStoredProcedure::UserUpdatePrefForumStyle(int iPrefForumStyle)
{
	AddParam("PrefForumStyle", iPrefForumStyle);
	return true;
}

bool CStoredProcedure::UserUpdatePrefForumThreadStyle(int iPrefForumThreadStyle)
{
	AddParam("PrefForumThreadStyle", iPrefForumThreadStyle);
	return true;
}

bool CStoredProcedure::UserUpdatePrefForumShowMaxPosts(int iPrefForumShowMaxPosts)
{
	AddParam("PrefForumShowMaxPosts", iPrefForumShowMaxPosts);
	return true;
}

bool CStoredProcedure::UserUpdatePrefReceiveWeeklyMailshot(bool bPrefReceiveWeeklyMailshot)
{
	AddParam("PrefReceiveWeeklyMailshot", bPrefReceiveWeeklyMailshot);
	return true;
}

bool CStoredProcedure::UserUpdatePrefReceiveDailyUpdates(bool bPrefReceiveDailyUpdates)
{
	AddParam("PrefReceiveDailyUpdates", bPrefReceiveDailyUpdates);
	return true;
}

bool CStoredProcedure::UserUpdatePostcode(const TDVCHAR* pPostcode)
{
	AddParam("Postcode", pPostcode);
	return true;
}

bool CStoredProcedure::UserUpdateRegion(const TDVCHAR* pRegion)
{
	AddParam("Region", pRegion);
	return true;
}

bool CStoredProcedure::UserUpdateArea(const TDVCHAR* pArea)
{
	AddParam("Area", pArea);
	return true;
}

bool CStoredProcedure::UserUpdateAllowSubscriptions( bool bAllowSubscriptions )
{
	AddParam("AllowSubscriptions", bAllowSubscriptions);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DoUpdateUser()

	Author:		Kim Harries
	Created:	15/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUserUpdate and one or more calls to various
				UserUpdate methods this method completes the process by actually
				calling the stored procedure and finalising the changes.

*********************************************************************************/

bool CStoredProcedure::DoUpdateUser()
{
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::BeginUpdateArticle(int ih2g2ID)

	Author:		Kim Harries
	Created:	16/03/2000
	Inputs:		ih2g2ID - the ID of the article which is to be updated
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Prepares to call a SP to update a guide entry. Must call each ot
				the appropriate update methods (e.g. ArticleUpdateSubject,
				ArticleUpdateBody, etc.) and then finally call DoUpdateArticle
				before the SP is actually executed.

*********************************************************************************/

bool CStoredProcedure::BeginUpdateArticle(int ih2g2ID)
{
	TDVASSERT(ih2g2ID > 0, "CStoredProcedure::BeginUpdateArticle(...) called with non-positive h2g2 ID");
	
	//initialise bits
	m_iUpdateBits = 0;

	// do sanity check on ID
	if (ih2g2ID <= 0)
	{
		return false;
	}
	// need the actual entry ID for the SP
	int iEntryID = ih2g2ID / 10;
	StartStoredProcedure("updateguideentry");
	AddParam("EntryID", iEntryID);
	return true;
}
bool CStoredProcedure::BeginUpdateArticle(int ih2g2ID, int iUserID)
{
	TDVASSERT(ih2g2ID > 0, "CStoredProcedure::BeginUpdateArticle(...) called with non-positive h2g2 ID");
	
	//initialise bits
	m_iUpdateBits = 0;

	// do sanity check on ID
	if (ih2g2ID <= 0)
	{
		return false;
	}
	// need the actual entry ID for the SP
	int iEntryID = ih2g2ID / 10;
	StartStoredProcedure("updateguideentry");
	AddParam("EntryID", iEntryID);
	AddParam("editinguser", iUserID);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ArticleUpdateSubject(const TDVCHAR* pSubject)

	Author:		Kim Harries
	Created:	16/03/2000
	Inputs:		pSubject - the new subject for the article
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUpdateArticle and before a call to DoUpdateArticle
				it adds a parameter so that the users anonymous flag will be updated to
				the value provided.

*********************************************************************************/

bool CStoredProcedure::ArticleUpdateSubject(const TDVCHAR* pSubject)
{
	m_iUpdateBits |= ARTICLEUPDATESUBJECT;
	AddParam("Subject", pSubject);
	return true;
}

bool CStoredProcedure::ArticleUpdatePreProcessed(bool bPreProcessed)
{
	m_iUpdateBits |= ARTICLEUPDATEPREPROCESSED;
	AddParam("PreProcessed",bPreProcessed);
	return true;
}

bool CStoredProcedure::ArticleUpdatePermissions(bool bCanRead, bool bCanWrite, bool bCanChangePermissions)
{
	m_iUpdateBits |= ARTICLEUPDATEPERMISSIONS;
	AddParam("CanRead",bCanRead);
	AddParam("CanWrite",bCanWrite);
	AddParam("CanChangePermissions",bCanChangePermissions);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ArticleUpdateSubmittable(int iSubmittable)

	Author:		Dharmesh Raithatha
	Created:	8/30/01
	Inputs:		iSubmittable - currently 1 for yes - 0 for no
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Used after a call to BeginUpdateArticle and before a call to DoUpdateArticle
				it adds a parameter so that the users anonymous flag will be updated to
				the value provided.

*********************************************************************************/

bool CStoredProcedure::ArticleUpdateSubmittable(int iSubmittable)
{
	m_iUpdateBits |= ARTICLEUPDATESUBMITTABLE;
	AddParam("Submittable",iSubmittable);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ArticleUpdateType(int iType)

	Author:		Mark Neves
	Created:	25/9/2003
	Inputs:		iType = type of the article
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Used after a call to BeginUpdateArticle and before a call to DoUpdateArticle
				it adds a parameter so that the users anonymous flag will be updated to
				the value provided.

*********************************************************************************/

bool CStoredProcedure::ArticleUpdateType(int iType)
{
	m_iUpdateBits |= ARTICLEUPDATETYPE;
	AddParam("Type",iType);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ArticleUpdateDateCreated()

	Author:		Martin Robb
	Created:	16/08/2005
	Inputs:		
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Allows the Dates Created to be reset to the current datetime.
				Useful when an article changes status - eg becomes approved.

*********************************************************************************/

bool CStoredProcedure::ArticleUpdateDateCreated()
{
	m_iUpdateBits |= ARTICLEUPDATEDATECREATED;
	AddParam("updatedatecreated",true);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ArticleUpdateExtraInfo(CExtraInfo& ExtraInfo)

	Author:		Dharmesh Raithatha
	Created:	6/26/2003
	Inputs:		ExtraInfo - the extrainfo that you want to update the article with
	Outputs:	-
	Returns:	true if successfull, false otherwise	
	Purpose:	Used after a call to BeginUpdateArticle and before a call to DoUpdateArticle
				it adds a parameter so that the extrainfo will be updated in the article. 
				Essentially replaces the existing extrainfo


*********************************************************************************/

bool CStoredProcedure::ArticleUpdateExtraInfo(CExtraInfo& ExtraInfo)
{
	m_iUpdateBits |= ARTICLEUPDATEEXTRAINFO;
	CTDVString sExtraInfo;
	ExtraInfo.GetInfoAsXML(sExtraInfo);
	AddParam("ExtraInfo",sExtraInfo);
	return true;
}

bool CStoredProcedure::ArticleUpdateBody(const TDVCHAR* pBody)
{
	m_iUpdateBits |= ARTICLEUPDATEBODY;
	AddParam("BodyText", pBody);
	return true;
}

bool CStoredProcedure::ArticleUpdateStyle(int iStyle)
{
	m_iUpdateBits |= ARTICLEUPDATESTYLE;
	if (iStyle == 0)
	{
		AddNullParam("Style");
	}
	else
	{
		AddParam("Style", iStyle);
	}
	return true;
}

bool CStoredProcedure::ArticleUpdateStatus(int iStatus)
{
	m_iUpdateBits |= ARTICLEUPDATESTATUS;
	if (iStatus == 0)
	{
		AddNullParam("Status");
	}
	else
	{
		AddParam("Status", iStatus);
	}
	return true;
}

bool CStoredProcedure::ArticleUpdateEditorID(int iEditorID)
{
	m_iUpdateBits |= ARTICLEUPDATEEDITORID;
	if (iEditorID == 0)
	{
		AddNullParam("Editor");
	}
	else
	{
		AddParam("Editor", iEditorID);
	}
	return true;
}

bool CStoredProcedure::ArticleUpdateClubEditors(int iClubID)
{
	m_iUpdateBits |= ARTICLEUPDATECLUBEDITORS;
	if (iClubID == 0)
	{
		AddNullParam("GroupNumber");
	}
	else
	{
		AddParam("GroupNumber", iClubID);
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DoUpdateUser()

	Author:		Kim Harries
	Created:	16/03/2000
	Updated:	17/09/2004: Nick Stevenson
	Inputs:		-
	Outputs:	-
	Returns:	true successfull, false otherwise
	Fields:		NA
	Purpose:	Used after a call to BeginUpdateArticle and one or more calls to various
				ArticleUpdate methods this method completes the process by actually
				calling the stored procedure and finalising the changes.

				Update:
				Prior to execution a bit comparison is done on the value of m_iUpdateBits.
				If the correct article fields have been updated the stored procedure
				will need to add an event to to the Event Queue table so set set a 
				true value for the 'addevent' param

*********************************************************************************/

bool CStoredProcedure::DoUpdateArticle(bool bUpdateContentSignif/*=false*/, int iEditingUser/*=0*/)
{

	// check if the correct fields have been updated before adding a 
	// true value to indicate and event should be created.
	int iUpdateBits = (ARTICLEUPDATESUBJECT | ARTICLEUPDATEBODY);
	if( (iUpdateBits & m_iUpdateBits) > 0)
	{
		AddParam("addevent", 1);

		// an update of content signif is not always required
		// so we add params depending on whether or not values have 
		// been passed into this function
		if(bUpdateContentSignif)
		{
			AddParam("updatecontentsignif", 1);
			if(iEditingUser > 0)
			{
				AddParam("editinguser", iEditingUser);
			}else
			{
				AddNullParam("editinguser");
			}
		}
		else
		{
			AddNullParam("updatecontentsignif");
		}
	}

	// execute the procedure
	ExecuteStoredProcedure();

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateNewArticle(int iUserID, const TDVCHAR* pSubject, const TDVCHAR* pBody, CExtraInfo& ExtraInfo, int iStyle, int iSiteID, int iSubmittable, int iTypeID, int iStatus, int* pih2g2ID, bool bPreProcessed, bool bDefaultCanRead, bool bDefaultCanWrite, bool bDefaultCanChangePermissions)

	Author:		Kim Harries
	Created:	21/03/2000
	Inputs:		iUserID - user ID of the author
				pSubject - subject of the new entry
				pBody - content of the new entry
				ExtraInfo - extrainfo for new entry,
				iStyle - format style
				iSiteID - ID of site to own article
				iSubmittable = 
				bDefaultCanRead - Article permissions
				bDefaultCanWrite - Article permissions
				bDefaultCanChangePermissions - Article permissions
	Outputs:	pih2g2ID - int into which to put the id of the new guide entry, or
					zero if failed
	Returns:	true successful, false otherwise
	Fields:		NA
	Purpose:	Creates a new guide entry in the database with the given data.

*********************************************************************************/

bool CStoredProcedure::CreateNewArticle(int iUserID, const TDVCHAR* pSubject, const TDVCHAR* pBody, CExtraInfo& ExtraInfo, 
	int iStyle, int iSiteID, int iSubmittable, int iTypeID, int iStatus, int* pih2g2ID, bool bPreProcessed, 
	bool bDefaultCanRead, bool bDefaultCanWrite, bool bDefaultCanChangePermissions, int iForumStyle, int iGroupNumber)
{
	TDVASSERT(iUserID > 0, "CStoredProcedure::CreateNewArticle(...) called with no-positive user ID");
	TDVASSERT(pih2g2ID != NULL, "CStoredProcedure::CreateNewArticle(...) called with NULL pih2g2ID pointer");
	
	// can't create a guide entry without a user ID, or return the h2g2ID without
	// the address of the int to put it in
	if (iUserID <= 0 || pih2g2ID == NULL)
	{
		return false;
	}
	// TODO: check that this is correct

	CTDVString sExtraInfo;
	
	if (ExtraInfo.IsCreated())
	{
		ExtraInfo.GetInfoAsXML(sExtraInfo);
	}
	else
	{
		return false;
	}

	bool bSuccess = true;

	StartStoredProcedure("createguideentry");

	// author is both researcher and editor?
	AddParam("subject", pSubject);
	AddParam("bodytext", pBody);
	AddParam("extrainfo",sExtraInfo);
	AddParam("editor", iUserID);
	AddParam("style", iStyle);
	AddParam("status", iStatus); // a status of 3 == user entry (public)
	AddParam("typeid",iTypeID);
	AddNullParam("keywords"); // no keywords
	AddParam("researcher", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("submittable",iSubmittable);
	AddParam("preprocessed",bPreProcessed);
	AddParam("canread", bDefaultCanRead);
	AddParam("canwrite", bDefaultCanWrite);
	AddParam("canchangepermissions", bDefaultCanChangePermissions);
	//DaveW 20/10/04 - Set the discussion forum style
	AddParam("forumstyle", iForumStyle);
	if (iGroupNumber != 0)
	{
		AddParam("groupnumber", iGroupNumber);
	}
	else 
	{
		AddNullParam("groupnumber");
	}

	// MarkH 10/11/03 - Create a hash value for this entry. This enables us to check to see if we've
	//					already submitted any duplicates
	CTDVString sHash;
	CTDVString sSource;
	sSource << pSubject << "<:>" << pBody << "<:>" << iUserID << "<:>" << iSiteID << "<:>" << iStyle << "<:>" << iSubmittable << "<:>" << iTypeID;
	GenerateHash(sSource, sHash);

	// Add the UID to the param list
	if (!AddUIDParam("hash",sHash))
	{
		return false;
	}

	ExecuteStoredProcedure();

	// now check that the DB update was successful and get the ID
	// of the new entry
	*pih2g2ID = GetIntField("h2g2ID");
	if (*pih2g2ID == 0)
	{
		bSuccess = false;
	}
	else
	{
		bSuccess = true;
	}
	return bSuccess;
}

bool CStoredProcedure::GetPostContents(int iReplyTo, int iUserID, int *iForumID, int *iThreadID, CTDVString *sUsername, CTDVString *pSiteSuffix, CTDVString *sBody, CTDVString* pSubject, bool* oCanRead, bool* oCanWrite, int* oPostStyle, int* oPostIndex, int* oUserID)
{
	StartStoredProcedure("getthreadpostcontents");
	AddParam(iReplyTo);
	if (iUserID > 0)
	{
		AddParam(iUserID);
	}
	else
	{
		AddNullParam();
	}
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*iForumID = GetIntField("ForumID");
		*iThreadID = GetIntField("ThreadID");
		GetField("UserName", *sUsername);
		GetField("SiteSuffix", *pSiteSuffix);
		*oUserID = GetIntField("UserID");
		GetField("text", *sBody);
		GetField("Subject", *pSubject);
		*oCanRead = GetBoolField("CanRead");
		*oCanWrite = GetBoolField("CanWrite");
		*oPostStyle = GetIntField("PostStyle");
		*oPostIndex = GetIntField("PostIndex");
		return true;
	}
}

/*********************************************************************************

	bool CStoredProcedure::PostToForum(int iUserID, int iForumID, int iReplyTo, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int* oThreadID, int* oPostID, const TDVCHAR *pType, const TDVCHAR *pEventDate, bool bForcePreMod)

	Author:		Jim Lynn
	Created:	20/03/2000
	Inputs:		iUserID - ID of user posting
				iForumID - forum to which we're posting
				iReplyTo - post to which we're replying (or 0)
				iThreadID - thread to which we're replying
				sSubject - subject line
				sBody - body of text
				pType - Notice Type;
				pEventDate - Notice Event date
	Outputs:	oThreadID - New ThreadID created
				oPostID - ID of the post made
	Returns:	true if successful, false otherwise
	Purpose:	posts to a forum.

*********************************************************************************/

bool CStoredProcedure::PostToForum(int iUserID, int iForumID, int iReplyTo, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody,
								   int iPostStyle, int* oThreadID, int* oPostID, const TDVCHAR *pType, const TDVCHAR *pEventDate, bool bForceModerate, bool bForcePreModerate, bool bIgnoreModeration,
								   int iClub, int iNodeID /* = 0 */, const TDVCHAR* pIPAddress /* = NULL */, const TDVCHAR* pPhrases /* = NULL */,
								   bool bAllowQueuing /* = false */, bool* pbWasQueued /* = NULL */, bool* pbIsPreModPosting /* =NULL */,
								   bool* pbIsPreModerated /* = NULL */, const TDVCHAR* pBBCUID /*= NULL*/, bool bIsNotable /* = false */, const TDVCHAR* pModNotes /* = NULL */)
{
	CTDVString sHash;
	CTDVString sSource;
	sSource << pSubject << "<:>" << pBody << "<:>" << iUserID << "<:>" << iForumID << "<:>" << iThreadID << "<:>" << iReplyTo;
	GenerateHash(sSource, sHash);

	StartStoredProcedure("posttoforum", true);
	AddParam(iUserID);
	AddParam(iForumID);
	if (iReplyTo > 0)
	{
		AddParam(iReplyTo);
	}
	else
	{
		AddNullParam();
	}
	if (iThreadID > 0)
	{
		AddParam(iThreadID);
	}
	else
	{
		AddNullParam();
	}
	AddParam(pSubject);
	AddParam(pBody);
	AddParam(iPostStyle);

	// Add the UID to the param list
	if (!AddUIDParam(sHash))
	{
		return false;
	}

	AddNullParam();
	AddNullParam();

	// Add the notice type if given
	if (pType != NULL)
	{
		AddParam(pType);
	}
	else
	{
		AddNullParam();
	}
	
	// Add the eventdate if given
	if (pEventDate != NULL)
	{
		AddParam(pEventDate);
	}
	else
	{
		AddNullParam();
	}

	// Add the force moderation flag. Actually influences the unmoderated state.
	AddParam( bForceModerate );

	//Forces premoderation .
	AddParam( bForcePreModerate );

	//Flag to Ignore moderation eg editor / superuser. 
	AddParam(bIgnoreModeration);

	if ( iClub > 0 )
	{
		AddParam(iClub);
	}
	else
	{
		AddNullParam();
	}

	if ( iNodeID > 0)
	{	
		AddParam(iNodeID);
	}	
	else
	{
		AddNullParam();
	}

	if (pIPAddress != NULL && pIPAddress[0] != 0)
	{
		AddParam(pIPAddress);
	}
	else
	{
		AddNullParam();
	}

	if (pPhrases != NULL)
	{
		AddParam(pPhrases);
	}
	else
	{
		AddNullParam();
	}

	if (bAllowQueuing)
	{
		AddParam(1);
	}
	else
	{ 
		AddParam(0);
	}

	if (pBBCUID != NULL && pBBCUID[0] != 0)
	{
		AddUIDParam(pBBCUID);
	}
	else
	{
		AddNullParam();
	}

	if (bIsNotable)
	{
		AddParam(1);
	}
	else
	{ 
		AddParam(0);
	}

    // IsComment parameter
    AddParam(0);

    if ( pModNotes != NULL )
    {
        AddParam(pModNotes);
    }

	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*oThreadID = GetIntField("ThreadID");
		*oPostID = GetIntField("PostID");
		if (pbWasQueued != NULL)
		{
			*pbWasQueued = GetBoolField("WasQueued");
		}

		if (pbIsPreModPosting != NULL)
		{
			*pbIsPreModPosting = GetBoolField("IsPreModPosting");
		}
		if ( pbIsPreModerated != NULL ) 
		{
			*pbIsPreModerated = GetBoolField("IsPreModerated");
		}

		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::PostToEndOfThread(int iUserID, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int* oThreadID, int* oPostID)

	Author:		Kim Harries
	Created:	10/01/2001
	Inputs:		iUserID - ID of user posting
				iThreadID - thread to which we're replying
				sSubject - subject line
				sBody - body of text
	Outputs:	oPostID - ID of the post made
	Returns:	true if successful, false otherwise
	Purpose:	posts to the end of an existing thread

*********************************************************************************/

bool CStoredProcedure::PostToEndOfThread(int iUserID, int iThreadID, const TDVCHAR *pSubject, const TDVCHAR *pBody, int* oPostID)
{
	CTDVString sHash;
	CTDVString sSource;
	sSource << pSubject << "<:>" << pBody << "<:>" << iUserID << "<:>" << "0" << "<:>" << iThreadID << "<:>" << "0";
	GenerateHash(sSource, sHash);

	StartStoredProcedure("PostToEndOfThread");
	AddParam(iUserID);
	AddParam(iThreadID);
	AddParam(pSubject);
	AddParam(pBody);

	// Add the UID to the param list
	if (!AddUIDParam(sHash))
	{
		return false;
	}

	AddNullParam();
	AddNullParam();
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*oPostID = GetIntField("PostID");
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	int CStoredProcedure::GetIndexOfPostInThread(int iThreadID, int iPostID)

	Author:		Jim Lynn
	Created:	21/03/2000
	Inputs:		iThreadID - ID of thread containing post
				iPostID - ID of post in thread
	Outputs:	-
	Returns:	Position of the post in the list of threadentries - 
	Purpose:	this allows us to display the selection containing a particular 
				post when showing paged post contents

*********************************************************************************/

int CStoredProcedure::GetIndexOfPostInThread(int iThreadID, int iPostID)
{
	StartStoredProcedure("getindexofpost");
	AddParam(iThreadID);
	AddParam(iPostID);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		return GetIntField("Index");
	}
	else
	{
		return 0;
	}
}

bool CStoredProcedure::PostToJournal(int iUserID, int iJournalID, const TDVCHAR* pUsername, 
									 const TDVCHAR *pSubject, const TDVCHAR *pBody, int iSiteID, 
									 int iPostStyle, bool bForcePreMod, bool bIgnoreModeration,
									 const TDVCHAR* pIPAddress /* = NULL */, const TDVCHAR* pBBCUID /*= NULL*/)
{
	CTDVString sHash;
	CTDVString sSource;
	sSource << pSubject << "<:>" << pBody << "<:>" << iUserID << "<:>" << iJournalID << "<:>" << iPostStyle << "<:>ToJournal";
	GenerateHash(sSource, sHash);
	StartStoredProcedure("posttojournal");
	AddParam(iUserID);
	if (iJournalID > 0)
	{
		AddParam(iJournalID);
	}
	else
	{
		AddNullParam();
	}

	AddParam(pSubject);
	AddParam(pUsername);
	AddParam(pBody);
	AddParam(iSiteID);
	AddParam(iPostStyle);

	// Add the UID to the param list
	if (!AddUIDParam(sHash))
	{
		return false;
	}

	AddParam(bForcePreMod);
	AddParam(bIgnoreModeration);

	if (pIPAddress != NULL && pIPAddress[0] != 0)
	{
		AddParam(pIPAddress);
	}
	else
	{
		AddNullParam();
	}

	if (pBBCUID != NULL && pBBCUID[0] != 0)
	{
		AddUIDParam(pBBCUID);
	}
	else
	{
		AddNullParam();
	}

	ExecuteStoredProcedure();
	return (!IsEOF());
}

bool CStoredProcedure::ActivateNewEmail(int iUserID, int iKey, CTDVString* pReason)
{
	StartStoredProcedure("activatenewemailaddress");
	AddParam(iUserID);
	AddParam(iKey);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		GetField("Message",*pReason);
		if (GetIntField("Success") == 1)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		*pReason = "of an unknown error";
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::ChangeUser	Address(int iUserID, const TDVCHAR* pOldEmail, const TDVCHAR* pNewEmail, int* piSecretKey, CTDVString* pReport)

	Author:		Kim Harries
	Created:	26/03/2000
	Inputs:		iUserID - user whose email is being changed
				pOldEmail - their current email address
				pNewEmail - the new email address
	Outputs:	piSecretKey - the secret key for them to active atheir new email
				pReport - string with any status/error reprt
	Returns:	true if the change was successful, false if not
	Purpose:	Changes the users email in the database if possible and provides
				a secret key with which they can finalise the change.

*********************************************************************************/

bool CStoredProcedure::ChangeUserEmailAddress(int iUserID, const TDVCHAR* pOldEmail, const TDVCHAR* pNewEmail, int* piSecretKey, CTDVString* pReport)
{
	TDVASSERT(piSecretKey != NULL, "CStoredProcedure::ChangeUserEmailAddress(...) called with NULL piSecretKey");
	TDVASSERT(pReport != NULL, "CStoredProcedure::ChangeUserEmailAddress(...) called with NULL pReport");
	// must fail if address for secret key ouput not given
	if (piSecretKey == NULL)
	{
		return false;
	}
	StartStoredProcedure("storenewemailaddress");
	AddParam("UserID", iUserID);
	AddParam("OldEmail", pOldEmail);
	AddParam("NewEmail", pNewEmail);
	ExecuteStoredProcedure();
	// check if we have any fields at all
	if (IsEOF())
	{
		// something went wrong but we don't know what
		*pReport = "error accessing database";
		return false;
	}
	else
	{
		// we have some return fields
		int iSuccess = GetIntField("Success");
		int iKey = GetIntField("SecretKey");

		// only get status message if a string variable has been supplied to contain it
		if (pReport != NULL)
		{
			GetField("Message", *pReport);
		}
		// if failure flagged or do not have a secret key then fail
		if (iSuccess == 0 || iKey == 0)
		{
			return false;
		}
		else
		{
			// all okay so put the secret key in the output variable
			*piSecretKey = iKey;
			return true;
		}
	}
}

/*********************************************************************************

	bool CStoredProcedure::StoreEmailRegistration(const TDVCHAR *pEmail, CTDVString *pCookie, CTDVString *pKey, CTDVString *pPassword, int *piUserID, bool *pbExists)

	Author:		Jim Lynn
	Created:	26/03/2000
	Inputs:		pEmail - email address to store
	Outputs:	pCookie - Cookie from database
				pKey - code key to return in email
				pPassword - password if defined
				piUserID - UserID from database
				pbExists - true if the user already exists
	Returns:	-
	Purpose:	Registers a new email address, and returns details for the
				registration email. Will also return details for an already
				registered email address to allow password registration.

*********************************************************************************/

bool CStoredProcedure::StoreEmailRegistration(const TDVCHAR *pEmail, CTDVString *pCookie, CTDVString *pKey, CTDVString *pPassword, int *piUserID, bool *pbExists, bool *pbNew)
{
	StartStoredProcedure("storenewemail");
	AddParam(pEmail);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		GetField("Cookie",*pCookie);
		GetField("Password", *pPassword);
		GetField("Checksum", *pKey);
		*pbExists = GetBoolField("Exists");
		*piUserID = GetIntField("UserID");
		*pbNew = GetBoolField("New");
		return true;
	}
	return false;
}

/*********************************************************************************

	bool CStoredProcedure::ActivateUser(int iUserID, int iSecretKey, CTDVString* pCookie)

	Author:		Kim Harries
	Created:	03/04/2000
	Inputs:		iUserID - the ID of the user we are trying to activate
				iSecretKey - the secret key that authenticates this activation
	Outputs:	pCookie - the new cookie for this user
	Returns:	true if user was successfully activated, false if they could not
				be activated for some reason
	Purpose:	Activates the user either for the first time if they are a new user
				responding to their registration email, or re-activates a user
				who has logged out.

*********************************************************************************/

bool CStoredProcedure::ActivateUser(int iUserID, int iSecretKey, CTDVString* pCookie)
{
	// TODO: stuff
	TDVASSERT(pCookie != NULL, "CStoredProcedure::ActivateUser(...) called with NULL pCookie");

	// if we have nowhere to put our cookie then fail
	if (pCookie == NULL)
	{
		return false;
	}
	// execute the appropriate SP and then extract the info
	StartStoredProcedure("activateuser2");
	AddParam("testchecksum", iSecretKey);
	AddParam("userid", iUserID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		// if we have no data then something has gone wrong
		return false;
	}
	else
	{
		// otherwise get the cookie field and put it in our output variable
		// if this fails then the registration also fails
		return GetField("cookie", *pCookie);
	}
}


/*********************************************************************************

	bool CStoredProcedure::MarkForumThreadRead(int iUserID, int iForumID, int iThreadID, int iPostID)

	Author:		Jim Lynn
	Created:	30/03/2000
	Inputs:		iUserID - ID of current user
				iForumID - ID of forum
				iThreadID - ID of thread
				iPostID - Index of last post read
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	If the thread is in the user's favourite forums list, this
				function will mark it as being read up to the post specified

*********************************************************************************/

bool CStoredProcedure::MarkForumThreadRead(int iUserID, int iThreadID, int iPostID, bool bForce)
{
	StartStoredProcedure("markthreadread");
	AddParam(iUserID);
	AddParam(iThreadID);
	AddParam(iPostID);
	if (bForce) 
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	ExecuteStoredProcedure();
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CatGetNodeDetails(int iNodeID, CTDVString *pName, int *piCatID, CTDVString *pCatName, CTDVString *pDescription)

	Author:		Jim Lynn
	Created:	05/04/2000
	Inputs:		iNodeID - ID of the node in the hierarchy table
	Outputs:	pName - pointer to string to receive name of node
				piCatID - ptr to int to contain the cat ID
				pCatName - ptr to unique name of category
				pDescription - pre to string to hold description of category
	Returns:	true if found, false if not
	Purpose:	Returns the overall details of this node - names and so forth

*********************************************************************************/

bool CStoredProcedure::CatGetNodeDetails(int iNodeID, CTDVString *pName, int *piCatID, CTDVString *pCatName, CTDVString *pDescription)
{
	StartStoredProcedure("gethierarchynodedetails");
	AddParam(iNodeID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	GetField("DisplayName", *pName);
	*piCatID = GetIntField("CategoryID");
	GetField("UniqueName", *pCatName);
	GetField("Description", *pDescription);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAncestry(int iNodeID)

	Author:		Jim Lynn
	Created:	11/04/2000
	Inputs:		iNodeID - node in the categorisation hierarchy tree
	Outputs:	-
	Returns:	true if no error otherwise false
	Purpose:	Returns a result set giving the hierarchy in descending order
				of tree (i.e. ancestors first) allowing you to display the
				hierarchy of subjects in which this one lives
				No longer returns false if no resultset

*********************************************************************************/

bool CStoredProcedure::GetAncestry(int iNodeID)
{
	StartStoredProcedure("getancestry");
	AddParam(iNodeID);
	ExecuteStoredProcedure();
	if (HandleError("getancestry"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CatGetSubjects(int iNodeID)

	Author:		Jim Lynn
	Created:	11/04/2000
	Inputs:		iNodeID - ID of the node in the subject tree
	Outputs:	-
	Returns:	true if found, false otherwise
	Purpose:	Gets all the subjects (i.e. child nodes) of this node - gets
				a result set describing the subnodes

*********************************************************************************/

bool CStoredProcedure::CatGetSubjects(int iNodeID, bool& bSuccess)
{
	// Start the procedure
	StartStoredProcedure("getsubjectsincategory");

	// Add the params
	AddParam(iNodeID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getsubjectsincategory"))
	{
		return false;
	}

	// Set the success flag and return
	bSuccess = !IsEOF();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CatGetArticles(int iCatID)

	Author:		Jim Lynn
	Created:	11/04/2000
	Inputs:		iCatID - category ID (*not* node ID)
	Outputs:	-
	Returns:	true if succeeded, false otherwise
	Purpose:	Gets a list of all the articles in this category as a result set

*********************************************************************************/

bool CStoredProcedure::CatGetArticles(int iCatID)
{
	StartStoredProcedure("getarticlesincategory");
	AddParam(iCatID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::CacheGetForumMostRecentPost(int iForumID, int iThreadID, int *oPostID, CTDVDateTime *oDate)

	Author:		Jim Lynn
	Created:	11/04/2000
	Inputs:		iForumID - ID of forum
				iThreadID - ID of thread in forum
	Outputs:	oPostID - ptr to int to contain the number of posts in the thread
				oDate - ptr to date to receive the date of the most recent post
	Returns:	true if info found, false otherwise
	Purpose:	Used for caching. Gets the number of posts and the date of the last
				post, allowing the cache of messages and headers to work out if they're
				dirty or not.

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::CacheGetForumMostRecentPost(int iForumID, int iThreadID, int *oPostID, CTDVDateTime *oDate)
{
	CTDVString sQuery = "	SELECT  \
		CASE \
		WHEN 60*60*12 < UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(f.LastUpdated)) \
		THEN \
			60*60*12 \
		ELSE \
			UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(f.LastUpdated)) \
		END as DatePosted, \
		COUNT(*) as NumPosts \
		FROM ThreadEntries t \
			INNER JOIN Forums f \
			ON t.ForumID = f.ForumID \
		WHERE t.ForumID = @forumid AND t.ThreadID = @threadid";

	char pTemp[255];
	sprintf(pTemp,_T("%d"),iForumID);
	sQuery.Replace("@forumid", pTemp);
	sprintf(pTemp, _T("%d"),iThreadID);
	sQuery.Replace("@threadid", pTemp);
	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oPostID = GetIntField("NumPosts");
		int NumSeconds = GetIntField("DatePosted");
		*oDate = CTDVDateTime(NumSeconds);
		CTDVString sRes;
		oDate->GetAsXML(sRes);
		return true;
	}
}

#else

bool CStoredProcedure::CacheGetForumMostRecentPost(int iForumID, int iThreadID, int *oPostID, CTDVDateTime *oDate)
{
	StartStoredProcedure("cachegetforummostrecentpost");
	AddParam(iForumID);
	AddParam(iThreadID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oPostID = GetIntField("NumPosts");
		int NumSeconds = GetIntField("DatePosted");
		*oDate = CTDVDateTime(NumSeconds);
		CTDVString sRes;
		oDate->GetAsXML(sRes);
		return true;
	}
}

#endif

/*********************************************************************************

	bool CStoredProcedure::CacheGetThreadLastUpdated(int iThreadId, CTDVDateTime* pDate)

	Author:		Martin Robb
	Created:	22/03/06
	Inputs:		iThreadId
	Outputs:	pDate - returned date of thread last updated 
	Returns:	true if found, false otherwise
	Purpose:	Used to invalidate thread cache.

*********************************************************************************/
bool CStoredProcedure::CacheGetThreadLastUpdated( int iThreadId, CTDVDateTime* pLastUpdated )
{
	if ( iThreadId == 0 || pLastUpdated == NULL )
		return false;

	StartStoredProcedure("cachegetthreadlastupdated");
	AddParam("threadId", iThreadId);

	//Last Updated is 'seconds ago'
	int iLastUpdated = 0;
	AddOutputParam("lastupdated", &iLastUpdated);

	ExecuteStoredProcedure();

	//Output parameter available when resultset is processed.
	while ( !IsEOF() )
		MoveNext();

	*pLastUpdated = CTDVDateTime(iLastUpdated);

	return !HandleError("cachegetthreadlastupdated");
}

/*********************************************************************************

	bool CStoredProcedure::CacheGetMostRecentReviewForumThreadDate(int iReviewForumID, CTDVDateTime* pDate)

	Author:		Dharmesh Raithatha
	Created:	9/12/01
	Inputs:		iReviewForumID - review forum id
	Outputs:	pDate - returned date of last updated forum post
	Returns:	true if found, false otherwise
	Purpose:	Gets the date of the thread in the reivew forum which was last posted to.
				This allows the cache of thread headers to know when it's dirty.

*********************************************************************************/

bool CStoredProcedure::CacheGetMostRecentReviewForumThreadDate(int iReviewForumID, CTDVDateTime* pDate)
{
	StartStoredProcedure("cachegetmostrecentreviewforumthreaddate");
	AddParam(iReviewForumID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*pDate = CTDVDateTime(GetIntField("MostRecent"));
		CTDVString sRes;
		pDate->GetAsXML(sRes);
		return true;
	}
}

/*********************************************************************************

	bool CStoredProcedure::CacheGetMostRecentThreadDate(int iForumID, CTDVDateTime *pDate)

	Author:		Jim Lynn
	Created:	11/04/2000
	Inputs:		iForumID - forum ID
	Outputs:	pDate - returned date of last updated forum post
	Returns:	true if found, false otherwise
	Purpose:	Gets the date of the thread in the forum which was last posted to.
				This allows the cache of thread headers to know when it's dirty.

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::CacheGetMostRecentThreadDate(int iForumID, CTDVDateTime *pDate)
{
	CTDVString sQuery;
	sQuery << "SELECT CASE WHEN 60*60*12 < (UNIX_TIMESTAMP() - UNIX_TIMESTAMP(LastUpdated)) THEN 60*60*12 ELSE (UNIX_TIMESTAMP() - UNIX_TIMESTAMP(LastUpdated)) END as MostRecent\
	FROM Forums\
	WHERE ForumID = " << iForumID;

	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*pDate = CTDVDateTime(GetIntField("MostRecent"));
		CTDVString sRes;
		pDate->GetAsXML(sRes);
		return true;
	}
}

#else

bool CStoredProcedure::CacheGetMostRecentThreadDate(int iForumID, CTDVDateTime *pDate)
{
	StartStoredProcedure("cachegetmostrecentthreaddate");
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*pDate = CTDVDateTime(GetIntField("MostRecent"));
		CTDVString sRes;
		pDate->GetAsXML(sRes);
		return true;
	}
}

#endif

/*********************************************************************************

	bool CStoredProcedure::CacheGetArticleDate(int h2g2ID, CTDVDateTime *oDate)

	Author:		Jim Lynn
	Created:	11/04/2000
	Inputs:		h2g2ID - ID of the article
	Outputs:	oDate - receives the date the article was last updated
	Returns:	true/false, success failure
	Purpose:	Used by the cache to see if its copy of an article is out of
				date or not.

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::CacheGetArticleDate(int h2g2ID, CTDVDateTime *oDate)
{
	CTDVString sQuery = "SELECT LEAST(UNIX_TIMESTAMP() - UNIX_TIMESTAMP(LastUpdated),60*60*24)-1 as seconds \
		FROM GuideEntries g WHERE g.h2g2id = ";
		sQuery << h2g2ID;

	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oDate = CTDVDateTime(GetIntField("seconds"));
		return true;
	}
}

#else

bool CStoredProcedure::CacheGetArticleDate(int h2g2ID, CTDVDateTime *oDate	)
{
	StartStoredProcedure("cachegetarticledate");
	AddParam(h2g2ID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oDate = CTDVDateTime(GetIntField("seconds"));
		return true;
	}
}

#endif

/*********************************************************************************

	bool CStoredProcedure::CacheGetArticleInfo(int h2g2ID, CTDVDateTime *opDate = NULL, int* opTopicID = NULL, int* opBoardPromoID = NULL)

		Author:		Mark Howitt
        Created:	14/03/2005
        Inputs:		h2g2ID - The Id of the article you want to get the info about.
        Outputs:	opDate - A pointer to a Date Object that'll take the return value.
					opTopicID - A pointer to an int that will take the TopicId if found.
					opBoardPromoID - A Pointer to an int that'll take the BoardPromoID if found.
        Returns:	true if ok, false if not found or problems
        Purpose:	Used to get the cached date information to see if we are able to use
					the cache or read it from the database. Also gets the TopicID and BoardPromoID for the article.

*********************************************************************************/
bool CStoredProcedure::CacheGetArticleInfo(int h2g2ID, CTDVDateTime *opDate, int* opTopicID, int* opBoardPromoID)
{
	// Call the procedure
	StartStoredProcedure("cachegetarticleinfo");

	// Setup the params
	AddParam("h2g2id",h2g2ID);
	
	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("CacheGetArticleInfo") || IsEOF())
	{
		return false;
	}

	// Set the date if we're given a valid Date Object
	if (opDate != NULL)
	{
		*opDate = CTDVDateTime(GetIntField("seconds"));
	}

	// Fill in the Topic ID if we're given a valid pointer
	if (opTopicID != NULL)
	{
		*opTopicID = GetIntField("topicid");
	}

	// Fill in the BoardPromoID if we're given a valid pointer
	if (opBoardPromoID != NULL)
	{
		*opBoardPromoID = GetIntField("boardpromoid");
		if (*opBoardPromoID == 0)
		{
			// Check the Default board promo ID
			*opBoardPromoID = GetIntField("defaultboardpromoid");
		}
	}

	// Return the ok!
	return true;
}


#ifdef __MYSQL__

bool CStoredProcedure::CacheGetKeyArticleDate(const TDVCHAR *pName, int iSiteID, CTDVDateTime *oDate)
{
	CTDVString sQuery;
	sQuery = "SELECT @entryid := EntryID FROM KeyArticles ";
	sQuery << "WHERE ArticleName = '" << pName << "' AND DateActive <= NOW() AND SiteID = " << iSiteID <<"\
  ORDER BY DateActive DESC\
  LIMIT 0,1";
	m_pDBO->ExecuteQuery(sQuery);
	sQuery = "SELECT @dateactive = UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(DateActive)) FROM KeyArticles WHERE ArticleName = @artname AND DateActive <= NOW()";
	m_pDBO->ExecuteQuery(sQuery);

	sQuery = "SELECT @DateCreated := UNIX_TIMESTAMP() - UNIX_TIMESTAMP(DateCreated), @lastupdated := UNIX_TIMESTAMP() - UNIX_TIMESTAMP(LastUpdated)\
FROM GuideEntries g WHERE g.Entryid = @entryid";
	m_pDBO->ExecuteQuery(sQuery);

	sQuery = "SELECT LEAST(@dateactive, @lastupdated, @DateCreated, 60*60*24) as tval";

	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oDate = CTDVDateTime(GetIntField("Seconds"));
		CTDVString sRes;
		oDate->GetAsXML(sRes);
		return true;
	}
}

#else

bool CStoredProcedure::CacheGetKeyArticleDate(const TDVCHAR *pName, int iSiteID, CTDVDateTime *oDate)
{
	StartStoredProcedure("cachegetkeyarticledate");
	AddParam(pName);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oDate = CTDVDateTime(GetIntField("Seconds"));
		CTDVString sRes;
		oDate->GetAsXML(sRes);
		return true;
	}
}

#endif

/*********************************************************************************

	bool CStoredProcedure::AddEditHistory(int h2g2ID, int iUserID, int iAction, const TDVCHAR *pReason)

	Author:		Jim Lynn
	Created:	13/04/2000
	Inputs:		h2g2ID - ID of article
				iUserID - ID of user making the change
				iAction - Action performed
				pReason - textual description of action performed
	Outputs:	-
	Returns:	true
	Purpose:	Adds an entry into the edit history when an article is edited.

*********************************************************************************/

bool CStoredProcedure::AddEditHistory(int h2g2ID, int iUserID, int iAction, const TDVCHAR *pReason)
{
	int iEntryID = h2g2ID / 10;
	StartStoredProcedure("createedithistory");
	AddParam(iEntryID);
	AddParam(iUserID);
	AddParam(iAction);
	AddNullParam();
	AddParam(pReason);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchUserGroups(int iUserID)

	Author:		Kim Harries
	Created:	10/05/2000
	Inputs:		iUserID - ID of user whose groups we are finding
	Outputs:	-
	Returns:	true if successfull, flase if not
	Purpose:	Fetchs the names of all the groups this user belongs to

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::FetchUserGroups(int iUserID, int iSiteID)
{
	CTDVString sQuery;
	sQuery << "SELECT g.Name FROM groups g \
INNER JOIN GroupMembers m ON m.GroupID = g.GroupID \
WHERE m.UserID = " << iUserID << " AND g.UserInfo = 1 AND m.SiteID = " << iSiteID;

	CTDVString temp;

	m_pDBO->ExecuteQuery(sQuery);
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

#else

bool CStoredProcedure::FetchUserGroups(int iUserID, int iSiteID)
{
	CTDVString temp;

	StartStoredProcedure("fetchusersgroups");
	AddParam("UserID", iUserID);
	AddParam("siteid", iSiteID);
	ExecuteStoredProcedure();
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

#endif


/*********************************************************************************

	int CStoredProcedure::GetIndexOfThreadInForum(int iThreadID, int iForumID)

	Author:		Jim Lynn
	Created:	20/05/2000
	Inputs:		iThreadID - ID of the thread whose index we want
	Outputs:	iForumID - ID of the forum containing the thread
	Returns:	index of the thread in the forum
	Purpose:	Tells us which block of threads to display for a particular thread

*********************************************************************************/

#ifdef __MYSQL__

int CStoredProcedure::GetIndexOfThreadInForum(int iThreadID, int iForumID)
{
	CTDVString sQuery;
	sQuery << "SELECT @lastposted := LastPosted FROM Threads WHERE ThreadID = " << iThreadID;
	m_pDBO->ExecuteQuery(sQuery);

	sQuery.Empty();
	sQuery << "select count(*) as 'Index' from Threads\
	WHERE ForumID = " << iForumID << " AND LastPosted > @lastposted AND VisibleTo IS NULL";
	m_pDBO->ExecuteQuery(sQuery);

	if (!IsEOF())
	{
		return GetIntField("Index");
	}
	else
	{
		return 0;
	}

}

#else

int CStoredProcedure::GetIndexOfThreadInForum(int iThreadID, int iForumID)
{
	StartStoredProcedure("getindexofthread");
	AddParam(iThreadID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		return GetIntField("Index");
	}
	else
	{
		return 0;
	}

}

#endif

#if defined(_ADMIN_VERSION) // methods only available in the admin version

/*********************************************************************************

	bool CStoredProcedure::FetchUsersMailshotSubscriptions(int iUserID, bool* pbMonthly, bool* pbWeekly, bool* pbDaily, bool* pbOneOff)

	Author:		Kim Harries
	Created:	24/08/2000
	Inputs:		iUserID - ID of the user whose details we are fetching
	Outputs:	bMonthly - current state of subscription to monthly newsletter
				bWeekly - current state of subscription to weekly newsletter
				bDaily - current state of subscription to daily newsletter
				bOneOff - current state of subscription to oneoff newsletter
	Returns:	true for success
	Purpose:	Fetches this users current status with regard to mailshot subscriptions.
				Places the values in the appropriate output variables, but also returns
				them in the following fields:

				bMonthly	bit
				bWeekly		bit
				bDaily		bit
				bOneOff		bit

*********************************************************************************/

bool CStoredProcedure::FetchUsersMailshotSubscriptions(int iUserID, bool* pbMonthly, bool* pbWeekly, bool* pbDaily, bool* pbOneOff)
{
	TDVASSERT(pbMonthly != NULL && pbWeekly != NULL && pbDaily != NULL && pbOneOff != NULL, "NULL output parameter in CStoredProcedure::FetchUsersMailshotSubscriptions(...)");
	// check output parameters have been provided
	if (pbMonthly == NULL || pbWeekly == NULL || pbDaily == NULL || pbOneOff == NULL)
	{
		return false;
	}

	CTDVString temp;

	StartStoredProcedure("FetchNewsletterSubscriptions");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	int iErrorCode;
	if (!GetLastError(&temp, iErrorCode))
	{
		*pbMonthly = GetBoolField("Monthly");
		*pbWeekly = GetBoolField("Weekly");
		*pbDaily = GetBoolField("Daily");
		*pbOneOff = GetBoolField("OneOff");
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUsersMailshotSubscriptions(int iUserID, bool bMonthly, bool bWeekly, bool bDaily, bool bOneOff)

	Author:		Kim Harries
	Created:	24/08/2000
	Inputs:		iUserID - ID of user we are updating
				bMonthly - new state for subscription to monthly newsletter
				bWeekly - new state for subscription to weekly newsletter
				bDaily - new state for subscription to daily newsletter
				bOneOff - new state for subscription to oneoff newsletter
	Outputs:	-
	Returns:	true for success
	Purpose:	Updates the specified users subscription to newsletters. Will change
				the preference values in the Preferences table, as well as inserting
				or changing the cancelled status in the Membership table as appropriate.

*********************************************************************************/

bool CStoredProcedure::UpdateUsersMailshotSubscriptions(int iUserID, bool bMonthly, bool bWeekly, bool bDaily, bool bOneOff)
{
	CTDVString temp;

	StartStoredProcedure("UpdateNewsletterSubscription");
	AddParam("UserID", iUserID);
	AddParam("Monthly", bMonthly);
	AddParam("Weekly", bWeekly);
	AddParam("Daily", bDaily);
	AddParam("OneOff", bOneOff);
	ExecuteStoredProcedure();
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchMailshotDetails(const TDVCHAR* pMailshotName)

	Author:		Kim Harries
	Created:	23/08/2000
	Inputs:		pMailshotName - name of the mailshot whose details we want
	Outputs:	-
	Returns:	true for success
	Purpose:	Fetches the details of the named mailshot. Fields returned are:

				ShotName	string
				ShotID		int
				ListID		int
				Status		int
				FromName	string
				FromAddress	string
				Subject		string
				Text		string

*********************************************************************************/

bool CStoredProcedure::FetchMailshotDetails(const TDVCHAR* pMailshotName)
{
	CTDVString temp;

	StartStoredProcedure("FetchMailshotDetails");
	AddParam("ShotName", pMailshotName);
	ExecuteStoredProcedure();
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchMailingListMembers(int iListID)

	Author:		Kim Harries
	Created:	24/08/2000
	Inputs:		iListID - the ID of the mailing list whose members we want
	Outputs:	-
	Returns:	true for success
	Purpose:	Fetches the members belonging to a particular mailing list. Fields
				returned are:

				Email		string
				Username	string
				UserID		int

*********************************************************************************/

bool CStoredProcedure::FetchMailingListMembers(int iListID)
{
	CTDVString temp;

	StartStoredProcedure("FetchMailingListMembers");
	AddParam("ListID", iListID);
	ExecuteStoredProcedure();
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUsersSendRequests(int iUserID, int iShotID)

	Author:		Kim Harries
	Created:	24/08/2000
	Inputs:		iUserID - the user whose send requests is to be updated
				iShotID - the mailshot which has been sent to them
	Outputs:	-
	Returns:	true for success
	Purpose:	Updates the records to indicate that a particular mailshot was
				successfully sent to a particular user.

*********************************************************************************/

bool CStoredProcedure::UpdateUsersSendRequests(int iUserID, int iShotID)
{
	CTDVString temp;

	StartStoredProcedure("UpdateUsersSendRequests");
	AddParam("UserID", iUserID);
	AddParam("ShotID", iShotID);
	ExecuteStoredProcedure();
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchUsersSecretKey(int iUserID, int* piSecretKey)

	Author:		Kim Harries
	Created:	29/08/2000
	Inputs:		iUserID - the user whose secret key value we want
	Outputs:	piSecretKey - the secret key value calculated from their cookie
	Returns:	true for success
	Purpose:	Returns the secret key value calculated from this users
				cookie which can be used for confirmation of identity within
				URL requests such as registration or subscription changes.

*********************************************************************************/

bool CStoredProcedure::FetchUsersSecretKey(int iUserID, int* piSecretKey)
{
	TDVASSERT(piSecretKey != NULL, "NULL piSecretKey in CStoredProcedure::FetchUsersSecretKey(...)");
	if (piSecretKey == NULL)
	{
		return false;
	}

	CTDVString temp;

	StartStoredProcedure("getregistrationkey");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	*piSecretKey = GetIntField("Key");
	int iErrorCode;
	return !GetLastError(&temp, iErrorCode);
}

#endif // _ADMIN_VERSION

/*********************************************************************************

	bool CStoredProcedure::FetchNewUsers(int iNumberOfUnits, const TDVCHAR* pUnitType, 
		bool bFilterUsers, cosnt CTDVString * pFilterType, int iSiteID, int iShowUpdatingUsers)

	Author:		Kim Harries
	Created:	02/09/2000
	Inputs:		iNumberOfUnits - the number of time units since registration to
					use when determining if a user counts as new.
				pUnitType - the type of unit to use. Default is day, but valid values
					include hour, month, week, year, etc.
				bOnlyThoseWithMastheads - true if only want to return users that
					have written a homepage introduction. Defaults to false.
				bFilterUsers - true if only want subset of users
				sFilterType - should be not NULL if bFilterUsers is true. could be
				"haveintroduction" - users who created the introduction in their Personal
				Space; "noposting" - users who created the introduction in their Personal
				Space, but have no postings to it.
	Outputs:	-
	Returns:	true for success
	Purpose:	Fetches all the users that registered within the specified number
				of time units since the current date/time.

	Fields:		UserID		int
				Username	varchar
				DateJoined	date
				Masthead	int

*********************************************************************************/

bool CStoredProcedure::FetchNewUsers(int iNumberOfUnits, const TDVCHAR* pUnitType, 
									 bool bFilterUsers,
									 const TDVCHAR* pFilterType,
									 int iSiteID, 
									 int iShowUpdatingUsers)
{
	TDVASSERT(iNumberOfUnits > 0, "iNumberOfUnits <= 0 in CStoredProcedure::FetchNewUsers(...)");

	CTDVString sTemp;
	int iErrorCode;

	StartStoredProcedure("FetchNewUsers");
	AddParam("NumberOfUnits", iNumberOfUnits);
	AddParam("UnitType", pUnitType);
	AddParam("FilterUsers", (int)bFilterUsers);
	AddParam("FilterType", pFilterType);
	AddParam("SiteID", iSiteID);
	AddParam("ShowUpdatingUsers", iShowUpdatingUsers);
	ExecuteStoredProcedure();
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::IsUserSubscribed(int iUserID, int iThreadID, int iForumID, bool* pbThreadSubscribed, bool* pbForumSubscribed)

	Author:		Jim Lynn
	Created:	21/07/2000
	Inputs:		iUserID - ID of the current user
				iThreadID - ID of the thread we're interested in
				iForumID - ID of the forum containing the thread
	Outputs:	pbThreadSubscribed - true or false inidcating subscribed state
				pbForumSubscribed - true or false inidcating subscribed state
	Returns:	true if database returned value
				false if not (i.e. database error)
	Purpose:	Looks and sees if the user has an entry in the ThreadPostings
				table, which tells us if he wants to be notified of postings to
				the thread or forum.

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::IsUserSubscribed(int iUserID, int iThreadID, int iForumID, bool* pbThreadSubscribed, bool* pbForumSubscribed)
{
	CTDVString sQuery;
	sQuery << "SELECT CASE WHEN f.ForumID IS NULL THEN 0 ELSE 1 END as ForumSubscribed, CASE WHEN t.ThreadID IS NULL THEN 0 ELSE 1 END  as ThreadSubscribed\
	FROM Users u\
	LEFT JOIN ThreadPostings t ON t.UserID = u.userid AND t.ThreadID = " << iThreadID << "\
	LEFT JOIN FaveForums f ON f.UserID = u.UserID AND f.ForumID = " << iForumID << "\
	WHERE u.UserID = " << iUserID;
	m_pDBO->ExecuteQuery(sQuery);
	if (!IsEOF())
	{
		*pbThreadSubscribed =  (GetIntField("ThreadSubscribed") == 1);
		*pbForumSubscribed =  (GetIntField("ForumSubscribed") == 1);
		return true;
	}
	else
	{
		return false;
	}
}

#else

bool CStoredProcedure::IsUserSubscribed(int iUserID, int iThreadID, int iForumID, bool* pbThreadSubscribed, bool* pbForumSubscribed, int* piLastPostCountRead, int* piLastUserPostID)
{
	StartStoredProcedure("isusersubscribed");
	AddParam(iUserID);
	AddParam(iThreadID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*pbThreadSubscribed =  (GetIntField("ThreadSubscribed") == 1);
		*pbForumSubscribed =  (GetIntField("ForumSubscribed") == 1);
		*piLastPostCountRead = GetIntField("LastPostCountRead");
		*piLastUserPostID = GetIntField("LastUserPostID");
		return true;
	}
	else
	{
		return false;
	}
}

#endif

/*********************************************************************************

	bool CStoredProcedure::SubscribeToThread(int iUserID, int iThreadID, int iForumID)

	Author:		Jim Lynn
	Created:	19/09/2000
	Inputs:		iUserID - ID of user
				iThreadID - ID of the thread to subscribe to
				iForumID - ID of the forum containing the thread
	Outputs:	-
	Returns:	-
	Purpose:	Subscribes to the given thread so the user will receive
				updates when the thread is posted to.

*********************************************************************************/

bool CStoredProcedure::SubscribeToThread(int iUserID, int iThreadID, int iForumID)
{
	StartStoredProcedure("subscribetothread");
	AddParam(iUserID);
	AddParam(iThreadID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UnsubscribeFromThread(int iUserID, int iThreadID, int iForumID)

	Author:		Jim Lynn
	Created:	19/09/2000
	Inputs:		iUserID - ID of user
				iThreadID - ID of thread to unsubscribe
				iForumID - ID of forum containing thread
	Outputs:	-
	Returns:	-
	Purpose:	Unsubscribed the user from the thread so they don't receive any
				future updates about the given thread

*********************************************************************************/

bool CStoredProcedure::UnsubscribeFromThread(int iUserID, int iThreadID, int iForumID)
{
	StartStoredProcedure("unsubscribefromthread");
	AddParam(iUserID);
	AddParam(iThreadID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	return true;

}

/*********************************************************************************

	bool CStoredProcedure::SubscribeToForum(int iUserID, int iForumID)

	Author:		Jim Lynn
	Created:	19/09/2000
	Inputs:		iUserID - ID of user
				iForumID - ID of the forum to which the user is subscribing
	Outputs:	-
	Returns:	-
	Purpose:	Subscribes the user to the forum, meaning any *new* conversations
				will appear on their recent conversations page.

*********************************************************************************/

bool CStoredProcedure::SubscribeToForum(int iUserID, int iForumID)
{
	StartStoredProcedure("subscribetoforum");
	AddParam(iUserID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	return true;

}

/*********************************************************************************

	bool CStoredProcedure::UnsubscribeFromForum(int iUserID, int iForumID)

	Author:		Jim Lynn
	Created:	19/09/2000
	Inputs:		iUserID - ID of user
				iForumID - ID of forum to unsubscribe
	Outputs:	-
	Returns:	-
	Purpose:	unsubscribes from the forum. Means that new conversations will
				no longer appear on their recent conversations list

*********************************************************************************/

bool CStoredProcedure::UnsubscribeFromForum(int iUserID, int iForumID)
{
	StartStoredProcedure("unsubscribefromforum");
	AddParam(iUserID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UnsubscribeFromJournalThread(int iUserID, int iThreadID, int iForumID)

	Author:		Jim Lynn
	Created:	19/09/2000
	Inputs:		iUserID - user ID
				iThreadID - thread the user wishes to remove
				iForumID - ID of forum
	Outputs:	-
	Returns:	-
	Purpose:	removes the entry in ThreadPostings for the given journal entry.
				This will make the entry disappear from the user's homepage.

*********************************************************************************/

bool CStoredProcedure::UnsubscribeFromJournalThread(int iUserID, int iThreadID, int iForumID)
{
	StartStoredProcedure("unsubscribefromjournalthread");
	AddParam(iUserID);
	AddParam(iThreadID);
	AddParam(iForumID);
	ExecuteStoredProcedure();
	return true;

}


/*********************************************************************************

	bool CStoredProcedure::LogRegistrationAttempt(int iUserID, TDVCHAR *pEmail, TDVCHAR *pIPaddress)

	Author:		Jim Lynn
	Created:	20/09/2000
	Inputs:		iUserID - ID of user registering the email address (or 0)
				pEmail - email address being registered
				pIPaddress - string representing IP address
	Outputs:	-
	Returns:	-
	Purpose:	Logs a user attempting to register an email address

*********************************************************************************/

bool CStoredProcedure::LogRegistrationAttempt(int iUserID, const TDVCHAR *pEmail, const TDVCHAR *pIPaddress)
{
	StartStoredProcedure("logregistrationattempt");
	if (iUserID > 0)
	{
		AddParam(iUserID);
	}
	else
	{
		AddNullParam();
	}
	AddParam(pEmail);
	AddParam(pIPaddress);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ChangePassword(int iUserID, const TDVCHAR *pPassword)

	Author:		Jim Lynn
	Created:	20/09/2000
	Inputs:		iUserID - user ID
				pPassword - password to set
	Outputs:	-
	Returns:	-
	Purpose:	Sets the password during fast-track registration

*********************************************************************************/

bool CStoredProcedure::ChangePassword(int iUserID, const TDVCHAR *pPassword)
{
	StartStoredProcedure("changepassword");
	AddParam(iUserID);
	AddParam(pPassword);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CancelUserAccount(int iUserID, const TDVCHAR *pKey, int *piResult, CTDVString* pReason)

	Author:		Jim Lynn
	Created:	21/09/2000
	Inputs:		iUserID - ID of account to cancel
				pKey - secret key
	Outputs:	piResult - numeric result (0 means success)
				pReason - string containing reason it failed
	Returns:	false if no result found
	Purpose:	Cancels a user account

*********************************************************************************/

bool CStoredProcedure::CancelUserAccount(int iUserID, const TDVCHAR *pKey, int *piResult, CTDVString* pReason)
{
	StartStoredProcedure("canceluseraccount");
	AddParam(iUserID);
	AddParam(pKey);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*piResult = GetIntField("Result");
		GetField("Reason", *pReason);
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::FetchEmailText(const TDVCHAR *pEmailName, CTDVString *pText, CTDVString *pSubject)

	Author:		Jim Lynn
	Created:	25/09/2000
	Inputs:		pEmailName - key article name to fetch
	Outputs:	pText - text of the article
				pSubject - Subject line for the article
	Returns:	true if found, false otherwise
	Purpose:	Fetches the email text of an email.

*********************************************************************************/
//TODO:IL:move to CModerationEmail
bool CStoredProcedure::FetchEmailText(int iSiteID, const TDVCHAR *pEmailName, 
									  CTDVString *pText, CTDVString *pSubject)
{
	StartStoredProcedure("fetchemailtext");
	AddParam("SiteID", iSiteID);
	AddParam("emailname", pEmailName);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		if (pText != NULL)
		{
			GetField("text", *pText);
		}

		if (pSubject != NULL)
		{
			GetField("Subject", *pSubject);
		}
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::LogUserCancelled(int iUserID, const TDVCHAR *pIPaddress, int iUserCancelled)

	Author:		Jim Lynn
	Created:	26/09/2000
	Inputs:		iUserID - ID of the user *doing* the cancelling
				pIPaddress - address of canclling user
				iUserCancelled - ID of the user they have cancelled
	Outputs:	-
	Returns:	true
	Purpose:	Logs users cancelling other user accounts.

*********************************************************************************/

bool CStoredProcedure::LogUserCancelled(int iUserID, const TDVCHAR *pIPaddress, int iUserCancelled)
{
	StartStoredProcedure("logusercancelled");
	if (iUserID > 0)
	{
		AddParam(iUserID);
	}
	else
	{
		AddNullParam();
	}
	AddParam(pIPaddress);
	AddParam(iUserCancelled);
	ExecuteStoredProcedure();
	return true;

}

/*********************************************************************************

	bool CStoredProcedure::VerifyUserKey(int iUserID, int iKey, int *oResult, CTDVString *oReason, CTDVString *oEmail, CTDVDateTime *oDateReleased, int* oActive)

	Author:		Jim Lynn
	Created:	28/09/2000
	Inputs:		iUserID - ID of the user we wish to verify
				iKey - secret key (checksum of the cookie)
	Outputs:	oResult - integer describing the result
					0 - success
					1 - account permanently suspended
					2 - account suspended until the DateReleased field
					3 - key does not match field
				oReason - string describing error
				oEmail - email address of the user
				oDateReleased - Date the user will be released
				oActive - 0 if the user is not currently active, 1 if they are
	Returns:	true
	Purpose:	Used in activation of users as a pre-check before activation in
				case the keys don't match or the user is sinbinned

*********************************************************************************/

bool CStoredProcedure::VerifyUserKey(int iUserID, int iKey, int *oResult, CTDVString *oReason, CTDVString *oEmail, CTDVDateTime *oDateReleased, int* oActive)
{
	StartStoredProcedure("verifyuserkey");
	AddParam(iUserID);
	AddParam(iKey);
	ExecuteStoredProcedure();
	*oResult = GetIntField("Result");
	*oActive = GetIntField("Active");
	GetField("Reason", *oReason);
	if (FieldExists("Email"))
	{
		GetField("Email", *oEmail);
	}
	if (FieldExists("DateReleased"))
	{
		*oDateReleased = GetDateField("DateReleased");
	}
	return true;
}

bool CStoredProcedure::AddRecommendedUser(int iUserID, int iRecommendedUserID)
{
	StartStoredProcedure("addrecommendeduser");
	AddParam(iUserID);
	AddParam(iRecommendedUserID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdatePostingsModeration(int iForumID, int iThreadID, int iPostID, int iModID, int iStatus, const TDVCHAR* pcNotes, int iReferTo)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		iForumID - ID of the forum
				iThreadID - ID of the thread
				iPostID - ID of the post they are moderating
				iModID - the moderation ID
				iStatus - the moderation decision
				pcNotes - notes to attach to the decision, if any
				iReferTo - the userID to refer this psot to, if any
				iRefferedBy - the user ID of the user who refers
				iModStatus - ThreadModeration status 
				bNewStyle - Indicates new or old moderation 
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::UpdatePostingsModeration(int iForumID, int iThreadID, 
												int iPostID, int iModID, 
												int iStatus, const TDVCHAR* pcNotes, 
												int iReferTo, int iReferredBy,
												int iModStatus, bool bNewStyle  )
{
	CTDVString	sNotes = pcNotes;
	// now call the actual SP
	if ( bNewStyle )
		StartStoredProcedure("moderatepost");
	else
		StartStoredProcedure("moderatepostold");
	AddParam("ForumID", iForumID);
	AddParam("ThreadID", iThreadID);
	AddParam("PostID", iPostID);
	AddParam("ModID", iModID);
	AddParam("Status", iStatus);
	AddParam("Notes", sNotes);
	AddParam("ReferTo", iReferTo);
	AddParam("ReferredBy", iReferredBy);
	AddParam("ModerationStatus", iModStatus);
	ExecuteStoredProcedure();
	
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchNextPostModerationBatch(int iUserID, 
		const TDVCHAR* pcShowType, int iReferrals, bool bFastMod, bool bNotFastMod)
	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		iUserID - ID of the user doing the update
				pcShowType - the type of posts to show: new, legacy, or complaints
				iReferrals - 1 if we are fetching referrals queue
				bFastMod - true to return fastmod posts
				bNotFastMod - true to return not fastmod posts
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::FetchNextPostModerationBatch(int iUserID, 
	const TDVCHAR* pcShowType, int iReferrals, bool bFastMod, bool bNotFastMod)
{
	CTDVString	sShowType = pcShowType;
	int			iShowNew = 0;
	int			iComplaints = 0;
	// find out show parameters from the show type arg
	if (sShowType.CompareText("COMPLAINTS"))
	{
		iComplaints = 1;
		iShowNew = 1;
	}
	else if (sShowType.CompareText("NEW"))
	{
		iShowNew = 1;
	}
	// determine if we are getting referrals or a new batch of posts
	if (iReferrals == 1)
	{
		if (bFastMod)
		{
			StartStoredProcedure("getfastreferralbatch");
		}
		else
		{
			StartStoredProcedure("getforumreferralbatch");
		}
	}
	else
	{
		if (bFastMod)
		{
			StartStoredProcedure("getfastmoderationbatch");
		}
		else
		{
			StartStoredProcedure("getforummoderationbatch");
		}
	}
	AddParam("UserID", iUserID);
	AddParam("NewPosts", iShowNew);
	AddParam("Complaints", iComplaints);
	//AddParam("fastmod", bFastMod);
	//AddParam("notfastmod", bNotFastMod);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}



/*********************************************************************************

	bool CStoredProcedure::UpdateArticleModeration(int ih2g2ID, int iModID, int iStatus, const TDVCHAR* pcNotes, int iReferTo)

	Author:		Kim Harries
	Created:	05/02/2001
	Inputs:		ih2g2ID
				iModID
				iStatus
				psNotes
				iReferTo
				iReferrerID - id of the user who referrs
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::UpdateArticleModeration(int ih2g2ID, int iModID, 
											   int iStatus, const TDVCHAR* pcNotes, 
											   int iReferTo, int iReferrerID)
{
	CTDVString	sNotes = pcNotes;

	StartStoredProcedure("moderatearticle");
	AddParam("h2g2ID", ih2g2ID);
	AddParam("ModID", iModID);
	AddParam("Status", iStatus);
	AddParam("Notes", sNotes);
	AddParam("ReferTo", iReferTo);
	AddParam("ReferredBy", iReferrerID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchNextArticleModerationBatch(int iUserID, const TDVCHAR* pcShowType, int iReferrals)

	Author:		Kim Harries
	Created:	06/02/2001
	Inputs:		iUserID - ID of the user doing the update
				pcShowType - the type of posts to show: new, legacy, or all
				iReferrals - 1 if referrals are to be fetched, zero otherwise
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::FetchNextArticleModerationBatch(int iUserID, const TDVCHAR* pcShowType, int iReferrals )
{
	CTDVString	sShowType = pcShowType;
	int			iComplaints = 0;
	int			iShowNew = 0;
	// find out show parameters from the show type arg
	if (sShowType.CompareText("COMPLAINTS"))
	{
		iComplaints = 1;
		iShowNew = 1;
	}
	else if (sShowType.CompareText("NEW"))
	{
		iShowNew = 1;
	}
	// determine if we are getting referrals or a new batch of posts
	if (iReferrals == 1)
	{
		StartStoredProcedure("FetchArticleReferralsBatch");
		AddParam("UserID", iUserID);
		AddParam("NewEntries", iShowNew);
		AddParam("Complaints", iComplaints);
	}
	else
	{
		StartStoredProcedure("getarticlemoderationbatch");
		AddParam("UserID", iUserID);
		AddParam("NewEntries", iShowNew);
		AddParam("Complaints", iComplaints);
	}
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchNextGeneralModerationBatch(int iUserID, int iReferrals)

	Author:		Kim Harries
	Created:	22/02/2001
	Inputs:		iUserID - ID of the user doing the update
				iReferrals - 1 if referrals are to be fetched, zero otherwise
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::FetchNextGeneralModerationBatch(int iUserID, int iReferrals)
{
	// determine if we are getting referrals or a new batch of posts
	if (iReferrals == 1)
	{
		StartStoredProcedure("FetchGeneralReferralsBatch");
		AddParam("UserID", iUserID);
	}
	else
	{
		StartStoredProcedure("FetchGeneralModerationBatch");
		AddParam("UserID", iUserID);
	}
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateGeneralModeration(int iModID, int iStatus, 
											   const TDVCHAR* pcNotes, 
											   int iReferTo, iReferredBy)

	Author:		Kim Harries
	Created:	22/02/2001
	Inputs:		iModID
				iStatus
				psNotes
				iReferTo
				iReferredBy - id of the user who refers
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::UpdateGeneralModeration(int iModID, int iStatus, 
											   const TDVCHAR* pcNotes, 
											   int iReferTo, int iReferredBy)
{
	StartStoredProcedure("ModerateGeneralPage");
	AddParam("ModID", iModID);
	AddParam("Status", iStatus);
	AddParam("Notes", pcNotes);
	AddParam("ReferTo", iReferTo);
	AddParam("ReferredBy", iReferredBy);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::GetForumFromThreadID(int iThreadID, int* iForumID)

	Author:		Dharmesh Raithatha
	Created:	10/4/01
	Inputs:		iThreadID - Thread that you want to find the forum for
	Outputs:	iforumID - ForumID for that Thread
	Returns:	true if successful false otherwise
	Purpose:	Finds the ForumID for the given ThreadID

*********************************************************************************/

bool CStoredProcedure::GetForumFromThreadID(int iThreadID, int* iForumID)
{
	StartStoredProcedure("getforumfromthreadid");
	AddParam(iThreadID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	*iForumID = GetIntField("ForumID");
	if (*iForumID == 0)
	{
		return false;
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::GetH2G2IDFromForumID(int iForumID, int* iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	10/4/01
	Inputs:		iForumID  - Forum that you want to know is associated with which article
	Outputs:	iH2G2ID - the article id that is associated with that forum
	Returns:	true if successful, false otherwise
	Purpose:	finds the h2g2id from the forumid

*********************************************************************************/

bool CStoredProcedure::GetH2G2IDFromForumID(int iForumID, int* iH2G2ID)
{
	StartStoredProcedure("geth2g2idfromforumid");
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	*iH2G2ID = GetIntField("H2G2ID");
	if (*iH2G2ID == 0)
	{
		return false;
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::RemoveArticleFromPeerReview(iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	10/5/01
	Inputs:		iH2G2ID - id of article to delete
	Outputs:	-
	Returns:	true if successful , false otherwise
	Purpose:	deletes the given article from reviewforummembers table if the article
				is there.

*********************************************************************************/

bool CStoredProcedure::RemoveArticleFromPeerReview(int iH2G2ID)
{
	StartStoredProcedure("removearticlefrompeerreview");
	AddParam(iH2G2ID);
	ExecuteStoredProcedure();
	if (GetIntField("Success") == 1)
	{
		return true;
	}
	
	return false;
}
/*********************************************************************************

	bool CStoredProcedure::IsForumAReviewForum(int iForumID, int *iReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	9/24/01
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	given forum ID returns the 

*********************************************************************************/

bool CStoredProcedure::IsForumAReviewForum(int iForumID, int *iReviewForumID)
{
	StartStoredProcedure("isforumareviewforum");
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	*iReviewForumID = GetIntField("ReviewForumID");

	if (*iReviewForumID == 0)
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::FetchPersonalSpaceForum(int iEditorID, int iSiteID, int *iUserForumID)
{
	StartStoredProcedure("fetchpersonalspaceforum");
	AddParam(iEditorID);
	AddParam(iSiteID);
	ExecuteStoredProcedure();

	if (IsEOF())
	{
		return false;
	}

	*iUserForumID = GetIntField("ForumID");

	if (*iUserForumID == 0)
	{
		return false;
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::FetchMonthEntrySummary(int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	14/05/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Gets the list of guide entries for the last month to the current date

*********************************************************************************/

bool CStoredProcedure::FetchMonthEntrySummary(int iSiteID)
{
	StartStoredProcedure("getmonthsummary");
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	//check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::SetGuideEntrySubmittable(int iH2G2ID, int iValue)

	Author:		Dharmesh Raithatha
	Created:	10/19/01
	Inputs:		iH2G2ID - ID you want to 
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::SetGuideEntrySubmittable(int iH2G2ID, int iValue)
{
	StartStoredProcedure("setguideentrysubmittable");
	AddParam("h2g2id",iH2G2ID);
	AddParam("value",iValue);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchForumFromH2G2ID(int iH2G2ID, int *pForumID)

	Author:		Dharmesh Raithatha
	Created:	8/21/01
	Inputs:		iH2G2ID - guideentry we are interested in
	Outputs:	pForumID - ForumId for that entry
	Returns:	true if successful, false otherwise
	Purpose:	Fetches the forum id 

*********************************************************************************/

bool CStoredProcedure::FetchForumFromH2G2ID(int iH2G2ID, int *pForumID)
{
	StartStoredProcedure("fetchforumfromh2g2id");
	AddParam("h2g2id",iH2G2ID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	*pForumID = GetIntField("ForumID");

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumThreadsByH2G2ID(int iReviewForumID,bool bAscending = true)

	Author:		Dharmesh Raithatha
	Created:	9/11/01
	Inputs:		iReviewForumID - id of reviewforum that you want threads for
				bMostRecentFirst - order the results are recieved
	Fields:		AuthorID - author of article 
				h2g2id,
				Threadid,
				FirstSubject - subject of first posting,
				Subject - subject of entry
				LastPosted - date of last posting to the conversation, 
				dateentered - date article was submitted,
				Username,
				forumid - id of forum
				ThreadCount - number of threads in the forum
	Returns:	true if it finds something, false otherwise
	Purpose:	returns all the list of articles that have been submitted to the given review forum 
				ordered by the authorsname
*********************************************************************************/

bool CStoredProcedure::FetchReviewForumThreadsByH2G2ID(int iReviewForumID,bool bAscending)
{
	StartStoredProcedure("fetchreviewforumthreadsbyh2g2id");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("ascending",bAscending);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;

}


/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumThreadsBySubject(int iReviewForumID,bool bAscending = true)

	Author:		Dharmesh Raithatha
	Created:	9/11/01
	Inputs:		iReviewForumID - id of reviewforum that you want threads for
				bMostRecentFirst - order the results are recieved
	Fields:		AuthorID - author of article 
				h2g2id,
				Threadid,
				FirstSubject - subject of first posting,
				Subject - subject of entry
				LastPosted - date of last posting to the conversation, 
				dateentered - date article was submitted,
				Username,
				forumid - id of forum
				ThreadCount - number of threads in the forum
	Returns:	true if it finds something, false otherwise
	Purpose:	returns all the list of articles that have been submitted to the given review forum 
				ordered by the authorsname
*********************************************************************************/

bool CStoredProcedure::FetchReviewForumThreadsBySubject(int iReviewForumID,bool bAscending)
{
	StartStoredProcedure("fetchreviewforumthreadsbysubject");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("ascending",bAscending);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;

}
	
/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumThreadsByDateEntered(int iReviewForumID,bool bMostRecentFirst = true)

	Author:		Dharmesh Raithatha
	Created:	9/11/01
	Inputs:		iReviewForumID - id of reviewforum that you want threads for
				bMostRecentFirst - order the results are recieved
	Fields:		AuthorID - author of article 
				h2g2id,
				Threadid,
				FirstSubject - subject of first posting,
				Subject - subject of entry
				LastPosted - date of last posting to the conversation, 
				dateentered - date article was submitted,
				Username,
				forumid - id of forum
				ThreadCount - number of threads in the forum
	Returns:	true if it finds something, false otherwise
	Purpose:	returns all the list of articles that have been submitted to the given review forum 
				ordered by the date it was entered

*********************************************************************************/

bool CStoredProcedure::FetchReviewForumThreadsByDateEntered(int iReviewForumID,bool bMostRecentFirst /* true*/)
{
	StartStoredProcedure("fetchreviewforumthreadsbydateentered");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("ascending",bMostRecentFirst);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	CStoredProcedure::FetchReviewForumThreadsByLastPosted(int iReviewForumID,bool bMostRecentFirst = true)

	Author:		Dharmesh Raithatha
	Created:	9/11/01
	Inputs:		iReviewForumID - id of reviewforum that you want threads for
				bMostRecentFirst - order the results are recieved
	Fields:		AuthorID - author of article 
				h2g2id,
				Threadid,
				FirstSubject - subject of first posting,
				Subject - subject of entry
				LastPosted - date of last posting to the conversation, 
				dateentered - date article was submitted,
				Username,
				forumid - id of forum
				ThreadCount - number of threads in the forum
	Returns:	true if it finds something, false otherwise
	Purpose:	returns all the list of articles that have been submitted to the given review forum 
				ordered by the date of last posting to the thread
*********************************************************************************/

bool CStoredProcedure::FetchReviewForumThreadsByLastPosted(int iReviewForumID,bool bMostRecentFirst /*true*/)
{
	StartStoredProcedure("fetchreviewforumthreadsbylastposted");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("ascending",bMostRecentFirst);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumThreadsByUserID(int iReviewForumID,bool bAscending = true)

	Author:		Dharmesh Raithatha
	Created:	9/11/01
	Inputs:		iReviewForumID - id of reviewforum that you want threads for
				bMostRecentFirst - order the results are recieved
	Fields:		AuthorID - author of article 
				h2g2id,
				Threadid,
				FirstSubject - subject of first posting,
				Subject - subject of entry
				LastPosted - date of last posting to the conversation, 
				dateentered - date article was submitted,
				Username,
				forumid - id of forum
				ThreadCount - number of threads in the forum
	Returns:	true if it finds something, false otherwise
	Purpose:	returns all the list of articles that have been submitted to the given review forum 
				ordered by the authorID
*********************************************************************************/

bool CStoredProcedure::FetchReviewForumThreadsByUserID(int iReviewForumID,bool bAscending /*true*/)
{
	StartStoredProcedure("fetchreviewforumthreadsbyuserid");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("ascending",bAscending);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;
	
}


/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumThreadsByUserName(int iReviewForumID,bool bAscending = true)

	Author:		Dharmesh Raithatha
	Created:	9/11/01
	Inputs:		iReviewForumID - id of reviewforum that you want threads for
				bMostRecentFirst - order the results are recieved
	Fields:		AuthorID - author of article 
				h2g2id,
				Threadid,
				FirstSubject - subject of first posting,
				Subject - subject of entry
				LastPosted - date of last posting to the conversation, 
				dateentered - date article was submitted,
				Username,
				forumid - id of forum
				ThreadCount - number of threads in the forum
	Returns:	true if it finds something, false otherwise
	Purpose:	returns all the list of articles that have been submitted to the given review forum 
				ordered by the authorsname
*********************************************************************************/

bool CStoredProcedure::FetchReviewForumThreadsByUserName(int iReviewForumID,bool bAscending /*true*/)
{
	
	StartStoredProcedure("fetchreviewforumthreadsbyusername");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("ascending",bAscending);
	ExecuteStoredProcedure();
		if (IsEOF())
	{
		return false;
	}

	return true;

}
  
/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumMemberDetails(int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	8/31/01
	Inputs:		iH2G2ID - details of this guideentry
	Fields:		ReviewForumID,SubmitterID,ThreadID,PostID,ForumID,DateCreated,
	Outputs:	-
	Returns:	
	Purpose:	-

*********************************************************************************/

#ifdef __MYSQL__

bool CStoredProcedure::FetchReviewForumMemberDetails(int iH2G2ID)
{
	CTDVString sQuery;
	sQuery << "SELECT * from ReviewForumMembers r where r.h2g2id = " << iH2G2ID;
	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}

	return true;

}

#else

bool CStoredProcedure::FetchReviewForumMemberDetails(int iH2G2ID)
{
	StartStoredProcedure("fetchreviewforummemberdetails");
	AddParam("h2g2id",iH2G2ID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;

}

#endif

/*********************************************************************************

	bool CStoredProcedure::AddArticleToReviewForumMembers(int iH2G2ID,int iSubmitterID,
	int iSiteID,int iReviewForumID,const TDVCHAR* sSubject,const TDVCHAR* sEditedComments,
	int& iThreadID,int& iPostID, CTDVString* pErrors)

	Author:		Dharmesh Raithatha
	Created:	8/23/01
	Inputs:		see posttoforum
	Outputs:	the new thread id and postid, if fails pError will contain an error
	Returns:	true if succeeded false otherwise
	Purpose:	Add an article to a particular review forum

*********************************************************************************/

bool CStoredProcedure::AddArticleToReviewForumMembers(int iH2G2ID,int iSubmitterID,
			int iSiteID,int iReviewForumID,const TDVCHAR* sSubject,
			const TDVCHAR* sContent,int* iForumID,int* iThreadID,int* iPostID, CTDVString* pErrors)
{

//	if (IsArticleInReviewForum(iH2G2ID,iSiteID))
//	{
//		*pErrors = "The article is already in a review forum";
//		return false;
//	}

//	if (!FetchReviewForumDetails(iReviewForumID))
//	{
//		*pErrors = "Failed to get ReviewForum Details";
//		return false;
//	}

//	int iReviewForumH2G2ID = GetIntField("H2G2ID");

//	if (!FetchForumFromH2G2ID(iReviewForumH2G2ID,iForumID))
//	{
//		*pErrors = "Failed to find forumid";
//		return false;
//	}

	// Because we haven't yet posted to the forum, we don't know the threadID etc.
	// This should *really* be a whole transaction, shouldn't it?
	// Why the heck not? Makes a lot more sense that way...
	
	*iThreadID = 0;
	*iPostID = 0;
	
	CTDVString sHash;
	CTDVString sSource;
	sSource << sSubject << "<:>" << sContent << "<:>" << iSubmitterID << "<:>" << "0" << "<:>" << "0" << "<:>" << "0" << "<:>ToReviewForum";
	GenerateHash(sSource, sHash);

	StartStoredProcedure("addarticletoreviewforummembers");
	AddParam("h2g2id",iH2G2ID);
	AddParam("reviewforumid",iReviewForumID);
	AddParam("submitterid",iSubmitterID);
//	AddParam("forumid",*iForumID);
	AddParam("subject", sSubject);
	AddParam("content", sContent);

	// Add the UID to the param list
	if (!AddUIDParam("hash",sHash))
	{
		return false;
	}

	ExecuteStoredProcedure();

	//check if the stored procedure was successful - can only fail if entry already exists in the table 
	if (GetIntField("Success") == 0)
	{
		*pErrors = "Failed to add into review forum - possible duplicate entry";
		return false;
	}

	//Post to the forum after you have inserted the article into the review forum.
	
//	if (!PostToForum(iSubmitterID,*iForumID,0,0,sSubject,sContent,iThreadID,iPostID))
//	{
//		*pErrors = "Failed to post to Forum";
//		return false;
//	}

	*iThreadID = GetIntField("ThreadID");
	*iPostID = GetIntField("PostID");
	*iForumID = GetIntField("ForumID");
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumDetails(int iReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	8/21/01
	Inputs:		iReviewForumID - the id for the review forum
	Fields:
	Outputs:	none
	Returns:	true if succesful, false otherwise
	Purpose:	gets information about a particular review forum, get the ones you 
				want using GetParam methods

*********************************************************************************/

bool CStoredProcedure::FetchReviewForumDetails(int iID, bool bIDIsReviewForumID)
{
	StartStoredProcedure("fetchreviewforumdetails");
	if (bIDIsReviewForumID)
	{
		AddParam("reviewforumid",iID);
	}
	else
	{
		AddParam("h2g2id",iID);
	}
	ExecuteStoredProcedure();

	return (!IsEOF());

}

/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumDetailsViaReviewForumID(int iReviewForumID)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Fetch using a ReviewForumID

*********************************************************************************/

bool CStoredProcedure::FetchReviewForumDetailsViaReviewForumID(int iReviewForumID)
{
	return FetchReviewForumDetails(iReviewForumID, true);
}

/*********************************************************************************

	bool CStoredProcedure::FetchReviewForumDetailsViaH2G2ID(int iH2G2ID)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Fetch using a H2G2ID

*********************************************************************************/

bool CStoredProcedure::FetchReviewForumDetailsViaH2G2ID(int iH2G2ID)
{
	return FetchReviewForumDetails(iH2G2ID, false);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateThreadFirstSubject(int iThreadID, const TDVCHAR* sFirstSubject)

	Author:		Dharmesh Raithatha
	Created:	10/9/01
	Inputs:		iThreadID - thread you want to change
				sFirstSubject - the text for the firstsubject
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Set the given threads first subject 

*********************************************************************************/

bool CStoredProcedure::UpdateThreadFirstSubject(int iThreadID, const TDVCHAR* sFirstSubject)
{
	StartStoredProcedure("updatethreadfirstsubject");
	AddParam(iThreadID);
	AddParam(sFirstSubject);
	ExecuteStoredProcedure();

	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

bool CStoredProcedure::UpdateReviewForum(int iReviewForumID, const TDVCHAR* sName,const TDVCHAR* sURL, bool bRecommendable,int iIncubateTime)
{
	StartStoredProcedure("updatereviewforum");
	AddParam("reviewforumid",iReviewForumID);
	AddParam("name",sName);
	AddParam("url",sURL);
	AddParam("recommend",bRecommendable);
	AddParam("incubate",iIncubateTime);
	ExecuteStoredProcedure();

	int iCheckReviewForumID = 0;
	iCheckReviewForumID = GetIntField("ID");

	if (iCheckReviewForumID <= 0)
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::FetchAllReviewForumDetails()
{
	StartStoredProcedure("fetchallreviewforumdetails");
	ExecuteStoredProcedure();

	return (!IsEOF());
}


bool CStoredProcedure::AddNewHierarchyType(const int iTypeID, const CTDVString& sDescription, const int iSiteID)
{
	StartStoredProcedure("AddNewHierarchyType");
	AddParam("TypeID",iTypeID);
	AddParam("Description", sDescription);
	AddParam("SiteID",iSiteID);
	
	ExecuteStoredProcedure();

	return true;
}

/*
bool CStoredProcedure::AddNewProfanity(const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, const int iRating, const TDVCHAR* pProfanityReplacement)
{
	StartStoredProcedure("AddNewProfanity");

	AddParam("GroupId", iGroupId);
	AddParam("SiteId", iSiteId);
	AddParam("Profanity", pProfanity);
	AddParam("ProfanityRating", iRating);
	AddParam("ProfanityReplacement", pProfanityReplacement);

	ExecuteStoredProcedure();

	if (HandleError("AddNewProfanity"))
	{
		return false;
	}
	
	return true;
}
*/

bool CStoredProcedure::AddNewProfanity(const TDVCHAR* pProfanity, const int iModClassID, const int iRefer)
{
	StartStoredProcedure("profanityaddprofanity");

	AddParam("modclassid", iModClassID);
	AddParam("profanity", pProfanity);
	AddParam("refer", iRefer);

	ExecuteStoredProcedure();

	if (HandleError("profanityaddprofanity"))
	{
		return false;
	}
	
	return true;
}


bool CStoredProcedure::UpdateProfanity(const int iProfanityId, const int iGroupId, const int iSiteId, const TDVCHAR* pProfanity, const int iRating, const TDVCHAR* pProfanityReplacement)
{
	StartStoredProcedure("UpdateProfanity");

	AddParam("ProfanityId", iProfanityId);
	AddParam("GroupId", iGroupId);
	AddParam("SiteId", iSiteId);
	AddParam("Profanity", pProfanity);
	AddParam("ProfanityRating", iRating);
	AddParam("ProfanityReplacement", pProfanityReplacement);

	ExecuteStoredProcedure();

	if (HandleError("UpdateProfanity"))
	{
		return false;
	}
	
	return true;
}

bool CStoredProcedure::UpdateProfanity(const int iProfanityId, const CTDVString& sProfanity, const int iModClassId, const int iRefer)
{
	StartStoredProcedure("profanityupdateprofanity");

	AddParam("profanityid", iProfanityId);
	AddParam("profanity", sProfanity);
	AddParam("modclassid", iModClassId);
	AddParam("refer", iRefer);

	ExecuteStoredProcedure();

	if (HandleError("UpdateProfanity"))
	{
		return false;
	}
	return true;
}


bool CStoredProcedure::GetAllProfanities()
{
	StartStoredProcedure("profanitiesgetall");


	ExecuteStoredProcedure();
	if (HandleError("profanitiesgetall"))
	{
		return false;
	}
	
	return true;
}


bool CStoredProcedure::GetProfanityInfo(const int iProfanityId)
{
	StartStoredProcedure("GetProfanityInfo");
	AddParam("ProfanityId", iProfanityId);
	ExecuteStoredProcedure();

	if (HandleError("GetProfanityInfo"))
	{
		return false;
	}
	
	return true;
}


bool CStoredProcedure::GetProfanityInfoByName(const TDVCHAR* pProfanity)
{
	StartStoredProcedure("GetProfanityInfoByName");
	AddParam("Profanity", pProfanity);
	ExecuteStoredProcedure();

	if (HandleError("GetProfanityInfoByName"))
	{
		return false;
	}
	
	return true;
}


bool CStoredProcedure::DeleteProfanity(const int iProfanityID)
{
	StartStoredProcedure("profanitydeleteprofanity");
	AddParam("profanityid", iProfanityID);
	ExecuteStoredProcedure();

	if (HandleError("DeleteProfanity"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************
bool CStoredProcedure::GetProfanityListForSite(const int iSiteId)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		iGroupId - ID of site you want the profanities for
Outputs:	-
Returns:	true if ok, false if not
Purpose:	Finds profanities that belong to a particular site (including the 
			global group and the group the site belongs to)
*********************************************************************************/

bool CStoredProcedure::GetProfanityListForSite(const int iSiteId)
{
	StartStoredProcedure("GetProfanityListForSite");
	AddParam("SiteId", iSiteId);
	ExecuteStoredProcedure();
	if (HandleError("GetProfanityInfoForSite"))
	{
		return false;
	}
	
	return true;
}


/*********************************************************************************
bool CStoredProcedure::GetProfanityListForGroup(const int iGroupId)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		iGroupId - ID of group you want the profanities for, or 0 for global
Outputs:	-
Returns:	true if ok, false if not
Purpose:	Finds profanities that belong in a particular group
*********************************************************************************/

bool CStoredProcedure::GetProfanityListForGroup(const int iGroupId)
{
	StartStoredProcedure("GetProfanityListForGroup");
	AddParam("GroupId", iGroupId);
	ExecuteStoredProcedure();
	if (HandleError("GetProfanityInfoForGroup"))
	{
		return false;
	}
	
	return true;
}


/*********************************************************************************
bool CStoredProcedure::GetProfanityGroupInfo(const int iGroupId)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		iGroupId - ID of profanity group
Outputs:	-
Returns:	true if ok, false if not
Purpose:	Fetches profanity group info for a given ID
*********************************************************************************/

bool CStoredProcedure::GetProfanityGroupInfo(const int iGroupId)
{
	StartStoredProcedure("GetProfanityGroupInfo");
	AddParam("GroupId", iGroupId);
	ExecuteStoredProcedure();
	if (HandleError("GetProfanityGroupInfo"))
	{
		return false;
	}
	
	return true;
}


/*********************************************************************************
bool CStoredProcedure::UpdateProfanityGroup(const int iGroupId, const TDVCHAR* pGroupName)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		iGroupId - ID of profanity group
			pGroupName - Name of group
Outputs:	-
Returns:	true if ok, false if not
Purpose:	Updates profanity group info for a given ID
*********************************************************************************/

/*
bool CStoredProcedure::UpdateProfanityGroup(const int iGroupId, const TDVCHAR* pGroupName)
{
	StartStoredProcedure("UpdateProfanityGroup");
	AddParam("GroupId", iGroupId);
	AddParam("GroupName", pGroupName);
	ExecuteStoredProcedure();
	if (HandleError("UpdateProfanityGroup"))
	{
		return false;
	}
	
	return true;
}
*/

/*********************************************************************************
bool CStoredProcedure::AddSiteToProfanityGroup(const int iGroupId, const int iSiteId)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		iGroupId - ID of profanity group
			iSiteId - ID of site to add
Outputs:	-
Returns:	true if ok, false if not
Purpose:	Adds site to specified group
*********************************************************************************/

/*
bool CStoredProcedure::AddSiteToProfanityGroup(const int iGroupId, const int iSiteId)
{
	StartStoredProcedure("AddSiteToProfanityGroup");
	AddParam("GroupId", iGroupId);
	AddParam("SiteId", iSiteId);
	ExecuteStoredProcedure();
	if (HandleError("AddSiteToProfanityGroup"))
	{
		return false;
	}
	
	return true;
}
*/

/*

bool CStoredProcedure::RemoveSiteFromProfanityGroup(const int iSiteId)
{
	StartStoredProcedure("RemoveSiteFromProfanityGroup");
	AddParam("SiteId", iSiteId);
	ExecuteStoredProcedure();
	if (HandleError("RemoveSiteFromProfanityGroup"))
	{
		return false;
	}
	
	return true;
}
*/

/*

bool CStoredProcedure::DeleteProfanityGroup(const int iGroupId)
{
	StartStoredProcedure("deleteprofanitygroup");
	AddParam("groupid", iGroupId);
	ExecuteStoredProcedure();
	if (HandleError("DeleteProfanityGroup"))
	{
		return false;
	}
	
	return true;
}
*/

bool CStoredProcedure::AddNewReviewForum(const TDVCHAR* sForumName, const TDVCHAR* sURLFriendlyName,
										 int iIncubateTime, bool bRecommendable, int iSiteID,
										 int* iReviewForumID, int iUserID, CExtraInfo& Extra, int iType)
{
	CTDVString sExtra;
	if(!Extra.GetInfoAsXML(sExtra))
	{
		
		return false;
	}

	StartStoredProcedure("addnewreviewforum");
	AddParam("URLName",sURLFriendlyName);
	AddParam("ReviewForumName",sForumName);
	AddParam("Incubate",iIncubateTime);
	AddParam("Recommend",bRecommendable);
	AddParam("SiteID",iSiteID);
	AddParam("userid", iUserID);
	AddParam("extra", sExtra);
	AddParam("Type", iType);

	CTDVString sHash;
	CTDVString sSource;
	sSource << sForumName << "<:>" << sURLFriendlyName << "<:>" << iUserID << "<:>" << iSiteID << "<:>" << sExtra << "<:>" << iIncubateTime << "<:>" << bRecommendable;
	GenerateHash(sSource, sHash);

	// Add the UID to the param list
	if (!AddUIDParam("hash",sHash))
	{
		return false;
	}

	ExecuteStoredProcedure();

	*iReviewForumID = 0;
	*iReviewForumID = GetIntField("ReviewForumID");

	return (*iReviewForumID > 0);

}


/*********************************************************************************

	bool CStoredProcedure::IsArticleInReviewForum(int iH2G2ID,int iSiteID,int* iReviewForumID,CTDVString* sURLFriendlyName)

	Author:		Dharmesh Raithatha
	Created:	8/15/01
	Inputs:		iH2G2ID - id of the article to check 
				iSiteID - the current siteId
				Outputs:	sURLFriendlyName - the friendly url name of the 
							iReviewForumId - id of the review forum the article is in
	Returns:	-
	Purpose:	checks id the article is in a review forum, if it is and you have supplied
				an output parameter then it returns the urlfriendlyname for it

*********************************************************************************/

bool CStoredProcedure::IsArticleInReviewForum(int iH2G2ID,int iSiteID,int* pReviewForumID)
{

	StartStoredProcedure("isarticleinreviewforum");
	AddParam("h2g2id", iH2G2ID);
	AddParam("siteid", iSiteID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	if ( pReviewForumID != NULL)
	{
		*pReviewForumID = GetIntField("ReviewForumID");
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetReviewForums(int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	8/15/01
	Inputs:		iSiteID - The siteID you are interested in
	Outputs:	-
	Returns:	true if there are reviewforums found, false otherwise
	Purpose:	Finds all the review forums for the given siteID. Pass in 0
				for the site ID to get a list of all review forums from all
				sites

*********************************************************************************/

#ifdef __MYSQL__
bool CStoredProcedure::GetReviewForums(int iSiteID)
{
	CTDVString sQuery;
	sQuery << "SELECT * FROM ReviewForums WHERE SiteID = " << iSiteID;
	m_pDBO->ExecuteQuery(sQuery);	
	return (!IsEOF());
}
#else

bool CStoredProcedure::GetReviewForums(int iSiteID)
{
	StartStoredProcedure("getreviewforums");
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();
	return (!IsEOF());
}

#endif

/*********************************************************************************

bool GetNodeIdFromAliasId(int iLinkNodeID)

	Author:		Dharmesh Raithatha
	Created:	28/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Gets all the records from hierarchynodelias where linknodeid 
				matches

*********************************************************************************/

bool CStoredProcedure::GetNodeIdFromAliasId(int iLinkNodeID)
{
	StartStoredProcedure("getnodeidfromaliasid");
	AddParam("linknodeid", iLinkNodeID);
	ExecuteStoredProcedure();
	return !IsEOF(); 
}


/*********************************************************************************

	bool CStoredProcedure::GetNodesWithAncestor(int iAncestor)

	Author:		Nick Stevenson
	Created:	02/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::SetTypeForNodesWithAncestor(const int iAncestor, const int iTypeID, const int iSiteID)
{
	StartStoredProcedure("SetTypeForNodesWithAncestor");
	AddParam("ancestor",iAncestor);
	AddParam("typeid",iTypeID);
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();
	if (HandleError("SetTypeForNodesWithAncestor"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

bool DeleteNodeFromHierarchy(int iNodeID)

	Author:		Dharmesh Raithatha
	Created:	28/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Deletes the subject from the hierarchy

*********************************************************************************/

bool CStoredProcedure::DeleteNodeFromHierarchy(int iNodeID)
{
	StartStoredProcedure("deletenodefromhierarchy");
	AddParam("nodeid",iNodeID);
	ExecuteStoredProcedure();
	
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);

}
/*********************************************************************************

	bool CStoredProcedure::AddNodeToHierarchy(int iParentID, const CTDVString& sDisplayName,int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	28/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Adds a node to the hierarchy, updates the ancestry and the counts
				if the DisplayName already exists then return 'NewNode = NULL'
				otherwise 'NewNode = nodeid of added node'

*********************************************************************************/

bool CStoredProcedure::AddNodeToHierarchy(int iParentID, const TDVCHAR* pDisplayName,int &iNewSubjectID,int iSiteID)
{
	StartStoredProcedure("addnodetohierarchy");
	AddParam("ParentID",iParentID);
	AddParam("DisplayName",pDisplayName);
	AddParam("SiteId",iSiteID);
	ExecuteStoredProcedure();

	iNewSubjectID = GetIntField("NewNode"); 
	if (iNewSubjectID == NULL)
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool MoveHierarchyNode(int iParentID,int iMovingNode)

	Author:		Dharmesh Raithatha
	Created:	28/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Moves a node in the hierarchy to a new parent in the hierarchy. 
				updates the ancestors and updates the hierarchycount

*********************************************************************************/

bool CStoredProcedure::MoveHierarchyNode(int iParentID,int iMovingNode, CTDVString& sErrorReason)
{
	StartStoredProcedure("movehierarchynode");
	AddParam("nodeid",iMovingNode);
	AddParam("newparentid",iParentID);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		// An error occurred
		return false;
	}

	GetField("result",sErrorReason);
	return sErrorReason.CompareText("ok");
}


/*********************************************************************************

	bool AddAliastoHierarchy(int iNodeID,int iLinkNodeID)

	Author:		Dharmesh Raithatha
	Created:	29/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Adds an alias to a node in the hierarchy and updates the count by
				1

*********************************************************************************/

bool CStoredProcedure::AddAliasToHierarchy(int iNodeID,int iLinkNodeID)
{
	StartStoredProcedure("addaliastohierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("linknodeid",iLinkNodeID);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool DeleteAliasFromHierarchy(int iLinkNodeId,iNodeId)

	Author:		Dharmesh Raithatha
	Created:	29/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	deletes the linknode from the hierarchynodealias that corresponds
				to the nodeid and decrements the count

*********************************************************************************/

bool CStoredProcedure::DeleteAliasFromHierarchy(int iLinkNodeId,int iNodeId)
{

	StartStoredProcedure("deletealiasfromhierarchy");
	AddParam("linknodeid",iLinkNodeId);
	AddParam("nodeid",iNodeId);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}


/*********************************************************************************

	bool AddArticleToHierarchy(int iNodeID, int iH2G2ID) //DR

	Author:		Dharmesh Raithatha
	Created:	29/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Adds an aritcle to the hierarchy and increments count by 1

*********************************************************************************/

bool CStoredProcedure::AddArticleToHierarchy(int iNodeID, int iH2G2ID, int iViewingUser, bool& bSuccess)
{
	StartStoredProcedure("addarticletohierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("h2g2id",iH2G2ID);
	AddParam("userid", iViewingUser);
	ExecuteStoredProcedure();

	if (HandleError("AddArticleToHierarchy"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}
	bSuccess = GetIntField("Success") == 1;
	return true;
}

/*********************************************************************************

	bool AddClubToHierarchy(int iNodeID, int iClubID, bool& bSuccess) //DR

	Author:		Mark Neves
	Created:	7/7/03
	Inputs:		iNodeID = ID of heirarchy
				iClubID = ID of club
				bSuccess = place to store the result
	Outputs:	bSuccess = true if successful
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	Adds a club to the hierarchy and increments count by 1

*********************************************************************************/

bool CStoredProcedure::AddClubToHierarchy(int iNodeID, int iClubID, int iViewingUser, bool& bSuccess)
{
	StartStoredProcedure("addclubtohierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("clubid",iClubID);
	AddParam("userid", iViewingUser);
	ExecuteStoredProcedure();

	if (HandleError("AddClubToHierarchy"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess = (GetIntField("Success") == 1);
	return true;
}

/*********************************************************************************

	bool AddUserToHierarchy(int iNodeID, int iThreadID, bool& bSuccess) 

	Author:		Martin Robb
	Created:	05/05/05
	Inputs:		iNodeID = ID of heirarchy node
				iUserId - ID of user to tag
	Outputs:	bSuccess = true if successful, false if post not added
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	Adds a user to the hierarchy and increments count by 1

*********************************************************************************/
bool CStoredProcedure::AddUserToHierarchy(int iNodeID, int iUserID, int iViewingUser, bool& bSuccess)
{
	StartStoredProcedure("addusertohierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("userid", iUserID);
	//AddParam("viewinguserid", iViewingUser);
	ExecuteStoredProcedure();

	if (HandleError("AddUserToHierarchy"))
	{
		bSuccess = false;
		return false;		
	}

	bSuccess = (GetIntField("Success") == 1);
	return true;
}

/*********************************************************************************

	bool AddThreadToHierarchy(int iNodeID, int iThreadID, bool& bSuccess) 

	Author:		Martin Robb
	Created:	01/02/05
	Inputs:		iNodeID = ID of heirarchy node
				iThreadId - ID of thread
				iViewingUserid - used to update significant update for user.
	Outputs:	bSuccess = true if successful, false if post not added
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	Adds a thread to the hierarchy ( HierarchyThreadMembers table )

*********************************************************************************/

bool CStoredProcedure::AddThreadToHierarchy(int iNodeID, int iThreadID, int iViewingUser, bool& bSuccess)
{
	StartStoredProcedure("addthreadtohierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("threadid", iThreadID);
	AddParam("userid", iViewingUser);
	ExecuteStoredProcedure();

	if (HandleError("AddThreadToHierarchy"))
	{
		bSuccess = false;
		return false;		
	}

	bSuccess = (GetIntField("Success") == 1);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteArticleFromHierarchy(int iH2G2ID, int iNodeID)

	Author:		Dharmesh Raithatha
	Created:	29/06/2001
	Inputs:		-
	Outputs:	- bSuccess - Success if item located and deleted.
	Returns:	false on error
	Purpose:	deletes the article from the hierarchyarticlemembers

*********************************************************************************/

bool CStoredProcedure::DeleteArticleFromHierarchy(int iH2G2ID, int iNodeID, bool& bSuccess) //DR
{
	StartStoredProcedure("deletearticlefromhierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("h2g2id",iH2G2ID);
	ExecuteStoredProcedure();

	if ( HandleError("DeleteArticleFromHierarchy") )
	{
		bSuccess = false;
		return false;
	}

	bSuccess = GetIntField("Success") == 1;
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteThreadFromHierarchy(int iThreadID, int iNodeID, bool& bSuccess )

	Author:		Martin Robb
	Created:	08/02/2005
	Inputs:		- iThreadID, iNodeID - identifies post for deletion
	Outputs:	- bSuccess - Success if item located and deleted
	Returns:	false on db error
	Purpose:	deletes the thread from the hierarchyThreadMembers table.

*********************************************************************************/

bool CStoredProcedure::DeleteThreadFromHierarchy(int iThreadID, int iNodeID, bool& bSuccess) //DR
{
	StartStoredProcedure("deletethreadfromhierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("threadid",iThreadID);
	ExecuteStoredProcedure();

	if ( HandleError("DeleteThreadFromHierarchy") )
	{
		bSuccess = false;
		return false;
	}

	bSuccess = GetIntField("Success") == 1;
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteUserFromHierarchy(int iThreadID, int iNodeID)

	Author:		Martin Robb
	Created:	05/05/2005
	Inputs:		- iUserID, iNodeID - identifies post for deletion
	Outputs:	- bSuccess - Success if item located and deleted
	Returns:	false on db error
	Purpose:	deletes the article from the hierarchyNoticeBoardMembers.

*********************************************************************************/

bool CStoredProcedure::DeleteUserFromHierarchy(int iUserID, int iNodeID, bool& bSuccess)
{
	StartStoredProcedure("deleteuserfromhierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("userid",iUserID);
	ExecuteStoredProcedure();

	if ( HandleError("DeleteUserFromHierarchy") )
	{
		bSuccess = false;
		return false;
	}

	bSuccess = GetIntField("Success") == 1;
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::DeleteClubFromHierarchy(int iClubID,int iNodeID, bool& bSuccess) //DR

	Author:		Mark Neves
	Created:	7/7/03
	Inputs:		iClubID = id of club
				iNodeID = id of hierarchy
				bSuccess = place to store the result
	Outputs:	bSuccess = true if successful
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	deletes the club from the hierarchyclubmemebrs that corresponds
				to the nodeid and decrements the count in Hierarchy

*********************************************************************************/

bool CStoredProcedure::DeleteClubFromHierarchy(int iClubID, int iNodeID, bool& bSuccess) //DR
{
	StartStoredProcedure("deleteclubfromhierarchy");
	AddParam("nodeid",iNodeID);
	AddParam("clubid",iClubID);
	ExecuteStoredProcedure();

	if (HandleError("DeleteClubFromHierarchy"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess = (GetIntField("Success") == 1);
	return true;
}

/*********************************************************************************

	CStoredProcedure::GetNewClubsInLastMonth()

	Author:		Nick Stevenson
	Created:	10/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetNewClubsInLastMonth()
{
	StartStoredProcedure("getnewclubsinlastmonth");
	ExecuteStoredProcedure();

	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetNewClubsInLastMonth "; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}


	return true;
	
}


/*********************************************************************************

	bool CStoredProcedure::GetClubList(int iSiteID, bool bOrderByLastUpdated)

	Author:		Mark Neves
	Created:	06/11/2003
	Inputs:		iSiteID = site ID
				bOrderByLastUpdated = sort method
	Outputs:	-
	Returns:	-
	Purpose:	Gets all clubs in the given site (excluding hidden clubs)
				if bOrderByLastUpdated is true, they are ordered by LastUpdated
				if bOrderByLastUpdated is true, they are ordered by DateCreated

*********************************************************************************/

bool CStoredProcedure::GetClubList(int iSiteID, bool bOrderByLastUpdated)
{
	StartStoredProcedure("getclublist");
	AddParam("siteid",iSiteID);
	AddParam("orderbylastupdated",bOrderByLastUpdated);
	ExecuteStoredProcedure();

	if (HandleError("GetClubList"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool GetClubsInRelatedHierarchiesOfClub(int iClubID, bool& bSuccess) //DR

	Author:		Mark Neves
	Created:	15/7/03
	Inputs:		iClubID = ID of club
				bSuccess = place to store the result
	Outputs:	bSuccess = true if successful
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	This gets a list of clubs that belong to all the hierarchies that the
				given club belongs too.
				It excludes the given club from the list

*********************************************************************************/

bool CStoredProcedure::GetClubsInRelatedHierarchiesOfClub(int iClubID, bool& bSuccess)
{
	StartStoredProcedure("getclubsinrelatedhierarchiesofclub");
	AddParam("clubid",iClubID);
	ExecuteStoredProcedure();

	if (HandleError("GetClubsInRelatedHierarchies"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess = (!IsEOF());
	return true;
}

/*********************************************************************************

	bool GetArticlesInRelatedHierarchiesOfClub(int iClubID, bool& bSuccess) //DR

	Author:		Mark Neves
	Created:	15/7/03
	Inputs:		iClubID = ID of club
				bSuccess = place to store the result
	Outputs:	bSuccess = true if successful
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	This gets a list of articles that belong to all the hierarchies that the
				given club belongs too.

*********************************************************************************/

bool CStoredProcedure::GetArticlesInRelatedHierarchiesOfClub(int iClubID, bool& bSuccess)
{
	StartStoredProcedure("getarticlesinrelatedhierarchiesofclub");
	AddParam("clubid",iClubID);
	ExecuteStoredProcedure();

	if (HandleError("GetArticlesInRelatedHierarchiesOfClub"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess = (!IsEOF());
	return true;
}

/*********************************************************************************

	bool UpdateHierarchyDescription(int iNodeID,const CTDVString& sDescription,int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	29/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	updates the description of a node in the hierarchy

*********************************************************************************/

bool CStoredProcedure::UpdateHierarchyDescription(int iNodeID,const TDVCHAR* pDescription,int iSiteID)
{
	StartStoredProcedure("updatehierarchydescription");
	AddParam("nodeid",iNodeID);
	AddParam("description",pDescription);
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();
	if (GetIntField("NodeID") != NULL)
		return true;

	return false;

}


/*********************************************************************************

	bool UpdateHierarchyDisplayName(int iNodeID,const CTDVString& sDisplayName)

	Author:		Dharmesh Raithatha
	Created:	29/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	updates the displayname of a node in the hierarchy

*********************************************************************************/

bool CStoredProcedure::UpdateHierarchyDisplayName(int iNodeID,const TDVCHAR* pDisplayName)
{
	StartStoredProcedure("updatehierarchydisplayname");
	AddParam("nodeid",iNodeID);
	AddParam("displayname",pDisplayName);
	ExecuteStoredProcedure();
	if (GetIntField("NodeID") != NULL)
		return true;

	return false;


}

/*********************************************************************************

	bool CStoredProcedure::UpdateHierarchySynonyms(int iNodeID,const TDVCHAR* pSynonyms,
							bool &bSuccess)

	Author:		Dharmesh Raithatha
	Created:	7/14/2003
	Inputs:		iNodeID - Node to update at
				pSynonyms - the synonyms as a string
	Outputs:	bSuccess - true if updated false otherwise
	Returns:	true if no fatal error encoutnered, false otherwise
	Purpose:	updates the synonym list at a given node

*********************************************************************************/

bool CStoredProcedure::UpdateHierarchySynonyms(int iNodeID,const TDVCHAR* pSynonyms, bool &bSuccess)
{
	StartStoredProcedure("updatehierarchysynonyms");
	AddParam("nodeid",iNodeID);
	AddParam("synonyms",pSynonyms);
	ExecuteStoredProcedure();

	if (HandleError("UpdateHierarchySynonyms"))
	{
		return false;
	}

	if (GetIntField("NodeID") != NULL)
	{
		bSuccess = true;
	}
	else
	{
		bSuccess = false;
	}

	return true;
}

/*********************************************************************************

	bool DoUpdateUserAdd(int iNodeID,int iUserAdd,bool &bSuccess)

	Author:		Dharmesh Raithatha
	Created:	7/14/2003
	Inputs:		iNodeID - the node that you want to change the field 
				iUserID - the value of the userAdd field (currently 0 and 1)
	Outputs:	bSuccess - true if successfully updated, false otherwise
	Returns:	false if there was a database error
	Purpose:	updates the useradd field against a given node. This field controls
				whether a normal user can add content to that node.

*********************************************************************************/

bool CStoredProcedure::DoUpdateUserAdd(int iNodeID,int iUserAdd,bool &bSuccess)
{
	StartStoredProcedure("doupdateuseradd");
	AddParam("nodeid",iNodeID);
	AddParam("useradd",iUserAdd);
	ExecuteStoredProcedure();

	if (HandleError("DoUpdateUserAdd"))
	{
		return false;
	}
  
	if (GetIntField("NodeID") > 0)
	{
		bSuccess = true;
	}
	else
	{
		bSuccess = false;
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeDetails2(int iID,bool bIDIsNodeID, CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID, int* pBaseLine)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Gets the displayname and description of the given node in the 
	hierarchy

*********************************************************************************/

bool CStoredProcedure::GetHierarchyNodeDetails2(int iID,bool bIDIsNodeID, CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID, int* pBaseLine)
{
	StartStoredProcedure("gethierarchynodedetails2");
	if (bIDIsNodeID)
	{
		AddParam("nodeid",iID);
	}
	else
	{
		AddParam("h2g2id",iID);
	}
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	if (pName != NULL)
	{
		GetField("DisplayName", *pName);
	}

	if (pDescription != NULL)
	{
		GetField("Description", *pDescription);
	}

	if (pParentID != NULL)
	{
		*pParentID = GetIntField("ParentID");
	}

	if (ph2g2ID != NULL)
	{
		*ph2g2ID = GetIntField("h2g2ID");
	}

	if (pUserAdd != NULL)
	{
		*pUserAdd = GetIntField("UserAdd");
	}

	if (pNodeID != NULL)
	{
		*pNodeID = GetIntField("NodeID");
	}
	
	if(pTypeID != NULL)
	{
		*pTypeID = GetIntField("Type");
	}

	if(pSiteID != NULL)
	{
		*pSiteID = GetIntField("SiteID");
	}

	if (pSynonyms != NULL)
	{
		GetField("Synonyms", *pSynonyms);
	}

	if (pBaseLine != NULL)
	{
		*pBaseLine = GetIntField("BaseLine");
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeDetailsViaNodeID(int iNodeID,CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID, int* pBaseLine)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Get using a NodeID

*********************************************************************************/

bool CStoredProcedure::GetHierarchyNodeDetailsViaNodeID(int iNodeID,CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID, int* pBaseLine)
{
	return GetHierarchyNodeDetails2(iNodeID,true,pName,pDescription,pParentID,ph2g2ID,pSynonyms,pUserAdd,pNodeID,pTypeID, pSiteID, pBaseLine);
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeDetailsViaH2G2ID(int iH2G2ID,CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pSiteID, int* pBaseLine)

	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Get using a H2G2ID

*********************************************************************************/

bool CStoredProcedure::GetHierarchyNodeDetailsViaH2G2ID(int iH2G2ID,CTDVString *pName,CTDVString* pDescription,int* pParentID, int* ph2g2ID, CTDVString* pSynonyms, int* pUserAdd, int* pNodeID, int* pTypeID, int* pSiteID, int* pBaseLine)
{
	return GetHierarchyNodeDetails2(iH2G2ID,false,pName,pDescription,pParentID,ph2g2ID,pSynonyms,pUserAdd,pNodeID, pTypeID, pSiteID, pBaseLine);
}


/*********************************************************************************

bool CStoredProcedure::GetRootNodeFromHierarchy(int iSiteID, int* pNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	gets the rootnodeid from the hierarchy of a given site 
	hierarchy

*********************************************************************************/

bool CStoredProcedure::GetRootNodeFromHierarchy(int iSiteID, int* pNodeID)
{

	StartStoredProcedure("getrootnodefromhierarchy");
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	*pNodeID = GetIntField("NodeID");
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeAliases(int iNodeID, bool& bSuccess)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Gets the list of nodelinks and subject names of the alias within the
				given id

*********************************************************************************/

bool CStoredProcedure::GetHierarchyNodeAliases(int iNodeID, bool& bSuccess)
{
	// Start the procedure
	StartStoredProcedure("getaliasesinhierarchy");

	// Add the Params
	AddParam(iNodeID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetHierarchyNodeAliases"))
	{
		return false;
	}

	// Set the success flag and return
	bSuccess = !IsEOF();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeArticles(int iNodeID, iType )

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Modified:	10/03/2005 (jamesp - contentrating)
	Inputs:		- NodeID for tagged articles ,  Type filter
	Outputs:	-
	Returns:	true if successful
	Purpose:	gets the articles within the given hierarchy node

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeArticles(int iNodeID, bool& bSuccess,  int iType/*=0*/, int iMaxResults /*=500*/, bool bIncludeContentRatingData)
{
	// Start the procedure
	StartStoredProcedure("getarticlesinhierarchynode");

	// Add the params
	AddParam(iNodeID);
	AddParam(iType);
	AddParam(iMaxResults);
	AddParam(bIncludeContentRatingData);
	AddParam("currentsiteid", m_SiteID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetHierarchyNodeArticles"))
	{
		return false;
	}

	// Set the success flag and return
	bSuccess = !IsEOF();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeArticlesWithLocal(int iNodeID,  int iType, 
		int iMaxResults, bool bIncludeContentRatingData, int iUserTaxonomyNodeID)

	Author:		David Williams
	Created:	07/04/2005
	Inputs:		- NodeID for tagged articles 
				- iType type filter
				- iMaxResults maximum results to return
				- bIncludeContentRating to include content ratings
				- iUserTaxonomyNodeID - the user's taxonomy node
	Outputs:	-
	Returns:	true if successful
	Purpose:	gets the articles within the given hierarchy node and tags if local

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeArticlesWithLocal(int iNodeID,  int iType/*=0*/, int iMaxResults /*=500*/, bool bIncludeContentRatingData, int iUserTaxonomyNodeID/*=0*/)
{
	StartStoredProcedure("getarticlesinhierarchynodewithlocal");
	AddParam("nodeid", iNodeID);
	AddParam("type", iType);
	AddParam("maxresults", iMaxResults);
	AddParam("showcontentratingdata", (int)bIncludeContentRatingData);
	AddParam("usernodeid", iUserTaxonomyNodeID);
	AddParam("currentsiteid", m_SiteID);

	ExecuteStoredProcedure();
	if (HandleError("GetHierarchyNodeArticlesWithLocal"))
	{
		return false;
	}
	return true;
}
/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodesArticles( const std::vector< int >& )

	Author:		Martin Robb
	Created:	16/12/2004
	Inputs:		- vector of nodes, Type filter
	Outputs:	- NA
	Returns:	true if successful
	Purpose:	gets the intersection of the articles tagged to the provided nodes.
				Can filter the nodes on type if required.
				Not currently in use,
*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodesArticles( const std::vector<int>& nodes, int iType )
{
	//Create a delimited string form the nodes
	CTDVString sNodes;
	for ( std::vector<int>::const_iterator iter = nodes.begin(); iter != nodes.end(); ++iter )
	{
		if ( iter != nodes.begin() )
		{
			sNodes << ",";
		}
		sNodes << *iter;
	}

	// Start the procedure
	StartStoredProcedure("getarticlesinhierarchynodes");

	// Add the params
	AddParam(sNodes);

	CTDVString token(",");
	AddParam(token);
	AddParam(iType);
	
	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetHierarchyNodeArticles"))
	{
		return false;
	}

	// Set the success flag and return
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeClubs(int iNodeID, bool& bSuccess)

	Author:		Mark Neves
	Created:	7/07/2003
	Inputs:		iNodeID = hierarchy node id
				bSuccess = place to store the result
	Outputs:	bSuccess = true if successful
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	gets the clubs within the given hierarchy node

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeClubs(int iNodeID, bool& bSuccess )
{
	StartStoredProcedure("getclubsinhierarchynode");
	AddParam(iNodeID);	
	AddParam("currentsiteid", m_SiteID);	// Current viewing siteid
	ExecuteStoredProcedure();

	if (HandleError("GetHierarchyNodeClubs"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess = !IsEOF();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeClubsWithLocal(int iNodeID, int iUserTaxonomyNodeID)

	Author:		Mark Neves
	Created:	7/07/2003
	Inputs:		iNodeID = hierarchy node id
				iUserTaxonomyNodeID - the user's taxonomy node
	Outputs:	-
	Returns:	true if executed ok, false if serious DB error occurred
	Purpose:	gets the clubs within the given hierarchy node with local tag

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeClubsWithLocal(int iNodeID, int iUserTaxonomyNodeID)
{
	StartStoredProcedure("getclubsinhierarchynodewithlocal");
	AddParam("nodeid", iNodeID);
	AddParam("usernodeid", iUserTaxonomyNodeID);
	AddParam("currentsiteid", m_SiteID);	// Current viewing siteid
	ExecuteStoredProcedure();

	if (HandleError("GetHierarchyNodeClubsWithLocel"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CacheGetMostRecentGuideEntry()

	Author:		Dharmesh Raithatha
	Created:	22/05/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Gets the 

*********************************************************************************/

bool CStoredProcedure::CacheGetTimeOfMostRecentGuideEntry(CTDVDateTime* pDate)
{
	StartStoredProcedure("cachegettimeofmostrecentguideentry");
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*pDate = CTDVDateTime(GetIntField("Seconds"));
		return true;
	}
	//check there is no error
}

/*********************************************************************************

	bool CStoredProcedure::FetchNextNicknameModerationBatch(int iUserID)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		iUserID - ID of the user doing the update
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::FetchNextNicknameModerationBatch(int iUserID)
{
	StartStoredProcedure("FetchNicknameModerationBatch");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateNicknameModeration(int iModID, int iStatus)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		iModID
				iStatus
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::UpdateNicknameModeration( int iModID, int iStatus )
{
	StartStoredProcedure("ModerateNickname");
	AddParam("ModID", iModID);
	AddParam("Status", iStatus);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::QueueArticleForModeration(int ih2g2ID, 
		int iTriggerId, int iTriggeredBy, const TDVCHAR* pcNotes)

	Author:		Kim Harries
	Created:	15/02/2001
	Inputs:		ih2g2ID
				iTriggerId - moderation trigger id - Moderator, Profanity filter,
					etc. see ModTrigger table
				iTriggeredBy - moderator id if iTriggerId is Moderator. Pass 
					value less than 1 to set to NULL
				pcNotes
	Outputs:	-
	Returns:	true if successful
	Purpose:	Queues the article for moderation.

*********************************************************************************/

bool CStoredProcedure::QueueArticleForModeration(int ih2g2ID, 
	int iTriggerId, int iTriggeredBy, const TDVCHAR* pcNotes, int* pModId)
{
	StartStoredProcedure("QueueArticleForModeration");
	AddParam("h2g2ID", ih2g2ID);
	AddParam("triggerid", iTriggerId);
	AddParam("triggeredby", iTriggeredBy);
	AddParam("Notes", pcNotes);
	int iModId;
	AddOutputParam("modid", &iModId);
	ExecuteStoredProcedure();
	while (IsEOF() == false)
	{
		MoveNext();
	}
	if (pModId != NULL)
	{
		*pModId = iModId;
	}
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::QueueNicknameForModeration(int iUserID, int iSiteID)

	Author:		Kim Harries
	Created:	27/02/2001
	Inputs:		iUserID - Id of the user whos name is being moderated
				iSiteID - the site on which they changed their name.
	Outputs:	-
	Returns:	true if successful
	Purpose:	Queues the users nickname for moderation.

*********************************************************************************/

bool CStoredProcedure::QueueNicknameForModeration(int iUserID, int iSiteID, const CTDVString& sNickName )
{
	StartStoredProcedure("QueueNicknameForModeration");
	AddParam("UserID", iUserID);
	AddParam("SiteID",iSiteID);
	AddParam("NickName", sNickName);
	ExecuteStoredProcedure();

	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllArticleModerations(int iUserID, int iCalledBy, int iModClassID)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iUserID
				iCalledBy - user id who called the method.
				iModClassID - the id of the class you want to unlock the entries for.
					If this is set to 0, then all entries in all classes are unlocked.
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all articles locked by this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllArticleModerations(int iUserID, int iCalledBy, int iModClassID)
{
	StartStoredProcedure("UnlockAllArticleModerations");
	AddParam("UserID", iUserID);
	AddParam("calledby", iCalledBy);
	if (iModClassID > 0)
	{
		AddParam("ModClassID",iModClassID);
	}
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllForumModerations(int iUserID)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iUserID
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all posts locked by this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllForumModerations(int iUserID)
{
	StartStoredProcedure("UnlockAllForumModerations");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockModeratePostsForUser(int iUserID)

	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		iUserID - User Id to unlock
				iModClassId - If non-zero unlock sites with given mod class id 
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all posts locked by this user for moderation.

*********************************************************************************/
bool CStoredProcedure::UnlockModeratePostsForUser( int iUserID, int iModClassID )
{
	StartStoredProcedure("UnlockModeratePostsForUser");
	AddParam("userID",iUserID);
	if ( iModClassID > 0 )
		AddParam("modclassid", iModClassID );
	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::UnlockModeratePostsForSite(int iUserID, int iSiteId)

	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		iUserID - Editor instigating unlock
				iSiteId - Site to unlock.
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all posts for a site.

*********************************************************************************/
bool CStoredProcedure::UnlockModeratePostsForSite ( int iUserID, int iSiteID, bool bSuperUser )
{

	StartStoredProcedure("UnlockModeratePostsForSite");
	AddParam("userid", iUserID);
	AddParam("siteid",iSiteID);
	AddParam( "superuser", bSuperUser );
	return ExecuteStoredProcedure();
}
	
/*********************************************************************************

	bool CStoredProcedure::UnlockModeratePosts(int iUserID)

	Author:		Martin Robb
	Created:	15/11/2005
	Inputs:		iUserID - Editor instigating unlock
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all posts for all sites.

*********************************************************************************/
bool CStoredProcedure::UnlockModeratePosts( int iUserID, bool bSuperUser )
{
	StartStoredProcedure("UnlockModeratePosts");
	AddParam( "userid", iUserID );
	AddParam( "superuser", bSuperUser );
	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllNicknameModerations(int iUserID, int iClassModID)

	Author:		Kim Harries
	Created:	06/03/2001
	Inputs:		iUserID
				iClassModID - The id of the class that the nicknames belong to.
					If set to 0, then all nicknames form all classes are unlocked
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all nicknames locked by this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllNicknameModerations(int iUserID, int iClassModID)
{
	StartStoredProcedure("UnlockAllNicknameModerations");
	AddParam("UserID", iUserID);
	if (iClassModID > 0)
	{
		AddParam("ModClassID", iClassModID);
	}
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllGeneralModerations(int iUserID)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iUserID
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all general page moderations locked by this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllGeneralModerations(int iUserID)
{
	StartStoredProcedure("UnlockAllGeneralModerations");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllArticleReferrals(int iUserID, int iCalledBy)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iUserID
				iCalledBy - current user id
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all articles referred to this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllArticleReferrals(int iUserID, int iCalledBy)
{
	StartStoredProcedure("UnlockAllArticleReferrals");
	AddParam("UserID", iUserID);
	AddParam("calledby", iCalledBy);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllForumReferrals(int iUserID)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iUserID
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all posts referred to this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllForumReferrals(int iUserID)
{
	StartStoredProcedure("UnlockAllForumReferrals");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnlockAllGeneralReferrals(int iUserID)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iUserID
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unlocks all general pages referred to this user for moderation.

*********************************************************************************/

bool CStoredProcedure::UnlockAllGeneralReferrals(int iUserID)
{
	StartStoredProcedure("UnlockAllGeneralReferrals");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchPostDetails(int iPostID)

	Author:		Kim Harries
	Created:	07/02/2001
	Inputs:		iPostID - ID of the post to fetch details on
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::FetchPostDetails(int iPostID)
{
	StartStoredProcedure("FetchPostDetails");
	AddParam("PostID", iPostID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UpdatePostDetails(int iPostID, const TDVCHAR* pcSubject, const TDVCHAR* pcText, bool bSetLastUpdated)

	Author:		Kim Harries
	Created:	16/02/2001
	Inputs:		iPostID - ID of the post to fetch details on
				pcSubject
				pcText
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::UpdatePostDetails(CUser* pUser, int iPostID, const TDVCHAR* pcSubject, 
										 const TDVCHAR* pcText, const TDVCHAR* pEventDate, bool bSetLastUpdated, bool bForceModerateAndHide,
										 bool bIgnoreModeration)
{
	int iUserID = 0;
	if (pUser != NULL)
	{
		iUserID = pUser->GetUserID();
	}

	StartStoredProcedure("UpdatePostDetails");
	AddParam("UserID",iUserID);
	AddParam("PostID", iPostID);
	AddParam("Subject", pcSubject);
	AddParam("Text", pcText);
	if ( pEventDate )
		AddParam("Eventdate", pEventDate);
	AddParam("SetLastUpdated", bSetLastUpdated);
	AddParam("ForceModerateAndHide",bForceModerateAndHide);
	AddParam("IgnoreModeration",bIgnoreModeration);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode;
	// check there is no error
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::HidePost(int iPostID)

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		iPostID - ID of the post to hide
	Outputs:	-
	Returns:	true if successful
	Purpose:	Hides the given post.

*********************************************************************************/

bool CStoredProcedure::HidePost(int iPostID, int iHiddenStatus )
{
	StartStoredProcedure("HidePost");
	AddParam("PostID", iPostID);
	AddParam("HiddenID", iHiddenStatus);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnhidePost(int iPostID)

	Author:		Kim Harries
	Created:	19/02/2001
	Inputs:		iPostID - ID of the post to unhide
	Outputs:	-
	Returns:	true if successful
	Purpose:	Unhides the given post.

*********************************************************************************/

bool CStoredProcedure::UnhidePost(int iPostID)
{
	StartStoredProcedure("UnhidePost");
	AddParam("PostID", iPostID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::HideArticle(int iEntryID, int iHiddenStatus, 
		int iModId, int iCalledBy)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		iEntryID - ID of the post to hide
				iHiddenStatus - 1 = Hidden Failed Moderation.
								2 = Hidden for Referal.
								3 = Hidden For Moderation.
				iModId - article moderation id if "hide" action needs to be
					linked with a particular moderation record
				iTriggerId - see ModTrigger table
				iCalledBy - user id who called the method
	Outputs:	-
	Returns:	true if successful
	Purpose:	Hides the given Article.

*********************************************************************************/

bool CStoredProcedure::HideArticle(int iEntryID, int iHiddenStatus, int iModId, 
	int iTriggerId, int iCalledBy)
{
	StartStoredProcedure("HideArticle");
	AddParam("EntryID", iEntryID);
	AddParam("HiddenStatus",iHiddenStatus);
	AddParam("modid", iModId);
	AddParam("triggerid", iTriggerId);
	AddParam("calledby", iCalledBy);
	ExecuteStoredProcedure();

	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnhideArticle(int iEntryID, int iModId, 
		int iTriggerId, int iCalledBy)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		iEntryID - ID of the Article to unhide
				iModId - article moderation id if "unhide" actions needs to
					be linked with a particular moderation record
				iTriggerId - see ModTrigger table
				iCalledBy - user if who called the method

	Outputs:	-
	Returns:	true if successful
	Purpose:	Unhides the given Article.

*********************************************************************************/

bool CStoredProcedure::UnhideArticle(int iEntryID, int iModId, 
	int iTriggerId, int iCalledBy)
{
	StartStoredProcedure("UnhideArticle");
	AddParam("EntryID", iEntryID);
	AddParam("modid", iModId);
	AddParam("triggerid", iTriggerId);
	AddParam("calledby", iCalledBy);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchArticleDetails(int iEntryID)

	Author:		Kim Harries
	Created:	12/02/2001
	Inputs:		iEntryID - ID of the article to fetch details on
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::FetchArticleDetails(int iEntryID)
{
	StartStoredProcedure("FetchArticleDetails");
	AddParam("EntryID", iEntryID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchGuideEntryDetails(int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	10/2/2003
	Inputs:		iH2G2ID - guidentry you want to get details for
	Outputs:	-
	Returns:	false if error or h2g2id not present
	Purpose:	Fetches all the information about the guidentry from the guideentries
				table.

*********************************************************************************/

bool CStoredProcedure::FetchGuideEntryDetails(int iH2G2ID)
{
	StartStoredProcedure("FetchGuideEntryDetails");
	AddParam("H2G2ID", iH2G2ID);
	ExecuteStoredProcedure();
	
	if (HandleError("FetchGuideEntryDetails"))
	{
		return false;
	}

	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetSiteSpecificContentSignifSettings(int p_iSiteID)

	Author:		James Conway
	Created:	18/04/2005
	Inputs:		p_iSiteID - SiteID you want ContentSignifSettings for. 
	Outputs:	-
	Returns:	false if error or p_iSiteID not present
	Purpose:	Fetches all ContentSignif settings for a site. 

*********************************************************************************/

bool CStoredProcedure::GetSiteSpecificContentSignifSettings(int p_iSiteID)
{
	StartStoredProcedure("getsitespecificcontentsignifsettings");
	AddParam("siteid", p_iSiteID);
	ExecuteStoredProcedure();
	
	if (HandleError("getsitespecificcontentsignifsettings"))
	{
		return false;
	}

	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::SetSiteSpecificContentSignifSettings(int piSiteID, CTDVString p_param1, CTDVString p_param2, CTDVString p_param3, CTDVString p_param4, CTDVString p_param5, CTDVString p_param6, CTDVString p_param7, CTDVString p_param8, CTDVString p_param9, CTDVString p_param10, CTDVString p_param11, CTDVString p_param12, CTDVString p_param13, CTDVString p_param14, CTDVString p_param15, CTDVString p_param16, CTDVString p_param17, CTDVString p_param18, CTDVString p_param19, CTDVString p_param20, CTDVString p_param21, CTDVString p_param22, CTDVString p_param23, CTDVString p_param24, CTDVString p_param25, CTDVString p_param26, CTDVString p_param27, CTDVString p_param28, CTDVString p_param29, CTDVString p_param30, CTDVString p_param31, CTDVString p_param32, CTDVString p_param33, CTDVString p_param34, CTDVString p_param35)

	Author:		James Conway
	Created:	18/04/2005
	Inputs:		p_iSiteID (SiteID you want ContentSignifSettings for) and increment and decrement values for the site. 
	Outputs:	-
	Returns:	false if error or p_iSiteID not present
	Purpose:	Sets ContentSignif settings for a site. 

*********************************************************************************/
bool CStoredProcedure::SetSiteSpecificContentSignifSettings(int piSiteID, CTDVString p_param1, CTDVString p_param2, CTDVString p_param3, CTDVString p_param4, CTDVString p_param5, CTDVString p_param6, CTDVString p_param7, CTDVString p_param8, CTDVString p_param9, CTDVString p_param10, CTDVString p_param11, CTDVString p_param12, CTDVString p_param13, CTDVString p_param14, CTDVString p_param15, CTDVString p_param16, CTDVString p_param17, CTDVString p_param18, CTDVString p_param19, CTDVString p_param20, CTDVString p_param21, CTDVString p_param22, CTDVString p_param23, CTDVString p_param24, CTDVString p_param25, CTDVString p_param26, CTDVString p_param27, CTDVString p_param28, CTDVString p_param29, CTDVString p_param30, CTDVString p_param31, CTDVString p_param32, CTDVString p_param33, CTDVString p_param34, CTDVString p_param35)
{
	StartStoredProcedure("updatesitespecificcontentsignifsettings");
	AddParam("siteid", piSiteID);
	AddParam("param1", p_param1);
	AddParam("param2", p_param2);
	AddParam("param3", p_param3);
	AddParam("param4", p_param4);
	AddParam("param5", p_param5);
	AddParam("param6", p_param6);
	AddParam("param7", p_param7);
	AddParam("param8", p_param8);
	AddParam("param9", p_param9);
	AddParam("param10", p_param10);
	AddParam("param11", p_param11);
	AddParam("param12", p_param12);
	AddParam("param13", p_param13);
	AddParam("param14", p_param14);
	AddParam("param15", p_param15);
	AddParam("param16", p_param16);
	AddParam("param17", p_param17);
	AddParam("param18", p_param18);
	AddParam("param19", p_param19);
	AddParam("param20", p_param20);
	AddParam("param21", p_param21);
	AddParam("param22", p_param22);
	AddParam("param23", p_param23);
	AddParam("param24", p_param24);
	AddParam("param25", p_param25);
	AddParam("param26", p_param26);
	AddParam("param27", p_param27);
	AddParam("param28", p_param28);
	AddParam("param29", p_param29);
	AddParam("param30", p_param30);
	AddParam("param31", p_param31);
	AddParam("param32", p_param32);
	AddParam("param33", p_param33);
	AddParam("param34", p_param34);
	AddParam("param35", p_param35);
	ExecuteStoredProcedure();
	
	if (HandleError("SetSiteSpecificContentSignifSettings"))
	{
		return false;
	}

	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::DecrementContentSignif(int p_iSiteID)

	Author:		James Conway
	Created:	18/04/2005
	Inputs:		p_iSiteID 
	Outputs:	-
	Returns:	false if errort
	Purpose:	Decrements site's ContentSignif tables. 

*********************************************************************************/
bool CStoredProcedure::DecrementContentSignif(int p_iSiteID)
{
	StartStoredProcedure("ContentSignifSiteDecrement");
	AddParam("SiteID", p_iSiteID);
	ExecuteStoredProcedure();

	if (HandleError("DecrementContentSignif"))
	{
		return false;
	}

	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetMostSignifContent(int p_iSiteID)

	Author:		James Conway
	Created:	25/4/2005
	Inputs:		p_iSiteID 
	Outputs:	
	Returns:	boolean false if error
	Purpose:	Gets the most significant content for a site.

*********************************************************************************/

bool CStoredProcedure::GetMostSignifContent(int p_iSiteID)
{
	StartStoredProcedure("getmostsignifcontent");
	AddParam("SiteID", p_iSiteID);
	ExecuteStoredProcedure();

	if (HandleError("GetMostSignifContent"))
	{
		return false;
	}

	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetArticlePermissionsForUser(const int iEntryId, const int iUserId, 
				bool& bCanRead, bool& bCanWrite, bool bCanChangePermissions)

	Author:		David van Zijl
	Created:	10/2/2003
	Inputs:		iEntryId - guidentry you want to get details for
				iUserId - user to get permissions for
	Outputs:	bCanRead, bCanWrite, bCanChangePermissions
	Returns:	false if error
	Purpose:	Fetches article permissions

*********************************************************************************/

bool CStoredProcedure::GetArticlePermissionsForUser(const int iH2G2Id, const int iUserId, 
				bool& bUserFound, bool& bCanRead, bool& bCanWrite, bool& bCanChangePermissions)
{
	StartStoredProcedure("GetArticlePermissionsForUser");
	AddParam("h2g2Id", iH2G2Id);
	AddParam("UserId", iUserId);
	ExecuteStoredProcedure();
	
	if (HandleError("GetArticlePermissionsForUser"))
	{
		return false;
	}

	if (IsEOF() || IsNULL("h2g2id"))
	{
		// No rows, so user not found for that article
		bUserFound = false;
	}
	else
	{
		bUserFound = true;
		bCanRead  = (GetIntField("CanRead") == 1);
		bCanWrite = (GetIntField("CanWrite") == 1);
		bCanChangePermissions = (GetIntField("CanChangePermissions") == 1);
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchEditorsList()

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches a list of all the users with editor status

*********************************************************************************/

bool CStoredProcedure::FetchEditorsList()
{
	StartStoredProcedure("FetchEditorsList");
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchModeratorsList()

	Author:		Kim Harries
	Created:	07/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches a list of all the users in the moderator group

*********************************************************************************/

bool CStoredProcedure::FetchModeratorsList()
{
	StartStoredProcedure("FetchModeratorsList");
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchLockedItemsStats()

	Author:		Kim Harries
	Created:	08/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches statistics all items currently locked or referred to specific
				users.

*********************************************************************************/

bool CStoredProcedure::FetchLockedItemsStats()
{
	StartStoredProcedure("FetchLockedItemsStats");
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchUsersLastSession(int iUserID)

	Author:		Kim Harries
	Created:	09/03/2001
	Inputs:		iUserID - id of user to fetch session ifo on
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches info on this users most recent session.

*********************************************************************************/

bool CStoredProcedure::FetchUsersLastSession(int iUserID)
{
	StartStoredProcedure("FetchUsersLastSession");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnreferArticle(int iModID, int iCalledBy, const TDVCHAR* pcNotes)

	Author:		Kim Harries
	Created:	14/03/2001
	Inputs:		iModID - moderation id of the item to be unreferred
				iCalledBy - user id who called the method
	Outputs:	-
	Returns:	true if successful
	Purpose:	Return the item to the locked queue of the person that referred it.

*********************************************************************************/

bool CStoredProcedure::UnreferArticle(int iModID, int iCalledBy, const TDVCHAR* pcNotes)
{
	StartStoredProcedure("UnreferArticle");
	AddParam("ModID", iModID);
	AddParam("Notes", pcNotes);
	AddParam("calledby", iCalledBy);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UnreferPost(int iModID, const TDVCHAR* pcNotes)

	Author:		Kim Harries
	Created:	14/03/2001
	Inputs:		iModID - moderation id of the item to be unreferred
	Outputs:	-
	Returns:	true if successful
	Purpose:	Return the item to the locked queue of the person that referred it.

*********************************************************************************/

bool CStoredProcedure::UnreferPost(int iModID, const TDVCHAR* pcNotes)
{
	StartStoredProcedure("UnreferPost");
	AddParam("ModID", iModID);
	AddParam("Notes", pcNotes);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchArticleModerationHistory(int ih2g2ID)

	Author:		Kim Harries
	Created:	15/03/2001
	Inputs:		ih2g2ID - the article we want the history of
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches the moderation history for this entry.

*********************************************************************************/

bool CStoredProcedure::FetchArticleModerationHistory(int ih2g2ID)
{
	StartStoredProcedure("FetchArticleModerationHistory");
	AddParam("h2g2ID", ih2g2ID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchPostModerationHistory(int iPostID)

	Author:		Kim Harries
	Created:	16/03/2001
	Inputs:		iPostID - the post we want the history of
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches the moderation history for this post.

*********************************************************************************/

bool CStoredProcedure::FetchPostModerationHistory(int iPostID)
{
	StartStoredProcedure("FetchPostModerationHistory");
	AddParam("PostID", iPostID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchArticleDetails(int iUserID, int ih2g2ID)

	Author:		Kim Harries
	Created:	26/02/2001
	Inputs:		iUserID
				ih2g2ID
	Outputs:	-
	Returns:	true if user has this entry locked for moderation
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::UserHasEntryLockedForModeration(int iUserID, int ih2g2ID)
{
	bool	bLocked = false;

	StartStoredProcedure("checkuserhasentrylockedformoderation");
	AddParam("userid", iUserID);
	AddParam("h2g2id", ih2g2ID);
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	if (!GetLastError(&sTemp, iErrorCode))
	{
		bLocked = GetBoolField("IsLocked");
	}
	return bLocked;
}

/*********************************************************************************

	bool CStoredProcedure::RegisterArticleComplaint(int iComplainantID, int ih2g2ID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText)

	Author:		Kim Harries
	Created:	08/02/2001
	Inputs:		iComplainantID
				ih2g2ID
				pcCorrespondenceEmail
				pcComplaintText
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::RegisterArticleComplaint(int iComplainantID, int ih2g2ID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText, const TDVCHAR* pIPAddress, const TDVCHAR* pBBCUID)
{
	// make sure complaint text is cropped to 2000 chars
	//sComplaintText = sComplaintText.Left(2000); - not needed as Complaints as stored as TEXT fields
	StartStoredProcedure("RegisterArticleComplaint");
	AddParam("ComplainantID", iComplainantID);
	AddParam("CorrespondenceEmail", pcCorrespondenceEmail);
	AddParam("h2g2ID", ih2g2ID);
	AddParam("ComplaintText", pcComplaintText);

    CTDVString hash;
    CTDVString content = CTDVString(iComplainantID) + ":" + pcCorrespondenceEmail + ":" + CTDVString(ih2g2ID) + ":" + pcComplaintText;
    GenerateHash(content,hash);
    AddUIDParam("hash",hash);

	if (pIPAddress != NULL && pIPAddress[0] != 0)
	{
		AddParam(pIPAddress);
	}
	else
	{
		AddNullParam();
	}

	if (pBBCUID != NULL && pBBCUID[0] != 0)
	{
		AddUIDParam(pBBCUID);
	}
	else
	{
		AddNullParam();
	}

	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::RegisterPostingComplaint(int iComplainantID, int iPostID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText)

	Author:		Kim Harries
	Created:	08/02/2001
	Inputs:		iComplainantID
				iPostID
				pcCorrespondenceEmail
				pcComplaintText
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::RegisterPostingComplaint(int iComplainantID, int iPostID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText, const TDVCHAR* pIPAddress, const TDVCHAR* pBBCUID)
{
	// make sure complaint text is cropped to 2000 chars
	//sComplaintText = sComplaintText.Left(2000); - not needed as Complaints as stored as TEXT fields
	StartStoredProcedure("RegisterPostingComplaint");
	AddParam("ComplainantID", iComplainantID);
	AddParam("CorrespondenceEmail", pcCorrespondenceEmail);
	AddParam("PostID", iPostID);
	AddParam("ComplaintText", pcComplaintText);

    CTDVString hash;
    CTDVString content = CTDVString(iComplainantID) + ":" + pcCorrespondenceEmail + ":" + CTDVString(iPostID) + ":" + pcComplaintText;
    GenerateHash(content,hash);
    AddUIDParam("hash",hash);

	if (pIPAddress != NULL && pIPAddress[0] != 0)
	{
		AddParam("IPAddress",pIPAddress);
	}
	else
	{
		AddNullParam("IPAddress");
	}
	if (pBBCUID != NULL && pBBCUID[0] != 0)
	{
		AddUIDParam("bbcuid",pBBCUID);
	}
	else
	{
		AddNullParam("bbcuid");
	}
	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::LockPostModerationEntry(int iModID, int iUserID)

		Author:		Mark Neves
        Created:	08/04/2004
        Inputs:		iModID = the id for the row in the threadmod table
					iUserID = the ID of the user who wants to lock it
        Outputs:	-
        Returns:	true if OK, false otherwise
        Purpose:	Direct access to the threadmod table allowing you to lock an entry

*********************************************************************************/

bool CStoredProcedure::LockPostModerationEntry(int iModID, int iUserID)
{
	StartStoredProcedure("lockpostmoderationentry");
	AddParam("ModID", iModID);
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();

	if (HandleError("LockPostModerationEntry"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}	

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RegisterGeneralComplaint(int iComplainantID, const TDVCHAR* pcURL, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText)

	Author:		Kim Harries
	Created:	08/02/2001
	Inputs:		iComplainantID
				pcURL
				pcCorrespondenceEmail
				pcComplaintText
	Outputs:	-
	Returns:	true if successful
	Purpose:	???

*********************************************************************************/

bool CStoredProcedure::RegisterGeneralComplaint(int iComplainantID, const TDVCHAR* pcURL, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText, int iSiteID, const TDVCHAR* pIPAddress, const TDVCHAR* pBBCUID)
{
	TDVASSERT(iSiteID > 0,"Invalid SiteID in CStoredProcedure::RegisterGeneralComplaint");

	// make sure complaint text is cropped to 2000 chars
	//sComplaintText = sComplaintText.Left(2000); - not needed as Complaints as stored as TEXT fields
	StartStoredProcedure("RegisterGeneralComplaint");
	AddParam("ComplainantID", iComplainantID);
	AddParam("URL", pcURL);
	AddParam("CorrespondenceEmail", pcCorrespondenceEmail);
	AddParam("ComplaintText",  pcComplaintText);
	AddParam("SiteID",iSiteID);

    CTDVString hash;
    CTDVString content = CTDVString(iComplainantID) + ":" + pcCorrespondenceEmail + ":" + pcURL + ":" + pcComplaintText;
    GenerateHash(content,hash);
    AddUIDParam("hash",hash);

	if (pIPAddress != NULL && pIPAddress[0] != 0)
	{
		AddParam(pIPAddress);
	}
	else
	{
		AddNullParam();
	}

	if (pBBCUID != NULL && pBBCUID[0] != 0)
	{
		AddUIDParam(pBBCUID);
	}
	else
	{
		AddNullParam();
	}

	ExecuteStoredProcedure();
	// check there is no error
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::AssociateBBCUID(const TDVCHAR *pLoginName, const TDVCHAR *pBBCUID, const TDVCHAR *pEmail, const TDVCHAR* pPassword, int *oUserID, int *oError, CTDVString *oErrorString, CTDVString* oCookie)

	Author:		Jim Lynn
	Created:	08/02/2001
	Inputs:		pLoginName - BBC loginname
				pBBCUID - UID from the BBC database. Can be either 32 char or 36 char
				pEmail - email address to key from our database
				pPassword - h2g2 password to verify identity
	Outputs:	oUserID - int user ID from the h2g2 database
				oCookie - string containing our cookie
				oError - int error code (0 means success)
				oErrorString - string description of error
				oFirstTime - 0 if they have already activated the account
								1 if it's the first time.
	Returns:	true if succeeded, false if failed
	Purpose:	Gets a verified BBC loginname and UID and associates it with a user
				in our database. Will fail if the user already has another login
				associated with them, or the email/password combo failed.

*********************************************************************************/

bool CStoredProcedure::AssociateBBCUID(const TDVCHAR *pLoginName, const TDVCHAR *pBBCUID, const TDVCHAR *pEmail, const TDVCHAR* pPassword, int *oUserID, int *oError, CTDVString *oErrorString, CTDVString* oCookie, int* oFirstTime)
{
	CTDVString sBBCUID;
	// Fix BBC UID to have our format
	if (strlen(pBBCUID) == 32)
	{
		// Change from 0123456789ABCDEF0123456789ABCDEF
		// to 01234567-89AB-CDEF-0123-456789ABCDEF
		TDVCHAR temp[37];
		
		const TDVCHAR* src = pBBCUID;
		TDVCHAR* dest = temp;

		strncpy(dest, src,8);
		dest += 8;
		src += 8;
		dest++[0] = '-';

		strncpy(dest, src,4);
		dest += 4;
		src += 4;
		dest++[0] = '-';

		strncpy(dest, src,4);
		dest += 4;
		src += 4;
		dest++[0] = '-';

		strncpy(dest, src,4);
		dest += 4;
		src += 4;
		dest++[0] = '-';

		strncpy(dest, src,12);
		dest += 12;
		src += 12;
		dest++[0] = 0;
		
		sBBCUID = temp;
	}
	else
	{
		sBBCUID = pBBCUID;
	}
	StartStoredProcedure("associatewithbbc");
	AddParam(pEmail);
	AddParam(sBBCUID);
	AddParam(pPassword);
	AddParam(pLoginName);

	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*oError = GetIntField("Error");
		GetField("Reason", *oErrorString);
		*oUserID = GetIntField("UserID");
		GetField("Cookie", *oCookie);

		return ((*oError) == 0);
	}
	else
	{
		*oError = -1;
		*oErrorString = "Failed to get result from database";
		return false;
	}
}

bool CStoredProcedure::FindBBCUID(const TDVCHAR *pUID, int iSiteID, int *oUserID, CTDVString *oCookie)
{
	StartStoredProcedure("findbbcuid");

	// Add the UID to the param list
	if (!AddUIDParam(pUID))
	{
		return false;
	}

	AddParam(iSiteID);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*oUserID = GetIntField("UserID");
		GetField("Cookie", *oCookie);
		return true;
	}
	else
	{
		return false;
	}
}

bool CStoredProcedure::CreateNewUserFromBBCUID(const TDVCHAR *pLoginName, const TDVCHAR *pUID, const TDVCHAR *pEmail, int iSiteID, int *oUserID, CTDVString *oCookie)
{
	StartStoredProcedure("createnewuserwithbbcuid");

	AddParam(pLoginName);

	// Add the UID to the param list
	if (!AddUIDParam(pUID))
	{
		return false;
	}

	AddParam(pEmail);
	AddParam(iSiteID);
	ExecuteStoredProcedure();

	if (!IsEOF())
	{
		*oUserID = GetIntField("UserID");
		GetField("Cookie", *oCookie);
		return true;
	}
	else
	{
		return false;
	}

}

/*********************************************************************************

	bool CStoredProcedure::CreateNewUserFromUserID(const TDVCHAR *pUserName,int iUserID,const TDVCHAR *pEmail, int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	given the user id this will create a new user in the table. The 
				user table is no longer autoincrementing

*********************************************************************************/
/*
bool CStoredProcedure::CreateNewUserFromUserID(const TDVCHAR *pUserName, int iUserID, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstNames, const TDVCHAR* pLastName )
{
	StartStoredProcedure("createnewuserfromuserid");
	AddParam("userid", iUserID);
	AddParam("username", pUserName);
	AddParam("email", pEmail);
	AddParam("siteid", iSiteID);
	if ( pFirstNames ) 
	{
		AddParam("firstnames", pFirstNames );
	}
	if ( pLastName ) 
	{
		AddParam("lastname", pLastName );
	}
	ExecuteStoredProcedure();

	if (HandleError("CreateNewUserFromUserID"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}	

	if (!IsEOF())
	{
		return true;
	}
	else
	{
		return false;
	}
}
*/
/*********************************************************************************

	bool SynchroniseUserWithProfile(const TDVCHAR *pUserName, const TDVCHAR *pFirstNames,
							const TDVCHAR *pLastName, int iUserID,const TDVCHAR* sEmail,
							const TDVCHAR* sLoginName, int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	9/12/2003
	Inputs:		pFirstNames = first names (can be NULL if not supported by this SSO service)
				pLastName = last name  (can be NULL if not supported by this SSO service)
				iUserID = the user id
				sEmail = email address
                sLoginName = login name
				iSiteID = site id
	Outputs:	-
	Returns:	-
	Purpose:	Updates the given user with the given information

*********************************************************************************/
bool CStoredProcedure::SynchroniseUserWithProfile(CTDVString* pFirstNames,
												  CTDVString* pLastName, int iUserID,
												  const TDVCHAR* sEmail, 
												  const TDVCHAR* sLoginName,
												  int iSiteID,
												  CTDVString* pDisplayName,
												  BOOL bIdentitySite)
{
	StartStoredProcedure("synchroniseuserwithprofile");
	AddParam("userid",iUserID);
	AddParam("EMail",sEmail);
	AddParam("LoginName", sLoginName);
	AddParam("SiteID",iSiteID);
	AddParam("identitysite",bIdentitySite ? 1 : 0);

	// Only add first and last name params if values have been passed in
	if (pFirstNames != NULL)
	{
		AddParam("FirstNames",*pFirstNames);
	}

	if (pLastName != NULL)
	{
		AddParam("LastName",*pLastName);
	}

	if (pDisplayName != NULL && pDisplayName->GetLength() > 0)
	{
		AddParam("DisplayName",*pDisplayName);
	}

	ExecuteStoredProcedure();

	if (HandleError("SynchroniseUserWithProfile"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}	

	if (!IsEOF())
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CStoredProcedure::IsDatabaseRunning()
{
	StartStoredProcedure("isdatabaserunning");
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CStoredProcedure::GetPreModerationState()
{
	StartStoredProcedure("getpremoderationstate");
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		return (GetIntField("PreModeration") == 1);
	}
	else
	{
		return false;
	}

}

/*********************************************************************************

	bool CStoredProcedure::SubmitScoutRecommendation(int iUserID, int iEntryID, const TDVCHAR* pcComments)

	Author:		Kim Harries
	Created:	08/11/2000
	Inputs:		iUserID - ID of the scout doing the recommending
				iEntryID - ID of the entry they are recommending
				pcComments - any comments they made
	Outputs:	-
	Returns:	true if successful
	Purpose:	Records the scouts recommendation if it is a valid one.
	Fields:		RecommendationID int - unique ID for this recommendation, if successful
				AlreadyRecommended bit - set to 1 if entry is already recommended and is pending
					an editorial decision
				UserID int - the user ID of the user that recommended it if already recommended
				Username varchar(255) - ditto for their username
				WrongStatus bit - set to 1 if the entry had the wrong status to be recommended
				Success bit - set to 1 if the recommendatin was stored

*********************************************************************************/

bool CStoredProcedure::SubmitScoutRecommendation(int iUserID, int iEntryID, const TDVCHAR* pcComments)
{
	StartStoredProcedure("StoreScoutRecommendation");
	AddParam("ScoutID", iUserID);
	AddParam("EntryID", iEntryID);
	if (pcComments != NULL)
	{
		AddParam("Comments", pcComments);
	}
	ExecuteStoredProcedure();

	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::SubmitSubbedEntry(int iUserID, int iEntryID, const TDVCHAR* pcComments = NULL)

	Author:		Kim Harries
	Created:	18/12/2000
	Inputs:		iUserID - ID of the sub submitting this entry
				iEntryID - ID of the entry that has been subbed
				pcComments - any comments they made
	Outputs:	-
	Returns:	true if successful
	Purpose:	Submits an entry that has been subbed and needs to be returned to
				the editors.
	Fields:		Success bit => whether operation was successful
				InvalidEntry bit => true if entry is not an accepted recommendation
				UserNotSub bit => true if this user is not the sub for this entry
				RecommendationStatus bit => the status of the recommendation (before the operation)
				DateReturned  date => date that the entry was returned, if it laready has been

*********************************************************************************/

bool CStoredProcedure::SubmitSubbedEntry(int iUserID, int iEntryID, const TDVCHAR* pcComments)
{
	StartStoredProcedure("SubmitReturnedSubbedEntry");
	AddParam("UserID", iUserID);
	AddParam("EntryID", iEntryID);
	if (pcComments != NULL)
	{
		AddParam("Comments", pcComments);
	}
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::MoveThread(int iThreadID, int iForumID)

	Author:		Kim Harries
	Created:	20/12/2000
	Inputs:		iThreadID - thread to move
				iForumID - forum to move it to
	Outputs:	-
	Returns:	true if successful
	Purpose:	Moves the specified thread to the specified forum.
	Fields:		Success bit => whether operation was successful
				???

*********************************************************************************/

bool CStoredProcedure::MoveThread(int iThreadID, int iForumID)
{
	StartStoredProcedure("MoveThread2");
	AddParam("ThreadID", iThreadID);
	AddParam("ForumID", iForumID);
	ExecuteStoredProcedure();
	
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UndoThreadMove(int iThreadID, int iPostID)

	Author:		Kim Harries
	Created:	09/01/2001
	Inputs:		iThreadID - thread to undo move of
				iPostID - auto posting that needs removing
	Outputs:	-
	Returns:	true if successful
	Purpose:	Undoes the move of the specified thread to the specified forum, and
				also hides the posting that was automatically made to that thread.
	Fields:		Success bit => whether operation was successful
				???

*********************************************************************************/

bool CStoredProcedure::UndoThreadMove(int iThreadID, int iPostID)
{
	StartStoredProcedure("UndoThreadMove");
	AddParam("ThreadID", iThreadID);
	AddParam("PostID", iPostID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::FetchThreadMoveDetails(int iThreadID, int iForumID)

	Author:		Kim Harries
	Created:	21/12/2000
	Inputs:		iThreadID - thread to move
				iForumID - forum to move it to
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches details on the forums involved in moving this thread
				to this new forum.
	Fields:		Success bit => whether operation was successful
				???

*********************************************************************************/

bool CStoredProcedure::FetchThreadMoveDetails(int iThreadID, int iForumID)
{
	StartStoredProcedure("FetchThreadMoveDetails");
	AddParam("ThreadID", iThreadID);
	AddParam("ForumID", iForumID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateEntryResearcherList(int iEntryID, int iEditorID, int* piResearcherIDArray, int iTotalResearchers)

	Author:		Kim Harries
	Created:	04/01/2001
	Inputs:		iEntryID - ID of the entry to update
				iEditorID - ID of the editor
				piResearcherIDArray - array of user IDs
				iTotalResearchers - total no. of researchers
	Outputs:	-
	Returns:	true if successful
	Purpose:	Updates the entries list of researchers to the one provided
	Fields:		Success bit => whether operation was successful
				???

*********************************************************************************/

bool CStoredProcedure::UpdateEntryResearcherList(int iEntryID, int iEditorID, int* piResearcherIDArray, int iTotalResearchers)
{
	TDVASSERT(iEditorID > 0, "Invalid EditorID in CStoredProcedure::UpdateEntryResearcherList(...)");

	CTDVString	sError;
	CTDVString	sTemp;
	int			i = 0;
	bool		bOkay = true;

	// first use the update SP, which will delete any existing researchers
	StartStoredProcedure("UpdateEntryResearcherList");
	AddParam(iEntryID);
	// make sure editor is always included in the list
	AddParam(iEditorID);
	for (i = 0; i < iTotalResearchers && i < 19; i++)
	{
//		sTemp = "id";
//		sTemp << i + 1;
		AddParam(piResearcherIDArray[i]);
	}
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	int iErrorCode;
	bOkay = bOkay && !GetLastError(&sError, iErrorCode);
	// if we have more than 20 researchers (including the editor) to add we now use the
	// add researchers SP, since this wont delete any existing researchers
	while (bOkay && i < iTotalResearchers)
	{
		int	iCount = 0;

		StartStoredProcedure("AddEntryResearchers");
		AddParam(iEntryID);
		for (i = i; i < iTotalResearchers && iCount < 20; i++)
		{
		//	sTemp = "id";
		//	sTemp << i;
			AddParam(piResearcherIDArray[i]);
			iCount++;
		}
		ExecuteStoredProcedure();
		// should be no errors, but check just in case
		int iErrorCode;
		bOkay = bOkay && !GetLastError(&sError, iErrorCode);
	}
	// return success value
	return bOkay;
}

/*********************************************************************************

	bool CStoredProcedure::FetchRandomArticle(int iSiteID, int iStatus1 = 3, int iStatus2 = -1, int iStatus3 = -1, int iStatus4 = -1, int iStatus5 = -1);

	Author:		Kim Harries
	Created:	29/11/2000
	Inputs:		iStatus1	- status values of the entries to
				iStatus2	  select a random one from
				iStatus3
				iStatus4
				iStatus4
	Outputs:	-
	Returns:	true if successful
	Purpose:	Selects an entry at random from those with the given status and
				returns summary details of it
	Fields:		???

	Note:		Default value of -1 is given to all unspecified statuses except the
				first because this will never be a valid status value.

*********************************************************************************/

bool CStoredProcedure::FetchRandomArticle(int iSiteID, int iStatus1, int iStatus2, int iStatus3, int iStatus4, int iStatus5)
{
	StartStoredProcedure("FetchRandomArticle");
	AddParam("SiteID", iSiteID);
	AddParam("Status1", iStatus1);
	AddParam("Status2", iStatus2);
	AddParam("Status3", iStatus3);
	AddParam("Status4", iStatus4);
	AddParam("Status5", iStatus5);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	return !GetLastError(&sTemp, iErrorCode);
}

/*********************************************************************************

	bool CStoredProcedure::CheckIsSubEditor(int iUserID, int iEntryID);

	Author:		Kim Harries
	Created:	04/12/2000
	Inputs:		iUserID - ID of potential sub editor
				iEntryID - ID of entry to check if they are the subbing
	Outputs:	-
	Returns:	true if successful
	Purpose:	Checks if this user is currently subbing this entry.
	Fields:		???

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::CheckIsSubEditor(int iUserID, int iEntryID)
{
	m_sQuery.Empty();
	m_sQuery << "select\
	CASE WHEN r.RecommendationID > 0 THEN  1\
	else  0 END as IsSub\
	 FROM Users u\
	LEFT JOIN AcceptedRecommendations r ON u.UserID = r.SubEditorID AND r.Status = 2 AND r.EntryID = " << iEntryID
	<< " WHERE u.UserID =" << iUserID;
	m_pDBO->ExecuteQuery(m_sQuery);
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CheckIsSubEditor(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	// if no errors then return the value of the field 'IsSub'
	return GetBoolField("IsSub");
}

#else

bool CStoredProcedure::CheckIsSubEditor(int iUserID, int iEntryID)
{
	StartStoredProcedure("checkissubeditor");
	AddParam("userid", iUserID);
	AddParam("entryid", iEntryID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CheckIsSubEditor(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	// if no errors then return the value of the field 'IsSub'
	return GetBoolField("IsSub");
}

#endif
/*********************************************************************************

	bool CStoredProcedure::FetchUserGroupsList()

	Author:		Kim Harries
	Created:	29/03/2001
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches a list of all the user groups available
	Fields:		???

*********************************************************************************/

bool CStoredProcedure::FetchUserGroupsList()
{
	StartStoredProcedure("FetchUserGroupsList");
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchUserGroupsList(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchScoutStats(int iScoutID)

	Author:		Kim Harries
	Created:	29/03/2001
	Inputs:		iScoutID - scouts user ID
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches some summary stats on this scout
	Fields:		???

*********************************************************************************/

bool CStoredProcedure::FetchScoutStats(int iScoutID)
{
	StartStoredProcedure("FetchScoutStats");
	AddParam("ScoutID", iScoutID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchScoutStats(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchSubEditorStats(int iSubID)

	Author:		Kim Harries
	Created:	29/03/2001
	Inputs:		iSubID - subs user ID
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches some summary stats on this sub
	Fields:		???

*********************************************************************************/

bool CStoredProcedure::FetchSubEditorStats(int iSubID)
{
	StartStoredProcedure("FetchSubEditorStats");
	AddParam("SubID", iSubID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchSubEditorStats(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::DeactivateAccount(int iUserID)
{
	StartStoredProcedure("deactivateaccount");
	AddParam("userid", iUserID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::DeactivateAccount(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::ReactivateAccount(int iUserID)
{
	StartStoredProcedure("ReactivateAccount");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::ReactivateAccount(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::ClearBBCDetails(int iUserID)
{
	StartStoredProcedure("clearusersbbclogindetails");
	AddParam("userid", iUserID);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::ClearBBCDetails(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::UpdateScoutDetails(int iUserID, int iQuota, const TDVCHAR* pcInterval)
{
	CTDVString	sInterval = pcInterval;

	StartStoredProcedure("UpdateScoutDetails");
	AddParam("UserID", iUserID);
	AddParam("Quota", iQuota);
	AddParam("Interval", sInterval);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::UpdateScoutDetails(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::UpdateSubDetails(int iUserID, int iQuota)
{
	StartStoredProcedure("UpdateSubDetails");
	AddParam("UserID", iUserID);
	AddParam("Quota", iQuota);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::UpdateSubDetails(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::FetchScoutRecommendationsList(int iScoutID, const TDVCHAR* pcUnitType, int iNumberOfUnits)
{
	TDVASSERT(pcUnitType != NULL, "CStoredProcedure::FetchScoutRecommendationsList(...) called with NULL pcTimeUnit");
	TDVASSERT(iNumberOfUnits > 0, "CStoredProcedure::FetchScoutRecommendationsList(...) called with non-positive iNumberOfUnits");

	StartStoredProcedure("FetchScoutRecommendationsList");
	AddParam("ScoutID", iScoutID);
	AddParam("UnitType", pcUnitType);
	AddParam("NumberOfUnits", iNumberOfUnits);
	AddParam("siteid", m_SiteID);	// Current viewing site id
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchScoutRecommendationsList(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::FetchSubEditorsAllocationsList(int iSubID, const TDVCHAR* pcUnitType, int iNumberOfUnits)
{
	TDVASSERT(pcUnitType != NULL, "CStoredProcedure::FetchSubEditorsAllocationsList(...) called with NULL pcTimeUnit");
	TDVASSERT(iNumberOfUnits > 0, "CStoredProcedure::FetchSubEditorsAllocationsList(...) called with non-positive iNumberOfUnits");

	StartStoredProcedure("FetchSubEditorsAllocationsList");
	AddParam("SubID", iSubID);
	AddParam("UnitType", pcUnitType);
	AddParam("NumberOfUnits", iNumberOfUnits);
	AddParam("siteid", m_SiteID);	// Current viewing site id
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchSubEditorsAllocationsList(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	return true;
}

bool CStoredProcedure::CreateNewUserGroup(int iUserID, const TDVCHAR* pcNewGroupName)
{
	TDVASSERT(pcNewGroupName != NULL, "CStoredProcedure::CreateNewUserGroup(...) called with NULL pcNewGroupName");

	StartStoredProcedure("createnewusergroup");
	AddParam("userid", iUserID);
	AddParam("groupname", pcNewGroupName);
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CreateNewUserGroup(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::FetchGroupMembershipList(const TDVCHAR* pcGroupName, int iSiteID, int iSystem)
{
	TDVASSERT(pcGroupName != NULL, "CStoredProcedure::FetchGroupMembershipList(...) called with NULL pcGroupName");

	StartStoredProcedure("FetchGroupMembershipList");
	AddParam("GroupName", pcGroupName);
	AddParam("SiteID", iSiteID);
	AddParam("system", iSystem);
	ExecuteStoredProcedure();

	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchGroupMembershipList(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

bool CStoredProcedure::FetchSubNotificationStatus(int* piNumberUnnotified)
{
	TDVASSERT(piNumberUnnotified != NULL, "CStoredProcedure::FetchSubNotificationStatus(...) called with NULL piNumberUnnotified");

	StartStoredProcedure("FetchUnnotifiedSubsTotal");
	ExecuteStoredProcedure();
	// should be no errors, but check just in case
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::FetchSubNotificationStatus(...) : ";
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	// return the value got if we have an output parameter
	if (piNumberUnnotified != NULL)
	{
		*piNumberUnnotified = GetIntField("Total");
	}
	return true;
}


bool CStoredProcedure::Initialise(DBO *pDBO, int iSiteID, CGI* pCGI)
{
	CStoredProcedureBase::Initialise(pDBO, pCGI);

	m_SiteID = iSiteID;

	return true;
}


bool CStoredProcedure::FetchSubbedArticleDetails(int h2g2ID)
{
	StartStoredProcedure("fetchsubbedarticledetails");
	AddParam(h2g2ID);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		return true;
	}
	else
	{
		return false;
	}
}

#ifdef __MYSQL__
bool CStoredProcedure::FetchSiteData(int iSiteID)
{
	CTDVString sQuery = "SELECT @siteid := ";
	if (iSiteID > 0)
	{
		sQuery << iSiteID;
	}
	else
	{
		sQuery << "NULL";
	}
	m_pDBO->ExecuteQuery(sQuery);
	sQuery = "SELECT s.*, p.AgreedTerms, k.SkinName, k.Description as SkinDescription , k.UseFrames\
	FROM Sites s \
	INNER JOIN SiteSkins k ON s.SiteID = k.SiteID\
	INNER JOIN Preferences p ON s.SiteID = p.SiteID AND p.UserID = 0\
	WHERE s.SiteID = @siteid OR @siteid IS NULL\
	ORDER BY s.SiteID";
	m_pDBO->ExecuteQuery(sQuery);
	return true;

}
#else

bool CStoredProcedure::FetchSiteData(int iSiteID)
{
	StartStoredProcedure("fetchsitedata");
	if (iSiteID > 0)
	{
		AddParam(iSiteID);
	}
	ExecuteStoredProcedure();
	return true;
}

#endif

bool CStoredProcedure::GetAcceptedEntries(int iSiteID)
{
	StartStoredProcedure("getacceptedentries");
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	return true;
}
#ifdef __MYSQL__

bool CStoredProcedure::CacheGetArticleListDate(int UserID, int SiteID, CTDVDateTime *oDate)
{
	m_sQuery.Empty();
	if (SiteID = 0)
	{
		m_sQuery << "(select UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(LastUpdated)) as seconds FROM GuideEntries g INNER JOIN Researchers r ON r.EntryID = g.EntryID\
		WHERE (r.UserID = " << UserID << ")\
		)\
		UNION\
		(select UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(LastUpdated)) as seconds FROM GuideEntries g\
		WHERE (g.Editor = " << UserID << ")\
		)\
		order by seconds";
	}
	else
	{
		m_sQuery << "(select UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(LastUpdated)) as seconds FROM GuideEntries g INNER JOIN Researchers r ON r.EntryID = g.EntryID\
		WHERE (r.UserID = " << UserID << ")\
		AND (g.SiteID = " << SiteID << ")\
		)\
		UNION\
		(select UNIX_TIMESTAMP() - UNIX_TIMESTAMP(MAX(LastUpdated)) as seconds FROM GuideEntries g\
		WHERE (g.Editor = " << UserID << ")\
		AND (g.SiteID = " << SiteID << " )\
		)\
		order by seconds";
	}
	m_pDBO->ExecuteQuery(m_sQuery);
	if (!IsEOF())
	{
		*oDate = CTDVDateTime(GetIntField("seconds"));
	}
	return true;
}

#else

bool CStoredProcedure::CacheGetArticleListDate(int UserID, int SiteID, CTDVDateTime *oDate)
{
	StartStoredProcedure("cachegetarticlelistdate");
	AddParam(UserID);
	AddParam(SiteID);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		*oDate = CTDVDateTime(GetIntField("seconds"));
	}
	return true;
}

#endif

bool CStoredProcedure::UserUpdateAgreedTerms(bool bAgreedTerms)
{
	AddParam("AgreedTerms", bAgreedTerms);
	return true;
}

#ifdef __MYSQL__

bool CStoredProcedure::GetKeyArticleList(int iSiteID)
{
	CTDVString sQuery = "SELECT @siteid := ";
	sQuery << iSiteID;
	m_pDBO->ExecuteQuery(sQuery);
	sQuery = "SELECT k.ArticleName, k.EntryID, g.h2g2ID FROM KeyArticles k\
  INNER JOIN GuideEntries g ON k.EntryID = g.EntryID\
\
  LEFT JOIN KeyArticles k1 ON (k1.DateActive <= NOW())\
          AND (k1.DateActive > k.DateActive)\
          AND (k1.ArticleName = k.ArticleName)\
          AND (k1.SiteID = k.SiteID)\
\
  WHERE k.DateActive <= NOW() AND k.SiteID = @siteid \
    AND k.ArticleName <> 'xmlfrontpage' \
    AND k1.ArticleName IS NULL \
  ORDER BY k.ArticleName, k.DateActive DESC";
	
	m_pDBO->ExecuteQuery(sQuery);
	if (IsEOF())
	{
		return false;
	}
	else
	{
		return true;
	}
}

#else

bool CStoredProcedure::GetKeyArticleList(int iSiteID)
{
	StartStoredProcedure("getkeyarticlelist");
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		return true;
	}
}

#endif

bool CStoredProcedure::SetKeyArticle(const TDVCHAR* pArticleName, int h2g2id, int iSiteID, bool bAllowOtherSites, const TDVCHAR* pDate, CTDVString* oError)
{
	StartStoredProcedure("setkeyarticle");
	AddParam(pArticleName);
	AddParam(h2g2id);
	AddParam(iSiteID);
	if (bAllowOtherSites)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	if (pDate[0] != 0)
	{
		AddParam(pDate);
	}
	ExecuteStoredProcedure();
	GetField("Error", *oError);
	return (GetBoolField("Success"));
}

bool CStoredProcedure::StartDeleteKeyArticles(int iSiteID)
{
	StartStoredProcedure("removekeyarticles");
	AddParam(iSiteID);
	return true;
}

bool CStoredProcedure::AddDeleteKeyArticle(const TDVCHAR* pArticleName)
{
	AddParam(pArticleName);
	return true;
}

bool CStoredProcedure::DoDeleteKeyArticles()
{
	ExecuteStoredProcedure();
	return true;
}

#ifdef __MYSQL__
bool CStoredProcedure::GetSiteTopFives(int iSiteID, const TDVCHAR* pGroupName)
{
	CTDVString sQuery = "SET @siteid = ";
	sQuery << iSiteID << ",\
                @groupname = ";
	if (pGroupName != NULL)
	{
		sQuery << "'" << pGroupName << "'";
	}
	else
	{
		sQuery << "NULL";
	}
	m_pDBO->ExecuteQuery(sQuery);
	sQuery = "SELECT  t.GroupName,\
      t.GroupDescription,\
      t.SiteID,\
      f.ForumID,\
      t.ThreadID,\
      CASE WHEN f.Title = ''\
        THEN 'No Subject'\
        WHEN u.UserName IS NOT NULL\
        THEN 'Journal of ' + u.UserName\
        WHEN (th.FirstSubject IS NOT NULL AND th.FirstSubject = '')\
        THEN 'No Subject'\
        WHEN th.FirstSubject IS NOT NULL\
        THEN th.FirstSubject\
        ELSE f.Title\
        END as Title,\
    g.Subject,\
    g.EntryID,\
    g.h2g2ID,\
     CONCAT('A', g.h2g2ID) as ActualID,\
          t.Rank\
    FROM TopFives t\
    LEFT JOIN Forums f ON f.ForumID = t.ForumID\
    LEFT JOIN Users u ON u.Journal = t.ForumID\
    LEFT JOIN GuideEntries g ON g.h2g2ID = t.h2g2ID\
    LEFT JOIN Threads th ON th.ThreadID = t.ThreadID\
    WHERE t.SiteID = @siteid AND (t.GroupName = @groupname OR @groupname IS NULL) ORDER BY GroupName, Rank;";

	m_pDBO->ExecuteQuery(sQuery);
	return (!IsEOF());
}

#else

bool CStoredProcedure::GetSiteTopFives(int iSiteID, const TDVCHAR* pGroupName)
{
//	StartStoredProcedure("gettopfives");
	StartStoredProcedure("gettopfives2");
	AddParam(iSiteID);
	if (pGroupName != NULL)
	{
		AddParam(pGroupName);
	}
	ExecuteStoredProcedure();
	return (!IsEOF());
}

#endif

bool CStoredProcedure::DeleteTopFive(int iSiteID, const TDVCHAR* pGroupName)
{
	StartStoredProcedure("deletetopfive");
    AddParam("groupname",pGroupName);
	AddParam("siteid",iSiteID);
	return ExecuteStoredProcedure();

}

bool CStoredProcedure::GetSiteListOfLists(int iSiteID, CTDVString* oResult)
{
	StartStoredProcedure("getsitelistoflists");
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	*oResult = "<TOP-FIVE-LISTS>";
	while (!IsEOF())
	{
		CTDVString sName;
		CTDVString sType;
		GetField("GroupName", sName);
		GetField("Type", sType);
		*oResult << "<LIST><GROUPNAME>" << sName << "</GROUPNAME><TYPE>" << sType << "</TYPE></LIST>";
		MoveNext();
	}
	*oResult << "</TOP-FIVE-LISTS>";
	return true;
}

bool CStoredProcedure::StartSetTopFiveArticleList(int iSiteID, const TDVCHAR* pGroupName, const TDVCHAR* pGroupDescription)
{
	StartStoredProcedure("settopfivelist");
	AddParam(iSiteID);
	AddParam(pGroupName);
	AddParam(pGroupDescription);
	return true;
}

bool CStoredProcedure::StartSetTopFiveForumList(int iSiteID, const TDVCHAR* pGroupName, const TDVCHAR* pGroupDescription)
{
	StartStoredProcedure("settopfiveforumlist");
	AddParam(iSiteID);
	AddParam(pGroupName);
	AddParam(pGroupDescription);
	return true;
}

bool CStoredProcedure::AddArticleTopFiveID(int ih2g2ID )
{
	AddParam(ih2g2ID);
	return true;
}

bool CStoredProcedure::AddTopFiveID(int ih2g2ID, int iThreadID)
{
	AddParam(ih2g2ID);
	if (iThreadID <= 0)
	{
		AddNullParam();
	}
	else
	{
		AddParam(iThreadID);
	}
	return true;
}

bool CStoredProcedure::DoSetTopFive()
{
	ExecuteStoredProcedure();
	return true;
}

int CStoredProcedure::UpdateSiteDetails(int iSiteID, const TDVCHAR* pShortName, const TDVCHAR* pSSOService,
	const TDVCHAR* pDescription, const TDVCHAR* pDefaultSkin, const TDVCHAR* pSkinSet, bool premoderation, 
	bool noautoswitch, bool customterms, CTDVString* oError, 
	const TDVCHAR* pcModeratorsEmail, const TDVCHAR* pcEditorsEmail,
	const TDVCHAR* pcFeedbackEmail, int iAutoMessageUserID, bool bPassworded, bool bUnmoderated,
	bool bArticleGuestBookForums, const int iThreadOrder, const int iThreadEditTimeLimit,
	const TDVCHAR* psEventEmailSubject, int iEventAlertMessageUserID, int iAllowRemoveVote, int iIncludeCrumbtrail, 
	int iAllowPostCodesInSearch, bool bQueuePostings, int iTopicClosed)
{
	StartStoredProcedure("updatesitedetails");
	AddParam(iSiteID);
	AddParam(pShortName);
	AddParam(pDescription);
	AddParam(pDefaultSkin);
    AddParam(pSkinSet);
	AddParam(premoderation);
	AddParam(noautoswitch);
	AddParam(customterms);
	AddParam(pcModeratorsEmail);
	AddParam(pcEditorsEmail);
	AddParam(pcFeedbackEmail);
	AddParam(iAutoMessageUserID);
	if (bPassworded)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	if (bUnmoderated)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	if (bArticleGuestBookForums)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	AddParam(iThreadOrder);
	AddParam(iThreadEditTimeLimit);
	AddParam(psEventEmailSubject);
	AddParam(iEventAlertMessageUserID);
	AddParam(iAllowRemoveVote);
	AddParam(iIncludeCrumbtrail);
	AddParam(iAllowPostCodesInSearch);

	if (bQueuePostings)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}

	//SSOService will default to URLName if not specified.
	if ( pSSOService && strlen(pSSOService) > 0 )
	{
		AddParam(pSSOService);
	}
	else
	{
		AddNullParam();
	}

	AddParam(iTopicClosed);

	ExecuteStoredProcedure();
	int iResult = GetIntField("Result");
	if (iResult > 0)
	{
		GetField("Error", *oError);
	}
	return iResult;
}

bool CStoredProcedure::UpdateSiteConfig(int iSiteID, const TDVCHAR* pConfig)
{
	if (iSiteID <=0 || pConfig == NULL)
	{
		return false;
	}

	StartStoredProcedure("updatesiteconfig");
	AddParam("siteid",iSiteID);
	AddParam("config",pConfig);
	ExecuteStoredProcedure();

	if (HandleError("UpdateSiteConfig"))
	{
		return false;
	}

	return true;
}


bool CStoredProcedure::UpdateSkinDescription(int iSiteID, const TDVCHAR* pName, const TDVCHAR* pDescription, int iUseFrames)
{
	StartStoredProcedure("updateskindescription");
	AddParam(iSiteID);
	AddParam(pName);
	AddParam(pDescription);
	AddParam(iUseFrames);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::UpdateFrontpage(int iSiteID, const TDVCHAR* pSubject, const TDVCHAR* pBody, int iUserID, const TDVCHAR* pDate, const TDVCHAR* psExtraInfo)
{
	CExtraInfo ExtraInfo;
	ExtraInfo.Create(CGuideEntry::TYPEARTICLE);

	CTDVString sExtra;
	ExtraInfo.GetInfoAsXML(sExtra);

	StartStoredProcedure("createguideentry");

	AddParam(pSubject);
	AddParam(pBody);
	AddParam(sExtra);
	AddParam(iUserID);
	AddParam(1);
	AddParam(10);
	AddParam(1);
	AddNullParam();
	AddNullParam();
	AddParam(iSiteID);
	AddParam(0);

	// MarkH 10/11/03 - Create a hash value for this entry. This enables us to check to see if we've
	//					already submitted any duplicates
	CTDVString sHash;
	CTDVString sSource;
	sSource << pSubject << "<:>" << pBody << "<:>" << iUserID << "<:>" << iSiteID << "<:>" << pDate;
	GenerateHash(sSource, sHash);

	// Add the UID to the param list
	if (!AddUIDParam(sHash))
	{
		return false;
	}

	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::UpdateFrontPage"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	StartStoredProcedure("storekeyarticle");

	int iNewID = GetIntField("EntryID");
	CTDVString name("xmlfrontpage");
	AddParam(name);
	AddParam(iNewID);
	if (strlen(pDate) > 0)
	{
		CTDVDateTime dDate;
		dDate.ParseDateTime(pDate);
		AddParam(dDate);
	}
	else
	{
		AddNullParam();
	}
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::UpdateFrontPage"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	return true;
}

bool CStoredProcedure::UpdateFrontpagePreview(int iSiteID, const TDVCHAR* pBody, int iUserID, const TDVCHAR* pEditKey, CExtraInfo& ExtraInfo)
{
	CTDVString sExtra;
	ExtraInfo.GetInfoAsXML(sExtra);

	StartStoredProcedure("UpdateFrontPagePreview");
	AddParam("bodytext",pBody);
	AddParam("siteid",iSiteID);
	AddParam("editor",iUserID);
	AddParam("extrainfo",sExtra);
	// This could be an empty string and that's no good to 
	// pass in to the SP. This should handle both cases
	if (!CTDVString(pEditKey).IsEmpty())
	{
		AddParam("editkey",pEditKey);
	}

	ExecuteStoredProcedure();
	if (HandleError("UpdateFrontpagePreview"))
	{
		return false;
	}
	return true;
}

#ifdef __MYSQL__

bool CStoredProcedure::GetArticleCrumbTrail(int ih2g2ID)
{
	CTDVString sQuery;
	sQuery << "(  SELECT  a.NodeID as MainNode, a.AncestorID as NodeID, h.TreeLevel as TreeLevel, h.DisplayName as DisplayName\
    FROM Ancestors a\
    INNER JOIN Hierarchy h\
      ON a.AncestorID = h.NodeID\
    INNER JOIN hierarchyarticlemembers h1 ON a.NodeID = h1.NodeID\
  WHERE h1.h2g2id = " << ih2g2ID << ")\
UNION\
(\
  SELECT h.NodeID, h.NodeID, h.TreeLevel, h.DisplayName\
    FROM Hierarchy h\
    INNER JOIN hierarchyarticlemembers h1 ON h.NodeID = h1.NodeID\
  WHERE h1.h2g2id = " << ih2g2ID << "\
)\
  ORDER BY MainNode, TreeLevel";
	m_pDBO->ExecuteQuery(sQuery);
	return (!IsEOF());
}

#else

bool CStoredProcedure::GetArticleCrumbTrail(int ih2g2ID)
{
	StartStoredProcedure("getarticlecrumbtrail");
	AddParam(ih2g2ID);
	ExecuteStoredProcedure();
	return (!IsEOF());
}

#endif

bool CStoredProcedure::GetUserCrumbTrail(int iUserID)
{
	StartStoredProcedure("getusercrumbtrail");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return (!IsEOF());
}

bool CStoredProcedure::CreateNewSite(const TDVCHAR *pURLName, const TDVCHAR *pShortName, const TDVCHAR* pSSOService,
	const TDVCHAR *pDescription, const TDVCHAR *pDefaultSkin, 
	const TDVCHAR *pSkinDescription, const TDVCHAR* pSkinSet, bool bUseFrames, int iPreModeration, 
	int iNoAutoSwitch, int iCustomTerms, const TDVCHAR* pcModeratorsEmail, 
	const TDVCHAR* pcEditorsEmail, const TDVCHAR* pcFeedbackEmail,int iAutoMessageUserID, bool bPassworded,
	bool bUnmoderated, bool bArticleGuestBookForums, const int iThreadOrder, const int iThreadEditTimeLimit,
	const TDVCHAR* psEventEmailSubject, int iEventAlertMessageUserID, int iIncludeCrumbtrail, int iAllowPostCodesInSearch)
{
	StartStoredProcedure("createnewsite");
	AddParam(pURLName);
	AddParam(pShortName);
	AddParam(pDescription);
	AddParam(pDefaultSkin);
	AddParam(pSkinDescription);
    AddParam(pSkinSet);
	if (bUseFrames)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	AddParam(iPreModeration);
	AddParam(iNoAutoSwitch);
	AddParam(iCustomTerms);
	AddParam(pcModeratorsEmail);
	AddParam(pcEditorsEmail);
	AddParam(pcFeedbackEmail);
	AddParam(iAutoMessageUserID);
	if (bPassworded)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}

	if (bUnmoderated)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}

	if (bArticleGuestBookForums)
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	AddParam(iThreadOrder);
	AddParam(iThreadEditTimeLimit);
	AddParam(psEventEmailSubject);
	AddParam(iEventAlertMessageUserID);
	AddParam(iIncludeCrumbtrail);
	AddParam(iAllowPostCodesInSearch);
	
	//SSOService will default to URLName if not specified.
	if ( pSSOService && strlen(pSSOService) > 0 )
	{
		AddParam(pSSOService);
	}

	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		return (GetIntField("SiteID") > 0);
	}
	else
	{
		return false;
	}
}

bool CStoredProcedure::AddSkinToSite(int SiteID, const TDVCHAR *pSkinName, const TDVCHAR *pSkinDescription, int iUseFrames)
{
	StartStoredProcedure("addskintosite");
	AddParam(SiteID);
	AddParam(pSkinName);
	AddParam(pSkinDescription);
	AddParam(iUseFrames);
	ExecuteStoredProcedure();
	if (!IsEOF())
	{
		int result = GetIntField("Result");
		return (result == 0);
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::FetchUserStatistics(int iUserID, int iDisplayMode, CTDVDateTime dtStartDate, CTDVDateTime dtEndDate)

	Author:		Igor Loboda
	Created:	21/01/2002
	Inputs:		iUserID - user ID
				dtStartDate  - start date of search
				dtEndDate - end date of search
	Outputs:	-
	Returns:	true if successful, false if not
	Fields:		-

	Purpose:	Fetches user statistics: which posts where made to which forums under
				which threads

*********************************************************************************/

bool CStoredProcedure::FetchUserStatistics(int iUserID, int iDisplayMode, CTDVDateTime dtStartDate, CTDVDateTime dtEndDate, int& iRecordsCount)
{
	StartStoredProcedure("FetchUserStatistics");
	AddParam("UserID", iUserID);
	AddParam("Mode", iDisplayMode);
	AddParam("startdate", dtStartDate);
	AddParam("enddate", dtEndDate);
	AddOutputParam("recordscount", &iRecordsCount);
	ExecuteStoredProcedure();
	return !IsEOF();
}

bool CStoredProcedure::CacheGetHierarchyMostRecentUpdateTime(CTDVDateTime *oDate)
{
	StartStoredProcedure("cachegethierarchymostrecentupdatetime");
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		int NumSeconds = GetIntField("DatePosted");
		*oDate = CTDVDateTime(NumSeconds);
		CTDVString sRes;
		oDate->GetAsXML(sRes);
		return true;
	} 
}

/*********************************************************************************

	bool CStoredProcedure::CacheGetFreshestUserPostingDate(int iUserID, CTDVDateTime *oDate)

	Author:		Igor Loboda
	Created:	21/01/2002
	Inputs:		iUserID - ID of user
	Outputs:	oDate - ptr to date to receive the date of the most recent post
	Returns:	true if info found, false otherwise
	Purpose:	Used for caching. Gets the date of the last post made by specified 
				user, allowing the cache to work out if they're	dirty or not.

*********************************************************************************/

bool CStoredProcedure::CacheGetFreshestUserPostingDate(int iUserID, CTDVDateTime *oDate)
{
	StartStoredProcedure("cachegetfreshestuserpostingdate");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oDate = CTDVDateTime(GetIntField("seconds"));
		return true;
	}
}

/*********************************************************************************

	bool CStoredProcedure::GetQueuedModPerSite(int iUserID)

	Author:		Igor Loboda
	Created:	15/02/2002
	Inputs:		iUserID - ID of user
	Outputs:	-
	Returns:	true if info found, false otherwise
	Purpose:	Fetches the number of queued moderation items and complains for each site
				for given users

*********************************************************************************/

bool CStoredProcedure::GetQueuedModPerSite(int iUserID)
{
	StartStoredProcedure("GetQueuedModPerSite");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	if (HandleError("GetQueuedModPerSite"))
	{
		return false;
	}
	else
	{
		return true;
	}
}

/*********************************************************************************

	bool CStoredProcedure::GetArticleModDetailsFromModID(int iModID)

	Author:		Dharmesh Raithatha
	Created:	2/20/02
	Inputs:		iModID - article modid
	Outputs:	-
	Returns:	true if there was a row obtained from the ArticleMod table
	Purpose:	returns the entire row from article mod based on the modid

*********************************************************************************/

bool CStoredProcedure::GetArticleModDetailsFromModID(int iModID)
{
	StartStoredProcedure("GetArticleModDetailsFromModID");
	AddParam("ModID",iModID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetThreadModDetailsFromModID(int iModID)

	Author:		Dharmesh Raithatha
	Created:	2/20/02
	Inputs:		iModID - article modid
	Outputs:	-
	Returns:	true if there was a row obtained from the ThreadMod table
	Purpose:	returns the entire row from threadmod based on the modid

*********************************************************************************/

bool CStoredProcedure::GetThreadModDetailsFromModID(int iModID)
{
	StartStoredProcedure("GetThreadModDetailsFromModID");
	AddParam("ModID",iModID);
	ExecuteStoredProcedure();
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetModerationBilling(const TDVCHAR* pStart, const TDVCHAR* pEnd, int ForceRecalc)

	Author:		Jim Lynn
	Created:	22/02/2002
	Inputs:		pStart, pEnd - start and end date over which to collect billing information
				ForceRecalc - 1 to force the SP to recalculate, 0 to get any available
					cached information
	Outputs:	-
	Returns:	true
	Purpose:	Fetches moderation billing information on a per-site basis between the
				two dates given (upper date is exclusive).

*********************************************************************************/

bool CStoredProcedure::GetModerationBilling(const TDVCHAR* pStart, const TDVCHAR* pEnd, int ForceRecalc)
{
	StartStoredProcedure("getmoderationbilling");
	AddParam(pStart);
	AddParam(pEnd);
	AddParam(ForceRecalc);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetModerationPosts
	Author:		Martin Robb
	Created:	29/11/2005
	Inputs:		-	Viewing User ID
					Viewing User SuperUser Status 
					Alerts - fetch alerts only.
					HeldItems - fetch Held Items only.
					Locked Items - fetch Locked Items. ( Not a status / may be combined with status ).
					ModClassId - Filter - fetch posts for sites with specified modclassid 
	Outputs:	-
	Returns:	true
	Purpose:	Fetches Posts for Moderation.

*********************************************************************************/
bool CStoredProcedure::GetModerationPosts( int iUserId, bool bIsSuperUser, bool bAlerts, bool bReferrals, bool bHeldItems, bool bLockedItems, int iModClassId, int iPostId, bool bDuplicateComplaints, int iShow, bool bFastMod )
{
		StartStoredProcedure("getmoderationposts");
		if ( bHeldItems )
			AddParam("Status",CModeratePosts::MODERATEPOSTS_HOLD);
		else if ( bReferrals )
			AddParam("Status", CModeratePosts::MODERATEPOSTS_REFER);
		AddParam("UserId", iUserId);
		AddParam("Alerts",bAlerts);
		AddParam("LockedItems",bLockedItems);
		AddParam("IsSuperUser", bIsSuperUser );
		if ( iModClassId > 0 )
			AddParam("modclassid", iModClassId );
		if ( iPostId > 0 ) 
			AddParam("PostId", iPostId);
		if ( bDuplicateComplaints )
			AddParam("DuplicateComplaints", bDuplicateComplaints);
		AddParam("show",iShow);
		AddParam("fastmod", bFastMod);
		return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::GetModerationMediaAssets
	Author:		Martin Robb
	Created:	19/12/2005
	Inputs:		-	Viewing User ID
					Viewing User SuperUser Status 
					Alerts - fetch alerts only.
					HeldItems - fetch Held Items only.
					Locked Items - fetch Locked Items. ( Not a status / may be combined with status ).
	Outputs:	-
	Returns:	true
	Purpose:	Fetches Media Assets for moderation.

*********************************************************************************/
bool CStoredProcedure::GetModerationMediaAssets( int iUserId, bool bIsSuperUser, bool bAlerts, bool bReferrals, bool bHeldItems, bool bLockedItems )
{

	StartStoredProcedure("getmoderationmediaassets");
	if ( bHeldItems )
		AddParam("Status",CModeratePosts::MODERATEPOSTS_HOLD);
	else if ( bReferrals )
		AddParam("Status", CModeratePosts::MODERATEPOSTS_REFER);
	AddParam("UserId", iUserId);
	AddParam("Alerts",bAlerts);
	AddParam("LockedItems",bLockedItems);
	AddParam("IsSuperUser", bIsSuperUser );
	ExecuteStoredProcedure();
	return !HandleError("getmoderationmediaassets");
}

/*********************************************************************************

	bool CStoredProcedure::GetModerationArticles
	Author:		Martin Robb
	Created:	22/05/2006
	Inputs:		-	Viewing User ID
					Viewing User SuperUser Status 
					Alerts - fetch alerts only.
					HeldItems - fetch Held Items only.
					Locked Items - fetch Locked Items. ( Not a status / may be combined with status ).
	Outputs:	-
	Returns:	true
	Purpose:	Fetches NickNames for Moderation.

*********************************************************************************/
bool CStoredProcedure::GetModerationArticles(int iUserId, bool bIsSuperUser, bool bAlerts, bool bReferrals, bool bLockedItems, int iModClassId )
{
	StartStoredProcedure("getmoderationarticles");
	AddParam("userid", iUserId);

	if ( bReferrals )
		AddParam("Status", CModeratePosts::MODERATEPOSTS_REFER);

	AddParam("alerts", bAlerts);
	AddParam("lockeditems", bLockedItems);
	AddParam("issuperuser", bIsSuperUser);
	
	if ( iModClassId > 0 )
		AddParam("modclassid", iModClassId);

	ExecuteStoredProcedure();
	return !HandleError("getmoderationarticles");

}

/*********************************************************************************

	bool CStoredProcedure::GetModerationNickNames
	Author:		Martin Robb
	Created:	29/11/2005
	Inputs:		-	Viewing User ID
					Viewing User SuperUser Status 
					Alerts - fetch alerts only.
					HeldItems - fetch Held Items only.
					Locked Items - fetch Locked Items. ( Not a status / may be combined with status ).
	Outputs:	-
	Returns:	true
	Purpose:	Fetches NickNames for Moderation.

*********************************************************************************/
bool CStoredProcedure::GetModerationNickNames( int iUserID, bool bIsSuperUser, bool bAlerts, bool bHeldItems, bool bLockedItems, int iModClassId, int iShow )
{
	StartStoredProcedure("getModerationNicknames");
	AddParam("UserId", iUserID);
	if ( bHeldItems )
		AddParam("Status",CModeratePosts::MODERATEPOSTS_HOLD);
	AddParam("Alerts",bAlerts);
	AddParam("LockedItems",bLockedItems);
	AddParam("IsSuperUser", bIsSuperUser);
	if ( iModClassId > 0 )
		AddParam("modclassid", iModClassId );
	AddParam("Show", iShow);

	
	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::FetchRefereeList()

	Author:		Igor Loboda
	Created:	27/02/2002
	Inputs:		-
	Outputs:	-
	Returns:	true
	Purpose:	Fetches the list of all referees for all sites

*********************************************************************************/
bool CStoredProcedure::FetchRefereeList()
{
	StartStoredProcedure("FetchRefereeList");
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsRefereeForAnySite(bool& isReferee)

	Author:		Igor Loboda
	Created:	28/02/2002
	Inputs:		iUserID - user ID
	Outputs:	isReferee - true if given user is Referee for at least one site
	Returns:	true
	Purpose:	checks whether specified user is Referee for at least one site

*********************************************************************************/
bool CStoredProcedure::IsRefereeForAnySite(int iUserID, bool& bIsReferee)
{
	StartStoredProcedure("IsRefereeForAnySite");
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	int nOfSites = GetIntField("NumberOfSites");
	bIsReferee = (nOfSites != 0);

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetModeratorsForSite(int iSiteID)

	Author:		Dharmesh Raithatha
	Created:	2/28/02
	Inputs:		iSiteID - the site you are interested in
	Outputs:	-
	Returns:	true if information was found, false otherwise
	Purpose:	Given a siteID it returns the moderators for that site and all
				the sites that they are registered to.

*********************************************************************************/

bool CStoredProcedure::GetModeratorsForSite(int iSiteID)
{
	StartStoredProcedure("GetModeratorsForSite");
	AddParam("SiteID", iSiteID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::RemoveFromResearcherList(int EntryID, int iUserID)

	Author:		Igor Loboda
	Created:	05/03/2002
	Inputs:		ih2g2ID - guide entry h2g2id 
				iUserID - user ID
	Outputs:	isReferee - true if given user is Referee for at least one site
	Returns:	true
	Purpose:	checks whether specified user is Referee for at least one site

*********************************************************************************/
bool CStoredProcedure::RemoveFromResearcherList(int ih2g2ID, int iUserID)
{
	StartStoredProcedure("RemoveFromResearcherList");
	AddParam("h2g2ID", ih2g2ID);
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();
	int removed = GetIntField("Removed");
	return (removed > 0);
}

/*********************************************************************************

	bool CStoredProcedure::MoveArticleToSite(int ih2g2ID, int iSiteID)

	Author:		Igor Loboda
	Created:	28/03/2002
	Inputs:		ih2g2ID - guide entry h2g2id 
				iSiteID - target site ID
	Outputs:	-
	Returns:	true on success
	Purpose:	moves specified article along with it's forums to specified site

*********************************************************************************/
bool CStoredProcedure::MoveArticleToSite(int ih2g2ID, int iSiteID)
{
	StartStoredProcedure("MoveArticleToSite");
	AddParam("h2g2ID", ih2g2ID);
	AddParam("newSiteID", iSiteID);
	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::MoveForumToSite(int iForumID, int iSiteID)

	Author:		Igor Loboda
	Created:	11/04/2002
	Inputs:		iForumID - ID of the forum to move
				iSiteID - target site ID
	Outputs:	-
	Returns:	true on success
	Purpose:	moves specified forum to specified site

*********************************************************************************/
bool CStoredProcedure::MoveForumToSite(int iForumID, int iSiteID)
{
	StartStoredProcedure("MoveForumToSite");
	AddParam("ForumID", iForumID);
	AddParam("NewSiteID", iSiteID);
	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::ForceUpdateArticle(int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	10/05/2002
	Inputs:		iH2G2ID - ID of the entry to update
	Outputs:	-
	Returns:	true on success
	Purpose:	Sets the lastupdated field of the entry to the current time 
				so that the cache will be invalid

*********************************************************************************/
bool CStoredProcedure::ForceUpdateEntry(int iH2G2ID)
{
	StartStoredProcedure("ForceUpdateEntry");
	AddParam("H2G2ID", iH2G2ID);	
	return ExecuteStoredProcedure();
}

/*********************************************************************************

	bool CStoredProcedure::FetchWatchedJournals(int iUserID)

	Author:		Jim Lynn
	Created:	19/09/2002
	Inputs:		iUserID - ID of the user whose list of watched journals we want
	Outputs:	-
	Returns:	true if successful
	Purpose:	Fetches a list of all the users whose journals the current user
				is watching. This gives us a quick and easy 'friends' list for
				homepages.

*********************************************************************************/
#ifdef __MYSQL__

bool CStoredProcedure::FetchWatchedJournals(int iUserID)
{
	m_sQuery.Empty();
	m_sQuery << "select fo.*,u.* FROM FaveForums f\
  INNER JOIN Forums fo ON fo.ForumID = f.ForumID\
  INNER JOIN Users u ON fo.JournalOwner = u.UserID\
	WHERE f.UserID = " << iUserID << "\
	ORDER BY u.UserName";
	return m_pDBO->ExecuteQuery(m_sQuery);
}

#else

bool CStoredProcedure::FetchWatchedJournals(int iUserID)
{
	StartStoredProcedure("fetchwatchedjournals");
	AddParam(iUserID);
	return ExecuteStoredProcedure();
}

#endif
/*
bool CStoredProcedure::AddFriend(int iUserID, int iFriendID, int iSiteID)
{
	StartStoredProcedure("addfriend");
	AddParam(iUserID);
	AddParam(iFriendID);
	AddParam(iSiteID);
	return ExecuteStoredProcedure();
}

bool CStoredProcedure::AddInterest(int iUserID, int iSiteID, const TDVCHAR *pInterest)
{
	StartStoredProcedure("addinterest");
	AddParam(iUserID);
	AddParam(iSiteID);
	AddParam(pInterest);
	return ExecuteStoredProcedure();
}

bool CStoredProcedure::FetchInterestList(int iUserID)
{
	StartStoredProcedure("fetchinterestlist");
	AddParam(iUserID);
	return ExecuteStoredProcedure();
}
*/

bool CStoredProcedure::WatchUserJournal(int iUserID, int iWatchedUserID, int iSiteID)
{
	if (iSiteID <= 0)
	{
		return false;
	}
	StartStoredProcedure("watchuserjournal");
	AddParam(iUserID);
	AddParam(iWatchedUserID);
	AddParam(iSiteID);
	return ExecuteStoredProcedure();
}

bool CStoredProcedure::StopWatchingUserJournal(int iUserID, int iWatchedUserID)
{
	StartStoredProcedure("stopwatchinguserjournal");
	AddParam(iUserID);
	AddParam(iWatchedUserID);
	AddParam("currentsiteid", m_SiteID);
	return ExecuteStoredProcedure();
}

bool CStoredProcedure::StartDeleteWatchUser(int iUserID)
{
	StartStoredProcedure("deletewatchedusers");
	AddParam(iUserID);
	AddParam("currentsiteid", m_SiteID);
	return true;
}

bool CStoredProcedure::AddDeleteWatchUser(int iWatchedUserID)
{
	AddParam(iWatchedUserID);
	return true;
}

bool CStoredProcedure::DoDeleteWatchUsers()
{
	return ExecuteStoredProcedure();
}

bool CStoredProcedure::FetchWatchedJournalPosts(int iUserID)
{
	StartStoredProcedure("fetchwatchedjournalposts");
	AddParam(iUserID);
	AddParam("currentsiteid", m_SiteID);
	return ExecuteStoredProcedure();
}

bool CStoredProcedure::UserUpdatePrefXML(const TDVCHAR *pXML)
{
	AddParam("PrefXML", pXML);
	return true;
}
#ifdef __MYSQL__

bool CStoredProcedure::FetchWatchingUsers(int iUserID)
{
	m_sQuery.Empty();
	m_sQuery << "select u.*, fo.ForumID, fo.SiteID\
  FROM Users u1\
  INNER JOIN FaveForums f ON f.ForumID = u1.Journal\
  INNER JOIN Users u ON f.UserID = u.UserID\
  INNER JOIN Forums fo ON fo.ForumID = u.Journal\
	WHERE u1.UserID = " << iUserID;
	return m_pDBO->ExecuteQuery(m_sQuery);
}

#else

bool CStoredProcedure::FetchWatchingUsers(int iUserID, int iSiteID)
{
	StartStoredProcedure("watchingusers");
	AddParam(iUserID);
	AddParam(iSiteID);
	return ExecuteStoredProcedure();
}

#endif
int CStoredProcedure::GetFirstNewPostInThread(int iThreadID, CTDVDateTime dTime)
{
	StartStoredProcedure("getindexoffirstnewpost");
	AddParam(iThreadID);
	AddParam(dTime);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return 0;
	}
	else
	{
		return GetIntField("Index");
	}
}

bool CStoredProcedure::LoginLocalUser(const char *pLoginName, const char *pPassword, int* oUserID, CTDVString *oUserName, CTDVString *oCookie, CTDVString *oBBCUID)
{
	if (oUserName == NULL || oCookie == NULL || oBBCUID == NULL)
	{
		return false;
	}
	StartStoredProcedure("loginlocaluser");
	AddParam(pLoginName);
	AddParam(pPassword);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oUserID = GetIntField("UserID");
		GetField("UserName", *oUserName);
		GetField("Cookie", *oCookie);
		GetField("BBCUID", *oBBCUID);
		return true;
	}
}

bool CStoredProcedure::RegisterLocalUser(const TDVCHAR *pLoginName, const TDVCHAR *pPassword, const TDVCHAR *pEmail, int *oErrorCode, int *oUserID, CTDVString *oCookie, CTDVString *oBBCUID)
{
	if (oErrorCode == NULL || oUserID == NULL || oCookie == NULL || oBBCUID == NULL)
	{
		return false;
	}
	StartStoredProcedure("RegisterLocalUser");
	AddParam(pLoginName);
	AddParam(pPassword);
	AddParam(pEmail);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		*oErrorCode = GetIntField("ErrorCode");
		if ((*oErrorCode) > 0)
		{
			return true;
		}
		else
		{
			*oUserID = GetIntField("UserID");
			GetField("Cookie", *oCookie);
			GetField("BBCUID", *oBBCUID);
			return true;
		}
	}
}

bool CStoredProcedure::UpdateLocalPassword(const TDVCHAR *pLoginName, const TDVCHAR *pPassword, const TDVCHAR *pNewPassword)
{
	StartStoredProcedure("updatelocalpassword");
	AddParam(pLoginName);
	AddParam(pPassword);
	AddParam(pNewPassword);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetForumPermissions(int iUserID, int iForumID, bool &oCanRead, bool &oCanWrite)
{
	int canRead = 0;
	int canWrite = 0;

	StartStoredProcedure("getforumpermissions");
	AddParam(iUserID);
	AddParam(iForumID);
	AddOutputParam("canread",&canRead);
	AddOutputParam("canwrite",&canWrite);
	ExecuteStoredProcedure();

	//Ouput Parameters are available when resultset processed.
	while ( !IsEOF() )
	{
		MoveNext();
	}

	oCanRead = (canRead != 0 );
	oCanWrite = (canWrite != 0 );
	return true;
}

bool CStoredProcedure::GetThreadPermissions(int iUserID, int iThreadID, bool &oCanRead, bool &oCanWrite)
{
	StartStoredProcedure("getthreadpermissions");
	AddParam(iUserID);
	AddParam(iThreadID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		oCanRead = GetBoolField("CanRead");
		oCanWrite = GetBoolField("CanWrite");
		return true;
	}
}

bool CStoredProcedure::UpdateForumPermissions(int iForumID, bool bChangeRead, int iRead, bool bChangeWrite, int iWrite, bool bChangeThreadRead, int iThreadRead, bool bChangeThreadWrite, int iThreadWrite)
{
	StartStoredProcedure("updateforumpermissions");
	AddParam(iForumID);
	if (bChangeRead)
	{
		AddParam(iRead);
	}
	else
	{
		AddNullParam();
	}
	if (bChangeWrite)
	{
		AddParam(iWrite);
	}
	else
	{
		AddNullParam();
	}
	if (bChangeThreadRead)
	{
		AddParam(iThreadRead);
	}
	else
	{
		AddNullParam();
	}
	if (bChangeThreadWrite)
	{
		AddParam(iThreadWrite);
	}
	else
	{
		AddNullParam();
	}
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GenerateHash(const TDVCHAR* pContent, CTDVString& oResult)
{
/*
	CryptoPP::MD5 md5;

	const char *hex = "0123456789abcdef";
	char *r, result[33];
	int i;
	byte digest[16];
	memset(digest,0,16);
	md5.CalculateDigest(digest, (byte*)pContent, strlen(pContent));
	for (i = 0, r = result; i < 16; i++) 
	{
		*r++ = hex[digest[i] >> 4];
		*r++ = hex[digest[i] & 0xF];
	}
	*r = '\0';
	oResult = result;
	return true;
*/

//	CryptoPP::MD5 md5;

	const char *hex = "0123456789abcdef";
	char *r, result[33];
	int i;
	byte digest[16];
	memset(digest,0,16);
	md5_buffer(pContent, strlen(pContent), digest);
	for (i = 0, r = result; i < 16; i++) 
	{
		*r++ = hex[digest[i] >> 4];
		*r++ = hex[digest[i] & 0xF];
	}
	*r = '\0';
	oResult = result;
	return true;
}

/*********************************************************************************

	Author:		Nick Stevenson
	Created:	16/07/2003
	Inputs:		- iTeamID team id value, iClub ref to integer, iMember ref to integer, 
				ref to integer iOwner, bSuccess boolean flag to indicating successful query
	Outputs:	- iClub, iMember, iOwner, bSuccess -true if query completes
	Returns:	- true or false according to whether or not there's a fatal error.
	Purpose:	- Calls procedure in DB and extracts values returned by the query

*********************************************************************************/

bool CStoredProcedure::GetClubIDAndClubTeamsForTeamID(int iTeamID, int& iClub, int& iMember, int& iOwner, bool& bSuccess )
{
	StartStoredProcedure("getclubidandclubteamsforteamid");
	AddParam(iTeamID);
	ExecuteStoredProcedure();

	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetClubIDAndClubTeamsForTeamID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	

	iClub	= GetIntField("ClubID");
	iOwner	= GetIntField("OwnerTeam");
	iMember	= GetIntField("MemberTeam");

	bSuccess = !IsEOF();

	return true;	
}

bool CStoredProcedure::GetClubPermissions(int iUserID, int iClubID, bool &oCanAutoJoinMember, bool &oCanAutoJoinOwner, bool &oCanBecomeMember, bool &oCanBecomeOwner, bool &oCanApproveMembers, bool &oCanApproveOwners, bool &oCanDemoteOwners, bool &oCanDemoteMembers, bool &oCanViewActions, bool &oCanView, bool &oCanEdit)
{
	StartStoredProcedure("getclubpermissions");
	AddParam(iUserID);
	AddParam(iClubID);
	ExecuteStoredProcedure();
	if (IsEOF())
	{
		return false;
	}
	else
	{
		oCanAutoJoinMember = GetBoolField("fCanAutoJoinMember");
		oCanAutoJoinOwner = GetBoolField("fCanAutoJoinOwner");
		oCanBecomeMember = GetBoolField("fCanBecomeMember");
		oCanBecomeOwner = GetBoolField("fCanBecomeOwner");
		oCanApproveMembers = GetBoolField("fCanApproveMembers");
		oCanApproveOwners = GetBoolField("fCanApproveOwners");
		oCanDemoteMembers = GetBoolField("fCanDemoteMembers");
		oCanDemoteOwners = GetBoolField("fCanDemoteOwners");
		oCanViewActions = GetBoolField("fCanViewActions");
		oCanView = GetBoolField("fCanView");
		oCanEdit = GetBoolField("fCanEdit");
		return true;
	}
}

bool CStoredProcedure::PerformClubAction(int iClubID, int iUserID, int iActionUserID, int iActionType, const int iSiteID)
{
	StartStoredProcedure("performclubaction");
	AddParam(iClubID);
	AddParam(iUserID);
	AddParam(iActionUserID);
	AddParam(iActionType);
	AddParam(iSiteID);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::CompleteClubAction(int iActionID, int iUserID, int iActionResult)
{
	StartStoredProcedure("completeclubaction");
	AddParam(iUserID);
	AddParam(iActionID);
	AddParam(iActionResult);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchClubDetails(int iID, bool bIDIsClubID, bool& bSuccess)

	Author:		Dharmesh Raithatha
	Created:	5/12/2003
	Inputs:		iID - a ClubID or a h2g2ID
	Outputs:	bSuccess - true if details were fetched, false if there were
				no details for that club
	Returns:	true if successfully run, false otherwise 
	Purpose:	Given a clubid or h2g2id, fetches the details for that club 

*********************************************************************************/

bool CStoredProcedure::FetchClubDetails(int iID, bool bIDIsClubID, bool& bSuccess)
{
	StartStoredProcedure("fetchclubdetails");
	if (bIDIsClubID)
	{
		AddParam("ClubID",iID);
	}
	else
	{
		AddParam("h2g2ID",iID);
	}
	ExecuteStoredProcedure();

	if (HandleError("FetchClubDetails"))
	{
		bSuccess = false;
		return false;
	}
		
	bSuccess = !IsEOF();

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchClubDetailsViaClubID(int iClubID, bool& bSuccess)

	Author:		Mark Neves
	Created:	03/09/2003
	Inputs:		iClubID = the ID of the club
	Outputs:	bSuccess updated with success state
	Returns:	true if OK, false if something nasty happened
	Purpose:	Gets the club details given the club ID

*********************************************************************************/

bool CStoredProcedure::FetchClubDetailsViaClubID(int iClubID, bool& bSuccess)
{
	return FetchClubDetails(iClubID, true, bSuccess);
}

/*********************************************************************************

	bool CStoredProcedure::FetchClubDetailsViaH2G2ID(int iH2G2ID, bool& bSuccess)

	Author:		Mark Neves
	Created:	03/09/2003
	Inputs:		iH2G2ID = the ID of the article associated with the club
	Outputs:	bSuccess updated with success state
	Returns:	true if OK, false if something nasty happened
	Purpose:	Gets the club details given the h2g2ID of the club's article

*********************************************************************************/

bool CStoredProcedure::FetchClubDetailsViaH2G2ID(int iH2G2ID, bool& bSuccess)
{
	return FetchClubDetails(iH2G2ID, false, bSuccess);
}


bool CStoredProcedure::GetClubActionList(int iClubID)
{
	StartStoredProcedure("getactionlistforclub");
	AddParam(iClubID);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetUserActionList(int iUserID)
{
	StartStoredProcedure("getactionlistforuser");
	AddParam(iUserID);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetAllTeamMembers(int iTeamID, int iSiteID,bool &bNoMembers)

	Author:		Dharmesh Raithatha
	Created:	5/16/2003
	Inputs:		iTeamID - id of the team you want to find the members for
	Outputs:	bNoMembers - true if the team is empty or not present
	Returns:	true if successfully run, false otherwise
	Purpose:	Given the team id finds all the team members in that team

*********************************************************************************/

bool CStoredProcedure::GetAllTeamMembers(int iTeamID, int iSiteID,bool &bNoMembers)
{
	StartStoredProcedure("GetAllTeamMembers");
	AddParam(iTeamID);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	
	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetTeamMembers "; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	if (IsEOF())
	{
		bNoMembers = true;  
	}
	else
	{
		bNoMembers = false;
	}

	return true;

}

bool CStoredProcedure::UpdateDefaultPermissions(int iSiteID,
	int iClubCanAutoJoinMember, 
	int iClubCanAutoJoinOwner, 
	int iClubCanBecomeMember, 
	int iClubCanBecomeOwner, 
	int iClubCanApproveMembers, 
	int iClubCanApproveOwners, 
	int iClubCanDemoteOwners, 
	int iClubCanDemoteMembers, 
	int iClubCanViewActions, 
	int iClubCanView, 
	int iClubCanPostJournal, 
	int iClubCanPostCalendar,
	int iClubCanEdit, 

	int iClubOwnerCanAutoJoinMember, 
	int iClubOwnerCanAutoJoinOwner, 
	int iClubOwnerCanBecomeMember, 
	int iClubOwnerCanBecomeOwner, 
	int iClubOwnerCanApproveMembers, 
	int iClubOwnerCanApproveOwners, 
	int iClubOwnerCanDemoteOwners, 
	int iClubOwnerCanDemoteMembers, 
	int iClubOwnerCanViewActions, 
	int iClubOwnerCanView, 
	int iClubOwnerCanPostJournal, 
	int iClubOwnerCanPostCalendar, 
	int iClubOwnerCanEdit, 

	int iClubMemberCanAutoJoinMember, 
	int iClubMemberCanAutoJoinOwner, 
	int iClubMemberCanBecomeMember, 
	int iClubMemberCanBecomeOwner, 
	int iClubMemberCanApproveMembers, 
	int iClubMemberCanApproveOwners, 
	int iClubMemberCanDemoteOwners, 
	int iClubMemberCanDemoteMembers, 
	int iClubMemberCanViewActions, 
	int iClubMemberCanView, 
	int iClubMemberCanPostJournal, 
	int iClubMemberCanPostCalendar, 
	int iClubMemberCanEdit, 

	int iClosedClubCanAutoJoinMember, 
	int iClosedClubCanAutoJoinOwner, 
	int iClosedClubCanBecomeMember, 
	int iClosedClubCanBecomeOwner, 
	int iClosedClubCanApproveMembers, 
	int iClosedClubCanApproveOwners, 
	int iClosedClubCanDemoteOwners, 
	int iClosedClubCanDemoteMembers, 
	int iClosedClubCanViewActions, 
	int iClosedClubCanView, 
	int iClosedClubCanPostJournal, 
	int iClosedClubCanPostCalendar, 
	int iClosedClubCanEdit, 

	int iClosedClubOwnerCanAutoJoinMember, 
	int iClosedClubOwnerCanAutoJoinOwner, 
	int iClosedClubOwnerCanBecomeMember, 
	int iClosedClubOwnerCanBecomeOwner, 
	int iClosedClubOwnerCanApproveMembers, 
	int iClosedClubOwnerCanApproveOwners, 
	int iClosedClubOwnerCanDemoteOwners, 
	int iClosedClubOwnerCanDemoteMembers, 
	int iClosedClubOwnerCanViewActions, 
	int iClosedClubOwnerCanView, 
	int iClosedClubOwnerCanPostJournal, 
	int iClosedClubOwnerCanPostCalendar, 
	int iClosedClubOwnerCanEdit, 

	int iClosedClubMemberCanAutoJoinMember, 
	int iClosedClubMemberCanAutoJoinOwner, 
	int iClosedClubMemberCanBecomeMember, 
	int iClosedClubMemberCanBecomeOwner, 
	int iClosedClubMemberCanApproveMembers, 
	int iClosedClubMemberCanApproveOwners, 
	int iClosedClubMemberCanDemoteOwners, 
	int iClosedClubMemberCanDemoteMembers, 
	int iClosedClubMemberCanViewActions, 
	int iClosedClubMemberCanView, 
	int iClosedClubMemberCanPostJournal, 
	int iClosedClubMemberCanPostCalendar,
	int iClosedClubMemberCanEdit)
{
	StartStoredProcedure("updatedefaultpermissions");
	AddParam(iSiteID);

	AddParam(iClubCanAutoJoinMember); 
	AddParam(iClubCanAutoJoinOwner); 
	AddParam(iClubCanBecomeMember); 
	AddParam(iClubCanBecomeOwner); 
	AddParam(iClubCanApproveMembers); 
	AddParam(iClubCanApproveOwners); 
	AddParam(iClubCanDemoteOwners); 
	AddParam(iClubCanDemoteMembers); 
	AddParam(iClubCanViewActions); 
	AddParam(iClubCanView); 
	AddParam(iClubCanPostJournal); 
	AddParam(iClubCanPostCalendar); 

	AddParam(iClubOwnerCanAutoJoinMember); 
	AddParam(iClubOwnerCanAutoJoinOwner); 
	AddParam(iClubOwnerCanBecomeMember); 
	AddParam(iClubOwnerCanBecomeOwner); 
	AddParam(iClubOwnerCanApproveMembers); 
	AddParam(iClubOwnerCanApproveOwners); 
	AddParam(iClubOwnerCanDemoteOwners); 
	AddParam(iClubOwnerCanDemoteMembers); 
	AddParam(iClubOwnerCanViewActions); 
	AddParam(iClubOwnerCanView); 
	AddParam(iClubOwnerCanPostJournal); 
	AddParam(iClubOwnerCanPostCalendar); 

	AddParam(iClubMemberCanAutoJoinMember); 
	AddParam(iClubMemberCanAutoJoinOwner); 
	AddParam(iClubMemberCanBecomeMember); 
	AddParam(iClubMemberCanBecomeOwner); 
	AddParam(iClubMemberCanApproveMembers); 
	AddParam(iClubMemberCanApproveOwners); 
	AddParam(iClubMemberCanDemoteOwners); 
	AddParam(iClubMemberCanDemoteMembers); 
	AddParam(iClubMemberCanViewActions); 
	AddParam(iClubMemberCanView); 
	AddParam(iClubMemberCanPostJournal); 
	AddParam(iClubMemberCanPostCalendar); 

	AddParam(iClosedClubCanAutoJoinMember); 
	AddParam(iClosedClubCanAutoJoinOwner); 
	AddParam(iClosedClubCanBecomeMember); 
	AddParam(iClosedClubCanBecomeOwner); 
	AddParam(iClosedClubCanApproveMembers); 
	AddParam(iClosedClubCanApproveOwners); 
	AddParam(iClosedClubCanDemoteOwners); 
	AddParam(iClosedClubCanDemoteMembers); 
	AddParam(iClosedClubCanViewActions); 
	AddParam(iClosedClubCanView); 
	AddParam(iClosedClubCanPostJournal); 
	AddParam(iClosedClubCanPostCalendar); 

	AddParam(iClosedClubOwnerCanAutoJoinMember); 
	AddParam(iClosedClubOwnerCanAutoJoinOwner); 
	AddParam(iClosedClubOwnerCanBecomeMember); 
	AddParam(iClosedClubOwnerCanBecomeOwner); 
	AddParam(iClosedClubOwnerCanApproveMembers); 
	AddParam(iClosedClubOwnerCanApproveOwners); 
	AddParam(iClosedClubOwnerCanDemoteOwners); 
	AddParam(iClosedClubOwnerCanDemoteMembers); 
	AddParam(iClosedClubOwnerCanViewActions); 
	AddParam(iClosedClubOwnerCanView); 
	AddParam(iClosedClubOwnerCanPostJournal); 
	AddParam(iClosedClubOwnerCanPostCalendar); 

	AddParam(iClosedClubMemberCanAutoJoinMember); 
	AddParam(iClosedClubMemberCanAutoJoinOwner); 
	AddParam(iClosedClubMemberCanBecomeMember); 
	AddParam(iClosedClubMemberCanBecomeOwner); 
	AddParam(iClosedClubMemberCanApproveMembers); 
	AddParam(iClosedClubMemberCanApproveOwners); 
	AddParam(iClosedClubMemberCanDemoteOwners); 
	AddParam(iClosedClubMemberCanDemoteMembers); 
	AddParam(iClosedClubMemberCanViewActions); 
	AddParam(iClosedClubMemberCanView); 
	AddParam(iClosedClubMemberCanPostJournal); 
	AddParam(iClosedClubMemberCanPostCalendar); 
	ExecuteStoredProcedure();

	return true;
}

bool CStoredProcedure::GetForumPostsAsGuestbook(int ForumID, int iAscendingOrder)
{
	StartStoredProcedure("getforumpostsguestbook");
	AddParam(ForumID);
	AddParam(iAscendingOrder);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetForumPostsAsGuestbookSkipAndShow(int iForumID, int iAscendingOrder, int iSkip, int iShow)
{
	StartStoredProcedure("getforumpostsguestbookskipandshow");
	AddParam("ForumID", iForumID);
	AddParam("firstindex", iSkip + 1);
	AddParam("lastindex", iSkip + iShow);
	AddParam("ascendingorder", iAscendingOrder);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::SearchHierarchy(const TDVCHAR *pSearchTerm, int iSiteID)
{
	StartStoredProcedure("searchhierarchy");
	AddParam(pSearchTerm);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::BeginUpdateClub(int iClubID,int iUserID, bool bChangeEditor)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		iClubID = the club;s ID
				iUserID = UserID
				bChangeEditor = true if the viewing user is not a site editor or su
	Outputs:	-
	Returns:	true if able to start the Update Club process
	Purpose:	Call this to start a club update operation.
				After this call, call ClubUpdate...() functions to update the various bits
				you want to update.
				When you are ready, call DoUpdateClub() to complete the update.

*********************************************************************************/

bool CStoredProcedure::BeginUpdateClub(int iClubID,int iUserID, bool bChangeEditor)
{
	TDVASSERT(iClubID > 0, "CStoredProcedure::BeginUpdateClub() called with non-positive club ID");

	StartStoredProcedure("updateclub");
	AddParam("ClubID", iClubID);
	AddParam("UserID", iUserID);
	AddParam("changeEditor", bChangeEditor);

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ClubUpdateTitle(const TDVCHAR* pTitle)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		pTitle = the new title (or name) of the club
	Outputs:	-
	Returns:	true if ok
	Purpose:	Call after a call to BeginUpdateClub(), then call
				DoUpdateClub() to commit the change.

*********************************************************************************/

bool CStoredProcedure::ClubUpdateTitle(const TDVCHAR* pTitle)
{
	AddParam("Title", pTitle);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ClubUpdateBodyText(const TDVCHAR* pBodyText)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		pBodyText = the new body text of the club's article
	Outputs:	-
	Returns:	true if ok
	Purpose:	Call after a call to BeginUpdateClub(), then call
				DoUpdateClub() to commit the change.

*********************************************************************************/

bool CStoredProcedure::ClubUpdateBodyText(const TDVCHAR* pBodyText)
{
	AddParam("BodyText", pBodyText);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ClubUpdateExtraInfo(const CExtraInfo& ExtraInfo)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		ExtraInfo = ref to the ExtraInfo object containing new ExtraInfo
	Outputs:	-
	Returns:	true if ok
	Purpose:	Call after a call to BeginUpdateClub(), then call
				DoUpdateClub() to commit the change.

*********************************************************************************/

bool CStoredProcedure::ClubUpdateExtraInfo(const CExtraInfo& ExtraInfo)
{
	CTDVString sExtraInfoXML;
	if (ExtraInfo.GetInfoAsXML(sExtraInfoXML))
	{
		AddParam("ExtraInfo",sExtraInfoXML);
		return true;
	}

	return false;
}

/*********************************************************************************

	bool CStoredProcedure::DoUpdateClub(bool& bSuccess)

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		-
	Outputs:	bSuccess contains the success of the updates
	Returns:	true if the stored procedure ran OK
	Purpose:	Call after using BeginUpdateClub(), and ClubUpdate...() functions.
				This commits all the changes made via calls to ClubUpdate...() calls
				
*********************************************************************************/

bool CStoredProcedure::DoUpdateClub(bool& bSuccess)
{
	if (!CheckProcedureName("updateclub"))
	{
		CTDVString sMessage;
		sMessage << "DoUpdateClub() called with wrong stored procedure name (currently set as " << m_sProcName << " )";
		TDVASSERT(false, sMessage);
		return false;
	}

	ExecuteStoredProcedure();

	if (HandleError("DoUpdateClub"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}
	else
	{
		bSuccess = (GetIntField("Success") == 1);
		return true;
	}
}


bool CStoredProcedure::ClipPageToObject(const TDVCHAR* pSourceType, int iSourceID, 
	const TDVCHAR *pDestType, int iDestID, const TDVCHAR* pTitle,
	const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, 
	bool bHidden, int iTeamID, const TDVCHAR *pRelationship, 
	const TDVCHAR* pUrl, int iSubmitterID, int iDestinationSiteId )
{
	StartStoredProcedure("addlinks");
	AddParam("sourcetype",pSourceType);
	AddParam("sourceid",iSourceID);
	AddParam("desttype",pDestType);
	AddParam("destid",iDestID);
	AddParam("submitterid",iSubmitterID);
	if (pTitle == NULL || pTitle[0] == 0)
	{
		AddNullParam("title");
	}
	else
	{
		AddParam("title", pTitle);
	}
	if (pLinkDescription == NULL || pLinkDescription[0] == 0)
	{
		AddNullParam("description");
	}
	else
	{
		AddParam("description", pLinkDescription);
	}
	if (pLinkGroup == NULL)
	{
		AddParam("group","");
	}
	else
	{
		AddParam("group",pLinkGroup);
	}
	AddParam("ishidden",bHidden);
	AddParam("teamid",iTeamID);
	AddParam("url", pUrl ? pUrl : "");
	if (pRelationship != NULL && strlen(pRelationship) > 0)
	{
		AddParam("Relationship",pRelationship);
	}
	AddParam("destsiteid", iDestinationSiteId);

	ExecuteStoredProcedure();
	return true;
}


bool CStoredProcedure::ClipPageToUserPage(const TDVCHAR *pPageType, int iObjectID, const TDVCHAR *pLinkDescription, const TDVCHAR *pLinkGroup, const TDVCHAR* pRelationship, CUser* pViewingUser, int iDestinationSiteId, bool bPrivate )
{
	if (pViewingUser == NULL)
	{
		TDVASSERT(false, "NULL viewing user passed in");
		return false;
	}

	int iUserID = pViewingUser->GetUserID();
	int iTeamID = 0;
	if (!pViewingUser->GetTeamID(&iTeamID))
	{
		TDVASSERT(false, "Failed to get team ID of the viewing user");
		return false;
	}

	return ClipPageToObject("userpage", iUserID, pPageType, iObjectID, NULL,
		pLinkDescription, pLinkGroup, bPrivate, iTeamID, pRelationship, NULL, iUserID, iDestinationSiteId );
}

bool CStoredProcedure::ClipPageToClub(int iClubID,const TDVCHAR* pPageType, 
	int iPageID, const TDVCHAR* pTitle, const TDVCHAR* pLinkDescription, 
	const TDVCHAR* pLinkGroup,int iTeamID,const TDVCHAR* pRelationship, 
	const TDVCHAR* pUrl, int iSubmitterID, int iDestinationSiteId )
{
	// At the moment, all links added directly to a club are public (not hidden)
	bool bHidden = false;

	return ClipPageToObject("club", iClubID, pPageType, iPageID, pTitle,
		pLinkDescription, pLinkGroup, bHidden, 
		iTeamID, pRelationship, pUrl, iSubmitterID, iDestinationSiteId );
}

bool CStoredProcedure::GetLinkGroups(const TDVCHAR* pSourceType, int iSourceID)
{
	StartStoredProcedure("getlinkgroups");
	AddParam(pSourceType);
	AddParam(iSourceID);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetUserLinks(int iUserID, const TDVCHAR* pLinkGroup, bool bShowPrivate)
{
	StartStoredProcedure("getuserlinks");
	AddParam(iUserID);

	CTDVString emptylinkgroup;
	if (pLinkGroup == NULL)
	{
		AddParam(emptylinkgroup);
	}
	else
	{
		AddParam(pLinkGroup);
	}
	if (bShowPrivate) 
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetFrontPageElementLinks
	Author:		Martin Robb
	Created:	20/01/2005
	Inputs:		-
	Outputs:	None
	Returns:	true if the stored procedure executed without error
	Purpose:	Fetch the Links for the Given ID.
				In this case the ID corresponds to a front page element.
				The queries GetUserLinks, GetClublinks and GetFrontpagelinks are v similar.
				They have not been combined as it may be detrimental to database query optimisation.
				However it may be a good idea to combine the methods GetUserLinks, GetClubLinks and GetFrontPageElementLinks.
*********************************************************************************/
bool CStoredProcedure::GetFrontPageElementLinks(int iElementID,  bool bShowPrivate)
{
	StartStoredProcedure("getfrontpageelementlinks");
	AddParam(iElementID);
	
	if (bShowPrivate) 
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::DeleteLink(int iLinkID, int iUserID, int iSiteID, bool& bDeleted)
{
	StartStoredProcedure("deletelink");
	AddParam("linkid",iLinkID);	
	AddParam("userid",iUserID);	
	AddParam("siteid",iSiteID);
	ExecuteStoredProcedure();
	int nRowCount = GetIntField("rowcount");
	bDeleted = (nRowCount > 0);
	return true;
}

bool CStoredProcedure::MoveLink(int iLinkID, const TDVCHAR* pNewLocation)
{
	StartStoredProcedure("movelink");
	AddParam(iLinkID);
	AddParam(pNewLocation);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::ChangeLinkPrivacy(int iLinkID, bool bPrivate)
{
	StartStoredProcedure("changelinkprivacy");
	AddParam(iLinkID);
	if (bPrivate) 
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetVoteLinks(int iVoteID, const TDVCHAR* pLinkGroup, bool bShowPrivate)
{
	StartStoredProcedure("getvotelinks");
	AddParam("voteid",iVoteID);
	if (pLinkGroup == NULL)
	{
		AddParam("linkgroup","");
	}
	else
	{
		AddParam("linkgroup",pLinkGroup);
	}
	if (bShowPrivate) 
	{
		AddParam("showprivate",1);
	}
	else
	{
		AddParam("showprivate",0);
	}
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetRelatedArticles(int ih2g2ID)

	Author:		Mark Howitt
	Created:	20/08/2003
	Inputs:		-
	Outputs:	- 
	Returns:	-
	Purpose:	Finds all the related articals to the given artical.

*********************************************************************************/

bool CStoredProcedure::GetRelatedArticles(int ih2g2ID)
{
	StartStoredProcedure("getrelatedarticles");
	AddParam("h2g2ID", ih2g2ID);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetRelatedClubs(int ih2g2ID)

	Author:		Mark Howitt
	Created:	20/08/2003
	Inputs:		ih2g2id - the h2g2ID of the article you want to check for
	Outputs:	- 
	Returns:	true 
	Purpose:	Finds all the related clubs to the given artical.

*********************************************************************************/

bool CStoredProcedure::GetRelatedClubs(int ih2g2ID)
{
	StartStoredProcedure("getrelatedclubs");
	AddParam("h2g2ID", ih2g2ID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllClubsThatUserBelongsTo(int iUserID, int iInLastNoOfDays = 1, int iSiteID = 0)

	Author:		Mark Howitt
	Created:	27/08/2003
	Inputs:		iUserID - the id of the user you wnat to check for.
				iInLastNoOfDays - Used to find the number of new members in the
					last couple of days denoted by iInLastNoOfDays.
				iSiteID - The Id of the site you want to get the clubs from
	Outputs:	- 
	Returns:	true
	Purpose:	Returns all the clubs that the current user belongs to

*********************************************************************************/

bool CStoredProcedure::GetAllClubsThatUserBelongsTo(int iUserID, int iInLastNoOfDays, int iSiteID)
{
	// Start the procedure
	StartStoredProcedure("getallclubsthatuserbelongsto");

	// Add the params
	AddParam("iUserID",iUserID);
	AddParam("iInLastNoOfDays",iInLastNoOfDays);
	AddParam("iSiteID",iSiteID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetAllClubsThatUserBelongsTo"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::CopyLinksToClub(int iUserID, int iClubID, const TDVCHAR* pLinkGroup)
{
	StartStoredProcedure("copylinkstoclub");
	AddParam(iUserID);
	AddParam(iClubID);
	if (pLinkGroup == NULL)
	{
		AddParam("");
	}
	else
	{
		AddParam(pLinkGroup);
	}
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetAllEditableClubs(int iUserID)
{
	StartStoredProcedure("getalleditableclubs");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetEditableClubLinkGroups(int iUserID)
{
	StartStoredProcedure("geteditableclublinkgroups");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GetClubLinks(int iClubID, const TDVCHAR* pLinkGroup, bool bShowPrivate)
{
	StartStoredProcedure("getclublinks");
	AddParam(iClubID);
	if (pLinkGroup == NULL)
	{
		AddParam("");
	}
	else
	{
		AddParam(pLinkGroup);
	}
	if (bShowPrivate) 
	{
		AddParam(1);
	}
	else
	{
		AddParam(0);
	}
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::CopySingleLinkToClub(int iLinkID, int iClubID, const TDVCHAR* pClubLinkGroup)
{
	StartStoredProcedure("copysinglelinktoclub");
	AddParam(iLinkID);
	AddParam(iClubID);
	AddParam(pClubLinkGroup);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetNumberOfTeamMembers(int iTeamID, CTDVString& sNumberOfMembers, int iInLastNoOfDays)
  
	Author:		Mark Howitt
	Created:	29/08/2003
	Inputs:		iTeamID - The Id for the team your looking for the members in.
				iInLastNoOfDays - The number of days to look back in. Used to check for new users.
								  This value is 0 by default which means all users will be found.
								  Another value will will check the past for that number of days.

	Outputs:	-
	Returns:	true if all went ok, false if not
	Purpose:	Gets all the members belonging to a given TeamID.
				The results return the total number of members and the number of member joined
				in the last couple of days defined by iInLastNoOfDays

*********************************************************************************/

bool CStoredProcedure::GetNumberOfTeamMembers(int iTeamID, int iInLastNoOfDays)
{
	// Set up the procedure
	StartStoredProcedure("getteammemberscount");

	// Add the team id and the no of days if the value if greater than 0.
	AddParam(iTeamID);
	AddParam(iInLastNoOfDays);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetNumberOfTeamMembers"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsUserInTeamMembersOfClub(int iUserID, int iClubID, bool& bIsInTeam)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iUserID - the id of the user you want to check
				iClubID - the club id to check in
	Outputs:	bIsInTeam - a flag to state wether the user is in the team members or not
	Returns:	true if ok, false if not.
	Purpose:	Checks to see if a user is in the teams member of a club

*********************************************************************************/

bool CStoredProcedure::IsUserInTeamMembersOfClub(int iUserID, int iClubID, bool& bIsInTeam)
{
	// Set up the procedure
	StartStoredProcedure("isuserinteammembersofclub");

	// Add the team id and the no of days if the value if greater than 0.
	AddParam(iUserID);
	AddParam(iClubID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::IsUserInTeamMembersOfClub"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	bIsInTeam = !IsEOF();

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsUserInOwnerMembersOfClub(int iUserID, int iClubID, bool& bIsInTeam)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iUserID - the user you want to check for
				iClubID - the club you want to check in
	Outputs:	iIsInTeam - A flag that say wether the user is a team member or not
	Returns:	true if ok, false if not
	Purpose:	Checks to see if a given user is in the owners of a club

*********************************************************************************/

bool CStoredProcedure::IsUserInOwnerMembersOfClub(int iUserID, int iClubID, bool& bIsInTeam)
{
	// Set up the procedure
	StartStoredProcedure("isuserinownermembersofclub");

	// Add the team id and the no of days if the value if greater than 0.
	AddParam(iUserID);
	AddParam(iClubID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::IsUserInOwnerMembersOfClub"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	bIsInTeam = !IsEOF();

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetThreadListForForum(int iForumID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iForumID = the forum you want to get the thread list form
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Gets a list of thread entries for a given forum.

*********************************************************************************/

bool CStoredProcedure::GetThreadListForForum(int iForumID)
{
	// Set up the procedure
	StartStoredProcedure("getthreadlistfromforum");

	// Add the forum ID to check against
	AddParam(iForumID);
	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetThreadListForForum"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CheckUserBelongsToClub(int iUserID, int iClubID,
															bool& bUserBelongs)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iUserID - the user you want to check
				iClubID - the club that you want to check against
	Outputs:	bUserBelongs - a flag that returns true if the user actually
					belongs to the club, false if not.
	Returns:	true if ok, false if not
	Purpose:	Checks to see if the given user belongs to the given club

*********************************************************************************/

bool CStoredProcedure::CheckUserBelongsToClub(int iUserID, int iClubID, bool& bUserBelongs)
{
	// Set up the procedure
	StartStoredProcedure("doesuserbelongtoclub");

	// Add the userid and clubid
	AddParam(iUserID);
	AddParam(iClubID);
	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CheckUserBelongsToClub"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		bUserBelongs = false;
		return false;
	}

	bUserBelongs = GetIntField("UserBelongs") == 0 ? false : true;
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUsersRole(int iUserID, int iClubID, const TDVCHAR *psRole)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iUserID - the user to update the role for
				iClubID - the club that the user is in
				psRole - the new role that the user has
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Updates the role of a given user in a given club

*********************************************************************************/

bool CStoredProcedure::UpdateUsersRole(int iUserID, int iClubID, const TDVCHAR *psRole)
{
	// Set up the procedure
	StartStoredProcedure("updateusersrole");

	// Add the userid and clubid
	AddParam(iUserID);
	AddParam(iClubID);
	AddParam(psRole);
	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::UpdateUsersRole"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetAllVotingUsersWithReponse(int iVoteID, int iResponse,
																int iSiteID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iVoteID - the id of the vote you want to check against
				iResponse - the type of response to check
				iSiteID - the site to look in
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Gets all the users who haved voted with a particular response
				for a given vote

*********************************************************************************/

bool CStoredProcedure::GetAllVotingUsersWithReponse(int iVoteID, int iResponse,
													int iSiteID)
{
	// Set up the procedure
	StartStoredProcedure("getallvotinguserswithresponse");

	// Add the VoteID and Response
	AddParam(iVoteID);
	AddParam(iResponse);
	AddParam(iSiteID);
	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetAllVotingUsersWithReponse"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetVoteDetails(int iVoteID, bool& bSuccess)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iVoteID - the id of the vote you want to get the details for
	Outputs:	bSuccess - a flag to state wether the operation went ok
	Returns:	ture if ok, false if not.
	Purpose:	Gets the details for a given vote

*********************************************************************************/

bool CStoredProcedure::GetVoteDetails(int iVoteID, bool& bSuccess)
{
	// Set up the procedure
	StartStoredProcedure("getvotedetails");

	// Add the VoteID
	AddParam(iVoteID);
	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetVoteDetails"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	bSuccess = IsEOF() ? false : true;

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddResponseToVote(int iVoteID, int iUserID,
									CTDVString& sBBCUID, int iResponse,
									bool bVisible, int iThreadID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iVoteID - the id of the vote you want to add the response to.
				iUserID - the id of the user voting.
				sBBCUID - the BBCUID of the user voting. Only used when they
							are not logged in.
				iResponse - the response the user has given.
				bVisible - a flag to say if the users voted visibly.
				iThreadID - An ID of a thread if the user is voting on a notice.
							This is defaulted to 0 which means the vote is for
							a club.
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Adds a user response to a given vote

*********************************************************************************/

bool CStoredProcedure::AddResponseToVote(int iVoteID, int iUserID, CTDVString& sBBCUID,
										 int iResponse, bool bVisible, int iSiteID, int iThreadID)
{
	// Set up the procedure
	StartStoredProcedure("addresponsetovote");

	// Add the VoteID
	AddParam(iVoteID);
	AddParam(iUserID);
	
	// Add the UID to the param list
	CTDVString sHash;
	GenerateHash(sBBCUID,sHash);
	if (!AddUIDParam(sHash))
	{
		return false;
	}

	AddParam(iResponse);
	AddParam(bVisible ? 1 : 0);

	AddParam(iSiteID);

	if (iThreadID > 0)
	{
		AddParam(iThreadID);
	}
	else
	{
		AddNullParam();
	}

	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::AddResponseToVote"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateNewVote(int &iVoteID, int iType,
							CTDVDateTime &dClosingDate, bool bIsYesNo, int iOwnerID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		sName - the name of the vote.
				iType - the type of vote you're creating.
				dClosingDate - the closing date of the vote if given.
				bIsYesNo - a flag to state wether the vote is a simple yes/no or
							a multi response vote.
				int iOwner - The owner of the new vote.
	Outputs:	iVoteId - the id of the newly created vote.
	Returns:	true if ok, false if not.
	Purpose:	Creates a new vote with the given details.

*********************************************************************************/

bool CStoredProcedure::CreateNewVote(int &iVoteID, int iType,
									 CTDVDateTime &dClosingDate, bool bIsYesNo,
									 int iOwnerID, int iResponseMin, int iResponseMax, bool bAllowAnonymousRating )
{
	// Set up the procedure
	StartStoredProcedure("createnewvote");

	// Add the VoteID
	AddParam("itype",iType);

	if (dClosingDate > dClosingDate.GetCurrentTime())
	{
		AddParam("dCloseDate",dClosingDate);
	}
	else
	{
		AddNullParam("dclosedate");
	}

	AddParam("iyesno",bIsYesNo ? 1 : 0);
	AddParam("iownerid",iOwnerID);

	if ( iResponseMin != -1 )
	{
		AddParam("iresponsemin", iResponseMin);
	}

	if ( iResponseMax != -1 )
	{
		AddParam("iresponsemax", iResponseMax); 
	}

	AddParam("AllowAnonymousRating", bAllowAnonymousRating); 
	
	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CreateNewVote"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	
	// Get the new VoteID
	iVoteID = GetIntField("VoteID");
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetObjectIDFromVoteID(int iType, int iVoteID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iType - the type of item you're looking for
				iVoteid - the voteid that the item belongs to
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Tries to find the item id that belongs to a given vote.

*********************************************************************************/

bool CStoredProcedure::GetObjectIDFromVoteID(int iType, int iVoteID)
{
	// Set up the procedure
	if (iType == CVotePageBuilder::VOTETYPE_CLUB)
	{
		StartStoredProcedure("getclubidfromvoteid");
	}
	else if (iType == CVotePageBuilder::VOTETYPE_NOTICE)
	{
		StartStoredProcedure("getthreadidfromvoteid");
	}
	else
	{
		TDVASSERT(false, "Invalid Object type given to stored procedure!");
		return false;
	}

	// Add the VoteID
	AddParam(iVoteID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetClubIDFromVoteID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddVoteToClubTable(int iClubID, int iVoteID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iClubID - the id of the club you want to add a vote to
				iVoteID - the id of the vote you're trying to add.
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Adds a vote to the clubvotes table

*********************************************************************************/

bool CStoredProcedure::AddVoteToClubTable(int iClubID, int iVoteID)
{
	// Set up the procedure
	StartStoredProcedure("addvotetoclubtable");

	// Add the ClubID and VoteID
	AddParam(iClubID);
	AddParam(iVoteID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::AddVoteToClubTable"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUserDetailsFromID(int iUserID, int iSiteID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iUserID - the id of the user you want to get the details for
				iSiteID - the site to look in
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Gets the users details given a user ID

*********************************************************************************/

bool CStoredProcedure::GetUserDetailsFromID(int iUserID, int iSiteID)
{
	// Set up the procedure
	StartStoredProcedure("getusernamefromid");

	// Add the users ID
	AddParam(iUserID);
	AddParam(iSiteID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetUserNameFromID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	// Get the users name and return
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetVoteIDFromClubID(int iClubID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iCLub - the id of the club you want to find the vote for.
	Outputs:	-
	Returns:	ture if ok, false if not
	Purpose:	Finds the club ID for a given VoteID

*********************************************************************************/

bool CStoredProcedure::GetVoteIDFromClubID(int iClubID)
{
	// Set up the procedure
	StartStoredProcedure("getvoteidfromclubid");

	// Add the Clubs ID
	AddParam(iClubID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetVoteIDFromClubID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetNumberOfVotesWithResponse(int iVoteID, int iResponse,
												int &iVisible, int &iHidden)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iVoteID - The id of the vote you are wanting to check for
				iResponse - The type of response to check for.
	Outputs:	iVisible - the number of visible users.
				iHidden - the number of hidden users.
	Returns:	true if ok, false if not
	Purpose:	Finds the amount of visible and hidden users who have voted with
				a specific response.

*********************************************************************************/

bool CStoredProcedure::GetNumberOfVotesWithResponse(int iVoteID, int iResponse,
													int &iVisible, int &iHidden)
{
	// Set up the procedure
	StartStoredProcedure("getnumberofvoteswithresponse");

	// Add the Clubs ID
	AddParam(iVoteID);
	AddParam(iResponse);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	if (HandleError("GetNumberOfVotesWithResponse"))
	{
		return false;
	}

	// Get the results from the query
	if (!IsNULL("Visible"))
	{
		iVisible = GetIntField("Visible");
	}
	if (!IsNULL("Hidden"))
	{
		iHidden = GetIntField("Hidden");
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::HasUserAlreadyVoted(int iVoteID, int iUserID, CTDVString& sBBCUID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iVoteID - The vote you want to check against.
				iUserID - The id of the user you want to check for - Can be 0 for Non-sigedin users.
				sBBCUID - The cookie BBCUID of the user your checking for.
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Checks to see if a given user has already voted.

*********************************************************************************/

bool CStoredProcedure::HasUserAlreadyVoted(int iVoteID, int iUserID, CTDVString& sBBCUID)
{
	// Set up the procedure
	StartStoredProcedure("hasuseralreadyvoted2");

	// Add the vote and user
	AddParam(iVoteID);
	AddParam(iUserID);

	// Add the UID to the param list
	CTDVString sHash;
	GenerateHash(sBBCUID,sHash);
	if (!AddUIDParam(sHash))
	{
		return false;
	}

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	if (HandleError("HasUserAlreadyVoted"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllNodesThatItemBelongsTo(int iItemID, int iItemType)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iItemID - The Item you want to search for
				iItemType - The type of item you're looking for
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Finds all the nodes that a given item is attached to

*********************************************************************************/

bool CStoredProcedure::GetAllNodesThatItemBelongsTo(int iItemID, int iItemType)
{
	// Check to see what type the item is
	if (CGuideEntry::IsTypeOfArticle(iItemType) || CGuideEntry::IsTypeOfUserPage(iItemType))
	{
		// We're doing articles
		StartStoredProcedure("getallnodesthatarticlebelongsto");
		AddParam("ih2g2ID",iItemID);
	}
	else if (CGuideEntry::IsTypeOfClub(iItemType))
	{
		// We're doing clubs
		StartStoredProcedure("getallnodesthatclubbelongsto");
		AddParam("iClubID",iItemID);
	}
	/*else if ( CForum::TYPENOTICEBOARDPOST == iItemType )
	{
		//Fetch All nodes that this notice belongs too.
		StartStoredProcedure("getallnodesthatnoticeboardpostbelongsto");
		AddParam("iThreadId",iItemID);
	}*/
	else
	{
		// Don't know what type we are!
		TDVASSERT(false, CTDVString("Warning raised in CStoredProcedure::GetAllNodesThatItemBelongsTo - Inappropriate TypeID (") << iItemType << ") Given!");
		return true;
	}

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	if (HandleError("GetAllNodesThatItemBelongsTo"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllNodesThatThreadBelongsTo(int iThreadID )

	Author:		Martin Robb
	Created:	22/10/2003
	Inputs:		iThreadID - The Item you want to search for
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Finds all the nodes that a given item is attached to

*********************************************************************************/

bool CStoredProcedure::GetAllNodesThatNoticeBoardPostBelongsTo (int iThreadID )
{
	StartStoredProcedure("getallnodesthatnoticeboardpostbelongsto");
	AddParam(iThreadID);
	ExecuteStoredProcedure();
	return !HandleError("getallnodesthatnoticeboardpostbelongsto");
}

/*********************************************************************************

	bool CStoredProcedure::GetAllNodesThatUserBelongsTo(int iUserID )

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iThreadID - The Item you want to search for
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Finds all the nodes that a given item is attached to

*********************************************************************************/
bool CStoredProcedure::GetAllNodesThatUserBelongsTo (int iUserID )
{
	StartStoredProcedure("getallnodesthatuserbelongsto");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return !HandleError("getallnodesthatuserbelongsto");
}

/*********************************************************************************

	bool CStoredProcedure::IsUserAuthorisedForArticle(int iUserID, ih2g2ID, iforumID, bResult )

	Author:		Martin Robb
	Created:	16/01/2009
	Inputs:		iUserID - check to see if user is author
                iforumID - Identify article via the articles forum.
                Provide either h2g2Id or forumId in order to identify article
	Outputs:	- True if supplied user is editor of article
	Returns:	true if ok, false if not
	Purpose:	Check to see if user is author of article
=*********************************************************************************/
bool CStoredProcedure::IsUserAuthorForArticle(int iUserID, int iforumID, bool &bAuthor )
{
    bAuthor = false;
    StartStoredProcedure("isuserinauthormembersofarticle");
    AddParam("userid", iUserID);
    AddParam("forumid", iforumID);

    ExecuteStoredProcedure();

    if ( HandleError("IsUserAuthorisedForArticle") ) 
	{
		return false;
	}

    // Only get a result if user is author of article.
    bAuthor = !IsEOF();
    return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsUserAuthorisedForItem(int iTypeID, int iItemID, int iUserID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iTypeID - The Type of item you want to find the info for.
				iItemID - The ID of the item you want to check.
				iUserID - The user you want to check against.
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Checks to see if the user is in the author or owner of the given item.

*********************************************************************************/

bool CStoredProcedure::IsUserAuthorisedForItem(int iTypeID, int iItemID, int iUserID)
{
	// Check to see what type the item is
	if (CGuideEntry::IsTypeOfArticle(iTypeID) || CGuideEntry::IsTypeOfUserPage(iTypeID))
	{
		// We're doing articles
		StartStoredProcedure("isuserinauthormembersofarticle");
	}
	else if (CGuideEntry::IsTypeOfClub(iTypeID))
	{
		// We're doing clubs
		StartStoredProcedure("isuserinownermembersofclub");
	}
	else
	{
		// Don't know what type we are!
		TDVASSERT(false, "Error occurred in CStoredProcedure::IsUserAuthorisedForItem - Invalid TypeID Given!");
		return false;
	}

	// Add the ItemsID
	AddParam(iUserID);
	AddParam(iItemID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::IsUserAuthorisedForItem"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsUserAuthorisedForThread( int iThreadID, int iUserID )

	Author:		Martin Robb
	Created:	22/10/2003
	Inputs:		iThreadID - The Thread to be checked
				iUserID - The user you want to check against.
	Outputs:	- bAuthorised - result
	Returns:	false on error.
	Purpose:	Sets bAuthor is user is author of given thread.

*********************************************************************************/

bool CStoredProcedure::IsUserAuthorisedForThread ( int iThreadID, int iUserID, bool& bAuthor )
{
	bAuthor = false;
	StartStoredProcedure("isuserauthorofthread");

	// Add the ItemsID
	AddParam(iThreadID);
	AddParam(iUserID);

	ExecuteStoredProcedure();

	if ( HandleError("IsUserAuthorisedForThread") ) 
	{
		return false;
	}

	//If aresult has been found then user is author of thread.
	bAuthor = !IsEOF();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MoveItemFromSourceToDestinationNode(int iItemID,
					int iItemType, int iNodeIDFrom, int iNodeIDTo, bool& bSuccess)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iItemID - The ID of the item you are trying to move.
				iItemType - The type of item you are trying move.
				iNodeIDFrom - The Id of the node you are trying to move from.
				iNodeIDTo - The ID of the node you want to move the item to.
	Outputs:	bSuccess - A flag to state wether the operation went ok.
	Returns:	true if ok, false if not.
	Purpose:	Tries to move a given Item from one node to antother.
				This function calls the relavent sql procedure depending on
				the type of item you are tyring to move.

*********************************************************************************/

bool CStoredProcedure::MoveItemFromSourceToDestinationNode(int iItemID, int iItemType,
														   int iNodeIDFrom, int iNodeIDTo,
														   bool& bSuccess)
{
	// Check to see what type the item is
	if (CGuideEntry::IsTypeOfArticle(iItemType) || CGuideEntry::IsTypeOfUserPage(iItemType))
	{
		// We're doing articles
		StartStoredProcedure("movearticlefromsourcetodestinationnode");
	}
	else if (CGuideEntry::IsTypeOfClub(iItemType))
	{
		// We're doing clubs
		StartStoredProcedure("moveclubfromsourcetodestinationnode");
	}
	else
	{
		// Don't know what type we are!
		TDVASSERT(false, "Error occurred in CStoredProcedure::MoveItemFromSourceToDestinationNode - Invalid TypeID Given!");
		return false;
	}

	AddParam(iItemID);
	AddParam(iNodeIDFrom);
	AddParam(iNodeIDTo);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::MoveItemFromSourceToDestinationNode"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	bSuccess = GetIntField("Success") == 1 ? true : false;
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MoveThreadFromSourceToDestinationNode(int iThreadID, int iNodeIDFrom, int iNodeIDTo, bool& bSuccess)

	Author:		MartinRobb
	Created:	22/04/2005
	Inputs:		iThreadID - The ID of the item you are trying to move.
				iNodeIDFrom - The Id of the node you are trying to move from.
				iNodeIDTo - The ID of the node you want to move the item to.
	Outputs:	bSuccess - A flag to state wether the operation went ok.
	Returns:	true if ok, false if not.
	Purpose:	Tries to move a given thread from one hierarchy node to antother.

*********************************************************************************/

bool CStoredProcedure::MoveThreadFromSourceToDestinationNode(int iThreadID,
														   int iNodeIDFrom, 
														   int iNodeIDTo,
														   bool& bSuccess)
{
	StartStoredProcedure("movethreadfromsourcetodestinationnode");

	AddParam(iThreadID);
	AddParam(iNodeIDFrom);
	AddParam(iNodeIDTo);
	ExecuteStoredProcedure();

	if ( HandleError("MoveThreadFromSourceToDestinationNode") )
	{
		bSuccess = false;
		return false;
	}

	bSuccess = GetIntField("Success") == 1 ? true : false;
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MoveUserFromSourceToDestinationNode(int iUserID, int iNodeIDFrom, int iNodeIDTo, bool& bSuccess)

	Author:		Martin Robb
	Created:	05/05/2005
	Inputs:		iUserID - The ID of the item you are trying to move.
				iNodeIDFrom - The Id of the node you are trying to move from.
				iNodeIDTo - The ID of the node you want to move the item to.
	Outputs:	bSuccess - A flag to state wether the operation went ok.
	Returns:	true if ok, false if not.
	Purpose:	Tries to move a given User from one node to antother.

*********************************************************************************/

bool CStoredProcedure::MoveUserFromSourceToDestinationNode(int iUserID,
														   int iNodeIDFrom, 
														   int iNodeIDTo,
														   bool& bSuccess)
{
	StartStoredProcedure("moveuserfromsourcetodestinationnode");

	AddParam(iUserID);
	AddParam(iNodeIDFrom);
	AddParam(iNodeIDTo);
	ExecuteStoredProcedure();

	if ( HandleError("MoveUserFromSourceToDestinationNode") )
	{
		bSuccess = false;
		return false;
	}

	bSuccess = GetIntField("Success") == 1 ? true : false;
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CanUserAddToNode(int iNodeID, bool &bCanAdd)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iNodeID - the Node you want to check for
	Outputs:	bCanAdd - A return flag stating wether the user is allowed to
						  add things to it or not
	Returns:	true if ok, false if not.
	Purpose:	Checks a given node to see if the user is allowed to add to it.

*********************************************************************************/

bool CStoredProcedure::CanUserAddToNode(int iNodeID, bool &bCanAdd)
{
	// Set up the procedure
	StartStoredProcedure("canuseaddtonode");

	// Add nodeid
	AddParam(iNodeID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::CanUserAddToNode"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	bCanAdd = GetIntField("CanAdd") > 0 ? true : false;
	return true;
}

bool CStoredProcedure::GetTaxonomyNodeFromID(const TDVCHAR* pID, int& iNode)
{
	StartStoredProcedure("gettaxonomynodefromid");
	AddParam(pID);
	ExecuteStoredProcedure();
	if (!IsEOF()) 
	{
		iNode = GetIntField("NodeID");
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::AddNewUpload(int iTeamID, int iUserID, CTDVString& sFileName, int iFileType, bool& bSuccess)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::AddNewUpload(int iTeamID, int iUserID, CTDVString& sFileName, int iFileType, int& iUploadID, bool& bSuccess)
{
	// Set up the procedure
	StartStoredProcedure("addnewupload");
	AddParam("teamid",iTeamID);
	AddParam("userid",iUserID);
	AddParam("filename",sFileName);
	AddParam("filetype",iFileType);
	ExecuteStoredProcedure();

	if (HandleError("AddNewUpload"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	iUploadID =  GetIntField("UploadID");
	bSuccess  = (GetIntField("Success") == 1);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUploadStatus(int iUploadID, int iNewStatus, bool& bSuccess)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::UpdateUploadStatus(int iUploadID, int iNewStatus, bool& bSuccess)
{
	// Set up the procedure
	StartStoredProcedure("updateuploadstatus");
	AddParam("uploadid",iUploadID);
	AddParam("newstatus",iNewStatus);
	ExecuteStoredProcedure();

	if (HandleError("UpdateUploadStatus"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess  = (GetIntField("Success") == 1);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUploadsForTeam(int iTeamID, bool& bSuccess)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetUploadsForTeam(int iTeamID, bool& bSuccess)
{
	// Set up the procedure
	StartStoredProcedure("getuploadsforteam");
	AddParam("teamid",iTeamID);
	ExecuteStoredProcedure();

	if (HandleError("GetUploadsForTeam"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess  = (!IsEOF());
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUploadsForUser(int iUserID, bool& bSuccess)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetUploadsForUser(int iUserID, bool& bSuccess)
{
	// Set up the procedure
	StartStoredProcedure("getuploadsforuser");
	AddParam("userid",iUserID);
	ExecuteStoredProcedure();

	if (HandleError("GetUploadsForUser"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess  = (!IsEOF());
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteUpload(int iUploadID, bool& bSuccess)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::DeleteUpload(int iUploadID, bool& bSuccess)
{
	// Set up the procedure
	StartStoredProcedure("deleteupload");
	AddParam("uploadid",iUploadID);
	ExecuteStoredProcedure();

	if (HandleError("DeleteUpload"))
	{
		bSuccess = false;
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	bSuccess  = (GetIntField("Success") == 1);

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetForumModerationStatus(int iForumID, int iThreadID,int &iModerationStatus)

	Author:		Mark Neves
	Created:	15/9/2003
	Inputs:		iForumID - Forum that you are looking for
				iThreadID - Thread to find its owning forum (takes precedence)
	Outputs:	iModerationStatus - moderation status of the forum, 0 if forum not found
	Returns:	true is storedprocedure successful, false otherwise
	Purpose:	Finds the moderation status from the given forum or threadid

*********************************************************************************/

bool CStoredProcedure::GetForumModerationStatus(int iForumID, int iThreadID,int &iModerationStatus)
{
	StartStoredProcedure("getforummoderationstatus");
	AddParam(iForumID);
	AddParam(iThreadID);
	ExecuteStoredProcedure();

	CTDVString sTemp;
	int iErrorCode;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetForumModerationStatus "; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	// If GetIntField() fails, it will return 0, which means "undefined"
	iModerationStatus = 0;
	if(!IsEOF())
	{
		iModerationStatus = GetIntField("ModerationStatus");
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::UpdateUserJournalModerationStatus(int iUserID, int iNewStatus)

	Author:		Mark Neves
	Created:	15/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::UpdateUserJournalModerationStatus(int iUserID,int iNewStatus)
{
	StartStoredProcedure("updateforummoderationstatus");
	AddParam("userid",iUserID);
	AddParam("newstatus",iNewStatus);
	ExecuteStoredProcedure();

	if (HandleError("UpdateUserJournalModerationStatus"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	return (GetIntField("Success") == 1);
}

/*********************************************************************************

	bool CStoredProcedure::UpdateForumModerationStatus(int iForumID,int iNewStatus)

	Author:		Mark Neves
	Created:	15/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::UpdateForumModerationStatus(int iForumID,int iNewStatus)
{
	StartStoredProcedure("updateforummoderationstatus");
	AddParam("forumid",iForumID);
	AddParam("newstatus",iNewStatus);
	ExecuteStoredProcedure();

	if (HandleError("UpdateForumModerationStatus"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	return (GetIntField("Success") == 1);
}


/*********************************************************************************

	bool CStoredProcedure::UpdateArticleModerationStatus(int ih2g2ID,int iNewStatus)

	Author:		Mark Neves
	Created:	16/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::UpdateArticleModerationStatus(int ih2g2ID,int iNewStatus)
{
	StartStoredProcedure("updatearticlemoderationstatus");
	AddParam("h2g2id",ih2g2ID);
	AddParam("newstatus",iNewStatus);
	ExecuteStoredProcedure();

	if (HandleError("UpdateArticleModerationStatus"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	return (GetIntField("Success") == 1);
}

/*********************************************************************************

	bool CStoredProcedure::GetArticleModerationStatus(int ih2g2ID,int &iModerationStatus)

	Author:		Mark Neves
	Created:	16/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetArticleModerationStatus(int ih2g2ID,int &iModerationStatus)
{
	StartStoredProcedure("getarticlemoderationstatus");
	AddParam("h2g2id",ih2g2ID);
	ExecuteStoredProcedure();

	if (HandleError("GetArticleModerationStatus"))
	{
		return false;
	}

	// If GetIntField() fails, it will return 0, which means "undefined"
	iModerationStatus = 0;
	if(!IsEOF())
	{
		iModerationStatus = GetIntField("ModerationStatus");
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsArticleInModeration(int ih2g2ID,int &isArticleInModeration)

	Author:		James Conway
	Created:	30/04/2008
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::IsArticleInModeration(int ih2g2ID,int &isArticleInModeration)
{
	StartStoredProcedure("isarticleinmoderation");
	AddParam("h2g2id",ih2g2ID);
	ExecuteStoredProcedure();

	if (HandleError("IsArticleInModeration"))
	{
		return false;
	}

	// If GetIntField() fails, it will return 0, which means "undefined"
	isArticleInModeration = 0;
	if(!IsEOF())
	{
		isArticleInModeration = GetIntField("InModeration");
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::UpdateClubModerationStatus(int iClubID,int iNewStatus)

	Author:		Mark Neves
	Created:	18/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::UpdateClubModerationStatus(int iClubID,int iNewStatus)
{
	StartStoredProcedure("updateclubmoderationstatus");
	AddParam("clubid",iClubID);
	AddParam("newstatus",iNewStatus);
	ExecuteStoredProcedure();

	if (HandleError("UpdateClubModerationStatus"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	return (GetIntField("Success") == 1);
}

/*********************************************************************************

	bool CStoredProcedure::GetClubModerationStatus(int iClubID,int &iModerationStatus)

	Author:		Mark Neves
	Created:	22/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetClubModerationStatus(int iClubID,int &iModerationStatus)
{
	StartStoredProcedure("getclubmoderationstatus");
	AddParam("clubid",iClubID);
	ExecuteStoredProcedure();

	if (HandleError("GetClubModerationStatus"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	// If GetIntField() fails, it will return 0, which means "undefined"
	iModerationStatus = 0;
	if(!IsEOF())
	{
		iModerationStatus = GetIntField("ModerationStatus");
	}
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetHierarchyByTreeLevelAndParent(const int iSiteID)

	Author:		Nick Stevenson
	Created:	19/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetHierarchyByTreeLevelAndParent(const int iSiteID)
{
	StartStoredProcedure("GetHierarchyByTreeLevelAndParent");
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetHierarchyTreeLevel"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	
	//return (!IsEOF());
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetVoteIDForThreadID(int iThreadID)

	Author:		Mark Howitt
	Created:	19/09/2003
	Inputs:		iThreadID - The threadID that the voteid belongs to.
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Returns the VoteID of a vote that belongs to a given thread

*********************************************************************************/

bool CStoredProcedure::GetVoteIDForThreadID(int iThreadID)
{
	StartStoredProcedure("getvoteidforthreadid");
	AddParam(iThreadID);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetVoteIDForThreadID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetForumDetailsFromNodeID(int iNodeID, int iSiteID)

	Author:		Mark Howitt
	Created:	19/09/2003
	Inputs:		iNodeID - the node you want to get the forum details for.
				iSiteId - the site you want to look in..
	Outputs:	-
	Returns:	true if ok, false if not.
	Purpose:	Gets the forum details for a node in a specified site.

*********************************************************************************/

bool CStoredProcedure::GetForumDetailsFromNodeID(int iNodeID, int iSiteID)
{
	StartStoredProcedure("getforumidfromnodeid");
	AddParam(iNodeID);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetForumFromNodeID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddVoteToThreadVoteTable(int iThreadID, int iVoteID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iThreadID - the thread that you want to add the vote to
				iVoteID - the vote id that you want to add
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Adds a vote to the threadvote table.

*********************************************************************************/

bool CStoredProcedure::AddVoteToThreadVoteTable(int iThreadID, int iVoteID)
{
	// Set up the procedure
	StartStoredProcedure("addvotetothreadtable");

	// Add the ClubID and VoteID
	AddParam(iThreadID);
	AddParam(iVoteID);

	// Execute and check to see if everything went ok.
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::AddVoteToThreadVoteTable"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetNodeIDForThreadID(int iThreadID, int iSiteID)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iThreadID - the thread id that you want to find the node for
				iSiteID - The site to look in
	Returns:	true if ok, false if not.
	Purpose:	Finds the node that the thread belongs to.

*********************************************************************************/

bool CStoredProcedure::GetNodeIDForThreadID(int iThreadID, int iSiteID)
{
	StartStoredProcedure("getnodeidforthreadid");
	AddParam(iThreadID);
	AddParam(iSiteID);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetNodeIDForThreadID"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllEventsInTheNextNumberOfDays(int iForumID, int iDays)

	Author:		Mark Howitt
	Created:	22/10/2003
	Inputs:		iForumID - The Forum you wnat to search for events in
				iDays - The number of days into the future you want to search.
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Finds all events that are set to happed within the specified number of days.

*********************************************************************************/

bool CStoredProcedure::GetAllEventsInTheNextNumberOfDays(int iForumID, int iDays)
{
	StartStoredProcedure("getalleventsforthenextnumberofdays");
	AddParam(iForumID);
	AddParam(iDays);
	ExecuteStoredProcedure();
	CTDVString sTemp;
	int iErrorCode = 0;
	if (GetLastError(&sTemp, iErrorCode))
	{
		CTDVString sMessage = "Error occurred in CStoredProcedure::GetAllEventsInTheNextNumberOfDays"; 
		sMessage << sTemp;
		TDVASSERT(false, sMessage);
		return false;
	}
	
	return true;
}



/*********************************************************************************

	bool CStoredProcedure::GetReservedArticles(int iUserID)

	Author:		Mark Neves
	Created:	24/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetReservedArticles(int iUserID)
{
	StartStoredProcedure("getreservedarticles");
	AddParam("userid",iUserID);
	ExecuteStoredProcedure();

	if (HandleError("GetReservedArticles"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	return (!IsEOF());
}

/*********************************************************************************

	bool CStoredProcedure::ForumGetNoticeBoardPosts(int iForumID)

	Author:		Mark HOwitt
	Created:	02/10/2003
	Inputs:		- iForumID
	Outputs:	-	NA
	Returns:	- false if no results found or db error
	Purpose:	- Fetches all the notice board posts for a forum.

*********************************************************************************/

bool CStoredProcedure::ForumGetNoticeBoardPosts(int iForumID)
{
	StartStoredProcedure("forumgetnoticeboardposts");
	AddParam(iForumID);
	ExecuteStoredProcedure();
	if ( HandleError("ForumGetNoticeBoardPosts") )
	{
		return false;
	}
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetNoticeBoardPostsForNode(int iNodeID, int iSiteID)

	Author:		Martin Robb
	Created:	05/02/2005
	Inputs:		- Node ID, SiteID 
	Outputs:	- None
	Returns:	- False on error
	Purpose:	- Fetch Notice Board Posts tagged to the provided node 
					where the node is relevant for a given site.

*********************************************************************************/

bool CStoredProcedure::GetNoticeBoardPostsForNode( int iNodeID, int iSiteID )
{
	StartStoredProcedure("getnoticeboardpostsfornode");
	AddParam(iNodeID);
	AddParam(iSiteID);

	ExecuteStoredProcedure();
	return !HandleError("GetNoticeBoardPostsForNode");
}

/*********************************************************************************

	bool CStoredProcedure::GetUsersForNode(int iNodeID, int iSiteID)

	Author:		Martin Robb
	Created:	10/05/2005
	Inputs:		- Node ID, SiteID 
	Outputs:	- None
	Returns:	- False on error
	Purpose:	- Fetch Notice Board Posts tagged to the provided node 
					where the node is relevant for a given site.

*********************************************************************************/

bool CStoredProcedure::GetUsersForNode( int iNodeID, int iSiteID )
{
	StartStoredProcedure("getusersfornode");
	AddParam(iNodeID);
	AddParam(iSiteID);

	ExecuteStoredProcedure();
	return !HandleError("GetUsersForNode");
}

/*********************************************************************************

	bool CStoredProcedure::GetClubCrumbTrail(int iClubID)

	Author:		Mark Neves
	Created:	02/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetClubCrumbTrail(int iClubID)
{
	StartStoredProcedure("getclubcrumbtrail");
	AddParam("clubid",iClubID);
	ExecuteStoredProcedure();

	if (HandleError("GetClubCrumbTrail"))
	{
		return false;		// An error was handled, so indicate that the stored procedure failed by returning false
	}

	return (!IsEOF());
}

/*********************************************************************************

	bool CStoredProcedure::ForumGetNoticeInfo(int iForumID, int iThreadID)

	Author:		Mark Howitt
	Created:	02/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CStoredProcedure::ForumGetNoticeInfo(int iForumID, int iThreadID)
{
	StartStoredProcedure("forumgetnoticeinfo");
	AddParam(iForumID);
	AddParam(iThreadID);
	ExecuteStoredProcedure();
	if (HandleError("ForumGetNoticeInfo"))
	{
		return false;
	}

	return (!IsEOF());
}

bool CStoredProcedure::MarkAllThreadsRead(int iUserID)
{
	StartStoredProcedure("markallthreadsread");
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllLocalAuthorityNodes(const int iSiteID)

	Author:		Mark Howitt
	Created:	03/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if it found all the nodes, false if not
	Purpose:	Gets all the local authority nodes for noticeboards

*********************************************************************************/
bool CStoredProcedure::GetAllLocalAuthorityNodes(const int iSiteID, const int iNodeID, const int iAuthorityLevel)
{
	// Call the procedure
	StartStoredProcedure("GetAllLocalAuthorityNodes");
	AddParam("iSiteID",iSiteID);
	AddParam("iNodeID",iNodeID);
	AddParam("iAuthorityLevel",iAuthorityLevel);
	ExecuteStoredProcedure();
	if (HandleError("GetAllLocalAuthorityNodes"))
	{
		return false;
	}
	
	// Return the verdict
	return (!IsEOF());
}

/*********************************************************************************

	bool CStoredProcedure::GetTreeLevelForNodeID(int iNodeID, int iSiteID)

	Author:		Mark Howitt
	Created:	05/12/2003
	Inputs:		iNodeID - the node to look for
				iSiteID - the site to look in
	Outputs:	-
	Returns:	true if node level found, false if not
	Purpose:	Finds the tree level for a given node

*********************************************************************************/

bool CStoredProcedure::GetTreeLevelForNodeID(int iNodeID, int iSiteID)
{
	// Call the procedure
	StartStoredProcedure("GetTreeLevelForNodeID");
	AddParam("TaxNode",iNodeID);
	AddParam("SiteID",iSiteID);
	ExecuteStoredProcedure();
	if (HandleError("GetTreeLevelForNodeID"))
	{
		return false;
	}
	
	// Return the verdict
	return (!IsEOF());
}

/*********************************************************************************

	bool CStoredProcedure::GetTagLimitsForItem(int iTypeID)

	Author:		Mark Howitt
	Created:	17/12/2003
	Inputs:		iTypeID - The Type of limits you want to find
	Outputs:	-
	Returns:	true if a result is found, false if not
	Purpose:	Gets the limits for a given type of node

*********************************************************************************/

bool CStoredProcedure::GetTagLimitsForItem(int iTypeID)
{
	// Call the procedure
	StartStoredProcedure("GetTagLimitsForItem");
	AddParam("iArticleType",iTypeID);
	ExecuteStoredProcedure();
	if (HandleError("GetTagLimitsForItemAndSite"))
	{
		return false;
	}
	
	// Return the verdict
	return (!IsEOF());
}

/*********************************************************************************

	bool CStoredProcedure::GetTagLimitsForThread()

	Author:		Martin Robb
	Created:	13/04/2005
	Inputs:		None.
	Outputs:	-
	Returns:	False on error.
	Purpose:	Gets the tag limits for a thread

*********************************************************************************/

bool CStoredProcedure::GetTagLimitsForThread()
{
	// Call the procedure
	StartStoredProcedure("GetTagLimitsForThread");
	ExecuteStoredProcedure();
	if (HandleError("GetTagLimitsForThread"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTagLimitsForUser()

	Author:		Martin Robb
	Created:	05/05/2005
	Inputs:		None.
	Outputs:	-
	Returns:	False on error.
	Purpose:	Gets the tag limits for a user.

*********************************************************************************/

bool CStoredProcedure::GetTagLimitsForUser()
{
	// Call the procedure
	StartStoredProcedure("gettaglimitsforuser");
	ExecuteStoredProcedure();
	if (HandleError("GetTagLimitsForUser"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsUserAuthorisedToCreateVote(int iItemID, int iVoteType, int iUserID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iItemID - the ID of the item you want to create the vote for
				iVoteType - the type of vote you want
				iUserID - the id of the user trying to create the vote
	Outputs:	-
	Returns:	true if a result is found, false if not!
	Purpose:	

*********************************************************************************/

bool CStoredProcedure::IsUserAuthorisedToCreateVote(int iItemID, int iVoteType, int iUserID)
{
	// Call the procedure
	StartStoredProcedure("IsUserAuthorisedToCreateVote");
	AddParam("iItemID",iItemID);
	AddParam("iVoteType",iVoteType);
	AddParam("iUserID",iUserID);

	ExecuteStoredProcedure();
	if (HandleError("IsUserAuthorisedToCreateVote"))
	{
		return false;
	}
	
	// Return the verdict
	return (!IsEOF());
}

/*********************************************************************************

	bool CStoredProcedure::SetTagLimitForItem( int iItemType, int iNodeType, int iLimit, int iSiteID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iItemType - the type of item you want to set a limit for
				iNodeType - the type of node you are setting a limit for
				iSiteId - the id of the site which will have the limits set
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Sets the limits for a given nodetype and itemtype on a given site.

*********************************************************************************/

bool CStoredProcedure::SetTagLimitForItem( int iItemType, int iNodeType, int iLimit, int iSiteID)
{
	// Call the procedure depending on what the limits are.
	// -1 means delete the limit!
	if (iLimit == -1)
	{
		StartStoredProcedure("deletetaglimitforitem");
	}
	else
	{
		StartStoredProcedure("settaglimitforitem");
		AddParam("ilimit",iLimit);
	}

	AddParam("iitemtype",iItemType);
	AddParam("inodetype",iNodeType);
	AddParam("isiteid",iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("SetTagLimitForItem"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetTagLimitForThread( int iNodeType, int iLimit, int iSiteID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iNodeType - the type of node you are setting a limit for
				iSiteId - the id of the site which will have the limits set
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Sets the thread limits for a given nodetype and itemtype on a given site.

*********************************************************************************/

bool CStoredProcedure::SetTagLimitForThread( int iNodeType, int iLimit, int iSiteID )
{
	// Call the procedure depending on what the limits are.
	// -1 means delete the limit!
	if (iLimit == -1)
	{
		StartStoredProcedure("deletetaglimitforthread");
	}
	else
	{
		StartStoredProcedure("settaglimitforthread");
		AddParam("ilimit",iLimit);
	}

	AddParam("inodetype",iNodeType);
	AddParam("isiteid",iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("SetTagLimitForThread"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetTagLimitForUser(int iNodeType, int iLimit, int iSiteID)

	Author:		Martin Robb
	Created:	04/05/2005
	Inputs:		iNodeType - the type of node you are setting a limit for
				iSiteId - the id of the site which will have the limits set
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	Sets the user limits for a given nodetype on a given site.

*********************************************************************************/
bool CStoredProcedure::SetTagLimitForUser(int iNodeType,int iLimit,int iSiteID)
{
	// Call the procedure depending on what the limits are.
	// -1 means delete the limit!
	if (iLimit == -1)
	{
		StartStoredProcedure("deletetaglimitforuser");
	}
	else
	{
		StartStoredProcedure("settaglimitforuser");
		AddParam("ilimit",iLimit);
	}

	AddParam("inodetype",iNodeType);
	AddParam("isiteid",iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("SetTagLimitForUser"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTagLimitsForSite(const int iSiteID)

	Author:		Mark Howitt
	Created:	12/01/2004
	Inputs:		iSiteId - the id of the site you want ot get the limits for
	Outputs:	-
	Returns:	true if ok, false if not
	Purpose:	gets the current limits for a given site

*********************************************************************************/

bool CStoredProcedure::GetTagLimitsForSite(const int iSiteID)
{
	// Call the procedure
	StartStoredProcedure("GetTagLimitsForSite");
	AddParam("iSiteID",iSiteID);
	ExecuteStoredProcedure();
	if (HandleError("SetTagLimitForItem"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUserHierarchyNodes(int iUserID, int iSiteID)

		Author:		Mark Neves
        Created:	12/11/2004
        Inputs:		iUserID = user id
					iSiteID = the site ID
        Outputs:	-
        Returns:	true if ok, false if a disaster
        Purpose:	Finds all the hierarchy nodes that the user has attached objects to.
					i.e. all the nodes the user has tagged articles, clubs or their userpage

*********************************************************************************/

bool CStoredProcedure::GetUserHierarchyNodes(int iUserID, int iSiteID)
{
	StartStoredProcedure("GetUserHierarchyNodes");
	AddParam("UserID",iUserID);
	AddParam("SiteID",iSiteID);
	ExecuteStoredProcedure();
	if (HandleError("GetUserHierarchyNodes"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetMultipleHierarchyNodeDetails(CDNAIntArray& NodeArray,int i)

		Author:		Mark Neves
        Created:	17/11/2004
        Inputs:		NodeArray = an array on node IDs
					i = index to start looking through the array
        Outputs:	-
        Returns:	true if OK, false if not
        Purpose:	Gets the details for the nodes specified in the array of NodeIDs,
					starting from element i.

					This func will get details for a set of nodes.  The size of the set is
					fixed, but the caller should assume no knowledge on the size of the set.

					Starting from element i, it fetches node details for N nodes
					where N is the smaller of the number of remaining nodes in the array, 
					and the maximum set size.  Then it returns.

					The caller reads the result set.  If the result set is smaller than the 
					remaining nodes in the array, call again with i set to the next node in the
					array that needs fetching.  Continue until all nodes have been fetched.

*********************************************************************************/

bool CStoredProcedure::GetMultipleHierarchyNodeDetails(CDNAIntArray& NodeArray,int i)
{
	if (i < NodeArray.GetSize())
	{
		StartStoredProcedure("getmultiplehierarchynodedetails");
		for (int j=1;j <= 10 && i < NodeArray.GetSize();j++)
		{
			CTDVString sParamName = "Node";
			sParamName << CTDVString(j);
			AddParam(sParamName,NodeArray.GetAt(i++));
		}
        ExecuteStoredProcedure();

		if (HandleError("GetMultipleHierarchyNodeDetails"))
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateForumEvent(CDNAIntArray& iForums, int iAction, CTDVDateTime& dEventTime, int iEventType, int iDayType)

		Author:		Mark Howitt
		Created:	08/03/2004
		Inputs:		iForums - The list of forum ids you want to set the event for.
					iAction - The action the event will perform. 0 = close, 1 = open
					dEventTime - The time the event will be avtivated.
					iEventType - The type of event you want to create. 1 = recursive, 2 = one off
					iDayType - The Day type for the event. 0 - 6 = mon - sun, 7 = everyday
					bDeleteExistingEvents - A flag that states wether or not to delete all existing events
											for the forums before creating the new ones
		Outputs:	-
		Returns:	true if all went well
		Purpose:	Creates a new event for a given list of forums
		
*********************************************************************************/
bool CStoredProcedure::CreateForumEvent(CDNAIntArray& iForums, int iAction, CTDVDateTime& dEventTime, int iEventType, int iDayType, bool bDeleteExistingEvents)
{
	// Go through the forumids in blocks of 20 as this is the
	// max number of params the procedure can take at one time
	CTDVString sForum;
	for (int i = 0; i < iForums.GetSize(); i += 20)
	{
		// Call the procedure
		StartStoredProcedure("createforumevent");

		// Setup the params
		AddParam("daytype",iDayType);
		AddParam("eventtime",dEventTime);
		AddParam("eventtype",iEventType);
		AddParam("action",iAction);
		AddParam("deleteexisting",bDeleteExistingEvents);

		// Now add the forums from the array
		for (int j = i, k = 0; j < iForums.GetSize() && k < 20; j++,k++)
		{
			// Set the correct Param names for each forum
			sForum = "f";
			sForum << k;
			AddParam(sForum,(int)iForums[j]);
		}

		// Call the procedure
		ExecuteStoredProcedure();
		if (HandleError("CreateForumEvent"))
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetForumEventInfo(CDNAIntArray& iForums)

		Author:		Mark Howitt
        Created:	08/03/2004
        Inputs:		iForums - An Array of forums to get the info for.
        Outputs:	-
        Returns:	true if all ok
        Purpose:	Gets the event info for given forums

*********************************************************************************/
bool CStoredProcedure::GetForumEventInfo(CDNAIntArray& iForums)
{
	// Check to make sure we arn't being called with to many forumids
	if (iForums.GetSize() > 20 || iForums.GetSize() < 1)
	{
		TDVASSERT(false,"Too many or few forumids given limits are 1-20!!!");
		return false;
	}

	// Call the procedure
	StartStoredProcedure("GetForumEventInfo");

	// Add the forums from the array
	CTDVString sForum;
	for (int i = 0; i < iForums.GetSize(); i++)
	{
		// Set the correct Param names for each forum
		sForum = "F";
		sForum << i;
		int iDebug = iForums[i];
		AddParam(sForum,(int)iForums[i]);
	}

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetForumEventInfo"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteForumEvents(CDNAIntArray& iEvents)

		Author:		Mark Howitt
        Created:	08/03/2004
        Inputs:		iEvents - A List of Event ID's to delete
        Outputs:	-
        Returns:	true if ok
        Purpose:	Deletes a given number of events.

*********************************************************************************/
bool CStoredProcedure::DeleteForumEvents(CDNAIntArray& iEvents)
{
	// Go through the forumids in blocks of 20 as this is the
	// max number of params the procedure can take at one time
	CTDVString sEvent;
	for (int i = 0; i < iEvents.GetSize(); i += 20)
	{
		// Call the procedure
		StartStoredProcedure("deleteforumevent");

		// Add the forums from the array
		for (int j = i, k = 0; j < iEvents.GetSize(); j++, k++)
		{
			// Set the correct Param names for each forum
			sEvent = "e";
			sEvent << k;
			AddParam(sEvent,(int)iEvents[j]);
		}

		// Call the procedure
		ExecuteStoredProcedure();
		if (HandleError("DeleteForumEvent"))
		{
			return false;
		}
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteForumEventsMatching(CDNAIntArray&  iForums, int iAction, int iEventType, int iDayType)

		Author:		Mark Howitt
        Created:	21/04/2004
        Inputs:		iForums - A list of forum IDs to delete the events for
					iAction - The action to match against
					iEventType - The Event type to match against
					iDayType - the day type to match against
        Outputs:	-
        Returns:	treu if ok, false if not
        Purpose:	Deletes all the events that match the action, event type and daytype for
					the given list of forums.

*********************************************************************************/
bool CStoredProcedure::DeleteForumEventsMatching(CDNAIntArray&  iForums, int iAction, int iEventType, int iDayType)
{
	// Go through the forumids in blocks of 20 as this is the
	// max number of params the procedure can take at one time
	CTDVString sForum;
	for (int i = 0; i < iForums.GetSize(); i += 20)
	{
		// Call the procedure
		StartStoredProcedure("deleteforumeventsmatching");

		// Setup the params
		AddParam("daytype",iDayType);
		AddParam("eventtype",iEventType);
		AddParam("action",iAction);

		// Now add the forums from the array
		for (int j = i, k = 0; j < iForums.GetSize() && k < 20; j++,k++)
		{
			// Set the correct Param names for each forum
			sForum = "f";
			sForum << k;
			AddParam(sForum,(int)iForums[j]);
		}

		// Call the procedure
		ExecuteStoredProcedure();
		if (HandleError("DeleteForumEventsMatching"))
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetForumActiveStatus(CDNAIntArray& iForums, int iActive)

		Author:		Mark Howitt
        Created:	08/03/2004
        Inputs:		iForums - An Array of ForumID's to set the active flag for.
					iActive - The new Active state for the forums.
        Outputs:	-
        Returns:	true if ok
        Purpose:	Sets the active flag for the given forums. This is used to
					shutdown or re-open

*********************************************************************************/
bool CStoredProcedure::SetForumActiveStatus(CDNAIntArray& iForums, int iActive)
{
	// Go through the forumids in blocks of 20 as this is the
	// max number of params the procedure can take at one time
	CTDVString sForum;
	for (int i = 0; i < iForums.GetSize(); i += 20)
	{
		// Call the procedure
		StartStoredProcedure("SetForumsActiveStatus");

		// Add the forums from the array
		for (int j = i, k = 0; j < iForums.GetSize() && k < 20; j++, k++)
		{
			// Set the correct Param names for each forum
			sForum = "F";
			sForum << k;
			AddParam(sForum,(int)iForums[j]);
		}
		AddParam("Active", iActive);

		// Call the procedure
		ExecuteStoredProcedure();
		if (HandleError("SetForumActiveStatus"))
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RunScheduledForumEvents(void)

		Author:		Mark Howitt
        Created:	08/03/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if all ok
        Purpose:	Runs the scheduled events for all forums in the
					ForumScheduledEvents Table.

*********************************************************************************/
bool CStoredProcedure::RunScheduledForumEvents(void)
{
	// Call the procedure
	StartStoredProcedure("RunScheduledForumEvents");

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("RunScheduledForumEvents"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::SetThreadVisibleToUsers(int iThread, int iForumID, bool bVisible)

		Author:		Mark Howitt
        Created:	17/03/2004
        Inputs:		iThreadID - the id of the thread you want to make visible or not.
					iForumID - the id of the forum that the thread belongs to.
					bVisible - the flag that states wether or not the thread is visible.
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Sets the visible state for a given thread.

*********************************************************************************/
bool CStoredProcedure::SetThreadVisibleToUsers(int iThread, int iForumID, bool bVisible)
{
	// Start the procedure
	StartStoredProcedure("SetThreadVisibletoUsers");

	// Add the params
	AddParam("ThreadID",iThread);
	AddParam("ForumID",iForumID);
	AddParam("Visible",bVisible);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetThreadVisibleToUsers"))
	{
		return false;
	}

	return true;
}

// Set the 'archive' status of this article - whether the forum attached to the article is 'read-only'
bool CStoredProcedure::SetArticleForumArchiveStatus(int iH2G2ID, bool bArchive)
{
	StartStoredProcedure("setarticleforumarchivestatus");
	AddParam("h2g2id",iH2G2ID);
	if (bArchive)
	{
		AddParam("archivestatus", 1);
	}
	else
	{
		AddParam("archivestatus",0);
	}
	ExecuteStoredProcedure();
	if (HandleError("SetArticleForumArchiveStatus"))
	{
		return false;
	}

	return true;
}

// Gets the status based on the forum attached to the article
bool CStoredProcedure::GetArticleForumArchiveStatus(int iH2G2ID, bool& bArchive)
{
	bArchive = false;
	StartStoredProcedure("getarticleforumarchivestatus");
	AddParam("h2g2id",iH2G2ID);
	ExecuteStoredProcedure();
	if (HandleError("SetArticleForumArchiveStatus") || IsEOF())
	{
		return false;
	}

	int iStatus = GetIntField("ArchiveStatus");
	if (iStatus == 1)
	{
		bArchive = true;
	}
	else
	{
		bArchive = false;
	}

	return true;
}

/*********************************************************************************
bool CStoredProcedure::DeleteArticleFromAllNodes(int ih2g2Id, int iSiteId, 
	const char* pNodeTypeName)

Author:		Igor Loboda
Created:	14/05/2003
Inputs:		ih2g2Id - article h2g2id
			iSiteId - site id
			pNoteTypeName - e.g. 'Location'
Returns:	true if item was detached from hierarchy nodes
Purpose:	detaches specified item from all hierarchy nodes of a given type
			Note: works for articles only, not for clubs
*********************************************************************************/

bool CStoredProcedure::DeleteArticleFromAllNodes(int ih2g2Id, int iSiteId, const char* pNodeTypeName = NULL)
{
	// Start the procedure
	StartStoredProcedure("deletearticlefromallnodes");

	// Add the params
	AddParam("h2g2id", ih2g2Id);
	AddParam("siteId", iSiteId);
	if ( pNodeTypeName )
		AddParam("nodeTypeName", pNodeTypeName);

	// Now execute the procedure
	ExecuteStoredProcedure();
	return !HandleError("DeleteTagItemFromAllNodes");
}

/*********************************************************************************

	bool CStoredProcedure::DeleteUserFromAllNodes(int iUserID, int iSiteID, const TDVCHAR* pNodeType)

		Author:		Mark Howitt
        Created:	28/10/2005
        Inputs:		iUserID - The Id of the user you want to remove from all the nodes
					iSiteID - The site that the node bel;ong to
					pNodeType - the type of node that you want to remove the user form
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes a given users from all nodes of a site of a given type.
					i.e. pNodeType = 'Location'

*********************************************************************************/
bool CStoredProcedure::DeleteUserFromAllNodes(int iUserID, int iSiteID, const TDVCHAR* pNodeTypeName = NULL)
{
	// Start the procecdure
	StartStoredProcedure("deleteuserfromallnodes");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	if ( pNodeTypeName ) 
		AddParam("nodetypename",pNodeTypeName);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteUserFromAllNodes"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteThreadFromAllNodes(int iUserID, int iSiteID )

		Author:		Martin Robb
        Created:	23/11/2005
        Inputs:		iUserID - The Id of the user you want to remove from all the nodes
					iSiteID - The site that the node bel;ong to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes thread from all hierarchy nodes.

*********************************************************************************/
bool CStoredProcedure::DeleteThreadFromAllNodes(int iThreadID, int iSiteID )
{
	// Start the procecdure
	StartStoredProcedure("deletethreadfromallnodes");

	// Setup the params
	AddParam("threadid",iThreadID);
	//AddParam("siteid",iSiteID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteThreadFromAllNodes"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteClubFromAllNodes(int iUserID, int iSiteID, const TDVCHAR* pNodeType)

		Author:		Martin Robb
        Created:	23/11/2006
        Inputs:		iUserID - The Id of the user you want to remove from all the nodes
					iSiteID - The current site.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes club from all hierarchy nodes.

*********************************************************************************/
bool CStoredProcedure::DeleteClubFromAllNodes( int iClubID, int iSiteID )
{
	// Start the procecdure
	StartStoredProcedure("deleteclubfromallnodes");

	// Setup the params
	AddParam("clubid",iClubID);
	//AddParam("siteid",iSiteID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteClubFromAllNodes"))
	{
		return false;
	}
	return true;
}


/*********************************************************************************
bool CStoredProcedure::GetHierarchyCloseNodes(int iNodeId, int iBaseLine)	
Author:		Igor Loboda
Created:	13/07/2004
Inputs:		iNodeId - hierarchy node id
			iBaseLine - BaseLine field value corresponding to given hierarchy node
Returns:	true on success
Purpose:	returns list of close nodes
*********************************************************************************/

bool CStoredProcedure::GetHierarchyCloseNodes(int iNodeId, int iBaseLine)	
{
	StartStoredProcedure("GetHierarchyCloseNodes");
	AddParam(iNodeId);
	AddParam(iBaseLine);
	ExecuteStoredProcedure();
	return !HandleError("GetHierarchyCloseNodes");
}


/*********************************************************************************
bool CStoredProcedure::GetTaggedContent(int iMaxRows, int iSort, const char* pIdes)
Author:		Igor Loboda
Created:	13/07/2004
Inputs:		iMaxRows - max number of rows to return
			iSort - says how to sort the resultset
			pIdes - string of '|' separated hierarchy nodes ides			
Returns:	true on success
Purpose:	returns up to iMaxRows articles and clubs tagged to any of given nodes
*********************************************************************************/

bool CStoredProcedure::GetTaggedContent(int iMaxRows, int iSort, const char* pIdes)
{
	StartStoredProcedure("GetTaggedContent");
	AddParam("maxRows", iMaxRows);
	AddParam("sort", iSort);
	AddParam("hierarchyNodes", pIdes);
	AddParam("currentsiteid", m_SiteID);
	ExecuteStoredProcedure();
	return !HandleError("GetTaggedContent");
}

/*********************************************************************************

	bool CStoredProcedure::GetTaggedContentForNode(int iMaxRows, int iNodeID)

		Author:		Mark Neves
		Created:	12/04/2007
		Inputs:		iMaxRows = the max num rows the SP should return
					iNodeID = the node in question
		Outputs:	-
		Returns:	true if OK, false otherwise
		Purpose:	Returns the CLOSEMEMBER nodes for the given node.  It combines the functionality of
					GetHierarchyCloseNodes() and GetTaggedContent() into one SP, making it more efficient

*********************************************************************************/

bool CStoredProcedure::GetTaggedContentForNode(int iMaxRows, int iNodeID)
{
	StartStoredProcedure("GetTaggedContentForNode");
	AddParam("maxRows", iMaxRows);
	AddParam("nodeid", iNodeID);
	AddParam("siteid", m_SiteID);
	ExecuteStoredProcedure();
	return !HandleError("GetTaggedContentForNode");
}

/*********************************************************************************

	bool CStoredProcedure::GetGroupMembersForGroup(const TDVCHAR* psGroupName, int iSiteID)

		Author:		Mark Howitt
        Created:	14/07/2004
        Inputs:		psGroupName - The name of the group you want to find the members of.
					iSiteID - the ID of the site you want to frin the members on
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Finds all the members for the given groupname and siteid.

*********************************************************************************/
bool CStoredProcedure::GetGroupMembersForGroup(const TDVCHAR* psGroupName, int iSiteID)
{
	// Start the procedure
	StartStoredProcedure("GetGroupMembersForGroupOnSite");

	// Add the params
	AddParam("GroupName",psGroupName);
	AddParam("SiteID",iSiteID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetGroupMembersForGroup"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetMatchingUserAccounts(const TDVCHAR* psFirstNames, const TDVCHAR* psLastName, const TDVCHAR* psEmail)

		Author:		Mark Howitt
        Created:	23/07/2004
        Inputs:		psFirstNames - The first names to try and match.
					psLatName - The last name to try and match.
					psEmail - The email address to try and match on.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Tries to find matching account based on matching firstnames and last name OR
					by matching emails.

*********************************************************************************/
bool CStoredProcedure::GetMatchingUserAccounts(const TDVCHAR* psFirstNames, const TDVCHAR* psLastName, const TDVCHAR* psEmail)
{
	// Start the procedure
	StartStoredProcedure("GetMatchingUserAccounts");

	// Add the params
	AddParam("FirstNames",psFirstNames);
	AddParam("LastName",psLastName);
	AddParam("Email",psEmail);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetMatchingUserAccounts"))
	{
		return false;
	}

	return true;
}



bool CStoredProcedure::GetCurrentGuideEntryBatchIDs(int iFirstInBatch, CTDVDateTime* p_dMoreRecentThan)
{
	StartStoredProcedure("GetCurrentGuideEntriesInBatch");
	AddParam(iFirstInBatch);
	if(p_dMoreRecentThan != NULL)
	{
		AddParam(*p_dMoreRecentThan);
	}
	else
	{
		AddNullParam();
	}
	ExecuteStoredProcedure();
	if (HandleError("GetCurrentGuideEntriesInBatch"))
	{
		return false;
	}

	return !IsEOF();
}



/*********************************************************************************
bool CStoredProcedure::GetProfanityGroupList(const int iGroupId)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		iGroupId - ID of group you want the sites for, or 0 for all
Outputs:	-
Returns:	true if ok, false if not
Purpose:	Finds profanity groups and sites that belong to them
*********************************************************************************/

bool CStoredProcedure::GetProfanityGroupList(const int iGroupId)
{
	// Start the procedure
	StartStoredProcedure("GetProfanityGroupList");

	// Add the params
	AddParam("GroupID", iGroupId);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetProfanityGroupList"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************
bool CStoredProcedure::CreateNewProfanityGroup(const TDVCHAR* pGroupName)
Author:		David van Zijl
Created:	02/08/2004
Inputs:		pGroupName - Name of new group
Outputs:	iGroupId - ID of newly created group or old group is name already exists
			bAlreadyExists - True if name already exists in database
Returns:	true if ok, false if not
Purpose:	Inserts new group into DB
*********************************************************************************/

/*
bool CStoredProcedure::CreateNewProfanityGroup(const TDVCHAR* pGroupName)
{
	StartStoredProcedure("createnewprofanitygroup");
	AddParam("groupname", pGroupName);
	ExecuteStoredProcedure();

	if (HandleError("CreateNewProfanityGroup"))
	{
		return false;
	}

	return true;
}
*/

/*********************************************************************************

	bool CStoredProcedure::GetTopics

	Author:		Martin Robb
	Created:	29/10/04
	Inputs:		TopicStatus (defaults to 'LIVE'), SiteID ( defaults to 0 meaning all Sites)
	Outputs:	NA
	Returns:	true if topics found
	Purpose:	Defaults to finding live topics for all sites unless parameters specified

*********************************************************************************/

bool CStoredProcedure::GetTopics( int iTopicStatus, int iSiteID )
{
	StartStoredProcedure("getTopicDetails");
	AddParam("TopicStatus",iTopicStatus);
	AddParam("SiteID", iSiteID);
	ExecuteStoredProcedure();
	if (HandleError("GetTopics"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetTopicForumIDs( int iTopicStatus, int iSiteID )
{
	StartStoredProcedure("getTopicForumIDs");
	AddParam("TopicStatus",iTopicStatus);
	AddParam("SiteID", iSiteID);
	ExecuteStoredProcedure();
	if (HandleError("GetTopicForumIDs"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveUsersVote(iVoteID,iUserID)

		Author:		Mark Howitt
        Created:	06/08/2004
        Inputs:		iVoteID - The id of the vote you want to remove the vote on.
					iUserID - the id of the user you want to remove the vote.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes a users vote fpor a given voteid

*********************************************************************************/
bool CStoredProcedure::RemoveUsersVote(int iVoteID, int iUserID)
{
	// Start the procedure
	StartStoredProcedure("RemoveUsersVote");

	// Add the params
	AddParam("VoteID",iVoteID);
	AddParam("UserID",iUserID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("RemoveUsersVote"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAlertsToSend()

		Author:		Mark Howitt
        Created:	16/02/2007
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Fetches all the alerts to send from the EmailAlertQueue.

*********************************************************************************/
bool CStoredProcedure::GetAlertsToSend()
{
	// Start the procedure
	StartStoredProcedure("GetAlertsToSend");

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetAlertsToSend"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddToEventQueue(EventType eET,int iUserID,int iItemID,int iItemType)

		Author:		Mark Neves
        Created:	18/08/2004
        Inputs:		eET = the event type
					iItemID = the ID of the item the event is associated with (e.g. h2g2id)
					iItemType = the type of ID iItemID is
					iItemID2 = the ID an item that is linked with the event
					iItemType2 = the type of ID iItemID2 is
        Outputs:	-
        Returns:	true if OK
        Purpose:	Adds an event to the event queue

*********************************************************************************/

bool CStoredProcedure::AddToEventQueue(int iET,int iUserID,int iItemID,int iItemType,int iItemID2,int iItemType2)
{
	// Start the procedure
	StartStoredProcedure("addtoeventqueue");

	// Add the params
	AddParam("EventType",iET);
	AddParam("eventuserid",iUserID);
	AddParam("ItemID",iItemID);
	AddParam("ItemType",iItemType);
	AddParam("ItemID2",iItemID2);
	AddParam("ItemType2",iItemType2);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddToEventQueue"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteAllFromEventQueue()

		Author:		Mark Neves
        Created:	25/08/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if OK
        Purpose:	Deletes all events from the event queue

*********************************************************************************/
bool CStoredProcedure::DeleteAllFromEventQueue()
{
	// Start the procedure
	StartStoredProcedure("deleteallfromeventqueue");

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteAllFromEventQueue"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteEMailEventsForUserAndSite(int iUserID, int iSiteID, int iEMailType, int iNotifyType)

		Author:		Mark Neves
        Created:	26/08/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::DeleteEMailEventsForUserAndSite(int iUserID, int iSiteID, int iEMailType, int iNotifyType)
{
	// Start the procedure, check to see what type of list we're trying to use
	if (iEMailType == 1)
	{
		StartStoredProcedure("deleteemaileventsforuserandsite");
	}
	else if (iEMailType == 2)
	{
		StartStoredProcedure("deleteinstantemaileventsforuserandsite");
	}
	else
	{
		TDVASSERT(false,"Invalid EMail Alert List Type Given!!!");
		return false;
	}

	// Add the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	AddParam("notifytype",iNotifyType);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteAllFromEventQueue"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteByDateFromEventQueue(CTDVDateTime* p_dDate)

		Author:		Nick Stevenson
        Created:	14/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::DeleteByDateFromEventQueue(CTDVDateTime* p_dDate)
{
	StartStoredProcedure("deletebydatefromeventqueue");

	AddParam(*p_dDate);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteByDateFromEventQueue"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SearchArticlesNew(const TDVCHAR* sSearchWords, bool bShowApproved, bool bShowNormal, bool bShowSubmitted, bool bUseANDSearch, int iSiteID, int iCategory)

		Author:		Mark Howitt
        Created:	13/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	New Search procedure!

*********************************************************************************/
bool CStoredProcedure::SearchArticlesNew(const TDVCHAR* sSearchWords, bool bShowApproved, bool bShowNormal, bool bShowSubmitted, bool bUseANDSearch, int iSiteID, int iCategory, int iMaxResults)
{
	StartStoredProcedure("SearchArticlesAdvanced2");

	AddParam("KeyWords",sSearchWords);
	AddParam("ShowSubmitted",bShowSubmitted);
	AddParam("ShowNormal",bShowNormal);
	AddParam("ShowApproved",bShowApproved);
	AddParam("SiteID",iSiteID);
	AddParam("UseANDSearch",bUseANDSearch);
	if (iCategory > 0)
	{
		AddParam("WithinCategory",iCategory);
	}
	AddParam("MaxResults",iMaxResults);
	
	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("SearchArticlesNew"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	int CStoredProcedure::GetUpdateBits()

		Author:		Nick Stevenson
        Created:	14/09/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

int CStoredProcedure::GetUpdateBits()
{
	return m_iUpdateBits;
}

bool CStoredProcedure::UpdateForumAlertInstantly(int iAlertInstantly, int iForumID)
{

	StartStoredProcedure("UpdateForumAlertInstantly");

	AddParam("alert",iAlertInstantly);
	AddParam("forumid",iForumID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("UpdateForumAlertInstantly"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetForumDetails(int iItemID, int iItemType, int iUserID)

		Author:		Mark Howitt
        Created:	20/09/2004
        Inputs:		iItemID -  The id of the item you want to use to get the forum details for.
					iItemType - The type of item you want to use. This can be IT_FORUM, IT_THREAD or IT_POST
					iUserID - A UserID so that the IsUsersPvtForum flag can be set
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the details for the forum using either the forumid, threadid or postid

*********************************************************************************/
bool CStoredProcedure::GetForumDetails(int iItemID, int iItemType, int iUserID)
{
	// Start the procedure
	StartStoredProcedure("GetForumDetails");

	// Add the item id and type
	AddParam("ItemID",iItemID);
	AddParam("ItemType",iItemType);
	AddParam("UserID",iUserID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetForumDetails"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUsersEmailAlertSubscriptionForItem(int iUserID, int iItemID, int iItemType)

		Author:		Mark Howitt
        Created:	27/09/2004
        Inputs:		iUserID - The ID of the user you want to find the subsciptions for.
					iItemID - the ID of the item to check for.
					iItemType - THe type of item you want to check for
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Finds what subscriptions the user has for the given forumID.

*********************************************************************************/
bool CStoredProcedure::GetUsersEmailAlertSubscriptionForItem(int iUserID, int iForumID, int iItemType)
{
	// Start the procedure
	StartStoredProcedure("getusersemailalertsubscriptionforitem");

	// Add the params
	AddParam("UserID",iUserID);
	AddParam("ItemID",iForumID);
	AddParam("ItemType",iItemType);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetUsersEmailAlertSubscriptionForItem"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CheckEMailAlertStatus(int iInstantTimeRange, int iNormalTimeRange)

		Author:		Mark Howitt
        Created:	30/09/2004
        Inputs:		iInstantTimeRange - The time range in mins that instant emails are valid.
					iNormalTimeRange - The time range in hours that normal emails are valid.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Checks the status of the email event queue to make sure there
					are no over due emails. This can be caused by the email server being down,
					user email invalid and other errors.

*********************************************************************************/
bool CStoredProcedure::CheckEMailAlertStatus(int iInstantTimeRange, int iNormalTimeRange)
{
	// Start the procedure
	StartStoredProcedure("checkemailalertstatus");

	// Add the params
	AddParam("iinstanttimerange",iInstantTimeRange);
	AddParam("inormaltimerange",iNormalTimeRange);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("CheckEMailAlertStatus"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetBREAKAndPARABREAKArticles()

		Author:		Mark Neves
        Created:	04/10/2004
        Inputs:		-
        Outputs:	-
        Returns:	true if OK, false otherwise
        Purpose:	Interface to getBREAKandPARABREAKarticles

*********************************************************************************/

bool CStoredProcedure::GetBREAKAndPARABREAKArticles()
{
	// Start the procedure
	StartStoredProcedure("getBREAKandPARABREAKarticles");
	ExecuteStoredProcedure();
	if (HandleError("GetBREAKAndPARABREAKArticles"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetForumStyle(int iForumID)

		Author:		David Williams
        Created:	25/10/2004
        Inputs:		iForumID - the unique id of the forum
		Outputs:	-
        Returns:	true if executed successfully, false otherwise
        Purpose:	Get the style of the forum. Removing the restriction that there
					is a single forum style per A page. Forums table upgraded to 
					keep track of it's current style (discussion or comment). Defaults
					to the site default value.

*********************************************************************************/

bool CStoredProcedure::GetForumStyle(int iForumID)
{
	StartStoredProcedure("getforumstyle");
	AddParam("ForumID", iForumID);
	ExecuteStoredProcedure();
	if (HandleError("GetForumStyle"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateFrontPageElement(int iSiteID, int iElementType, int iElementStatus, int iElementLinkID, int iFrontPagePos)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		iSiteID - the site which the new element belongs to.
					iUserID - Editing user.
					iElementType - the type of element to create.
					iElemenetStatus - The Status of the new element.
					iElementLinkID - The link id for the new element, 0 = non.
					iFrontPagePos - The position on the frontpage, 0 = auto placement
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates a new frontpage element of given type and status for a given site.
					The optional elemenet link id is for creating new live elements
					so that they can have the link to the preview element.

*********************************************************************************/
bool CStoredProcedure::CreateFrontPageElement(int iSiteID, int iUserID, int iElementType, int iElementStatus, int iElementLinkID, int iFrontPagePos)
{
	// Start by checking what type of element we are trying to create
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("createtopicelement");
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("createtextboxelement");
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("createboardpromoelement");
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::CreateFrontPageElement - Invalid Element Type Given!!!");
		return false;
	}

	AddParam("siteid", iSiteID);
	AddParam("userid", iUserID);
	AddParam("elementstatus",iElementStatus);
	AddParam("elementlinkid",iElementLinkID);
	AddParam("frontpageposition",iFrontPagePos);
	ExecuteStoredProcedure();
	if (HandleError("CreateFrontPageElement"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteFrontPageElement(int iElementID, int iElementType)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		iElenetID - The Id of the element you want to delete
					iElementType - the type of element you are teying to delete.
								   used as a sanity check
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Marks the given element as deleted in the front page elements table.

*********************************************************************************/
bool CStoredProcedure::DeleteFrontPageElement(int iElementID, int iElementType, int iUserID )
{
		// Start by checking what type of element we are trying to create
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("deletetopicelement");
		AddParam("topicelementid",iElementID);
		AddParam("userid",iUserID);
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("deletetextboxelement");
		AddParam("textboxelementid",iElementID);
		AddParam("userid",iUserID);
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("deleteboardpromoelement");
		AddParam("boardpromoelementid",iElementID);
		AddParam("userid",iUserID);
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::DeleteFrontPageElement - Invalid Element Type Given!!!");
		return false;
	}

	ExecuteStoredProcedure();
	if (HandleError("DeleteFrontPageElement"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::StartUpdateFrontPageElement(int iElementID, int iElementType, int iUserId )

		Author:		Mark Howitt
        Created:	02/11/2004
        Inputs:		iElementID - the id of the element you are about to update
					iElementType - The Type of element we are updating. 
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Starts the update procedure for a given element id

*********************************************************************************/
bool CStoredProcedure::StartUpdateFrontPageElement(int iElementID, int iElementType )
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("UpdateTopicElement");
		AddParam("TopicElementID",iElementID);
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("UpdateTextBoxElement");
		AddParam("TextBoxElementID",iElementID);
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("UpdateBoardPromoElement");
		AddParam("BoardPromoElementID",iElementID);
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::StartUpdateFrontPageElement - Incorrect Element Type given!");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateFrontPageElement(const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	02/11/2004
        Inputs:		psEditKey - The unique edit key for the element.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Commits all changes to the element.

*********************************************************************************/
bool CStoredProcedure::UpdateFrontPageElement(int iUserID, const TDVCHAR* psEditKey)
{
	AddParam("editorid", iUserID );

	// Add the UID to the param list
	if (!AddUIDParam("EditKey",psEditKey))
	{
		return false;
	}

	// Execute the procedure and check for errors
	ExecuteStoredProcedure();
	if (HandleError("UpdateFrontPageElement"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementTopicID(int iTopicID)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the TopicID for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementTopicID(int iTopicID)
{
	// Add the param to the procedure
	AddParam("TopicID",iTopicID);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementTemplateType(int iTemplateType)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Template Type for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementTemplateType(int iTemplateType)
{
	// Add the param to the procedure
	AddParam("TemplateType",iTemplateType);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementTextBoxType(int iTextBoxType)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the TextBox Type for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementTextBoxType(int iTextBoxType)
{
	// Add the param to the procedure
	AddParam("TextBoxType",iTextBoxType);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementBorderType(int iBorderType)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Text Border Type for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementBorderType(int iBorderType)
{
	// Add the param to the procedure
	AddParam("TextBorderType",iBorderType);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementPosition(int iPosition)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the FrontPage Position for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementPosition(int iPosition)
{
	// Add the param to the procedure
	AddParam("FrontPagePosition",iPosition);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementStatus(int iStatus)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Element Status for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementStatus(int iStatus)
{
	// Add the param to the procedure
	AddParam("ElementStatus",iStatus);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementLinkID(int iLinkID)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Element Link ID for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementLinkID(int iLinkID)
{
	// Add the param to the procedure
	AddParam("ElementLinkID",iLinkID);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementTitle(const TDVCHAR* psTitle)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Title for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementTitle(const TDVCHAR* psTitle)
{
	// Add the param to the procedure
	AddParam("Title",psTitle);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementText(const TDVCHAR* psText)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Text for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementText(const TDVCHAR* psText)
{
	// Add the param to the procedure
	AddParam("Text",psText);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementImageName(const TDVCHAR* psImageName)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Image Name for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementImageName(const TDVCHAR* psImageName)
{
	// Add the param to the procedure
	AddParam("ImageName",psImageName);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementImageAltText(const TDVCHAR* psImageAltText)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the Image Alt Text for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementImageAltText(const TDVCHAR* psImageAltText)
{
	// Add the param to the procedure
	AddParam("ImageAltText",psImageAltText);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementImageWidth(int iImageWidth)

		Author:		Mark Howitt
        Created:	16/02/2005
        Purpose:	Sets the ImageWidth for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementImageWidth(int iImageWidth)
{
	// Add the param to the procedure
	AddParam("ImageWidth",iImageWidth);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementImageHeight(int iImageHeight)

		Author:		Mark Howitt
        Created:	16/02/2005
        Purpose:	Sets the ImageHeight for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementImageHeight(int iImageHeight)
{
	// Add the param to the procedure
	AddParam("ImageHeight",iImageHeight);
}

/*********************************************************************************

	void CStoredProcedure::SetFPElementUseNoOfPosts(int iUseNoOfPosts)

		Author:		Mark Howitt
        Created:	02/11/2004
        Purpose:	Sets the UseNoOfPosts Flag for an element. The element is given in the
					UpdateFrontPageelement() function!

*********************************************************************************/
void CStoredProcedure::SetFPElementUseNoOfPosts(int iUseNoOfPosts)
{
	// Add the param to the procedure
	AddParam("UseNoOfPosts",iUseNoOfPosts);
}

void CStoredProcedure::SetFPElementTemplateTypeToAllInSite(bool bApplyTemplateToAllInSite)
{
	// Add the param to the procedure
	AddParam("ApplyTemplateToAllInSite",bApplyTemplateToAllInSite);
}

/*********************************************************************************

	bool CStoredProcedure::GetFrontPageElementsForSiteID(int iSiteID, int iElementType, int iElementStaus, int iElementStatus2 = -1)

		Author:		Mark Howitt
        Created:	02/11/2004
        Inputs:		iSiteID - The site that you want to get the elements for.
					iElementType - the type of elements you want to get. 0 = Topics, 1 = Textboxes
					iElementStatus - The Status of the elements you want to get! 0 = live, 1 = preview.
					int iElementStatus2 - Optional param. Used if you require a list of more than one status type.
							e.g. Used by the make active code so it gets preview and archivepreview status elements
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets all the elements of a given type for a given site.

*********************************************************************************/
bool CStoredProcedure::GetFrontPageElementsForSiteID(int iSiteID, int iElementType, int iElementStaus, int iElementStatus2)
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("GetTopicElementsForSite");
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("GetTextBoxElementsForSite");
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("GetBoardPromoElementsForSite");
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::GetFrontPageElementsForSiteID - Incorrect Element Type given!");
		return false;
	}

	AddParam("SiteID", iSiteID);
	AddParam("ElementStatus",iElementStaus);

	// See if we are required to find elements of a different status as well.
	if (iElementStatus2 > 0 && iElementStatus2 < 5)
	{
		AddParam("ElementStatus2",iElementStatus2);
	}

	ExecuteStoredProcedure();
	if (HandleError("GetFrontPageElementsForSite"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetFrontPageElementsForSiteID(int iSiteID, int iElementType, int iElementStaus, int iElementStatus2 = -1)

		Author:		Mark Howitt
        Created:	02/11/2004
        Inputs:		iSiteID - The site that you want to get the elements for.
					iElementType - the type of elements you want to get. 0 = Topics, 1 = Textboxes
					iElementStatus - The Status of the elements you want to get! 0 = live, 1 = preview.
					int iElementStatus2 - Optional param. Used if you require a list of more than one status type.
							e.g. Used by the make active code so it gets preview and archivepreview status elements
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets all the elements of a given type for a given site.

*********************************************************************************/
bool CStoredProcedure::GetFrontPageElementsForPhrases(int iSiteID, const std::vector<PHRASE>& lphrases, int iElementType, int iElementStatus )
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("GetTextBoxElementsForPhrases");
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("GetBoardPromoElementsForPhrases");
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::GetFrontPageElementsForPhrase - Incorrect Element Type given!");
		return false;
	}

	AddParam("SiteID", iSiteID);
	//AddParam("ElementStatus",iElementStaus);

	// See if we are required to find elements of a different status as well.
	//if (iElementStatus2 > 0 && iElementStatus2 < 5)
	//{
	//	AddParam("ElementStatus2",iElementStatus2);
	//}

	//Ceate a comma separated list
	CTDVString sphrases;
	for ( std::vector<PHRASE>::const_iterator iter = lphrases.begin(); iter != lphrases.end(); ++iter )
	{
		sphrases << (sphrases.IsEmpty() ?  "" : "|") << iter->m_Phrase;
	}

	if ( !sphrases.IsEmpty() )
	{
		AddParam("keyphraselist", sphrases);
	}

	AddParam("ElementStatus", iElementStatus);
	ExecuteStoredProcedure();
	if (HandleError("GetFrontPageElementsForPhrase"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetFrontPageElementDetails(int iElementID, int iElementType)

		Author:		Mark Howitt
        Created:	03/11/2004
        Inputs:		iElementID - the id of the element you want to get the details for
					iElementType - The type of element you want to get the details for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets the details for the given frontpage element.

*********************************************************************************/
bool CStoredProcedure::GetFrontPageElementDetails(int iElementID, int iElementType)
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("GetTopicElementDetails");
		AddParam("TopicElementID",iElementID);
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("GetTextBoxDetails");
		AddParam("TextBoxElementID",iElementID);
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("GetBoardPromoDetails");
		AddParam("BoardPromoElementID",iElementID);
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::StartUpdateFrontPageElement - Incorrect Element Type given!");
		return false;
	}

	ExecuteStoredProcedure();
	if (HandleError("GetFrontPageElementDetails"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetFrontPageElementKeyPhrases( int iSiteId, int iElementType, int iElementID, int* pDefault )

		Author:		Mark Robb
        Created:	1/9/2005
        Inputs:		- 
        Outputs:	-
        Returns:	-
        Purpose:	- Usess an uoutput paam to indicate that board promo is a default site board promo. 

*********************************************************************************/
bool CStoredProcedure::GetFrontPageElementKeyPhrases( int iSiteId, int iElementType, int iElementID, int* pDefault )
{
	if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("getboardpromoelementkeyphrases",false);
		AddParam("siteid", iSiteId);
		AddParam("boardpromoelementid", iElementID);
		if ( pDefault != NULL ) 
			AddOutputParam(pDefault);
		ExecuteStoredProcedure();
	}
	else if ( iElementType == CFrontPageElement::ET_TEXTBOX )
	{
		StartStoredProcedure("gettextboxelementkeyphrases",false);
		AddParam("siteid", iSiteId);
		AddParam("textboxelementid", iElementID);
		ExecuteStoredProcedure();
	}

	if ( HandleError("GetFrontPageElementKeyPhrases") )
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::PostPrivateAlertMessage(int iSendToUserID, int iSiteID, const TDVCHAR* psSubject, const TDVCHAR* psMessage)

		Author:		Mark Howitt
        Created:	11/11/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::PostPrivateAlertMessage(int iSendToUserID, int iSiteID, const TDVCHAR* psSubject, const TDVCHAR* psMessage)
{
	// Start the procedure
	StartStoredProcedure("PostPrivateAlertMessage");

	// Get the current date
	CTDVString sDate;
	CTDVDateTime Date;
	Date.GetCurrentTime();
	Date.GetAsString(sDate);

	// Generate a hash value for the post
	CTDVString sHash;
	CTDVString sSource;
	sSource << iSendToUserID << "<:>" << iSiteID << "<:>" << psSubject << "<:>" << psMessage << "<:>" << sDate;
	GenerateHash(sSource, sHash);

	// Add the params, if any
	AddParam("SendToUserID", iSendToUserID);
	AddParam("SiteID",iSiteID);
	AddParam("Subject",psSubject);
	AddParam("Message", psMessage);

	// Add the UID to the param list
	if (!AddUIDParam("hash",sHash))
	{
		return false;
	}

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("PostPrivateAlertMessage"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SendDNASystemMessage(int piSendToUserID, int piSiteID, const TDVCHAR* psMessageBody)

		Author:		James Conway
        Created:	11/05/2006
        Inputs:		piSendToUserID - UserID of message recipient
					piSiteID - SiteID message is associated with
					psMessageBody - Message body
        Outputs:	-
        Returns:	SP's @@Error int
        Purpose:	Posts a system message to user. 

*********************************************************************************/
bool CStoredProcedure::SendDNASystemMessage(int piSendToUserID, int piSiteID, const TDVCHAR* psMessageBody)
{
	// Start the procedure
	StartStoredProcedure("senddnasystemmessage");

	// Add the params
	AddParam("userid", piSendToUserID);
	AddParam("siteid", piSiteID);
	AddParam("messagebody", psMessageBody);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("senddnasystemmessage"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::MakeFrontPageElementActive(int iElementID, int iElementType)
	
		Author: Mark Howitt
		Created: 30/11/2004
		Inputs: iElementId - The id of the preview element you want to make active
				iEditorID - the ID of the user 'making active'
				iElementType - the type of element you want to make active.
		Outputs: -
		Returns: true if ok, false if not
		Purpose: Creates or updates the active part of a frontpage element.

*********************************************************************************/
bool CStoredProcedure::MakeFrontPageElementActive(int iElementID, int iEditorID, int iElementType)
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("MakePreviewTopicElementActive");
		AddParam("TopicElementID",iElementID);
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("MakePreviewTextBoxElementActive");
		AddParam("TextBoxElementID",iElementID);
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("MakePreviewBoardPromoElementActive");
		AddParam("BoardPromoElementID",iElementID);
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::MakeFrontPageElementActive - Incorrect Element Type given!");
		return false;
	}

	AddParam("editorid",iEditorID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("MakeFrontPageElementActive"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MakeFrontPageElementsActive(int iSiteID, int iElementType)

		Author:		Mark Howitt
        Created:	03/03/2005
        Inputs:		iSiteID - the id of the site you want to make the preview element active.
					iEditorID - the userId of the editor in question.
        Outputs:	-
        Returns:	true if ok ,false if not.
        Purpose:	Mkaes all preview and archived preview elements active for a given site.

*********************************************************************************/
bool CStoredProcedure::MakeFrontPageElementsActive(int iSiteID, int iEditorID, int iElementType)
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("MakePreviewTopicElementsActive");
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("MakePreviewTextBoxElementsActive");
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("MakePreviewBoardPromoElementsActive");
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::MakeFrontPageElementActive - Incorrect Element Type given!");
		return false;
	}
	
	// Add the site id to the params.
	AddParam("siteid",iSiteID);

	//Add editorID 
	AddParam("editorid", iEditorID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("MakeFrontPageElementActive"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DoesTopicAlreadyExist( int iSiteID, const TDVCHAR* psTitle,  int iTopicStatus, bool* pbTopicAlreadyExist)

		Author:		DavidE
        Created:	09/12/2004
        Inputs:		- int iSiteID - the id of the site 
						- const TDVCHAR* psTitle - title of the topic being checked 
						- int iTopicStatus - status of the topic being checked can be live, or preview or archieved						
						- int iTopicIDToExclude, id of topic to exclude (needed when a topic is being edited)
        Outputs:	- bool& bTopicAlreadyExist - return parameter
        Returns:	- true if functions succeeds or false otherwise
        Purpose:	- queries the db to determine whether a Topic ( actually a guideentry ) with the same 
						  title and the same status already exists for a particular site. Prevents duplicates
						  returns true if a correspoinding entry can be found

*********************************************************************************/
bool CStoredProcedure::DoesTopicAlreadyExist( int iSiteID, const TDVCHAR* psTitle,  int iTopicStatus, bool& bTopicAlreadyExist, int iTopicIDToExclude/*=0*/)
{
	// Start the procedure
	StartStoredProcedure("doestopicalreadyexist");

	//Add Params
	AddParam("isiteid",   iSiteID);
	AddParam("stitle", psTitle);
	AddParam("itopicstatus", iTopicStatus);
	AddParam("itopicidtoexclude", iTopicIDToExclude);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DoesTopicAlreadyExist"))
	{
		return false;
	}

	if (IsEOF())	
	{
		return false;
	}
	
	bTopicAlreadyExist =  (GetIntField("iTopicAlreadyExist") > 0);		
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateTopic(int& iTopicID, int iSiteID, int iUserID, const TDVCHAR* psTitle, const TDVCHAR* psText,  int iTopicStatus, int iTopicLinkID)

		Author:		DavidE
        Created:	09/12/2004
        Inputs:		-int iSiteID  - the id of the site 
						-int iEditorID - the id of the editor creating this topic 
						-const TDVCHAR* psTitle - the title of this topic 
						-const TDVCHAR* psText - the description ogf this topic 
						-int iTopicStatus - can be live, preview or archieved
						-int iTopicLinkID - hell knows 
        Outputs:	-int& iTopicID - the id of the newly created topic entry
        Returns:	-true if functions succeeds or false otherwise
        Purpose:	-creates a new topic (originally added as part of the message board project)
						a topic has a one-to-one relationship with a GuideEntry (of article type)
						note only an editor is alowed to create a topic
						note a Topic can either have a live, preview or archieved status

*********************************************************************************/
bool CStoredProcedure::CreateTopic(int& iTopicID, int iSiteID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText,  int iTopicStatus, int iTopicLinkID)
{
	CExtraInfo ExtraInfo;
	ExtraInfo.Create(CGuideEntry::TYPEARTICLE);
	CTDVString sExtra;
	ExtraInfo.GetInfoAsXML(sExtra);

	// Start the procedure
	StartStoredProcedure("createtopic");

	// Add the params, if any	
	AddParam("isiteid",   iSiteID);
	AddParam("ieditorid",  iEditorID);
	AddParam("stitle", psTitle);
	AddParam("stext", psText);
	AddParam("itopicstatus", iTopicStatus);
	AddParam("itopiclinkid", iTopicLinkID);
	AddParam("sextrainfo", sExtra);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("CreateTopic"))
	{
		return false;
	}

	if (IsEOF())	
	{
		return false;
	}
	
	iTopicID =  GetIntField("iTopicID");		
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::EditTopic(int iTopicID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText,  int iStyle, const TDVCHAR* sEditKey)

		Author:		DavidE
        Created:	10/12/2004
        Inputs:		-int iTopicID- the id of the topic being edited
        Outputs:	-int iEditorID - the id of the user who is making this edit
        				-const TDVCHAR* psTitle - the new title of this topic 
						-const TDVCHAR* psText - the new description ogf this topic 
						-int iStyle - style of text (GuideML or Plain text)
						-const TDVCHAR* sEditKey -unique id used to verify that item has not been updated by another editor
						-the Edit Key will differ if rec has been updated, as a new one is generated for each edit 
		Returns:	-true if functions succeeds or false otherwise
        Purpose:	-Edits the field of a topic

*********************************************************************************/

bool CStoredProcedure::EditTopic(int iTopicID, int iEditorID, const TDVCHAR* psTitle, const TDVCHAR* psText, int iStyle, const TDVCHAR* sEditKey)
{
	// Start the procedure
	StartStoredProcedure("edittopic");

	// Add the params, if any	
	AddParam("itopicid", iTopicID);
	AddParam("ieditorid",  iEditorID);
	AddParam("stitle", psTitle);
	AddParam("stext", psText);	
	AddParam("istyle", iStyle);
	AddParam("editkey", sEditKey);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("EditTopic"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTopicsForSiteID(int iSiteID, int iTopicStatus, bool bIncludeArchivedTopics = false)

		Author:		DavidE
        Created:	09/12/2004
        Inputs:		iSiteID  - the id of the site 
					iTopicStatus - can be live, preview or archieved
					bIncludeArchivedTopics - A flag that states that you require the archived topics included in the list
        Outputs:	resultset contains just records of the entries which match 
        Returns:	true if functions succeeds or false otherwise
        Purpose:	get the corresponding guideentries and topics table records

*********************************************************************************/

bool CStoredProcedure::GetTopicsForSiteID(int iSiteID, int iTopicStatus, bool bIncludeArchivedTopics)
{
	// Start the procedure
	StartStoredProcedure("GetTopicsForSiteID");

	// Add the params, if any
	AddParam("iSiteID", iSiteID);
	AddParam("iTopicStatus", iTopicStatus);
	AddParam("includearchived",bIncludeArchivedTopics);
	
	// Execute the procedure
	ExecuteStoredProcedure();

	if (HandleError("GetTopicsForSiteID"))
	{
		return false;
	}

	return true;
}



/*********************************************************************************

	bool CStoredProcedure::GetTopicDetails(int iTopicID)

		Author:		DavidE
        Created:	09/12/2004
        Inputs:		-iTopicID - sought Topic's id
        Outputs:	-resultset contains just one record
        Returns:	-true if functions succeeds or false otherwise
        Purpose:	-get the corresponding guideentries and topics table record

*********************************************************************************/
bool CStoredProcedure::GetTopicDetails(int iTopicID)
{
	// Start the procedure
	StartStoredProcedure("GetTopicDetail");

	// Add the params, if any
	AddParam("iTopicID", iTopicID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetTopicDetail"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool  CStoredProcedure::DeleteTopic(int iTopicID)

		Author:		DavidE
        Created:	10/12/2004
        Inputs:		-int iTopicID - the id of the topic to delete 
        Outputs:	-none
        Returns:	-true if functions succeeds or false otherwise
        Purpose:	-deletes the topic record id'ed by iTopicID

*********************************************************************************/
bool  CStoredProcedure::DeleteTopic(int iTopicID)
{
	// Start the procedure
	StartStoredProcedure("deletetopic");

	// Add the params, if any
	AddParam("itopicid", iTopicID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteTopic"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool  CStoredProcedure::MoveTopicPositionally(int iTopicID, int iDirection, const TDVCHAR* sEditKey)

		Author:		David E
        Created:	10/12/2004
        Inputs:		-int iTopicID - the id of the topic record to move 
        				-int iDirection - 0 if topic is being moved down or 1 if topic is being moved up in display list
						-const TDVCHAR* sEditKey -unique id used to verify that item has not been updated by another editor
						-the Edit Key will differ if rec has been updated, as a new one is generated for each edit 
		Outputs:
        Returns:	-true if functions succeeds or false otherwise
        Purpose:	-moves a topic (visually) either one step up or down - see the position field of the topics table

*********************************************************************************/
bool  CStoredProcedure::MoveTopicPositionally(int iTopicID, int iDirection, const TDVCHAR* sEditKey)
{
	// Start the procedure
	StartStoredProcedure("MoveTopicPositionally");

	// Add the params, if any
	AddParam("iTopicID", iTopicID);
	AddParam("iDirection", iDirection);
	AddParam("EditKey", sEditKey);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("MoveTopicPositionally"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTopicTitle(int iTopicID, CTDVString& sTitle)

		Author:		David E
        Created:	13/12/2004
        Inputs:		-int iTopicID - the id of the topic record to move 						
        Outputs:	-CTDVString& sTitle - the title of the sought topic
        Returns:	-the title of the sought topic
        Purpose:	-the title of the sought topic

*********************************************************************************/

bool CStoredProcedure::GetTopicTitle(int iTopicID, CTDVString& sTitle)
{
	// Start the procedure
	StartStoredProcedure("GetTopicTitle");

	// Add the params, if any
	AddParam("iTopicID", iTopicID);	
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetTopicTitle"))
	{
		return false;
	}
	
	if (IsEOF())	
	{
		return false;
	}
	
	return GetField("subject", sTitle);		
}

bool CStoredProcedure::UpdateAdminStatus(int iSiteID, int iType, int iStatus)
{
	StartStoredProcedure("UpdateMessageBoardAdminStatus");

	AddParam("Type", iType);
	AddParam("Status", iStatus);
	AddParam("SiteID", iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("UpdateAdminStatus"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::UpdateEveryAdminStatusForSite(int iSiteID, int iStatus)
{
	StartStoredProcedure("UpdateEveryMessageBoardAdminStatusForSite");

	AddParam("Status", iStatus);
	AddParam("SiteID", iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("UpdateEveryAdminStatusForSite"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetMessageBoardAdminStatusIndicators(int iSiteID)
{
	StartStoredProcedure("GetMessageBoardAdminStatusIndicators");

	AddParam("SiteID", iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("GetMessageBoardAdminStatusIndicators"))
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::GetFullModeratorList(void)
{
	StartStoredProcedure("getfullmoderatorlist");
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::GiveModeratorsAccess(const TDVCHAR* pAccessObject, int AccessID)
{
	// Complete the open AddUserToTempList
	ExecuteStoredProcedure();
	GetField("UID", m_sUserListUID);
	StartStoredProcedure("givemoderatoraccess");
	AddParam(m_sUserListUID);
	AddParam(AccessID);
	AddParam(pAccessObject);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::StartAddUserToTempList()
{
	m_iItemCount = 0;
	m_sUserListUID = "";
	StartStoredProcedure("addtotempuserlist");
	AddNullParam();
	return true;
}

bool CStoredProcedure::AddUserToTempList(int iUserID)
{
	AddParam(iUserID);
	m_iItemCount++;
	if (m_iItemCount >= 50)
	{
		ExecuteStoredProcedure();
		m_iItemCount = 0;
		GetField("UID", m_sUserListUID);
		StartStoredProcedure("addtotempuserlist");
	}
	return true;
}


bool CStoredProcedure::FlushTempUserList(void)
{
	ExecuteStoredProcedure();
	GetField("UID", m_sUserListUID);
	StartStoredProcedure("flushtempuserlist");
	AddParam(m_sUserListUID);
	ExecuteStoredProcedure();
	return false;
}

bool CStoredProcedure::GetModerationClassList(void)
{
	StartStoredProcedure("getmoderationclasslist");
	ExecuteStoredProcedure();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetSitesModerationDetails

		Author:		Martin Robb
        Created:	09/02/2006
        Inputs:		- 
        Outputs:	-
        Returns:	- false on error
        Purpose:	-	Returns a list of sites moderation details.
						If user details are given then the list will be filtered on user permissions.
						Superuser will have access to all sites.
						bReferees indicates sites for which the user is a referee only
*********************************************************************************/
bool CStoredProcedure::GetSitesModerationDetails( int iUserID, bool bIsSuperUser, bool bRefereeFilter )
{
	StartStoredProcedure("getsitesmoderationdetails");
	if ( iUserID > 0 )
	{
		AddParam("userid",iUserID);
		AddParam("IsSuperUser",bIsSuperUser);
		AddParam("Referees", bRefereeFilter);
	}

	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::RemoveModeratorAccess(const TDVCHAR* pAccessObject, int AccessID)
{
	// Complete the open AddUserToTempList
	ExecuteStoredProcedure();
	GetField("UID", m_sUserListUID);
	StartStoredProcedure("removemoderatoraccess");
	AddParam(m_sUserListUID);
	AddParam(AccessID);
	AddParam(pAccessObject);
	ExecuteStoredProcedure();
	return true;
}


bool CStoredProcedure::FindUserFromEmail(const TDVCHAR* pEmail)
{
	StartStoredProcedure("finduserfromemail");
	AddParam(pEmail);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::AddNewModeratorToClasses(int iUserID)
{
	// Complete the AddUserToTempList
	ExecuteStoredProcedure();
	GetField("UID", m_sUserListUID);
	StartStoredProcedure("addnewmoderatortoclasses");
	AddParam(m_sUserListUID);
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return true;
}


bool CStoredProcedure::GetGroupsAndGroupMembersForSite(int iSiteID)
{
	// Start the procedure
	StartStoredProcedure("GetGroupsAndMembersForSite");

	// Add the params, if any
	AddParam("SiteID", iSiteID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if(HandleError("GetGroupsAndMembersForSite"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MakeFrontPageLayoutActive(int iSiteID)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::MakeFrontPageLayoutActive(int iSiteID)
{
	// Complete the AddUserToTempList
	StartStoredProcedure("MakeFrontPageLayoutActive");
	AddParam(iSiteID);
	ExecuteStoredProcedure();

	//handle errors
	if (HandleError("MakeFrontPageLayoutActive"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetNumberOfTopicsForSiteID(int iSiteID, int iTopicStatus, int& iNumTopics)
{
	// Start the procedure
	StartStoredProcedure("GetNumberOfTopicsForSiteID");

	// Add the params, if any
	AddParam("iSiteID", iSiteID);	
	AddParam("iTopicStatus",iTopicStatus);

	// Execute the procedure
	ExecuteStoredProcedure();

	//handle errors
	if (HandleError("GetNumberOfTopicsForSiteID"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetNumberOfFrontPageElementsForSiteID(int iSiteID, int iElementType, int iElementStatus, int& iNumElements)
{
	// Start the update procedure and add the element param.
	if (iElementType == CFrontPageElement::ET_TOPIC)
	{
		StartStoredProcedure("GetNumberOfTopicElementsForSiteID");
	}
	else if (iElementType == CFrontPageElement::ET_TEXTBOX)
	{
		StartStoredProcedure("GetNumberOfTextBoxElementsForSiteID");
	}
	else if (iElementType == CFrontPageElement::ET_BOARDPROMO)
	{
		StartStoredProcedure("GetNumberOfBoardPromoElementsForSiteID");
	}
	else
	{
		TDVASSERT(false,"CStoredProcedure::GetNumberOfFrontPageElementsForSiteID - Incorrect Element Type given!");
		return false;
	}

	// Add the params, if any
	AddParam("iSiteID", iSiteID);	
	AddParam("iElementStatus", iElementStatus);

	// Execute the procedure
	ExecuteStoredProcedure();

	//handle errors
	if (HandleError("GetNumberOfFrontPageElementsForSiteID"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MakePreviewTopicActiveForSite(const int iSiteID, int iTopicID, int iEditorID)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::MakePreviewTopicActiveForSite(const int iSiteID, int iTopicID, int iEditorID)
{
	// Start the procedure
	StartStoredProcedure("MakePreviewTopicActiveForSiteID");

	// Add the params, if any
	AddParam("iSiteID", iSiteID);	
	AddParam("iTopicID", iTopicID);	
	AddParam("iEditorID", iEditorID);
	
	// Execute the procedure
	ExecuteStoredProcedure();

	//handle errors
	if (HandleError("MakePreviewTopicActiveForSiteID"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::MakePreviewTopicsActiveForSite(const int iSiteID, int iEditorID)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::MakePreviewTopicsActiveForSite(const int iSiteID, int iEditorID)
{
	// Start the procedure
	StartStoredProcedure("MakePreviewTopicsActiveForSiteID");

	// Add the params, if any
	AddParam("iSiteID", iSiteID);	
	AddParam("iEditorID", iEditorID);

	// Execute the procedure
	ExecuteStoredProcedure();

	//handle errors
	if (HandleError("MakePreviewTopicsActiveForSiteID"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************
bool CStoredProcedure::GetVoteLinksTotals(int iPollId)
Author:		Igor Loboda
Created:	21/04/2005
Inputs:		iPollId - poll id to get the links totals for
Purpose:	fetches the number of opposition links and the
			number of support links.
*********************************************************************************/

bool CStoredProcedure::GetVoteLinksTotals(int iPollId)
{
	StartStoredProcedure("getvotelinkstotals");
	AddParam(iPollId);
	if(!ExecuteStoredProcedure() || HandleError("getvotelinkstotals"))
	{
		TDVASSERT(false, "CStoredProcedure::GetVoteLinksTotals() Failed to execute sp");
		return false;
	}

	return true;
}

/*********************************************************************************
	Author:		James Pullicino
    Created:	07/01/2005
    Inputs:		PollID
    Outputs:	
    Returns:	
    Purpose:	Gets voting results of Poll
*********************************************************************************/
bool CStoredProcedure::GetPollResults(int nPollID)
{
	StartStoredProcedure("GetPollResults");
	AddParam(nPollID);
	if(!ExecuteStoredProcedure() || HandleError("GetPollResults"))
	{
		TDVASSERT(false, "CStoredProcedure::GetPollResults() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************
	Author:		James Pullicino
    Created:	10/01/2005
    Inputs:		PollID, UserID
    Outputs:	
    Returns:	
    Purpose:	Gets voting results of Poll for a particular user
*********************************************************************************/
bool CStoredProcedure::GetUserVotes(int nPollID, int nUserID)
{
	StartStoredProcedure("GetUserVotes");
	AddParam(nPollID);
	AddParam(nUserID);
	if(!ExecuteStoredProcedure() || HandleError("GetUserVotes"))
	{
		TDVASSERT(false, "CStoredProcedure::GetUserVotes() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************
	Author:		James Pullicino
    Created:	10/01/2005
    Inputs:		ItemID and ItemType
    Outputs:	Returns records with pollIDs for this item/page
    Returns:	
    Purpose:	Gets ids of polls that are linked to an item/page
*********************************************************************************/
bool CStoredProcedure::GetPagePolls(int nItemID, int nItemType)
{
	StartStoredProcedure("GetPagePolls");
	AddParam(nItemID);
	AddParam(nItemType);
	if(!ExecuteStoredProcedure() || HandleError("GetPagePolls"))
	{
		TDVASSERT(false, "CStoredProcedure::GetPagePolls() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::HidePoll(bool bHide, int nPollID, int nItemID, int nItemType)

		Author:		James Pullicino
        Created:	12/01/2005
	
		Inputs:		bHide - 1=hide 0=unhide
					nPollID		- ID of poll
					nItemID		- ID of item poll is attached to
					nItemType	- Type of item poll is attached to
				
					Note: If nItemID and nItemType are BOTH 0, poll will be un/hidden for
					all items its attached to
				
		Outputs:	none
		Returns:	nothing
		Purpose:	Hide/Unhide a poll

*********************************************************************************/
bool CStoredProcedure::HidePoll(bool bHide, int nPollID, int nItemID, int nItemType)
{
	StartStoredProcedure("HidePoll");
	AddParam(bHide);
	AddParam(nPollID);
	AddParam(nItemID);
	AddParam(nItemType);
	if(!ExecuteStoredProcedure() || HandleError("HidePoll"))
	{
		TDVASSERT(false, "CStoredProcedure::HidePoll() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::LinkPollWithItem(int nPollID, int nItemID, int nItemType)

		Author:		James Pullicino
        Created:	13/01/2005

        Inputs:		nPollID		- ID of poll
					nItemID		- ID of item poll is attached to
					nItemType	- Type of item poll is attached to (See CPoll::ItemType enum)

        Outputs:	none
        Returns:	true/false
        Purpose:	Adds a poll to a page/item

*********************************************************************************/
bool CStoredProcedure::LinkPollWithItem(int nPollID, int nItemID, int nItemType)
{
	StartStoredProcedure("LinkPollWithItem");
	AddParam(nPollID);
	AddParam(nItemID);
	AddParam(nItemType);
	if(!ExecuteStoredProcedure() || HandleError("LinkPollWithItem"))
	{
		TDVASSERT(false, "CStoredProcedure::LinkPollWithItem() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetPollDetails(int nPollID)

		Author:		James Pullicino
        Created:	13/01/2005
        Inputs:		nPollID - ID of poll which you want to load
        Outputs:	"Type" of poll
        Returns:	true/false
        Purpose:	Get properties of a poll
*********************************************************************************/

bool CStoredProcedure::GetPollDetails(int nPollID)
{
	StartStoredProcedure("GetPollDetails");
	AddParam(nPollID);
	if(!ExecuteStoredProcedure() || HandleError("GetPollDetails"))
	{
		TDVASSERT(false, "CStoredProcedure::GetPollDetails() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::PollContentRatingVote(int nPollID, int nUserID, int nResponse)

		Author:		James Pullicino
        Created:	27/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Add/Update vote for a user for content rating polls

*********************************************************************************/

bool CStoredProcedure::PollContentRatingVote(int nPollID, int nUserID, int nResponse)
{
	StartStoredProcedure("pollcontentratingvote", true);
	AddParam(nPollID);AddParam(nUserID);AddParam(nResponse);
	
	if(!ExecuteStoredProcedure() || HandleError("PollContentRatingVote"))
	{
		TDVASSERT(false, "CStoredProcedure::PollContentRatingVote() Failed to execute stored procedure");
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::PollAnonymousContentRatingVote(int nPollID, int nUserID, int nResponse)

		Author:		Steve Francis
        Created:	27/02/2007
        Inputs:		-	nPollID - the id of the poll you want to add the response to.
						iUserID - the id of the user voting. Can be 0 for anonymous votes
						nResponse - the response the user has given.
						sBBCUID - the BBCUID of the user voting. Only used when they
									are not logged in.
		Outputs:	-
        Returns:	-
        Purpose:	Add/Update vote for a user for anonymous content rating polls

*********************************************************************************/

bool CStoredProcedure::PollAnonymousContentRatingVote(int nPollID, int nUserID, int nResponse, CTDVString& sBBCUID)
{

	StartStoredProcedure("pollanonymouscontentratingvote", true);
	AddParam(nPollID);
	AddParam(nUserID);
	AddParam(nResponse);

	// Add the UID to the param list
	CTDVString sHash;
	if(!GenerateHash(sBBCUID, sHash))
	{
		TDVASSERT(false, "CStoredProcedure::PollAnonymousContentRatingVote() GenerateHash failed");
		return false;
	}
	if (!AddUIDParam(sHash))
	{
		return false;
	}
	
	if(!ExecuteStoredProcedure() || HandleError("PollAnonymousContentRatingVote"))
	{
		TDVASSERT(false, "CStoredProcedure::PollAnonymousContentRatingVote() Failed to execute stored procedure");
		return false;
	}
	
	return true;
}
/*********************************************************************************

	bool CStoredProcedure::GetBBCUIDVotes(int nPollID, const TDVCHAR * pBBCUID)

		Author:		James Pullicino
        Created:	02/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Get voting results for user with a BBCUID

*********************************************************************************/

bool CStoredProcedure::GetBBCUIDVotes(int nPollID, const TDVCHAR * pBBCUID)
{
	TDVASSERT(pBBCUID, "CStoredProcedure::GetBBCUIDVotes() invalid param pBBCUID");

	StartStoredProcedure("GetBBCUIDVotes", true);

	AddParam(nPollID);
	
	CTDVString sHash;
	if(!GenerateHash(pBBCUID,sHash))
	{
		TDVASSERT(false, "CStoredProcedure::GetBBCUIDVotes() GenerateHash failed");
		return false;
	}

	AddUIDParam( sHash );	
		
	bool bSuccess = ExecuteStoredProcedure();
	
	if(HandleError("GetBBCUIDVotes") || !bSuccess)
	{
		TDVASSERT(false, "CStoredProcedure::GetBBCUIDVotes() Failed to execute stored procedure");
		return false;
	}
	
	return true;
}

bool CStoredProcedure::AddNewModeratorToSites(int iUserID)
{
	ExecuteStoredProcedure();
	GetField("UID", m_sUserListUID);
	StartStoredProcedure("addnewmoderatortosites");
	AddParam(m_sUserListUID);
	AddParam(iUserID);
	ExecuteStoredProcedure();
	return true;
}

bool CStoredProcedure::ChangeModerationClassOfSite(int iSiteID, int iClassID)
{
	StartStoredProcedure("changemoderationclassofsite");
	AddParam(iSiteID);
	AddParam(iClassID);
	ExecuteStoredProcedure();
	return true;
}



/*********************************************************************************

	bool CStoredProcedure::FetchEmailVocab(void)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::FetchEmailVocab(void)
{
	StartStoredProcedure("fetchemailvocab");

	ExecuteStoredProcedure();
	if (HandleError("FetchEmailVocab"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddNewEmailVocabEntry(int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		iSiteID, the id of the Site
					sName, name of the vocab entry, e.g. Guide, Thread, Forum
					sSubstitution, value to substitute with on this site, e.g. Article, Conversation, Conversations
        Outputs:	-
        Returns:	true if successfully added, false otherwise
        Purpose:	This adds a new piece of vocabularly to the EmailVocab table for the specified site.
					The EmailVocab table is used to make text substitutions in email text for common words
					in DNA that may have different synonyms across sites.

*********************************************************************************/
bool CStoredProcedure::AddNewEmailVocabEntry(const int iSiteID, const CTDVString& sName, const CTDVString& sSubstitution)
{
	StartStoredProcedure("addnewemailvocabentry");

	AddParam("SiteID", iSiteID);
	AddParam("Name", sName);
	AddParam("Substitution", sSubstitution);

	ExecuteStoredProcedure();
	if (HandleError("AddNewEmailVocabEntry"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::RemoveEmailVocabEntry(const int iSiteID, const CTDVString& sName)
{
	StartStoredProcedure("removeemailvocabentry");

	AddParam("SiteID", iSiteID);
	AddParam("Name", sName);

	ExecuteStoredProcedure();
	if (HandleError("RemoveEmailVocabEntry"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchEmailTemplate(int iSiteID, const CTDVString& sTemplateName)

		Author:		David Williams
        Created:	01/12/2004
        Inputs:		iSiteID - Site ID
					sTemplateName - Name of the template
        Outputs:	-
        Returns:	true if successful, otherwise false
        Purpose:	Fetches the specified email template, use recordset features to retrieve 
					specific columns

*********************************************************************************/
bool CStoredProcedure::FetchEmailTemplate(const int iSiteID, const CTDVString& sTemplateName, const int iModClassID)
{
	StartStoredProcedure("fetchemailtemplate");

	AddParam("siteid", iSiteID);
	AddParam("emailname", sTemplateName);
	if (iModClassID != -1)
	{
		AddParam("modclass", iModClassID);
	}

	ExecuteStoredProcedure();
	if (HandleError("FetchEmailTemplate"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddNewEmailTemplate(const int iModClassID, const CTDVString& sTemplateName, const CTDVString& sSubject, const CTDVString& sBody)

		Author:		David Williams
        Created:	03/12/2004
        Inputs:		iModClassID - Moderation Class ID
					sTemplateName - Name of the email template
					sSubject - Subject line of the email template
                    sBody - Body text of the email template
        Outputs:	-
        Returns:	true if successful, otherwise false
        Purpose:	Adds a new email template to a specified moderation class

*********************************************************************************/
bool CStoredProcedure::AddNewEmailTemplate(const int iModClassID, const CTDVString& sTemplateName, 
	const CTDVString& sSubject, const CTDVString& sBody)
{
	StartStoredProcedure("addnewemailtemplate");

	AddParam("ModClassID", iModClassID);
	AddParam("Name", sTemplateName);
	AddParam("Subject", sSubject);
	AddParam("Body", sBody);

	ExecuteStoredProcedure();
	if (HandleError("AddNewEmailTemplate"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateEmailTemplate(const int iModClassID, const CTDVString& sTemplateName, 
		const CTDVString& sSubject, const CTDVString& sBody)

		Author:		David Williams
        Created:	03/12/2004
        Inputs:		iModClassID - Moderation Class ID
					sTemplateName - Name of the email template
					sSubject - Subject line for the email template
					sBody - Text body of the email template
        Outputs:	-
        Returns:	true if successful, false otherwise
        Purpose:	Update the subject line and body text of an email template

*********************************************************************************/
bool CStoredProcedure::UpdateEmailTemplate(const int iModClassID, const CTDVString& sTemplateName, 
	const CTDVString& sSubject, const CTDVString& sBody)
{
	StartStoredProcedure("updateemailtemplate");

	AddParam("ModClassID", iModClassID);
	AddParam("Name", sTemplateName);
	AddParam("Subject", sSubject);
	AddParam("Body", sBody);

	ExecuteStoredProcedure();
	if (HandleError("UpdateEmailTemplate"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveEmailTemplate(const int iModClassID, const CTDVString& sTemplateName)

		Author:		David Williams
        Created:	03/12/2004
        Inputs:		iModClassID - Moderation Class ID
					sTemplateName - Name of the template
        Outputs:	-
        Returns:	true if successful, otherwise false
        Purpose:	Removes a named email template from a specified moderation class.

*********************************************************************************/
bool CStoredProcedure::RemoveEmailTemplate(const int iModClassID, const CTDVString& sTemplateName)
{
	StartStoredProcedure("deleteemailtemplate");

	AddParam("modclassid", iModClassID);
	AddParam("templatename", sTemplateName);

	ExecuteStoredProcedure();
	if (HandleError("DeleteEmailTemplate"))
	{
		return false;
	}
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetEmailTemplates(const int iModClassID)

		Author:		David Williams
        Created:	22/12/2004
        Inputs:		iModClassID - Moderation Class ID
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::GetEmailTemplates(const int iViewID, const CTDVString& sViewObject)
{
	if (sViewObject.CompareText("class"))
	{
		StartStoredProcedure("getemailtemplatesbymodclassid");
		AddParam("modclassid", iViewID);
	}
	else if (sViewObject.CompareText("site"))
	{
		StartStoredProcedure("getemailtemplatesbysiteid");
		AddParam("siteid", iViewID);
	}
	else if ( sViewObject.CompareText("all") || sViewObject.CompareText("default"))
	{
		StartStoredProcedure("getemailtemplatesbymodclassid");
		AddParam("modclassid", -1);
	}

	ExecuteStoredProcedure();
	if (HandleError("GetEmailTemplates"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetEmailTemplateIDByName(const int iViewID, CTDVString& sViewObject, const CTDVString& sTemplateName, int& iTemplateID)
{
	StartStoredProcedure("getemailtemplateidbyname");
	AddParam("viewid", iViewID);
	sViewObject.MakeLower();
	AddParam("viewtype", sViewObject);
	AddParam("templatename", sTemplateName);

	ExecuteStoredProcedure();
	if (HandleError("GetEmailTemplateIDByName"))
	{
		return false;
	}

	if (!IsEOF())
	{
		iTemplateID = GetIntField("EmailTemplateID");
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetKeyArticleText(const TCHAR* pName,int iSiteID)

		Author:		Mark Neves
        Created:	21/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetKeyArticleText(const TCHAR* pName,int iSiteID)
{
	StartStoredProcedure("getkeyarticletext");
	AddParam("articlename",pName);
	AddParam("SiteID", iSiteID);

	ExecuteStoredProcedure();

	if (HandleError("GetKeyArticleText"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetNewUnScheduledForumIDsForSiteID(const int iSiteID)
{
	StartStoredProcedure("GetNewUnScheduledForumIDsForSiteID");

	AddParam("SiteID", iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("GetScheduledForumIDsForSiteID"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GenerateDuplicateScheduledEventsForNewForums(const int iExistingForum, CDNAIntArray& iForums)
{
	// Go through the forumids in blocks of 20 as this is the
	// max number of params the procedure can take at one time

	CTDVString sForum;
	for (int i = 0; i < iForums.GetSize(); i += 20)
	{
		// Call the procedure
		StartStoredProcedure("GenerateDuplicateScheduledEventsForNewForums");

		// Setup the params
		AddParam("Existing",iExistingForum);

		// Now add the forums from the array
		for (int j = i, k = 0; j < iForums.GetSize() && k < 20; j++,k++)
		{
			// Set the correct Param names for each forum
			sForum = "F";
			sForum << k;
			AddParam(sForum,(int)iForums[j]);
		}

		// Call the procedure
		ExecuteStoredProcedure();
		if (HandleError("GenerateDuplicateScheduleEventsForNewForums"))
		{
			return false;
		}
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetBoardPromoLocations(int iBoardPromoID)

		Author:		Mark Howitt
        Created:	27/01/2005
        Inputs:		iBoardPromoID - The Promo you want to get the loactions for
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets all the topic locations for a given board promo

*********************************************************************************/
bool CStoredProcedure::GetBoardPromoLocations(int iBoardPromoID)
{
	// Call the procedure
	StartStoredProcedure("GetBoardPromoElementLocations");

	// Setup the params
	AddParam("BoardPromoElementID",iBoardPromoID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetBoardPromoLocations"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetBoardPromoLocations(int iBoardPromoID, CDNAIntArray& TopicList, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	27/01/2005
        Inputs:		iBoardPromoID - The id of the promo you want to set the locations for.
					TopicList - An array of topics ids that you want to set the location of the promo for.
					psEditKey - The edit key needed to verify the edit.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets the loaction for a given promo id.

*********************************************************************************/
bool CStoredProcedure::SetBoardPromoLocations(int iBoardPromoID, CDNAIntArray& TopicList, const TDVCHAR* psEditKey, int iUserID)
{
	// Set up the list of topics to update
	CTDVString sTopics;
	for (int i = 0; i < TopicList.GetSize(); i++)
	{
		sTopics << TopicList[i];
		if (i < TopicList.GetSize() - 1)
		{
			sTopics << ",";
		}
	}

	// Call the procedure
	StartStoredProcedure("SetBoardPromoLocations");

	// Setup the params
	AddParam("BoardPromoElementID",iBoardPromoID);

	// Add the UID to the param list
	if (!AddUIDParam("editkey",psEditKey))
	{
		return false;
	}

	AddParam("Topics",sTopics);
	AddParam("userid",iUserID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetBoardPromoLocations"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTopicFromForumID(int iForumID)

		Author:		Mark Howitt
        Created:	03/02/2005
        Inputs:		iForumID - The id of the forum you want to check that belongs to a topic.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Tries to get the topic that the forumid belongs to

*********************************************************************************/
bool CStoredProcedure::GetTopicFromForumID(int iForumID)
{
	// Call the procedure
	StartStoredProcedure("GetTopicFromForumID");

	// Setup the params
	AddParam("ForumID",iForumID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetTopicFromForumID"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTopicFromForumID(int ih2g2ID)

		Author:		Mark Howitt
        Created:	03/02/2005
        Inputs:		ih2g2ID - The id of the guideentry you want to check that belongs to a topic.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Tries to get the topic that the forumid belongs to

*********************************************************************************/
bool CStoredProcedure::GetTopicFromh2g2ID(int ih2g2ID)
{
	// Call the procedure
	StartStoredProcedure("gettopicfromh2g2id");

	// Setup the params
	AddParam("h2g2id",ih2g2ID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetTopicFromh2g2ID"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CleanUpActiveTopicBoardPromoLocations(int iSiteID)

		Author:		Mark Howitt
        Created:	04/02/2005
        Inputs:		iSiteID - the site you want to make sure is cleanup correctly!
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Basically this function is used to ensure any active topics have their
					BoardPromoID and DefaultBoardPromoIDs setup correctly.

*********************************************************************************/
bool CStoredProcedure::CleanUpActiveTopicBoardPromoLocations(int iSiteID)
{
	// Call the procedure
	StartStoredProcedure("cleanupboardpromolocationsforactivetopics");

	// Setup the params
	AddParam("siteid",iSiteID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("CleanUpActiveTopicBoardPromoLocations"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetDefaultBoardPromoForTopics(int iSiteID, int iBoardPromoID)

		Author:		Mark Howitt
        Created:	07/02/2005
        Inputs:		iSiteID - The site that the topics belong to that you want to update
					iBoardPromoID - The Id of the promo that you want to set a default
					iUserID - The ID of the user that is doing the changes.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets the default board promo for all topics on a given site.

*********************************************************************************/
bool CStoredProcedure::SetDefaultBoardPromoForTopics(int iSiteID, int iBoardPromoID, int iUserID)
{
	// Call the procedure
	StartStoredProcedure("setdefaultboardpromofortopics");

	// Setup the params
	AddParam("siteid",iSiteID);
	AddParam("boardpromoid",iBoardPromoID);
	AddParam("userid",iUserID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetDefaultBoardPromoForTopics"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText)

		Author:		David Williams
        Created:	21/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::AddSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription)
{
	StartStoredProcedure("addsiteemailinsert");

	AddParam("SiteID", iSiteID);
	AddParam("Name", sName);
	AddParam("Group", sGroup);
	AddParam("Text", sText);
	AddParam("ReasonDescription", sDescription);

	ExecuteStoredProcedure();
	if (HandleError("AddSiteEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::AddModClassEmailInsert( const int iModClassID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription)
{
	StartStoredProcedure("addmodclassemailinsert");

	AddParam("ModClassID", iModClassID);
	AddParam("Name", sName);
	AddParam("Group", sGroup);
	AddParam("Text", sText);
	AddParam("ReasonDescription", sDescription);

	ExecuteStoredProcedure();
	if (HandleError("AddModClassEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::UpdateSiteEmailInsert(const int iSiteID, const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription)
{
	StartStoredProcedure("updatesiteemailinsert");

	AddParam("SiteID", iSiteID);
	AddParam("Name", sName);
	AddParam("Group", sGroup);
	AddParam("Text", sText);
	AddParam("ReasonDescription", sDescription);

	ExecuteStoredProcedure();
	if (HandleError("UpdateSiteEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::UpdateModClassEmailInsert(const int iViewID, const CTDVString& sViewObject,  const CTDVString& sName, const CTDVString& sGroup, const CTDVString& sText, const CTDVString& sDescription)
{
	if (sViewObject.CompareText("class"))
	{
		StartStoredProcedure("updatemodclassemailinsert");
		AddParam("ModClassID", iViewID);
	}
	else
	{
		StartStoredProcedure("updatemodclassemailinsertbysiteid");
		AddParam("SiteID", iViewID);
	}

	AddParam("Name", sName);
	AddParam("Group", sGroup);
	AddParam("Text", sText);
	AddParam("ReasonDescription", sDescription);

	ExecuteStoredProcedure();
	if (HandleError("UpdateModClassEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::RemoveSiteEmailInsert(const int iSiteID, const CTDVString& sName)
{
	StartStoredProcedure("removesiteemailinsert");
	
	AddParam("SiteID", iSiteID);
	AddParam("Name", sName);

	ExecuteStoredProcedure();
	if (HandleError("RemoveSiteEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::RemoveModClassEmailInsert(const int iModClassID, const CTDVString& sName)
{
	StartStoredProcedure("removemodclassemailinsert");

	AddParam("ModClassID", iModClassID);
	AddParam("Name", sName);

	ExecuteStoredProcedure();
	if (HandleError("RemoveModClassEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::CreateEmailTemplateSet(const int iModClassID)
{
	StartStoredProcedure("createemailtemplateset");

	AddParam("modclassid", iModClassID);

	ExecuteStoredProcedure();
	if (HandleError("CreateEmailTemplateSet"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetEmailInserts(const int iViewID, const CTDVString& sViewObject)
{
	if ( sViewObject.CompareText("site") )
	{
		StartStoredProcedure("getemailinsertsbysite");
		AddParam("SiteID", iViewID);
	}
	if ( sViewObject.CompareText("class") )
	{
		StartStoredProcedure("getemailinsertsbyclass");
		AddParam("ModClassID", iViewID);
	}
	if ( sViewObject.CompareText("default") || sViewObject.CompareText("all") )
	{
		StartStoredProcedure("getemailinsertsbyclass");
		AddParam("ModClassID", -1);
	}

	ExecuteStoredProcedure();
	if (HandleError("GetEmailInserts"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetEmailInsert(const int iSearchID, const CTDVString& sInsertName)
{
	StartStoredProcedure("getemailinsert");

	AddParam("siteid", iSearchID);
	AddParam("insertname", sInsertName);

	ExecuteStoredProcedure();
	if (HandleError("GetEmailInsert"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetEmailInsertGroups(void)
{
	StartStoredProcedure("getemailinsertgroups");
	ExecuteStoredProcedure();
	if (HandleError("GetEmailInsertGroups"))
	{
		return false;
	}
	return true;
}
/*********************************************************************************

	bool CStoredProcedure::UpdatePreviewSiteConfigData(const TDVCHAR* psSiteConfig, int iSiteID, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		psSiteConfig - The new Site Config Data you want to update with.
					iSIteID - The site that you want to update the data for.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Updates the preview siteconfig data for a given site

*********************************************************************************/
bool CStoredProcedure::UpdatePreviewSiteConfigData(const TDVCHAR* psSiteConfig, int iSiteID, const TDVCHAR* psEditKey)
{
	// Call the procedure
	StartStoredProcedure("updatepreviewsiteconfig");

	// Setup the params
	AddParam("siteid",iSiteID);
	AddParam("config",psSiteConfig);

	// Add the UID to the param list
	if (!AddUIDParam("editkey",psEditKey))
	{
		return false;
	}

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("UpdatePreviewSiteConfigData"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchPreviewSiteData(int iSiteID)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		iSiteID - The site that you want to get the data for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets the preview site data for a given site.

*********************************************************************************/
bool CStoredProcedure::FetchPreviewSiteData(int iSiteID)
{
	// Call the procedure
	StartStoredProcedure("fetchpreviewsitedata");

	// Setup the params
	AddParam("siteid",iSiteID);

	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("FetchPreviewSiteData"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchPreviewSiteConfigData(int iSiteID)

		Author:		Mark Howitt
        Created:	09/02/2005
        Inputs:		iSiteID - The site that you want to get the data for.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets the preview siteconfig for a given site.

*********************************************************************************/
bool CStoredProcedure::FetchPreviewSiteConfigData(int iSiteID)
{
	// Call the procedure
	StartStoredProcedure("fetchpreviewsiteconfig");

	// Setup the params
	AddParam("siteid",iSiteID);
	
	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("FetchPreviewSiteConfigData"))
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::CreateNewModerationClass(const TDVCHAR* pClassName, const TDVCHAR* pDescription, int iBasedOn)
{
	StartStoredProcedure("createnewmoderationclass");
	AddParam(pClassName);
	AddParam(pDescription);
	AddParam(iBasedOn);
	ExecuteStoredProcedure();
	if (HandleError("CreateNewModerationClass"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetBoardPromoName(int iPromoID, const TDVCHAR* psName, const TDVCHAR* psEditKey)

		Author:		Mark Howitt
        Created:	18/02/2005
        Inputs:		iPromoID - the id of the promo you want to update
					psName - the new name you want to set
					psEditKey - the edit key required to do the update
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets a new name for a given boardpromo

*********************************************************************************/
bool CStoredProcedure::SetBoardPromoName(int iPromoID, const TDVCHAR* psName, const TDVCHAR* psEditKey)
{
	// Call the procedure
	StartStoredProcedure("setboardpromoname");

	// Setup the params
	AddParam("promoid",iPromoID);
	AddParam("name",psName);

	// Add the UID to the param list
	if (!AddUIDParam("editkey",psEditKey))
	{
		return false;
	}
	
	// Call the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetBoardPromoName"))
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::UpdateBoardPromoKeyPhrases( int iBoardPromoID, const std::vector<PHRASE>& vPhrases, bool bDefault )
{
	CTDVString sPhrases;
	for ( std::vector<PHRASE>::const_iterator iter = vPhrases.begin(); iter != vPhrases.end(); ++iter )
	{
		CTDVString sPhrase = iter->m_Phrase;

		//Handle empty key phrase 
		if ( sPhrase == "" )
			sPhrase = "|";
		sPhrases << ( sPhrases.IsEmpty() ? "" : "|" ) << sPhrase;
	}
	StartStoredProcedure("UpdateBoardPromoElementKeyPhrases");
	AddParam("BoardPromoID", iBoardPromoID);
	if ( !sPhrases.IsEmpty() )
	{
		AddParam("KeyPhrases", sPhrases);
	}
	AddParam("bdefault",bDefault);
	
	ExecuteStoredProcedure();
	if ( HandleError("UpdateBoardPromoElementKeyPhrases") )
		return false;

	return true;
}

bool CStoredProcedure::UpdateTextBoxKeyPhrases( int iTextBoxID, const std::vector<PHRASE>& vPhrases)
{
	CTDVString sPhrases;
	for ( std::vector<PHRASE>::const_iterator iter = vPhrases.begin(); iter != vPhrases.end(); ++iter )
	{
		CTDVString sPhrase = iter->m_Phrase;

		//Handle empty key phrase 
		if ( sPhrase == "" )
			sPhrase = "|";
		sPhrases << ( sPhrases.IsEmpty() ? "" : "|" ) << sPhrase;
	}
	StartStoredProcedure("UpdateTextBoxElementKeyPhrases");
	AddParam("TextBoxID", iTextBoxID);
	AddParam("KeyPhrases", sPhrases);
	ExecuteStoredProcedure();
	if ( HandleError("UpdateTextBoxPhrases") )
		return false;

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::PollGetItemIDs(std::vector<int> & vecItemIDs, int nPollID, CPoll::ItemType nItemType)

		Author:		James Pullicino
        Created:	21/02/2005

        Inputs:		nItemType - Type of items for which to get IDs. Set to ITEMTYPE_UNKNOWN
								to get ids of all items.

        Outputs:	On Success, vecItemIDs is emptied and populated with Item IDs
        
		Returns:	true/false

        Purpose:	Gets IDs of items that a poll is linked to

*********************************************************************************/

bool CStoredProcedure::PollGetItemIDs(std::vector<int> & vecItemIDs, int nPollID, int nItemType)
{
	StartStoredProcedure("pollgetitemids");
	
	AddParam(nPollID);
	AddParam(nItemType);

	if(!ExecuteStoredProcedure() || HandleError("PollGetItemIDs"))
	{
		TDVASSERT(false, "CStoredProcedure::PollGetItemIDs() Failed to execute stored procedure");
		return false;
	}

	// Populate vector
	vecItemIDs.clear();
	while(!IsEOF())
	{
		vecItemIDs.push_back(GetIntField("ItemID"));
		MoveNext();
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::PollGetArticleAuthorID(int & nAuthorID, int nArticleID)

		Author:		James Pullicino
        Created:	21/02/2005
        Inputs:		nArticleID - H2G2ID of article
        Outputs:	On Success, nAuthorID is set to author id of article (Editor field)
        Returns:	true/false
        Purpose:	Gets Author ID of article

*********************************************************************************/

bool CStoredProcedure::PollGetArticleAuthorID(int & nAuthorID, int nArticleID)
{
	StartStoredProcedure("pollgetarticleauthorid");
	AddParam(nArticleID);
	if(!ExecuteStoredProcedure() || HandleError("PollGetArticleAuthorID"))
	{
		TDVASSERT(false, "CStoredProcedure::PollGetArticleAuthorID() Failed to execute stored procedure");
		return false;
	}

	// Invalid ArticleID?
	if(IsEOF()) return false;

	nAuthorID = GetIntField("Editor");

	return true;
}


/*********************************************************************************

	bool CStoredProcedure:FetchGroupsAndMembers()

		Author:		James Pullicino
        Created:	08/04/2005
        Purpose:	Loads all groups and members from database

*********************************************************************************/

bool CStoredProcedure::FetchGroupsAndMembers()
{
	StartStoredProcedure("fetchgroupsandmembers");
	if(!ExecuteStoredProcedure() || HandleError("FetchGroupsAndMembers"))
	{
		TDVASSERT(false, "CStoredProcedure::FetchGroupsAndMembers() Failed to execute stored procedure");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure:FetchGroupsForUser()

		Author:		Jim Lynn
        Created:	11/09/2007
        Purpose:	Fetches all the groups on all sites of which the user is a member

*********************************************************************************/

bool CStoredProcedure::FetchGroupsForUser(int iUserID)
{
	StartStoredProcedure("fetchgroupsforuser");
	AddParam("userid",iUserID);
	if(!ExecuteStoredProcedure() || HandleError("FetchGroupsForUser"))
	{
		TDVASSERT(false, "CStoredProcedure::FetchGroupsForUser() Failed to execute stored procedure");
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::CreateCategoryList(int iUserID, int iSiteID, const TDVCHAR* psDescription)

		Author:		Mark Howitt
        Created:	30/03/2005
        Inputs:		iUserID - The Id of the user who created the list.
					iSiteID - the ID of the site that the list was created for
					psDescription - A String that describes the list
					psWebSiteURL - the website the category list is going to be on.
					iOwnerFlag - flag indicating if category list create is owner of the site.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Creates a new Category List for a given user on a given site.

*********************************************************************************/
bool CStoredProcedure::CreateCategoryList(int iUserID, int iSiteID, const TDVCHAR* psDescription, const TDVCHAR* psWebSiteURL, int iOwnerFlag)
{
	// Start the procedure
	StartStoredProcedure("createcategorylist");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	AddParam("description",psDescription);
	AddParam("website",psWebSiteURL);
	AddParam("isowner",iOwnerFlag);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("CreateCategoryList"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::DeleteCategoryList(CTDVString& sCategoryListID)

		Author:		Mark Howitt
        Created:	30/03/2005
        Inputs:		sCategoryListID - The ID of the list you want to delete
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Deletes the the Category List that matches the ID

*********************************************************************************/
bool CStoredProcedure::DeleteCategoryList(CTDVString& sCategoryListID)
{
	// Start the procedure
	StartStoredProcedure("deletecategorylist");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DeleteCategoryList"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddNodeToCategoryList(CTDVString& sCategoryListID, int iNodeID)

		Author:		Mark Howitt
        Created:	30/03/2005
        Inputs:		sCategoryListID - The Id of the category list you want to add the node to.
					iNodeID - the ID of the node you want to add to the list
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Addes the given node id to the category list with the given id

*********************************************************************************/
bool CStoredProcedure::AddNodeToCategoryList(CTDVString& sCategoryListID, int iNodeID)
{
	// Start the procedure
	StartStoredProcedure("addnodetocategorylist");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}

	AddParam("nodeid",iNodeID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddNodeToCategoryList"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveNodeFromCategoryList(CTDVString& sCategoryListID, int iNodeID)

		Author:		Mark Howitt
        Created:	30/03/2005
        Inputs:		sCategoryListID - THe id of the category you want to remove the node from.
					iNodeID - the ID of the node you want to remove from the list
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Removes a given node from a given category list.

*********************************************************************************/
bool CStoredProcedure::RemoveNodeFromCategoryList(CTDVString& sCategoryListID, int iNodeID)
{
	// Start the procedure
	StartStoredProcedure("deletecategorylistmember");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}

	AddParam("nodeid",iNodeID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("RemoveNodeFromCategoryList"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RenameCategoryList(CTDVString& sCategoryListID, const TDVCHAR* psDescription)

		Author:		Mark Howitt
        Created:	30/03/2005
        Inputs:		sCategoryListID - The ID of the list you want to rename.
					psDescription - The new name for the category list
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Renames the given category list

*********************************************************************************/
bool CStoredProcedure::RenameCategoryList(CTDVString& sCategoryListID, const TDVCHAR* psDescription)
{
	// Start the procedure
	StartStoredProcedure("renamecategorylist");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}

	AddParam("description",psDescription);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("RenameCategoryList"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetListWidth(CTDVString& sCategoryListID, int iListWidth)

		Author:		James Conway
        Created:	30/03/2005
        Inputs:		sCategoryListID - The ID of the list you want to rename.
					iListWidth - The new width for the category list
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Renames the given category list

*********************************************************************************/
bool CStoredProcedure::SetListWidth(CTDVString& sCategoryListID, int iListWidth)
{
	// Start the procedure
	StartStoredProcedure("setcategorylistwidth");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}

	AddParam("listwidth",iListWidth);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("setcategorylistwidth"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetCategoryListNodes(CTDVString& sCategoryListID)

		Author:		Mark Howitt
        Created:	31/03/2005
        Inputs:		sCategoryListID - The id of the category you want to get the list of nodes for.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets a list of all the nodes for a given list

*********************************************************************************/
bool CStoredProcedure::GetCategoryListNodes(CTDVString& sCategoryListID)
{
	// Start the procedure
	StartStoredProcedure("getcategorylistnodes");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetCategoryListNodes"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetCategoryListLastUpdated(CTDVString& sCategoryListID)

		Author:		Mark Howitt
        Created:	05/04/2005
        Inputs:		sCategoryListID - The Id of the list you want to get the lastupdated value for.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the last updated date for a given category list

*********************************************************************************/
bool CStoredProcedure::GetCategoryListLastUpdated(CTDVString& sCategoryListID)
{
	// Start the procedure
	StartStoredProcedure("getcategorylistlastupdated");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetCategoryListLastUpdated"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetCategoryListOwner(CTDVString& sCategoryListID)

		Author:		Mark Howitt
        Created:	05/04/2005
        Inputs:		sCategoryLIstID - the id of the list you want to get the owner for
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Gets the id of the user who owns the the category with the given category list id

*********************************************************************************/
bool CStoredProcedure::GetCategoryListOwner(CTDVString& sCategoryListID)
{
	// Start the procedure
	StartStoredProcedure("getcategorylistowner");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetCategoryListOwner"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetCategoryListsForUser(int iUserID, int iSiteID)

		Author:		Mark Howitt
        Created:	05/04/2005
        Inputs:		iUserID - THe Id of the user that you want to get the lists for.
					iSiteID - the id of the site that you  want to get the lists from.
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets all the lists for a gaiven user on a given site.

*********************************************************************************/
bool CStoredProcedure::GetCategoryListsForUser(int iUserID, int iSiteID)
{
	// Start the procedure
	StartStoredProcedure("getcategorylistsforuser");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetCategoryListsForUser"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetCategoryListForGUID(CTDVString& sCategoryListID)

		Author:		Mark Howitt
        Created:	05/04/2005
        Inputs:		sCategoryListID - the id of the list you want to get
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the category list with for the given ID

*********************************************************************************/
bool CStoredProcedure::GetCategoryListForGUID(CTDVString& sCategoryListID)
{
	// Start the procedure
	StartStoredProcedure("getcategorylistforguid");

	// Setup the params
	if (!AddUIDParam("categorylistid",sCategoryListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetCategoryListForGUID"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateEmailAlertList(int iUserID, int iSiteID, int iEmailType)

		Author:		Mark Howitt
        Created:	08/04/2005
        Inputs:		iUserID - The ID of the user who will own the list
					iSiteID - THe Site that the list belongs to.
					iEmailType - The type of email list you want to update.
								 1 = normal, 2 = instant
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Creates a new Email Alert List of a given type

*********************************************************************************/
bool CStoredProcedure::CreateEmailAlertList(int iUserID, int iSiteID, int iEmailType)
{
	// Check which type of list and Start the procedure
	if (iEmailType == 1)
	{
		// Normal EMail List
		StartStoredProcedure("createemailalertlist");
	}
	else if (iEmailType == 2)
	{
		// Instant Email List
		StartStoredProcedure("createinstantemailalertlist");
	}
	else
	{
		// Not Valid!!!
		TDVASSERT(false,"Invalid Email Type Given!!!");
		return false;
	}

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("CreateEmailAlertList"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddItemToEmailAlertList(int iItemID, int iItemType, int iNotificationType, CTDVString& sEmailAlertListID, int iEmailType)

		Author:		Mark Howitt
        Created:	08/04/2005
        Inputs:		iItemID - The Id of the Item you are wanting to add.
					iItemType - The Type of item you are wanting to add
					iNotificationType - The Type of notification tyou want to use.
										1 - EMail, 2 - Message
					sEmailAlertListID - THe ID of the list you want to add the item to.
					iEmailType - The type of email list you want to update.
								 1 = normal, 2 = instant
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Adds a given Item of a given type to a email list

*********************************************************************************/
bool CStoredProcedure::AddItemToEmailAlertList(int iItemID, int iItemType, int iNotificationType, CTDVString& sEmailAlertListID, int iEmailType)
{
	// Check which type of list and Start the procedure
	if (iEmailType == 1)
	{
		// Normal EMail List
		StartStoredProcedure("additemtoemailalertlist");
	}
	else if (iEmailType == 2)
	{
		// Instant Email List
		StartStoredProcedure("additemtoinstantemailalertlist");
	}
	else
	{
		// Not Valid!!!
		TDVASSERT(false,"Invalid Email Type Given!!!");
		return false;
	}

	// Setup the params
	AddParam("itemid",iItemID);
	AddParam("itemtype",iItemType);
	AddParam("notifytype",iNotificationType);

	// Add the UID to the param list
	if (!AddUIDParam("emailalertlistid",sEmailAlertListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddItemToEmailAlertList"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetEMailListsForUser(int iUserID, int iSiteID, int iEmailType)

		Author:		Mark Howitt
        Created:	12/04/2005
        Inputs:		iUserID - The Id of the user you want to get the list for
					iSiteID - The Id of the site the list belongs to.
					iEmailType - THe type of email list you look for.
								 1 = normal, 2 = instant
        Outputs:	-
        Returns:	true if ok, fasle if not
        Purpose:	Gets the email list for the given type for a given user on a given site.

*********************************************************************************/
bool CStoredProcedure::GetEMailListsForUser(int iUserID, int iSiteID, int iEmailType)
{
	// Check which type of list and Start the procedure
	if (iEmailType == 1)
	{
		// Normal EMail List
		StartStoredProcedure("getemaillistsforuser");
	}
	else if (iEmailType == 2)
	{
		// Instant Email List
		StartStoredProcedure("getinstantemaillistsforuser");
	}
	else
	{
		// Not Valid!!!
		TDVASSERT(false,"Invalid Email Type Given!!!");
		return false;
	}

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetEMailListsForUser"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveItemFromEmailList(int iMemberID, CTDVString& sEmailAlertListID, int iEmailType)

		Author:		Mark Howitt
        Created:	12/04/2005
        Inputs:		iMemberID - The memberid of the item you want to remove.
					sEMailAlertListID - The ID of the list you want to remove.
					iEmailType - The Type of email list to remove from.
								 1 = normal, 2 = instant
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes a given item from a given email list.

*********************************************************************************/
bool CStoredProcedure::RemoveItemFromEmailList(int iMemberID, CTDVString& sEmailAlertListID, int iEmailType)
{
	// Check which type of list and Start the procedure
	if (iEmailType == 1)
	{
		// Normal EMail List
		StartStoredProcedure("removeitemfromemaillist");
	}
	else if (iEmailType == 2)
	{
		// Instant Email List
		StartStoredProcedure("removeitemfrominstantemaillist");
	}
	else
	{
		// Not Valid!!!
		TDVASSERT(false,"Invalid Email Type Given!!!");
		return false;
	}

	// Setup the params
	AddParam("memberid",iMemberID);

	// Add the UID to the param list
	if (!AddUIDParam("emailalertlistid",sEmailAlertListID))
	{
		return false;
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("RemoveItemFromEmailList"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ChangeEMailListTypeForItemMember(int iUserID, int iSiteID, int iMemberID, int iCurrentListType, int iNewListType)

		Author:		Mark Howitt
        Created:	16/11/2004
        Inputs:		iUserId - the Id of the user who owns the list and member
					iSiteID - the id of the site the member should belong to
					iMemberID - The id of the member in the email members list
					iCurrentListType - the type of list you want to move the member from
										 1 = normal, 2 = instant
					iNewListType - the type of list you want to move the memebr to.
										 1 = normal, 2 = instant
        Outputs:	-
        Returns:	true if ok ,false if not
        Purpose:	Moves an item from one type of email list to the other.

*********************************************************************************/
bool CStoredProcedure::ChangeEMailListTypeForItemMember(int iUserID, int iSiteID, int iMemberID, int iCurrentListType, int iNewListType)
{
	// Start the procedure
	if (iCurrentListType == 1 && iNewListType == 2)
	{
		// Move from normal to instant
		StartStoredProcedure("makenormalitemmemberaninstantalert");
	}
	else if (iCurrentListType == 2 && iNewListType == 1)
	{
		// Move from instant to normal
		StartStoredProcedure("makeinstantitemmemberanormalalert");
	}
	else
	{
		// Can't do this operation!!!
		TDVASSERT(false,"CStoredProcedure::ChangeEMailListTypeForItemMember - Invalid List Types used");
		return false;
	}

	// Add the params, if any
	AddParam("memberid", iMemberID);
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("ChangeEMailListTypeForItemMember"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetItemDetailsFromEMailALertMemberID(int iEMailListType, int iMemberID)

		Author:		Mark Howitt
		Created:	13/04/2005
		Inputs:		iEMailListType - The type of email list the member belongs to.
								 1 = normal, 2 = instant
					iMemberID - The ID of the member you want to get the details for.
		Outputs:	-
		Returns:	true if ok, false if not.
		Purpose:	Gets all the details for a given member in a given email list type.
		
*********************************************************************************/
bool CStoredProcedure::GetItemDetailsFromEMailALertMemberID(int iEMailListType, int iMemberID)
{
	// Check which type of list and Start the procedure
	if (iEMailListType == 1)
	{
		// Normal EMail List
		StartStoredProcedure("getitemdetailsfromemailalertmemberid");
	}
	else if (iEMailListType == 2)
	{
		// Instant Email List
		StartStoredProcedure("getitemdetailsfrominstantemailalertmemberid");
	}
	else
	{
		// Not Valid!!!
		TDVASSERT(false,"Invalid Email Type Given!!!");
		return false;
	}

	// Setup the params
	AddParam("memberid",iMemberID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetItemDetailsFromEMailALertMemberID"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetNotificationTypeForEmailAlertItem(int iMemberID, int iNotifyType, int iEmailListType, CTDVString& sEmailAlertListID)

		Author:		Mark Howitt
        Created:	14/04/2005
        Inputs:		iMemberID - The Id of the member you want to change the notification type for.
					iNotifyType - the New Notification type for the member.
					iEmailType - The type of email list the member belongs to.
					sEmailAlertlistID - the ID of the list that the member belongs to.
        Outputs:	-
        Returns:	true if ok, false if not.
        Purpose:	Sets the notification type for a given member of a given email list.

*********************************************************************************/
bool CStoredProcedure::SetNotificationTypeForEmailAlertItem(int iMemberID, int iNotifyType, int iEmailListType, CTDVString& sEmailAlertListID)
{
	// Check which type of list and Start the procedure
	if (iEmailListType == 1)
	{
		// Normal EMail List
		StartStoredProcedure("setnotifytypeforemaillistmember");
	}
	else if (iEmailListType == 2)
	{
		// Instant Email List
		StartStoredProcedure("setnotifytypeforinstantemaillistmember");
	}
	else
	{
		// Not Valid!!!
		TDVASSERT(false,"Invalid Email Type Given!!!");
		return false;
	}

	// Setup the params
	AddParam("memberid",iMemberID);
	AddParam("notifytype",iNotifyType);

	// Add the UID to the param list
	bool bUIDOk = false;
	if (iEmailListType == 1)
	{
		bUIDOk = AddUIDParam("emailalertlistid",sEmailAlertListID);
	}
	else if (iEmailListType == 2)
	{
		bUIDOk = AddUIDParam("instantemailalertlistid",sEmailAlertListID);
	}

	// Check to make sure the UID got added ok
	if (!bUIDOk)
	{
		return false;
	}

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetItemDetailsFromEMailALertMemberID"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetEMailListForEmailAlertListID(int iEmailListType, const TDVCHAR* psEmailAlertListID)

		Author:		Mark Howitt
        Created:	15/04/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::GetEMailListForEmailAlertListID(int iEmailListType, const TDVCHAR* psEmailAlertListID)
{
	// Start the procecdure
	StartStoredProcedure("getemailalertlistforguid");

	// Setup the params
	AddParam("emaillisttype",iEmailListType);

	// Add the UID to the param list
	if (!AddUIDParam("emailalertlistid",psEmailAlertListID))
	{
		return false;
	}

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetEMailListForEmailAlertListID"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetVotesCastByUser( int iUserID, int iSiteID)

		Author:		DE
        Created:	11/05/2005
        Inputs:		-iUser : id of the user whose votes are to be obtained
						-iSiteID : the id of the site - usually 16 for ican
        Outputs:	-true if successful, false otherwise
        Returns:	-returns a resultset containing details of all the threads and clubs a user 
						-has voted for. In Ican these translates as Notices and Campaigns 
        Purpose:	-Get all the items a user has voted for

*********************************************************************************/

bool CStoredProcedure::GetVotesCastByUser( int iUserID, int iSiteID)
{
	// Start the procecdure
	StartStoredProcedure("getvotescastbyuser");

	// Setup the params
	AddParam("iuserid",iUserID);
	AddParam("isiteid",iSiteID);

	
	// Execute the procedure
	ExecuteStoredProcedure();

	//handle error, if any
	if (HandleError("GetVotesCastByUser"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetClubsArticleLinksTo(int iArticleID)

		Author:		James Pullicino
        Created:	06/06/2005
        Inputs:		iArticleID - ID of article
        Outputs:	-
        Returns:	-
        Purpose:	Get all clubs that this article links to 

*********************************************************************************/

bool CStoredProcedure::GetClubsArticleLinksTo(int iArticleID)
{
	// Start the procecdure
	StartStoredProcedure("getclubsarticlelinksto");
	AddParam("articleid",iArticleID);
    if(!ExecuteStoredProcedure() || HandleError("FetchGroupsAndMembers"))
	{
		TDVASSERT(false, "CStoredProcedure::GetClubsArticleLinksTo() Error executing sp");
		return false;
	}

	return true;
}

bool CStoredProcedure::GetThreadsWithKeyPhrases(const CTDVString& sPhrases, int iSkip, int iShow)
{
	StartStoredProcedure("getthreadswithkeyphrases");
	AddParam("keyphraselist",sPhrases);
	AddParam("siteid",m_SiteID);
	AddParam("firstindex",iSkip);
	AddParam("lastindex",iSkip + iShow);
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError("GetThreadsWithKeyPhrases"); 
	}
	return true;
}

bool CStoredProcedure::GetKeyPhrasesForSite( int iSiteID )
{
	StartStoredProcedure("getkeyphrasesforsite");
	AddParam("siteid",iSiteID);
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError("GetKeyPhrasesForSite"); 
	}
	return true;
}

bool CStoredProcedure::GetKeyPhrasesFromThread( int iThreadID )
{
	StartStoredProcedure("getkeyphrasesfromthread");
	AddParam("threadId", iThreadID );
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError("GetKeyPhrasesromThread"); 
	}
	return true;
}

bool CStoredProcedure::AddKeyPhrasesToThread( int iThreadID, const CTDVString& sPhrases)
{
	StartStoredProcedure("addkeyphrasestothread");
	AddParam("threadid",iThreadID);
	AddParam("keywords",sPhrases);
	ExecuteStoredProcedure();
	return !HandleError("AddKeyPhrasesToThread");
}

bool CStoredProcedure::GetKeyPhraseHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy )
{
	if ( sPhrases.IsEmpty() )
	{
		//get ranked results of key phrases.
		StartStoredProcedure("getkeyphrasehotlist");
		AddParam("siteid",iSiteId);
		AddParam("skip",iSkip);
		AddParam("show",iShow);
		if ( sSortBy == "Phrase" )
		{
			AddParam("sortbyphrase", 1);
		}
	}
	else
	{
		//Get ranked results of associated keyphrases.
		StartStoredProcedure("getkeyphrasehotlistwithphrase");
		AddParam("siteid",iSiteId);
		AddParam("keyphraselist",sPhrases);
		AddParam("skip",iSkip);
		AddParam("show",iShow);
		if ( sSortBy == "Phrase" )
		{
			AddParam("sortbyphrase", 1);
		}
	}
	ExecuteStoredProcedure();
	return !HandleError("getkeyphrasehotlist");
}

/*********************************************************************************

	bool CStoredProcedure::GetKeyPhraseScore(sPhrasesToScore,sFilter,iSite)

		Author:		Martin Robb
        Created:	20/07/2005
        Inputs:		- sPhrasesToScore, sKeyPhraseFilter, SiteId
        Outputs:	-
        Returns:	-
        Purpose:	- Score (using contentsgnif for threads associated with phrases ) the list of key phrases with a further optional list of key phrases as a filter.

*********************************************************************************/
bool CStoredProcedure::GetKeyPhraseScore(int iSiteId, const CTDVString& sPhrasesToScore, const CTDVString& sFilter )
{
	if ( sFilter.IsEmpty() )
	{
		StartStoredProcedure("getkeyphrasescore");
		AddParam("keyphraselist",sPhrasesToScore);
		AddParam("siteid",iSiteId);
	}
	else
	{
		StartStoredProcedure("getkeyphrasesscorewithphrase");
		AddParam("filterlist",sPhrasesToScore);
		AddParam("keyphrases",sFilter);
		AddParam("siteid",iSiteId);
	}
	ExecuteStoredProcedure();
	return !HandleError("getkeyphrasescore");
}

/*********************************************************************************

	bool CStoredProcedure::GetKeyPhraseScore(sPhrasesToScore,sFilter,iSite)

		Author:		Martin Robb
        Created:	20/07/2005
        Inputs:		- sPhrasesToScore, sKeyPhraseFilter, SiteId
        Outputs:	-
        Returns:	-
        Purpose:	- Score (using contentsgnif for threads associated with phrases ) the list of key phrases with a further optional list of key phrases as a filter.

*********************************************************************************/
bool CStoredProcedure::GetSiteKeyPhraseScores(int iSiteId, const CTDVString& sFilter )
{
	if ( sFilter.IsEmpty() )
	{
		StartStoredProcedure("getkeyphrasesforsitescores");
		AddParam("siteid",iSiteId);
	}
	else
	{
		StartStoredProcedure("getkeyphrasesforsitescoreswithfilter");
		AddParam("keyphrases",sFilter);
		AddParam("siteid",iSiteId);
	}
	ExecuteStoredProcedure();
	return !HandleError("getkeyphrasescore");
}

/*********************************************************************************
bool CStoredProcedure::AddKeyPhrasesToMediaAsset( int iAssetID, const CTDVString& sPhrases)
Author:		Martin Robb
Created:	26/10/2005
Inputs:		int iAsetId 
			sPhrases comma separated list of phrases to add to asset.
Purpose:	Get key phrases for the provided asset.
*********************************************************************************/
bool CStoredProcedure::AddKeyPhrasesToMediaAsset( int iAssetID, const CTDVString& sPhrases)
{
	StartStoredProcedure("AddKeyPhrasesToMediaAsset");
	AddParam("assetid",iAssetID);
	AddParam("keywords",sPhrases);
	ExecuteStoredProcedure();
	return !HandleError("AddKeyPhrasesToMediaAsset");
}

/*********************************************************************************
bool CStoredProcedure::AddKeyPhrasesToArticle( int iH2G2ID, const CTDVString& sPhrases)
Author:		Steven Francis
Created:	14/12/2005
Inputs:		int iH2G2Id 
			sPhrases comma separated list of phrases to add to the aticle.
Purpose:	Add key phrases to the provided article.
*********************************************************************************/
bool CStoredProcedure::AddKeyPhrasesToArticle( int iH2G2ID, const CTDVString& sPhrases)
{
	StartStoredProcedure("AddKeyPhrasesToArticle");
	AddParam("h2g2id", iH2G2ID);
	AddParam("keywords", sPhrases);
	ExecuteStoredProcedure();
	return !HandleError("AddKeyPhrasesToArticle");
}

/*********************************************************************************
bool CStoredProcedure::AddKeyPhrasesToArticle( int iH2G2ID, const CTDVString& sPhrases)
Author:		David Williams
Created:	18/05/2007
Inputs:		int iH2G2Id 
			sPhrases comma separated list of phrases to add to the aticle.
Purpose:	Add key phrases to the provided article.
*********************************************************************************/
bool CStoredProcedure::AddKeyPhrasesToArticleWithNamespaces( int iH2G2ID, const CTDVString& sPhrases, const CTDVString& sNamespaces)
{
	StartStoredProcedure("AddKeyPhrasesToArticle");
	AddParam("h2g2id", iH2G2ID);
	AddParam("keywords", sPhrases);
	AddParam("namespaces", sNamespaces);
	ExecuteStoredProcedure();
	return !HandleError("AddKeyPhrasesToArticle");
}

/*********************************************************************************
bool CStoredProcedure::GetMediaAssetsWithKeyPhrases(const CTDVString& sPhrases, int iContentType, int iSkip, int iShow, CTDVString sSortBy)
Author:		Martin Robb
Created:	26/10/2005
Inputs:		sPhrases - comma separated - search citeria
			iContentTYpe - additional filter on content type.
			skip & show
			sSortBy - sort by caption or sort by date (latest first)( default ).
Purpose:	Get key phrases for the provided asset.
*********************************************************************************/
bool CStoredProcedure::GetMediaAssetsWithKeyPhrases(const CTDVString& sPhrases, int iContentType, int iSkip, int iShow, CTDVString sSortBy)
{
	CTDVString strStoredProcedureName = "";
	if ( sPhrases.IsEmpty() )
	{
		if (iContentType == 1)
		{
			strStoredProcedureName = "getimageassetsforsite";
		}
		else if (iContentType == 2)
		{
			strStoredProcedureName = "getaudioassetsforsite";
		}
		else if (iContentType == 3)
		{
			strStoredProcedureName = "getvideoassetsforsite";
		}
		else //iContentType = 0
		{
			strStoredProcedureName = "getmediaassetsforsite";
		}
		// Start the procecdure
		StartStoredProcedure(strStoredProcedureName);

	}
	else
	{
		if (iContentType == 1)
		{
			strStoredProcedureName = "getimageassetswithkeyphrases";
		}
		else if (iContentType == 2)
		{
			strStoredProcedureName = "getaudioassetswithkeyphrases";
		}
		else if (iContentType == 3)
		{
			strStoredProcedureName = "getvideoassetswithkeyphrases";
		}
		else //iContentType = 0
		{
			strStoredProcedureName = "getmediaassetswithkeyphrases";
		}
		// Start the procecdure
		StartStoredProcedure(strStoredProcedureName);

		AddParam("keyphraselist",sPhrases);

	}
	AddParam("siteid",m_SiteID);
	AddParam("firstindex",iSkip);
	AddParam("lastindex",iSkip + iShow);

	if ( sSortBy == "Caption" )
	{
		AddParam("sortbycaption", 1);
	}

	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError(strStoredProcedureName); 
	}
	return true;
}

/*********************************************************************************
bool CStoredProcedure::GetArticlesWithKeyPhrases(const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy)
Author:		Steven Francis
Created:	14/12/2005
Inputs:		sPhrases - comma separated - search citeria
			iContentType - -1 just Articles, 
							0 Articles with Media Assets, 
							1 with Image Assets, 
							2 with Audio Assets, 
							3 with Video Assets
			skip & show
			sSortBy - sort by subject/caption or sort by date (latest first)( default ).
Purpose:	Get articles for the provided key phrases.
*********************************************************************************/
bool CStoredProcedure::GetArticlesWithKeyPhrases(const CTDVString& sPhrases, int iContentType, int iSkip, int iShow, CTDVString sSortBy)
{
	CTDVString strStoredProcedureName = "";

	strStoredProcedureName = "getarticles_dynamic"; 
	
	// Start the procecdure
	StartStoredProcedure(strStoredProcedureName);

	if (!sPhrases.IsEmpty())
	{
		AddParam("keyphraselist",sPhrases);
	}
	AddParam("siteid", m_SiteID);
	AddParam("firstindex", iSkip + 1); // First Index starts at 1.
	AddParam("lastindex", iSkip + iShow);

	if (iContentType > -1)
	{
		AddParam("assettype", iContentType);
	}

	if ( sSortBy == "Caption" )
	{
		AddParam("sortbycaption", 1);
	}
	else if ( sSortBy == "Rating" )
	{
		AddParam("sortbyrating", 1);
	}
    else if ( sSortBy == "ForumPostCount" )
    {
        AddParam("sortbypostcount", 1);
    }
    else if ( sSortBy == "LastUpdated" )
    {
        AddParam("sortbylastupdated", 1);
    }
    else if ( sSortBy == "ForumLastPosted" )
    {
        AddParam("sortbylastposted", 1);
    }

	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError(strStoredProcedureName); 
	}
	return true;
}

/*********************************************************************************
bool CStoredProcedure::GetKeyPhrasesFromMediaAsset( int iAssetID ) 
Author:		Martin Robb
Created:	26/10/2005
Inputs:		assetid, 
Purpose:	Get key phrases for the provided asset.
*********************************************************************************/
bool CStoredProcedure::GetKeyPhrasesFromMediaAsset(int iAssetID)
{
	StartStoredProcedure("getkeyphrasesfrommediaasset");
	AddParam("AssetId", iAssetID );
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError("GetKeyPhrasesFromMediaAsset"); 
	}
	return true;
}

/*********************************************************************************
bool CStoredProcedure::GetKeyPhrasesFromArticle( int iH2G2ID ) 
Author:		Steven Francis
Created:	14/12/2005
Inputs:		iH2G2ID, 
Purpose:	Get key phrases for the provided article.
*********************************************************************************/
bool CStoredProcedure::GetKeyPhrasesFromArticle(int iH2G2ID)
{
	StartStoredProcedure("getkeyphrasesfromarticle");
	AddParam("H2G2ID", iH2G2ID );
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError("getkeyphrasesfromarticle"); 
	}
	return true;
}

/*********************************************************************************
bool CStoredProcedure::GetKeyPhraseMediaAssetHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType )
Author:		Martin Robb
Created:	26/10/2005
Inputs:		siteid, 
			phrases filter - hot list will be based on assets that are associated with these phrases
			skp & show params 
			ssortByParam - sort by rank ( default ) or sort by phrase.
			iMediaAssetType - the media asset type to filter on.
Purpose:	Get a tag cloud based on the provided site and phrases filter.
*********************************************************************************/
bool CStoredProcedure::GetKeyPhraseMediaAssetHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType )
{
	CTDVString strStoredProcedureName = "";
	if ( sPhrases.IsEmpty() )
	{
		//get ranked results of key phrases.
		if (iMediaAssetType == 1)
		{
			strStoredProcedureName = "getkeyphraseimageassethotlist";
		}
		else if (iMediaAssetType == 2)
		{
			strStoredProcedureName = "getkeyphraseaudioassethotlist";
		}
		else if (iMediaAssetType == 3)
		{
			strStoredProcedureName = "getkeyphrasevideoassethotlist";
		}
		else //iMediaAssetType = 0
		{
			strStoredProcedureName = "getkeyphrasemediaassethotlist";
		}
		// Start the procecdure
		StartStoredProcedure(strStoredProcedureName);
		AddParam("siteid",iSiteId);
		AddParam("skip",iSkip);
		AddParam("show",iShow);
		if ( sSortBy == "Phrase" )
		{
			AddParam("sortbyphrase", 1);
		}
	}
	else
	{
		//Get ranked results of associated keyphrases.
		if (iMediaAssetType == 1)
		{
			strStoredProcedureName = "getkeyphraseimageassethotlistwithphrase";
		}
		else if (iMediaAssetType == 2)
		{
			strStoredProcedureName = "getkeyphraseaudioassethotlistwithphrase";
		}
		else if (iMediaAssetType == 3)
		{
			strStoredProcedureName = "getkeyphrasevideoassethotlistwithphrase";
		}
		else //iMediaAssetType = 0
		{
			strStoredProcedureName = "getkeyphrasemediaassethotlistwithphrase";
		}
		StartStoredProcedure(strStoredProcedureName);
		AddParam("siteid",iSiteId);
		AddParam("keyphraselist",sPhrases);
		AddParam("skip",iSkip);
		AddParam("show",iShow);
		if ( sSortBy == "Phrase" )
		{
			AddParam("sortbyphrase", 1);
		}
	}
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError(strStoredProcedureName); 
	}
	return true;
}

/*********************************************************************************
bool CStoredProcedure::GetKeyPhraseArticleHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy)
Author:		Steven Francis
Created:	16/12/2005
Inputs:		siteid, 
			phrases filter - hot list will be based on articles that are associated with these phrases
			skp & show params 
			ssortByParam - sort by rank ( default ) or sort by phrase.
			iMediaAssetType - the media asset type to filter on.
Purpose:	Get a tag cloud based on the provided site and phrases filter.
*********************************************************************************/
bool CStoredProcedure::GetKeyPhraseArticleHotList( int iSiteId, const CTDVString& sPhrases, int iSkip, int iShow, CTDVString sSortBy, int iMediaAssetType )
{
	CTDVString strStoredProcedureName = "";
	if ( sPhrases.IsEmpty() )
	{
		if (iMediaAssetType == -1)
		{
			strStoredProcedureName = "getkeyphrasearticlehotlist";
		}
		else if (iMediaAssetType == 1)
		{
			strStoredProcedureName = "getkeyphrasearticleimageassethotlist";
		}
		else if (iMediaAssetType == 2)
		{
			strStoredProcedureName = "getkeyphrasearticleaudioassethotlist";
		}
		else if (iMediaAssetType == 3)
		{
			strStoredProcedureName = "getkeyphrasearticlevideoassethotlist";
		}
		else //iMediaAssetType = 0
		{
			//Just get the hotlist of  the articles with an media asset of any type
			strStoredProcedureName = "getkeyphrasearticlemediaassethotlist";
		}

		// Start the procecdure
		StartStoredProcedure(strStoredProcedureName);
		AddParam("siteid",iSiteId);
		AddParam("skip",iSkip);
		AddParam("show",iShow);
		if ( sSortBy == "Phrase" )
		{
			AddParam("sortbyphrase", 1);
		}
	}
	else
	{
		if (iMediaAssetType == -1)
		{
			strStoredProcedureName = "getkeyphrasearticlehotlistwithphrase";
		}
		else if (iMediaAssetType == 1)
		{
			strStoredProcedureName = "getkeyphrasearticleimageassethotlistwithphrase";
		}
		else if (iMediaAssetType == 2)
		{
			strStoredProcedureName = "getkeyphrasearticleaudioassethotlistwithphrase";
		}
		else if (iMediaAssetType == 3)
		{
			strStoredProcedureName = "getkeyphrasearticlevideoassethotlistwithphrase";
		}
		else //iMediaAssetType = 0
		{
			//Just get the hotlist of the articles with an media asset of any type with that phrase
			strStoredProcedureName = "getkeyphrasearticlemediaassethotlistwithphrase";
		}

		// Start the procecdure
		StartStoredProcedure(strStoredProcedureName);
		AddParam("siteid",iSiteId);
		AddParam("keyphraselist",sPhrases);
		AddParam("skip",iSkip);
		AddParam("show",iShow);
		if ( sSortBy == "Phrase" )
		{
			AddParam("sortbyphrase", 1);
		}
	}
	if ( !ExecuteStoredProcedure() )
	{
		return !HandleError(strStoredProcedureName); 
	}
	return true;
}

/*********************************************************************************
bool CStoredProcedure::UpdateFastMod(int iSiteId, int iForumId, bool bFastMod)
Author:		Igor Loboda
Created:	11/07/2005
Purpose:	updates fast mod flag of given forum on give site
*********************************************************************************/

bool CStoredProcedure::UpdateFastMod(int iSiteId, int iForumId, bool bFastMod)
{
	CTDVString temp;

	StartStoredProcedure("updatefastmod");
	AddParam("siteId", iSiteId);
	AddParam("forumid", iForumId);
	AddParam("fastmod", bFastMod);
	ExecuteStoredProcedure();
	return !HandleError("updatefastmod");
}

/*********************************************************************************

	bool CStoredProcedure::DynamicListsGetGlobal()

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets all global dynamic lists

*********************************************************************************/

bool CStoredProcedure::DynamicListsGetGlobal()
{
	StartStoredProcedure("dynamiclistsgetglobal");

	if(!ExecuteStoredProcedure() || HandleError("dynamiclistsgetglobal"))
	{
		TDVASSERT(false, "CStoredProcedure::dynamiclistsgetglobal() Error executing sp");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetDynamicListXML(const TDVCHAR* ListName)

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		ListName - Name of dynamic list
        Outputs:	Single 'xml' field
        Returns:	-
        Purpose:	Gets the XML schema for a dyanamic list

*********************************************************************************/

bool CStoredProcedure::GetDynamicListXML(const TDVCHAR* ListName)
{
	CTDVString StoredProcedureName = "dlist";
	StoredProcedureName	+= ListName;
	
	StartStoredProcedure(StoredProcedureName);
	AddParam("getxml", 1);
	
	if(!ExecuteStoredProcedure() || HandleError(StoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetDynamicListData(const TDVCHAR* ListName)

		Author:		James Pullicino
        Created:	19/07/2005
        Inputs:		ListName - Name of dynamic list
        Outputs:	Record for each item in dynamic list
        Returns:	-
        Purpose:	Runs dynamic list stored procedure

*********************************************************************************/

bool CStoredProcedure::GetDynamicListData(const TDVCHAR* ListName)
{
	CTDVString StoredProcedureName = "dlist";
	StoredProcedureName	+= ListName;

	StartStoredProcedure(StoredProcedureName);
	AddParam("getxml", 0);
	
	if(!ExecuteStoredProcedure() || HandleError(StoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetThreadDetails(int iThreadID)

		Author:		Mark Howitt
        Created:	26/07/2005
        Inputs:		iThreadID - The threadid you want to get the details for
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Fetches details about the given thread

*********************************************************************************/
bool CStoredProcedure::GetThreadDetails(int iThreadID)
{
	// Start the procecdure
	StartStoredProcedure("getthreaddetails");

	// Setup the params
	AddParam("threadid",iThreadID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetThreadDetails"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddClubAlertGroup(int iUserID, int iSiteID, int iItemID, int iNotifyType, int iAlertType, int& iGroupID, int& iResult)

		Author:		Mark Howitt
        Created:	10/08/2005
        Inputs:		iUserID - The id of the user who owns the alert
					iSiteID - the id of the site the club belongs to
					iClubID - The Id of the CLub you're adding
					iNotificationType - The type of notification the user will recieve
					iAlertType - the type of alert. Instant or normal
        Outputs:	iGroupID - This wioll take the id of the new alert group
					iResult - This will take the result infomation.
								1 = Everything went ok
								0 = Item does not exists
								-1 = Invalid Type given
								-2 = Insert into members table failed
								-3 = Update alert list failed
        Returns:	true if ok, false if not
        Purpose:	Adds a club to a users alert list and returns the new group id.

*********************************************************************************/
bool CStoredProcedure::AddClubAlertGroup(int iUserID, int iSiteID, int iClubID/*, int iNotifyType, int iAlertType*/, int& iGroupID, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("addclubalertgroup");

	// Setup the params
	AddParam("clubid",iClubID);
	AddParam("userid",iUserID);
//	AddParam("notifytype",iNotifyType);
	AddParam("siteid",iSiteID);
//	AddParam("listtype",iAlertType);

	// Now add the output values
	AddOutputParam(&iGroupID);
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddClubAlertGroup"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddNodeAlertGroup(int iUserID, int iSiteID, int iNodeID, int iNotifyType, int iAlertType, int& iGroupID, int& iResult)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - The id of the user who owns the alert
					iSiteID - the id of the site the club belongs to
					iNodeID - The Id of the Node you're adding
					iNotificationType - The type of notification the user will recieve
					iAlertType - the type of alert. Instant or normal
        Outputs:	iGroupID - This wioll take the id of the new alert group
					iResult - This will take the result infomation.
								1 = Everything went ok
								0 = Item does not exists
								-1 = Invalid Type given
								-2 = Insert into members table failed
								-3 = Update alert list failed
        Returns:	true if ok, false if not
        Purpose:	Adds a node to a users alert list and returns the new group id.

*********************************************************************************/
bool CStoredProcedure::AddNodeAlertGroup(int iUserID, int iSiteID, int iNodeID,/* int iNotifyType, int iAlertType, */int& iGroupID, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("addnodealertgroup");

	// Setup the params
	AddParam("nodeid",iNodeID);
	AddParam("userid",iUserID);
//	AddParam("notifytype",iNotifyType);
	AddParam("siteid",iSiteID);
//	AddParam("listtype",iAlertType);

	// Now add the output values
	AddOutputParam(&iGroupID);
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddNodeAlertGroup"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddThreadAlertGroup(int iUserID, int iSiteID, int iThreadID, int iNotifyType, int iAlertType, int& iGroupID, int& iResult)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - The id of the user who owns the alert
					iSiteID - the id of the site the club belongs to
					iThreadID - The Id of the Thread you're adding
					iNotificationType - The type of notification the user will recieve
					iAlertType - the type of alert. Instant or normal
        Outputs:	iGroupID - This wioll take the id of the new alert group
					iResult - This will take the result infomation.
								1 = Everything went ok
								0 = Item does not exists
								-1 = Invalid Type given
								-2 = Insert into members table failed
								-3 = Update alert list failed
        Returns:	true if ok, false if not
        Purpose:	Adds a thread to a users alert list and returns the new group id.

*********************************************************************************/
bool CStoredProcedure::AddThreadAlertGroup(int iUserID, int iSiteID, int iThreadID,/* int iNotifyType, int iAlertType, */int& iGroupID, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("addthreadalertgroup");

	// Setup the params
	AddParam("threadid",iThreadID);
	AddParam("userid",iUserID);
//	AddParam("notifytype",iNotifyType);
	AddParam("siteid",iSiteID);
//	AddParam("listtype",iAlertType);

	// Now add the output values
	AddOutputParam(&iGroupID);
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddClubAlertGroup"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddForumAlertGroup(int iUserID, int iSiteID, int iForumID, int iNotifyType, int iAlertType, int& iGroupID, int& iResult)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - The id of the user who owns the alert
					iSiteID - the id of the site the club belongs to
					iForumID - The Id of the Forum you're adding
					iNotificationType - The type of notification the user will recieve
					iAlertType - the type of alert. Instant or normal
        Outputs:	iGroupID - This wioll take the id of the new alert group
					iResult - This will take the result infomation...
								1 = Everything went ok
								0 = Item does not exists
								-1 = Invalid Type given
								-2 = Insert into members table failed
								-3 = Update alert list failed
		Returns:	true if ok, false if not
        Purpose:	Adds a forum to a users alert list and returns the new group id.

*********************************************************************************/
bool CStoredProcedure::AddForumAlertGroup(int iUserID, int iSiteID, int iForumID,/* int iNotifyType, int iAlertType, */int& iGroupID, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("addforumalertgroup");

	// Setup the params
	AddParam("forumid",iForumID);
	AddParam("userid",iUserID);
//	AddParam("notifytype",iNotifyType);
	AddParam("siteid",iSiteID);
//	AddParam("listtype",iAlertType);

	// Now add the output values
	AddOutputParam(&iGroupID);
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddForumAlertGroup"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddArticleAlertGroup(int iUserID, int iSiteID, int ih2g2ID, int iNotifyType, int iAlertType, int& iGroupID, int& iResult)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - The id of the user who owns the alert
					iSiteID - the id of the site the club belongs to
					ih2g2ID - The Id of the Article you're adding
					iNotificationType - The type of notification the user will recieve
					iAlertType - the type of alert. Instant or normal
        Outputs:	iGroupID - This wioll take the id of the new alert group
					iResult - This will take the result infomation.
								1 = Everything went ok
								0 = Item does not exists
								-1 = Invalid Type given
								-2 = Insert into members table failed
								-3 = Update alert list failed
        Returns:	true if ok, false if not
        Purpose:	Adds an Article to a users alert list and returns the new group id.

*********************************************************************************/
bool CStoredProcedure::AddArticleAlertGroup(int iUserID, int iSiteID, int ih2g2ID,/* int iNotifyType, int iAlertType, */int& iGroupID, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("addarticlealertgroup");

	// Setup the params
	AddParam("h2g2id",ih2g2ID);
	AddParam("userid",iUserID);
//	AddParam("notifytype",iNotifyType);
	AddParam("siteid",iSiteID);
//	AddParam("listtype",iAlertType);

	// Now add the output values
	AddOutputParam(&iGroupID);
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("AddArticleAlertGroup"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveGroupAlert(int iUserID, int iGroupID)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - the id of the user who wants to remove the group
					iGroupID - the id of the group that you want to remove
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Removes a given group

*********************************************************************************/
bool CStoredProcedure::RemoveGroupAlert(int iUserID, int iGroupID)
{
	// Start the procecdure
	StartStoredProcedure("deletealertgroup");

	// Setup the params
	AddParam("groupid",iGroupID);
	AddParam("userid",iUserID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("RemoveGroupAlert"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::EditGroupAlert(int iUserID, int iGroupID, int iNotifyType, int iAlertType, int& iResult)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - The id of the user who wants to make the changes
					iGroupID - the id of the group that they want to change
					iNotifyType - the new type of notification for the group
					iAlertType - the new type of alert for the group
        Outputs:	iResult - This will take the result of the action
        Returns:	true if ok, false if not
        Purpose:	Changes the alert and notification type for a given group

*********************************************************************************/
bool CStoredProcedure::EditGroupAlert(int iUserID, int iGroupID, int iNotifyType, int iAlertType, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("editgroupalert");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("groupid",iGroupID);
	AddParam("alerttype",iAlertType);
	AddParam("notifytype",iNotifyType);

	// Now add the output value
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("EditGroupAlert"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::EditGroupAlerts(int iUserID, int iSiteID, int iIsOwner, int iNotifyType, int iAlertType, int& iResult)

		Author:		Mark Howitt
        Created:	01/09/2005
        Inputs:		iUserID - The Id of the user who owns the alerts
					iSiteID - The Id of the site the groups belong to
					iIsOwner - A flag to state which group alerts to update. Ones you own or one you don't
					iNotifyType - the new type of notification you want
					iAlertType - How frequent do you wnat the alerts
        Outputs:	iResult - This will take the result of the update
        Returns:	true if ok, false if not
        Purpose:	Updates all the groups which a user either owns or not. Changes the frequency of the alerts and the notification type.

*********************************************************************************/
bool CStoredProcedure::EditGroupAlerts(int iUserID, int iSiteID, int iIsOwner, int iNotifyType, int iAlertType, int& iResult)
{
	// Start the procecdure
	StartStoredProcedure("editalertgroups");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	AddParam("isowner",iIsOwner);
	AddParam("alertlisttype",iAlertType);
	AddParam("notifytype",iNotifyType);

	// Now add the output value
	AddOutputParam(&iResult);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("EditGroupAlerts"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetGroupAlertsForUser(int iUserID, int iSiteID)

		Author:		Mark Howitt
        Created:	12/08/2005
        Inputs:		iUserID - the id of the user who you want to get the groups for
					iSiteID - the id of the site the groups belong to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets all the groups for a given user for a given site

*********************************************************************************/
bool CStoredProcedure::GetGroupAlertsForUser(int iUserID, int iSiteID)
{
	// Start the procecdure
	StartStoredProcedure("getusersalertgroupdetails");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetGroupAlertsForUser"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetClubLinkDetails(int iLinkID)

		Author:		DE
        Created:	03/08/2005
        Inputs:		iLinkID - The id of the link 
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Fetches details about the given link

*********************************************************************************/
bool CStoredProcedure::GetClubLinkDetails(int iLinkID)
{
	// Start the procecdure
	StartStoredProcedure("getclublinkdetails");

	// Setup the params
	AddParam("linkid",iLinkID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetClubLinkDetails"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::EditClubLinkDetails(int iLinkID, CTDVString sTitle, CTDVString sURL, CTDVString sDescription )

		Author:		DE
        Created:	03/08/2005
        Inputs:		iLinkID - The id of the link 
						CTDVString sTitle  - Title of link
						CTDVString sURL  - URL of link
						CTDVString sDescription - Description of link
						iUserID - user id of the editor
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Updates the given link

*********************************************************************************/
bool CStoredProcedure::EditClubLinkDetails(int iLinkID, CTDVString& sTitle, CTDVString& sURL, CTDVString& sDescription , int iUserID)
{
	// Start the procecdure
	StartStoredProcedure("editclublinkdetails");

	// Setup the params
	AddParam("linkid",iLinkID);
	AddParam("title",sTitle);
	AddParam("url",sURL);
	AddParam("desc",sDescription);
	AddParam("userid", iUserID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("EditClubLinkDetails"))
	{
		return false;
	}

	int nRowCount = GetIntField("rowcount");	
	return (nRowCount > 0);	
}

/*********************************************************************************

	bool CStoredProcedure::GetLinkTeamID(int iTeamID, int iUserID)

		Author:		DE
        Created:	03/08/2005
        Inputs:		iTeamID - The id of the Team
						iLinkID - The id of the link
        Outputs:	
        Returns:	true if ok, false if not
        Purpose:	returns teamid  attribute of a link

*********************************************************************************/
bool CStoredProcedure::GetLinkTeamID(int iLinkID, int& iTeamID)
{
	iTeamID = false;

	// Start the procecdure
	StartStoredProcedure("getlinkteamid");

	// Setup the params
	AddParam("linkid",iLinkID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetLinkTeamID"))
	{
		return false;
	}

	if (!IsEOF())
	{		
		iTeamID =  GetIntField("TeamID");	
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsUserAMemberOfThisTeam(int iTeamID, int iUserID)

		Author:		DE
        Created:	03/08/2005
        Inputs:		iTeamID - The id of the Team
						iUserID - The id of the User
        Outputs:	bIsMember
        Returns:	true if ok, false if not
        Purpose:	returns true if a user is a member of a team false otherwise

*********************************************************************************/
bool CStoredProcedure::IsUserAMemberOfThisTeam(int iTeamID, int iUserID, bool& bIsMember)
{
	bIsMember = false;

	// Start the procecdure
	StartStoredProcedure("isuseramemberofthisteam");

	// Setup the params
	AddParam("teamid",iTeamID);
	AddParam("userid",iUserID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("IsUserAMemberOfThisTeam"))
	{
		return false;
	}

	if (!IsEOF())
	{		
		bIsMember =  ((GetIntField("IsAMember")) > 0);	
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetForumIDForTeamID(int iTeamID, int iForumID)

		Author:		DE
        Created:	11/08/2005
        Inputs:		iTeamID - The id of the Team
						iForumID - The id of the Forum
        Outputs:	iForumID of this team
        Returns:	true if ok, false if not
        Purpose:	returns the id of the forum for this team

*********************************************************************************/
bool CStoredProcedure::GetForumIDForTeamID(int iTeamID, int& iForumID)
{
	iForumID = 0;

	// Start the procecdure
	StartStoredProcedure("getforumidforteamid");

	// Setup the params
	AddParam("teamid",iTeamID);	
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetForumIDForTeamID"))
	{
		return false;
	}

	if (!IsEOF())
	{		
		iForumID =  GetIntField("ForumID");	
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetTrackedUsers(int iSiteID, int iSkip, int iShow, int iDirection, CTDVString sSortedOn)

		Author:		David Williams
        Created:	12/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::GetTrackedUsers(int iSiteID, int iSkip, int iShow, int iDirection, CTDVString sSortedOn)
{
	StartStoredProcedure("gettrackedusers");
	
	AddParam("siteid", iSiteID);
	AddParam("skip", iSkip);
	AddParam("show", iShow);
	AddParam("direction", iDirection);
	AddParam("sortedon", sSortedOn);

	ExecuteStoredProcedure();

	if (HandleError("GetTrackedUsers"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::SearchTrackedUsers(int iSiteID, CTDVString sSearchOn, CTDVString sUserName, int iUserID, CTDVString sEmail)

		Author:		David Williams
        Created:	15/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::SearchTrackedUsers(int iSiteID, CTDVString sSearchOn, CTDVString sUserName, int iUserID, CTDVString sEmail, int iSkip, int iShow, int* piReturn)
{
	StartStoredProcedure("searchtrackedusers");

	AddParam("siteid", iSiteID);
	AddParam("searchon", sSearchOn);
	AddParam("partialnickname", sUserName);
	AddParam("userid", iUserID);
	AddParam("emailaddress", sEmail);
	AddParam("skip", iSkip);
	AddParam("show", iShow);
	//AddOutputParam(piReturn);
	AddReturnParam(piReturn);

	ExecuteStoredProcedure();

	if (HandleError("SearchTrackedUserrs"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUserTags(void)

		Author:		David Williams
        Created:	23/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetUserTags(void)
{
	StartStoredProcedure("getusertags");
	ExecuteStoredProcedure();

	if (HandleError("GetUserTags"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTrackedMemberDetails(int iSiteID, int iUserID)

		Author:		David Williams
        Created:	25/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetTrackedMemberDetails(int iSiteID, int iUserID)
{
	StartStoredProcedure("gettrackedmemberdetails");

	AddParam("siteid", iSiteID);
	AddParam("userid", iUserID);

	ExecuteStoredProcedure();
	if (HandleError("gettrackedmemberdetails"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateTrackedMemberProfile(int iUserID, int iSiteID, int iPrefStatus, int iPrefDuration, CTDVString sTagIDs, bool bApplyToAltIDs)

		Author:		David Williams
        Created:	25/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::UpdateTrackedMemberProfile(int iUserID, int iSiteID, int iPrefStatus, int iPrefDuration, CTDVString sTagIDs, bool bApplyToAltIDs, bool bAllProfiles)
{
	StartStoredProcedure("updatetrackedmemberprofile");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("prefstatus", iPrefStatus);
	AddParam("prefstatusduration", iPrefDuration);
	AddParam("usertags", sTagIDs);
	AddParam("applytoaltids", bApplyToAltIDs);
	AddParam("allprofiles", bAllProfiles);

	ExecuteStoredProcedure();
	if (HandleError("UpdateTrackedMemberProfile"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetTrackedMemberSummary(int iUserID, int iSiteID)

		Author:		David Williams
        Created:	26/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/
bool CStoredProcedure::GetTrackedMemberSummary(int iUserID, int iSiteID)
{
	StartStoredProcedure("gettrackedmembersummary");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("GetTrackedMembersSummary"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetUserStatuses(void)
{
	StartStoredProcedure("getuserstatuses");
	ExecuteStoredProcedure();
	if (HandleError("getuserstatuses"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetModReasons(int iID, bool bIsModClassID)
{
	StartStoredProcedure("getmodreasons");
	if (bIsModClassID)
	{
		AddParam("modclassid", iID);
	}
	else
	{
		AddParam("siteid", iID);
	}

	ExecuteStoredProcedure();
	if (HandleError("getmodreasons"))
	{
		return false;
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::GetArticleGroupAlertID(int iUserID, int iSiteID, int ih2g2ID)

		Author:		James Pullicino
        Created:	08/09/2005
        Inputs:		-
        Outputs:	'GroupAlertID' field
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetArticleGroupAlertID(int iUserID, int iSiteID, int ih2g2ID)
{
	StartStoredProcedure("getarticlegroupalertid");
	
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("h2g2id", ih2g2ID);

	if(!ExecuteStoredProcedure() || HandleError("getarticlegroupalertid"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetClubGroupAlertID(int iUserID, int iSiteID, int iClubID)

		Author:		James Pullicino
        Created:	08/09/2005
        Inputs:		-
        Outputs:	GroupAlertID' field
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetClubGroupAlertID(int iUserID, int iSiteID, int iClubID)
{
	StartStoredProcedure("getclubgroupalertid");
	
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("clubid", iClubID);

	if(!ExecuteStoredProcedure() || HandleError("getclubgroupalertid"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetNodeGroupAlertID(int iUserID, int iSiteID, int ihNodeID)

		Author:		James Pullicino
        Created:	08/09/2005
        Inputs:		-
        Outputs:	GroupAlertID' field
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetNodeGroupAlertID(int iUserID, int iSiteID, int ihNodeID)
{
	StartStoredProcedure("getnodegroupalertid");
	
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("nodeid", ihNodeID);

	if(!ExecuteStoredProcedure() || HandleError("getnodegroupalertid"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetForumGroupAlertID(int iUserID, int iSiteID, int iFroumID)

		Author:		James Pullicino
        Created:	08/09/2005
        Inputs:		-
        Outputs:	GroupAlertID' field
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetForumGroupAlertID(int iUserID, int iSiteID, int iFroumID)
{
	StartStoredProcedure("getaforumgroupalertid");
	
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("forumid", iFroumID);

	if(!ExecuteStoredProcedure() || HandleError("getaforumgroupalertid"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetThreadGroupAlertID(int iUserID, int iSiteID, int iThreadID)

		Author:		James Pullicino
        Created:	08/09/2005
        Inputs:		-
        Outputs:	GroupAlertID' field
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CStoredProcedure::GetThreadGroupAlertID(int iUserID, int iSiteID, int iThreadID)
{
	StartStoredProcedure("getthreadgroupalertid");
	
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddParam("threadid", iThreadID);

	if(!ExecuteStoredProcedure() || HandleError("getthreadgroupalertid"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetMediaAsset(int iMediaAssetID, int iContentType))

	Author:		- Steve Francis
    Created:	- 13/10/2005
    Inputs:		- iMediaAssetID, iContentType
    Outputs:	- Boolean result
    Returns:	-
    Purpose:	- Returns the media asset dataset for the given media asset id and content type
					if no content type then it just gets the dataset from the media asset id

*********************************************************************************/

bool CStoredProcedure::GetMediaAsset(int iMediaAssetID, int iContentType)
{
	CTDVString strStoredProcedureName = "";

	if (iContentType == 1)
	{
		strStoredProcedureName = "getimageasset";
	}
	else if (iContentType == 2)
	{
		strStoredProcedureName = "getaudioasset";
	}
	else if (iContentType == 3)
	{
		strStoredProcedureName = "getvideoasset";
	}
	else // if (iContentType == 0)
	{
		strStoredProcedureName = "getmediaasset";
	}
	// Start the procecdure
	StartStoredProcedure(strStoredProcedureName);
	
	AddParam("mediaassetid", iMediaAssetID);

	ExecuteStoredProcedure();

	if(HandleError(strStoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CreateMediaAsset(int *piAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, const TDVCHAR* pExtraElementXML, 
									int iUserID, CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated)

	Author:		Steve Francis
    Created:	13/10/2005
	Inputs:		int iSiteID, 
				const TDVCHAR* pCaption,
				const TDVCHAR* pFilename, 
				const TDVCHAR* pMimeType,
				int iContentType,
				const TDVCHAR* pExtraElementXML,
				int iUserID,
				const TDVCHAR* pDescription,
				int iFileLength
				const TDVCHAR* pIPAddress - optional
				bool bSkipModeration - optional
				const TDVCHAR* pExternalLinkURL - optional

	Outputs:	piMediaAssetID,  - int into which to put the id of the new media asset, or
								zero if failed
				dtDateCreated, 
				dtLastUpdated these are used to display the summary after its created

	Returns:	true successful, false otherwise
	Fields:		NA
	Purpose:	Creates a new media asset in the database with the given data.

*********************************************************************************/

bool CStoredProcedure::CreateMediaAsset(int *piMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, 
									const TDVCHAR* pExtraElementXML, int iUserID, 
									const TDVCHAR* pDescription, bool bAddToLibrary, 
									CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated, 
									int iFileLength, const TDVCHAR* pIPAddress /* = NULL */, 
									bool bSkipModeration /* = FALSE */,
									const TDVCHAR* pExternalLinkURL /* = NULL */)
{
	TDVASSERT(iSiteID > 0, "CStoredProcedure::CreateMediaAsset(...) called with non-positive Site ID");
	
	// site ID, or return the AssetID without
	// the address of the int to put it in
	if (iSiteID <= 0 || piMediaAssetID == NULL || pCaption == "")
	{
		return false;
	}

	*piMediaAssetID = 0;

	bool bSuccess = true;

	CTDVString strStoredProcedureName = "";

	if (iContentType == 1)
	{
		strStoredProcedureName = "createimageasset";
	}
	else if (iContentType == 2)
	{
		strStoredProcedureName = "createaudioasset";
	}
	else // iContentType == 3 
	{
		strStoredProcedureName = "createvideoasset";
	}
	//These internally call createmediaassetinternal


	// Start the procecdure
	StartStoredProcedure(strStoredProcedureName);

	AddParam("siteid", iSiteID);
	AddParam("caption", pCaption);
	AddParam("filename", pFilename);
	AddParam("mimetype", pMimeType);
	AddParam("extraelementxml", pExtraElementXML);
	AddParam("ownerid", iUserID);
	AddParam("description", pDescription);
	if (bAddToLibrary)
	{
		AddParam("addtolibrary", 1);
	}
	else
	{
		AddParam("addtolibrary", 0);
	}
	AddParam("filesize", iFileLength);


	if (pIPAddress != NULL && pIPAddress[0] != 0)
	{
		AddParam("ipaddress", pIPAddress);
	}

	if (bSkipModeration)
	{
		AddParam("skipmoderation", 1);
	}

	if (pExternalLinkURL != NULL && pExternalLinkURL[0] != 0)
	{
		AddParam("externallinkurl", pExternalLinkURL);
	}

	ExecuteStoredProcedure();

	if (HandleError(strStoredProcedureName))
	{
		bSuccess = false;
	}
	else
	{
		// now check that the DB update was successful and get the ID
		// of the new entry
		*piMediaAssetID = GetIntField("mediaassetid");
		if (*piMediaAssetID > 0)
		{
			dtDateCreated = GetDateField("DateCreated");
			dtLastUpdated = GetDateField("LastUpdated");
			bSuccess = true;
		}
		else
		{
			bSuccess = false;
		}
	}
	return bSuccess;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateMediaAsset(int iAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, const TDVCHAR* pExtraElementXML, 
									int iUserID, CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated, int iHidden,
									const TDVCHAR* pExternalLinkURL = NULL );

	Author:		Steve Francis
    Created:	13/10/2005
	Inputs:		int iMediaAssetID,
				int iSiteID, 
				const TDVCHAR* pCaption,
				const TDVCHAR* pFilename,
				const TDVCHAR* pMimeType,
				int iContentType,
				const TDVCHAR* pExtraElementXML,
				int iUserID,
				const TDVCHAR* pDescription,
				int iHidden
				const TDVCHAR* pExternalLinkURL = NULL );

	Outputs:	dtDateCreated, 
				dtLastUpdated - these are used to display the summary after its updated

	Returns:	true successful, false otherwise
	Fields:		NA
	Purpose:	Updates an existing media asset in the database with the given data.

*********************************************************************************/

bool CStoredProcedure::UpdateMediaAsset(int iMediaAssetID, int iSiteID, const TDVCHAR* pCaption,
									const TDVCHAR* pFilename, const TDVCHAR* pMimeType, int iContentType, const TDVCHAR* pExtraElementXML, 
									int iUserID, const TDVCHAR* pDescription, CTDVDateTime &dtDateCreated, CTDVDateTime &dtLastUpdated, int iHidden,
									const TDVCHAR* pExternalLinkURL /*= NULL*/ )
{
	TDVASSERT(iSiteID > 0, "CStoredProcedure::UpdateMediaAsset(...) called with non-positive Site ID");
	
	// Fail if site ID, or AssetID are 0 or less
	// or if no caption
	if (iSiteID <= 0 || iMediaAssetID <= 0 || pCaption == "")
	{
		return false;
	}

	bool bSuccess = true;

	StartStoredProcedure("updatemediaasset");

	AddParam("mediaassetid", iMediaAssetID);
	AddParam("siteid", iSiteID);
	AddParam("caption", pCaption);
	AddParam("filename", pFilename);
	AddParam("mimetype", pMimeType);
	AddParam("contenttype", iContentType);
	AddParam("extraelementxml", pExtraElementXML);
	AddParam("ownerid", iUserID);
	AddParam("description", pDescription);
	AddParam("hidden", iHidden);

	if (pExternalLinkURL != NULL && pExternalLinkURL[0] != 0)
	{
		AddParam("externallinkurl", pExternalLinkURL);
	}

	ExecuteStoredProcedure();

	if (HandleError("updatemediaasset"))
	{
		bSuccess = false;
	}
	else
	{
		dtDateCreated = GetDateField("DateCreated");
		dtLastUpdated = GetDateField("LastUpdated");
		bSuccess = true;
	}
	return bSuccess;
}

bool CStoredProcedure::MediaAssetUploadQueueAdd(int iMediaAssetID, const TDVCHAR* pServer, bool bAddToLibrary /* = false */, bool bSkipModeration /* = false */)
{
	StartStoredProcedure("mediaassetuploadqueueadd");
	
	AddParam("assetid", iMediaAssetID);
	AddParam("server", pServer);

	if (bAddToLibrary)
	{
		AddParam("addtolibrary", 1);
	}
	if (bSkipModeration)
	{
		AddParam("skipmoderation", 1);
	}

	ExecuteStoredProcedure();

	if(HandleError("mediaassetuploadqueueadd"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::LinkArticleAndMediaAsset(int ih2g2ID, int iMediaAssetID)

	Author:		Steven Francis
	Created:	18/11/2005
	Inputs:		ih2g2ID - the article id
				iMediaAssetID - the media asset id
	Outputs:	
	Returns:	bool if the link entry added ok
	Purpose:	Creates a record that links an article id to a media asset id
*********************************************************************************/
bool CStoredProcedure::LinkArticleAndMediaAsset(int iH2G2ID, int iMediaAssetID)
{
	StartStoredProcedure("linkarticleandmediaasset");
	
	AddParam("h2g2id", iH2G2ID);
	AddParam("mediaassetid", iMediaAssetID);

	if(!ExecuteStoredProcedure() || HandleError("linkarticleandmediaasset"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetArticlesAssets(int iH2G2ID)

	Author:		Steven Francis
	Created:	29/11/2005
	Inputs:		ih2g2ID - the article id
	Outputs:	
	Returns:	bool 
	Purpose:	Gets the the mediaasset ids for a given article (iH2G2ID)
*********************************************************************************/
bool CStoredProcedure::GetArticlesAssets(int iH2G2ID)
{
	StartStoredProcedure("getarticlesassets");
	
	AddParam("h2g2id", iH2G2ID);

	if(!ExecuteStoredProcedure() || HandleError("getarticlesassets"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveLinkedArticlesAssets(int iH2G2ID)

	Author:		Steven Francis
	Created:	30/11/2005
	Inputs:		ih2g2ID - the article id
	Outputs:	
	Returns:	bool 
	Purpose:	Removes the the mediaasset ids for a given article (iH2G2ID)
*********************************************************************************/
bool CStoredProcedure::RemoveLinkedArticlesAssets(int iH2G2ID)
{
	StartStoredProcedure("removelinkedarticlesassets");
	
	AddParam("h2g2id", iH2G2ID);

	if(!ExecuteStoredProcedure() || HandleError("removelinkedarticlesassets"))
	{
		return false;
	}
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetUsersMediaAssets(int iUserID, int iContentType, int iSkip, int iShow, CDTVString sSortBy)

	Author:		- Steve Francis
    Created:	- 05/12/2005
    Inputs:		- int iUserID, int iContentType, int iSkip, int iShow, bool bOwner, CDTVString sSortBy
    Outputs:	- Boolean result
    Returns:	-
    Purpose:	- Returns the media asset dataset for the given users id and content type
					if no content type then it just gets the media asset dataset for that user id

*********************************************************************************/
bool CStoredProcedure::GetUsersMediaAssets(int iUserID, int iContentType, int iSkip, int iShow, bool bOwner, CTDVString sSortBy)
{
	CTDVString strStoredProcedureName = "";

	if (iContentType == 1)
	{
		strStoredProcedureName = "getusersimageassets";
	}
	else if (iContentType == 2)
	{
		strStoredProcedureName = "getusersaudioassets";
	}
	else if (iContentType == 3)
	{
		strStoredProcedureName = "getusersvideoassets";
	}
	else // if (iContentType == 0)
	{
		strStoredProcedureName = "getusersmediaassets";
	}
	// Start the procecdure
	StartStoredProcedure(strStoredProcedureName);
	
	AddParam("userid", iUserID);
	AddParam("firstindex",iSkip);
	AddParam("lastindex",iSkip + iShow);

	if ( sSortBy == "Caption" )
	{
		AddParam("sortbycaption", 1);
	}

	if ( bOwner )
	{
		AddParam("owner", 1);
	}

	ExecuteStoredProcedure();

	if(HandleError(strStoredProcedureName))
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::ModerateMediaAsset( int iModID, int iStatus, const CTDVString& sNotes, int iReferTo, int iUserID)
{
	StartStoredProcedure("moderatemediaasset");
	AddParam("ModID", iModID);
	AddParam("status", iStatus);
	AddParam("Notes", sNotes);
	AddParam("ReferTo", iReferTo);
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();

	return !HandleError("moderatemediaasset");
}

bool CStoredProcedure::ModerateMediaAssetByArticleID(int iArticleModID, int iStatus, const CTDVString& sNotes, int iReferTo, int iUserID)
{
	StartStoredProcedure("moderatemediaassetbyarticleid");

	AddParam("ArticleModID", iArticleModID);
	AddParam("Status", iStatus);
	AddParam("Notes", sNotes);
	AddParam("ReferTo", iReferTo);
	AddParam("UserID", iUserID);
	ExecuteStoredProcedure();

	return !HandleError("moderatemediaassetbyarticleid");
}

/*********************************************************************************

	bool CStoredProcedure::QueueMediaAssetForModeration(int iMediaAssetID, int iSiteID, int iComplainantID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText )

	Author:		- Steve Francis
    Created:	- 03/06/2005
    Inputs:		- int iMediaAssetID, int iSiteID, int iComplainantID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText 
    Outputs:	- Boolean result
    Returns:	-
    Purpose:	- Adds the specified Media Asset ID to the moderation queue

*********************************************************************************/
bool CStoredProcedure::QueueMediaAssetForModeration( int iMediaAssetID, int iSiteID, int iComplainantID, const TDVCHAR* pcCorrespondenceEmail, const TDVCHAR* pcComplaintText )
{
	StartStoredProcedure("queuemediaassetformoderation");
	AddParam("mediaassetid", iMediaAssetID);
	AddParam("siteid", iSiteID);

	if (iComplainantID != NULL)
	{
		AddParam("ComplainantID", iComplainantID);
		AddParam("CorrespondenceEmail", pcCorrespondenceEmail);
		AddParam("ComplaintText", pcComplaintText);
	}

	ExecuteStoredProcedure();

	return !HandleError("queuemediaassetformoderation");
}

/*********************************************************************************

	bool CStoredProcedure::GetUsersArticlesWithMediaAssets(int iUserID, int iContentType, int iSkip, int iShow, bool bOwner, CDTVString sSortBy)

	Author:		- Steve Francis
    Created:	- 05/12/2005
    Inputs:		- int iUserID, int iContentType, int iSkip, int iShow, bool bViewingUser, CDTVString sSortBy
    Outputs:	- Boolean result
    Returns:	-
    Purpose:	- Returns the articles that have media assets dataset for the given users id and content type
					if no content type then it just gets the articles that have media asset dataset for that user id

*********************************************************************************/
bool CStoredProcedure::GetUsersArticlesWithMediaAssets(int iUserID, int iContentType, int iSkip, int iShow, bool bOwner, CTDVString sSortBy)
{
	CTDVString strStoredProcedureName = "";

	if (iContentType == 1)
	{
		strStoredProcedureName = "getusersarticleswithimageassets";
	}
	else if (iContentType == 2)
	{
		strStoredProcedureName = "getusersarticleswithaudioassets";
	}
	else if (iContentType == 3)
	{
		strStoredProcedureName = "getusersarticleswithvideoassets";
	}
	else // if (iContentType == 0)
	{
		strStoredProcedureName = "getusersarticleswithmediaassets";
	}
	// Start the procecdure
	StartStoredProcedure(strStoredProcedureName);
	
	AddParam("userid", iUserID);
	AddParam("firstindex",iSkip);
	AddParam("lastindex",iSkip + iShow);

	if ( sSortBy == "Caption" )
	{
		AddParam("sortbycaption", 1);
	}
	else if ( sSortBy == "Rating" )
	{
		AddParam("sortbyrating", 1);
	}

	if ( bOwner )
	{
		AddParam("owner", 1);
	}

	ExecuteStoredProcedure();

	if(HandleError(strStoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CheckUsersFileUploadLimit()

	Author:		Steven Francis
	Created:	17/01/2006
	Inputs:		int iFileLength, 
				int iCurrentUserID
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to check the users upload limit 
	            against the new file size (in essence to allow the upload or not)
*********************************************************************************/
bool CStoredProcedure::CheckUsersFileUploadLimit(int iFileLength, int iCurrentUserID)
{
	CTDVString strStoredProcedureName = "checkusersfileuploadlimit";

	// Start the procecdure
	StartStoredProcedure(strStoredProcedureName);
	
	AddParam("filelength", iFileLength);
	AddParam("userid", iCurrentUserID);

	ExecuteStoredProcedure();

	if(HandleError(strStoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetFTPUploadQueue()

	Author:		Steven Francis
	Created:	20/01/2006
	Inputs:		-
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to show the upload queue
*********************************************************************************/
bool CStoredProcedure::GetFTPUploadQueue( int iSiteID)
{
	CTDVString strStoredProcedureName;

	if (iSiteID > 0)
	{
		strStoredProcedureName = "getftpuploadqueueforsite";
	}
	else
	{
		strStoredProcedureName = "getftpuploadqueue";
	}

	StartStoredProcedure(strStoredProcedureName);

	if (iSiteID > 0)
	{
		AddParam(iSiteID);
	}

	ExecuteStoredProcedure();

	if(HandleError(strStoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::ReprocessFailedUploads( int iSiteID, int iMediaAssetID )

	Author:		Steven Francis
	Created:	09/02/2006
	Inputs:		int iSiteID, int iMediaAssetID
	Outputs:	-
	Returns:	bool
	Purpose:	Calls the stored procedure to reset the upload status for the 
				failed items in the upload queue so an attempt is made to reprocess
				the items for a site or an individual asset if an id is passed in
*********************************************************************************/
bool CStoredProcedure::ReprocessFailedUploads( int iSiteID, int iMediaAssetID )
{
	CTDVString strStoredProcedureName;

	strStoredProcedureName = "reprocessfaileduploads";

	StartStoredProcedure(strStoredProcedureName);

	AddParam(iSiteID);

	if (iMediaAssetID > 0)
	{
		AddParam(iMediaAssetID);
	}

	ExecuteStoredProcedure();

	if(HandleError(strStoredProcedureName))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetSiteOpenCloseTimes(int iSiteID)

	Author:		- James Conway
    Created:	- 16/01/2006
    Inputs:		- int SiteID
    Outputs:	- 
    Returns:	- False if no error, true of error in sp has been handled.
    Purpose:	- Gets the opening and closing times for topics on a site.

*********************************************************************************/
bool CStoredProcedure::GetSiteOpenCloseTimes(int iSiteID)
{
	StartStoredProcedure("getsitetopicsopenclosetimes");
	//AddParam("siteid", iSiteID);
	ExecuteStoredProcedure();

	return !HandleError("getsiteopenclosetimes");
}

/*********************************************************************************

	bool CStoredProcedure::UpdateSiteClosed(int iSiteID)

	Author:		- James Conway
    Created:	- 16/01/2006
    Inputs:		- int SiteID, iClosedStatus (1=closed, 0=open)
    Outputs:	- 
    Returns:	- False if no error, true of error in sp has been handled.
    Purpose:	- Updates Closed flag on Sites table.

*********************************************************************************/
bool CStoredProcedure::UpdateSiteClosed(int iSiteID, int iClosedStatus)
{
	StartStoredProcedure("updatesitetopicsclosed");
	AddParam("siteid", iSiteID);
	AddParam("siteemergencyclosed", iClosedStatus);
	ExecuteStoredProcedure();

	return !HandleError("updatesiteclosed");
}

/*********************************************************************************

	bool CStoredProcedure::CloseThread(int iThreadID)

		Author:		Jim Lynn
        Created:	23/01/2006
        Inputs:		iThreadID - ID of the thread to close/make read only
					bHide - optional parameter - hide thread too.
        Outputs:	-
        Returns:	true if successfull, false if there was a database error
        Purpose:	Closes down a whole thread. Currently this will hide the thread
					but we're hoping to change this to simply locking it and making it 
					read-only in future.

*********************************************************************************/

bool CStoredProcedure::CloseThread(int iThreadID, bool bHide )
{
	StartStoredProcedure("closethread");
	AddParam(iThreadID);
	AddParam(bHide);

	ExecuteStoredProcedure();

	if(HandleError("closethread"))
	{
		return false;
	}

	return true;

}

/*********************************************************************************

	bool CStoredProcedure::ReOpenThread(int iThreadID)

		Author:		Jim Lynn
        Created:	23/01/2006
        Inputs:		iThreadID - ID of the thread to close
        Outputs:	-
        Returns:	true if successfull, false if there was a database error
        Purpose:	ReOpen a closed thread and make it visible.
*********************************************************************************/
bool CStoredProcedure::ReOpenThread(int iThreadID)
{
	StartStoredProcedure("reopenthread");
	AddParam(iThreadID);

	ExecuteStoredProcedure();
	if(HandleError("reopenthread"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveKeyPhrasesFromAssets(int iID, CTDVString& sPhrases )

		Author:		Steven Francis
        Created:	27/01/2006
        Inputs:		iID - ID of article/asset/thread the phrases are to be removed from
					sPhrases - csv list of phrases to remove from thread.
					eKeyPhraseType - type of thing to remove the key phrases from
        Outputs:	-
        Returns:	bool - success of failure of storedprocedure
        Purpose:	Remove a list of phrases from a specified article/asset/thread.

*********************************************************************************/
bool CStoredProcedure::RemoveKeyPhrasesFromAssets(int iID, CTDVString& sPhrases )
{
	StartStoredProcedure("removekeyphrasesfromassets");
	AddParam("id", iID);
	AddParam("phrases", sPhrases);
	

	ExecuteStoredProcedure();
	if (HandleError("removekeyphrasesfromassets"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveKeyPhrasesFromArticle(int iH2G2ID, const CTDVString& sPhrases, const CTDVString& sNameSpaces, int iSiteId )

		Author:		Martin Robb
        Created:	15/06/2007
        Inputs:		h2g2IDID - h2g2id of Article
					Phrases - Phrase to match
					PhrasenameSpaceIds - List of PhraseNameSpace Ids to disassociate from article.

        Outputs:	-
        Returns:	bool - success of failure of storedprocedure
        Purpose:	Remove phrase within the given namespaces on given site for article 

*********************************************************************************/
bool CStoredProcedure::RemoveKeyPhrasesFromArticle(int iH2G2ID, std::vector<int> phrasenamespaceids )
{
	CTDVString sIDs;
	for ( std::vector<int>::iterator iter = phrasenamespaceids.begin(); iter != phrasenamespaceids.end(); ++iter )
	{
		if ( !sIDs.IsEmpty() )
			sIDs << "|";
		sIDs << CTDVString(*iter);
	}

	StartStoredProcedure("removekeyphrasesfromarticles");
	AddParam("h2g2id",iH2G2ID);
	AddParam("phrasenamespaceids", sIDs);
	ExecuteStoredProcedure();
	return !HandleError("removekeyphrasesfromarticles");
}

/*********************************************************************************

	bool CStoredProcedure::RemoveKeyPhrasesFromThread(int iThreadID, CTDVString& sPhraseIDs)

		Author:		David Williams
        Created:	18/11/2005
        Inputs:		iThreadID - ID of thread phrases to be removed from
					sPhraseIDs - csv list of phrase ids to remove from thread.
        Outputs:	-
        Returns:	bool - success of failure of storedprocedure
        Purpose:	Remove a list of phrases from a specified thread.

*********************************************************************************/
bool CStoredProcedure::RemoveKeyPhrasesFromThread(int iThreadID, CTDVString& sPhraseIDs)
{
	StartStoredProcedure("removekeyphrasesfromthread");

	AddParam("threadid", iThreadID);
	AddParam("phraseids", sPhraseIDs);

	ExecuteStoredProcedure();
	if (HandleError("RemoveKeyPhrasesFromThread"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveAllKeyPhrases(int iID, CTDVString& sPhrases, KEYPHRASETYPE eKeyPhraseType)

		Author:		Steven Francis
        Created:	19/06/2006
        Inputs:		iID - ID of article/asset/thread the phrases are to be removed from
					eKeyPhraseType - type of thing to remove the key phrases from
        Outputs:	-
        Returns:	bool - success of failure of storedprocedure
        Purpose:	Remove all phrases from a specified article/asset.

*********************************************************************************/
bool CStoredProcedure::RemoveAllKeyPhrases(int iID, KEYPHRASETYPE eKeyPhraseType)
{
	CTDVString strStoredProcedureName;
	if (eKeyPhraseType == ARTICLE)
	{
		strStoredProcedureName = "removeallkeyphrasesfromarticle";
	}
	else if(eKeyPhraseType == ASSET)
	{
		strStoredProcedureName = "removeallkeyphrasesfromasset";
	}
		
	StartStoredProcedure(strStoredProcedureName);

	AddParam("id", iID);

	ExecuteStoredProcedure();
	if (HandleError(strStoredProcedureName))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::UpdateSiteOpenCloseSchedule(int iSiteID, std::vector<CTDVString>& SQLParamVector)
{
	StartStoredProcedure("updatesitetopicsopencloseschedule");

	int iNumberOfParams = SQLParamVector.size();

	if (iNumberOfParams == 0)
	{
		// No scheduled closures. 
		return true; 
	}

	AddParam("siteid", iSiteID);
				
	for(int i = 0; i < iNumberOfParams; i++)
	{
		CTDVString sParamName = ""; 

		sParamName << "param" << i;

		AddParam(sParamName, SQLParamVector.at(i));
	}

	ExecuteStoredProcedure();
	if (HandleError("UpdateSiteOpenCloseSchedule"))
	{
		return false;
	}

	return true; 
}
bool CStoredProcedure::CreateDailyRecurSchedule(int iSiteID, int iRecurrentEventOpenHours, int iRecurrentEventCloseHours, int iRecurrentEventOpenMinutes, int iRecurrentEventCloseMinutes)
{
	StartStoredProcedure("createdailyrecurschedule");
	AddParam("siteid", iSiteID);
	AddParam("recurrenteventopenhours", iRecurrentEventOpenHours);
	AddParam("recurrenteventclosehours", iRecurrentEventCloseHours);
	AddParam("recurrenteventopenminutes", iRecurrentEventOpenMinutes);
	AddParam("recurrenteventcloseminutes", iRecurrentEventCloseMinutes);

	ExecuteStoredProcedure();
	if (HandleError("CreateDailyRecurSchedule"))
	{
		return false;
	}

	return true; 
}
bool CStoredProcedure::DeleteScheduledEvents(int iSiteID)
{
	StartStoredProcedure("deletescheduledevents");
	AddParam("siteid", iSiteID);

	ExecuteStoredProcedure();
	if (HandleError("DeleteScheduledEvents"))
	{
		return false;
	}

	return true; 
}

bool CStoredProcedure::GetDistressMessages(int iModClassId)
{
	StartStoredProcedure("moderationgetdistressmessages");
	if ( iModClassId > 0 )
		AddParam("modclassid",iModClassId);
	ExecuteStoredProcedure();
	if ( HandleError("moderationgetdistressmessages") )
		return false;

	return true;
}

bool CStoredProcedure::GetDistressMessage(int iMessageId)
{
	StartStoredProcedure("moderationgetdistressmessage");
	AddParam("id",iMessageId);
	ExecuteStoredProcedure();
	if ( HandleError("moderationgetdistressmessage") )
		return false;

	return true;
}

bool CStoredProcedure::AddDistressMessage( int iModClassId, CTDVString sSubject, CTDVString sText )
{
	StartStoredProcedure("moderationadddistressmessage");
	AddParam("modclassid", iModClassId);
	AddParam("subject", sSubject);
	AddParam("text", sText);
	ExecuteStoredProcedure();
	if ( HandleError("moderationadddistressmessage") )
		return false;

	return true;
}
	
bool CStoredProcedure::RemoveDistressMessage( int iMessageId )
{
	StartStoredProcedure("moderationremovedistressmessage");
	AddParam("id",iMessageId);
	ExecuteStoredProcedure();
	if ( HandleError("moderationremovedistressmessage") )
		return false;

	return true;
}
	
bool CStoredProcedure::UpdateDistressMessage( int iMessageId, int iModClassId, CTDVString sSubject, CTDVString sText )
{
	StartStoredProcedure("moderationupdatedistressmessage");
	AddParam("id",iMessageId);
	AddParam("modclassid", iModClassId);
	AddParam("subject", sSubject);
	AddParam("text", sText);
	ExecuteStoredProcedure();
	if ( HandleError("moderationupdatedistressmessage") )
		return false;

	return true;
}

bool CStoredProcedure::GetModeratorInfo(int iUserID)
{
	StartStoredProcedure("getmoderatorinfo");
	AddParam("userid", iUserID);
	ExecuteStoredProcedure();

	if (HandleError("getmoderatorinfo"))
	{
		return false;
	}
	return true;
}


/*********************************************************************************

	bool CStoredProcedure::HideMediaAsset(int iMediaAssetID, int iSiteID, int iHiddenStatus)

	Author:		Steven Francis
	Created:	30/03/2006
	Inputs:		iMediaAssetID - ID of Media Asset to hide
				iHiddenStatus - Hidden Status
	Outputs:	
	Purpose:	Updates the Hidden flag for the media asset
	
*********************************************************************************/
bool CStoredProcedure::HideMediaAsset(int iMediaAssetID, int iHiddenStatus)
{
	StartStoredProcedure("hidemediaasset");
	
	AddParam("mediaassetid", iMediaAssetID);
	if(iHiddenStatus != 0)
	{
		AddParam("hiddenstatus", iHiddenStatus);
	}

	if(!ExecuteStoredProcedure() || HandleError("hidemediaasset"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CheckUserPostFreq(int iUserID, int iSiteID, int& iSeconds)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Checks to see if this user has to wait before posting again to this site,
					and if so, returns the number of seconds left

*********************************************************************************/

bool CStoredProcedure::CheckUserPostFreq(int iUserID, int iSiteID, int& iSeconds)
{
	StartStoredProcedure("checkuserpostfreq");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	AddOutputParam("seconds",&iSeconds);
	ExecuteStoredProcedure();

	if (HandleError("checkuserpostfreq"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllSiteOptions()

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets all the site options from the db

*********************************************************************************/

bool CStoredProcedure::GetAllSiteOptions()
{
	StartStoredProcedure("getallsiteoptions");
	ExecuteStoredProcedure();

	if (HandleError("GetAllSiteOptions"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetSiteOption(int iSiteID, CTDVString& sSection, CTDVString& sName, CTDVString& sValue)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Sets a single site option

*********************************************************************************/

bool CStoredProcedure::SetSiteOption(int iSiteID, CTDVString& sSection, CTDVString& sName, CTDVString& sValue)
{
	StartStoredProcedure("setsiteoption");
	AddParam("siteid",iSiteID);
	AddParam("section",sSection);
	AddParam("name",sName);
	AddParam("value",sValue);
	ExecuteStoredProcedure();

	if (HandleError("SetSiteOption"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteSiteOption(int iSiteID, CTDVString& sSection, CTDVString& sName)

		Author:		Mark Neves
        Created:	03/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Deletes a single site option

*********************************************************************************/

bool CStoredProcedure::DeleteSiteOption(int iSiteID, CTDVString& sSection, CTDVString& sName)
{
	StartStoredProcedure("deletesiteoption");
	AddParam("siteid",iSiteID);
	AddParam("section",sSection);
	AddParam("name",sName);
	ExecuteStoredProcedure();

	if (HandleError("DeleteSiteOption"))
	{
		return false;
	}
	return true;
}



/*********************************************************************************

	bool CStoredProcedure::UserJoinedSite(int UserID, int SiteID)

		Author:		James Pullicino
        Created:	06/04/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Called when user joins a site. Saves datejoined

*********************************************************************************/

bool CStoredProcedure::UserJoinedSite(int UserID, int SiteID)
{
	StartStoredProcedure("userjoinedsite");
	AddParam("siteid", SiteID);
	AddParam("userid", UserID);	
	if(!ExecuteStoredProcedure() || HandleError("userjoinedsite"))
	{
		TDVASSERT(false, "CStoredProcedure::serJoinedSite() Failed to execute stored procedure");
		return false;
	}

	return true;
}

bool CStoredProcedure::GetUserPrefStatus(int iUserID, int iSiteID, int* iPrefStatus)
{
	StartStoredProcedure("getmemberprefstatus");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);

	AddOutputParam("prefstatus", iPrefStatus);
	if (!ExecuteStoredProcedure() || HandleError("getmemberprefstatus"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUserPrivacyDetails(int iUserID)

		Author:		Mark Howitt
        Created:	02/05/2006
        Inputs:		iUserID - The id of the user you want to get the details for
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the users privacy details

*********************************************************************************/
bool CStoredProcedure::GetUserPrivacyDetails(int iUserID)
{
	// Start the procedure
	StartStoredProcedure("getusersprivacydetails");

	// Setup the params
	AddParam("userid",iUserID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetUserPrivacyDetails"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::StartUserPrivacyUpdate(int iUserID)

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		iUserID - The is of the user you want to update the privacy settings for
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Starts the update privacy options procedure for a given user

*********************************************************************************/
bool CStoredProcedure::StartUserPrivacyUpdate(int iUserID)
{
	// Start the procedure and add the userid
	StartStoredProcedure("startuserprivacyupdate");
	AddParam("userid",iUserID);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUserPrivacyHideLocation(bool bHide)

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		bHide - A flag that states whether or not to hide the users location
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the hide location param

*********************************************************************************/
bool CStoredProcedure::UpdateUserPrivacyHideLocation(bool bHide)
{
	// Add the param to the procedure
	AddParam("hidelocation",bHide);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateUserPrivacyHideUserName(bool bHide)

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		bHide - A flag to state whether or not to hide the username detials
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Adds the hide username param

*********************************************************************************/
bool CStoredProcedure::UpdateUserPrivacyHideUserName(bool bHide)
{
	// Add the param to the procedure
	AddParam("hideusername",bHide);
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CommitUserPrivacyUpdates()

		Author:		Mark Howitt
        Created:	10/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Executes the Update Privacy procedure

*********************************************************************************/
bool CStoredProcedure::CommitUserPrivacyUpdates()
{
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("StartUserPrivacyUpdate"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetUsersHideLocationFlag(int iUserID, bool bHide)

		Author:		Mark Howitt
        Created:	02/05/2006
        Inputs:		iUserID - The id of the user you want to set the flag for
					bHide - The value you want to set the flag to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the hide location privacy flag for the given user

*********************************************************************************/
bool CStoredProcedure::SetUsersHideLocationFlag(int iUserID, bool bHide)
{
	// Start the procedure
	StartStoredProcedure("setusershidelocationflag");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("hide",bHide);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetUsersHideLocationFlag"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetUsersHideUserNameFlag(int iUserID, bool bHide)

		Author:		Mark Howitt
        Created:	02/05/2006
        Inputs:		iUserID - The id of the user you want to set the flag for
					bHide - The value you want to set the flag to
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Sets the hide username privacy flag for the given user

*********************************************************************************/
bool CStoredProcedure::SetUsersHideUserNameFlag(int iUserID, bool bHide)
{
	// Start the procedure
	StartStoredProcedure("setusershideusernameflag");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("hide",bHide);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetUsersHideUserNameFlag"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetAllAllowedURLs()

	Author:		Steven Francis
	Created:	02/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Gets the Lists of OK URLs into in memory cache
	
*********************************************************************************/
bool CStoredProcedure::GetAllAllowedURLs()
{
	StartStoredProcedure("getallallowedurls");

	ExecuteStoredProcedure();
	if (HandleError("getallallowedurls"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddNewAllowedURL()

	Author:		Steven Francis
	Created:	02/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Gets the Lists of OK URLs into in mmeory cache
	
*********************************************************************************/
bool CStoredProcedure::AddNewAllowedURL(const TDVCHAR* pURL, const int iSiteID)
{
	StartStoredProcedure("addnewallowedurl");

	AddParam("siteid", iSiteID);
	AddParam("url", pURL);

	ExecuteStoredProcedure();

	if (HandleError("addnewallowedurl"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateAllowedURL()

	Author:		Steven Francis
	Created:	04/05/2006
	Inputs:		
	Outputs:	
	Purpose:	Updates an allowed url in the list for a site
	
*********************************************************************************/
bool CStoredProcedure::UpdateAllowedURL(const int iAllowedURLID, const CTDVString& sAllowedURL, 
									 const int iSiteID)
{
	StartStoredProcedure("updateallowedurl");

	AddParam("id", iAllowedURLID);
	AddParam("siteid", iSiteID);
	AddParam("url", sAllowedURL);

	ExecuteStoredProcedure();

	if (HandleError("updateallowedurl"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DeleteAllowedURL()

	Author:		Steven Francis
	Created:	04/05/2006
	Inputs:		ID - id of the allowed url
	Outputs:	
	Purpose:	Deletes an allowed url in the list for a site
	
*********************************************************************************/
bool CStoredProcedure::DeleteAllowedURL(const int iAllowedURLID)
{
	StartStoredProcedure("deleteallowedurl");

	AddParam("id", iAllowedURLID);

	ExecuteStoredProcedure();

	if (HandleError("deleteallowedurl"))
	{
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UnArchiveTopic(int iTopicID, int iUserID, bool& bValidTopic)

		Author:		Mark Howitt
        Created:	12/05/2006
        Inputs:		iTopicID - The id of the topic you want to unarchive.
					iUserID - The Id of the user who is unarching the topic.
        Outputs:	bValidTopic - A flag that is set to true if the supplied topid id was valid, false if not
        Returns:	true if ok, false if not.
        Purpose:	Unarchives the given topic id. This only works for preview topics
					as the makeactive will update the active topic status.

*********************************************************************************/
bool CStoredProcedure::UnArchiveTopic(int iTopicID, int iUserID, bool& bValidTopic)
{
	// Start the procedure
	StartStoredProcedure("unarchivetopic");

	// Setup the params
	int iValid = 0;
	AddParam("topicid",iTopicID);
	AddParam("editorid",iUserID);
	AddOutputParam("validtopic",&iValid);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("UnArchiveTopic"))
	{
		return false;
	}


	// Now zip through the result set to get the output param!
	while (!IsEOF())
	{
		// Keep going
		MoveNext();
	}

	// Set the valid variable
	bValidTopic = iValid > 0;

	return true;
}
/*********************************************************************************

	bool CStoredProcedure::GetUserSystemMessageMailbox

		Author:		James Conway
        Created:	08/05/2006
        Inputs:		iUserID - The id of the user you want to get the details for
					iSiteID - Site message pertain to
					show - the maximum number of message to return
					skip - place in results set to start returning messages from
        Outputs:	-
        Returns:	true if ok, false if not
        Purpose:	Gets the user's system messages

*********************************************************************************/
bool CStoredProcedure::GetUserSystemMessageMailbox(int iUserID, int iSiteID, int iSkip, int iShow)
{
	// Start the procedure
	StartStoredProcedure("getuserssystemmessagemailbox");

	// Setup the params
	AddParam("userid",iUserID);
	AddParam("siteid",iSiteID);
	AddParam("skip",iSkip);
	AddParam("show",iShow);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getuserssystemmessagemailbox"))
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::GetPostingStats(const TDVCHAR* pDate, int interval)
{
	StartStoredProcedure("stats_getpostingstats");
	AddParam(pDate);
	AddParam(interval);
	ExecuteStoredProcedure();
	if (HandleError("GetPostingStats"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::CheckPreModPostingExists(int iModID, bool bCreate = false)

		Author:		Mark Howitt
		Created:	12/06/2006
		Inputs:		iModID - The Id of the mod item you want to check exists in the PreModPostings table
					bCreate - A flag to state wheter or not to create the post if it exists?
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Checks to see if a given mod item exists in the PreModPostings Tables, and 
					optionally create the post turning it into normal Pre Mod post.

*********************************************************************************/
bool CStoredProcedure::CheckPreModPostingExists(int iModID, bool bCreate)
{
	// Start the procedure
	StartStoredProcedure("checkpremodpostingexists");

	// Setup the params
	AddParam("modid",iModID);
	AddParam("create",bCreate);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("CheckPreModPostingExists"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetMBStatsModStatsPerTopic(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	26/05/2006
        Inputs:		iSiteID = the site id
					dtDate = specifies the day for the stats
        Outputs:	-
        Returns:	-
        Purpose:	Gets the moderator stats per topic for the site given, on the day specified
					by dtDate.

					This will fail if the date is sooner than yesterday - ie. you can only get stats
					for days that are in the past.

*********************************************************************************/

bool CStoredProcedure::GetMBStatsModStatsPerTopic(int iSiteID, CTDVDateTime& dtDate)
{
	StartStoredProcedure("getmbstatsmodstatspertopic");

	// Setup the params
	AddParam("siteid",iSiteID);
	AddParam("date",dtDate);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getmbstatsmodstatspertopic"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetMBStatsModStatsTopicTotals(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	26/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets the moderation totals per topic for the site given, on the day specified
					by dtDate.

					This will fail if the date is sooner than yesterday - ie. you can only get stats
					for days that are in the past.

*********************************************************************************/

bool CStoredProcedure::GetMBStatsModStatsTopicTotals(int iSiteID, CTDVDateTime& dtDate)
{
	StartStoredProcedure("getmbstatsmodstatstopictotals");

	// Setup the params
	AddParam("siteid",iSiteID);
	AddParam("date",dtDate);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getmbstatsmodstatstopictotals"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetMBStatsTopicTotalComplaints(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	26/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets the total complaints per topic for the site given, on the day specified
					by dtDate.

					This SP compliments GetMBStatsModStatsTopicTotals().  Call this to get the complaints
					totals for the same topics

					This will fail if the date is sooner than yesterday - ie. you can only get stats
					for days that are in the past.

*********************************************************************************/

bool CStoredProcedure::GetMBStatsTopicTotalComplaints(int iSiteID, CTDVDateTime& dtDate)
{
	StartStoredProcedure("getmbstatstopictotalcomplaints");

	// Setup the params
	AddParam("siteid",iSiteID);
	AddParam("date",dtDate);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getmbstatstopictotalcomplaints"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetMBStatsHostsPostsPerTopic(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	26/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Gets the number of posts by each host on the topics for the site given, on the day specified
					by dtDate.

					This will fail if the date is sooner than yesterday - ie. you can only get stats
					for days that are in the past.

*********************************************************************************/

bool CStoredProcedure::GetMBStatsHostsPostsPerTopic(int iSiteID, CTDVDateTime& dtDate)
{
	StartStoredProcedure("getmbstatshostspostspertopic");

	// Setup the params
	AddParam("siteid",iSiteID);
	AddParam("date",dtDate);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getmbstatshostspostspertopic"))
	{
		return false;
	}

	return true;
}


/*********************************************************************************

	bool CStoredProcedure::GetUserPostDetailsViaBBCUID(const TDVCHAR* pBBCUID)

		Author:		Mark Neves
		Created:	19/06/2006
		Inputs:		pBBCUID = ptr to a BBCUID cookie value
		Outputs:	-
		Returns:	-
		Purpose:	Gets a list of posts that have a matching BBCUID value associated with it

*********************************************************************************/

bool CStoredProcedure::GetUserPostDetailsViaBBCUID(const TDVCHAR* pBBCUID)
{
	StartStoredProcedure("getuserpostdetailsviabbcuid");

	// Setup the params
	if (!AddUIDParam("bbcuid",pBBCUID))
	{
		AddNullParam("bbcuid");
	}
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getuserpostdetailsviabbcuid"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetEmailAlertStats(int iSiteID = 0)

		Author:		Mark Howitt
		Created:	19/06/2006
		Inputs:		iSiteID - The id of the site that you want to get the email stats for.
						This is defaulted to 0 which means all sites.
		Outputs:	-
		Returns:	true if ok, false if not
		Purpose:	Gets the email alert stats for a given site OR for all sites.

*********************************************************************************/
bool CStoredProcedure::GetEmailAlertStats(int iSiteID)
{
	StartStoredProcedure("getemailalertstats");

	// Setup the params
	AddParam("siteid",iSiteID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetEmailAlertStats"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::UpdateEmailAlertStats(int iTotalEmailsSent, int iTotalPrivateMsgSent, int iTotalFailed, int iUpdateType)

		Author:		Mark Howitt
		Created:	20/06/2006
		Inputs:		iTotalEmailsSent - The number of emails that were sent ok.
					iTotalPrivateMsgSent - The number of private messages sent ok.
					iTotalFailed - The number of failed alerts.
					iUpdateType - The type of update. instant, daily....
		Outputs:	-
		Returns:	-
		Purpose:	-

*********************************************************************************/
bool CStoredProcedure::UpdateEmailAlertStats(int iTotalEmailsSent, int iTotalPrivateMsgSent, int iTotalFailed, int iUpdateType)
{
	StartStoredProcedure("updateemailalertstats");

	// Setup the params
	AddParam("totalemailssent",iTotalEmailsSent);
	AddParam("totalprivatemsgssent",iTotalPrivateMsgSent);
	AddParam("totalfailed",iTotalFailed);
	AddParam("updatetype",iUpdateType);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetEmailAlertStats"))
	{
		return false;
	}

	return true;
}

bool CStoredProcedure::GetIsEditorOnAnySite(int iUserID)
{
	StartStoredProcedure("iseditoronanysite");

	AddParam("userid", iUserID);

	ExecuteStoredProcedure();
	if (HandleError("IsEditorOnAnySite"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetSitesUserIsEditorOf(int iUserID)
{
	StartStoredProcedure("getsitesuseriseditorof");

	AddParam("userid", iUserID);

	ExecuteStoredProcedure();
	if (HandleError("getsitesuseriseditorof"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::DisableUsersEmailAlerts(int iUserID, CTDVString sGUID)

		Author:		Mark Howitt
		Created:	10/07/2006
		Inputs:		iUserID - The id of the user you want to disable the alerts for.
					sGUID - The ID of the list you want to disable.
		Outputs:	-
		Returns:	true if ok, false if not.
		Purpose:	Disables all the alerts for a given user. the guid id used to
					validate non logged in calls.

*********************************************************************************/
bool CStoredProcedure::DisableUsersEmailAlerts(int iUserID, CTDVString sGUID)
{
	StartStoredProcedure("disableuseremailalerts");

	// Setup the params
	AddParam("userid",iUserID);
	AddUIDParam("guid",sGUID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("DisableUsersEmailAlerts"))
	{
		return false;
	}

	return true;
}
/*********************************************************************************

	bool CStoredProcedure::DeleteDNASystemMessage

		Author:		James Conway
		Created:	12/07/2006
		Inputs:		iMsgID - The id of the message to be deleted
		Outputs:	-
		Returns:	true if ok, false if not.
		Purpose:	Deletes user's dna system message.

*********************************************************************************/
bool CStoredProcedure::DeleteDNASystemMessage(int iMsgID)
{
	StartStoredProcedure("deletednasystemmessage");

	// Setup the params
	AddParam("msgid",iMsgID);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("deletednasystemmessage"))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CStoredProcedure::FetchGuideEntry(int iH2G2ID)

	Author:		Steven Francis
	Created:	10/2/2003
	Inputs:		iH2G2ID - guidentry you want to get details for
	Outputs:	-
	Returns:	false if error or h2g2id not present
	Purpose:	Fetches information about the guidentry from the guideentries
				table.

*********************************************************************************/

bool CStoredProcedure::FetchGuideEntry(int iH2G2ID)
{
	if (iH2G2ID < 1)
	{
		TDVASSERT(false, "FetchGuide Entry called with invalid H2G2ID");
		return false;
	}

	int iEntryID = iH2G2ID / 10;

	StartStoredProcedure("FetchGuideEntry");

	AddParam("EntryID", iEntryID);
	ExecuteStoredProcedure();
	
	if (HandleError("FetchGuideEntry"))
	{
		return false;
	}

	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeArticlesWithMediaAssets(int iNodeID, iType )

	Author:		Steven Francis
    Created:	15/08/2006
	Inputs:		- NodeID for tagged articles ,  Type filter
	Outputs:	-
	Returns:	true if successful
	Purpose:	gets the articles within the given hierarchy node with the mediaasset info

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeArticlesWithMediaAssets(int iNodeID, bool& bSuccess,  int iType/*=0*/, int iMaxResults /*=500*/, bool bIncludeContentRatingData)
{
	// Start the procedure
	StartStoredProcedure("getarticlesinhierarchynodewithmediaassets");

	// Add the params
	AddParam(iNodeID);
	AddParam(iType);
	AddParam(iMaxResults);
	AddParam(bIncludeContentRatingData);
	AddParam("currentsiteid", m_SiteID);

	// Now execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("getarticlesinhierarchynodewithmediaassets"))
	{
		return false;
	}

	// Set the success flag and return
	bSuccess = !IsEOF();
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeArticlesWithLocalWithMediaAssets(int iNodeID,  int iType, 
		int iMaxResults, bool bIncludeContentRatingData, int iUserTaxonomyNodeID)

	Author:		Steven Francis
    Created:	15/08/2006
	Inputs:		- NodeID for tagged articles 
				- iType type filter
				- iMaxResults maximum results to return
				- bIncludeContentRating to include content ratings
				- iUserTaxonomyNodeID - the user's taxonomy node
	Outputs:	-
	Returns:	true if successful
	Purpose:	gets the articles within the given hierarchy node and tags if local with the mediaasset info

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeArticlesWithLocalWithMediaAssets(int iNodeID,  int iType/*=0*/, int iMaxResults /*=500*/, bool bIncludeContentRatingData, int iUserTaxonomyNodeID/*=0*/)
{
	StartStoredProcedure("getarticlesinhierarchynodewithlocalwithmediaassets");
	AddParam("nodeid", iNodeID);
	AddParam("type", iType);
	AddParam("maxresults", iMaxResults);
	AddParam("showcontentratingdata", (int)bIncludeContentRatingData);
	AddParam("usernodeid", iUserTaxonomyNodeID);
	AddParam("currentsiteid", m_SiteID);

	ExecuteStoredProcedure();
	if (HandleError("getarticlesinhierarchynodewithlocalwithmediaassets"))
	{
		return false;
	}
	return !IsEOF();
}

/*********************************************************************************

	bool CStoredProcedure::GetHierarchyNodeArticlesWithKeyPhrases(int iNodeID,  int iType, int iMaxResults, bool bShowMediaAssetInfo)

	Author:		Steven Francis
    Created:	03/05/2007
	Inputs:		- NodeID for tagged articles 
				- iType type filter
				- iMaxResults maximum results to return
				- bShowMediaAssetInfo whether to include media asset info
	Outputs:	-
	Returns:	true if successful
	Purpose:	gets the articles within the given hierarchy node with the keyphrases 
				as the first result set

*********************************************************************************/
bool CStoredProcedure::GetHierarchyNodeArticlesWithKeyPhrases(int iNodeID,  int iType/*=0*/, int iMaxResults /*=500*/, bool bShowMediaAssetInfo /*=false*/)
{
	StartStoredProcedure("getarticlesinhierarchynodewithkeyphrases");
	AddParam("nodeid", iNodeID);
	AddParam("type", iType);
	AddParam("maxresults", iMaxResults);
	AddParam("showmediaassetdata", (int)bShowMediaAssetInfo);
	AddParam("currentsiteid", m_SiteID);

	ExecuteStoredProcedure();
	if (HandleError("getarticlesinhierarchynodewithkeyphrases"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetNewUserForSite(int iSiteID, const TDVCHAR* pTimeUnit, int iNoOfUnits, CTDVString* psTotal)

		Author:		Mark Howitt
		Created:	20/09/2006
		Inputs:		iSiteID - The id of the iste you want to get the new users for.
					pTimeUnit - The unit of time that you want to search across.
						Current one of the following...
							Day
							Week
							Month
							Year
					iNoOfUnits - The number of time units you want to search across.
						The Max value is 1 Year in any unit.
		Outputs:	pTotal - If not null will take the total number of users found.
		Returns:	True if ok, false if not
		Purpose:	Gets the details of all the users who have joined a site over a
					given date range for a given site.

*********************************************************************************/
bool CStoredProcedure::GetNewUserForSite(int iSiteID, const TDVCHAR* pTimeUnit, int iNoOfUnits, int* pTotal)
{
	StartStoredProcedure("getnewusersforsite");

	// Setup the params
	AddParam("SiteID",iSiteID);
	AddParam("TimeUnit",pTimeUnit);
	AddParam("NumberOfUnits",iNoOfUnits);

	// Add the output param if we've been given one
	AddOutputParam("COunt",pTotal);
	
	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("GetNewUserForSite"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::SetArticleDateRange(int iEntryID, CTDVDateTime& dStartDate, CTDVDateTime& dEndDate, int iTimeInterval)

		Author:		Mark Neves
		Created:	18/01/2007
		Inputs:		iEntryID = Entry ID of article
					dStartDate = start of range
					dEndDate = end of range
					iTimeInterval = 0 or num days with the range specifying the event's duration
		Outputs:	-
		Returns:	true or false
		Purpose:	Adds a date range for the given article

*********************************************************************************/

bool CStoredProcedure::SetArticleDateRange(int iEntryID, CTDVDateTime& dStartDate, CTDVDateTime& dEndDate, int iTimeInterval)
{
	StartStoredProcedure("setarticledaterange");

	// Setup the params
	AddParam("EntryID",iEntryID);
	AddParam("StartDate",dStartDate);
	AddParam("EndDate",dEndDate);
	AddParam("TimeInterval",iTimeInterval);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("SetArticleDateRange"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::RemoveArticleDateRange(int iEntryID)

		Author:		Steve Francis
		Created:	19/06/2007
		Inputs:		iEntryID = Entry ID of article
		Outputs:	-
		Returns:	true or false
		Purpose:	Removes a date range from the given article

*********************************************************************************/

bool CStoredProcedure::RemoveArticleDateRange(int iEntryID)
{
	StartStoredProcedure("removearticledaterange");

	// Setup the param
	AddParam("EntryID",iEntryID);

	// Execute the procedure
	ExecuteStoredProcedure();
	if (HandleError("removearticledaterange"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetUsersMostRecentComments(int iUserID, int iSiteId, int iSkip, int iShow )

	Author:		Steven Francis
	Created:	15/06/2007
	Inputs:		iUserID - user ID of the user whose most recent comments this object
					should contain.
				iShow - the site to get the comments for.
				iShow - the maximum number of comments to include in list.
				iSkip - the number of records to skip
    Outputs:	-
    Returns:	true if ok, false if not
    Purpose:	Fetches all the comments for a given user.

*********************************************************************************/

bool CStoredProcedure::GetUsersMostRecentComments(int iUserID, int iSiteId, int iSkip, int iShow )
{
	StartStoredProcedure("getusercommentsstats");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteId);
	AddParam("firstindex", iSkip);
	AddParam("lastindex", iSkip + iShow);
	ExecuteStoredProcedure();
	if (HandleError("getusercommentsstats"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsEmailInBannedList(CTDVString sEmailToCheck)

		Author:		Mark Howitt
		Created:	10/07/2007
		Inputs:		sEmailToCheck - the email that you want to check to see if it's banned
		Outputs:	-
		Returns:	True if ok, false if not
		Purpose:	Checks the banned email list to see if the given email exists

*********************************************************************************/
bool CStoredProcedure::IsEmailInBannedList(CTDVString sEmailToCheck)
{
	// Start the procedure, add the param and then execute
	StartStoredProcedure("IsEmailInBannedList");
	AddParam("EMail",sEmailToCheck);
	if (!ExecuteStoredProcedure() || HandleError("IsEmailInBannedList"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::AddArticleSubscription( int h2g2Id )

		Author:		Martin Robb
		Created:	10/09/2007
		Inputs:		h2g2Id of new article.
		Outputs:	-
		Returns:	True if ok, false if not
		Purpose:	Adds article to subscribed users article subscriptions

*********************************************************************************/
bool CStoredProcedure::AddArticleSubscription( int h2g2Id )
{
	// Start the procedure, add the param and then execute
	StartStoredProcedure("addarticlesubscription");
	AddParam("h2g2id", h2g2Id);
	if (!ExecuteStoredProcedure() || HandleError("addarticlesubscription"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetRecentArticlesOfSubscribedToUsers( int iUserID, int iSiteID )
{
	// Start the procedure, add the param and then execute
	StartStoredProcedure("getrecentsubscribedarticles");
	AddParam("userid", iUserID);
	AddParam("siteid", iSiteID);
	if (!ExecuteStoredProcedure() || HandleError("getrecentsubscribedarticles"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::GetArticleLocations(int h2g2Id)
{
	StartStoredProcedure("getguideentrylocation");
	AddParam("h2g2id", h2g2Id);
	if (!ExecuteStoredProcedure() || HandleError("getguideentrylocation"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::AddEntryLocations(int ih2g2id, int iUserId, CTDVString& sLocationXML)
{
	StartStoredProcedure("setguideentrylocation");
	AddParam("entryid", ih2g2id);
	AddParam("userid", iUserId);
	AddParam("locationxml", sLocationXML);
	if (!ExecuteStoredProcedure() || HandleError("setguideentrylocation"))
	{
		return false;
	}
	return true;
}

bool CStoredProcedure::IsEmailBannedFromComplaints(CTDVString& sEMail)
{
	StartStoredProcedure("isemailbannedfromcomplaints");
	AddParam("EMail", sEMail);
	if (!ExecuteStoredProcedure() || HandleError("isemailbannedfromcomplaints"))
	{
		return false;
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::GetBookmarkCount(int iH2G2ID, int piBookmarkCount)

	Author:		Steven Francis
	Created:	10/2/2003
	Inputs:		iH2G2ID - guidentry you want to get details for
	Outputs:	piBookmarkCount - the bookmark count
	Returns:	false if error or h2g2id not present
	Purpose:	Fetches information about the guidentry from the guideentries
				table.

*********************************************************************************/

bool CStoredProcedure::GetBookmarkCount(int iH2G2ID, int* piBookmarkCount)
{
	if (iH2G2ID < 1)
	{
		TDVASSERT(false, "GetBookmarkCount Entry called with invalid H2G2ID");
		return false;
	}

	StartStoredProcedure("GetBookmarkCount");

	AddParam("H2G2ID", iH2G2ID);
	ExecuteStoredProcedure();
	
	if (HandleError("GetBookmarkCount"))
	{
		return false;
	}

	if (IsEOF())
	{
		*piBookmarkCount = 0;
	}
	else
	{
		*piBookmarkCount = GetIntField("BookmarkCount");
	}
	return true;
}

/*********************************************************************************

	bool CStoredProcedure::IsNickNameInModerationQueue(int iUserID)

		Author:		Mark Howitt
		Created:	14/12/2007
		Inputs:		iUserID - The id of the user you want to see if their nickname is queued
								for moderation.
		Outputs:	-
		Returns:	True if everything ok, false if not
		Purpose:	Checks to see if the given user has a nicjkname in the nickname moderation queue

*********************************************************************************/
bool CStoredProcedure::IsNickNameInModerationQueue(int iUserID)
{
	StartStoredProcedure("isnicknameinmoderationqueue");
	AddParam("UserID", iUserID);
	if (!ExecuteStoredProcedure() || HandleError("isnicknameinmoderationqueue"))
	{
		return false;
	}
	return true;
}

/********************************************************************************
 bool CStoredProcedure::IsNickNameInModerationQueue(int iUserID)

		Author:		Martin Robb
		Created:	22/04/2008
		Inputs:		iUserID - userid to check
					iSiteID	- siteid filter
					
		Outputs:	- Daily User Article Count
		Returns:	True if everything ok, false if not
		Purpose:	Checks users daily article count. Used to limit articles a user may create on a daily basis.

*********************************************************************************/
bool CStoredProcedure::GetMemberArticleCount( int iUserID, int iSiteID, int& userarticlecount )
{
	StartStoredProcedure("getmemberarticlecount");
	AddParam("userid",iUserID);
	AddParam("siteid", iSiteID);
	if  ( ExecuteStoredProcedure() && !IsEOF() )
	{
		userarticlecount = GetIntField("articlecount");
		return true;
	}
	return false;
}

/*********************************************************************************

	bool CStoredProcedure::CreateNewUserFromIdentityID(int iIdentityUserID, int iLegacySSOUserID, const TDVCHAR *pUserName, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName)

		Author:		Mark Howitt
		Created:	04/08/2008
		Inputs:		iIdentityUserID - The Identity ID for the user to be created.
					iLegacySSOUserID - The legacy SSO ID for the user if they have one.
					pUserName - The name for the user being created.
					pEMail - The users email address.
					pFirstNames - The first names for the user. Can be NULL depending on the site.
					pLastName - The last name for the user. Can be NULL depending on the site.
		Returns:	True if the user was created, false if not.
		Purpose:	Gets the user details from the database. If they do not exist then they get created.

*********************************************************************************/
bool CStoredProcedure::CreateNewUserFromIdentityID(int iIdentityUserID, int iLegacySSOUserID, const TDVCHAR *pUserName, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName, const TDVCHAR* pDisplayName)
{
	StartStoredProcedure("createnewuserfromidentityid");

	AddParam("identityuserid",iIdentityUserID);
	if (iLegacySSOUserID > 0)
	{
		AddParam("legacyssoid",iLegacySSOUserID);
	}
	AddParam("username",pUserName);
	AddParam("email", pEmail);
	AddParam("siteid",iSiteID);
	if (pFirstName != NULL) 
	{
		AddParam("firstnames",pFirstName);
	}

	if (pLastName != NULL)
	{
		AddParam("lastname",pLastName);
	}

	if (pDisplayName != NULL && strlen(pDisplayName) > 0)
	{
		AddParam("displayname",pDisplayName);
	}

	ExecuteStoredProcedure();
	if (HandleError("CreateNewUserFromIdentityID"))
	{
		// An error was handled, so indicate that the stored procedure failed by returning false
		return false;
	}	

	if (!IsEOF())
	{
		return true;
	}
	else
	{
		return false;
	}
}

/*********************************************************************************

	bool CStoredProcedure::CreateNewUserFromSSOID(int iSSOUserID, const TDVCHAR *pUserName, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName)

		Author:		Mark Howitt
		Created:	04/08/2008
		Inputs:		iSSOUserID - The SSO User ID for the user to be created.
					pUserName - The name for the user being created.
					pEMail - The users email address.
					pFirstNames - The first names for the user. Can be NULL depending on the site.
					pLastName - The last name for the user. Can be NULL depending on the site.
		Returns:	True if the user was created, false if not.
		Purpose:	Gets the user details from the database. If they do not exist then they get created.

*********************************************************************************/
bool CStoredProcedure::CreateNewUserFromSSOID(int iSSOUserID, const TDVCHAR *pUserName, const TDVCHAR* pEmail, int iSiteID, const TDVCHAR* pFirstName, const TDVCHAR* pLastName, const TDVCHAR* pDisplayName)
{
	StartStoredProcedure("createnewuserfromssoid");
	AddParam("ssouserid",iSSOUserID);
	AddParam("username",pUserName);
	AddParam("email", pEmail);
	AddParam("siteid",iSiteID);
	if (pFirstName != NULL) 
	{
		AddParam("firstnames",pFirstName);
	}

	if (pLastName != NULL)
	{
		AddParam("lastname",pLastName);
	}

	if (pDisplayName != NULL && strlen(pDisplayName) > 0)
	{
		AddParam("displayname",pDisplayName);
	}

	ExecuteStoredProcedure();
	if (HandleError("CreateNewUserFromSSOID"))
	{
		// An error was handled, so indicate that the stored procedure failed by returning false
		return false;
	}	

	if (!IsEOF())
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool CStoredProcedure::GetDNAUserIDFromSSOUserID(int iSSOUserID, bool& bIDFound)
{
	StartStoredProcedure("getdnauseridfromssouserid");
	AddParam("ssouserid",iSSOUserID);
	ExecuteStoredProcedure();
	if (HandleError("GetDNAUserIDFromSSOUserID"))
	{
		// An error was handled, so indicate that the stored procedure failed by returning false
		return false;
	}	
	bIDFound = !IsEOF();
	return true;
}

bool CStoredProcedure::GetDNAUserIDFromIdentityUserID(int iIdentityUserID, bool& bIDFound)
{
	StartStoredProcedure("getdnauseridfromidentityuserid");
	AddParam("IdentityUserID",iIdentityUserID);
	ExecuteStoredProcedure();
	if (HandleError("GetDNAUserIDFromIdentityUserID"))
	{
		// An error was handled, so indicate that the stored procedure failed by returning false
		return false;
	}
	bIDFound = !IsEOF();
	return true;
}
