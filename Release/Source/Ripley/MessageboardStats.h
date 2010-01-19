// MessageboardStats.h: interface for the CMessageboardStats class.
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

#if !defined(AFX_MESSAGEBOARDSTATS_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
#define AFX_MESSAGEBOARDSTATS_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"
#include <map>
using namespace std;

class CInputContext;

//---------------------------------------------------------------------------------------

struct CModStatsPerTopic
{
	CModStatsPerTopic()
	{
		m_iForumID = m_iUserID = m_iNumFail = m_iNumPass = m_iNumRefer = 0;
	}

	int m_iForumID;
	int m_iUserID;
	int m_iNumFail;
	int m_iNumPass;
	int m_iNumRefer;

	CTDVString m_sTopicTitle;
	CTDVString m_sUserName;
	CTDVString m_sEmail;
};
typedef map<CTDVString, CModStatsPerTopic> MBSTATS_MODSTATSPERTOPICS;

//---------------------------------------------------------------------------------------

struct CModStatsTopicTotals
{
	CModStatsTopicTotals()
	{
		m_iForumID = m_iNumFail = m_iNumPass = m_iNumRefer = m_iNumComplaints = m_iTotal = 0;
	}

	int m_iForumID;
	int m_iNumFail;
	int m_iNumPass;
	int m_iNumRefer;
	int m_iNumComplaints;
	int m_iTotal;

	CTDVString m_sTopicTitle;
};
typedef map<int, CModStatsTopicTotals> MBSTATS_MODSTATSTOPICTOTALS;

//---------------------------------------------------------------------------------------

struct CHostsPostsPerTopic
{
	CHostsPostsPerTopic()
	{
		m_iUserID = m_iForumID = m_iTotalPosts = 0;
	}

	int m_iUserID;
	int m_iForumID;
	int m_iTotalPosts;

	CTDVString m_sTopicTitle;
	CTDVString m_sUserName;
	CTDVString m_sEmail;
};
typedef map<CTDVString, CHostsPostsPerTopic> MBSTATS_HOSTSPOSTSPERTOPIC;

//---------------------------------------------------------------------------------------

class CMessageboardStats : public CXMLObject  
{
public:
	CMessageboardStats(CInputContext& inputContext);
	virtual ~CMessageboardStats();

public:
	bool Process();

protected:
	bool Initialise();

	bool GenerateModStatsPerTopic(int iSiteID, CTDVDateTime& dtDate);
	bool GenerateModStatsTopicTotals(int iSiteID, CTDVDateTime& dtDate);
	bool GenerateHostsPostsPerTopic(int iSiteID, CTDVDateTime& dtDate);

	bool SendMBStatsEmail(int iSiteID, CTDVDateTime& dtDate,const TDVCHAR* pEmailFrom, const TDVCHAR* pEmailTo);
};

#endif // !defined(AFX_MESSAGEBOARDSTATS_H__F43943ED_BDA6_4122_8277_F7ED3DC0E51D__INCLUDED_)
