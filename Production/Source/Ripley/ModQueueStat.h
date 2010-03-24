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

#pragma once

#include "TDVString.h"
#include "TDVDateTime.h"

class CModQueueStat
{
	public:
		CModQueueStat(const char* pState, const char* pObjectType,
			const CTDVDateTime& queueStart, bool bFastMod,
			int iModClassId, int iTimeLeft, int iTotal);
		virtual ~CModQueueStat();

		//default empty queue stat
		CModQueueStat(const char* pState, const char* pObjectType, bool bFastMod,
			int iModClassID);

		bool operator==(const CModQueueStat& rhs);

		const char* GetState() const { return m_sState; }
		const char* GetObjectType() const { return m_sObjectType; }
		const CTDVDateTime& GetMinDateQueued() const { return m_MinDateQueued; }
		bool GetIsFastMod() const { return m_bFastMod; }
		int GetModClassId() const { return m_iModClassId; }
		int GetTimeLeft() const { return m_iTimeLeft; }
		int GetTotal() const { return m_iTotal; }

	protected:
		CTDVString m_sState;
		CTDVString m_sObjectType;
		CTDVDateTime m_MinDateQueued;
		bool m_bFastMod;
		int m_iModClassId;
		int m_iTimeLeft;
		int m_iTotal;
};

