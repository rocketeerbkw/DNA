using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using BBC.Dna.Data;
using DnaEventService.Common;
using Microsoft.Http;
using System.Diagnostics;

using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection.CallHandlers;

namespace Dna.SnesIntegration.ExModerationProcessor
{
    [LogCallHandler]
    public class ExModerationProcessor : MarshalByRefObject
    {
        
        static private bool processing = false;

        private IDnaDataReaderCreator DataReaderCreator { get; set; }
        private IDnaHttpClientCreator HttpClientCreator { get; set; }


        public ExModerationProcessor()
        {
        }
        
        public ExModerationProcessor(IDnaDataReaderCreator dataReaderCreator,
            IDnaLogger logger,
            IDnaHttpClientCreator httpClientCreator)
        {
            DataReaderCreator = dataReaderCreator;
            HttpClientCreator = httpClientCreator;
            LogUtility.Logger = logger;
        }

        public void ProcessEvents(object state)
        {
            if (processing == true)
                return;

            processing = true;
            Dictionary<int, HttpStatusCode> results;
            try
            {
                IEnumerable<ExModerationEvent> events;
                using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getexmoderationevents"))
                {
                    reader.Execute();

                    events = BuildExModerationEvents(reader);
                    results = SendExModerationEvents(events);
                }
                UpdateExModerationEvents(results);
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

        private Dictionary<int, HttpStatusCode> SendExModerationEvents(IEnumerable<ExModerationEvent> activities)
        {
            Dictionary<int, HttpStatusCode> results = new Dictionary<int, HttpStatusCode>();
            foreach ( ExModerationEvent activity in activities)
            {
                results.Add(activity.ModId, SendEvent(activity));
            }
            return results;

        }

        private IEnumerable<ExModerationEvent> BuildExModerationEvents(IDnaDataReader reader)
        {
            List<ExModerationEvent> activities = new List<ExModerationEvent>();
            while (reader.Read())
            {
                activities.Add(ExModerationEvent.CreateExModerationEvent(reader));
            }
            
            return activities;
        }

        private static string BuildParameterXml(Dictionary<int, HttpStatusCode> results)
        {
            string events = string.Empty;
            foreach (var result in results)
            {
                events = events + @"<event id=""" + result.Key.ToString() + @""" handled=""" + Convert.ToString(result.Value == HttpStatusCode.OK ? 1 : 0) + @""" />";
            }
            return events;
        }

        private HttpStatusCode SendEvent(ExModerationEvent activity)
        {
            IDnaHttpClient client = HttpClientCreator.CreateHttpClient(activity.CallBackUri);
            
            String  activityAsJSON = activity.ToJSON();


            LogUtility.LogRequest(activityAsJSON, activity.CallBackUri);

            HttpContent content =
                HttpContent.Create(activityAsJSON, "application/json");

            try
            {
                using (HttpResponseMessage response = client.Post("", content))
                {
                    LogUtility.LogResponse(response.StatusCode, response);
                    return response.StatusCode;
                }
            }
            catch (HttpProcessingException e)
            {
                // Handle errors due to unreachable urls.
                if (e.Message.Contains(Convert.ToString(HttpStatusCode.GatewayTimeout)))
                    return HttpStatusCode.GatewayTimeout;
                else
                    throw e;
            }
        }

        private void UpdateExModerationEvents(Dictionary<int, HttpStatusCode> results)
        {
            if (results.Keys.Count > 0)
            {
                string ids = BuildParameterXml(results);

                if (ids.Length > 0)
                {
                    using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("updateexmoderationevents"))
                    {
                        reader.AddParameter("eventids", ids);
                        reader.Execute();
                    }
                }
            }
        }
    }
}
