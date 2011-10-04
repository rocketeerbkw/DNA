using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;
using BBC.Dna.Sites;
using System.Data;
using System.Data.SqlClient;
using BBC.Dna.Moderation.Utils;
using BBC.DNA.Moderation.Utils;

namespace BBC.Dna.Objects
{
    [GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [SerializableAttribute()]
    [DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "SUBMIT-REVIEW-FORUM")]
    [DataContract(Name = "reviewSubmission")]
    public partial class ReviewSubmission
    {
        #region Properties

        /// <remarks/>
        [DataMember(Name = "articleH2G2Id", Order = 1)]
        public int ArticleH2G2Id { get; set; }

        /// <remarks/>
        [DataMember(Name = "newThreadPostId", Order = 2)]
        public int NewThreadPostId { get; set; }

        /// <remarks/>
        [DataMember(Name = "newThreadThreadId", Order = 3)]
        public int NewThreadThreadId { get; set; }

        /// <remarks/>
        [DataMember(Name = "newThreadForumId", Order = 4)]
        public int NewThreadForumId { get; set; }
        
        #endregion


        public static ReviewSubmission SubmitArticle(IDnaDataReaderCreator readerCreator, 
                int submitterId,
                string submitterUsername,
                BBC.Dna.Sites.ISite site,
                int articleId,
                string subject,
                int editorId,
                string editorUsername,
                int reviewForumId, 
                string comments)
        {
            ReviewSubmission reviewSubmissionResponse = new ReviewSubmission();
            string subjectDB = "A" + articleId.ToString() + " - " + subject;

            string editedComments = "Entry: " + subject + " - A" + articleId.ToString() + "\n";
            editedComments += "Author: " + editorUsername + " - U" + editorId.ToString() + "\n\n";
            editedComments += comments;

            string hash = String.Empty;
            string hashString = subject + "<:>" + editedComments + "<:>" + submitterId.ToString() + "<:>0<:>0<:>0<:>ToReviewForum";

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("addarticletoreviewforummembers"))
            {
                reader.AddParameter("h2g2id", articleId);
                reader.AddParameter("reviewforumid", reviewForumId);
                reader.AddParameter("submitterid", submitterId);
                reader.AddParameter("subject", subjectDB);
                reader.AddParameter("content", editedComments);
                reader.AddParameter("Hash", DnaHasher.GenerateHash(hashString));

                reader.Execute();

                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {
                    reviewSubmissionResponse.ArticleH2G2Id = articleId;

                    reviewSubmissionResponse.NewThreadPostId = reader.GetInt32NullAsZero("postid");
                    reviewSubmissionResponse.NewThreadThreadId = reader.GetInt32NullAsZero("threadid");
                    reviewSubmissionResponse.NewThreadForumId = reader.GetInt32NullAsZero("forumid");
                }
                else
                {
                    throw ApiException.GetError(ErrorType.AddIntoReviewForumFailed);
                }
            }

            //set the lastupdatefield on the guideentry
            //this is done by a trigger so update a field to be the same as it already is
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("ForceUpdateEntry"))
            {
                reader.AddParameter("h2g2id", articleId);

                reader.Execute();
            }

            if (submitterId != editorId)
            {
                NotifyAuthorOnPersonalSpace(readerCreator,
                    submitterId, 
                    submitterUsername,
                    editorId,
                    editorUsername, 
                    articleId, 
                    site,
                    reviewForumId, 
                    reviewSubmissionResponse.NewThreadForumId, 
                    reviewSubmissionResponse.NewThreadThreadId, 
                    reviewSubmissionResponse.NewThreadPostId,
                    subject,
                    comments);
            }

            return reviewSubmissionResponse;
        }

        private static void NotifyAuthorOnPersonalSpace(IDnaDataReaderCreator readerCreator,
            int submitterId,
            string submitterUsername,
            int editorId, 
            string editorUsername, 
            int articleId,
            BBC.Dna.Sites.ISite site, 
            int reviewForumId,
            int newThreadForumId,
            int newThreadThreadId,
            int newThreadPostId, 
            string subject, 
            string comments)
        {

            int personalSpaceForumID = FetchPersonalSpaceForum(readerCreator, editorId, site.SiteID);

            ReviewForum reviewForum = ReviewForum.CreateFromDatabase(readerCreator, reviewForumId, true);

            string generatedSubject = "Your entry has been submitted to '" + reviewForum.ForumName + "'";

            string generatedBody = "Entry: " + subject + " - A" + articleId + " \n";
            generatedBody += "Author: " + editorUsername + " - U" + editorId + " \n";
            generatedBody += "Submitter: " + submitterUsername + " - U" + submitterId + "\n\n";

            generatedBody += "This is an automated message.\n\n";

            generatedBody += "Your entry above has been submitted to the Review Forum '" + reviewForum.ForumName + "'"
                           + " by the Researcher named above. For more information about what happens next check out <./>ReviewForums-Next</.>.\n\n";

            generatedBody += "You can see the discussion about your entry at " + "F" + newThreadForumId.ToString() + "?thread=" + newThreadThreadId.ToString() + "\n\n";

            generatedBody += "If you'd rather your entry wasn't in this Review Forum then you can remove it by visiting "
                           + "<./>" + reviewForum.UrlFriendlyName + "</.> and clicking on the relevant 'Remove' link."
                           + " To prevent it being put into a Review Forum in the future, please click on the 'Edit Entry' button and tick the 'Not for Review' box.\n\n";


            bool forceModeration;
            CheckForProfanities(site, generatedBody, out forceModeration);           
            
            //TODO URL and Email filter


            // save the Post in the database
            ThreadPost post = new ThreadPost();
            post.InReplyTo = 0;
            post.ThreadId = 0;
            post.Subject = generatedSubject;
            post.Text = generatedBody;
            post.Style = PostStyle.Style.plaintext;

            post.CreateForumPost(readerCreator,
                submitterId,
                personalSpaceForumID, 
                false, 
                false, 
                "", 
                System.Guid.Empty, 
                false, 
                false, 
                false, 
                forceModeration,
                string.Empty,
                string.Empty);
        
        }

        private static int FetchPersonalSpaceForum(IDnaDataReaderCreator readerCreator, 
                                                    int editorId, 
                                                    int siteId)
        {
            int userForumId = 0;
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetchpersonalspaceforum"))
            {
                reader.AddParameter("userid", editorId);
                reader.AddParameter("siteid", siteId);

                reader.Execute();
                // Check to see if we found anything
                if (reader.HasRows && reader.Read())
                {
                    userForumId = reader.GetInt32NullAsZero("ForumID");
                }
            }
            return userForumId;
        }

        private static void CheckForProfanities(BBC.Dna.Sites.ISite site, string textToCheck, out bool forceModeration)
        {
            string matchingProfanity;
            List<Term> terms = null;
            forceModeration = false;
            ProfanityFilter.FilterState state = ProfanityFilter.CheckForProfanities(site.ModClassID, textToCheck,
                                                                                    out matchingProfanity, out terms);
            if (ProfanityFilter.FilterState.FailBlock == state)
            {
                throw ApiException.GetError(ErrorType.ProfanityFoundInText);
            }
            if (ProfanityFilter.FilterState.FailRefer == state)
            {
                forceModeration = true;
            }
        }
    }
}
