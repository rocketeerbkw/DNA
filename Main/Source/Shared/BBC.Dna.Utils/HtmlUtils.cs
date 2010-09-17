using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using System.Web;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Helper class for html mundging
    /// </summary>
    public class HtmlUtils
    {
        /// <summary>
        /// Tries to parse the given string to valid html
        /// </summary>
        /// <param name="htmlToParse">The string that contains the html you want to try to make valid</param>
        /// <returns></returns>
        static public string TryParseToValidHtml(string htmlToParse)
        {
            string parsedHtml = htmlToParse;

            // Try to clean random brackets and BR tags
            Regex regex = new Regex(@"(<[^<>]+)<BR \/>");
            while (regex.Match(parsedHtml).Success)
            {
                parsedHtml = regex.Replace(parsedHtml, @"$1 ");
            }

            parsedHtml = EscapeNonEscapedAmpersands(parsedHtml);

            // Now run it through the xml parser
            XmlDocument xDoc = new XmlDocument();
            try
            {
                xDoc.LoadXml(parsedHtml);
            }
            catch (XmlException ex)
            {
                // Didn't parse!!! Convert it to plain text.
                DnaDiagnostics.Default.WriteToLog("HTMLValidation", ex.Message);
                return StringUtils.EscapeAllXml(htmlToParse);
            }

            return xDoc.InnerXml.ToString();
        }

        /// <summary>
        /// Parses richtext input to check that it passes xml validation rules.
        /// </summary>
        /// <param name="textToCheck">The richtext input to parse</param>
        /// <param name="errorMessage">A string that will take any error message produced</param>
        /// <returns>True if it parsed ok, false if not. The error will be returned in the passed in string</returns>
        public static bool ParseToValidGuideML(string textToCheck, ref string errorMessage)
        {
            string validML = EscapeNonEscapedAmpersands("<GUIDEML>" + textToCheck + "</GUIDEML>");

            XmlDocument xDoc = new XmlDocument();
            try
            {
                xDoc.LoadXml(validML);
            }
            catch (XmlException ex)
            {
                errorMessage = FormatXmlErrorMessageFromExceptionMessage(ex);
                return false;
            }
            return true;
        }

        /// <summary>
        /// Helper method that parses Xml Exception messages to dna meesages
        /// </summary>
        /// <param name="ex">The Xml Exception</param>
        /// <returns>The dna mundged version</returns>
        private static string FormatXmlErrorMessageFromExceptionMessage(XmlException ex)
        {
            string errorMessage = "";
            string exceptionMessge = ex.Message;
            int comma = exceptionMessge.IndexOf(',');
            int fullstop = exceptionMessge.IndexOf('.');
            if (fullstop < comma)
            {
                errorMessage = exceptionMessge.Substring(0, fullstop);
            }
            else
            {
                errorMessage = exceptionMessge.Substring(0, comma);
                comma = exceptionMessge.IndexOf(',', comma + 1);
                if (fullstop > comma && comma != -1)
                {
                    errorMessage += exceptionMessge.Substring(comma, fullstop - comma);
                }
            }
            return errorMessage + " on line " + ex.LineNumber.ToString();
        }

        /// <summary>
        /// Replaces all non escaped ampersands with escaped versions.
        /// This method uses a crude system in which it checks to see if there's a &amp; and then checks to see
        /// if there's a ; before the next one. If not, then it replaces it with &amp;amp;
        /// </summary>
        /// <param name="textToFix">The text you want to search and replace</param>
        /// <returns>The parsed text</returns>
        public static string EscapeNonEscapedAmpersands(string textToFix)
        {
            int lastPos = 0;
            int currentPos = 0;

            // Quickly check for amps
            if (textToFix.IndexOf('&') == -1)
            {
                // NO amps, return with what we were given
                return textToFix;
            }
            
            // Keep going untill we don't find anyting
            while (currentPos > -1 && lastPos <= textToFix.Length)
            {
                currentPos = textToFix.IndexOf('&', lastPos);
                if (currentPos > -1)
                {
                    // Check to see if there's a ; before the next &
                    int nextSem = textToFix.IndexOf(';', currentPos + 1);


                    if (nextSem == -1)
                    {//no semicolon therefore not escaped
                        textToFix = textToFix.Substring(0, currentPos) + "&amp;" + textToFix.Substring(currentPos + 1, textToFix.Length - currentPos - 1);
                        lastPos = currentPos+5;//add length of &amp;
                    }
                    else
                    {
                        string escapedString = textToFix.Substring(currentPos, nextSem - currentPos + 1);
                        //try and decode the escaped string - if it returns a single letter then its already escaped
                        if (HttpUtility.HtmlDecode(escapedString).Length == 1)
                        {
                            lastPos = nextSem;
                        }
                        else
                        {//not escaped so replace the '&'
                            textToFix = textToFix.Substring(0, currentPos) + "&amp;" + textToFix.Substring(currentPos + 1, textToFix.Length - currentPos - 1);
                            lastPos = currentPos + 5;//add length of &amp;
                        }
                    }
                }
            }
            return textToFix;
        }

        private static string[] _dnaTags = { "quote", "smiley"};
        private static string[] _allowedHtmlTags= { "blockquote", "br", "em", "li", "p", "pre", "q", "strong", "ul", "b"};
        private static Regex StripHTMLExp = new Regex(@"(<\/?(?<tagname>[a-zA-Z0-9]+)[^>]*>)", RegexOptions.Compiled);

        /// <summary>
        /// removes all tag excepted for allowed tags
        /// uppercases all non-dna tags
        /// ignores dnatags completely
        /// </summary>
        /// <param name="Input"></param>
        /// <returns></returns>
        public static string CleanHtmlTags(string Input, bool stripHtmlTags)
        {
            
            string Output = Input;

            foreach (Match Tag in StripHTMLExp.Matches(Input))
            {
                string HTMLTag = Tag.Value.ToLower();
                string tagName = Tag.Groups["tagname"].Value.ToLower();

                if (_dnaTags.Contains(tagName))
                {
                    continue;
                }

                if (!stripHtmlTags && _allowedHtmlTags.Contains(tagName))
                {
                    var newTag = string.Format("<{0}>",tagName.ToUpper());
                    if (Tag.Value.IndexOf("</") == 0)
                    {
                        newTag = string.Format("</{0}>", tagName.ToUpper());
                    }
                    if (Tag.Value.IndexOf("/>") > 0)
                    {
                        newTag = string.Format("<{0}/>", tagName.ToUpper());
                    }
                    Output = ReplaceFirst(Output, Tag.Value, newTag);
                }
                else
                {
                    // Remove tags that are not allowed
                    Output = ReplaceFirst(Output, Tag.Value, "");
                }
            }

            return Output;
        }

        /// <summary>
        /// Runs inputted text against code and only allows a selected set of tags
        /// </summary>
        /// <param name="textToFix">The text to run against</param>
        /// <returns>The fixed string</returns>
        public static string RemoveAllHtmlTags(string textToFix)
        {
            if (string.IsNullOrEmpty(textToFix))
            {
                return textToFix;
            }
            Regex StripHTMLExp = new Regex(@"(<\/?[^>]+>)");
            return StripHTMLExp.Matches(textToFix).Cast<Match>().Aggregate(textToFix, (current, Tag) => current.Replace(Tag.Value, ""));
        }

        /// <summary>
        /// Replaces new lines and carriage returns with HTML <BR /> tags. 
        /// </summary>
        /// <param name="text">The text to be processed.</param>
        public static string ReplaceCRsWithBRs(string text)
        {

            return text.Replace("\r\n", "<BR />").Replace("\n", "<BR />");
        }

        /// <summary>
        /// Replaces the first instance only
        /// </summary>
        /// <param name="haystack"></param>
        /// <param name="needle"></param>
        /// <param name="replacement"></param>
        /// <returns></returns>
        private static string ReplaceFirst(string haystack, string needle, string replacement)
        {
            int pos = haystack.IndexOf(needle);
            if (pos < 0) return haystack;
            return haystack.Substring(0, pos) + replacement + haystack.Substring(pos + needle.Length);
        }

        /// <summary>
        /// Html decodes string
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string HtmlDecode(string text)
        {
            return HttpUtility.HtmlDecode(text);
        }

        /// <summary>
        /// Html encodes string
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string HtmlEncode(string text)
        {
            return HttpUtility.HtmlEncode(text);
        }

        /// <summary>
        /// creates a xmlelement from html and tag to enclose it in
        /// </summary>
        /// <param name="text"></param>
        /// <param name="tagName"></param>
        /// <returns></returns>
        public static XmlElement ParseHtmlToXmlElement(string text, string tagName)
        {
            // Now run it through the xml parser
            XmlDocument xDoc = new XmlDocument();
            if (string.IsNullOrEmpty(text))
            {
                xDoc.LoadXml(string.Format("<{0} />", tagName));
                return xDoc.DocumentElement;
            }
            text = EscapeNonEscapedAmpersands(text);
            tagName = tagName.ToUpper();

            
            try
            {
                xDoc.LoadXml(string.Format("<{0}>{1}</{0}>", tagName, text));
            }
            catch
            {
                xDoc.LoadXml(string.Format("<{0} />", tagName));
                xDoc.DocumentElement.InnerText = text;
            }

            return xDoc.DocumentElement;
           
        }
    }
}
