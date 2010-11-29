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
		
        // assumes that mbarchers does not have the search site option set
		[TestMethod]
		public void ThreadSearch_NoSiteOption_GoodMessageNoMatches()
		{
	        selenium.Open("/dna/mbarchers/searchposts");

            Assert.IsFalse(selenium.IsTextPresent("Search has not been configured for this application."));
		}


        //Not sure if this one will work, can type do a null string?
        // curently it will fail because it does not produce the standard 'none found' message
        [TestMethod]
        public void ThreadSearch_NoSearchTerm_GoodMessageNoMatches()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_MessageNoItems();
        }

        [TestMethod]
        public void ThreadSearch_NoMatchingTerm_GoodMessageNoMatches()
		{
		    selenium.Open("/dna/mbiplayer/searchposts");
		    selenium.Type("searchtext", "noresults");
		    selenium.Click("//input[@value='Search']");
		    selenium.WaitForPageToLoad("30000");

            validate_MessageNoItems();
		}

        [TestMethod]
        public void ThreadSearch_JunkTermLowerCase_GoodMessageNoMatches()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "and");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_MessageNoItems();
        }

        [TestMethod]
        public void ThreadSearch_JunkTermUpperCase_GoodMessageNoMatches()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "ALSO");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_MessageNoItems();
        }

        [TestMethod]
        public void ThreadSearch_MultipleJunkTerms_GoodMessageNoMatches()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "both between and before");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_MessageNoItems();
        }

        [TestMethod]
        public void ThreadSearch_MatchingTerm_NoMessageSomeMatches()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "radio");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");
        }

        [TestMethod]
        public void ThreadSearch_JunkAndMatching_NoMessageSomeMatchesGoodHighlight()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "each radio has music");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");
            validate_MatchHighlight("music");
            validate_NoMatchHighlight("each");
            validate_NoMatchHighlight("has");
        }

        // the unit test is bit of dodgy char testing so just really need to check it E2E
        [TestMethod]
        public void ThreadSearch_MatchingTermBadChars_NoMessageSomeMatches()
        {
            selenium.Open("/dna/mbiplayer/searchposts");
            selenium.Type("searchtext", "\"radio & music\"");
            selenium.Click("//input[@value='Search']");
            selenium.WaitForPageToLoad("30000");

            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");
            validate_MatchHighlight("music");
            validate_NoMatchHighlight("&");
        }

        // Assumes that the search term pulls back more than 1 page so that previous from last will not get you back to first and next after first does not get you to last
        [TestMethod]
		public void ThreadSearch_MultipleMatches_PaginatesCorrectly()
		{
		
            selenium.Open("/dna/mbiplayer/searchposts");		
            selenium.Type("searchtext", "radio");
		    selenium.Click("//input[@value='Search']");
		    selenium.WaitForPageToLoad("30000");

            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // at first, the first and previous should be present and not be links. Can't be certain how many pages we have, at least 2
            validate_ItemPresent("//ul[@class='pagination']/li[1]", "First", false);
            validate_ItemPresent("//ul[@class='pagination']/li[2]", "« Previous", false);

            validate_ItemPresent("//ul[@class='pagination']/li[3]", "1", true);
            validate_ItemMarkedCurrent("//ul[@class='pagination']//li[3][@class='current']", true);

            validate_ItemPresent("//ul[@class='pagination']/li[4]", "2", true);
            validate_ItemMarkedCurrent("//ul[@class='pagination']//li[4][@class='current']", false);

            validate_ItemPresent("//ul[@class='pagination']//li", "Next »", true);
            validate_ItemPresent("//ul[@class='pagination']//li", "Last", true);


            selenium.Click("link=Next »");
            selenium.WaitForPageToLoad("30000");

            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // ensure that pages other than the first contain interesting stuff
            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");

            // first and previous should now have links
            validate_ItemPresent("//ul[@class='pagination']/li[1]", "First", true);
            validate_ItemPresent("//ul[@class='pagination']/li[2]", "« Previous", true);

            validate_ItemMarkedCurrent("//ul[@class='pagination']//li[3][@class='current']", false); // was true
            validate_ItemMarkedCurrent("//ul[@class='pagination']//li[4][@class='current']", true); // was false


            selenium.Click("link=« Previous");
		    selenium.WaitForPageToLoad("30000");

            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // ensure that pages other than the first contain interesting stuff
            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");

            // next and last should retain their links
            validate_ItemPresent("//ul[@class='pagination']//li", "Next »", true);
            validate_ItemPresent("//ul[@class='pagination']//li", "Last", true);

            // first and previous should retain their links because we have more than 1 page
            validate_ItemPresent("//ul[@class='pagination']/li[1]", "First", true);
            validate_ItemPresent("//ul[@class='pagination']/li[2]", "« Previous", true);


            selenium.Click("link=Last");
		    selenium.WaitForPageToLoad("30000");

            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // ensure that pages other than the first contain interesting stuff
            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");

            // next and last should lose their links
            validate_ItemPresent("//ul[@class='pagination']//li", "Next »", false);
            validate_ItemPresent("//ul[@class='pagination']//li", "Last", false);

            // first and previous should retain their links
            validate_ItemPresent("//ul[@class='pagination']/li[1]", "First", true);
            validate_ItemPresent("//ul[@class='pagination']/li[2]", "« Previous", true);


		    selenium.Click("link=First");
		    selenium.WaitForPageToLoad("30000");

            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // ensure that we have actaully come back to a sueful page - could compare the first item here with the first item before but it is too complicated and liable to break
            validate_NoMessageSomeItems();
            validate_MatchHighlight("radio");

            // next and last should regain lose their links
            validate_ItemPresent("//ul[@class='pagination']//li", "Next »", true);
            validate_ItemPresent("//ul[@class='pagination']//li", "Last", true);

            // first and previous should lose their links
            validate_ItemPresent("//ul[@class='pagination']/li[1]", "First", false);
            validate_ItemPresent("//ul[@class='pagination']/li[2]", "« Previous", false);
		}

        private void validate_NoMessageSomeItems()
        {
            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // verify that we do not have the 'not found' message
            try
            {
                Assert.IsFalse(selenium.IsTextPresent("No results found, please refine your search."));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
            // verify that there is at least one item in the list
            try
            {
                Assert.IsTrue(selenium.IsElementPresent("//ul[@id='topofthreads']/li"));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
        }

        private void validate_MessageNoItems()
        {
            // if not on this page, no point in checking the rest
            Assert.AreEqual("BBC - BBC iPlayer Messageboard - Search results", selenium.GetTitle());

            // verify, i.e. don't crash we have the 'not found' message
            try
            {
                Assert.IsTrue(selenium.IsTextPresent("No results found, please refine your search."));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
            // verify that we do not have any items in the list of found posts
            try
            {
                Assert.IsFalse(selenium.IsElementPresent("//ul[@id='topofthreads']/li"));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
        }

        // look for a span
        private void validate_MatchHighlight()
        {
            try
            {
                Assert.IsTrue(selenium.IsElementPresent("//span[@class='searchresult']"));

            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
        }

        // look for an span that containse the given text
        private void validate_MatchHighlight(string matched)
        {
            try
            {
                Assert.IsTrue(selenium.IsElementPresent("span[@class='searchresult'][contains(text(),'" + matched + "')]"));

            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
        }

        //Make sure that there is no span over the given text
        private void validate_NoMatchHighlight(string matched)
        {
            validate_MatchHighlight();
            try
            {
                Assert.IsFalse(selenium.IsElementPresent("span[@class='searchresult'][contains(text(),'" + matched + "')]"));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
        }

        private void validate_ItemPresent(string path, string text, boolean asLink)
        {
            try
            {
                Assert.AreEqual(text, selenium.GetText(path + "/span"));
            }
            catch (AssertionException e)
            {
                verificationErrors.Append(e.Message);
            }

            try
            {
                if( asLink )
                    Assert.IsTrue(selenium.IsElementPresent(path + "/a"));
                else
                    Assert.IsFalse(selenium.IsElementPresent(path + "/a"));
            }
            catch (AssertionException e)
            {
                verificationErrors.Append(e.Message);
            }
        }

        private void validate_ItemMarkedCurrent(string path, boolean isCurrent)
        {
            try
            {
                if( isCurrent)
                    Assert.IsTrue(selenium.IsElementPresent(path));
                else
                    Assert.IsFalse(selenium.IsElementPresent(path));
            }
            catch (AssertionException e)
            {
                verificationErrors.Append(e.Message);
            }
    }

}