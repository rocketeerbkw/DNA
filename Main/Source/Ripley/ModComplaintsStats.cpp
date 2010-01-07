#include "stdafx.h"
#include ".\modcomplaintsstats.h"

const char* CModComplaintsStats::FORUMS = "forums";
const char* CModComplaintsStats::FORUMS_FASTMOD = "referrals-fastmod";
const char* CModComplaintsStats::ENTRIES = "entries";
const char* CModComplaintsStats::GENERAL = "general";

CModComplaintsStats::CModComplaintsStats(CInputContext& inputContext)
	:
	m_InputContext(inputContext)
{
	m_InputContext.InitialiseStoredProcedureObject(m_Sp);
}

CModComplaintsStats::~CModComplaintsStats()
{
}

/*
bool CModComplaintsStats::Fetch(int iUserId)
Author:		Igor Loboda
Created:	20/07/2005
Purpose:	Retrieves alerts stats from the database and
			stores them internally as a map mapping name of a stats type
			into amount of alerts of that type. It could be accessed
			via Stats() method
*/

bool CModComplaintsStats::Fetch(int iUserId)
{
	m_Stats.clear();

	m_Sp.StartStoredProcedure("fetchmodcomplaintsstats");
	m_Sp.AddParam("userid", iUserId);
	m_Sp.ExecuteStoredProcedure();
	if (m_Sp.HandleError("fetchmodcomplaintsstats"))
	{
		return false;
	}

	while (m_Sp.IsEOF() == false)
	{
		CTDVString sName;
		m_Sp.GetField("name", sName);
		int iCount = m_Sp.GetIntField("count");
		m_Stats.insert(CStats::value_type(sName, iCount));

		m_Sp.MoveNext();
	}

	return true;
}