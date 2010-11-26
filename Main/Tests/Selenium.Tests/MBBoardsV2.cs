using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Selenium;
using System.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Tests;

namespace Selenium.Tests
{
	[TestClass]
	public class MBBoardsV2: SeleniumTestHarness
	{
		private ISelenium selenium;
		private StringBuilder verificationErrors;
		
		[TestInitialize]
		public void SetupTest()
		{
			base.StartServer();
			selenium = new DefaultSelenium("localhost", 4444, "*chrome", ConfigurationManager.AppSettings["baseUrl"]);
			selenium.Start();
			verificationErrors = new StringBuilder();
		}
		
		[TestCleanup]
		public void TeardownTest()
		{
			try
			{
				selenium.Stop();
			}
			catch (Exception)
			{
				// Ignore errors if unable to close the browser
			}
			base.StopServer();
			Assert.AreEqual("", verificationErrors.ToString());
		}
		
		[TestMethod]
        public void MBBoardsV2_CorrectTitle_ReturnsCorrectTitle()
        {
            selenium.Open("/dna/mbfood/");
            Assert.AreEqual("BBC - Food Messageboard - Home", selenium.GetTitle());
            Assert.IsTrue(selenium.IsTextPresent("Recent Discussions"));
            Assert.IsTrue(selenium.IsTextPresent("Sign in"));
        }


        [TestMethod]
        public void MBBoardsV2_ThreadingPagination_ReturnsPages()
        {
            selenium.Open("/dna/mbfood/NF8650210");
            selenium.Click("link=Next »");
            selenium.WaitForPageToLoad("30000");
            selenium.Click("link=« Previous");
            selenium.WaitForPageToLoad("30000");
            selenium.Click("link=Last");
            selenium.WaitForPageToLoad("30000");
            selenium.Click("link=First");
            selenium.WaitForPageToLoad("30000");
        }

        [TestMethod]
        public void MBBoardsV2_LogAdminUserIn_ReturnsCorrectLinks()
        {
            selenium.Open("/dna/mbfood/");
            Assert.AreEqual("BBC - Food Messageboard - Home", selenium.GetTitle());
            Assert.IsTrue(selenium.IsTextPresent("Recent Discussions"));
            Assert.IsTrue(selenium.IsTextPresent("Sign in"));
            selenium.Click("link=Sign in");
            selenium.WaitForPageToLoad("30000");
            selenium.Click("bbcid_username");
            selenium.Type("bbcid_username", "marcusparnwell");
            selenium.Type("bbcid_password", "password123");
            selenium.Click("signin");
            selenium.WaitForPageToLoad("30000");
            Assert.IsTrue(selenium.IsTextPresent("Messageboard Admin"));
            Assert.IsFalse(selenium.IsTextPresent("Sign in"));
        }

	}
}
