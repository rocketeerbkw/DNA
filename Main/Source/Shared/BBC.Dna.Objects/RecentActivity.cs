using System.Xml.Serialization;
using BBC.Dna.Objects;
using System.Xml;
using System.Runtime.Serialization;
using System;
using BBC.Dna.Data;
using System.Collections.Generic;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = false, TypeName = "RECENTACTIVITY")]
    [XmlRootAttribute("RECENTACTIVITY", Namespace="", IsNullable=false)]
    [DataContract(Name="recentAcivity")]
    public class RecentActivity : CachableBase<RecentActivity>
    {
        public RecentActivity()
        {
            MostRecentConversations = new TopFiveForums();
            MostRecentArticles = new TopFiveArticles();
            MostRecentUserArticles = new TopFiveArticles();
            MostRecentUpdatedArticles = new TopFiveArticles();
        }
        
        /// <summary>
        /// Gets the TopFive for the current site. If a valid cached version is available, that is returned instead of getting it from the database
        /// </summary>
        /// <param name="siteID">The site you want to get the top fives for</param>
        /// <param name="readerCreator">DateReaderCreator to create database readers</param>
        /// <param name="diagnostics">The diagnostics object for writing to the logs</param>
        /// <param name="cache">The current cache manager for the application</param>
        /// <returns>The TopFives object for the given site</returns>
        static public RecentActivity GetSiteRecentActivity(int siteID, IDnaDataReaderCreator readerCreator, IDnaDiagnostics diagnostics, ICacheManager cache)
        {
            RecentActivity recentAcivity = new RecentActivity();
            string cacheKey = recentAcivity.GetCacheKey(siteID);
            var cachedRecentActivity = (CachableBase<RecentActivity>)cache.GetData(cacheKey);
            if (cachedRecentActivity == null || !cachedRecentActivity.IsUpToDate(null))
            {
                recentAcivity.GetRecentActivityForSite(siteID, readerCreator, diagnostics);
                cache.Add(cacheKey, recentAcivity.Clone());
            }
            else
            {
                recentAcivity = (RecentActivity)cachedRecentActivity;
            }

            return recentAcivity;
        }

        /// <summary>
        /// Checks the current object to see if it's still valid to use
        /// </summary>
        /// <param name="readerCreator">A data reader creator to perform database requests</param>
        /// <returns>True if it is, false if not</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return CacheExpireryDate > DateTime.Now;
        }

        /// <summary>
        /// Gets the top fives for a given site
        /// </summary>
        /// <param name="siteID">Id of the site you want to get the top fives for</param>
        /// <param name="readerCreator">Data reader creator</param>
        /// <param name="diagnostics">The Diagnostics object for writing to the output logs</param>
        public void GetRecentActivityForSite(int siteID, IDnaDataReaderCreator readerCreator, IDnaDiagnostics diagnostics)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("gettopfives2"))
            {
                try
                {
                    reader.AddParameter("siteid", siteID);
                    reader.Execute();
                    bool moreRows = reader.Read();

                    while (moreRows)
                    {
                    
                        if (!reader.IsDBNull("h2g2id"))
                        {
                            moreRows = AddArticles(reader);
                        }
                        else if (!reader.IsDBNull("forumid"))
                        {
                            moreRows = AddForums(reader);
                        }
                        else
                        {
                            moreRows = reader.Read();
                        }
                    }
                }
                catch (Exception ex)
                {
                    diagnostics.WriteExceptionToLog(ex);
                }
                CacheExpireryDate = DateTime.Now.AddMinutes(5);
            }
        }

        /// <summary>
        /// Creates and adds the current top five article to the topfives
        /// </summary>
        /// <param name="reader">The data reader that holds the information</param>
        private bool AddArticles(IDnaDataReader reader)
        {
            TopFiveArticles tempList = new TopFiveArticles();
            var groupName = reader.GetStringNullAsEmpty("groupname");
            switch (groupName.ToUpper())
            {
                case "MOSTRECENT":
                    tempList = MostRecentArticles; break;

                case "MOSTRECENTUSER":
                    tempList = MostRecentUserArticles; break;

                case "UPDATED":
                    tempList = MostRecentUpdatedArticles; break;
            }

            tempList.Name = groupName;
            tempList.Title = reader.GetStringNullAsEmpty("groupdescription");


            TopFiveArticle topFiveArticle = null;
            bool moreRows = true;

            while (moreRows && tempList.Name == reader.GetStringNullAsEmpty("groupname"))
            {
                topFiveArticle = new TopFiveArticle();
                

                topFiveArticle.DateUpdated.Date = new Date(reader.GetDateTime("dateupdated"));
                if (!reader.IsDBNull("eventdate"))
                {
                    topFiveArticle.EventDate.Date = new Date(reader.GetDateTime("eventdate"));
                }

                topFiveArticle.Type = (Article.ArticleType)Enum.Parse(typeof(Article.ArticleType), reader.GetInt32NullAsZero("type").ToString());
                topFiveArticle.H2G2ID = reader.GetInt32NullAsZero("h2g2id");
                topFiveArticle.LinkItemID = reader.GetInt32NullAsZero("linkitemid");
                topFiveArticle.LinkItemName = reader.GetStringNullAsEmpty("linkitemname");
                topFiveArticle.LinkItemType = reader.GetInt32NullAsZero("linkitemtype");
                topFiveArticle.Subject = reader.GetStringNullAsEmpty("subject");
                topFiveArticle.User.UserId = reader.GetInt32NullAsZero("itemauthorid");
                topFiveArticle.User.UserName = reader.GetStringNullAsEmpty("username");
                topFiveArticle.User.SiteSuffix = reader.GetStringNullAsEmpty("sitesuffix");

                tempList.topFiveArticleList.Add(topFiveArticle);
                moreRows = reader.Read();
            }

            return moreRows;
        }

        /// <summary>
        /// Creates and adds the current top five forum to the topfives
        /// </summary>
        /// <param name="reader">The data reader that holds the information</param>
        private bool AddForums(IDnaDataReader reader)
        {
            MostRecentConversations.Name = reader.GetStringNullAsEmpty("groupname");
            MostRecentConversations.Title = reader.GetStringNullAsEmpty("groupdescription");

            TopFiveForum topFiveForum = null;
            bool moreRows = true;

            while (moreRows && MostRecentConversations.Name == reader.GetStringNullAsEmpty("groupname"))
            {
                topFiveForum = new TopFiveForum();
                

                topFiveForum.ForumID = reader.GetInt32NullAsZero("forumid");
                topFiveForum.Subject = ThreadPost.FormatSubject(reader.GetStringNullAsEmpty("title"), BBC.Dna.Moderation.Utils.CommentStatus.Hidden.NotHidden);
                topFiveForum.ThreadID = reader.GetInt32NullAsZero("threadid");

                MostRecentConversations.topFiveForumList.Add(topFiveForum);
                moreRows = reader.Read();
            }

            return moreRows;
        }

        /// <remarks/>
        [XmlElementAttribute("MOSTRECENTARTICLES", Order = 0)]
        [DataMember(Name="mostRecentArticles")]
        public TopFiveArticles MostRecentArticles
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("MOSTRECENTUSERARTICLES", Order = 1)]
        [DataMember(Name = "mostRecentUserArticles")]
        public TopFiveArticles MostRecentUserArticles
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("MOSTRECENTUPDATEDARTICLES", Order = 2)]
        [DataMember(Name = "mostRecentUpdatedArticles")]
        public TopFiveArticles MostRecentUpdatedArticles
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("MOSTRECENTCONVERSATIONS", Order = 3)]
        [DataMember(Name = "mostRecentConversations")]
        public TopFiveForums MostRecentConversations
        {
            get;
            set;
        }

        [XmlIgnore]
        public DateTime CacheExpireryDate
        {
            get;
            set;
        }

    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [DataContract]
    public class TopFiveBase
    {
        /// <remarks/>
        [XmlElementAttribute("TITLE", Order = 0)]
        [DataMember(Name = "title")]
        public string Title
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute("NAME")]
        [DataMember(Name = "name")]
        public string Name
        {
            get;
            set;
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [DataContract(Name="forumList")]
    public class TopFiveForums : TopFiveBase
    {
        public TopFiveForums()
        {
            topFiveForumList = new List<TopFiveForum>();
        }
        
        /// <remarks/>
        [XmlElementAttribute("FORUM", Order = 1)]
        [DataMember(Name="forums")]
        public System.Collections.Generic.List<TopFiveForum> topFiveForumList
        {
            get;
            set;
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [DataContract(Name = "articles")]
    public class TopFiveArticles : TopFiveBase
    {
        public TopFiveArticles()
        {
            topFiveArticleList = new List<TopFiveArticle>();
        }

        /// <remarks/>
        [XmlElementAttribute("ARTICLE", Order = 1)]
        [DataMember(Name = "articles")]
        public System.Collections.Generic.List<TopFiveArticle> topFiveArticleList
        {
            get;
            set;
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true)]
    [DataContract(Name="forum")]
    public class TopFiveForum
    {
        /// <remarks/>
        [XmlElementAttribute("FORUMID", Order = 0)]
        [DataMember(Name="forumId")]
        public int ForumID
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("THREADID", Order = 1)]
        [DataMember(Name = "threadID")]
        public int ThreadID
        {
            get;
            set;
        }

        /// <remarks/>
        private string _subject = String.Empty;
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "SUBJECT")]
        [DataMember(Name = "subject")]
        public string Subject
        {
            get
            {
                return StringUtils.EscapeAllXml(_subject);
            }
            set { _subject = value; }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true)]
    [DataContract(Name = "article")]
    public class TopFiveArticle
    {
        public TopFiveArticle()
        {
            _user = new User();
            DateUpdated = new DateElement();
            EventDate = new DateElement();
        }

        [XmlIgnore]
        private User _user;
        
        /// <remarks/>
        [XmlElementAttribute(Order = 0)]
        [DataMember(Name="h2g2Id")]
        public int H2G2ID
        {
            get;
            set;
        }

        /// <remarks/>
        private string _subject = String.Empty;
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "SUBJECT")]
        [DataMember(Name = "subject")]
        public string Subject
        {
            get
            {
                return StringUtils.EscapeAllXml(_subject);
            }
            set { _subject = value; }
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 2, ElementName = "TYPE")]
        [DataMember(Name = "type")]
        public Article.ArticleType Type
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlIgnore]
        private string _extraInfo = string.Empty;

        [XmlIgnore]
        public string ExtraInfo
        {
            get { return _extraInfo; }
            set { _extraInfo = value; }
        }


        
        
        /// <remarks/>
        [XmlElementAttribute("LINKITEMTYPE", Order = 3)]
        [DataMember(Name = "linkItemType")]
        public int LinkItemType
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("LINKITEMID", Order = 4)]
        [DataMember(Name = "linkItemID")]
        public int LinkItemID
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("LINKITEMNAME", Order = 5)]
        [DataMember(Name = "linkItemName")]
        public string LinkItemName
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("DATEUPDATED", Order = 6)]
        [DataMember(Name = "dateUpdated")]
        public DateElement DateUpdated
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("EVENTDATEDATE", Order = 7)]
        [DataMember(Name = "eventDate")]
        public DateElement EventDate
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("USER", Order=8)]
        [DataMember(Name = "user")]
        public User User
        {
            get
            {
                return _user;
            }
            set
            {
                _user = value;
            }
        }
    }
}
