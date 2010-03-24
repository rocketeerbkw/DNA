using System;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Basic Exception class.
    /// </summary>
    /// <remarks>
    /// 
    /// </remarks>
    public class DnaException : Exception
    {
        /// <summary>
        /// 
        /// </summary>
        public DnaException()
            : base()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public DnaException( string message )
            : base(message)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public DnaException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }
}
