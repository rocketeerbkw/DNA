using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// The dna ServerUtility Interface. Impliments all calls needed by DNA from the HttpServerUtility.
    /// </summary>
	public interface IServerUtility
	{
        /// <summary>
        /// The Map Path method
        /// </summary>
        /// <param name="path">The virtual path</param>
        /// <returns>The physical path</returns>
		string MapPath(string path);

        /// <summary>
        /// The Get Last Error method
        /// </summary>
        /// <returns>The last exception that occured</returns>
		Exception GetLastError();

        /// <summary>
        /// The Html Decode method
        /// </summary>
        /// <param name="decodeString">The string to decode</param>
        /// <returns>The decoded result</returns>
        string HtmlDecode(string decodeString);

        /// <summary>
        /// The Transfer method
        /// </summary>
        /// <param name="path">The path to transfer to</param>
        void Transfer(String path);

        /// <summary>
        /// The Script Timeout property
        /// </summary>
        int ScriptTimeout { get; set; }
	}
}
