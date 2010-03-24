using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class handling the building of the ArticleKeyPhrases
    /// </summary>
    public class ArticleKeyPhrases : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the ArticleKeyPhrases component
        /// </summary>
        /// <param name="context">The inputcontext that the component is running in</param>
        public ArticleKeyPhrases(IInputContext context)
            : base(context)
        {
        }
    }
}