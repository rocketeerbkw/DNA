using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using DnaEventService.Common;

namespace Dna.BIEventSystem
{
    static class BIEventProcessorLogUtility
    {
        public static void LogBIEvent(this IDnaLogger logger, string message , BIEvent ev)
        {
            var props = new Dictionary<string, object>()
            {
                { "EventId",                    ev.EventId},
                { "EventType",                  ev.EventType}
            };

            logger.LogInformation(message, DateTime.MaxValue, props);
        }
    }
}
