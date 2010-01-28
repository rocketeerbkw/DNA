using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using BBC.Dna.Data;
using DnaEventService.Common;
using Microsoft.Http;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection.CallHandlers;

namespace Dna.SnesIntegration.ActivityProcessor
{
    [LogCallHandler]
    public class SnesActivityProcessor : MarshalByRefObject
    {
        private IDnaDataReaderCreator DataReaderCreator { get; set; }
        private IDnaHttpClientCreator HttpClientCreator { get; set; }
        private int BatchSize { get; set; }

        private static bool _processing;

        public SnesActivityProcessor(IDnaDataReaderCreator dataReaderCreator,
            IDnaLogger logger,
            IDnaHttpClientCreator httpClientCreator,
            int batchSize)
        {
            DataReaderCreator = dataReaderCreator;
            LogUtility.Logger = logger;
            HttpClientCreator = httpClientCreator;
            BatchSize = batchSize;
        }

        public SnesActivityProcessor(IDnaDataReaderCreator dataReaderCreator,
            IDnaLogger logger,
            IDnaHttpClientCreator httpClientCreator)
            : this(dataReaderCreator, logger, httpClientCreator, 100)
        {
        }

        public void ProcessEvents(object state)
        {
            if (_processing)
                return;

            _processing = true;
            try
            {
                IEnumerable<ISnesActivity> snesEvents;
                using (var reader = DataReaderCreator.CreateDnaDataReader("getsnesevents"))
                {
                    reader.AddParameter("batchSize", BatchSize);
                    snesEvents = BuildSnesEvents(reader);
                }
                var results = SendSnesEvents(snesEvents);
                RemoveSentSnesEvents(results);
            }
            catch (Exception ex)
            {
                LogUtility.LogException(ex);
            }
            finally
            {
                _processing = false;
            }
        }

        private static IEnumerable<ISnesActivity> BuildSnesEvents(IDnaDataReader reader)
        {
            var activities = new List<ISnesActivity>();
            reader.Execute();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    activities.Add(SnesActivityFactory.CreateSnesActivity(reader));
                }
            }
            return activities;
        }

        private Dictionary<int, HttpStatusCode> SendSnesEvents(IEnumerable<ISnesActivity> activities)
        {
            return activities.ToDictionary(activity => activity.ActivityId, activity => SendEvent(activity));
        }

        private HttpStatusCode SendEvent(ISnesActivity activity)
        {
            var client = HttpClientCreator.CreateHttpClient();
            return activity.Send(client);
        }

        private void RemoveSentSnesEvents(Dictionary<int, HttpStatusCode> results)
        {
            if (results.Keys.Count <= 0) return;
            var ids = BuildParameterXml(results);

            if (ids.Length <= 0) return;
            using (var reader = DataReaderCreator.CreateDnaDataReader("removehandledsnesevents"))
            {
                reader.AddParameter("eventids", ids).Execute();
            }
        }

        private static string BuildParameterXml(Dictionary<int, HttpStatusCode> results)
        {
            return results
                .Where(result => result.Value == HttpStatusCode.OK)
                .Aggregate(string.Empty, (current, result) => AppendEventIdElement(result, current));
        }

        private static string AppendEventIdElement(KeyValuePair<int, HttpStatusCode> result, string ids)
        {
            return ids + "<eventid>" + result.Key + "</eventid>";
        }
    }
}
