using BBC.Dna.Data;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "SUBSCRIBE-RESULT")]
    [System.Xml.Serialization.XmlRootAttribute("SUBSCRIBE-RESULT", Namespace="", IsNullable=false)]
    [DataContract(Name = "subscribeResult")]
    public partial class SubscribeResult
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FROMFORUM")]
        [DataMember(Name = "fromForum", Order=1)]
        public int FromForum
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TOFORUM")]
        [DataMember(Name = "toForum", Order = 2)]
        public int ToForum
        {
            get;
            set;
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FROMTHREAD")]
        [DataMember(Name = "fromThreadId", Order = 3)]
        public int FromThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TOTHREAD")]
        [DataMember(Name = "toThreadId", Order = 4)]
        public int ToThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "JOURNAL")]
        [DataMember(Name = "journal", Order = 5)]
        public int Journal
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FAILED")]
        [DataMember(Name = "failed", Order = 6)]
        public int Failed
        {
            get;
            set;
        }

        [System.Xml.Serialization.XmlIgnore]
        [IgnoreDataMember]
        public bool FailedSpecified 
        {   
            get { return this.Failed != 0; }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        [DataMember(Name = "value", Order = 7)]
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
