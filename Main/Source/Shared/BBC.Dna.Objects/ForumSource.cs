using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml.Serialization;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "FORUMSOURCE")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "FORUMSOURCE")]
    [DataContract(Name = "forumSource")]
    public class ForumSource : CachableBase<ForumSource>
    {
        [XmlIgnore]
        [DataMember(Name = "type")]
        public ForumSourceType Type { get; set; }

        /// <summary>
        /// Must be lower case so added new element to do this.
        /// </summary>
        [XmlAttributeAttribute(AttributeName = "TYPE")]
        public string TypeElememt
        {
            get { return Type.ToString().ToLower(); }
            set { }
        }

        [XmlElement(ElementName = "ALERTINSTANTLY")]
        [DataMember(Name = "alertInstantly")]
        public byte AlertInstantly { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "ARTICLE")]
        [DataMember(Name = "article")]
        public Article Article { get; set; }

        /// <remarks/>
        [XmlIgnore]
        [DataMember(Name = "h2g2Id")]
        public int ArticleH2G2Id { get; set; }


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
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ForumSource CreateForumSource(ICacheManager cache, IDnaDataReaderCreator creator, User viewingUser,
                                                    int forumId, int threadId, int siteId, bool includeArticle,
                                                    bool ignoreCache, bool applySkin)
        {
            var source = new ForumSource();
            string key = source.GetCacheKey(forumId, threadId, siteId);
            //check for item in the cache first
            if (!ignoreCache)
            {
//not ignoring cache

                source = (ForumSource) cache.GetData(key);
                if (source != null)
                {
//add article back to object
                    source.Article = Article.CreateArticle(cache, creator, viewingUser, source.ArticleH2G2Id, ignoreCache, applySkin);
                    return source;
                }
            }

            //create from db
            source = CreateForumSourceFromDatabase(cache, creator, viewingUser, forumId, threadId, siteId,
                                                   includeArticle, applySkin);

            if (source != null)
            {
                //add to cache, first strip article as it is cached on its own
                var sourceCopy = (ForumSource)source.Clone();
                sourceCopy.Article = null;
                cache.Add(key, sourceCopy);
                source.Article = Article.CreateArticle(cache, creator, viewingUser, source.ArticleH2G2Id, ignoreCache, applySkin);
            }
            
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
        /// <returns></returns>
        public static ForumSource CreateForumSourceFromDatabase(ICacheManager cache, IDnaDataReaderCreator creator,
                                                                 User viewingUser, int forumId, int threadId, int siteId,
                                                                 bool includeArticle, bool applySkin)
        {
            ForumSource source = null;

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
                    source = new ForumSource();
                    source.Type = (ForumSourceType) dataReader.GetInt32NullAsZero("Type");
                    source.AlertInstantly = (byte) dataReader.GetInt32("AlertInstantly");

                    switch (source.Type)
                    {
                        case ForumSourceType.Article:
                            //do nothing here
                            break;

                        case ForumSourceType.Journal:
                            source = new ForumSourceJournal
                                         {
                                             Type = source.Type,
                                             AlertInstantly = source.AlertInstantly,
                                             JournalUser = new UserElement
                                                               {
//TODO: add cached version
                                                                   user =
                                                                       User.CreateUserFromReader(dataReader, "Journal")
                                                               }
                                         };
                            break;

                        case ForumSourceType.ReviewForum:
                            source = new ForumSourceReviewForum
                                         {
                                             Type = source.Type,
                                             AlertInstantly = source.AlertInstantly,
                                             //TODO: add cached version
                                             ReviewForum =
                                                 ReviewForum.CreateFromDatabase(creator,
                                                                                dataReader.GetInt32NullAsZero(
                                                                                    "ReviewForumID"), true)
                                         };
                            break;

                        case ForumSourceType.Redirect:
                            source = new ForumSourceRedirect
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
                            source = new ForumSourceUser
                                         {
                                             Type = source.Type,
                                             AlertInstantly = source.AlertInstantly,
                                             User = new UserElement
                                                        {
//TODO: add cached version
                                                            user = User.CreateUserFromReader(dataReader)
                                                        }
                                         };
                            break;

                        case ForumSourceType.ClubForum:
                            goto case ForumSourceType.Club;

                        case ForumSourceType.ClubJournal:
                            goto case ForumSourceType.Club;

                        case ForumSourceType.Club:
                            source = new ForumSourceClub
                                         {
                                             Type = source.Type,
                                             AlertInstantly = source.AlertInstantly,
                                             Club = new Club
                                                        {
                                                            Id = dataReader.GetInt32NullAsZero("ClubID")
                                                        }
                                         };
                            break;
                    }

                    source.ArticleH2G2Id = dataReader.GetInt32NullAsZero("h2g2ID");
                }
                return source;
            }
        }

        /// <summary>
        /// Not required in this instance
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return true;
        }
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