using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.SocialAPI;

namespace FunctionalTests.SocialAPI
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
            Test_SearchTwitterUserByScreenName_ReturnCorrectResults_OrRateLimitedResponse("Srihari0309");
        }

        [TestMethod]
        public void SearchTwitterUserByScreenName_LowerCase_ReturnCorrectResults_OrRateLimitedResponse()
        {
            Test_SearchTwitterUserByScreenName_ReturnCorrectResults_OrRateLimitedResponse("srihari0309");
        }

        [TestMethod]
        public void SearchTwitterUserByScreenName_MixCase_ReturnCorrectResults_OrRateLimitedResponse()
        {
            Test_SearchTwitterUserByScreenName_ReturnCorrectResults_OrRateLimitedResponse("SriHari0309");
        }

        private void Test_SearchTwitterUserByScreenName_ReturnCorrectResults_OrRateLimitedResponse(string twitterScreenName)
        {

            TwitterClient client = new TwitterClient();
            TweetUsers tweetUser = new TweetUsers();

            try
            {
                tweetUser = client.GetUserDetailsByScrapping(twitterScreenName);
                Assert.IsNotNull(tweetUser);
                Assert.AreEqual(tweetUser.ScreenName, twitterScreenName, true);
            }
            catch (Exception ex)
            {
                string twitterLimitException = "The remote server returned an unexpected response: (400) Bad Request.";
                string twitterHttpException = "The HTTP request was forbidden with client authentication scheme 'Basic'.";
                if (ex.Message.Equals(twitterHttpException))
                {
                    Assert.AreEqual(twitterHttpException, ex.Message);
                }
                else
                {
                    Assert.AreEqual(twitterLimitException, ex.Message);
                }
            }
        }

        [TestMethod]
        public void SearchTwitterUserByScreenName_ReturnInCorrectResults_AlwaysException()
        {
            var strTwitterScreenName = "DotNetTemp";
            TwitterClient client = new TwitterClient();
            TweetUsers tweetUser = new TweetUsers();

            try
            {
                tweetUser = client.GetUserDetails(strTwitterScreenName);
            }
            catch (Exception ex)
            {
                string twitterLimitException = "The remote server returned an unexpected response: (400) Bad Request.";
                string twitterErrorNotFound = "The remote server returned an error: (404) Not Found.";
                string twitterHttpException = "The HTTP request was forbidden with client authentication scheme 'Basic'.";
                string twitterException = "The remote server returned an unexpected response: (410) Gone.";

                if (ex.InnerException.Message.Equals(twitterErrorNotFound))
                {
                    Assert.AreEqual(twitterErrorNotFound, ex.InnerException.Message);
                }
                else if (ex.Message.Equals(twitterHttpException))
                {
                    Assert.AreEqual(twitterHttpException, ex.Message);
                }
                else if(ex.Message.Equals(twitterException))
                {
                    Assert.AreEqual(twitterException, ex.Message);
                }
                else
                {
                    Assert.AreEqual(twitterLimitException, ex.Message);
                }
                return;
            }
            Assert.Fail();
        }
    }
}
