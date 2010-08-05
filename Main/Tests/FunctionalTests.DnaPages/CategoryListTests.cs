using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the CategoryList Tests page showing the articles coming up
    /// </summary>
    [TestClass]
    public class CategoryListTests
    {
        private bool _setupRun = false;
        private bool _categoryListsAdded = false; //For tests in isolation
        private string _categoryListsGUID1 = String.Empty;
        private string _categoryListsGUID2 = String.Empty;
        private string _categoryListsGUID1ForXml = String.Empty;
        private string _categoryListsGUID2ForXml = String.Empty;  

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _usersCategoryListsSchemaUri = "H2G2UsersCategoryListsFlat.xsd";
        private const string _categoryListSchemaUri = "H2G2CategoryListFlat.xsd";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("Setting up");
                _request.UseEditorAuthentication = true;
                _request.SetCurrentUserEditor();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get the test users categorylist page page
        /// </summary>
        [TestMethod]
        public void Test01GetUsersCategoryListPage()
        {
            Console.WriteLine("Before CategoryListTests - Test01GetUsersCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS") != null, "User Category List tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS[CATEGORYLISTSOWNERID='1090558353']") != null, "User Category List owner id tag tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS/LIST[GUID='" + _categoryListsGUID1ForXml + "']") != null, "User Category List - GUID 1 tag does not exist");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS/LIST[GUID='" + _categoryListsGUID1ForXml + "']/CATEGORYLISTNODES/CATEGORY[@NODEID='31']") != null, "User Category List - GUID 1 NODE 31 tag does not exist");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS/LIST[GUID='" + _categoryListsGUID2ForXml + "']") != null, "User Category List - GUID 2 tag does not exist");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS/LIST[GUID='" + _categoryListsGUID2ForXml + "']/CATEGORYLISTNODES/CATEGORY[@NODEID='31']") != null, "User Category List - GUID 2 NODE 31 tag does not exist");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS/LIST") != null, "User Category List - List tag does not exist");

            Console.WriteLine("After Test01GetUsersCategoryListPage");
        }

        /// <summary>
        /// Test that we can add a node to the test users categorylist page page
        /// </summary>
        [TestMethod]
        public void Test02AddNodeUsersCategoryListPage()
        {
            Console.WriteLine("Test02AddNodeUsersCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?&cmd=add&id=" + _categoryListsGUID1 + "&nodeid=54912&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[@MODE='ADD']") != null, "H2G2 mode attribute does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST") != null, "Category List tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ADDEDNODE") != null, "Renamed Category List tag does not exist");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ADDEDNODE[@GUID='" + _categoryListsGUID1 + "']") != null, "Added Node not added correctly - GUID.");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/ADDEDNODE[@NODEID='54912']") != null, "Added Node not added correctly - NODEID.");
            
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST/HIERARCHYDETAILS") != null, "HIERARCHY DETAILS tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST/HIERARCHYDETAILS[@NODEID='54912']") != null, "HIERARCHY DETAILS tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST[GUID='" + _categoryListsGUID1 + "']") != null, "Category List GUID tag does not exist");

            Console.WriteLine("After Test02AddNodeUsersCategoryListPage");
        }

        /// <summary>
        /// Test that we can rename the description of a users category list
        /// </summary>
        [TestMethod]
        public void Test03RenameNodeUsersCategoryListPage()
        {
            Console.WriteLine("Test03RenameNodeUsersCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?&cmd=rename&id=" + _categoryListsGUID1 + "&description=RenamedCategoryList&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[@MODE='RENAME']") != null, "H2G2 mode attribute does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST") != null, "Category Lists tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/RENAMEDCATEGORYLIST") != null, "Renamed Category List tag does not exist");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/RENAMEDCATEGORYLIST[@DESCRIPTION='RenamedCategoryList']") != null, "Renamed CategoryList changed name is not correct.");

            Console.WriteLine("After Test03RenameNodeUsersCategoryListPage");
        }

        /// <summary>
        /// Test that we can remove a node from the users category list
        /// </summary>
        [TestMethod]
        public void Test04RemoveNodeFromUsersCategoryListPage()
        {
            Console.WriteLine("Test04RemoveNodeFromUsersCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?&cmd=remove&id=" + _categoryListsGUID1 + "&nodeid=31&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[@MODE='REMOVE']") != null, "H2G2 mode attribute does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST") != null, "Category Lists tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/REMOVEDNODE") != null, "RemovedNode tag does not exist");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/REMOVEDNODE[@GUID='" + _categoryListsGUID1 + "']") != null, "Category List removed node not removed correctly - GUID.");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/REMOVEDNODE[@NODEID='31']") != null, "Category List removed node not removed correctly - NODEID");

            Console.WriteLine("After Test04RemoveNodeFromUsersCategoryListPage");
        }

        /// <summary>
        /// Test that we can delete a users category list
        /// </summary>
        [TestMethod]
        public void Test05DeleteUsersCategoryListPage()
        {
            Console.WriteLine("Test05DeleteUsersCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?&cmd=delete&id=" + _categoryListsGUID1 + "&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2[@MODE='DELETE']") != null, "H2G2 mode attribute does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/USERCATEGORYLISTS") != null, "User Category Lists tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/DELETEDCATEGORYLIST") != null, "RemovedNode tag does not exist");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/DELETEDCATEGORYLIST[@GUID='" + _categoryListsGUID1 + "']") != null, "Category List removed node not removed correctly - GUID.");

            Console.WriteLine("After Test05DeleteUsersCategoryListPage");
        }

        /// <summary>
        /// Test that we can create a users category list
        /// </summary>
        [Ignore]//method not implemented yet.
        public void Test06CreateUsersCategoryListPage()
        {
            Console.WriteLine("Test06CreateUsersCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?&cmd=create&description=Test3CreatedCategoryList&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/CATEGORYLIST/LIST[DESCRIPTION='Test3CreatedCategoryList']") == null, "User Category List not created.");

            Console.WriteLine("After Test06CreateUsersCategoryListPage");
        }

        /// <summary>
        /// Test that the users category list page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test07ValidateUsersCategoryListsPage()
        {
            Console.WriteLine("Before Test07ValidateUsersCategoryListsPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _usersCategoryListsSchemaUri);
            validator.Validate();

            Console.WriteLine("After Test07ValidateUsersCategoryListsPage");
        }

        /// <summary>
        /// Test that the category list page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test08ValidateCategoryListPage()
        {
            Console.WriteLine("Before Test08ValidateCategoryListPage");

            SetupATestCategoryList();

            //request the page
            _request.RequestPage("CategoryList?id=" + _categoryListsGUID2 + "&skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            // Check to make sure that the page returned with the correct information
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _categoryListSchemaUri);
            validator.Validate();

            Console.WriteLine("After Test08ValidateCategoryListPage");
        }


        private void SetupATestCategoryList()
        {
            if (!_categoryListsAdded)
            {
                _categoryListsAdded = true;

                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader reader = context.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("exec createcategorylist 1090558353, 1, 'Test Category List 1', 'Test web site 1', 1");
                    reader.Read();
                    _categoryListsGUID1 = reader.GetGuidAsStringOrEmpty("CategoryListID");
                    _categoryListsGUID1ForXml = _categoryListsGUID1.Replace("-", "");

                    reader.ExecuteDEBUGONLY("exec createcategorylist 1090558353, 1, 'Test Category List 2', 'Test web site 2', 1");
                    reader.Read();
                    _categoryListsGUID2 = reader.GetGuidAsStringOrEmpty("CategoryListID");
                    _categoryListsGUID2ForXml = _categoryListsGUID2.Replace("-", "");

                    reader.ExecuteDEBUGONLY("exec addnodetocategorylist '" + _categoryListsGUID1 + "', 31");
                    reader.ExecuteDEBUGONLY("exec addnodetocategorylist '" + _categoryListsGUID2 + "', 31");
                }
            }
        }

    }
}