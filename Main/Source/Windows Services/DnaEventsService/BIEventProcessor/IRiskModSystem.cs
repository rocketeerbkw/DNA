using System;

namespace Dna.BIEventSystem
{
    public interface IRiskModSystem
    {
        bool IsRisky(BIPostNeedsRiskAssessmentEvent ev);
        bool RecordPostToForumEvent(BIPostToForumEvent ev);
        bool RecordPostModerationDecision(BIPostModerationDecisionEvent ev);
    }
}
