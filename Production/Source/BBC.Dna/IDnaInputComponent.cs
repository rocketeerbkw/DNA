using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna
{
    /// <summary>
    /// Basic Interface for the DnaInputComponent class
    /// </summary>
    /// <remarks>
    /// 
    /// </remarks>
    public interface IDnaInputComponent : IDnaComponent
    {
        /// <summary>
        /// Get the value of the InputContext the interface for querying all aspects of the current request.
        /// </summary>
        IInputContext InputContext
        {
            get;
        }

        /// <summary>
        /// ProcessRequest is called by the DNA framework to ask this object to process the current request
        /// </summary>
        /// <remarks>
        /// If your component is able to work automatically by simply being added to the page,
        /// responding to parameters in the query string, then implement ProcessRequest to build
        /// your XML data, responding to parameters in the query string.
        /// </remarks>
        void ProcessRequest();

        /// <summary>
        /// This method is used to store XML into the KeyValueData table and add the Key as a cookie
        /// to the response. The next request then picks up the cookie key and retrives and inserts the
        /// data back into it's own XML document.
        /// The main use for this is for SSI logic that redirects before getting back to the end user.
        /// </summary>
        /// <param name="name">The name of the cookie you want to store</param>
        /// <param name="dataValue">The XML that you want to be reinserted into the next request page</param>
        /// <param name="cookiePath">The path for the cookie</param>
        /// <returns>The DataKey as a string</returns>
        string AddResponseKeyValueDataCookie(string name, XmlNode dataValue, string cookiePath);

        /// <summary>
        /// Gets the Data value stored against the given key from the KeyValueData table
        /// </summary>
        /// <param name="dataKey">The key for the data</param>
        /// <returns>The value held for the key as a XmlDocument</returns>
        XmlDocument GetKeyValueData(string dataKey);
    }
}
