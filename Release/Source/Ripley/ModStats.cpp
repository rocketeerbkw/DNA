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
#include ".\modstats.h"
#include "InputContext.h"
#include ".\moderatorinfo.h"
#include ".\user.h"
#include <algorithm>
#include <vector>

//forum
const char* CModStats::FOR_QUE_NOTFASTMOD = "forum-queued-notfastmod";
const char* CModStats::FOR_QUE_FASTMOD = "forum-queued-fastmod";
const char* CModStats::FOR_LOC = "forum-locked";
const char* CModStats::FOR_REF_QUE = "forum-referrals-queued";
const char* CModStats::FOR_REF_LOC = "forum-referrals-locked";
const char* CModStats::FOR_QUE = "forum-queued";
//forum complaints
const char* CModStats::FOR_COM_QUE = "forum-complaints-queued";
const char* CModStats::FOR_COM_LOC = "forum-complaints-locked";
const char* CModStats::FOR_COM_REF_QUE = "forum-complaints-referrals-queued";
const char* CModStats::FOR_COM_REF_LOC = "forum-complaints-referrals-locked";
//entries
const char* CModStats::ENT_QUE = "entries-queued";
const char* CModStats::ENT_LOC = "entries-locked";
const char* CModStats::ENT_REF_QUE = "entries-referrals-queued";
const char* CModStats::ENT_REF_LOC = "entries-referrals-locked";
//entries complaints
const char* CModStats::ENT_COM_QUE = "entries-complaints-queued";
const char* CModStats::ENT_COM_LOC = "entries-complaints-locked";
const char* CModStats::ENT_COM_REF_LOC = "entries-complaints-referrals-locked";
const char* CModStats::ENT_COM_REF_QUE = "entries-complaints-referrals-queued";
//nicknames
const char* CModStats::NIC_QUE = "nicknames-queued";
const char* CModStats::NIC_LOC = "nicknames-locked";
//general complaints
const char* CModStats::GEN_COM_LOC = "general-complaints-locked";
const char* CModStats::GEN_COM_QUE = "general-complaints-queued";
const char* CModStats::GEN_COM_REF_QUE = "general-complaints-referrals-queued";
const char* CModStats::GEN_COM_REF_LOC = "general-complaints-referrals-locked";
//image
const char* CModStats::EXLINKS_QUE = "exlinks-queued";
const char* CModStats::EXLINKS_LOC = "exlinks-locked";
const char* CModStats::EXLINKS_REF_QUE = "exlinks-referrals-queued";
const char* CModStats::EXLINKS_REF_LOC = "exlinks-referrals-locked";
//image complaint
const char* CModStats::EXLINKS_COM_QUE = "exlinks-complaints-queued";
const char* CModStats::EXLINKS_COM_LOC = "exlinks-complaints-locked";
const char* CModStats::EXLINKS_COM_REF_QUE = "exlinks-complaints-referrals-queued";
const char* CModStats::EXLINKS_COM_REF_LOC = "exlinks-complaints-referrals-locked";

CModStats::CModStats(CInputContext& inputContext)
	:
	m_InputContext(inputContext),
	m_bFastMod(false)
{
	m_InputContext.InitialiseStoredProcedureObject(m_Sp);
}

CModStats::~CModStats(void)
{
}

/***************************************************
bool CModStats::FetchOld(int iUserId, bool bFastMod)
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	fetches moderation statistics for given user(moderator) and given
			mode (fastmod or normal)
***************************************************/

bool CModStats::FetchOld(int iUserId, bool bFastMod)
{
	m_StatsOld.clear();

	const char* pSpName = (bFastMod == true ? "fetchmoderationstatisticsfastmod" :
		"fetchmoderationstatisticsold");
	m_Sp.StartStoredProcedure(pSpName);
	m_Sp.AddParam("userid", iUserId);
	m_Sp.ExecuteStoredProcedure();
	if (m_Sp.HandleError(pSpName))
	{
		return false;
	}

	while (m_Sp.IsEOF() == false)
	{
		CTDVString sName;
		m_Sp.GetField("type", sName);
		int iCount = m_Sp.GetIntField("total");
		m_StatsOld.insert(CStatsOld::value_type(sName, iCount));

		m_Sp.MoveNext();
	}

	m_bFastMod = bFastMod;
	return true;
}

/***************************************************
bool CModStats::Fetch(int iUserId)
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	fetches moderation statistics for given user(moderator)
***************************************************/

bool CModStats::Fetch(int iUserId)
{
	m_Stats.clear();

	m_Sp.StartStoredProcedure("fetchmoderationstatistics");
	m_Sp.AddParam("userid", iUserId);
	m_Sp.ExecuteStoredProcedure();
	if (m_Sp.HandleError("fetchmoderationstatistics"))
	{
		return false;
	}

    CreateEmptyQueues(iUserId);
	
	//replace empty items with actual queue data
	while (m_Sp.IsEOF() == false)
	{
		CTDVString sState;
		m_Sp.GetField("state", sState);
		CTDVString sObjectType;
		m_Sp.GetField("type", sObjectType);
        int iCount = m_Sp.GetIntField("total");
		int iTimeLeft = m_Sp.GetIntField("timeleft");
		int iModClassId = m_Sp.GetIntField("modclassid");
		bool bFastMod = m_Sp.GetIntField("fastmod") != 0;
		CTDVDateTime minDateQueued = m_Sp.GetDateField("mindatequeued");
		CModQueueStat modQueueStat(sState, sObjectType, minDateQueued, bFastMod,
			iModClassId, iTimeLeft, iCount);
		
		std::replace(m_Stats.begin(), m_Stats.end(), modQueueStat, modQueueStat);
		
		m_Sp.MoveNext();
	}

	return true;
}



/***************************************************
void CModStats::GetAsXmlOld(CTDVString& sXml)
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	Appends (!!!) stats xml (<MODERATION> and <REFERRALS> elements)
			to given string.
***************************************************/

void CModStats::GetAsXmlOld(CTDVString& sXml)
{
	sXml << "<MODERATION FASTMOD='" << (m_bFastMod == true ? 1 : 0) << "'>" \

		// forums m_StatsOld
		"<FORUMS>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[FOR_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[FOR_QUE] << "</QUEUED>" \
			"</NEW>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[FOR_COM_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[FOR_COM_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</FORUMS>";

	if (m_bFastMod == false)
	{
		// article m_StatsOld
		sXml << 
		"<ARTICLES>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[ENT_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[ENT_QUE] << "</QUEUED>" \
			"</NEW>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[ENT_COM_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[ENT_COM_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</ARTICLES>" \
		// nickname m_StatsOld
		"<NICKNAMES>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[NIC_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[NIC_QUE] << "</QUEUED>" \
			"</NEW>" \
		"</NICKNAMES>" \
		// general page m_StatsOld
		"<GENERAL>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[GEN_COM_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[GEN_COM_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</GENERAL>" \
		// images
		"<IMAGES>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[EXLINKS_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[EXLINKS_QUE] << "</QUEUED>" \
			"</NEW>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[EXLINKS_COM_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[EXLINKS_COM_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</IMAGES>";
	}

	sXml << "</MODERATION>" \

	// then referred moderations
	"<REFERRALS FASTMOD='" << (m_bFastMod == true ? 1 : 0) << "'>" \

		// forums m_StatsOld
		"<FORUMS>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[FOR_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[FOR_REF_QUE] << "</QUEUED>" \
			"</NEW>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[FOR_COM_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[FOR_COM_REF_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</FORUMS>";

	if (m_bFastMod == false)
	{
		// article m_StatsOld
		sXml << 
		"<ARTICLES>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[ENT_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[ENT_REF_QUE] << "</QUEUED>" \
			"</NEW>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[ENT_COM_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[ENT_COM_REF_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</ARTICLES>" \

		// general page m_StatsOld
		"<GENERAL>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[GEN_COM_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[GEN_COM_REF_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</GENERAL>" \

		// images
		"<IMAGES>" \
			"<NEW>" \
				"<LOCKED>" << m_StatsOld[EXLINKS_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[EXLINKS_REF_QUE] << "</QUEUED>" \
			"</NEW>" \
			"<COMPLAINTS>" \
				"<LOCKED>" << m_StatsOld[EXLINKS_COM_REF_LOC] << "</LOCKED>" \
				"<QUEUED>" << m_StatsOld[EXLINKS_COM_REF_QUE] << "</QUEUED>" \
			"</COMPLAINTS>" \
		"</IMAGES>";
	}

	sXml << "</REFERRALS>";
}



/***************************************************
void CModStats::GetAsXml(CTDVString& sXml)
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	Appends (!!!) stats xml (<MODERATION> and <REFERRALS> elements)
			to given string.
***************************************************/

void CModStats::GetAsXml(CTDVString& sXml)
{
	sXml << "<MODERATION-QUEUES>";
	for (CStats::const_iterator it = m_Stats.begin(); it != m_Stats.end(); it++)
	{
		const CModQueueStat& stat = *it;
		CTDVString sDate;
		stat.GetMinDateQueued().GetAsXML(sDate);
		sXml << "<MODERATION-QUEUE-SUMMARY FASTMOD='" << stat.GetIsFastMod() << "' " \
			"CLASSID='" << stat.GetModClassId() << "' TIMELEFT='" << stat.GetTimeLeft() << "' " \
			"TOTAL='" << stat.GetTotal() << "'>" \
			"<OBJECT-TYPE>" << stat.GetObjectType() << "</OBJECT-TYPE>" \
			"<STATE>" << stat.GetState() << "</STATE>" 
			<< sDate 
			<< "</MODERATION-QUEUE-SUMMARY>";
			
	}
	sXml << "</MODERATION-QUEUES>";
}

void CModStats::CreateEmptyQueues(int iUserId)
{
	CModeratorInfo moderatorInfo(m_InputContext);
	std::vector<int> moderatorClasses;
	moderatorInfo.GetModeratorInfo(iUserId);
	moderatorInfo.GetModeratorClasses(moderatorClasses);

	CUser* pViewer = m_InputContext.GetCurrentUser();
	bool bReferrals = pViewer->GetIsSuperuser();
	if ( !bReferrals )
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		SP.IsRefereeForAnySite(pViewer->GetUserID(), bReferrals);
	}

	bool bFastMod = m_InputContext.GetParamInt("fastmod") != 0;

	for( unsigned int i = 0; i < moderatorClasses.size(); i++)
	{
		int iModClassID = moderatorClasses[i];

		//forum posts and complaints
		m_Stats.push_back(CModQueueStat("queued","forum",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","forum",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("queued","forumcomplaint",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","forumcomplaint",bFastMod,iModClassID));

		if ( bReferrals )
		{
			//referred forum posts and complaints
			m_Stats.push_back(CModQueueStat("queuedreffered","forum",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("lockedreffered","forum",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("queuedreffered","forumcomplaint",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("lockedreffered","forumcomplaint",bFastMod,iModClassID));
		}

		//entries and complaints
		m_Stats.push_back(CModQueueStat("queued","entry",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","entry",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("queued","entrycomplaint",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","entrycomplaint",bFastMod,iModClassID));

		if ( bReferrals )
		{
			//referred entries and complaints
			m_Stats.push_back(CModQueueStat("queuedreffered","entry",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("lockedreffered","entry",bFastMod,iModClassID));		
			m_Stats.push_back(CModQueueStat("queuedreffered","entrycomplaint",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("lockedreffered","entrycomplaint",bFastMod,iModClassID));
		}

		//nickname queues
		m_Stats.push_back(CModQueueStat("queued","nickname",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","nickname",bFastMod,iModClassID));

		//general complaints
		m_Stats.push_back(CModQueueStat("queued","generalcomplaint",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","generalcomplaint",bFastMod,iModClassID));

		//referred general complaints
		m_Stats.push_back(CModQueueStat("queuedreffered","generalcomplaint",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("lockedreffered","generalcomplaint",bFastMod,iModClassID));


        //exlinks and complaints
		m_Stats.push_back(CModQueueStat("queued","exlink",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","exlink",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("queued","exlinkcomplaint",bFastMod,iModClassID));
		m_Stats.push_back(CModQueueStat("locked","exlinkcomplaint",bFastMod,iModClassID));

		if ( bReferrals )
		{
			//referred forum posts and complaints
			m_Stats.push_back(CModQueueStat("queuedreffered","exlink",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("lockedreffered","exlink",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("queuedreffered","exlinkcomplaint",bFastMod,iModClassID));
			m_Stats.push_back(CModQueueStat("lockedreffered","exlinkcomplaint",bFastMod,iModClassID));
		}
	}
}
