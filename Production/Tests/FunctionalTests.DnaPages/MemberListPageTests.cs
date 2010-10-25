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
    /// MemberListTests
    /// </summary>
    [TestClass]
    public class MemberListPageTests : WebFormTestCase 
    {
        DnaTestURLRequest _dnarequest = new DnaTestURLRequest("haveyoursay");

        int testSuperUserID = 1090558354;
        int testWrongUserID = 666;

        public MemberListPageTests() : base()
        {
            MasterSetUp();
        }

        protected override void SetUp() 
        {
            base.SetUp();
        }

        /// <summary>
        /// Look at the Users Page.
        /// </summary>
        [TestMethod]
        public void Test01MemberListPage()
        {
            Console.WriteLine("Before Test01MemberListPage");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester entry = new TextBoxTester("txtEntry", CurrentWebForm);
            Assert.AreEqual(entry.Visible, true);
            entry.Text = "1090558354";

            RadioButtonListTester radiolist = new RadioButtonListTester("rdSearchType");
            Assert.AreEqual(radiolist.Visible, true);
            radiolist.SelectedIndex = 0;

            ButtonTester search = new ButtonTester("Search", CurrentWebForm);

            LabelTester err = new LabelTester("lblError",CurrentWebForm);
            Assert.AreNotEqual("Insufficient permissions - Editor Status Required", err.Text);

            Console.WriteLine("After Test01MemberListPage");
        }

        /// <summary>
        /// Looks for the member list for the given user id in Member List Page.
        /// </summary>
        [TestMethod]
        public void Test02MemberListPageWithUserID()
        {
            Console.WriteLine("Before Test02MemberListPageWithUserID");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList?userid=" + testSuperUserID.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            HtmlTableTester table = new HtmlTableTester("tblResults");

            bool found = false;
            HtmlTagTester htmltag = (HtmlTagTester) table.Rows[1].Children("td").GetValue(1);
            string userID = htmltag.InnerHtml;

            if (userID == testSuperUserID.ToString())
            {
                found = true;
            }
                /*string[] cells = row.TrimmedCells;
                if (cells[1] == userID)
                {
                    //List Created OK 
                    found = true;
                    break;
                }*/

            Assert.IsTrue(!found, "User " + testSuperUserID.ToString() + ": Not returned and displayed in Member List Page.");
            Console.WriteLine("After Test02MemberListPageWithUserID");
        }
        /// <summary>
        /// Trys to look for the member list for the given user id in Member List Page but finds no data.
        /// </summary>
        [TestMethod]
        public void Test03MemberListPageWithWrongUserID()
        {
            Console.WriteLine("Before Test03MemberListPageWithWrongUserID");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList?userid=" + testWrongUserID.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            HtmlTableTester table = new HtmlTableTester("tblResults");

            bool nodata = false;
            if (table.BodyNoTags == "No data for those details")
            {
                nodata = true;
            }

            Assert.IsTrue(nodata, "User " + testWrongUserID.ToString() + ": Is returned and displayed in Member List Page when it shouldn't be.");
            Console.WriteLine("After Test03MemberListPageWithWrongUserID");
        }
        /// <summary>
        /// Look at the Users Page search by username.
        /// </summary>
        [TestMethod]
        public void Test04MemberListSearchByUsernamePage()
        {
            Console.WriteLine("Before Test04MemberListSearchByUsernamePage");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
            CurrentWebForm.Variables.Add("d_identityuserid", "dotneteditor");

            TextBoxTester entry = new TextBoxTester("txtEntry", CurrentWebForm);
            Assert.AreEqual(entry.Visible, true);
            entry.Text = "DotNetSuperUser";

            RadioButtonListTester radiolist = new RadioButtonListTester("rdSearchType", CurrentWebForm);
            Assert.AreEqual(radiolist.Visible, true);

            int index = GetSelectedIndex(radiolist, "User Name"); 
            
            radiolist.SelectedIndex = index;

            ButtonTester search = new ButtonTester("Search", CurrentWebForm);
            search.Click();

            HtmlTableTester table = new HtmlTableTester("tblResults");

            bool found = false;

            if (table.BodyNoTags != "No data for those details")
            {

                HtmlTagTester htmltag = (HtmlTagTester)table.Rows[1].Children("td").GetValue(1);
                string userID = htmltag.InnerHtml;

                string testSuperUserIDLink = "<a href=\"/dna/moderation/MemberDetails?userid=" + testSuperUserID.ToString() + "\">U" + testSuperUserID.ToString() + "</a>";

                if (userID == testSuperUserIDLink)
                {
                    found = true;
                }

                Assert.IsTrue(found, "User " + testSuperUserID.ToString() + ": Not returned and displayed in Member List Page.");
            }
            else
            {
                Assert.IsTrue(false, "Error no results returned.");
            }
            Console.WriteLine("After Test04MemberListSearchByUsernamePage");
        }

        private static int GetSelectedIndex(RadioButtonListTester radiolist, string itemName)
        {
            int index = -1;
            for (int i = 0; i < radiolist.Count; i++)
            {
                if (radiolist.List[i] == itemName)
                {
                    index = i;
                    break;
                }
            }

            return index;
        }
        /// <summary>
        /// Look at the Users Page search by email.
        /// </summary>
        [TestMethod]
        public void Test05MemberListSearchByEmailPage()
        {
            Console.WriteLine("Before Test05MemberListSearchByEmailPage");
            _dnarequest.SetCurrentUserEditor();
            
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
            CurrentWebForm.Variables.Add("d_identityuserid", "dotneteditor");

            TextBoxTester entry = new TextBoxTester("txtEntry", CurrentWebForm);
            Assert.AreEqual(entry.Visible, true);
            entry.Text = "mark.howitt@bbc.co.uk";

            RadioButtonListTester radiolist = new RadioButtonListTester("rdSearchType", CurrentWebForm);
            Assert.AreEqual(radiolist.Visible, true);
            
            int index = GetSelectedIndex(radiolist, "Email");

            radiolist.SelectedIndex = index;

            ButtonTester search = new ButtonTester("Search", CurrentWebForm);
            search.Click();

            HtmlTableTester table = new HtmlTableTester("tblResults");

            bool found = false;
            if (table.BodyNoTags != "No data for those details")
            {
                for (int i = 1; i < table.Rows.Length; i++)
                {
                    HtmlTagTester htmltag = (HtmlTagTester)table.Rows[i].Children("td").GetValue(1);
                    string userID = htmltag.InnerHtml;

                    string testSuperUserIDLink = "<a href=\"/dna/moderation/MemberDetails?userid=" + testSuperUserID.ToString() + "\">U" + testSuperUserID.ToString() + "</a>";

                    if (userID == testSuperUserIDLink)
                    {
                        found = true;
                    }
                }
                Assert.IsTrue(found, "User " + testSuperUserID.ToString() + ": Not returned and displayed in Member List Page.");
            }
            else
            {
                Assert.IsTrue(false, "Error no results returned.");
            }
 
            Console.WriteLine("After Test05MemberListSearchByEmailPage");
        }
        /// <summary>
        /// Look at the Users Page.
        /// </summary>
        [TestMethod]
        public void Test06MemberListNonEditorPage()
        {
            Console.WriteLine("Before Test06MemberListNonEditorPage");
            _dnarequest.SetCurrentUserNormal();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            LabelTester error = new LabelTester("lblError");
            string errorText = error.Text;
            bool isError = false;
            if (errorText == "Insufficient permissions - Editor Status Required")
            {
                isError = true;
            }

            Assert.IsTrue(isError, "Error in Member List Page.");

            Console.WriteLine("After Test06MemberListNonEditorPage");
        }
        /// <summary>
        /// Look at the Users Page search by IPAddress.
        /// </summary>
        [TestMethod]
        public void Test07MemberListSearchByIPAddressPage()
        {
            Console.WriteLine("Before Test07MemberListSearchByIPAddressPage");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester entry = new TextBoxTester("txtEntry", CurrentWebForm);
            Assert.AreEqual(entry.Visible, true);
            entry.Text = "12.34.56.78";

            RadioButtonListTester radiolist = new RadioButtonListTester("rdSearchType", CurrentWebForm);
            Assert.AreEqual(radiolist.Visible, true);

            int index = GetSelectedIndex(radiolist, "IP Address");

            radiolist.SelectedIndex = index;

            ButtonTester search = new ButtonTester("Search", CurrentWebForm);
            search.Click();

            Console.WriteLine("After Test07MemberListSearchByIPAddressPage");
        }
        /// <summary>
        /// Look at the Users Page search by BBCUID.
        /// </summary>
        [TestMethod]
        public void Test08MemberListSearchByBBCUIDPage()
        {
            Console.WriteLine("Before Test08MemberListSearchByBBCUIDPage");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/MemberList";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester entry = new TextBoxTester("txtEntry", CurrentWebForm);
            Assert.AreEqual(entry.Visible, true);
            entry.Text = "47C7CDBE-9D79-1517-50CA-0003BA0B17ED";

            RadioButtonListTester radiolist = new RadioButtonListTester("rdSearchType", CurrentWebForm);
            Assert.AreEqual(radiolist.Visible, true);

            int index = GetSelectedIndex(radiolist, "BBCUID");

            radiolist.SelectedIndex = index;

            ButtonTester search = new ButtonTester("Search", CurrentWebForm);
            search.Click();

            Console.WriteLine("After Test08MemberListSearchByBBCUIDPage");
        }
    }
}
