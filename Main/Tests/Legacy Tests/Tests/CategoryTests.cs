using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Test class CategoryTests.cs
    /// </summary>
    [TestClass]
    public class CategoryTests
    {
        Mockery _mock = new Mockery();
        IInputContext _mockedInputContext;
        XmlDocument _siteconfig = new XmlDocument();
        ISite _site;
        User _user;

        /// <summary>
        /// Setup method
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.ForceRestore();


            //Create the mocked inputcontext
            _mockedInputContext = DnaMockery.CreateDatabaseInputContext();
            _siteconfig.LoadXml("<SITECONFIG />");
            _site = _mock.NewMock<ISite>();
            Stub.On(_site).GetProperty("Config").Will(Return.Value(String.Empty));
            Stub.On(_site).GetProperty("SiteID").Will(Return.Value(1));

            _user = new User(_mockedInputContext);
            Stub.On(_mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(_user));
            Stub.On(_mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(_site));

        }
        /// <summary>
        /// Test method to test loading of the subject members for node id
        /// </summary>
        [TestMethod]
        public void Test01CheckGetSubjectMembersForNodeID()
        {
            Console.WriteLine("Before Test01CheckGetSubjectMembersForNodeID");

            // Create the stored procedure reader for the UITemplate object
            using (IDnaDataReader reader = _mockedInputContext.CreateDnaDataReader("getsubjectsincategory"))
            {
                Stub.On(_mockedInputContext).Method("CreateDnaDataReader").With("getsubjectsincategory").Will(Return.Value(reader));
                Category category = new Category(_mockedInputContext);
                XmlElement subjectMembers = category.GetSubjectMembersForNodeID(26);

                Assert.IsTrue(subjectMembers.SelectSingleNode("/SUBJECTMEMBER") != null, "Subject member list tag does not contain any subject members!");

                Assert.IsTrue(subjectMembers.SelectSingleNode("/SUBJECTMEMBER[NODEID=535]") != null, "Subject member 535 does not exist!");
                Assert.IsTrue(subjectMembers.SelectSingleNode("/SUBJECTMEMBER[NODEID=533]/SUBNODES/SUBNODE[SUBNAME='Wizards']") != null, "Subject member 533 does not exist or have the sub node with subname 'Wizards'!");

            }
            Console.WriteLine("After Test01CheckGetSubjectMembersForNodeID");
        }
        /// <summary>
        /// Test method to test loading of the users for node id
        /// </summary>
        [TestMethod]
        public void Test02CheckGetUsersForNodeID()
        {
            Console.WriteLine("Before Test02CheckGetUsersForNodeID");

            MakeJimAWizard();

            // Create the stored procedure reader for the UITemplate object
            using (IDnaDataReader reader = _mockedInputContext.CreateDnaDataReader("getusersfornode"))
            {
                Stub.On(_mockedInputContext).Method("CreateDnaDataReader").With("getusersfornode").Will(Return.Value(reader));
                Category category = new Category(_mockedInputContext);
                XmlElement usersInNode = category.GetUsersForNodeID(54912);

                Assert.IsTrue(usersInNode.SelectSingleNode("/USER") != null, "No User tag!");
                Assert.IsTrue(usersInNode.SelectSingleNode("/USER[USERID=6]") != null, "User ID 6 does not exist!");
            }
            Console.WriteLine("After Test02CheckGetUsersForNodeID");
        }

        /// <summary>
        /// Test method to test loading of the users for node id
        /// </summary>
        [TestMethod]
        public void Test03CheckGetHierarchyName()
        {
            Console.WriteLine("Before Test03CheckGetHierarchyName");

            // Create the stored procedure reader for the UITemplate object
            using (IDnaDataReader reader = _mockedInputContext.CreateDnaDataReader("gethierarchynodedetails2"))
            {
                Stub.On(_mockedInputContext).Method("CreateDnaDataReader").With("gethierarchynodedetails2").Will(Return.Value(reader));
                Category category = new Category(_mockedInputContext);
                string name = category.GetHierarchyName(54912);

                Assert.IsTrue(name == "Wizards", "Not got the correct name!");
            }
            Console.WriteLine("After Test03CheckGetHierarchyName");
        }

        /// <summary>
        /// Test method to test loading of the alias members for node id
        /// </summary>
        [TestMethod]
        public void Test04CheckGetAliasMembersForNodeID()
        {
            Console.WriteLine("Before Test04CheckGetAliasMembersForNodeID");
            SetupNodeAliases();

            // Create the stored procedure reader for the UITemplate object
            using (IDnaDataReader reader = _mockedInputContext.CreateDnaDataReader("getaliasesinhierarchy"))
            {
                Stub.On(_mockedInputContext).Method("CreateDnaDataReader").With("getaliasesinhierarchy").Will(Return.Value(reader));
                Category category = new Category(_mockedInputContext);
                XmlElement aliasMembers = category.GetNodeAliasMembersForNodeID(2377);

                Assert.IsTrue(aliasMembers.SelectSingleNode("/NODEALIASMEMBER") != null, "Alias member list tag does not contain any subject members!");

                Assert.IsTrue(aliasMembers.SelectSingleNode("/NODEALIASMEMBER[LINKNODEID=2324]") != null, "Alias member 2324 does not exist!");
                Assert.IsTrue(aliasMembers.SelectSingleNode("/NODEALIASMEMBER[LINKNODEID=2324]/SUBNODES/SUBNODE[SUBNAME='Road rage']") != null, "Alias member 2324 does not exist or have the sub node with subname 'Road rage'!");

            }
            Console.WriteLine("After Test04CheckGetAliasMembersForNodeID");
        }

        private void MakeJimAWizard()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("exec adduserstohierarchy 54912, '6'");
            }
        }

        private void SetupNodeAliases()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("exec addaliastohierarchy 2377, 2316");
            }
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("exec addaliastohierarchy 2377, 2324");
            }
        }
    }
}
