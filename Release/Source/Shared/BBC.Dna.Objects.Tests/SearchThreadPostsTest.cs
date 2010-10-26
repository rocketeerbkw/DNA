using System;
using System.Collections.Generic;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using BBC.Dna.Objects;
using BBC.Dna.Common;
using BBC.Dna.Api;
using TestUtils;

namespace BBC.Dna.Objects.Tests
{
    
    
    /// <summary>
    ///This is a test class for SearchThreadPostsTest and is intended
    ///to contain all SearchThreadPostsTest Unit Tests
    ///</summary>
    [TestClass()]
    public class SearchThreadPostsTest
    {
        public MockRepository Mocks = new MockRepository();

        [TestMethod()]
        public void IsUpToDate_DateWithinHour_ReturnsTrue()
        {
            var target = new SearchThreadPosts() { LastUpdated = DateTime.Now.AddMinutes(-1) };
            Assert.IsTrue(target.IsUpToDate(null));

        }

        [TestMethod()]
        public void IsUpToDate_DateOutSideHour_ReturnsFalse()
        {
            var target = new SearchThreadPosts() { LastUpdated = DateTime.Now.AddHours(-2) };
            Assert.IsFalse(target.IsUpToDate(null));

        }

        [TestMethod()]
        public void GetSearchThreadPosts_ValidObjectInCache_ReturnsObject()
        {
            var forumId = 1;
            var threadId = 1;
            var siteId = 1;
            var searchText = "search me";
            var lastUpdated = DateTime.MaxValue;
            var searchThreadPosts = GetListOfSearchPosts(siteId, forumId, threadId, searchText, 0, lastUpdated);
            
            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();

            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(searchThreadPosts);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            Mocks.ReplayAll();

            
            var actual = SearchThreadPosts.GetSearchThreadPosts(readerCreator, cache, site, forumId, threadId, 0, 0, searchText, false);
            Assert.AreEqual(searchThreadPosts.ForumId, actual.ForumId);
            Assert.AreEqual(searchThreadPosts.SearchTerm, actual.SearchTerm);
            Assert.AreEqual(searchThreadPosts.SiteId, actual.SiteId);
            
        }

        [TestMethod()]
        public void GetSearchThreadPosts_ExpiredObjectInCache_ReturnsDBObject()
        {
            var forumId = 1;
            var threadId = 1;
            var siteId = 1;
            var searchText = "search me";
            var lastUpdated = DateTime.MinValue;
            var siteName = "h2g2";
            var spName = "searchthreadentriesfast";


            var searchThreadPosts = GetListOfSearchPosts(siteId, forumId, threadId, searchText, 5, lastUpdated);
            var readerCreator = CreateMockCreator(searchThreadPosts, spName);
            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(searchThreadPosts);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.SiteName).Return(siteName);
            Mocks.ReplayAll();


            var actual = SearchThreadPosts.GetSearchThreadPosts(readerCreator, cache, site, forumId, threadId, 0, 0, searchText, false);
            Assert.AreEqual(searchThreadPosts.ForumId, actual.ForumId);
            Assert.AreEqual(searchThreadPosts.SearchTerm, actual.SearchTerm);
            Assert.AreEqual(searchThreadPosts.SiteId, actual.SiteId);
            Assert.AreEqual(searchThreadPosts.TotalPostCount, actual.Posts.Count);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader(spName));

        }

        [TestMethod()]
        public void GetSearchThreadPosts_NoObjectInCache_ReturnsDBObject()
        {
            var forumId = 1;
            var threadId = 1;
            var siteId = 1;
            var searchText = "search me";
            var lastUpdated = DateTime.MinValue;
            var siteName = "h2g2";
            var spName ="searchthreadentriesfast";


            var searchThreadPosts = GetListOfSearchPosts(siteId, forumId, threadId, searchText, 5, lastUpdated);
            var readerCreator = CreateMockCreator(searchThreadPosts, spName);
            var cache = Mocks.DynamicMock<ICacheManager>();
            cache.Stub(x => x.GetData("")).Constraints(Is.Anything()).Return(null);
            cache.Stub(x => x.Add("", null)).Constraints(Is.Anything(), Is.Anything()).Repeat.Once();

            var site = Mocks.DynamicMock<ISite>();
            site.Stub(x => x.SiteID).Return(siteId);
            site.Stub(x => x.SiteName).Return(siteName);
            Mocks.ReplayAll();


            var actual = SearchThreadPosts.GetSearchThreadPosts(readerCreator, cache, site, forumId, threadId, 2000, 0, searchText, false);
            Assert.AreEqual(searchThreadPosts.ForumId, actual.ForumId);
            Assert.AreEqual(searchThreadPosts.SearchTerm, actual.SearchTerm);
            Assert.AreEqual(searchThreadPosts.SiteId, actual.SiteId);
            Assert.AreEqual(searchThreadPosts.TotalPostCount, actual.Posts.Count);

            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader(spName));

        }

        [TestMethod()]
        public void FormatSearchTerm_ValidTerms_FormatsCorrectString()
        {
            var searchTerms = new string[] { "term1", "term2" };
            var expected = "term1&term2";

            Assert.AreEqual(expected, SearchThreadPosts.FormatSearchTerm(ref searchTerms));
        }

        [TestMethod()]
        public void FormatSearchTerm_ValidTermsWithBadChars_FormatsCorrectString()
        {
            var temp = new string[] { "te!rm1", "t!erm2" };
            Assert.AreEqual("term1&term2", SearchThreadPosts.FormatSearchTerm(ref temp));
            Assert.AreEqual("term1", temp[0]);
            Assert.AreEqual("term2", temp[1]);

            temp = new string[] { "term1&", "&term2" };
            Assert.AreEqual("term1&term2", SearchThreadPosts.FormatSearchTerm(ref temp));
            Assert.AreEqual("term1", temp[0]);
            Assert.AreEqual("term2", temp[1]);
            
            temp = new string[] { "\"term1\"", "term2" };
            Assert.AreEqual("term1&term2", SearchThreadPosts.FormatSearchTerm(ref temp));
            Assert.AreEqual("term1", temp[0]);
            Assert.AreEqual("term2", temp[1]);

            temp = new string[] { "\"term1\"", "term2" };
            Assert.AreEqual("term1&term2", SearchThreadPosts.FormatSearchTerm(ref temp));
            Assert.AreEqual("term1", temp[0]);
            Assert.AreEqual("term2", temp[1]);

            temp = new string[] { "term1", "the" };
            Assert.AreEqual("term1", SearchThreadPosts.FormatSearchTerm(ref temp));
            Assert.AreEqual("term1", temp[0]);
            Assert.AreEqual(1, temp.Length);


        }



        private SearchThreadPosts GetListOfSearchPosts(int siteId, int forumId, int threadId, string textToSearch, int count, DateTime lastUpdated)
        {
            var searchThreadPosts = new SearchThreadPosts()
            {
                TotalPostCount = count,
                LastUpdated = lastUpdated,
                ForumId = forumId,
                ThreadId = threadId,
                SearchTerm = textToSearch,
                SiteId = siteId
            };
            for (int i = 0; i < count; i++)
            {
                var searchThreadPost = new SearchThreadPost()
                {
                    ForumId = forumId,
                    ThreadId = threadId,
                };
                var rand = new Random(DateTime.Now.Millisecond);

                searchThreadPost.PostId = rand.Next(Int32.MaxValue);
                searchThreadPost.Rank= rand.Next(Int32.MaxValue);
                searchThreadPost.Text = RandomStringGenerator.NextString(5) + textToSearch + RandomStringGenerator.NextString(5);
                searchThreadPosts.Posts.Add(searchThreadPost);
            }
            return searchThreadPosts;
        
        }

        private IDnaDataReaderCreator CreateMockCreator(SearchThreadPosts searchThreadPosts, string spName)
        {
            Queue<int> postIdQueue = new Queue<int>();
            Queue<int> rankQueue = new Queue<int>();
            Queue<string> textQueue = new Queue<string>();

            foreach (var post in searchThreadPosts.Posts)
            {
                postIdQueue.Enqueue(post.PostId);
                rankQueue.Enqueue(post.Rank);
                textQueue.Enqueue(post.Text);
            }

            
            var reader = Mocks.DynamicMock<IDnaDataReader>();
            reader.Stub(x => x.HasRows).Return(true);
            reader.Stub(x => x.Read()).Return(true).Repeat.Times(searchThreadPosts.Posts.Count);
            reader.Stub(x => x.GetInt32NullAsZero("totalresults")).Return(searchThreadPosts.TotalPostCount);
            reader.Stub(x => x.GetInt32NullAsZero("EntryID")).Return(0).WhenCalled(x => x.ReturnValue = postIdQueue.Dequeue());
            reader.Stub(x => x.GetInt32NullAsZero("forumid")).Return(searchThreadPosts.ForumId);
            reader.Stub(x => x.GetInt32NullAsZero("threadid")).Return(searchThreadPosts.ThreadId);
            reader.Stub(x => x.GetInt32NullAsZero("rank")).Return(0).WhenCalled(x => x.ReturnValue =rankQueue.Dequeue());
            reader.Stub(x => x.GetStringNullAsEmpty("text")).Return("").WhenCalled(x => x.ReturnValue = textQueue.Dequeue());
            reader.Stub(x => x.DoesFieldExist("forumid")).Return(true);
            reader.Stub(x => x.DoesFieldExist("EntryID")).Return(true);
            reader.Stub(x => x.DoesFieldExist("threadid")).Return(true);
            reader.Stub(x => x.DoesFieldExist("rank")).Return(true);
            reader.Stub(x => x.DoesFieldExist("text")).Return(true);

            var readerCreator = Mocks.DynamicMock<IDnaDataReaderCreator>();
            readerCreator.Stub(x => x.CreateDnaDataReader(spName)).Return(reader);

            return readerCreator;

        }
    }
}
