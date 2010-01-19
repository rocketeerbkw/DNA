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
#include ".\modqueuestat.h"

CModQueueStat::CModQueueStat(const char* pState, const char* pObjectType,
	const CTDVDateTime& minDateQueued, bool bFastMod,
	int iModClassId, int iTimeLeft, int iTotal)
	:
	m_sState(pState), m_sObjectType(pObjectType), m_MinDateQueued(minDateQueued),
	m_bFastMod(bFastMod), m_iModClassId(iModClassId), m_iTimeLeft(iTimeLeft),
	m_iTotal(iTotal)
{
}

CModQueueStat::~CModQueueStat(void)
{
}

//create an empty/default state for a queue stat object
CModQueueStat::CModQueueStat(const char* pState, const char* pObjectType, bool bFastMod, int iModClassID) :
	m_sState(pState), m_sObjectType(pObjectType), m_bFastMod(bFastMod), m_iModClassId(iModClassID),
		m_iTimeLeft(0), m_MinDateQueued(0), m_iTotal(0)
{
}

//equality operator - for use in stl containers
//queue stats considered equal when state, type, fastmod status and class are the same
bool CModQueueStat::operator==(const CModQueueStat& rhs)
{
	bool bEqual = (m_sState==rhs.GetState()) && 
			(m_sObjectType == rhs.GetObjectType()) && 
			(m_bFastMod == rhs.GetIsFastMod()) &&
			(m_iModClassId == rhs.GetModClassId());
	return bEqual;
}
