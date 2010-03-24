using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Gives more information regarding xslt exceptions eg filename of xslt file which failed to load.
    /// </summary>
    public class XsltException : DnaException
    {
        /// <summary>
        /// Message constructor
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        /// <param name="innerException">Original Exception</param>
        public XsltException(string message, Exception innerException)
            : base(message,innerException)
        { }
    }
}
