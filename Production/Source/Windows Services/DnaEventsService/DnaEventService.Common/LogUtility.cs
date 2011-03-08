using System;
using System.Diagnostics;
using System.Net;
using System.Reflection;
using Microsoft.Http;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using System.Collections;
using System.Collections.Generic;

namespace DnaEventService.Common
{
    public static class LogUtility
    {
        public static void LogResponse(this IDnaLogger logger,HttpStatusCode httpStatusCode, HttpResponseMessage httpResponse)
        {
            var props = new Dictionary<string, object>() 
            { 
                { "Result", httpStatusCode.ToString()},
                { "Uri", httpResponse.Uri.ToString()},
                { "Content", httpResponse.Content.ReadAsString()}
            };
            string category = Assembly.GetCallingAssembly().GetName().Name + ".Responses";
            logger.LogGeneral(TraceEventType.Information, category, "", DateTime.MaxValue, props);
        }

        public static void LogRequest(this IDnaLogger logger, string postData, string requestUri)
        {
            var props = new Dictionary<string, object>() 
            { 
                { "POST Data",    postData },
                { "Activity Uri", requestUri}
            };

            string category = Assembly.GetCallingAssembly().GetName().Name + ".Requests";
            logger.LogGeneral(TraceEventType.Information, category, "", DateTime.MaxValue, props);
        }

        public static void LogException(this IDnaLogger logger, Exception ex)
        {
            var props = new Dictionary<string, object>();

            if (ex.InnerException != null)
                props.Add("Inner Exception", ex.InnerException.Message);

            props.Add("Stack Trace", ex.StackTrace);

            string category = Assembly.GetCallingAssembly().GetName().Name+".Exceptions";
            logger.LogGeneral(TraceEventType.Error, category, ex.Message, DateTime.MaxValue, props);
        }


        public static void Log(this IDnaLogger logger, TraceEventType eventType, string message, Dictionary<string, object> props)
        {
            string category = Assembly.GetCallingAssembly().GetName().Name;
            logger.LogGeneral(eventType, category, message, DateTime.MaxValue, props);
        }

        public static void Log(this IDnaLogger logger, TraceEventType eventType, string message, params object[] p)
        {
            string category = Assembly.GetCallingAssembly().GetName().Name;
            logger.LogGeneral(eventType, category, message, DateTime.MaxValue, p);
        }

        public static void Log(this IDnaLogger logger, TraceEventType eventType, string message, DateTime startTime, Dictionary<string, object> props)
        {
            string category = Assembly.GetCallingAssembly().GetName().Name;
            logger.LogGeneral(eventType, category, message, startTime, props);
        }

        public static void Log(this IDnaLogger logger, TraceEventType eventType, string message, DateTime startTime, params object[] p)
        {
            string category = Assembly.GetCallingAssembly().GetName().Name;
            logger.LogGeneral(eventType, category, message, startTime, p);
        }

        private static void LogGeneral(this IDnaLogger logger, TraceEventType traceEventType, string category, string message, DateTime startTime, params object[] p)
        {
            var props = new Dictionary<string, object>();
            int i = 0;
            string key = "";
            foreach (object o in p)
            {
                if (i++ % 2 == 0)
                    key = (string)o;
                else
                    props.Add(key, o);
            }

            logger.LogGeneral(traceEventType, category, message, startTime, props);
        }

        private static void LogGeneral(this IDnaLogger logger, TraceEventType traceEventType, string category, string message, DateTime startTime, Dictionary<string, object> props)
        {
            if (logger == null)
                return;

            var entry = new LogEntry { Severity = traceEventType };

            entry.Categories.Add(category);
            entry.Message = message;

            foreach (var kv in props)
            {
                if (kv.Value != null)
                    entry.ExtendedProperties.Add(kv.Key, kv.Value);
                else
                    entry.ExtendedProperties.Add(kv.Key, "NULL");
            }

            if (startTime != null && startTime != DateTime.MaxValue)
                entry.ExtendedProperties.Add("Time Taken", (DateTime.Now-startTime).TotalSeconds);

            logger.Write(entry);
        }
    }
}