using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TechTalk.SpecFlow;
using Tests;
using Comments.AcceptanceTests.Support;
using BBC.Dna.Api;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading;

namespace Comments.AcceptanceTests.StepDefinitions
{
    public partial class StepDefinitions
    {
        [Given(@"a forum has been setup to allow anonymous posting")]
        public void GivenAForumHasBeenSetupToAllowAnonymousPosting()
        {
            bool allowAnonymousPosting = true;
            string title = "testcommentforums-anonymousposting";
            string id = "new-anonymous-commentforum" + DateTime.Now.Ticks.ToString();
            CommentForumTestUtils.CreateTestCommentForum(request, allowAnonymousPosting, title, id);
        }

        [Given(@"a forum allows only signed in users to add to it")]
        public void GivenAForumAllowsOnlySignedInUsersToAddToIt()
        {
            bool allowAnonymousPosting = false;
            string title = "testcommentforums-signedinposting";
            string id = "new-signedin-commentforum" + DateTime.Now.Ticks.ToString();
            CommentForumTestUtils.CreateTestCommentForum(request, allowAnonymousPosting, title, id);
        }

        [Given(@"has had an post already against it by a user who is signed in")]
        public void GivenHasHadAnPostAlreadyAgainstItByAUserWhoIsSignedIn()
        {
            callingUserType = DnaTestURLRequest.usertype.EDITOR;
            WhenPostsToIt();
        }

        [When(@"a user who is not signed in goes to the forum")]
        public void WhenAUserWhoIsNotSignedInGoesToTheForum()
        {
            callingUserType = DnaTestURLRequest.usertype.NOTLOGGEDIN;
        }

        [When(@"posts to it")]
        public void WhenPostsToIt()
        {
            string text = "";
            string username = "";
            if (callingUserType == DnaTestURLRequest.usertype.NOTLOGGEDIN)
            {
                text = "(Anonymous) I would like to say " + DateTime.Now.Ticks + " is a big number";
                username = "Anonymous Bob";
            }
            else
            {
                text = "(SignedIn) I would like to say " + DateTime.Now.Ticks + " is a big number";
                username = request.CurrentUserName;
            }

            TestRunnerManager.GetTestRunner().ScenarioContext.Remove("CreateTestCommentForum.LastPostedText");
            TestRunnerManager.GetTestRunner().ScenarioContext.Add("CreateTestCommentForum.LastPostedText", text);

            CommentForum createdForum = TestRunnerManager.GetTestRunner().ScenarioContext.Get<CommentForum>("CreateTestCommentForum.newCommentForum");
            CommentForum thisRequestCommentForum = CommentForumTestUtils.CreateCommentforumToPost(createdForum.allowNotSignedInCommenting, createdForum.Title, createdForum.Id, text, createdForum.ParentUri, username);
 
            try
            {
                string jsonPostData = CommentForumTestUtils.SerializeToJsonString(thisRequestCommentForum);
                CommentForumTestUtils.CallPUTCreateCommentAPIRequest(request, "h2g2", thisRequestCommentForum.Id, jsonPostData, callingUserType);
                var returnedCommentInfo = (CommentInfo)request.GetLastResponseAsJSONObject(typeof(CommentInfo));
                TestRunnerManager.GetTestRunner().ScenarioContext.Remove("CreateTestCommentForum.returnedCommentInfo");
                TestRunnerManager.GetTestRunner().ScenarioContext.Add("CreateTestCommentForum.returnedCommentInfo", returnedCommentInfo);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                if (createdForum.allowNotSignedInCommenting)
                {
                    Console.WriteLine(ex.StackTrace);
                    throw ex;
                }
            }
        }

        [When(@"anonymous user tries to post to it")]
        public void WhenAnonymousUserTriesToPostToIt()
        {
            callingUserType = DnaTestURLRequest.usertype.NOTLOGGEDIN;
            WhenPostsToIt();
        }

        [When(@"an anonymous user goes to the same forum")]
        public void WhenAnAnonymousUserGoesToTheSameForum()
        {
            callingUserType = DnaTestURLRequest.usertype.NOTLOGGEDIN;
        }

        [Then(@"the post is not added")]
        public void ThenThePostIsNotAdded()
        {
            string postedText = TestRunnerManager.GetTestRunner().ScenarioContext.Get<string>("CreateTestCommentForum.LastPostedText");
            CommentForum commentForum = TestRunnerManager.GetTestRunner().ScenarioContext.Get<CommentForum>("CreateTestCommentForum.newCommentForum");
            CommentForumTestUtils.CheckCommentIsOrIsNotInTheCommentList(request, false, postedText, commentForum);
        }

        [Then(@"adds correctly to the forum")]
        public void ThenAddsCorrectlyToTheForum()
        {
            string postedText = TestRunnerManager.GetTestRunner().ScenarioContext.Get<string>("CreateTestCommentForum.LastPostedText");
            CommentForum commentForum = TestRunnerManager.GetTestRunner().ScenarioContext.Get<CommentForum>("CreateTestCommentForum.newCommentForum");
            CommentForumTestUtils.CheckCommentIsOrIsNotInTheCommentList(request, true, postedText, commentForum);
        }

        [Then(@"the post is successfully placed")]
        public void ThenThePostIsSuccessfullyPlaced()
        {
            Assert.AreEqual(System.Net.HttpStatusCode.OK, request.GetLastStatusCode());
        }

        [Then(@"they are given a message saying they need to be signed in or regsistered to post")]
        public void ThenTheyAreGivenAMessageSayingTheyNeedToBeSignedInOrRegsisteredToPost()
        {
            CommentForumTestUtils.AssertResponseContainsGivenErrorTypeDetailAndCode(request.GetLastResponseAsString(), ErrorType.NotAuthorized);
        }
    }
}
