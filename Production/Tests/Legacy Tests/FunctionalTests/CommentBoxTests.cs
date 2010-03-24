using System;
using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class CommentBoxTests
    {
        private bool _doOpenSite = false;
        private const string _schemaUri = "H2G2CommentBoxFlat.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After CommentBoxTests");
        }

        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateNewCommentForumAndComment()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewCommentForumAndComment");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";
            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE") == null, "End date missing when specified!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") != null, "Failed to post a comment!!!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='blahblahblah']") != null, "Posted comment did not appear!!!");

            Console.WriteLine("After CommentBoxTests - TestCreateNewCommentForumAndComment");
        }

        /// <summary>
        /// This test basically check to make sure we handle simple errors in the correct way
        /// </summary>
        [TestMethod]
        public void TestBasicErrorsAndParsing()
        {
            Console.WriteLine("Before CommentBoxTests - TestBasicErrorsAndParsing");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=premod&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check for parsing errors in guideml posts
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah2<From>NormalUser&dnahostpageurl=" + hosturl + "&dnapoststyle=1&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsNotNull(xml.SelectSingleNode("//ERROR[@TYPE='XmlParseError']"), "Failed to find the XMLError error");
            Assert.AreEqual("blahblahblah2%3CFrom%3ENormalUser", xml.SelectSingleNode("//ORIGINALPOSTTEXT").InnerText, "The original text should be 'blahblahblah2%C3From%3ENormalUser'");

            // Check for correct handling for profanities
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblah1blah3NormalUser fuck&dnahostpageurl=" + hosturl + "&poststyle=1&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsNotNull(xml.SelectSingleNode("//ERROR[@TYPE='profanityblocked']"), "Failed to find the Profanity Blocked error");
            Assert.AreEqual("blahblah1blah3NormalUser%20fuck", xml.SelectSingleNode("//ORIGINALPOSTTEXT").InnerText, "The original text should be 'blahblah1blah3NormalUser%20fuck'");

            Console.WriteLine("After CommentBoxTests - TestBasicErrorsAndParsing");
        }

        /// <summary>
        /// Test that we can create a premod forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateNewPreModCommentForumAndComment()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewPreModCommentForumAndComment");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=premod&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE") == null, "End date missing when specified!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@MODERATIONSTATUS='3']") != null, "The forums moderation status should be 3 (premod)");

            // Now check to make sure that a normal users post gets premoderated
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblahFromNormalUser&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") != null, "Failed to create new comment");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[@HIDDEN='3']") != null, "Failed to create new comment with hidden status 3");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[SUBJECT='Hidden']") != null, "Failed to create new comment with hidden subject");

            // Now check to make sure that a notable can post a comment without being moderated
            request.SetCurrentUserNotableUser();
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblahFromNotableUser&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "2", "The forum should have 2 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='blahblahblahFromNotableUser']") != null, "Posted comment did not appear for notable!!!");

            // Now check to make sure that a editor can post a comment without being moderated
            request.SetCurrentUserEditor();
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblahFromEditor&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "3", "The forum should have 3 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='blahblahblahFromEditor']") != null, "Posted comment did not appear for editor!!!");

            Console.WriteLine("After CommentBoxTests - TestCreateNewPreModCommentForumAndComment");
        }

        /// <summary>
        /// Tear down function that ensures that the site is in the non emergency closed state!
        /// </summary>
        public void EnsureSiteBackToOrginalState()
        {
            Console.WriteLine("Before CommentBoxTests - EnsureSiteBackToOrginalState");
            if (_doOpenSite)
            {
                SetSiteEmergencyClosed(false);
                //// Make sure the site is open
                //DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
                //request.SetCurrentUserEditor();
                //request.UseEditorAuthentication = true;
                //request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
                //XmlDocument xml = request.GetLastResponseAsXML();
                //Assert.IsTrue(xml.SelectSingleNode("/H2G2[SITE-CLOSED='0']") != null, "The haveyoursay site was not reopened correctly! Please check your database!");

                //// Now wait untill the .net has been signaled by ripley that we need to recache site data. Emergency closed is in the data!!!
                //// Make sure we've got a drop clause after 15 seconds!!!
                //DateTime time = DateTime.Now.AddSeconds(15);
                //bool siteIsOpen = false;
                //while (!siteIsOpen && time > DateTime.Now)
                //{
                //    request.RequestPage("acswithoutapi?skin=purexml");
                //    siteIsOpen = request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED").InnerXml.CompareTo("0") == 0;
                //}
            }
            _doOpenSite = false;

            Console.WriteLine("After CommentBoxTests - EnsureSiteBackToOrginalState");
        }

        /*
        /// <summary>
        /// Helper method that signals for a site to be closed/open and then waits for that site to recieve and process the signal
        /// </summary>
        /// <param name="siteClosed">The state that you want tohe site to be in. 1 = closed, 0 = open</param>
        /// <returns>True if the site was updated, false if not</returns>
        private static bool SignalAndWaitforSiteToOpenOrClose(int siteClosed)
        {
            // Make sure the site is open
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            if (siteClosed > 0)
            {
                request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
            }
            else
            {
                request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
            }

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[SITE-CLOSED='" + siteClosed.ToString() + "']") != null, "The haveyoursay site was not updated correctly! Please check your database!");

            // Now wait untill the .net has been signaled by ripley that we need to recache site data. Emergency closed is in the data!!!
            // Make sure we've got a drop clause after 15 seconds!!!
            int tries = 0;
            bool updated = false;
            Console.Write("Waiting for open/close signal to be processed ");
            while (tries++ <= 20 && !updated)
            {
                //request.RequestPage("acswithoutapi?skin=purexml");
                if (siteClosed > 0)
                {
                    request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
                }
                else
                {
                    request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
                } 
                
                if (request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED") != null)
                {
                    updated = request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED").InnerXml.CompareTo(siteClosed.ToString()) == 0;

                    if (!updated)
                    {
                        // Goto sleep for 5 secs
                        System.Threading.Thread.Sleep(5000);
                        Console.Write(".");
                    }
                }
            }
            tries *= 5;
            Console.WriteLine(" waited " + tries.ToString() + " seconds.");
            return updated;
        }
         * */
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

            using (FullInputContext inputContext = new FullInputContext(false))
            {
                inputContext.SendSignal("action=recache-site");
            }

            return true;
        }


        

        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated emergency closed site
        /// </summary>
        [TestMethod]
        public void TestCreateNewCommentForumAndCommentOnEmergencyClosedSite()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewCommentForumAndCommentOnEmergencyClosedSite");
            _doOpenSite = true;

            // Start by emergency closing the site.
            Assert.IsTrue(SetSiteEmergencyClosed(true), "Failed to close the site in a timely fashion!!!");

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            
            //request.SetCurrentUserEditor();
            //request.UseEditorAuthentication = true;
            //request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
            //XmlDocument xml = request.GetLastResponseAsXML();
            //Assert.AreEqual(xml.SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "1", "The haveyoursay site was not closed correctly! Please check your database!");

            //// Now wait untill the .net has been signaled by ripley that we need to recache site data. Emergency closed is in the data!!!
            //// Make sure we've got a drop clause after 15 seconds!!!
            //DateTime time = DateTime.Now.AddSeconds(30);
            //bool siteIsClosed = false;
            //while (!siteIsClosed && time > DateTime.Now)
            //{
            //    request.RequestPage("acswithoutapi?skin=purexml");
            //    if (request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED") != null)
            //    {
            //        siteIsClosed = request.GetLastResponseAsXML().SelectSingleNode("//SITE/SITECLOSED").InnerXml.CompareTo("1") == 0;
            //    }
            //}

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = false;
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE") == null, "End date missing when specified!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0");
            Assert.IsTrue(xml.SelectSingleNode("//SITE[SITECLOSED='1']") != null, "haveyoursay site is not closed when we set the test to close it.");

            // Now check to make sure that a normal users post gets premoderated
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblahFromNormalUser&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "0", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") == null, "Normal user should not be able to post to a closed site!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0");
            Assert.IsTrue(xml.SelectSingleNode("//SITE[SITECLOSED='1']") != null, "haveyoursay site is not closed when we set the test to close it.");

            // Now check to make sure that a notable can post a comment without being moderated
            request.SetCurrentUserNotableUser();
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblahFromNotableUser&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "0", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") == null, "Notable user should not be able to post to a closed site!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0");
            Assert.IsTrue(xml.SelectSingleNode("//SITE[SITECLOSED='1']") != null, "haveyoursay site is not closed when we set the test to close it.");

            // Now check to make sure that a editor can post a comment without being moderated
            request.SetCurrentUserEditor();
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblahFromEditor&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='blahblahblahFromEditor']") != null, "Posted comment did not appear for editor!!!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0 even for editors as the forum is cached as if a normal user is viewing the page when closed");
            Assert.IsTrue(xml.SelectSingleNode("//SITE[SITECLOSED='1']") != null, "haveyoursay site is not closed when we set the test to close it.");


            SetSiteEmergencyClosed(false);
            Console.WriteLine("After CommentBoxTests - TestCreateNewCommentForumAndCommentOnEmergencyClosedSite");
        }

        [TestMethod]
        public void TestCreateCommentSiteError()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestCreateCommentWithChangeSite";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Now change site
            request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();

            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=TestCreateCommentWithChangeSite&dnahostpageurl=" + hosturl + "&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ERROR[@TYPE='commentfailed-invalidsite']") != null,"Error not created." );
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "0", "Comment appears to have been created from a different site.");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") == null, "Post was created where it was not expected.");
          
        }


        [TestMethod]
        public void TestCommentWithDodgyCharInIt()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            Console.WriteLine("Before CommentBoxTests - TestCommentWithDodgyCharInIt");

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=Test<character&dnahostpageurl=" + hosturl + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/TEXT").InnerText == "Test<character", "Post was created with the comment marked up.");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/TEXT").InnerXml == "Test&lt;character", "Post was created with the comment marked up.");

            Console.WriteLine("After CommentBoxTests -  TestCommentWithDodgyCharInIt");
        }

        [TestMethod]
        public void TestCommentWithALinkWithCRLFInIt()
        {
            Console.WriteLine("Before CommentBoxTests - TestCommentWithALinkWithCRLFInIt");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            //string dodgyLink = @"<a href='#" + "\r\n" + @"'>Test Link</a>";
            string dodgyLink = @"<a href=""http:" + "%0D%0A" + @""">Test Link</a>";
            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?skin=purexml&dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah" + dodgyLink + "&dnahostpageurl=" + hosturl);

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/TEXT").InnerText == "blahblahblah<a href=\"http:\">Test Link</a>", "Post was created with the comment cut off.");

            Console.WriteLine("After CommentBoxTests -  TestCommentWithALinkWithCRLFInIt");
        }
        [TestMethod]
        public void TestCommentWithALinkWithCRLFInItPostStyle1()
        {
            Console.WriteLine("Before CommentBoxTests - TestCommentWithALinkWithCRLFInItPostStyle1");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();

            string dodgyLink = @"<a href=""#" + "\r\n" + @""">Test Link</a>";
            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?skin=purexml&dnapoststyle=1&dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah" + dodgyLink + "&dnahostpageurl=" + hosturl);

            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            //<ERROR TYPE="XmlParseError">
            //<ERRORMESSAGE>The comment contains invalid xml.</ERRORMESSAGE> 
            //</ERROR>

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ERROR[@TYPE='XmlParseError']") != null, "Error not created.");

            Console.WriteLine("After CommentBoxTests -  TestCommentWithALinkWithCRLFInItPostStyle1");
        }

        /// <summary>
        /// Test to make sure that if we submit a richtext post that we display it correctly in the comment box list
        /// </summary>
        [TestMethod]
        public void TestRichTextPosts()
        {
            Console.WriteLine("Before CommentBoxTests - TestRichTextPosts");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=reactive&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Add a comment to the list
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            request.RequestPage("acswithoutapi?dnauid=" + uid + @"&dnaaction=add&dnacomment=blahblahblah2<b>NormalUser</b>
with a carrage return.&dnahostpageurl=" + hosturl + "&dnapoststyle=1&skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(@"blahblahblah2<b>NormalUser</b><BR />with a carrage return.", xml.SelectSingleNode("//RICHPOST").InnerXml, "The rich post did not come back with the expected formatting.");

            Console.WriteLine("After CommentBoxTests - TestRichTextPosts");
        }

        /// <summary>
        /// Test to make sure that if we submit a richtext post that we display it correctly in the comment box list
        /// </summary>
        [TestMethod]
        public void TestRichTextPostsCRLFInLink()
        {
            Console.WriteLine("Before CommentBoxTests - TestRichTextPostsCRLFInLink");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=reactive&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Add a comment to the list
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            url = "acswithoutapi?dnauid=" + uid + @"&dnaaction=add&dnacomment=blahblahblah2<b>NormalUser</b><a href=""
www.bbc.co.uk/dna/h2g2"">fail you bugger</a>with a carrage
return.&dnahostpageurl=" + hosturl + "&dnapoststyle=1&skin=purexml";
            request.RequestPage(url);
            XmlDocument xml = request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(@"blahblahblah2<b>NormalUser</b><a href="" www.bbc.co.uk/dna/h2g2"">fail you bugger</a>with a carrage<BR />return.", xml.SelectSingleNode("//RICHPOST").InnerXml, "The rich post did not come back with the expected formatting.");

            Console.WriteLine("After CommentBoxTests - TestRichTextPostsCRLFInLink");
        }


        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateCommentForumAndThenChangeTitle()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateCommentForumAndThenChangeTitle");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.UseEditorAuthentication = true;
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);
            XmlDocument xml = request.GetLastResponseAsXML();

            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();

            string newtitle = "TestingCommentBoxChangesTitle";
            url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + newtitle + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";
            request.RequestPage(url);
            // now get the response
            xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/COMMENTFORUMTITLE").InnerText == "TestingCommentBoxChangesTitle", "Forum Title has not been changed.");
            
            request.RequestPage("CommentForumList?dnaskip=0&dnashow=100&skin=purexml");
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + uid + "']/TITLE").InnerText == "TestingCommentBoxChangesTitle", "The comment forum list page has not been generated correctly - COMMENTFORUMLISTTITLE!!!");
        }

        /// <summary>
        /// Test to make sure that if we submit a richtext post that we display it correctly in the comment box list
        /// </summary>
        [TestMethod]
        public void TestRichTextPostWithDodgyTagsReportsCorrectErrors()
        {
            Console.WriteLine("Before CommentBoxTests - TestRichTextPostWithDodgyTags");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=reactive&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Add a comment to the list
            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            string comment = @"blahblahblah2<b>NormalUser</b><a href=""
www.bbc.co.uk/dna/h2g2"">>fail you <bugger</a>with a carrage
return.";
            TestCommentRequestErrorMessage(uid, comment, @"The '&lt;' character, cannot be included in a name on line 2");

            // DO NOT REFORMAT THE FOLLOWING TEST AS IT CONTAINS /r/n AS INTENDED!!!
            comment = @"blahblahblah2<b>NormalUser</b><a href=""www.bbc.co.uk/dna/h2g2"" test='blah''>>fail you bugger</a>with an error message!!!.";
            TestCommentRequestErrorMessage(uid, comment, @"Name cannot begin with the ''' character on line 1");

            Console.WriteLine("After CommentBoxTests - TestRichTextPostWithDodgyTags");
        }

        /// <summary>
        /// Tests the comments error messages for given comments
        /// </summary>
        /// <param name="comment">The comment you want to test against</param>
        /// <param name="expectedMessage">The expected error message</param>
        private void TestCommentRequestErrorMessage(string uid, string comment, string expectedMessage)
        {
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string encodedComment = HttpUtility.UrlEncode(comment);
            string url = "acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + encodedComment + "&dnahostpageurl=" + hosturl + "&dnapoststyle=1&dnaur=1&skin=purexml";
            request.RequestPage(url);
            
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.AreEqual(expectedMessage, xml.SelectSingleNode("//ERRORMESSAGE").InnerXml, "Incorrect error message given.");
        }

        /// <summary>
        /// Test to make sure we handle illegal xml entities
        /// </summary>
        [TestMethod]
        public void TestIllegalXMLEntities()
        {
            string text = "(&#x1B;£) &#x09; ety &#x0B; uetyue &#x0A; hi hi hi &#x0D;bfbjdsb \b \r \n \t jffd &#27; test &#09; tuiruir";
            string expectedResult = "(£) &#x09; ety  uetyue &#x0A; hi hi hi &#x0D;bfbjdsb  \r \n \t jffd  test &#09; tuiruir";

            string pattern = @"&#x(0[0-8BCE-F]|1[0-9A-F])?;|&#(0[0-8]|1[1-24-9]|2[0-9]|3[01])?;|[^\u0009\u000A\u000D\u0020-\uFFFF]";

            Regex regex = new Regex(pattern, RegexOptions.IgnoreCase);
            if (regex.IsMatch(text))
            {
                text = regex.Replace(text, String.Empty);
            }

            Assert.AreEqual(expectedResult, text);
        }




        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateNewCommentForumAndCommentWithAUnicodeComment()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewCommentForumAndCommentWithAUnicodeComment");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBoxUnicode";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";
            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            string comment = "\u4E0D\u8981\u6050\u614C works too now as well as well as \u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435 \u00A3 \u0024 \u0025";

            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=&dnahostpageurl=" + hosturl + "&skin=purexml");
            
            //The unicode string just goes in as it is to come out not sure this will fully test how the string will come from the skins
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + comment + "&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") != null, "Failed to post a comment!!!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='" + comment + "']") != null, "Posted comment did not appear!!!");

            Console.WriteLine("After CommentBoxTests - TestCreateNewCommentForumAndCommentWithAUnicodeComment");
        }


        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated site with a unicode title
        /// </summary>
        [TestMethod]
        public void TestCreateCommentForumWithUnicodeTitleAndThenChangeUnicodeTitle()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateCommentForumWithUnicodeTitleAndThenChangeUnicodeTitle");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string encodedTitle = "\u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + encodedTitle + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);
            XmlDocument xml = request.GetLastResponseAsXML();
            string comment = "\u03CC\u03C7\u03B9 \u03C0\u03B1\u03BD\u03B9\u03BA\u03CC\u03C2" + uid;
            // Now check to make sure we can post to the comment box
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + comment + "&dnahostpageurl=" + hosturl + "&skin=purexml");
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();

            string encodedNewTitle = "\u30D1\u30CB\u30C3\u30AF\u306B\u9665\u3063\u3066\u306F\u3044\u3051\u306A\u3044";
            url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + encodedNewTitle + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";
            request.RequestPage(url);
            // now get the response
            xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST/COMMENTFORUMTITLE").InnerText == encodedNewTitle, "Forum Title has not been changed.");

            request.RequestPage("CommentForumList?dnaskip=0&dnashow=100&skin=purexml");
            // Check to make sure that the page returned with the correct information
            xml = request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("H2G2/COMMENTFORUMLIST/COMMENTFORUM[@UID='" + uid + "']/TITLE").InnerText == encodedNewTitle, "The comment forum list page has not been generated correctly - COMMENTFORUMLISTTITLE!!!");

            Console.WriteLine("After CommentBoxTests - TestCreateCommentForumWithUnicodeTitleAndThenChangeUnicodeTitle");
        }
        /// <summary>
        /// Test that we can create a premod forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateNewPreModCommentForumAndUnicodeComment()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewPreModCommentForumAndUnicodeComment");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string encodedTitle = "\u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + encodedTitle + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=premod&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@MODERATIONSTATUS='3']") != null, "The forums moderation status should be 3 (premod)");

            // Now check to make sure that a normal users post gets premoderated
            string comment = "\u03CC\u03C7\u03B9 \u03C0\u03B1\u03BD\u03B9\u03BA\u03CC\u03C2 FromNormalUser" + uid;
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + comment + "&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") != null, "Failed to create new comment");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[@HIDDEN='3']") != null, "Failed to create new comment with hidden status 3");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[SUBJECT='Hidden']") != null, "Failed to create new comment with hidden subject");

            // Now check to make sure that a notable can post a comment without being moderated
            request.SetCurrentUserNotableUser();
            string notableComment = "\u03CC\u03C7\u03B9 \u03C0\u03B1\u03BD\u03B9\u03BA\u03CC\u03C2 FromNotable" + uid;
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + notableComment + "&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "2", "The forum should have 2 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='" + notableComment + "']") != null, "Posted comment did not appear for notable!!!");

            // Now check to make sure that a editor can post a comment without being moderated
            request.SetCurrentUserEditor();
            string editorComment = "\u03CC\u03C7\u03B9 \u03C0\u03B1\u03BD\u03B9\u03BA\u03CC\u03C2 FromEditor" + uid;
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + editorComment + "&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "3", "The forum should have 3 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='" + editorComment + "']") != null, "Posted comment did not appear for editor!!!");

            Console.WriteLine("After CommentBoxTests - TestCreateNewPreModCommentForumAndUnicodeComment");
        }
        /// <summary>
        /// Test that we can create a forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateNewUnicodeCommentComplain()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewUnicodeCommentComplain");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string encodedTitle = "TestCreateNewUnicodeCommentComplain - \u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acs";
            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + encodedTitle + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            string comment = "ComplainAboutThis\u4E0D\u8981\u6050\u614C works too now as well as well as \u041D\u0435 \u043F\u0430\u043D\u0438\u043A\u0443\u0439\u0442\u0435 \u00A3 \u0024 \u0025";

            // Now check to make sure we can post to the comment box
            //The unicode string just goes in as it is to come out not sure this will fully test how the string will come from the skins
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=" + comment + "&dnahostpageurl=" + hosturl + "&skin=purexml");            
            
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") != null, "Failed to post a comment!!!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='" + comment + "']") != null, "Posted comment did not appear!!!");

            string postID = xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST").Attributes["POSTID"].Value;

            //COMPLAIN ABOUT IT
            //request.SetCurrentUserNotLoggedInUser();
            request.RequestPage("UserComplaintPage?postid=" + postID + "&action=submit&complaintreason=libellous&complainttext=Complaint&email=mark.howitt@bbc.co.uk&skin=purexml");
            xml = request.GetLastResponseAsXML();

            // Check to make sure complaint was processed
            Assert.IsTrue(xml.SelectSingleNode("//H2G2/USERCOMPLAINT/@MODID") != null, "Complaint did not succeed");

            //PUT the moderator into a moderation class
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("insert into moderationclassmembers (ModClassID, UserID) values (1, 1090564231)");
            }

            request.SetCurrentUserModerator();
            request.UseEditorAuthentication = true;
            request.RequestPage("moderateposts?modclassid=1&s_classview=1&alerts=1&fastmod=0&notfastmod=0&skin=purexml");

            xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/POSTMODERATION/POST[TEXT='" + comment + "']") != null, "Complained about comment did not appear correctly!!!");

            Console.WriteLine("After CommentBoxTests - TestCreateNewUnicodeCommentComplain");
        }


        /// <summary>
        /// Test that we can create a premod forum and post to it for a normal non moderated site
        /// </summary>
        [TestMethod]
        public void TestCreateNewCommentForumAndThenChangeHostPageUrl()
        {
            Console.WriteLine("Before CommentBoxTests - TestCreateNewCommentForumAndThenChangeHostPageUrl");

            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://" + _server + "/dna/haveyoursay/acswithoutapi";

            string url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            //Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE") != null, "End date missing when specified!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            //post comment
            request.RequestPage("acswithoutapi?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST") != null, "Failed to post a comment!!!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[TEXT='blahblahblah']") != null, "Posted comment did not appear!!!");


            //change hostpageurl
            hosturl = "http://" + _server + "/dna/haveyoursay/acsapi_afterchange";
            url = "acswithoutapi?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&dnainitialmodstatus=premod&skin=purexml";

            // now get the response
            request.RequestPage(url);
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag doers not exist!");
            //Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE") != null, "End date missing when specified!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            Console.WriteLine("After CommentBoxTests - TestCreateNewCommentForumAndThenChangeHostPageUrl");
        }
    }
}
