using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TechTalk.SpecFlow;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Users;

namespace Comments.AcceptanceTests.StepDefinitions
{
    public partial class StepDefinitions
    {
        private int profileSiteId;
        private User user;


        [When(@"I create a profile with a valid twitter user that does not already exist in DNA")]
        public void WhenICreateAProfileWithAValidTwitterUserThatDoesNotAlreadyExistInDNA()
        {
            // Mock twitter user not in DB
            // Mock 
            //var twitterUser = new TwitterUser();
            //var profile = new TwitterProfile(twitterUser);

            ScenarioContext.Current.Pending();
        }

        [When(@"I update a profile with a valid twitter user that does not already exist in DNA")]
        public void WhenIUpdateAProfileWithAValidTwitterUserThatDoesNotAlreadyExistInDNA()
        {
            //profile.Update();
            ScenarioContext.Current.Pending();
        }

        [Then(@"the user is created in the same site as the profile")]
        public void ThenTheUserIsCreatedInTheSameSiteAsTheProfile()
        {
            Assert.AreEqual(profileSiteId, user.PrimarySiteId);
        }
    }
}
