using BBC.Dna.Data;
using System;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Xml.Serialization;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
namespace BBC.Dna.Objects
{


    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "FORUMSOURCE")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "FORUMSOURCE")]
    public partial class ForumSource : ICloneable
    {
        [XmlIgnore]
        public ForumSourceType Type
        {
            get;
            set;
        }

        /// <summary>
        /// Must be lower case so added new element to do this.
        /// </summary>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "TYPE")]
        public string TypeElememt
        {
            get{ return Type.ToString().ToLower();}
            set{}
        }

        [System.Xml.Serialization.XmlElement(ElementName = "ALERTINSTANTLY")]
        public byte AlertInstantly
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(ElementName = "ARTICLE")]
        public Article Article
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlIgnore]
        public int ArticleH2g2Id 
        { get; set; }

        /// <summary>
        /// Creates the forum source from the cache or db
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="siteId"></param>
        /// <param name="includeArticle"></param>
        /// <param name="title"></param>
        /// <returns></returns>
        static public ForumSource CreateForumSource(ICacheManager cache, IDnaDataReaderCreator creator, User viewingUser, int forumId, int threadId, int siteId, bool includeArticle, bool ignoreCache)
        {
            ForumSource source = null;
            string key = GetCacheKey(forumId, threadId, siteId);
            //check for item in the cache first
            if (!ignoreCache)
            {//not ignoring cache

                source = (ForumSource)cache.GetData(key);
                if (source != null)
                {//add article back to object
                    if (includeArticle && source.ArticleH2g2Id != 0)
                    {
                        source.Article = Article.CreateArticle(cache, creator, viewingUser, source.ArticleH2g2Id); 
                    }
                    return source;
                }
            }

            //create from db
            source = CreateForumSourceFromDatabase(cache, creator, viewingUser, forumId, threadId, siteId, includeArticle);
            //add to cache, first strip article as it is cached on its own
            ForumSource sourceCopy = (ForumSource)source.Clone();
            sourceCopy.Article = null;
            cache.Add(key, sourceCopy);
            return source;

        }

        /// <summary>
        /// Creates the forum source from the db
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="siteId"></param>
        /// <param name="includeArticle"></param>
        /// <param name="title"></param>
        /// <returns></returns>
        static private ForumSource CreateForumSourceFromDatabase(ICacheManager cache, IDnaDataReaderCreator creator, User viewingUser, int forumId, int threadId, int siteId, bool includeArticle)
        {
            int h2g2Id = 0;
            ForumSource source = new ForumSource();

            //TODO: getforumsource returns entire users, articles, journals etc - massive query
            // it should return the type, the id of the item and use objects/caches to get objects.
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getforumsource"))
            {
                dataReader.AddParameter("ForumID", forumId);
                dataReader.AddParameter("ThreadID", threadId);
                dataReader.AddParameter("CurrentSiteID", siteId);
                dataReader.Execute();

                if (dataReader.HasRows && dataReader.Read())
                {
                    source.Type = (ForumSourceType)dataReader.GetInt32NullAsZero("Type");
                    source.AlertInstantly = (byte)dataReader.GetInt32("AlertInstantly");

                    switch (source.Type)
                    {
                        case ForumSourceType.Article:
                            //do nothing here
                            break;

                        case ForumSourceType.Journal:
                            source = new ForumSourceJournal()
                            {
                                Type = source.Type,
                                AlertInstantly = source.AlertInstantly,
                                JournalUser = new UserElement()
                                    {//TODO: add cached version
                                        user = User.CreateUserFromReader(dataReader, "Journal")
                                    }
                            };
                            break;

                        case ForumSourceType.ReviewForum:
                            source = new ForumSourceReviewForum()
                            {
                                Type = source.Type,
                                AlertInstantly = source.AlertInstantly,

                                //TODO: add cached version
                                ReviewForum = ReviewForum.CreateFromDatabase(creator, dataReader.GetInt32NullAsZero("ReviewForumID"), true)
                            };
                            break;

                        case ForumSourceType.Redirect:
                            source = new ForumSourceRedirect()
                            {
                                Type = source.Type,
                                AlertInstantly = source.AlertInstantly,
                                Url = dataReader.GetStringNullAsEmpty("URL")
                            };
                            break;

                        case ForumSourceType.NoticeBoard:
                            //do nothing
                            break;

                        case ForumSourceType.PrivateUser:
                            goto case ForumSourceType.UserPage;


                        case ForumSourceType.UserPage:
                            source = new ForumSourceUser()
                            {
                                Type = source.Type,
                                AlertInstantly = source.AlertInstantly,
                                User = new UserElement()
                                {//TODO: add cached version
                                    user = User.CreateUserFromReader(dataReader)
                                }
                            };
                            break;

                        case ForumSourceType.ClubForum:
                            goto case ForumSourceType.Club;

                        case ForumSourceType.ClubJournal:
                            goto case ForumSourceType.Club;

                        case ForumSourceType.Club:
                            h2g2Id = dataReader.GetInt32NullAsZero("ClubH2G2ID");
                            source = new ForumSourceClub()
                            {
                                Type = source.Type,
                                AlertInstantly = source.AlertInstantly,
                                Club = new Club()
                                {
                                    Id = dataReader.GetInt32NullAsZero("ClubID")
                                }
                            };
                            break;
                    }
                    
                    if (includeArticle)
                    {
                        source.ArticleH2g2Id = dataReader.GetInt32NullAsZero("h2g2ID");
                        source.Article = Article.CreateArticle(cache, creator, viewingUser, source.ArticleH2g2Id);
                    }

                }
                return source;
            }


        }

        /// <summary>
        /// Returns the cache key
        /// </summary>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="siteId"></param>
        /// <returns></returns>
        static public string GetCacheKey(int forumId, int threadId, int siteId)
        {
            return string.Format("{0}|{1}|{2}|{3}", typeof(ForumSource).AssemblyQualifiedName, forumId, threadId, siteId);
        }

        #region ICloneable Members

        // deep copy in separeate memory space
        public object Clone()
        {
            MemoryStream ms = new MemoryStream();
            BinaryFormatter bf = new BinaryFormatter();
            bf.Serialize(ms, this);
            ms.Position = 0;
            object obj = bf.Deserialize(ms);
            ms.Close();
            return obj;

        }

        #endregion
    }

    public enum ForumSourceType
    {
        Journal = 0,
        Article = 1,
        UserPage = 2,
        ReviewForum = 3,
        PrivateUser = 4,
        Club = 5,
        ClubForum = 6,
        ClubJournal = 7,
        NoticeBoard = 8,
        Redirect = 9
    }
}