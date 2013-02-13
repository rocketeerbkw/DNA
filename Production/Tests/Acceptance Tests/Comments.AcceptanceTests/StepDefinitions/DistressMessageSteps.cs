using System;
using System.Collections.Generic;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using BBC.Dna.Users;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Moq;
using TechTalk.SpecFlow;
using BBC.Dna.Api;
using Tests;
using Forum = BBC.Dna.Api.Forum;
using TestUtils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using BBC.Dna.Common;

namespace MyNamespace
{
    [Binding]
    public class StepDefinitions
    {
        //Some things we'll need throughout the test
        private IDnaDataReaderCreator DataReaderCreator;
        private int CommentForumId;

        private class ModerationItem : IComparable
        {
            public int ForumId {get;set;}
            public int ThreadId {get;set;}
            public int PostId {get;set;}
            public int ModId {get;set;}

            #region IComparable Members

            public int CompareTo(object obj)
            {
                if (obj == null) return 1;

                ModerationItem modItem = obj as ModerationItem;
                if (modItem != null)
                    return ModId.CompareTo(this.ModId);
                else
                    throw new ArgumentException("Object is not a ModerationItem");
            }
            #endregion
        }
        private List<ModerationItem> modItems = new List<ModerationItem>();

        private List<string> RipleyServerAddresses = new List<string>();
        private List<string> DotNetServerAddresses = new List<string>();
        private Mock<ICacheManager> CacheManager = new Mock<ICacheManager>();
        private Mock<IDnaDiagnostics> Diagnostics =  new Mock<IDnaDiagnostics>();
        private SiteList SiteList;
        private Mock<ISite> Site = new Mock<ISite>();
        private Forum Forum;
        private string SortBy = "Created";
        private string SortDirection = "Ascending";

        [Given(@"I have an comment in the referal queue")]
        public void GivenIHaveAnCommentInTheReferalQueue()
        {
            //To get to this stage we need:-
            //1. Create a comment forum (make it pre-mod)
            //2. Add at least 2 posts
            //3. Refer the first post
            //  a) for a post to be referred it should be in the mod queue (so - make the comment forum pre-mod
            //Let's not make a web request if possible - we'll need the databse though
            //SnapshotInitialisation.RestoreFromSnapshot(); //TODO: SnapshotInitialisation should not depend on IIS at all. 
            //Whatever info is required should be injected.
            //TODO: get this from config
            string connectionString =
                @"database=smallGuide; server=.\MSSQL2008R2; user id=sa; password=Thanatos99; pooling=false";
            
            DataReaderCreator = new DnaDataReaderCreator(connectionString, Diagnostics.Object);

            SiteList = new SiteList(DataReaderCreator,
                                    Diagnostics.Object,
                                    CacheManager.Object,
                                    RipleyServerAddresses,
                                    DotNetServerAddresses);

            var comments = new BBC.Dna.Api.Comments(Diagnostics.Object,
                                                    DataReaderCreator,
                                                    CacheManager.Object,
                                                    SiteList);

            Forum = new Forum();
            Forum.Id = "distress-message-fun-and-games";
            Forum.ParentUri = "http://www.bbc.co.uk/dna/h2g2";
            Forum.Title = "distress-message-fun-and-games";

            Forum.ModerationServiceGroup = ModerationStatus.ForumStatus.PostMod;
            
            Site.Setup(x => x.SiteID).Returns(1);
            Site.Setup(x => x.SiteName).Returns("h2g2");

            //see if this comment forum already exists
            var commentForum = comments.GetCommentForumByUid(Forum.Id, Site.Object, true);
            if (commentForum == null)
            {
                commentForum = comments.CreateCommentForum(Forum, Site.Object);
            }
            //save the forumid for later in the test
            CommentForumId = commentForum.ForumID;

            //if we have less than 2 comments we need to get up to 2
            int commentCount = commentForum.commentList.TotalCount;
            while (commentCount < 2)
            {
                //Ok this is what I want to do but...
                //commentForum.Post(new Comment(...));
                //TODO: can we add this method through a good refactor
                var commentInfo = new CommentInfo();
                commentInfo.text = "Simple comment text " + commentCount.ToString();
                
                var callingUser = new Mock<ICallingUser>();
                callingUser.Setup(x => x.UserID).Returns(TestUserAccounts.GetNormalUserAccount.UserID);
                callingUser.Setup(x => x.IsSecureRequest).Returns(true);
                comments.CallingUser = callingUser.Object;
                
                var info = comments.CreateComment(commentForum, commentInfo);

                commentCount++;
            }
        }

        [When(@"I want to place a distress message against a comment")]
        public void WhenIWantToPlaceADistressMessageAgainstAComment()
        {
            //get the items to moderate
            GetModerationItems();

            //refer the first one
            ReferFirstPost();

            using (var dataReader = DataReaderCreator.CreateDnaDataReader("getmoderationposts"))
            {
                dataReader.AddParameter("userid", TestUserAccounts.GetSuperUserAccount.UserID);
                dataReader.AddParameter("status", 2);//2 is referred
                dataReader.AddParameter("alerts", 0);
                dataReader.AddParameter("lockeditems", 1);
                dataReader.AddParameter("fastmod", 0);
                dataReader.AddParameter("issuperuser", 1);
                dataReader.Execute();

                while (dataReader.HasRows && dataReader.Read())
                {
                    PostDistressMessage(dataReader);
                }
            }
        }

        [When(@"the forum is sorted by '(.*)' '(.*)'")]
        public void WhenTheForumIsSortedBy(string p0, string p1)
        {
            SortBy = p0;
            SortDirection = p1;
            //ScenarioContext.Current.Pending();
        }

        private void PostDistressMessage(IDnaDataReader dataReader)
        {
            var inputContextMock = new Mock<IInputContext>();
            inputContextMock.Setup(x => x.CurrentSite.AutoMessageUserID).Returns(6);
            
            inputContextMock.Setup(x => x.CreateDnaDataReader("moderationgetdistressmessage")).Returns(
                DataReaderCreator.CreateDnaDataReader("moderationgetdistressmessage"));

            inputContextMock.Setup(x => x.CreateDnaDataReader("insertdistressmessage")).Returns(
                DataReaderCreator.CreateDnaDataReader("insertdistressmessage"));

            inputContextMock.Setup(x => x.ViewingUser.IsNotable).Returns(false);
            inputContextMock.Setup(x => x.IpAddress).Returns("192.168.0.1");
            inputContextMock.Setup(x => x.BBCUid).Returns(new Guid("12345678901234567890123456789012"));
            
            inputContextMock.Setup(x => x.CreateDnaDataReader("posttoforum")).Returns(
                DataReaderCreator.CreateDnaDataReader("posttoforum"));

            ModerationDistressMessages distressMessage = new ModerationDistressMessages(inputContextMock.Object);
            distressMessage.PostDistressMessage(1, 
                dataReader.GetInt32NullAsZero("SiteID"), 
                CommentForumId, 
                dataReader.GetInt32NullAsZero("ThreadId"), 
                dataReader.GetInt32NullAsZero("EntryId"));
        }

        private void ReferFirstPost()
        {
            if (modItems.Count > 0)
            {
                modItems.Sort();
                var modItem = modItems[0];
                var threadId = modItem.ThreadId;
                var postId = modItem.PostId;
                var modId = modItem.ModId;
                var moderationDecision = ModerationItemStatus.Refer;
                var notes = "notes";
                var referId = TestUserAccounts.GetSuperUserAccount.UserID;
                var threadModStatus = 0;
                var emailType = "OffensiveInsert";
                var complaintEmails = new Queue<string>();
                var complaintIds = new Queue<int>();
                var modIds = new Queue<int>();
                var authorEmail = "";
                var authorId = 0;
                var modUserId = 0;

                ModerationPosts.ApplyModerationDecision(DataReaderCreator, CommentForumId, ref threadId, ref postId, modId, moderationDecision, notes,
                    referId, threadModStatus, emailType, out complaintEmails, out complaintIds, out modIds, out authorEmail, out authorId, modUserId);
            }
        }

        private void GetModerationItems()
        {
            using (var dataReader = DataReaderCreator.CreateDnaDataReader("getmoderationposts"))
            {
                dataReader.AddParameter("userid", TestUserAccounts.GetModeratorAccount.UserID);
                dataReader.Execute();

                while (dataReader.HasRows && dataReader.Read())
                {
                    var forumid = dataReader.GetInt32NullAsZero("forumid");
                    if (forumid == CommentForumId)
                    {
                        modItems.Add(new ModerationItem()
                        {
                            ForumId = forumid,
                            ModId = dataReader.GetInt32NullAsZero("ModId"),
                            PostId = dataReader.GetInt32NullAsZero("EntryId"),
                            ThreadId = dataReader.GetInt32NullAsZero("ThreadId")
                        });
                    }
                }
            }
        }

        [Then(@"the distress message will appear in the comments module as a reply to the referred message")]
        public void ThenTheDistressMessageWillAppearInTheCommentsModuleAsAReplyToTheReferredMessage()
        {
            var comments = new BBC.Dna.Api.Comments(Diagnostics.Object,
                                                    DataReaderCreator,
                                                    CacheManager.Object,
                                                    SiteList);

            //see if this comment forum already exists
            comments.SortBy = (SortBy)Enum.Parse(typeof(SortBy), SortBy);
            comments.SortDirection = (SortDirection)Enum.Parse(typeof(SortDirection), SortDirection);
            var commentForum = comments.GetCommentForumByUid(Forum.Id, Site.Object, true);
            if (commentForum != null)
            {
                foreach (var comment in commentForum.commentList.comments)
                {
                    if (comment.DistressMessage != null)
                    {
                        Assert.AreEqual("body", comment.DistressMessage.text);
                        return;
                    }
                }
            }
            Assert.Fail("No distress message found");
        }

        [BeforeScenario("wip")]
        public void WorkInProgress()
        {
            TechTalk.SpecFlow.ScenarioContext.Current.Pending();
        }
    }
}