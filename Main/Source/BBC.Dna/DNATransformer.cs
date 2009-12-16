using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Web;
using System.Web.UI;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// The Dna XML Transformer. Used to transform the Dna page into html or xml or any other format
    /// </summary>
    public abstract class DnaTransformer : IDnaTransformer
    {
        // Setup some private variables
		private IOutputContext _outputContext;

        /// <summary>
        /// Gets the output context
        /// </summary>
		protected IOutputContext OutputContext
		{
			get { return _outputContext; }
		}


        /// <summary>
        /// Default constructor for the Transformer object
        /// </summary>
        /// <param name="context">The context for the page that the _transformer will be using</param>
        public DnaTransformer(IOutputContext context)
        {
            _outputContext = context;
        }

        /// <summary>
        /// Property for getting the xsltfile that will be used for doing the transform
        /// </summary>
        public static string XsltFileName
        {
            get { return _xsltFileName; }
           // set { _xsltFileName = value; }
        }
        
        private static string _xsltFileName = "Output.xsl";

        /// <summary>
        /// The abstract Transform method
        /// </summary>
        /// <param name="component">The IDNACompnent you are transforming</param>
        /// <returns>true if ok, false if not</returns>
		public abstract bool TransformXML(IDnaComponent component);

        /// <summary>
        /// Static method that creates and returns a transformer object of the correct type
        /// </summary>
        /// <param name="inputContext">Our Input context</param>
        /// <param name="outputContext">Our Output context</param>
        /// <returns>The new Http transformer</returns>
		public static IDnaTransformer CreateTransformer(IInputContext inputContext, IOutputContext outputContext)
		{
            // Create and Return the transformer
            return new HtmlTransformer(outputContext);
		}

        /// <summary>
        /// Base class implementation always returns null
        /// </summary>
        /// <returns>null</returns>
        public virtual string GetCachedOutput()
        {
            return null;
        }

        /// <summary>
        /// Creates a key based on the request that's unique for this type of transformer
        /// </summary>
        /// <returns>The key</returns>
        protected string CreateTransformerRequestCacheKey()
        {
            return GetType().ToString() + ":" + OutputContext.CreateRequestCacheKey();
        }

		/// <summary>
		/// <see cref="IDnaTransformer"/>
		/// </summary>
		/// <returns></returns>
		public virtual bool IsCachedOutputAvailable()
		{
			return false;
		}

		/// <summary>
		/// Default implementation of WriteCachedOutput - will simply write the cached output if it's available
		/// </summary>
		public virtual void WriteCachedOutput()
		{
			string key = CreateTransformerRequestCacheKey();
			string output = OutputContext.GetCachedObject(key) as string;
			if (output != null)
			{
				OutputContext.Writer.Write(output);
			}
		}
    }
}
