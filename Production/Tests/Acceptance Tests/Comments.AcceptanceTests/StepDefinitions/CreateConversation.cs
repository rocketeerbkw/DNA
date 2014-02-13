using TechTalk.SpecFlow;

namespace Comments.AcceptanceTests.StepDefinitions
{
    //[Binding]
    public partial class StepDefinitions
    {
        [Given(@"a comment forum")]
        public void Givenacommentforum()
        {
            //ScenarioContext.Current.Pending();

            //setup the class/classes or mock objects required to get yourself into the know context.
            //this is the 'Arrange' part
        }

        [When(@"I create a new conversation")]
        public void WhenIcreateanewconversation()
        {
            // ScenarioContext.Current.Pending();
            //check that you have the right outcome
            //this is the 'Assert' part. Try to keep it to ONE assert.
        }

        [Then(@"blah blah blah")]
        public void Thenblahblahblah()
        {
            //ScenarioContext.Current.Pending();

            //gather and process the inputs on you objects...
            //this is the 'Act' part
        }
    }
}
