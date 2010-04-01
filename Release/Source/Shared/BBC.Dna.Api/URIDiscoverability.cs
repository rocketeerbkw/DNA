using System.Collections.Generic;
using System.Linq;

namespace BBC.Dna.Api
{
    public static class UriDiscoverability
    {
        #region uriType enum

        public enum UriType
        {
            CommentForum,
            CommentForumById,
            CommentForumBySiteName,
            Comments,
            CommentsByCommentForumId,
            Complaint,
            Comment,
            RatingForumById,
            RatingsByRatingForumId,
            Threads
        }

        #endregion

        private static readonly Dictionary<UriType, string> UriTypeMapping;

        static UriDiscoverability()
        {
            UriTypeMapping = new Dictionary<UriType, string>();
            UriTypeMapping.Add(UriType.CommentForum, "V1/commentsforums/");
            UriTypeMapping.Add(UriType.CommentForumById, "V1/site/[sitename]/commentsforums/[commentforumid]/");
            UriTypeMapping.Add(UriType.RatingForumById, "V1/site/[sitename]/ratingsforums/[uid]/");
            UriTypeMapping.Add(UriType.CommentForumBySiteName, "V1/site/[sitename]/");
            UriTypeMapping.Add(UriType.Comments, "V1/commentsforums/comments/");
            UriTypeMapping.Add(UriType.CommentsByCommentForumId, "V1/site/[sitename]/commentsforums/[commentforumid]/");
            UriTypeMapping.Add(UriType.RatingsByRatingForumId, "V1/site/[sitename]/ratingsforums/[RatingForumid]/");
            UriTypeMapping.Add(UriType.Complaint,
                                "http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            UriTypeMapping.Add(UriType.Comment, "[parentUri]?PostID=[postid]");
            UriTypeMapping.Add(UriType.Threads, "V1/site/[sitename]/ratingsforums/[uid]/threads");
        }

        /// <summary>
        /// Takes a type of URI and a bunch of key/value pairs to replace within the string
        /// </summary>
        /// <param name="baseUrl">The current path without trailing slash</param>
        /// <param name="type">the type to return</param>
        /// <param name="replacements">the key value replacements to use within the URI</param>
        /// <returns>The new URI</returns>
        public static string GetUriWithReplacments(string baseUrl, UriType type, Dictionary<string, string> replacements)
        {
            string uri = string.Empty;
            try
            {
                uri = UriTypeMapping[type];
                if (replacements != null)
                {
                    uri = replacements.Keys.Aggregate(uri, (current, key) => current.Replace(string.Format("[{0}]", key), replacements[key]));
                }
            }
            catch
            {
            }

            if (uri.IndexOf("http:") != 0)
            {
                return baseUrl + "/" + uri;
            }
            return uri;
        }
    }
}