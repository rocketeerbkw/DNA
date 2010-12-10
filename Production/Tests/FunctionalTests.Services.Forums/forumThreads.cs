using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna.Api;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Utils;

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Collections.Specialized;



namespace FunctionalTests.Services.Forums
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class ForumThreads_V1
    {
        private const string _schemaForumThreads = "Dna.Services.Forums\\forumThreads.xsd";
        private const string _schemaReviewForumPage = "Dna.Services.Forums\\reviewForumPage.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("After forumThreads_V1");
        }

        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Constructor
        /// </summary>
        public ForumThreads_V1()
        {
          
        }

        
        /// <summary>
        /// Test CreateCommentForum method from service
        /// </summary>
        [TestMethod]
        public void GetForumXml_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetForumXml_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}?format=xml", _sitename, 150);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"","") , _schemaForumThreads);
            validator.Validate();

            Console.WriteLine("After GetForumXml_ReadOnly_ReturnsValidXml");
        }


        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void CreateThread_WithValidHTMLValues_ReturnsSuccess()
        {
            Console.WriteLine("Before CreateThread_WithValidHTMLValues_ReturnsSuccess");

            string forum = "7619338";
            string subject = "html posted thread subject";
            string text = "html posted text";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/create.htm", _sitename, forum);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("subject={0}&text={1}&style={2}",
                 HttpUtility.HtmlEncode(subject),
                 HttpUtility.HtmlEncode(text),
                 HttpUtility.HtmlEncode(style));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After CreateThread_WithValidHTMLValues_ReturnsSuccess");
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void CreateThread_WithValidXMLValues_ReturnsSuccess()
        {
            Console.WriteLine("Before CreateThread_WithValidXMLValues_ReturnsSuccess");

            string forum = "7619338";
            string subject = "xml posted subject";
            string text = "xml psoted text";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads",
                _sitename, forum);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{2}</style><subject>{0}</subject><text>{1}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             subject,
             text,
             style);

            request.RequestPageWithFullURL(url, serializedData, "text/xml");

            Console.WriteLine("After CreateForumPost_WithValidXMLValues_ReturnsSuccess");
        }
        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void SubscribeToUnsubscribeFromForum_ReturnsSuccess()
        {
            Console.WriteLine("Before SubscribeToUnsubscribeFromForum_ReturnsSuccess");

            string forum = "7619338";

            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/subscribe", _sitename, forum);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("No data");

            request.RequestPageWithFullURL(url, postData, "text/xml");
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/unsubscribe", _sitename, forum);

            request.RequestPageWithFullURL(url, postData, "text/xml");
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After SubscribeToUnsubscribeFromForum_ReturnsSuccess");
        }
        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void SubscribeToUnsubscribeFromThread_ReturnsSuccess()
        {
            Console.WriteLine("Before SubscribeToUnsubscribeFromForum_ReturnsSuccess");

            string forum = "7619338";
            string thread = "31";

            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/subscribe", _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("No data");

            request.RequestPageWithFullURL(url, postData, "text/xml");
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/unsubscribe", _sitename, forum, thread);

            request.RequestPageWithFullURL(url, postData, "text/xml");
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After SubscribeToUnsubscribeFromForum_ReturnsSuccess");
        }
        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void SubscribeToUnsubscribeFromThread_ReturnsFailure()
        {
            Console.WriteLine("Before SubscribeToUnsubscribeFromThread_ReturnsFailure");

            string forum = "31";
            string thread = "7619338";

            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/subscribe", _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("No data");
            try
            {
                request.RequestPageWithFullURL(url, postData, "text/xml");
            }
            catch (WebException)
            {
            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.NotAuthorized.ToString(), errorData.Code);            



            url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/unsubscribe", _sitename, forum, thread);

            try
            {
                request.RequestPageWithFullURL(url, postData, "text/data");
            }
            catch (WebException)
            {
            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.NotAuthorized.ToString(), errorData.Code);            

            Console.WriteLine("After SubscribeToUnsubscribeFromThread_ReturnsFailure");
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void CreateThread_WithValidHTMLValuesAgainstAJournal_ReturnsSuccess()
        {
            Console.WriteLine("Before CreateThread_WithValidHTMLValuesAgainstAJournal_ReturnsSuccess");

            //Users - 1090501859
            //Journal

            string forum = "7618990";
            string subject = "html posted thread subject";
            string text = "html posted text";
            string style = "0";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/create.htm", _sitename, forum);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("subject={0}&text={1}&style={2}",
                 HttpUtility.HtmlEncode(subject),
                 HttpUtility.HtmlEncode(text),
                 HttpUtility.HtmlEncode(style));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", null, localHeaders);
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After CreateThread_WithValidHTMLValuesAgainstAJournal_ReturnsSuccess");

        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void CreateJournalThread_WithValidXMLValues_ReturnsSuccess()
        {
            Console.WriteLine("Before CreateJournalThread_WithValidXMLValues_ReturnsSuccess");

            string forum = "7618990";
            string subject = "xml posted subject";
            string text = "xml psoted text";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads",
                _sitename, forum);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{2}</style><subject>{0}</subject><text>{1}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             subject,
             text,
             style);

            request.RequestPageWithFullURL(url, serializedData, "text/xml");

            Console.WriteLine("After CreateJournalThread_WithValidXMLValues_ReturnsSuccess");
        }

        /// <summary>
        /// Test GetReviewForum method from service
        /// </summary>
        [TestMethod]
        public void GetReviewForum_ReadOnly_ReturnsValid()
        {
            Console.WriteLine("Before GetReviewForum_ReadOnly_ReturnsValid");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/reviewforums/{1}?format=xml", _sitename, 1);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");

            // test deserializiation
            ReviewForumPage reviewForumPage = (ReviewForumPage)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ReviewForumPage));

            Assert.IsTrue(reviewForumPage.ReviewForum.Id == 1, "Wrong Review Forum");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaReviewForumPage);
            validator.Validate();

            Console.WriteLine("After GetReviewForum_ReadOnly_ReturnsValid");
        }
    }
}
