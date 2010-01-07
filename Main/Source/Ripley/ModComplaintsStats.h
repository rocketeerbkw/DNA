#pragma once
#include "storedprocedurebase.h"
#include "inputcontext.h"

class CModComplaintsStats
{	
	public:
		typedef map<CTDVString, int> CStats;
		static const char* FORUMS;
		static const char* FORUMS_FASTMOD;
		static const char* ENTRIES;
		static const char* GENERAL;

	public:
		CModComplaintsStats(CInputContext& inputContext);
		virtual ~CModComplaintsStats();

		bool Fetch(int iUserId);
		const CStats& Stats() const { return m_Stats; }
		
	protected:
		CStats m_Stats;
		CStoredProcedureBase m_Sp;
		CInputContext m_InputContext;
};
