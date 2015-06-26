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
    /// Comment List Tests
    /// </summary>
    [TestClass]
    public class CommentsListTests
    {
        /// <summary>
        /// Test that we get a correct list of comments for a given user
        /// </summary>
        [TestMethod]
        public void TestGetCommentsListForUser6()
        {
            Console.WriteLine("Before CommentLists - TestGetCommentsListForUser6");
            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            User user = new User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the CommentList object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getusercommentsstats"))
            {
                using (IDnaDataReader reader2 = context.CreateDnaDataReader("fetchgroupsandmembers"))
                {
                    Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getusercommentsstats").Will(Return.Value(reader));
                    Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("fetchgroupsandmembers").Will(Return.Value(reader2));

                    // Create a new CommentsList object and get the list of comments
                    CommentsList testCommentsList = new CommentsList(mockedInputContext);
                    Assert.IsTrue(testCommentsList.CreateRecentCommentsList(6, 1, 0, 20));
                }
            }
            Console.WriteLine("After CommentLists - TestGetCommentsListForUser6");
        }
    }
}
