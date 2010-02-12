using System;
using BBC.Dna.Utils;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// Thrown when a site option is not found
    /// </summary>
    public sealed class SiteOptionNotFoundException : DnaException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public SiteOptionNotFoundException()
        {
        }

        /// <summary>
        /// Message constructor
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        public SiteOptionNotFoundException(string message) : base(message)
        {
        }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public SiteOptionNotFoundException(string message, Exception inner) : base(message, inner)
        {
        }

        /// <summary>
        /// Adds the params to the Data section of the error
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="section"></param>
        /// <param name="name"></param>
        public SiteOptionNotFoundException(int siteId, string section, string name)
        {
            Data.Add("SiteID", siteId);
            Data.Add("Section", section);
            Data.Add("Name", name);
        }
    }

    /// <summary>
    /// Thrown whenever the type is invalid for the operation that was attempted
    /// </summary>
    public class SiteOptionInvalidTypeException : DnaException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public SiteOptionInvalidTypeException()
        {
        }

        /// <summary>
        /// Message constructor
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        public SiteOptionInvalidTypeException(string message) : base(message)
        {
        }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public SiteOptionInvalidTypeException(string message, Exception inner) : base(message, inner)
        {
        }
    }
}