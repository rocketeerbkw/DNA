using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Content rating poll tests
    /// </summary>
    [TestClass]
    public class NewPollContentRatingTests
    {
        // Setup a mockery and DataReader field
        Mockery _mock;
        IDnaDataReader _mockedDataReader;
        IDnaDiagnostics _mockedDiagnostics;
        IInputContext _databaseContext = null;

        /// <summary>
        /// Default constructor
        /// </summary>
        public NewPollContentRatingTests()
        {
            // Create the snap shot roll back if we need it!
			SnapshotInitialisation.ForceRestore();

            if (_databaseContext == null)
            {
                _databaseContext = DnaMockery.CreateDatabaseInputContext(); 
            }
        }

        /// <summary>
        /// Sets up the tests mock and datareader objects
        /// </summary>
        [TestInitialize]
        public void SetUp()
        {
            // Create the mockery object
            _mock = new Mockery();

            // Now create a mocked DataReader. This will be returned by the mocked input context method CreateDnaDataReader
            _mockedDataReader = _mock.NewMock<IDnaDataReader>();
            _mockedDiagnostics = _mock.NewMock<IDnaDiagnostics>();
            Stub.On(_mockedDiagnostics).Method("WriteWarningToLog").Will(Return.Value(null));

            // Ensure the Statistics object is initialised
            Statistics.ResetCounters();
        }

        /// <summary>
        /// Creates a mocked up AppContext with the diagnostics overriden
        /// </summary>
        /// <returns>The new mocked up input context</returns>
        private IAppContext CreateMockedAppContextAndDiagnostics()
        {
            IAppContext mockedAppContext = _mock.NewMock<IAppContext>();
            Stub.On(mockedAppContext).GetProperty("Diagnostics").Will(Return.Value(_mockedDiagnostics));
            return mockedAppContext;
        }

        /// <summary>
        /// Helper function for creating a datareader for a given procedure for the mocked inputcontext
        /// </summary>
        /// <param name="procedureName">The name of the procedure you want to apply to the mocked input context</param>
        /// <param name="mockedApp"></param>
        /// <returns>The new datareader for that procedure</returns>
        private IDnaDataReader CreateDataReaderForMockedAppContextForStoreProcedure(string procedureName, IAppContext mockedApp)
        {
            IDnaDataReader reader = _databaseContext.CreateDnaDataReader(procedureName);
            Stub.On(mockedApp).Method("CreateDnaDataReader").With(procedureName).Will(Return.Value(reader));
            return reader;
        }

        /// <summary>
        /// Helper method for creating a mocked dan data reader for a given app context.
        /// </summary>
        /// <param name="procedureName">The name of the procedure the datareader will use</param>
        /// <param name="mockedApp">The app context that the procedure is to be created for</param>
        /// <param name="defaultAddParamMock">Set to true if you want them to just return the data reader regardless of the inputs</param>
        /// <param name="hasRowsAndReadReturnValue">The HasRows AND Read return value when called</param>
        /// <returns></returns>
        private IDnaDataReader CreateMockedDanDataReaderForAppContextWithValues(string procedureName, IAppContext mockedApp, bool defaultAddParamMock, bool hasRowsAndReadReturnValue)
        {
            IDnaDataReader mockedDataReader = _mock.NewMock<IDnaDataReader>();
            Stub.On(mockedApp).Method("CreateDnaDataReader").With(procedureName).Will(Return.Value(mockedDataReader));
            if (defaultAddParamMock)
                Stub.On(mockedDataReader).Method("AddParameter").Will(Return.Value(mockedDataReader));
            Stub.On(mockedDataReader).Method("Execute").Will(Return.Value(mockedDataReader));
            Stub.On(mockedDataReader).GetProperty("HasRows").Will(Return.Value(hasRowsAndReadReturnValue));
            Stub.On(mockedDataReader).Method("Read").Will(Return.Value(hasRowsAndReadReturnValue));
            Stub.On(mockedDataReader).Method("Dispose").Will(Return.Value(null));
            return mockedDataReader;
        }

        /// <summary>
        /// Test to make sure we fail when trying to create a poll with a valid poll id
        /// </summary>
        [TestMethod]
        public void TestCreateNewPollFailsWithValidPollID()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
            testPoll.PollID = 1;
            Assert.IsFalse(testPoll.CreatePoll(), "Creating a poll with a valid poll id should return false!");
        }

        /// <summary>
        /// Test to make sure we can create a poll without a range
        /// </summary>
        [TestMethod]
        public void TestCreateNewPollWithoutRange()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            using (IDnaDataReader reader = CreateDataReaderForMockedAppContextForStoreProcedure("CreateNewVote", mockedAppContext))
            {
                PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
                Assert.IsTrue(testPoll.CreatePoll(), "Creating a poll without a range should return true!");
            }
        }

        /// <summary>
        /// Test to make sure we can create a poll with a range
        /// </summary>
        [TestMethod]
        public void TestCreateNewPollWithRange()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            using (IDnaDataReader reader = CreateDataReaderForMockedAppContextForStoreProcedure("CreateNewVote", mockedAppContext))
            {
                PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
                testPoll.SetResponseMinMax(0, 10);
                Assert.IsTrue(testPoll.CreatePoll(), "Creating a poll with a range should return true!");
            }
        }

        /// <summary>
        /// Creates a new valid content rating poll
        /// </summary>
        /// <param name="minResponse">The minimum response value</param>
        /// <param name="maxResponse">The maximum response value</param>
        /// <param name="appContext">The App context you want to create the poll in</param>
        /// <returns>The new poll</returns>
        private PollContentRating CreateValidPoll(int minResponse, int maxResponse, IAppContext appContext)
        {
            // Create the app context for the poll to run in
            using (IDnaDataReader reader = CreateDataReaderForMockedAppContextForStoreProcedure("CreateNewVote", appContext))
            {
                PollContentRating testPoll = new PollContentRating(appContext, null);
                testPoll.SetResponseMinMax(0, 10);
                if (!testPoll.CreatePoll())
                {
                    return null;
                }
                return testPoll;
            }
        }

        /// <summary>
        /// Test to make sure that the remove vote function returns an error as it's not allowed on this type of poll, as well as an error for no redirect
        /// </summary>
        [TestMethod]
        public void TestRemoveVoteReturnsErrorCodeAndErrorForNoRedirect()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = CreateValidPoll(0, 10, mockedAppContext);
            testPoll.RedirectURL = "";
            testPoll.RemoveVote();
            Assert.AreEqual(@"<ERROR TYPE=""ERRORCODE_BADPARAMS""><ERRORMESSAGE>'s_redirectto' not set by skin</ERRORMESSAGE></ERROR><ERROR TYPE=""2""><ERRORMESSAGE></ERRORMESSAGE></ERROR>", testPoll.RootElement.InnerXml.ToString(), "The xml for the poll should contain an error about a missing redirect");
            Assert.AreEqual(@"?PollErrorCode=2", testPoll.RedirectURL, "The poll should of put an error code on the redirect, even though it was empty!");
        }

        /// <summary>
        /// Test to make sure that we get the correct error code when trying to remove a vote
        /// </summary>
        [TestMethod]
        public void TestRemoveVoteReturnsErrorCode()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = CreateValidPoll(0, 10, mockedAppContext);
            testPoll.RedirectURL = @"dna/actionnetwork/";
            testPoll.RemoveVote();
            Assert.AreNotEqual(@"<ERROR TYPE=""ERRORCODE_BADPARAMS""><ERRORMESSAGE>'s_redirectto' not set by skin</ERRORMESSAGE></ERROR>", testPoll.RootElement.InnerXml.ToString(), "The xml for the poll should not contain an error about a missing redirect");
            Assert.AreEqual(@"dna/actionnetwork/?PollErrorCode=2", testPoll.RedirectURL, "The poll should of put an error code on the redirect, even though it was empty!");
        }

        /// <summary>
        /// Test to make suree that the poll returns false if we try to link it to a item when it has an invalid poll ID
        /// </summary>
        [TestMethod]
        public void TestLinkPollWithItemReturnsFalseForInvalidPollID()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
            testPoll.PollID = -1;
            Assert.IsFalse(testPoll.LinkPollWithItem(123,Poll.ItemType.ITEMTYPE_ARTICLE),"Should return false when poll id is invalid!");
        }

        /// <summary>
        /// Test to make sure that the poll returns false whern we are trying to link it to more than item
        /// </summary>
        [TestMethod]
        public void TestLinkPollFailsWhenThePollIsAlreadyLinkedToMoreThanOneItem()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
            testPoll.PollID = 123;
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, true))
            {
                Assert.IsFalse(testPoll.LinkPollWithItem(123, Poll.ItemType.ITEMTYPE_ARTICLE), "Should return false when poll is already linked to more than one item!");
            }
        }

        /// <summary>
        /// Test to make sure we can link an item to a poll that hasn't already been linked
        /// </summary>
        [TestMethod]
        public void TestThatLinkingAnItemToANonLinkPollReturnsTrue()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
            testPoll.PollID = 123;
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, false))
            {
                using (IDnaDataReader mockedDataReader2 = CreateMockedDanDataReaderForAppContextWithValues("LinkPollWithItem", mockedAppContext, true, false))
                {
                    Assert.IsTrue(testPoll.LinkPollWithItem(123, Poll.ItemType.ITEMTYPE_ARTICLE), "Should return true when adding a link to a poll that hasn't got one already!");
                }
            }
        }

        /// <summary>
        /// Tests to make sure that the poll returns false when trying to hide a vote with no redirect url specified
        /// </summary>
        [TestMethod]
        public void TestHidePollFailsWhenNoRedirectGiven()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
            testPoll.PollID = 123;
            Assert.IsTrue(testPoll.HidePoll(true), "Hide poll should return true when no redirect url given.");
            Assert.AreEqual(@"<ERROR TYPE=""ERRORCODE_BADPARAMS""><ERRORMESSAGE>'s_redirectto' not set by skin</ERRORMESSAGE></ERROR>", testPoll.RootElement.InnerXml.ToString(), "The xml for the poll should not contain an error about a missing redirect");
        }

        /// <summary>
        /// Helper metyhod that creates a mocked user for qa given mocked app context
        /// </summary>
        /// <param name="mockedAppContext">The mocked app context to add the user to</param>
        /// <param name="userID"></param>
        /// <param name="isLoggedIn"></param>
        /// <param name="isEditor"></param>
        private IUser CreateMockedUserForMockedAppContext(IAppContext mockedAppContext, int userID, bool isLoggedIn, bool isEditor)
        {
            IUser mockedUser = _mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(userID));
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(isEditor));
            Stub.On(mockedUser).GetProperty("UserLoggedIn").Will(Return.Value(isLoggedIn));
            return mockedUser;
        }

        /// <summary>
        /// Tests to make sure that the user must be logged in to hide votes
        /// </summary>
        [TestMethod]
        public void TestHidePollFailsWhenUserNotLoggedIn()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 0, false, false);
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"dna/actionnetwork/";
            Assert.IsTrue(testPoll.HidePoll(true), "Hide poll should return true when the user is not logged in.");
            Assert.AreEqual(@"dna/actionnetwork/?PollErrorCode=5", testPoll.RedirectURL, "Redirect should contain an error code when trying to hide a poll with no logged in user");
        }

        /// <summary>
        /// Tests to make sure that normal users are not able to hide votes
        /// </summary>
        [TestMethod]
        public void TestHidePollFailsWhenUserLoggedInButNotEditor()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123, true, false);
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"dna/actionnetwork/";
            Assert.IsTrue(testPoll.HidePoll(true), "Hide poll should return true when the user is not an editor.");
            Assert.AreEqual(@"dna/actionnetwork/?PollErrorCode=5", testPoll.RedirectURL, "Redirect should contain an error code when trying to hide a poll with no logged in user");
        }

        /// <summary>
        /// Tests to make sure that editors can hide polls ok
        /// </summary>
        [TestMethod]
        public void TestHidePollReturnsTrueWhenLoggedInAsEditor()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123, true, true);
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"dna/actionnetwork/";
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("HidePoll", mockedAppContext, true, true))
            {
                Assert.IsTrue(testPoll.HidePoll(true), "Hide poll should return false when the user is not an editor.");
                Assert.AreEqual(@"dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when trying to hide a poll with an editor");
            }
        }

        /// <summary>
        /// Test voting returns true and gives an xml error when the redirect url is not given
        /// </summary>
        [TestMethod]
        public void TestVoteReturnsTrueWhenNoRedirectGiven()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);
            testPoll.PollID = 0;
            testPoll.RedirectURL = "";
            Assert.IsTrue(testPoll.Vote(0), "Vote with no redirect value should return true!");
            Assert.AreEqual(@"<ERROR TYPE=""ERRORCODE_BADPARAMS""><ERRORMESSAGE>'s_redirectto' not set by skin</ERRORMESSAGE></ERROR>", testPoll.RootElement.InnerXml.ToString(), "The xml for the poll should contain an error about a missing redirect");
        }

        /// <summary>
        /// Check to make sure voting returns false and gives an error on the redirect when the poll id is not valid
        /// </summary>
        [TestMethod]
        public void TestVoteReturnsFalseWhenRedirectGivenAndPollIDIsInvalid()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            PollContentRating testPoll = new PollContentRating(mockedAppContext,null);
            testPoll.PollID = 0;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            Assert.IsFalse(testPoll.Vote(0), "vote should return false if the poll id is not valid!");
            Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=3", testPoll.RedirectURL, "Redirect should contain an error code when trying to hide a poll with an editor");
        }

        /// <summary>
        /// Check to make sure that the vote returns true, but with errors when a non logged in user tries to vote on a non anonymous poll
        /// </summary>
        [TestMethod]
        public void TestVotingReturnsTrueWhenUserNotLoggedInVotingOnANonAnonymousPoll()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123, false, false);
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = false;
            Assert.IsTrue(testPoll.Vote(0), "vote should return true if a non logged in user tries to vote on a non anonymous poll!");
            Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=4", testPoll.RedirectURL, "Redirect should contain an error code when trying to vote on a non anonymous poll not logged in");
        }

        /// <summary>
        /// Check to make sure the poll returns false and gives an error code when a logged in user with invalid userid tries to vote on a non anonymous voting poll
        /// </summary>
        [TestMethod]
        public void TestVotingReturnsFalseWhenALoggedInUserWithInvalidUserIDVotesOnANonAnonymousVotingPoll()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 0, true, false);
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = false;
            Assert.IsFalse(testPoll.Vote(0), "vote should return true if a logged in user with invalid userid tries to vote on a non anonymous poll!");
            Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=0", testPoll.RedirectURL, "Redirect should contain an error code when trying to vote on a non anonymous poll logged in with invalid user id");
        }

        /// <summary>
        /// Check to make sure that we return false when a logged in user with invalid user id tries to vote on an anonymous poll
        /// </summary>
        [TestMethod]
        public void TestVotingReturnsFalseWhenLoggedInUserWithInValidUserIDTriesToVoteOnAnAnonymousVotingPoll()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 0, true, false);
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = true;
            Assert.IsFalse(testPoll.Vote(0), "vote should return true if a logged in user with invalid userid tries to vote on an anonymous poll!");
            Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=0", testPoll.RedirectURL, "Redirect should contain an error code when trying to vote on an anonymous poll logged in with invalid user id");
        }

        /// <summary>
        /// Check to make sure the poll returns true and with error codes when the author of the content the poll is linked to tries to vote
        /// </summary>
        [TestMethod]
        public void TestVotingReturnsTrueWIthErrorCodesWhenTheAuthorOfTheContentThatThePollIsLinkedToTriesToVote()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            int mockedUserID = 123456;
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, mockedUserID, true, false);
            Stub.On(mockedUser).GetProperty("BbcUid").Will(Return.Value("376A83FE-C114-8E06-698B-C66138D635AE"));

            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = "/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = true;

            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, true))
            {
                Stub.On(mockedDataReader).Method("GetInt32").With("itemid").Will(Return.Value(654321));
                using (IDnaDataReader mockedDataReader2 = CreateMockedDanDataReaderForAppContextWithValues("pollgetarticleauthorid", mockedAppContext, true, true))
                {
                    Stub.On(mockedDataReader2).Method("GetInt32").With("userid").Will(Return.Value(mockedUserID));

                    Assert.IsTrue(testPoll.Vote(0), "Vote should return true if a logged in user who's the author of the content the poll is linked to!");
                    Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=6", testPoll.RedirectURL, "Redirect should contain an error code when the author of the content the poll is linked to tries to vote");
                }
            }
        }

        /// <summary>
        /// Check to make sure the vote returns true with errors when the response to a vote is out of range for an anonymous poll and logged out user
        /// </summary>
        [TestMethod]
        public void TestVotingRetrunsTrueIfTheResponseIsOutOfRangeOnAnAnonymousePollAndUserNotLoggedIn_BelowMinValue()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            int mockedUserID = 123456;
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, mockedUserID, false, false);
            Stub.On(mockedUser).GetProperty("BbcUid").Will(Return.Value("376A83FE-C114-8E06-698B-C66138D635AE"));

            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = true;
            testPoll.SetResponseMinMax(0, 10);

            using (IDnaDataReader reader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, false))
            {
                // Test for value below the minimum
                Assert.IsTrue(testPoll.Vote(-1), "Vote should return true if a non logged in users response to an anonymous poll is below the minimum value!");
                Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=2", testPoll.RedirectURL, "Redirect should contain an error code when a logged out users response to an anonymous poll is out of range");
            }
        }

        /// <summary>
        /// Check to make sure the vote returns true with errors when the response to a vote is out of range for an anonymous poll and logged out user
        /// </summary>
        [TestMethod]
        public void TestVotingRetrunsTrueIfTheResponseIsOutOfRangeOnAnAnonymousePollAndUserNotLoggedIn_AboveMaxValue()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            int mockedUserID = 123456;
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, mockedUserID, false, false);
            Stub.On(mockedUser).GetProperty("BbcUid").Will(Return.Value("376A83FE-C114-8E06-698B-C66138D635AE"));

            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = true;
            testPoll.SetResponseMinMax(0, 10);

            using (IDnaDataReader reader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, false))
            {
                // Test for value above the maximum
                Assert.IsTrue(testPoll.Vote(11), "Vote should return true if a non logged in users response to an anonymous poll is above the maximum value!");
                Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=2", testPoll.RedirectURL, "Redirect should contain an error code when a logged out users response to an anonymous poll is out of range");
            }
        }

        /// <summary>
        /// Test to make sure a logged in user can vote with a response within the polls voting range on a non anonymous poll
        /// </summary>
        [TestMethod]
        public void TestVotingReturnsTrueWithNoErrorsWhenALoggedInUserWithValidResponseVotesOnANonAnonymousPoll()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            int mockedUserID = 123456;
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, mockedUserID, true, false);
            Stub.On(mockedUser).GetProperty("BbcUid").Will(Return.Value("376A83FE-C114-8E06-698B-C66138D635AE"));

            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = false;
            testPoll.SetResponseMinMax(0, 10);

            using (IDnaDataReader reader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, false))
            {
                using (IDnaDataReader reader2 = CreateDataReaderForMockedAppContextForStoreProcedure("pollcontentratingvote", mockedAppContext))
                {
                    // Test for value below the minimum
                    Assert.IsTrue(testPoll.Vote(5), "Vote should return true if a logged in users response to an anonymous poll is within voting range!");
                    Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when logged in user votes with an inrange response!");
                }
            }
        }

        /// <summary>
        /// Test to make sure a non logged in user can vote with a response within the polls voting range on an anonymous poll
        /// </summary>
        [TestMethod]
        public void TestVotingReturnsTrueWithNoErrorsWhenAnonLoggedInUserWithValidResponseVotesOnAnAnonymousPoll()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            int mockedUserID = 123456;
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, mockedUserID, false, false);
            Stub.On(mockedUser).GetProperty("BbcUid").Will(Return.Value("376A83FE-C114-8E06-698B-C66138D635AE"));

            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;
            testPoll.RedirectURL = @"/dna/actionnetwork/";
            testPoll.AllowAnonymousVoting = true;
            testPoll.SetResponseMinMax(0, 10);

            using (IDnaDataReader reader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, false))
            {
                using (IDnaDataReader reader2 = CreateDataReaderForMockedAppContextForStoreProcedure("pollanonymouscontentratingvote", mockedAppContext))
                {
                    // Test for value below the minimum
                    Assert.IsTrue(testPoll.Vote(5), "Vote should return true if a logged in users response to an anonymous poll is within voting range!");
                    Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when logged in user votes with an inrange response!");
                }
            }
        }

        /// <summary>
        /// Check to make sure the poll ParseRequestURLForCommand call fails when no redirect given
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_FailsWithNoRedirect()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create the request object
            IRequest mockedRequest = _mock.NewMock<IRequest>();
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value(""));

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);

            // Now test that the request is handled correctly
            Assert.IsFalse(testPoll.ParseRequestURLForCommand(mockedRequest),"Parsing the request with no redirect should fail!");
            Assert.AreEqual(@"<ERROR TYPE=""ERRORCODE_BADPARAMS""><ERRORMESSAGE>'s_redirectto' not set by skin</ERRORMESSAGE></ERROR>", testPoll.RootElement.InnerXml.ToString(), "The xml for the poll should contain an error about a missing redirect");
        }

        /// <summary>
        /// Check to make sure that the parsing of the request fails with error codes when no command is given
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_FailsWithNoCommand()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create the request object
            IRequest mockedRequest = _mock.NewMock<IRequest>();
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value(""));

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);

            // Now test that the request is handled correctly
            Assert.IsFalse(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with no command should fail!");
            Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=1", testPoll.RedirectURL, "Redirect should contain an error code when parsing the request with no command!");
        }

        /// <summary>
        /// Check to amke sure that we can parse the url correctly for a valid vote command.
        /// The test uses a non logged in user on an anonymous voting poll.
        /// !!! We have tests for all the other cases which call the vote method directly !!!
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_ReturnsTrueForValidVoteCommand()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create a non logged in user with valid bbcuid
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, false, false);
            Stub.On(mockedUser).GetProperty("BbcUid").Will(Return.Value("376A83FE-C114-8E06-698B-C66138D635AE"));

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.SetResponseMinMax(0, 10);
            testPoll.PollID = 123;
            testPoll.AllowAnonymousVoting = true;

            // Mock the procedures the voting 
            using (IDnaDataReader reader = CreateMockedDanDataReaderForAppContextWithValues("pollgetitemids", mockedAppContext, true, false))
            {
                using (IDnaDataReader reader2 = CreateDataReaderForMockedAppContextForStoreProcedure("pollanonymouscontentratingvote", mockedAppContext))
                {
                    // Create the request object
                    IRequest mockedRequest = _mock.NewMock<IRequest>();
                    Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
                    Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value("vote"));
                    Stub.On(mockedRequest).Method("TryGetParamIntOrKnownValueOnError").With("response", -1, "Try to get the response for the poll vote").Will(Return.Value(5));

                    // Now test that the request is handled correctly
                    Assert.IsTrue(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with valid vote command should not fail!");
                    Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when parsing the request with valid vote command!");
                }
            }
        }

        /// <summary>
        /// Check to amke sure that we can parse the url correctly for a valid remove vote command.
        /// !!! We have tests for all the other cases which call the remove vote method directly !!!
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_ReturnsTrueForRemoveVoteCommand()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, null);

            // Create the request object
            IRequest mockedRequest = _mock.NewMock<IRequest>();
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value("removevote"));

            // Now test that the request is handled correctly
            Assert.IsTrue(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with remove vote command should not fail!");
            Assert.AreEqual(@"/dna/actionnetwork/?PollErrorCode=2", testPoll.RedirectURL, "Redirect should contain an error code when parsing the request with remove command!");
        }

        /// <summary>
        /// Check to make sure we can correctly handle a valid Hide poll command
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_ReturnsTrueForValidHidePollCommand()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create a logged in editor
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;

            // Create a mocked data reader
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("HidePoll", mockedAppContext, true, true))
            {
                // Create the request object
                IRequest mockedRequest = _mock.NewMock<IRequest>();
                Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
                Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value("hidepoll"));

                // Now test that the request is handled correctly
                Assert.IsTrue(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with hide poll command should not fail!");
                Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when parsing the request with hide poll command!");
            }
        }

        /// <summary>
        /// Check to make sure we can correctly handle a valid unHide poll command
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_ReturnsTrueForValidUnHidePollCommand()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create a logged in editor
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;

            // Create a mocked data reader
            IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("HidePoll", mockedAppContext, true, true);

            // Create the request object
            IRequest mockedRequest = _mock.NewMock<IRequest>();
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
            Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value("hidepoll"));

            // Now test that the request is handled correctly
            Assert.IsTrue(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with unhide poll command should not fail!");
            Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when parsing the request with unhide poll command!");
        }

        /// <summary>
        /// Check to make sure we can correctly handle a valid config poll command with a hide value of 0 (Unhide the vote)
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_ReturnsTrueForValidConfigPollCommandWithHideSetToZero()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create a logged in editor
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;

            // Create a mocked data reader
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("HidePoll", mockedAppContext, true, true))
            {
                // Create the request object
                IRequest mockedRequest = _mock.NewMock<IRequest>();
                Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
                Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value("hidepoll"));
                Stub.On(mockedRequest).Method("DoesParamExist").With("hide", "Hide/Unhide bool param").Will(Return.Value(true));
                Stub.On(mockedRequest).Method("GetParamIntOrZero").With("hide", "Hide/Unhide bool param").Will(Return.Value(0));

                // Now test that the request is handled correctly
                Assert.IsTrue(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with config poll command with hide = 0 should not fail!");
                Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when parsing the request with config poll command with hide = 0!");
            }
        }

        /// <summary>
        /// Check to make sure we can correctly handle a valid config poll command with a hide value of 1 (Hide the vote)
        /// </summary>
        [TestMethod]
        public void Test_ParseRequestURLForCommand_ReturnsTrueForValidConfigPollCommandWithHideSetToOne()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create a logged in editor
            IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

            // Create the Poll. It won't need a user at this stage
            PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
            testPoll.PollID = 123;

            // Create a mocked data reader
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("HidePoll", mockedAppContext, true, true))
            {
                // Create the request object
                IRequest mockedRequest = _mock.NewMock<IRequest>();
                Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("s_redirectto", "Check the redirect for the poll exists").Will(Return.Value("/dna/actionnetwork/"));
                Stub.On(mockedRequest).Method("GetParamStringOrEmpty").With("cmd", "Get the command for the poll").Will(Return.Value("hidepoll"));
                Stub.On(mockedRequest).Method("DoesParamExist").With("hide", "Hide/Unhide bool param").Will(Return.Value(true));
                Stub.On(mockedRequest).Method("GetParamIntOrZero").With("hide", "Hide/Unhide bool param").Will(Return.Value(1));

                // Now test that the request is handled correctly
                Assert.IsTrue(testPoll.ParseRequestURLForCommand(mockedRequest), "Parsing the request with config poll command with hide = 1 should not fail!");
                Assert.AreEqual(@"/dna/actionnetwork/", testPoll.RedirectURL, "Redirect should not contain an error code when parsing the request with config poll command with hide = 1!");
            }
        }

        /// <summary>
        /// Test Poll statistics generation
        /// </summary>
        [TestMethod]
        public void Test_Statistics_UserLoggedInAndStatisticsSet()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create data reader for load user vote. 
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("GetUserVotes", mockedAppContext, true, true))
            {
                Stub.On(mockedDataReader).Method("GetInt32").WithAnyArguments().Will(Return.Value(1));
                Stub.On(mockedAppContext).Method("CreateDnaDataReader").With("GetUserVotes").Will(Return.Value(mockedDataReader));

                // Create a logged in editor
                IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

                // Create the Poll.
                PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
                testPoll.PollID = 123;

                // Set stats
                testPoll.SetPollStatistic("blah", "blah-value");
                testPoll.SetContentRatingStatistics(5, 2.2);

                Assert.IsTrue(testPoll.MakePollXML(false) != null, "MakePollXML should return true when user is logged in and stats set.");

                // Check Xml
                XmlDocument doc = new XmlDocument();
                XmlNode docNode = doc.ImportNode(testPoll.RootElement, true);
                XmlNode statNode = docNode.SelectSingleNode("POLL/STATISTICS");
                Assert.IsNotNull(statNode, "Failed to find POLL/STATISTICS");
                // Check values of Statistics XML
                Assert.IsTrue(statNode.Attributes.Count == 3, "Unexpected attributes in Poll Statistics");
                XmlNode blahNode = statNode.Attributes.GetNamedItem("BLAH");
                Assert.IsTrue(blahNode.Value.Equals("blah-value"), "Attribute is not an expected value.");

                XmlNode votecountNode = statNode.Attributes.GetNamedItem("VOTECOUNT");
                Assert.IsTrue(votecountNode.Value.Equals("5"), "VOTECOUNT attribute is not an expected value.");

                XmlNode avgRatingNode = statNode.Attributes.GetNamedItem("AVERAGERATING");
                Assert.IsTrue(avgRatingNode.Value.Equals("2.2"), "AVERAGERATING attribute is not an expected value.");
            }
        }

        /// <summary>
        /// Test Poll statistics with invalid name
        /// </summary>
        [TestMethod]
        public void Test_Statistics_NullName()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create data reader for load user vote. 
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("GetUserVotes", mockedAppContext, true, true))
            {
                Stub.On(mockedDataReader).Method("GetInt32").WithAnyArguments().Will(Return.Value(1));

                Stub.On(mockedAppContext).Method("CreateDnaDataReader").With("GetUserVotes").Will(Return.Value(mockedDataReader));

                // Create a logged in editor
                IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

                // Create the Poll.
                PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
                testPoll.PollID = 123;

                // try to set stat with invalid name
                testPoll.SetPollStatistic(null, "blah-value");

                Assert.IsTrue(testPoll.MakePollXML(false) != null, "MakePollXML should return true when user is logged in and stats set.");

                XmlDocument doc = new XmlDocument();
                XmlNode docNode = doc.ImportNode(testPoll.RootElement, true);
                XmlNode errorNode = docNode.SelectSingleNode("ERROR");
                Assert.IsNotNull(errorNode, "Failed to find ERROR element");
                XmlNode errorAttribute = errorNode.Attributes.GetNamedItem("TYPE");
                Assert.IsTrue(errorAttribute.Value.Equals("2"), "Unexpected value for error code.");

                XmlNode statNode = docNode.SelectSingleNode("POLL/STATISTICS");
                Assert.IsNull(statNode, "Inexpected POLL/STATISTICS element");
            }
        }

        /// <summary>
        /// Test Poll statistics with invalid name
        /// </summary>
        [TestMethod]
        public void Test_Statistics_BlankName()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create data reader for load user vote. 
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("GetUserVotes", mockedAppContext, true, true))
            {
                Stub.On(mockedDataReader).Method("GetInt32").WithAnyArguments().Will(Return.Value(1));
                Stub.On(mockedAppContext).Method("CreateDnaDataReader").With("GetUserVotes").Will(Return.Value(mockedDataReader));

                // Create a logged in editor
                IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

                // Create the Poll.
                PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
                testPoll.PollID = 123;

                // try to set stat with invalid name
                testPoll.SetPollStatistic("", "blah-value");

                Assert.IsTrue(testPoll.MakePollXML(false) != null, "MakePollXML should return true when user is logged in and stats set.");

                XmlDocument doc = new XmlDocument();
                XmlNode docNode = doc.ImportNode(testPoll.RootElement, true);
                XmlNode errorNode = docNode.SelectSingleNode("ERROR");
                Assert.IsNotNull(errorNode, "Failed to find ERROR element");
                XmlNode errorAttribute = errorNode.Attributes.GetNamedItem("TYPE");
                Assert.IsTrue(errorAttribute.Value.Equals("2"), "Unexpected value for error code.");

                XmlNode statNode = docNode.SelectSingleNode("POLL/STATISTICS");
                Assert.IsNull(statNode, "Inexpected POLL/STATISTICS element");
            }
        }

        /// <summary>
        /// Test update of a Poll statistics
        /// </summary>
        [TestMethod]
        public void Test_Statistics_UpdateAStat()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create data reader for load user vote. 
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("GetUserVotes", mockedAppContext, true, true))
            {
                Stub.On(mockedDataReader).Method("GetInt32").WithAnyArguments().Will(Return.Value(1));
                Stub.On(mockedAppContext).Method("CreateDnaDataReader").With("GetUserVotes").Will(Return.Value(mockedDataReader));

                // Create a logged in editor
                IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

                // Create the Poll.
                PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
                testPoll.PollID = 123;

                // add VOTECOUNT and AVERAGERATING
                testPoll.SetContentRatingStatistics(5, 2.2);
                testPoll.SetPollStatistic("VOTECOUNT", "7");

                Assert.IsTrue(testPoll.MakePollXML(false) != null, "MakePollXML should return true when user is logged in and stats set.");

                // Check Xml
                XmlDocument doc = new XmlDocument();
                XmlNode docNode = doc.ImportNode(testPoll.RootElement, true);
                XmlNode statNode = docNode.SelectSingleNode("POLL/STATISTICS");
                Assert.IsNotNull(statNode, "Failed to find POLL/STATISTICS");
                // Check values of Statistics XML
                Assert.IsTrue(statNode.Attributes.Count == 2, "Unexpected attributes in Poll Statistics");
                XmlNode countNode = statNode.Attributes.GetNamedItem("VOTECOUNT");
                Assert.IsTrue(countNode.Value.Equals("7"), "VOTECOUNT attribute is not an expected value.");

                XmlNode avgRatingNode = statNode.Attributes.GetNamedItem("AVERAGERATING");
                Assert.IsTrue(avgRatingNode.Value.Equals("2.2"), "AVERAGERATING attribute is not an expected value.");
            }
        }
        
        /// <summary>
        /// Test update of a Poll statistics
        /// </summary>
        [TestMethod]
        public void Test_Statistics_RemoveAStat()
        {
            // Create the app context for the poll to run in
            IAppContext mockedAppContext = CreateMockedAppContextAndDiagnostics();

            // Create data reader for load user vote. 
            using (IDnaDataReader mockedDataReader = CreateMockedDanDataReaderForAppContextWithValues("GetUserVotes", mockedAppContext, true, true))
            {
                Stub.On(mockedDataReader).Method("GetInt32").WithAnyArguments().Will(Return.Value(1));

                Stub.On(mockedAppContext).Method("CreateDnaDataReader").With("GetUserVotes").Will(Return.Value(mockedDataReader));

                // Create a logged in editor
                IUser mockedUser = CreateMockedUserForMockedAppContext(mockedAppContext, 123456, true, true);

                // Create the Poll.
                PollContentRating testPoll = new PollContentRating(mockedAppContext, mockedUser);
                testPoll.PollID = 123;

                // add VOTECOUNT and AVERAGERATING
                testPoll.SetContentRatingStatistics(5, 2.2);
                testPoll.SetPollStatistic("votecount", null);

                Assert.IsTrue(testPoll.MakePollXML(false) != null, "MakePollXML should return true when user is logged in and stats set.");

                // Check Xml
                XmlDocument doc = new XmlDocument();
                XmlNode docNode = doc.ImportNode(testPoll.RootElement, true);
                XmlNode statNode = docNode.SelectSingleNode("POLL/STATISTICS");
                Assert.IsNotNull(statNode, "Failed to find POLL/STATISTICS");



                // Check values of Statistics XML
                Assert.IsTrue(statNode.Attributes.Count == 1, "Unexpected attributes in Poll Statistics");
                XmlNode countNode = statNode.Attributes.GetNamedItem("VOTECOUNT");
                Assert.IsNull(countNode, "Found VOTECOUNT attribute when we should not have.");

                XmlNode avgRatingNode = statNode.Attributes.GetNamedItem("AVERAGERATING");
                Assert.IsTrue(avgRatingNode.Value.Equals("2.2"), "AVERAGERATING attribute is not an expected value.");
            }
        }
    }
}
