using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Timers;
using BBC.Dna.Data;
using System.Threading;
using DnaEventService.Common;

namespace Dna.BIEventSystem
{
    public class BIEventProcessor : System.Timers.Timer
    {
        private static BIEventProcessor      BIEventProcessorInstance { get; set; }
        private static IDnaDataReaderCreator TheGuideDataReaderCreator { get; set; }
        private static IDnaDataReaderCreator RiskModDataReaderCreator { get; set; }
        private static bool                  DisableRiskMod { get; set; }
        private static int                   TickCounter { get; set; }
        private static bool                  RecRiskModDecOnThreadEntries { get; set; }

        public static IDnaLogger BIEventLogger { get; set; }

        public static BIEventProcessor CreateBIEventProcessor(IDnaLogger logger, IDnaDataReaderCreator theGuideDataReaderCreator, IDnaDataReaderCreator riskModDataReaderCreator, int interval, bool disableRiskMod, bool recRiskModDecOnThreadEntries)
        {
            BIEventLogger = logger;

            if (BIEventProcessorInstance != null)
            {
                // It's designed to have only one instance of BIEventProcessor running at a time
                // so turn the old one off and close it 
                BIEventProcessorInstance.Stop();
                BIEventProcessorInstance.Close();
            }

            TheGuideDataReaderCreator = theGuideDataReaderCreator;
            RiskModDataReaderCreator = riskModDataReaderCreator;
            DisableRiskMod = disableRiskMod;
            RecRiskModDecOnThreadEntries = recRiskModDecOnThreadEntries;

            BIEventProcessorInstance = new BIEventProcessor(interval);

            var props = new Dictionary<string, object>() 
            { 
                { "TheGuide connection string",   TheGuideDataReaderCreator != null ? TheGuideDataReaderCreator.ConnectionString : "NULL" },
                { "RiskMod connection string",    RiskModDataReaderCreator !=null ? RiskModDataReaderCreator.ConnectionString : "NULL" },
                { "Interval",                     interval },
                { "DisableRiskMod",               DisableRiskMod },
                { "RecRiskModDecOnThreadEntries", RecRiskModDecOnThreadEntries }
            };
            BIEventLogger.LogInformation("Created BIEventProcessor with these params", props);

            return BIEventProcessorInstance;
        }

        BIEventProcessor(int interval)
        {
            Interval = interval;
            Enabled = false;
            Elapsed += new ElapsedEventHandler(BIEventProcessor_Tick);
        }

        public void WaitWhileHandlingEvent()
        {
            Monitor.TryEnter(_locker, Timeout.Infinite);
            Monitor.Exit(_locker);
        }

        public new void Start()
        {
            BIEventLogger.LogInformation("Starting BIEventProcessor");
            base.Start();
        }

        static readonly object _locker = new object();

        void BIEventProcessor_Tick(object sender, ElapsedEventArgs e)
        {
            if (Monitor.TryEnter(_locker))
            {
                DateTime tickStart = DateTime.Now;

                BIEventLogger.LogInformation("============== Tick start: " + ++TickCounter);

                RiskModSystem riskModSys = null;
                TheGuideSystem theGuideSys = null;
                List<BIEvent> events = null;

                try
                {
                    riskModSys = new RiskModSystem(RiskModDataReaderCreator, DisableRiskMod);
                    theGuideSys = new TheGuideSystem(TheGuideDataReaderCreator, riskModSys);

                    events = theGuideSys.GetBIEvents();

                    if (events.Count > 0)
                        ProcessEvents(events);

                    if (RecRiskModDecOnThreadEntries)
                        RecordRiskModDecisionsOnThreadEntries(theGuideSys, events);
                }
                catch (Exception ex)
                {
                    BIEventLogger.LogException(ex);
                }
                finally
                {
                    try
                    {
                        // Remove events we managed to process, even if an Exception was caught
                        var processedEvents = GetProcessedEventsList(events);
                        if (processedEvents.Count > 0)
                            theGuideSys.RemoveBIEvents(processedEvents);
                    }
                    catch (Exception ex)
                    {
                        BIEventLogger.LogException(ex);
                    }

                    TimeSpan tickTime = DateTime.Now - tickStart;

                    BIEventLogger.LogInformation("^^^^^^^^^^^^^^ Tick end: " + TickCounter + " (" + tickTime.TotalSeconds+"s)");
                    Monitor.Exit(_locker);
                }
            }
         }

        private List<BIEvent> GetProcessedEventsList(List<BIEvent> events)
        {
            var processedEvents = new List<BIEvent>();

            foreach (var ev in events.Where(x => x.Processed))
                processedEvents.Add(ev);

            return processedEvents;
        }

        public void ProcessEvents(List<BIEvent> events)
        {
            foreach (var ev in events)
            {
                BIEventLogger.LogBIEvent("Processing Event", ev);
                ev.Process();
            }
        }

        private void RecordRiskModDecisionsOnThreadEntries(ITheGuideSystem theGuideSys, List<BIEvent> events)
        {
            // Find all the processed BIPostToForumEvents that have a non-null Risky value
            IEnumerable<BIPostToForumEvent> biPostEvents = events.Where(ev => ev is BIPostToForumEvent).Cast<BIPostToForumEvent>();

            // Record the decision in TheGuide system
            theGuideSys.RecordRiskModDecisionsOnPosts(biPostEvents);
        }
    }
}
