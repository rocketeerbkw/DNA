using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Moderation.Utils
{
    

    public class ModerationStatus
    {
        /// <summary>
        /// These are the moderation status' for a forum. Note unknown means refer to 
        /// </summary>
        public enum ForumStatus : int
        {
            /// <summary>
            /// not set for a forum so refer to site
            /// </summary>
            Unknown = 0,
            /// <summary>
            /// Is reactive and unmoderated
            /// </summary>
            Reactive = 1,
            /// <summary>
            /// Is post moderated
            /// </summary>
            PostMod = 2,
            /// <summary>
            /// Is per moderated
            /// </summary>
            PreMod = 3

        };

        /// <summary>
        /// These are the site level moderation flags
        /// </summary>
        public enum SiteStatus : int
        {
            /// <summary>
            /// Unmoderated - no moderation completed
            /// </summary>
            UnMod = 0,
            /// <summary>
            /// All posts are moderated but after they are shown
            /// </summary>
            PostMod = 1,
            /// <summary>
            /// All posts are moderated before being shown
            /// </summary>
            PreMod = 2

        };

        public enum NicknameStatus
        {
            /// <summary>
            /// Unmoderated - no moderation completed
            /// </summary>
            UnMod = 0,
            /// <summary>
            /// Nickname changes are postmoderated.
            /// </summary>
            PostMod = 1,
            /// <summary>
            /// Nickname changes are premoderated
            /// </summary>
            PreMod = 2
        }

        public enum ArticleStatus : int
        {

            Undefined = 0,

            UnMod = 1,

            PostMod = 2,

            PreMod = 3
        }

        /// <summary>
        /// User Moderation Statuses.
        /// </summary>
        public enum UserStatus
        {
            /// <summary>
            /// 
            /// </summary>
            Standard,
            /// <summary>
            /// 
            /// </summary>
            Premoderated,
            /// <summary>
            /// 
            /// </summary>
            Postmoderated,
            /// <summary>
            /// 
            /// </summary>
            SendForReview,
            /// <summary>
            /// 
            /// </summary>
            Restricted
        }

        /// <summary>
        /// The various moderation triggers
        /// </summary>
        public enum ModerationTriggers
        {
            /// <summary>
            /// Triggered by unknown user
            /// </summary>
            ByNoUser = 0,
            /// <summary>
            /// Triggered by profanities
            /// </summary>
            Profanities = 2,
            /// <summary>
            /// Triggered by automatic
            /// </summary>
            Automatic = 3
        }
    }

}
