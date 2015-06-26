using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Linq;

namespace FunctionalTests
{
    /// <summary>
    /// Test class for the Users project
    /// </summary>
    [TestClass]
    public class SiteManagerTests
    {
        private string _siteName = "h2g2";
        private int _siteId = 1;

        /// <summary>
        /// Setup fixture
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary />
        [TestMethod]
        public void SiteManager_GetKnownSite_ReturnsCorrectXML()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication= true;

            request.RequestPage("sitemanager?skin=purexml");

            var xmlDoc = request.GetLastResponseAsXML();
            ValidateSiteManagerPage(xmlDoc);
           
        }

        /// <summary />
        [TestMethod]
        public void SiteManager_GetKnownSiteWithNormalUser_ReturnsCorrectError()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;

            request.RequestPage("sitemanager?skin=purexml");

            var xmlDoc = request.GetLastResponseAsXML();

            ValidateError(xmlDoc, "Authorization");

        }

        /// <summary />
        [TestMethod]
        public void SiteManager_GetKnownSiteWithEditorUser_ReturnsCorrectError()
        {
            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;

            request.RequestPage("sitemanager?skin=purexml");

            var xmlDoc = request.GetLastResponseAsXML();

            ValidateError(xmlDoc, "INVALID PERMISSIONS");

        }

        /// <summary />
        [TestMethod]
        public void SiteManager_UpdateSiteModClassInvalidLanguage_ReturnsCorrectError()
        {
            var modId = 0;
            var name = "chinesestandard";
            try
            {
                
                using (FullInputContext inputcontext = new FullInputContext(""))
                {
                    using (IDnaDataReader dataReader = inputcontext.CreateDnaDataReader("createnewmoderationclass"))
                    {
                        dataReader.AddParameter("classname", name);
                        dataReader.AddParameter("description", "chinesestandard");
                        dataReader.AddParameter("Language", "zh");
                        dataReader.AddParameter("basedonclass", 1);
                        dataReader.Execute();
                    }

                    SendSignal();

                    using (IDnaDataReader dataReader = inputcontext.CreateDnaDataReader(""))
                    {
                        dataReader.ExecuteDEBUGONLY("select modclassid from moderationclass where name='" + name + "'");
                        Assert.IsTrue(dataReader.Read());
                        modId = dataReader.GetInt32("modclassid");
                    }
                }

                var request = new DnaTestURLRequest(_siteName);
                request.SetCurrentUserSuperUser();
                request.UseEditorAuthentication = true;
                request.RequestPage("sitemanager?skin=purexml");

                var xmlDoc = request.GetLastResponseAsXML();
                var listData = GeneratePostData(xmlDoc, _siteId);
                var originalModClassId = listData.FirstOrDefault(x => x.Key == "modclassid").Value;
                var pair = listData.Remove(listData.FirstOrDefault(x => x.Key == "modclassid"));
                listData.Add(new KeyValuePair<string,string>("modclassid", modId.ToString()));

                request.RequestPage("sitemanager?skin=purexml&update=1", ConvertToQueue(listData));
                xmlDoc = request.GetLastResponseAsXML();

                ValidateError(xmlDoc, "UPDATE ERROR");

                Assert.AreEqual(originalModClassId, xmlDoc.SelectSingleNode("/H2G2/SITEMANAGER/MODERATIONCLASSID").InnerText);

            }
            finally
            {
                using (FullInputContext inputcontext = new FullInputContext(""))
                {
                    if (modId != 0)
                    {
                        using (IDnaDataReader dataReader = inputcontext.CreateDnaDataReader(""))
                        {
                            dataReader.ExecuteDEBUGONLY("delete from TermsByModClass where modclassid=" + modId.ToString());
                            dataReader.ExecuteDEBUGONLY("delete from moderationclass where modclassid=" + modId.ToString());
                        }
                    }
                }

            }

        }

        private void SendSignal()
        {
            var url = String.Format("http://{0}/dna/h2g2/dnaSignal?action=recache-moderationclasses", DnaTestURLRequest.CurrentServer);
            var request = new DnaTestURLRequest("h2g2");
            //request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");


        }

        /// <summary />
        [TestMethod]
        public void SiteManager_UpdateSiteModClassValidLanguage_ReturnsCorrectUpdate()
        {
            var modId = 0;
            var originalModClassId = 0;

            var request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage("sitemanager?skin=purexml");


            var xmlDoc = request.GetLastResponseAsXML();
            ValidateSiteManagerPage(xmlDoc);
            var listData = GeneratePostData(xmlDoc, _siteId);
            originalModClassId = Int32.Parse(listData.FirstOrDefault(x => x.Key == "modclassid").Value);

            try
            {

                using (FullInputContext inputcontext = new FullInputContext(""))
                {
                    using (IDnaDataReader dataReader = inputcontext.CreateDnaDataReader(""))
                    {
                        dataReader.ExecuteDEBUGONLY("select modclassid from moderationclass where classlanguage='en' and modclassid <> " + originalModClassId.ToString());
                        Assert.IsTrue(dataReader.Read());
                        modId = dataReader.GetInt32("modclassid");
                    }
                }

                
                var pair = listData.Remove(listData.FirstOrDefault(x => x.Key == "modclassid"));
                listData.Add(new KeyValuePair<string, string>("modclassid", modId.ToString()));

                request.RequestPage("sitemanager?skin=purexml&update=1", ConvertToQueue(listData));
                xmlDoc = request.GetLastResponseAsXML();

                ValidateSiteManagerPage(xmlDoc);
                Assert.AreEqual(modId.ToString(), xmlDoc.SelectSingleNode("/H2G2/SITEMANAGER/MODERATIONCLASSID").InnerText);

                listData = GeneratePostData(xmlDoc, _siteId);
                pair = listData.Remove(listData.FirstOrDefault(x => x.Key == "modclassid"));
                listData.Add(new KeyValuePair<string, string>("modclassid", originalModClassId.ToString()));
                request.RequestPage("sitemanager?skin=purexml&update=1", ConvertToQueue(listData));
                xmlDoc = request.GetLastResponseAsXML();
                ValidateSiteManagerPage(xmlDoc);

                Assert.AreEqual(originalModClassId.ToString(), xmlDoc.SelectSingleNode("/H2G2/SITEMANAGER/MODERATIONCLASSID").InnerText);

            }
            finally
            {
            }

        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="xmlDoc"></param>
        private void ValidateSiteManagerPage(XmlDocument xmlDoc)
        {
            DnaXmlValidator validator = new DnaXmlValidator(xmlDoc.SelectSingleNode("/H2G2/SITE-LIST").OuterXml, "Site-List.xsd");
            validator.Validate();

            validator = new DnaXmlValidator(xmlDoc.SelectSingleNode("/H2G2/MODERATION-CLASSES").OuterXml, "Moderation-Classes.xsd");
            validator.Validate();

            validator = new DnaXmlValidator(xmlDoc.SelectSingleNode("/H2G2/SITEMANAGER").OuterXml, "SiteManager.xsd");
            validator.Validate();

            Assert.IsNull(xmlDoc.SelectSingleNode("H2G2/ERROR"));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="xml"></param>
        /// <param name="type"></param>
        private void ValidateError(XmlDocument xml, string type)
        {
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR[@TYPE='" + type + "']"));
        }

        private List<KeyValuePair<string, string>> GeneratePostData(XmlDocument xml, int siteid)
        {

            List<KeyValuePair<string, string>> postData = new List<KeyValuePair<string, string>>();
            postData.Add(new KeyValuePair<string,string>("modclassid", xml.SelectSingleNode("/H2G2/SITEMANAGER/MODERATIONCLASSID").InnerText));
            postData.Add(new KeyValuePair<string,string>("siteid", siteid.ToString()));
            postData.Add(new KeyValuePair<string, string>("shortName", xml.SelectSingleNode("/H2G2/SITEMANAGER/SHORTNAME").InnerText));
            postData.Add(new KeyValuePair<string, string>("description", xml.SelectSingleNode("/H2G2/SITEMANAGER/DESCRIPTION").InnerText));
            postData.Add(new KeyValuePair<string, string>("skinSet", xml.SelectSingleNode("/H2G2/SITEMANAGER/SKINSET").InnerText));
            postData.Add(new KeyValuePair<string, string>("defaultSkin", xml.SelectSingleNode("/H2G2/SITEMANAGER/DEFAULTSKIN").InnerText));
            postData.Add(new KeyValuePair<string, string>("moderatorsemail", xml.SelectSingleNode("/H2G2/SITEMANAGER/MODERATORSEMAIL").InnerText));
            postData.Add(new KeyValuePair<string, string>("editorsemail", xml.SelectSingleNode("/H2G2/SITEMANAGER/EDITORSEMAIL").InnerText));
            postData.Add(new KeyValuePair<string, string>("feedbackemail", xml.SelectSingleNode("/H2G2/SITEMANAGER/FEEDBACKEMAIL").InnerText));
            postData.Add(new KeyValuePair<string, string>("sampleurl", xml.SelectSingleNode("/H2G2/SITEMANAGER/SAMPLEURL").InnerText));
            
            var premoderated = xml.SelectSingleNode("/H2G2/SITEMANAGER/PREMODERATED").InnerText;
            var unmoderated = xml.SelectSingleNode("/H2G2/SITEMANAGER/UNMODERATED").InnerText;
            var modStatus =0;
            if (unmoderated == "1")
            {
                modStatus = 1;
            }
            else if (premoderated == "1")
            {
                modStatus = 3;
            }
            else
            {
                modStatus = 2;
            }
            postData.Add(new KeyValuePair<string, string>("modstatus", modStatus.ToString()));

            postData.Add(new KeyValuePair<string, string>("ssoservice", xml.SelectSingleNode("/H2G2/SITEMANAGER/SSOSERVICE").InnerText));
            postData.Add(new KeyValuePair<string, string>("noautoswitch", xml.SelectSingleNode("/H2G2/SITEMANAGER/NOAUTOSWITCH").InnerText));
            postData.Add(new KeyValuePair<string, string>("customterms", xml.SelectSingleNode("/H2G2/SITEMANAGER/CUSTOMTERMS").InnerText));
            postData.Add(new KeyValuePair<string, string>("automessageuserid", xml.SelectSingleNode("/H2G2/SITEMANAGER/AUTOMESSAGEUSERID").InnerText));
            postData.Add(new KeyValuePair<string, string>("passworded", xml.SelectSingleNode("/H2G2/SITEMANAGER/PASSWORDED").InnerText));
            postData.Add(new KeyValuePair<string, string>("articleforumstyle", xml.SelectSingleNode("/H2G2/SITEMANAGER/ARTICLEFORUMSTYLE").InnerText));
            postData.Add(new KeyValuePair<string, string>("threadorder", xml.SelectSingleNode("/H2G2/SITEMANAGER/THREADSORTORDER").InnerText));
            postData.Add(new KeyValuePair<string, string>("threadedittimelimit", xml.SelectSingleNode("/H2G2/SITEMANAGER/THREADEDITTIMELIMIT").InnerText));
            postData.Add(new KeyValuePair<string, string>("eventalertmessageuserid", xml.SelectSingleNode("/H2G2/SITEMANAGER/EVENTALERTMESSAGEUSERID").InnerText));
            postData.Add(new KeyValuePair<string, string>("allowRemoveVote", xml.SelectSingleNode("/H2G2/SITEMANAGER/ALLOWREMOVEVOTE").InnerText));
            postData.Add(new KeyValuePair<string, string>("includecrumbtrail", xml.SelectSingleNode("/H2G2/SITEMANAGER/INCLUDECRUMBTRAIL").InnerText));
            postData.Add(new KeyValuePair<string, string>("allowpostcodesinsearch", xml.SelectSingleNode("/H2G2/SITEMANAGER/ALLOWPOSTCODESINSEARCH").InnerText));
            postData.Add(new KeyValuePair<string, string>("eventemailsubject", xml.SelectSingleNode("/H2G2/SITEMANAGER/EVENTEMAILSUBJECT").InnerText));
            postData.Add(new KeyValuePair<string, string>("queuePostings", xml.SelectSingleNode("/H2G2/SITEMANAGER/QUEUEPOSTINGS").InnerText));
            postData.Add(new KeyValuePair<string, string>("identitypolicy", xml.SelectSingleNode("/H2G2/SITEMANAGER/CURRENTIDENTITYPOLICY").InnerText));

            postData.Add(new KeyValuePair<string, string>("riskmodonoff", xml.SelectSingleNode("/H2G2/SITEMANAGER/RISKMODONOFF").InnerText));
            postData.Add(new KeyValuePair<string, string>("riskmodpublishmethod", xml.SelectSingleNode("/H2G2/SITEMANAGER/RISKMODPUBLISHMETHOD").InnerText));
            postData.Add(new KeyValuePair<string, string>("notes", Guid.NewGuid().ToString()));


            return postData;
        }

        private Queue<KeyValuePair<string, string>> ConvertToQueue(List<KeyValuePair<string, string>> data)
        {
            Queue<KeyValuePair<string, string>> queueData = new Queue<KeyValuePair<string, string>>();
            foreach(var item in data)
            {
                queueData.Enqueue(item);
            }
            return queueData;
        }
    }
}
