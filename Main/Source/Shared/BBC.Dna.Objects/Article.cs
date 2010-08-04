using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable()]
    [XmlType(AnonymousType = true, TypeName = "ARTICLE")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "ARTICLE")]
    [DataContract(Name="article")]
    public class Article : CachableBase<Article>
    {
        #region Properties

        /// <remarks/>
        private string _extraInfo = string.Empty;

        /// <remarks/>
        private string _guide = String.Empty;

        private string _subject = String.Empty;

        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        [DataMember (Name="id")]
        public int H2g2Id { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        public int EntryId { get; set; }


        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        [DataMember(Name = "hidden")]
        public int HiddenStatus { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [XmlIgnore]
        [DataMember(Name = "style")]
        public GuideEntryStyle Style { get; set; }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "ARTICLEINFO")]
        [DataMember(Name="articleInfo")]
        public ArticleInfo ArticleInfo { get; set; }

        /// <remarks/>
        [XmlElement(Order = 1, ElementName = "SUBJECT")]
        [DataMember(Name="subject")]
        public string Subject
        {
            get
            {
                if (HiddenStatus > 0)
                {
                    // Hidden! Tell the user
                    return "Article Pending Moderation";
                }
                return HtmlUtils.HtmlDecode(_subject);
            }
            set { _subject = value; }
        }

        [XmlIgnore]
        public string Guide
        {
            get { return _guide; }
            set { _guide = value; }
        }

        /// <remarks/>
        [XmlAnyElement(Order = 2)]
        [DataMember(Name="text")]
        public XmlElement GuideElement
        {
            get { return GuideEntry.CreateGuideEntry(Guide, HiddenStatus, Style); }
            set { Guide = value.OuterXml; }
        }


        [XmlIgnore]
        public string ExtraInfo
        {
            get { return _extraInfo; }
            set { _extraInfo = value; }
        }

        /// <remarks/>
        [XmlAnyElement(Order = 3)]
        public XmlElement ExtraInfoElement
        {
            get { return ExtraInfoCreator.CreateExtraInfo(ExtraInfo); }
            set { ExtraInfo = value.OuterXml; }
        }

        /// <remarks/>
        [XmlElement(Order = 4, ElementName = "BOOKMARKCOUNT")]
        public int BookmarkCount { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANREAD")]
        public int CanRead { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANWRITE")]
        public int CanWrite { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "CANCHANGEPERMISSIONS")]
        public int CanChangePermissions { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANREAD")]
        public int DefaultCanRead { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("canRead"))]
        public bool DefaultCanReadBool
        {
            get { return DefaultCanRead == 1; }
            set { }
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANWRITE")]
        public int DefaultCanWrite { get; set; }

        [XmlIgnore]
        [DataMember(Name = ("canWrite"))]
        public bool DefaultCanWriteBool
        {
            get { return DefaultCanWrite == 1; }
            set { }
        }

        /// <remarks/>
        [XmlAttribute(AttributeName = "DEFAULTCANCHANGEPERMISSIONS")]
        public int DefaultCanChangePermissions { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "PROFANITYTRIGGERED")]
        public int ProfanityTriggered { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "NONALLOWEDURLSTRIGGERED")]
        public int NonAllowedUrlsTriggered { get; set; }

        [XmlIgnore]
        public int ForumStyle { get; set; }

        #endregion

        /// <summary>
        /// Status 7 = deleted
        /// </summary>
        [XmlIgnore]
        public bool IsDeleted
        {
            get { return ArticleInfo.Status.Type == 7; }
        }

        /// <summary>
        /// Updates the article based on the viewing user
        /// </summary>
        /// <param name="viewingUser"></param>
        /// <param name="reader"></param>
        public void UpdatePermissionsForViewingUser(IUser viewingUser, IDnaDataReaderCreator readerCreator)
        {
            // Check to make sure we've got a logged in user
            if (viewingUser == null || !viewingUser.UserLoggedIn)
            {
                // Nothing to update
                return;
            }

            bool _canRead = true;
            bool _canWrite = true;
            bool _canChangePermissions = true;

            // Check to see if we're an editor
            if (!viewingUser.IsEditor && !viewingUser.IsSuperUser)
            {
                // get the users permissions from the database
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("GetArticlePermissionsForUser"))
                {
                    reader.AddParameter("h2g2ID", H2g2Id);
                    reader.AddParameter("UserID", viewingUser.UserId);
                    reader.Execute();

                    // Check to make sure we got something back
                    if (!reader.HasRows || !reader.Read() || reader.IsDBNull("h2g2id"))
                    {
                        // Nothing to do, just return
                        return;
                    }

                    // Update the permissions from the results
                    _canRead = reader.GetInt32("CanRead") > 0;
                    _canWrite = reader.GetInt32("CanWrite") > 0;
                    _canChangePermissions = reader.GetInt32("CanChangePermissions") > 0;
                }
            }
            // Now update the articles can read / write and change permissions
            CanRead = _canRead ? 1 : 0;
            CanWrite = _canWrite ? 1 : 0;
            CanChangePermissions = _canChangePermissions ? 1 : 0;
        }

        /// <summary>
        /// Sets the bookmark count in the object
        /// </summary>
        /// <param name="reader"></param>
        public void GetBookmarkCount(IDnaDataReaderCreator readerCreator)
        {
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("GetBookmarkCount"))
            {
                reader.AddParameter("H2G2ID", H2g2Id);
                reader.Execute();

                if (reader.Read())
                {
                    BookmarkCount = reader.GetInt32NullAsZero("BookmarkCount");
                }
            }
        }

        /// <summary>
        /// Updates the profanity and nonallowed flags in xml
        /// </summary>
        /// <param name="profanityTriggered"></param>
        /// <param name="nonAllowedURLsTriggered"></param>
        public void UpdateProfanityUrlTriggerCount(bool profanityTriggered, bool nonAllowedURLsTriggered)
        {
            ProfanityTriggered = (profanityTriggered ? 1 : 0);
            NonAllowedUrlsTriggered = (nonAllowedURLsTriggered ? 1 : 0);
        }

        /// <summary>
        /// Replaces <BR /> tags with /r/n for textareas
        /// </summary>
        public void MakeEdittable()
        {
            if (ArticleInfo != null && ArticleInfo.PreProcessed > 0 && Guide != null)
            {
                // REPLACE BRs WITH RETURNS
                Guide = Guide.Replace("<BR />", "\r\n");
            }
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            DateTime lastUpdate = DateTime.Now;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("cachegetarticleinfo2"))
            {
                reader.AddParameter("h2g2id", H2g2Id);
                reader.Execute();

                // If we found the info, set the expiry date
                if (reader.HasRows && reader.Read())
                {
                    lastUpdate = reader.GetDateTime("LastUpdated");
                }
            }
            return (ArticleInfo != null && ArticleInfo.LastUpdated != null &&
                    ArticleInfo.LastUpdated.Date.Local.DateTime >= lastUpdate);
        }

        /// <summary>
        /// Checks to see if a user has edit permissions for the current guide entry
        /// </summary>
        /// <param name="user">The user you want to check against</param>
        /// <returns>True if they are able to edit, false if not</returns>
        public bool HasEditPermission(User user)
        {
            // Check to see if we've got special permissions
            bool editable = user.HasSpecialEditPermissions(H2g2Id);

            // Make sure the h2g2id is valid
            if (!editable && ValidateH2G2ID(H2g2Id))
            {
                // Guide Entry is editable if it is a valid article, the user is the same as the
                // editor, and the status of the entry is either 2, 3, 4, or 7 => i.e. it is a
                // user entry that is private or public, or is awaiting consideration or has been
                // deleted
                // only give editors edit permission on all entries on the admin version
                // give moderators edit permission if they have entry locked for moderation

                if (ArticleInfo.Status.Type == 1 && user.IsGuardian)
                {
                    editable = true;
                }

                // If the user is the editor of the entry and the status is correct, then they can edit
                if (ArticleInfo.PageAuthor.Editor.user.UserId == user.UserId)
                {
                    if ((ArticleInfo.Status.Type > 1 && ArticleInfo.Status.Type < 5) || ArticleInfo.Status.Type == 7)
                    {
                        editable = true;
                    }
                }
            }

            return editable;
        }

        /// <summary>
        /// Checks to see the given user is a subeditor for the entry
        /// </summary>
        /// <param name="user">The user you want to check for subeditor status</param>
        /// <returns>True if they are, fasle if not</returns>
        public bool CheckIsSubEditor(User user, IDnaDataReaderCreator creator)
        {
            // Check to see if the user has editing permissions
            bool isSubEditor = false;
            if (HasEditPermission(user) && user.UserId > 0)
            {
                // Check the database to see if they are a sub editor
                using (IDnaDataReader reader = creator.CreateDnaDataReader("checkissubeditor"))
                {
                    reader.AddParameter("userid", user.UserId);
                    reader.AddParameter("entryID", EntryId);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        isSubEditor = reader.GetBoolean("IsSub");
                    }
                }
            }
            // return the verdict
            return isSubEditor;
        }

        /// <summary>
        /// Fills the object ForumStyle with the valid style
        /// </summary>
        /// <param name="creator"></param>
        private void GetForumStyle(IDnaDataReaderCreator creator)
        {
            using (IDnaDataReader reader = creator.CreateDnaDataReader("getforumstyle"))
            {
                reader.AddParameter("ForumID", ArticleInfo.ForumId);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    ForumStyle = reader.GetByte("ForumStyle");
                }
            }
        }

        /// <summary>
        /// Creates the article from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="entryId"></param>
        /// <returns></returns>
        public static Article CreateArticleFromDatabase(IDnaDataReaderCreator readerCreator, int entryId)
        {
            Article article = null;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getarticlecomponents2"))
            {
                // Add the entry id and execute
                reader.AddParameter("EntryID", entryId);
                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw new Exception("Article not found");
                }
                else
                {
                    // Go though the results untill we get the main article
                    do
                    {
                        if (reader.GetInt32("IsMainArticle") == 1)
                        {
                            article = CreateArticleFromReader(readerCreator, reader);

                            break; //got the info so run
                        }
                    } while (reader.Read());

                    //not created so scream
                    if (article == null)
                    {
                        throw new Exception("Article not found");
                    }
                }
            }
            return article;
        }

        /// <summary>
        /// Creates the random article from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="status1"></param>
        /// <param name="status2"></param>
        /// <param name="status3"></param>
        /// <param name="status4"></param>
        /// <param name="status5"></param>
        /// <returns></returns>
        public static Article CreateRandomArticleFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                                int siteId, 
                                                                                int status1,
                                                                                int status2,
                                                                                int status3,
                                                                                int status4,
                                                                                int status5 )
        {
            Article article = null;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetchrandomarticle"))
            {
                // Add the site id and execute
                reader.AddParameter("SiteID", siteId);
	            reader.AddParameter("Status1", status1);
	            reader.AddParameter("Status2", status2);
	            reader.AddParameter("Status3", status3);
	            reader.AddParameter("Status4", status4);
	            reader.AddParameter("Status5", status5);
                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw new Exception("Article not found");
                }
                else
                {
                    article = CreateArticleFromReader(readerCreator, reader);

                    //not created so scream
                    if (article == null)
                    {
                        throw new Exception("Article not found");
                    }
                }
            }
            return article;
        }

        private static Article CreateArticleFromReader(IDnaDataReaderCreator readerCreator, IDnaDataReader reader)
        {
            Article article = new Article();
            article.EntryId = reader.GetInt32("EntryID");
            article.H2g2Id = reader.GetInt32("h2g2ID");

            // if h2g2ID is zero then this is a new entry, so don't try to validate its ID
            // => must avoid trying to show alternative entries for a new entry!
            if (article.H2g2Id > 0)
            {
                // check if this is a valid h2g2ID
                if (!ValidateH2G2ID(article.H2g2Id))
                {
                    throw new NotImplementedException("Invalid ID we've got here!");
                }
            }
            article.ArticleInfo = ArticleInfo.GetEntryFromDataBase(article.EntryId, reader,
                                                                   readerCreator);

            if (article.ArticleInfo == null)
            {
                throw new Exception("Unable to create article info");
            }

            // Now start reading in all the values for the entry
            //int Submittable = reader.GetTinyIntAsInt("Submittable");
            //int type = reader.GetInt32("Type");

            article.Subject = reader.GetString("subject");
            article.Style = (GuideEntryStyle)reader.GetInt32NullAsZero("style");
            if (article.Style == 0)
            {
                article.Style = GuideEntryStyle.GuideML;
            }
            article.ExtraInfo = reader.GetString("extrainfo");

            if (!reader.IsDBNull("HIdden"))
            {
                article.HiddenStatus = reader.GetInt32("Hidden");
            }
            article.DefaultCanRead = reader.GetTinyIntAsInt("CanRead");
            article.DefaultCanWrite = reader.GetTinyIntAsInt("CanWrite");
            article.DefaultCanChangePermissions = reader.GetTinyIntAsInt("CanChangePermissions");
            //default to the default values
            article.CanRead = reader.GetTinyIntAsInt("CanRead");
            article.CanWrite = reader.GetTinyIntAsInt("CanWrite");
            article.CanChangePermissions = reader.GetTinyIntAsInt("CanChangePermissions");
            //fill complex children objects
            article.GetBookmarkCount(readerCreator);
            article.Guide = reader.GetString("text");

            if (article.Guide != null &&
                article.GuideElement.ParentNode.SelectSingleNode("//GUIDE") != null)
            {
                article.ArticleInfo.GetReferences(readerCreator,
                                                  article.GuideElement.ParentNode.SelectSingleNode(
                                                      "//GUIDE"));
            }

            //get forum style
            article.GetForumStyle(readerCreator);
            return article;
        }

        /// <summary>
        /// Gets article from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="h2g2Id"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Article CreateArticle(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                            int h2g2Id, bool ignoreCache)
        {
            var article = new Article();
            //convert entryId
            //int entryId = Convert.ToInt32(h2g2Id.ToString().Substring(0, entryId.ToString().Length - 1));
            int entryId = h2g2Id / 10;

            string key = article.GetCacheKey(entryId);
            //check for item in the cache first
            if (!ignoreCache)
            {
//not ignoring cache

                article = (Article) cache.GetData(key);
                if (article != null)
                {
//check if still valid with db...
                    if (article.IsUpToDate(readerCreator))
                    {
//all good - apply viewing user attributes and return
                        article.UpdatePermissionsForViewingUser(viewingUser, readerCreator);
                        return article;
                    }
                }
            }

            //create from db
            article = CreateArticleFromDatabase(readerCreator, entryId);
            //add to cache
            cache.Add(key, article);
            //update with viewuser info
            article.UpdatePermissionsForViewingUser(viewingUser, readerCreator);

            return article;
        }

        /// <summary>
        /// Gets random article from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="status1"></param>
        /// <param name="status2"></param>
        /// <param name="status3"></param>
        /// <param name="status4"></param>
        /// <param name="status5"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Article CreateRandomArticle(ICacheManager cache, 
                                                    IDnaDataReaderCreator readerCreator, 
                                                    User viewingUser,
                                                    int siteId, 
                                                    int status1,
                                                    int status2,
                                                    int status3,
                                                    int status4,
                                                    int status5, 
                                                    bool ignoreCache)
        {
            var article = new Article();

            //create from db
            article = CreateRandomArticleFromDatabase(readerCreator, siteId, status1, status2, status3, status4, status5);

            //update with viewuser info
            article.UpdatePermissionsForViewingUser(viewingUser, readerCreator);

            return article;
        }


        /// <summary>
        /// Gets article from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="h2g2Id"></param>
        /// <returns></returns>
        public static Article CreateArticle(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                            int h2g2Id)
        {
            return CreateArticle(cache, readerCreator, viewingUser, h2g2Id, false);
        }

        /// <summary>
        /// Gets article from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="status1"></param>
        /// <param name="status2"></param>
        /// <param name="status3"></param>
        /// <param name="status4"></param>
        /// <param name="status5"></param>
        /// <returns></returns>
        public static Article CreateRandomArticle(ICacheManager cache, 
                                                    IDnaDataReaderCreator readerCreator, 
                                                    User viewingUser,
                                                    int siteId, 
                                                    int status1,
                                                    int status2,
                                                    int status3,
                                                    int status4,
                                                    int status5)
        {
            return CreateRandomArticle(cache, readerCreator, viewingUser, siteId, status1, status2, status3, status4, status5, false);
        }

        /// <summary>
        /// Gets about me article from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="identityUserName"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Article CreateAboutMeArticle(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                            int siteId, string identityUserName)
        {
            return CreateAboutMeArticle(cache, readerCreator, viewingUser, siteId, identityUserName, false);
        }

        /// <summary>
        /// Gets about me article from cache or db if not found in cache by DNAUserid
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="DNAUserid"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Article CreateAboutMeArticleByDNAUserId(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                            int siteId, int DNAUserid)
        {
            return CreateAboutMeArticleByDNAUserId(cache, readerCreator, viewingUser, siteId, DNAUserid, false);
        }

        /// <summary>
        /// Gets article from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="identityUserName"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Article CreateAboutMeArticle(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                                        int siteId, string identityUserName, bool ignoreCache)
        {
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("finduserfromidentityusername"))
            {
                // Add the identityUserName and execute
                reader.AddParameter("identityUserName", identityUserName);

                reader.AddParameter("siteid", siteId);

                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
                else
                {
                    int h2g2Id = reader.GetInt32NullAsZero("Masthead");
                    return CreateArticle(cache, readerCreator, viewingUser, h2g2Id, false);
                }
            }
        }

        /// <summary>
        /// Gets article from cache or db if not found in cache from a dnauserid
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="DNAUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Article CreateAboutMeArticleByDNAUserId(ICacheManager cache, IDnaDataReaderCreator readerCreator, User viewingUser,
                                            int siteId, int DNAUserId, bool ignoreCache)
        {
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("finduserfromid"))
            {
                // Add the identityUserName and execute
                reader.AddParameter("userId", DNAUserId);

                reader.AddParameter("siteid", siteId);

                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
                else
                {
                    int h2g2Id = reader.GetInt32NullAsZero("Masthead");
                    return CreateArticle(cache, readerCreator, viewingUser, h2g2Id, false);
                }
            }
        }

        /// <summary>
        /// Validates the h2g2id to make sure it correctly translates to an entry id
        /// </summary>
        /// <remarks>This is the C# version of the C++ IsValidChecksum(...) function.</remarks>
        /// <returns>True if valid, false if not</returns>
        public static bool ValidateH2G2ID(int h2g2ID)
        {
            // Check to make sure we've got at least a two digit number
            if (h2g2ID < 10)
            {
                return false;
            }

            // First get the check sum value. The last digit of the id
            string checkSumAsString = h2g2ID.ToString();
            int checkSum = Convert.ToInt32(checkSumAsString.Substring(checkSumAsString.Length - 1, 1));

            // Now get the entry id which is all the digits minus the checksum
            int entryID = Convert.ToInt32(checkSumAsString.Substring(0, checkSumAsString.Length - 1));

            // Now recalculate the check sum
            int testID = entryID;
            int calculatedCheck = 0;
            while (testID > 0)
            {
                calculatedCheck += testID%10;
                testID /= 10;
            }
            calculatedCheck = calculatedCheck%10;
            calculatedCheck = 9 - calculatedCheck;

            // Now return the comparision of the calculated check sum with the one passed in.
            // If they're not the same, it's invalid!
            if (calculatedCheck == checkSum)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}