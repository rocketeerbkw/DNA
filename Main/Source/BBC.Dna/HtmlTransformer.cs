using System;
using System.IO;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace BBC.Dna
{
    /// <summary>
    /// Concrete DnaTransformer class implementing HTML transformation.
    /// </summary>
    public class HtmlTransformer : DnaTransformer
    {
        /// <summary>
        /// Constructor for the HTML transformer.
        /// </summary>
        /// <param name="outputContext">Output context of the request.</param>
        public HtmlTransformer(IOutputContext outputContext)
            : base(outputContext)
        {
        }

        /// <summary>
        /// If there exists some cached html output for this request, it is returned.
        /// If not, null is returns
        /// </summary>
        /// <returns>cached output, or null if there isn't any</returns>
        public override string GetCachedOutput()
        {
            if (OutputContext.IsHtmlCachingEnabled())
            {
                string key = CreateTransformerRequestCacheKey();
                return OutputContext.GetCachedObject(key) as string;
            }

            return null;
        }

        /// <summary>
        /// <see cref="IDnaTransformer"/>
        /// </summary>
        /// <returns></returns>
        public override bool IsCachedOutputAvailable()
        {
            if (OutputContext.IsHtmlCachingEnabled())
            {
                string key = CreateTransformerRequestCacheKey();
                return (null != OutputContext.GetCachedObject(key));
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// The main transformation function. This takes a component and then transforms the XML Doc with the required xslt file.
        /// This function will also check to see if a redirect has been inserted into the tree, and if so execute the redirect without the
        /// transformation.
        /// </summary>
        /// <remarks>Note that only the first redirect will be executed, so first come first served!!!</remarks>
        /// <param name="component">The IDNACompnent you are transforming</param>
        /// <returns>true if ok, false if not</returns>
        public override bool TransformXML(IDnaComponent component)
        {
            // Create the XML navigator for the given component XMLDoc. Check to see if we've been given a redirect
            XPathDocument xdoc = new XPathDocument(new XmlNodeReader(component.RootElement.FirstChild));
            XPathNavigator xnav = xdoc.CreateNavigator();
            XPathNavigator redirect = xnav.SelectSingleNode("/H2G2/REDIRECT/@URL");
            if (null != redirect)
            {
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

            OutputContext.Diagnostics.WriteTimedEventToLog("HTMLTransform", "Applying " + xslFile);

            int htmlCachingTime = OutputContext.GetHtmlCachingTime();
            if (htmlCachingTime > 0 && OutputContext.IsHtmlCachingEnabled())
            {
                // We need to cache the output before sending it to OutputContext.Writer so write to a StringWriter 
                StringWriter sw = new StringWriter();
                Transformer.Transform(xnav, null, sw);

                //  Write to OutputContext.Writer
                string output = sw.ToString();
                /*  Uncomment if you ever need this for debugging purposes
                #if DEBUG
                output = "<!--Caching HTML output on " + DateTime.Now.ToString() + " for " + htmlCachingTime.ToString() + " seconds-->" + output;
                #endif
                 */
                OutputContext.Writer.Write(output);

                // Now cache the output
                string key = CreateTransformerRequestCacheKey();
                OutputContext.CacheObject(key, output, htmlCachingTime);


                OutputContext.Diagnostics.WriteTimedEventToLog("HTMLTransformCached", "Applied and cached output");
            }
            else
            {
                try
                {
                    // No output caching, so write directly to OutputContext.Writer
                    Transformer.Transform(xnav, null, OutputContext.Writer);
                }
                catch (Exception ex)
                {
                    OutputContext.Diagnostics.WriteTimedEventToLog("Transform", ex.Message);
                    throw;
                }

                OutputContext.Diagnostics.WriteTimedEventToLog("HTMLTransform", "Applied");
            }

            // Make a note on how long it took
            return true;
        }
    }
}
