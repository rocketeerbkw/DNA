using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace RipleyTests
{
    [TestClass]
    public class TypedArticleTests
    {
        //NOTE ENDDate values returned from the database will be the day after they values input
        //So in these tests we are just checking the database values are as we expect

        [TestMethod]
        public void TestTypedArticleUpdateCancelled()
        {
            Console.WriteLine("Before TestTypedArticleUpdateCancelled");
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            IDnaDataReader dataReader = inputContext.CreateDnaDataReader("");
            DateRangeInfo origDrInfo = new DateRangeInfo();
            ReadTopDateRangeRecord(dataReader, ref origDrInfo);

            // Create a "cancelled" typed article - i.e. do everything but actually create the article
            XmlDocument xml = UpdateCancelledTypedArticle(request, origDrInfo.entryId);

            Assert.IsTrue(GetMutiStageType(xml) == "TYPED-ARTICLE-EDIT");
            Assert.IsTrue(IsMutiStageCancelled(xml));
            Console.WriteLine("After TestTypedArticleUpdateCancelled");
        }

        [TestMethod]
        public void TestTypedArticleCreateCancelled()
        {
            Console.WriteLine("Before TestTypedArticleUpdateCancelled");
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            IDnaDataReader dataReader = inputContext.CreateDnaDataReader("");

            // Create a "cancelled" typed article - i.e. do everything but actually create the article
            XmlDocument xml = CreateCancelledTypedArticle(request);

            Assert.IsTrue(GetMutiStageType(xml) == "TYPED-ARTICLE-CREATE");
            Assert.IsTrue(IsMutiStageCancelled(xml));
            Console.WriteLine("After TestTypedArticleCreateCancelled");
        }

        [TestMethod]
        public void TestTypedArticleEditWithDateRange()
        {
            Console.WriteLine("Before TestTypedArticleEditWithDateRange");
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            IDnaDataReader dataReader = inputContext.CreateDnaDataReader("");
            DateRangeInfo origDrInfo = new DateRangeInfo();
            ReadTopDateRangeRecord(dataReader, ref origDrInfo);

            DateRangeInfo newDrInfo = new DateRangeInfo();

            // Update without a time interval
            XmlDocument xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 16, 11, 1993, 17, 12, 2003, 0);
            ReadTopDateRangeRecord(dataReader, ref newDrInfo);
            Assert.IsTrue(newDrInfo.startDate.CompareTo(new DateTime(1993, 11, 16)) == 0, "StartDate incorrect");
            Assert.IsTrue(newDrInfo.endDate.CompareTo(new DateTime(2003, 12, 18)) == 0, "EndDate incorrect");
            Assert.IsTrue(newDrInfo.timeIntervalNull, "TimeInterval should be a null value");
            Assert.IsTrue(GetEntryIDFromXml(xml) == newDrInfo.entryId, "Entry ID doesn't match");
            Assert.IsTrue(newDrInfo.entryId == origDrInfo.entryId, "Entry ID should be same as original");

            // Update with a time interval
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 17, 12, 1994, 18, 1, 2004, 27);
            ReadTopDateRangeRecord(dataReader, ref newDrInfo);
            Assert.IsTrue(newDrInfo.startDate.CompareTo(new DateTime(1994, 12, 17)) == 0, "StartDate incorrect");
            Assert.IsTrue(newDrInfo.endDate.CompareTo(new DateTime(2004, 1, 19)) == 0, "EndDate incorrect");
            Assert.IsFalse(newDrInfo.timeIntervalNull, "TimeInterval should not be a null value");
            Assert.IsTrue(newDrInfo.timeInterval == 27, "TimeInterval should be 27");
            Assert.IsTrue(GetEntryIDFromXml(xml) == newDrInfo.entryId, "Entry ID doesn't match");
            Assert.IsTrue(newDrInfo.entryId == origDrInfo.entryId, "Entry ID should be same as original");

            // Test error codes
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 30, 2, 1968, 5, 8, 1968, 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateInvalid");
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 6, 8, 1968, 31, 4, 1968, 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "EndDateInvalid");
            //xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 28, 2, 2068, 5, 8, 1968, 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateInTheFuture");
            //xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 28, 2, 1968, 5, 8, 2068, 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "EndDateInTheFuture");
            //xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 6, 8, 1968, 6, 8, 1968, 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateEqualsEndDate");
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 6, 8, 1968, 5, 8, 1968, 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateGreaterThanEndDate");
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, 6, 8, 1968, 7, 8, 1968, 3);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "TimeIntervalInvalid");
            Console.WriteLine("After TestTypedArticleEditWithDateRange");
        }

        [TestMethod]
        public void TestTypedArticleEditWithDateRangeUsingFreeTextDates()
        {
            //create article first...
            TestTypedArticleCreateWithDateRange();

            Console.WriteLine("Before TestTypedArticleEditWithDateRangeUsingFreeTextDates");
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            IDnaDataReader dataReader = inputContext.CreateDnaDataReader("");
            DateRangeInfo origDrInfo = new DateRangeInfo();
            ReadTopDateRangeRecord(dataReader, ref origDrInfo);

            DateRangeInfo newDrInfo = new DateRangeInfo();

            // Update without a time interval
            XmlDocument xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "16/11/1993", "17/12/2003", 0);
            ReadTopDateRangeRecord(dataReader, ref newDrInfo);
            Assert.IsTrue(newDrInfo.startDate.CompareTo(new DateTime(1993, 11, 16)) == 0, "StartDate incorrect");
            Assert.IsTrue(newDrInfo.endDate.CompareTo(new DateTime(2003, 12, 18)) == 0, "EndDate incorrect");
            Assert.IsTrue(newDrInfo.timeIntervalNull, "TimeInterval should be a null value");
            Assert.IsTrue(GetEntryIDFromXml(xml) == newDrInfo.entryId, "Entry ID doesn't match");
            Assert.IsTrue(newDrInfo.entryId == origDrInfo.entryId, "Entry ID should be same as original");

            // Update with a time interval
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "17/12/1994", "18/01/2004", 27);
            ReadTopDateRangeRecord(dataReader, ref newDrInfo);
            Assert.IsTrue(newDrInfo.startDate.CompareTo(new DateTime(1994, 12, 17)) == 0, "StartDate incorrect");
            Assert.IsTrue(newDrInfo.endDate.CompareTo(new DateTime(2004, 1, 19)) == 0, "EndDate incorrect");
            Assert.IsFalse(newDrInfo.timeIntervalNull, "TimeInterval should not be a null value");
            Assert.IsTrue(newDrInfo.timeInterval == 27, "TimeInterval should be 27");
            Assert.IsTrue(GetEntryIDFromXml(xml) == newDrInfo.entryId, "Entry ID doesn't match");
            Assert.IsTrue(newDrInfo.entryId == origDrInfo.entryId, "Entry ID should be same as original");

            // Test error codes
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "30/02/1968", "05/08/1968", 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateInvalid");
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "06/08/1968", "31/04/1968", 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "EndDateInvalid");
            //xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "06/08/1968", "06/08/1968", 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateEqualsEndDate");
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "06/08/1968", "05/08/1968", 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateGreaterThanEndDate");
            xml = UpdateTypedArticleWithDateRange(request, origDrInfo.entryId, "06/08/1968", "07/08/1968", 3);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "TimeIntervalInvalid");
            Console.WriteLine("After TestTypedArticleEditWithDateRangeUsingFreeTextDates");
        }

        [TestMethod]
        public void TestTypedArticleCreateWithDateRangeUsingFreeTextDates()
        {
            Console.WriteLine("Before TestTypedArticleCreateWithDateRangeUsingFreeTextDates");
            // Connect to Actionnetwork and navigate to a known unhidden node
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            IDnaDataReader dataReader2 = inputContext.CreateDnaDataReader("");
            DateRangeInfo drInfo2 = new DateRangeInfo();

            // Create without a time interval
            XmlDocument xml = CreateTypedArticleWithDateRange(request, "06/08/2005", "17/09/2005", 0);
            ReadTopDateRangeRecord(dataReader2, ref drInfo2);
            Assert.IsTrue(drInfo2.startDate.CompareTo(new DateTime(2005, 8, 6)) == 0, "StartDate incorrect");
            Assert.IsTrue(drInfo2.endDate.CompareTo(new DateTime(2005, 9, 18)) == 0, "EndDate incorrect");
            Assert.IsTrue(drInfo2.timeIntervalNull, "TimeInterval should be a null value");
            int xmlH2G2Id = GetEntryIDFromXml(xml);
            Assert.IsTrue(xmlH2G2Id == drInfo2.entryId, "Entry ID doesn't match");

            // Create with a time interval
            xml = CreateTypedArticleWithDateRange(request, "10/11/1970", "20/12/1970", 5);
            ReadTopDateRangeRecord(dataReader2, ref drInfo2);
            Assert.IsTrue(drInfo2.startDate.CompareTo(new DateTime(1970, 11, 10)) == 0, "StartDate incorrect");
            Assert.IsTrue(drInfo2.endDate.CompareTo(new DateTime(1970, 12, 21)) == 0, "EndDate incorrect");
            Assert.IsFalse(drInfo2.timeIntervalNull, "TimeInterval should NOT be a null value");
            Assert.IsTrue(drInfo2.timeInterval == 5, "TimeInterval should be 5");
            int lastEntryId = GetEntryIDFromXml(xml);
            Assert.IsTrue(lastEntryId == drInfo2.entryId, "EntryID differs from the value in the XML");

            // Test error codes
            xml = CreateTypedArticleWithDateRange(request, "30/02/1968", "05/08/1968", 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateInvalid");

            xml = CreateTypedArticleWithDateRange(request, "06/08/1968", "31/04/1968", 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "EndDateInvalid");

            //xml = CreateTypedArticleWithDateRange(request, "06/08/1968", "06/08/1968", 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateEqualsEndDate");

            xml = CreateTypedArticleWithDateRange(request, "06/08/1968", "05/08/1968", 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateGreaterThanEndDate");

            xml = CreateTypedArticleWithDateRange(request, "06/08/1968", "07/08/1968", 3);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "TimeIntervalInvalid");

            ReadTopDateRangeRecord(dataReader2, ref drInfo2);
            Assert.IsTrue(drInfo2.startDate.CompareTo(new DateTime(1970, 11, 10)) == 0, "StartDate should be same as last one");
            Assert.IsTrue(drInfo2.endDate.CompareTo(new DateTime(1970, 12, 21)) == 0, "EndDate should be same as last one");
            Assert.IsFalse(drInfo2.timeIntervalNull, "TimeInterval should NOT be a null value");
            Assert.IsTrue(drInfo2.timeInterval == 5, "TimeInterval should be same as last one");
            Assert.IsTrue(lastEntryId == drInfo2.entryId, "EntryId should be same as last one");

            // Try just the single start date (no end date)
            xml = CreateTypedArticleWithSingleStartDateRange(request, "01/01/2007", 0);
            ReadTopDateRangeRecord(dataReader2, ref drInfo2);
            Assert.IsTrue(drInfo2.startDate.CompareTo(new DateTime(2007, 1, 1)) == 0, "StartDate incorrect");
            Assert.IsTrue(drInfo2.endDate.CompareTo(new DateTime(2007, 1, 2)) == 0, "EndDate incorrect");
            Console.WriteLine("After TestTypedArticleCreateWithDateRangeUsingFreeTextDates");
        }

        [TestMethod]
        public void TestTypedArticleCreateWithDateRange()
        {
            Console.WriteLine("Before TestTypedArticleCreateWithDateRange");
            // Connect to Actionnetwork and navigate to a known unhidden node
            DnaTestURLRequest request = new DnaTestURLRequest("actionnetwork");
            request.SetCurrentUserNormal();
            IInputContext inputContext = DnaMockery.CreateDatabaseInputContext();
            IDnaDataReader dataReader = inputContext.CreateDnaDataReader("");
            DateRangeInfo drInfo = new DateRangeInfo();

            // Create without a time interval
            XmlDocument xml = CreateTypedArticleWithDateRange(request, 6, 8, 2005, 17, 9, 2005, 0);
            ReadTopDateRangeRecord(dataReader, ref drInfo);
            Assert.IsTrue(drInfo.startDate.CompareTo(new DateTime(2005, 8, 6)) == 0, "StartDate incorrect");
            Assert.IsTrue(drInfo.endDate.CompareTo(new DateTime(2005, 9, 18)) == 0, "EndDate incorrect");
            Assert.IsTrue(drInfo.timeIntervalNull, "TimeInterval should be a null value");
            Assert.IsTrue(GetEntryIDFromXml(xml) == drInfo.entryId, "Entry ID doesn't match");

            // Create with a time interval
            xml = CreateTypedArticleWithDateRange(request, 10, 11, 1970, 20, 12, 1970, 5);
            ReadTopDateRangeRecord(dataReader, ref drInfo);
            Assert.IsTrue(drInfo.startDate.CompareTo(new DateTime(1970, 11, 10)) == 0, "StartDate incorrect");
            Assert.IsTrue(drInfo.endDate.CompareTo(new DateTime(1970, 12, 21)) == 0, "EndDate incorrect");
            Assert.IsFalse(drInfo.timeIntervalNull, "TimeInterval should NOT be a null value");
            Assert.IsTrue(drInfo.timeInterval == 5, "TimeInterval should be 5");
            int lastEntryId = GetEntryIDFromXml(xml);
            Assert.IsTrue(lastEntryId == drInfo.entryId, "EntryID differs from the value in the XML");

            // Test error codes
            xml = CreateTypedArticleWithDateRange(request, 30, 2, 1968, 5, 8, 1968, 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateInvalid");

            xml = CreateTypedArticleWithDateRange(request, 6, 8, 1968, 31, 4, 1968, 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "EndDateInvalid");

            //xml = CreateTypedArticleWithDateRange(request, 28, 2, 2068, 5, 8, 1968, 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateInTheFuture");

            //xml = CreateTypedArticleWithDateRange(request, 28, 2, 1968, 5, 8, 2068, 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "EndDateInTheFuture");

            //No longer need this test as we add one to the enddate
            //xml = CreateTypedArticleWithDateRange(request, 6, 8, 1968, 6, 8, 1968, 10);
            //Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateEqualsEndDate");

            xml = CreateTypedArticleWithDateRange(request, 6, 8, 1968, 5, 8, 1968, 10);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "StartDateGreaterThanEndDate");

            xml = CreateTypedArticleWithDateRange(request, 6, 8, 1968, 7, 8, 1968, 3);
            Assert.IsTrue(ReadDateRangeErrorCode(xml) == "TimeIntervalInvalid");
           
            ReadTopDateRangeRecord(dataReader, ref drInfo);
            Assert.IsTrue(drInfo.startDate.CompareTo(new DateTime(1970, 11, 10)) == 0, "StartDate should be same as last one");
            Assert.IsTrue(drInfo.endDate.CompareTo(new DateTime(1970, 12, 21)) == 0, "EndDate should be same as last one");
            Assert.IsFalse(drInfo.timeIntervalNull, "TimeInterval should NOT be a null value");
            Assert.IsTrue(drInfo.timeInterval == 5, "TimeInterval should be same as last one");
            Assert.IsTrue(lastEntryId == drInfo.entryId, "EntryId should be same as last one");

            //Try just the single start date (no end date)
            xml = CreateTypedArticleWithSingleStartDateRange(request, 1, 1, 2007, 0);
            ReadTopDateRangeRecord(dataReader, ref drInfo);
            Assert.IsTrue(drInfo.startDate.CompareTo(new DateTime(2007, 1, 1)) == 0, "StartDate incorrect");
            Assert.IsTrue(drInfo.endDate.CompareTo(new DateTime(2007, 1, 2)) == 0, "EndDate incorrect");
            Console.WriteLine("After TestTypedArticleCreateWithDateRange");
        }

        private string ReadDateRangeErrorCode(XmlDocument xml)
        {
            XmlNode node = xml.SelectSingleNode("/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STARTDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR/@CODE");
            string errorCode = node.InnerText.ToString();
            return errorCode;
        }                

        private int GetEntryIDFromXml(XmlDocument xml)
        {
            XmlNode node = xml.SelectSingleNode("/H2G2/ARTICLE/@H2G2ID");
            return int.Parse(node.InnerText.ToString()) / 10;
        }

        private string GetMutiStageType(XmlDocument xml)
        {
            XmlNode node = xml.SelectSingleNode("/H2G2/MULTI-STAGE/@TYPE");
            return node.InnerText.ToString();
        }

        private bool IsMutiStageCancelled(XmlDocument xml)
        {
            XmlNode node = xml.SelectSingleNode("/H2G2/MULTI-STAGE/@CANCEL");
            return node.InnerText.ToString().Equals("YES");
        }

        private XmlDocument CreateCancelledTypedArticle(DnaTestURLRequest request)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleCreateParams(postParams, CreateRandomTitle(), true);
            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument UpdateCancelledTypedArticle(DnaTestURLRequest request, int entryId)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleUpdateParams(postParams, entryId, CreateRandomTitle(), true);
            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument CreateTypedArticleWithDateRange(DnaTestURLRequest request, int startDay, int startMonth, int startYear, int endDay, int endMonth, int endYear, int timeInterval)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleCreateParams(postParams, CreateRandomTitle(), false);
            AddTypedArticleDateRangeParams(postParams, startDay, startMonth, startYear, endDay, endMonth, endYear, timeInterval);
            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument CreateTypedArticleWithDateRange(DnaTestURLRequest request, string startDate, string endDate, int timeInterval)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleCreateParams(postParams, CreateRandomTitle(), false);
            AddTypedArticleDateRangeParams(postParams, startDate, endDate, timeInterval);
            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument CreateTypedArticleWithSingleStartDateRange(DnaTestURLRequest request, int startDay, int startMonth, int startYear, int timeInterval)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleCreateParams(postParams, CreateRandomTitle(), false);
            AddTypedArticleSingleStartDateRangeParam(postParams, startDay, startMonth, startYear, timeInterval);

            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument CreateTypedArticleWithSingleStartDateRange(DnaTestURLRequest request, string startDate, int timeInterval)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleCreateParams(postParams, CreateRandomTitle(), false);
            AddTypedArticleSingleStartDateRangeParam(postParams, startDate, timeInterval);

            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument UpdateTypedArticleWithDateRange(DnaTestURLRequest request, int entryId, int startDay, int startMonth, int startYear, int endDay, int endMonth, int endYear, int timeInterval)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleUpdateParams(postParams, entryId, CreateRandomTitle(), false);
            AddTypedArticleDateRangeParams(postParams, startDay, startMonth, startYear, endDay, endMonth, endYear, timeInterval);
            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private XmlDocument UpdateTypedArticleWithDateRange(DnaTestURLRequest request, int entryId, string startDate, string endDate, int timeInterval)
        {
            DnaTestURLRequestParams postParams = new DnaTestURLRequestParams();
            AddTypedArticleUpdateParams(postParams, entryId, CreateRandomTitle(), false);
            AddTypedArticleDateRangeParams(postParams, startDate, endDate, timeInterval);
            request.RequestPage("TypedArticle?skin=purexml", postParams.PostParams);
            return request.GetLastResponseAsXML();
        }

        private void AddTypedArticleBaseParams(DnaTestURLRequestParams postParams, string title)
        {
            postParams.Add("_msxml", "<MULTI-INPUT>" +
                                    "    <REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>" +
                                    "    <REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>" +
                                    "    <REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>" +
                                    "    <ELEMENT NAME='ROLE'></ELEMENT>" +
                                    "    <REQUIRED NAME='WHOCANEDIT'><VALIDATE TYPE='EMPTY'/></REQUIRED>" +
                                    "    <ELEMENT NAME='POLLTYPE1'></ELEMENT>" +
                                    "    <ELEMENT NAME='POLLTYPE2'></ELEMENT>" +
                                    "</MULTI-INPUT>");
            postParams.Add("type", "2");
            postParams.Add("_msfinish", "yes");
            postParams.Add("_msstage", "1");
            postParams.Add("title", title);
            postParams.Add("role", "testrole");
            postParams.Add("body", "Test body text");
            postParams.Add("whocanedit", "me");
        }

        private void AddTypedArticleCreateParams(DnaTestURLRequestParams postParams, string title, bool cancelled)
        {
            AddTypedArticleBaseParams(postParams, title);
            if (cancelled)
            {
                postParams.Add("acreatecancelled", "1");
            }
            else
            {
                postParams.Add("acreate", "1");
            }
        }

        private void AddTypedArticleUpdateParams(DnaTestURLRequestParams postParams, int entryId, string title, bool cancelled)
        {
            AddTypedArticleBaseParams(postParams, title);
            if (cancelled)
            {
                postParams.Add("aupdatecancelled", "1");
            }
            else
            {
                postParams.Add("aupdate", "1");
            }
            postParams.Add("h2g2id", GenerateH2G2Id(entryId).ToString());
        }

        private void AddTypedArticleDateRangeParams(DnaTestURLRequestParams postParams, int startDay, int startMonth, int startYear, int endDay, int endMonth, int endYear, int timeInterval)
        {
            postParams.Add("startday", startDay.ToString());
            postParams.Add("startmonth", startMonth.ToString());
            postParams.Add("startyear", startYear.ToString());
            postParams.Add("endday", endDay.ToString());
            postParams.Add("endmonth", endMonth.ToString());
            postParams.Add("endyear", endYear.ToString());

            if (timeInterval > 0)
            {
                postParams.Add("timeinterval", timeInterval.ToString());
            }
        }

        private void AddTypedArticleDateRangeParams(DnaTestURLRequestParams postParams, string startDate, string endDate, int timeInterval)
        {
            postParams.Add("startdate", startDate);
            postParams.Add("enddate", endDate);
            if (timeInterval > 0)
            {
                postParams.Add("timeinterval", timeInterval.ToString());
            }
        }

        private void AddTypedArticleSingleStartDateRangeParam(DnaTestURLRequestParams postParams, int startDay, int startMonth, int startYear, int timeInterval)
        {
            postParams.Add("startday", startDay.ToString());
            postParams.Add("startmonth", startMonth.ToString());
            postParams.Add("startyear", startYear.ToString());

            if (timeInterval > 0)
            {
                postParams.Add("timeinterval", timeInterval.ToString());
            }
        }

        private void AddTypedArticleSingleStartDateRangeParam(DnaTestURLRequestParams postParams, string startDate, int timeInterval)
        {
            postParams.Add("startdate", startDate);

            if (timeInterval > 0)
            {
                postParams.Add("timeinterval", timeInterval.ToString());
            }
        }

        private string CreateRandomTitle()
        {
            string title = "Test "+DateTime.Now.ToShortDateString()+" ";
            Random r = new Random((int)DateTime.Now.Ticks);
            title += r.Next().ToString();
            return title;
        }

        private void ReadTopDateRangeRecord(IDnaDataReader dataReader, ref DateRangeInfo drInfo)
        {
            dataReader.ExecuteDEBUGONLY("select top 1 * from articledaterange order by entryid desc");

            if (dataReader.Read())
            {
                drInfo.entryId= dataReader.GetInt32("EntryID");
                drInfo.startDate = dataReader.GetDateTime("StartDate");
                drInfo.endDate = dataReader.GetDateTime("EndDate");
                drInfo.timeIntervalNull = dataReader.IsDBNull("TimeInterval");
                if (!drInfo.timeIntervalNull)
                {
                    drInfo.timeInterval = dataReader.GetInt32("TimeInterval");
                }
            }
            else
            {
                Assert.Fail("Unable to read the ArticleDateRange table");
            }
        }

        private int GenerateH2G2Id(int entryId)
        {
            int temp = entryId;
	        int Checksum = 0;
	        while (temp > 0)
            {
        		Checksum = Checksum + (temp % 10);
		        temp = temp / 10;
            }
        	return (10 * entryId) + (9 - Checksum % 10);
        }
    }

    class DateRangeInfo
    {
        public int entryId;
        public DateTime startDate;
        public DateTime endDate;
        public bool timeIntervalNull;
        public int timeInterval;
    }
}
