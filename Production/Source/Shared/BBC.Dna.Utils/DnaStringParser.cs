using System;
using System.Text;
using System.Collections;
using System.Collections.Generic;


namespace BBC.Dna.Utils
{
    /// <summary>
    /// Utility class for parsing strings.
    /// </summary>
    /// <remarks>An substring can be in quotes to indicate that it should not be split.</remarks>
    /// <remarks>Double delimiter tokens are stripped out as are delimiters in substring elements.</remarks>
    public class DnaStringParser
    {
        private String _originalString;
        private String _stringToParse;
        private char[] _delimiters;
        private bool _removeDelimiters;
        private bool _removeQuotes;
        private bool _removeDuplicates;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="s">String to parse.</param>
        /// <param name="delimiters">Delimiters.</param>
        /// <param name="removeDelimiters">A flag to state whether or not delimiters should be removed from the results</param>
        /// <param name="removeDuplicates">A flag to state whether or not to remove quotes from the results</param>
        /// <param name="removeQuotes">A flag to state whether or not to remove duplicate entries form the results</param>
        public DnaStringParser(String s, char[] delimiters, bool removeDelimiters, bool removeQuotes, bool removeDuplicates)
        {
            _originalString = s;
            _delimiters = delimiters;
            _removeDelimiters = removeDelimiters;
            _removeDuplicates = removeDuplicates;
            _removeQuotes = removeQuotes;
        }

        /// <summary>
        /// Parses instance string.
        /// </summary>
        /// <returns>String array containing the substrings in this instance that are delimited by instance delimiters.</returns>
        public string[] Parse()
        {
            PrepareStringForParsing();

            if (_stringToParse.IndexOf('"') > -1)
            {
                return ParseStringContainingQuotes();
            }

            string[] substrings = _stringToParse.Split(_delimiters, StringSplitOptions.RemoveEmptyEntries);

            return TrimAndRemoveDuplicates(substrings);
        }

        /// <summary>
        /// Parses instance string and returns an ArrayList.
        /// </summary>
        /// <returns>Arraylist containing the substrings in this instance that are delimited by instance delimiters.</returns>
        public ArrayList ParseToArrayList()
        {
            PrepareStringForParsing();

            string[] substrings;

            if (_stringToParse.IndexOf('"') > -1)
            {
                substrings = ParseStringContainingQuotes();
            }
            else
            {
                substrings = _stringToParse.Split(_delimiters, StringSplitOptions.RemoveEmptyEntries);
            }

            string[] trimmedsubstrings = TrimAndRemoveDuplicates(substrings);

            ArrayList parsedList = new ArrayList();
            foreach (string substring in trimmedsubstrings)
            {
                parsedList.Add(substring);
            }
            return parsedList;
        }

        /// <summary>
        /// Get's charater separated string based on instance string. 
        /// </summary>
        /// <param name="seperator">The character you want to use as the seperator</param>
        /// <returns>Charater separed string.</returns>
        public string GetParsedString(char seperator)
        {
            StringBuilder commaSeparatedList = new StringBuilder();
            string[] substrings = Parse();

            foreach (string substring in substrings)
            {
                commaSeparatedList.Append(substring + seperator);
            }

            return commaSeparatedList.ToString();
        }

        /// <summary>
        /// Trims elements in string array and removes duplicates.
        /// </summary>
        private string[] TrimAndRemoveDuplicates(string[] preTrim)
        {
            ArrayList postTrim = new ArrayList();
            string trimmedElement;

            foreach (string element in preTrim)
            {
                trimmedElement = element.Trim();
                if (!((trimmedElement == String.Empty) || (postTrim.Contains(trimmedElement) && _removeDuplicates)))
                {
                    postTrim.Add(trimmedElement);
                }
            }

            return (String[])postTrim.ToArray(typeof(string));
        }

        /// <summary>
        /// Internally prepares string for parsing. All processing occurs on the prepared string not the original. 
        /// </summary>
        /// <remarks>Strips out double tokens.</remarks>
        private void PrepareStringForParsing()
        {
            _stringToParse = _originalString;

            foreach (Char delimiter in _delimiters)
            {
                string doubleDelimiter = "" + delimiter + delimiter;

                _stringToParse.Replace(doubleDelimiter, delimiter.ToString());
            }
        }

        /// <summary>
        /// Removes delimiters from string.
        /// </summary>
        /// <param name="s">String to process</param>
        /// <returns>String with delimiters removed.</returns>
        private String RemoveDelimiters(String s)
        {
            foreach (char delimiter in _delimiters)
            {
                s = s.Replace(delimiter.ToString(), "");
            }

            return s;
        }

        /// <summary>
        /// Parses string that contains quotes. 
        /// </summary>
        /// <returns>String array containing the substrings in this instance that are delimited by instance delimiters.</returns>
        /// <remarks>An substring can be in quotes to indicate that it should not be split.</remarks>
        private string[] ParseStringContainingQuotes()
        {
            // Find all the split points for the string
            List<int> splitPoints = new List<int>();
            int quote1 = _stringToParse.IndexOf('"');
            int quote2 = _stringToParse.IndexOf('"', quote1 + 1);
            int splitPoint = _stringToParse.IndexOf(_delimiters[0]);
            while (splitPoint > 0)
            {
                if (splitPoint < quote1 && quote1 > -1)
                {
                    // Split point is before the first quote, so add the split point
                    splitPoints.Add(splitPoint);
                    splitPoint = _stringToParse.IndexOf(_delimiters[0], splitPoint + 1);
                }
                else if (splitPoint > quote1 && splitPoint < quote2)
                {
                    // The delimiter is inside quotes, so just find the next one
                    splitPoint = _stringToParse.IndexOf(_delimiters[0], splitPoint + 1);
                }
                else if (splitPoint > quote1 && splitPoint > quote2)
                {
                    // We're outside the quoted area, so add the split point as it's valid
                    splitPoints.Add(splitPoint);
                    splitPoint = _stringToParse.IndexOf(_delimiters[0], splitPoint + 1);
                    quote1 = _stringToParse.IndexOf('"', quote1);
                    quote2 = _stringToParse.IndexOf('"', quote1 + 1);
                }
            }

            // Now put all the items into the string array
            int pos = 0;
            char[] quote = new char[] { '"' };
            string substring = "";
            ArrayList substrings = new ArrayList();
            for (int i = 0; i <= splitPoints.Count; i++)
            {
                // Check to see if we're the last pass
                if (i == splitPoints.Count)
                {
                    // Last pass, just get the remainding as the stirng
                    substring = _stringToParse.Substring(pos, _stringToParse.Length - pos);
                }
                else
                {
                    // Get the string between the last splitpoint and the current
                    substring = _stringToParse.Substring(pos, splitPoints[i] - pos);
                    pos = splitPoints[i] + 1;
                }
                // Clean up the string and add it to the array
                substring = substring.Trim();
                if (_removeDelimiters)
                {
                    substring = RemoveDelimiters(substring);
                }
                if (_removeQuotes)
                {
                    substring = substring.Trim(quote);
                }
                substrings.Add(substring);
            }

            // Just return the array of strings
            return TrimAndRemoveDuplicates((String[])substrings.ToArray(typeof(string)));
        }

    }
}