using System;
using System.Collections.Generic;
using System.Diagnostics;
using DnaEventService.Common;

namespace Dna.DatabaseEmailProcessor
{
    static class DatabaseEmailProcessorLogger
    {
        public static void LogEmailProcessEvent(this IDnaLogger logger, string message, EmailDetailsToProcess ev)
        {
            var props = new Dictionary<string, object>()
            {
                { "EmailId", ev.ID},
                { "Subject", ev.Subject}
            };

            logger.Log(TraceEventType.Verbose, message, DateTime.MaxValue, props);
        }
    }
}
