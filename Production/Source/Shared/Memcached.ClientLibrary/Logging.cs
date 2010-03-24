using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace Memcached.ClientLibrary
{
    public static class Logging
    {
        public static void Error(string message)
        {
            Error(message, null);
        }

        public static void Error(string message, Exception e)
        {
            if (Logger.IsLoggingEnabled())
            {
                LogEntry entry = new LogEntry() { Message = message, Severity = System.Diagnostics.TraceEventType.Error };
                if (e != null)
                {
                    entry.ExtendedProperties.Add("ExceptionMessage", e.Message);
                    entry.ExtendedProperties.Add("ExceptionSource", e.Source);
                    entry.ExtendedProperties.Add("ExceptionStack", e.StackTrace);
                    entry.ExtendedProperties.Add("ExceptionInnerMessage", e.InnerException);
                }
                Logger.Write(entry);
            }
        }

        public static void Info(string message)
        {
            if (Logger.IsLoggingEnabled())
            {
                LogEntry entry = new LogEntry() { Message = message, Severity = System.Diagnostics.TraceEventType.Information };
                Logger.Write(entry);
            }
        }

        public static void Verbose(string message)
        {
            if (Logger.IsLoggingEnabled())
            {
                LogEntry entry = new LogEntry() { Message = message, Severity = System.Diagnostics.TraceEventType.Verbose };
                Logger.Write(entry);
            }
        }
    }
}
