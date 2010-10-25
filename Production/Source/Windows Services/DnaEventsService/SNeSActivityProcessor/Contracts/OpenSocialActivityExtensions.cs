using System;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using BBC.Dna.Utils;


namespace Dna.SnesIntegration.ActivityProcessor.Contracts
{
    [DataContract]
    public static class OpenSocialActivityExtensions
    {
        private const int MaxChars = 511;

        

        /// <summary>
        /// Formats the body into snes friendly text - max 511 and no html
        /// </summary>
        /// <param name="input"></param>
        /// <returns></returns>
        public static string FormatBody(this string input)
        {
            if (String.IsNullOrEmpty(input))
            {
                return string.Empty;
            }
            input = HtmlUtils.RemoveAllHtmlTags(input);
            if (input.Length > MaxChars)
            {
                input = input.Substring(0, MaxChars - 3);
                input = input.Substring(0, input.LastIndexOf(' '));
                input += "...";
            }
            return input;
        }

        /// <summary>
        /// replaces values within formated string
        /// Replacments include: {forumid}, {threadid}, {postid}, {sitename}, {parenturl} and {commentforumuid}
        /// </summary>
        /// <param name="input"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <param name="siteName"></param>
        /// <param name="parentUrl"></param>
        /// <param name="commentForumUid"></param>
        /// <returns></returns>
        public static string FormatReplacementStrings(this string input, int forumId, int threadId, int postId, string siteName, string parentUrl, string commentForumUid)
        {
            if (String.IsNullOrEmpty(input))
            {
                return string.Empty;
            }
            input = input.Replace("{forumid}", forumId.ToString());
            input = input.Replace("{threadid}", threadId.ToString());
            input = input.Replace("{postid}", postId.ToString());
            input = input.Replace("{sitename}", siteName);
            input = input.Replace("{parenturl}", parentUrl);
            input = input.Replace("{commentforumuid}", commentForumUid);
            return input;
        }

            
    }

}


