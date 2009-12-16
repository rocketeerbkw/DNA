using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// The review forum class
    /// </summary>
    public class ReviewForum : DnaInputComponent
    {
        /// <summary>
        /// Order by type for the Review Forum
        /// </summary>
	    public enum OrderBy 
        {
            /// <summary>
            /// Date entered ordered review forum
            /// </summary>
            DATEENTERED = 1,
            /// <summary>
            /// Last posted ordered review forum
            /// </summary>
            LASTPOSTED = 2,
            /// <summary>
            /// Author ID ordered review forum
            /// </summary>
            AUTHORID = 3,
            /// <summary>
            /// Author Name ordered review forum
            /// </summary>
            AUTHORNAME = 4,
            /// <summary>
            /// H2G2 ID ordered review forum
            /// </summary>
            H2G2ID = 5,
            /// <summary>
            /// Subject ordered review forum
            /// </summary>
            SUBJECT = 6
        };

        XmlElement _reviewForum;

        bool _initialised;
        /// <summary>
        /// Accesor for IsInitialised
        /// </summary>
        public bool IsInitialised
        {
            get { return _initialised; }
            set { _initialised = value; }
        }

        bool _recommend;
        /// <summary>
        /// Accesor for IsRecommendable
        /// </summary>
        public bool IsRecommendable
        {
            get { return _recommend; }
            set { _recommend = value; }
        }

        int _reviewForumID;
        /// <summary>
        /// Accesor for ReviewForumID
        /// </summary>
        public int ReviewForumID
        {
            get { return _reviewForumID; }
            set { _reviewForumID = value; }
        }

        int _H2G2ID;
        /// <summary>
        /// Accesor for H2G2ID
        /// </summary>
        public int H2G2ID
        {
            get { return _H2G2ID; }
            set { _H2G2ID = value; }
        }

        int _siteID;
        /// <summary>
        /// Accesor for SiteID
        /// </summary>
        public int SiteID
        {
            get { return _siteID; }
            set { _siteID = value; }
        }

        int _incubateTime;
        /// <summary>
        /// Accesor for IncubateTime
        /// </summary>
        public int IncubateTime
        {
            get { return _incubateTime; }
            set { _incubateTime = value; }
        }

        string _reviewForumName;
        /// <summary>
        /// Accesor for ReviewForumName
        /// </summary>
        public string ReviewForumName
        {
            get { return _reviewForumName; }
            set { _reviewForumName = value; }
        }

        string _urlFriendlyName;
        /// <summary>
        /// Accesor for UrlFriendlyName
        /// </summary>
        public string UrlFriendlyName
        {
            get { return _urlFriendlyName; }
            set { _urlFriendlyName = value; }
        }

        /// <summary>
        /// The default constructor
        /// </summary>
        public ReviewForum(IInputContext context)
            : base(context)
        {
        }


        /// <summary>
        /// Allows a review forum to be initialised with a ReviewForumID
        /// </summary>
        /// <param name="reviewForumID"></param>
        /// <param name="alwaysFromDB"></param>
        public void InitialiseViaReviewForumID(int reviewForumID, bool alwaysFromDB)
        {
            Initialise(reviewForumID, true, alwaysFromDB);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="H2G2ID"></param>
        /// <param name="alwaysFromDB"></param>
        public void InitialiseViaH2G2ID(int H2G2ID, bool alwaysFromDB)
        {
            Initialise(H2G2ID, false, alwaysFromDB);
        }

        /// <summary>
        /// Initialises the object with the details about the current review forum / article
        /// </summary>
        /// <param name="ID">H2G2ID or ReviewForumID</param>
        /// <param name="isReviewForumID">Is this a review Forum ID or H2G2ID</param>
        /// <param name="alwaysFromDB">set to true if you want info from DB always no cache</param>
        private void Initialise(int ID, bool isReviewForumID, bool alwaysFromDB)
        {
            RootElement.RemoveAll();

	        string cachename = "RF";
            cachename += "-" + ID + ".txt";

            _initialised = false;

            if (isReviewForumID)
            {

                DateTime expires = DateTime.Now - new TimeSpan(12, 0, 0);	//expire after 12 hours

                string reviewForumCache = String.Empty;

                //get it from the cache if you can
                if (!alwaysFromDB && InputContext.FileCacheGetItem("reviewforums", cachename, ref expires, ref reviewForumCache))
                {
                    //int iVarsRead = sscanf(sReviewForum, "%d\n%d\n%d\n%d\n%d\n%[^\n]\n%s[^\n]", &iReviewForumID, &iH2G2ID, &iSiteID, &iRecommend, &iIncubateTime, &sReviewForumName, &sURLFriendlyName);

                    char newLine = '\n';
                    String[] splitString = reviewForumCache.Split(newLine);
                    int recommend = 0;

                    Int32.TryParse(splitString[0], out _reviewForumID);
                    Int32.TryParse(splitString[1], out _H2G2ID);
                    Int32.TryParse(splitString[2], out _siteID);
                    Int32.TryParse(splitString[3], out recommend);
                    Int32.TryParse(splitString[4], out _incubateTime);

                    _reviewForumName = splitString[5];
                    _urlFriendlyName = splitString[6];

                    if (recommend == 1)
                    {
                        _recommend = true;
                    }
                    else
                    {
                        _recommend = false;
                    }
                    _initialised = true;
                }
            }
            if (!_initialised)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchreviewforumdetails"))
                {
                    if (isReviewForumID)
                    {
                        dataReader.AddParameter("reviewforumid", ID);
                    }
                    else
                    {
                        dataReader.AddParameter("h2g2id", ID);
                    }

                    dataReader.Execute();
                    // Check to see if we found anything
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        _reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                        _reviewForumName = dataReader.GetStringNullAsEmpty("forumname");
                        _urlFriendlyName = dataReader.GetStringNullAsEmpty("urlfriendlyname");
                        _H2G2ID = dataReader.GetInt32NullAsZero("h2g2id");
                        _siteID = dataReader.GetInt32NullAsZero("siteid");
                        _incubateTime = dataReader.GetInt32NullAsZero("IncubateTime");
                        if (dataReader.GetByteNullAsZero("recommend") == 1)
                        {
                            _recommend = true;
                        }
                        else
                        {
                            _recommend = false;
                        }

                        string reviewForum = String.Empty;
                        reviewForum += _reviewForumID + "\n";
                        reviewForum += _H2G2ID + "\n";
                        reviewForum += _siteID + "\n";
                        reviewForum += _recommend + "\n";
                        reviewForum += _incubateTime + "\n";
                        reviewForum += _reviewForumName + "\n";
                        reviewForum += _urlFriendlyName + "\n";

                        InputContext.FileCachePutItem("reviewforums", cachename, reviewForum);
                        _initialised = true;
                    }
                    else
                    {
                        XmlElement reviewForumError = AddElementTag(RootElement, "REVIEWFORUM");
                        AddErrorXml("BADID", "The review forum id is invalid.", reviewForumError);
                        return;
                    }
                }
            }
            //Now build the XML
            _reviewForum = AddElementTag(RootElement, "REVIEWFORUM");
            AddAttribute(_reviewForum, "ID", _reviewForumID);
            AddTextTag(_reviewForum, "FORUMNAME", _reviewForumName);
            AddTextTag(_reviewForum, "URLFRIENDLYNAME", _urlFriendlyName);
            if (IsRecommendable)
            {
                AddIntElement(_reviewForum, "RECOMMENDABLE", 1);
            }
            else
            {
                AddIntElement(_reviewForum, "RECOMMENDABLE", 0);
            }
            AddIntElement(_reviewForum, "H2G2ID", _H2G2ID);
            AddIntElement(_reviewForum, "SITEID", _siteID);
            AddIntElement(_reviewForum, "INCUBATETIME", _incubateTime);
        }

        /// <summary>
        /// Initialise the data from passed in values
        /// </summary>
        /// <param name="reviewForumID"></param>
        /// <param name="forumName"></param>
        /// <param name="urlFriendlyName"></param>
        /// <param name="incubateTime"></param>
        /// <param name="recommend"></param>
        /// <param name="H2G2ID"></param>
        /// <param name="siteID"></param>
        public void InitialiseFromData(int reviewForumID,string forumName, string urlFriendlyName, int incubateTime, bool recommend, int H2G2ID, int siteID)
        {
	        _reviewForumID = reviewForumID;
            _reviewForumName = forumName;
            _urlFriendlyName = urlFriendlyName;
	        //this will be a NULL value but is left in for legacy reasons
	        _H2G2ID = H2G2ID;
	        _siteID = siteID;
	        _incubateTime = incubateTime;
	        _recommend = recommend;
	        _initialised = true;
        }

        /// <summary>
        /// Gets the Review Forum Thread List
        /// </summary>
        /// <param name="numThreads"></param>
        /// <param name="numSkipped"></param>
        /// <param name="orderBy"></param>
        /// <param name="ascending"></param>
        public void GetReviewForumThreadList(int numThreads, int numSkipped, OrderBy orderBy, bool ascending)
        {
            if (!_initialised)
            {
                throw new DnaException("NOT INITIALISED - Tried to use review forum without initialising");
            }
            if (numThreads == 0)
            {
                throw new DnaException("ZERO THREADS - Stupid to not fetch any threads from forum");
            }
	        string cachename = "RFT";
	        cachename += _reviewForumID.ToString() + "-" + orderBy.ToString() + "-" + ascending.ToString() + "-" + numSkipped.ToString() + "-" + (numSkipped + numThreads - 1).ToString() + ".txt";

            string reviewForumXml = String.Empty;

            DateTime lastDate;

            //find out the cache dirty date
            lastDate = CacheGetMostRecentReviewForumThreadDate(_reviewForumID);

            //get it from the cache if you can
            if (InputContext.FileCacheGetItem("reviewforums", cachename, ref lastDate, ref reviewForumXml))
            {
                // Create the review forums thread list from the cache
                CreateAndInsertCachedXMLToANode(reviewForumXml, "REVIEWFORUMTHREADS", true, "REVIEWFORUM");

                // Finally update the relative dates and return
                UpdateRelativeDates();
                return;
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(GetReviewForumThreadsStoredProcedure(orderBy)))
            {
                dataReader.AddParameter("reviewforumid", _reviewForumID);
                dataReader.AddParameter("ascending", ascending);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    // Got a list, so let's skip the first NumSkipped threads
                    if (numSkipped > 0)
                    {
                        //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
                        //the one required
                        for (int i = 0; i < numSkipped; i++)
                        {
                            dataReader.Read();
                        }
                    }

                    int index = 0;
                    int forumID = dataReader.GetInt32NullAsZero("forumid");

                    //now lets build up the review forums threads xml
                    XmlElement reviewForumThreads = AddElementTag(_reviewForum, "REVIEWFORUMTHREADS");
                    AddAttribute(reviewForumThreads, "FORUMID", forumID);
                    AddAttribute(reviewForumThreads, "SKIPTO", numSkipped);
                    AddAttribute(reviewForumThreads, "COUNT", numThreads);

                    int totalThreads = dataReader.GetInt32NullAsZero("ThreadCount");
                    AddAttribute(reviewForumThreads, "TOTALTHREADS", totalThreads);
                    AddAttribute(reviewForumThreads, "ORDERBY", (int) orderBy);
                    AddAttribute(reviewForumThreads, "DIR", ascending);

                    do
                    {
                        int threadID = dataReader.GetInt32NullAsZero("ThreadID");
                        string subject = dataReader.GetStringNullAsEmpty("Subject");
                        DateTime datePosted = dataReader.GetDateTime("LastPosted");
                        DateTime dateEntered = dataReader.GetDateTime("DateEntered");
                        int H2G2ID = dataReader.GetInt32NullAsZero("h2g2id");
                        int authorID = dataReader.GetInt32NullAsZero("authorid");
                        int submitterID = dataReader.GetInt32NullAsZero("submitterid");
                        string userName = dataReader.GetStringNullAsEmpty("username");

                        XmlElement thread = AddElementTag(reviewForumThreads, "THREAD");
                        AddAttribute(thread, "INDEX", index);
                        AddIntElement(thread, "THREADID", threadID);
                        AddIntElement(thread, "H2G2ID", H2G2ID);
                        AddTextTag(thread, "SUBJECT", subject);
                        AddDateXml(datePosted, thread, "DATEPOSTED");
                        AddDateXml(dateEntered, thread, "DATEENTERED");

                        XmlElement authorElement = AddElementTag(thread, "AUTHOR");
                        XmlElement submitterElement = AddElementTag(thread, "SUBMITTER");

                        XmlElement user = AddElementTag(authorElement, "USER");
                        AddIntElement(user, "USERID", authorID);
                        AddTextTag(user, "USERNAME", userName);

                        XmlElement subuser = AddElementTag(submitterElement, "USER");
                        AddIntElement(subuser, "USERID", submitterID);

                    /*
                      User author = new User(InputContext);
                      author.AddUserXMLBlock(dataReader, authorID, authorElement);

                      User submitter = new User(InputContext);
                      submitter.AddPrefixedUserXMLBlock(dataReader, submitterID, submitterElement);
                    */

                        numThreads--;
                        index++;

                    } while (numThreads > 0 && dataReader.Read());

                    // See if there's an extra row waiting
                    if (numThreads == 0 && dataReader.Read())
                    {
                        AddAttribute(reviewForumThreads, "MORE", 1);
                    }

                    InputContext.FileCachePutItem("reviewforums", cachename, reviewForumThreads.OuterXml);
                    UpdateRelativeDates();
                }
            }
        }
        /// <summary>
        /// Whether all the names for the site are unique
        /// </summary>
        /// <param name="name"></param>
        /// <param name="URL"></param>
        /// <param name="siteID"></param>
        /// <returns>Whether the names are unique for that site</returns>
        public bool AreNamesUniqueWithinSite(string name, string URL, int siteID)
        {
            bool unique = true;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchallreviewforumdetails"))
            {
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    do
                    {
                        string reviewForumName = dataReader.GetStringNullAsEmpty("ForumName");
                        string URLFriendlyName = dataReader.GetStringNullAsEmpty("URLFriendlyName");
                        int nextSiteID = dataReader.GetInt32NullAsZero("SiteID");
                        //if the review forum is in the same site and either of the names are the same then fail
                        if (nextSiteID == siteID && (reviewForumName == name || URLFriendlyName == URL))
                        {
                            unique = false;
                            break;
                        }
                    } while (dataReader.Read());
                }
            }
            return unique;
        }

        /// <summary>
        /// Gets the date of the thread in the reivew forum which was last posted to.
		///		This allows the cache of thread headers to know when it's dirty.
        /// </summary>
        /// <param name="reviewForumID">review forum id</param>
        /// <returns>returned date of last updated forum post</returns>
        private DateTime CacheGetMostRecentReviewForumThreadDate(int reviewForumID)
        {
            DateTime lastDate = DateTime.MinValue;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("cachegetmostrecentreviewforumthreaddate"))
            {
                dataReader.AddParameter("reviewforumid", reviewForumID);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    lastDate = DateTime.Now.Subtract(new TimeSpan(0, 0, dataReader.GetInt32("MostRecent")));
                }
            }
            return lastDate;
        }

        /// <summary>
        /// Gets the stored procedure to be called dependant on order by
        /// </summary>
        /// <param name="orderBy">what order by</param>
        /// <returns>Stored procedure name</returns>
        string GetReviewForumThreadsStoredProcedure(OrderBy orderBy)
        {
            string storedProcedure = String.Empty;
	        switch (orderBy)
	        {
                case OrderBy.DATEENTERED:
		        {
                    storedProcedure = "fetchreviewforumthreadsbydateentered";
                    break;
		        }

                case OrderBy.LASTPOSTED:
		        {
                    storedProcedure = "fetchreviewforumthreadsbylastposted";
                    break;
                }
                case OrderBy.AUTHORID:
		        {
                    storedProcedure = "fetchreviewforumthreadsbyuserid";
                    break;
                }
                case OrderBy.AUTHORNAME:
		        {
                    storedProcedure = "fetchreviewforumthreadsbyusername";
                    break;
                }
                case OrderBy.H2G2ID:
		        {
                    storedProcedure = "fetchreviewforumthreadsbyh2g2id";
                    break;
                }
                case OrderBy.SUBJECT:
		        {
                    storedProcedure = "fetchreviewforumthreadsbysubject";
                    break;
                }
	            default:
		        {
			        throw new DnaException("NO ORDER BY - Order by clause not specified or unknown.");
                }
	        }
            return storedProcedure;
        }

        /// <summary>
        /// Updates the review forum
        /// </summary>
        /// <param name="forumName"></param>
        /// <param name="urlFriendlyName"></param>
        /// <param name="recommend"></param>
        /// <param name="incubateTime"></param>
        public void Update(string forumName, string urlFriendlyName, bool recommend, int incubateTime)
        {
            if (!_initialised)
            {
                throw new DnaException("NOT INITIALISED - Tried to use review forum without initialising");
            }

            if (!recommend && incubateTime != _incubateTime)
            {
                incubateTime = _incubateTime;
            }
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updatereviewforum"))
            {
                dataReader.AddParameter("reviewforumid", _reviewForumID);
                dataReader.AddParameter("name", forumName);
                dataReader.AddParameter("url", urlFriendlyName);
                dataReader.AddParameter("recommend", recommend);
                dataReader.AddParameter("incubate", incubateTime);
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    int checkReviewForumID = dataReader.GetInt32NullAsZero("ID");
                    if (checkReviewForumID > 0)
                    {
                        _reviewForumName = forumName;
                        _urlFriendlyName = urlFriendlyName;
                        _incubateTime = incubateTime;
                        _recommend = recommend;
                    }
                }
            }
        }

        /// <summary>
        /// Creates a new reviewforum in the database
        /// </summary>
        /// <param name="forumName"></param>
        /// <param name="URLFriendlyName"></param>
        /// <param name="incubateTime"></param>
        /// <param name="recommend"></param>
        /// <param name="siteID"></param>
        /// <param name="userID"></param>
        public void CreateAndInitialiseNewReviewForum(string forumName, string URLFriendlyName, int incubateTime, bool recommend,int siteID, int userID)
        {        	
	        _urlFriendlyName = URLFriendlyName;
	        _reviewForumName = forumName;

	        // Get the user information

	        if (_reviewForumName == String.Empty || _urlFriendlyName == String.Empty || _urlFriendlyName.IndexOf(" ") >= 0 || siteID <= 0 || incubateTime < 0)
	        {
                throw new DnaException("INVALID PARAMETERS - Invalid parameters in CreateAndInitialiseNewReviewForum.");

                /*
		        TDVASSERT(forumName != String.Empty ,"NULL forumname in CReviewForum::AddNewReviewForum");
		        TDVASSERT(_urlFriendlyName != String.Empty ,"NULL forumname in CReviewForum::AddNewReviewForum");
		        TDVASSERT(_urlFriendlyName.Find(" ") < 0,"Spaces found in the URL");
		        TDVASSERT(incubateTime >= 0, "Invalid incubate time in CReviewForum::AddNewReviewForum");
		        TDVASSERT(siteID > 0,"invalid siteid in CReviewForum::AddNewReviewForum");
		        TDVASSERT(userID > 0,"invalid userid in CReviewForum::AddNewReviewForum");
		        return false;*/
	        }

	        ExtraInfo extrainfo = new ExtraInfo();
	        int typeID = (int) GuideEntry.GuideEntryType.TYPEREVIEWFORUM;
            if (!extrainfo.TryCreate(typeID, ""))
	        {
                throw new DnaException("ReviewForum - InitialiseAndCreateNewReviewForum - Failed to create extrainfo for reviewforum due bad element");
	        }
	        //pass in the object -not the string!
        	
	        int reviewForumID = 0;
            string hash = String.Empty;
            string hashString = forumName + "<:>" + URLFriendlyName + "<:>" + userID + "<:>" + siteID + "<:>" + extrainfo.RootElement.OuterXml + "<:>" + incubateTime + "<:>" + recommend;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("addnewreviewforum"))
            {
                dataReader.AddParameter("URLName", URLFriendlyName);
                dataReader.AddParameter("ReviewForumName", forumName);
                dataReader.AddParameter("Incubate", incubateTime);
                dataReader.AddParameter("Recommend", recommend);
                dataReader.AddParameter("SiteID", siteID);
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("extra", extrainfo.RootElement.OuterXml);
                dataReader.AddParameter("Type", typeID);
                dataReader.AddParameter("Hash", DnaHasher.GenerateHash(hashString));
                dataReader.Execute();
                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                }
            }
            if (reviewForumID > 0)
            {
                _recommend = recommend;
                _incubateTime = incubateTime;
                _siteID = siteID;
                _reviewForumID = reviewForumID;

                _initialised = true;
            }
        }    
    }
}
