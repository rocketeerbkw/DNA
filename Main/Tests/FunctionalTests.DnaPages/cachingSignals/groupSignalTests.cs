using BBC.Dna.Data;
using BBC.Dna.Sites;
using FunctionalTests.Services.Comments;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net;
using System.Threading;
using System.Xml;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test to prove that the signals that refresh the groups cache are effective
    /// </summary>
    [TestClass]
    public class Group_Refresh_Signals_Tests
    {

        [TestInitialize]
        [TestCleanup]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            DnaTestURLRequest testUserReq = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);
            testUserReq.SetCurrentUserNormal();
            clearFromDB(testUserReq);
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-groups");
            }
        }

        /// <summary>
        /// See that the signal generated by a C# page affect the API
        /// In general, all the calls here will crash the test if they do not succeed - the Database one is not explicitly fussy
        /// </summary>
        [TestMethod]
        public void cPlusToApi()
        {
            // Step 1. Try to create a comments forum using the API but as a normal user, should get unauthorised
            DnaTestURLRequest testUserReq = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            testUserReq.SetCurrentUserNormal();

            testUserReq = createForum(testUserReq, HttpStatusCode.Unauthorized); // will crash the test if it does not get the right status

            // Step 2. Use the Inspect User page (a C++ page) to update the user's groups
            setEdStatusCplus(testUserReq, true);

            Thread.Sleep(5000);

            // Step 3. Remove trace of this from the database, so that we can see that there is some caching somewhere
            clearFromDB(testUserReq);

            // Step 4. Try creating a comment forum again, should succeed because now the test user is an editor on the globally named site
            testUserReq = createForum(testUserReq, HttpStatusCode.OK);

        }

        /// <summary>
        /// Remove all the groups from the user given in the parameter
        /// </summary>
        /// <param name="testUserReq">the user to be affected</param>
        private void clearFromDB(DnaTestURLRequest testUserReq)
        {
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    ISiteList _siteList = SiteList.GetSiteList();
                    ISite site = _siteList.GetSite(testUtils_CommentsAPI.sitename);

                    string sqlStr = "delete from GroupMembers where UserId=" + testUserReq.CurrentUserID;
                    reader.ExecuteDEBUGONLY(sqlStr);

                    sqlStr = "select * from GroupMembers where UserId=" + testUserReq.CurrentUserID;
                    reader.ExecuteDEBUGONLY(sqlStr);

                    Assert.IsFalse(reader.HasRows, "Error clearing the databse. The user whoulc have no rows in the groupMembers table");
                }
            }
        }


        /// <summary>
        /// Using a C++ page, update the user, giving it edditor in the site
        /// uses the server and sitename from the utils object
        /// </summary>
        /// <param name="userId">the ID if the user to promote</param>
        private void setEdStatusCplus(DnaTestURLRequest testUserReq, bool setItOn)
        {
            //string queryStr = "";
            XmlDocument thePage;
            string url = "";
            string postData = "UserID=" + testUserReq.CurrentUserID + "&cmd=UpdateGroups";

            DnaTestURLRequest edUserReq = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            if (setItOn)
                postData += "&GroupsMenu=EDITOR";

            edUserReq.SetCurrentUserEditor();
            edUserReq.UseEditorAuthentication = true;

            url = "http://" + testUtils_CommentsAPI.server + "/dna/" + testUtils_CommentsAPI.sitename + "/inspectuser?skin=purexml";

            try
            {
                edUserReq.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch
            {
                // Don't loose control
            }

            thePage = edUserReq.GetLastResponseAsXML();

            Assert.IsTrue(edUserReq.CurrentWebResponse.StatusCode == HttpStatusCode.OK,
                "Failed to make . Wanted: OK\nGot: " + edUserReq.CurrentWebResponse.StatusCode + "\n" + edUserReq.CurrentWebResponse.StatusDescription
                );

        }

        /// <summary>
        /// Helper function that attempts to create a comments forum using the API
        /// </summary>
        /// <param name="myRequest">A request - this contains all the data like the user and stuff</param>
        /// <returns>the request - containing the result of the attempt</returns>
        private DnaTestURLRequest createForum(DnaTestURLRequest myRequest, HttpStatusCode expectedCode)
        {
            string id = "";
            string title = "";
            string parentUri = ""; // not actually going to do anything with these, but need to give them the postXML

            string url = "http://" + testUtils_CommentsAPI.server + testUtils_CommentsAPI._resourceLocation + "/site/" + testUtils_CommentsAPI.sitename + "/";

            string postXML = testUtils_CommentsAPI.makePostXml(ref id, ref title, ref parentUri); // make some unique data for the new forum

            try
            {
                myRequest.RequestPageWithFullURL(url, postXML, "text/xml");
            }
            catch
            {
                // Don't loose control
            }

            Assert.IsTrue(myRequest.CurrentWebResponse.StatusCode == expectedCode,
                "Error making test comments forum. Wanted: " + expectedCode + "\nGot: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
                );

            return myRequest;
        }

        /// <summary>
        /// Build an appropraite query string using the user data that is in the request
        /// </summary>
        /// <param name="myRequest"></param>
        /// <returns></returns>
        private string makeQuery(DnaTestURLRequest tstUsrReq, DnaTestURLRequest edUsrReq)
        {
            //UserID=13954729&FetchUserID=13954729&UserName=mpg-ed&EmailAddress=dnatestuser%2B2@googlemail.com&Title=&FirstNames=mpg&LastName=ed&Status=1&Password=&GroupsMenu=FIELDRESEARCHERS&GroupsMenu=EDITOR&UpdateGroups=Update+Groups&ScoutQuota=0&ScoutInterval=day&RecommendationsPeriod=month&SubQuota=0&SubAllocationsPeriod=month
            string qSt = "";
            qSt += "UserID=" + edUsrReq.CurrentUserID + "&";
            qSt += "FetchUserID=" + tstUsrReq.CurrentUserID + "&";
            qSt += "UserName=" + tstUsrReq.CurrentUserName + "&";
            //qSt += "EmailAddress=" + "dnatestuser%2B2@googlemail.com" + "&"; // dummy
            qSt += "GroupsMenu=EDITOR&UpdateGroups=Update+Groups" + "&";

            return qSt;
        }

    }
}

