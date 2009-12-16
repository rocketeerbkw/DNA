using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// Simple container class for extra info tag values
    /// </summary>
    public class ExtraInfoTagValue
    {
        /// <summary>
        /// Default constructor for creating an extra info tag value
        /// </summary>
        /// <param name="tagname">The name of the tag</param>
        /// <param name="value">The value that represnts the tag</param>
        public ExtraInfoTagValue(string tagname, string value)
        {
            _tagName = tagname;
            _value = value;
        }

        private string _tagName;
        private string _value;

        /// <summary>
        /// Get property for the tagname
        /// </summary>
        public string TagName
        {
            get { return _tagName; }
        }

        /// <summary>
        /// Get property for the value
        /// </summary>
        public string Value
        {
            get { return _value; }
        }
    }

    /// <summary>
    /// The ExtraInfo class
    /// </summary>
    public class ExtraInfo : DnaComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ExtraInfo()
        {
        }

        private XmlNode _extraNode;
        private bool _isCreated = false;

        /// <summary>
        /// Use this property to see if the extra info has been created
        /// </summary>
        public bool IsCreated
        {
            get { return _isCreated; }
        }

        /// <summary>
        /// This method creates the extra info object from text
        /// </summary>
        /// <param name="type">The type of the entry the extrainfo belongs to</param>
        /// <param name="extraInfo">The string that the extrainfo should be created from. Can be left blank</param>
        /// <returns>True if the extrainfo was parsed correctly, false if not</returns>
        public bool TryCreate(int type, string extraInfo)
        {
            // TODO - Convert the C++ version
            _extraNode = AddElementTag(RootElement, "EXTRAINFO");
            XmlNode typeNode = AddElementTag(_extraNode, "TYPE");
            AddAttribute(typeNode, "ID", type);
            bool parseOk = true;
            if (extraInfo.Length > 0)
            {
                XmlDocument doc = null;
                try
                {
                    doc = new XmlDocument();
                    doc.LoadXml(extraInfo);

                    // Now add all the child nodes to the tree
                    foreach (XmlNode node in doc.SelectNodes("//EXTRAINFO"))
                    {
                        if (node.Value != null)
                        {
                            AddExtraInfoTagValue(node.Name, node.Value.ToString());
                        }
                    }
                }
                catch (XmlException)
                {
                    parseOk = false;
                }
            }
            _isCreated = true;
            return parseOk;
        }

        /// <summary>
        /// This method allows you to add new tags to the extra info block
        /// </summary>
        /// <param name="tagName">The name of the new tag</param>
        /// <param name="value">The value that represents the new tag</param>
        public void AddExtraInfoTagValue(string tagName, string value)
        {
            // Add the new tag to the tree
            AddTextTag(_extraNode, tagName.ToUpper(), value);
        }

        /// <summary>
        /// Gets the extra info tag values as a list of ExtraInfoTagValues
        /// </summary>
        /// <returns>A list of the tags and values</returns>
        public List<ExtraInfoTagValue> GetExtraInfoTagList()
        {
            // Go through the child elements of the extrainfo adding them to the list
            List<ExtraInfoTagValue> tagValueList = new List<ExtraInfoTagValue>();
            foreach (XmlNode node in _extraNode.ChildNodes)
            {
                tagValueList.Add(new ExtraInfoTagValue(node.Name, node.Value.ToString()));
            }

            // Return the list
            return tagValueList;
        }
    }
}
