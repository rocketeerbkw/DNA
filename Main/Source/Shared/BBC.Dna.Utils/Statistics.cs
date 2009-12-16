using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna.Utils
{
	/// <summary>
	/// A class to track some usage statistics on a per-minute basis
	/// </summary>
	public class Statistics
	{
		class StatData
		{
			/// <summary>
			/// ctor
			/// </summary>
			public StatData()
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
			public void AddNonSSORequest()
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

			int m_RawRequestCounter;
			int m_ServerBusyCounter;
			int m_TotalRequestTime;
			int m_Requests;
			int m_NonSSORequests;

			int m_CacheHitCounter;
			int m_CacheMissCounter;

			int m_RssCacheHitCounter;
			int m_RssCacheMissCounter;

			int m_SsiCacheHitCounter;
			int m_SsiCacheMissCounter;

			int m_HTMLCacheHitCounter;
			int m_HTMLCacheMissCounter;
		}


		/// <summary>
		/// Default constructor
		/// </summary>
		public Statistics()
		{
		}

		/// <summary>
		/// Add to the RawRequests stats
		/// </summary>
		public static void AddRawRequest()
		{
			_statData[CalcMinutes()].AddRawRequest();
		}
		/// <summary>
		/// Add to the ServerTooBusy stats
		/// </summary>
		public static void AddServerBusy()
		{
			_statData[CalcMinutes()].AddServerBusy();
		}
		/// <summary>
		/// Addto the tracking of average request duration
		/// </summary>
		/// <param name="ttaken"></param>
		public static void AddRequestDuration(int ttaken)
		{
			_statData[CalcMinutes()].AddRequestDuration(ttaken);
		}
		/// <summary>
		/// Add a non SSO request to the stats
		/// </summary>
		public static void AddNonSSORequest()
		{
			_statData[CalcMinutes()].AddNonSSORequest();
		}
		/// <summary>
		/// Add an XML cache hit
		/// </summary>
		public static void AddCacheHit()
		{
			_statData[CalcMinutes()].AddCacheHit();
		}
		/// <summary>
		/// Add an XML cache miss
		/// </summary>
		public static void AddCacheMiss()
		{
			_statData[CalcMinutes()].AddCacheMiss();
		}
		/// <summary>
		/// Add an RSS cache hit
		/// </summary>
		public static void AddRssCacheHit()
		{
			_statData[CalcMinutes()].AddRssCacheHit();
		}
		/// <summary>
		/// Add an RSS cache miss
		/// </summary>
		public static void AddRssCacheMiss()
		{
			_statData[CalcMinutes()].AddRssCacheMiss();
		}
		/// <summary>
		/// Add an SSI cache hit
		/// </summary>
		public static void AddSsiCacheHit()
		{
			_statData[CalcMinutes()].AddSsiCacheHit();
		}

		/// <summary>
		/// Add an SSI cache miss
		/// </summary>
		public static void AddSsiCacheMiss()
		{
			_statData[CalcMinutes()].AddSsiCacheMiss();
		}
		/// <summary>
		/// Add an HTML cache hit
		/// </summary>
		public static void AddHTMLCacheHit()
		{
			_statData[CalcMinutes()].AddHTMLCacheHit();
		}
		/// <summary>
		/// Add an HTML cache miss
		/// </summary>
		public static void AddHTMLCacheMiss()
		{
			_statData[CalcMinutes()].AddHTMLCacheMiss();
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
			StatData[] data = new StatData[24 * 60];
			for (int i = 0; i < 24 * 60; i++)
			{
				data[i] = new StatData();
			}
			_statData = data;
		}

		private static bool AreStatsEmpty()
		{
			return (_statData == null);
		}

		/// <summary>
		/// Reset the stats counters
		/// </summary>
		public static void ResetCounters()
		{
			StatData[] data = new StatData[25 * 60];
			for (int i = 0; i < 24 * 60; i++)
			{
				data[i] = new StatData();
			}
			_statData = data;
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
			//Default is data at 1 minute intervals from midnight.
			if (interval < 1 || interval > 24 * 60)
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
			TimeSpan timespan = new TimeSpan();
			int minutes = 0;
			for (int i = 0; i < 24 * 60; i++)
			{
				if (rawrequests < long.MaxValue - _statData[i].GetRawRequestCounter())
					rawrequests += _statData[i].GetRawRequestCounter();
				else
					rawrequests = long.MaxValue;

				if (serverbusy < long.MaxValue - _statData[i].GetServerBusyCounter())
					serverbusy += _statData[i].GetServerBusyCounter();
				else
					serverbusy = long.MaxValue;

				if (nonssorequests < long.MaxValue - _statData[i].GetNonSSORequest())
					nonssorequests += _statData[i].GetNonSSORequest();
				else
					nonssorequests = long.MaxValue;

				if (cachehits < long.MaxValue - _statData[i].GetCacheHitCounter())
					cachehits += _statData[i].GetCacheHitCounter();
				else
					cachehits = long.MaxValue;

				if (cachemisses < long.MaxValue - _statData[i].GetCacheMissCounter())
					cachemisses += _statData[i].GetCacheMissCounter();
				else
					cachemisses = long.MaxValue;

				if (rsscachehits < long.MaxValue - _statData[i].GetRssCacheHitCounter())
					rsscachehits += _statData[i].GetRssCacheHitCounter();
				else
					rsscachehits = long.MaxValue;

				if (rsscachemisses < long.MaxValue - _statData[i].GetRssCacheMissCounter())
					rsscachemisses += _statData[i].GetRssCacheMissCounter();
				else
					rsscachemisses = long.MaxValue;

				if (ssicachehits < long.MaxValue - _statData[i].GetSsiCacheHitCounter())
					ssicachehits += _statData[i].GetSsiCacheHitCounter();
				else
					ssicachehits = long.MaxValue;

				if (ssicachemisses < long.MaxValue - _statData[i].GetSsiCacheMissCounter())
					ssicachemisses += _statData[i].GetSsiCacheMissCounter();
				else
					ssicachemisses = long.MaxValue;


				if (htmlcachehits < long.MaxValue - _statData[i].GetHTMLCacheHitCounter())
					htmlcachehits += _statData[i].GetHTMLCacheHitCounter();
				else
					htmlcachehits = long.MaxValue;

				if (htmlcachemisses < long.MaxValue - _statData[i].GetHTMLCacheMissCounter())
					htmlcachemisses += _statData[i].GetHTMLCacheMissCounter();
				else
					htmlcachemisses = long.MaxValue;


				if (requests < long.MaxValue - _statData[i].GetRequests())
					requests += _statData[i].GetRequests();
				else
					requests = long.MaxValue;

				if (requesttime < long.MaxValue - _statData[i].GetRequestTime())
					requesttime += _statData[i].GetRequestTime();
				else
					requesttime = long.MaxValue;

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

					AddLongElement(xmlbuilder, datasection, "REQUESTS", requests);

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
					timespan += new TimeSpan(0, interval, 0);
				}
			}
			return xmlbuilder;
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

		/// <summary>
		/// Get a string XML representation of the Stats data grouped in hour intervals
		/// </summary>
		/// <returns></returns>
		public static string GetStatisticsXML()
		{
			return GetStatisticsXML(60);
		}

		private static int CalcMinutes()
		{
			DateTime now = DateTime.Now;
			return (now.Hour * 60) + now.Minute;
		}

		private static object _lockstats = new object();
		private static DateTime _dateStarted;
		private static StatData[] _statData;

	}
}
