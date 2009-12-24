﻿using System;
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
    [TestClass]
    public class ModeratorManagementPageTests
    {
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

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&giveaccess=1&userid={0}&siteid={1}&skin=purexml",request2.CurrentUserID,1) );

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='editor']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]",request2.CurrentUserID,1) );
            Assert.IsNotNull(node);

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&removeaccess=1&userid={0}&siteid={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserModeratorOfSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&giveaccess=1&userid={0}&siteid={1}&skin=purexml", request2.CurrentUserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&removeaccess=1&userid={0}&siteid={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserNotableOfSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&giveaccess=1&userid={0}&siteid={1}&skin=purexml", request2.CurrentUserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='notables']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&removeaccess=1&userid={0}&siteid={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserModeratorOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&giveaccess=1&userid={0}&classid={1}&skin=purexml", request2.CurrentUserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&removeaccess=1&userid={0}&classid={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserEditorOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&giveaccess=1&userid={0}&classid={1}&skin=purexml", request2.CurrentUserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='editor']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=editor&removeaccess=1&userid={0}&classid={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void MakeUserNotableOfClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&giveaccess=1&userid={0}&classid={1}&skin=purexml", request2.CurrentUserID, 1));

            //Check user is editor of site concerned.
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='notables']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

            //Remove Access
            request.RequestPage(String.Format("ModeratorManagement?manage=notables&removeaccess=1&userid={0}&classid={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);
        }

        [TestMethod]
        public void UpdateUserAsModeratorToSite()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;

            //Check user is not moderator ro site beforehand.
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&skin=purexml", request2.CurrentUserID, 1));
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);

            //Update user and chack user is now moderator
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&updateuser=1&userid={0}&tosite={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/SITES/SITE[@SITEID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

        }

        [TestMethod]
        public void UpdateUserAsEditorToClass()
        {
            DnaTestURLRequest request = new DnaTestURLRequest("moderation");
            request.SetCurrentUserSuperUser();

            DnaTestURLRequest request2 = new DnaTestURLRequest("moderation");
            request2.SetCurrentUserNormal();

            request.UseEditorAuthentication = true;

            //Check User isn't already editor to class
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&skin=purexml", request2.CurrentUserID, 1));
            XmlDocument xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            XmlNode node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNull(node);

            //Update user so user is editor for class and check XML.
            request.RequestPage(String.Format("ModeratorManagement?manage=moderator&updateuser=1&userid={0}&toclass={1}&skin=purexml", request2.CurrentUserID, 1));
            xml = request.GetLastResponseAsXML();
            Assert.IsNotNull(xml.SelectSingleNode("/H2G2/MODERATOR-LIST[@GROUPNAME='moderator']"));
            node = xml.SelectSingleNode(String.Format("/H2G2/MODERATOR-LIST/MODERATOR[USER/USERID={0}]/CLASSES[CLASSID={1}]", request2.CurrentUserID, 1));
            Assert.IsNotNull(node);

        }
    }
}
