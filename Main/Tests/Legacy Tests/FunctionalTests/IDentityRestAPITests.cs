using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Xml;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

using TestUtils;

namespace FunctionalTests
{
    [TestClass]
    public class IdentityRestAPITests
    {
        private string _userName = "testers";
        private string _password = "123456789";
        private string _dob = "1989-12-31";
        private string _displayName = "Good old tester";
        private Cookie _identityUserCookie = null;
        private Cookie _secureidentityUserCookie = null;
        private string _userIdentityID = String.Empty;
        string _responseString = "";
        private Dictionary<string, string> _postParams = new Dictionary<string, string>();
        private List<Cookie> _cookies = new List<Cookie>();

        [TestInitialize]
        public void Setup()
        {
            // Create a user to play with
            _cookies.Clear();
            _userName = "testers" + DateTime.Now.Ticks.ToString();
            if (!TestUserCreator.CreateIdentityUser(_userName, _password, _dob, _userName + "@bbc.co.uk", _displayName, true, TestUserCreator.IdentityPolicies.Adult, true, 0, out _identityUserCookie, out _secureidentityUserCookie, out _userIdentityID))
            {
                Assert.Fail(TestUserCreator.GetLastError);
            }
            _cookies.Add(_identityUserCookie);
            _responseString = "";
        }

        [TestMethod]
        public void LoginAndGetUserDetails()
        {
            HttpWebResponse response = TestUserCreator.CallIdentityRestAPI(string.Format("/users/{0}/attributes", _userName), null, _cookies, TestUserCreator.RequestVerb.GET);
            Assert.IsTrue(response != null, TestUserCreator.GetLastError);
            XmlDocument doc = GetLastResponseAsXML(response);

            Assert.AreEqual(_userName, doc.SelectSingleNode("//username").InnerText);
            Assert.AreEqual(_dob, doc.SelectSingleNode("//date_of_birth").InnerText);
            Assert.AreEqual(_displayName, doc.SelectSingleNode("//displayname").InnerText);
        }

        [TestMethod]
        public void GetDNAPolicies()
        {
            HttpWebResponse response = TestUserCreator.CallIdentityRestAPI("/policy", null, _cookies, TestUserCreator.RequestVerb.GET);
            Assert.IsTrue(response != null, TestUserCreator.GetLastError);
            XmlDocument xDoc = GetLastResponseAsXML(response);
            
            // Check to make sure that we get a valid response and it's value is true
            Assert.IsNotNull(xDoc.SelectSingleNode("//policies"), "No policies found!");

            // Get the DNA policies from the results
            List<string> policies = new List<string>();
            foreach (XmlNode policy in xDoc.SelectNodes("//policies/policy/uri"))
            {
                if (policy.InnerText.Contains("/dna/") && !policies.Contains(policy.InnerText))
                {
                    policies.Add(policy.InnerText);
                }
            }

            Assert.AreNotEqual(0, policies.Count, "No dna policies found!");
        }

        [TestMethod]
        public void AuthorizeUserWithPolicy()
        {
            _postParams.Clear();
            _postParams.Add("target_resource", "http://identity/policies/dna/adult");
            HttpWebResponse response = TestUserCreator.CallIdentityRestAPI("/authorization", _postParams, _cookies, TestUserCreator.RequestVerb.GET);
            Assert.IsTrue(response != null, TestUserCreator.GetLastError);
            XmlDocument xDoc = GetLastResponseAsXML(response);
        }
        
        /// <summary>
        /// Gets the last response as a string
        /// </summary>
        /// <returns>The response as a string.</returns>
        public string GetLastResponseAsString(HttpWebResponse response)
        {
            if (response.GetResponseStream().CanRead)
            {
                // Create a reader from the response stream and return the content
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    _responseString = reader.ReadToEnd();
                }
                response.Close();
            }
            return _responseString;
        }

        /// <summary>
        /// Gets the last response as xml
        /// </summary>
        /// <returns>The response as xml.</returns>
        public XmlDocument GetLastResponseAsXML(HttpWebResponse response)
        {
            // Get the response as a string if we don't already have it
            _responseString = GetLastResponseAsString(response);

            // Create a new xml doc from the string
            XmlDocument doc = new XmlDocument();
            try
            {
                doc.LoadXml(_responseString);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failed to load the response as XML - " + ex.Message);
            }
            return doc;
        }
    }
}
