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
        public static IDnaLogger Logger {get;set;}

        public static void LogResponse(HttpStatusCode httpStatusCode, HttpResponseMessage httpResponse)
        {
            string assemblyName = Assembly.GetCallingAssembly().GetName().Name;

            LogEntry entry = new LogEntry();
            entry.Categories.Add(assemblyName + ".Responses");
            if (httpStatusCode == HttpStatusCode.OK)
            {
                entry.Severity = TraceEventType.Information;
            }
            else
            {
                entry.Severity = TraceEventType.Error;
            }
            entry.ExtendedProperties.Add("Result: ", httpStatusCode.ToString());
            entry.ExtendedProperties.Add("Uri: ", httpResponse.Uri.ToString());
            entry.ExtendedProperties.Add("Content: ", httpResponse.Content.ReadAsString());
            Logger.Write(entry);
        }

        public static void LogRequest(string postData, string requestUri)
        {
            string assemblyName = Assembly.GetCallingAssembly().GetName().Name;
            LogEntry entry = new LogEntry();
            entry.Severity = TraceEventType.Information;
            entry.Categories.Add(assemblyName + ".Requests");
            entry.ExtendedProperties.Add("POST Data:", postData);
            entry.ExtendedProperties.Add("Activity Uri:", requestUri);
            Logger.Write(entry);
        }

        public static void LogException(Exception ex)
        {
            LogEntry entry = new LogEntry();
            entry.Severity = TraceEventType.Error;
            entry.Message = ex.Message;
            if (ex.InnerException != null)
                entry.ExtendedProperties.Add("Inner Exception: ", ex.InnerException.Message);

            Logger.Write(entry);
        }
    }
}
