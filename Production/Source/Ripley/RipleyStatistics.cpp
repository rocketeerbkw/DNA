#include "stdafx.h"
#include ".\ripleystatistics.h"

#include "xmlbuilder.h"

//Initialise a vector with minutes in a day - data runs from midnight - midnight.
CRipleyStatistics::CRipleyStatistics( ) : m_StatData(24*60)
{
	InitializeCriticalSection(&m_criticalsection);
	m_dDateStarted = m_dDateStarted.GetCurrentTime();
}

CRipleyStatistics::~CRipleyStatistics(void)
{
	DeleteCriticalSection(&m_criticalsection);
}

/*********************************************************************************

	bool CRipleyStatistics::AddCacheHit()
		Author:		Martin Robb
        Created:	24/01/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments CacheHit Counter - counts number of times XML created from cache.

*********************************************************************************/
void CRipleyStatistics::AddCacheHit( void )
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddCacheHit();
}

/*********************************************************************************

	bool CRipleyStatistics::AddCacheMiss()
		Author:		Martin Robb
        Created:	24/01/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments CacheMiss Counter - counts number of times XML not created from cache successfully.

*********************************************************************************/
void CRipleyStatistics::AddCacheMiss(void)
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddCacheMiss();
}
/*********************************************************************************

	bool CRipleyStatistics::AddRssCacheHit()
		Author:		James Conway
        Created:	13/03/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments RssCacheHit Counter - counts number of times the output is taken from cache.

*********************************************************************************/
void CRipleyStatistics::AddRssCacheHit( void )
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddRssCacheHit();
}
/*********************************************************************************

	bool CRipleyStatistics::AddRssCacheMiss()
		Author:		James Conway
        Created:	13/03/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments RssCacheMiss Counter - counts number of times the output is taken from cache.

*********************************************************************************/
void CRipleyStatistics::AddRssCacheMiss(void)
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddRssCacheMiss();
}
/*********************************************************************************

	bool CRipleyStatistics::AddSsiCacheHit()
		Author:		James Conway
        Created:	13/03/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments SsiCacheHit Counter - counts number of times the output is taken from cache.

*********************************************************************************/
void CRipleyStatistics::AddSsiCacheHit( void )
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddSsiCacheHit();
}
/*********************************************************************************

	bool CRipleyStatistics::AddSsiCacheMiss()
		Author:		James Conway
        Created:	13/03/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments SsiCacheMiss Counter - counts number of times the output is taken from cache.

*********************************************************************************/
void CRipleyStatistics::AddSsiCacheMiss(void)
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddSsiCacheMiss();
}

/*********************************************************************************

	void CRipleyStatistics::AddHTMLCacheHit(void)

		Author:		Mark Neves
        Created:	11/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Increments every time a HTML cache file is served

*********************************************************************************/

void CRipleyStatistics::AddHTMLCacheHit(void)
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddHTMLCacheHit();
}

/*********************************************************************************

	void CRipleyStatistics::AddHTMLCacheMiss(void)

		Author:		Mark Neves
        Created:	11/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Increments every time a HTML file is either missing or has expired

*********************************************************************************/

void CRipleyStatistics::AddHTMLCacheMiss(void)
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddHTMLCacheMiss();
}

/*********************************************************************************

	bool CRipleyStatistics::AddServerBusy()
		Author:		Martin Robb
        Created:	20/01/2006
        Inputs:		None.
        Outputs:	-
        Returns:	None
        Purpose:	Increments Server Busy Count - Incremented everytiem a server busy message is returned.

*********************************************************************************/
void CRipleyStatistics::AddServerBusy(void)
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddServerBusy();
}

/*********************************************************************************

	void CRipleyStatistics::AddRawRequest()

		Author:		Mark Neves
        Created:	12/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	This counts the raw requests that come in, at the very top (i.e. before being processed in any way)
					The request could later hit the HTML cache, be a "Server too busy", a normal request, etc.

*********************************************************************************/

void CRipleyStatistics::AddRawRequest()
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddRawRequest();
}

/*********************************************************************************

	void CRipleyStatistics::AddNonSSORequest()

		Author:		Mark Neves
        Created:	11/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Increments for every request that does not contain an SSO cookie

*********************************************************************************/

void CRipleyStatistics::AddLoggedOutRequest()
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddLoggedOutRequest();
}


/*********************************************************************************

	bool CRipleyStatistics::AddRequestDuration( ttaken )
		Author:		Martin Robb
        Created:	20/01/2006
        Inputs:		Time taken for current request.
        Outputs:	-
        Returns:	None
        Purpose:	Records request duration in order to calculate average request time.

*********************************************************************************/
void CRipleyStatistics::AddRequestDuration( long ttaken )
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddRequestDuration(ttaken);
}

void CRipleyStatistics::AddIdentityCallDuration( long ttaken )
{
	int minutes = CalcMinutes();
	m_StatData[minutes].AddIdentityCallDuration(ttaken);
}

/*********************************************************************************

	bool CRipleyStatistics::GetStatisticsXML()
		Author:		Martin Robb
        Created:	20/01/2006
        Inputs:		Time taken for current request.
        Outputs:	-
        Returns:	XML
        Purpose:	Produces XML with performance stats.

*********************************************************************************/
CTDVString CRipleyStatistics::GetStatisticsXML( int interval  )
{
	//Default is data at 1 minute intervals from midnight.
	if ( interval < 1 || interval > 24*60 )
		interval = 1;

	CDBXMLBuilder	xmlbuilder;
	CTDVString		sXML;
	xmlbuilder.Initialise(&sXML);
	xmlbuilder.OpenTag("STATISTICS");
	xmlbuilder.AddDateTag("STARTDATE",m_dDateStarted);
	xmlbuilder.AddDateTag("CURRENTDATE",CTDVDateTime(COleDateTime::GetCurrentTime()));

	long	rawrequests = 0;
	long	serverbusy = 0;
	long	nonssorequests = 0;
	long	cachehits = 0;
	long	cachemisses = 0;
	long	rsscachehits = 0;
	long	rsscachemisses = 0;
	long	ssicachehits = 0;
	long	ssicachemisses = 0;
	long	htmlcachehits = 0;
	long	htmlcachemisses = 0;
	long	requests = 0;
	long	requesttime = 0;
	long	identitytime = 0;
	long	identitycallcount = 0;

	CTimeSpan	timespan;
	int minutes = 0;
	for ( std::vector<STAT_DATA>::iterator iter = m_StatData.begin(); iter != m_StatData.end(); ++iter )
	{
		if ( rawrequests < LONG_MAX - iter->GetRawRequestCounter() )
			rawrequests += iter->GetRawRequestCounter();
		else
			rawrequests = LONG_MAX;

		if ( serverbusy < LONG_MAX - iter->GetServerBusyCounter() )
			serverbusy += iter->GetServerBusyCounter();
		else
			serverbusy = LONG_MAX;

		if ( nonssorequests < LONG_MAX - iter->GetLoggedOutRequests() )
			nonssorequests += iter->GetLoggedOutRequests();
		else
			nonssorequests = LONG_MAX;
		
		if ( cachehits < LONG_MAX - iter->GetCacheHitCounter() )
			cachehits += iter->GetCacheHitCounter();
		else
			cachehits = LONG_MAX;
		
		if ( cachemisses < LONG_MAX - iter->GetCacheMissCounter() )
			cachemisses += iter->GetCacheMissCounter();
		else
			cachemisses = LONG_MAX;

		if ( rsscachehits < LONG_MAX - iter->GetRssCacheHitCounter() )
			rsscachehits += iter->GetRssCacheHitCounter();
		else
			rsscachehits = LONG_MAX;
		
		if ( rsscachemisses < LONG_MAX - iter->GetRssCacheMissCounter() )
			rsscachemisses += iter->GetRssCacheMissCounter();
		else
			rsscachemisses = LONG_MAX;

		if ( ssicachehits < LONG_MAX - iter->GetSsiCacheHitCounter() )
			ssicachehits += iter->GetSsiCacheHitCounter();
		else
			ssicachehits = LONG_MAX;
		
		if ( ssicachemisses < LONG_MAX - iter->GetSsiCacheMissCounter() )
			ssicachemisses += iter->GetSsiCacheMissCounter();
		else
			ssicachemisses = LONG_MAX;


		if ( htmlcachehits < LONG_MAX - iter->GetHTMLCacheHitCounter() )
			htmlcachehits += iter->GetHTMLCacheHitCounter();
		else
			htmlcachehits = LONG_MAX;
		
		if ( htmlcachemisses < LONG_MAX - iter->GetHTMLCacheMissCounter() )
			htmlcachemisses += iter->GetHTMLCacheMissCounter();
		else
			htmlcachemisses = LONG_MAX;


		if ( requests < LONG_MAX - iter->GetRequests() )
			requests += iter->GetRequests();
		else
			requests = LONG_MAX;
		
		if ( requesttime < LONG_MAX - iter->GetRequestTime() )
			requesttime += iter->GetRequestTime();
		else
			requesttime = LONG_MAX;

		if ( identitytime < LONG_MAX - iter->GetIdentityCallTime() )
			identitytime += iter->GetIdentityCallTime();
		else
			identitytime = LONG_MAX;

		if ( identitycallcount < LONG_MAX - iter->GetIdentityCallCount() )
			identitycallcount += iter->GetIdentityCallCount();
		else
			identitycallcount = LONG_MAX;

		++minutes;
		if ( minutes%interval == 0 )
		{	
			xmlbuilder.OpenTag("STATISTICSDATA",true);
			
			//Guard against an integer overflow.
			xmlbuilder.AddAttribute("INTERVALSTARTTIME", timespan.Format("%H:%M"), true);
			xmlbuilder.AddIntTag("RAWREQUESTS", rawrequests < INT_MAX ? rawrequests : INT_MAX );
			xmlbuilder.AddIntTag("SERVERBUSYCOUNT", serverbusy < INT_MAX ? serverbusy : INT_MAX );
			xmlbuilder.AddIntTag("CACHEHITS", cachehits < INT_MAX ? cachehits : INT_MAX );
			xmlbuilder.AddIntTag("CACHEMISSES",cachemisses < INT_MAX ? cachemisses : INT_MAX );
			xmlbuilder.AddIntTag("RSSCACHEHITS", rsscachehits < INT_MAX ? rsscachehits : INT_MAX );
			xmlbuilder.AddIntTag("RSSCACHEMISSES", rsscachemisses < INT_MAX ? rsscachemisses : INT_MAX );
			xmlbuilder.AddIntTag("SSICACHEHITS", ssicachehits < INT_MAX ? ssicachehits : INT_MAX );
			xmlbuilder.AddIntTag("SSICACHEMISSES", ssicachemisses < INT_MAX ? ssicachemisses : INT_MAX );
			xmlbuilder.AddIntTag("NONSSOREQUESTS", nonssorequests < INT_MAX ? nonssorequests : INT_MAX );
			xmlbuilder.AddIntTag("HTMLCACHEHITS", htmlcachehits < INT_MAX ? htmlcachehits : INT_MAX );
			xmlbuilder.AddIntTag("HTMLCACHEMISSES", htmlcachemisses < INT_MAX ? htmlcachemisses : INT_MAX );
			
			if ( requesttime < LONG_MAX && requests < LONG_MAX )
				xmlbuilder.AddIntTag("AVERAGEREQUESTTIME", requesttime/(requests > 0 ? requests : 1) ); // Nearest millisecond.

			if ( identitytime < LONG_MAX && requests < LONG_MAX )
				xmlbuilder.AddIntTag("AVERAGEIDENTITYTIME", identitytime/(identitycallcount > 0 ? identitycallcount : 1) ); // Nearest millisecond.

			xmlbuilder.AddIntTag("IDENTITYREQUESTS", identitycallcount < INT_MAX ? identitycallcount : INT_MAX );
			
			xmlbuilder.AddIntTag("REQUESTS", requests < INT_MAX ? requests : INT_MAX );
			xmlbuilder.CloseTag("STATISTICSDATA");

			//Reset.
			rawrequests = 0;
			serverbusy = 0;
			nonssorequests = 0;
			cachehits = 0;
			cachemisses = 0;
			rsscachehits = 0;
			rsscachemisses = 0;
			ssicachehits = 0;
			ssicachemisses = 0;
			htmlcachehits = 0;
			htmlcachemisses = 0;
			requests = 0;
			requesttime = 0;
			identitytime= 0;
			identitycallcount = 0;
			timespan += CTimeSpan(0,0,interval,0);
		}
	}
	xmlbuilder.CloseTag("STATISTICS");

	return sXML;
}

/*********************************************************************************

	bool CRipleyStatistics::ResetCounters()
		Author:		Martin Robb
        Created:	25/01/2006
        Inputs:		None
        Outputs:	-
        Returns:	true on success
        Purpose:	Resets the collected data.

*********************************************************************************/
void CRipleyStatistics::ResetCounters()
{
	EnterCriticalSection(&m_criticalsection);
	m_dDateStarted = COleDateTime::GetCurrentTime();
	m_StatData = std::vector<STAT_DATA>(24*60);
	LeaveCriticalSection(&m_criticalsection);
}


/************************ Stat Data Methods ***************************************/
void CRipleyStatistics::STAT_DATA::AddCacheHit()
{
	InterlockedIncrement(&m_CacheHitCounter);
}

void CRipleyStatistics::STAT_DATA::AddCacheMiss()
{
	InterlockedIncrement(&m_CacheMissCounter);
}
void CRipleyStatistics::STAT_DATA::AddRssCacheHit()
{
	InterlockedIncrement(&m_RssCacheHitCounter);
}
void CRipleyStatistics::STAT_DATA::AddRssCacheMiss()
{
	InterlockedIncrement(&m_RssCacheMissCounter);
}
void CRipleyStatistics::STAT_DATA::AddSsiCacheHit()
{
	InterlockedIncrement(&m_SsiCacheHitCounter);
}
void CRipleyStatistics::STAT_DATA::AddSsiCacheMiss()
{
	InterlockedIncrement(&m_SsiCacheMissCounter);
}
void CRipleyStatistics::STAT_DATA::AddServerBusy()
{
	InterlockedIncrement(&m_ServerBusyCounter);
}
void CRipleyStatistics::STAT_DATA::AddRawRequest()
{
	InterlockedIncrement(&m_RawRequestCounter);
}
void CRipleyStatistics::STAT_DATA::AddLoggedOutRequest()
{
	InterlockedIncrement(&m_LoggedOutRequests);
}
void CRipleyStatistics::STAT_DATA::AddHTMLCacheHit()
{
	InterlockedIncrement(&m_HTMLCacheHitCounter);
}
void CRipleyStatistics::STAT_DATA::AddHTMLCacheMiss()
{
	InterlockedIncrement(&m_HTMLCacheMissCounter);
}
void CRipleyStatistics::STAT_DATA::AddRequestDuration( int ttaken )
{
	InterlockedIncrement(&m_Requests);
	InterlockedExchangeAdd(&m_TotalRequestTime,ttaken);
}
void CRipleyStatistics::STAT_DATA::AddIdentityCallDuration( int ttaken )
{
	InterlockedIncrement(&m_IdentityCallCount);
	InterlockedExchangeAdd(&m_IdentityCallTime,ttaken);
}

/*********************************************************************************

	int CRipleyStatistics::CalcMinutes()

		Author:		Mark Neves
        Created:	11/05/2006
        Inputs:		-
        Outputs:	-
        Returns:	The current "minutes" slot
        Purpose:	Centralised this calculation code

*********************************************************************************/

int CRipleyStatistics::CalcMinutes()
{
	//Data runs from midnight - midnight - get minutes into day.
	CTDVDateTime timestamp = COleDateTime::GetCurrentTime();
	return timestamp.GetMinute() + timestamp.GetHour()*60;
}
