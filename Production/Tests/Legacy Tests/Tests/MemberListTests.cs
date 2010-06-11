using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Member List Tests
    /// </summary>
    [TestClass]
    public class MemberListTests
    {
        private const string _schemaUri = "MemberList.xsd";
        private int _entryID = 0;

        /// <summary>
        /// Makes sure that there's at least one threadentry for the tests to run against
        /// </summary>
        [TestInitialize]
        public void TestSetup()
        {
            // Create the stored procedure reader for the setup
            DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
            request.UseIdentitySignIn = true;
            request.SetCurrentUserNormal();

            // Setup the request url
            string uid = Guid.NewGuid().ToString();
            string title = "TestingCommentBox";
            string hosturl = "http://local.bbc.co.uk/dna/haveyoursay/acs";
            string url = "acs?dnauid=" + uid + "&dnainitialtitle=" + title + "&dnahostpageurl=" + hosturl + "&dnaforumduration=0&skin=purexml";

            // Request the page and then post a comment
            request.RequestPage(url);
            XmlDocument xml = request.GetLastResponseAsXML();
            request.RequestSecurePage("acs?dnauid=" + uid + "&dnaaction=add&dnacomment=blahblahblah&dnahostpageurl=" + hosturl + "&skin=purexml");
            XmlDocument xDoc = request.GetLastResponseAsXML();
            _entryID = Convert.ToInt32(xDoc.SelectSingleNode("//POST/@POSTID").InnerText);

            bool haveIpInfo = false;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("SELECT TOP 1 EntryID FROM ThreadEntriesIpAddress WHERE entryid = " + _entryID.ToString() + " and ipaddress = '12.34.56.78' and bbcuid = '47BEB336-3409-00CF-CAD0-080020C4C7DD'");
                if (reader.Read() && reader.HasRows)
                {
                    haveIpInfo = true;
                }
            }

            // Check to see if we had the ip details added
            if (!haveIpInfo)
            {
                // No details. Insert them manualy
                using (IDnaDataReader reader = context.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("UPDATE ThreadEntriesIpAddress SET entryid = " + _entryID.ToString() + ", ipaddress = '12.34.56.78', bbcuid = '47BEB336-3409-00CF-CAD0-080020C4C7DD' WHERE EntryID = " + _entryID.ToString());
                    reader.Read();
                }
            }
        }

        /// <summary>
        /// Test that we get a list of accounts for a given member
        /// </summary>
        [TestMethod]
        public void TestGetMemberListForUser1090558354()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));

            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the stored procedure reader for the MemberList object
            using (IDnaDataReader reader = context.CreateDnaDataReader("SearchForUserViaUserID"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("SearchForUserViaUserID").Will(Return.Value(reader));

                // Create a new MemberList object and get the list of member accounts
                MemberList testMemberList = new MemberList(mockedInputContext);
                testMemberList.GetMemberListXml(0, 1090558354, "", "", "", "", "", true);

                XmlElement xml = testMemberList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHTYPE='0']") != null, "The xml is not generated correctly (UserSearchType)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHID='1090558354']") != null, "The xml is not generated correctly (UserSearchUserID)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/@COUNT") != null, "The xml is not generated correctly (Count)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/SSOUSERID") != null, "Could not find the users sso userid!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/IDENTITYUSERID") != null, "Could not find the users identity userid!!!");
                
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
        }
        /// <summary>
        /// Test that we get a list of accounts for a given member via email
        /// </summary>
        [TestMethod]
        public void TestGetMemberListForUserByEmail()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));
            Stub.On(mockedUser).GetProperty("Email").Will(Return.Value("mark.howitt@bbc.co.uk"));

            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the stored procedure reader for the MemberList object
            using (IDnaDataReader reader = context.CreateDnaDataReader("SearchForUserViaEmail"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("SearchForUserViaEmail").Will(Return.Value(reader));

                // Create a new MemberList object and get the list of member accounts
                MemberList testMemberList = new MemberList(mockedInputContext);
                testMemberList.GetMemberListXml(1, 0, "mark.howitt@bbc.co.uk", "", "", "", "", true);

                XmlElement xml = testMemberList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHTYPE='1']") != null, "The xml is not generated correctly (UserSearchType)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHEMAIL='mark.howitt@bbc.co.uk']") != null, "The xml is not generated correctly (UserSearchEmail)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/@COUNT") != null, "The xml is not generated correctly (Count)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/SSOUSERID") != null, "Could not find the users sso userid!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/IDENTITYUSERID") != null, "Could not find the users identity userid!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
        }

        /// <summary>
        /// Test that we get a list of accounts for a given member via username
        /// </summary>
        [TestMethod]
        public void TestGetMemberListForUserByUserName()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));

            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the stored procedure reader for the MemberList object
            using (IDnaDataReader reader = context.CreateDnaDataReader("SearchForUserViaUserName"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("SearchForUserViaUserName").Will(Return.Value(reader));

                // Create a new MemberList object and get the list of member accounts
                MemberList testMemberList = new MemberList(mockedInputContext);
                testMemberList.GetMemberListXml(2, 0, "", "DotNetSuperUser", "", "", "", true);

                XmlElement xml = testMemberList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHTYPE='2']") != null, "The xml is not generated correctly (UserSearchType)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHNAME='DotNetSuperUser']") != null, "The xml is not generated correctly (UserSearchUserName)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/@COUNT") != null, "The xml is not generated correctly (Count)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/SSOUSERID") != null, "Could not find the users sso userid!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/IDENTITYUSERID") != null, "Could not find the users identity userid!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
        }
        /// <summary>
        /// Test that we get a list of accounts for a given member via ipaddress
        /// </summary>
        [TestMethod]
        public void TestGetMemberListForUserByIPAddress()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));

            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the stored procedure reader for the MemberList object
            using (IDnaDataReader reader = context.CreateDnaDataReader("SearchForUserViaIPAddress"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("SearchForUserViaIPAddress").Will(Return.Value(reader));

                // Create a new MemberList object and get the list of member accounts
                MemberList testMemberList = new MemberList(mockedInputContext);
                testMemberList.GetMemberListXml(3, 0, "", "", "12.34.56.78", "", "", true);

                XmlElement xml = testMemberList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHTYPE='3']") != null, "The xml is not generated correctly (UserSearchType)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHIPADDRESS='12.34.56.78']") != null, "The xml is not generated correctly (UserSearchIPAddress)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/@COUNT") != null, "The xml is not generated correctly (Count)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/SSOUSERID") != null, "Could not find the users sso userid!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/IDENTITYUSERID") != null, "Could not find the users identity userid!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
        }

        /// <summary>
        /// Test that we get a list of accounts for a given member via BBC UID
        /// </summary>
        [TestMethod]
        public void TestGetMemberListForUserByBBCUID()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));

            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the stored procedure reader for the MemberList object
            using (IDnaDataReader reader = context.CreateDnaDataReader("SearchForUserViaBBCUID"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("SearchForUserViaBBCUID").Will(Return.Value(reader));

                // Create a new MemberList object and get the list of member accounts
                MemberList testMemberList = new MemberList(mockedInputContext);
                testMemberList.GetMemberListXml(4, 0, "", "", "", "47BEB336-3409-00CF-CAD0-080020C4C7DD", "", true);

                XmlElement xml = testMemberList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHTYPE='4']") != null, "The xml is not generated correctly (UserSearchType)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHBBCUID='47BEB336-3409-00CF-CAD0-080020C4C7DD']") != null, "The xml is not generated correctly (UserSearchBBCUID)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/@COUNT") != null, "The xml is not generated correctly (Count)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/SSOUSERID") != null, "Could not find the users sso userid!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/IDENTITYUSERID") != null, "Could not find the users identity userid!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
        }
        /// <summary>
        /// Test that we get a list of accounts for a given member via login name
        /// </summary>
        [TestMethod]
        public void TestGetMemberListForUserByLoginName()
        {
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");

            ISite mockedSite = mock.NewMock<ISite>();
            //Stub.On(mockedSite).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(mockedSite).GetProperty("SiteID").Will(Return.Value(1));

            IUser mockedUser = mock.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558354));

            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(mockedUser));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(mockedSite));

            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the stored procedure reader for the MemberList object
            using (IDnaDataReader reader = context.CreateDnaDataReader("SearchForUserViaLoginName"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("SearchForUserViaLoginName").Will(Return.Value(reader));

                // Create a new MemberList object and get the list of member accounts
                MemberList testMemberList = new MemberList(mockedInputContext);
                testMemberList.GetMemberListXml(5, 0, "", "", "", "", "DotNetSuperUser", true);

                XmlElement xml = testMemberList.RootElement;
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST") != null, "The xml is not generated correctly!!!");

                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHTYPE='5']") != null, "The xml is not generated correctly (UserSearchType)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST[@USERSEARCHLOGINNAME='DotNetSuperUser']") != null, "The xml is not generated correctly (UserSearchLoginName)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/@COUNT") != null, "The xml is not generated correctly (Count)!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/SSOUSERID") != null, "Could not find the users sso userid!!!");
                Assert.IsTrue(xml.SelectSingleNode("MEMBERLIST/USERACCOUNTS/USERACCOUNT/IDENTITYUSERID") != null, "Could not find the users identity userid!!!");

                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
                validator.Validate();
            }
        }
    }
}
