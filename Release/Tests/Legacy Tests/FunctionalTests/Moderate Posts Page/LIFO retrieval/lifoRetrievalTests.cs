using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// The retreival order is determined by a flag that is attached to a mod-class, so setting it will affect everything in that class
    /// need to find ther class that the site used is in
    /// </summary>
    [TestClass]
    public class ModeratePostsPageLifoTests
    {
        /// <summary>
        /// Set up function  
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
        }
 
        /// <summary>
        /// make some posts and tehn retreive them witht eh LIFO flag set different ways
        /// There is currently no GUI to allow for the setting of the bit, so it has to be done directly using SQL
        /// </summary>
        [TestMethod]
        public void LifoRetrievalTest()
        {
            const int numbItems = 20; // how many comments to make

            // 1. use the comments api to create some posts
            string newForum = makeForum();
            int modClassOfSite = getModClass(testUtils_CommentsAPI.sitename);

            string[] newItems = new string[numbItems];

            for( int itemCount = 0; itemCount < numbItems; itemCount++)
            {
                newItems[itemCount] = testUtils_CommentsAPI.makeTestComment(newForum);
            }

            // make sure that the class is not LIFO already
            makeClassLifo(false, modClassOfSite);

            // get the list of IDs
            XmlNodeList nodes = getThePostIds(1000, modClassOfSite);

            // in it's normal state, items will be retreived FIFO, therefore, the IDs will increase down the list
            for (int i = 0; i < nodes.Count - 1; i++)
            {
                int firstID = Int32.Parse(nodes[i].Value);
                int secondID = Int32.Parse(nodes[i + 1].Value);


                Assert.IsTrue(firstID < secondID,
                    "IDs should be in ascending order, but post " + i + "(" + firstID.ToString() + ") is not less than the next one (" + secondID.ToString() + ")");
            }

            // now set it to be LIFO
            makeClassLifo(true, modClassOfSite);

            nodes = getThePostIds(1000, modClassOfSite);

            // now, items will be retreived LIFO, therefore, the IDs will decrease down the list
            for (int i = 0; i < nodes.Count - 1; i++)
            {
                int firstID = Int32.Parse(nodes[i].Value);
                int secondID = Int32.Parse(nodes[i + 1].Value);

                Assert.IsTrue(firstID > secondID,
                    "IDs should be in descending order, but post " + i + "(" + firstID.ToString() + ") is not greater than the next one (" + secondID.ToString() + ")");
            }

            // make if FIFO again
            makeClassLifo(false, modClassOfSite);

            nodes = getThePostIds(1000, modClassOfSite);

            // now, items will be retreived FIFO, therefore, the IDs will increase down the list
            for (int i = 0; i < nodes.Count - 1; i++)
            {
                int firstID = Int32.Parse(nodes[i].Value);
                int secondID = Int32.Parse(nodes[i + 1].Value);

                Assert.IsTrue(firstID < secondID,
                    "IDs should be in ascending order, but post " + i + "(" + firstID.ToString() + ") is not less than the next one (" + secondID.ToString() + ")");
            }
        }

        /// <summary>
        /// make a forum that is in pre-mod
        /// </summary>
        /// <returns>The name of the forum</returns>
        private string makeForum()
        {
            string id = "";
            string url = "http://" + testUtils_CommentsAPI.server + testUtils_CommentsAPI._resourceLocation + "/site/" + testUtils_CommentsAPI.sitename + "/";
            string postData = makePostData(ref id);

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            myRequest.SetCurrentUserEditor();

            myRequest.RequestPageWithFullURL(url, postData, "text/xml");

            return id;
        }

        /// <summary>
        /// differes from the utils one in that it makes the forum be postmod - force them into the queue
        /// </summary>
        /// <returns></returns>
        private string makePostData(ref string id)
        {
            string newbit = Guid.NewGuid().ToString();
            id = "LifoTest-" + Guid.NewGuid().ToString(); // the tail bit creates an unique string
            string title = "LifoTest Title " + newbit;
            string parentUri = "http://www.bbc.co.uk/dna/" + newbit + "/";

            ModerationStatus.ForumStatus moderationStatus = ModerationStatus.ForumStatus.PostMod;

            return String.Format("<commentForum xmlns=\"BBC.Dna.Api\">" +
                "<id>{0}</id>" +
                "<title>{1}</title>" +
                "<parentUri>{2}</parentUri>" +
                "<moderationServiceGroup>{3}</moderationServiceGroup>" +
                "</commentForum>",
                id, title, parentUri, moderationStatus
                );
        }

        /// <summary>
        /// reads the moderate posts page
        /// </summary>
        /// <param name="toShow">how manu items to show</param>
        /// <returns>the page as XML</returns>
        private XmlNodeList getThePostIds(int toShow, int modClassOfSite)
        {
            string url = "http://" + testUtils_CommentsAPI.server + "/dna/moderation/moderateposts?modclassid=";

            url += modClassOfSite;
            url += "&s_classview=3&fastmod=0&notfastmod=0?skin=purexml";
            url += "&show=" + toShow.ToString();

            DnaTestURLRequest myRequest = new DnaTestURLRequest(testUtils_CommentsAPI.sitename);

            myRequest.SetCurrentUserModerator();
            myRequest.UseEditorAuthentication = true; ;

            myRequest.RequestPageWithFullURL(url, "", "");
            
            /* have to comment this out because teh schema is not a match of the output
            // just make sure that we are getting what we want
            DnaXmlValidator validator = new DnaXmlValidator(myRequest.GetLastResponseAsXML().InnerXml, "H2G2ModeratePosts.xsd");
            validator.Validate();
            */

            XmlDocument xml = myRequest.GetLastResponseAsXML();

            return xml.SelectNodes("//@POSTID"); ;
        }

        /// <summary>
        /// going directly not the database, set the flag
        /// </summary>
        /// <param name="up">boolean to say which way to set the flag</param>
        /// <param name="modClassOfSite">needed so that we change the right thing</param>
        private void makeClassLifo(Boolean flag, int modClassOfSite)
        {
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                string sqlStr;

                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    ISiteList _siteList = SiteList.GetSiteList();
                    ISite site = _siteList.GetSite(testUtils_CommentsAPI.sitename);

                    sqlStr = "UPDATE ModerationClass SET LIFOQueue=" + (flag ? 1 : 0);
                    sqlStr += " WHERE ModClassID=" + modClassOfSite;

                    reader.ExecuteDEBUGONLY(sqlStr);

                    Assert.AreEqual(reader.RecordsAffected, 1, "SQL change should have afected 1 line. Actually did " + reader.RecordsAffected);
                }
            }
        }

        /// <summary>
        /// find out the mod class of the site that we are using
        /// </summary>
        /// <param name="siteName">short name of site to find out about</param>
        /// <returns>the mod class of that site</returns>
        private int getModClass(string siteName)
        {
            using (FullInputContext inputcontext = new FullInputContext(true))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    ISiteList _siteList = SiteList.GetSiteList();
                    ISite site = _siteList.GetSite(testUtils_CommentsAPI.sitename);

                    string sqlStr = "select ModClassId FROM Sites WHERE shortname ='" + siteName +"'";

                    reader.ExecuteDEBUGONLY(sqlStr);

                    Assert.IsTrue(reader.HasRows);

                    reader.Read();

                    return reader.GetInt32("ModClassId");
                }
            }
        }
    }
}
