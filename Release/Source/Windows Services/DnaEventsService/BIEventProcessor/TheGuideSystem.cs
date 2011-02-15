using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using DnaEventService.Common;
using System.Diagnostics;

namespace Dna.BIEventSystem
{
    public class TheGuideSystem : ITheGuideSystem
    {
        IDnaDataReaderCreator TheGuideDataReaderCreator { get; set; }
        IRiskModSystem RiskModSystem { get; set; }

        public TheGuideSystem(IDnaDataReaderCreator theGuideDataReaderCreator, IRiskModSystem riskMod)
        {
            TheGuideDataReaderCreator = theGuideDataReaderCreator;
            RiskModSystem = riskMod;
        }

        public List<BIEvent> GetBIEvents()
        {
            List<BIEvent> events;

            using (IDnaDataReader reader = TheGuideDataReaderCreator.CreateDnaDataReader("getbievents"))
            {
                reader.Execute();
                events = GetBIEvents(reader);
            }

            BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "GetBIEvents() finished", "Num Events", events.Count);

            return events;
        }

        private List<BIEvent> GetBIEvents(IDnaDataReader reader)
        {
            List<BIEvent> biEventList = new List<BIEvent>();
            while (reader.Read())
            {
                BIEvent be = BIEvent.CreateBiEvent(reader, this, RiskModSystem);
                biEventList.Add(be);
            }

            return biEventList;
        }

        public void RemoveBIEvents(List<BIEvent> events)
        {
            BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "RemoveBIEvents()", "Num Events to remove", events.Count);

            if (events.Count > 0)
            {
                string eventsListXml = events.Aggregate(string.Empty, (current, ev) => current + "<eventid>" + ev.EventId + "</eventid>");

                using (IDnaDataReader reader = TheGuideDataReaderCreator.CreateDnaDataReader("removehandledbievents"))
                {
                    reader.AddParameter("eventids", eventsListXml);
                    reader.Execute();
                }
            }
        }
        

        public void ProcessPostRiskAssessment(BIPostNeedsRiskAssessmentEvent ev, bool risky)
        {
            DateTime startTime = DateTime.Now;

            using (IDnaDataReader reader = TheGuideDataReaderCreator.CreateDnaDataReader("riskmod_processriskassessmentforthreadentry"))
            {
                reader.AddParameter("riskmodthreadentryqueueid", ev.RiskModThreadEntryQueueId);
                reader.AddParameter("risky", risky);
                reader.Execute();

                // Read through all result sets to find an OuterErrorCode.  If found, throw an exception
                // The reason is that the proc calls other procs, which may or may not generate their own result sets
                // We're not interested in any results, except for the error result set created by the outer query
                do
                {
                    while (reader.Read())
                    {
                        if (reader.DoesFieldExist("OuterErrorCode"))
                        {
                            string msg = string.Format("ProcessPostRiskAssessment: SP Error from riskmod_processriskassessmentforthreadentry ({0}): {1}", reader.GetInt32("OuterErrorCode"), reader.GetString("OuterErrorMessage"));
                            throw new Exception(msg);
                        }
                    }
                } while (reader.NextResult());
            }

            BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "ProcessPostRiskAssessment() end", startTime, "RiskModThreadEntryQueueId", ev.RiskModThreadEntryQueueId);
        }

        public void RecordRiskModDecisionsOnPosts(IEnumerable<BIPostToForumEvent> biPostEvents)
        {
            // Process all the BIPostToForumEvents that have a value for Risky, and have been processed
            foreach (var ev in biPostEvents.Where(ev => ev.Processed))
            {
                DateTime startTime = DateTime.Now;

                using (IDnaDataReader reader = TheGuideDataReaderCreator.CreateDnaDataReader("riskmod_recordriskmoddecisionforthreadentry"))
                {
                    reader.AddParameter("siteid", ev.SiteId);
                    reader.AddParameter("forumid", ev.ForumId);
                    reader.AddParameter("threadentryid", ev.ThreadEntryId);
                    reader.AddParameter("risky", ev.Risky);
                    reader.Execute();
                }

                BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "RecordRiskModDecisionsOnPost() end", startTime, "SiteId", ev.SiteId, "ForumId", ev.ForumId, "ThreadEntryId", ev.ThreadEntryId, "Risky", ev.Risky);
            }
        }
    }
}
