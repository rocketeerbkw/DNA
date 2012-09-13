﻿// ------------------------------------------------------------------------------
//  <auto-generated>
//      This code was generated by SpecFlow (http://www.specflow.org/).
//      SpecFlow Version:1.8.1.0
//      Runtime Version:2.0.50727.4971
// 
//      Changes to this file may cause incorrect behavior and will be lost if
//      the code is regenerated.
//  </auto-generated>
// ------------------------------------------------------------------------------
#region Designer generated code
namespace Comments.AcceptanceTests
{
    using TechTalk.SpecFlow;
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("TechTalk.SpecFlow", "1.8.1.0")]
    [System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClassAttribute()]
    public partial class AnonymousUsersCanPostOntoForumsEvenIfFirstPostHasBeenDoneByAUserWhoIsSignedInFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "Comments.AnonymousPosting.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Anonymous users can post onto forums even if first post has been done by a user w" +
                    "ho is signed in", "In order to allow anonymous user posting to a forum even if the first post has be" +
                    "en posted as signed in user\r\nas an anonymous user on a forum\r\nI want to be able " +
                    "to add to the forum even if the first post in that forum was completed by someon" +
                    "e signed in", ProgrammingLanguage.CSharp, ((string[])(null)));
            testRunner.OnFeatureStart(featureInfo);
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassCleanupAttribute()]
        public static void FeatureTearDown()
        {
            testRunner.OnFeatureEnd();
            testRunner = null;
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestInitializeAttribute()]
        public virtual void TestInitialize()
        {
            if (((TechTalk.SpecFlow.FeatureContext.Current != null) 
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "Anonymous users can post onto forums even if first post has been done by a user w" +
                            "ho is signed in")))
            {
                Comments.AcceptanceTests.AnonymousUsersCanPostOntoForumsEvenIfFirstPostHasBeenDoneByAUserWhoIsSignedInFeature.FeatureSetup(null);
            }
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestCleanupAttribute()]
        public virtual void ScenarioTearDown()
        {
            testRunner.OnScenarioEnd();
        }
        
        public virtual void ScenarioSetup(TechTalk.SpecFlow.ScenarioInfo scenarioInfo)
        {
            testRunner.OnScenarioStart(scenarioInfo);
        }
        
        public virtual void ScenarioCleanup()
        {
            testRunner.CollectScenarioErrors();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Forum set up to accept anonymous posting")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Anonymous users can post onto forums even if first post has been done by a user w" +
            "ho is signed in")]
        public virtual void ForumSetUpToAcceptAnonymousPosting()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Forum set up to accept anonymous posting", ((string[])(null)));
#line 6
this.ScenarioSetup(scenarioInfo);
#line 7
testRunner.Given("a forum has been setup to allow anonymous posting");
#line 8
testRunner.When("a user who is not signed in goes to the forum");
#line 9
testRunner.And("posts to it");
#line 10
testRunner.Then("the post is successfully placed");
#line 11
testRunner.And("adds correctly to the forum");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Forum set up to accept anonymous posting and first post against it has been done " +
            "by a signed in user")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Anonymous users can post onto forums even if first post has been done by a user w" +
            "ho is signed in")]
        public virtual void ForumSetUpToAcceptAnonymousPostingAndFirstPostAgainstItHasBeenDoneByASignedInUser()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Forum set up to accept anonymous posting and first post against it has been done " +
                    "by a signed in user", ((string[])(null)));
#line 13
this.ScenarioSetup(scenarioInfo);
#line 14
testRunner.Given("a forum has been setup to allow anonymous posting");
#line 15
testRunner.And("has had an post already against it by a user who is signed in");
#line 16
testRunner.When("an anonymous user goes to the same forum");
#line 17
testRunner.And("posts to it");
#line 18
testRunner.Then("the post is successfully placed");
#line 19
testRunner.And("adds correctly to the forum");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Forum has been setup to only allow signed in users to post to it")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Anonymous users can post onto forums even if first post has been done by a user w" +
            "ho is signed in")]
        public virtual void ForumHasBeenSetupToOnlyAllowSignedInUsersToPostToIt()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Forum has been setup to only allow signed in users to post to it", ((string[])(null)));
#line 21
this.ScenarioSetup(scenarioInfo);
#line 22
testRunner.Given("a forum allows only signed in users to add to it");
#line 23
testRunner.When("anonymous user tries to post to it");
#line 24
testRunner.Then("they are given a message saying they need to be signed in or regsistered to post");
#line 25
testRunner.And("the post is not added");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#endregion
