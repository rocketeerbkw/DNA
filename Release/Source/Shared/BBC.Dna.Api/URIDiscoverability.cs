using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Api
{
    public static class URIDiscoverability
    {
        public enum uriType
        {
            CommentForum,
            CommentForumByID,
            CommentForumBySiteName,
            Comments,
            CommentsByCommentForumID,
            Complaint,
            Comment,
            RatingForumByID,
            RatingsByRatingForumID,
            Threads
        }
        private static Dictionary<uriType, string> _UriTypeMapping;
        static URIDiscoverability()
        {
            _UriTypeMapping = new Dictionary<uriType, string>();
            _UriTypeMapping.Add(uriType.CommentForum, "V1/commentsforums/");
            _UriTypeMapping.Add(uriType.CommentForumByID, "V1/site/[sitename]/commentsforums/[commentforumid]/");
            _UriTypeMapping.Add(uriType.RatingForumByID, "V1/site/[sitename]/ratingsforums/[uid]/");
            _UriTypeMapping.Add(uriType.CommentForumBySiteName, "V1/site/[sitename]/");
            _UriTypeMapping.Add(uriType.Comments, "V1/commentsforums/comments/");
            _UriTypeMapping.Add(uriType.CommentsByCommentForumID, "V1/site/[sitename]/commentsforums/[commentforumid]/");
            _UriTypeMapping.Add(uriType.RatingsByRatingForumID, "V1/site/[sitename]/ratingsforums/[RatingForumid]/");
            _UriTypeMapping.Add(uriType.Complaint, "http://www.bbc.co.uk/dna/[sitename]/comments/UserComplaintPage?PostID=[postid]&s_start=1");
            _UriTypeMapping.Add(uriType.Comment, "[parentUri]?PostID=[postid]");
            _UriTypeMapping.Add(uriType.Threads, "V1/site/[sitename]/ratingsforums/[uid]/threads");

        }

        /// <summary>
        /// Takes a type of URI and a bunch of key/value pairs to replace within the string
        /// </summary>
        /// <param name="baseUrl">The current path without trailing slash</param>
        /// <param name="type">the type to return</param>
        /// <param name="replacements">the key value replacements to use within the URI</param>
        /// <returns>The new URI</returns>
        public static string GetUriWithReplacments(string baseUrl, uriType type, Dictionary<string, string>replacements)
        {
            string uri = string.Empty;
            try
            {
                uri = _UriTypeMapping[type];
                if (replacements != null)
                {
                    foreach (string key in replacements.Keys)
                    {
                        uri = uri.Replace(string.Format("[{0}]", key), replacements[key]);
                    }
                }
            }
            catch { }

            if (uri.IndexOf("http:") != 0)
            {
                return baseUrl + "/" + uri;
            }
            else
            {
                return uri;
            }
        }
    
    }
}
