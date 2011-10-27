using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Threading;
using System.Linq;
using BBC.Dna.Utils;
using TestUtils;


namespace FunctionalTests
{
    [TestClass]
    public class ModeratorManagementPageTests
    {
        private const int _siteId = 1;
        private const int _modClassId = 3;//the one h2g2 is in

        /// <summary>
        /// Check Normal User Does not have access .
        /// </summary>
        [TestMethod]
        public void TestModeratorManagementPageNonSuperuser()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratorManagement?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
        }

        /// <summary>
        /// Check the Xml Schema.
        /// </summary>
        [TestMethod]
        public void TestModeratorManagementPageXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratorManagement?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2") != null, "The page does not exist!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, "H2G2ModeratorManagementPage.xsd");
            validator.Validate();
        }

        [TestMethod]
        public void MakeUserEditorOfSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&giveaccess=1&userid={0}&siteid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _siteId));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='editor']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _siteId));
            Assert.IsNotNull(node);

            CheckUserPermissions("EDITOR");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&removeaccess=1&userid={0}&siteid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserModeratorOfSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&giveaccess=1&userid={0}&siteid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNotNull(node);

            

            CheckUserPermissions("MODERATOR");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&removeaccess=1&userid={0}&siteid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserNotableOfSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&giveaccess=1&userid={0}&siteid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='notables']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNotNull(node);

            
            CheckUserPermissions("NOTABLES");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&removeaccess=1&userid={0}&siteid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserModeratorOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&giveaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNotNull(node);

            CheckUserPermissions("MODERATOR");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&removeaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserEditorOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&giveaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='editor']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNotNull(node);

            CheckUserPermissions("EDITOR");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&removeaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserNotableOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&giveaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='notables']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNotNull(node);

            CheckUserPermissions("NOTABLES");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&removeaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void UpdateUserAsModeratorToSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;

            //Check user is not moderator ro site beforehand.
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNull(node);

            //Update user and chack user is now moderator
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&updateuser=1&userid={0}&tosite={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNotNull(node);

        }

        [TestMethod]
        public void UpdateUserAsEditorToClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;

            //Check User isn't already editor to class
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNull(node);

            //Update user so user is editor for class and check XML.
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&updateuser=1&userid={0}&toclass={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, 1));
            Assert.IsNotNull(node);

        }


        private void CheckUserPermissions(string groupName)
        {
            DnaTestURLRequest request3 = new DnaTestURLRequest("h2g2");
            request3.SetCurrentUserNormal();
            //c# page
            request3.RequestPage("acs?skin=purexml");
            var xml = request3.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME[text()='" + groupName + "']"));
            //api
            var callinguser_url = @"https://" + DnaTestURLRequest.SecureServerAddress + @"/dna/api/users/UsersService.svc/V1/site/h2g2/users/callinguser";
            request3.RequestPageWithFullURL(callinguser_url);
            BBC.Dna.Users.User user = (BBC.Dna.Users.User)StringUtils.DeserializeObject(request3.GetLastResponseAsXML().OuterXml, typeof(BBC.Dna.Users.User));
            Assert.IsTrue(user.UsersListOfGroups.Exists(x => x.Name.ToUpper() == groupName.ToUpper()), "The group '" + groupName + "' not found in the users xml\r\n" + request3.GetLastResponseAsXML().OuterXml);
            //ripley page
            request3.RequestPage("frontpage?skin=purexml");
            xml = request3.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("//H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME[text()='" + groupName + "']"));

            

        }

        [TestCleanup]
        public void TearDown()
        {
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("delete from GroupMembers where UserId=" + TestUserAccounts.GetNormalUserAccount.UserID);
                    reader.ExecuteDEBUGONLY("delete from ModerationClassMembers where UserId=" + TestUserAccounts.GetNormalUserAccount.UserID);
                }
                inputcontext.SendSignal("action=recache-groups&userid=" + TestUserAccounts.GetNormalUserAccount.UserID);
            }
        }

        [TestMethod]
        public void TestModeratorManagementPage_AsEditor()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserEditor();
            request.UseEditorAuthentication = true;
            request.RequestPage(@"ModeratorManagement?skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNull(xml.SelectSingleNode("H2G2/ERROR"));

            var node = xml.SelectSingleNode("H2G2/MODERATION-CLASSES");
            Assert.AreEqual(0, node.ChildNodes.Count);
    
        }

        [TestMethod]
        public void MakeUserRefereeOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=referee&giveaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='referee']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNotNull(node);

            CheckUserPermissions("REFEREE");

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=referee&removeaccess=1&userid={0}&classid={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void UpdateUserAsEditorToSite_ThenAccessToolAsEditor()
        {
            //try as normal user
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage("ModeratorManagement?manage=moderator&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));

            //try as super user
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&updateuser=1&userid={0}&tosite={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _siteId));//adding to moderation

            //Check user is editor of site concerned.
            xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='editor']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", TestUserAccounts.GetNormalUserAccount.UserID, _siteId));
            Assert.IsNotNull(node);

            CheckUserPermissions("EDITOR");

            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;

            //Check User isn't already editor to class
            request.RequestPage("ModeratorManagement?manage=moderator&skin=purexml");
            xml = request.GetLastResponseAsXML();
            Assert.AreEqual(0, xml.SelectSingleNode("/H2G2/MODERATOR-LIST").ChildNodes.Count);
            Assert.AreEqual(2, xml.SelectSingleNode("/H2G2/SITE-LIST").ChildNodes.Count);
            


        }

        [TestMethod]
        public void UpdateUserAsEditorToClass_ThenAccessToolAsEditor()
        {
            //try as normal user
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;
            request.RequestPage("ModeratorManagement?manage=moderator&skin=purexml");

            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));

            //try as super user
            request.SetCurrentUserSuperUser();
            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&updateuser=1&userid={0}&toclass={1}&skin=purexml", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));//adding to moderation

            //Check user is editor of site concerned.
            xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='editor']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID/text()='{1}']", TestUserAccounts.GetNormalUserAccount.UserID, _modClassId));
            Assert.IsNotNull(node);

            CheckUserPermissions("EDITOR");

            request.SetCurrentUserNormal();
            request.UseEditorAuthentication = true;

            //Check User isn't already editor to class
            request.RequestPage("ModeratorManagement?manage=moderator&skin=purexml");
            xml = request.GetLastResponseAsXML();
            Assert.AreEqual(1, xml.SelectSingleNode("/H2G2/MODERATION-CLASSES").ChildNodes.Count);
            Assert.AreNotEqual(0, xml.SelectSingleNode("/H2G2/SITE-LIST").ChildNodes.Count);



        }

        private void SendSignal()
        {
            var url = String.Format("http://{0}/dna/h2g2/dnaSignal?action=recache-groups", DnaTestURLRequest.CurrentServer);
            var request = new DnaTestURLRequest("h2g2");
            //request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(url, null, "text/xml");

            url = String.Format("http://{0}/dna/api/comments/status.aspx?action=recache-groups", DnaTestURLRequest.CurrentServer);
            request.RequestPageWithFullURL(url, null, "text/xml");


        }

    }
}
