using System;
using System.Collections.Generic;
using System.Text;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// General Profile API Exception Class
    /// </summary>
    public class ProfileAPIException : Exception
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ProfileAPIException() { }

        /// <summary>
        /// Message constructor
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        public ProfileAPIException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public ProfileAPIException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Profile API Connection Details Exception Class
    /// </summary>
    public class ProfileAPIConnectionDetailsException : ProfileAPIException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ProfileAPIConnectionDetailsException() { }

        /// <summary>
        /// Mesaage constructor
        /// </summary>
        /// <param name="message">The description of the Connection Details problem that caused the exception</param>
        public ProfileAPIConnectionDetailsException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the Connection Details problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public ProfileAPIConnectionDetailsException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Profile API DateReader Exception Class
    /// </summary>
    public class ProfileAPIDataReaderException : ProfileAPIException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ProfileAPIDataReaderException() { }

        /// <summary>
        /// Mesaage constructor
        /// </summary>
        /// <param name="message">The description of the DataReader problem that caused the exception</param>
        public ProfileAPIDataReaderException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the DataReader problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public ProfileAPIDataReaderException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Profile API Service Exception Class
    /// </summary>
    public class ProfileAPIServiceException : ProfileAPIException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ProfileAPIServiceException() { }

        /// <summary>
        /// Mesaage constructor
        /// </summary>
        /// <param name="message">The description of the Service problem that caused the exception</param>
        public ProfileAPIServiceException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the Service problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public ProfileAPIServiceException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Profile API Cookie Exception Class
    /// </summary>
    public class ProfileAPICookieException : ProfileAPIException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ProfileAPICookieException() { }

        /// <summary>
        /// Mesaage constructor
        /// </summary>
        /// <param name="message">The description of the Cookie problem that caused the exception</param>
        public ProfileAPICookieException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the Cookie problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public ProfileAPICookieException(string message, Exception inner) : base(message, inner) { }
    }

    /// <summary>
    /// Profile API User Exception Class
    /// </summary>
    public class ProfileAPIUserException : ProfileAPIException
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public ProfileAPIUserException() { }

        /// <summary>
        /// Mesaage constructor
        /// </summary>
        /// <param name="message">The description of the User problem that caused the exception</param>
        public ProfileAPIUserException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the User problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public ProfileAPIUserException(string message, Exception inner) : base(message, inner) { }
    }
}
