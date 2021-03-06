﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using DnaEventService.Common;
using System.Data.SqlClient;
using System.Diagnostics;

namespace Dna.BIEventSystem
{
    public class RiskModSystem : IRiskModSystem
    {
        private IDnaDataReaderCreator RiskModDataReaderCreator { get; set; }

        /// <summary>
        /// Set this to true to disable the RiskMod system
        /// When true, the methods will make appropriate decisions in the absence of an underlying RiskMod system
        /// </summary>
        private bool Disabled { get; set; }

        public RiskModSystem(IDnaDataReaderCreator riskModDataReaderCreator, bool disableRiskMod)
        {
            RiskModDataReaderCreator = riskModDataReaderCreator;
            Disabled = disableRiskMod;
        }

        public bool IsRisky(BIPostNeedsRiskAssessmentEvent ev)
        {
            // When disabled, always assume it's risky
            if (Disabled)
                return true;

            try
            {
                DateTime startTime = DateTime.Now;

                using (IDnaDataReader reader = RiskModDataReaderCreator.CreateDnaDataReader("predict_withoutentryid"))
                {
                    reader.AddParameter("isArticle", 0);
                    reader.AddParameter("ModClassId", ev.ModClassId);
                    reader.AddParameter("SiteID", ev.SiteId);
                    reader.AddParameter("ForumId", ev.ForumId);
                    reader.AddParameter("ThreadID", ev.ThreadId);
                    reader.AddParameter("UserID", ev.UserId);
                    reader.AddParameter("DatePosted", ev.DatePosted);
                    reader.AddParameter("text", ev.Text);
                    reader.AddIntOutputParameter("moderation");
                    reader.AddIntReturnValue();
                    reader.Execute();

                    int moderationResult = reader.GetIntReturnValue();

                    BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "IsRisky() end", startTime, "RiskModThreadEntryQueueId", ev.RiskModThreadEntryQueueId, "Result", moderationResult);

                    return moderationResult > 0;
                }
            }
            catch (Exception ex)
            {
                // If there is a problem getting a risk assessment, assume it's risky
                BIEventProcessor.BIEventLogger.LogException(ex);
                return true;
            }
        }

        public bool RecordPostToForumEvent(BIPostToForumEvent ev, out bool? risky)
        {
            risky = null;

            // When disabled, don't record this event
            if (Disabled)
                return false;

            DateTime startTime = DateTime.Now;

            using (IDnaDataReader reader = RiskModDataReaderCreator.CreateDnaDataReader("predict"))
            {
                reader.AddParameter("EntryId", ev.ThreadEntryId);
                reader.AddParameter("isArticle", 0);
                reader.AddParameter("ModClassId", ev.ModClassId);
                reader.AddParameter("SiteID", ev.SiteId);
                reader.AddParameter("ForumId", ev.ForumId);
                reader.AddParameter("ThreadID", ev.ThreadId);
                reader.AddParameter("UserID", ev.UserId);
                reader.AddParameter("NextSibling", ev.NextSibling);
                reader.AddParameter("Parent", ev.Parent);
                reader.AddParameter("PrevSibling", ev.PrevSibling);
                reader.AddParameter("FirstChild", ev.FirstChild);
                reader.AddParameter("DatePosted", ev.DatePosted);
                reader.AddParameter("text", ev.Text);
                reader.AddIntOutputParameter("moderation");
                reader.Execute();

                int? moderationResult = reader.GetNullableIntOutputParameter("moderation");

                BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "RecordPostToForumEvent() end", startTime, "ThreadEntryId", ev.ThreadEntryId, "ModerationResult", moderationResult);

                if (moderationResult.HasValue)
                    risky = moderationResult > 0;
                else
                    risky = null;
            }

            return true;
        }

        public bool RecordPostModerationDecision(BIPostModerationDecisionEvent ev)
        {
            // When disabled, don't record this event
            if (Disabled)
                return false;

            DateTime startTime = DateTime.Now;

            using (IDnaDataReader reader = RiskModDataReaderCreator.CreateDnaDataReader("moderation"))
            {
                reader.AddParameter("EntryId", ev.ThreadEntryId);
                reader.AddParameter("isArticle", 0);
                reader.AddParameter("Status", ev.ModDecisionStatus);
                reader.AddParameter("isComplain", ev.IsComplaint);
                reader.AddParameter("DateStatusChanged", ev.EventDate);
                reader.Execute();
            }

            var props = new Dictionary<string, object>() 
            { 
                { "ThreadEntryId", ev.ThreadEntryId },
                { "Status",  ev.ModDecisionStatus },
                { "isComplaint", ev.IsComplaint},
                { "DateStatusChanged",ev.EventDate }
            };
            BIEventProcessor.BIEventLogger.Log(TraceEventType.Verbose, "RecordPostModerationDecision() end", startTime, props);

            return true;
        }
    }
}
