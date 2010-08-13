using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the ComingUp Tests page showing the articles coming up
    /// </summary>
    [TestClass]
    public class UserDetailsTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "userdetails.xsd";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {

            SnapshotInitialisation.RestoreFromSnapshot();
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("Setting up");
                _request.UseEditorAuthentication = false;
                _request.SetCurrentUserNormal();
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [Ignore]//test doesn't work
        public void Test01DefaultDetailsReturn()
        {
            Console.WriteLine("Before UserDetailsTests - Test01DefaultDetailsReturn");

            //request the page
            _request.RequestPage("UserDetails?skin=purexml");

            // now get the response
            XmlDocument xml = _request.GetLastResponseAsXML();

            //validate response
            ValidateBaseXML(xml);

            Console.WriteLine("After UserDetailsTests - Test01DefaultDetailsReturn");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [Ignore]//test doesn't work
        public void Test02ModifySkin()
        {
            Console.WriteLine("Before UserDetailsTests - Test02ModifySkin");

            //request the page
            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original skin
            XmlNode xmlSkin = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SKIN");
            Assert.IsTrue(xmlSkin != null, "Incorrect skin returned");
            string originalSkin = xmlSkin.InnerText;
            string newSkin = "Alabaster";

            //change the skin
            _request.RequestPage("UserDetails?cmd=SUBMIT&prefskin=" + newSkin + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlSkin = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SKIN");
            Assert.IsTrue(xmlSkin != null, "Incorrect skin returned");
            Assert.IsTrue(xmlSkin.InnerText == newSkin, "Incorrect skin returned");

            //change the skin back to original
            _request.RequestPage("UserDetails?cmd=SUBMIT&prefskin=" + originalSkin + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlSkin = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SKIN");
            Assert.IsTrue(xmlSkin != null, "Incorrect skin returned");
            Assert.IsTrue(xmlSkin.InnerText == originalSkin, "Incorrect skin returned");
            

            Console.WriteLine("After UserDetailsTests - Test02ModifySkin");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test03ModifyUserMode()
        {
            Console.WriteLine("Before UserDetailsTests - Test03ModifyUserMode");

            //request the page
            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original skin
            XmlNode xmlUserMode = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE");
            Assert.IsTrue(xmlUserMode != null, "Incorrect user mode returned");
            string originalUserMode = xmlUserMode.InnerText;
            string newUserMode = "1";

            //change the skin
            _request.RequestPage("UserDetails?cmd=SUBMIT&PrefUserMode=" + newUserMode + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlUserMode = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE");
            Assert.IsTrue(xmlUserMode != null, "Incorrect user mode returned");
            Assert.IsTrue(xmlUserMode.InnerText == newUserMode, "Incorrect user mode returned");

            //change the skin back to original
            _request.RequestPage("UserDetails?cmd=SUBMIT&PrefUserMode=" + originalUserMode + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlUserMode = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/USER-MODE");
            Assert.IsTrue(xmlUserMode != null, "Incorrect user mode returned");
            Assert.IsTrue(xmlUserMode.InnerText == originalUserMode, "Incorrect user mode returned");


            Console.WriteLine("After UserDetailsTests - Test03ModifyUserMode");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test04ModifyForumStyle()
        {
            Console.WriteLine("Before UserDetailsTests - Test04ModifyForumStyle");

            //request the page
            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original skin
            XmlNode xmlForumStyle = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/FORUM-STYLE");
            Assert.IsTrue(xmlForumStyle != null, "Incorrect user mode returned");
            string originalForumStyle = xmlForumStyle.InnerText;
            string newForumStyle = "1";

            //change the skin
            _request.RequestPage("UserDetails?cmd=SUBMIT&PrefForumStyle=" + newForumStyle + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlForumStyle = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/FORUM-STYLE");
            Assert.IsTrue(xmlForumStyle != null, "Incorrect user mode returned");
            Assert.IsTrue(xmlForumStyle.InnerText == newForumStyle, "Incorrect user mode returned");

            //change the skin back to original
            _request.RequestPage("UserDetails?cmd=SUBMIT&PrefForumStyle=" + originalForumStyle + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlForumStyle = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/FORUM-STYLE");
            Assert.IsTrue(xmlForumStyle != null, "Incorrect user mode returned");
            Assert.IsTrue(xmlForumStyle.InnerText == originalForumStyle, "Incorrect user mode returned");


            Console.WriteLine("After UserDetailsTests - Test04ModifyForumStyle");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test05SetSkinMethod()
        {
            Console.WriteLine("Before UserDetailsTests - Test05SetSkinMethod");

            //request the page
            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original skin
            XmlNode xmlSkin = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SKIN");
            Assert.IsTrue(xmlSkin != null, "Incorrect skin returned");
            string originalSkin = xmlSkin.InnerText;
            string newSkin = "Alabaster";

            //change the skin
            _request.RequestPage("UserDetails?setskin=1&NewSkin=" + newSkin + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlSkin = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SKIN");
            Assert.IsTrue(xmlSkin != null, "Incorrect skin returned");
            Assert.IsTrue(xmlSkin.InnerText == newSkin, "Incorrect skin returned");

            //change the skin back to original
            _request.RequestPage("UserDetails?setskin=1&NewSkin=" + originalSkin + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            xmlSkin = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SKIN");
            Assert.IsTrue(xmlSkin != null, "Incorrect skin returned");
            Assert.IsTrue(xmlSkin.InnerText == originalSkin, "Incorrect skin returned");


            Console.WriteLine("After UserDetailsTests - Test05SetSkinMethod");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test06DefaultDetailsReturnUserBanned()
        {
            Console.WriteLine("Before UserDetailsTests - Test06DefaultDetailsReturnUserBanned");

            //request the page
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserBanned();
            request.RequestPage("UserDetails?skin=purexml");

            // now get the response
            XmlDocument xml = request.GetLastResponseAsXML();

            //validate response
            ValidateBaseXML(xml);

            XmlNode xmlMessage = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/MESSAGE");
            Assert.IsTrue(xmlMessage != null, "Incorrect return message");
            Assert.IsTrue(xmlMessage.InnerText != String.Empty, "Incorrect return message");
            Assert.IsTrue(xmlMessage.Attributes["TYPE"].Value == "restricteduser", "Incorrect return message");
            

            Console.WriteLine("After UserDetailsTests - Test06DefaultDetailsReturnUserBanned");
        }

        /// <summary>
        /// Test to make sure that we fail when we try to submit a sitesuffix with a block fail term
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetSiteSuffixWithBlockFailProfanity_ExpectFail()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetSiteSuffixWithBlockFailProfanity_ExpectFail");

            SetNicknameModerationStatus(0);

            string termSiteSuffix = "fuck"; // Key word in block list

            //change the skin
            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + termSiteSuffix + "&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            XmlNode xmlMessage = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/MESSAGE");
            Assert.IsTrue(xmlMessage != null, "Incorrect return message");
            Assert.IsTrue(xmlMessage.InnerText != String.Empty, "Incorrect return message");
            Assert.IsTrue(xmlMessage.Attributes["TYPE"].Value == "sitesuffixfailprofanitycheck", "Incorrect return message");

            RevertSiteSpecificDisplayNameToBlank();
            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetSiteSuffixWithBlockFailProfanity_ExpectFail");
        }

        /// <summary>
        /// Test to make sure that we don't fail when we try to submit a sitesuffix with a refer fail term
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetSiteSuffixWithReferrFailProfanity_ExpectOk()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetSiteSuffixWithReferrFailProfanity_ExpectOk");
            RevertSiteSpecificDisplayNameToBlank();

            string termSiteSuffix = "arse"; // key term in referal list

            SetNicknameModerationStatus(0);

            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + termSiteSuffix + "&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            XmlNode xmlMessage = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/MESSAGE");
            Assert.IsFalse(xmlMessage.Attributes["TYPE"].Value == "sitesuffixfailprofanitycheck", "Incorrect return message");

            RevertSiteSpecificDisplayNameToBlank();

            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetSiteSuffixWithReferrFailProfanity_ExpectOk");
        }

        /// <summary>
        /// Test to make sure that we don't update the users username when they submit one
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetUserName_ExpectNoChange()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetUserName_ExpectNoChange");

            string newName = "This is my new name!";
            string originalUserName = _request.CurrentUserName;

            _request.RequestPage("UserDetails?cmd=SUBMIT&UserName=" + newName + "&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/USERNAME"),"Failed to find username in xml");
            Assert.AreEqual(originalUserName,xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/USERNAME").InnerText,"Username should not of changed!");

            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetUserName_ExpectNoChange");
        }

        /// <summary>
        /// Test that when we submit a valid sitesuffix that it updates the current user details
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdated()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdated");
            RevertSiteSpecificDisplayNameToBlank();

            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX"), "The current user should have a site suffix XML Node!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX").InnerText == "", "The current user should not have a site suffix!");

            string newSiteSuffix = "This is my new site suffix!";

            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + newSiteSuffix + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX"), "Failed to find SiteSuffix in xml");
            Assert.AreEqual(newSiteSuffix, xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX").InnerText, "SiteSuffix should of been changed!");

            RevertSiteSpecificDisplayNameToBlank();

            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdated");
        }


        /// <summary>
        /// Test that when we submit a valid sitesuffix that it updates the current user details and puts the nickname in the mod queue
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedandPutInModQueue()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedandPutInModQueue");
            RevertSiteSpecificDisplayNameToBlank();

            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX"), "The current user should have a site suffix XML Node!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX").InnerText == "", "The current user should not have a site suffix!");

            string newSiteSuffix = "This is my new site suffix!" + Guid.NewGuid().ToString();

            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + newSiteSuffix + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX"), "Failed to find SiteSuffix in xml");
            Assert.AreEqual(newSiteSuffix, xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX").InnerText, "SiteSuffix should of been changed!");

            string userName = _request.CurrentUserName;
            string moderationDisplayName = userName + "|" + newSiteSuffix;
            int modID = CheckNicknameModerationQueue(moderationDisplayName);
            Assert.IsTrue(modID != 0, "The current user should have their site suffix added to the modqueue!");

            RevertSiteSpecificDisplayNameToBlank();
            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedandPutInModQueue");
        }

        /// <summary>
        /// Test that when we submit a valid sitesuffix that it updates the current user details and puts the nickname in the mod queue
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedLengthTests()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedLengthTests");
            RevertSiteSpecificDisplayNameToBlank();

            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX"), "The current user should have a site suffix XML Node!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX").InnerText == "", "The current user should not have a site suffix!");

            TestSiteSpecificDisplayNameWithLength(255);
            TestSiteSpecificDisplayNameWithLength(254);
            TestSiteSpecificDisplayNameWithLength(1);
            TestSiteSpecificDisplayNameWithLength(127);

            RevertSiteSpecificDisplayNameToBlank();

            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedLengthTests");
        }

        /// <summary>
        /// Test that when we submit a sitesuffix that is too long the nickname is truncated at 255
        /// </summary>
        [TestMethod]
        public void TestSiteSpecificDisplayNameWithExceededLength()
        {
            string siteSpecificDisplayName = GetSiteSpecificDisplayName(300);
            string encodedSSDN = HttpUtility.UrlEncode(siteSpecificDisplayName);

            string expectedTruncatedSSDN = siteSpecificDisplayName.Substring(0, 255);

            //String should be truncated
            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + encodedSSDN + "&skin=purexml");
            XmlDocument xmlResponse = _request.GetLastResponseAsXML();
            ValidateBaseXML(xmlResponse);

            Assert.IsNotNull(xmlResponse.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX"), "Failed to find SiteSuffix in xml");
            Assert.AreEqual(expectedTruncatedSSDN, xmlResponse.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX").InnerText, "SiteSuffix should of been changed!");
        }

        /// <summary>
        /// Test that when we submit a sitesuffix that has leading and trailing whitespace is trimmed
        /// </summary>
        [TestMethod]
        public void TestSiteSpecificDisplayNameWithLeadingAndTrailingWhitespace()
        {
            string siteSpecificDisplayName = "  Here is my Test nickname.  ";
            string trimmedSSDN = siteSpecificDisplayName.Trim();

            //String should be truncated
            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + siteSpecificDisplayName + "&skin=purexml");
            XmlDocument xmlResponse = _request.GetLastResponseAsXML();
            ValidateBaseXML(xmlResponse);

            Assert.IsNotNull(xmlResponse.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX"), "Failed to find SiteSuffix in xml");
            Assert.AreEqual(trimmedSSDN, xmlResponse.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX").InnerText, "SiteSuffix should of been changed!");
        }

        private void RevertSiteSpecificDisplayNameToBlank()
        {
            //Set it back to blank to play nicely with other tests (and check setting to blank works too)
            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=&skin=purexml");
            _request.RequestPage("UserDetails?skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX").InnerText == "", "The current user should have had its site suffix reset to blank!");
        }

        private void TestSiteSpecificDisplayNameWithLength(int length)
        {
            string siteSpecificDisplayName = GetSiteSpecificDisplayName(length);
            string encodedSSDN = HttpUtility.UrlEncode(siteSpecificDisplayName);

            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + encodedSSDN + "&skin=purexml");
            XmlDocument xmlResponse = _request.GetLastResponseAsXML();
            ValidateBaseXML(xmlResponse);

            Assert.IsNotNull(xmlResponse.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX"), "Failed to find SiteSuffix in xml");
            Assert.AreEqual(siteSpecificDisplayName, xmlResponse.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX").InnerText, "SiteSuffix should of been changed!");
        }

        /// <summary>
        /// Gets a list of the printable ascii codes.
        /// </summary>
        /// <returns></returns>
        private string GetASCIIcodes()
        {
            string asciiCodes = String.Empty;
            for (int i=32;i < 127; i++)
            {
                asciiCodes += (char) i;
            }
            return asciiCodes;
        }

        /// <summary>
        /// Gets a string of random printable ascii characters of given length.
        /// </summary>
        /// <returns>A string of random ascii chars</returns>
        private string GetSiteSpecificDisplayName(int length)
        {
            string siteSpecificDisplayName = String.Empty;
            string asciiCodes = GetASCIIcodes();
            Random random = new Random(DateTime.Now.Millisecond);
            for (int i = 0; i < length; i++)
            {
                char randomChar = asciiCodes[random.Next(asciiCodes.Length)];
                //if the character at the start or beginning is a space
                if ((i == 0 || i == length-1) && randomChar == 32)
                {
                    randomChar = 'x';
                }

                siteSpecificDisplayName += randomChar;
            }

            return siteSpecificDisplayName;
        }

        /// <summary>
        /// Sets Nickname Moderation SiteOption.
        /// </summary>
        /// <param name="modStatus"></param>
        private void SetNicknameModerationStatus(int modStatus)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("delete from siteoptions where siteid=1 and name='NicknameModerationStatus'");

                reader.ExecuteDEBUGONLY("insert into siteoptions (section, siteid, name, value, type,description) " +
                   "values('Moderation',1,'NicknameModerationStatus'," + Convert.ToString(modStatus) + ", 0,'Nickname Moderation Status')");
            }

        }

        /// <summary>
        /// Checks Nickname Moderation Queue for existence of nickname
        /// </summary>
        /// <param name="nickname"></param>
        /// <returns></returns>
        private int CheckNicknameModerationQueue(string nickName)
        {
            int modId = 0;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from nicknamemod where nickname='" + nickName + "' and siteid = 1 and status = 0");
                if (reader.HasRows)
                {
                    reader.Read();
                    modId = reader.GetInt32("ModID");
                }
            }
            return modId;
        }

        /// <summary>
        /// Runs various tests against the xml returned
        /// </summary>
        /// <param name="baseXml">The XmlDocument containing the response</param>
        private void ValidateBaseXML(XmlDocument baseXml)
        {
            XmlNode xmlError = baseXml.SelectSingleNode("/H2G2/ERROR");
            Assert.IsTrue(xmlError == null, "H2G2 error returned");

            XmlNode xmlNode = baseXml.SelectSingleNode("/H2G2/USER-DETAILS-FORM");
            Assert.IsTrue(xmlNode != null, "Incorrect data returned");

            XmlNode xmlH2G2 = baseXml.SelectSingleNode("/H2G2");
            Assert.IsTrue(xmlH2G2.Attributes["TYPE"] != null, "Incorrect H2G2 type returned");
            Assert.IsTrue(xmlH2G2.Attributes["TYPE"].Value == "USERDETAILS", "Incorrect H2G2 type returned");

            DnaXmlValidator validator = new DnaXmlValidator(xmlNode.OuterXml, _schemaUri);
            validator.Validate();
        }

        /// <summary>
        /// Test that when we submit a valid sitesuffix that it updates 
        /// the current user details and puts the nickname in the mod queue
        /// passes it and redisplays it and checks the username hasn't been messed
        /// </summary>
        [TestMethod]
        public void UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedModeratedPass()
        {
            Console.WriteLine("Before UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedandPutInModQueue");
            RevertSiteSpecificDisplayNameToBlank();

            _request.RequestPage("UserDetails?skin=purexml");
            string userName = _request.CurrentUserName;

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX"), "The current user should have a site suffix XML Node!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX").InnerText == "", "The current user should not have a site suffix!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerText == userName, "The current user should be DotNetNormalUser!");

            string newSiteSuffix = "This is my new site suffix!" + Guid.NewGuid().ToString();

            _request.RequestPage("UserDetails?cmd=SUBMIT&SiteSuffix=" + newSiteSuffix + "&skin=purexml");
            xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX"), "Failed to find SiteSuffix in xml");
            Assert.AreEqual(newSiteSuffix, xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/PREFERENCES/SITESUFFIX").InnerText, "SiteSuffix should of been changed!");

            string moderationDisplayName = userName + "|" + newSiteSuffix;

            //Check the name is in the moderation queue
            int modID =  CheckNicknameModerationQueue(moderationDisplayName);
            Assert.IsTrue(modID != 0, "The current user should have their site suffix added to the modqueue!");

            //Pass the nickname
            PassModeratedNickName(modID);

            //Check the name is NOT in the moderation queue
            modID = CheckNicknameModerationQueue(moderationDisplayName);
            Assert.IsTrue(modID == 0, "The current user should not have their site suffix in the queue now!");

            //Get the user details check the new site suffix and 
            _request.RequestPage("UserDetails?skin=purexml");
            xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/SITESUFFIX").InnerText == newSiteSuffix, "The current user should have the new site suffix!");
            Assert.IsTrue(xml.SelectSingleNode("/H2G2/VIEWING-USER/USER/USERNAME").InnerText == userName, "The current user should NOT have had their username updated!");

            RevertSiteSpecificDisplayNameToBlank();
            Console.WriteLine("After UserDetailsTests - UserDetailsBuilder_SetSiteSuffix_ExpectSiteSuffixUpdatedandPutInModQueue");
        }

        private void PassModeratedNickName(int modID)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("ModerateNickname"))
            {
                reader.AddParameter("modid", modID);
                reader.AddParameter("status", 3);
                reader.Execute();
                if (reader.Read())
                {
                }
            }            
        }
       
    }
}