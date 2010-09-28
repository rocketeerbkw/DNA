using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using BBC.Dna.Data;

namespace BBC.DNA.Moderation.Utils
{
    public class UrlFilter
    {
        //static string URLRegEx = @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\w\d:#@%/;$()~_?\+-=\\\.&]*)";
        
        static string URLRegEx2 = @"(^|[ \t\r\n])((ftp|http|https|gopher|mailto|news|nntp|telnet|wais|file|prospero|aim|webcal):(([A-Za-z0-9$_.+!*(),;/?:@&~=-])|%[A-Fa-f0-9]{2}){2,}(#([a-zA-Z0-9][a-zA-Z0-9$_.+!*(),;/?:@&~=%-]*))?([A-Za-z0-9$_+!*();/?:~-]))";

        //static string complexWWWcheck = @"(([A-Za-z0-9$_.+!*(),;/?:@&~=-])|%[A-Fa-f0-9]{2}){2,}(#([a-zA-Z0-9][a-zA-Z0-9$_.+!*(),;/?:@&~=%-]*))?([A-Za-z0-9$_+!*();/?:~-])";
        static string simpleWWWcheck = @"([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?";

        static Regex regExURL = new Regex(URLRegEx2);
        static Regex regExSimpleWWWcheck = new Regex(simpleWWWcheck);

        /// <summary>
        /// Filter response state
        /// </summary>
        public enum FilterState
        {
            /// <summary>
            /// Passes the non allowed URL check
            /// </summary>
            Pass,
            /// <summary>
            /// Fails the non allowed filter check
            /// </summary>
            Fail
        };


        /// <summary>
        /// Checks the string to see if it might contain a URL.
        /// </summary>
        /// <param name="stringToCheck"></param>
        /// <returns></returns>
        public static bool CheckForURL(string stringToCheck)
        {
            string loweredCheck = stringToCheck.ToLower();
            return regExURL.IsMatch(loweredCheck);
        }

        /// <summary>
        /// Checks a given string for non allowed urls which are taken from the nonallowedurl 
        /// table in the database.
        /// </summary>
        /// <param name="stringToCheck">The string you want to check for non allowed urls</param>
        /// <param name="nonAllowedMatches">Collection of matching urls</param>
        /// <returns>Filter state if the string contains a non allowed URL or not</returns>
        public FilterState CheckForURLs(string stringToCheck, List<string> nonAllowedMatches, int siteId, IDnaDataReaderCreator readerCreator)
        {
            AllowedUrls allowedUrls = new AllowedUrls();
            allowedUrls.LoadAllowedURLLists(readerCreator);
            
            string loweredCheck = stringToCheck.ToLower();
            FilterState filterState = FilterState.Pass;
            nonAllowedMatches.Clear();

            MatchCollection matches = regExURL.Matches(stringToCheck);
            if (matches.Count > 0) //Look for full proper URLs first
            {
                foreach (Match regexmatch in matches)
                {
                    //For all the URLs in the text check to see if they're in the non allowed URL list
                    //if they are fail and add them to the returned matched list

                    bool isAllowed = allowedUrls.DoesAllowedURLListContain(siteId, regexmatch.ToString());

                    if (!isAllowed)
                    {
                        filterState = FilterState.Fail;
                        nonAllowedMatches.Add(regexmatch.ToString());
                    }
                }
            }
            else //if none try the simple www check
            {
                matches = regExSimpleWWWcheck.Matches(stringToCheck);

                foreach (Match regexmatch in matches)
                {
                    //For all the URLs in the text check to see if they're in the non allowed URL list
                    //if they are fail and add them to the returned matched list
                    bool isAllowed = allowedUrls.DoesAllowedURLListContain(siteId, regexmatch.ToString());

                    if (!isAllowed)
                    {
                        filterState = FilterState.Fail;
                        nonAllowedMatches.Add(regexmatch.ToString());
                    }
                }
            }
            return filterState;
        }
    }
}
