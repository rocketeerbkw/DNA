using System.Xml.Serialization;
using BBC.Dna.Objects;
using System.Xml;
using System.Runtime.Serialization;
using System;
using BBC.Dna.Data;
using System.Collections.Generic;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=false, TypeName="TOP-FIVES")]
    [XmlRootAttribute("TOP-FIVES", Namespace="", IsNullable=false)]
    public class TopFives : CachableBase<TopFives>
    {
        public TopFives()
        {
            TopFiveList = new List<TopFiveBase>();
        }
        
        /// <summary>
        /// Gets the TopFive for the current site. If a valid cached version is available, that is returned instead of getting it from the database
        /// </summary>
        /// <param name="siteID">The site you want to get the top fives for</param>
        /// <param name="readerCreator">DateReaderCreator to create database readers</param>
        /// <param name="diagnostics">The diagnostics object for writing to the logs</param>
        /// <param name="cache">The current cache manager for the application</param>
        /// <returns>The TopFives object for the given site</returns>
        static public TopFives GetSiteTopFives(int siteID, IDnaDataReaderCreator readerCreator, IDnaDiagnostics diagnostics, ICacheManager cache)
        {
            TopFives topFive = new TopFives();
            string cacheKey = topFive.GetCacheKey("topfives-site-", siteID);
            var cachedTopFives = (CachableBase<TopFives>)cache.GetData(cacheKey);
            if (cachedTopFives == null || !cachedTopFives.IsUpToDate(null))
            {
                topFive.GetTopFivesForSite(siteID, readerCreator, diagnostics);
                cache.Add(cacheKey, topFive.Clone());
            }
            else
            {
                topFive = (TopFives)cachedTopFives;
            }

            return topFive;
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
        public void GetTopFivesForSite(int siteID, IDnaDataReaderCreator readerCreator, IDnaDiagnostics diagnostics)
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
                            moreRows = AddArticlesToTopFive(reader);
                        }
                        else if (!reader.IsDBNull("forumid"))
                        {
                            moreRows = AddForumsToTopFive(reader);
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
                    TopFiveList.Clear();
                }
                CacheExpireryDate = DateTime.Now.AddMinutes(5);
            }
        }

        /// <summary>
        /// Creates and adds the current top five article to the topfives
        /// </summary>
        /// <param name="reader">The data reader that holds the information</param>
        private bool AddArticlesToTopFive(IDnaDataReader reader)
        {
            TopFiveArticles topFiveArticles = new TopFiveArticles();
            TopFiveList.Add(topFiveArticles);

            topFiveArticles.Name = reader.GetStringNullAsEmpty("groupname");
            topFiveArticles.Title = reader.GetStringNullAsEmpty("groupdescription");

            TopFiveArticle topFiveArticle = null;
            bool moreRows = true;

            while (moreRows && topFiveArticles.Name == reader.GetStringNullAsEmpty("groupname"))
            {
                topFiveArticle = new TopFiveArticle();
                topFiveArticles.topFiveArticleList.Add(topFiveArticle);

                topFiveArticle.DateUpdated.Date = new Date(reader.GetDateTime("dateupdated"));
                if (!reader.IsDBNull("eventdate"))
                {
                    topFiveArticle.EventDate.Date = new Date(reader.GetDateTime("eventdate"));
                }
                topFiveArticle.ExtraInfo = reader.GetStringNullAsEmpty("extrainfo");
                topFiveArticle.H2G2ID = reader.GetInt32NullAsZero("h2g2id");
                topFiveArticle.LinkItemID = reader.GetInt32NullAsZero("linkitemid");
                topFiveArticle.LinkItemName = reader.GetStringNullAsEmpty("linkitemname");
                topFiveArticle.LinkItemType = reader.GetInt32NullAsZero("linkitemtype");
                topFiveArticle.Subject = reader.GetStringNullAsEmpty("subject");
                topFiveArticle.User.UserID = reader.GetInt32NullAsZero("itemauthorid");
                topFiveArticle.User.UserName = reader.GetStringNullAsEmpty("username");
                topFiveArticle.User.SiteSuffix = reader.GetStringNullAsEmpty("sitesuffix");

                moreRows = reader.Read();
            }

            return moreRows;
        }

        /// <summary>
        /// Creates and adds the current top five forum to the topfives
        /// </summary>
        /// <param name="reader">The data reader that holds the information</param>
        private bool AddForumsToTopFive(IDnaDataReader reader)
        {
            TopFiveForums topFiveForums = new TopFiveForums();
            TopFiveList.Add(topFiveForums);
            topFiveForums.Name = reader.GetStringNullAsEmpty("groupname");
            topFiveForums.Title = reader.GetStringNullAsEmpty("groupdescription");

            TopFiveForum topFiveForum = null;
            bool moreRows = true;

            while (moreRows && topFiveForums.Name == reader.GetStringNullAsEmpty("groupname"))
            {
                topFiveForum = new TopFiveForum();
                topFiveForums.topFiveForumList.Add(topFiveForum);

                topFiveForum.ForumID = reader.GetInt32NullAsZero("forumid");
                topFiveForum.Subject = reader.GetStringNullAsEmpty("title");
                topFiveForum.ThreadID = reader.GetInt32NullAsZero("threadid");

                moreRows = reader.Read();
            }

            return moreRows;
        }

        /// <remarks/>
        [XmlElementAttribute("TOP-FIVE", Order = 0)]
        public List<TopFiveBase> TopFiveList
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
    [XmlTypeAttribute("TOP-FIVE")]
    [XmlInclude(typeof(TopFiveArticles)), XmlInclude(typeof(TopFiveForums))]
    public class TopFiveBase
    {
        /// <remarks/>
        [XmlElementAttribute("TITLE", Order = 0)]
        public string Title
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute("NAME")]
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
    public class TopFiveForums : TopFiveBase
    {
        public TopFiveForums()
        {
            topFiveForumList = new List<TopFiveForum>();
        }
        
        /// <remarks/>
        [XmlElementAttribute("TOP-FIVE-FORUM", Order = 1)]
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
    public class TopFiveArticles : TopFiveBase
    {
        public TopFiveArticles()
        {
            topFiveArticleList = new List<TopFiveArticle>();
        }

        /// <remarks/>
        [XmlElementAttribute("TOP-FIVE-ARTICLE", Order = 1)]
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
    public class TopFiveForum
    {
        /// <remarks/>
        [XmlElementAttribute("FORUMID", Order = 0)]
        public int ForumID
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("THREADID", Order = 1)]
        public int ThreadID
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("SUBJECT", Order = 2)]
        public string Subject
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
    public class TopFiveArticle
    {
        public TopFiveArticle()
        {
            _user = new TopFiveArticleUser();
            DateUpdated = new TopFiveDateUpdated();
            EventDate = new TopFiveEventDate();
        }

        [XmlIgnore]
        private TopFiveArticleUser _user;
        
        /// <remarks/>
        [XmlElementAttribute(Order = 0)]
        public int H2G2ID
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("SUBJECT", Order = 1)]
        public string Subject
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
        [XmlAnyElement(Order = 2)]
        public XmlElement ExtrainfoElement
        {
            get { return ExtraInfoCreator.CreateExtraInfo(ExtraInfo); }
            set { ExtraInfo = value.OuterXml; }
        }
        
        /// <remarks/>
        [XmlElementAttribute("LINKITEMTYPE", Order = 3)]
        public int LinkItemType
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("LINKITEMID", Order = 4)]
        public int LinkItemID
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("LINKITEMNAME", Order = 5)]
        public string LinkItemName
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("DATEUPDATED", Order = 6)]
        public TopFiveDateUpdated DateUpdated
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("EVENTDATEDATE", Order = 7)]
        public TopFiveEventDate EventDate
        {
            get;
            set;
        }
        
        /// <remarks/>
        [XmlElementAttribute("USER", Order=8)]
        public TopFiveArticleUser User
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

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true)]
    public class TopFiveDateUpdated
    {
        /// <remarks/>
        [XmlElementAttribute("DATE", Order = 0)]
        public Dna.Objects.Date Date
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
    public class TopFiveEventDate
    {
        /// <remarks/>
        [XmlElementAttribute("DATE", Order = 0)]
        public Dna.Objects.Date Date
        {
            get;
            set;
        }
    }

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType=true)]
    public class TopFiveArticleUser
    {
        /// <remarks/>
        [XmlElementAttribute("USERID", Order = 0)]
        public int UserID
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("USERNAME", Order = 1)]
        public string UserName
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("SITESUFFIX", Order = 2)]
        public string SiteSuffix
        {
            get;
            set;
        }
    }
}
