using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class MoreUserSubscriptionsPageTests.cs
    /// </summary>
    [TestClass]
    public class BlockedUserSubscriptionsPageTests
    {
        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2BlockedUserSubscriptionsFlat.xsd";
        private bool _setupRun = false;
        private int _userId = 0;

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
                _request.SetCurrentUserNormal();
                _request.UseIdentitySignIn = true;
                //_request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.NORMALUSER);
                _userId = _request.CurrentUserID;
                _setupRun = true;
            }
        }

        /// <summary>
        /// Tests BlockSubscriptions action . 
        /// This indicates that the user is not willing to accept subscriptions to their content.
        /// </summary>
        [TestMethod]
        public void TestBlockSubscriptions()
        {
            Console.WriteLine("Before TestBlockSubscriptions");
            _request.RequestPage("BUS1090501859?dnaaction=blocksubscriptions&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS[@ACCEPTSUBSCRIPTIONS='0']"));
            Console.WriteLine("After TestBlockSubscriptions");
        }

        /// <summary>
        /// Tests AcceptSubscriptions action.
        /// Indicates that the user is willing to accept subscriptions to their content.
        /// </summary>
        [TestMethod]
        public void TestAcceptSubscriptions()
        {
            Console.WriteLine("Before TestAcceptSubscriptions");
            _request.RequestPage("BUS1090501859?dnaaction=acceptsubscriptions&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS[@ACCEPTSUBSCRIPTIONS='1']"));
            Console.WriteLine("After TestAcceptSubscriptions");
        }

        /// <summary>
        /// Tests that an author may block a user from subscribing to their content.
        /// dnaaction=blockusersubscription&amp;blockedID=6 will block userid 6.
        /// </summary>
        [TestMethod]
        public void TestBlockUserSubscription()
        {
            Console.WriteLine("Before TestBlockUserSubscription");
            _request.RequestPage("BUS1090501859?dnaaction=blockusersubscription&blockedID=6&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS/BLOCKEDUSERSUBSCRIPTIONS-LIST/USERS/USER[USERID='6']"));
            Console.WriteLine("After TestBlockUserSubscription");
        }


        /// <summary>
        /// Tests that an author may lift a block allowing a user to subscribe to their content.
        /// dnaaction=unblockusersubscription&amp;blockedID=6 will unblock userid 6.
        /// </summary>
        [TestMethod]
        public void TestUnBlockUserSubscription()
        {
            Console.WriteLine("Before TestUnBlockUserSubscription");
            _request.RequestPage("BUS1090501859?dnaaction=unblockusersubscription&blockedID=6&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNull(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS/BLOCKEDUSERSUBSCRIPTIONS-LIST/USERS/USER[USERID='6']"));
            Console.WriteLine("After TestUnBlockUserSubscription");
        }

        /// <summary>
        /// Tests user is only allowed to action their own page . 
        /// This indicates that the user is not willing to accept subscriptions to their content.
        /// </summary>
        [TestMethod]
        public void TestOnlyOwnerAllowedActions()
        {
            Console.WriteLine("Before TestOnlyOwnerAllowedActions");
            _request.RequestPage("BUS6?dnaaction=blocksubscriptions&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='You can only view your own blocked subscriptions.']"));
            Console.WriteLine("After TestOnlyOwnerAllowedActions");
        }

        /// <summary>
        /// Test we get a Blocked User Subscriptions page for the call and it's valid against the schema
        /// </summary>
        [TestMethod]
        public void TestCheckOutputFormatBlockedUserSubscriptionsPageTest()
        {
            Console.WriteLine("Before TestCheckOutputFormatBlockedUserSubscriptionsPageTest");
            _request.RequestPage("BUS1090501859?skin=purexml");
            Console.WriteLine("After TestCheckOutputFormatBlockedUserSubscriptionsPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS/BLOCKEDUSERSUBSCRIPTIONS-LIST") != null, "The Blocked User Subscriptions list page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS/BLOCKEDUSERSUBSCRIPTIONS-LIST/@SKIP") != null, "TheBlocked User Subscriptions list page has not been generated correctly - SKIP!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS/BLOCKEDUSERSUBSCRIPTIONS-LIST/@SHOW") != null, "The Blocked User Subscriptions list page has not been generated correctly - SHOW!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/BLOCKEDUSERSUBSCRIPTIONS[@USERID='1090501859']") != null, "The Blocked User Subscriptions list page has not been generated correctly - USERID!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
    }
}

