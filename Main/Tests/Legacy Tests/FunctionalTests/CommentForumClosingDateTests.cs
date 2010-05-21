using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class runs all the tests for checking and setting the forum duration
    /// </summary>
    [TestClass]
    public class CommentForumClosingDateTests
    {

        [TestInitialize]
        public void Setup()
        {
            // Make sure the database is in the starting position
            SnapshotInitialisation.ForceRestore();
        }

        private const string _schemaUri = "H2G2CommentBoxFlat.xsd";

        IInputContext _context = DnaMockery.CreateDatabaseInputContext();
        /// <summary>
        /// Tests to make sure that we can create new comment box forums with no closing dates
        /// No acs using api always sets the close date based on the defaults
        /// </summary>
        [TestMethod]
        public void Test1CreateForumWithNoCloseDate()
        {
            Console.WriteLine("Before CommentForumClosingDateTests - Test1CreateForumWithNoCloseDate");

            // Create a new comment box with no closing date
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "Testing";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null,"Comment box tag doers not exist!");
            //Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE") != null,"End date missing when specified!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            Console.WriteLine("After CommentForumClosingDateTests - Test1CreateForumWithNoCloseDate");
        }

        /// <summary>
        /// Tests to make sure that we can create new comment box forums with the default closing date
        /// </summary>
        [TestMethod]
        public void Test2CreateForumWithDefaultCloseDate()
        {
            Console.WriteLine("Before CommentForumClosingDateTests - Test2CreateForumWithDefaultCloseDate");

            // Create a new comment box with no closing date
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "Testing";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");

            //Check that the set local time is the same
            XmlNode date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            DateTime closedate = DateTime.Today.AddDays(365+1);
            Assert.IsTrue(date != null, "End date has been created when non specified!");
            Assert.AreEqual(closedate.ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(closedate.ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(closedate.ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            Console.WriteLine("After CommentForumClosingDateTests - Test2CreateForumWithDefaultCloseDate");
        }

        /// <summary>
        /// Tests to make sure that we can create new comment box forums with a overriden closing date
        /// </summary>
        [TestMethod]
        public void Test3CreateForumWithClosingDateDefinedAsDays()
        {
            // Create a new comment box with no closing date
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "Testing";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=30&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            XmlNode date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            DateTime closedate = DateTime.Today.AddDays(30 + 1);
            Assert.IsTrue(date != null, "End date missing when specified!");
            Assert.AreEqual(closedate.ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(closedate.ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(closedate.ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");
        }

        /// <summary>
        /// Tests to make sure that we can create new comment box forums with a overriden closing date
        /// </summary>
        [TestMethod]
        public void Test4CreateForumWithClosingDateDefinedAsDate()
        {
            // Create a new comment box with no closing date
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string forumClosingDate = DateTime.Today.AddDays(10).Year.ToString();
            if (DateTime.Today.AddDays(10).Month.ToString().Length == 1)
            {
                forumClosingDate += "0";
            }
            forumClosingDate += DateTime.Today.AddDays(10).Month.ToString();
            if (DateTime.Today.AddDays(10).Day.ToString().Length == 1)
            {
                forumClosingDate += "0";
            }
            forumClosingDate += DateTime.Today.AddDays(10).Day.ToString();

            string uid = Guid.NewGuid().ToString();
            string title = "Testing";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumclosedate=" + forumClosingDate + "&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            XmlNode date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            Assert.IsTrue(date != null, "End date missing when specified!");
            Assert.AreEqual(DateTime.Today.AddDays(10 + 1).ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(10 + 1).ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(10 + 1).ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");
        }

        /// <summary>
        /// Tests to make sure that the can write flag gets set correctly for forums that have closed
        /// </summary>
        [TestMethod]
        public void Test5CheckThatCanWriteFlagGetSetAccordinglyInRespectToForumClosingDate()
        {
            // Create a new comment box with no closing date
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string forumClosingDate = DateTime.Today.AddDays(10).Year.ToString();
            if (DateTime.Today.AddDays(10).Month.ToString().Length == 1)
            {
                forumClosingDate += "0";
            }
            forumClosingDate += DateTime.Today.AddDays(10).Month.ToString();
            if (DateTime.Today.AddDays(10).Day.ToString().Length == 1)
            {
                forumClosingDate += "0";
            }
            forumClosingDate += DateTime.Today.AddDays(10).Day.ToString();

            string uid = Guid.NewGuid().ToString();
            string title = "Testing";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumclosedate=" + forumClosingDate + "&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            XmlNode date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            Assert.IsTrue(date != null, "End date missing when specified!");
            Assert.AreEqual(DateTime.Today.AddDays(10 + 1).ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(10 + 1).ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(10 + 1).ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='1']") != null, "The forums can write flag should be set 1");

            // Now ste the closing date of the forum to something in the past.
            using (IDnaDataReader dataReader = _context.CreateDnaDataReader("updatecommentforumstatus"))
            {
                dataReader.AddParameter("uid", uid);
                dataReader.AddParameter("forumclosedate", DateTime.Today.AddDays(-20));
                dataReader.Execute();
            }

            // now get the response
            request.RequestPage("acs?dnauid=" + uid + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            Assert.IsTrue(date != null, "End date missing when specified!");
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "0", "The forum not have any posts!");

            // Now make sure the user can't post to a closed forum
            request.RequestSecurePage("acs?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            Assert.IsTrue(date != null, "End date missing when specified!");
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "0", "The forum not have any posts!");

            // Now make sure Editors can post to a closed forum
            request.SetCurrentUserEditor();
            request.RequestSecurePage("acs?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX") != null, "Comment box tag does not exist!");
            date = xml.SelectSingleNode("/H2G2/COMMENTBOX/ENDDATE/DATE/LOCAL");
            Assert.IsTrue(date != null, "End date missing when specified!");
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("MM"), date.Attributes["MONTH"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("dd"), date.Attributes["DAY"].Value);
            Assert.AreEqual(DateTime.Today.AddDays(-20).ToString("yyyy"), date.Attributes["YEAR"].Value);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@UID='" + uid + "']") != null, "Forums uid does not matched the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@HOSTPAGEURL='" + hosturl + "']") != null, "Host url does not match the one used to create!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS[@CANWRITE='0']") != null, "The forums can write flag should be set 0 even fopr the editor! This is due to the fact that the forum gets put into html caching mode.");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS").Attributes["FORUMPOSTCOUNT"].Value == "1", "The forum should have 1 post!");

            // Added extra test for making sure that a normal user cannot post to a forum that has closed
        }
        
        /// <summary>
        /// Tests to make sure that we can handle invalid params for the closing date
        /// </summary>
        [TestMethod]
        public void Test6CheckCorrectErrorResponseForInvalidDateParams()
        {
            Console.WriteLine("After CommentForumClosingDateTests - Test6CheckCorrectErrorResponseForInvalidDateParams");

            // Create a new comment box with no closing date
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.SetCurrentUserNormal();

            // Setup the request url
            string forumClosingDate = "20061332";

            string uid = Guid.NewGuid().ToString();
            string title = "Testing";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumclosedate=" + forumClosingDate + "&skin=purexml";

            // now get the response
            request.RequestPage(url);

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.OuterXml, _schemaUri);
            validator.Validate();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/COMMENTBOX/FORUMTHREADPOSTS") == null, "CommentBoxForum should not exist!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ERROR") != null, "The error tag does not exist!");
            Assert.AreEqual(xml.SelectSingleNode("/H2G2/ERROR").Attributes["TYPE"].Value, "invalidparameters", "The error type is not correct!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ERROR/ERRORMESSAGE").InnerText.Contains("Invalid date format given for forumclosedate"), "The error message is not correct!");

            Console.WriteLine("After CommentForumClosingDateTests - Test6CheckCorrectErrorResponseForInvalidDateParams");
        }
    }
}
