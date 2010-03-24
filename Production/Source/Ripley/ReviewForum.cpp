// ReviewForum.cpp: implementation of the CReviewForum class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "tdvassert.h"
#include "ReviewForum.h"
#include "GuideEntry.h"
#include "StoredProcedure.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CReviewForum::CReviewForum(CInputContext& inputContext) 
: CXMLObject(inputContext), 
m_bInitialised(false),
m_iSiteID(0),
m_iH2G2ID(0),
m_bRecommend(false),
m_iIncubateTime(0)
{

}

CReviewForum::~CReviewForum()
{

}

/*********************************************************************************

	bool CReviewForum::Initialise(int iReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	9/13/01
	Inputs:		iReviewForumID - review forum id
				bAlwaysFromDb = set to true if you want info from DB
	Outputs:	-
	Returns:	true if successful
	Purpose:	initialises the object with the details about the current review 
				forum
*********************************************************************************/

bool CReviewForum::Initialise(int iID,bool bIDIsReviewForumID, bool bAlwaysFromDB /*=false*/)
{
	CTDVString cachename = "RF";

	if (bIDIsReviewForumID)
	{
		int iReviewForumID = iID;

		cachename << "-"<< iReviewForumID << ".txt";

		CTDVDateTime dExpires(60*60*12);	//expire after 12 hours

		CTDVString sReviewForum = "";

		//get it from the cache if you can
		if (!bAlwaysFromDB && CacheGetItem("reviewforums", cachename, &dExpires, &sReviewForum))
		{
			int iReviewForumID = 0;
			TDVCHAR sReviewForumName[256];
			TDVCHAR sURLFriendlyName[256];
			int iH2G2ID = 0;
			int iSiteID = 0;
			int iRecommend = 0;
			int iIncubateTime = 0;

			// first read in the member variables
			int iVarsRead = sscanf(sReviewForum, "%d\n%d\n%d\n%d\n%d\n%[^\n]\n%s[^\n]",&iReviewForumID,&iH2G2ID,&iSiteID,&iRecommend,&iIncubateTime,&sReviewForumName,&sURLFriendlyName);
			if (iVarsRead == 7)
			{
				m_iReviewForumID = iReviewForumID;
				m_sReviewForumName = sReviewForumName;
				m_sURLFriendlyName = sURLFriendlyName;
				m_iH2G2ID = iH2G2ID;
				m_iSiteID = iSiteID;
				m_iIncubateTime = iIncubateTime;
				if (iRecommend)
				{
					m_bRecommend = true;
				}
				else
				{
					m_bRecommend = false;
				}
				
				m_bInitialised = true;
				return true;
			}

			TDVASSERT(false,"problem with reading the reviewforum initialisation cache");

			//Fall through if there is a problem with reading the cache
		}
	}

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetReviewForumThreadList");
		GracefulError("REVIEWFORUM","DBERROR","A Database Error Occured. Click Refresh to try again");
		return false;
	}

	bool bOK = false;

	if (bIDIsReviewForumID)
	{
		bOK = mSP.FetchReviewForumDetailsViaReviewForumID(iID);
	}
	else
	{
		bOK = mSP.FetchReviewForumDetailsViaH2G2ID(iID);
	}

	if (bOK)
	{
		m_iReviewForumID = mSP.GetIntField("ReviewForumID");
		m_bInitialised = true;
		mSP.GetField("forumname",m_sReviewForumName);
		mSP.GetField("urlfriendlyname",m_sURLFriendlyName);
		m_iH2G2ID = mSP.GetIntField("h2g2id");
		m_iSiteID = mSP.GetIntField("siteid");
		m_iIncubateTime = mSP.GetIntField("IncubateTime");
		if (mSP.GetIntField("recommend"))
		{
			m_bRecommend = true;
		}
		else
		{
			m_bRecommend = false;
		}

		//create the cache text
		CTDVString sReviewForum;
		sReviewForum << m_iReviewForumID << "\n";
		sReviewForum << m_iH2G2ID << "\n";
		sReviewForum << m_iSiteID << "\n";
		sReviewForum << m_bRecommend << "\n";
		sReviewForum << m_iIncubateTime << "\n";
		sReviewForum << m_sReviewForumName << "\n";
		sReviewForum << m_sURLFriendlyName << "\n";
		
		CachePutItem("reviewforums", cachename, sReviewForum);
		return true;
	}

	GracefulError("REVIEWFORUM","BADID","The review forum id is invalid","FrontPage","FrontPage");
	return false;	
}

/*********************************************************************************

	bool CReviewForum::InitialiseViaReviewForumID(int iReviewForumID,bool bAlwaysFromDB)
	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Allows a review forum to be initialised with a ReviewForumID

*********************************************************************************/

bool CReviewForum::InitialiseViaReviewForumID(int iReviewForumID,bool bAlwaysFromDB /*=false*/)
{
	return Initialise(iReviewForumID, true, bAlwaysFromDB);
}

/*********************************************************************************

	bool CReviewForum::InitialiseViaH2G2ID(int iH2G2ID,bool bAlwaysFromDB)
	Author:		Mark Neves
	Created:	04/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Allows a review forum to be initialised with a H2G2ID

*********************************************************************************/

bool CReviewForum::InitialiseViaH2G2ID(int iH2G2ID,bool bAlwaysFromDB /*=false*/)
{
	return Initialise(iH2G2ID, false, bAlwaysFromDB);
}

bool CReviewForum::InitialiseFromData(int iReviewForumID,const TDVCHAR* sForumName, const TDVCHAR* sURLFriendlyName, int iIncubateTime, bool bRecommend,int iH2G2ID, int iSiteID)
{
	m_iReviewForumID = iReviewForumID;
	m_sReviewForumName = sForumName;
	m_sURLFriendlyName = sURLFriendlyName;
	//this will be a NULL value but is left in for legacy reasons
	m_iH2G2ID = iH2G2ID;
	m_iSiteID = iSiteID;
	m_iIncubateTime = iIncubateTime;
	m_bRecommend = bRecommend;
	m_bInitialised = true;
	return true;
}

int CReviewForum::GetSiteID() const
{
	return m_iSiteID;
}

int CReviewForum::GetH2G2ID() const
{
	return m_iH2G2ID;
}

int CReviewForum::GetReviewForumID() const
{
	return m_iReviewForumID;
}

int CReviewForum::GetIncubateTime() const
{
	return m_iIncubateTime;
}

bool CReviewForum::IsRecommendable() const
{
	return m_bRecommend;
}

const CTDVString& CReviewForum::GetReviewForumName() const
{
	return m_sReviewForumName;
}


const CTDVString& CReviewForum::GetURLFriendlyName() const
{
	return m_sURLFriendlyName;
}

bool CReviewForum::IsInitialised() const
{
	return m_bInitialised;

}

/*********************************************************************************

	bool CReviewForum::GetReviewForumThreadList(int iReviewForumID,int iNumThreads, int iNumSkipped)

	Author:		Dharmesh Raithatha
	Created:	9/7/01
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CReviewForum::GetReviewForumThreadList(int iNumThreads, int iNumSkipped, OrderBy eOrderBy, bool bAscending)
{
	TDVASSERT(m_bInitialised,"Tried to use review forum without initialising");

	TDVASSERT(iNumThreads > 0, "Stupid to not fetch any threads from forum");

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetReviewForumThreadList");
		GracefulError("REVIEWFORUM","DBERROR","A Database Error Occured. Click Refresh to try again");
		return true;
	}

	// Create the cachename - "RFT-1-1-1-25-264.txt"

	CTDVString cachename = "RFT";
	cachename << m_iReviewForumID << "-" << eOrderBy << "-" << bAscending << "-" << iNumSkipped << "-" << iNumSkipped + iNumThreads - 1 << ".txt";

	CTDVDateTime dLastDate;

	//find out the cache dirty date
	mSP.CacheGetMostRecentReviewForumThreadDate(m_iReviewForumID, &dLastDate);

	CTDVString sReviewForumXML = "";

	//get it from the cache if you can
	if (CacheGetItem("reviewforums", cachename, &dLastDate, &sReviewForumXML))
	{
		// this should not fail, but might if cache is garbled so check anyway
		if (CreateFromCacheText(sReviewForumXML))
		{
			UpdateRelativeDates();
			return true;
		}
	}

	//get the reviewforum details

	bool bGotThreads = GetReviewForumThreadsFromDatabase(mSP,m_iReviewForumID,eOrderBy,bAscending);

	// If there aren't any more threads we should still return an empty set
	// not fail

		// Got a list, so let's skip the first NumSkipped threads
	if (bGotThreads && iNumSkipped > 0)
	{
		mSP.MoveNext(iNumSkipped);
	}

	int iForumID = 0;

	if (bGotThreads)
	{
		iForumID = mSP.GetIntField("forumid");
	}

	//Get the review forum in xml form
	if (!GetAsXMLString(sReviewForumXML))
	{
		GracefulError("REVIEWFORUM","XML","An XML Error Occured");
		return true;
	}

	if (!CreateFromXMLText(sReviewForumXML))
	{
		GracefulError("REVIEWFORUM","XML","An XML Error Occured");
		return true;
	}

	CTDVString sThreads = "";

	//now lets build up the review forums threads xml
	
	sThreads << "<REVIEWFORUMTHREADS FORUMID='";
	sThreads << iForumID << "' SKIPTO='" << iNumSkipped << "' COUNT='" << iNumThreads << "'";
	
	if (bGotThreads)
	{
		int iTotalThreads = mSP.GetIntField("ThreadCount");
		sThreads << " TOTALTHREADS='" << iTotalThreads << "'"
		<< " ORDERBY='" << eOrderBy << "'"
		<< " DIR='" << bAscending << "'"; 
	}
	
	sThreads << ">";

	int iIndex = 0;

	if (bGotThreads)
	{
		while (!mSP.IsEOF() && iNumThreads > 0)
		{
			int ThreadID = mSP.GetIntField("ThreadID");
			CTDVString sSubject = "";
			mSP.GetField("Subject", sSubject);
			EscapeXMLText(&sSubject);
			CTDVDateTime dDatePosted = mSP.GetDateField("LastPosted");
			CTDVString sDatePosted = "";
			dDatePosted.GetAsXML(sDatePosted);
			CTDVDateTime dDateEntered = mSP.GetDateField("DateEntered");
			CTDVString sDateEntered = "";
			dDateEntered.GetAsXML(sDateEntered);
			int iH2G2ID = 0;
			iH2G2ID = mSP.GetIntField("h2g2id");
			int iAuthorID = mSP.GetIntField("authorid");
			CTDVString sUserName;
			mSP.GetField("username",sUserName);
			int iSubmitterID = mSP.GetIntField("submitterid");

			
			sThreads << "<THREAD INDEX='" << iIndex << "'><THREADID>" << ThreadID << "</THREADID>\n"
				<< "<H2G2ID>" << iH2G2ID << "</H2G2ID>\n"
				<< "<SUBJECT>" << sSubject << "</SUBJECT>\n"
				<< "<DATEPOSTED>" << sDatePosted << "</DATEPOSTED>\n"
				<< "<DATEENTERED>" << sDateEntered << "</DATEENTERED>\n"
				<< "<AUTHOR><USER>"
				<< "<USERID>" << iAuthorID << "</USERID>"
				<< "<USERNAME>" << sUserName << "</USERNAME>\n"
				<< "</USER></AUTHOR>"
				<< "<SUBMITTER><USER>"
				<< "<USERID>" << iSubmitterID << "</USERID>"
				<< "</USER></SUBMITTER>"
				<< "</THREAD>\n";
			mSP.MoveNext();
			iNumThreads--;
			iIndex++;
		}
	}

	sThreads << "</REVIEWFORUMTHREADS>";
	
	if (!AddInside("REVIEWFORUM",sThreads))
	{
		GracefulError("REVIEWFORUM","XML","An XML Error Occured");
		return true;
	}
	
	// If we haven't yet reached EOF then set the 'more' flag

	if (!mSP.IsEOF())
	{
		// Get the node and add a MORE attribute
		CXMLTree* pFNode = m_pTree->FindFirstTagName("REVIEWFORUMTHREADS");
		TDVASSERT(pFNode != NULL, "Can't find REVIEWFORUMTHREADS node");
		
		if (pFNode != NULL)
		{
			pFNode->SetAttribute("MORE","1");
		}
	}

	CTDVString StringToCache;
	CreateCacheText(&StringToCache);
	CachePutItem("reviewforums", cachename, StringToCache);

	UpdateRelativeDates();
	
	return true;

}

bool CReviewForum::AreNamesUniqueWithinSite(const TDVCHAR* sName,const TDVCHAR* sURL,int iSiteID,bool* bUnique)
{
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CReviewForum::NamesAlreadyExist");
		return false;
	}
	
	if (!mSP.FetchAllReviewForumDetails())
	{
		*bUnique = true;
		return true;
	}

	while (!mSP.IsEOF())
	{
		CTDVString sReviewForumName;
		CTDVString sURLFriendlyName;
		int iNextSiteID = 0;

		mSP.GetField("ForumName",sReviewForumName);
		mSP.GetField("URLFriendlyName",sURLFriendlyName);
		iNextSiteID = mSP.GetIntField("SiteID");

		//if the review forum is in the same site and either of the names are the same then fail
		if (iNextSiteID == iSiteID && (sReviewForumName.CompareText(sName) || sURLFriendlyName.CompareText(sURL)))
		{
			*bUnique = false;
			return true;
		}

		mSP.MoveNext();
	}

	*bUnique = true;
	return true;
}

bool CReviewForum::GetReviewForumThreadsFromDatabase(CStoredProcedure& mSP, int iReviewForumID, OrderBy eOrderBy, bool bAscending)
{
	switch (eOrderBy)
	{
	case DATEENTERED :
		{
			return mSP.FetchReviewForumThreadsByDateEntered(iReviewForumID,bAscending);
		}
	case LASTPOSTED	:
		{
			return mSP.FetchReviewForumThreadsByLastPosted(iReviewForumID,bAscending);
		}
	case AUTHORID :
		{
			return mSP.FetchReviewForumThreadsByUserID(iReviewForumID,bAscending);
		}
	case AUTHORNAME :
		{
			return mSP.FetchReviewForumThreadsByUserName(iReviewForumID,!bAscending);
		}
	case H2G2ID :
		{
			return mSP.FetchReviewForumThreadsByH2G2ID(iReviewForumID,bAscending);
		}
	case SUBJECT :
		{
			return mSP.FetchReviewForumThreadsBySubject(iReviewForumID,!bAscending);
		}
	default:
		{
			return false;
		}
	} 
}

bool CReviewForum::GetAsXMLString(CTDVString& sResult) const
{
	TDVASSERT(sResult.IsEmpty(),"Non-empty string used in CReviewForum::GetAsXMLString");

	if (!m_bInitialised)
	{
		return false;
	}

	sResult = "";
	sResult << "<REVIEWFORUM ID='" << m_iReviewForumID << "'>" 
		<< "<FORUMNAME>" << m_sReviewForumName << "</FORUMNAME>" 
		<< "<URLFRIENDLYNAME>" << m_sURLFriendlyName << "</URLFRIENDLYNAME>"
		<< "<RECOMMENDABLE>" << IsRecommendable() << "</RECOMMENDABLE>"
		<< "<H2G2ID>" << m_iH2G2ID << "</H2G2ID>"
		<< "<SITEID>" << m_iSiteID << "</SITEID>"
		<< "<INCUBATETIME>" << m_iIncubateTime << "</INCUBATETIME>"
		<< "</REVIEWFORUM>";

	return true;
}

bool CReviewForum::Update(const TDVCHAR* sName,const TDVCHAR* sURL,bool bRecommendable, 
						  int iIncubateTime)
{

	TDVASSERT(IsInitialised(),"Called CReviewForum::Update without Initialising the reviewforum first");

	if (bRecommendable == 0 && iIncubateTime != m_iIncubateTime)
	{
		iIncubateTime = m_iIncubateTime;
	}

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetReviewForumThreadList");
		return false;
	}

	if (!mSP.UpdateReviewForum(m_iReviewForumID,sName,sURL,bRecommendable,iIncubateTime))
	{
		return false;
	}

	m_sReviewForumName = sName;
	m_sURLFriendlyName = sURL;
	m_bRecommend = bRecommendable;
	m_iIncubateTime = iIncubateTime;

	return true;
}

bool CReviewForum::GracefulError(const TDVCHAR* pOuterTag,const TDVCHAR* pErrorType,const TDVCHAR* pErrorText/*=NULL*/,
										   const TDVCHAR* pLinkHref/*NULL*/,const TDVCHAR* pLinkBody/*NULL*/)
{

	if (pOuterTag == NULL || pErrorType == NULL)
	{
		SetError("An error ocurred and we were unable to fail gracefully");
		return false;
	}

	Destroy();

	CTDVString errorXML;
	errorXML << "<" << pOuterTag << ">";
	errorXML << "<ERROR TYPE='";
	errorXML << pErrorType << "'>";
	if (pErrorText != NULL)
	{
		errorXML << "<MESSAGE>" << pErrorText << "</MESSAGE>";
	}
	if (pLinkHref != NULL && pLinkBody != NULL)
	{
		errorXML << "<LINK HREF='" << pLinkHref << "'>" << pLinkBody << "</LINK>";
	}

	errorXML << "</ERROR>" << "</" << pOuterTag << ">";

	if(!CreateFromXMLText(errorXML))
	{
		SetError("XML Error");
		return false;
	}

	return true;

}

/*********************************************************************************

	bool CReviewForum::CreateAndInitialiseNewReviewForum(const TDVCHAR* sForumName, const TDVCHAR* 
					   sURLFriendlyName, int iIncubateTime, int iUserID)

	Author:		Dharmesh Raithatha
	Created:	1/15/02
	Returns:	true if successfully added, false otherwise
	Purpose:	Creates a new reviewforum in the database

*********************************************************************************/

bool CReviewForum::CreateAndInitialiseNewReviewForum(const TDVCHAR* sForumName, const TDVCHAR* sURLFriendlyName, int iIncubateTime, bool bRecommend,int iSiteID, int iUserID)
{
	
	m_sURLFriendlyName = sURLFriendlyName;
	m_sReviewForumName = sForumName;

	// Get the user information

	if (m_sReviewForumName.IsEmpty() || m_sURLFriendlyName.IsEmpty() || m_sURLFriendlyName.Find(" ") >= 0 || iSiteID <= 0 || iIncubateTime < 0)
	{
		TDVASSERT(sForumName != NULL,"NULL forumname in CReviewForum::AddNewReviewForum");
		TDVASSERT(sURLFriendlyName != NULL,"NULL forumname in CReviewForum::AddNewReviewForum");
		TDVASSERT(m_sURLFriendlyName.Find(" ") < 0,"Spaces found in the URL");
		TDVASSERT(iIncubateTime >= 0, "Invalid incubate time in CReviewForum::AddNewReviewForum");
		TDVASSERT(iSiteID > 0,"invalid siteid in CReviewForum::AddNewReviewForum");
		TDVASSERT(iUserID > 0,"invalid userid in CReviewForum::AddNewReviewForum");
		return false;
	}

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		TDVASSERT(false, "Failed to create SP in CForum::GetReviewForumThreadList");
		return false;
	}

	CExtraInfo Extra;
	int iTypeID = CGuideEntry::TYPEREVIEWFORUM;
	if(!Extra.Create(iTypeID))
	{
		SetDNALastError("ReviewForum","InitialiseAndCreateNewReviewForum","Failed to create extrainfo for reviewforum due bad element");
		return false;
	}
	//pass in the object -not the string!
	
	int iReviewForumID = 0;
	
	if (!mSP.AddNewReviewForum(sForumName,sURLFriendlyName,iIncubateTime,bRecommend,iSiteID,&iReviewForumID, iUserID, Extra, iTypeID))
	{
		TDVASSERT(false,"Failed to add new review forum in CReviewForum::AddNewReviewForum");
		return false;
	}

	m_bRecommend = bRecommend;
	m_iIncubateTime = iIncubateTime;
	m_iSiteID = iSiteID;
	m_iReviewForumID = iReviewForumID;

	m_bInitialised= true;

	return true;
}

void CReviewForum::SetError(const TDVCHAR* pErrorText)
{
	CTDVString sErrorText = pErrorText;
	EscapeXMLText(&sErrorText);
	m_sErrorText = sErrorText;
}

const CTDVString& CReviewForum::GetError()
{
	return m_sErrorText;
}
