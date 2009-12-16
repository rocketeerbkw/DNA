using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.IO;

namespace BBC.Dna
{
	/// <summary>
	/// A transformer which can output XML results. Suitable for RSS feeds
	/// </summary>
	public class XmlTransformer : DnaTransformer
	{
        /// <summary>
        /// Constructor for the XML transformer.
        /// </summary>
        /// <param name="outputContext">Output context of the request.</param>
        public XmlTransformer(IOutputContext outputContext) : base(outputContext)
        {
			//XsltFileName = "Output.xsl";
        }

/// <summary>
		/// Transforms the page into an XML format. Uses XSLT but will output using a correct mimetype
		/// </summary>
		/// <param name="component">Component (probably a WholePage) to transform</param>
		/// <returns>true if succeeded, false otherwise</returns>
		public override bool TransformXML(IDnaComponent component)
		{
			// Create the XML navigator for the given component XMLDoc. Check to see if we've been given a redirect
			XPathDocument xdoc = new XPathDocument(new XmlNodeReader(component.RootElement.FirstChild));
			XPathNavigator xnav = xdoc.CreateNavigator();
			XPathNavigator redirect = xnav.SelectSingleNode("/H2G2/REDIRECT/@URL");
			if (null != redirect)
			{
				// We've been given a redirect, so execute it and return
				OutputContext.Redirect(redirect.InnerXml);
				return true;
			}

			// Try to get a cached transform for this xslt file
			string xslFile = OutputContext.GetSkinPath(XsltFileName);
#if DEBUG
			// Check to see if we've been given a debug skin override
			if (OutputContext.DebugSkinFile.Length > 0)
			{
				// Override the skin with the one specified in the debug url param
				xslFile = OutputContext.DebugSkinFile;
			}
#endif
			XslCompiledTransform Transformer = OutputContext.GetCachedXslTransform(xslFile);

			// Now transform the document into the output context

			OutputContext.Diagnostics.WriteTimedEventToLog("XMLTransform", "Applying " + xslFile);

            int xmlCachingTime = 60*5;	// Cache for five minutes 
            if (xmlCachingTime > 0)		// Leave this test in case we add a condition to disable XML caching
            {
                // We need to cache the output before sending it to OutputContext.Writer so write to a StringWriter 
                StringWriter sw = new StringWriter();
                Transformer.Transform(xnav, null, sw);

                //  Write to OutputContext.Writer
                string output = sw.ToString();
//#if DEBUG
//                output = "Caching HTML output on " + DateTime.Now.ToString() + " for " + htmlCachingTime.ToString() + " seconds" + output;
//#endif
				OutputContext.SetContentType("text/xml");
				OutputContext.Writer.Write(output);

                // Now cache the output
                string key = CreateTransformerRequestCacheKey();
                OutputContext.CacheObject(key, output, xmlCachingTime);


                OutputContext.Diagnostics.WriteTimedEventToLog("XMLTransformCached", "Applied and cached output");
            }
            else
            {
				// No output caching, so write directly to OutputContext.Writer
			OutputContext.SetContentType("text/xml");	
			Transformer.Transform(xnav, null, OutputContext.Writer);

				OutputContext.Diagnostics.WriteTimedEventToLog("XMLTransform", "Applied");
			}

			// Make a note on how long it took
			return true;
		}

		/// <summary>
		/// Get the cached copy of this XML request
		/// </summary>
		/// <returns>string containing the cached output if it exists in the cache. null otherwise.</returns>
		public override string GetCachedOutput()
		{
			// Unlike the HTML transformer, the XML transformer will *always* cache results
			string key = CreateTransformerRequestCacheKey();
			return OutputContext.GetCachedObject(key) as string;
		}

		/// <summary>
		/// <see cref="IDnaTransformer"/>
		/// </summary>
		/// <returns></returns>
		public override bool IsCachedOutputAvailable()
		{
			string key = CreateTransformerRequestCacheKey();
			return (null != OutputContext.GetCachedObject(key));
		}

		/// <summary>
		/// <see cref="IDnaTransformer"/>
		/// </summary>
		public override void WriteCachedOutput()
		{
			OutputContext.SetContentType("text/xml");
			string key = CreateTransformerRequestCacheKey();
			string output = OutputContext.GetCachedObject(key) as string;
			OutputContext.Writer.Write(output);
		}

	}
}
