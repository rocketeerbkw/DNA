using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna.Page
{
    /// <summary>
    /// Setup class for adding aspx control ids and xpath info to the DnaXmlDataSource controls list
    /// </summary>
    public class DnaXmlSourceDetails
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="controlID">The id of the control you want the whole page XML to be it's data source</param>
        /// <param name="xpath">The XPath to the particular part of the tree you want to source from. If left blank, then it uses the root</param>
        public DnaXmlSourceDetails(string controlID, string xpath)
        {
            _controlID = controlID;
            _xpath = xpath;
        }

        private string _controlID = "";
        private string _xpath = "";

        /// <summary>
        /// Get property for the control id
        /// </summary>
        public string ControlID
        {
            get { return _controlID; }
        }

        /// <summary>
        /// Get property for the XPath location
        /// </summary>
        public string XPath
        {
            get { return _xpath; }
        }
    }
}
