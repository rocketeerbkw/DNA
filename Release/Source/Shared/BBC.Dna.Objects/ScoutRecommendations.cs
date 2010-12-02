using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;
using BBC.Dna.Sites;
using System.Data;
using System.Data.SqlClient;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Objects
{
    [GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "SCOUT-RECOMMENDATION")]
    [DataContract(Name = "scoutRecommendations")]
    public partial class ScoutRecommendations : CachableBase<ScoutRecommendations>
    {
        #region Properties

        public ScoutRecommendations()
        {
            Articles = new List<ArticleSummary>();
        }

        /// <remarks/>
        [DataMember(Name = "submittedArticleH2G2Id", Order = 1)]
        public int SubmittedArticleH2G2Id { get; set; }

        /// <remarks/>
        [DataMember(Name = "submitted", Order = 2)]
        public bool Submitted { get; set; }

        /// <remarks/>
        [XmlElement("ARTICLES", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "Articles", Order = 3)]
        public List<ArticleSummary> Articles { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        public static ScoutRecommendations RecommendArticle(IDnaDataReaderCreator readerCreator, 
                BBC.Dna.Sites.ISite site,
                int scoutId,
                bool isScoutEditor,
                int articleId,
                string comments)
        {
            ScoutRecommendations scoutRecommendationsResponse = new ScoutRecommendations();

            CreateFromh2g2ID(readerCreator, scoutId, isScoutEditor, articleId, comments);

            int entryId = articleId / 10;

            bool alreadyRecommended = false;
            bool wrongStatus = false;
            bool okay = false;
            int userID = 0;
            string username = String.Empty;

            //Submit the article
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("StoreScoutRecommendation"))
            {
                reader.AddParameter("ScoutID", scoutId);
                reader.AddParameter("EntryID", entryId);
                if (comments != String.Empty)
                {
                    reader.AddParameter("Comments", comments);
                }

                reader.Execute();
                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {

                    alreadyRecommended = reader.GetBoolean("AlreadyRecommended");
                    wrongStatus = reader.GetBoolean("WrongStatus");
                    okay = reader.GetBoolean("Success");
                    userID = reader.GetInt32NullAsZero("UserID");
                    username = reader.GetStringNullAsEmpty("Username");
                }
            }
            if (okay)
            {
                scoutRecommendationsResponse.SubmittedArticleH2G2Id = articleId;
                scoutRecommendationsResponse.Submitted = true;

                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("updateguideentry"))
                {
                    reader.AddParameter("EntryID", entryId);
                    reader.AddParameter("Submittable", false);
                    reader.Execute();
                }
            }
            else
            {
                if (wrongStatus)
                {
                    throw new ApiException("Entry is not a public user entry", ErrorType.WrongStatus);
                }
                // entry already recommended
                else if (alreadyRecommended)
                {
                    throw new ApiException("Entry has already been recommended by U" + userID.ToString() + "-" + username, ErrorType.AlreadyRecommended);
                }
                // something unspecified went wrong
                else if (!okay)
                {
                    throw new ApiException("An unspecified error occurred whilst processing the request.", ErrorType.Unknown);
                }
            }

            return scoutRecommendationsResponse;
        }

        private static void CreateFromh2g2ID(IDnaDataReaderCreator readerCreator, int scoutId, bool isScoutEditor, int articleId, string comments)
        {
            if (!Article.ValidateH2G2ID(articleId))
            {
                throw new ApiException("H2G2ID invalid.", ErrorType.InvalidH2G2Id);
            }

            // now we've checked that the h2g2ID is valid get the entry ID from it
            int entryId = articleId / 10;

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("FetchArticleSummary"))
            {
                reader.AddParameter("EntryID", entryId);
                reader.Execute();

                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {
                    int h2g2ID = reader.GetInt32NullAsZero("h2g2ID");
                    string subject = reader.GetStringNullAsEmpty("Subject");
                    string editorName = reader.GetStringNullAsEmpty("EditorName");
                    int editorID = reader.GetInt32NullAsZero("EditorID");
                    int status = reader.GetInt32NullAsZero("Status");
                    bool isSubCopy = reader.GetBoolean("IsSubCopy");
                    bool hasSubCopy = reader.GetBoolean("HasSubCopy");
                    int subCopyID = reader.GetInt32NullAsZero("SubCopyID");
                    int recommendedByScoutID = reader.GetInt32NullAsZero("RecommendedByScoutID");
                    string recommendedByUserName = reader.GetStringNullAsEmpty("RecommendedByUserName");

                    // check that this entry is appropriate for recommendation and if not then
                    // assume it is valid then set to invalid if any problems found

                    // give the reason why
                    // Entry not suitable reasons are:
                    //	- entry is already in edited guide
                    //	- entry is a key article
                    //	- entry is already recommended
                    //	- entry is deleted
                    //	- entry was written by the scout trying to recommend it
                    // only status value 3 (user entry, public) is actually suitable for recommendations

                    if (recommendedByScoutID > 0)
                    {
                        throw new ApiException("Entry has already been recommended by U" + recommendedByScoutID.ToString() + "-" + recommendedByUserName, ErrorType.AlreadyRecommended);
                    }
                    else if (status != 3)
                    {
                        string errorMessage = String.Empty;

                        switch (status)
                        {
                            case 0: errorMessage = "No Status";
                                break;
                            case 1: errorMessage = "Already Edited";
                                break;
                            case 2: errorMessage = "Private Entry";
                                break;
                            case 4: errorMessage = "Already Recommended";
                                break;
                            case 5: errorMessage = "Already Recommended";
                                break;
                            case 6: errorMessage = "Already Recommended";
                                break;
                            case 7: errorMessage = "Deleted";
                                break;
                            case 8: errorMessage = "Already Recommended";
                                break;
                            case 9: errorMessage = "Key Article";
                                break;
                            case 10: errorMessage = "Key Article";
                                break;
                            case 11: errorMessage = "Already Recommended";
                                break;
                            case 12: errorMessage = "Already Recommended";
                                break;
                            case 13: errorMessage = "Already Recommended";
                                break;
                            default: errorMessage = "Invalid Status";
                                break;
                        }

                        throw new ApiException(errorMessage, ErrorType.WrongStatus);
                    }
                    else if (isSubCopy)
                    {
                        throw new ApiException("Sub-editors draft copy for Edited Entry", ErrorType.WrongStatus);
                    }

                    // check that scout is not the author, but allow editors to recommend
                    // their own entries should they ever wish to
                    if (scoutId == editorID && !isScoutEditor)
                    {
                        throw new ApiException("Recommender is author", ErrorType.OwnEntry);
                    }

                    //if the scout is not an editor then check that the entry is recommendable
                    if (!isScoutEditor && !RecommendEntry(readerCreator, h2g2ID))
                    {
                        throw new ApiException("Not in appropriate review forum", ErrorType.NotInReview);
                    }
                }
            }
        }

        private static bool RecommendEntry(IDnaDataReaderCreator readerCreator, int h2g2Id)
        {
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("fetchreviewforummemberdetails"))
            {
                dataReader.AddParameter("h2g2id", h2g2Id);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    int reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                    DateTime dateEntered = dataReader.GetDateTime("DateEntered");
                    DateTime dateNow = DateTime.Now;
                    TimeSpan dateDiff = dateNow - dateEntered;

                    ReviewForum reviewForum = ReviewForum.CreateFromDatabase(readerCreator, reviewForumID, true); 

                    if (reviewForum.Recommendable == 1)
                    {
                        int incubateTime = reviewForum.IncubateTime;

                        if (dateDiff.Days >= incubateTime)
                        {
                            return true;
                        }
                    }

                }
            }

            return false;

        }

        public static ScoutRecommendations CreateScoutRecommendationsFromDatabase(IDnaDataReaderCreator readerCreator, int siteId, int skip, int show)
        {
            ScoutRecommendations scoutRecommendations = new ScoutRecommendations();

            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("FetchUndecidedRecommendations"))
            {
                reader.AddParameter("siteid", siteId);
                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    //The stored procedure returns one row for each article. 
                    do
                    {
                        //Delegate creation of XML to Article class.
                        ArticleSummary articleSummary = ArticleSummary.CreateArticleSummaryFromReader(reader);
                        scoutRecommendations.Articles.Add(articleSummary);

                    } while (reader.Read());
                }
            }
            return scoutRecommendations;
        }
        /// <summary>
        /// Gets the scout recommendation list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static ScoutRecommendations CreateScoutRecommendations(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                int siteId)
        {
            return CreateScoutRecommendations(cache, readerCreator, siteId, 0, 20, false);
        }
  
        /// <summary>
        /// Gets the scout recommendation list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static ScoutRecommendations CreateScoutRecommendations(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                int siteId, 
                                                int skip, 
                                                int show,
                                                bool ignoreCache)
        {
            var scoutRecommendations = new ScoutRecommendations();

            string key = scoutRecommendations.GetCacheKey(siteId, skip, show);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                scoutRecommendations = (ScoutRecommendations)cache.GetData(key);
                if (scoutRecommendations != null)
                {
                    //check if still valid with db...
                    if (scoutRecommendations.IsUpToDate(readerCreator))
                    {
                        return scoutRecommendations;
                    }
                }
            }

            //create from db
            scoutRecommendations = CreateScoutRecommendationsFromDatabase(readerCreator, siteId, skip, show);

            scoutRecommendations.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, scoutRecommendations);

            return scoutRecommendations;
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return false;
        }
    }
}
