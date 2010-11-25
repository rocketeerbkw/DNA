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
    public class CustomBarlesque : SeleniumTestHarness
    {
        private ISelenium selenium;
        private StringBuilder verificationErrors;

        string stateOfOption = "0";  // default value of off
        string valueOfOption = string.Empty; // empty string

        [ClassInitialize]
        public void SetupClass()
        {
            base.StartServer();
            selenium = new DefaultSelenium("localhost", 4444, "*chrome", ConfigurationManager.AppSettings["baseUrl"]);
            selenium.Start();
            verificationErrors = new StringBuilder();

            selenium.DeleteAllVisibleCookies();

            selenium.Open("/dna/mbfood/");
            // To Do
            // too general, could crash test if a topic happened to have the wrong name 
            Assert.IsFalse(selenium.IsTextPresent("error"));
            Assert.IsFalse(selenium.IsTextPresent("There has been a problem"));

            selenium.Click("link=Sign in");
            selenium.Click("bbcid_username");
            selenium.Type("bbcid_username", "mpgsuper");
            selenium.Type("bbcid_password", "ratbags");
            selenium.Click("signin");
            selenium.WaitForPageToLoad("30000");

            // going this way so as to be certain to get the right site options without thinking about it
            selenium.Click("link=Site Options");
            selenium.WaitForPageToLoad("30000");

            // check a) where we are b) BBC site requirements for page titles https://confluence.dev.bbc.co.uk/display/DNA/Meta+Data - note that this title breaks those guidelines
            Assert.AreEqual("BBC - Food - DNA Administration - Site Options - Food", selenium.GetTitle());
            Assert.IsTrue(selenium.IsElementPresent("//input[@name='sov_49_General_CustomBarlesquePath']");

            stateOfOption = selenium.GetValue("//input[@name='so_49_General_CustomBarlesquePath' and @type='radio' and @checked='']/@value");
            valueOfOption = selenium.GetValue("//input[@name='so_49_General_CustomBarlesquePath' and @type='text']");
        }

        [ClassCleanup]
        public void TeardownClass()
        {
            try
            {
                selenium.Open("/dna/mbfood/boards-admin/siteoptions");

                Assert.AreEqual("BBC - Food - DNA Administration - Site Options - Food", selenium.GetTitle());

                selenium.Click("//input[@name='so_49_General_CustomBarlesquePath' and @value='" + stateOfOption + "' and @type='radio']");
                selenium.Type("sov_49_General_CustomBarlesquePath", valueOfOption);
                selenium.Click("cmd");

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
        public void CustomBarlesque_OptionOff_StandardLinksNoScope()
        {
            helper_setOption("0", "");

            helper_goAndcheckPage("iPlayer", "TV", false, "");
        }

        [TestMethod]
        public void CustomBarlesque_cbbcOption_CbbcLinksCbbcScope()
        {
            helper_setOption("1", "var=&quot;blq_variant&quot; value=&quot;cbbc&quot; | var=&quot;blq_search_scope&quot; value=&quot;cbbc&quot;");

            helper_goAndcheckPage("CBBC iPlayer", "CBBC on TV", true, "cbbc");
        }


        [TestMethod]
        public void CustomBarlesque_cbeebOption_CbeebLinksCbeebScope()
        {
            helper_setOption("1", "var=&quot;blq_variant&quot; value=&quot;cbeebies&quot; | var=&quot;blq_search_scope&quot; value=&quot;cbeebies&quot;");

            helper_goAndcheckPage("CBeebies iPlayer", "TV", true, "cbeebies");
        }

        [TestMethod]
        public void CustomBarlesque_otherOption_StandardLinksOtherScope()
        {
            helper_setOption("1", "var=&quot;blq_variant&quot; value=&quot;cabbages&quot; | var=&quot;blq_search_scope&quot; value=&quot;kings&quot;");

            helper_goAndcheckPage("iPlayer", "TV", true, "kings");
        }

        // Helper functions
        private void helper_setOption(string OptionState, string OptionValue)
        {
            selenium.Open("/dna/mbfood/boards-admin/siteoptions");

            Assert.AreEqual("BBC - Food - DNA Administration - Site Options - Food", selenium.GetTitle());
            
            selenium.Click("//input[@name='so_49_General_CustomBarlesquePath' and @value='0' and @type='radio']");
            selenium.Click("cmd");
            selenium.WaitForPageToLoad("30000");
        }

        private void helper_goAndcheckPage(string iPlayerLink, string TvLink, boolean scopeOn, boolean scopeValue)
        {

            selenium.Open("/dna/mbfood/NF8650210");

            Assert.AreEqual("BBC - CBBC messageboards - Home", selenium.GetTitle());
            // To Do
            // These need to be more specific in where they may be found they are far too general and could cause it to crash for no good reason
            Assert.IsFalse(selenium.IsTextPresent("error"));
            Assert.IsFalse(selenium.IsTextPresent("There has been a problem"));
            
            try
            {
                Assert.IsTrue(selenium.IsElementPresent("//ul[@id='blq-nav-main']//a[contains(text(),'" + iPlayerLink + "')]"));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);
            }
            try
            {
                Assert.IsTrue(selenium.IsElementPresent("//ul[@id='blq-nav-main']//a[contains(text(),'" + TvLink + "')]"));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);

            }
            try
            {
                if( scopeOn )
                    Assert.IsTrue(selenium.IsElementPresent("//input[@name='scope'][@value='" + scopeValue + "']"));
                else
                    Assert.IsFalse(selenium.IsElementPresent("//input[@name='scope']"));
            }
            catch (Exception e)
            {
                verificationErrors.Append(e.Message);

            }
        }


    }

    
}
