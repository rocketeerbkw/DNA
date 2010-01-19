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
        [TestMethod]
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
        [TestMethod]
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
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test07ChangeNickNameProfanityBlocked()
        {
            Console.WriteLine("Before UserDetailsTests - Test07ChangeNickNameProfanity");

            SetNicknameModerationStatus(0);

            string profanityUsername = "fuck";

            //change the skin
            _request.RequestPage("UserDetails?cmd=SUBMIT&UserName=" + profanityUsername + "&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            XmlNode xmlMessage = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/MESSAGE");
            Assert.IsTrue(xmlMessage != null, "Incorrect return message");
            Assert.IsTrue(xmlMessage.InnerText != String.Empty, "Incorrect return message");
            Assert.IsTrue(xmlMessage.Attributes["TYPE"].Value == "nicknamefailprofanitycheck", "Incorrect return message");


            Console.WriteLine("After UserDetailsTests - Test07ChangeNickNameProfanity");
        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test08ChangeNickNameProfanityReferred()
        {
            Console.WriteLine("Before UserDetailsTests - Test07ChangeNickNameProfanity");

            string profanityUsername = "arse";

            SetNicknameModerationStatus(0);

            _request.RequestPage("UserDetails?cmd=SUBMIT&UserName=" + profanityUsername + "&skin=purexml");
            XmlDocument xml = _request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            XmlNode xmlMessage = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/MESSAGE");
            Assert.IsFalse(xmlMessage.Attributes["TYPE"].Value == "nicknamefailprofanitycheck", "Incorrect return message");

            // Check that Nickname is in moderation queue due to referred profanity.
            Assert.IsTrue(CheckNicknamModerationQueue(profanityUsername));

        }

        /// <summary>
        /// Test that we can get coming up page
        /// </summary>
        [TestMethod]
        public void Test09ModifyUserNamePreModerated()
        {
            Console.WriteLine("Before UserDetailsTests - Test08ModifyUserNamePreModeratedSite");

            //set up h2g2 site as premod
            SetNicknameModerationStatus(2);

            //request the page
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPage("UserDetails?skin=purexml&_ns=1");
            XmlDocument xml = request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original username
            XmlNode xmlUserName = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/USERNAME");
            Assert.IsTrue(xmlUserName != null, "Incorrect user mode returned");
            string originalUsername = xmlUserName.InnerText;
            string newUserName = originalUsername + Guid.NewGuid().ToString();

            request.RequestPage("UserDetails?cmd=SUBMIT&UserName=" + newUserName + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            XmlNode xmlMessage = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/MESSAGE");
            Assert.IsTrue(xmlMessage != null, "Incorrect return message");
            Assert.IsTrue(xmlMessage.InnerText != String.Empty, "Incorrect return message");
            Assert.IsTrue(xmlMessage.Attributes["TYPE"].Value == "usernamepremoderated", "Incorrect return message");

            // Check Username not changed.
            xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM[USERNAME='" + originalUsername + "']");
            Assert.IsNotNull(xmlUserName, "Username has not been updated");
            Assert.IsTrue(CheckNicknamModerationQueue(newUserName), "Nickname change is in moderation queue");
        }

        [TestMethod]
        public void Test10ModifyUserNamePostModerated()
        {
            SetNicknameModerationStatus(1);

            //request the page
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPage("UserDetails?skin=purexml&_ns=1");
            XmlDocument xml = request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original username
            XmlNode xmlUserName = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/USERNAME");
            Assert.IsTrue(xmlUserName != null, "Incorrect user mode returned");
            string originalUsername = xmlUserName.InnerText;
            string newUserName = originalUsername +Guid.NewGuid().ToString();

            request.RequestPage("UserDetails?cmd=SUBMIT&UserName=" + newUserName + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            // Check Username changed.
            xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM[USERNAME='" + newUserName + "']");
            Assert.IsNotNull(xmlUserName, "Username has been updated");
            Assert.IsTrue(CheckNicknamModerationQueue(newUserName), "Nickname change is in moderation queue");

        }

        [TestMethod]
        public void Test11ModifyUserNameUnModerated()
        {
            SetNicknameModerationStatus(0);

            //request the page
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPage("UserDetails?skin=purexml&_ns=1");
            XmlDocument xml = request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            //get the original username
            XmlNode xmlUserName = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM/USERNAME");
            Assert.IsTrue(xmlUserName != null, "Incorrect user mode returned");
            string originalUsername = xmlUserName.InnerText;
            string newUserName = originalUsername + Guid.NewGuid().ToString();

            request.RequestPage("UserDetails?cmd=SUBMIT&UserName=" + newUserName + "&skin=purexml");
            xml = request.GetLastResponseAsXML();
            ValidateBaseXML(xml);

            // Check Username changed.
            xmlUserName = xml.SelectSingleNode("/H2G2/USER-DETAILS-FORM[USERNAME='" + newUserName + "']");
            Assert.IsNotNull(xmlUserName, "Username has been updated");
            Assert.IsFalse(CheckNicknamModerationQueue(newUserName), "Nickname change is not in moderation queue");
            
        }
        

        /// <summary>
        /// Sets Nickname Moderation SiteOption.
        /// </summary>
        /// <param name="modStatus"></param>
        private void SetNicknameModerationStatus( int modStatus )
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
        private bool CheckNicknamModerationQueue(string nickName)
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("select * from nicknamemod where nickname='" + nickName + "' and siteid = 1 and status = 0");
                return reader.HasRows;
            }
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

       
    }
}