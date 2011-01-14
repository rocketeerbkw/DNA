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
using BBC.Dna.Utils;

using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Objects;
using System.Collections.Specialized;
using BBC.Dna;
using TestUtils;



namespace FunctionalTests.Services.Forums
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class ForumThreadPosts_V1
    {
        private const string _schemaForumThreads = "Dna.Services.Forums\\forumThreadPosts.xsd";
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
        public ForumThreadPosts_V1()
        {
        }


        /// <summary>
        /// Test if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}?format=xml returns valid xml
        /// </summary>
        [TestMethod]
        public void GetForumThreadsXml_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetForumXml_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}?format=xml", _sitename, 150, 33);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
            validator.Validate();

            Console.WriteLine("After GetForumXml_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/post{3}?format=xml returns valid xml
        /// </summary>
        [TestMethod]
        public void GetForumThreadsWithPostXml_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetForumXml_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/post/{3}?format=XML", _sitename, 150, 33, 60);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
            validator.Validate();

            Console.WriteLine("After GetForumXml_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test if /dna/api/forums/ForumsService.svc/V1/site/{0}/threads/{2}?format=xml returns valid xml
        /// </summary>
        [TestMethod]
        public void GetThreadXml_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetThreadXml_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/threads/{2}?format=XML", _sitename, 150, 33, 60);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaForumThreads);
            validator.Validate();

            Console.WriteLine("After GetThreadXml_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test if /dna/api/forums/ForumsService.svc/V1/site/{0}/posts/{1} returns valid xml
        /// </summary>
        [TestMethod]
        public void GetThreadPostXml_WithValidID_ReturnsDeserializableObject()
        {
            Console.WriteLine("Before GetThreadPostXml_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/posts/{1}", _sitename, 60);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");

            // deserialize
            ThreadPost threadPost = (ThreadPost)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadPost));


            Assert.AreEqual(@"Doe the stuff that buys me beer!", threadPost.Subject);
            Assert.AreEqual(@"Dough.. the $tuff that buys me beer,<BR />Ray.. the guy who sells me beer, *<BR />Me.. the guy who drinks the beer,<BR />Fa(r).. the distance to my beer,<BR />So.. I think I'll have a beer,<BR />La.. la la la la la beer,<BR />Tea.. no thanks I'm drinking beer!<BR /><BR />That will bring us back to .... [looks at empty glass] d'oh! <BR /><BR /><SMILEY TYPE='kiss' H2G2='Smiley#kiss'/><SMILEY TYPE='kiss' H2G2='Smiley#kiss'/>", threadPost.Text);
            
            Assert.AreEqual(60, threadPost.PostId);

            Console.WriteLine("Before GetThreadPostXml_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test if /dna/api/forums/ForumsService.svc/V1/site/{0}/posts/{1} return 404 when invalid id is passed
        /// </summary>
        [TestMethod]
        public void GetThreadPostXml_WithInvalidID_Returns404()
        {
            Console.WriteLine("Before GetThreadPostXml_WithInvalidID_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/posts/{1}", _sitename, 99999);

            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ThreadPostNotFound.ToString(), errorData.Code);

            Console.WriteLine("Before GetThreadPostXml_WithInvalidID_Returns404");
        }

        /// <summary>
        /// Test if /dna/api/forums/ForumsService.svc/V1/site/{0}/posts/{1} return 404 when invalid site is passed
        /// </summary>
        [TestMethod]
        public void GetThreadPostXml_WithNonExistingSite_Returns404()
        {
            Console.WriteLine("Before GetThreadPostXml_WithNonExistingSite_Returns404");
            string nonExistingSite = "non_existing_site";

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/posts/{1}", nonExistingSite, 60);

            // now get the response
            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);

            Console.WriteLine("Before GetThreadPostXml_WithNonExistingSite_Returns404");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/create.htm executes without error
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithValidHTMLValues_ReturnsSuccess()
        {
            Console.WriteLine("Before CreateForumPostHTML_WithValidValues_ReturnsSuccess");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}/create.htm",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("inReplyTo={0}&subject={1}&text={2}&style={3}",
                 HttpUtility.UrlEncode(inReplyTo),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(text),
                 HttpUtility.UrlEncode(style));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);
            
            //check deserialisation
            ThreadPost savedThreadPost = (ThreadPost)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(ThreadPost));

            Console.WriteLine("After CreateForumPostHTML_WithValidValues_ReturnsSuccess");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} executes without error
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithValidXMLValues_ReturnsSuccess()
        {
            Console.WriteLine("Before CreateForumPost_WithValidXMLValues_ReturnsSuccess");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "31";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            request.RequestPageWithFullURL(url, serializedData, "text/xml");

            Console.WriteLine("After CreateForumPost_WithValidXMLValues_ReturnsSuccess");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when invalid site is passed in
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithNonExistingSiteID_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithNonExistingSiteID_ThrowsException");

            string nonexisting_siteid = "nonexistingsite";
            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "31";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                nonexisting_siteid, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithNonExistingSiteID_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when badly formed threadid passed in
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithBadlyFormedThreadID_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithBadlyFormedThreadID_ThrowsException");

            string forum = "7619338";
            string badlyformed_threadid = "nonexistingsite";
            string inReplyTo = "31";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, badlyformed_threadid);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (Exception)
            {

            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.InvalidThreadID.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithBadlyFormedThreadID_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when non-existing thread id is passed in
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithNonExistingThreadID_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithNonExistingThreadID_ThrowsException");

            string forum = "7619338";
            string nonexisting_threadid = "999999999";
            string inReplyTo = "31";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}", _sitename, forum, nonexisting_threadid);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }

            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ForumUnknown.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithNonExistingThreadID_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when user doesnt have permission
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithUserWithoutWritePermission_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithUserWithoutWritePermission_ThrowsException");

            string forum = "7619337";
            string threadid = "30";
            string inReplyTo = "30";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, threadid);

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("closethread"))
            {
                reader.AddParameter("@threadid", Convert.ToInt32(threadid))
                .Execute()
                .Read();
            }


            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal(); // userid_without_writepermission????

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {
            }


            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ForumReadOnly.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithUserWithoutWritePermission_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when non-existing forum id is passed in
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithNonExistingForumID_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithNonExistingForumID_ThrowsException");

            string nonexisting_forumid = "9999999";
            string threadid = "999999";
            string inReplyTo = "9999";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}", _sitename, nonexisting_forumid, threadid);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ForumUnknown.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithNonExistingForumID_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} user can't the found
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithMissingUserCredentials_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithNonExistingForumID_ThrowsException");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            //request.SetCurrentUserNormal(); // no user set

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingUserCredentials.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithMissingUserCredentials_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when posting requires secure user but user is not secure
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithInsecurePost_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithInsecurePost_ThrowsException");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();
            request.UseDebugUserSecureCookie = false;

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.NotSecure.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithInsecurePost_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when user is banned
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithBannedUser_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithBannedUser_ThrowsException");

            // TODO: this is currently failing, fix this when we have the new user code

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserBanned();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserIsBanned.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithBannedUser_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when site is closed
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithClosedSite_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithClosedSite_ThrowsException");

            string closed_site = "h2g2";
            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "test";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                closed_site, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal(); // set normal user as editors can access closed sites

            try
            {
                SetSiteValue(closed_site, "SiteEmergencyClosed", 1);

                string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
                 inReplyTo,
                 subject,
                 text,
                 style);

                try
                {
                    request.RequestPageWithFullURL(url, serializedData, "text/xml");
                }
                catch (WebException)
                {

                }
                Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
                ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
                Assert.AreEqual(ErrorType.SiteIsClosed.ToString(), errorData.Code);
            }
            finally
            {
                SetSiteValue(closed_site, "SiteEmergencyClosed", 0);
            }

            Console.WriteLine("After CreateForumPost_WithClosedSite_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when postign text is empty
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithEmptyText_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithEmptyText_ThrowsException");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal(); // no user set

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.EmptyText.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithEmptyText_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when text exceeds limit
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithExceededTextLimit_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithExceededTextLimit_ThrowsException");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "123456";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                SetSiteOption("1", "CommentForum", "MaxCommentCharacterLength", "0", 5, "description");

                try
                {
                    request.RequestPageWithFullURL(url, serializedData, "text/xml");
                }
                catch (WebException)
                {

                }
                Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
                ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
                Assert.AreEqual(ErrorType.ExceededTextLimit.ToString(), errorData.Code);
            }
            finally
            {
                RemoveSiteOption("1", "MaxCommentCharacterLength");
            }

            Console.WriteLine("After CreateForumPost_WithExceededTextLimit_ThrowsException");
        }

        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception when text is too little
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithMinCharLimitNotReached_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithMinCharLimitNotReached_ThrowsException");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "1";
            string subject = "test";
            string text = "1234";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                SetSiteOption("1", "CommentForum", "MinCommentCharacterLength","0",  5, "description"); 
                try
                {
                    request.RequestPageWithFullURL(url, serializedData, "text/xml");
                }
                catch (WebException)
                {

                }
                Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
                ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
                Assert.AreEqual(ErrorType.MinCharLimitNotReached.ToString(), errorData.Code);
            }
            finally
            {
                RemoveSiteOption("1", "MinCommentCharacterLength");
            }

            Console.WriteLine("After CreateForumPost_WithMinCharLimitNotReached_ThrowsException");
        }



        /// <summary>
        /// Tests if /dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2} throws an exception where profanities are used
        /// </summary>
        [TestMethod]
        public void CreateForumPost_WithProfanitiesInPost_ThrowsException()
        {
            Console.WriteLine("Before CreateForumPost_WithProfanitiesInPost_ThrowsException");

            string forum = "7619338";
            string thread = "31";
            string inReplyTo = "31";
            string subject = "test";
            string text = "fuck";
            string style = "richtext";
            string url = String.Format("http://" + _server + "/dna/api/forums/ForumsService.svc/V1/site/{0}/forums/{1}/threads/{2}",
                _sitename, forum, thread);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?><threadPost xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects""><datePosted i:nil=""true"" /><firstChild>0</firstChild><inReplyTo>{0}</inReplyTo><inReplyToIndex>0</inReplyToIndex><index>0</index><nextIndex>0</nextIndex><nextSibling>0</nextSibling><postId>0</postId><prevIndex>0</prevIndex><prevSibling>0</prevSibling><status>0</status><style>{3}</style><subject>{1}</subject><text>{2}</text><threadId>0</threadId><user i:nil=""true"" /></threadPost>",
             inReplyTo,
             subject,
             text,
             style);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ProfanityFoundInText.ToString(), errorData.Code);

            Console.WriteLine("After CreateForumPost_WithProfanitiesInPost_ThrowsException");
        }



        private void SetSiteValue(string urlName, string name, int value)
        {
            //set SiteEmergencyClosed value
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY(String.Format("UPDATE Sites SET {0} = {1} WHERE UrlName = '{2}'", name, value.ToString(), urlName));
                }
            }

            SendSiteRefreshSignal();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void SetSiteOption(string siteID, string section, string name, string type, int value, string description)
        {
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY(String.Format(@"insert into siteoptions 
                        (SiteID,Section,Name,Value,Type, Description) 
                        values ({0}, '{1}','{2}','{3}', '{4}', '{5}')",
                        siteID, section, name, value, type, description));
                }
            }
            SendSiteRefreshSignal();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void RemoveSiteOption(string siteid, string name)
        {
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY(
                        String.Format(@"delete from siteoptions where name='{0}' and siteid={1}",
                         name, siteid));
                }
            }
            SendSiteRefreshSignal();
        }

        private void SendSiteRefreshSignal()
        {
            // issue a signal to cause a cache refresh
            DnaTestURLRequest myRequest = new DnaTestURLRequest("h2g2");
            myRequest.AssertWebRequestFailure = false;
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/forums/status.aspx?action=recache-site", null, "text/html");

        }

    }
}
