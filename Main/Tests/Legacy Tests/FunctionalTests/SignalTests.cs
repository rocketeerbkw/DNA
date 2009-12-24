using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Net;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test class for testing the signaling system
    /// </summary>
    [TestClass]
    public class SignalTests
    {
        private Dictionary<string, string> _times = null;
        private string _originalValue = "";
        private string _timeParam = "param1";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("Signal Test StartUp");
            // First get the open close times for the h2g2 site
            //GetOpenCloseTimes();
            //_originalValue = _times[_timeParam];
            SnapshotInitialisation.RestoreFromSnapshot();
            SetSiteEmergencyClosed(false);
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                inputContext.SendSignal("action=recache-site");
            }
            
        }

        /// <summary>
        /// Test that we can manually send the recache site signal
        /// </summary>
        [Ignore]
        public void TestManualSignalSendToRecacheSiteListData()
        {
            Console.WriteLine("TestManualSignalSendToRecacheSiteListData");
            // Now get one of the times so we can do some checks
            String[] currentValues = _times[_timeParam].Split('_');

            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0],  currentValues[3]).InnerXml, currentValues[1]);

            // Now change the hour for the time and update the database
            string newTime = currentValues[0] + "_";
            int hour = Convert.ToInt32(currentValues[1]);
            if (hour < 1)
            {
                hour++;
            }
            else
            {
                hour--;
            }
            newTime += hour + "_" + currentValues[2] + "_" + currentValues[3];
            _times[_timeParam] = newTime;

            // Set the new time
            Assert.IsTrue(SetOpenCloseTimes(), "Failed to create the new open time for h2g2");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(),currentValues[0],currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]).InnerXml, currentValues[1]);

            // Now send the recache signal and check to make sure that the times are updated!
            request.RequestPage("dnasignal?action=recache-site&skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]).InnerXml, Convert.ToString(hour));

            // Finally set the time back to it's original time
            _times[_timeParam] = _originalValue;
            Assert.IsTrue(SetOpenCloseTimes(), "Failed to create the new open time for h2g2");

            // Double check to make sure it's back to normal
            request.RequestPage("dnasignal?action=recache-site&skin=purexml");
            Assert.IsTrue(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]) != null);
            Assert.AreEqual(GetMatchingNode(request.GetLastResponseAsXML(), currentValues[0], currentValues[3]).InnerXml, currentValues[1]);
        }

        /// <summary>
        /// Test that we can get the code to send the recache signal via the dot net application.
        /// This should send the request to the ripley application!
        /// </summary>
        [TestMethod]
        public void TestCodeSignalSendToRecacheSiteListDataViaDotNet()
        {
            Console.WriteLine("TestCodeSignalSendToRecacheSiteListDataViaDotNet");
            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now set the site to be closed
            Assert.IsTrue(SetSiteEmergencyClosed(true), "Failed to close h2g2");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now send the recache signal and check to make sure that the times are updated!
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                inputContext.SendSignal("action=recache-site");

                // Now check to make sure that the XML for the sitelist has not changed
                request.RequestPage("acs?skin=purexml");
                Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
                Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "1");

                // Now check to make sure that the XML for the sitelist has not changed
                request.RequestPage("?skin=purexml");
                Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
                Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "1");

                // Now set the site to be open
                Assert.IsTrue(SetSiteEmergencyClosed(false), "Failed to open h2g2");

                // Double check to make sure it's back to normal
                // Now send the recache signal and check to make sure that the times are updated!
                inputContext.SendSignal("action=recache-site");
            }
            // Now check to make sure that the closed value has been put back correctly
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the closed value has been put back correctly
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");
        }

        /// <summary>
        /// Test that we can get the code to send the recache signal via the ripley application.
        /// This should send the request to the dot net application!
        /// </summary>
        [Ignore]
        public void TestCodeSignalSendToRecacheSiteListDataViaRipley()
        {
            Console.WriteLine("TestCodeSignalSendToRecacheSiteListDataViaRipley");
            // Create the request for the test. Make sure we sign in as an editor
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.UseEditorAuthentication = true;
            request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            // Get the current open and close times for the h2g2 site
            request.RequestPage("?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now send a request to the ripley code to close the site and make sure the xml reflects the fact
            request.RequestPage("messageboardschedule?action=closesite&confirm=1&skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "1");

            // Check to make sure that the dot net web app got the signal and that the xml reflects the fact!
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "1");

            // Now send a request to the ripley code to open the site and make sure the xml reflects the fact
            request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Check to make sure that the dot net web app got the signal and that the xml reflects the fact!
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");
        }

        /// <summary>
        /// Make sure that the open close times are set back to there original values
        /// </summary>
        [TestCleanup]
        public void TidyUp()
        {
            // Make sure the times get put back correctly
            SetSiteEmergencyClosed(false);
            using (FullInputContext inputContext = new FullInputContext(false))
            {
                inputContext.SendSignal("action=recache-site");
            }
        }

        private XmlNode GetMatchingNode(XmlDocument xml, string param1, string param2)
        {
            // Return the node if found that matches the given criteria
            return xml.SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[DAYOFWEEK='" + param1 + "'][CLOSED='" + param2 + "']/HOUR");
        }

        private void GetOpenCloseTimes()
        {
            // Create a new dictionary
            _times = new Dictionary<string, string>();

            // Fill the times dictionary with the current open close times for h2g2
            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");

            // Check to see if we've got openclose times for this site
            if (request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME/DAYOFWEEK") == null)
            {
                // no times! Set daily repeating times for the site
                request.UseEditorAuthentication = true;
                request.SignUserIntoSSOViaProfileAPI(DnaTestURLRequest.usertype.EDITOR);
                request.RequestPage("messageboardschedule?action=update&updatetype=sameeveryday&recurrenteventopenhours=0&recurrenteventopenminutes=15&recurrenteventclosehours=23&recurrenteventcloseminutes=45&skin=purexml");
                request.UseEditorAuthentication = false;

                // Now re-request the original page
                request.RequestPage("acs?skin=purexml");
            }

            for (int i = 1, k = 0; i <= 7; i++)
            {
                _times.Add("param" + k++, GetTimes(request.GetLastResponseAsXML(), i, 0));
                _times.Add("param" + k++, GetTimes(request.GetLastResponseAsXML(), i, 1));
            }
        }

        private string GetTimes(XmlDocument xml, int day, int closed)
        {
            StringBuilder time = new StringBuilder();
            time.Append(day + "_" + xml.SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[DAYOFWEEK='" + day + "'][CLOSED='" + closed + "']/HOUR").InnerText);
            time.AppendFormat("_" + xml.SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[DAYOFWEEK='" + day + "'][CLOSED='" + closed + "']/MINUTE").InnerText + "_" + closed);
            return time.ToString();
        }

        private bool SetOpenCloseTimes()
        {
            // First delete the current open closing times
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("deletescheduledevents"))
                {
                    dataReader.AddParameter("siteid", 1);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }

            // Call the stored procedure directly as we don't want the signaling to be done automatically in this test!
            try
            {
                // First set the new open time for sunday
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("updatesitetopicsopencloseschedule"))
                {
                    dataReader.AddParameter("siteid", 1);

                    // Now fo through the dictionay adding the values
                    for (int i = 0; i < _times.Count; i++)
                    {
                        dataReader.AddParameter("param" + i, _times["param" + i]);
                    }
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }
            return true;
        }

        private bool SetSiteEmergencyClosed(bool setClosed)
        {
            // Set the value in the database
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("updatesitetopicsclosed"))
                {
                    dataReader.AddParameter("siteid", 1);
                    dataReader.AddParameter("siteemergencyclosed", setClosed ? 1 : 0);
                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                Assert.Fail(ex.Message);
                return false;
            }

            return true;
        }
    }
}

