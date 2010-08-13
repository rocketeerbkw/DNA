using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Class to Check for a valid email address
    /// Email Validation RegEx with help from http://www.regular-expressions.info/regexbuddy/email.html
    /// </summary>
    public static class EmailAddressFilter
    {
        static string validateEmail = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$";
        static string containsEmail = @"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b";

        /*static string containsEmail = "([^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c" +
           "\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+|\\x22([^\\x0d" +
           "\\x22\\x5c\\x80-\\xff]|\\x5c[\\x00-\\x7f])*\\x22)" +
           "(\\x2e([^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e" +
           "\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff]+|" +
           "\\x22([^\\x0d\\x22\\x5c\\x80-\\xff]|\\x5c\\x00" +
           "-\\x7f)*\\x22))*\\x40([^\\x00-\\x20\\x22\\x28" +
           "\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d" +
           "\\x7f-\\xff]+|\\x5b([^\\x0d\\x5b-\\x5d\\x80-\\xff" +
           "]|\\x5c[\\x00-\\x7f])*\\x5d)(\\x2e([^\\x00-\\x20" +
           "\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40" +
           "\\x5b-\\x5d\\x7f-\\xff]+|\\x5b([^\\x0d\\x5b-" +
           "\\x5d\\x80-\\xff]|\\x5c[\\x00-\\x7f])*\\x5d))*";*/

        static Regex regExEmailValidate = new Regex(validateEmail,RegexOptions.IgnoreCase);
        static Regex regExContainsEmail = new Regex(containsEmail, RegexOptions.IgnoreCase);

        /// <summary>
        /// Checks if the string contains an email address
        /// </summary>
        /// <param name="stringToCheck">The string to check if it contains an email address</param>
        /// <returns>True if it contains one</returns>
        public static bool CheckForEmailAddresses(string stringToCheck)
        {
            return regExContainsEmail.IsMatch(stringToCheck);
        }

        /// <summary>
        /// Checks if the string is a valid email address
        /// </summary>
        /// <param name="stringToCheck">The string to check if it is a valid email address</param>
        /// <returns>True if it is a valid email address</returns>
        public static bool IsValidEmailAddresses(string stringToCheck)
        {
            return regExEmailValidate.IsMatch(stringToCheck);
        }
    }
}
