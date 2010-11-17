using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Objects;
using BBC.Dna.Utils;
using Tests;
using Rhino.Mocks;
using BBC.Dna.Data;
using Rhino.Mocks.Constraints;
using System.Xml;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;
using BBC.Dna.Api;
using BBC.Dna.Common;

namespace BBC.Dna.Objects.Tests
{
    /// <summary>
    /// Summary description for HierarchyDetailsTest
    /// </summary>
    [TestClass]
    public class CategoryTest
    {
        private readonly int _test_h2g2id = 100;
        private readonly int _test_nodeID = 99;
        private readonly string _test_categoryCacheKey = "BBC.Dna.Objects.Category, BBC.Dna.Objects, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887|99|";
        private readonly int _test_ParentID_NonRoot = 44;
        private readonly int _test_ParentID_Root = 0;
        private readonly DateTime _test_lastUpdated = DateTime.Now;

        /// <summary>
        /// Helper function to set up parameters for CreateCategory call
        /// </summary>
        /// <param name="mocks"></param>
        /// <param name="cache"></param>
        /// <param name="article"></param>
        /// <param name="article_h2g2id"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        public void CreateCategory_SetupDefaultMocks(out MockRepository mocks, out ICacheManager cache, out Article article, int article_h2g2id, out IDnaDataReaderCreator readerCreator, out User viewingUser, out ISite site)
        {
            mocks = new MockRepository();
            cache = mocks.DynamicMock<ICacheManager>();
            article = ArticleTest.CreateArticle();
            article.H2g2Id = article_h2g2id;
            article.EntryId = article_h2g2id / 10;
            readerCreator = mocks.DynamicMock<IDnaDataReaderCreator>();
            viewingUser = UserTest.CreateTestUser();
            site = mocks.DynamicMock<ISite>();
        }

        /// <summary>
        /// Tests if Category's serialized XML passes Category.xsd schema validation
        /// </summary>
        [TestMethod]
        public void Category_SerializedXML_PassesSchemaValidation()
        {
            var hierarchyDetails = CreateTestCategory();
            var objXml = StringUtils.SerializeToXmlUsingXmlSerialiser(hierarchyDetails);
            var validator = new DnaXmlValidator(objXml, "Category.xsd");
            validator.Validate();
        }
        
        /// <summary>
        /// Tests if CreateCategory atually uses the cache when DoNotIgnoreCache = true
        /// </summary>
        [TestMethod()]
        public void CreateCategory_WithDoNotIgnoreCache_CacheIsNotIgnored()  
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            Article article;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateCategory_SetupDefaultMocks(out mocks, out cache, out article, _test_h2g2id, out readerCreator, out viewingUser, out site);
            Category cachedCategory = CreateTestCategory();
            cachedCategory.LastUpdated = _test_lastUpdated;

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // simulate the category being in cache
            cache.Stub(x => x.GetData(_test_categoryCacheKey)).Return(cachedCategory);

            // simulate cachegetcategory being called and returning an up to date value
            IDnaDataReader cachegetcategoryReader = mocks.DynamicMock<IDnaDataReader>();
            cachegetcategoryReader.Stub(x => x.HasRows).Return(true);
            cachegetcategoryReader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            cachegetcategoryReader.Stub(x => x.GetDateTime("LastUpdated")).Return(_test_lastUpdated).Repeat.Times(8);      
            
            readerCreator.Stub(x => x.CreateDnaDataReader("")).Return(cachegetcategoryReader).Constraints(Is.Anything());

            // EXECUTE THE TEST             
            mocks.ReplayAll();
            Category actual = Category.CreateCategory(site, cache, readerCreator, viewingUser, _test_nodeID, false); 

            // VERIFY THE RESULTS
            // we were only testing the 'ignoreCache' parameter from the previous call
            // check the cache was accessed and the same instance returned
            cache.AssertWasCalled(c => c.GetData(_test_categoryCacheKey), options => options.Repeat.AtLeastOnce());
            Assert.AreSame(cachedCategory, actual);
        }

        /// <summary>
        /// Tests if CreateCategory bypasses the cache when DoNotIgnoreCache = false
        /// </summary>
        [TestMethod()]
        public void CreateCategory_WithIgnoreCache_CacheIsIgnored()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            Article article;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateCategory_SetupDefaultMocks(out mocks, out cache, out article, _test_h2g2id, out readerCreator, out viewingUser, out site);

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // mock the gethierarchynodedetails2 response, only minimal fields are required for this test
            IDnaDataReader gethierarchynodedetails2Reader = mocks.DynamicMock<IDnaDataReader>();
            gethierarchynodedetails2Reader.Stub(x => x.HasRows).Return(true);
            gethierarchynodedetails2Reader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(_test_h2g2id);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            readerCreator.Stub(x => x.CreateDnaDataReader("gethierarchynodedetails2")).Return(gethierarchynodedetails2Reader).Constraints(Is.Anything());

            // EXECUTE THE TEST            
            mocks.ReplayAll();
            Category actual = Category.CreateCategory(site, cache, readerCreator, viewingUser, _test_nodeID, true);

            // VERIFY THE RESULTS
            // we were only testing the 'ignoreCache' parameter from the previous call
            // check the cache was NEVER accessed, that a datareader call was made and that item was added to cache
            cache.AssertWasNotCalled(c => c.GetData(_test_categoryCacheKey));
            readerCreator.AssertWasCalled(x => x.CreateDnaDataReader("gethierarchynodedetails2"));
            cache.AssertWasCalled(c => c.Add(_test_categoryCacheKey, actual));
        }

        /// <summary>
        /// Test if CreateCategory throws an exception when no results are returned
        /// </summary>
        [TestMethod()]
        public void CreateCategory_NoResults_ThrowsException()
        {
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            Article article;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateCategory_SetupDefaultMocks(out mocks, out cache, out article, _test_h2g2id, out readerCreator, out viewingUser, out site);

            IDnaDataReader anyReader = mocks.DynamicMock<IDnaDataReader>();
            anyReader.Stub(x => x.HasRows).Return(false);
            anyReader.Stub(x => x.Read()).Return(false);
            readerCreator.Stub(x => x.CreateDnaDataReader("")).Return(anyReader).Constraints(Is.Anything());
            mocks.ReplayAll();

            try
            {
                Category actual = Category.CreateCategory(site, cache, readerCreator, viewingUser, _test_nodeID, false);
            }
            catch (ApiException e)
            {
                Assert.AreEqual(e.type, ErrorType.CategoryNotFound);
            }
        }

        
        /// <summary>
        /// Tests if CreateCategory correctly populates all immediate child properties of the returned instance
        /// </summary>
        [TestMethod()]
        public void CreateCategory_ValidResultSet_ReturnsValidObject()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;            
            Article article;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateCategory_SetupDefaultMocks(out mocks, out cache, out article, _test_h2g2id, out readerCreator, out viewingUser, out site);

            // create a mocked article to be returned by the mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader gethierarchynodedetails2Reader = mocks.DynamicMock<IDnaDataReader>();   
            gethierarchynodedetails2Reader.Stub(x => x.HasRows).Return(true);
            gethierarchynodedetails2Reader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            gethierarchynodedetails2Reader.Stub(x => x.GetStringNullAsEmpty("DisplayName")).Return("TestName");
            gethierarchynodedetails2Reader.Stub(x => x.GetStringNullAsEmpty("Description")).Return("TestDescription");
            gethierarchynodedetails2Reader.Stub(x => x.GetStringNullAsEmpty("synonyms")).Return("synonyms");
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(_test_h2g2id);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            gethierarchynodedetails2Reader.Stub(x => x.GetTinyIntAsInt("userAdd")).Return(1);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("type")).Return(2);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("nodeID")).Return(_test_nodeID);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("ParentID")).Return(_test_ParentID_Root);
            readerCreator.Stub(x => x.CreateDnaDataReader("gethierarchynodedetails2")).Return(gethierarchynodedetails2Reader).Constraints(Is.Anything());
            
            // EXECUTE THE TEST
            mocks.ReplayAll();
            Category actual = Category.CreateCategory(site, cache, readerCreator, viewingUser, _test_nodeID, false);
            
            // VERIFY THE RESULTS
            Assert.AreEqual("TestName", actual.DisplayName);
            Assert.AreEqual("TestDescription", actual.Description);
            Assert.AreEqual("synonyms", actual.Synonyms);
            Assert.AreEqual(_test_h2g2id, actual.H2g2id);
            Assert.AreEqual(1, actual.UserAdd);
            Assert.AreEqual(2, actual.Type);
            Assert.AreEqual(_test_nodeID, actual.NodeId);
            Assert.IsNotNull(actual.Ancestry);
            Assert.IsNotNull(actual.Children);
            Assert.IsNotNull(actual.Children.SubCategories);
            Assert.IsNotNull(actual.Children.Articles);
            Assert.IsNotNull(actual.Article);           
        }
        
        /// <summary>
        /// Tests if CreateCategory correctly sets the IsRoot property of the returned Category instance
        /// </summary>
        [TestMethod()]
        public void CreateCategory_WithRootCategory_ReturnsAsRoot()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            Article article;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateCategory_SetupDefaultMocks(out mocks, out cache, out article, _test_h2g2id, out readerCreator, out viewingUser, out site);            

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader gethierarchynodedetails2Reader = mocks.DynamicMock<IDnaDataReader>();
            gethierarchynodedetails2Reader.Stub(x => x.HasRows).Return(true);
            gethierarchynodedetails2Reader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(_test_h2g2id);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("ParentID")).Return(_test_ParentID_NonRoot);
            readerCreator.Stub(x => x.CreateDnaDataReader("gethierarchynodedetails2")).Return(gethierarchynodedetails2Reader).Constraints(Is.Anything());

            // EXECUTE THE TEST 
            mocks.ReplayAll();
            Category actual = Category.CreateCategory(site, cache, readerCreator, viewingUser, _test_nodeID, false);

            // VERIFY THE RESULTS
            Assert.AreEqual(false, actual.IsRoot);
        }

        /// <summary>
        /// Tests if CreateCategory correctly sets the IsRoot property of the returned Category instance
        /// </summary>
        [TestMethod()]
        public void CreateCategory_NotWithRootCategory_ReturnsIsRootAsFalse()
        {
            // PREPARE THE TEST
            // setup the default mocks
            MockRepository mocks;
            ICacheManager cache;
            Article article;
            IDnaDataReaderCreator readerCreator;
            User viewingUser;
            ISite site;
            CreateCategory_SetupDefaultMocks(out mocks, out cache, out article, _test_h2g2id, out readerCreator, out viewingUser, out site);

            // create a mocked article to be returned by mock cache so we can bypass the DB call
            cache.Stub(x => x.GetData(article.GetCacheKey(article.EntryId))).Return(article);

            // mock the gethierarchynodedetails2 response
            IDnaDataReader gethierarchynodedetails2Reader = mocks.DynamicMock<IDnaDataReader>();
            gethierarchynodedetails2Reader.Stub(x => x.HasRows).Return(true);
            gethierarchynodedetails2Reader.Stub(x => x.Read()).Return(true).Repeat.Times(8);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("h2g2ID")).Return(_test_h2g2id);
            gethierarchynodedetails2Reader.Stub(x => x.GetInt32("IsMainArticle")).Return(1);

            gethierarchynodedetails2Reader.Stub(x => x.GetInt32NullAsZero("ParentID")).Return(_test_ParentID_Root);
            readerCreator.Stub(x => x.CreateDnaDataReader("gethierarchynodedetails2")).Return(gethierarchynodedetails2Reader).Constraints(Is.Anything());

            // EXECUTE THE TEST 
            mocks.ReplayAll();
            Category actual = Category.CreateCategory(site, cache, readerCreator, viewingUser, _test_nodeID, false);

            // VERIFY THE RESULTS
            Assert.AreEqual(true, actual.IsRoot);
        }





        public static Category CreateTestCategory()
        {
            var hierarchyDetails = new Category()
            {           
                H2g2id = 1,
                IsRoot = true,
                NodeId = 1,
                Type = 1,
                UserAdd = 1,       
                DisplayName = "",
                Description = "",
                Synonyms = "", 
                Article = ArticleTest.CreateArticle(),
                Ancestry = new List<CategorySummary>()
                {
                    new CategorySummary()
                    {                          
                        AliasCount = 1,
                        ArticleCount = 1,
                        Name = "Name",
                        NodeCount = 1,
                        NodeID = 1,
                        SortOrder = 1,
                        StrippedName = ""
                    }
                },
                Children = new CategoryChildren()
                {

                    Articles = new List<ArticleSummary>() 
                     { 
                         CreateChildArticles(),
                         CreateChildArticles()
                     },
                    SubCategories = new List<CategorySummary>()
                    {
                        CreateChildCategories(),
                        CreateChildCategories()

                    }
                }
            };
            return hierarchyDetails;
        }

        public static ArticleSummary CreateChildArticles()
        {
            ArticleSummary returnValue = new ArticleSummary()
            {
                DateCreated = new DateElement(DateTime.Now),
                Editor = new UserElement()
                {
                    user = UserTest.CreateTestUser()
                },
                Type = Article.ArticleType.Article,
                H2G2ID = 1,
                LastUpdated = new DateElement(DateTime.Now),
                Name = "Test",
                SortOrder = 1,
                Status = new ArticleStatus()
                {                   
                    Type = 1,
                    Value = "1"
                },
                 StrippedName = "StrippedName"
            }; 
           
            return returnValue;
        }

        public static CategorySummary CreateChildCategories()
        {
            CategorySummary returnValue = new CategorySummary()
            {
                AliasCount = 1,
                ArticleCount = 1,
                Name = "Name",
                NodeCount = 1,
                NodeID = 1,
                SortOrder = 1,
                StrippedName = "",
                SubNodes = new List<CategorySummarySubnode>()
                {
                    new CategorySummarySubnode() 
                    {
                         ID = 1,
                         Type = 1,
                         Value = "value"
                    }
                },
                Type = 1
            };
            return returnValue;
        }
    }
}
