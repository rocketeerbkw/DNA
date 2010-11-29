using System.ServiceModel.Syndication;
using System.Xml;
using BBC.Dna.Utils;
using System.Runtime.Serialization;
using System;
using System.IO;

namespace BBC.Dna.Api
{
    [Serializable] [DataContractAttribute]
    public class baseContract
    {
        /// <summary>
        /// Serializes object to XML
        /// </summary>
        /// <returns>String of XML</returns>
        public Stream ToXml()
        {
            return StringUtils.SerializeToXml(this);
        }

        /// <summary>
        /// Serializes object to JSON
        /// </summary>
        /// <returns>String of JSON</returns>
        public Stream ToJson()
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
            throw new NotImplementedException("HTML is not supported at this time");
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
