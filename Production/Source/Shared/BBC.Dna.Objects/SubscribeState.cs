using BBC.Dna.Data;
namespace BBC.Dna.Objects
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]

    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="SUBSCRIBE-STATE")]
    [System.Xml.Serialization.XmlRootAttribute("SUBSCRIBE-STATE", Namespace="", IsNullable=false)]
    public partial class SubscribeState
    {

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "USERID")]
        public int UserId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FORUMID")]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREADID")]
        public int ThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THREAD")]
        public int Thread
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "LASTPOSTCOUNTREAD")]
        public int LastPostCountRead
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "LASTUSERPOSTID")]
        public int LastUserPostId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FORUM")]
        public int Forum
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlTextAttribute()]
        public string Value
        {
            get;
            set;
        } 
        #endregion

        /// <summary>
        /// Get the thread subscribe state.
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <param name="threadId"></param>
        /// <param name="forumId"></param>
        /// <returns></returns>
        static public SubscribeState GetSubscriptionState(IDnaDataReaderCreator creator, int userId, int threadId, int forumId)
        {
            SubscribeState state = new SubscribeState()
            {
                UserId = userId,
                ThreadId = threadId,
                ForumId = forumId
            };

            if (userId > 0)
            {
                using (IDnaDataReader reader = creator.CreateDnaDataReader("isusersubscribed"))
                {
                    reader.AddParameter("userid", userId);
                    reader.AddParameter("threadid", threadId);
                    reader.AddParameter("forumid", forumId);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        bool threadSubscribed = reader.GetInt32NullAsZero("ThreadSubscribed") == 1;
                        bool forumSubscribed = reader.GetInt32NullAsZero("ForumSubscribed") == 1;
                        int lastPostCountRead = reader.GetInt32NullAsZero("LastPostCountRead");
                        int lastUserPostID = reader.GetInt32NullAsZero("LastUserPostID");

                        state = new SubscribeState()
                        {
                            UserId = userId,
                            ThreadId = threadId,
                            ForumId = forumId
                        };

                        if (threadSubscribed)
                        {
                            state.Thread = 1;
                            state.LastPostCountRead = lastPostCountRead;
                            state.LastUserPostId = lastUserPostID;
                        }
                        else
                        {
                            state.Thread = 0;
                        }
                        if (forumSubscribed)
                        {
                            state.Forum = 1;
                        }
                    }
                }
            }
            return state;
        }
    }
}
