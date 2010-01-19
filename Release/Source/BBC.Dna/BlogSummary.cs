using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna
{
    /// <summary>
    /// Blog Summary class
    /// </summary>
    public class BlogSummary : DnaInputComponent
    {
        /// <summary>
        /// BlogSummary constructor
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public BlogSummary(IInputContext context)
            : base(context)
        {
            
        }

        /// <summary>
        /// Process the request
        /// </summary>
        public override void ProcessRequest()
        {
            //string dnaListNs = InputContext.GetParamStringOrEmpty("dna_list_ns", "");
            XmlNode blogSummary = AddElementTag(RootElement, "BLOGSUMMARY");
            //int dnaUidCount = InputContext.GetParamCountOrZero("u", "0, 1 or more dnauids");
            
			//if (dnaUidCount != 0)
			//{
                //Get Comment Forums for the given uids.
                CommentForumListBuilder commentForumListBuilder = new CommentForumListBuilder(InputContext);
                //commentForumListBuilder.SkipUrlProcessing = true;
                commentForumListBuilder.GetCommentListsFromUids();
                AddInside(commentForumListBuilder,  "BLOGSUMMARY");
			//}

			
            // Return comments forums for the given uid prefix.
            if (InputContext.DoesParamExist("dnacommentforumlistprefix", "Include Recent Comments") )
            {
                commentForumListBuilder = new CommentForumListBuilder(InputContext);
                //commentForumListBuilder.SkipUidProcessing = true;
                commentForumListBuilder.GetCommentListsFromUidPrefix();
                AddInside(RootElement, commentForumListBuilder);
            }
            
            // Add Recent Comments XML unless otherwise specified.
            if ( InputContext.DoesParamExist("dnarecentcommentsprefix","Include Recent Comments") )
            {
                RecentCommentForumPostsBuilder recentComments = new RecentCommentForumPostsBuilder(InputContext);
                recentComments.TryGetRecentCommentForumPosts();
                AddInside(RootElement, recentComments);
		    }
        }
    }
}
