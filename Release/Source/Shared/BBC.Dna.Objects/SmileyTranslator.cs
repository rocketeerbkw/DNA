using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;


namespace BBC.Dna.Objects
{
    /// <summary>
    /// Class to translate shorthand smiley text eg :-) into smiley XML elements.
    /// </summary>
    public class SmileyTranslator 
    {
        public static Hashtable Replacements = new Hashtable();
        public static bool IsInitialised = false;

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
            if ( IsInitialised == false)
            {//not iniatlised so just return
                return raw;
            }

            String result = raw;
            foreach (string shortcut in Replacements.Keys)
            {
                result = result.Replace(shortcut, (string)Replacements[shortcut]);
            }
            return result; 
        }

        /// <summary>
        /// Load list of smileys which need to be replaced by Smiley XML.
        /// Generate XML replacements.
        /// Generate RegEx to match smiley shortcode.
        /// </summary>
        /// <returns></returns>
        public static void LoadSmileys(IDnaDataReaderCreator  creator)
        {
            Replacements.Clear();
            IsInitialised = false;
            String regex = String.Empty;
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getsmileylist"))
            {
                dataReader.Execute();
                while (dataReader.Read())
                {
                    String name = dataReader.GetStringNullAsEmpty("name");
                    String shorthand = dataReader.GetStringNullAsEmpty("tag");
                    
                    String replace = "<SMILEY TYPE='***' H2G2='Smiley#***'/>";
                    //shorthand = StringUtils.EscapeAllXml(shorthand);
                    Replacements.Add(shorthand, replace.Replace("***",name));
                }
            }
            IsInitialised = true;
        }
    }
}
