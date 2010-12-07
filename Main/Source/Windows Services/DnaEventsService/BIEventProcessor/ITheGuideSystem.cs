using System;
using System.Collections.Generic;

namespace Dna.BIEventSystem
{
    public interface ITheGuideSystem
    {
        List<BIEvent> GetBIEvents();

        void ProcessPostRiskAssessment(BIPostNeedsRiskAssessmentEvent bIPostNeedsRiskAssessmentEvent, bool risky);

        void RecordRiskModDecisionsOnPosts(IEnumerable<BIPostToForumEvent> events);
    }
}
