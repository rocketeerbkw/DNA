using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace BBC.Dna
{
	/// <summary>
	/// A transformer which simply passes through the XML page unchanged
	/// </summary>
	public class PureXmlTransformer : DnaTransformer
	{
		/// <summary>
		/// Constructor
		/// </summary>
		/// <param name="outputContext"></param>
		public PureXmlTransformer(IOutputContext outputContext)
			: base(outputContext)
		{
		}

		/// <summary>
		/// <see cref="DnaTransformer"/>
		/// </summary>
		public override bool TransformXML(IDnaComponent component)
		{
#if DEBUG
            // purexml shouldn't redirect
			XPathDocument xdoc = new XPathDocument(new XmlNodeReader(component.RootElement.FirstChild));
			XPathNavigator xnav = xdoc.CreateNavigator();
			XPathNavigator redirect = xnav.SelectSingleNode("/H2G2/REDIRECT/@URL");
			if (null != redirect)
			{
				OutputContext.Redirect(redirect.InnerXml);
				return true;
			}
#endif
            OutputContext.SetContentType("text/xml");
			// Make the PageComponent Render itself into the page
			//_page.RenderPage(writer);
            OutputContext.Writer.Write("<?xml version=\"1.0\"?>\r\n" + Entities.GetEntities() + "\r\n");
			OutputContext.Writer.Write(component.RootElement.InnerXml);

			OutputContext.Diagnostics.WriteTimedEventToLog("PureXmlTransform", "Applied PureXml transform");
			return true;
		}

	}
}
