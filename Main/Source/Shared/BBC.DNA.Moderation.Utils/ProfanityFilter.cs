using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Threading;
using System.Diagnostics;
using System.Text.RegularExpressions;
using BBC.Dna.Data;
using BBC.Dna.Utils;


namespace BBC.Dna.Moderation.Utils
{

	/// <summary>
	/// General class for handling the profanity list and filtering user input
	/// </summary>
	public class ProfanityFilter //: DnaInputComponent
	{
		private struct ProfanityPair
		{
			public ProfanityPair(List<string> profanity, List<string> refer)
			{
				_profanityList = profanity;
				_referList = refer;
			}
			private List<string> _profanityList;

			public List<string> ProfanityList
			{
				get { return _profanityList; }
				set { _profanityList = value; }
			}
			private List<string> _referList;

			public List<string> ReferList
			{
				get { return _referList; }
				set { _referList = value; }
			}
		}

		/// <summary>
		/// The main, static data structure to hold the profanities
		/// It's a dictionary which maps a pair of word lists to each moderation class
		/// </summary>
		private static Dictionary<int, ProfanityPair> _profanityClasses;

        /// <summary>
        /// The internal mapping between site name and mod class
        /// </summary>
        private static Dictionary<string, int> _sitenameModclass = new Dictionary<string,int>();

        //private static Dictionary<string, int> _siteNameModClassId;
		
		/// <summary>
		/// A temporary holder to load the profanity list
		/// We then swap this with the main object
		/// </summary>
		private static Dictionary<int, ProfanityPair> _profLoader;
		private static Object _lock = new object();
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

        /*
		/// <summary>
		/// Constructor for a ProfanityFilter object
		/// </summary>
		/// <param name="context">InputContext</param>
		public ProfanityFilter(IInputContext context)
			: base(context)
		{
		}
        */

		//private void InitTest(bool recache)
		//{
		//    Locking.InitialiseCode initmethod = InitialiseIt;
		//    Locking.InitialiseOrRefresh(_lock, initmethod, ref _profanityClasses, recache);

		//}

		//private Dictionary<int, ProfanityPair> InitialiseIt()
		//{
		//    IDnaDataReader reader = InputContext.CreateDnaDataReader("getallprofanities");
		//    InitialiseProfanityClasses();

		//    reader.Execute();

		//    while (reader.Read())
		//    {
		//        int modClassID = reader.GetInt32("ModClassID");
		//        string Profanity = reader.GetStringNullAsEmpty("Profanity").ToLower();
		//        int Refer = reader.GetByte("Refer");

		//        AddProfanityToList(modClassID, Profanity, Refer);
		//    }
		//    reader.Close();
		//    return _profLoader;
		//}

	    /// <summary>
	    /// Initialise the static profanity data if it hasn't already been initialised.
	    /// Safe to call on each request.
	    /// </summary>
	    /// <param name="connectionString">The connection to use</param>
	    /// <param name="readerCreator"></param>
	    /// <param name="dnaDiag">For logging - can be null</param>
	    public static void InitialiseProfanitiesIfEmpty(IDnaDataReaderCreator readerCreator, IDnaDiagnostics dnaDiag)
		{
            if (_profanityClasses == null)
            {
                InitialiseProfanities(readerCreator, dnaDiag);
                return;
            }
		    return;
		}

	    /// <summary>
	    /// 
	    /// </summary>
	    /// <param name="connectionString"></param>
	    /// <param name="readerCreator"></param>
	    /// <param name="dnaDiag"></param>
	    public static void InitialiseProfanities(IDnaDataReaderCreator readerCreator, IDnaDiagnostics dnaDiag)
	    {
	        if (Monitor.TryEnter(_lock))
	        {
	            try
	            {
                    using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getallprofanities"))
	                {
	                    InitialiseProfanityClasses();

	                    reader.Execute();

	                    while (reader.Read())
	                    {
	                        int modClassID = reader.GetInt32("ModClassID");
	                        string Profanity = reader.GetStringNullAsEmpty("Profanity").ToLower();
	                        int Refer = reader.GetByte("Refer");

	                        AddProfanityToList(modClassID, Profanity, Refer);
	                    }
	                }
	                TransferLoadedProfanities();

                        

	            }
	            finally
	            {
	                Monitor.Exit(_lock);
	            }
	        }
	        else
	        {
	            // Failed to get a lock, so something else is initialising
	            // We'll have to wait until the lock is released
	            Monitor.Enter(_lock);
	            Monitor.Exit(_lock);
	            // If _profanityClasses is still null, then something serious has gone wrong
	            // So throw an exception
	            if (_profanityClasses == null)
	            {
	                throw new Exception("InitialiseProfanitiesIfEmpty was unable to create a profanity list");
	            }
	            else
	            {
	                return;
	            }
	        }
	    }

	    /// <summary>
		/// Initialise the data structures with data from an XML file
		/// </summary>
		/// <param name="filename">name of the XML file to use</param>
		/// <param name="schema">nae of the xsd file to check against the data</param>
		/// <returns>true if loaded data</returns>
		public static void InitialiseTestData(string filename, string schema)
		{
			if (_profanityClasses != null)
			{
				return;	// use existing data
			}
			XmlDocument doc = new XmlDocument();
			doc.Schemas.Add(null, schema);
			doc.Load(filename);
			doc.Validate(null);

			InitialiseProfanityClasses();

			// The data gives us the profanity string, the mod class ID amd a Refer flag
			//Dictionary<int, List<string>> ProfanityLists = new Dictionary<int, List<string>>();
			//Dictionary<int, List<string>> ReferLists = new Dictionary<int, List<string>>();

			// Get the profanity information
			foreach (XmlNode profnode in doc.SelectNodes("/profanityData/profanities/P"))
			{
				int modClassID = Convert.ToInt32(profnode.Attributes["ModClassID"].InnerText);
				string Profanity = profnode.Attributes["Profanity"].InnerText.ToLower();
				int Refer = Convert.ToInt32(profnode.Attributes["Refer"].InnerText);

				AddProfanityToList(modClassID, Profanity, Refer);
			}
			TransferLoadedProfanities();

            //add site url to mod class id mapping
            _sitenameModclass.Clear();
            foreach (XmlNode profnode in doc.SelectNodes("/profanityData/siteData/s"))
			{
                _sitenameModclass.Add(profnode.Attributes["urlname"].Value.ToLower(), Convert.ToInt32(profnode.Attributes["modclassid"].Value));

            }

			// Now we've got two strings per modclassID

			//foreach (int modClass in ProfanityLists.Keys)
			//{
			//    ProfanityPair newPair = new ProfanityPair(ProfanityLists[modClass], ReferLists[modClass]);
			//    _profanityClasses.Add(modClass, newPair);
			//}

			if (_profanityClasses.ContainsKey(2))
			{
				throw new Exception("Profanity list shouldn't contain ModClassID 2");
			}
		}

		/// <summary>
		/// Helper function for tests for when we want to explicitly clear the existing profanity data
		/// </summary>
		public static void ClearTestData()
		{
			_profanityClasses = null;
            _sitenameModclass.Clear();
		}

		/// <summary>
		/// Helper function to add a new profanity to our data structures.
		/// Useful for modularising access to the actual structure, so that test initialisation
		/// uses as much real code as possible
		/// </summary>
		/// <param name="modClassID">Moderation class ID for this profanity</param>
		/// <param name="Profanity">The string to find</param>
		/// <param name="Refer">0 for block, 1 for refer</param>
		private static void AddProfanityToList(int modClassID, string Profanity, int Refer)
		{
			if (!_profLoader.ContainsKey(modClassID))
			{
				_profLoader.Add(modClassID, new ProfanityPair(new List<string>(), new List<string>()));
			}
			//if (!ReferLists.ContainsKey(modClassID))
			//{
			//    ReferLists.Add(modClassID, new List<string>());
			//}

			//if (!ProfanityLists.ContainsKey(modClassID))
			//{
			//    ProfanityLists.Add(modClassID, new List<string>());
			//}

			if (Refer == 1)
			{
				_profLoader[modClassID].ReferList.Add(Profanity);
				//ReferLists[modClassID].Add(Profanity);
			}
			else
			{
				_profLoader[modClassID].ProfanityList.Add(Profanity);
				//ProfanityLists[modClassID].Add(Profanity);
			}
		}

		/// <summary>
		/// Initialise the data structures used to store the profanities
		/// </summary>
		private static void InitialiseProfanityClasses()
		{
			// The static data consists of a dictionary of moderation class IDs as keys
			// and a pair of lists of strings
			_profLoader = new Dictionary<int, ProfanityPair>();
		}

		/// <summary>
		/// Takes the profanity list loaded into _profLoader and puts it in
		/// the _profanityClasses variable
		/// </summary>
		private static void TransferLoadedProfanities()
		{
			_profanityClasses = _profLoader;
		}

        /// <summary>
        /// Loads the mappings between sitename and mod class
        /// </summary>
        /// <param name="connectionString">The connection to use</param>
        /// <param name="dnaDiag">For logging - can be null</param>
        private static void LoadSiteNameModClasses(string connectionString, IDnaDiagnostics dnaDiag)
        {
            _sitenameModclass.Clear();

            foreach (int modClassID in _profanityClasses.Keys)
            {
                using (IDnaDataReader reader = StoredProcedureReader.Create("getsitesformoderationclass", connectionString, dnaDiag))
                {
                    reader.AddParameter("modclassid", modClassID);
                    reader.Execute();

                    while (reader.Read())
                    {
                        _sitenameModclass.Add(reader.GetString("urlname"), modClassID);
                    }

                }
            }
        }


        /*
		/// <summary>
		/// Non-static check for profanities which gets the current moderation class out of the input context
		/// </summary>
		/// <param name="textToCheck">The string we're checking</param>
		/// <param name="matchingProfanity">If it fails, which profanity did it find</param>
		/// <returns>Pass, FailBlock or FailRefer</returns>
		public FilterState CheckForProfanities(string textToCheck, out string matchingProfanity)
		{
			return CheckForProfanities(InputContext.CurrentSite.ModClassID, textToCheck, out matchingProfanity);
		}
        */

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
        /// Check the given string for profanities according to our internal list
        /// Can either Pass, FailBlock (meaning they have to resubmit) or FailRefer (which
        /// puts the post into the moderation queue)
        /// </summary>
        /// <param name="siteName">The site url name</param>
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
        public static FilterState CheckForProfanities(string siteName, string textToCheck, out string matchingProfanity)
        {
            //get modclassid from sitename

            int modClassId = 0;
            if (_sitenameModclass.ContainsKey(siteName))
            {
                modClassId = (int)_sitenameModclass[siteName];
            }
            return CheckForProfanities(modClassId, textToCheck, out matchingProfanity);
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
		
        /*
		/// <summary>
		/// Request processing code for the Profanity filter object
		/// Currently used only for testing
		/// </summary>
		public override void ProcessRequest()
		{
			if (InputContext.DoesParamExist("testspeed", "Flag used to do speed tests on the profanity filter. Test purposes only"))
			{
				int numRepeats = InputContext.GetParamIntOrZero("numrepeats", "Number of repeats for speed testing of profanity filter");
				string textToCheck = InputContext.GetParamStringOrEmpty("texttocheck", "test to use when speed testing the profanity filter");
				Stopwatch watch = new Stopwatch();
				XmlNode node = AddElementTag(RootElement, "PROFANITYTIMER");
				
				// Do some repeats with different sized data
				DoProfanityTest(node, textToCheck, numRepeats, 1);
				DoProfanityTest(node, textToCheck, numRepeats, 2);
				DoProfanityTest(node, textToCheck, numRepeats, 4);
				DoProfanityTest(node, textToCheck, numRepeats, 8);
				DoProfanityTest(node, textToCheck, numRepeats, 16);
				DoProfanityTest(node, textToCheck, numRepeats, 32);
				DoProfanityTest(node, textToCheck, numRepeats, 64);
				DoProfanityTest(node, textToCheck, numRepeats, 128);
			}
		}

		private void DoProfanityTest(XmlNode parentnode, string textToCheck, int numRepeats, int numDuplicates)
		{
			Stopwatch watch = new Stopwatch();

			StringBuilder repeats = new StringBuilder();
			for (int i = 0; i < numDuplicates; i++)
			{
				repeats.Append(textToCheck);
			}
			string bigtext = repeats.ToString();
			ProfanityFilter filter = new ProfanityFilter(InputContext);
			watch.Start();
			for (int i = 0; i < numRepeats; i++)
			{
				string word;
				filter.CheckForProfanities(bigtext, out word);
			}
			watch.Stop();
			XmlNode node = AddElementTag(parentnode, "EVENT");
			AddAttribute(node, "TIME", watch.ElapsedMilliseconds.ToString());
			AddAttribute(node, "REPEATS", numRepeats.ToString());
			AddAttribute(node, "STRINGDUPLICATES", numDuplicates.ToString());
		}
         * */

	}
}
