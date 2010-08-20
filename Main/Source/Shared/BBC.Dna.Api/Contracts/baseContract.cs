using System.ServiceModel.Syndication;
using System.Xml;
using BBC.Dna.Utils;
using System.Runtime.Serialization;
using System;

namespace BBC.Dna.Api
{
    [Serializable] [DataContractAttribute]
    public class baseContract
    {
        /// <summary>
        /// Serializes object to XML
        /// </summary>
        /// <returns>String of XML</returns>
        public string ToXml()
        {
            return StringUtils.SerializeToXml(this);
        }

        /// <summary>
        /// Serializes object to JSON
        /// </summary>
        /// <returns>String of JSON</returns>
        public string ToJson()
        {
            return StringUtils.SerializeToJson(this);
        }

        /// <summary>
        /// Returns HTML transformed string
        /// </summary>
        /// <param name="xsltFile">The xslt skin</param>
        /// <param name="error">The number of errors returned</param>
        /// <returns>The HTML output</returns>
        public string ToHtml(string xsltFile, ref int error)
        {
            string rawXml = StringUtils.SerializeToXml(this);
            rawXml = rawXml.Replace("&lt;", "<");
            rawXml = rawXml.Replace("&gt;", ">");
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(rawXml);
            
            return XSLTransformer.TransformUsingXslt2(xsltFile, xmlDoc, ref error);
        }

        /// <summary>
        /// Converts obecjt to syndication feed
        /// </summary>
        /// <returns>SyndicationFeed  or null</returns>
        public virtual SyndicationFeed ToFeed()
        {
            return null;
        }

    }
}
