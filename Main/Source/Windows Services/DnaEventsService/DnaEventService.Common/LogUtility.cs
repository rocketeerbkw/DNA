using System;
using System.Diagnostics;
using System.Net;
using System.Reflection;
using Microsoft.Http;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace DnaEventService.Common
{
    public class LogUtility
    {
        public static IDnaLogger Logger { get; set; }

        public static void LogResponse(HttpStatusCode httpStatusCode, HttpResponseMessage httpResponse)
        {
            string assemblyName = Assembly.GetCallingAssembly().GetName().Name;

            var entry = new LogEntry();
            entry.Categories.Add(assemblyName + ".Responses");
            entry.Severity = httpStatusCode == HttpStatusCode.OK ? TraceEventType.Information : TraceEventType.Error;
            entry.ExtendedProperties.Add("Result: ", httpStatusCode.ToString());
            entry.ExtendedProperties.Add("Uri: ", httpResponse.Uri.ToString());
            entry.ExtendedProperties.Add("Content: ", httpResponse.Content.ReadAsString());
            Logger.Write(entry);
        }

        public static void LogRequest(string postData, string requestUri)
        {
            string assemblyName = Assembly.GetCallingAssembly().GetName().Name;
            var entry = new LogEntry { Severity = TraceEventType.Information };
            entry.Categories.Add(assemblyName + ".Requests");
            entry.ExtendedProperties.Add("POST Data:", postData);
            entry.ExtendedProperties.Add("Activity Uri:", requestUri);
            Logger.Write(entry);
        }

        public static void LogException(Exception ex)
        {
            var entry = new LogEntry { Severity = TraceEventType.Error, Message = ex.Message };
            if (ex.InnerException != null)
                entry.ExtendedProperties.Add("Inner Exception: ", ex.InnerException.Message);

            Logger.Write(entry);
        }
    }
}