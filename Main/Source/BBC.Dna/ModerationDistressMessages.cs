using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// Moderation Distress Messages - Used by moderators to post preconfigured messages.
    /// eg If you are thinking about ... contact the Samaritins.
    /// </summary>
    public class ModerationDistressMessages : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerationDistressMessages(IInputContext context)
            : base(context)
        { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="distressMessageId"></param>
        /// <param name="siteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <returns></returns>
        public bool PostDistressMessage(int distressMessageId, int siteId, int forumId, int threadId, int postId)
        {
            Forum f = new Forum(InputContext);
            int userId = InputContext.CurrentSite.AutoMessageUserID;

            String body = String.Empty;
            String subject = String.Empty;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("moderationgetdistressmessage"))
            {
                dataReader.AddParameter("id", distressMessageId);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    subject = dataReader.GetStringNullAsEmpty("subject");
                    body = dataReader.GetStringNullAsEmpty("text");
                }
            }

            int newPostId = 0;
            bool isQueued, isPreModPosting, isPreModerated;
            if (subject != String.Empty && body != String.Empty)
            {
                f.PostToForum(userId, forumId, ref threadId, postId, subject, body, 0, true, out newPostId, out isQueued, out isPreModPosting, out isPreModerated);
                using (var reader = InputContext.CreateDnaDataReader("insertdistressmessage"))
                {
                    reader.AddParameter("parentid", postId);
                    reader.AddParameter("distressmessageid", newPostId);

                    try
                    {
                        reader.Execute();
                    }
                    catch (Exception ex)
                    {
                        var blah = ex.Message;
                    }
                }

            }

            return newPostId != 0;
        }

        /// <summary>
        /// Get all moderation distress messages
        /// </summary>
        public override void ProcessRequest()
        {
            GenerateXml(0);
        }

        /// <summary>
        /// Get Moderation Distress Messsages gor the given moderation class.
        /// </summary>
        /// <param name="modClassId"></param>
        public XmlElement GenerateXml( int modClassId )
        {
            XmlElement distressMessages = AddElementTag(RootElement, "DISTRESSMESSAGES");
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("moderationgetdistressmessages"))
            {
                if (modClassId > 0)
                {
                    dataReader.AddParameter("modclassid", modClassId);
                    AddAttribute(distressMessages, "MODCLASSID", modClassId);
                }
                dataReader.Execute();

                while (dataReader.Read())
                {
                    XmlElement distressMessage =  AddElementTag(distressMessages, "DISTRESSMESSAGE");
                    AddAttribute(distressMessage, "ID", dataReader.GetInt32NullAsZero("messageid"));
                    AddIntElement(distressMessage, "MODCLASSID", dataReader.GetInt32NullAsZero("modclassid"));
                    AddTextTag(distressMessage, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));
                    AddTextTag(distressMessage, "TEXT", dataReader.GetStringNullAsEmpty("text"));
                }
            }
            return distressMessages;
        }
    }
}
