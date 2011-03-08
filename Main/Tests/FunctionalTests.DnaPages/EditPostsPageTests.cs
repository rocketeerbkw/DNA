using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using System.Net;


namespace FunctionalTests
{
    [TestClass]
    public class EditPostsPageTests
    {

        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.RestoreFromSnapshot();

            using (FullInputContext _context = new FullInputContext(""))
            {

                using (IDnaDataReader dataReader = _context.CreateDnaDataReader(""))
                {
                    dataReader.ExecuteDEBUGONLY("update threadentries set hidden=null where entryid=" + _postId.ToString());
                }
            }
        }

        //private int _threadId = 34;
        //private int _forumId = 7325075;
        private int _postId = 61;
        //private int _siteId = 70;//mbiplayer
        private string _siteName = "mbiplayer";

        [TestMethod]
        public void EditPost_AsNormalUser_ReturnsError()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserNormal();
            var xml = GetPost(request, @"editpost?skin=purexml&postid=" + _postId.ToString());
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
            Assert.IsNull(xml.SelectSingleNode("H2G2/POST-EDIT-FORM"));
        }

        [TestMethod]
        public void EditPost_MissingPostId_ReturnsError()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            var xml = GetPost(request, @"editpost?skin=purexml");
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/ERROR"));
            Assert.IsNull(xml.SelectSingleNode("H2G2/POST-EDIT-FORM"));
        }

        [TestMethod]
        public void EditPost_DoEdit_ReturnsEdittedPost()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            var xml = GetPost(request, @"editpost?skin=purexml&postid=" + _postId.ToString());

            Assert.IsNull(xml.SelectSingleNode("H2G2/ERROR"));
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/POST-EDIT-FORM"));

            var editForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, editForm.PostId);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("PostID", editForm.PostId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("Subject", editForm.Subject + "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("Text", editForm.Text + "1"));
            postParams.Enqueue(new KeyValuePair<string, string>("Update", "Update"));
            postParams.Enqueue(new KeyValuePair<string, string>("hidePostReason", ""));
            postParams.Enqueue(new KeyValuePair<string, string>("notes", "test"));

            request.RequestPage("editpost?skin=purexml", false, postParams);
            xml = request.GetLastResponseAsXML();

            var returnedForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, returnedForm.PostId);
            Assert.AreEqual(editForm.Subject + "1", returnedForm.Subject);
            Assert.AreEqual(editForm.Text + "1", returnedForm.Text);
        }

        [TestMethod]
        public void EditPost_FailPost_ReturnsFailedPost()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            var xml = GetPost(request, @"editpost?skin=purexml&postid=" + _postId.ToString());

            Assert.IsNull(xml.SelectSingleNode("H2G2/ERROR"));
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/POST-EDIT-FORM"));

            var editForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, editForm.PostId);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("PostID", editForm.PostId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("Subject", editForm.Subject));
            postParams.Enqueue(new KeyValuePair<string, string>("Text", editForm.Text));
            postParams.Enqueue(new KeyValuePair<string, string>("Update", "Update"));
            postParams.Enqueue(new KeyValuePair<string, string>("hidePostReason", "OffensiveInsert"));
            postParams.Enqueue(new KeyValuePair<string, string>("notes", "test"));

            request.RequestPage("editpost?skin=purexml", false, postParams);
            xml = request.GetLastResponseAsXML();

            var returnedForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, returnedForm.PostId);
            Assert.AreEqual(1, returnedForm.Hidden);
        }

        [TestMethod]
        public void EditPost_UnhidesPost_ReturnsUnhiddenPost()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_siteName);
            request.SetCurrentUserEditor();
            var xml = GetPost(request, @"editpost?skin=purexml&postid=" + _postId.ToString());

            Assert.IsNull(xml.SelectSingleNode("H2G2/ERROR"));
            Assert.IsNotNull(xml.SelectSingleNode("H2G2/POST-EDIT-FORM"));

            var editForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, editForm.PostId);

            var postParams = new Queue<KeyValuePair<string, string>>();
            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("PostID", editForm.PostId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("Subject", editForm.Subject));
            postParams.Enqueue(new KeyValuePair<string, string>("Text", editForm.Text));
            postParams.Enqueue(new KeyValuePair<string, string>("Update", "Update"));
            postParams.Enqueue(new KeyValuePair<string, string>("hidePostReason", "OffensiveInsert"));
            postParams.Enqueue(new KeyValuePair<string, string>("notes", "EditPost_UnhidesPost_ReturnsUnhiddenPost"));

            request.RequestPage("editpost?skin=purexml", false, postParams);
            xml = request.GetLastResponseAsXML();

            var returnedForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, returnedForm.PostId);
            Assert.AreEqual(1, returnedForm.Hidden);


            postParams = new Queue<KeyValuePair<string, string>>();
            postParams.Enqueue(new KeyValuePair<string, string>("PostID", editForm.PostId.ToString()));
            postParams.Enqueue(new KeyValuePair<string, string>("Subject", editForm.Subject));
            postParams.Enqueue(new KeyValuePair<string, string>("Text", editForm.Text));
            postParams.Enqueue(new KeyValuePair<string, string>("Update", "Update"));
            postParams.Enqueue(new KeyValuePair<string, string>("notes", "test"));

            request.RequestPage("editpost?skin=purexml", false, postParams);
            xml = request.GetLastResponseAsXML();

            returnedForm = (PostEditForm)StringUtils.DeserializeObjectUsingXmlSerialiser(xml.SelectSingleNode("H2G2/POST-EDIT-FORM").OuterXml, typeof(PostEditForm));
            Assert.AreEqual(_postId, returnedForm.PostId);
            Assert.AreEqual(0, returnedForm.Hidden);
        }

        private XmlDocument GetPost(DnaTestURLRequest request, string url)
        {
            request.UseEditorAuthentication = true;
            request.RequestPage(url);

            XmlDocument xml = request.GetLastResponseAsXML();


            return xml;
        }
    }
}
