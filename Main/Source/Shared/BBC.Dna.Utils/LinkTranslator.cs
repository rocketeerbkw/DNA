using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Class to expand F## C## or http:// into links
    /// </summary>
    public class LinkTranslator
    { 
        static Regex regLinkEx = new Regex(@"(\A|(?<=))(?<!')((http|https):[A-Za-z0-9/](([A-Za-z0-9$_.+!*(),;/?:@&~=-])|%[A-Fa-f0-9]{2})+(#([a-zA-Z0-9$_.+!*(),;/?:@&~=%-]*))?)[^.?\s<]");
        //static Regex regInternalLinkEx = new Regex(@"(\A|(?<=\s))&lt;[.]/&gt;\w+&lt;/[.]&gt;(\Z|(?=\s))"); // Match <./>A-Z</.>
        //static Regex regGroupEx = new Regex(@"(?<=\s)G[1-9]\d*(?=\s)");

//        static Regex regForumEx = new Regex(@"(\A|(?<=\s))F[1-9]\d+(\Z|(?=\s))");
//        static Regex regArticleEx = new Regex(@"(\A|(?<=\s))A[0-9]+(\Z|(?=\s))");
//        static Regex regCategoryEx = new Regex(@"(\A|(?<=\s))C[0-9]+");
//       static Regex regUserEx = new Regex(@"(\A|(?<=\s))U(?!2\b|8\b|9\b|10\b|11\b|14\b|15\b|16\b|17\b|18\b|20\b|21\b)[0-9]+(\Z|(?=\s))");

        static Regex regForumEx = new Regex(@"(\A|(?<=\s))F[1-9]\d+(?!\d)");
        static Regex regArticleEx = new Regex(@"(\A|(?<=\s))A[0-9]+(?!\d)");
        static Regex regCategoryEx = new Regex(@"(\A|(?<=\s))C[0-9]+(?!\d)");
        static Regex regUserEx = new Regex(@"(\A|(?<=\s))U(?!2\b|8\b|9\b|10\b|11\b|14\b|15\b|16\b|17\b|18\b|20\b|21\b)[0-9]+(?!\d)");

        static Regex regTwitterUserName = new Regex(@"(@)((?:[A-Za-z0-9-_]+))");
        static Regex regTwitterHashTag = new Regex(@"(#)((?:[A-Za-z0-9-_]+))");
        
        static string re1 = "(F)";	// Any Single Character 1
        static string re2 = "(\\d+)";	// Integer Number 1
        static string re3 = "(\\?)";	// Any Single Character 2
        static string re4 = "(thread)";	// Variable Name 1
        static string re5 = "(=)";	// Any Single Character 3
        static string re6 = "(\\d+)";	// Integer Number 2

        static string re7 = "(\\/)";	// Any Single Character 3
        static string re8 = "(T)";	// Any Single Character 4

        static Regex regOldForumThreadEx = new Regex(re1 + re2 + re3 + re4 + re5 + re6, RegexOptions.IgnoreCase | RegexOptions.Singleline);

        static Regex regNewForumThreadEx = new Regex(re1 + re2 + re7 + re8 + re6, RegexOptions.IgnoreCase | RegexOptions.Singleline);

        
        static string twitterUser = "http://twitter.com/";
        static string twitterSearch = "http://search.twitter.com/search?q=";
        
        /// <summary>
        /// Check the input string for matches.
        /// If match found then expand into LINK XML .
        /// Consider changing the Link XML so that all Links are of the same format.
        /// </summary>
        /// <param name="raw">The string to check if it is a valid email address</param>
        /// <returns>True if it is a valid email address</returns>
        public static string TranslateText(string raw)
        {
            
            String result = raw;

            /*if (regInternalLinkEx.IsMatch(raw))
            {
                String replace = "<LINK HREF=\"***\">***</LINK>";
                MatchCollection matches = regInternalLinkEx.Matches(raw);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    //Remove <./> and </.> from internal link
                    String s = match.Value;
                    s = s.Replace(@"&lt;./&gt;", "");
                    s = s.Replace(@"&lt;/.&gt;", "");
                    s = s.Trim();
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }*/

            result = TranslateTextLinks(result);

            if (regUserEx.IsMatch(result))
            {
                String replace = "<LINK BIO=\"***\">***</LINK>";
                MatchCollection matches = regUserEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            if (regArticleEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regArticleEx.Matches(result);
         
                // Reverse the order - expand links from back to front so that index is unaltered.
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach ( Match match in stack )
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                    
                }
            }

            if (regForumEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regForumEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach ( Match match in stack )
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            if (regCategoryEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regCategoryEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            /*if (regGroupEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regGroupEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }*/
            return result;
        }

        /// <summary>
        /// Check the input string for matches.
        /// If match found then expand into LINK XML .
        /// Consider changing the Link XML so that all Links are of the same format.
        /// </summary>
        /// <param name="raw">The string to check if it is a valid email address</param>
        /// <returns>True if it is a valid email address</returns>
        public static string TranslateTextLinks(string raw)
        {

            String result = raw;

            /*if (regInternalLinkEx.IsMatch(raw))
            {
                String replace = "<LINK HREF=\"***\">***</LINK>";
                MatchCollection matches = regInternalLinkEx.Matches(raw);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    //Remove <./> and </.> from internal link
                    String s = match.Value;
                    s = s.Replace(@"&lt;./&gt;", "");
                    s = s.Replace(@"&lt;/.&gt;", "");
                    s = s.Trim();
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }*/

            if (regLinkEx.IsMatch(result))
            {
                String replace = "<LINK HREF=\"***\">***</LINK>";
                result = ReplaceExLinks(result, replace);
            }

            return result;
        }

        /// <summary>
        /// Does the replacement of html ex links - if the link is in a <a></a> tags then it will be ignored
        /// </summary>
        /// <param name="result"></param>
        /// <param name="replace"></param>
        /// <returns></returns>
        private static string ReplaceExLinks(string result, string replace)
        {
            MatchCollection matches = regLinkEx.Matches(result);
            Stack stack = new Stack();
            foreach (Match match in matches)
            {
                stack.Push(match);
            }

            var hrefPattern = "href=\"";
            foreach (Match match in stack)
            {
                if(match.Index > hrefPattern.Length)
                {
                    var prevsChars = result.Substring(match.Index - hrefPattern.Length, hrefPattern.Length);
                    if(prevsChars == hrefPattern)
                    {
                        continue;
                    }
                }
                String s = match.Value;
                result = result.Remove(match.Index, match.Length);
                result = result.Insert(match.Index, replace.Replace("***", s));
            }
            return result;
        }

        /// <summary>
        /// Finds and replaces http based links into a href links
        /// </summary>
        /// <param name="raw"></param>
        /// <returns></returns>
        public static string TranslateExLinksToHtml(string raw)
        {
            if (regLinkEx.IsMatch(raw))
            {
                String replace = "<a href=\"***\">***</a>";
                raw = ReplaceExLinks(raw, replace);
            }
            return raw;
        }

        /// <summary>
        /// Finds the Twitter related tags - @ and #.
        /// Replaces the tags with the twitter urls in a href links
        /// </summary>
        /// <param name="raw"></param>
        /// <returns></returns>
        public static string TranslateTwitterTags(string raw)
        {
            if (regTwitterUserName.IsMatch(raw))
            {
                raw = Regex.Replace(raw, regTwitterUserName.ToString(), new MatchEvaluator(LinkTranslator.Username));
            }
            if (regTwitterHashTag.IsMatch(raw))
            {
                raw = Regex.Replace(raw, regTwitterHashTag.ToString(), new MatchEvaluator(LinkTranslator.Hashtag));
            }
            return raw;
        }

        /// <summary>
        /// Translates the @ tag to the corresponding twitter url
        /// </summary>
        /// <param name="m"></param>
        /// <returns></returns>
        private static string Username(Match m)
        {
            string twitterText = m.ToString();
            string username = twitterText.Replace("@", "");
            return LinkTranslator.TranslateToTwitterUrl(twitterUser, username, twitterText);
        }

        /// <summary>
        /// Translates the # tag to the corresponding twitter url
        /// </summary>
        /// <param name="m"></param>
        /// <returns></returns>
        private static string Hashtag(Match m)
        {
            string twitterText = m.ToString();
            string tag = twitterText.Replace("#", "%23");
            return LinkTranslator.TranslateToTwitterUrl(twitterSearch, tag, twitterText);
        }

        /// <summary>
        /// Formation of the anchor tag with the twitter details
        /// </summary>
        /// <param name="twitterUrl"></param>
        /// <param name="twitterMatch"></param>
        /// <param name="twitterText"></param>
        /// <returns></returns>
        private static string TranslateToTwitterUrl(string twitterUrl, string twitterMatch, string twitterText)
        {
            return string.Format("<a href=\"{0}{1}\" target=\"_blank\">{2}</a>", twitterUrl, twitterMatch, twitterText);
        }
        /// <summary>
        /// Changes the H2G2 specific links
        /// </summary>
        /// <param name="raw">The string to check if it is a valid email address</param>
        /// <returns>True if it is a valid email address</returns>
        public static string TranslateH2G2Text(string raw)
        {

            String result = raw;

            if (regUserEx.IsMatch(result))
            {
                String replace = "<LINK BIO=\"***\">***</LINK>";
                MatchCollection matches = regUserEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            if (regArticleEx.IsMatch(result))
            {
                String replace = "<LINK H2G2=\"***\">***</LINK>";
                MatchCollection matches = regArticleEx.Matches(result);

                // Reverse the order - expand links from back to front so that index is unaltered.
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));

                }
            }

            if (regForumEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regForumEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            if (regCategoryEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regCategoryEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            if (regOldForumThreadEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regOldForumThreadEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            if (regNewForumThreadEx.IsMatch(result))
            {
                String replace = "<LINK DNAID=\"***\">***</LINK>";
                MatchCollection matches = regNewForumThreadEx.Matches(result);
                Stack stack = new Stack();
                foreach (Match match in matches)
                {
                    stack.Push(match);
                }

                foreach (Match match in stack)
                {
                    String s = match.Value;
                    result = result.Remove(match.Index, match.Length);
                    result = result.Insert(match.Index, replace.Replace("***", s));
                }
            }

            return result;
        }
    }
}