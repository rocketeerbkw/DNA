using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using BBC.Dna.Data;
using DnaEventService.Common;
using System.Diagnostics;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection.CallHandlers;

namespace Dna.SiteEventProcessor
{
    [LogCallHandler]
    public class SiteEventsProcessor : System.Timers.Timer
    {
        static private bool processing = false;

        public static IDnaLogger SiteEventLogger { get; private set; }

        private IDnaDataReaderCreator DataReaderCreator { get; set; }

        public SiteEventsProcessor()
        {
        }

        public SiteEventsProcessor(IDnaDataReaderCreator dataReaderCreator,
            IDnaLogger logger)
        {
            DataReaderCreator = dataReaderCreator;
            SiteEventLogger = logger;
        }

        public void ProcessEvents(object state)
        {
            if (processing == true)
                return;

            processing = true;
            try
            {
                ArticleModerationDecision.ProcessArticleModerationDecisionActivity(DataReaderCreator);
                PostModerationDecision.ProcessPostModerationDecisionActivity(DataReaderCreator);
                ComplaintPostEvent.ProcessComplaintPostEventActivity(DataReaderCreator);
                ComplaintArticleEvent.ProcessComplaintArticleEventActivity(DataReaderCreator);
                UserModeratedEvent.ProcessUserModatedEventActivity(DataReaderCreator);
                NewUserEvent.ProcessNewUserEventActivity(DataReaderCreator);

                using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("removesiteevents"))
                {
                    reader.Execute();
                }
            }
            catch (Exception ex)
            {
                SiteEventLogger.LogException(ex);
            }
            finally
            {
                processing = false;
            }
        }


    }
}
