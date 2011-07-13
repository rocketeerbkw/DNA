using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Moderation
{
    public enum SiteActivityType
    {
        ModeratePostFailed = 1,
        ModeratePostReferred = 2,
        ModerateArticleFailed = 3,
        ModerateArticleReferred = 4,
        ModerateExLinkFailed = 5,
        ModerateExlinkReferred = 6,
        ComplaintPost = 7,
        ComplaintArticle = 8,
        ComplaintExlink = 9,
        UserModeratedPremod = 10,
        UserModeratedPostMod =11,
        UserModeratedBanned = 12,
        UserModeratedDeactivated = 13,
        NewUserToSite = 14,
        SiteSummary = 15,
        UserModeratedStandard = 16,
        UserPost = 17,
        ComplaintPostUpHeld = 18,
        ComplaintPostRejected = 19,
        UserModeratedTrusted = 20
    }
}
