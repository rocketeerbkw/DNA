using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Syndication;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.SocialAPI.Tests
{
    /// <summary>
    /// Summary description for UnitTest1
    /// </summary>
    [TestClass]
    public class SearchTests
    {
        public SearchTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        [TestMethod]
        public void SearchTwitterUserByScreenName_ReturnCorrectResults_OrRateLimitedResponse()
        {
            var strTwitterScreenName = "Srihari0309";

            TwitterClient client = new TwitterClient();
            TweetUsers tweetUser = new TweetUsers();

            try
            {
                tweetUser = client.GetUserDetails(strTwitterScreenName);
                Assert.IsNotNull(tweetUser);
                Assert.AreEqual(tweetUser.ScreenName, strTwitterScreenName);
            }
            catch (Exception ex)
            {
                string twitterLimitException = "The remote server returned an unexpected response: (400) Bad Request.";
                Assert.AreEqual(twitterLimitException, ex.Message);
            }

        }

        [TestMethod]
        public void SearchTwitterUserByScreenName_ReturnInCorrectResults_AlwaysException()
        {
            var strTwitterScreenName = "DotNetUser";

            TwitterClient client = new TwitterClient();
            TweetUsers tweetUser = new TweetUsers();

            try
            {
                tweetUser = client.GetUserDetails(strTwitterScreenName);
            }
            catch (Exception ex)
            {
                string twitterLimitException = "The remote server returned an unexpected response: (400) Bad Request.";
                Assert.AreEqual(twitterLimitException, ex.Message);
                return;
            }
            Assert.Fail();
        }

       
    }
}
