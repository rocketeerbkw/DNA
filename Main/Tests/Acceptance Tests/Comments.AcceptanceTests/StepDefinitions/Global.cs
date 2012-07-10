using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TechTalk.SpecFlow;
using Tests;

namespace Comments.AcceptanceTests.StepDefinitions
{
    [Binding]
    public partial class StepDefinitions
    {
        private DnaTestURLRequest request = null;
        private DnaTestURLRequest.usertype callingUserType = DnaTestURLRequest.usertype.NOTLOGGEDIN;

        [BeforeFeature]
        public static void BeforeTheFeature()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            TestRunnerManager.GetTestRunner().FeatureContext.Add("dnarequester", new DnaTestURLRequest(""));
        }

        [BeforeScenarioBlock]
        public void BeforeTheScenario()
        {
            request = TestRunnerManager.GetTestRunner().FeatureContext.Get<DnaTestURLRequest>("dnarequester");
        }
    }
}
