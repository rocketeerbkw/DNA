using System;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Text;
using BBC.Dna.Utils;
using Dna.SnesIntegration.ActivityProcessor.Contracts;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SnesActivityProcessorTests
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
            var comment = new OpenSocialActivity();

            comment.Title = "A title";
            comment.Body = "A body";
            comment.DisplayName = "mooks";
            comment.PostedTime = 1234567890;
            comment.Url = new Uri("http://www.bbc.co.uk/dna/h2g2/F1",UriKind.RelativeOrAbsolute);
            comment.UserName = "1234";
            comment.ObjectDescription = "An object description";
            comment.ObjectUri = new Uri("/dna/h2g2/F1", UriKind.Relative);
            comment.ObjectTitle = "A title";

            string json = comment.SerializeToJson();

            Assert.IsTrue(json.Contains("\"title\":\"A title\""));

        }

        [TestMethod]
        public void OpenSocialContract_DeserializeFromJson_ReturnsOk()
        {
            //string openSocialActivityJson = 
            //    @"{"+
            //    @"""objectUri"":""b00qhs5v""," +
            //    @"""body"":""Rock and Chips""," +
            //    @"""meh"":""meh""" +
            //    @"}";

            string testJson = @"{""startIndex"":0, ""itemsPerPage"":1,""totalResults"":20, ""entry"":[{""id"":0}, {""id"":1}]}";

            var ser = new DataContractJsonSerializer(typeof(OpenSocialActivities));
            var ms = new MemoryStream(Encoding.Unicode.GetBytes(testJson));
            var activity = ser.ReadObject(ms) as OpenSocialActivities;
        }
    }
}


