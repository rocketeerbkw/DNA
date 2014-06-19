using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Xml;
using BBC.Dna.Utils;
using System.Linq;

namespace BBC.Dna.Utils
{
	/// <summary>
	/// A class to track some usage statistics on a per-minute basis
	/// </summary>
	public class Statistics
	{
		public class StatData
		{
			/// <summary>
			/// ctor
			/// </summary>
			public StatData()
			{
                ResetStatDataVale();
			}

            public void ResetStatDataVale()
            {
                m_RawRequestCounter = 0;
                m_ServerBusyCounter = 0;
                m_TotalRequestTime = 0;
                m_Requests = 0;
                m_NonSSORequests = 0;
                m_CacheHitCounter = 0;
                m_CacheMissCounter = 0;
                m_RssCacheHitCounter = 0;
                m_RssCacheMissCounter = 0;
                m_SsiCacheHitCounter = 0;
                m_SsiCacheMissCounter = 0;
                m_HTMLCacheHitCounter = 0;
                m_HTMLCacheMissCounter = 0;
                m_IdentityUserCall = 0;
                m_IdentityCallCount = 0;
                m_ForbiddenResponseCount = 0;
                Date = DateToTheMinute();
            }

			public void AddCacheHit()
			{
				Interlocked.Increment(ref m_CacheHitCounter);
			}

			public void AddCacheMiss()
			{
				Interlocked.Increment(ref m_CacheMissCounter);
			}
			public void AddRssCacheHit()
			{
				Interlocked.Increment(ref m_RssCacheHitCounter);
			}
			public void AddRssCacheMiss()
			{
				Interlocked.Increment(ref m_RssCacheMissCounter);
			}
			public void AddSsiCacheHit()
			{
				Interlocked.Increment(ref m_SsiCacheHitCounter);
			}
			public void AddSsiCacheMiss()
			{
				Interlocked.Increment(ref m_SsiCacheMissCounter);
			}
			public void AddServerBusy()
			{
				Interlocked.Increment(ref m_ServerBusyCounter);
			}
			public void AddRawRequest()
			{
				Interlocked.Increment(ref m_RawRequestCounter);
			}
			public void AddLoggedOutRequest()
			{
				Interlocked.Increment(ref m_NonSSORequests);
			}
			public void AddHTMLCacheHit()
			{
				Interlocked.Increment(ref m_HTMLCacheHitCounter);
			}
			public void AddHTMLCacheMiss()
			{
				Interlocked.Increment(ref m_HTMLCacheMissCounter);
			}
            public void AddRequestDuration(int ttaken)
            {
                Interlocked.Increment(ref m_Requests);
                Interlocked.Add(ref m_TotalRequestTime, ttaken);
            }
            public void AddIdentityCallDuration(int ttaken)
            {
                Interlocked.Increment(ref m_IdentityCallCount);
                Interlocked.Add(ref m_IdentityUserCall, ttaken);
            }
            public void AddForbiddenResponse()
            {
                Interlocked.Increment(ref m_ForbiddenResponseCount);
            }

			public int GetRawRequestCounter() { return m_RawRequestCounter; }
			public int GetServerBusyCounter() { return m_ServerBusyCounter; }
			public int GetNonSSORequest() { return m_NonSSORequests; }
			public int GetCacheMissCounter() { return m_CacheMissCounter; }
			public int GetCacheHitCounter() { return m_CacheHitCounter; }
			public int GetRssCacheMissCounter() { return m_RssCacheMissCounter; }
			public int GetRssCacheHitCounter() { return m_RssCacheHitCounter; }
			public int GetSsiCacheMissCounter() { return m_SsiCacheMissCounter; }
			public int GetSsiCacheHitCounter() { return m_SsiCacheHitCounter; }
			public int GetHTMLCacheHitCounter() { return m_HTMLCacheHitCounter; }
			public int GetHTMLCacheMissCounter() { return m_HTMLCacheMissCounter; }
			public int GetRequests() { return m_Requests; }
			public int GetRequestTime() { return m_TotalRequestTime; }
            public int GetIdentityCallTime() { return m_IdentityUserCall; }
            public int GetIdentityCallCount() { return m_IdentityCallCount; }
            public int GetForbiddenResponseCount() { return m_ForbiddenResponseCount; }

            public DateTime Date { get; set; }

			int m_RawRequestCounter;
			int m_ServerBusyCounter;
			int m_TotalRequestTime;
			int m_Requests;
			int m_NonSSORequests;
            int m_ForbiddenResponseCount;

			int m_CacheHitCounter;
			int m_CacheMissCounter;

			int m_RssCacheHitCounter;
			int m_RssCacheMissCounter;

			int m_SsiCacheHitCounter;
			int m_SsiCacheMissCounter;

			int m_HTMLCacheHitCounter;
			int m_HTMLCacheMissCounter;

            int m_IdentityUserCall;
            int m_IdentityCallCount;

		}


		/// <summary>
		/// Default constructor
		/// </summary>

		/// <summary>
		/// Add to the RawRequests stats
		/// </summary>
		public static void AddRawRequest()
		{
			StatDataArray[CalcMinutes()].AddRawRequest();
		}
		/// <summary>
		/// Add to the ServerTooBusy stats
		/// </summary>
		public static void AddServerBusy()
		{
			StatDataArray[CalcMinutes()].AddServerBusy();
		}
        /// <summary>
        /// Addto the tracking of average request duration
        /// </summary>
        /// <param name="ttaken"></param>
        public static void AddRequestDuration(int ttaken)
        {
            StatDataArray[CalcMinutes()].AddRequestDuration(ttaken);
        }
        /// <summary>
        /// Addto the tracking of average request duration
        /// </summary>
        /// <param name="ttaken"></param>
        public static void AddIdentityCallDuration(int ttaken)
        {
            StatDataArray[CalcMinutes()].AddIdentityCallDuration(ttaken);
        }
		/// <summary>
		/// Add a non SSO request to the stats
		/// </summary>
		public static void AddLoggedOutRequest()
		{
			StatDataArray[CalcMinutes()].AddLoggedOutRequest();
		}
		/// <summary>
		/// Add an XML cache hit
		/// </summary>
		public static void AddCacheHit()
		{
			StatDataArray[CalcMinutes()].AddCacheHit();
		}
		/// <summary>
		/// Add an XML cache miss
		/// </summary>
		public static void AddCacheMiss()
		{
			StatDataArray[CalcMinutes()].AddCacheMiss();
		}
		/// <summary>
		/// Add an RSS cache hit
		/// </summary>
		public static void AddRssCacheHit()
		{
			StatDataArray[CalcMinutes()].AddRssCacheHit();
		}
		/// <summary>
		/// Add an RSS cache miss
		/// </summary>
		public static void AddRssCacheMiss()
		{
			StatDataArray[CalcMinutes()].AddRssCacheMiss();
		}
		/// <summary>
		/// Add an SSI cache hit
		/// </summary>
		public static void AddSsiCacheHit()
		{
			StatDataArray[CalcMinutes()].AddSsiCacheHit();
		}

		/// <summary>
		/// Add an SSI cache miss
		/// </summary>
		public static void AddSsiCacheMiss()
		{
			StatDataArray[CalcMinutes()].AddSsiCacheMiss();
		}
		/// <summary>
		/// Add an HTML cache hit
		/// </summary>
		public static void AddHTMLCacheHit()
		{
			StatDataArray[CalcMinutes()].AddHTMLCacheHit();
		}
		/// <summary>
		/// Add an HTML cache miss
		/// </summary>
		public static void AddHTMLCacheMiss()
		{
			StatDataArray[CalcMinutes()].AddHTMLCacheMiss();
		}

        /// <summary>
        /// 
        /// </summary>
        public static void AddForbiddenResponse()
        {
            StatDataArray[CalcMinutes()].AddForbiddenResponse();
        }

		/// <summary>
		/// This method will initialise the static data for the Statistics class only if
		/// it hasn't already been initialised. 
		/// </summary>
		/// <remarks>It can be called multiple times but will only initialise and clear the static data
		/// if it is currently empty. If you want to clear the current data call <see cref="ResetCounters"/>
		/// </remarks>
		public static void InitialiseIfEmpty()
		{
            Locking.InitialiseOrRefresh(_lockstats, InitData, AreStatsEmpty, false, null);
		}

		private static void InitData(object context)
		{
			_dateStarted = DateTime.Now;
            StatData[] data = new StatData[StatDataArraySize];
            for (int i = 0; i < StatDataArraySize; i++)
			{
				data[i] = new StatData();
			}
			StatDataArray = data;
		}

		private static bool AreStatsEmpty()
		{
			return (StatDataArray == null);
		}

		/// <summary>
		/// Reset the stats counters
		/// </summary>
		public static void ResetCounters()
		{
            StatData[] data = new StatData[_hoursPeriod * _minsPeriod];
            for (int i = 0; i < _hoursPeriod * _minsPeriod; i++)
            {
                data[i] = new StatData();
            }
            StatDataArray = data;
		}

		/// <summary>
		/// Get an XML representation of the Statistics XML for the given time interval
		/// </summary>
		/// <param name="interval">Number of minutes to group the stats</param>
		/// <returns></returns>
		public static string GetStatisticsXML(int interval)
		{
			XmlDocument xmlbuilder = CreateStatisticsDocument(interval);
			return xmlbuilder.InnerXml.ToString();
		}

        /// <summary>
        /// Creates an XML document representing the stats
        /// </summary>
        /// <param name="interval">The given time interval in minutes</param>
        /// <returns>Stats XML doc</returns>
		public static XmlDocument CreateStatisticsDocument(int interval)
		{
            if (interval < 1 || interval > _hoursPeriod * _minsPeriod)
                interval = 1;

            XmlDocument xmlbuilder = new XmlDocument();
            XmlElement root = xmlbuilder.CreateElement("STATISTICS");
            xmlbuilder.AppendChild(root);
            XmlElement element = xmlbuilder.CreateElement("STARTDATE");
            element.AppendChild(DnaDateTime.GetDateTimeAsElement(xmlbuilder, _dateStarted));
            root.AppendChild(element);
            element = xmlbuilder.CreateElement("CURRENTDATE");
            element.AppendChild(DnaDateTime.GetDateTimeAsElement(xmlbuilder, DateTime.Now));
            root.AppendChild(element);

			long rawrequests = 0;
			long serverbusy = 0;
			long nonssorequests = 0;
			long cachehits = 0;
			long cachemisses = 0;
			long rsscachehits = 0;
			long rsscachemisses = 0;
			long ssicachehits = 0;
			long ssicachemisses = 0;
			long htmlcachehits = 0;
			long htmlcachemisses = 0;
			long requests = 0;
			long requesttime = 0;
            long identityCallTime = 0;
            long identityCallCount = 0;
            long forbiddenResponseCount = 0;

            StatData[] statDataInPeriod = StatDataInThePeriod(StatDataArray);

			TimeSpan timespan = new TimeSpan();
			int minutes = 0;

            foreach (StatData sd in statDataInPeriod)
            {
				if (rawrequests < long.MaxValue - sd.GetRawRequestCounter())
					rawrequests += sd.GetRawRequestCounter();
				else
					rawrequests = long.MaxValue;

				if (serverbusy < long.MaxValue - sd.GetServerBusyCounter())
					serverbusy += sd.GetServerBusyCounter();
				else
					serverbusy = long.MaxValue;

				if (nonssorequests < long.MaxValue - sd.GetNonSSORequest())
					nonssorequests += sd.GetNonSSORequest();
				else
					nonssorequests = long.MaxValue;

				if (cachehits < long.MaxValue - sd.GetCacheHitCounter())
					cachehits += sd.GetCacheHitCounter();
				else
					cachehits = long.MaxValue;

				if (cachemisses < long.MaxValue - sd.GetCacheMissCounter())
					cachemisses += sd.GetCacheMissCounter();
				else
					cachemisses = long.MaxValue;

				if (rsscachehits < long.MaxValue - sd.GetRssCacheHitCounter())
					rsscachehits += sd.GetRssCacheHitCounter();
				else
					rsscachehits = long.MaxValue;

				if (rsscachemisses < long.MaxValue - sd.GetRssCacheMissCounter())
					rsscachemisses += sd.GetRssCacheMissCounter();
				else
					rsscachemisses = long.MaxValue;

				if (ssicachehits < long.MaxValue - sd.GetSsiCacheHitCounter())
					ssicachehits += sd.GetSsiCacheHitCounter();
				else
					ssicachehits = long.MaxValue;

				if (ssicachemisses < long.MaxValue - sd.GetSsiCacheMissCounter())
					ssicachemisses += sd.GetSsiCacheMissCounter();
				else
					ssicachemisses = long.MaxValue;


				if (htmlcachehits < long.MaxValue - sd.GetHTMLCacheHitCounter())
					htmlcachehits += sd.GetHTMLCacheHitCounter();
				else
					htmlcachehits = long.MaxValue;

				if (htmlcachemisses < long.MaxValue - sd.GetHTMLCacheMissCounter())
					htmlcachemisses += sd.GetHTMLCacheMissCounter();
				else
					htmlcachemisses = long.MaxValue;


				if (requests < long.MaxValue - sd.GetRequests())
					requests += sd.GetRequests();
				else
					requests = long.MaxValue;

                if (requesttime < long.MaxValue - sd.GetRequestTime())
                    requesttime += sd.GetRequestTime();
                else
                    requesttime = long.MaxValue;

                if (identityCallTime < long.MaxValue - sd.GetIdentityCallTime())
                    identityCallTime += sd.GetIdentityCallTime();
                else
                    identityCallTime = long.MaxValue;

                if (identityCallCount < long.MaxValue - sd.GetIdentityCallCount())
                    identityCallCount += sd.GetIdentityCallCount();
                else
                    identityCallCount = long.MaxValue;

                if (identityCallCount < long.MaxValue - sd.GetForbiddenResponseCount())
                    identityCallCount += sd.GetForbiddenResponseCount();
                else
                    identityCallCount = long.MaxValue;

				++minutes;
				if (minutes % interval == 0)
				{
					XmlElement datasection = xmlbuilder.CreateElement("STATISTICSDATA");

					AddNewAttribute(xmlbuilder, datasection, "INTERVALSTARTTIME", string.Format("{0:D2}:{1:D2}", timespan.Hours, timespan.Minutes));

					//Guard against an integer overflow.
					AddLongElement(xmlbuilder, datasection, "RAWREQUESTS", rawrequests);

					AddLongElement(xmlbuilder, datasection, "SERVERBUSYCOUNT", serverbusy);
					AddLongElement(xmlbuilder, datasection, "CACHEHITS", cachehits);
					AddLongElement(xmlbuilder, datasection, "CACHEMISSES", cachemisses);
					AddLongElement(xmlbuilder, datasection, "RSSCACHEHITS", rsscachehits);
					AddLongElement(xmlbuilder, datasection, "RSSCACHEMISSES", rsscachemisses);
					AddLongElement(xmlbuilder, datasection, "SSICACHEHITS", ssicachehits);
					AddLongElement(xmlbuilder, datasection, "SSICACHEMISSES", ssicachemisses);
					AddLongElement(xmlbuilder, datasection, "NONSSOREQUESTS", nonssorequests);
					AddLongElement(xmlbuilder, datasection, "HTMLCACHEHITS", htmlcachehits);
					AddLongElement(xmlbuilder, datasection, "HTMLCACHEMISSES", htmlcachemisses);

					AddLongElement(xmlbuilder, datasection, "AVERAGEREQUESTTIME", requesttime / (requests > 0 ? requests : 1));

                    AddLongElement(xmlbuilder, datasection, "AVERAGEIDENTITYTIME", identityCallTime / (identityCallCount > 0 ? identityCallCount : 1));
                    AddLongElement(xmlbuilder, datasection, "IDENTITYREQUESTS", identityCallCount);

					AddLongElement(xmlbuilder, datasection, "REQUESTS", requests);
                    AddLongElement(xmlbuilder, datasection, "FORBIDDENREQUESTS", forbiddenResponseCount);

					root.AppendChild(datasection);

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
                    identityCallTime = 0;
                    identityCallCount = 0;
                    forbiddenResponseCount = 0;
					timespan += new TimeSpan(0, interval, 0);
				}
			}
			return xmlbuilder;
		}

        /// <summary>
        /// Get a string XML representation of the Stats data grouped in hour intervals
        /// </summary>
        /// <returns></returns>
        public static string GetStatisticsXML()
        {
            return GetStatisticsXML(_minsPeriod);
        }

        public static void SetStatDataDate(int statDataArrayId)
        {
            if (StatDataArray[statDataArrayId].Date < DateToTheMinute())
            {
                StatDataArray[statDataArrayId].ResetStatDataVale(); 
            }
        }

        public static void SetStatDataArraySize(int hours, int mins)
        {
            _hoursPeriod = hours;
            _minsPeriod = mins;
        }

        public static int CalculateCurrentStatDataArrayId(int currentHour, int hourMins, int currentMinute)
        {
            int id = 0;
            
            id = (currentHour * hourMins) + currentMinute;

            while (id > StatDataArraySize -1)
            {
                id = id % StatDataArraySize;
            }

            return id;
        }

        public static StatData[] StatDataInThePeriod(StatData[] data)
        {
            return data.Where(s => s.Date > (DateToTheMinute().AddMinutes(-(_hoursPeriod * _minsPeriod)))).ToArray();
        }

		private static void AddLongElement(XmlDocument xmlbuilder, XmlElement datasection, string elementName, long value)
		{
			XmlElement element = xmlbuilder.CreateElement(elementName);
			element.InnerXml = value.ToString();
			datasection.AppendChild(element);
		}

		private static void AddNewAttribute(XmlDocument xmlbuilder, XmlElement datasection, string attrName, string attrValue)
		{
			XmlAttribute attr = xmlbuilder.CreateAttribute(attrName);
			attr.Value = attrValue;
			datasection.Attributes.Append(attr);
		}

		private static int CalcMinutes()
		{
            int statDataArrayId = 0;

			DateTime now = DateTime.Now;

            lock (_lockCalcMinutes)
            {
                statDataArrayId = CalculateCurrentStatDataArrayId(now.Hour, 60, now.Minute);

                SetStatDataDate(statDataArrayId);
            }

			return statDataArrayId;
		}

        public static DateTime DateToTheMinute()
        {
            return DateTime.Now.Date.AddHours(DateTime.Now.Hour).AddMinutes(DateTime.Now.Minute);
        }

		public static StatData[] StatDataArray { get;set; }

        public static int StatDataArraySize
        {
            get
            {
                return _hoursPeriod * _minsPeriod;
            }
        }

        public static int MinsPeriod
        {
            get
            {
                return _minsPeriod;
            }
        }

        public static int HoursPeriod
        {
            get
            {
                return _hoursPeriod;
            }
        }
        
        private static int _hoursPeriod = 24;
        private static int _minsPeriod = 60;
        private static object _lockstats = new object();
        private static object _lockCalcMinutes = new object();

        private static DateTime _dateStarted;

        

	}
}
