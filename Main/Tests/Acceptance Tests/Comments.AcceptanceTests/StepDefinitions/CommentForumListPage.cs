using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TechTalk.SpecFlow;
using Comments.AcceptanceTests.Support;
using BBC.Dna.Api;

namespace Comments.AcceptanceTests.StepDefinitions
{
    public partial class StepDefinitions
    {
        [Given(@"a contact email address has already been associated to it")]
        public void GivenAContactEmailAddressHasAlreadyBeenAssociatedToIt()
        {
            ScenarioContext.Current.Pending();
        }

        [Given(@"an exisiting comment forum")]
        public void GivenAnExisitingCommentForum()
        {
            //ContactFormTestUtils.CallCreateContactFormAPIRequest(request, "h2g2", 
        }

        [Then(@"the returned contact form object contains the default site email address")]
        public void ThenTheReturnedContactFormObjectContainsTheDefaultSiteEmailAddress()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"amend the email address to blank")]
        public void WhenAmendTheEmailAddressToBlank()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"I go to the CommentForumList page")]
        public void WhenIGoToTheCommentForumListPage()
        {
            CommentForumTestUtils.CallCommentForumList(request, "&s_displaycontactforms=1&skin=purexml");
        }

        [When(@"submit my changes")]
        public void WhenSubmitMyChanges()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"there is a valid site default email address")]
        public void WhenThereIsAValidSiteDefaultEmailAddress()
        {
            ScenarioContext.Current.Pending();
        }

        [Then(@"an invalid contact email exception is thrown")]
        public void ThenAnInvalidContactEmailExceptionIsThrown()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"a non @BBC\.co\.uk address is entered")]
        public void WhenANonBBC_Co_UkAddressIsEntered()
        {
            ScenarioContext.Current.Pending();
        }

        [Then(@"the chosen Forum is updated with the new '<email_address>'")]
        public void ThenTheChosenForumIsUpdatedWithTheNewEmail_Address(Table table)
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"amend the email address to '<email_address>'")]
        public void WhenAmendTheEmailAddressToEmail_Address()
        {
            ScenarioContext.Current.Pending();
        }

        [Given(@"a user goes to a page with a contact form on it")]
        public void GivenAUserGoesToAPageWithAContactFormOnIt()
        {
            ScenarioContext.Current.Pending();
        }

        [Then(@"the contact form is created without editor involvement")]
        public void ThenTheContactFormIsCreatedWithoutEditorInvolvement()
        {
            ScenarioContext.Current.Pending();
        }

        [When(@"the first submission has been done on it")]
        public void WhenTheFirstSubmissionHasBeenDoneOnIt()
        {
            ScenarioContext.Current.Pending();
        }

        [Given(@"the contact form has anonymous posting set to '<Anon_Post>'")]
        public void GivenTheContactFormHasAnonymousPostingSetToAnon_Post()
        {
            ScenarioContext.Current.Pending();
        }

        [Then(@"the posts is '<Post_Status>'")]
        public void ThenThePostsIsPost_Status(Table table)
        {
            ScenarioContext.Current.Pending();
        }
    }
}
