using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Api
{
    

    public class PostStyle
    {
        public enum Style
        {
            unknown=0,
            richtext = 1,
            plaintext = 2,

        };

        /// <summary>
        /// Takes a int and maps to the string version
        /// </summary>
        /// <param name="style">The string representation of the style status</param>
        /// <returns>The enum value</returns>
        public static Style GetFromString(string style)
        {
            if (style == null)
            {
                return Style.unknown;
            }
            else
            {
                style = style.ToLower();
            }
            if (style == Style.richtext.ToString())
            {
                return Style.richtext;
            }
            else if (style == Style.plaintext.ToString())
            {
                return Style.plaintext;
            }
            else 
            {
                return Style.unknown;
            }

            
        }

        /// <summary>
        /// Takes a int and maps to the string version
        /// </summary>
        /// <param name="moderationStatus">The integer representation of the style</param>
        /// <returns>The enum version</returns>
        public static Style GetFromInt(int style)
        {
            try
            {
                return (Style)style;
            }
            catch
            { }
            return Style.unknown;
        }
    }

}
