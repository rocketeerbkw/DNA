using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using NUnit.Extensions.Asp;
using NUnit.Extensions.Asp.AspTester;
using NUnit.Extensions.Asp.HtmlTester;
using Tests;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace FunctionalTests
{
    /// <summary>
    /// DynamicListTests
    /// </summary>
    [TestClass]
    public class DynamicListsTests : WebFormTestCase 
    {

        public DynamicListsTests() : base()
        {
            MasterSetUp();
        }

        Dictionary<int, string> _dynamicLists = new Dictionary<int, string>();

        DnaTestURLRequest _dnarequest = new DnaTestURLRequest("haveyoursay");

        /// <summary>
        /// 
        /// </summary>
        protected override void SetUp() 
        {
            base.SetUp();
        }

        /// <summary>
        /// Remove Dynamic Lists created during test run.
        /// Will  Deactivate and Delete any Dynamic Lists.
        /// </summary>
        [TestCleanup]
        public void DeleteDynamicLists()
        {
            foreach ( KeyValuePair<int,string> dlist in _dynamicLists )
            {
                //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
                _dnarequest.SetCurrentUserEditor();
                _dnarequest.UseEditorAuthentication = true;
                
                //DeActivate ( Unpublish )  Dynamic List.
                string relativePath = @"/dna/haveyoursay/DynamicListAdmin?deactivateid=" + dlist.Key.ToString();
                _dnarequest.RequestNUnitASPPage(relativePath, Browser);

                //Delete Dynamic List Definition.
                relativePath = @"/dna/haveyoursay/DynamicListAdmin?deleteid=" + dlist.Key.ToString();
                _dnarequest.RequestNUnitASPPage(relativePath, Browser);
            }
        }

        /// <summary>
        /// Create Dynamic List.
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForArticles()
        {
            Console.WriteLine("TestDynamicListDefinitionForArticles");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
           
            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForArticle";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("ARTICLES");
            item.Selected = true;

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForArticle");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForArticle", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForArticle");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForArticle.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForArticle", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

        }

        /// <summary>
        /// Creates Dynamic List for Threads
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForThreads()
        {
            Console.WriteLine("TestDynamicListDefinitionForThreads");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForThreads";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("THREADS");
            item.Selected = true;

            TextBoxTester createddate = new TextBoxTester("txtDateCreated", CurrentWebForm);
            createddate.Text = "365";

            TextBoxTester lastupdateddate = new TextBoxTester("txtLastUpdated", CurrentWebForm);
            lastupdateddate.Text = "365";

            TextBoxTester threadtype = new TextBoxTester("txtThreadType", CurrentWebForm);
            threadtype.Text = "1";

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForThreads");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForThreads", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForThreads");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForThreads.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForThreads", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Creates a Dynamic List Defintion or a list of forum type.
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForForums()
        {
            Console.WriteLine("TestDynamicListDefinitionForForums");
            DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForForums";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("FORUMS");
            item.Selected = true;

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForForums");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForForums", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForForums");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForForums.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForForums", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Creates a Dynamic List of Club Type.
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForClubs()
        {
            Console.WriteLine("TestDynamicListDefinitionForClubs");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForClubs";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("CLUBS");
            item.Selected = true;

            TextBoxTester createddate = new TextBoxTester("txtDateCreated", CurrentWebForm);
            createddate.Text = "365";

            TextBoxTester lastupdateddate = new TextBoxTester("txtLastUpdated", CurrentWebForm);
            lastupdateddate.Text = "365";

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForClubs");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForClubs", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForClubs");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForClubs.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForClubs", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Creates a dynamic list of user type.
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForUsers()
        {
            Console.WriteLine("TestDynamicListDefinitionForUsers");
            DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForUsers";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("USERS");
            item.Selected = true;

            TextBoxTester created = new TextBoxTester("txtDateCreated", CurrentWebForm);
            created.Text = "365";

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForUsers");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForUsers", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForUsers");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForUsers.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForUsers", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Creates a Dynamic List of Category type.
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForCategories()
        {
            Console.WriteLine("TestDynamicListDefinitionForCategories");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForCategories";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("CATEGORIES");
            item.Selected = true;

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForCategories");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForCategories", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForCategories");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForCategories.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath,Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForCategories", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Creates a Dynamic List Definition for Topics
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForTopics()
        {
            Console.WriteLine("TestDynamicListDefinitionForTopics");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForTopics";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("TOPICFORUMS");
            item.Selected = true;

            //Create Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForTopics");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForTopics", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForTopics");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForTopics.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForTopics", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Creates a Dyanmic List Definition for Campaign Diary Entries
        /// </summary>
        [TestMethod]
        public void TestDynamicListDefinitionForCampaignDiaryEntries()
        {
            Console.WriteLine("TestDynamicListDefinitionForCampaignDiaryEntries");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/EditDynamicListDefinition";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester name = new TextBoxTester("txtName", CurrentWebForm);
            name.Text = "DynamicListForCampaignDiaryEntries";

            DropDownListTester type = new DropDownListTester("cmbType", CurrentWebForm);
            ListItemTester item = type.Items.FindByValue("CAMPAIGNDIARYENTRIES");
            item.Selected = true;

            TextBoxTester eventdate = new TextBoxTester("txtEventDate", CurrentWebForm);
            eventdate.Text = "365";

            TextBoxTester threadtype = new TextBoxTester("txtThreadType", CurrentWebForm);
            threadtype.Text = "1";

            // Dynamic List Definiton by clicking update.
            ButtonTester update = new ButtonTester("btnUpdate", CurrentWebForm);
            update.Click();

            testDynamicListAdmin("DynamicListForCampaignDiaryEntries");

            string xml;
            int id = 0;
            getDynamicListDefinitionXML("DynamicListForCampaignDiaryEntries", out xml, out id);
            if (id > 0)
            {
                _dynamicLists.Add(id, "DynamicListForCampaignDiaryEntries");
            }

            //Validate the Dynamic list Definition Xml.
            DnaXmlValidator validator = new DnaXmlValidator(xml, "DynamicListForCampaignDiaries.xsd");
            validator.Validate();

            //Bring up the edit page and check it displays the list.
            relativePath = @"/dna/haveyoursay/EditDynamicListDefinition?id=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            TextBoxTester checkname = new TextBoxTester("txtName", CurrentWebForm);
            string dlistname = checkname.Text;
            Assert.AreEqual(dlistname, "DynamicListForCampaignDiaryEntries", "Name does not match");

            //Publish the Dynamic List.
            relativePath = @"/dna/haveyoursay/DynamicListAdmin?activateid=" + id.ToString();
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);
        }

        /// <summary>
        /// Examine the Dynamic Lists XML of the Dynamic Lists produced in the previous tests.
        /// </summary>
        [Ignore]
        public void testPublishedDynamicListsXML()
        {
            //Publish the Dynamic List.
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.RequestPage("?_dl=1&Skin=purexml");
            XmlDocument xml = request.GetLastResponseAsXML();
            foreach( KeyValuePair<int,string> dlist in _dynamicLists )
            {
                //Verify Existence of Dynamic List in final XML.
                XmlNode name = xml.SelectSingleNode("H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='" + dlist.Value + "']");
                Assert.IsNotNull(name,"Unable to find Dynamic List Name " + dlist.Value + " in published Dynamic Lists XML.");
            }
        }

        /// <summary>
        /// Looks for the given list name in Dynamic List Admin page.
        /// </summary>
        /// <param name="listName">Name of List</param>
        /// <returns></returns>
        private bool testDynamicListAdmin(string listName)
        {
            Console.WriteLine("testDynamicListAdmin");
            //DnaTestURLRequest dnarequest = new DnaTestURLRequest("haveyoursay");
            _dnarequest.SetCurrentUserEditor();
            _dnarequest.UseEditorAuthentication = true;
            string relativePath = @"/dna/haveyoursay/DynamicListAdmin";
            _dnarequest.RequestNUnitASPPage(relativePath, Browser);

            DataGridTester table = new DataGridTester("tblDynamicLists", CurrentWebForm);
            bool found = false;
            for (int i = 0; i < table.RowCount; ++i)
            {
                DataGridTester.Row row = table.GetRow(i);
                string[] cells = row.TrimmedCells;
                if (cells[0] == listName)
                {
                    //List Created OK 
                    found = true;
                    break;
                }
            }

            Assert.IsTrue(found, "DynamicList has not been created and displayed in DynamicListAdmin.");
            return found;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="name">Name of List to get XML</param>
        /// <param name="xml">dynamic list defintion xml</param>
        /// <param name="id">dynamic list defintiion id</param>
        /// <returns></returns>
        private bool getDynamicListDefinitionXML(string name, out string xml, out int id)
        {
            //Examine the XML of the new dynamic list.
            //The Dynamic List Definition is not used in the UI so will have to go to the DB
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("dynamiclistgetlists"))
            {
                dataReader.AddParameter("@siteurlname", "haveyoursay");
                dataReader.Execute();

                id = 0;
                xml = string.Empty;
                while (dataReader.Read())
                {
                    if (dataReader.GetString("name") == name)
                    {
                        id = dataReader.GetInt32("id");
                        xml = dataReader.GetString("xml");
                        return true;
                    }
                }

                return false;
            }
        }
    }
}
