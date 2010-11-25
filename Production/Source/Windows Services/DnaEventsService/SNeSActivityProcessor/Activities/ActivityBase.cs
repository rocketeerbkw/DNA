using System;
using System.Net;
using System.Text;
using DnaEventService.Common;
using Microsoft.Http;

namespace Dna.SnesIntegration.ActivityProcessor.Activities
{
    public enum ActivityType
    {
        PublishActivity = 19,
        RevokeActivity = 20,    
    }

    public abstract class ActivityBase : MarshalByRefObject, ISnesActivity
    {
        #region ISnesActivity Members

        public int ActivityId { get; set; }
        public string Content { get; set; }

        public virtual Uri GetUri()
        {
            return new Uri("", UriKind.Relative);
        }

        public virtual string GetActivityJson()
        {
            return String.Empty;
        }

        public abstract HttpStatusCode Send(IDnaHttpClient client);

        #endregion

        #region Protected Methods

        protected HttpStatusCode Send(Func<Uri, HttpResponseMessage> func)
        {
            SnesActivityProcessor.SnesActivityLogger.LogRequest(GetActivityJson(), GetUri().ToString());
            using (var response = func(GetUri()))
            {
                response.Content.LoadIntoBuffer();
                Content = response.Content.ReadAsString();
                LogResponse(response);
                return response.StatusCode;
            }
        }

        protected HttpStatusCode Send(Func<Uri, HttpContent, HttpResponseMessage> func)
        {
            SnesActivityProcessor.SnesActivityLogger.LogRequest(GetActivityJson(), GetUri().ToString());
            var activityJson = GetActivityJson();
            var content = HttpContent.Create(activityJson, Encoding.UTF8, "application/json");
            using (var response = func(GetUri(), content))
            {
                response.Content.LoadIntoBuffer();
                Content = response.Content.ReadAsString();
                LogResponse(response);
                return response.StatusCode;
            }
        }

        private void LogResponse(HttpResponseMessage response)
        {
            var statusCode = response.StatusCode;
            SnesActivityProcessor.SnesActivityLogger.LogResponse(statusCode, response);
        }

        #endregion
    }
}


