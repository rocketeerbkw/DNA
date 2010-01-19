using System;
using System.Collections.Generic;
using System.Text;

namespace Tests
{
    /// <summary>
    /// Object used to create a collection of post params to use with the DnaTestURLRequest object
    /// </summary>
    public class DnaTestURLRequestParams
    {
        Queue<KeyValuePair<string, string>> _postParams = new Queue<KeyValuePair<string, string>>();

        /// <summary>
        /// Gets the post params object containing the params
        /// </summary>
        public Queue<KeyValuePair<string, string>> PostParams
        {
            get { return _postParams; }
        }

        /// <summary>
        /// Adds the given key/value pair to the list of post params
        /// </summary>
        /// <param name="key">The key</param>
        /// <param name="value">The value</param>
        public void Add(string key, string value)
        {
            _postParams.Enqueue(new KeyValuePair<string, string>(key,value));
        }
    }
}
