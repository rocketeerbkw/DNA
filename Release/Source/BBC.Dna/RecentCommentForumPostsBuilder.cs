using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// Class to build top 5 recent posts to comment forums (i.e. Blogs)
    /// </summary>
    public class RecentCommentForumPostsBuilder : DnaInputComponent
    {
        /// <summary>
        /// RecentCommentForumPostsBuilder constructor
        /// </summary>
        /// <param name="context">The input context</param>
        public RecentCommentForumPostsBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Try and get the recent comment forum posts.
        /// </summary>
        public void TryGetRecentCommentForumPosts()
        {
            string prefix = InputContext.GetParamStringOrEmpty("dnarecentcommentsprefix", @"The prefix for a UID. Used to group related comment forums");
            if (prefix != String.Empty)
            {
                prefix += '%';

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getrecentcomments"))
                {
                    dataReader.AddParameter("@prefix", prefix);
                    dataReader.AddParameter("@siteid", InputContext.CurrentSite.SiteID);
                    dataReader.Execute();

                    BuildRecentCommentsXml(dataReader);
                }
            }
        }

        private void BuildRecentCommentsXml(IDnaDataReader dataReader)
        {
            XmlNode recentComments = CreateElementNode("RECENTCOMMENTS");
            //ForumPost post = new ForumPost();
            if (dataReader.HasRows)
            {
                while (dataReader.Read())
                {
                    ForumPost.AddPostXml(dataReader, this, recentComments, InputContext);
                };
            }
            RootElement.AppendChild(recentComments);
        }
    }

}
