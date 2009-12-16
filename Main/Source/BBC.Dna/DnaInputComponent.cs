using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using BBC.Dna.Component;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// The component type you need to process requests
    /// </summary>
    public abstract class DnaInputComponent : DnaComponent, IDnaInputComponent
    {
        /// <summary>
        /// Interface for querying all aspects of thie current request.
        /// </summary>
        private IInputContext _inputContext;

        /// <summary>
        /// Get the value of the InputContext the interface for querying all aspects of the current request.
        /// </summary>
        public IInputContext InputContext
        {
            get { return _inputContext; }
        }

        /// <summary>
        /// Creates a component that acts on an IInputContext object - i.e. one 
        /// that needs to manipulate the request
        /// </summary>
        /// <remarks>
        /// IMPORTANT! DnaInputContext objects should not live longer that the request, otherwise
        /// a reference to the request object will hang around in the heap after the request has completed,
        /// causing all sorts of untold problems with resources and the like.
        /// 
        /// If your object lives outsite a request (e.g. SiteList), derive from DnaComponent.  Pass in the
        /// InputContext to methods that need a context to operate (e.g. for accessing the db, writing diagnostics, etc)
        /// but make sure the reference isn't kept around in a member variable, hash table, etc.
        /// </remarks>
        /// <see cref="DnaComponent"/>
        /// <param name="context"></param>
        public DnaInputComponent(IInputContext context)
        {
            _inputContext = context;
        }

        /// <summary>
        /// 
        /// </summary>
        public virtual void ProcessRequest()
        {
            // Throw a not implemented exception
            return;
        }

        /// <summary>
        /// This method finds or creates the redirect tag and sets the url to the given dna page
        /// This method will use the current server and site and then append the given redirect
        /// </summary>
        /// <param name="dnaPageUrl">The page you want to redirect to</param>
        /// <returns>The Node that holds the redirect</returns>
        public XmlNode AddDnaRedirect(string dnaPageUrl)
        {
            // Check to see if we already have a redirect
            XmlNode redirectNode = RootElement.SelectSingleNode("REDIRECT");
            XmlAttribute redirectURL = null;
            if (redirectNode == null)
            {
                // Create the element and the attribute
                redirectNode = AddElement(RootElement, "REDIRECT", "");
            }
            else
            {
                // Try to get the URL attribute
                redirectURL = redirectNode.Attributes["URL"];
            }

            // Check to see if we need to add the url attribute
            if (redirectURL == null)
            {
                redirectURL = AddAttribute(redirectNode, "URL", "");
            }

            // Now create the URL
            string dnaPage = dnaPageUrl;

            // check to see if we need to remove anything. i.e. server and site
            if (dnaPage.Contains("/"))
            {
                dnaPage = dnaPage.Substring(dnaPage.LastIndexOf("/"));
            }

            // Set the attribute /H2G2/REDIRECT/@URL
            Uri dnaPageUri = new Uri("http://" + _inputContext.CurrentServerName +"/dna/h2g2/" + dnaPage);
            redirectURL.Value = dnaPageUri.ToString();
            return redirectNode;
        }

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
        public string AddResponseKeyValueDataCookie(string name, XmlNode dataValue, string cookiePath)
        {
            // First of all save the XMl fragment into the KeyValueData database table
            string dataKey = "";
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("savekeyvaluedata"))
            {
                reader.AddParameter("datavalue", dataValue.OuterXml.ToString());
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    dataKey = reader.GetGuidAsStringOrEmpty("DataKey");
                }
            }
            
            // Make sure we got a valid GUID back
            if (dataKey.Length > 0)
            {
                // Add the cookie to the cookies XML
                XmlElement kvdCookies = (XmlElement)RootElement.SelectSingleNode("/H2G2/KVD-COOKIES");
                if (kvdCookies == null)
                {
                    kvdCookies = AddElementTag(RootElement, "KVD-COOKIES");
                }
                XmlNode cookie = AddTextElement(kvdCookies, "COOKIE", dataKey);
                AddAttribute(cookie, "NAME", HttpUtility.UrlEncode(name));
                AddAttribute(cookie, "PATH", HttpUtility.UrlEncode(cookiePath));
            }
            else
            {
                // State we had a problem
                AddErrorXml("KeyValueCookie", "Failed to get valid GUID for data", RootElement);
            }

            return dataKey;
        }

        /// <summary>
        /// Gets the Data value stored against the given key from the KeyValueData table
        /// </summary>
        /// <param name="dataKey">The key for the data</param>
        /// <returns>The value held for the key as a XmlDocument</returns>
        public XmlDocument GetKeyValueData(string dataKey)
        {
            // Try to get the data for the given key
            XmlDocument xmlDataDoc = new XmlDocument();
            string xmlData = "";
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getkeyvaluedata"))
            {
                reader.AddParameter("datakey", dataKey);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    xmlData = reader.GetXmlAsString("DataValue");
                }
            }

            // Now try to create the Xml Document from the data
            try
            {
                xmlDataDoc.LoadXml(xmlData);
            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);
            }

            return xmlDataDoc;
        }
    }
}
