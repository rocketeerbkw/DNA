/******************************************************************************
class:	CRipleyStatistics

Provides Basic Statistics.

Example Usage:
	Call GetStatisticsXML() to retrieve current statistics regarding ripley/dna performance for a particular server.

Implementation details:
	Records pertinent details.
	Thread Safe.
******************************************************************************/

#pragma once

#include "TDVString.h"
#include "TDVDateTime.h"

#include <limits.h>

#include <map>
#include <vector>

class CRipleyStatistics 
{
public:
	CRipleyStatistics( );
	~CRipleyStatistics(void);

	void AddRawRequest();
	void AddServerBusy(void);
	void AddRequestDuration( long ttaken );
	void AddIdentityCallDuration( long ttaken );
	void AddLoggedOutRequest();
	void AddCacheHit(void);
	void AddCacheMiss(void);
	void AddRssCacheHit(void);
	void AddRssCacheMiss(void);
	void AddSsiCacheHit(void);
	void AddSsiCacheMiss(void);
	void AddHTMLCacheHit();
	void AddHTMLCacheMiss();

	void ResetCounters(void);

	CTDVString GetStatisticsXML( int interval = 60 );
private:
	int CalcMinutes();

	CTDVDateTime	m_dDateStarted;

	struct STAT_DATA
	{

		STAT_DATA() :	m_RawRequestCounter(0),
						m_ServerBusyCounter(0), 
						m_TotalRequestTime(0),
						m_Requests(0),
						m_LoggedOutRequests(0),
						m_CacheHitCounter(0),
						m_CacheMissCounter(0),
						m_RssCacheHitCounter(0),
						m_RssCacheMissCounter(0),
						m_SsiCacheHitCounter(0),
						m_SsiCacheMissCounter(0),
						m_HTMLCacheHitCounter(0),
						m_HTMLCacheMissCounter(0),
						m_IdentityCallTime(0),
						m_IdentityCallCount(0)
						{}
		
		void AddRawRequest();
		void AddServerBusy();
		void AddLoggedOutRequest();
		void AddCacheHit();
		void AddCacheMiss();
		void AddRssCacheHit();
		void AddRssCacheMiss();
		void AddSsiCacheHit();
		void AddSsiCacheMiss();
		void AddHTMLCacheHit();
		void AddHTMLCacheMiss();
		void AddRequestDuration( int ttaken);
		void AddIdentityCallDuration( int ttaken);

		long GetRawRequestCounter()		{ return m_RawRequestCounter; }
		long GetServerBusyCounter()		{ return m_ServerBusyCounter; }
		long GetLoggedOutRequests()		{ return m_LoggedOutRequests; }
		long GetCacheMissCounter()		{ return m_CacheMissCounter; }
		long GetCacheHitCounter()		{ return m_CacheHitCounter; }
		long GetRssCacheMissCounter()	{ return m_RssCacheMissCounter; }
		long GetRssCacheHitCounter()	{ return m_RssCacheHitCounter; }
		long GetSsiCacheMissCounter()	{ return m_SsiCacheMissCounter; }
		long GetSsiCacheHitCounter()	{ return m_SsiCacheHitCounter; }
		long GetHTMLCacheHitCounter()	{ return m_HTMLCacheHitCounter; }
		long GetHTMLCacheMissCounter()	{ return m_HTMLCacheMissCounter; }
		long GetRequests()				{ return m_Requests; }
		long GetRequestTime()			{ return m_TotalRequestTime; }
		long GetIdentityCallTime()		{ return m_IdentityCallTime; }
		long GetIdentityCallCount()		{ return m_IdentityCallCount; }

	private:

		//Share this counter with all instances.
		long	m_RawRequestCounter;
		long	m_ServerBusyCounter;
		long	m_TotalRequestTime;
		long	m_Requests;
		long	m_LoggedOutRequests;

		long	m_CacheHitCounter;
		long	m_CacheMissCounter;

		long	m_RssCacheHitCounter;
		long	m_RssCacheMissCounter;

		long	m_SsiCacheHitCounter;
		long	m_SsiCacheMissCounter;

		long	m_HTMLCacheHitCounter;
		long	m_HTMLCacheMissCounter;

		long	m_IdentityCallTime;
		long	m_IdentityCallCount;
	};

	std::vector<STAT_DATA>	m_StatData;

	CRITICAL_SECTION m_criticalsection;
};
