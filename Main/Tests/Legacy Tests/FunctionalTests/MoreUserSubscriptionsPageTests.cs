using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class MoreUserSubscriptionsPageTests.cs
    /// </summary>
    [TestClass]
    public class MoreUserSubscriptionsPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2MoreUserSubscriptionsFlat.xsd";
        private IInputContext _context = DnaMockery.CreateDatabaseInputContext();

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                _request.SetCurrentUserProfileTest();
               //_request.UseEditorAuthentication = true;
               // _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }
        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateMoreUserSubscriptionsPageTest()
        {
            Console.WriteLine("Before Test01CreateMoreUserSubscriptionsPageTest");
            _request.RequestPage("MUS6?skin=purexml");
            Console.WriteLine("After Test01CreateMoreUserSubscriptionsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");
        }

        /// <summary>
        /// Test we get a more User Subscriptions page for the call. 
        /// </summary>
        [TestMethod]
        public void Test02GetMoreUserSubscriptionsPageTest()
        {
            Console.WriteLine("Before Test02GetMoreUserSubscriptionsPageTest");
            _request.RequestPage("MUS6?skin=purexml");
            Console.WriteLine("After Test02GetMoreUserSubscriptionsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");
        }

        /// <summary>
        /// Test we get a User Subscriptions page for the call and it's valid 
        /// </summary>
        [TestMethod]
        public void Test03CheckOutputFormatMoreUserSubscriptionsPageTest()
        {
            Console.WriteLine("Before Test03CheckOutputFormatMoreUserSubscriptionsPageTest");
            _request.RequestPage("MUS6?skin=purexml");
            Console.WriteLine("After Test03CheckOutputFormatMoreUserSubscriptionsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='6']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test we get the logged in User Subscriptions page for the call and it's valid 
        /// </summary>
        [TestMethod]
        public void Test04CheckLoggedInMoreUserSubscriptionsPageTest()
        {
            SubscribeToUser(1090498911, 6, 1);

            Console.WriteLine("Before Test04CheckLoggedInMoreUserSubscriptionsPageTest");
            _request.RequestPage("MUS1090498911?skin=purexml");
            Console.WriteLine("After Test04CheckLoggedInMoreUserSubscriptionsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='1090498911']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USERS/USER[USERID='6']") != null, "The Subscribed To user in the User Subscriptions list page has not been generated correctly - USERS/USERID!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test we can unsubscribe a user from the User Subscriptions page and it's not there in the returned XML and it's valid 
        /// </summary>
        [TestMethod]
        public void Test05TestNotOwnerUnsubcribeFromUserTest()
        {
            SubscribeToUser(6, 1090498911, 1);

            Console.WriteLine("Before Test05TestNotOwnerUnsubcribeFromUserTest");
            _request.RequestPage("MUS6?dnaaction=unsubscribe&subscribedtoid=6&skin=purexml");
            Console.WriteLine("After Test05TestNotOwnerUnsubcribeFromUserTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='6']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR") != null, "The User Subscriptions list page should not allow someone else to unsubscribe your subscriptions, it should error!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test we can unsubscribe a user from the User Subscriptions page and it's not there in the returned XML and it's valid 
        /// </summary>
        [TestMethod]
        public void Test06TestOwnerUnsubcribeFromUserTest()
        {
            SubscribeToUser(1090498911, 6, 1);

            Console.WriteLine("Before Test06TestOwnerUnsubcribeFromUserTest");
            _request.RequestPage("MUS1090498911?dnaaction=unsubscribe&subscribedtoid=6&skin=purexml");
            Console.WriteLine("After Test06TestOwnerUnsubcribeFromUserTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='1090498911']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsFalse(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USERS/USER[USERID='6']") != null, "The Subscribed To user exists in the User Subscriptions list, it should have been removed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test we can subscribe to a user from the User Subscriptions page and there in the returned XML and it's valid 
        /// </summary>
        [TestMethod]
        public void Test07TestSubcribeToUserTest()
        {
            _request.SetCurrentUserNormal();
            Console.WriteLine("Before Test07TestSubcribeToUserTest");
            _request.RequestPage("MUS1090501859?dnaaction=subscribe&subscribedtoid=1090558353&skin=purexml");
            Console.WriteLine("After Test07TestSubcribeToUserTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='1090501859']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USERS/USER[USERID='1090558353']") != null, "The Subscribed To user does not exist in the User Subscriptions list, it should be there!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test we get an error from the User Subscriptions page if we try to subscribe to our self. 
        /// </summary>
        [TestMethod]
        public void Test08TestSubcribeToSelfErrorTest()
        {
            Console.WriteLine("Before Test08TestSubcribeToSelfErrorTest");
            _request.RequestPage("MUS1090498911?dnaaction=subscribe&subscribedtoid=1090498911&skin=purexml");
            Console.WriteLine("After Test08TestSubcribeToSelfErrorTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='1090498911']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR") != null, "The User Subscriptions list page should not allow you to subscribe to yourself, it should error!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Test we get an error from the User Subscriptions page if we try to subscribe to a user when not logged in. 
        /// </summary>
        [TestMethod]
        public void Test09TestSubcribeWhenLoggedOutErrorTest()
        {
            //Make sure we don't have user 6 subscribed
            Console.WriteLine("Before Test09TestSubcribeWhenLoggedOutErrorTest");
            _request.RequestPage("MUS1090498911?dnaaction=unsubscribe&subscribedtoid=6&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='1090498911']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsFalse(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USERS/USER[USERID='6']") != null, "The Subscribed To user exists in the User Subscriptions list, it should have been removed!!!");

            _request.SetCurrentUserNotLoggedInUser();

            _request.RequestPage("MUS1090498911?dnaaction=subscribe&subscribedtoid=6&skin=purexml");
            Console.WriteLine("After Test09TestSubcribeWhenLoggedOutErrorTest");

            xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='1090498911']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR") != null, "The User Subscriptions list page should not allow you to subscribe to yourself, it should error!!!");
            Assert.IsFalse(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/USERS/USER[USERID='6']") != null, "The Subscribed To user exists in the User Subscriptions list, it should not be there!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test we can unsubscribe a user from the User Subscriptions page and it's not there in the returned XML and it's valid 
        /// </summary>
        [TestMethod]
        public void Test10TestNotOwnerSubcribeFromUserTest()
        {
            UnsubscribeFromUser(6, 1090501859);

            Console.WriteLine("Before Test10TestNotOwnerSubcribeFromUserTest");
            _request.RequestPage("MUS6?dnaaction=subscribe&subscribedtoid=1090501859&skin=purexml");
            Console.WriteLine("After Test10TestNotOwnerSubcribeFromUserTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST") != null, "The User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SKIP") != null, "The User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS/USERSUBSCRIPTION-LIST/@SHOW") != null, "The User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/MOREUSERSUBSCRIPTIONS[@USERID='6']") != null, "The User Subscriptions list page has not been generated correctly - USERID!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR") != null, "The User Subscriptions list page should not allow someone else to subscribe to other users, it should error!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }


        /// <summary>
        /// Function to add a subscription to a user
        /// </summary>
        /// <param name="userID">The user id of the person trying to subscribe to another user</param>
        /// <param name="authorID">The user id the person is trying to subscribe to</param>
        /// <param name="siteID">The site id of the site</param>
        private void SubscribeToUser(int userID, int authorID, int siteID)
        {
            using (IDnaDataReader dataReader = _context.CreateDnaDataReader("SubscribeToUser"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("authorid", authorID);
                dataReader.AddParameter("siteid", siteID);

                dataReader.Execute();
           }
        }
        /// <summary>
        /// Function to remove a subscription to a user
        /// </summary>
        /// <param name="userID">The user id of the person trying to unsubscribe</param>
        /// <param name="subscribedtoid">The user id of the person that the user is trying unsubscribe from</param>
        private void UnsubscribeFromUser(int userID, int subscribedtoid)
        {
            using (IDnaDataReader dataReader = _context.CreateDnaDataReader("unsubscribefromuser"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("subscribedtoid", subscribedtoid);

                dataReader.Execute();
            }
        }
    }

}
