using System;
using System.Text;
using System.Text.RegularExpressions;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Utility class for processing DNA's GuideML. 
    /// </summary>
    public class GuideMLTranslator
    {
        /// <summary>
        /// An array of url terminators.
        /// </summary>
        private char[] urlTerminators = new char[] { ' ', ',', '\'', '"', '<', '>', '@', '[', ']', '|', '{', '}', '^', '`', '\''};
        /// <summary>
        /// DNA's max url length.
        /// </summary>
        private const int MAXURLLENGTH = 1023;

        /// <summary>
        /// Converts a piece of plain text into GuideML.
        /// </summary>
        /// <param name="text">String to convert from plain text to GuideML</param>
        /// <returns>Converted string</returns>
        public string PlainTextToGuideML(string text)
        {
			return "<GUIDE><BODY>" + ConvertPlainText(text) + "</BODY></GUIDE>";
        }

        /// <summary>
        /// Marks up plain text with GuideML tags e.g. LINK and does not put the resulting string in a XML element.
        /// </summary>
        /// <param name="text">String to convert from plain text to GuideML</param>
        /// <returns>Converted string</returns>
        public string ConvertPlainText(string text)
        {
            string convertedText = String.Empty;
			convertedText = StringUtils.EscapeAllXml(text);
            convertedText = ReplaceHttpWithLinkTag(convertedText);
			//ReplaceHttpWithLinkTag(text, ref convertedText);
			convertedText = HtmlUtils.ReplaceCRsWithBRs(convertedText); 

            return convertedText;
        }

		private string ReplaceHttpWithLinkTag(string text)
		{
			if (String.IsNullOrEmpty(text))
			{
				return string.Empty;
			}
			Regex re = new Regex(@"(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~;])*", RegexOptions.Compiled);
			return re.Replace(text, ReplaceHttpRegex);
		}

		private string ReplaceHttpRegex(Match m)
		{

			string escapeMatch = m.Groups[0].Value;
			if (escapeMatch.Length > MAXURLLENGTH)
			{
				return escapeMatch;
			}
			string trailing = string.Empty;
			if (escapeMatch.EndsWith(".") || escapeMatch.EndsWith("?") || escapeMatch.EndsWith(")") || escapeMatch.EndsWith(","))
			{
				trailing = escapeMatch.Substring(escapeMatch.Length - 1, 1);
				escapeMatch = escapeMatch.Substring(0, escapeMatch.Length - 1);
			}
			escapeMatch = escapeMatch.Replace("'", "&apos;")
				.Replace("\"","&quot;");
			return "<LINK HREF=\"" + escapeMatch + "\">" + escapeMatch + "</LINK>" + trailing;
		}

        /// <summary>
        /// Replaces http:// sequence with GuideML's link tag.
        /// </summary>
        /// <param name="text">String to convert</param>
        /// <param name="convertedText">Converted text</param>
        private void ReplaceHttpWithLinkTag(string text, ref string convertedText)
        {
            if (String.IsNullOrEmpty(text))
            {
                // don't process a null or empty string
                convertedText = convertedText + text;
                return;
            }

            int httpStartPos = text.IndexOf("http://");

            if (httpStartPos >= 0)
            {
                // http:// sequence found. 
                int httpEndPos = text.IndexOfAny(urlTerminators, httpStartPos);

                if (httpEndPos == -1)
                {
                    httpEndPos = text.Length;
                }

                String url = text.Substring(httpStartPos, httpEndPos - httpStartPos);
                String lastCharInUrl = url.Substring(url.Length - 1, 1);

                while (true)
                {
                    if (String.Compare(lastCharInUrl, ")") == 0 ||
                        String.Compare(lastCharInUrl, "?") == 0 ||
                        String.Compare(lastCharInUrl, ".") == 0)
                    {
                        httpEndPos--;
                        url = url.Substring(0, url.Length - 1);
                        lastCharInUrl = url.Substring(url.Length - 1, 1);
                    }
                    else
                    {
                        break;
                    }
                }

                if ((httpEndPos - httpStartPos) > MAXURLLENGTH)
                {
                    convertedText = convertedText + text;

                    return;
                }
                convertedText = convertedText + text.Substring(0, httpStartPos);

                convertedText = convertedText + "<LINK HREF=\"" + url + "\">" + url + "</LINK>";

                ReplaceHttpWithLinkTag(text.Substring(httpEndPos), ref convertedText);
            }
            else
            {
                convertedText = convertedText + text;
            }

            return;
        }
     

    }
}