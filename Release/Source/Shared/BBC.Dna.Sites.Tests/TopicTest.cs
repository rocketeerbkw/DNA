using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BBC.Dna.Sites.Tests
{
    /// <summary>
    ///This is a test class for TopicTest and is intended
    ///to contain all TopicTest Unit Tests
    ///</summary>
    [TestClass]
    public class TopicTest
    {
      /// <summary>
        ///A test for Topic Constructor
        ///</summary>
        [TestMethod]
        public void TopicConstructorTest()
        {
            int topicId = 1; 
            string title = "test"; 
            int h2G2Id = 1; 
            int forumId = 1;
            int status = 1; 
            var target = new Topic(topicId, title, h2G2Id, forumId, status);
            Assert.AreEqual(topicId, target.TopicId);

        }

        /// <summary>
        ///A test for Topic Constructor
        ///</summary>
        [TestMethod]
        public void TopicConstructorTest_TitleContainsHtmlEncoding_CorrectlyDecodesEncoding()
        {
            int topicId = 1;
            string title = "test &amp; test";
            int h2G2Id = 1;
            int forumId = 1;
            int status = 1;
            var target = new Topic(topicId, title, h2G2Id, forumId, status);
            Assert.AreEqual(topicId, target.TopicId);
            Assert.AreEqual("test & test", target.Title);

        }
    }
}