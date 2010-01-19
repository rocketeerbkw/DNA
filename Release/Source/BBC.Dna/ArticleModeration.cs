using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// Article moderation class
    /// </summary>
    public class ArticleModeration
    {
        /// <summary>
        /// Default Article moderation constructor
        /// </summary>
        /// <param name="appContext">An app context so that the class can use stored procedures</param>
        public ArticleModeration(IAppContext appContext)
        {
            _appContext = appContext;
        }

        private IAppContext _appContext = null;

        /// <summary>
        /// The various moderation statuses
        /// </summary>
        public enum ArticleModerationStatus
        {
            /// <summary>
            /// Undefined moderation status
            /// </summary>
            UnDefined = 0,
            /// <summary>
            /// Unmoderated status
            /// </summary>
            UnModerated = 1,
            /// <summary>
            /// Post moderated status
            /// </summary>
            PostModerated = 2,
            /// <summary>
            /// Pre moderated status
            /// </summary>
            PreModerated = 3
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

        /// <summary>
        /// Checks to see if the article needs to be placed in the moderation system
        /// </summary>
        /// <param name="articleOwner">The user who owns the article.</param>
        /// <param name="site">The site that the article was created in</param>
        /// <param name="h2g2ID">The h2g2id of the article you want to moderate</param>
        /// <param name="profanitiesFound">A flag that states whether or not a profanity was found</param>
        /// <returns>True if the article was placed in the moderation queue, False if not</returns>
        public bool ModerateArticle(IUser articleOwner, ISite site, int h2g2ID, bool profanitiesFound)
        {
            // Check to see if the user is immune from moderation
            if (!articleOwner.HasSpecialEditPermissions(h2g2ID))
            {
                // Now do some simple checks on the site and user
                bool siteModerated = (int)site.ModerationStatus > 1;
                bool userModerated = articleOwner.IsPreModerated;
                bool userInSinBin = articleOwner.IsAutoSinBin;
                bool articleModerated = IsArticleModerated(h2g2ID);

                // If anything came back as being moderated, then queue the article for moderation
                if (siteModerated || userInSinBin || userModerated || articleModerated || profanitiesFound)
                {
                    // Queue the article for moderation
                    using (IDnaDataReader reader = _appContext.CreateDnaDataReader("QueueArticleForModeration"))
                    {
                        // Check to see what triggered the moderation
                        int triggerID = (int)ModerationTriggers.Automatic;
                        if (profanitiesFound)
                        {
                            triggerID = (int)ModerationTriggers.Profanities;
                        }

                        // Create the notes for the moderation decision
                        string notes = "Created/Edited by user U" + articleOwner.UserID.ToString();

                        // Add the article to the queue
                        reader.AddParameter("h2g2ID", h2g2ID);
                        reader.AddParameter("TriggerID", triggerID);
                        reader.AddParameter("TriggeredBy", articleOwner.UserID);
                        reader.AddParameter("Notes", notes);
                        reader.AddIntOutputParameter("ModID");
                        reader.Execute();
                        while (reader.Read()) { }

                        // Get the new mod id for the article
                        int modID = 0;
                        reader.TryGetIntOutputParameter("ModeID", out modID);
                    }

                    // Article was moderated
                    return true;
                }
            }

            // Article was not moderated
            return false;
        }

        /// <summary>
        /// Checks to see if the article is currently moderated
        /// </summary>
        /// <param name="h2g2ID">The h2g2ID of the article you want to check against</param>
        /// <returns>True if the article is in pre/post moderated or we failed to find the status,
        /// False if the article is unmoderated</returns>
        public bool IsArticleModerated(int h2g2ID)
        {
            // Get the status
            ArticleModerationStatus status = GetArticleModerationStatus(h2g2ID);
            if (status == ArticleModerationStatus.UnModerated)
            {
                // Article not moderated
                return false;
            }

            // Article moderated
            return true;
        }

        /// <summary>
        /// Gets the current moderation status for a given article
        /// </summary>
        /// <param name="h2g2ID">The h2g2 id of the article you want to check against</param>
        public ArticleModerationStatus GetArticleModerationStatus(int h2g2ID)
        {
            using (IDnaDataReader reader = _appContext.CreateDnaDataReader("getarticlemoderationstatus"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.Execute();
                if (reader.Read() && reader.HasRows)
                {
                    int moderationStatus = reader.GetInt32("ModerationStatus");
                    if (moderationStatus == 1)
                    {
                        return ArticleModerationStatus.UnModerated;
                    }
                    else if (moderationStatus == 2)
                    {
                        return ArticleModerationStatus.PostModerated;
                    }
                    else if (moderationStatus == 3)
                    {
                        return ArticleModerationStatus.PreModerated;
                    }
                }
            }

            // If we got here, we don't know the moderation status!
            return ArticleModerationStatus.UnDefined;
        }
    }
}
