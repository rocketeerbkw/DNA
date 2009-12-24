using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class ArticleSearchPageTests.cs
    /// </summary>
    [TestClass]
    public class ArticleSearchPageTests
    {
        private string _firstH2G2ID = String.Empty;
        private string _firstSite16H2G2ID = String.Empty;
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("actionnetwork");
        private const string _schemaUri = "H2G2ArticleSearchFlat.xsd";

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("setting up");
                //_request.UseEditorAuthentication = true;
                //_request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);
                _setupRun = true;
            }
        }

        /// <summary>
        /// Test we can get to the page. 
        /// </summary>
        [TestMethod]
        public void Test01CreateArticleSearchPageTest()
        {
            Console.WriteLine("Test01CreateArticleSearchPageTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skin=purexml");
            Console.WriteLine("After Test01CreateArticleSearchPageTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH") != null, "The article search page has not been generated!!!");
        }

        /// <summary>
        /// Article Search Within Date Range Test
        /// </summary>
        [TestMethod]
        public void Test02ArticleSearchWithinDateRangeTest()
        {
            Console.WriteLine("Test02ArticleSearchDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test02ArticleSearchDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test
        /// </summary>
        [TestMethod]
        public void Test03ArticleSearchTouchingDateRangeTest()
        {
            Console.WriteLine("Test03ArticleSearchDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test03ArticleSearchDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test
        /// </summary>
        [TestMethod]
        public void Test04ArticleSearchPlainSiteSearchTest()
        {
            Console.WriteLine("Test04ArticleSearchDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test04ArticleSearchDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search with Media Assets for Site Search Test
        /// </summary>
        [TestMethod]
        public void Test05ArticleSearchMediaAssetsSiteSearchTest()
        {
            Console.WriteLine("Test05ArticleSearchMediaAssetsSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=0&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test05ArticleSearchMediaAssetsSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search with Image Assets for Site Search Test
        /// </summary>
        [TestMethod]
        public void Test06ArticleSearchImageAssetsSiteSearchTest()
        {
            Console.WriteLine("Test06ArticleSearchImageAssetsSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=1&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test06ArticleSearchImageAssetsSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=1]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search with Audio Assets for Site Search Test
        /// </summary>
        [TestMethod]
        public void Test07ArticleSearchAudioAssetsSiteSearchTest()
        {
            Console.WriteLine("Test07ArticleSearchAudioAssetsSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=2&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test07ArticleSearchAudioAssetsSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=2]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search with Video Assets for Site Search Test
        /// </summary>
        [TestMethod]
        public void Test08ArticleSearchVideoAssetsSiteSearchTest()
        {
            Console.WriteLine("Test08ArticleSearchVideoAssetsSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=3&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test08ArticleSearchVideoAssetsSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=3]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search Within Date Range Test with phrase
        /// </summary>
        [TestMethod]
        public void Test09ArticleSearchWithinDateWithPhraseRangeTest()
        {
            Console.WriteLine("Test09ArticleSearchWithinDateWithPhraseRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test09ArticleSearchWithinDateWithPhraseRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test with phrase
        /// </summary>
        [TestMethod]
        public void Test10ArticleSearchTouchingDateRangeWithPhraseTest()
        {
            Console.WriteLine("Test10ArticleSearchTouchingDateRangeWithPhraseTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test10ArticleSearchTouchingDateRangeWithPhraseTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test with phrase
        /// </summary>
        [TestMethod]
        public void Test11ArticleSearchPlainSiteWithPhraseSearchTest()
        {
            Console.WriteLine("Test11ArticleSearchPlainSiteWithPhraseSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test11ArticleSearchPlainSiteWithPhraseSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search with Media Assets for Site Search Test with phrase
        /// </summary>
        [TestMethod]
        public void Test12ArticleSearchMediaAssetsWithPhraseSiteSearchTest()
        {
            Console.WriteLine("Test12ArticleSearchMediaAssetsWithPhraseSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=0&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test12ArticleSearchMediaAssetsWithPhraseSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search with Image Assets for Site Search Test with phrase
        /// </summary>
        [TestMethod]
        public void Test13ArticleSearchImageAssetsSiteWIthPhraseSearchTest()
        {
            Console.WriteLine("Test13ArticleSearchImageAssetsSiteWIthPhraseSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=1&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test13ArticleSearchImageAssetsSiteWIthPhraseSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=1]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search with Audio Assets for Site Search Test with phrase
        /// </summary>
        [TestMethod]
        public void Test14ArticleSearchAudioAssetsSiteWithPhraseSearchTest()
        {
            Console.WriteLine("Test14ArticleSearchAudioAssetsSiteWithPhraseSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=2&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test14ArticleSearchAudioAssetsSiteWithPhraseSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=2]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search with Video Assets for Site Search Test with phrase
        /// </summary>
        [TestMethod]
        public void Test15ArticleSearchVideoAssetsWithPhraseSiteSearchTest()
        {
            Console.WriteLine("Test15ArticleSearchVideoAssetsWithPhraseSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=3&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test15ArticleSearchVideoAssetsWithPhraseSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=3]") != null, "The all articles with media assets for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search With Erroneous Start Date Range Test
        /// </summary>
        [TestMethod]
        public void Test16ArticleSearchWithErroneousStartDateRangeTest()
        {
            Console.WriteLine("Test16ArticleSearchWithErroneousDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=63&startmonth=15&startyear=2006&&endday=1&endmonth=1&endyear=2007");
            Console.WriteLine("After Test16ArticleSearchWithErroneousDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid start date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (STARTDATE_INVALID)']") != null, "The invalid start date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search With Erroneous End Date Range Test
        /// </summary>
        [TestMethod]
        public void Test17ArticleSearchWithErroneousEndDateRangeTest()
        {
            Console.WriteLine("Test17ArticleSearchWithErroneousEndDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=64&endmonth=36&endyear=2007");
            Console.WriteLine("After Test17ArticleSearchWithErroneousEndDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid rnd date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (ENDDATE_INVALID)']") != null, "The invalid end date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search With Start Date Range Greater than End Date Range Test
        /// </summary>
        [TestMethod]
        public void Test18ArticleSearchWithStartGreaterThanEndDateRangeTest()
        {
            Console.WriteLine("Test18ArticleSearchWithStartGreaterThanEndDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2005");
            Console.WriteLine("After Test18ArticleSearchWithStartGreaterThanEndDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid start date range greater than end date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (STARTDATE_GREATERTHAN_ENDDATE)']") != null, "The invalid start date range greater than end date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search With Start Date Range Equal to the End Date Range Test
        /// </summary>
        [TestMethod]
        public void Test19ArticleSearchStartDateEqualsEndDateTest()
        {
            Console.WriteLine("Test19ArticleSearchStartDateEqualsEndDateTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=31&endmonth=12&endyear=2005"); // ArticleSearch assumes dates are inclusive so adds a day to the endday.
            Console.WriteLine("After Test19ArticleSearchStartDateEqualsEndDateTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid start date range equals the end date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (STARTDATE_EQUALS_ENDDATE)']") != null, "The start date range equals the end date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search Time Interval Within Date Range Test
        /// </summary>
        [TestMethod]
        public void Test20ArticleSearchTimeIntervalWithinDateRangeTest()
        {
            Console.WriteLine("Test20ArticleSearchTimeIntervalWithinDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&timeinterval=7");
            Console.WriteLine("After Test20ArticleSearchTimeIntervalWithinDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@TIMEINTERVAL=7]") != null, "The time interval within date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search Time Interval Touching Date Range Test
        /// </summary>
        [TestMethod]
        public void Test21ArticleSearchTimeIntervalTouchingDateRangeTest()
        {
            Console.WriteLine("Test21ArticleSearchTimeIntervalTouchingDateRangeTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&timeinterval=7");
            Console.WriteLine("After Test21ArticleSearchTimeIntervalTouchingDateRangeTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@TIMEINTERVAL=7]") != null, "The time interval within date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test Sort By Caption
        /// </summary>
        [TestMethod]
        public void Test22ArticleSearchWithinDateRangeTestSortByCaption()
        {
            Console.WriteLine("Test22ArticleSearchWithinDateRangeTestSortByCaption");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=Caption");
            Console.WriteLine("After Test22ArticleSearchWithinDateRangeTestSortByCaption");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page sort by caption has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='Caption']") != null, "The within date range article search page sort by caption has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test sort by Rating
        /// </summary>
        [TestMethod]
        public void Test23ArticleSearchWithinDateRangeTestSortByRating()
        {
            Console.WriteLine("Test23ArticleSearchWithinDateRangeTestSortByRating");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=Rating");
            Console.WriteLine("After Test23ArticleSearchWithinDateRangeTestSortByRating");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page sort by rating has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='Rating']") != null, "The within date range article search page sort by caption has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test sort by Rating try to show more than 200
        /// </summary>
        [TestMethod]
        public void Test24ArticleSearchShowMoreThan200()
        {
            Console.WriteLine("Test24ArticleSearchShowMoreThan200");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=300&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=Rating");
            Console.WriteLine("After Test24ArticleSearchShowMoreThan200");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SHOW=200]") != null, "The article search page is not restricting to 200 records!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test No End Date
        /// </summary>
        [TestMethod]
        public void Test25ArticleSearchWithinDateRangeNoEndDateTest()
        {
            Console.WriteLine("Test25ArticleSearchWithinDateRangeNoEndDateTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006");
            Console.WriteLine("After Test25ArticleSearchWithinDateRangeNoEndDateTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/DATERANGESTART/DATE[@DAY=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/DATERANGEEND/DATE[@DAY=1]") != null, "The default end date has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test26ArticleSearchWithinDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test26ArticleSearchWithinDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006&&enddate=1/1/2007");
            Console.WriteLine("After Test26ArticleSearchWithinDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test27ArticleSearchTouchingDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test27ArticleSearchTouchingDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startdate=1/1/2006&&enddate=1/1/2007");
            Console.WriteLine("After Test27ArticleSearchTouchingDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search Within Date Range Test with phrase Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test28ArticleSearchWithinDateWithPhraseRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test28ArticleSearchWithinDateWithPhraseRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006&&enddate=1/1/2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test28ArticleSearchWithinDateWithPhraseRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test with phrase Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test29ArticleSearchTouchingDateRangeWithPhraseTestDatesAsStrings()
        {
            Console.WriteLine("Test29ArticleSearchTouchingDateRangeWithPhraseTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&phrase=Test&namespace=null");
            Console.WriteLine("After Test29ArticleSearchTouchingDateRangeWithPhraseTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search With Erroneous Start Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test30ArticleSearchWithErroneousStartDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test30ArticleSearchWithErroneousStartDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=63/15/2006&enddate=1/1/2007");
            Console.WriteLine("After Test30ArticleSearchWithErroneousStartDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid start date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (STARTDATE_INVALID)']") != null, "The invalid start date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search With Erroneous End Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test31ArticleSearchWithErroneousEndDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test31ArticleSearchWithErroneousEndDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2007&enddate=63/74/2007");
            Console.WriteLine("After Test31ArticleSearchWithErroneousEndDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid rnd date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (ENDDATE_INVALID)']") != null, "The invalid end date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search With Start Date Range Greater than End Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test32ArticleSearchWithStartGreaterThanEndDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test32ArticleSearchWithStartGreaterThanEndDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006&enddate=1/1/2005");
            Console.WriteLine("After Test32ArticleSearchWithStartGreaterThanEndDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid start date range greater than end date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (STARTDATE_GREATERTHAN_ENDDATE)']") != null, "The invalid start date range greater than end date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search With Start Date Range Equal to the End Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test33ArticleSearchStartDateEqualsEndDateTestDatesAsStrings()
        {
            Console.WriteLine("Test33ArticleSearchStartDateEqualsEndDateTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2007&enddate=31/12/2006"); // ArticleSearch assumes dates are inclusive so adds a day to the endday.
            Console.WriteLine("After Test33ArticleSearchStartDateEqualsEndDateTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[@TYPE='invalidparameters']") != null, "The invalid start date range equals the end date range has not been flagged as an error!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ERROR[ERRORMESSAGE='Illegal date parameters (STARTDATE_EQUALS_ENDDATE)']") != null, "The start date range equals the end date range message is not correct!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search Time Interval Within Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test34ArticleSearchTimeIntervalWithinDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test34ArticleSearchTimeIntervalWithinDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&timeinterval=7");
            Console.WriteLine("After Test34ArticleSearchTimeIntervalWithinDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@TIMEINTERVAL=7]") != null, "The time interval within date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Article Search Time Interval Touching Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test35ArticleSearchTimeIntervalTouchingDateRangeTestDatesAsStrings()
        {
            Console.WriteLine("Test35ArticleSearchTimeIntervalTouchingDateRangeTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&timeinterval=7");
            Console.WriteLine("After Test35ArticleSearchTimeIntervalTouchingDateRangeTestDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@TIMEINTERVAL=7]") != null, "The time interval within date range article search page has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test Sort By Caption Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test36ArticleSearchWithinDateRangeTestSortByCaptionDatesAsStrings()
        {
            Console.WriteLine("Test36ArticleSearchWithinDateRangeTestSortByCaptionDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&articlesortby=Caption");
            Console.WriteLine("After Test36ArticleSearchWithinDateRangeTestSortByCaptionDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page sort by caption has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='Caption']") != null, "The within date range article search page sort by caption has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test sort by Rating Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test37ArticleSearchWithinDateRangeTestSortByRatingDatesAsStrings()
        {
            Console.WriteLine("Test37ArticleSearchWithinDateRangeTestSortByRatingDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&articlesortby=Rating");
            Console.WriteLine("After Test37ArticleSearchWithinDateRangeTestSortByRatingDatesAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page sort by rating has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='Rating']") != null, "The within date range article search page sort by caption has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test No End Date Date As Strings
        /// </summary>
        [TestMethod]
        public void Test38ArticleSearchWithinDateRangeNoEndDateTestDateAsStrings()
        {
            Console.WriteLine("Test38ArticleSearchWithinDateRangeNoEndDateTestDateAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2006");
            Console.WriteLine("After Test38ArticleSearchWithinDateRangeNoEndDateTestDateAsStrings");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/DATERANGESTART/DATE[@DAY=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/DATERANGEEND/DATE[@DAY=1]") != null, "The default end date has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test sort by Rating
        /// </summary>
        [TestMethod]
        public void Test39ArticleSearchPlainSiteSearchTestSortByRating()
        {
            Console.WriteLine("Test39ArticleSearchPlainSiteSearchTestSortByRating");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=0&articlesortby=Rating&skin=purexml");
            Console.WriteLine("After Test39ArticleSearchPlainSiteSearchTestSortByRating");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='Rating']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test40ArticleSearchPlainSiteSearchTestSortByStartDate()
        {
            Console.WriteLine("Test40ArticleSearchPlainSiteSearchTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=0&articlesortby=StartDate&skin=purexml");
            Console.WriteLine("After Test40ArticleSearchPlainSiteSearchTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test41ArticleSearchWithinDateRangeTestSortByStartDate()
        {
            Console.WriteLine("Test41ArticleSearchWithinDateRangeTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=StartDate");
            Console.WriteLine("After Test41ArticleSearchWithinDateRangeTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page sort by rating has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The within date range article search page sort by caption has not been generated correctly!!! (Sortby)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test42ArticleSearchTouchingDateRangeTestSortByStartDate()
        {
            Console.WriteLine("Test42ArticleSearchTouchingDateRangeTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=StartDate");
            Console.WriteLine("After Test42ArticleSearchTouchingDateRangeTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Sortby)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test with phrase Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test43ArticleSearchTouchingDateRangeWithPhraseTestSortByStartDate()
        {
            Console.WriteLine("Test43ArticleSearchTouchingDateRangeWithPhraseTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null&articlesortby=StartDate");
            Console.WriteLine("After Test43ArticleSearchTouchingDateRangeWithPhraseTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!!(Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test with phrase Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test44ArticleSearchWithinDateRangeWithPhraseTestSortByStartDate()
        {
            Console.WriteLine("Test44ArticleSearchWithinDateRangeWithPhraseTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null&articlesortby=StartDate");
            Console.WriteLine("After Test44ArticleSearchWithinDateRangeWithPhraseTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The within date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Editorial Article Search Plain Site Search Test (sort by DateCreated)
        /// </summary>
        [TestMethod]
        public void Test45EditorialArticleSearchPlainSiteSearchTest()
        {
            Console.WriteLine("Test45EditorialArticleSearchPlainSiteSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=0&skin=purexml");
            Console.WriteLine("After Test45EditorialArticleSearchPlainSiteSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The all articles for site article search page has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Editorial Article Search Plain Site Search Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test46EditorialArticleSearchPlainSiteSearchTestSortByStartDate()
        {
            Console.WriteLine("Test46EditorialArticleSearchPlainSiteSearchTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=0&articlesortby=StartDate&skin=purexml");
            Console.WriteLine("After Test46EditorialArticleSearchPlainSiteSearchTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The all articles for site article search page has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Editorial Article Search Within Date Range Test with phrase Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test47EditorialArticleSearchWithinDateRangeWithPhraseTestSortByStartDate()
        {
            Console.WriteLine("Test47EditorialArticleSearchWithinDateRangeWithPhraseTestSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null&articlesortby=StartDate");
            Console.WriteLine("After Test47EditorialArticleSearchWithinDateRangeWithPhraseTestSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The within date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The within date range article search page sort by start date has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Editorial Article Search Touching Date Range Test with phrase Dates As Strings Sort By Start Date
        /// </summary>
        [TestMethod]
        public void Test48EditorialArticleSearchTouchingDateRangeWithPhraseTestDatesAsStringsSortByStartDate()
        {
            Console.WriteLine("Test48EditorialArticleSearchTouchingDateRangeWithPhraseTestDatesAsStringsSortByStartDate");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&phrase=Test&namespace=null&articlesortby=StartDate");
            Console.WriteLine("After Test48EditorialArticleSearchTouchingDateRangeWithPhraseTestDatesAsStringsSortByStartDate");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The touching date range article search page sort by start date has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test49ArticleSearchPlainSiteSearchTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test49ArticleSearchPlainSiteSearchTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=0&articlesortby=StartDate&descendingorder=1&skin=purexml");
            Console.WriteLine("After Test49ArticleSearchPlainSiteSearchTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test50ArticleSearchWithinDateRangeTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test50ArticleSearchWithinDateRangeTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=StartDate&descendingorder=1");
            Console.WriteLine("After Test50ArticleSearchWithinDateRangeTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page sort by rating has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The within date range article search page sort by caption has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test51ArticleSearchTouchingDateRangeTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test51ArticleSearchTouchingDateRangeTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&articlesortby=StartDate&descendingorder=1");
            Console.WriteLine("After Test51ArticleSearchTouchingDateRangeTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Touching Date Range Test with phrase Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test52ArticleSearchTouchingDateRangeWithPhraseTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test52ArticleSearchTouchingDateRangeWithPhraseTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null&articlesortby=StartDate&descendingorder=1");
            Console.WriteLine("After Test52ArticleSearchTouchingDateRangeWithPhraseTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!!(Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Within Date Range Test with phrase Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test53ArticleSearchWithinDateRangeWithPhraseTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test53ArticleSearchWithinDateRangeWithPhraseTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null&articlesortby=StartDate&descendingorder=1");
            Console.WriteLine("After Test53ArticleSearchWithinDateRangeWithPhraseTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The within date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Editorial Article Search Plain Site Search Test (sort by DateCreated) with the descending order flag set
        /// This will have no effect on the data returned
        /// </summary>
        [TestMethod]
        public void Test54EditorialArticleSearchPlainSiteSearchTestAscendingOrder()
        {
            Console.WriteLine("Test54EditorialArticleSearchPlainSiteSearchTestAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=0&skin=purexml&descendingorder=1");
            Console.WriteLine("After Test54EditorialArticleSearchPlainSiteSearchTestAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The all articles for site article search page has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Editorial Article Search Plain Site Search Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test55EditorialArticleSearchPlainSiteSearchTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test55EditorialArticleSearchPlainSiteSearchTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=0&articlesortby=StartDate&skin=purexml&descendingorder=1");
            Console.WriteLine("After Test55EditorialArticleSearchPlainSiteSearchTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The all articles for site article search page has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The all articles for site article search page has not been generated correctly!!! - (SortBy)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Editorial Article Search Within Date Range Test with phrase Test sort by Start Date
        /// </summary>
        [TestMethod]
        public void Test56EditorialArticleSearchWithinDateRangeWithPhraseTestSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test56EditorialArticleSearchWithinDateRangeWithPhraseTestSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=null&articlesortby=StartDate&descendingorder=1");
            Console.WriteLine("After Test56EditorialArticleSearchWithinDateRangeWithPhraseTestSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The within date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The within date range article search page sort by start date has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }
        /// <summary>
        /// Editorial Article Search Touching Date Range Test with phrase Dates As Strings Sort By Start Date
        /// </summary>
        [TestMethod]
        public void Test57EditorialArticleSearchTouchingDateRangeWithPhraseTestDatesAsStringsSortByStartDateAscendingOrder()
        {
            Console.WriteLine("Test57EditorialArticleSearchTouchingDateRangeWithPhraseTestDatesAsStringsSortByStartDateAscendingOrder");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"articlestatus=3&skip=0&show=10&contenttype=-1&datesearchtype=2&skin=purexml&startdate=1/1/2006&enddate=1/1/2007&phrase=Test&namespace=null&articlesortby=StartDate&descendingorder=1");
            Console.WriteLine("After Test57EditorialArticleSearchTouchingDateRangeWithPhraseTestDatesAsStringsSortByStartDateAscendingOrder");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=2]") != null, "The touching date range article search page has not been generated correctly!!! (Search Type)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@SORTBY='StartDate']") != null, "The touching date range article search page sort by start date has not been generated correctly!!! (Sortby)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLESTATUS=3]") != null, "The touching date range article search page sort by start date has not been generated correctly!!! - (Status)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DESCENDINGORDER=1]") != null, "The all articles for site article search page has not been generated correctly!!! - (DescendingOrder)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test with phrase and namespace
        /// </summary>
        [TestMethod]
        public void Test58ArticleSearchPlainSiteWithPhraseAndNamespaceSearchTest()
        {
            Console.WriteLine("Test58ArticleSearchPlainSiteWithPhraseAndNamespaceSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=0&skin=purexml&startday=1&startmonth=1&startyear=2006&&endday=1&endmonth=1&endyear=2007&phrase=Test&namespace=TestNamespace");
            Console.WriteLine("After Test58ArticleSearchPlainSiteWithPhraseAndNamespaceSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=0]") != null, "The all articles for site article search page has not been generated correctly!!! - (DateSearchType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAME='Test']") != null, "Phrase XML not generated completed!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/PHRASES/PHRASE[NAMESPACE='TestNamespace']") != null, "Phrase Namespace XML not generated completed!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Article Search Plain Site Search Test with articleTypeFilter
        /// </summary>
        [TestMethod]
        public void Test59ArticleSearchPlainSiteWithArticleTypeFilterSearchTest()
        {
            Console.WriteLine("Test59ArticleSearchPlainSiteWithArticleTypeFilterSearchTest");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&articletype=1&skin=purexml");
            Console.WriteLine("After Test59ArticleSearchPlainSiteWithArticleTypeFilterSearchTest");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@CONTENTTYPE=-1]") != null, "The all articles for site article search page has not been generated correctly!!! - (ContentType)");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@ARTICLETYPE=1]") != null, "The  all articles for site article search page has not been generated correctly!!! - (Article Type)");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Sort articles by zeitgeist score
        /// </summary>
        [TestMethod]
        public void Test60SortArticlesByZeitgeistScore()
        {
            Console.WriteLine("Test60SortArticlesByZeitgeistScore");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&articlesortby=ArticleZeitgeist&skin=purexml");
            Console.WriteLine("After Test60SortArticlesByZeitgeistScore");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE/ZEITGEIST/SCORE") != null, "Zeitgeist scores for articles have not been generated correctly!!!");


            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=1]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 2]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 1 < score of article at position 2!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=2]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 3]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 2 < score of article at position 3!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=3]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 4]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 3 < score of article at position 4!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=4]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 4]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 4 < score of article at position 5!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES").ChildNodes.Count == 10, "ArticleSearch has not returned the correct number of articles given the skip and show params.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Sort articles by zeitgeist score with paging
        /// </summary>
        [TestMethod]
        public void Test61SortArticlesByZeitgeistScoreWithPaging()
        {
            Console.WriteLine("Test61SortArticlesByZeitgeistScoreWithPaging");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=10&show=10&contenttype=-1&articlesortby=ArticleZeitgeist&skin=purexml");
            Console.WriteLine("After Test61SortArticlesByZeitgeistScoreWithPaging");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE/ZEITGEIST/SCORE") != null, "Zeitgeist scores for articles have not been generated correctly!!!");


            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=1]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 2]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 1 < score of article at position 2!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=2]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 3]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 2 < score of article at position 3!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=3]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 4]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 3 < score of article at position 4!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=4]/ZEITGEIST/SCORE").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 4]/ZEITGEIST/SCORE").FirstChild.Value), "Articles have not been sorted according to zeitgiest scores correctly. The score of the article at position 4 < score of article at position 5!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES").ChildNodes.Count == 10, "ArticleSearch has not returned the correct number of articles given the skip and show params.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Sort articles by number of posts
        /// </summary>
        [TestMethod]
        public void Test62SortArticlesByPostCount()
        {
            Console.WriteLine("Test62SortArticlesByPostCount");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&articlesortby=PostCount&skin=purexml");
            Console.WriteLine("After Test62SortArticlesByPostCount");

            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=1]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 2]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 1 < the number of posts associated with the article at position 2!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=2]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 3]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 2 < the number of posts associated with the article at position 3!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=3]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 4]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 3 < the number of posts associated with the article at position 4!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=4]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 5]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 4 < the number of posts associated with the article at position 5!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES").ChildNodes.Count == 10, "ArticleSearch has not returned the correct number of articles given the skip and show params.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Sort articles by number of posts with paging
        /// </summary>
        [TestMethod]
        public void Test63SortArticlesByPostCountPaging()
        {
            Console.WriteLine("Test63SortArticlesByPostCountPaging");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=10&show=10&contenttype=-1&articlesortby=ArticleZeitgeist&skin=purexml");
            Console.WriteLine("After Test63SortArticlesByPostCountPaging");

            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=1]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 2]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 1 < the number of posts associated with the article at position 2!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=2]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 3]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 2 < the number of posts associated with the article at position 3!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=3]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 4]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 3 < the number of posts associated with the article at position 4!!!");
            Assert.IsTrue(Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=4]/NUMBEROFPOSTS").FirstChild.Value) >= Double.Parse(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position() = 5]/NUMBEROFPOSTS").FirstChild.Value), "Articles have not been sorted according to number of posts scores correctly. The number of posts associated with the article at position 4 < the number of posts associated with the article at position 5!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/ARTICLES").ChildNodes.Count == 10, "ArticleSearch has not returned the correct number of articles given the skip and show params.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        private bool CheckFullTextCatalogueExists(string siteName)
        {
            bool exists = false;
            string sql = String.Empty;

            if (siteName == "Collective")
            {
                /* Is there a populated full text catalog on Collective's GuideEntries to test against? */
                sql = "select * from sys.fulltext_catalogs c INNER JOIN sys.fulltext_indexes i ON c.fulltext_catalog_id = i.fulltext_catalog_id where name = 'VGuideEntryText_collectiveCat'";
            }
            else if (siteName == "Memoryshare")
            {
                /* Is there a populated full text catalog on MemoryShare's GuideEntries to test against? */
                sql = "select * from sys.fulltext_catalogs c INNER JOIN sys.fulltext_indexes i ON c.fulltext_catalog_id = i.fulltext_catalog_id where name = 'VGuideEntryText_memoryshareCat'";
            }
            else
            {
                /* Is there a populated full text catalog on GuideEntries to test against? */
                sql = "select * from sys.fulltext_catalogs c INNER JOIN sys.fulltext_indexes i ON c.fulltext_catalog_id = i.fulltext_catalog_id where name = 'GuideEntriesCat'";
            }

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(sql))
            {
                dataReader.ExecuteDEBUGONLY(sql);
                if (dataReader.HasRows)
                {
                    exists = true;
                }
            }

            return exists;
        }

        /// <summary>
        /// Free text search on collective
        /// </summary>
        [TestMethod]
        public void Test64FreeTextSearchOnCollective()
        {
            Console.WriteLine("Test64FreeTextSearchOnCollective");
            if (CheckFullTextCatalogueExists(@"Collective"))
            {
                DnaTestURLRequest _collectiveRequest = new DnaTestURLRequest("collective");

                _collectiveRequest.RequestAspxPage("ArticleSearchPage.aspx", @"skip=10&show=10&contenttype=-1&freetextsearch=Test&skin=purexml");

                XmlDocument xml = _collectiveRequest.GetLastResponseAsXML();

                Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[FREETEXTSEARCH='Test']") != null, "Article Search XML not generated completed - Free Text Search Term!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
            else
            {
                Console.WriteLine("WARNING!! Test not run as Collective full text indexes are not present!");
            }
            Console.WriteLine("After Test64FreeTextSearchOnCollective");
        }
        /// <summary>
        /// Free text search on Memoryshare
        /// </summary>
        [TestMethod]
        public void Test65FreeTextSearchOnMemoryshare()
        {
            Console.WriteLine("Test65FreeTextSearchOnMemoryshare");
            if (CheckFullTextCatalogueExists(@"Memoryshare"))
            {
                DnaTestURLRequest _memoryshareRequest = new DnaTestURLRequest("memoryshare");

                _memoryshareRequest.RequestAspxPage("ArticleSearchPage.aspx", @"skip=10&show=10&contenttype=-1&freetextsearch=Test&skin=purexml");

                XmlDocument xml = _memoryshareRequest.GetLastResponseAsXML();

                Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[FREETEXTSEARCH='Test']") != null, "Article Search XML not generated completed - Free Text Search Term!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
            else
            {
                Console.WriteLine("WARNING!! Test not run as Memoryshare full text indexes are not present!");
            }
            Console.WriteLine("After Test65FreeTextSearchOnMemoryshare");
        }
        /// <summary>
        /// Free text search on h2g2
        /// </summary>
        [TestMethod]
        public void Test66FreeTextSearchOnH2G2()
        {
            Console.WriteLine("Test66FreeTextSearchOnH2G2");
            if (CheckFullTextCatalogueExists(@"h2g2"))
            {
                DnaTestURLRequest _h2g2Request = new DnaTestURLRequest("h2g2");

                _h2g2Request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=10&show=10&contenttype=-1&freetextsearch=Test&skin=purexml");

                XmlDocument xml = _h2g2Request.GetLastResponseAsXML();

                Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[FREETEXTSEARCH='Test']") != null, "Article Search XML not generated completed - Free Text Search Term!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
            else
            {
                Console.WriteLine("WARNING!! Test not run as full text indexes are not present!");
            }
            Console.WriteLine("After Test66FreeTextSearchOnH2G2");
        }
        /// <summary>
        /// Article Search With Start Date Range Equal to the End Date Range Test Dates As Strings
        /// </summary>
        [TestMethod]
        public void Test67ArticleSearchStartDateParamEqualsEndDateParamTestDatesAsStrings()
        {
            Console.WriteLine("Test67ArticleSearchStartDateParamEqualsEndDateParamTestDatesAsStrings");
            _request.RequestAspxPage("ArticleSearchPage.aspx", @"skip=0&show=10&contenttype=-1&datesearchtype=1&skin=purexml&startdate=1/1/2007&enddate=1/1/2007"); // ArticleSearch assumes dates are inclusive so adds a day to the endday.

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH[@DATESEARCHTYPE=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/DATERANGESTART/DATE[@DAY=1]") != null, "The within date range article search page has not been generated correctly!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLESEARCH/DATERANGEEND/DATE[@DAY=1]") != null, "The default end date has not been generated correctly!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
            Console.WriteLine("After Test67ArticleSearchStartDateParamEqualsEndDateParamTestDatesAsStrings");
        }

        /// <summary>
        /// Checks Hotlist generation
        /// </summary>
        [TestMethod]
        public void Test68ArticleHotlistShowPhrasesTest()
        {
            Console.WriteLine("Test68ArticleHotlistShowPhrasesTest");

            SignalAndWaitforSiteOptionToBeSet(16, "ArticleSearch", "GenerateHotlist", 1);

            //Changed the database so try a new request object to make sure we get the correct siteoption
            DnaTestURLRequest newRequest = new DnaTestURLRequest("actionnetwork");
            newRequest.RequestAspxPage("ArticleSearchPage.aspx", @"contenttype=-1&showphrases=150&skin=purexml");
            Console.WriteLine("After Test68ArticleHotlistShowPhrasesTest");

            XmlDocument xml = newRequest.GetLastResponseAsXML();

            XmlNode siteoptionset = xml.SelectSingleNode("H2G2/SITE/SITEOPTIONS/SITEOPTION[@GLOBAL='0'][NAME='GenerateHotlist'][VALUE='1']");
            if (siteoptionset == null)
            {
                Console.WriteLine("siteoption not set");
            }

            XmlNode globaloptionset = xml.SelectSingleNode("H2G2/SITE/SITEOPTIONS/SITEOPTION[@GLOBAL='1'][NAME='GenerateHotList'][VALUE='1']");
            if (globaloptionset == null)
            {
                Console.WriteLine("globaloptionset not set");
            }

            Console.WriteLine("HotPhrases");
            XmlNode hotphrases = xml.SelectSingleNode("H2G2/ARTICLEHOT-PHRASES");
            if (hotphrases == null)
            {
                Console.WriteLine("No hotlist");
            }
            else
            {
                Console.WriteLine(hotphrases.InnerXml);
            }

            XmlNode showphrases = xml.SelectSingleNode("H2G2/ARTICLEHOT-PHRASES/@SHOW");
            if (showphrases == null)
            {
                Console.WriteLine("No show");
            }
            else
            {
                Console.WriteLine(showphrases.InnerXml);
            }

            Assert.IsTrue(xml.SelectSingleNode("H2G2/ARTICLEHOT-PHRASES[@SHOW=150]") != null, "The Hotlist show phrases doesn't match the entered value!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Checks ArticleSearch sort by bookmark count (for site with IncludeBookmarkCount SiteOption = 1
        /// </summary>
        [TestMethod]
        public void Test69ArticleSearchSortByBookmarkCountWhereSiteOptionIncludeBookmarkCountIs1()
        {
            Console.WriteLine("Test69ArticleSearchSortByBookmarkCountWhereSiteOptionIncludeBookmarkCountIs1");

            //Changed the database so try a new request object to make sure we get the correct siteoption
            DnaTestURLRequest newRequest = new DnaTestURLRequest("h2g2"); // SiteOption IncludeBookmarkCount = 1 for h2g2 on SmallGuide
            newRequest.RequestAspxPage("ArticleSearchPage.aspx", @"contenttype=-1&showphrases=20&articlesortby=BookmarkCount&skin=purexml");
            Console.WriteLine("After Test69ArticleSearchSortByBookmarkCountWhereSiteOptionIncludeBookmarkCountIs1");

            XmlDocument xml = newRequest.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ARTICLESEARCH[@SORTBY='BookmarkCount']") != null, "The @SORTBY element is not BookmarkCount!!!");

            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=1]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=2]/BOOKMARKCOUNT").FirstChild.Value), "Articles 1-2 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=2]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=3]/BOOKMARKCOUNT").FirstChild.Value), "Articles 2-3 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=3]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=4]/BOOKMARKCOUNT").FirstChild.Value), "Articles 3-4 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=4]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=5]/BOOKMARKCOUNT").FirstChild.Value), "Articles 4-5 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=5]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=6]/BOOKMARKCOUNT").FirstChild.Value), "Articles 5-6 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=6]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=7]/BOOKMARKCOUNT").FirstChild.Value), "Articles 6-7 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=7]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=8]/BOOKMARKCOUNT").FirstChild.Value), "Articles 7-8 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=8]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=9]/BOOKMARKCOUNT").FirstChild.Value), "Articles 8-9 are not in Bookmark count order.");
            Assert.IsTrue(Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=9]/BOOKMARKCOUNT").FirstChild.Value) > Int32.Parse(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[position()=10]/BOOKMARKCOUNT").FirstChild.Value), "Articles 9-10 are not in Bookmark count order.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Checks ArticleSearch sort by bookmark count (for site with IncludeBookmarkCount SiteOption = 1
        /// </summary>
        [TestMethod]
        public void Test70ArticleSearchSortByBookmarkCountWhereSiteOptionIncludeBookmarkCountIs0()
        {
            Console.WriteLine("Test70ArticleSearchSortByBookmarkCountWhereSiteOptionIncludeBookmarkCountIs0");

            //Changed the database so try a new request object to make sure we get the correct siteoption
            DnaTestURLRequest newRequest = new DnaTestURLRequest("actionnetwork");
            newRequest.RequestAspxPage("ArticleSearchPage.aspx", @"contenttype=-1&showphrases=20&articlesortby=BookmarkCount&skin=purexml");
            Console.WriteLine("After Test70ArticleSearchSortByBookmarkCountWhereSiteOptionIncludeBookmarkCountIs0");

            XmlDocument xml = newRequest.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ARTICLESEARCH[@SORTBY='BookmarkCount']") != null, "The @SORTBY element is not BookmarkCount!!!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE/BOOKMARKCOUNT") == null, "Element BOOKMARKCOUNT should not be outputted on a site where SiteOption BookmarkCount = 0.");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Helper method that signals for a siteoption to be changed then waits for that site to receive and process the signal
        /// </summary>
        /// <param name="siteid">The site id</param>
        /// <param name="section">The site option section</param>
        /// <param name="siteoption">The site option name</param>
        /// <param name="value">The value for the site option</param>
        private static void SignalAndWaitforSiteOptionToBeSet(int siteid, string section, string name, int value)
        {
            // Create a context that will provide us with real data reader support
            IInputContext testContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a datareader to set the Generate Hotlist flag
            using (IDnaDataReader reader = testContext.CreateDnaDataReader("setsiteoption"))
            {
                reader.AddParameter("SiteID", siteid);
                reader.AddParameter("Section", section);
                reader.AddParameter("Name", name);
                reader.AddParameter("Value", value);
                reader.Execute();
            }

            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestAspxPage("dnasignal.aspx", @"action=recache-site&skin=purexml");

            // Now wait untill the .net has been signaled by ripley that we need to recache site data. Site Options are in the data!!!
            // Make sure we've got a drop clause after 15 seconds!!!
            int tries = 0;
            bool updated = false;
            Console.Write("Waiting for signal to be processed ");
            while (tries++ <= 12 && !updated)
            {
                request.RequestPage("siteoptions?skin=purexml");
                if (request.GetLastResponseAsXML().SelectSingleNode("H2G2/SITEOPTIONS[@SITEID='16']/SITEOPTION[NAME='GenerateHotlist']/VALUE") != null)
                {
                    updated = request.GetLastResponseAsXML().SelectSingleNode("H2G2/SITEOPTIONS[@SITEID='16']/SITEOPTION[NAME='GenerateHotlist']/VALUE").InnerXml.CompareTo("1") == 0;

                    if (!updated)
                    {
                        // Goto sleep for 5 secs
                        System.Threading.Thread.Sleep(5000);
                        Console.Write(".");
                    }
                }
            }
            tries *= 5;
            Console.WriteLine(" waited " + tries.ToString() + " seconds.");
        }
    }
}