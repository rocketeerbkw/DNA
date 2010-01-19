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

#include "inputcontext.h"
#include "storedprocedurebase.h"
#include "modqueuestat.h"

/***************************************************
class CModStats
Author:	Igor Loboda
Created:	29/07/2005
Purpose:	fetches moderation statistics for given user(moderator) and given
			mode (fastmod or normal)
Usage:		create an instance, call Fetch, call GetAsXml or alternatively
			get stats map by calling Stats and iterate throug it yourself.
			String literals provided by the class like FOR_LOC can be used
			as keys for the stats map. FOR means forums, QUE - queued, LOC - locked
			COM - complaint, ENT - entry, NIC - nickname, GEN_COM - general
			complaint, REF - reffered, IMG - image.
***************************************************/

class CModStats
{
	public:
		typedef map<CTDVString, int> CStatsOld;
		typedef vector<CModQueueStat> CStats;

		//forum
		static const char* FOR_QUE_NOTFASTMOD;
		static const char* FOR_QUE_FASTMOD;
		static const char* FOR_LOC;
		static const char* FOR_REF_QUE;
		static const char* FOR_REF_LOC;
		static const char* FOR_QUE;

		//forum complaints
		static const char* FOR_COM_QUE;
		static const char* FOR_COM_LOC;
		static const char* FOR_COM_REF_QUE;
		static const char* FOR_COM_REF_LOC;

		//entries
		static const char* ENT_QUE;
		static const char* ENT_LOC;
		static const char* ENT_REF_QUE;
		static const char* ENT_REF_LOC;

		//entries complaints
		static const char* ENT_COM_QUE;
		static const char* ENT_COM_LOC;
		static const char* ENT_COM_REF_QUE;
		static const char* ENT_COM_REF_LOC;

		//nicknames
		static const char* NIC_QUE;
		static const char* NIC_LOC;

		//general complaints
		static const char* GEN_COM_LOC;
		static const char* GEN_COM_QUE;
		static const char* GEN_COM_REF_QUE;
		static const char* GEN_COM_REF_LOC;

		//image
		static const char* EXLINKS_QUE;
		static const char* EXLINKS_LOC;
		static const char* EXLINKS_REF_QUE;
		static const char* EXLINKS_REF_LOC;

		//External link or image complaint
		static const char* EXLINKS_COM_QUE;
		static const char* EXLINKS_COM_LOC;
		static const char* EXLINKS_COM_REF_QUE;
		static const char* EXLINKS_COM_REF_LOC;

	public:
		CModStats(CInputContext& inputContext);
		virtual ~CModStats(void);
		bool Fetch(int iUserId);
		bool FetchOld(int iUserId, bool bFastMod);
		const CStats& Stats() const { return m_Stats; }
		const CStatsOld& StatsOld() const { return m_StatsOld; }
		bool IsFastMod() const { return m_bFastMod; }
		void GetAsXml(CTDVString& sXml);
		void GetAsXmlOld(CTDVString& sXml);

	protected:
		CInputContext& m_InputContext;
		CStoredProcedureBase m_Sp;
		CStatsOld m_StatsOld;
		CStats m_Stats;
		bool m_bFastMod;

	private:
		void CreateEmptyQueues(int iUserId);
};
