using TechTalk.SpecFlow;

namespace Comments.AcceptanceTests.StepDefinitions
{
    //[Binding]
    public partial class StepDefinitions
    {
        [Given(@"I am in some known context")]
        public void GivenIAmInSomeKnownContext()
        {
            //ScenarioContext.Current.Pending();

            //setup the class/classes or mock objects required to get yourself into the know context.
            //this is the 'Arrange' part
        }

        [Then(@"I am in a new context")]
        public void ThenIAmInANewContext()
        {
            // ScenarioContext.Current.Pending();
            //check that you have the right outcome
            //this is the 'Assert' part. Try to keep it to ONE assert.
        }

        [When(@"I action some behaviour")]
        public void WhenIActionSomeBehaviour()
        {
            //ScenarioContext.Current.Pending();

            //gather and process the inputs on you objects...
            //this is the 'Act' part
        }
    }
}