using System;
using System.Net;
using System.Web;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Testing the creation of comments forums via the Comments API
    /// This set of tests check what happens with different types of user - normal people should not be able to create them
    /// In all cases, use the basic minimum of data
    /// </summary>
    
    public class testUtils_ratingsAPI
    {
        public const string _schemaRatingForum = "Dna.Services\\ratingForum.xsd";
        public const string _schemaRatingList = "Dna.Services\\ratingsList.xsd";
        public const string _schemaRating = "Dna.Services\\rating.xsd";
        public const string _schemaError = "Dna.Services\\error.xsd";

        public const string _resourceLocation = "/dna/api/comments/ReviewService.svc/V1/site";
        public const string _formPostUrlPart = "create.htm";


        public const int _implementedCeiling = 255; // documentation says "The score as a byte between 0-255"
        public const int _implementedFloor = 0;

        public static string server = DnaTestURLRequest.CurrentServer;
        public static string sitename = "h2g2";
        //public static string sitename = "Weather";
        //public static string _readByFidUrlStub = "http://" + server + _resourceLocation + sitename + "/reviewforum/" ;
        //public static string _createForumUrl = "http://" + server + _resourceLocation + sitename + "/";

        /*
        public static int runningForumCount = 0; // used to see our starting count, before we start adding forums.

        /// <summary>
        /// Simply count the number of commentsForums that have been created so far on this site
        /// </summary>
        /// <param name="SiteName">the name of the sute to query</param>
        /// <returns>the count</returns>
        /// As of the start of August 2009, this does not work because there is no 'list review fora attached to a a site'
        public static int countForums(string SiteName)
        {
            string _server = DnaTestURLRequest.CurrentServer;

            DnaTestURLRequest request = new DnaTestURLRequest(SiteName);

            request.SetCurrentUserNormal();

            // Setup the request url
            string url = "http://" + _server + _resourceLocation + SiteName + "/";

            // now get the response - no POST data, nor any clue about the input mime-type
            request.RequestPageWithFullURL(url, "", "");

            Assert.IsTrue(request.CurrentWebResponse.StatusCode == HttpStatusCode.OK);

            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaRatingForum);
            validator.Validate();

            BBC.Dna.Api.CommentForumList returnedList = (BBC.Dna.Api.CommentForumList)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Api.CommentForumList));
            Assert.IsTrue(returnedList != null);

            return returnedList.TotalCount;
        }
        */


        /// <summary>
        /// Make up some unique post data
        /// </summary>
        /// <returns>a string which is XML post data</returns>
        public static string makeCreatePostXml_minimal(ref string id, ref string title, ref string parentUri)
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = makeTimeStamp();

            if( id == "")
                id = "FunctiontestReviewForum-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string

            if (title == "")
                title = "Functiontest Title " + TimeStamp;

            if (parentUri == "")
                parentUri = "http://www.bbc.co.uk/dna/" +  TimeStamp + "/";

            string postXML = String.Format(
                "<ratingForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "</ratingForum>", 
                id, title, parentUri);

            return postXML;
        }

        /// <summary>
        /// Make the POST data as JSON
        /// </summary>
        public static String makeCreatePostJSON_minimal(ref string id, ref string title, ref string parentUri)
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = makeTimeStamp();

            if (id == "")
                id = "FunctiontestCommentForum-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string

            if (title == "")
                title = "Functiontest Title " + TimeStamp;

            if (parentUri == "")
                parentUri = "http://www.bbc.co.uk/dna/" + TimeStamp + "/";

            string postData = String.Format("id={0}&title={1}&parentUri={2}",
                HttpUtility.UrlEncode(id), HttpUtility.UrlEncode(title), HttpUtility.UrlEncode(parentUri)
                );

            return postData;
        }

        /// <summary>
        /// Make up some unique post data
        /// </summary>
        /// <returns>a string which is XML post data</returns>
        public static string makeEntryPostXml_minimal(ref string inputText, ref string inputRating)
        {
            System.Random RandNum = new System.Random();
            string postData = "";
            string rawText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque urna nunc, placerat nec tempus a, vehicula at justo. Vivamus vehicula hendrerit tincidunt. Aenean eleifend molestie purus et euismod. Nullam sapien elit, consectetur et tristique vel, molestie a ante. Nunc in elit in magna imperdiet faucibus vel vitae ligula. In ullamcorper";

            if (inputRating == "")  
                inputRating = RandNum.Next(1, 5).ToString();

            if( inputText == "" )
                inputText = rawText.Substring(RandNum.Next(0, 10), RandNum.Next(10, rawText.Length-21));

            postData = String.Format(
                "<rating xmlns=\"BBC.Dna.Api\"><text>{0}</text><rating>{1}</rating></rating>",
                inputText,
                inputRating
                );

            return postData;
        }

        /// <summary>
        /// Make the POST data as JSON
        /// </summary>
        public static String makeEntryPostJSON_minimal(ref string inputText, ref string inputRating)
        {
            System.Random RandNum = new System.Random();

            string postData = "";

            if (inputRating == "")
                inputRating = RandNum.Next(1, 5).ToString();

            if (inputText == "")
                inputText = "Functional test for Review API " + Guid.NewGuid().ToString();

            postData = String.Format("text={0}&rating={1}",
                HttpUtility.UrlEncode(inputText), HttpUtility.UrlEncode(inputRating)
                );

            return postData;
        }

        /// <summary>
        /// Create a forum in as simple a way as possible for the use of the review item creation tests
        /// </summary>
        /// <returns>ID of forum created</returns>
        public static string makeTestForum()
        {
            string id = "";
            string title = "";
            string parentUri = ""; // not actually going to do anything with these, but need to give them the postXML

            string url = makeCreateForumUrl(); 

            string postXML = makeCreatePostXml_minimal(ref id, ref title, ref parentUri); // make some unique data for the new forum

            DnaTestURLRequest myRequest = new DnaTestURLRequest(sitename);
            myRequest.SetCurrentUserEditor();

            try
            {
                myRequest.RequestPageWithFullURL(url, postXML, "text/xml");
            }
            catch
            {
                // Don't loose control
                string resp = myRequest.GetLastResponseAsString();
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to make the test forum. Expecting " + HttpStatusCode.OK + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));
            Assert.IsTrue(returnedForum.Id == id);
            
            return returnedForum.Id;
        }
        /*
        public static string makeTestItem(string forumId)
        {

            DnaTestURLRequest request = new DnaTestURLRequest(sitename);
            request.SetCurrentUserNormal();

            string text = "Functiontest Title" + Guid.NewGuid().ToString();
            string ratingForumXml = String.Format("<rating xmlns=\"BBC.Dna.Api\">" +
                "<text>{0}</text><rating>{1}</rating>" +
                "</rating>", text, 5);

            // Setup the request url
            string url = String.Format("http://" + server + "/dna/api/comments/ReviewService.svc/V1/site/{0}/reviewforum/{1}/", sitename, forumId);
            // now get the response
            request.RequestPageWithFullURL(url, ratingForumXml, "text/xml");
            // Check to make sure that the page returned with the correct information


            RatingInfo rating = (RatingInfo) StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(RatingInfo));
            return Convert.ToString(rating.ID);
        }
        */

        public static string makeTestItem(string forumId)
        {
            int index = 1; // give it a default value of 1
            return makeTestItem(forumId, index);
        }

        public static int maxNumDiffUsers = 5; // different users as avaialble below

        public static string makeTestItem(string forumId, int index)
        {
            
            System.Random RandNum = new System.Random();
            int inputRating = RandNum.Next(1, 5);
            string ratingString = "";
            string ratingScore = "";
            string postData = testUtils_ratingsAPI.makeEntryPostXml_minimal(ref ratingString, ref ratingScore);
            string url = makeCreatePostUrl(forumId);

            DnaTestURLRequest theRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            switch (index)
            {
                case 0: theRequest.SetCurrentUserNormal(); break;
                case 1: theRequest.SetCurrentUserNotableUser(); break;
                case 2: theRequest.SetCurrentUserModerator(); break;
                case 3: theRequest.SetCurrentUserProfileTest(); break;
                case 4: theRequest.SetCurrentUserEditor(); break;
                default: Assert.Fail("Can only set up 5 different users. Other users are particularly special"); break;
            }

            try
            {
                theRequest.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch
            {
                string resp = theRequest.GetLastResponseAsString();
            }

            Assert.IsTrue(theRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Error making test rating entity. Expecting " + HttpStatusCode.OK +
                " as response, got " + theRequest.CurrentWebResponse.StatusCode + "\n" +
                theRequest.CurrentWebResponse.StatusDescription
                );

            RatingInfo inf = (RatingInfo)StringUtils.DeserializeObject(theRequest.GetLastResponseAsString(), typeof(RatingInfo));

            return inf.ID.ToString();
        }

        public static string makeTimeStamp()
        {
            DateTime dt = DateTime.Now;
            String TimeStamp = dt.ToString("yyyyMMMMdddddHHmmssfff");

            return TimeStamp;
        }

        public static string forumEntryCount(string forumId)
        {
            string url = "http://" + server + "/" + _resourceLocation + "/" + sitename + "/" + "/reviewforum/" + forumId + "/";
            string formatParam = "text/xml";
            string postData = "";

            DnaTestURLRequest myRequest = new DnaTestURLRequest(sitename);
            myRequest.SetCurrentUserNormal();

            try
            {
                myRequest.RequestPageWithFullURL(url, postData, formatParam);
            }
            catch
            {
                // Don't loose control
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Expecting " + HttpStatusCode.OK + " as response, got " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            XmlDocument xml = myRequest.GetLastResponseAsXML();

            BBC.Dna.Api.RatingForum returnedForum = (BBC.Dna.Api.RatingForum)StringUtils.DeserializeObject(myRequest.GetLastResponseAsString(), typeof(BBC.Dna.Api.RatingForum));

            return returnedForum.ratingsList.TotalCount.ToString();

        }
        /// <summary>
        /// Get the ceiling value for a review forum. 
        /// Crashes if it fails
        /// </summary>
        /// <param name="testForumId">forum to be affected</param>
        /// <param name="forumCeiling">new value to be used by this forum</param>
        internal static void readCeiling(string testForumId )
        {
            string row = "";
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT * from dbo.ForumReview");

                while (reader.Read())
                {

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row = row + reader.GetName(i) + "=>" + reader.GetValue(i) + "\n";
                    }
                    row += "\n";
                }
            }
        }

        /*
        /// <summary>
        /// Get the ceiling value for a review forum. 
        /// Crashes if it fails
        /// </summary>
        /// <param name="testForumId">forum to be affected</param>
        /// <param name="forumCeiling">new value to be used by this forum</param>
        public static string readTable(string tableName)
        {
            string row = "";
            bool ftt = true;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT * from " + tableName);

                while (reader.Read())
                {
                    if (ftt)
                    {
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            row += reader.GetName(i) + "\t";
                        }
                        row += "\n";
                        ftt = false; 
                    }

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        row += reader.GetValue(i) + "\t";
                    }
                    row += "\n";
                }
            }
            return row;
        }
        */

        /// <summary>
        /// After a review form has been created, this will change the ceiling for the forum. 
        /// Crashes if it fails
        /// </summary>
        /// <param name="testForumId">forum to be affected</param>
        /// <param name="forumCeiling">new value to be used by this forum</param>
        internal static void setCeiling(string testForumId, string forumCeiling)
        {
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                string sqlStr;

                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    ISiteList _siteList = SiteList.GetSiteList(inputcontext.ReaderCreator, inputcontext.dnaDiagnostics, true);
                    ISite site = _siteList.GetSite(sitename);

                    sqlStr = "delete from siteoptions where siteid=" + site.SiteID.ToString() + " and Name='MaxForumRatingScore' ";
                    sqlStr += "insert into siteoptions (SiteID,Section,Name,Value,Type, Description) values(";
                    sqlStr += site.SiteID.ToString() + ",'CommentForum', 'MaxForumRatingScore'," + forumCeiling + ",0,'test MaxForumRatingScore value')"; 

                    reader.ExecuteDEBUGONLY(sqlStr);

                    // having changedd the value in the database, the cache must be updated too
                    // a call to any valid URL with the _ns=1 param should cause a refresh of the site cache

                    DnaTestURLRequest myRequest = new DnaTestURLRequest(sitename);
                    myRequest.RequestPageWithFullURL("http://" + server + "/dna/api/comments/CommentsService.svc/V1/commentsforums/?_ns=1", "", "text/xml");
                }
            }
        }

        public static string makeCreateForumUrl()
        {
            //http://dnadev.national.core.bbc.co.uk:8082/comments/ReviewService.svc/V1/site/{sitename}/
            return String.Format(
             "http://{0}/{1}/{2}/",
             testUtils_ratingsAPI.server,
             testUtils_ratingsAPI._resourceLocation,
             testUtils_ratingsAPI.sitename
             );
        }

        public static string makeCreatePostUrl(string forumId)
        {
            //http://dnadev.national.core.bbc.co.uk:8082/comments/ReviewService.svc/V1/site/{siteName}/reviewforum/{RatingForumID}/
            return String.Format(
             "http://{0}/{1}/{2}/reviewforum/{3}/",
             testUtils_ratingsAPI.server,
             testUtils_ratingsAPI._resourceLocation,
             testUtils_ratingsAPI.sitename,
             forumId
             );
        }

        public static string makeReadForumUrl(string forumID)
        {
            //http://dnadev.national.core.bbc.co.uk:8082/comments/ReviewService.svc/V1/site/{siteName}/reviewforum/{reviewForumId}/
            return String.Format(
                 "http://{0}/{1}/{2}/reviewforum/{3}/",
                testUtils_ratingsAPI.server,
                testUtils_ratingsAPI._resourceLocation,
                testUtils_ratingsAPI.sitename,
                forumID
             );
        }

    } // ends class
} // ends namespace
