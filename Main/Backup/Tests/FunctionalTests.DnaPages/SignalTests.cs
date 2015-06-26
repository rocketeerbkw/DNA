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
using System.Threading;


namespace FunctionalTests
{
    /// <summary>
    /// Test class for testing the signaling system
    /// </summary>
    [TestClass]
    public class SignalTests
    {

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("Signal Test StartUp");
            // First get the open close times for the h2g2 site
            SnapshotInitialisation.RestoreFromSnapshot();
            SetSiteEmergencyClosed(false);
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");
            }
            
        }

        /// <summary>
        /// Test that we can manually send the recache site signal
        /// </summary>
        [TestMethod]
        public void Messageboardschedule_SetInRipley_CheckVisibleInCSharp()
        {

            // Fill the times dictionary with the current open close times for h2g2
            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");

            // Check to see if we've got openclose times for this site
            Assert.IsNull(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME"));
            // no times! Set daily repeating times for the site
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();
            request.RequestPage("messageboardschedule?action=update&updatetype=sameeveryday&recurrenteventopenhours=0&recurrenteventopenminutes=15&recurrenteventclosehours=23&recurrenteventcloseminutes=45&skin=purexml");
            request.UseEditorAuthentication = false;

            Thread.Sleep(5000);
            // Now re-request the original page
           request.RequestPage("acs?skin=purexml");
           Assert.IsNotNull(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME"));
        
        }

        /// <summary>
        /// Test that we can get the code to send the recache signal via the dot net application.
        /// This should send the request to the ripley application!
        /// </summary>
        [TestMethod]
        public void Messageboardschedule_CloseSiteInDB_CheckClosedInCSharp()
        {
            Console.WriteLine("TestCodeSignalSendToRecacheSiteListDataViaDotNet");
            // Get the current open and close times for the h2g2 site
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("frontpage?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now set the site to be closed
            Assert.IsTrue(SetSiteEmergencyClosed(true), "Failed to close h2g2");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "0");

            // Now check to make sure that the XML for the sitelist has not changed
            request.RequestPage("frontpage?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            // Now send the recache signal and check to make sure that the times are updated!
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");

                // Now check to make sure that the XML for the sitelist has not changed
                request.RequestPage("acs?skin=purexml");
                Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
                Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "1");

                // Now check to make sure that the XML for the sitelist has not changed
                request.RequestPage("frontpage?skin=purexml");
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
            request.RequestPage("frontpage?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");
        }

        /// <summary>
        /// Test that we can get the code to send the recache signal via the ripley application.
        /// This should send the request to the dot net application!
        /// </summary>
        [TestMethod]
        public void TestCodeSignalSendToRecacheSiteListDataViaRipley()
        {
            Console.WriteLine("TestCodeSignalSendToRecacheSiteListDataViaRipley");
            // Create the request for the test. Make sure we sign in as an editor
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.UseEditorAuthentication = true;
            request.SetCurrentUserEditor();
            //request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.EDITOR);

            // Get the current open and close times for the h2g2 site
            request.RequestPage("frontpage?skin=purexml");
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

            Thread.Sleep(5000);

            // Check to make sure that the dot net web app got the signal and that the xml reflects the fact!
            request.RequestPage("acs?skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE/SITECLOSED").InnerXml, "1");

            // Now send a request to the ripley code to open the site and make sure the xml reflects the fact
            request.RequestPage("messageboardschedule?action=opensite&confirm=1&skin=purexml");
            Assert.IsTrue(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED") != null);
            Assert.AreEqual(request.GetLastResponseAsXML().SelectSingleNode("/H2G2/SITE-CLOSED").InnerXml, "0");

            Thread.Sleep(5000);

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
            using (FullInputContext inputContext = new FullInputContext(""))
            {
                inputContext.SendSignal("action=recache-site");
            }
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

