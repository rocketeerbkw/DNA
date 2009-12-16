using System;
using System.Collections.Generic;
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

        static private bool processing = false;

        private SnesActivityProcessor()
        {
        }

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
            if (processing == true)
                return;

            processing = true;

            Dictionary<int, HttpStatusCode> results;
            try
            {
                using (var reader = DataReaderCreator.CreateDnaDataReader("getsnesevents"))
                {
                    reader.AddParameter("batchSize", BatchSize);
                    results = SendSnesEvents(BuildSnesEvents(reader));
                }
                RemoveSentSnesEvents(results);
            }
            catch (Exception ex)
            {
                LogUtility.LogException(ex);
            }
            finally
            {
                processing = false;
            }
        }

        private IEnumerable<ISnesActivity> BuildSnesEvents(IDnaDataReader reader)
        {
            var activities = new List<ISnesActivity>();
            reader.Execute();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    activities.Add(SnesActivityFactory.CreateSNeSActivity(reader));
                }
            }
            return activities;
        }

        private Dictionary<int, HttpStatusCode> SendSnesEvents(IEnumerable<ISnesActivity> activities)
        {
            var results = new Dictionary<int, HttpStatusCode>();
            foreach (var activity in activities)
            {
                results.Add(activity.ActivityId, SendEvent(activity));
            }
            return results;
        }

        private HttpStatusCode SendEvent(ISnesActivity activity)
        {
            var client = HttpClientCreator.CreateHttpClient();

            var activityJson = activity.GetActivityJson();
            var activityUri = activity.GetPostUri();

            LogUtility.LogRequest(activityJson, activityUri);

            var content =
                HttpContent.Create(activityJson, "application/json");

            using (var response = client.Post(activityUri, content))
            {
                LogUtility.LogResponse(response.StatusCode, response);
                return response.StatusCode;
            }
        }

        private void RemoveSentSnesEvents(Dictionary<int, HttpStatusCode> results)
        {
            if (results.Keys.Count > 0)
            {
                var ids = BuildParameterXml(results);

                if (ids.Length > 0)
                {
                    using (var reader = DataReaderCreator.CreateDnaDataReader("removehandledsnesevents"))
                    {
                        reader.AddParameter("eventids", ids).Execute();
                    }
                }
            }
        }

        private static string BuildParameterXml(Dictionary<int, HttpStatusCode> results)
        {
            var ids = string.Empty;
            foreach (var result in results)
            {
                if (result.Value == HttpStatusCode.OK)
                {
                    ids = ids + "<eventid>" + result.Key.ToString() + "</eventid>";
                }
            }
            return ids;
        }
    }
}
