using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace Dna.BIEventSystem
{
    public class BIPostModerationDecisionEvent : BIEvent
    {
        public int ThreadEntryId { get; private set; }
        public int ModDecisionStatus { get; private set; }
        public bool IsComplaint { get; private set; }

        IRiskModSystem RiskModSys { get; set; }

        public BIPostModerationDecisionEvent(IRiskModSystem riskModSys)
        {
            RiskModSys = riskModSys;
        }

        protected override void SetProperties(IDnaDataReader reader)
        {
            base.SetProperties(reader);

            ThreadEntryId = reader.GetInt32("ThreadEntryId");
            ModDecisionStatus = reader.GetInt32("ModDecisionStatus");
            IsComplaint = reader.GetBoolean("IsComplaint");
        }

        public override void Process()
        {
            if (RiskModSys.RecordPostModerationDecision(this))
                Processed = true;
        }

    }
}
