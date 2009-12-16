using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;


namespace BBC.Dna
{
    /// <summary>
    /// Class to expand F## C## or http:// into links
    /// </summary>
    public class LinkTranslator
    { 
        static Regex regForumEx = new Regex(@"(\A|(?<=\s))F[1-9]\d+(\Z|(?=\s))");
        static Regex regArticleEx = new Regex(@"(\A|(?<=\s))A[0-9]+(\Z|(?=\s))");
        static Regex regCategoryEx = new Regex(@"(\A|(?<=\s))C[1-9&&[^45]]\d+(\Z|(?=\s))");
        static Regex regLinkEx = new Regex(@"(\A|(?<=\s))http://[a-zA-Z0-9\./:-]+(\Z|(?=\s))");
        static Regex regInternalLinkEx = new Regex(@"(\A|(?<=\s))&lt;[.]/&gt;\w+&lt;/[.]&gt;(\Z|(?=\s))"); // Match <./>A-Z</.>
        //static Regex regGroupEx = new Regex(@"(?<=\s)G[1-9]\d*(?=\s)");
        static Regex regUserEx = new Regex(@"(\A|(?<=\s))U(?!2\b|8\b|9\b|10\b|11\b|14\b|15\b|16\b|17\b|18\b|20\b|21\b)[0-9]+(\Z|(?=\s))");

        /// <summary>
        /// 
        /// </summary>
        public LinkTranslator()
        {
        }

        /// <summary>
        /// Check the input string for matches.
        /// If match found then expand into LINK XML .
        /// TODO: Match egEx expressions should be combined or optimised so that only 1 -pass is required on the input string.
        /// Consider changing the Link XML so that all Links are of the same format.
        /// </summary>
        /// <param name="raw">The string to check if it is a valid email address</param>
        /// <returns>True if it is a valid email address</returns>
        public static string TranslateText(string raw)
        {
            
            String result = raw;

            if (regInternalLinkEx.IsMatch(raw))
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
            }

            if (regLinkEx.IsMatch(result))
            {
                String replace = "<LINK HREF=\"***\">***</LINK>";
                MatchCollection matches = regLinkEx.Matches(result);
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
    }
}