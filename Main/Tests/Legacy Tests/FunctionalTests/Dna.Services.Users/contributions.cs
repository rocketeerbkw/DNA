using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Site;
using BBC.Dna;
using BBC.Dna.Data;

namespace FunctionalTests.Dna.Services.Users
{
    /// <summary>
    /// Summary description for contributions
    /// </summary>
    [TestClass]
    public class contributions
    {
        static string test_contributionsUrl;
        static string test_user_idString;
        static int test_dnauserid = 1090501859;
        static string test_identityuserid = "6042002"; // mapped to the associated test_dnauserid
        static string test_username = "U1090501859";

        static int test_blog_siteId = 73; // identity blog
        static string test_blog_url = "identityblogs"; 
        //int test_blog_commentForumId = 0;        
        static string test_blog_commentUniqueForumID = "blogUniqueID";  
        static string test_blog_titleText = "blog title test";
        //static string test_blog_subjectText = "blog subject";
        static string test_blog_commentText = "blog comment new";
        static int test_blog_postId;

        //int test_messageboard_siteId = 27; // five live
        // static string test_messageboard_name = "identityblogs";
        static string test_messageboard_url = "mbfivelive"; 
        static int test_messageBoard_forumId = 2148567;  // tennis
        static int test_messageboard_postId;
        static string test_messageboard_subjectText = "message board title";
        static string test_messageboard_commentText = "message board post text";

        static int test_community_siteId = 1;  // h2g2   
        static string test_community_url = "h2g2"; 
        static int test_community_forumId = 19585; // ask h2g2
        static int test_community_postId;
        static string test_community_subjectText = "community title";
        static string test_community_content = "community post text";

        //int test_embeddedComments_siteId = 72;  // haveyoursay    
        static string test_embeddedComments_url = "haveyoursay"; 
        static int test_embeddedComments_forumId = 7619031; // test message
        static int test_embeddedComments_postId;
        static string test_embeddedComments_subjectText = "embedded comments title";
        static string test_embeddedComments_content = "embedded comments text";

        public contributions()
        {
            test_contributionsUrl = @"http://" + DnaTestURLRequest.CurrentServer + @"/dna/api/users/UsersService.svc/V1/usercontributions/{user}";
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
        
        /// <summary>
        /// The setup will restore the snapshot, and create a user with one of each type of contribution.
        /// </summary>
        [ClassInitialize]
        public static void StartUp(TestContext testContext)
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // create the test user
            using (IDnaDataReader reader = context.CreateDnaDataReader("createnewuserfromssoid"))
            {
                reader.AddParameter("@ssouserid", test_dnauserid)
                .AddParameter("@username", test_username)
                .AddParameter("@email", "")
                .AddParameter("@siteid", test_community_siteId);
                reader.Execute();
            }

            // get a well known comment forum (blog)
            using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
            {
                reader.AddParameter("@uid", test_blog_commentUniqueForumID)
                .AddParameter("@url", "http://www.bbc.co.uk/comment.shtml")
                .AddParameter("@title", test_blog_titleText)
                .AddParameter("@siteid", test_blog_siteId)
                .AddParameter("@frompostindex", 0)
                .AddParameter("topostindex", 0)
                .AddParameter("@show", 5)
                .AddParameter("@createifnotexists", 1)
                .AddParameter("@duration", 1000)
                .AddParameter("@moderationstatus", 3);
                reader.Execute();
                reader.Read();
                test_blog_postId = reader.GetInt32("ForumID");
            }

            // post a comment to a comment forum for SiteType = Blog (1)
            using (IDnaDataReader reader = context.CreateDnaDataReader("createcomment"))
            {
                Guid hash = DnaHasher.GenerateCommentHashValue(test_blog_commentText, test_blog_commentUniqueForumID, test_dnauserid);
                reader.AddParameter("@uniqueid", test_blog_commentUniqueForumID)
                .AddParameter("@userid", test_dnauserid)
                .AddParameter("@siteid", test_blog_siteId)
                .AddParameter("@content", test_blog_commentText)
                .AddParameter("@hash", hash)
                .AddParameter("@forcemoderation", 0)
                .AddParameter("@ignoremoderation", 1)
                .AddParameter("@isnotable", 0)
                .AddParameter("@poststyle", 2)
                .Execute()
                .Read();
                test_blog_postId = reader.GetInt32("postid");
            }

            // post a message on a forum for SiteType = Community (2)
            using (IDnaDataReader reader = context.CreateDnaDataReader("posttoforum"))
            {
                Guid hash = DnaHasher.GenerateCommentHashValue(test_community_content, test_community_forumId.ToString(), test_dnauserid);

                reader.AddParameter("@userid", test_dnauserid)
                .AddParameter("@forumid", test_community_forumId)
                .AddParameter("@inreplyto", DBNull.Value)
                .AddParameter("@threadid", DBNull.Value)
                .AddParameter("@subject", test_community_subjectText)
                .AddParameter("@content", test_community_content)
                .AddParameter("@poststyle", 2)
                .AddParameter("@keywords", DBNull.Value)
                .AddParameter("@hash", hash)
                .AddParameter("@forcemoderate", 0)
                .AddParameter("@ignoremoderation", 0)
                .AddParameter("@keyphrases", "")
                .AddParameter("@allowqueuing", 1)
                .AddParameter("@bbcuid", "449206f2-35af-110c-a116-0003ba0c07a5")
                .AddParameter("@isnotable", 0)
                .AddParameter("@iscomment", 0);
                reader.Execute();
                reader.Read();
                test_community_postId = reader.GetInt32("postid");
            }

            // post a message on a forum for SiteType = Messageboard (3)
            using (IDnaDataReader reader = context.CreateDnaDataReader("posttoforum"))
            {
                Guid hash = DnaHasher.GenerateCommentHashValue(test_messageboard_commentText, test_messageBoard_forumId.ToString(), test_dnauserid);

                reader.AddParameter("@userid", test_dnauserid)
                .AddParameter("@forumid", test_messageBoard_forumId)	
                .AddParameter("@inreplyto", DBNull.Value)
                .AddParameter("@threadid", DBNull.Value)
                .AddParameter("@subject", test_messageboard_subjectText)
                .AddParameter("@content", test_messageboard_commentText)
                .AddParameter("@poststyle", 2)
                .AddParameter("@keywords", DBNull.Value)
                .AddParameter("@hash", hash)
                .AddParameter("@forcemoderate", 0)
                .AddParameter("@ignoremoderation", 0)
                .AddParameter("@keyphrases", "")
                .AddParameter("@allowqueuing", 1)
                .AddParameter("@bbcuid", "449206f2-35af-110c-a116-0003ba0c07a5")
                .AddParameter("@isnotable", 0)
                .AddParameter("@iscomment", 0);
                reader.Execute();
                reader.Read();
                test_messageboard_postId = reader.GetInt32("postid");
            }

            // post a message on a forum for SiteType = EmbeddedComments (4)
            using (IDnaDataReader reader = context.CreateDnaDataReader("posttoforum"))
            {
                Guid hash = DnaHasher.GenerateCommentHashValue(test_embeddedComments_content, test_embeddedComments_forumId.ToString(), test_dnauserid);

                reader.AddParameter("@userid", test_dnauserid)
                .AddParameter("@forumid", test_embeddedComments_forumId)
                .AddParameter("@inreplyto", DBNull.Value)
                .AddParameter("@threadid", DBNull.Value)
                .AddParameter("@subject", test_embeddedComments_subjectText)
                .AddParameter("@content", test_embeddedComments_content)
                .AddParameter("@poststyle", 2)
                .AddParameter("@keywords", DBNull.Value)
                .AddParameter("@hash", hash)
                .AddParameter("@forcemoderate", 0)
                .AddParameter("@ignoremoderation", 0)
                .AddParameter("@keyphrases", "")
                .AddParameter("@allowqueuing", 1)
                .AddParameter("@bbcuid", "449206f2-35af-110c-a116-0003ba0c07a5")
                .AddParameter("@isnotable", 0)
                .AddParameter("@iscomment", 0);
                reader.Execute();
                reader.Read();
                test_embeddedComments_postId = reader.GetInt32("postid");
            }
            test_user_idString = test_dnauserid.ToString();
        }


        [TestMethod]
        public void GetUserContributionsForSiteJSON_UserWithContributions_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUserContributionsForSiteJSON_UserWithContributions_ReturnsValidJSON");

            string contributions_for_site_json_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "/site/h2g2?format=json";
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_site_json_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(Contributions));

            foreach (Contribution contribution in contributions.ContributionItems)
            {
                Assert.AreEqual("h2g2", contribution.SiteUrl);
            }

            Console.WriteLine("After GetUserContributionsForSiteJSON_UserWithContributions_ReturnsValidJSON");
        }

        [TestMethod]
        public void GetUserContributionsForSiteXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsForSiteXML_UserWithContributions_ReturnsValidXML");

            string contributions_for_site_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "/site/h2g2?format=xml";
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_site_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));

            foreach (Contribution contribution in contributions.ContributionItems)
            {
                Assert.AreEqual("h2g2", contribution.SiteUrl);
            }

            Console.WriteLine("After GetUserContributionsForSiteXML_UserWithContributions_ReturnsValidXML");
        }

        [TestMethod]
        public void GetUserContributionsJSON_UserWithContributions_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUserContributionsJSON_UserWithContributions_ReturnsValidJSON");

            string contributions_json_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "?format=json";
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_json_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(Contributions));

            Contribution blogContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 4];
            Contribution communityContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 3];
            Contribution messageBoardContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 2];            
            Contribution embeddedCommentsContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 1];

            Assert.AreEqual(test_blog_titleText, blogContribution.Title);
            Assert.AreEqual(test_blog_commentText, blogContribution.Body);
            Assert.AreEqual(test_blog_postId, blogContribution.ThreadEntryID);
            Assert.AreEqual(test_blog_url, blogContribution.SiteUrl);

            Assert.AreEqual(test_community_subjectText, communityContribution.Subject);
            Assert.AreEqual(test_community_content, communityContribution.Body);
            Assert.AreEqual(test_community_postId, communityContribution.ThreadEntryID);
            Assert.AreEqual(test_community_url, communityContribution.SiteUrl);

            Assert.AreEqual(test_messageboard_subjectText, messageBoardContribution.Subject);
            Assert.AreEqual(test_messageboard_commentText, messageBoardContribution.Body);
            Assert.AreEqual(test_messageboard_postId, messageBoardContribution.ThreadEntryID);
            Assert.AreEqual(test_messageboard_url, messageBoardContribution.SiteUrl);

            Assert.AreEqual(test_embeddedComments_subjectText, embeddedCommentsContribution.Subject);
            Assert.AreEqual(test_embeddedComments_content, embeddedCommentsContribution.Body);
            Assert.AreEqual(test_embeddedComments_url, embeddedCommentsContribution.SiteUrl);
            Assert.AreEqual(test_embeddedComments_postId, embeddedCommentsContribution.ThreadEntryID);


            Console.WriteLine("After GetUserContributionsJSON_UserWithContributions_ReturnsValidJSON");

        }

        [TestMethod]
        public void GetUserContributionsXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsXML_UserWithContributions_ReturnsValidXML");

            string contributions_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "?format=xml";
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));

            Contribution blogContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 4];
            Contribution communityContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 3];
            Contribution messageBoardContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 2];
            Contribution embeddedCommentsContribution = contributions.ContributionItems[contributions.ContributionItems.Count - 1];

            Assert.AreEqual(test_blog_titleText, blogContribution.Title);
            Assert.AreEqual(test_blog_commentText, blogContribution.Body);
            Assert.AreEqual(test_blog_postId, blogContribution.ThreadEntryID);
            Assert.AreEqual(test_blog_url, blogContribution.SiteUrl);

            Assert.AreEqual(test_community_subjectText, communityContribution.Subject);
            Assert.AreEqual(test_community_content, communityContribution.Body);
            Assert.AreEqual(test_community_postId, communityContribution.ThreadEntryID);
            Assert.AreEqual(test_community_url, communityContribution.SiteUrl);

            Assert.AreEqual(test_messageboard_subjectText, messageBoardContribution.Subject);
            Assert.AreEqual(test_messageboard_commentText, messageBoardContribution.Body);
            Assert.AreEqual(test_messageboard_postId, messageBoardContribution.ThreadEntryID);
            Assert.AreEqual(test_messageboard_url, messageBoardContribution.SiteUrl);

            Assert.AreEqual(test_embeddedComments_subjectText, embeddedCommentsContribution.Subject);
            Assert.AreEqual(test_embeddedComments_content, embeddedCommentsContribution.Body);
            Assert.AreEqual(test_embeddedComments_url, embeddedCommentsContribution.SiteUrl);
            Assert.AreEqual(test_embeddedComments_postId, embeddedCommentsContribution.ThreadEntryID);

            Console.WriteLine("After GetUserContributionsXML_UserWithContributions_ReturnsValidXML");

        }

        [TestMethod]
        public void GetUserContributionsForAllTypesJSON_UserWithContributions_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUserContributionsForAllTypesJSON_UserWithContributions_ReturnsValidJSON");

            string contributions_for_type_json_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "?format=json";
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_json_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(Contributions));
            bool containsBlog = ((from c in contributions.ContributionItems where c.SiteType == SiteType.Blog select c).FirstOrDefault() != null);
            bool containsMessageboard = ((from c in contributions.ContributionItems where c.SiteType == SiteType.Messageboard select c).FirstOrDefault() != null);
            bool containsCommunity = ((from c in contributions.ContributionItems where c.SiteType == SiteType.Community select c).FirstOrDefault() != null);
            bool containsEmbeddedComments = ((from c in contributions.ContributionItems where c.SiteType == SiteType.EmbeddedComments select c).FirstOrDefault() != null);

            Assert.AreEqual(true, containsBlog);
            Assert.AreEqual(true, containsMessageboard);
            Assert.AreEqual(true, containsCommunity);
            Assert.AreEqual(true, containsEmbeddedComments);

            Console.WriteLine("After GetUserContributionsForAllTypesJSON_UserWithContributions_ReturnsValidJSON");
        }

        [TestMethod]
        public void GetUserContributionsForAllTypesWithPagingJSON_UserWithContributions_ReturnsValidJSON()
        {
            Console.WriteLine("Before GetUserContributionsForAllTypesWithPagingJSON_UserWithContributions_ReturnsValidJSON");

            string contributions_for_type_json_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "?format=json";
            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_json_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeJSONObject(request.GetLastResponseAsString(), typeof(Contributions));


            Console.WriteLine("After GetUserContributionsForAllTypesWithPagingJSON_UserWithContributions_ReturnsValidJSON");

        }

        [TestMethod]
        public void GetUserContributionsForAllTypesXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsForAllTypesXML_UserWithContributions_ReturnsValidXML");

            string contributions_for_type_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));
            
            bool containsBlog = ((from c in contributions.ContributionItems where c.SiteType == SiteType.Blog select c).FirstOrDefault() != null);
            bool containsMessageboard = ((from c in contributions.ContributionItems where c.SiteType == SiteType.Messageboard select c).FirstOrDefault() != null);
            bool containsCommunity = ((from c in contributions.ContributionItems where c.SiteType == SiteType.Community select c).FirstOrDefault() != null);
            bool containsEmbeddedComments = ((from c in contributions.ContributionItems where c.SiteType == SiteType.EmbeddedComments select c).FirstOrDefault() != null);

            Assert.AreEqual(true, containsBlog);
            Assert.AreEqual(true, containsMessageboard);
            Assert.AreEqual(true, containsCommunity);
            Assert.AreEqual(true, containsEmbeddedComments);


            Console.WriteLine("After GetUserContributionsForAllTypesXML_UserWithContributions_ReturnsValidXML");
        }

        [TestMethod]
        public void GetUserContributionsForBlogTypeXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsForBlogTypeXML_UserWithContributions_ReturnsValidXML");

            string contributions_for_type_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "/type/Blog?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));

            foreach (Contribution contribution in contributions.ContributionItems)
            {
                Assert.AreEqual(SiteType.Blog, contribution.SiteType);
            }

            Console.WriteLine("After GetUserContributionsForBlogTypeXML_UserWithContributions_ReturnsValidXML");
        }


        [TestMethod]
        public void GetUserContributionsForMessageBoardTypeXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsForMessageBoardTypeXML_UserWithContributions_ReturnsValidXML");

            string contributions_for_type_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "/type/Messageboard?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));

            foreach (Contribution contribution in contributions.ContributionItems)
            {
                Assert.AreEqual(SiteType.Messageboard, contribution.SiteType);
            }

            Console.WriteLine("After GetUserContributionsForMessageBoardTypeXML_UserWithContributions_ReturnsValidXML");
        }

        [TestMethod]
        public void GetUserContributionsForCommunityTypeXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsForTypeXML_UserWithContributions_ReturnsValidXML");

            string contributions_for_type_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "/type/Community?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));

            foreach (Contribution contribution in contributions.ContributionItems)
            {
                Assert.AreEqual(SiteType.Community, contribution.SiteType);
            }
            Console.WriteLine("After GetUserContributionsForCommunityTypeXML_UserWithContributions_ReturnsValidXML");
        }

        [TestMethod]
        public void GetUserContributionsForEmbeddedCommentsTypeXML_UserWithContributions_ReturnsValidXML()
        {
            Console.WriteLine("Before GetUserContributionsForEmbeddedCommentsTypeXML_UserWithContributions_ReturnsValidXML");

            string contributions_for_type_xml_url = test_contributionsUrl.Replace("{user}", test_identityuserid) + "/type/EmbeddedComments?format=xml";

            DnaTestURLRequest request = new DnaTestURLRequest("h2g2");
            request.SetCurrentUserNormal();
            request.RequestPageWithFullURL(contributions_for_type_xml_url);

            Contributions contributions = (Contributions)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Contributions));

            foreach (Contribution contribution in contributions.ContributionItems)
            {
                Assert.AreEqual(SiteType.EmbeddedComments, contribution.SiteType);
            }

            Console.WriteLine("After GetUserContributionsForEmbeddedCommentsTypeXML_UserWithContributions_ReturnsValidXML");
        }

    }
}
