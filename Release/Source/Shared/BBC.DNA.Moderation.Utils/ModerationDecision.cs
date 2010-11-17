using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.DNA.Moderation.Utils
{
    /// <summary>
    /// The various moderation statuses
    /// </summary>
    public enum ModerationDecisionStatus
    {
        /// <summary>
        /// </summary>
        UnDefined = 0,
        AwaitingDecision = 1,
        Referred = 2,
        Passed = 3,
        Fail = 4,
        Edit = 8
    }
}
