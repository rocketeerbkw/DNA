using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;


namespace BBC.Dna.Utils
{
    /// <summary>
    /// The quote translator class
    /// </summary>
    public class QuoteTranslator
    {
        // Simnple look for <quote> ...... </quote>
        // Expecting the incoming text to be escaped.
        static Regex advancedOpenQuote = new Regex("<quote.*?>(?<!</quote>)", RegexOptions.Multiline | RegexOptions.IgnoreCase);
        static Regex closeQuote = new Regex("</quote>", RegexOptions.IgnoreCase);

        /*
            The following regex &lt;quote.*?&gt;(?<!&lt;/quote&gt;)(?!.*'[^']*&gt;[^']*'.*) tries to cope with > in user names, but doesn't
            seem to work in the .net regex parser. It's here to give a hint on what needs to be done.
        */

        /// <summary>
        /// 
        /// </summary>
        /// <param name="m"></param>
        /// <returns></returns>
        static string AdvancedQuoteReplace(Match m)
        {
            return "";
        }

        /// <summary>
        /// 
        /// </summary>
        public QuoteTranslator()
        {
        }

        /// <summary>
        /// Check the input string for matches 
        /// The quote translator simply capitalises quote elements and attributes <quote>......</quote> into <QUOTE>........</QUOTE>
        /// </summary>
        /// <param name="raw">The string to translate</param>
        /// <returns>The new translated text if something was done, the original if not</returns>
        public static string TranslateText(string raw)
        {
            string result = raw;

            // Get all the open and closing quote matches
            MatchCollection openQuotes = advancedOpenQuote.Matches(raw);
            MatchCollection closeingQuotes = closeQuote.Matches(raw);

            // We'll only process quotes when we have the same number opening as closing. Also make sure there's something to do
            if (openQuotes.Count == closeingQuotes.Count && openQuotes.Count > 0)
            {
                // Go through all the open quotes and make sure they're in the right format
                foreach (Match m in openQuotes)
                {
                    string newText = "<QUOTE" + m.Value.Substring("<quote".Length, m.Value.Length - "<quote>".Length) + ">";
                    newText = newText.Replace("userid=", "USERID=");
                    newText = newText.Replace("user=", "USER=");
                    newText = newText.Replace("postid=", "POSTID=");
                    result = result.Replace(m.Value, newText);
                }

                // Now just replace the closing quotes
                result = result.Replace("</quote>", "</QUOTE>");
            }

            return result;
        }
    }
}
