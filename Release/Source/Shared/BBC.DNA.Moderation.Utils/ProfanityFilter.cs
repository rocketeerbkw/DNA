
using System;
using System.Linq;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Threading;
using System.Diagnostics;
using System.Text.RegularExpressions;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Common;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Collections.Specialized;
using BBC.DNA.Moderation.Utils;

using BBC.Dna;
namespace BBC.Dna.Moderation.Utils
{

    /// <summary>
    /// General class for handling the profanity list and filtering user input
    /// </summary>
    public class ProfanityFilter : SignalBase<ProfanityCache>
    {

        private const string _signalKey = "recache-terms";

        /// <summary>
        /// FilterState is the three different states the profanity filter can return
        /// </summary>
        public enum FilterState
        {
            /// <summary>
            /// The text passes the filter. No further action
            /// </summary>
            Pass,
            /// <summary>
            /// The text fails. Ask the user to resubmit the contribution.
            /// </summary>
            FailBlock,
            /// <summary>
            /// The text fails. Put the contribution into the moderation queue.
            /// </summary>
            FailRefer
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="connectionString">Connection details for accessing the database</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public ProfanityFilter(IDnaDataReaderCreator dnaData_readerCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
            : base(dnaData_readerCreator, dnaDiagnostics, caching, _signalKey, ripleyServerAddresses, dotNetServerAddresses)
        {
            InitialiseObject += new InitialiseObjectDelegate(InitialiseProfanities);
            HandleSignalObject = new HandleSignalDelegate(HandleSignal);
            GetStatsObject = new GetStatsDelegate(GetTermsStats);
            CheckVersionInCache();
            //register object with main signal helper
            SignalHelper.AddObject(typeof(ProfanityFilter), this);
        }

        /// <summary>
        /// Initialises the terms list
        /// </summary>
        /// <returns>Cachable object</returns>
        private void InitialiseProfanities(params object[] args)
        {
            var profanityCache = new ProfanityCache();

            using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("getallprofanities"))
            {
                reader.Execute();
                try
                {
                    while (reader.Read())
                    {
                        int modClassID = reader.GetInt32("ModClassID");
                        string Profanity = reader.GetStringNullAsEmpty("Profanity").ToLower();
                        int Refer = reader.GetByte("Refer");

                        int profanityId = reader.GetInt32("ProfanityID");

                        int forumID = reader.GetInt32("ForumID");
                       
                        if (false == profanityCache.ProfanityClasses.ModClassProfanities.ContainsKey(modClassID))
                        {
                            if (modClassID != 0)
                            {
                                profanityCache.ProfanityClasses.ModClassProfanities.Add(modClassID, new ProfanityPair());
                            }
                        }

                        if (false == profanityCache.ProfanityClasses.ForumProfanities.ContainsKey(forumID))
                        {
                            if (forumID != 0)
                            {
                                profanityCache.ProfanityClasses.ForumProfanities.Add(forumID, new ProfanityPair());
                            }
                        }

                        if (Refer == 1)
                        {
                            if (modClassID != 0)
                            {
                                profanityCache.ProfanityClasses.ModClassProfanities[modClassID].ReferList.Add(new KeyValuePair<int, string>(profanityId, Profanity));
                            }
                            if (forumID != 0)
                            {
                                profanityCache.ProfanityClasses.ForumProfanities[forumID].ReferList.Add(new KeyValuePair<int, string>(profanityId, Profanity));
                            }
                        }
                        else
                        {
                            if (modClassID != 0)
                            {
                                profanityCache.ProfanityClasses.ModClassProfanities[modClassID].ProfanityList.Add(new KeyValuePair<int, string>(profanityId, Profanity));
                            }
                            if (forumID != 0)
                            {
                                profanityCache.ProfanityClasses.ForumProfanities[forumID].ProfanityList.Add(new KeyValuePair<int, string>(profanityId, Profanity));
                            }
                        }

                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            AddToInternalObjects(GetCacheKey(), GetCacheKeyLastUpdate(), profanityCache);
        }

        /// <summary>
        /// Delegate for handling a signal
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        private bool HandleSignal(NameValueCollection args)
        {
            InitialiseProfanities();
            return true;
        }

        /// <summary>
        /// Returns list statistics
        /// </summary>
        /// <returns></returns>
        private NameValueCollection GetTermsStats()
        {
            var values = new NameValueCollection();
            var modTermValues = new NameValueCollection();
            var forumTermValues = new NameValueCollection();

            var _object = (ProfanityCache)GetObjectFromCache();

            //loop for mod class term values
            foreach (var modclass in _object.ProfanityClasses.ModClassProfanities)
            {
                values.Add("ModClassID_" + modclass.Key.ToString() + "_ProfanityList", modclass.Value.ProfanityList.Count.ToString());
                values.Add("ModClassID_" + modclass.Key.ToString() + "_ReferList", modclass.Value.ReferList.Count.ToString());
            }

            //loop for forum term values
            foreach (var forum in _object.ProfanityClasses.ForumProfanities)
            {
                values.Add("ForumID_" + forum.Key.ToString() + "_ProfanityList", forum.Value.ProfanityList.Count.ToString());
                values.Add("ForumID_" + forum.Key.ToString() + "_ReferList", forum.Value.ReferList.Count.ToString());
            }

            return values;
        }

        /// <summary>
        /// Returns the single static version
        /// </summary>
        /// <returns></returns>
        static public ProfanityFilter GetObject()
        {
            var obj = SignalHelper.GetObject(typeof(ProfanityFilter));
            if (obj != null)
            {
                return (ProfanityFilter)obj;
            }
            return null;
        }

        /// <summary>
        /// Check the given string for profanities according to our internal list
        /// Can either Pass, FailBlock (meaning they have to resubmit) or FailRefer (which
        /// puts the post into the moderation queue)
        /// </summary>
        /// <param name="modClassID">Which moderation class are we in</param>
        /// <param name="textToCheck">String containing the text to check against the list</param>
        /// <param name="matchingProfanity">Which profanity caused it to fail</param>
        /// <returns>
        /// <para>Pass: No profanities found</para>
        /// <para>FailBlock: A profanity was found which means the user must resubmit</para>
        /// <para>FailRefer: A profanity was found whic means the post is put in the moderation queue</para>
        ///</returns>
        ///<remarks>
        /// We want this as a static function primarily to make it testable. This version is less likely to
        /// be called than the above non-static version, which can get the current moderation class from the
        /// input context.
        ///</remarks>
        public static FilterState CheckForProfanities(int modClassID, string textToCheck, out string matchingProfanity, out List<Term> terms, int forumID)
        {
            //Updated the profanity cache to add the profanityid also
            
            var _profanityClasses = ((ProfanityCache)ProfanityFilter.GetObject().GetObjectFromCache()).ProfanityClasses;
            if (false == _profanityClasses.ModClassProfanities.ContainsKey(modClassID))
            {
                matchingProfanity = string.Empty;
                terms = null;
                return FilterState.Pass;
            }
            // Check the list of known profanities to see if we have any in the given text.
            // First create a local version of the string to check and make it lowercase.
            string lowerText = textToCheck.ToLower();

            
            // Now get the profanity list with the profanity id from the cache and call the contains function

            var profanity = new TermClasses();

            List<KeyValuePair<int, string>> ModClassProfanityList = new List<KeyValuePair<int, string>>();
            List<KeyValuePair<int, string>> ModClassReferList = new List<KeyValuePair<int, string>>();
            List<KeyValuePair<int, string>> ForumProfanityList = new List<KeyValuePair<int, string>>();
            List<KeyValuePair<int, string>> ForumReferList = new List<KeyValuePair<int, string>>();

            if (_profanityClasses.ModClassProfanities != null && _profanityClasses.ModClassProfanities.Count > 0
                && (true == _profanityClasses.ModClassProfanities.ContainsKey(modClassID))
                && _profanityClasses.ModClassProfanities[modClassID].ProfanityList != null
                && _profanityClasses.ModClassProfanities[modClassID].ProfanityList.Count > 0)
            {
                ModClassProfanityList = _profanityClasses.ModClassProfanities[modClassID].ProfanityList;
            }

            if (_profanityClasses.ModClassProfanities != null && _profanityClasses.ModClassProfanities.Count > 0
                && (true == _profanityClasses.ModClassProfanities.ContainsKey(modClassID))
                && _profanityClasses.ModClassProfanities[modClassID].ReferList != null
                && _profanityClasses.ModClassProfanities[modClassID].ReferList.Count > 0)
            {
                ModClassReferList = _profanityClasses.ModClassProfanities[modClassID].ReferList;
            }

            if (_profanityClasses.ForumProfanities != null && _profanityClasses.ForumProfanities.Count > 0
                && (true == _profanityClasses.ForumProfanities.ContainsKey(forumID) )
                && _profanityClasses.ForumProfanities[forumID].ProfanityList != null
                && _profanityClasses.ForumProfanities[forumID].ProfanityList.Count > 0)
            {
                ForumProfanityList = _profanityClasses.ForumProfanities[forumID].ProfanityList;
            }

            if (_profanityClasses.ForumProfanities != null &&  _profanityClasses.ForumProfanities.Count > 0
                && (true == _profanityClasses.ForumProfanities.ContainsKey(forumID))
                && _profanityClasses.ForumProfanities[forumID].ReferList != null
                && _profanityClasses.ForumProfanities[forumID].ReferList.Count > 0)
            {
                ForumReferList = _profanityClasses.ForumProfanities[forumID].ReferList;
            }

            if (true == DoesTextContain(lowerText, ModClassProfanityList, false, false, out matchingProfanity, out terms, modClassID, true))
            {
                return FilterState.FailBlock;
            }
            
            if (true == DoesTextContain(lowerText, ForumProfanityList, false, false, out matchingProfanity, out terms, forumID, false))
            {
                return FilterState.FailBlock;
            }


            if (true == DoesTextContain(lowerText, ModClassReferList, false, false, out matchingProfanity, out terms, modClassID, true))
            {
                List<Term> ReferTerms = new List<Term>();
                Term referTerm;
                foreach (Term term in terms)
                {
                    referTerm = new Term();
                    referTerm.Action = term.Action;
                    referTerm.ForumID = term.ForumID;
                    referTerm.Id = term.Id;
                    referTerm.ModClassID = term.ModClassID;
                    referTerm.Value = term.Value;

                    ReferTerms.Add(referTerm);
                }
                string strModClassProfanity = matchingProfanity;

                // Remove the checked term
                //if (terms != null && terms.Count > 0)
                //{
                //    foreach (Term term in terms)
                //    {
                //        if (true == lowerText.Contains(term.Value))
                //        {
                //            lowerText = lowerText.Replace(term.Value, "");
                //        }
                //    }
                //}
                terms.Clear();
                matchingProfanity = string.Empty;

                if (true == DoesTextContain(lowerText, ForumReferList, false, false, out matchingProfanity, out terms, forumID, false))
                {
                    ReferTerms.AddRange(terms.Where(x => !ReferTerms.Exists(z => z.Id == x.Id))); // Add the terms filtered by forum to the Terms filtered by Moderation Class
                }

                terms = ReferTerms;

                if (true == matchingProfanity.Contains(strModClassProfanity))
                {
                    matchingProfanity = matchingProfanity.Replace(strModClassProfanity, "").Trim();
                }
                
                matchingProfanity = strModClassProfanity + " " + matchingProfanity;
                
                matchingProfanity = matchingProfanity.Trim();
                return FilterState.FailRefer;
            }

            if(true == DoesTextContain(lowerText, ForumReferList, false, false, out matchingProfanity, out terms, forumID, false))
            {
                return FilterState.FailRefer;
            }
            return FilterState.Pass;
        }

        /// <summary>
        /// Function to Trim punctuation form start and end of word.
        /// Function is not used. 
        /// </summary>
        /// <param name="inputText"></param>
        /// <returns></returns>
        public static string TrimPunctuation(string inputText)
        {

            //Left Trim Punctuation.
            StringBuilder noPunctuation = new StringBuilder();
            bool newWord = true;
            for (int i = 0; i < inputText.Length; ++i)
            {
                char c = inputText[i];
                if (Char.IsWhiteSpace(c))
                {
                    newWord = true;
                    noPunctuation.Append(c);
                }
                else if (Char.IsNumber(c) || Char.IsLetter(c))
                {
                    newWord = false;
                    noPunctuation.Append(c);
                }
                else if (!newWord && !Char.IsControl(c))
                {
                    noPunctuation.Append(c);
                }
            }

            //Right Trim Punctuation
            newWord = true;
            for (int i = noPunctuation.Length - 1; i >= 0; --i)
            {
                char c = noPunctuation[i];
                if (Char.IsWhiteSpace(c))
                {
                    newWord = true;
                }
                else if (Char.IsNumber(c) || Char.IsLetter(c))
                {
                    newWord = false;
                }
                else if (newWord || Char.IsControl(c))
                {
                    noPunctuation.Remove(i, 1);
                }
            }
            return noPunctuation.ToString();
        }

        /// <summary>
        /// Remove URL's and similar from the input text.
        /// </summary>
        /// <param name="inputText">the input text</param>
        /// <returns>the input text with URL's removed.</returns>
        public static string RemoveLinksFromText(string inputText)
        {
            //URL match expression taken from O'Reilly C# Cookbook 2nd Edition pg. 587
            Regex RE = new Regex(@"(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~])*", RegexOptions.Compiled);
            return RE.Replace(inputText, "");
        }

        /// <summary>
        /// Helper function to scan a string for a list of words and return the first one found
        /// If bAllowPrefixChars is false the word must be preceded by a non-alphanumeric character
        /// If bAllowSuffixChars is false the word must be followed by a non-alphanumeric character.
        /// </summary>
        /// <param name="textToCheck">Text to scan</param>
        /// <param name="words">Delimited words to search for</param>
        /// <param name="bAllowPrefixChars">True if we allow partial matches with leading characters</param>
        /// <param name="bAllowSuffixChars">True if we allow partial matches with trailing characters</param>
        /// <param name="matchingWord"></param>
        /// <returns>true if a search word matched any of the text</returns>
        /// <remarks>
        /// <para>The Prefix chars flags indicate whether partial words are valid matches</para>
        /// <para>bAllowPrefixChars will allow leading alphabetic characters to match</para>
        /// <para>bAllowSuffixChars will allow trailing alphabetic characters to match</para>
        /// <para>prefix = true, suffix = true, search word = 'fred', 'alfredo', 'alfred', 'fredo' and 'fred' will all match</para>
        /// <para>prefix = true, suffix = false, searchword = 'fred', 'alfredo' and 'fredo' will not match, 'alfred' and 'fred' will match</para>
        /// <para>prefix = false, suffix = true, searchword = 'fred', 'alfredo' and 'alfred' will fail, 'fred' and 'fredo' will match</para>
        /// <para>prefix = false, suffix = false, searchword = 'fred', 'alfredo', 'alfred', 'fredo' will fail, 'fred' will match</para>
        /// <para>Note that the prefix and suffix flags are not used by the profanity filter</para>
        /// </remarks>
        public static bool DoesTextContain(string textToCheck, List<string> words,
                                 bool bAllowPrefixChars, bool bAllowSuffixChars,
                                 out string matchingWord)
        {
            //links in the text are not tested for profanities so remove them.
            //textToCheck = RemoveLinksFromText(textToCheck);

            // Go through the list of words.
            int pSearch = -1;
            int pCharBefore = -1;
            int pCharAfter = -1;
            matchingWord = string.Empty;
            List<string> matchingWordList = new List<string>();
            bool bMatch = false;
            int whichword = 0;
            string thisword = string.Empty;

            try
            {
                while (whichword < words.Count)
                {
                    thisword = words[whichword];
                    if (thisword.Length == 0)
                    {
                        whichword++;
                        continue;
                    }
                    // Start from the beginning
                    pSearch = textToCheck.IndexOf(thisword);

                    // If we're checking prefixes, do so
                    if ((!bAllowPrefixChars || !bAllowSuffixChars) && pSearch >= 0)
                    {
                        // Keep checking while we have a search pointer
                        while (pSearch >= 0 && !bMatch)
                        {
                            // Get the chars before and after the matching word
                            pCharBefore = pSearch - 1;
                            pCharAfter = pSearch + thisword.Length;

                            // Check to see if we've got a leading char when checking for prefix OR/AND
                            // trailing chars when checking for suffix.
                            if ((!bAllowPrefixChars && (pCharBefore > 0) && Char.IsLetter(textToCheck[pCharBefore])) ||
                                (!bAllowSuffixChars && (pCharAfter < textToCheck.Length) && (Char.IsLetter(textToCheck[pCharAfter]))))
                            {
                                // We found chars! Find the next match
                                pSearch = textToCheck.IndexOf(thisword, pSearch + 1);	// TODO: Make sure there's no off-by-one errors
                            }
                            else
                            {
                                // We have a non alphabetical char in front! We've found a match.
                                bMatch = true;
                            }
                        }
                    }
                    else
                    {
                        // Have we found a match?
                        if (pSearch >= 0)
                        {
                            bMatch = true;
                        }
                    }

                    // If still don't have a match, get the next word to search for.
                    if (!bMatch)
                    {
                        whichword++;
                        if (whichword < words.Count)
                        {
                            thisword = words[whichword];
                        }
                    }


                    // Checks for duplicates and adds the match to the list
                    if (bMatch)
                    {
                        if (false == matchingWordList.Contains(thisword))
                        {
                            matchingWordList.Add(thisword);
                        }
                        whichword++;
                        bMatch = false;
                    }
                }

                if (matchingWordList.Count > 0)
                {
                    foreach (string word in matchingWordList)
                    {
                        matchingWord += word + " ";
                    }
                    matchingWord = matchingWord.Trim();
                    bMatch = true;
                }

            }
            finally
            {
                matchingWordList.Clear();
                matchingWordList = null;
            }
            // Return the verdict!
            return bMatch;
        }



        /// <summary>
        /// Overloaded method that takes in tyhe keyvaluepair as the input paramter
        /// Helper function to scan a string for a list of words and return the first one found
        /// If bAllowPrefixChars is false the word must be preceded by a non-alphanumeric character
        /// If bAllowSuffixChars is false the word must be followed by a non-alphanumeric character.
        /// </summary>
        /// <param name="textToCheck">Text to scan</param>
        /// <param name="words">Delimited words to search for</param>
        /// <param name="bAllowPrefixChars">True if we allow partial matches with leading characters</param>
        /// <param name="bAllowSuffixChars">True if we allow partial matches with trailing characters</param>
        /// <param name="matchingWord"></param>
        /// <returns>true if a search word matched any of the text</returns>
        /// <remarks>
        /// <para>The Prefix chars flags indicate whether partial words are valid matches</para>
        /// <para>bAllowPrefixChars will allow leading alphabetic characters to match</para>
        /// <para>bAllowSuffixChars will allow trailing alphabetic characters to match</para>
        /// <para>prefix = true, suffix = true, search word = 'fred', 'alfredo', 'alfred', 'fredo' and 'fred' will all match</para>
        /// <para>prefix = true, suffix = false, searchword = 'fred', 'alfredo' and 'fredo' will not match, 'alfred' and 'fred' will match</para>
        /// <para>prefix = false, suffix = true, searchword = 'fred', 'alfredo' and 'alfred' will fail, 'fred' and 'fredo' will match</para>
        /// <para>prefix = false, suffix = false, searchword = 'fred', 'alfredo', 'alfred', 'fredo' will fail, 'fred' will match</para>
        /// <para>Note that the prefix and suffix flags are not used by the profanity filter</para>
        /// </remarks>
        public static bool DoesTextContain(string textToCheck, List<KeyValuePair<int, string>> words,
                                 bool bAllowPrefixChars, bool bAllowSuffixChars,
                                 out string matchingWord, out List<Term> terms, int modClassOrForumID, bool isByModClass)
        {
            //links in the text are not tested for profanities so remove them.
            //textToCheck = RemoveLinksFromText(textToCheck);

            // Go through the list of words.
            int pSearch = -1;
            int pCharBefore = -1;
            int pCharAfter = -1;
            matchingWord = string.Empty;
            List<string> matchingWordList = new List<string>();
            bool bMatch = false;
            int whichword = 0;
            string thisword = string.Empty;
            int termId = 0;
            Term term = null;
            terms = new List<Term>();

            try
            {
                while (whichword < words.Count)
                {
                    thisword = words[whichword].Value;
                    termId = words[whichword].Key;
                    if (thisword.Length == 0)
                    {
                        whichword++;
                        continue;
                    }
                    // Start from the beginning
                    pSearch = textToCheck.IndexOf(thisword);

                    // If we're checking prefixes, do so
                    if ((!bAllowPrefixChars || !bAllowSuffixChars) && pSearch >= 0)
                    {
                        // Keep checking while we have a search pointer
                        while (pSearch >= 0 && !bMatch)
                        {
                            // Get the chars before and after the matching word
                            pCharBefore = pSearch - 1;
                            pCharAfter = pSearch + thisword.Length;

                            // Check to see if we've got a leading char when checking for prefix OR/AND
                            // trailing chars when checking for suffix.
                            if ((!bAllowPrefixChars && (pCharBefore > 0) && Char.IsLetter(textToCheck[pCharBefore])) ||
                                (!bAllowSuffixChars && (pCharAfter < textToCheck.Length) && (Char.IsLetter(textToCheck[pCharAfter]))))
                            {
                                // We found chars! Find the next match
                                pSearch = textToCheck.IndexOf(thisword, pSearch + 1);	// TODO: Make sure there's no off-by-one errors
                            }
                            else
                            {
                                // We have a non alphabetical char in front! We've found a match.
                                bMatch = true;
                            }
                        }
                    }
                    else
                    {
                        // Have we found a match?
                        if (pSearch >= 0)
                        {
                            bMatch = true;
                        }
                    }

                    // If still don't have a match, get the next word to search for.
                    if (!bMatch)
                    {
                        whichword++;
                        if (whichword < words.Count)
                        {
                            thisword = words[whichword].Value;
                            termId = words[whichword].Key;
                        }
                    }


                    // Checks for duplicates and adds the match to the list
                    if (bMatch)
                    {
                        if (false == matchingWordList.Contains(thisword))
                        {
                            matchingWordList.Add(thisword);
                        }
                        whichword++;
                        bMatch = false;

                        //Filling up the terms object and adding it to the terms list
                        //term = new Term();
                        //term.Id = termId;
                        //term.Value = thisword;
                        //if (true == isByModClass)
                        //{
                        //    term.ModClassID = modClassOrForumID;
                        //}
                        //else
                        //{
                        //    term.ForumID = modClassOrForumID;
                        //}
                        //if (false == terms.Contains(term))
                        //{
                        //    terms.Add(term);
                        //}

                        //Filling up the termfiltered object and adding it to the termfiletered list
                        term = new Term();
                        term.Id = termId;
                        term.Value = thisword;
                        if (true == isByModClass)
                        {
                            //term.ModTerms.ModClassID = modClassOrForumID;
                            //term.ModTerms.ModTermList.Add(new KeyValuePair<int, string>(termId, thisword));

                            term.ModClassID = modClassOrForumID;
                            term.ForumID = 0;
                        }
                        else
                        {
                            //term.ForumTerms.ForumID = modClassOrForumID;
                            //term.ForumTerms.ForumTermList.Add(new KeyValuePair<int, string>(termId, thisword));

                            term.ForumID = modClassOrForumID;
                            term.ModClassID = 0;
                        }

                        if (false == terms.Contains(term))
                        {
                            terms.Add(term);
                        }
                    }
                }

                if (matchingWordList.Count > 0)
                {
                    foreach (string word in matchingWordList)
                    {
                        matchingWord += word + " ";
                    }
                    matchingWord = matchingWord.Trim();
                    bMatch = true;
                }

            }
            finally
            {
                matchingWordList.Clear();
                matchingWordList = null;
            }
            // Return the verdict!
            return bMatch;
        }


        /// <summary>
        /// 
        /// </summary>
        public void SendSignal()
        {
            SendSignals();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public ProfanityCache GetObjectFromCache()
        {
            return (ProfanityCache)GetCachedObject();
        }

    }
}
