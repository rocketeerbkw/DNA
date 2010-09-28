using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Moderation.Utils
{
    

    static public class CommentStatus
    {
        /// <summary>
        /// These are the moderation status' for a forum. Note unknown means refer to 
        /// </summary>
        public enum Hidden : int
        {
            /// <summary>
            /// Not hidden
            /// </summary>
            NotHidden = 0,
            /// <summary>
            /// removed due to fail in moderation
            /// </summary>
            Removed_FailedModeration = 1,
            /// <summary>
            /// Awaiting moderation referral
            /// </summary>
            Hidden_AwaitingReferral = 2,
            /// <summary>
            /// Awaiting pre moderation
            /// </summary>
            Hidden_AwaitingPreModeration = 3,
            /// <summary>
            /// Removed - Forum/Thread removed
            /// </summary>
            Removed_ForumRemoved = 5,
            /// <summary>
            /// Removed - editor complaint takedown
            /// </summary>
            Removed_EditorComplaintTakedown = 6,

            /// <summary>
            /// Removed - user deleted
            /// </summary>
            Removed_UserDeleted = 7,

            /// <summary>
            /// Removed - user content removed - probably spammer
            /// </summary>
            Removed_UserContentRemoved = 8,

        };
    }

}
