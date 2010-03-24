using System;
using System.Net;
using DnaEventService.Common;
using Microsoft.Http;

namespace Dna.SnesIntegration.ActivityProcessor
{
    abstract class ActivityBase : MarshalByRefObject, ISnesActivity
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
            LogUtility.LogRequest(GetActivityJson(), GetUri().ToString());
            using (var response = func(GetUri()))
            {
                response.Content.LoadIntoBuffer();
                Content = response.Content.ReadAsString();
                return LogResponse(response);
            }
        }

        protected HttpStatusCode Send(Func<Uri, HttpContent, HttpResponseMessage> func)
        {
            LogUtility.LogRequest(GetActivityJson(), GetUri().ToString());
            var activityJson = GetActivityJson();
            var content = HttpContent.Create(activityJson, "application/json");
            using (var response = func(GetUri(), content))
            {
                response.Content.LoadIntoBuffer();
                Content = response.Content.ReadAsString();
                return LogResponse(response);
            }
        }

        #endregion

        #region Static Methods

        private static HttpStatusCode LogResponse(HttpResponseMessage response)
        {
            var statusCode = response.StatusCode;
            LogUtility.LogResponse(statusCode, response);
            return statusCode;
        }

        #endregion
    }
}
