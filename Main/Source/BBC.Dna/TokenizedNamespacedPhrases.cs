using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// This class is used when you have tokenized phrases or namespaces.
    /// The phrases are contained in one string with tokens for seperators.
    /// e.g. "One|a|Three" where | is the token
    /// </summary>
    public class TokenizedNamespacedPhrases
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="nameSpace">A string that contains tokenized namespaces</param>
        /// <param name="phrases">A string that contains tokenized phrases</param>
        /// <param name="token">The token that is used to seperate the namespaces and phrases</param>
        /// <remarks>IMPORTANT!!! There should be the same amount of phrases as namespaces. If a phrase does not
        /// have a namespace, then an empty string should be present e.g "one||three"</remarks>
        public TokenizedNamespacedPhrases(string nameSpace, string phrases, string token)
        {
            _phrases = phrases;
            _namespace = nameSpace;
            _token = token;
            _tokenSet = true;
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="nameSpace">A string that contains tokenized namespaces</param>
        /// <param name="phrases">A string that contains tokenized phrases</param>
        /// <remarks>IMPORTANT!!! There should be the same amount of phrases as namespaces. If a phrase does not
        /// have a namespace, then an empty string should be present e.g "one||three"</remarks>
        public TokenizedNamespacedPhrases(string nameSpace, string phrases)
        {
            _phrases = phrases;
            _namespace = nameSpace;
        }

        private string _phrases;
        private string _namespace;
        private string _token = "";
        private bool _tokenSet = false;

        /// <summary>
        /// Get property that tell you if the token has been set for this instance.
        /// If not, you should use the 'static public string GetSiteDelimiterToken()' method in NamespacePhrases.
        /// </summary>
        public bool TokenSet
        {
            get { return _tokenSet; }
        }

        /// <summary>
        /// The token get property
        /// </summary>
        public string Token
        {
            get { return _token; }
            set
            {
                _token = value;
                _tokenSet = true;
            }
        }

        /// <summary>
        /// The namespace get property
        /// </summary>
        public string TokenizedNameSpace
        {
            get { return _namespace; }
        }

        /// <summary>
        /// The phrases get property
        /// </summary>
        public string TokenizedPhrases
        {
            get { return _phrases; }
        }
    }
}
