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
    /// </summary>
    public class Translator
    {
        /// <summary>
        /// 
        /// </summary>
        public Translator()
        {

        }

        /// <summary>
        /// Expands smileys and links into the appropriate XML eg <choc/> to <SMILEY></SMILEY> tags
        /// </summary>
        /// <param name="raw">The string to parse</param>
        /// <returns>The string with expanded smileys and links.</returns>
        public static string TranslateText(string raw)
        {
            String translated;

            //Escape Text.
            translated = StringUtils.EscapeAllXml(raw);

            // Perform Smiley Translations
            translated = SmileyTranslator.TranslateText(translated);

            // Expand Links 
            translated = LinkTranslator.TranslateText(translated);

            // Quote translator.
            translated = QuoteTranslator.TranslateText(translated);

            return translated;
            
        }
    }
}