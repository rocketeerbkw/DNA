using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using BBC.Dna.Data;

namespace BBC.Dna.Moderation.Utils
{

    [Serializable]
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
        [Serializable]
        public enum UserStatus
        {
            /// <summary>
            /// 
            /// </summary>
            Standard=0,
            /// <summary>
            /// 
            /// </summary>
            Premoderated=1,
            /// <summary>
            /// 
            /// </summary>
            Postmoderated=2,
            /// <summary>
            /// 
            /// </summary>
            SendForReview=3,
            /// <summary>
            /// 
            /// </summary>
            Restricted=4,
            /// <summary>
            /// 
            /// </summary>
            Deactivated=5,
            /// <summary>
            /// 
            /// </summary>
            Trusted = 6

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
        /// Function to update the moderation statuses of a list of member list accounts
        /// </summary>
        /// <param name="userIDList">List of User ID to update with the new moderation status</param>
        /// <param name="siteIDList">List of Site ID to update with the new moderation status</param>
        /// <param name="newPrefStatus">The value of the new moderation status</param>
        /// <param name="newPrefStatusDuration">The value of the duration of the new moderation status</param>
        /// <param name="reason">reason for changes</param>
        public static void UpdateModerationStatuses(IDnaDataReaderCreator readerCreator, List<int> userIDList,
            List<int> siteIDList, int newPrefStatus, int newPrefStatusDuration, string reason, int viewingUser)
        {
            //New function to take lists of users and sites
            string userIDs = @"";
            string siteIDs = @"";
            foreach (int userID in userIDList)
            {
                userIDs += userID.ToString();
                userIDs += "|";
            }
            //Remove the last one
            userIDs = userIDs.TrimEnd('|');

            foreach (int siteID in siteIDList)
            {
                siteIDs += siteID.ToString();
                siteIDs += "|";
            }
            //Remove the last one
            siteIDs = siteIDs.TrimEnd('|');
            //Set all the user id and siteid pairs to the passed in Status and duration
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("updatetrackedmemberlist"))
            {
                dataReader.AddParameter("userIDs", userIDs);
                dataReader.AddParameter("siteIDs", siteIDs);
                dataReader.AddParameter("prefstatus", newPrefStatus);
                dataReader.AddParameter("prefstatusduration", newPrefStatusDuration);
                dataReader.AddParameter("reason", reason);
                dataReader.AddParameter("viewinguser", viewingUser);

                dataReader.Execute();
            }
        }

        /// <summary>
        /// Deactivates account and optionally removes all content
        /// </summary>
        /// <param name="userIDList"></param>
        /// <param name="hideAllPosts"></param>
        /// <param name="reason"></param>
        public static bool DeactivateAccount(IDnaDataReaderCreator readerCreator, List<int> userIDList,
            bool hideAllPosts, string reason, int viewingUser)
        {
            foreach (int userId in userIDList)
            {
                using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("deactivateaccount"))
                {
                    dataReader.AddParameter("userid", userId);
                    dataReader.AddParameter("hidecontent", hideAllPosts ? 1 : 0);
                    dataReader.AddParameter("reason", reason);
                    dataReader.AddParameter("viewinguser", viewingUser); 

                    dataReader.Execute();
                }
            }
            return true;
        }

        /// <summary>
        /// Activates accounts
        /// </summary>
        /// <param name="userIDList"></param>
        /// <param name="reason"></param>
        public static bool ReactivateAccount(IDnaDataReaderCreator readerCreator, List<int> userIDList,
            string reason, int viewingUser)
        {
            foreach (int userId in userIDList)
            {
                using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("reactivateaccount"))
                {
                    dataReader.AddParameter("userid", userId);
                    dataReader.AddParameter("reason", reason);
                        dataReader.AddParameter("viewinguser", viewingUser);

                    dataReader.Execute();
                }
            }
            return true;
        }
    }

}
