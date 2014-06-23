using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;

namespace BBC.Dna.Api.Tests
{
    /// <summary>
    ///This is a test class for CommentInfoTest and is intended
    ///to contain all CommentInfoTest Unit Tests
    ///</summary>
    [TestClass]
    public class ContextTest
    {
        public ContextTest()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;
        private MockRepository mocks = new MockRepository();

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
      
        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithoutUid_ThrowsError()
        {
            var commentForum = new Forum{Id = ""};
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);

           
            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);
            

            try
            {
                context.CreateForum(commentForum, site);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual("Forum uid is empty, null or exceeds 255 characters.", ex.Message);
                Assert.AreEqual(ErrorType.InvalidForumUid, ex.type);               
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithoutUid_ThrowsError()
        {
            var commentForum = new Forum { Id = "" };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, site, null);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual("Forum uid is empty, null or exceeds 255 characters.", ex.Message);
                Assert.AreEqual(ErrorType.InvalidForumUid, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        [TestMethod]
        public void ShouldReplaceInvalidCharsFromCacheFileNameWithDash()
        {
            Statistics stats = new Statistics();
            Statistics.InitialiseIfEmpty(null,false);

            Context_Accessor testContext = new Context_Accessor(null, null, null, null);

            string originalFileName = "Dodgy/Name<for>a#file.txt";
            string expectedFileName = "Dodgy-Name-for-a#file.txt";

            testContext.FileCacheFolder = TestContext.TestDir;
            testContext.SetFailedEmailFileName(originalFileName);
            testContext.WriteFailedEmailToFile("me@bbc.co.uk", "you@bbc.co.uk", "test subject", "test body", "");

            DateTime expires = new DateTime();
            string failedEmailContent = "";
            FileCaching.GetItem(null, TestContext.TestDir, "failedmails", expectedFileName, ref expires, ref failedEmailContent);

            Assert.IsTrue(failedEmailContent.Length > 0);
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithTooLargeUid_ThrowsError()
        {
            var commentForum = new Forum { Id = "".PadRight(300, 'a') };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.CreateForum(commentForum, site);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual("Forum uid is empty, null or exceeds 255 characters.", ex.Message);
                Assert.AreEqual(ErrorType.InvalidForumUid, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithTooLargeUid_ThrowsError()
        {
            var commentForum = new Forum { Id = "".PadRight(300, 'a') };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, site, true);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual("Forum uid is empty, null or exceeds 255 characters.", ex.Message);
                Assert.AreEqual(ErrorType.InvalidForumUid, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithoutParentUri_ThrowsError()
        {
            var commentForum = new Forum { Id = "".PadRight(10, 'a'),
                ParentUri = ""
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.CreateForum(commentForum, site);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidForumParentUri, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithoutParentUri_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = ""
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, site, false);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidForumParentUri, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithNonBBCParentUri_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://someurl.com"
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.CreateForum(commentForum, site);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidForumParentUri, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithNonBBCParentUri_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://someurl.com"
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, site, null);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidForumParentUri, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithoutTitle_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = ""
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.CreateForum(commentForum, site);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidForumTitle, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithoutTitle_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = ""
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, site, true);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.InvalidForumTitle, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithoutSite_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title"
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.CreateForum(commentForum, null);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.UnknownSite, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithoutSite_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title"
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            //readerCreator.Stub(x => x.CreateDnaDataReader("getmoderationclasslist")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, null, true);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.UnknownSite, ex.type);
            }
            readerCreator.AssertWasNotCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithModerationStatus_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);

            context.CreateForum(commentForum, site);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        /// Test that forum can be created with bbc.com parent URL
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithDotComParentURL_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.com/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);

            context.CreateForum(commentForum, site);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        /// Test that forum can be created with bbc.co.uk parent URL
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithDotCoDotUKParentURL_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);

            context.CreateForum(commentForum, site);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithModerationStatus_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumupdate")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);

            context.UpdateForum(commentForum, site, null);
            Assert.IsNotNull(context.DnaDiagnostics);
            Assert.IsNotNull(context.DnaDataReaderCreator);
            Assert.IsNotNull(context.CacheManager);
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }


        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_WithDuration_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod,
                CloseDate = DateTime.Now.AddDays(2)
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);

            context.CreateForum(commentForum, site);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_WithDuration_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod,
                CloseDate = DateTime.Now.AddDays(2)
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumupdate")).Return(reader);


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);

            context.UpdateForum(commentForum, site, null);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumCreate_DBError_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod,
                CloseDate = DateTime.Now.AddDays(2)
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(reader);
            reader.Stub(x => x.Execute()).Throw(new Exception("DB ERROR"));


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.CreateForum(commentForum, site);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.Unknown, ex.type);
            }
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
        }

        /// <summary>
        ///A test for CommentInfo Constructor
        ///</summary>
        [TestMethod]
        public void ForumUpdate_DBError_ThrowsError()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod,
                CloseDate = DateTime.Now.AddDays(2)
            };
            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var site = mocks.DynamicMock<ISite>();
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumupdate")).Return(reader);
            reader.Stub(x => x.Execute()).Throw(new Exception("DB ERROR"));


            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, null);


            try
            {
                context.UpdateForum(commentForum, site, null);
                throw new Exception("Error not thrown within code");
            }
            catch (ApiException ex)
            {
                Assert.AreEqual(ErrorType.Unknown, ex.type);
            }
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumupdate"));
        }


        [TestMethod]
        public void ForumCreate_WithWithNotSignedIn_ReturnsOK()
        {
            var commentForum = new Forum
            {
                Id = "".PadRight(10, 'a'),
                ParentUri = "http://www.bbc.co.uk/dna",
                Title = "title",
                allowNotSignedInCommenting = true
            };
            var siteId = 1;
            var forumId = 10;

            var readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            var reader = mocks.DynamicMock<IDnaDataReader>();
            var site = mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            var cacheManager = mocks.DynamicMock<ICacheManager>();
            var siteList = mocks.DynamicMock<ISiteList>();
            siteList.Stub(x => x.GetSiteOptionValueBool(siteId, "CommentForum", "AllowNotSignedInCommenting")).Return(true);
            readerCreator.Stub(x => x.CreateDnaDataReader("commentforumcreate")).Return(reader);
            readerCreator.Stub(x => x.CreateDnaDataReader("createnewuserforforum")).Return(reader);
            
            reader.Stub(x => x.Read()).Return(true);
            reader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(forumId);

            mocks.ReplayAll();

            var context = new Context(null, readerCreator, cacheManager, siteList);

            context.CreateForum(commentForum, site);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("commentforumcreate"));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("createnewuserforforum"));
        }
    }
}