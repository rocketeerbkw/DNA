using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace BBC.Dna
{
    /// <summary>
    /// The DNA HttpServerUtility object. This class is used to provide a layer between DNA and the .NET Web request.
    /// It wraps all the required methods and properties that DNA requires.
    /// </summary>
    public class ServerUtility : IServerUtility
    {
        HttpServerUtility _serverUtility;

        /// <summary>
        /// The ServerUtility constructor
        /// </summary>
        /// <param name="serverUtility">The HttpServerUtility you want to wrap</param>
        public ServerUtility(HttpServerUtility serverUtility)
        {
            _serverUtility = serverUtility;
        }

        /// <summary>
        /// The Map Path method
        /// </summary>
        /// <param name="path">The virtual path</param>
        /// <returns>The physical path</returns>
        public string MapPath(string path)
        {
            return _serverUtility.MapPath(path);
        }

        /// <summary>
        /// The Get Last Error method
        /// </summary>
        /// <returns>The last exception that occured</returns>
        public Exception GetLastError()
        {
            return _serverUtility.GetLastError();
        }

        /// <summary>
        /// The Html Decode method
        /// </summary>
        /// <param name="decodeString">The string to decode</param>
        /// <returns>The decoded result</returns>
        public string HtmlDecode(string decodeString)
        {
            return _serverUtility.HtmlDecode(decodeString);
        }

        /// <summary>
        /// The Transfer method
        /// </summary>
        /// <param name="path">The path to transfer to</param>
        public void Transfer(String path)
        {
            _serverUtility.Transfer(path);
        }

        /// <summary>
        /// The Script Timeout property
        /// </summary>
        public int ScriptTimeout
        {
            get { return _serverUtility.ScriptTimeout; }
            set { _serverUtility.ScriptTimeout = value; }
        }
    }
}
