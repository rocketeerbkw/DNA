using System;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using System.Collections.Generic;
using BBC.Dna.Utils;


namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for ThreadPostTest and is intended
    ///to contain all ThreadPostTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ThreadPostTest
    {

        [TestInitialize]
        public void Initialize()
        {
            Queue<string> tags = new Queue<string>();
            tags.Enqueue("<2cents>");
            tags.Enqueue("<ale>");
            tags.Enqueue("<yikes>");
            tags.Enqueue(";)");
            

            Queue<string> tagTranslation = new Queue<string>();
            tagTranslation.Enqueue("2cents");
            tagTranslation.Enqueue("ale");
            tagTranslation.Enqueue("yikes");
            tagTranslation.Enqueue("winkeye");
            
            

            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(4);
            reader.Stub(x => x.GetStringNullAsEmpty("name")).Return("").WhenCalled(x => x.ReturnValue = tagTranslation.Dequeue());
            reader.Stub(x => x.GetStringNullAsEmpty("tag")).Return("").WhenCalled(x => x.ReturnValue = tags.Dequeue());
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getsmileylist")).Return(reader);
            mocks.ReplayAll();

            SmileyTranslator.LoadSmileys(creator);
        }

        /// <summary>
        ///A test for text
        ///</summary>
        [TestMethod()]
        public void FormatPost_DefaultStatus_ReturnsUnchangedText()
        {
            var testDataPlainText = new List<string[]>();
            testDataPlainText.Add(new[] { "This post is ok.", "This post is ok." });//no html
            testDataPlainText.Add(new[] { "This <script src=\"test\">post</script> is ok.", "This post is ok." });//script tags
            testDataPlainText.Add(new[] { "This <p onclick=\"test\">post</p> is ok.", "This post is ok." });//allowed tags with events
            testDataPlainText.Add(new[] { "This <link>post</link> is ok.", "This post is ok." });//invalid tags
            testDataPlainText.Add(new[] { "This <ale> post is ok.", "This <SMILEY TYPE='ale' H2G2='Smiley#ale'/> post is ok." });//with smileys translation
            testDataPlainText.Add(new[] { "This <quote>post</quote> is ok.", "This <QUOTE>post</QUOTE> is ok." });//with quote translation
            testDataPlainText.Add(new[] { "This http://www.bbc.co.uk/ is ok.", "This <LINK HREF=\"http://www.bbc.co.uk/\">http://www.bbc.co.uk/</LINK> is ok." });//with link translation
            testDataPlainText.Add(new[] { "This newline \r\n is ok.", "This newline <BR /> is ok." });//with newline translation
            testDataPlainText.Add(new[] { "1 > 4 < 5", "1 &gt; 4 &lt; 5" });//translates < and > chars
            testDataPlainText.Add(new[] { "jack & jill", "jack &amp; jill" });//translates & chars
            testDataPlainText.Add(new[] { @"I agree that Rick Stein's Soup au Pistou looked delicious, and it's a recipe I've been meaning to try for ages - every time I see the clip!  Must get round to it!  And James' tomatoes were a feast on a plate!

I thought it was interesting that Rick Stein added the courgettes at the same time as the potatoes, saying that as everything was going to be a bit overcooked anyway it didn't matter, and then later in the programme when James was making that lovely simple tomato soup, it was mentioned that people boil veg for far too long in soups and you might as well drink the veg water instead!    Dick was a brilliant guest - I've loved his eccentricity since his Scrapheap Challenge days (gosh - was that really 10 years ago <yikes>), and it was lovely to see someone so blatantly into their food.", "I agree that Rick Stein's Soup au Pistou looked delicious, and it's a recipe I've been meaning to try for ages - every time I see the clip!  Must get round to it!  And James' tomatoes were a feast on a plate!<BR /><BR />I thought it was interesting that Rick Stein added the courgettes at the same time as the potatoes, saying that as everything was going to be a bit overcooked anyway it didn't matter, and then later in the programme when James was making that lovely simple tomato soup, it was mentioned that people boil veg for far too long in soups and you might as well drink the veg water instead!    Dick was a brilliant guest - I've loved his eccentricity since his Scrapheap Challenge days (gosh - was that really 10 years ago <SMILEY TYPE='yikes' H2G2='Smiley#yikes'/>), and it was lovely to see someone so blatantly into their food." });//http://www.bbc.co.uk/dna/mbfood/NF2670471?thread=7721885&nbsp#p100078293

            

            foreach (var data in testDataPlainText)
            {
                Assert.AreEqual(data[1], ThreadPost.FormatPost(data[0], CommentStatus.Hidden.NotHidden, true));
            }

        }

        [TestMethod]
        public void FormatPost_FormatWithoutHTMLCleaningHTMLTags_ExpectFormattedWithHTMLTags()
        {
            var testText = "<b>Testing</b> bits & bobs <a href=\"http://thisisalink.com\">Dodgy link</a>\r\n is ok <ale>.";
            var expected = "&lt;b&gt;Testing&lt;/b&gt; bits &amp; bobs &lt;a href=\"http://thisisalink.com\"&gt;Dodgy link&lt;/a&gt;<BR /> is ok <SMILEY TYPE='ale' H2G2='Smiley#ale'/>.";
            var translated = ThreadPost.FormatPost(testText, CommentStatus.Hidden.NotHidden, false);
            Assert.AreEqual(expected, translated);
        }

        [TestMethod()]
        public void FormatPost_HiddenAwaitingPreModeration_ReturnsHiddenText()
        {
            var expected = "This post has been hidden.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Hidden_AwaitingPreModeration;
            string actual;


            actual = ThreadPost.FormatPost(testText, hidden, true);
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void FormatPost_HiddenAwaitingReferral_ReturnsHiddenText()
        {
            var expected = "This post has been hidden.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Hidden_AwaitingReferral;

            var actual = ThreadPost.FormatPost(testText, hidden, true);
            Assert.AreEqual(expected, actual);

        }

        [TestMethod()]
        public void FormatPost_RemovedEditorComplaintTakedown_ReturnsRemovedText()
        {
            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_EditorComplaintTakedown;

            var actual = ThreadPost.FormatPost(testText, hidden, true);
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void FormatPost_RemovedEditorFailedModeration_ReturnsRemovedText()
        {
            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_FailedModeration;

            var actual = ThreadPost.FormatPost(testText, hidden, true);
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void FormatPost_RemovedForumRemoved_ReturnsRemovedText()
        {

            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_ForumRemoved;

            var actual = ThreadPost.FormatPost(testText, hidden, true);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void FormatPost_RemovedUserDeleted_ReturnsRemovedText()
        {
            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_UserDeleted;

            var actual = ThreadPost.FormatPost(testText, hidden, true);
            Assert.AreEqual(expected, actual);

        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_DefaultStatus_ReturnsOriginalSubject()
        {
            Assert.AreEqual("some subject", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.NotHidden));
            
        }


        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_HiddenAwaitingPreModeration_ReturnsHiddenSubject()
        {
            Assert.AreEqual("Hidden", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Hidden_AwaitingPreModeration));

        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_HiddenAwaitingReferral_ReturnsHiddenSubject()
        {
            Assert.AreEqual("Hidden", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Hidden_AwaitingReferral));

        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_RemovedEditorComplaintTakedown_ReturnsRemovedSubject()
        {
            Assert.AreEqual("Removed", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Removed_EditorComplaintTakedown));
        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_RemovedFailedModeration_ReturnsRemovedSubject()
        {
            Assert.AreEqual("Removed", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Removed_FailedModeration));
        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_RemovedForumRemoved_ReturnsRemovedSubject()
        {
            Assert.AreEqual("Removed", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Removed_ForumRemoved));

        }

        /// <summary>
        ///A test for subject
        ///</summary>
        [TestMethod()]
        public void FormatSubject_RemovedUserDeleted_ReturnsRemovedSubject()
        {
            Assert.AreEqual("Removed", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Removed_UserDeleted));
        }

        [TestMethod()]
        public void FormatSubject_RemovedUserContent_ReturnsRemovedSubject()
        {
            Assert.AreEqual("Removed", ThreadPost.FormatSubject("some subject", CommentStatus.Hidden.Removed_UserContentRemoved));
        }

        

        public static ThreadPost CreateThreadPost()
        {
            return new ThreadPost()
            {
                DatePosted = new DateElement(DateTime.Now),
                Hidden = 0,
                Index = 0,
                InReplyTo = 0,
                LastUpdated = new DateElement(DateTime.Now),
                Style = PostStyle.Style.plaintext,
                FirstChild = 0,
                PrevSibling = 0,
                Subject = "temp",
                NextIndex = 0,
                NextSibling = 0,
                PostId = 0,
                PrevIndex = 0,
                Text = "test text",
                Editable = 0,
                User = UserTest.CreateTestUser()
            };
            
        }


        /// <summary>
        ///A test for CreateThreadPostFromDatabase
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromDatabase_ValidDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist("threadid")).Return(true);
            reader.Stub(x => x.DoesFieldExist("hidden")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return((int)CommentStatus.Hidden.Removed_EditorComplaintTakedown);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(1);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(1);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getpostsinthread")).Return(reader);
            mocks.ReplayAll();


            ThreadPost actual;
            actual = ThreadPost.CreateThreadPostFromDatabase(creator, 1);
            Assert.AreEqual(actual.ThreadId, 1);
            Assert.AreEqual(actual.Hidden, (byte)CommentStatus.Hidden.Removed_EditorComplaintTakedown);
        }


        [TestMethod()]
        public void CreateThreadPostFromDatabaseTest_EmptyDataSet_ReturnsException()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(false);
            reader.Stub(x => x.Read()).Return(false);
            IDnaDataReaderCreator creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader("getpostsinthread")).Return(reader);
            mocks.ReplayAll();

            try
            {
                ThreadPost.CreateThreadPostFromDatabase(creator, 1);
            }
            catch(Exception e) 
            {
                Assert.AreEqual(e.Message, "Thread post not found.");
            }

            
        }

        /// <summary>
        ///A test for CreateThreadPostFromReader
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromReader_ValidDataSet_ReturnsValidObject()
        {
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist("")).Return(true).Constraints(Is.Anything());
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(1);
            reader.Stub(x => x.GetInt32NullAsZero("hidden")).Return(1);
            

            mocks.ReplayAll();

            ThreadPost actual;
            actual = ThreadPost.CreateThreadPostFromReader(reader, 0);
            Assert.AreEqual(actual.ThreadId, 1);
        }

        /// <summary>
        ///A test for CreateThreadPostFromReader
        ///</summary>
        [TestMethod()]
        public void CreateThreadPostFromReader_WithPrefix_ReturnsValidObject()
        {
            string prefix = "prefix";
            MockRepository mocks = new MockRepository();
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist("")).Return(true).Constraints(Is.Anything());
            reader.Stub(x => x.GetInt32NullAsZero(prefix + "threadid")).Return(1);
            reader.Stub(x => x.GetStringNullAsEmpty(prefix + "text")).Return("some text");

            mocks.ReplayAll();

            ThreadPost actual;
            actual = ThreadPost.CreateThreadPostFromReader(reader, prefix, 0);
            Assert.AreEqual(actual.ThreadId, 1);
        }

        /// <summary>
        ///A test for TextElement
        ///</summary>
        [TestMethod()]
        public void TextElement_PlainText_ReturnsValidXml()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = "This is the default comment.";
            XmlElement actual;
            target.Text = expected;
            actual = target.TextElement;
            Assert.AreEqual(expected, actual.InnerXml);
        }

        /// <summary>
        ///A test for TextElement
        ///</summary>
        [TestMethod()]
        public void TextElement_RichText_ReturnsValidXml()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.richtext;
            string expected = "This is the default comment.";
            XmlElement actual;
            target.Text = expected;
            actual = target.TextElement;
            Assert.AreEqual(expected, actual.InnerXml);
        }

        /// <summary>
        ///A test for TextElement
        ///</summary>
        [TestMethod()]
        public void TextElement_InvalidXml_ReturnsEscapedXml()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.richtext;
            string expected = "This is the default &lt;notcomplete&gt; comment.";
            XmlElement actual;
            target.Text = "This is the default <notcomplete> comment.";
            actual = target.TextElement;
            Assert.AreEqual(expected, actual.InnerXml);
        }

        /// <summary>
        ///A test for TextElement
        ///</summary>
        [TestMethod()]
        public void TextElement_PlainTextWithNewLine_ReturnsValidXml()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.plaintext;
            string expected = @"This is the <BR />default comment.";
            XmlElement actual;
            target.Text = ThreadPost.FormatPost(@"This is the 
default comment.", CommentStatus.Hidden.NotHidden, true);
            actual = target.TextElement;
            Assert.AreEqual(expected, actual.InnerXml);
        }


        /// <summary>
        ///A test for TextElement
        ///</summary>
        [TestMethod()]
        public void TextElement_RichTextWithTags_ReturnsWithWithoutTags()
        {
            ThreadPost target = new ThreadPost();
            target.Style = PostStyle.Style.richtext;
            string expected = @"This is the default comment.";
            XmlElement actual;
            target.Text = ThreadPost.FormatPost("This is the <B>default</B> comment.", CommentStatus.Hidden.NotHidden, true);
            actual = target.TextElement;
            Assert.AreEqual(expected, actual.InnerXml);
        }


        /// <summary>
        ///A test for Hidden
        ///</summary>
        [TestMethod()]
        public void Hidden_SetValue_ReturnsCorrectGet()
        {
            ThreadPost target = new ThreadPost(); 
            byte expected = (byte)CommentStatus.Hidden.NotHidden;
            byte actual;
            target.Hidden = expected;
            actual = target.Hidden;
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for ThreadIdSpecified
        ///</summary>
        [TestMethod()]
        public void ThreadIdSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost(); 
            bool actual;
            actual = target.ThreadIdSpecified;
            Assert.AreEqual(false, actual);
        }

        /// <summary>
        ///A test for ThreadIdSpecified
        ///</summary>
        [TestMethod()]
        public void ThreadIdSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost(); 
            bool actual;
            target.ThreadId = 1;
            actual = target.ThreadIdSpecified;
            Assert.AreEqual(true, actual);
        }

        /// <summary>
        ///A test for PrevSiblingSpecified
        ///</summary>
        [TestMethod()]
        public void PrevSiblingSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost();
            Assert.IsFalse(target.PrevSiblingSpecified);
        }

        /// <summary>
        ///A test for PrevSiblingSpecified
        ///</summary>
        [TestMethod()]
        public void PrevSiblingSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost();
            target.PrevSibling = 1;
            Assert.IsTrue(target.PrevSiblingSpecified);
        }

        /// <summary>
        ///A test for PrevIndexSpecified
        ///</summary>
        [TestMethod()]
        public void PrevIndexSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost(); 
            Assert.IsFalse(target.PrevIndexSpecified);
        }

        /// <summary>
        ///A test for PrevIndexSpecified
        ///</summary>
        [TestMethod()]
        public void PrevIndexSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost();
            target.PrevIndex = 1;
            Assert.IsTrue(target.PrevIndexSpecified);
        }

        /// <summary>
        ///A test for NextSiblingSpecified
        ///</summary>
        [TestMethod()]
        public void NextSiblingSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost(); 
            Assert.IsFalse(target.NextSiblingSpecified);
        }

        /// <summary>
        ///A test for NextSiblingSpecified
        ///</summary>
        [TestMethod()]
        public void NextSiblingSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost();
            target.NextSibling = 1;
            Assert.IsTrue(target.NextSiblingSpecified);
        }

        /// <summary>
        ///A test for NextIndexSpecified
        ///</summary>
        [TestMethod()]
        public void NextIndexSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost(); 
            Assert.IsFalse(target.NextIndexSpecified);
        }

        /// <summary>
        ///A test for NextIndexSpecified
        ///</summary>
        [TestMethod()]
        public void NextIndexSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost();
            target.NextIndex = 1;
            Assert.IsTrue(target.NextIndexSpecified);
        }

        /// <summary>
        ///A test for InReplyToSpecified
        ///</summary>
        [TestMethod()]
        public void InReplyToSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost(); 
            Assert.IsFalse(target.InReplyToSpecified);
        }

        /// <summary>
        ///A test for InReplyToSpecified
        ///</summary>
        [TestMethod()]
        public void InReplyToSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost();
            target.InReplyTo = 1;
            Assert.IsTrue(target.InReplyToSpecified);
        }

        /// <summary>
        ///A test for FirstChildSpecified
        ///</summary>
        [TestMethod()]
        public void FirstChildSpecified_NothingSet_ReturnsFalse()
        {
            ThreadPost target = new ThreadPost(); 
            Assert.IsFalse(target.FirstChildSpecified);
        }

        /// <summary>
        ///A test for FirstChildSpecified
        ///</summary>
        [TestMethod()]
        public void FirstChildSpecified_SomethingSet_ReturnsTrue()
        {
            ThreadPost target = new ThreadPost();
            target.FirstChild = 1;
            Assert.IsTrue(target.FirstChildSpecified);
        }
    }
}
