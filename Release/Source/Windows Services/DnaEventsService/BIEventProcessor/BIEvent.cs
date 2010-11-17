using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace Dna.BIEventSystem
{
    public abstract class BIEvent
    {
        public EventTypes   EventType                   { get; private set; }
        public int          EventId                     { get; private set; }
        public DateTime     EventDate                   { get; private set; }

        public bool Processed { get; protected set; }

        public BIEvent()
        {
            Processed = false;
        }

        public abstract void Process();

        protected virtual void SetProperties(IDnaDataReader reader)
        {
            EventId   = reader.GetInt32("EventId");
            EventType = (EventTypes)reader.GetInt32("EventType");
            EventDate = reader.GetDateTime("EventDate");
        }

        public static BIEvent CreateBiEvent(IDnaDataReader reader, ITheGuideSystem theGuideSys, IRiskModSystem riskModSys)
        {
            EventTypes et = (EventTypes)reader.GetInt32("EventType");
            
            BIEvent be = null;

            switch (et)
            {
                case EventTypes.ET_POSTNEEDSRISKASSESSMENT: be = new BIPostNeedsRiskAssessmentEvent(theGuideSys, riskModSys); break;
                case EventTypes.ET_POSTTOFORUM:             be = new BIPostToForumEvent(riskModSys); break;
                case EventTypes.ET_MODERATIONDECISION_POST: be = new BIPostModerationDecisionEvent(riskModSys); break;

                default: throw new InvalidOperationException("Event Type " + et.ToString() + " not supported");
            }

            be.SetProperties(reader);

            return be;
        }   
    }
}
