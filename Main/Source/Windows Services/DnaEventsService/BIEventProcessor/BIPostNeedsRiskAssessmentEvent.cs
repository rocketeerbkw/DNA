using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace Dna.BIEventSystem
{
    public class BIPostNeedsRiskAssessmentEvent : BIEvent
    {
        public int? ThreadEntryId { get; private set; }
        public int ModClassId { get; private set; }
        public int SiteId { get; private set; }
        public int ForumId { get; private set; }
        public int ThreadId { get; private set; }
        public int UserId { get; private set; }
        public DateTime DatePosted { get; private set; }
        public string Text { get; private set; }
        public int RiskModThreadEntryQueueId { get; private set; }

        ITheGuideSystem TheGuideSystem { get; set; }
        IRiskModSystem RiskModSys { get; set; }

        public BIPostNeedsRiskAssessmentEvent(ITheGuideSystem srcSystem, IRiskModSystem riskModSys)
        {
            TheGuideSystem = srcSystem;
            RiskModSys = riskModSys;
        }

        protected override void SetProperties(IDnaDataReader reader)
        {
            base.SetProperties(reader);

            ThreadEntryId = reader.GetNullableInt32("ThreadEntryId");
            ModClassId = reader.GetInt32("ModClassId");
            SiteId = reader.GetInt32("SiteId");
            ForumId = reader.GetInt32("ForumId");
            ThreadId = reader.GetInt32("ThreadId");
            UserId = reader.GetInt32("UserId");
            DatePosted = reader.GetDateTime("DatePosted");
            Text = reader.GetString("text");
            RiskModThreadEntryQueueId = reader.GetInt32("RiskModThreadEntryQueueId");
        }

        public override void Process()
        {
            bool risky = RiskModSys.IsRisky(this);
            TheGuideSystem.ProcessPostRiskAssessment(this, risky);
            Processed = true;
        }
    }
}
