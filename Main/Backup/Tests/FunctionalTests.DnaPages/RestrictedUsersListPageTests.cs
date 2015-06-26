using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Extensions.Asp;
using NUnit.Extensions.Asp.AspTester;
using NUnit.Extensions.Asp.HtmlTester;
using Tests;



namespace FunctionalTests
{
    /// <summary>
    /// Restricted Users List Page Tests
    /// </summary>
    [TestClass]
    public class RestrictedUsersListPageTests : WebFormTestCase
    {
        /// <summary>
        /// Setup for the tests
        /// </summary>
        protected override void SetUp()
        {
            base.SetUp();
        }

        /// <summary>
        /// Look at the Users Page.
        /// </summary>
        [TestMethod]
        public void Test01RestrictedUsersListPage()
        {
            try
            {
                DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
                Console.WriteLine("Before Test01RestrictedUsersListPage");
                dnaRequest.SetCurrentUserEditor();
                dnaRequest.UseEditorAuthentication = true;
                string relativePath = @"/dna/h2g2/RestrictedUsers";
                dnaRequest.RequestNUnitASPPage(relativePath, Browser);

                System.Threading.Thread.Sleep(2000);

                DropDownListTester siteList = new DropDownListTester("SiteList");
                Assert.AreEqual(siteList.Visible, true);
                siteList.Items.FindByText("All").Selected = true;

                DropDownListTester userStatusTypes = new DropDownListTester("UserStatusTypes");
                Assert.AreEqual(userStatusTypes.Visible, true);
                userStatusTypes.Items.FindByText("Premoderated").Selected = true;

                LabelTester error = new LabelTester("lblError");
                string errorText = error.Text;
                bool noError = true;
                if (errorText == "Insufficient permissions - Editor Status Required")
                {
                    noError = false;
                }

                Assert.IsTrue(noError, "Error in Restricted User Page.");

                Console.WriteLine("After Test01RestrictedUsersListPage");
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION");
                Console.WriteLine(ex.Message);
            }

        }

        /// <summary>
        /// Looks for the to see if there is an error with a normal user.
        /// </summary>
        [TestMethod]
        public void Test02RestrictedUsersListPageWithNormalUserErrorTest()
        {
            try
            {
                DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
                Console.WriteLine("Before Test02RestrictedUsersListPageWithNormalUserErrorTest");
                dnaRequest.SetCurrentUserNormal();
                dnaRequest.UseEditorAuthentication = true;
                string relativePath = @"/dna/h2g2/RestrictedUsers";
                dnaRequest.RequestNUnitASPPage(relativePath, Browser);

                System.Threading.Thread.Sleep(2000);

                LabelTester error = new LabelTester("lblError");
                string errorText = error.Text;
                bool isError = false;
                if (errorText == "Insufficient permissions - Editor Status Required")
                {
                    isError = true;
                }

                Assert.IsTrue(isError, "No Error for Normal user in Restricted User Page.");

                Console.WriteLine("After Test02RestrictedUsersListPageWithNormalUserErrorTest");
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION");
                Console.WriteLine(ex.Message);
            }
        }
        /// <summary>
        /// Trys to look for the Restricted Users list for the given user id in Restricted Users Page but finds no data.
        /// </summary>
        [TestMethod]
        public void Test03RestrictedUsersListSearchByAllEmailsPage()
        {
            try
            {
                DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
                Console.WriteLine("Before Test03RestrictedUsersListSearchByAllEmailsPage");
                dnaRequest.SetCurrentUserEditor();
                dnaRequest.UseEditorAuthentication = true;
                string relativePath = @"/dna/h2g2/RestrictedUsers";
                dnaRequest.RequestNUnitASPPage(relativePath, Browser);

                System.Threading.Thread.Sleep(2000);

                DropDownListTester siteList = new DropDownListTester("SiteList");
                Assert.AreEqual(siteList.Visible, true);
                siteList.Items.FindByText("All").Selected = true;

                DropDownListTester userStatusTypes = new DropDownListTester("UserStatusTypes");
                Assert.AreEqual(userStatusTypes.Visible, true);
                userStatusTypes.Items.FindByText("Both").Selected = true;

                ButtonTester btnAll = new ButtonTester("btnAll", CurrentWebForm);
                btnAll.Click();

                System.Threading.Thread.Sleep(5000);

                HtmlTableTester table = new HtmlTableTester("tblResults");

                bool isdata = true;
                if (table.BodyNoTags != "No data for those details")
                {
                    isdata = false;
                }

                Assert.IsTrue(isdata, "No data for All accounts is returned when there should be at least one.");
                Console.WriteLine("After Test03RestrictedUsersListSearchByAllEmailsPage");
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION");
                Console.WriteLine(ex.Message);
            }
        }
        /// <summary>
        /// Look at the sleected a begins with letter button.
        /// </summary>
        [TestMethod]
        public void Test04RestrictedUserListPageSearchByBeginsWithLetterTest()
        {
            try
            {
                DnaTestURLRequest dnaRequest = new DnaTestURLRequest("h2g2");
                Console.WriteLine("Before Test04RestrictedUserListPageSearchByBeginsWithLetterTest");
                dnaRequest.SetCurrentUserEditor();
                dnaRequest.UseEditorAuthentication = true;
                string relativePath = @"/dna/h2g2/RestrictedUsers";
                dnaRequest.RequestNUnitASPPage(relativePath, Browser);

                System.Threading.Thread.Sleep(2000);

                DropDownListTester siteList = new DropDownListTester("SiteList");
                Assert.AreEqual(siteList.Visible, true);
                siteList.Items.FindByText("All").Selected = true;

                DropDownListTester userStatusTypes = new DropDownListTester("UserStatusTypes");
                Assert.AreEqual(userStatusTypes.Visible, true);
                userStatusTypes.Items.FindByText("Both").Selected = true;

                Console.WriteLine("Before Button creation");
                ButtonTester btnD = new ButtonTester("btnD", CurrentWebForm);
                Console.WriteLine("Before Button click");
                btnD.Click();

                System.Threading.Thread.Sleep(2000);

                Console.WriteLine("Before get table");

                HtmlTableTester table = new HtmlTableTester("tblResults");

                bool isdata = true;
                if (table.BodyNoTags != "No data for those details")
                {
                    isdata = false;
                }

                Console.WriteLine("After get table");

                Assert.IsTrue(isdata, "No data for All accounts is returned when there should be at least one.");

                Console.WriteLine("After Test04RestrictedUserListPageSearchByBeginsWithLetterTest");
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION");
                Console.WriteLine(ex.Message);
            }
        }
        /// <summary>
        /// Look at the Users Page search by email.
        /// </summary>
        [TestMethod]
        public void Test05RestrictedUsersListSearchByMostRecentPage()
        {
            try
            {
                DnaTestURLRequest dnaRequest = new DnaTestURLRequest("haveyoursay");
                Console.WriteLine("Before Test05RestrictedUsersListSearchByMostRecentPage");
                dnaRequest.SetCurrentUserEditor();
                dnaRequest.UseEditorAuthentication = true;
                string relativePath = @"/dna/haveyoursay/RestrictedUsers";
                dnaRequest.RequestNUnitASPPage(relativePath, Browser);

                ButtonTester mostRecent = new ButtonTester("btnMostRecent", CurrentWebForm);
                mostRecent.Click();

                HtmlTableTester table = new HtmlTableTester("tblResults");

                bool isdata = true;
                if (table.BodyNoTags != "No data for those details")
                {
                    isdata = false;
                }

                Assert.IsTrue(isdata, "No data for Most Recent accounts is returned when there should be at least one.");

                Console.WriteLine("After Test05RestrictedUsersListSearchByMostRecentPage");
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION");
                Console.WriteLine(ex.Message);
            }
        }
        /// <summary>
        /// Look at the Users Page.
        /// </summary>
        [TestMethod]
        public void Test06RestrictedUsersListNonEditorPage()
        {
            try
            {
                DnaTestURLRequest dnaRequest = new DnaTestURLRequest("haveyoursay");
                Console.WriteLine("Before Test06RestrictedUsersListNonEditorPage");
                dnaRequest.SetCurrentUserNormal();
                dnaRequest.UseEditorAuthentication = true;
                string relativePath = @"/dna/haveyoursay/RestrictedUsers";
                dnaRequest.RequestNUnitASPPage(relativePath, Browser);

                LabelTester error = new LabelTester("lblError");
                string errorText = error.Text;
                bool isError = false;
                if (errorText == "Insufficient permissions - Editor Status Required")
                {
                    isError = true;
                }

                Assert.IsTrue(isError, "Error in permissions for Restricted User Page.");

                Console.WriteLine("After Test06RestrictedUsersListNonEditorPage");
            }
            catch (Exception ex)
            {
                Console.WriteLine("EXCEPTION");
                Console.WriteLine(ex.Message);
            }
        }
    }
}
