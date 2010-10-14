using System;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Selenium;
using System.Configuration;
using TestUtils;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Tests;

namespace Selenium.Tests
{
	[TestClass]
	public class ThreadSearch : SeleniumTestHarness
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
		public void ThreadSearch_NoSiteOption_ReturnsCorrectErrorCode()
		{
	        selenium.Open("/dna/mbarchers/searchposts");
		    Assert.IsTrue(selenium.IsTextPresent("There has been a problem"));
		    Assert.IsTrue(selenium.IsTextPresent("Search has not been configured for this application."));
    			
		}

		[TestMethod]
		public void ThreadSearch_NoSearchResults_ReturnsCorrectErrorCode()
		{
		    selenium.Open("/dna/mbiplayer/searchposts");
		    selenium.Type("searchtext", "noresults");
		    selenium.Click("//input[@value='Go']");
		    selenium.WaitForPageToLoad("30000");
		    Assert.IsTrue(selenium.IsTextPresent("There has been a problem"));
		    Assert.IsTrue(selenium.IsTextPresent("No results found, please refine your search."));

		}

		[TestMethod]
		public void ThreadSearch_WithSearchResults_ReturnsCorrectResults()
		{
            selenium.Open("/dna/mbiplayer/searchposts");		
            selenium.Type("searchtext", "radio");
		    selenium.Click("//input[@value='Go']");
		    selenium.WaitForPageToLoad("30000");
    		
		    Assert.IsTrue(selenium.IsTextPresent("5"));
		

		}

        [TestMethod]
		public void ThreadSearch_WithSearchResultsPagination_ReturnsCorrectResults()
		{
		
            selenium.Open("/dna/mbiplayer/searchposts");		
            selenium.Type("searchtext", "radio");
		    selenium.Click("//input[@value='Go']");
		    selenium.WaitForPageToLoad("30000");
    		
		    Assert.IsTrue(selenium.IsTextPresent("5"));
            selenium.Click("link=Last");
		    selenium.WaitForPageToLoad("30000");
		    selenium.Click("link=First");
		    selenium.WaitForPageToLoad("30000");
		    selenium.Click("link=Next »");
		    selenium.WaitForPageToLoad("30000");
		    selenium.Click("link=« Previous");
		    selenium.WaitForPageToLoad("30000");
		

		}

	}

}
