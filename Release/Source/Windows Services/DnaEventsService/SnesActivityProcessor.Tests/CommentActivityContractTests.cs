
using BBC.Dna.Utils;
using Dna.SnesIntegration.ActivityProcessor;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SnesActivityTests
{
    public static class ObjectExtensionMethods
    {
        public static string SerializeToJson(this object source)
        {
            return StringUtils.SerializeToJson(source);
        }
    }

    [TestClass]
    public class CommentActivityContractTests
    {

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

        [TestMethod]
        public void CommentActivityDataContract_Serialize()
        {
            OpenSocialActivity comment = new OpenSocialActivity();

            comment.Title = "A title";
            comment.Body = "A body";
            comment.DisplayName = "mooks";
            comment.PostedTime = 1234567890;
            comment.Url = "http://www.bbc.co.uk/dna/h2g2/F1";
            comment.Username = "1234";
            comment.ObjectDescription = "An object description";
            comment.OjectUri = "/dna/h2g2/F1";
            comment.OjectTitle = "A title";

            string json = comment.SerializeToJson();

            Assert.IsTrue(json.Contains("\"title\":\"A title\""));
           
        }
    }
}
