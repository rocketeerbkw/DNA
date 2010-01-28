using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using DnaEventService.Common;
using Microsoft.Http;

namespace Dna.SnesIntegration.ActivityProcessor
{
    abstract class ActivityBase : MarshalByRefObject, ISnesActivity
    {

        #region ISnesActivity Members

        public abstract string GetActivityJson();

        public virtual Uri GetUri()
        {
            return new Uri("", UriKind.Relative);
        }

        public int ActivityId { get; set; }

        public abstract HttpStatusCode Send(IDnaHttpClient client);

        #region Protected Methods
        protected HttpStatusCode Send(Func<Uri,HttpResponseMessage> func)
        {
            LogUtility.LogRequest(GetActivityJson(), GetUri().ToString());
            using (var response = func(GetUri()))
            {
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

        #endregion
    }
}
