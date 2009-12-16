using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// The namespace phrases class
    /// </summary>
    public class NamespacePhrases
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The input context so the class can access the site options</param>
        public NamespacePhrases(IInputContext context)
        {
            _context = context;
        }

        private IInputContext _context = null;

        /// <summary>
        /// This method parses a list of key value pair phrases and namespaces into a list of phrases
        /// </summary>
        /// <param name="phraseAndNamespaces">A list of namespaces phrases to parse. The Key = namespace, Value = tokenizedphrases</param>
        /// <returns>The list of phrases parsed from the key value pairs.</returns>
        public List<Phrase> ParseTokenizedPhrases(List<TokenizedNamespacedPhrases> phraseAndNamespaces)
        {
            // Get the current site delimiter
            char delimiter = _context.GetSiteOptionValueString("KeyPhrases", "DelimiterToken")[0];
            List<Phrase> phrases = new List<Phrase>();

            foreach (TokenizedNamespacedPhrases phraseNamespace in phraseAndNamespaces)
            {
                // Get the namespace and phrase from the current item in the list.
                // Make sure we trim any delimiters from the end of the phrases
                string nameSpace = phraseNamespace.TokenizedNameSpace;
                string tokenizedPhrases = phraseNamespace.TokenizedPhrases.Trim(delimiter);

                // Check to see if we're going to be dealing with quotes
                Array splitPhrases;
                if (tokenizedPhrases.Contains("\""))
                {
                    // Ok, we need to make sure we don't split up the text inside the quotes
                    List<string> quotedphrases = new List<string>();

                    // Parse out the quoted strings
                    int quotestart = 0;
                    int quoteend = 0;
                    int token = 0;
                    string tempPhrases = tokenizedPhrases;

                    while (tempPhrases.Length > 0)
                    {
                        // Get the position of the next delimiter
                        token = tempPhrases.IndexOf(delimiter);

                        // Get the starting quote and ending quote positions
                        quoteend = 0;
                        quotestart = tempPhrases.IndexOf('"', quoteend);
                        if (quotestart < tempPhrases.Length)
                        {
                            quoteend = tempPhrases.IndexOf('"', quotestart + 1);
                        }

                        // See what we're dealing with
                        if (token >= 0)
                        {
                            // We've got a delimiter token. See if we've got any quotes
                            if (quotestart >= 0)
                            {
                                // We've found quotes
                                if (token < quotestart)
                                {
                                    // Remove the string before the delimiter
                                    quotedphrases.Add(tempPhrases.Substring(0, token));
                                    tempPhrases = tempPhrases.Substring(token).TrimStart(delimiter);
                                }
                                else
                                {
                                    // Remove the quoted string
                                    quotedphrases.Add(tempPhrases.Substring(quotestart, quoteend).Trim('"'));
                                    tempPhrases = tempPhrases.Substring(quoteend).TrimStart('"').TrimStart(delimiter);
                                }
                            }
                            else
                            {
                                // Remove the string before the delimiter
                                quotedphrases.Add(tempPhrases.Substring(0, token));
                                tempPhrases = tempPhrases.Substring(token).TrimStart(delimiter);
                            }
                        }
                        else
                        {
                            // No delimiter token found. See if we've got any quotes
                            if (quotestart >= 0)
                            {
                                // We've got quotes
                                // Remove the quoted string
                                quotedphrases.Add(tempPhrases.Substring(quotestart, quoteend).Trim('"'));
                                tempPhrases = tempPhrases.Substring(quoteend).TrimStart('"').TrimStart(delimiter);
                            }
                            else
                            {
                                // No quotes
                                quotedphrases.Add(tempPhrases);
                                tempPhrases = "";
                            }
                        }
                    }

                    splitPhrases = quotedphrases.ToArray();
                }
                else
                {
                    // Split the raw imput using the delimiter
                    splitPhrases = tokenizedPhrases.Split(delimiter);
                }

                foreach (string keyphrase in splitPhrases)
                {
                    // Clean the phrase first
                    string trimmedKeyphrase = keyphrase.Trim();

                    // Check we've got something to add
                    if (trimmedKeyphrase.Length > 0)
                    {
                        phrases.Add(new Phrase(trimmedKeyphrase, nameSpace));
                    }
                }
            }

            // Return the list of phrases
            return phrases;
        }

        /// <summary>
        /// Adds the given namespaced keyphrases to an article
        /// </summary>
        /// <param name="phraseAndNamespaces">A list of namespaced phrases to parse. The Key = namespace, Value = tokenizedphrases</param>
        /// <param name="h2g2ID">The h2g2id of the article you want add the phrases to</param>
        public void AddNameSpacePhrasesToArticle(List<TokenizedNamespacedPhrases> phraseAndNamespaces, int h2g2ID)
        {
            // Get the current site delimiter
            string delimiter = _context.GetSiteOptionValueString("KeyPhrases", "DelimiterToken");

            // Parse the list
            List<Phrase> keyphraseList = ParseTokenizedPhrases(phraseAndNamespaces);

            // Check to see if we did anything
            if (keyphraseList.Count > 0)
            {
                StringBuilder phraselist = new StringBuilder();
                StringBuilder namespacelist = new StringBuilder();
                foreach (Phrase current in keyphraseList)
                {
                    namespacelist.Append((phraselist.Length > 0 ? "|" : "") + current.NameSpace);
                    phraselist.Append((phraselist.Length > 0 ? "|" : "") + current.PhraseName);
                }

                // Now add them to the database
                using (IDnaDataReader reader = _context.CreateDnaDataReader("AddKeyPhrasesToArticle"))
                {
                    reader.AddParameter("h2g2ID", h2g2ID);
                    reader.AddParameter("Keywords", phraselist.ToString());
                    reader.AddParameter("NameSpaces", namespacelist.ToString());
                    reader.Execute();
                }
            }
        }

        /// <summary>
        /// Gets the sites delimiting token for the current site
        /// </summary>
        static public string GetSiteDelimiterToken(IInputContext context)
        {
            // Put the keyphrase delimiter into the XML so the skins can let the user know
            return context.GetSiteOptionValueString("KeyPhrases", "DelimiterToken");
        }
    }
}
