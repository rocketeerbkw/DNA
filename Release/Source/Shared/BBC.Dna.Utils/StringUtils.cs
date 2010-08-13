using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Text.RegularExpressions;
using System.Runtime.Serialization;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Xml.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Utility class for escaping and unescaping strings.
    /// </summary>
    public class StringUtils
    {
        /// <summary>
        /// Escapes the text so that it can be inserted into an XML tag
        /// It replaces &amp; , &lt; and &gt; with &amp;amp;, &lt;lt; and &gt;gt; respectively
        /// </summary>
        /// <param name="text">The text to be escaped</param>
        /// <returns>An escaped version of text</returns>
        public static string EscapeAllXml(string text)
        {
            if (text != null)
            {
				//text = text.Replace("&", "&amp;");
				//text = text.Replace("<", "&lt;");
				//text = text.Replace(">", "&gt;");
				XmlDocument doc = new XmlDocument();
				XmlText plaintext = doc.CreateTextNode(text);
				text = plaintext.OuterXml;
			}

            return text;
        }

        static string _pattern = @"&#x(0[0-8BCE-F]|1[0-9A-F])?;|&#(0[0-8]|1[1-24-9]|2[0-9]|3[01])?;|[^\u0009\u000A\u000D\u0020-\uFFFF]";
        
        static Regex _regex = new Regex(_pattern, RegexOptions.IgnoreCase | RegexOptions.Compiled);
        
        /// <summary>
		/// Strips out any illegal characters (below 32 except CR, LF and tab)
		/// </summary>
		/// <param name="text">string to process</param>
		/// <returns>sanitised text</returns>
        public static string StripInvalidXmlChars(string text)
        {
            if (_regex.IsMatch(text))
            {
                text = _regex.Replace(text, String.Empty);
            }
            return text;
        }

        /// <summary>
        /// Strips out any illegal characters (below 32 except CR, LF and tab)
        /// </summary>
        /// <param name="text">string to process</param>
        /// <returns>sanitised text</returns>
        public static string StripInvalidXmlChars2(string text)
        {
            char[] textchars = text.ToCharArray();
            for(int i = 0; i < textchars.Length;i++)
            {
                if (textchars[i] < 32)
                {
                    //If it is not one of the chracters tab or line feed or carriage return replace with ?
                    if (!(textchars[i] == '\t' || textchars[i] == '\n' || textchars[i] == '\r'))
                    {
                        textchars[i] = '?';
                    }
                }
            }
            return new string(textchars);
        }

        /// <summary>
        /// Unescapes the text so that it can be inserted into an XML tag
        /// It replaces &amp;amp;, &lt;lt; and &gt;gt; with &amp; , &lt; and &gt;  respectively
        /// </summary>
        /// <param name="text">The text to be unescaped</param>
        /// <returns>An unescaped version of text</returns>
        public static string UnescapeAllXml(string text)
        {
            if (text != null)
            {
                text = text.Replace("&amp;", "&");
                text = text.Replace("&lt;", "<");
                text = text.Replace("&gt;", ">");
            }

            return text;
        }

        /// <summary>
        /// Does everthing EscapeAllXml() plus escapes single apostophe characters
        /// </summary>
        /// <see cref="EscapeAllXml"/>
        /// <param name="text">The text to be escaped</param>
        /// <returns>An escaped version of text</returns>
        public static string EscapeAllXmlForAttribute(string text)
        {
            if (text != null)
            {
                text = EscapeAllXml(text);
                text = text.Replace("'", "&apos;");
            }

            return text;
        }

        /// <summary>
        /// Converts a piece of plain text into GuideML.
        /// </summary>
        /// <param name="text">String to convert from plain text to GuideML</param>
        /// <returns>Converted string with &lt;GUIDE&gt;&lt;BODY&gt;</returns>
        public static string PlainTextToGuideML(string text)
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML = String.Empty;
            guideML = guideMLTranslator.PlainTextToGuideML(text);

            return guideML;
        }

        /// <summary>
        /// Marks-up a piece of plain text.
        /// </summary>
        /// <param name="text">String to convert from plain text to GuideML</param>
        /// <returns>Converted string</returns>
        public static string ConvertPlainText(string text)
        {
            GuideMLTranslator guideMLTranslator = new GuideMLTranslator();
            string guideML = String.Empty;
            guideML = guideMLTranslator.ConvertPlainText(text);
            return guideML;
        }

        /// <summary>
        /// returns a string without any formatting tags or newlines
        /// Note this should match client side JS 
        /// </summary>
        /// <param name="text">String to be stripped</param>
        /// <returns>Converted string</returns>
        public static string StripFormattingFromText(string text)
        {
            Regex regTags = new Regex("(<([^>]+)>)");
            text = regTags.Replace(text,"");

            Regex regSpaces = new Regex("/s");
            text = regSpaces.Replace(text, "");

            return text;
        }

        /// <summary>
        /// UnEscapes a URL parameter. Replaces + with spaces and %XX with the ascii equivalent. Used to clean up parameters passed in the query string.
        /// </summary>
        /// <param name="text">String to unescape.</param>
        /// <returns>Converted string.</returns>
        public static string UnescapeString(string text)
        {
			return Uri.UnescapeDataString(text.Replace('+',' '));
			//String unescapedString = Uri.UnescapeDataString(text);

			//String plusString = unescapedString.Replace('+', ' ');

			//return plusString; 
        }


        /// <summary>
        /// Makes a string a valid file identitier.
        /// </summary>
        /// <param name="text">String to make safe.</param>
        /// <returns>Safe string.</returns>
        public static string MakeStringFileNameSafe(string text)
        {
            string safeText = text;
            foreach ( char disallowed in System.IO.Path.GetInvalidFileNameChars())
            {
                safeText = safeText.Replace(disallowed.ToString(), ""); 
            }
            foreach (char disallowed in System.IO.Path.GetInvalidPathChars())
            {
                safeText = safeText.Replace(disallowed.ToString(), "");
            }
            return safeText;
        }

        /// <summary>
        /// Replaces the ampersand character with "&amp;", but only if 
        /// it's not already part of a "&amp;" string
        /// </summary>
        /// <param name="text">The text to be escaped</param>
        /// <returns>An escaped version of text</returns>
        public static string EscapeAmpersands(string text)
        {
            if (text != null)
            {
                text = text.Replace("&amp;", "&");
                text = text.Replace("&", "&amp;");
            }

            return text;
        }

        /// <summary>
        /// Strips the given name of 'a ' or 'the '
        /// </summary>
        /// <param name="name">Name to strip</param>
        /// <returns>Stripped name</returns>
        public static string StrippedName(string name)
        {
            if (name == null) { return String.Empty; }
            string strippedName = name;
            if (strippedName.ToLower().StartsWith("a "))
            {
                strippedName = name.Substring(2);
            }
            else if (strippedName.ToLower().StartsWith("the "))
            {
                strippedName = name.Substring(4);
            }
            return strippedName;
        }


        /// <summary>
        /// Generates a summary from a given peice of text. Copes with RichText and GuideML
        /// </summary>
        /// <param name="text">The text to generate the summary from</param>
        /// <param name="summaryLength">The max length of the summary you want</param>
        /// <returns>The summary for the given text</returns>
        public static string GenerateSummaryFromText(string text, int summaryLength)
        {
            string summary = "";
            XmlDocument xDoc = new XmlDocument();
            try
            {
                // Load the text into the xml document.
                xDoc.LoadXml("<summary>" + text + "</summary>");

                // Check to see if we've got any child nodes. If so, then we've got richtext or guideml
                if (xDoc.FirstChild.HasChildNodes)
                {
                    int count = 0;
                    XmlNode start = xDoc.FirstChild.FirstChild;
                    XmlNode next = TrimTextNodes(start, ref count, summaryLength);
                    while (next != null)
                    {
                        next = TrimTextNodes(next, ref count, summaryLength);
                    }
                    summary = xDoc.FirstChild.InnerXml;
                }
                else
                {
                    // Plain text, just get the first 256 chars and return
                    summary = text.Substring(0, summaryLength);
                    if (text.Length > summaryLength)
                    {
                        summary += "...";
                    }
                }
            }
            catch (Exception ex)
            {
                string error = ex.Message;
                if (ex.InnerException != null)
                {
                    error += " : " + ex.InnerException.Message;
                }
                //AppContext.TheAppContext.Diagnostics.WriteWarningToLog("StringUtils", error);
                summary = text.Substring(0, summaryLength);
                if (text.Length > summaryLength)
                {
                    summary += "...";
                }
                summary = EscapeAllXml(summary);
            }

            return summary;
        }

        /// <summary>
        /// Trims text nodes so that the total number of text chars is maxCharCount. After maxCharCount chars have been allocated,
        /// then the rest of the text/nodes are removed.
        /// </summary>
        /// <param name="node">The current node to check</param>
        /// <param name="currentCharCount">The current char count</param>
        /// <param name="maxCharCount">The max total text chars you want before trimming</param>
        /// <returns>The child node, next sibling, parents next sibling or null if all nodes have been processed</returns>
        private static XmlNode TrimTextNodes(XmlNode node, ref int currentCharCount, int maxCharCount)
        {
            XmlNode next = null;
            if (currentCharCount > maxCharCount)
            {
                if (node.NextSibling != null)
                {
                    next = node.NextSibling;
                }
                else if (node.ParentNode.NextSibling != null)
                {
                    next = node.ParentNode.NextSibling;
                }
                else
                {
                    next = null;
                }
                node.ParentNode.RemoveChild(node);
            }
            else
            {
                if (node.NodeType == XmlNodeType.Text)
                {
                    if ((currentCharCount + node.Value.Length) > maxCharCount)
                    {
                        node.Value = node.Value.Substring(0, maxCharCount - currentCharCount) + "...";
                    }
                    currentCharCount += node.Value.Length;
                }

                if (node.FirstChild != null)
                {
                    next = node.FirstChild;
                }
                else if (node.NextSibling != null)
                {
                    next = node.NextSibling;
                }
                else
                {
                    next = node.ParentNode.NextSibling;
                }
            }
            return next;
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
                    node.ParentNode.InsertBefore(linkElement, node);
                    node.ParentNode.RemoveChild(node);
                }

                if (textAfter.Length > 0 && textAfter.Contains("http") && afterNode != null)
                {
                    MakeLinksFromUrls(afterNode);
                }
            }
        }

        /// <summary>
        /// Method to reconstruct an Object from XML string
        /// </summary>
        /// <param name="pXmlizedString"></param>
        /// <returns></returns>
        public static Object DeserializeObject(String xmlString, Type type)
        {
            DataContractSerializer xs = new DataContractSerializer(type);
            using (MemoryStream memoryStream = new MemoryStream(StringToUTF8ByteArray(xmlString)))
            {
                XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
                return xs.ReadObject(memoryStream);
            }
        }

        /// <summary>
        /// Method to reconstruct an Object from XML string
        /// </summary>
        /// <param name="pXmlizedString"></param>
        /// <returns></returns>
        public static Object DeserializeJSONObject(String jsonString, Type type)
        {
            DataContractJsonSerializer xs = new DataContractJsonSerializer(type);
            using (MemoryStream memoryStream = new MemoryStream(StringToUTF8ByteArray(jsonString)))
            {
                XmlTextWriter xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
                return xs.ReadObject(memoryStream);
            }
        }

        /// <summary>
        /// Takes an object, type and namespace and outputs xml
        /// </summary>
        /// <param name="obj">The object to serialize</param>
        /// <returns>XML string</returns>
        public static string SerializeToXml(object obj)
        {
            using (StringWriterWithEncoding writer = new StringWriterWithEncoding(Encoding.UTF8))
            {
                DataContractSerializer dcSerializer = new DataContractSerializer(obj.GetType());
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UTF8Encoding(false);

                using (XmlWriter xWriter = XmlWriter.Create(writer, settings))
                {
                    dcSerializer.WriteObject(xWriter, obj);
                    xWriter.Flush();
                    return writer.ToString();
                }
            }
        }

        /// <summary>
        /// Takes an object, type and namespace and outputs xml
        /// </summary>
        /// <param name="obj">The object to serialize</param>
        /// <returns>XML string</returns>
        public static string SerializeToXmlUsingXmlSerialiser(object obj)
        {
            using (var memoryStream = new MemoryStream())
            {
                var ns = new XmlSerializerNamespaces();
                ns.Add("", "");
                var xs = new XmlSerializer(obj.GetType());
                var xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
                xs.Serialize(xmlTextWriter, obj, ns);
                using (var memoryStream2 = (MemoryStream)xmlTextWriter.BaseStream)
                {
                    var actualXml = UTF8ByteArrayToString(memoryStream2.ToArray());
                    actualXml = actualXml.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");

                    return actualXml.TrimStart();
                }
            }
        }

        /// <summary>
        /// Method to reconstruct an Object from XML string
        /// </summary>
        /// <param name="xmlString"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public static Object DeserializeObjectUsingXmlSerialiser(String xmlString, Type type)
        {
            var xs = new XmlSerializer(type);
            using (var memoryStream = new MemoryStream(StringToUTF8ByteArray(xmlString)))
            {
                var xmlTextWriter = new XmlTextWriter(memoryStream, Encoding.UTF8);
                return xs.Deserialize(memoryStream);
            }
        }


        /// <summary>
        /// Takes an object, type and namespace and outputs xml
        /// </summary>
        /// <param name="obj">The object to serialize</param>
        /// <returns>json string</returns>
        public static string SerializeToJson(object obj)
        {
            DataContractJsonSerializer ser = new DataContractJsonSerializer(obj.GetType());
            using (MemoryStream ms = new MemoryStream())
            {
                ser.WriteObject(ms, obj);

                string json = Encoding.UTF8.GetString(ms.ToArray());
                return json;
            }
        }

        /// <summary>
        /// Takes a syndication feed and returns an RSS string
        /// </summary>
        /// <param name="feed">Syndication Feed</param>
        /// <returns>RSS formated string</returns>
        public static string SerializeToRss(SyndicationFeed feed)
        {
            using (StringWriterWithEncoding writer = new StringWriterWithEncoding(Encoding.UTF8))
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UTF8Encoding(false);
                //settings.Indent = true;

                using (XmlWriter xWriter = XmlWriter.Create(writer, settings))
                {
                    feed.SaveAsRss20(xWriter);
                    xWriter.Flush();
                    return writer.ToString();
                }
            }
        }

        /// <summary>
        /// Takes a syndication feed and returns an Atom10 string
        /// </summary>
        /// <param name="feed">Syndication Feed</param>
        /// <returns>RSS formated string</returns>
        public static string SerializeToAtom10(SyndicationFeed feed)
        {
            using (StringWriterWithEncoding writer = new StringWriterWithEncoding(Encoding.UTF8))
            {
                XmlWriterSettings settings = new XmlWriterSettings();
                settings.Encoding = new UTF8Encoding(false);
                //settings.Indent = true;

                using (XmlWriter xWriter = XmlWriter.Create(writer, settings))
                {
                    feed.SaveAsAtom10(xWriter);
                    xWriter.Flush();
                    return writer.ToString();
                }
            }
        }


        /// <summary>
        /// To convert a Byte Array of Unicode values (UTF-8 encoded) to a complete String.
        /// </summary>
        /// <param name="characters">Unicode Byte Array to be converted to String</param>
        /// <returns>String converted from Unicode Byte Array</returns>
        public static String UTF8ByteArrayToString(Byte[] characters)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            String constructedString = encoding.GetString(characters);
            return (constructedString);

        }

        /// <summary>
        /// Converts the String to UTF8 Byte array and is used in De serialization
        /// </summary>
        /// <param name="pXmlString"></param>
        /// <returns></returns>
        public static Byte[] StringToUTF8ByteArray(String pXmlString)
        {
            UTF8Encoding encoding = new UTF8Encoding();
            Byte[] byteArray = encoding.GetBytes(pXmlString);
            return byteArray;
        }

        /// <summary>
        /// Creates default and custom namespace object
        /// </summary>
        /// <param name="nameSpace">The custom namespace</param>
        /// <returns>XmlSerializerNamespaces containing namespace</returns>
        private static XmlSerializerNamespaces GetNamespaces(string nameSpace)
        {
            XmlSerializerNamespaces ns;
            ns = new XmlSerializerNamespaces();
            if (!String.IsNullOrEmpty(nameSpace))
            {
                ns.Add("", nameSpace);
            }
            ns.Add("xs", "http://www.w3.org/2001/XMLSchema");
            ns.Add("xsi", "http://www.w3.org/2001/XMLSchema-instance");
            return ns;
        }

    }

    public class StringWriterWithEncoding : StringWriter
    {
        public override Encoding Encoding
        {
            get
            {
                return MyEncoding;
            }
        }

        private Encoding myEncoding;
        public Encoding MyEncoding
        {
            get
            {
                return myEncoding;
            }
            set
            {
                myEncoding = value;
            }
        }

        public StringWriterWithEncoding(Encoding enc)
            : base()
        {
            myEncoding = enc;
        }
    }
}
