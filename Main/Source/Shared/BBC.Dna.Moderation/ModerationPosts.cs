using System.Xml.Serialization;
using BBC.Dna.Data;
using System;
using BBC.Dna.Utils;
using System.Collections.Generic;
namespace BBC.Dna.Moderation
{

    /// <summary>
    /// 
    /// </summary>
    public enum ModerationItemStatus
    {
        /// <summary>
        /// 
        /// </summary>
        Unlocked = 0,
        /// <summary>
        /// 
        /// </summary>
        Refer = 2,
        /// <summary>
        /// 
        /// </summary>
        Passed = 3,
        /// <summary>
        /// 
        /// </summary>
        Failed = 4,

        // FailedWithEdit = 6,

        /// <summary>
        /// 
        /// </summary>
        PassedWithEdit = 8
    }

    public class ModerationPosts
    {
        

        /// <summary>
        /// Registers complaint against post
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="complaintText"></param>
        /// <param name="email"></param>
        /// <param name="postId"></param>
        /// <param name="verificationUid"></param>
        /// <param name="modId"></param>
        public static void RegisterComplaint(IDnaDataReaderCreator creator, int userId, String complaintText, 
            String email, int postId, string ipAddress, Guid bbcUid, out Guid verificationUid, out int modId)
        {
            verificationUid = Guid.Empty;
            modId = 0;
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("registerpostingcomplaint"))
            {
                dataReader.AddParameter("complainantid", userId);
                dataReader.AddParameter("correspondenceemail", email);
                dataReader.AddParameter("postid", postId);
                dataReader.AddParameter("complainttext", complaintText);
                dataReader.AddParameter("ipaddress", ipAddress);
                dataReader.AddParameter("bbcuid", bbcUid);

                //HashValue
                Guid hash = DnaHasher.GenerateHash(Convert.ToString(userId) + ":" + email + ":" + Convert.ToString(postId) + ":" + complaintText);
                dataReader.AddParameter("hash", hash);
                dataReader.Execute();

                // Send Email

                if (dataReader.Read())
                {
                    if (dataReader.DoesFieldExist("modId"))
                    {
                        modId = dataReader.GetInt32NullAsZero("modId");
                    }
                    if (dataReader.DoesFieldExist("verificationUid"))
                    {
                        verificationUid = dataReader.GetGuid("verificationUid");

                    }
                }
            }
        }


        public static void ApplyModerationDecision(IDnaDataReaderCreator creator, int forumId, ref int threadId,
            ref int postId, int modId, ModerationItemStatus decision, String notes, int referId, int threadModStatus, 
            String emailType, out Queue<String> complainantEmails, out Queue<int> complainantIds, 
            out Queue<int> modIds, out String authorEmail, out int authorId, int modUserId)
        {
            complainantEmails = new Queue<string>();
            complainantIds = new Queue<int>();
            modIds = new Queue<int>();
            authorEmail = "";
            authorId = 0;
            int processed = 0;

            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("moderatepost"))
            {
                dataReader.AddParameter("forumid", forumId);
                dataReader.AddParameter("threadid", threadId);
                dataReader.AddParameter("postid", postId);
                dataReader.AddParameter("modid", modId);
                dataReader.AddParameter("status", (int)decision);
                dataReader.AddParameter("notes", notes);
                dataReader.AddParameter("referto", referId);
                dataReader.AddParameter("referredby", modUserId);
                dataReader.AddParameter("moderationstatus", threadModStatus);
                dataReader.AddParameter("emailType", emailType);

                dataReader.Execute();

                while (dataReader.Read())
                {
                    authorEmail = dataReader.GetStringNullAsEmpty("authorsemail");
                    authorId = dataReader.GetInt32NullAsZero("authorid");
                    processed = dataReader.GetInt32NullAsZero("processed");
                    String complainantEmail = dataReader.GetStringNullAsEmpty("complaintsemail");
                    complainantEmails.Enqueue(complainantEmail);
                    complainantIds.Enqueue(dataReader.GetInt32NullAsZero("complainantId"));
                    modIds.Enqueue(dataReader.GetInt32NullAsZero("modid"));
                    postId = dataReader.GetInt32NullAsZero("postid");
                    threadId = dataReader.GetInt32NullAsZero("threadid");
                }
            }
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="postId"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="hide"></param>
        /// <param name="ignoreModeration"></param>
        public static void EditPost(IDnaDataReaderCreator creator, int userId, int postId, String subject, String body, bool hide, bool ignoreModeration)
        {
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("updatepostdetails"))
            {
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("postid", postId);
                dataReader.AddParameter("subject", subject);
                dataReader.AddParameter("text", body);
                dataReader.AddParameter("setlastupdated", true);
                dataReader.AddParameter("forcemoderateandhide", hide);
                dataReader.AddParameter("ignoremoderation", ignoreModeration);

                dataReader.Execute();
            }

        }


    }
}
