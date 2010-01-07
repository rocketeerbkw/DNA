// MessageboardStats.cpp: implementation of the CMessageboardStats class.
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
#include "InputContext.h"
#include "MessageboardStats.h"
#include "tdvassert.h"
#include "User.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

/*********************************************************************************

	CMessageboardStats::CMessageboardStats(CInputContext& inputContext) : CXMLObject(inputContext)

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CMessageboardStats::CMessageboardStats(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

/*********************************************************************************

	CMessageboardStats::~CMessageboardStats()

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CMessageboardStats::~CMessageboardStats()
{
}

/*********************************************************************************

	bool CMessageboardStats::Initialise()

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Initialises the underlying XML object with the root tag

*********************************************************************************/

bool CMessageboardStats::Initialise()
{
	return CreateFromXMLText(MakeTag("MESSAGEBOARDSTATS",""),NULL,true);
}


/*********************************************************************************

	bool CMessageboardStats::Process()

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Processes the request, based on the InputContext params.

					Creates the mb stats for the current site

					Params supported are:
						date:  Set this to the day of the stats you want.  
							   Format: "yyyymmdd"
							   If no "date" param is given, it will default to yesterday

						emailfrom & emailto:
							If both these email params are specified, an email is send to "emailto"
							that contains the URL of the page that will show the stats

*********************************************************************************/

bool CMessageboardStats::Process()
{
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		return SetDNALastError("CMessageboardStats","Process","Only editors can see this page");
	}

	if (!Initialise())
	{
		return SetDNALastError("CMessageboardStats","Process","Initialise failed");
	}

	CTDVDateTime dtDate(60*60*24);		// Assume the date required is yesterday
	CTDVString sDateParam;
	dtDate.GetAsString(sDateParam);
	dtDate.GetAsString(sDateParam,true);

	if (m_InputContext.ParamExists("date"))
	{
		m_InputContext.GetParamString("date",sDateParam);
	}

	sDateParam = sDateParam.Left(8);	// Truncate to just YYYYMMDD
	sDateParam << "000000";				// Add the HHMMSS to the date

	dtDate.SetFromString(sDateParam);

	int iSiteID = m_InputContext.GetSiteID();

	// Add the SiteID & Day to the root tag
	CDBXMLBuilder cXML;
	cXML.AddIntTag("SITEDID",iSiteID);
	AddInside("MESSAGEBOARDSTATS",cXML.GetXML());
	cXML.Clear();
	cXML.AddDateTag("DAY",dtDate);
	AddInside("MESSAGEBOARDSTATS",cXML.GetXML());

	// Generate the rest of the XML for this page
	GenerateModStatsPerTopic(iSiteID,dtDate);
	GenerateModStatsTopicTotals(iSiteID,dtDate);
	GenerateHostsPostsPerTopic(iSiteID,dtDate);

	// If the caller wants to send an email, do the biz
	if (m_InputContext.ParamExists("emailfrom") && m_InputContext.ParamExists("emailto"))
	{
		CTDVString sEmailFrom, sEmailTo;
		m_InputContext.GetParamString("emailfrom",sEmailFrom);
		m_InputContext.GetParamString("emailto",sEmailTo);

		SendMBStatsEmail(iSiteID,dtDate,sEmailFrom,sEmailTo);
	}

	return true;
}

/*********************************************************************************

	bool CMessageboardStats::GenerateModStatsPerTopic(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Generates the XML describing the Moderator stats per topic in the current site

*********************************************************************************/

bool CMessageboardStats::GenerateModStatsPerTopic(int iSiteID, CTDVDateTime& dtDate)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetMBStatsModStatsPerTopic(iSiteID,dtDate))
	{
		return SetDNALastError("CMessageboardStats","GenerateModStatsPerTopic",SP.GetLastError());
	}

	MBSTATS_MODSTATSPERTOPICS mapModStatsPerTopic;

	// Collect the data into the map
	while (!SP.IsEOF())
	{
		int iForumID = SP.GetIntField("ForumID");
		int iUserID  = SP.GetIntField("UserID");

		CTDVString sKey(iForumID);
		sKey << CTDVString(iUserID);

		if (mapModStatsPerTopic.find(sKey) == mapModStatsPerTopic.end())
		{
			mapModStatsPerTopic[sKey].m_iForumID = iForumID;
			mapModStatsPerTopic[sKey].m_iUserID = iUserID;
			SP.GetField("TopicTitle",mapModStatsPerTopic[sKey].m_sTopicTitle);
			SP.GetField("UserName",mapModStatsPerTopic[sKey].m_sUserName);
			SP.GetField("Email",mapModStatsPerTopic[sKey].m_sEmail);
		}

		int iStatusID = SP.GetIntField("StatusID");
		int iTotal = SP.GetIntField("Total");
		switch (iStatusID)
		{
			case 2 : mapModStatsPerTopic[sKey].m_iNumRefer = iTotal;	break;
			case 3 : mapModStatsPerTopic[sKey].m_iNumPass = iTotal;	break;
			case 4 : mapModStatsPerTopic[sKey].m_iNumFail = iTotal;	break;
		}

		SP.MoveNext();
	}

	CDBXMLBuilder cXML;
	cXML.OpenTag("MODSTATSPERTOPIC");

	// Convert the map into XML
	MBSTATS_MODSTATSPERTOPICS::iterator it = mapModStatsPerTopic.begin();
	while (it != mapModStatsPerTopic.end())
	{
		CModStatsPerTopic item = (CModStatsPerTopic)((*it).second); 

		cXML.OpenTag("TOPICMODSTAT");

		cXML.AddTag("TOPICTITLE",item.m_sTopicTitle);
		cXML.AddIntTag("FORUMID",item.m_iForumID);
		cXML.AddIntTag("USERID",item.m_iUserID);
		cXML.AddTag("USERNAME",item.m_sUserName);
		cXML.AddTag("EMAIL",item.m_sEmail);
		cXML.AddIntTag("PASSED",item.m_iNumPass);
		cXML.AddIntTag("FAILED",item.m_iNumFail);
		cXML.AddIntTag("REFERRED",item.m_iNumRefer);

		cXML.CloseTag("TOPICMODSTAT");
		it++;
	}

	cXML.CloseTag("MODSTATSPERTOPIC");

	return AddInside("MESSAGEBOARDSTATS",cXML.GetXML());
}

/*********************************************************************************

	bool CMessageboardStats::GenerateModStatsTopicTotals(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Generates the XML describing the Moderation totals per topic in the current site

*********************************************************************************/

bool CMessageboardStats::GenerateModStatsTopicTotals(int iSiteID, CTDVDateTime& dtDate)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetMBStatsModStatsTopicTotals(iSiteID,dtDate))
	{
		return SetDNALastError("CMessageboardStats","Process","GetMBStatsModStatsTopicTotals() failed");
	}

	MBSTATS_MODSTATSTOPICTOTALS mapModStatsTopicTotals;

	// Collect the data into the map
	while (!SP.IsEOF())
	{
		int iForumID = SP.GetIntField("ForumID");

		if (mapModStatsTopicTotals.find(iForumID) == mapModStatsTopicTotals.end())
		{
			mapModStatsTopicTotals[iForumID].m_iForumID = iForumID;
			SP.GetField("TopicTitle",mapModStatsTopicTotals[iForumID].m_sTopicTitle);
		}

		int iStatusID = SP.GetIntField("StatusID");
		int iTotal = SP.GetIntField("Total");
		switch (iStatusID)
		{
			case 2 : mapModStatsTopicTotals[iForumID].m_iNumRefer = iTotal;	break;
			case 3 : mapModStatsTopicTotals[iForumID].m_iNumPass = iTotal;	break;
			case 4 : mapModStatsTopicTotals[iForumID].m_iNumFail = iTotal;	break;
		}

		SP.MoveNext();
	}

	if (!SP.GetMBStatsTopicTotalComplaints(iSiteID,dtDate))
	{
		return SetDNALastError("CMessageboardStats","GenerateModStatsTopicTotals",SP.GetLastError());
	}

	// Add the "complaints" and "total" to the map entries
	while (!SP.IsEOF())
	{
		int iForumID = SP.GetIntField("ForumID");
		int iTotal = SP.GetIntField("Total");
		mapModStatsTopicTotals[iForumID].m_iNumComplaints = iTotal;

		mapModStatsTopicTotals[iForumID].m_iTotal = 
			mapModStatsTopicTotals[iForumID].m_iNumPass +
			mapModStatsTopicTotals[iForumID].m_iNumFail +
			mapModStatsTopicTotals[iForumID].m_iNumRefer +
			mapModStatsTopicTotals[iForumID].m_iNumComplaints;

		SP.MoveNext();
	}

	CDBXMLBuilder cXML;
	cXML.OpenTag("MODSTATSTOPICTOTALS");

	// Convert the map into XML
	MBSTATS_MODSTATSTOPICTOTALS::iterator it = mapModStatsTopicTotals.begin();
	while (it != mapModStatsTopicTotals.end())
	{
		CModStatsTopicTotals item = (CModStatsTopicTotals)((*it).second); 

		cXML.OpenTag("TOPICTOTALS");

		cXML.AddTag("TOPICTITLE",item.m_sTopicTitle);
		cXML.AddIntTag("FORUMID",item.m_iForumID);
		cXML.AddIntTag("PASSED",item.m_iNumPass);
		cXML.AddIntTag("FAILED",item.m_iNumFail);
		cXML.AddIntTag("REFERRED",item.m_iNumRefer);
		cXML.AddIntTag("COMPLAINTS",item.m_iNumComplaints);
		cXML.AddIntTag("TOTAL",item.m_iTotal);

		cXML.CloseTag("TOPICTOTALS");
		it++;
	}

	cXML.CloseTag("MODSTATSTOPICTOTALS");

	return AddInside("MESSAGEBOARDSTATS",cXML.GetXML());
}


/*********************************************************************************

	bool CMessageboardStats::GenerateHostsPostsPerTopic(int iSiteID, CTDVDateTime& dtDate)

		Author:		Mark Neves
        Created:	25/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Generates the XML describing the how many posts each host has made to each topic

*********************************************************************************/

bool CMessageboardStats::GenerateHostsPostsPerTopic(int iSiteID, CTDVDateTime& dtDate)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.GetMBStatsHostsPostsPerTopic(iSiteID,dtDate))
	{
		return SetDNALastError("CMessageboardStats","GenerateHostsPostsPerTopic",SP.GetLastError());
	}

	MBSTATS_HOSTSPOSTSPERTOPIC mapHostsPostsPerTopic;

	// Collect the data into the map
	while (!SP.IsEOF())
	{
		int iUserID  = SP.GetIntField("UserID");
		int iForumID = SP.GetIntField("ForumID");

		CTDVString sKey(iUserID);
		sKey << CTDVString(iForumID);

		mapHostsPostsPerTopic[sKey].m_iUserID = iUserID;
		mapHostsPostsPerTopic[sKey].m_iForumID = iForumID;
		SP.GetField("TopicTitle",mapHostsPostsPerTopic[sKey].m_sTopicTitle);
		SP.GetField("UserName",mapHostsPostsPerTopic[sKey].m_sUserName);
		SP.GetField("Email",mapHostsPostsPerTopic[sKey].m_sEmail);
		mapHostsPostsPerTopic[sKey].m_iTotalPosts= SP.GetIntField("Total");;

		SP.MoveNext();
	}

	CDBXMLBuilder cXML;
	cXML.OpenTag("HOSTSPOSTSPERTOPIC");

	// Convert the map into XML
	MBSTATS_HOSTSPOSTSPERTOPIC::iterator it = mapHostsPostsPerTopic.begin();
	while (it != mapHostsPostsPerTopic.end())
	{
		CHostsPostsPerTopic item = (CHostsPostsPerTopic)((*it).second); 

		cXML.OpenTag("HOSTPOSTSINTOPIC");

		cXML.AddIntTag("USERID",item.m_iUserID);
		cXML.AddTag("USERNAME",item.m_sUserName);
		cXML.AddTag("EMAIL",item.m_sEmail);
		cXML.AddTag("TOPICTITLE",item.m_sTopicTitle);
		cXML.AddIntTag("FORUMID",item.m_iForumID);
		cXML.AddIntTag("TOTALPOSTS",item.m_iTotalPosts);

		cXML.CloseTag("HOSTPOSTSINTOPIC");
		it++;
	}

	cXML.CloseTag("HOSTSPOSTSPERTOPIC");

	return AddInside("MESSAGEBOARDSTATS",cXML.GetXML());
}


/*********************************************************************************

	bool CMessageboardStats::SendMBStatsEmail(int iSiteID, CTDVDateTime& dtDate,const TDVCHAR* pEmailFrom, const TDVCHAR* pEmailTo)

		Author:		Mark Neves
        Created:	26/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Sends an email containing the URL for the stats that have just been generated

					If an error has occurred, it is included in the email

*********************************************************************************/

bool CMessageboardStats::SendMBStatsEmail(int iSiteID, CTDVDateTime& dtDate,const TDVCHAR* pEmailFrom, const TDVCHAR* pEmailTo)
{
	CTDVString sDate, sURL, sNameOfSite, sEmailSubject, sEmailText;

	dtDate.GetAsString(sDate,true);
	sDate = sDate.Left(8);

	m_InputContext.GetSiteRootURL(iSiteID,sURL);
	m_InputContext.GetNameOfSite(iSiteID,&sNameOfSite);

	sURL << "mbstats?date=" << sDate;

	sEmailSubject << "Moderation stats for site " << sNameOfSite;

	if (ErrorReported())
	{
		sEmailText << "The following Error occurred\n\n";
		sEmailText << GetLastErrorAsXMLString() << "\n\n";
		sEmailText << "The link below may not work\n\n";
	}

	sEmailText << "Moderation stats are now available:\n\n";
	sEmailText << "http://" << sURL;

	m_InputContext.SendMailOrSystemMessage(pEmailTo,sEmailSubject, sEmailText, pEmailFrom, sNameOfSite);

	return true;
}
