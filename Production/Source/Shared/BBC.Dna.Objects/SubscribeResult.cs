using BBC.Dna.Data;
namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "SUBSCRIBE-RESULT")]
    [System.Xml.Serialization.XmlRootAttribute("SUBSCRIBE-RESULT", Namespace="", IsNullable=false)]
    public partial class SubscribeResult
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FROMFORUM")]
        public int FromForum
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TOFORUM")]
        public int ToForum
        {
            get;
            set;
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FROMTHREAD")]
        public int FromThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TOTHREAD")]
        public int ToThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "JOURNAL")]
        public int Journal
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FAILED")]
        public int Failed
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        public bool FailedSpecified { get { return this.Failed != 0; } }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        public string Value
        {
            get;
            set;
        }

        /// <summary>
        /// Unsubscribes from journal and returns resulting xml object
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
        /// <param name="forumId"></param>
        /// <returns></returns>
        static public SubscribeResult UnSubscribeFromJournalThread(IDnaDataReaderCreator creator, int userId, int threadId, int forumId)
        {
            SubscribeResult result = new SubscribeResult();
            using (IDnaDataReader reader = creator.CreateDnaDataReader("unsubscribefromjournalthread"))
            {
                reader.AddParameter("userid", userId);
                reader.AddParameter("threadid", threadId);
                reader.AddParameter("forumid", forumId);
                reader.Execute();

                if(reader.HasRows && reader.Read())
                {
                    result.FromThreadId = threadId;
                    result.Journal = 1;
                    int retCode = reader.GetInt32NullAsZero("Result");
                    if (retCode > 0)
                    {
                        result.Failed = retCode;
                        result.Value = reader.GetString("Reason") ?? "";
                    }
                }

            }
            return result;
        }

        /// <summary>
        /// Unsubscribes from journal and returns resulting xml object
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
        /// <param name="forumId"></param>
        /// <returns></returns>
        static public SubscribeResult SubscribeToForum(IDnaDataReaderCreator creator, int userId, int forumId, bool unSubcribe)
        {
            SubscribeResult result = new SubscribeResult();
            string spToCall = string.Empty;
            if (unSubcribe)
            {
                spToCall = "unsubscribefromforum";
                result.FromForum = forumId;
            }
            else
            {
                spToCall = "subscribetoforum";
                result.ToForum = forumId;
            }

            //get permissions
            bool canRead = false;
            bool canWrite = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetForumPermissions(userId, forumId, ref canRead, ref canWrite);

            if (canRead)
            {
                using (IDnaDataReader reader = creator.CreateDnaDataReader(spToCall))
                {
                    reader.AddParameter("userid", userId);
                    reader.AddParameter("forumid", forumId);
                    reader.Execute();
                }
            }
            else
            {
                result.Failed = 3;
                result.Value = "You don't have permission to read this forum";
            }

            
            return result;
        }

        /// <summary>
        /// Unsubscribes from journal and returns resulting xml object
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
        /// <param name="forumId"></param>
        /// <returns></returns>
        static public SubscribeResult SubscribeToThread(IDnaDataReaderCreator creator, int userId, int threadId, int forumId, bool unSubcribe)
        {
            SubscribeResult result = new SubscribeResult();
            string spToCall = string.Empty;
            if (unSubcribe)
            {
                spToCall = "unsubscribefromthread";
                result.FromThreadId = threadId;
            }
            else
            {
                spToCall = "subscribetothread";
                result.ToThreadId = threadId;
            }

            //get permissions
            bool canRead = false;
            bool canWrite = false;
            ForumHelper helper = new ForumHelper(creator);
            helper.GetThreadPermissions(userId, threadId, ref canRead, ref canWrite);

            if (canRead)
            {
                using (IDnaDataReader reader = creator.CreateDnaDataReader(spToCall))
                {
                    reader.AddParameter("userid", userId);
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("forumid", forumId);
                    reader.Execute();
                }
            }
            else
            {
                result.Failed = 5;
                result.Value = "You don't have permission to read this thread";
            }


            return result;
        }
    }
}
