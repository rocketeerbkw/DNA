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
    public partial class AbilityToChangeTheEmailAddressForAGivenContactFormsFeature
    {
        
        private static TechTalk.SpecFlow.ITestRunner testRunner;
        
#line 1 "CommentForumListPage.ContactForms.feature"
#line hidden
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.ClassInitializeAttribute()]
        public static void FeatureSetup(Microsoft.VisualStudio.TestTools.UnitTesting.TestContext testContext)
        {
            testRunner = TechTalk.SpecFlow.TestRunnerManager.GetTestRunner();
            TechTalk.SpecFlow.FeatureInfo featureInfo = new TechTalk.SpecFlow.FeatureInfo(new System.Globalization.CultureInfo("en-US"), "Ability to change the email address for a given contact forms", "In order to be able to have different email address receipients for each contact " +
                    "form\r\nAs an editor\r\nI need to have the ability to specify an email address per f" +
                    "orm", ProgrammingLanguage.CSharp, ((string[])(null)));
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
                        && (TechTalk.SpecFlow.FeatureContext.Current.FeatureInfo.Title != "Ability to change the email address for a given contact forms")))
            {
                Comments.AcceptanceTests.AbilityToChangeTheEmailAddressForAGivenContactFormsFeature.FeatureSetup(null);
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
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Existing comment forum amend contact email address")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Ability to change the email address for a given contact forms")]
        public virtual void ExistingCommentForumAmendContactEmailAddress()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Existing comment forum amend contact email address", ((string[])(null)));
#line 6
this.ScenarioSetup(scenarioInfo);
#line 7
testRunner.Given("an exisiting comment forum");
#line 8
testRunner.And("a contact email address has already been associated to it");
#line 9
testRunner.And("I am logged in as an editor");
#line 10
testRunner.When("I go to the CommentForumList page");
#line 11
testRunner.And("amend the email address to \'<email_address>\'");
#line 12
testRunner.And("submit my changes");
#line hidden
            TechTalk.SpecFlow.Table table1 = new TechTalk.SpecFlow.Table(new string[] {
                        "email_address"});
            table1.AddRow(new string[] {
                        "test@bbc.co.uk"});
#line 13
testRunner.Then("the chosen Forum is updated with the new \'<email_address>\'", ((string)(null)), table1);
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("A non \'@BBC.co.uk\' contact email address is not allowed")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Ability to change the email address for a given contact forms")]
        public virtual void ANonBBC_Co_UkContactEmailAddressIsNotAllowed()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("A non \'@BBC.co.uk\' contact email address is not allowed", ((string[])(null)));
#line 17
this.ScenarioSetup(scenarioInfo);
#line 18
testRunner.Given("an exisiting comment forum");
#line 19
testRunner.And("I am logged in as an editor");
#line 20
testRunner.When("I go to the CommentForumList page");
#line 21
testRunner.And("a non @BBC.co.uk address is entered");
#line 22
testRunner.And("submit my changes");
#line 23
testRunner.Then("an invalid contact email exception is thrown");
#line hidden
            this.ScenarioCleanup();
        }
        
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethodAttribute()]
        [Microsoft.VisualStudio.TestTools.UnitTesting.DescriptionAttribute("Existing comment forum amend contact email address to blank")]
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestPropertyAttribute("FeatureTitle", "Ability to change the email address for a given contact forms")]
        public virtual void ExistingCommentForumAmendContactEmailAddressToBlank()
        {
            TechTalk.SpecFlow.ScenarioInfo scenarioInfo = new TechTalk.SpecFlow.ScenarioInfo("Existing comment forum amend contact email address to blank", ((string[])(null)));
#line 25
this.ScenarioSetup(scenarioInfo);
#line 26
testRunner.Given("an exisiting comment forum");
#line 27
testRunner.And("a contact email address has already been associated to it");
#line 28
testRunner.And("I am logged in as an editor");
#line 29
testRunner.When("I go to the CommentForumList page");
#line 30
testRunner.And("amend the email address to blank");
#line 31
testRunner.And("there is a valid site default email address");
#line 32
testRunner.And("submit my changes");
#line 33
testRunner.Then("the returned contact form object contains the default site email address");
#line hidden
            this.ScenarioCleanup();
        }
    }
}
#endregion
