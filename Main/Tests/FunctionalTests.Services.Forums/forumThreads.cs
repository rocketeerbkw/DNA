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
    }
}
