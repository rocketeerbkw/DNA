using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Data;
using BBC.Dna;
using BBC.Dna.Utils;
using System.Transactions;
using NMock2;
using BBC.Dna.Sites;
using System.Xml;
using TestUtils;

namespace Tests
{
    /// <summary>
    /// Summary description for ModerationHistoryTests
    /// </summary>
    [TestClass]
    public class ModerationHistoryTests
    {
        /// <summary>
        /// 
        /// </summary>
        public ModerationHistoryTests()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //
        #endregion

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void PostHistory_GetPostHistoryAsSuperUserForAnonymousComplaint_ExpectFullComplainantDetails()
        {
            using (new TransactionScope())
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                int postId = 61;
                int userId = 0;
                int modId = 0;
                string email = "testuser@bbc.co.uk";
                string complaintText = "This is testing that the complainant details are correctly displayed";
                string IpAddress = "192.168.238.1";
                Guid BBCUid = new Guid();

                modId = RegisterTestComplaint(context, postId, userId, modId, email, complaintText, IpAddress, BBCUid);

                Stub.On(context).Method("GetParamStringOrEmpty").With("reference", "reference").Will(Return.Value(""));
                Stub.On(context).Method("GetParamIntOrZero").With("postid", "postid").Will(Return.Value(postId));
                Stub.On(context).Method("GetParamIntOrZero").With("h2g2id", "h2g2id").Will(Return.Value(0));
                Stub.On(context).Method("GetParamStringOrEmpty").With("exlinkurl", "exlinkurl").Will(Return.Value(""));

                ISite site = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true);

                IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();
                AppContext.ReaderCreator = creator;

                IUser viewingUser = DnaMockery.CurrentMockery.NewMock<IUser>();
                Stub.On(viewingUser).GetProperty("IsSuperUser").Will(Return.Value(true));

                Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(viewingUser));

                ModerationHistory history = new ModerationHistory(context);
                history.ProcessRequest();

                XmlNode modHistory = history.RootElement.SelectSingleNode("//MODERATION-HISTORY");
                Assert.IsNotNull(modHistory, "Failed to find the moderation history node");

                XmlNode modItem = modHistory.SelectSingleNode("MODERATION[@MODID='" + modId + "']");
                Assert.IsNotNull(modItem, "Failed to find the moderation node for the complaint.");

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/IPADDRESS"), "Failed to find complaint ipaddress");
                Assert.AreEqual(IpAddress, modItem.SelectSingleNode("COMPLAINT/IPADDRESS").InnerText);

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT"), "Failed to find complaint text");
                Assert.AreEqual(complaintText, modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT").InnerText);

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/BBCUID"), "Failed to find complaint BBCUID");
                Assert.AreEqual(BBCUid.ToString(), modItem.SelectSingleNode("COMPLAINT/BBCUID").InnerText);

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/EMAIL-ADDRESS"), "Failed to find complaint email address");
                Assert.AreEqual(email, modItem.SelectSingleNode("COMPLAINT/EMAIL-ADDRESS").InnerText);

                XmlNode complainantUser = modItem.SelectSingleNode("COMPLAINT/USER");
                Assert.IsNull(complainantUser, "There shouldn't be a complainant user block");
            }
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void PostHistory_GetPostHistoryAsSuperUserForLogedInComplaint_ExpectFullComplainantDetails()
        {
            using (new TransactionScope())
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                int postId = 61;
                int userId = TestUserAccounts.GetNormalUserAccount.UserID;
                int modId = 0;
                string email = "testuser@bbc.co.uk";
                string complaintText = "This is testing that the complainant details are correctly displayed";
                string IpAddress = "192.168.238.3";
                Guid BBCUid = new Guid();

                modId = RegisterTestComplaint(context, postId, userId, modId, email, complaintText, IpAddress, BBCUid);

                Stub.On(context).Method("GetParamStringOrEmpty").With("reference", "reference").Will(Return.Value(""));
                Stub.On(context).Method("GetParamIntOrZero").With("postid", "postid").Will(Return.Value(postId));
                Stub.On(context).Method("GetParamIntOrZero").With("h2g2id", "h2g2id").Will(Return.Value(0));
                Stub.On(context).Method("GetParamStringOrEmpty").With("exlinkurl", "exlinkurl").Will(Return.Value(""));

                ISite site = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true);

                IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();
                AppContext.ReaderCreator = creator;

                IUser viewingUser = DnaMockery.CurrentMockery.NewMock<IUser>();
                Stub.On(viewingUser).GetProperty("IsSuperUser").Will(Return.Value(true));

                Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(viewingUser));

                ModerationHistory history = new ModerationHistory(context);
                history.ProcessRequest();

                XmlNode modHistory = history.RootElement.SelectSingleNode("//MODERATION-HISTORY");
                Assert.IsNotNull(modHistory, "Failed to find the moderation history node");

                XmlNode modItem = modHistory.SelectSingleNode("MODERATION[@MODID='" + modId + "']");
                Assert.IsNotNull(modItem, "Failed to find the moderation node for the complaint.");

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/IPADDRESS"), "Failed to find complaint ipaddress");
                Assert.AreEqual(IpAddress, modItem.SelectSingleNode("COMPLAINT/IPADDRESS").InnerText);

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT"), "Failed to find complaint text");
                Assert.AreEqual(complaintText, modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT").InnerText);

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/BBCUID"), "Failed to find complaint BBCUID");
                Assert.AreEqual(BBCUid.ToString(), modItem.SelectSingleNode("COMPLAINT/BBCUID").InnerText);

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/EMAIL-ADDRESS"), "Failed to find complaint email address");
                Assert.AreEqual(email, modItem.SelectSingleNode("COMPLAINT/EMAIL-ADDRESS").InnerText);

                XmlNode complainantUser = modItem.SelectSingleNode("COMPLAINT/USER");
                Assert.IsNotNull(complainantUser, "Failed to find complaint user");

                Assert.IsNotNull(complainantUser.SelectSingleNode("USERID"), "Failed to find complaint userid");
                Assert.AreEqual(userId.ToString(), complainantUser.SelectSingleNode("USERID").InnerText, "The userid should be the one that complained");
            }
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void PostHistory_GetPostHistoryAsModeratorForAnonymousComplaint_ExpectLimitedComplainantDetails()
        {
            using (new TransactionScope())
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                int postId = 61;
                int userId = 0;
                int modId = 0;
                string email = "testuser@bbc.co.uk";
                string complaintText = "This is testing that the complainant details are correctly displayed";
                string IpAddress = "192.168.238.1";
                Guid BBCUid = new Guid();

                modId = RegisterTestComplaint(context, postId, userId, modId, email, complaintText, IpAddress, BBCUid);

                Stub.On(context).Method("GetParamStringOrEmpty").With("reference", "reference").Will(Return.Value(""));
                Stub.On(context).Method("GetParamIntOrZero").With("postid", "postid").Will(Return.Value(postId));
                Stub.On(context).Method("GetParamIntOrZero").With("h2g2id", "h2g2id").Will(Return.Value(0));
                Stub.On(context).Method("GetParamStringOrEmpty").With("exlinkurl", "exlinkurl").Will(Return.Value(""));

                ISite site = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true);

                IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();
                AppContext.ReaderCreator = creator;

                IUser viewingUser = DnaMockery.CurrentMockery.NewMock<IUser>();
                Stub.On(viewingUser).GetProperty("IsSuperUser").Will(Return.Value(false));

                Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(viewingUser));

                ModerationHistory history = new ModerationHistory(context);
                history.ProcessRequest();

                XmlNode baseNode = history.RootElement.SelectSingleNode("//MODERATION-HISTORY");

                XmlNode modHistory = history.RootElement.SelectSingleNode("//MODERATION-HISTORY");
                Assert.IsNotNull(modHistory, "Failed to find the moderation history node");

                XmlNode modItem = modHistory.SelectSingleNode("MODERATION[@MODID='" + modId + "']");
                Assert.IsNotNull(modItem, "Failed to find the moderation node for the complaint.");

                Assert.IsNull(modItem.SelectSingleNode("COMPLAINT/IPADDRESS"), "Non superusers shouldn't see this node");
                Assert.IsNull(modItem.SelectSingleNode("COMPLAINT/BBCUID"), "Non superusers shouldn't see this node");
                Assert.IsNull(modItem.SelectSingleNode("COMPLAINT/EMAIL-ADDRESS"), "Non superusers shouldn't see this node");

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT"), "Failed to find complaint text");
                Assert.AreEqual(complaintText, modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT").InnerText);

                XmlNode complainantUser = modItem.SelectSingleNode("COMPLAINT/USER");
                Assert.IsNull(complainantUser, "There shouldn't be a complainant user block");
            }
        }

        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void PostHistory_GetPostHistoryAsModeratorForLoggedinComplaint_ExpectLimitedComplainantDetails()
        {
            using (new TransactionScope())
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                int postId = 61;
                int userId = TestUserAccounts.GetNormalUserAccount.UserID;
                int modId = 0;
                string email = "testuser@bbc.co.uk";
                string complaintText = "This is testing that the complainant details are correctly displayed";
                string IpAddress = "192.168.238.1";
                Guid BBCUid = new Guid();

                modId = RegisterTestComplaint(context, postId, userId, modId, email, complaintText, IpAddress, BBCUid);

                Stub.On(context).Method("GetParamStringOrEmpty").With("reference", "reference").Will(Return.Value(""));
                Stub.On(context).Method("GetParamIntOrZero").With("postid", "postid").Will(Return.Value(postId));
                Stub.On(context).Method("GetParamIntOrZero").With("h2g2id", "h2g2id").Will(Return.Value(0));
                Stub.On(context).Method("GetParamStringOrEmpty").With("exlinkurl", "exlinkurl").Will(Return.Value(""));

                ISite site = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", true);

                IDnaDataReaderCreator creator = DnaMockery.CreateDatabaseReaderCreator();
                AppContext.ReaderCreator = creator;

                IUser viewingUser = DnaMockery.CurrentMockery.NewMock<IUser>();
                Stub.On(viewingUser).GetProperty("IsSuperUser").Will(Return.Value(false));

                Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(viewingUser));

                ModerationHistory history = new ModerationHistory(context);
                history.ProcessRequest();

                XmlNode baseNode = history.RootElement.SelectSingleNode("//MODERATION-HISTORY");

                XmlNode modHistory = history.RootElement.SelectSingleNode("//MODERATION-HISTORY");
                Assert.IsNotNull(modHistory, "Failed to find the moderation history node");

                XmlNode modItem = modHistory.SelectSingleNode("MODERATION[@MODID='" + modId + "']");
                Assert.IsNotNull(modItem, "Failed to find the moderation node for the complaint.");

                Assert.IsNull(modItem.SelectSingleNode("COMPLAINT/IPADDRESS"), "Non superusers shouldn't see this node");
                Assert.IsNull(modItem.SelectSingleNode("COMPLAINT/BBCUID"), "Non superusers shouldn't see this node");
                Assert.IsNull(modItem.SelectSingleNode("COMPLAINT/EMAIL-ADDRESS"), "Non superusers shouldn't see this node");

                Assert.IsNotNull(modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT"), "Failed to find complaint text");
                Assert.AreEqual(complaintText, modItem.SelectSingleNode("COMPLAINT/COMPLAINT-TEXT").InnerText);

                XmlNode complainantUser = modItem.SelectSingleNode("COMPLAINT/USER");
                Assert.IsNotNull(complainantUser, "Failed to find complaint user");

                Assert.IsNotNull(complainantUser.SelectSingleNode("USERID"), "Failed to find complaint userid");
                Assert.AreEqual(userId.ToString(), complainantUser.SelectSingleNode("USERID").InnerText, "The userid should be the one that complained");
            }
        }

        private static int RegisterTestComplaint(IInputContext context, int postId, int userId, int modId, string email, string complaintText, string IpAddress, Guid BBCUid)
        {
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("registerpostingcomplaint"))
            {
                dataReader.AddParameter("complainantid", userId);
                dataReader.AddParameter("correspondenceemail", email);
                dataReader.AddParameter("postid", postId);
                dataReader.AddParameter("complainttext", complaintText);
                dataReader.AddParameter("ipaddress", IpAddress);
                dataReader.AddParameter("bbcuid", BBCUid);

                //HashValue
                Guid hash = DnaHasher.GenerateHash(Convert.ToString(userId) + ":" + email + ":" + Convert.ToString(postId) + ":" + complaintText);
                dataReader.AddParameter("hash", hash);
                dataReader.Execute();

                // Send Email
                if (dataReader.Read())
                {
                    modId = dataReader.GetInt32NullAsZero("modId");
                }
            }
            return modId;
        }
    }
}
