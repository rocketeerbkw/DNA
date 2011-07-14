using System.CodeDom.Compiler;
using System;
using System.Diagnostics;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Objects;
using System.Collections.Generic;
using BBC.Dna.Data;
using BBC.Dna.Api;
using BBC.Dna.Moderation;
using System.Xml.Linq;

namespace BBC.Dna.Objects
{
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "POSTEDITFORM")]
    [XmlRootAttribute("POST-EDIT-FORM", Namespace = "", IsNullable = false)]
    public class PostEditForm
    {
        public static string DataFormatReversed = "<ACTIVITYDATA>A <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was reinstated in moderation by <USER USERID=\"{7}\">{8}</USER> because it was deemed <NOTES>{9}</NOTES></ACTIVITYDATA>";
        private const string ComplaintStringPrefix = "From EditPost:";

        public PostEditForm(IDnaDataReaderCreator creator)
        {
            _creator = creator;
        }

        public PostEditForm()
        {
        }

        #region Properties
        [XmlIgnore]
        private IDnaDataReaderCreator _creator = null;

        /// <remarks/>
        [XmlElementAttribute("POST-ID", Order = 0)]
        public int PostId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("THREAD-ID", Order = 1)]
        public int ThreadId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("FORUM-ID", Order = 2)]
        public int ForumId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 3, ElementName = "AUTHOR")]
        public UserElement Author
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute("DATE-POSTED", Order = 4)]
        public DateElement DatePosted
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 5, ElementName = "IPADDRESS")]
        public string IpAddress
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlIgnore]
        public Guid BBCUid
        {
            get;
            set;
        }

        [XmlElementAttribute(Order = 6, ElementName = "BBCUID")]
        public string BBCUidText
        {
            get { return BBCUid.ToString().ToUpper(); }
            set { BBCUid = new Guid(value); }
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 7, ElementName = "SUBJECT")]
        public string Subject
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 8, ElementName = "TEXT")]
        public string Text
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlElementAttribute(Order = 9, ElementName = "HIDDEN")]
        public byte Hidden
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlArray(Order = 10, ElementName = "POSTSWITHSAMEBBCUID")]
        [XmlArrayItem(ElementName = "POST")]
        public List<PostEditFormPostsWithSameBBCUidPost> PostsWithSameBBCUid
        {
            get;
            set;
        }

        [XmlIgnore]
        public int SiteId { get; set; }

        [XmlIgnore]
        public string ParentUrl { get; set; }

        #endregion

        /// <summary>
        /// Gets post edit form for a given post id
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="includeOtherPosts"></param>
        /// <param name="postId"></param>
        /// <returns></returns>
        public static PostEditForm GetPostEditFormFromPostId(IDnaDataReaderCreator creator, IUser viewingUser, 
            bool includeOtherPosts, int postId)
        {
            var postEditForum = new PostEditForm(creator) { PostId = postId };
            using (var reader = creator.CreateDnaDataReader("FetchPostDetails"))
            {

                reader.AddParameter("postID", postId);
                reader.Execute();

                if (reader.Read())
                {
                    postEditForum.ThreadId = reader.GetInt32NullAsZero("threadid");
                    postEditForum.ForumId = reader.GetInt32NullAsZero("forumid");
                    postEditForum.Author = new UserElement();
                    postEditForum.Author.user = User.CreateUserFromReader(reader);
                    postEditForum.BBCUid = reader.GetGuid("BBCUID");
                    postEditForum.IpAddress = reader.GetStringNullAsEmpty("IPAddress");
                    postEditForum.Hidden =(byte) (reader.GetInt32NullAsZero("hidden")==0?0:1);
                    postEditForum.Subject = reader.GetStringNullAsEmpty("subject");
                    postEditForum.Text = reader.GetStringNullAsEmpty("text");
                    postEditForum.DatePosted = new DateElement(reader.GetDateTime("dateposted"));
                    postEditForum.SiteId = reader.GetInt32NullAsZero("SiteID");
                    postEditForum.ParentUrl = reader.GetStringNullAsEmpty("HOSTPAGEURL");
                }
                else
                {// no post so return null object
                    return null;
                }
            }

            if (includeOtherPosts)
            {
                postEditForum.PostsWithSameBBCUid = GetPostWithSameBBCUid(creator, viewingUser, postEditForum.BBCUid);
            }
            return postEditForum;

        }

        /// <summary>
        /// Get other posts with the same uid
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="bbcUid"></param>
        /// <returns></returns>
        public static List<PostEditFormPostsWithSameBBCUidPost> GetPostWithSameBBCUid(IDnaDataReaderCreator creator, IUser viewingUser, Guid bbcUid)
        {
            var posts = new List<PostEditFormPostsWithSameBBCUidPost>();
            if (bbcUid == Guid.Empty || bbcUid == null)
            {
                return null;
            }

            using (var reader = creator.CreateDnaDataReader("getuserpostdetailsviabbcuid"))
            {

                reader.AddParameter("bbcuid", bbcUid);
                reader.Execute();

                while(reader.Read())
                {
                    var post = new PostEditFormPostsWithSameBBCUidPost();
                    post.DatePosted = new DateElement(reader.GetDateTime("dateposted"));
                    post.UserId = reader.GetInt32NullAsZero("userid");
                    post.UserName = reader.GetStringNullAsEmpty("username");
                    post.EntryId = reader.GetInt32NullAsZero("entryid");
                    post.ThreadId = reader.GetInt32NullAsZero("threadid");
                    post.ForumId = reader.GetInt32NullAsZero("forumid");
                    post.PostIndex = reader.GetInt32NullAsZero("postindex");
                    posts.Add(post);
                }
                
            }
            return posts;

        }

        /// <summary>
        /// Unhides the post in moderation
        /// </summary>
        public void UnHidePost(IUser viewingUser, string notes)
        {

            //create moderation item
            Guid verificationUid = Guid.Empty;
            int modId = 0;
            ModerationPosts.RegisterComplaint(_creator, viewingUser.UserId, ComplaintStringPrefix + notes, string.Empty, PostId,
                string.Empty, Guid.Empty, out verificationUid, out modId);
            if (modId == 0 )
            {
                throw new ApiException("Unable to moderate item", ErrorType.Unknown);
            }

           
            //unhide item
            Queue<String> complainantEmails;
            Queue<int> complainantIds;
            Queue<int> modIds;
            String authorEmail;
            int authorId;
            int forumId = ForumId;
            int threadId = ThreadId;
            int postId = PostId;

            ModerationPosts.ApplyModerationDecision(_creator, forumId, ref threadId, ref postId, modId,
                ModerationItemStatus.Passed, notes, 0, 0, "", out complainantEmails, out complainantIds,
                out modIds, out authorEmail, out authorId, viewingUser.UserId);

            //register siteevent for reversal
            SiteEvent siteEvent1 = new SiteEvent();
            siteEvent1.SiteId = SiteId;
            siteEvent1.Date = new Date(DateTime.Now);
            siteEvent1.Type = SiteActivityType.ModeratePostFailedReversal;
            siteEvent1.ActivityData = XElement.Parse(string.Format(DataFormatReversed, ForumId, PostId, ThreadId, ParentUrl, "post", 
                Author.user.UserId, Author.user.UserName, viewingUser.UserId, viewingUser.UserName, notes));
            siteEvent1.UserId = authorId;
            siteEvent1.SaveEvent(_creator);

            Hidden = 0;
        }

        /// <summary>
        /// Hide the post for the given reason
        /// </summary>
        /// <param name="viewingUser"></param>
        /// <param name="notes"></param>
        /// <param name="reason"></param>
        public void HidePost(IUser viewingUser, string notes, string reason)
        {

            //create moderation item
            Guid verificationUid = Guid.Empty;
            int modId = 0;
            ModerationPosts.RegisterComplaint(_creator, viewingUser.UserId, ComplaintStringPrefix + notes, string.Empty, PostId,
                string.Empty, Guid.Empty, out verificationUid, out modId);
            if (modId == 0)
            {
                throw new ApiException("Unable to moderate item", ErrorType.Unknown);
            }
            //unhide item
            Queue<String> complainantEmails;
            Queue<int> complainantIds;
            Queue<int> modIds;
            String authorEmail;
            int authorId;
            int forumId = ForumId;
            int threadId = ThreadId;
            int postId = PostId;

            ModerationPosts.ApplyModerationDecision(_creator, forumId, ref threadId, ref postId, modId,
                ModerationItemStatus.Failed, notes, 0, 0, reason, out complainantEmails, out complainantIds,
                out modIds, out authorEmail, out authorId, viewingUser.UserId);

            Hidden = 1;
        }

        /// <summary>
        /// Unhides the post in moderation
        /// </summary>
        public void EditPost(IUser viewingUser, string notes, string subject, string text)
        {

            //create moderation item
            Guid verificationUid = Guid.Empty;
            int modId = 0;
            ModerationPosts.RegisterComplaint(_creator, viewingUser.UserId, ComplaintStringPrefix + notes, string.Empty, PostId,
                string.Empty, Guid.Empty, out verificationUid, out modId);
            if (modId == 0)
            {
                throw new ApiException("Unable to moderate item", ErrorType.Unknown);
            }
            //edit the post
            ModerationPosts.EditPost(_creator, viewingUser.UserId, PostId, subject, text, false, true);

            //unhide item
            Queue<String> complainantEmails;
            Queue<int> complainantIds;
            Queue<int> modIds;
            String authorEmail;
            int authorId;
            int forumId = ForumId;
            int threadId = ThreadId;
            int postId = PostId;

            ModerationPosts.ApplyModerationDecision(_creator, forumId, ref threadId, ref postId, modId,
                ModerationItemStatus.PassedWithEdit, notes, 0, 0, "", out complainantEmails, out complainantIds,
                out modIds, out authorEmail, out authorId, viewingUser.UserId);

            Hidden = 0;
        }
    }
}
