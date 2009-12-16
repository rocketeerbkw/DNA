using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;


namespace BBC.Dna
{
    /// <summary>
    /// Class to translate shorthand smiley text eg :-) into smiley XML elements.
    /// </summary>
    public class SmileyTranslator 
    {
        static Hashtable replacements = new Hashtable();
        static Regex regEx;
        static bool _initialised = false;

        /// <summary>
        /// 
        /// </summary>
        public SmileyTranslator()
        {

        }

        /// <summary>
        /// Expands smiley shorthand into <SMILEY> </SMILEY> XML tags
        /// </summary>
        /// <param name="raw">The string to be expanded.</param>
        /// <returns>The translated string.</returns>
        public static string TranslateText(string raw)
        {
            if ( _initialised == false)
            {
                LoadSmileys();
                _initialised = true;
            }

            String result = raw;
            if ( regEx.IsMatch(raw) )
            {
                MatchCollection matches = regEx.Matches(raw);
                foreach ( Match match in matches )
                {
                    String s = match.Value;
                    String replacement = (String)replacements[s];
                    if (replacement != null)
                    {
                        result = result.Replace(s, replacement);
                    }
                }
            }
            return result; 
        }

        /// <summary>
        /// Load list of smileys which need to be replaced by Smiley XML.
        /// Generate XML replacements.
        /// Generate RegEx to match smiley shortcode.
        /// </summary>
        /// <returns></returns>
        private static bool LoadSmileys()
        {
            replacements.Clear();

            String regex = String.Empty;
            using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("getsmileylist"))
            {
                dataReader.Execute();
                while (dataReader.Read())
                {
                    String name = dataReader.GetStringNullAsEmpty("name");
                    String shorthand = dataReader.GetStringNullAsEmpty("tag");
                    
                    String replace = "<SMILEY TYPE='***' H2G2='Smiley#***'/>";
                    shorthand = StringUtils.EscapeAllXml(shorthand);
                    replacements.Add(shorthand, replace.Replace("***",name));

                    if (regex != String.Empty)
                        regex += @"|" + Regex.Escape(shorthand);
                    else
                        regex = Regex.Escape(shorthand);
                }
            }
           

            // Set up the experssion to match on.
            regEx = new Regex( regex, RegexOptions.IgnoreCase);
            return true;
        }
    }
}
