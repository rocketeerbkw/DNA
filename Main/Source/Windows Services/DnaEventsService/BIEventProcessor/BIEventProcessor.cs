using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Timers;
using BBC.Dna.Data;
using System.Threading;
using DnaEventService.Common;
using System.Diagnostics;

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
        private static int                   NumThreads { get; set; }

        public static IDnaLogger BIEventLogger { get; set; }

        public static BIEventProcessor CreateBIEventProcessor(IDnaLogger logger, IDnaDataReaderCreator theGuideDataReaderCreator, IDnaDataReaderCreator riskModDataReaderCreator, int interval, bool disableRiskMod, bool recRiskModDecOnThreadEntries, int numThreads)
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
            NumThreads = numThreads;

            int minNumThreads, minCompPorts, maxNumThreads, maxCompPorts;
            ThreadPool.GetMinThreads(out minNumThreads, out minCompPorts);
            ThreadPool.GetMaxThreads(out maxNumThreads, out maxCompPorts);
            if (minNumThreads < NumThreads)
                ThreadPool.SetMinThreads(NumThreads, NumThreads);

            BIEventProcessorInstance = new BIEventProcessor(interval);

            var props = new Dictionary<string, object>() 
            { 
                { "TheGuide connection string",   TheGuideDataReaderCreator != null ? TheGuideDataReaderCreator.ConnectionString : "NULL" },
                { "RiskMod connection string",    RiskModDataReaderCreator !=null ? RiskModDataReaderCreator.ConnectionString : "NULL" },
                { "Interval",                     interval },
                { "DisableRiskMod",               DisableRiskMod },
                { "RecRiskModDecOnThreadEntries", RecRiskModDecOnThreadEntries },
                { "NumThreads",                   NumThreads },
                { "MinThreads",                   minNumThreads },
                { "MaxThreads",                   maxNumThreads }
            };
            BIEventLogger.Log(TraceEventType.Information, "Created BIEventProcessor with these params", props);

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
            BIEventLogger.Log(TraceEventType.Information, "Starting BIEventProcessor");
            base.Start();
        }

        static readonly object _locker = new object();

        void BIEventProcessor_Tick(object sender, ElapsedEventArgs e)
        {
            if (Monitor.TryEnter(_locker))
            {
                DateTime tickStart = DateTime.Now;

                TickCounter += 1;
                BIEventLogger.Log(TraceEventType.Verbose,"============== Tick start: " + TickCounter);

                RiskModSystem riskModSys = null;
                TheGuideSystem theGuideSys = null;
                List<BIEvent> events = null;

                try
                {
                    riskModSys = new RiskModSystem(RiskModDataReaderCreator, DisableRiskMod);
                    theGuideSys = new TheGuideSystem(TheGuideDataReaderCreator, riskModSys);

                    events = theGuideSys.GetBIEvents();

                    if (events.Count > 0)
                    {
                        ProcessEvents(events,NumThreads);

                        if (RecRiskModDecOnThreadEntries)
                            RecordRiskModDecisionsOnThreadEntries(theGuideSys, events);
                    }
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

                    BIEventLogger.Log(TraceEventType.Verbose,"^^^^^^^^^^^^^^ Tick end: " + TickCounter + " (" + tickTime.TotalSeconds+"s)");
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

        public void ProcessEvents(List<BIEvent> events, int numThreads)
        {
            BIEventLogger.Log(TraceEventType.Verbose,"Starting ProcessEvents");
            DateTime startTime = DateTime.Now;

            BIEventQueue biEventQueue = new BIEventQueue();

            foreach (var ev in events)
                biEventQueue.Enqueue(ev);

            Action<BIEventQueue>[] workers = new Action<BIEventQueue>[numThreads];
            IAsyncResult[] workerResults = new IAsyncResult[numThreads];

            if (events.Count < numThreads)
                numThreads = events.Count;

            for (int i = 0; i < numThreads; i++)
            {
                workers[i] = evQ =>
                {
                    var ev = evQ.Dequeue();
                    while (ev != null)
                    {
                        BIEventLogger.LogBIEvent("Processing Event", ev);
                        ev.Process();
                        ev = evQ.Dequeue();
                    }
                };
                workerResults[i] = workers[i].BeginInvoke(biEventQueue, null, null);
            }

            for (int i = 0; i < numThreads; i++)
                workers[i].EndInvoke(workerResults[i]);

            BIEventLogger.Log(TraceEventType.Information,"Finished ProcessEvents", startTime, "Num threads", numThreads, "Num events", events.Count());
        }

        private void RecordRiskModDecisionsOnThreadEntries(ITheGuideSystem theGuideSys, List<BIEvent> events)
        {
            // Find all the BIPostToForumEvents
            IEnumerable<BIPostToForumEvent> biPostEvents = events.Where(ev => ev is BIPostToForumEvent).Cast<BIPostToForumEvent>();

            // Record the decision in TheGuide system
            theGuideSys.RecordRiskModDecisionsOnPosts(biPostEvents);
        }
    }
}
