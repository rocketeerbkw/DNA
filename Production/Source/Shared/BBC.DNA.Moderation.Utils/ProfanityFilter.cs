using System;
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

                while (reader.Read())
                {
                    int modClassID = reader.GetInt32("ModClassID");
                    string Profanity = reader.GetStringNullAsEmpty("Profanity").ToLower();
                    int Refer = reader.GetByte("Refer");

                    if (!profanityCache.ProfanityClasses.ContainsKey(modClassID))
                    {
                        profanityCache.ProfanityClasses.Add(modClassID, new ProfanityPair());
                    }

                    if (Refer == 1)
                    {
                        profanityCache.ProfanityClasses[modClassID].ReferList.Add(Profanity);
                        //ReferLists[modClassID].Add(Profanity);
                    }
                    else
                    {
                        profanityCache.ProfanityClasses[modClassID].ProfanityList.Add(Profanity);
                        //ProfanityLists[modClassID].Add(Profanity);
                    }
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


            var _object = (ProfanityCache)GetObjectFromCache();
            foreach (var modclass in _object.ProfanityClasses)
            {
                values.Add("ModClassID_" + modclass.Key.ToString() + "_ProfanityList", modclass.Value.ProfanityList.Count.ToString());
                values.Add("ModClassID_" + modclass.Key.ToString() + "_ReferList", modclass.Value.ReferList.Count.ToString());
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
		public static FilterState CheckForProfanities(int modClassID, string textToCheck, out string matchingProfanity)
		{
            var _profanityClasses = ((ProfanityCache)ProfanityFilter.GetObject().GetObjectFromCache()).ProfanityClasses;
			if (false == _profanityClasses.ContainsKey(modClassID))
			{
				matchingProfanity = string.Empty;
				return FilterState.Pass;
			}
			// Check the list of known profanities to see if we have any in the given text.
			// First create a local version of the string to check and make it lowercase.
			string lowerText = textToCheck.ToLower();   

			// Now get the profanity list from the cache and call the contains function
			List<string> ProfanityList;
			ProfanityList = _profanityClasses[modClassID].ProfanityList;
			List<string> ReferList = _profanityClasses[modClassID].ReferList;

			if (DoesTextContain( lowerText, ProfanityList, false, false, out matchingProfanity))
			{
				return FilterState.FailBlock;
			}

			if (DoesTextContain( lowerText, ReferList, false, false, out matchingProfanity))
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
                else if ( !newWord && !Char.IsControl(c) )
                {
                    noPunctuation.Append(c);
                }
            }

            //Right Trim Punctuation
            newWord = true;
            for (int i = noPunctuation.Length-1; i >= 0; --i)
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
                else if ( newWord || Char.IsControl(c) )
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
			bool bMatch = false;
			int whichword = 0;
			string thisword = string.Empty;
			while (whichword < words.Count && !bMatch)
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
			}

			// If we've found a match and we have a valid FirstMatch pointer, fill it in.
			if (bMatch)
			{
				matchingWord = thisword;
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
