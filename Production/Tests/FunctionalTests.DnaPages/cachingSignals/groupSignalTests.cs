using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Users;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using FunctionalTests.Services.Comments;


namespace FunctionalTests
{
    /// <summary>
    /// Test to prove that the signals that refresh the groups cache are effective
    /// </summary>
    [TestClass]
    public class Group_Refresh_Signals_Tests
    {
        /// <summary>
        /// See that the signal generated by a C# page affect the API
        /// In general, all the calls here will crash the test if they do not succeed - the Database one is not explicitly fussy
        /// </summary>
        [TestMethod]
        public void cPlusToApi(){
            // Step 1. Try to create a comments forum using the API but as a normal user, should get unauthorised
            DnaTestURLRequest testUserReq = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            testUserReq.SetCurrentUserNormal();

            testUserReq = createForum(testUserReq, HttpStatusCode.Unauthorized); // will crash the test if it does not get the right status

            // Step 2. Use the Inspect User page (a C++ page) to update the user's groups
            setEdStatusCplus(testUserReq, true);

            // Step 3. Remove trace of this from the database, so that we can see that there is some caching somewhere
            clearFromDB(testUserReq);

            // Step 4. Try creating a comment forum again, should succeed because now the test user is an editor on the globally named site
            testUserReq = createForum(testUserReq, HttpStatusCode.OK);

            // Step 5. Use the Inspect User page (a C++ page) to update the user's groups
            setEdStatusCplus(testUserReq, false);

            // Step 6. Remove trace of this from the database
            clearFromDB(testUserReq);

            // Step 7. try creating a comment forum again, shuould succeed because now the test user is an editor on the globally named site
            testUserReq = createForum(testUserReq, HttpStatusCode.Unauthorized); // will crash the test if it does not get the right status


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

            string url = "http://" + testUtils_CommentsAPI.server + testUtils_CommentsAPI._resourceLocation + "/site/" +testUtils_CommentsAPI.sitename + "/";

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
                "Error making test comments forum. Wanted: " + expectedCode +"\nGot: " + myRequest.CurrentWebResponse.StatusCode + "\n" + myRequest.CurrentWebResponse.StatusDescription
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

        /*
        /// <summary>
        /// Test that we can manually send the recache site signal
        /// </summary>
        [Ignore]
        public void TestManualSignalSendToRecacheSiteListData()
        {
            Console.WriteLine("TestManualSignalSendToRecacheSiteListData");
            // Now get one of the times so we can do some checks
            String[] currentValues = _times[_timeParam].Split('_');

            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0],  currentValues[3]).InnerXml, currentValues[1]);

            // Now change the hour for the time and update the database
            string newTime = currentValues[0] + "_";
            int hour = Convert.ToInt32(currentValues[1]);
            if (hour < 1)
            {
                hour++;
            }
            else
            {
                hour--;
            }
            newTime += hour + "_" + currentValues[2] + "_" + currentValues[3];
            _times[_timeParam] = newTime;

            // Set the new time
            Assert.IsTrue(SetOpenCloseTimes(), "Failed to create the new open time for h2g2");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(),currentValues[0],currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]).InnerXml, currentValues[1]);

            // Now send the recache signal and check to make sure that the times are updated!
            request.RequestPage("dnasignal?action=recache-site&skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]).InnerXml, Convert.ToString(hour));

            // Finally set the time back to it's original time
            _times[_timeParam] = _originalValue;
            Assert.IsTrue(SetOpenCloseTimes(), "Failed to create the new open time for h2g2");

            // Double check to make sure it's back to normal
            request.RequestPage("dnasignal?action=recache-site&skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]).InnerXml, currentValues[1]);
        }

        /// <summary>
        /// Test that we can get the code to send the recache signal via the dot net application.
        /// This should send the request to the ripley application!
        /// </summary>
        [TestMethod]
        public void TestCodeSignalSendToRecacheSiteListDataViaDotNet()
        {
            Console.WriteLine("TestCodeSignalSendToRecacheSiteListDataViaDotNet");
            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now set the site to be closed
            Assert.IsTrue(SetSiteEmergencyClosed(true), "Failed to close h2g2");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now send the recache signal and check to make sure that the times are updated!
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");

                // Now check to make sure that the XML for the sitelist has not changed
                request.RequestPage("acs?skin=purexml");
                Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
                Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "1");

                // Now check to make sure that the XML for the sitelist has not changed
                request.RequestPage("?skin=purexml");
                Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
                Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "1");

                // Now set the site to be open
                Assert.IsTrue(SetSiteEmergencyClosed(false), "Failed to open h2g2");

                // Double check to make sure it's back to normal
                // Now send the recache signal and check to make sure that the times are updated!
                inputContext.SendSignal("action=recache-site");
            }
            // Now check to make sure that the closed value has been put back correctly
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the closed value has been put back correctly
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");
        }

        /// <summary>
        /// Test that we can get the code to send the recache signal via the ripley application.
        /// This should send the request to the dot net application!
        /// </summary>
        [Ignore]
        public void TestCodeSignalSendToRecacheSiteListDataViaRipley()
        {
            Console.WriteLine("TestCodeSignalSendToRecacheSiteListDataViaRipley");
            // Create the request for the test. Make sure we sign in as an editor
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.UseEditorAuthentication = true;
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            // Get the current open and close times for the h2g2 site
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now send a request to the ripley code to close the site and make sure the xml reflects the fact
            request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "1");

            // Check to make sure that the dot net web app got the signal and that the xml reflects the fact!
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "1");

            // Now send a request to the ripley code to open the site and make sure the xml reflects the fact
            request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Check to make sure that the dot net web app got the signal and that the xml reflects the fact!
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");
        }

        /// <summary>
        /// Make sure that the open close times are set back to there original values
        /// </summary>
        [TestCleanup]
        public void TidyUp()
        {
            // Make sure the times get put back correctly
            SetSiteEmergencyClosed(false);
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");
            }
        }

        private XmlNode GetMatchingNode(XmlDocument xml, string param1, string param2)
        {
            // Return the node if found that matches the given criteria
            return xml.SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[DAYOFWEEK='" + param1 + "'][CLOSED='" + param2 + "']/HOUR");
        }

        private void GetOpenCloseTimes()
        {
            // Create a new dictionary
            _times = new Dictionary<string, string>();

            // Fill the times dictionary with the current open close times for h2g2
            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");

            // Check to see if we've got openclose times for this site
            if (request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME/DAYOFWEEK") == null)
            {
                // no times! Set daily repeating times for the site
                request.UseEditorAuthentication = true;
                request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.EDITOR);
                request.RequestPage("messageboardschedule?action=update&updatetype=sameeveryday&recurrenteventopenhours=0&recurrenteventopenminutes=15&recurrenteventclosehours=23&recurrenteventcloseminutes=45&skin=purexml");
                request.UseEditorAuthentication = false;

                // Now re-request the original page
                request.RequestPage("acs?skin=purexml");
            }

            for (int i = 1, k = 0; i <= 7; i++)
            {
                _times.Add("param" + k++, GetTimes(request.GetLastResponseAsXML(), i, 0));
                _times.Add("param" + k++, GetTimes(request.GetLastResponseAsXML(), i, 1));
            }
        }

        private string GetTimes(XmlDocument xml, int day, int closed)
        {
            StringBuilder time = new StringBuilder();
            time.Append(day + "_" + xml.SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[DAYOFWEEK='" + day + "'][CLOSED='" + closed + "']/HOUR").InnerText);
            time.AppendFormat("_" + xml.SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[DAYOFWEEK='" + day + "'][CLOSED='" + closed + "']/MINUTE").InnerText + "_" + closed);
            return time.ToString();
        }

        private bool SetOpenCloseTimes()
        {
            // First delete the current open closing times
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("deletescheduledevents"))
                {
                    dataReader.AddParameter("siteid", 1);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }

            // Call the stored procedure directly as we don't want the signaling to be done automatically in this test!
            try
            {
                // First set the new open time for sunday
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("updatesitetopicsopencloseschedule"))
                {
                    dataReader.AddParameter("siteid", 1);

                    // Now fo through the dictionay adding the values
                    for (int i = 0; i < _times.Count; i++)
                    {
                        dataReader.AddParameter("param" + i, _times["param" + i]);
                    }
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }
            return true;
        }

        private bool SetSiteEmergencyClosed(bool setClosed)
        {
            // Set the value in the database
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("updatesitetopicsclosed"))
                {
                    dataReader.AddParameter("siteid", 1);
                    dataReader.AddParameter("siteemergencyclosed", setClosed ? 1 : 0);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }

            return true;
        }
        */

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("Group cache signal Test StartUp");
            // First get the open close times for the h2g2 site
            //GetOpenCloseTimes();
            //_originalValue = _times[_timeParam];
            SnapshotInitialisation.RestoreFromSnapshot();
            /*
            SetSiteEmergencyClosed(false);
             * using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");
            }
             * */
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                var g = new UserGroups(inputContext.ReaderCreator, inputContext.dnaDiagnostics, CacheFactory.GetCacheManager(), null, null);
            }
            

        }

    }
}
