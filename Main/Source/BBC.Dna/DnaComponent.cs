using System;
using System.Data;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Text.RegularExpressions;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Xml.Serialization;

namespace BBC.Dna.Component
{
    /// <summary>
    /// DnaComponent - The base object for any Dna component
    /// </summary>
    public abstract class DnaComponent : IDnaComponent
    {
        /// <summary>
        /// The XMLDocument for the component.
        /// </summary>
        private XmlDocument _XMLDoc = null;

        private XmlElement _rootElement;

        /// <summary>
        /// Gets the XmlElement representing the root of the xml representation of the component.
        /// </summary>
        public XmlElement RootElement
        {
            get { return _rootElement; }
        }

		/// <summary>
		/// Tests to see if the Root Element of this document is empty or not
		/// </summary>
		public bool IsEmpty
		{
			get
			{
				return !_rootElement.HasChildNodes;
			}
		}

        /// <summary>
        /// Default constructor
        /// </summary>
        public DnaComponent()
        {
            // Create the Xml Doc
            _XMLDoc = new XmlDocument();
            _XMLDoc.LoadXml("<DNAROOT/>");
            _rootElement = _XMLDoc.FirstChild as XmlElement;
        }

        /// <summary>
        /// Helper function to import a node from another document.
        /// </summary>
        /// <param name="source">The node you want to import</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode ImportNode(XmlNode source)
        {
            return _XMLDoc.ImportNode(source, true);
        }

        /// <summary>
        /// Helper function for creating a new Element node
        /// </summary>
        /// <param name="name">The name of the node you want to create</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode CreateElementNode(string name)
        {
            return _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);
        }

        /// <summary>
        /// Helper function for creating a new Element
        /// </summary>
        /// <param name="name">The name of the node you want to create</param>
        /// <returns>The new element or null if it failed</returns>
        public XmlElement CreateElement(string name)
        {
            return (XmlElement) _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);
        }

        /// <summary>
        /// Helper function for adding a new element node to an existing node
        /// </summary>
        /// <param name="parent">The node that you want to add this node to</param>
        /// <param name="name">The name of the new node</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode AddElementTag(XmlNode parent, string name)
        {
            // Create the new node
            XmlNode newNode = CreateElementNode(name);
            parent.AppendChild(newNode);

            // Return the new node
            return newNode;
        }

        /// <summary>
        /// Helper function for adding a new element node to an existing Element
        /// </summary>
        /// <param name="parent">The Element that you want to add this Element to</param>
        /// <param name="name">The name of the new Element</param>
        /// <returns>The new Element or null if it failed</returns>
        public XmlElement AddElementTag(XmlElement parent, string name)
        {
            // Create the new Element
            XmlElement newElement = CreateElement(name);
            parent.AppendChild(newElement);

            // Return the new node
            return newElement;
        }

        /// <summary>
        /// Helper function for adding a new text node to an existing node
        /// </summary>
        /// <param name="parent">The node that you want to add this node to</param>
        /// <param name="name">The name of the new node</param>
        /// <param name="value">The value for the new node</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode AddTextTag(XmlNode parent, string name, string value)
        {
            // Create the new node and text element
            XmlNode text = _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);
            XmlNode newNode = _XMLDoc.CreateNode(XmlNodeType.Text, name.ToUpper(), null);
            newNode.Value = value;
            text.AppendChild(newNode);
            parent.AppendChild(text);

            // Return the new node
            return text;
        }

        /// <summary>
        /// Helper function for adding a text node to an existing node, where the text
        /// is know to be Xml compliant (i.e. already suitably escaped, well formed, etc)
        /// 
        /// Use this function when you don't want the XmlNode to escape the text again
        /// when it's converted to a string.
        /// 
        /// If the "value" is not Xml compliant, it calls AddTextTag() instead as a fall-back
        /// option
        /// 
        /// </summary>
        /// <param name="parent">The node that you want to add this node to</param>
        /// <param name="name">The name of the new node</param>
        /// <param name="value">The value for the new node</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode AddXmlTextTag(XmlNode parent, string name, string value)
        {
            // Create the new node and text element
            XmlNode text = _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);

            bool badXml = false;
            try
            {
                text.InnerXml = value;
            }
            catch (XmlException)
            {
                badXml = true;
            }

            if (badXml)
            {
                return AddTextTag(parent, name, value);
            }

            parent.AppendChild(text);

            // Return the new node
            return text;
        }

        /// <summary>
        /// Helper function for adding a new element to an existing node. 
        /// </summary>
        /// <param name="parent">The node you want to add to.</param>
        /// <param name="name">The name of the new node.</param>
        /// <param name="elementXml">String representation of the children of element named in param name.</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode AddElement(XmlNode parent, string name, string elementXml)
        {
            // Create the new node and text element
            XmlNode newNode = _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);
            newNode.InnerXml = elementXml;
            parent.AppendChild(newNode);

            // Return the new node
            return newNode;
        }

        /// <summary>
        /// Helper function for adding a new element to an existing element. 
        /// </summary>
        /// <param name="parent">The element you want to add to.</param>
        /// <param name="name">The name of the new element.</param>
        /// <param name="elementXml">String representation of the children of element named in param name.</param>
        /// <returns>The new element or null if it failed</returns>
        public XmlElement AddElement(XmlElement parent, string name, string elementXml)
        {
            // Create the new text element
            XmlElement newElement = (XmlElement) _XMLDoc.CreateElement(name.ToUpper());
            newElement.InnerXml = elementXml;
            parent.AppendChild(newElement);

            // Return the new node
            return newElement;
        }

        /// <summary>
        /// Helper function for adding an XnlElement to an existing node. 
        /// </summary>
        /// <param name="parent">The node you want to add to.</param>
        /// <param name="name">The name of the new node.</param>
        /// <param name="child">The child of element named in param name.</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode AddElement(XmlNode parent, string name, XmlElement child)
        {
            // Create the new node and text element
            XmlNode newNode = _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);
            newNode.AppendChild(child); 
            parent.AppendChild(newNode);

            // Return the new node
            return newNode;
        }

		/// <summary>
		/// Helper function for adding a new element to an existing node
		/// </summary>
		/// <param name="parentTagName">Name of parent node</param>
		/// <param name="name">Name of new element to create</param>
		/// <param name="elementXml">String representation of children of new element</param>
		/// <returns>The new node, or Null if it failed</returns>
		public XmlNode AddElement(string parentTagName, string name, string elementXml)
		{
			XmlNode parent = _XMLDoc.SelectSingleNode("//" + parentTagName);
			return AddElement(parent, name, elementXml);
		}

		/// <summary>
		/// Insert an entire XmlDocument at the specified position in the current document
		/// </summary>
		/// <param name="parent">Parent node to which the document's nodes should be attached</param>
		/// <param name="document">XmlDocument object to insert as a child of parent</param>
		/// <returns>The XmlNode of the inserted tree</returns>
		public XmlNode AddWholeDocument(XmlNode parent, XmlDocument document)
		{
			return parent.AppendChild(parent.OwnerDocument.ImportNode(document.DocumentElement, true));
		}

		/// <summary>
		/// Insert an entire XmlDocument at the specified position, wrapped in a node with the given name
		/// </summary>
		/// <param name="parent">Parent node to which the outer node should be attached</param>
		/// <param name="outername">Element name for the outer node</param>
		/// <param name="document">XmlDocument whose nodes should be inserted within the outernode</param>
		/// <returns>The XmlNode of the outer node</returns>
		public XmlNode AddWholeDocument(XmlNode parent, string outername, XmlDocument document)
		{
			XmlNode outernode = _XMLDoc.CreateElement(outername.ToUpper());
			XmlNode newparent = parent.AppendChild(outernode);
			AddWholeDocument(newparent, document);
			return newparent;
		}

		/// <summary>
		/// A Ripley-like function to insert a string chunk of XML at the required point of the document
		/// </summary>
		/// <param name="parent">Node to which to add this chunk</param>
		/// <param name="xmlFragment">string of XML to insert</param>
		/// <returns></returns>
		public XmlNode RipleyAddInside(XmlNode parent, string xmlFragment)
		{
			XmlDocument doc = new XmlDocument();
                doc.LoadXml(xmlFragment);
			return AddWholeDocument(parent, doc);
		}

		/// <summary>
		/// Adds the XML contents of a DnaComponent to the current component at the specified node
		/// </summary>
		/// <param name="parent">Parent node to which to add the imported nodes</param>
		/// <param name="component">DnaComponent whose XML should be appended</param>
		/// <returns>The imported node</returns>
		public XmlNode AddInside(XmlNode parent, IDnaComponent component)
		{
			XmlNode lastInserted = null;
			foreach (XmlNode child in component.RootElement.ChildNodes)
			{
				lastInserted = parent.AppendChild(_XMLDoc.ImportNode(child, true));
			}

			return lastInserted;
		}

        /// <summary>
        /// Adds the XmlNode from the given component to the specified parent
        /// </summary>
        /// <param name="parent">Parent node to which to add the imported node</param>
        /// <param name="component">DnaComponent whose node should be appended</param>
        /// <param name="xpathNode">The xpath of the node that you want to append to the parent node</param>
        /// <returns>The imported node</returns>
        public XmlNode AddInside(XmlNode parent, IDnaComponent component, string xpathNode)
        {
            return parent.AppendChild(_XMLDoc.ImportNode(component.RootElement.SelectSingleNode(xpathNode), true));
        }

        /// <summary>
        /// Helper function for adding a new text node to an existing node
        /// </summary>
        /// <param name="parent">The node that you want to add this node to</param>
        /// <param name="name">The name of the new node</param>
        /// <param name="value">The value for the new node</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlNode AddTextTag(XmlNode parent, string name, int value)
        {
            return AddTextTag(parent, name, value.ToString());
        }

        /// <summary>
        /// Helper function for adding a new attribute to a node
        /// </summary>
        /// <param name="node">The node that you want to add the attribute to</param>
        /// <param name="name">The name of the new attribute</param>
        /// <param name="value">The value for the new attribute</param>
        /// <returns>The attribute or null if it failed</returns>
        public XmlAttribute AddAttribute(XmlNode node, string name, string value)
        {
			// TODO: What happens with dodgy characters?
            // Setup some locals and the new attribute we want to add
            XmlAttribute newAttribute = _XMLDoc.CreateAttribute(name.ToUpper());
            newAttribute.Value = value;
            node.Attributes.Append(newAttribute);

            // Return the new Attribute
            return newAttribute;
        }

        /// <summary>
        /// Helper function for adding a new attribute to a node
        /// </summary>
        /// <param name="node">The node that you want to add the attribute to</param>
        /// <param name="name">The name of the new attribute</param>
        /// <param name="value">The value for the new attribute</param>
        /// <returns>The attribute or null if it failed</returns>
        public XmlAttribute AddAttribute(XmlNode node, string name, int value)
        {
            return AddAttribute(node, name, value.ToString());
        }

        /// <summary>
        /// Helper function for adding a new double value attribute to a node
        /// </summary>
        /// <param name="node">The node that you want to add the attribute to</param>
        /// <param name="name">The name of the new attribute</param>
        /// <param name="value">The double value for the new attribute</param>
        /// <returns>The attribute or null if it failed</returns>
        public XmlAttribute AddAttribute(XmlNode node, string name, double value)
        {
            return AddAttribute(node, name, value.ToString());
        }

        /// <summary>
        /// Helper function for adding a new attribute to a element
        /// </summary>
        /// <param name="element">The element that you want to add the attribute to</param>
        /// <param name="name">The name of the new attribute</param>
        /// <param name="value">The value for the new attribute</param>
        public void AddAttribute(XmlElement element, string name, int value)
        {
            element.SetAttribute(name, value.ToString());
        }

        /// <summary>
        /// Helper function for adding a new attribute to a element
        /// </summary>
        /// <param name="element">The element that you want to add the attribute to</param>
        /// <param name="name">The name of the new attribute</param>
        /// <param name="value">The value for the new attribute</param>
        public void AddAttribute(XmlElement element, string name, double value)
        {
            element.SetAttribute(name, value.ToString());
        }

        /// <summary>
        /// Helper function for adding a new bool attribute to a element
        /// </summary>
        /// <param name="element">The element that you want to add the attribute to</param>
        /// <param name="name">The name of the new attribute</param>
        /// <param name="value">The bool value for the new attribute</param>
        public void AddAttribute(XmlElement element, string name, bool value)
        {
            if (value)
            {
                element.SetAttribute(name, "1");
            }
            else
            {
                element.SetAttribute(name, "0");
            }

        }

        /// <summary>
        /// Inserts a given DnaComponents XML into the current page at the Root
        /// </summary>
        /// <param name="component">The component you want to insert</param>
        /// <returns>True if ok, false if not</returns>
        public bool AddInside(IDnaComponent component)
        {
            return AddInside(component, "");
        }

        /// <summary>
        /// Inserts a given DnaComponents XML into the current page
        /// </summary>
        /// <param name="component">The component you want to insert</param>
        /// <param name="nodeName">The name of the node you want to insert the component into. Leave empty to insert on the root node</param>
        /// <returns>True if ok, false if not</returns>
        public bool AddInside(IDnaComponent component, string nodeName)
        {
            XmlElement insertNode = RootElement;
            // Make sure that the component actually has a XML doc
            XmlElement componentRoot = component.RootElement;
            if (componentRoot == null)
            {
                return false;
            }

            // Now get the root node for this component

            // If given a name of a node to insert into, find it
            if (nodeName.Length > 0)
            {
                // Get the requested node
                insertNode = insertNode.SelectSingleNode("//" + nodeName.ToUpper()) as XmlElement;
            }

            // If we have a node to add to, append the component
            if (insertNode != null)
            {
                foreach (XmlNode child in componentRoot.ChildNodes)
                {
                    insertNode.AppendChild(_XMLDoc.ImportNode(child, true));
                }
                return true;
            }
            return false;
        }

        /// <summary>
        /// Imports a given node from a different XmlDocument object and Appends it to the given
        /// XPath defined node.
        /// </summary>
        /// <param name="xmlNodeToImport">The xml node that you want to Import and append</param>
        /// <param name="parentNodeXPath">The XPath to the parent node you want to add to. If this is empty
        /// then the node is appended to the root element</param>
        /// <returns>The node that was imported</returns>
        public XmlNode ImportAndAppend(XmlNode xmlNodeToImport, string parentNodeXPath)
        {
            XmlNode appendToNode = RootElement;
            // Check to see if we've been given a specified parent to append to.
            if (parentNodeXPath.Length > 0)
            {
                appendToNode = _XMLDoc.SelectSingleNode(parentNodeXPath);
                if (appendToNode == null)
                {
                    // Failed to find the specified node to append to.
                    return null;
                }
            }

            // Import and Append the node.
            return appendToNode.AppendChild(_XMLDoc.ImportNode(xmlNodeToImport, true));
        }

        /// <summary>
        /// Imports a given node from a different XmlDocument object and Appends it to the given
        /// XPath defined node.
        /// </summary>
        /// <param name="obj">The declarated object to serialise to xml and add</param>
        /// <param name="parentNodeXPath">The XPath to the parent node you want to add to. If this is empty
        /// then the node is appended to the root element</param>
        /// <returns>The node that was imported</returns>
        public XmlNode SerialiseAndAppend(object obj, string parentNodeXPath)
        {
            XmlNode appendToNode = RootElement;
            // Check to see if we've been given a specified parent to append to.
            if (parentNodeXPath.Length > 0)
            {
                appendToNode = _XMLDoc.SelectSingleNode(parentNodeXPath);
                if (appendToNode == null)
                {
                    // Failed to find the specified node to append to.
                    return null;
                }
            }

            XmlDocument xml = SerialiseToXmlDoc(obj);

            // Import and Append the node.
            return appendToNode.AppendChild(_XMLDoc.ImportNode(xml.DocumentElement, true));
        }

        /// <summary>
        /// Serialises the given object to an XmlDocument
        /// </summary>
        /// <param name="obj">The given object</param>
        /// <returns>An XmlDocument representing the serialised object</returns>
        protected XmlDocument SerialiseToXmlDoc(object obj)
        {
            XmlDocument xml = new XmlDocument();
            using (StringWriterWithEncoding writer = new StringWriterWithEncoding(Encoding.UTF8))
            {
                var ns = new XmlSerializerNamespaces();
                ns.Add("", "");
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UTF8Encoding(false);
                settings.Indent = true;
                settings.OmitXmlDeclaration = true;
                using (XmlWriter xWriter = XmlWriter.Create(writer, settings))
                {
                    System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(obj.GetType());
                    x.Serialize(xWriter, obj, ns);
                    xWriter.Flush();
                    xml.InnerXml = Entities.GetEntities() + writer.ToString();
                }
            }
            return xml;
        }

        /// <summary>
        /// Helper function to format Error Xml.
        /// </summary>
        /// <param name="errortype">A categorisation of error</param>
        /// <param name="errormessage">Error description.</param>
        /// <param name="parent">Optional node to insert error into.</param>
        /// <returns>ALWAYS returns false</returns>
        public bool AddErrorXml(string errortype, string errormessage, XmlNode parent)
        {
            if (parent == null)
            {
                parent = RootElement;
            }

            XmlNode error = CreateElementNode("ERROR");
            AddAttribute(error, "TYPE", errortype);
            AddTextTag(error, "ERRORMESSAGE", errormessage);
            parent.AppendChild(error);

            return false;
        }

        /// <summary>
        /// Like the AddErrorXml method, but adds extra information about the error.
        /// Example would be to display the html that is invalid when a use posts.
        /// </summary>
        /// <param name="errortype">A categorisation of error</param>
        /// <param name="errormessage">Error description.</param>
        /// <param name="extraInfo">Any extra information that goes with the current error</param>
        /// <param name="parent">Optional node to insert error into.</param>
        /// <returns>ALWAYS returns false</returns>
        public bool AddExtendedErrorXml(string errortype, string errormessage, string extraInfo, XmlNode parent)
        {
            if (parent == null)
            {
                parent = RootElement;
            }

            XmlNode error = CreateElementNode("ERROR");
            AddAttribute(error, "TYPE", errortype);
            AddTextTag(error, "ERRORMESSAGE", errormessage);
            AddTextTag(error, "EXTRAINFO", extraInfo);
            parent.AppendChild(error);

            return false;
        }

		/// <summary>
		/// Destroy everything below the object's root element
		/// </summary>
		public void Destroy()
		{
			RootElement.RemoveAll();
		}

        /// <summary>
        /// Helper function for adding a new text element to an existing element
        /// </summary>
        /// <param name="parent">The element that you want to add this element to</param>
        /// <param name="name">The name of the new element</param>
        /// <param name="value">The value for the new element</param>
        /// <returns>The new element or null if it failed</returns>
        public XmlElement AddTextElement(XmlElement parent, string name, string value)
        {
            // Create the new element with the text
            XmlElement text = _XMLDoc.CreateElement(name.ToUpper());
            text.AppendChild(_XMLDoc.CreateTextNode(value));
            parent.AppendChild(text);

            // Return the new element
            return text;
        }

        /// <summary>
        /// Helper function for adding a new Int element to an existing element
        /// </summary>
        /// <param name="parent">The element that you want to add this element to</param>
        /// <param name="name">The name of the new element</param>
        /// <param name="value">The int value for the new element</param>
        /// <returns>The new element or null if it failed</returns>
        public XmlElement AddIntElement(XmlNode parent, string name, int value)
        {
            // Create the new element with the text
            XmlElement text = _XMLDoc.CreateElement(name.ToUpper());
            text.AppendChild(_XMLDoc.CreateTextNode(value.ToString()));
            parent.AppendChild(text);

            // Return the new element
            return text;
        }

        /// <summary>
        /// Add a date from the database in the correct DNADateFormat to the XML
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="parent">parent to add the xml to</param>
        /// <param name="columnName">Column name to extract the date data from</param>
        /// <param name="XMLName">Name of the element in the XML document to store the data data in</param>
        public void AddDateXml(IDnaDataReader dataReader, XmlNode parent, string columnName, string XMLName)
        {
            if (!dataReader.IsDBNull(columnName))
            {
                DateTime date = dataReader.GetDateTime(columnName);
                XmlElement dateXML = DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, date);
                AddElement(parent, XMLName, dateXML);
            }
        }

        /// <summary>
        /// Add a date xml from a DateTime in the correct DNADateFormat to the XML
        /// </summary>
        /// <param name="date">DateTime to represent</param>
        /// <param name="parent">parent to add the xml to</param>
        /// <param name="XMLName">Name of the element in the XML document to store the data data in</param>
        public void AddDateXml(DateTime date, XmlNode parent, string XMLName)
        {
            XmlElement dateXML = DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, date);
            AddElement(parent, XMLName, dateXML);
        }

        /// <summary>
        /// Goes through the XML Tree updating all the relative dates
        /// </summary>
        public void UpdateRelativeDates()
        {
            // Find the first date element
            XmlNodeList dateList = RootElement.SelectNodes("//DATE");
            foreach (XmlNode current in dateList)
            {
                // Get the date from the info
                int year = Convert.ToInt32(current.Attributes["YEAR"].Value);
                int month = Convert.ToInt32(current.Attributes["MONTH"].Value);
                int day = Convert.ToInt32(current.Attributes["DAY"].Value);
                int hours = Convert.ToInt32(current.Attributes["HOURS"].Value);
                int minutes = Convert.ToInt32(current.Attributes["MINUTES"].Value);
                int seconds = Convert.ToInt32(current.Attributes["SECONDS"].Value);

                // Now calculate and update the relative date info
                DateTime date = new DateTime(year,month,day,hours,minutes,seconds,DateTimeKind.Utc);
                if (current.Attributes["RELATIVE"] != null)
                {
                    // Update the existing
                    current.Attributes["RELATIVE"].Value = DnaDateTime.TryGetRelativeValueForPastDate(date);
                }
                else
                {
                    // Create a new attribute
                    AddAttribute(current, "RELATIVE", DnaDateTime.TryGetRelativeValueForPastDate(date));
                }
            }
        }

        /// <summary>
        /// Creates and inserts cached XMLFiles
        /// </summary>
        /// <param name="cachedXML">The XML that represents the object</param>
        /// <param name="parentNodeName">The name of the node you want to import and it's children</param>
        /// <param name="removeExistsingChildren">A flag that lets you specify whether or not to remove any existing child nodes
        /// before inserting the new cached nodes</param>
        /// <returns>True if it created the cached object, false if it failed to parse</returns>
        public bool CreateAndInsertCachedXML(string cachedXML, string parentNodeName, bool removeExistsingChildren)
        {
            // Ok, we've got a cached version, create the XML from the string.
            XmlDocument cachedDoc = new XmlDocument();
            try
            {
                // Create an XML doc from the cached file
                    cachedDoc.LoadXml(cachedXML);
                }
            catch (XmlException ex)
            {
                // Problems!
                AppContext.TheAppContext.Diagnostics.WriteWarningToLog("DnaComponent", ex.Message);
                return false;
            }

            // Put the document into this objects document
            if (cachedDoc.FirstChild != null)
            {
                RootElement.AppendChild(ImportNode(cachedDoc.SelectSingleNode("//" + parentNodeName)));
            }
            return true;
        }

        /// <summary>
        /// Creates and inserts cached XMLFiles to a child
        /// </summary>
        /// <param name="cachedXML">The XML that represents the object</param>
        /// <param name="parentNodeName">The name of the node you want to import and it's children</param>
        /// <param name="removeExistsingChildren">A flag that lets you specify whether or not to remove any existing child nodes
        /// <param name="destinationXpath">The name of the node where you want to append the XML from the RootElement</param>
        /// before inserting the new cached nodes</param>
        /// <returns>True if it created the cached object, false if it failed to parse</returns>
        public bool CreateAndInsertCachedXMLToANode(string cachedXML, string parentNodeName, bool removeExistsingChildren, string destinationXpath)
        {
            // Ok, we've got a cached version, create the XML from the string.
            XmlDocument cachedDoc = new XmlDocument();
            try
            {
                // Create an XML doc from the cached file
                    cachedDoc.LoadXml(cachedXML);
            }
            catch (XmlException ex)
            {
                // Problems!
                AppContext.TheAppContext.Diagnostics.WriteWarningToLog("DnaComponent", ex.Message);
                return false;
            }
            XmlNode postion = RootElement.SelectSingleNode(destinationXpath);
            // Put the document into this objects document
            if (cachedDoc.FirstChild != null && postion != null)
            {
                postion.AppendChild(ImportNode(cachedDoc.SelectSingleNode("//" + parentNodeName)));
            }
            return true;
        }

        /// <summary>
        /// Looks through the given Nodes Text node children and replaces line breaks with BR tags
        /// </summary>
        /// <param name="startNode">The xml node to start look through</param>
        public void ReplaceLineBreaksWithBreakTagsInTextNodes(XmlNode startNode)
        {
            // Chekc to see if we've been given a null node
            if (startNode == null)
            {
                return;
            }

            // Go though all nodes looking for text nodes
            XmlNodeList textNodes = startNode.ChildNodes;
            foreach (XmlNode node in textNodes)
            {
                // Are we a text node?
                if (node.NodeType == XmlNodeType.Text)
                {
                    node.InnerText.Replace("\r\n", "<br/>");
                }

                // Now do the same to the children of this node if it has any?
                if (node.ChildNodes.Count > 0)
                {
                    ReplaceLineBreaksWithBreakTagsInTextNodes(node);
                }
            }
        }

        /// <summary>
        /// Helper function for adding a new text XmlElement to an existing node
        /// </summary>
        /// <param name="parent">The node that you want to add this node to</param>
        /// <param name="name">The name of the new node</param>
        /// <param name="value">The value for the new node</param>
        /// <returns>The new node or null if it failed</returns>
        public XmlElement AddTextTag(XmlElement parent, string name, string value)
        {
            // Create the new node and text element
            XmlElement text = (XmlElement) _XMLDoc.CreateNode(XmlNodeType.Element, name.ToUpper(), null);

            XmlNode newNode = _XMLDoc.CreateNode(XmlNodeType.Text, name.ToUpper(), null);
            newNode.Value = value;
            text.AppendChild(newNode);
            parent.AppendChild(text);

            // Return the new node
            return text;
        }

		/// <summary>
		/// Given a text node in a tree, this will find any instances of URLs in it
		/// and replace them with link tags.
		/// If the node isn't a text node, this does nothing. If the node doesn't contain
		/// any URLs then it also does nothing
		/// </summary>
		/// <param name="node">a node (which should be a text node) in an XML Document</param>
		public static void MakeLinksFromUrls(XmlNode node)
		{
			if (!(node is XmlText))
			{
				return;
			}
			string originalText = node.Value;
			Regex matchlink = new Regex(@"(http|https|ftp)\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?/?([a-zA-Z0-9\-\._\?\,\'/\\\+&%\$#\=~;])*");

			Match m = matchlink.Match(originalText);

			// This text node will have its value replaced by everything before the url
			// Then we add a new LINK element as the next sibling containing the actual URL
			// Then if there are any characters left, we create a new text node and call this function again
			if (m.Success)
			{
				string textBefore = originalText.Substring(0, m.Index);
				string url = m.Value;
				string textAfter = string.Empty;
				if (m.Index + m.Value.Length < originalText.Length)
				{
					textAfter = originalText.Substring(m.Index + m.Value.Length);
				}

				// First, create the link element
				XmlElement linkElement = node.OwnerDocument.CreateElement("LINK");
				linkElement.SetAttribute("HREF", url);
				linkElement.AppendChild(node.OwnerDocument.CreateTextNode(url));
				// If the textBefore value is empty but the textAfter isn't,
				// put the new node *before* the existing one
				// and truncate the existing node
				XmlText afterNode = null;
				if (textBefore.Length == 0 && textAfter.Length > 0)
				{
					node.ParentNode.InsertBefore(linkElement, node);
					node.Value = textAfter;
					afterNode = node as XmlText;
				}
				else if (textBefore.Length > 0)
				{
					node.ParentNode.InsertAfter(linkElement, node);
					node.Value = textBefore;
					if (textAfter.Length > 0)
					{
						afterNode = node.OwnerDocument.CreateTextNode(textAfter);
						node.ParentNode.InsertAfter(afterNode, linkElement);
					}
				}
				else // textBefore and textAfter both empty
				{
                    node.ParentNode.InsertBefore(linkElement,node);
                    node.ParentNode.RemoveChild(node);
				}

				if (textAfter.Length > 0 && textAfter.Contains("http") && afterNode != null)
				{
					MakeLinksFromUrls(afterNode);
				}
			}
		}


    }
}
