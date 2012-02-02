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
using BBC.Dna.Common;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;
using BBC.Dna.Api;
using BBC.Dna.Moderation.Utils.Tests;


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

            ProfanityFilterTests.InitialiseProfanities();
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
                Assert.AreEqual(data[1], ThreadPost.FormatPost(data[0], CommentStatus.Hidden.NotHidden, true, false));
            }

        }

        [TestMethod]
        public void FormatPost_FormatWithoutHTMLCleaningHTMLTags_ExpectFormattedWithHTMLTags()
        {
            var testText = "<b>Testing</b> bits & bobs <a href=\"http://thisisalink.com\">Dodgy link</a>\r\n is ok <ale>.";
            var expected = "&lt;b&gt;Testing&lt;/b&gt; bits &amp; bobs &lt;a href=\"http://thisisalink.com\"&gt;Dodgy link&lt;/a&gt;<BR /> is ok <SMILEY TYPE='ale' H2G2='Smiley#ale'/>.";
            var translated = ThreadPost.FormatPost(testText, CommentStatus.Hidden.NotHidden, false, false);
            Assert.AreEqual(expected, translated);
        }

        [TestMethod()]
        public void FormatPost_HiddenAwaitingPreModeration_ReturnsHiddenText()
        {
            var expected = "This post has been hidden.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Hidden_AwaitingPreModeration;
            string actual;


            actual = ThreadPost.FormatPost(testText, hidden, true, false);
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void FormatPost_HiddenAwaitingReferral_ReturnsHiddenText()
        {
            var expected = "This post has been hidden.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Hidden_AwaitingReferral;

            var actual = ThreadPost.FormatPost(testText, hidden, true, false);
            Assert.AreEqual(expected, actual);

        }

        [TestMethod()]
        public void FormatPost_RemovedEditorComplaintTakedown_ReturnsRemovedText()
        {
            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_EditorComplaintTakedown;

            var actual = ThreadPost.FormatPost(testText, hidden, true, false);
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void FormatPost_RemovedEditorFailedModeration_ReturnsRemovedText()
        {
            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_FailedModeration;

            var actual = ThreadPost.FormatPost(testText, hidden, true, false);
            Assert.AreEqual(expected, actual);


        }

        [TestMethod()]
        public void FormatPost_RemovedForumRemoved_ReturnsRemovedText()
        {

            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_ForumRemoved;

            var actual = ThreadPost.FormatPost(testText, hidden, true, false);
            Assert.AreEqual(expected, actual);
        }

        [TestMethod()]
        public void FormatPost_RemovedUserDeleted_ReturnsRemovedText()
        {
            var expected = "This post has been removed.";
            var testText = "some text";
            var hidden = CommentStatus.Hidden.Removed_UserDeleted;

            var actual = ThreadPost.FormatPost(testText, hidden, true, false);
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
            actual = ThreadPost.CreateThreadPostFromDatabase(creator, 1, false);
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
                ThreadPost.CreateThreadPostFromDatabase(creator, 1, false);
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
            actual = ThreadPost.CreateThreadPostFromReader(reader, 0, false);
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
            actual = ThreadPost.CreateThreadPostFromReader(reader, prefix, 0, null, false);
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
default comment.", CommentStatus.Hidden.NotHidden, true, false);
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
            target.Text = ThreadPost.FormatPost("This is the <B>default</B> comment.", CommentStatus.Hidden.NotHidden, true, false);
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

        [TestMethod]
        public void PostToForum_CanReadThreadFalse_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISite site = mocks.DynamicMock<ISite>();
            IUser viewingUser = mocks.DynamicMock<IUser>();
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, false, true);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.NotAuthorized, e.type);
            }

        }

        [TestMethod]
        public void PostToForum_CanWriteThreadFalse_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISite site = mocks.DynamicMock<ISite>();
            IUser viewingUser = mocks.DynamicMock<IUser>();
            ISiteList siteList = mocks.DynamicMock<ISiteList>();

            viewingUser.Stub(x => x.UserId).Return(1);

            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.ForumReadOnly, e.type);
            }

        }

        [TestMethod]
        public void PostToForum_CanReadForumFalse_ThrowsException()
        {
            var forumId = 1;
            var threadId = 0;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISite site = mocks.DynamicMock<ISite>();
            IUser viewingUser = mocks.DynamicMock<IUser>();
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, false, true);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.NotAuthorized, e.type);
            }

        }

        [TestMethod]
        public void PostToForum_CanWriteForumFalse_ThrowsException()
        {
            var forumId = 1;
            var threadId = 0;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISite site = mocks.DynamicMock<ISite>();
            IUser viewingUser = mocks.DynamicMock<IUser>();
            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            viewingUser.Stub(x => x.UserId).Return(1);

            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException e)
            {
                Assert.AreEqual(ErrorType.ForumReadOnly, e.type);
            }

        }

        [TestMethod]
        public void PostToForum_ReturnValueNotZero_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISite site = mocks.DynamicMock<ISite>();
            IUser viewingUser = mocks.DynamicMock<IUser>();
            ISiteList siteList = mocks.DynamicMock<ISiteList>();

            viewingUser.Stub(x => x.UserId).Return(1);
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostFreq(mocks, ref readerCreator, 0);
            IDnaDataReader readerReturn = mocks.DynamicMock<IDnaDataReader>();
            readerReturn.Stub(x => x.Read()).Return(true);
            readerReturn.Stub(x => x.DoesFieldExist("errorcode")).Return(true);
            readerReturn.Stub(x => x.GetInt32NullAsZero("errorcode")).Return(547);
            readerCreator.Stub(x => x.CreateDnaDataReader("posttoforum")).Return(readerReturn);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException e)
            {
                Assert.IsTrue(e.Message.IndexOf("547") > 0);
            }

        }

        [TestMethod]
        public void PostToForum_UserIsBanned_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISite site = mocks.DynamicMock<ISite>();
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, true, false, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.UserIsBanned, e.type);
        }

        [TestMethod]
        public void PostToForum_SiteIsEmergencyClosed_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, true, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.SiteIsClosed, e.type);
        }

        [TestMethod]
        public void PostToForum_SiteIsScheduledClosed_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, true);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test post",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.SiteIsClosed, e.type);
        }

        [TestMethod]
        public void PostToForum_EmptyText_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.EmptyText, e.type);
        }

        [TestMethod]
        public void PostToForum_NotLoggedIn_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            ISiteList siteList = mocks.DynamicMock<ISiteList>();


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = mocks.DynamicMock<IUser>();
            ISite site = CreateSiteObject(mocks, false, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "test",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.NotAuthorized, e.type);
        }

        [TestMethod]
        public void PostToForum_ExceedingMaxLength_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 5, 0,false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "more than 5 chars",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.ExceededTextLimit, e.type);
        }

        [TestMethod]
        public void PostToForum_MinLengthNotMet_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 100, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "more than 5 chars",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.MinCharLimitNotReached, e.type);
        }

        [Ignore]
        public void PostToForum_InvalidHTML_NoError()
        {
            // due to the added protection and encoding ont he front end - this is no longer checked.
            //it was causing issues with double encoding and historical posts need to be maintained.
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "<div>more than 5 chars",
                Subject = "test subject",
                ThreadId = threadId,
                Style = PostStyle.Style.richtext
            };

            threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            
        }


        [TestMethod]
        public void PostToForum_WithProfanity_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains profanity (ock and ",
                Subject = "test subject",
                ThreadId = threadId
            };

           

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.ProfanityFoundInText, e.type);
        }

        [TestMethod]
        public void PostToForum_WithProfanityInSubject_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);


            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains profanity  ",
                Subject = "test subject (ock and",
                ThreadId = threadId
            };



            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.ProfanityFoundInText, e.type);
        }

        [TestMethod]
        public void PostToForum_WithProfanityInSubjectOfReply_NoError()
        {// subject is not checked on subsequent replies
            var forumId = 1;
            var threadId = 1;
            var postId = 10;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            CreatePostFreq(mocks, ref readerCreator, 0);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains profanity  ",
                Subject = "test subject (ock and",
                ThreadId = threadId,
                InReplyTo = 1
            };



            threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            
        }


        [TestMethod]
        public void PostToForum_EverythingOk_ReturnsCorrectPostId()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            CreatePostFreq(mocks, ref readerCreator, 0);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "contains txt",
                Subject = "test subject",
                ThreadId = threadId
            };


            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);
        }

        [TestMethod]
        public void PostToForum_ProcessPreMod_ReturnsIsPreModPosting()
        {
            var forumId = 1;
            var postId = 0;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, true);
            CreatePostFreq(mocks, ref readerCreator, 0);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();
            //(ICacheManager cacheManager, IDnaDataReaderCreator readerCreator, ISite site, 
            //IUser viewingUser, ISiteList siteList, string _iPAddress, Guid bbcUidCookie, int forumId)

            var threadPost = new ThreadPost()
            {
                Text = "contains txt",
                Subject = "test subject",
                ThreadId = threadId
            };


            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);
            Assert.IsTrue(threadPost.IsPreModPosting);
        }

        [TestMethod]
        public void PostToForum_ReferredTerm_ReturnsForceModeration()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            CreatePostFreq(mocks, ref readerCreator, 0);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains referred term Bomb txt",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("forcemoderate", true));
            reader.AssertWasCalled(x => x.AddParameter("modnotes","Filtered terms: bomb"));
        }

        [TestMethod]
        public void PostToForum_SiteClosedAsSuperUser_ReturnsPost()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            var viewingUser = CreateUserObject(mocks, false, false, true);
            ISite site = CreateSiteObject(mocks, true, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();

            var threadPost = new ThreadPost()
            {
                Text = "contains referred term txt",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("ignoremoderation", true));

        }

        [TestMethod]
        public void PostToForum_SiteClosedAsEditor_ReturnsPost()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            var viewingUser = CreateUserObject(mocks, false, true, false);
            ISite site = CreateSiteObject(mocks, true, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains referred term txt",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("ignoremoderation", true));
        }

        [TestMethod]
        public void PostToForum_PreModerateNewDiscussions_ReturnsPreModeratedPost()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            CreatePostFreq(mocks, ref readerCreator, 0);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, true);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains referred term txt",
                Subject = "test subject",
                ThreadId = threadId
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("forcepremoderation", true));

        }

        [TestMethod]
        public void PostToForum_PreModerateNewDiscussionsWithReplyTo_ReturnsUnModeratedPost()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            CreatePostFreq(mocks, ref readerCreator, 0);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, true);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains referred term txt",
                Subject = "test subject",
                ThreadId = threadId,
                InReplyTo = 1
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("forcepremoderation", false));

        }

        [TestMethod]
        public void PostToForum_PreModerateNewDiscussionsAsNotable_ReturnsUnModeratedPost()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            viewingUser.Stub(x => x.IsNotable).Return(true);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, true);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains referred term txt",
                Subject = "test subject",
                ThreadId = threadId,
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("forcepremoderation", false));

        }

        [TestMethod]
        public void PostToForum_PreModerateNewDiscussionsAsEditor_ReturnsUnModeratedPost()
        {
            var forumId = 1;
            var postId = 10;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);
            var viewingUser = CreateUserObject(mocks, false, true, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, true);
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains referred term txt",
                Subject = "test subject",
                ThreadId = threadId,
            };

            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");
            reader.AssertWasCalled(x => x.AddParameter("forcepremoderation", false));

        }

        [TestMethod]
        public void PostToForum_WithinPostFreq_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostFreq(mocks, ref readerCreator, 20);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains text ",
                Subject = "test subject",
                ThreadId = threadId
            };



            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.AreEqual(ErrorType.PostFrequencyTimePeriodNotExpired, e.type);

        }

        [TestMethod]
        public void PostToForum_WithinPostFreqAsSuperUser_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();
            var postId = 10;

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostFreq(mocks, ref readerCreator, 20);
            var viewingUser = CreateUserObject(mocks, false, false, true);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains text ",
                Subject = "test subject",
                ThreadId = threadId
            };



            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");

        }

        [TestMethod]
        public void PostToForum_WithinPostFreqAsEditorUser_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();
            var postId = 10;

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostFreq(mocks, ref readerCreator, 20);
            var viewingUser = CreateUserObject(mocks, false, true, false);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains text ",
                Subject = "test subject",
                ThreadId = threadId
            };



            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");

        }

        [TestMethod]
        public void PostToForum_WithinPostFreqAsNotableUser_ThrowsException()
        {
            var forumId = 1;
            var threadId = 1;
            var ipAddress = "1.1.1.1";
            var bbcUid = Guid.NewGuid();
            var postId = 10;

            MockRepository mocks = new MockRepository();
            ICacheManager cacheManager = CreateCacheObject(mocks, ForumSourceType.Article);
            IDnaDataReaderCreator readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            CreateThreadPermissionObjects(mocks, ref readerCreator, true, true);
            CreateForumPermissionObjects(mocks, ref readerCreator, true, true);
            CreatePostFreq(mocks, ref readerCreator, 20);
            var viewingUser = CreateUserObject(mocks, false, false, false);
            viewingUser.Stub(x => x.IsNotable).Return(true);
            ISite site = CreateSiteObject(mocks, false, false);
            ISiteList siteList = CreateSiteList(mocks, 1, 0, 0, false);
            CreatePostToForumObjects(mocks, ref readerCreator, postId, threadId, false);

            mocks.ReplayAll();



            var threadPost = new ThreadPost()
            {
                Text = "contains text ",
                Subject = "test subject",
                ThreadId = threadId
            };



            ApiException e = null;
            try
            {
                threadPost.PostToForum(cacheManager, readerCreator, site, viewingUser, siteList, ipAddress, bbcUid, forumId);
            }
            catch (ApiException err)
            {
                e = err;
            }
            Assert.IsNull(e);

            Assert.AreEqual(postId, threadPost.PostId);
            Assert.AreEqual(threadId, threadPost.ThreadId);

            var reader = readerCreator.CreateDnaDataReader("posttoforum");

        }
        
        private static void CreateThreadPermissionObjects(MockRepository mocks, ref IDnaDataReaderCreator readerCreator, bool canRead, bool canWrite)
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetBoolean("CanRead")).Return(canRead);
            reader.Stub(x => x.GetBoolean("CanWrite")).Return(canWrite);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("getthreadpermissions")).Return(reader);
        }

        private static void CreateForumPermissionObjects(MockRepository mocks, ref IDnaDataReaderCreator readerCreator, bool canRead, bool canWrite)
        {
            int canReadOut = 0;
            int canWriteOut = 0;
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.TryGetIntOutputParameter("CanRead", out canReadOut)).Return(true).OutRef(canRead?1:0);
            reader.Stub(x => x.TryGetIntOutputParameter("CanWrite", out canWriteOut)).Return(true).OutRef(canWrite?1:0);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("getforumpermissions")).Return(reader);
           
        }

        private static void CreatePostToForumObjects(MockRepository mocks, ref IDnaDataReaderCreator readerCreator, int postId, int threadId, bool isPreModerated)
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.DoesFieldExist("postid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("postid")).Return(postId);
            reader.Stub(x => x.DoesFieldExist("threadid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(threadId);
            reader.Stub(x => x.DoesFieldExist("premodpostingmodid")).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("premodpostingmodid")).Return(isPreModerated ? 1 : 0);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("posttoforum")).Return(reader);
        }

        private static void CreatePostFreq(MockRepository mocks, ref IDnaDataReaderCreator readerCreator, int seconds )
        {
            IDnaDataReader reader = mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.GetIntOutputParameter("seconds")).Return(seconds);
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("checkuserpostfreq")).Return(reader);
        }


        private static IUser CreateUserObject(MockRepository mocks, bool isBanned, bool isEditor, bool isSuper)
        {
            IUser viewingUser = mocks.DynamicMock<IUser>();
            viewingUser.Stub(x => x.IsSuperUser).Return(isSuper);
            viewingUser.Stub(x => x.IsEditor).Return(isEditor);
            viewingUser.Stub(x => x.IsBanned).Return(isBanned);
            viewingUser.Stub(x => x.UserId).Return(1);

            return viewingUser;
        }

        private static ISite CreateSiteObject(MockRepository mocks, bool IsEmergencyClosed, bool IsSiteScheduledClosed)
        {
            ISite site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.IsEmergencyClosed).Return(IsEmergencyClosed);
            site.Stub(x => x.IsSiteScheduledClosed(DateTime.Now)).Constraints(Is.Anything()).Return(IsSiteScheduledClosed);
            site.Stub(x => x.SiteID).Return(1);
            site.Stub(x => x.ModClassID).Return(3);

            return site;
        }

        private static ISiteList CreateSiteList(MockRepository mocks, int siteId, int maxLength, int minLength, bool PreModerateNewDiscussions)
        {
            ISiteList siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MaxCommentCharacterLength")).Return(maxLength);
            siteList.Stub(x => x.GetSiteOptionValueInt(siteId, "CommentForum", "MinCommentCharacterLength")).Return(minLength);
            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "Moderation", "PreModerateNewDiscussions")).Return(PreModerateNewDiscussions);
            return siteList;
        }

        private static ICacheManager CreateCacheObject(MockRepository mocks, ForumSourceType type)
        {

            var forumSource = ForumSourceTest.CreateTestForumSource();
            forumSource.Type = type;
            
            var cacheManager  = mocks.DynamicMock<ICacheManager>();
            cacheManager.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(forumSource);

            return cacheManager;
        }
    }
}
