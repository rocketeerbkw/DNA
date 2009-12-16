using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    public class UserNotSignedInException : Exception
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public UserNotSignedInException() { }

        /// <summary>
        /// Message constructor
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        public UserNotSignedInException(string message) : base(message) { }

        /// <summary>
        /// Message constructor with inner exception
        /// </summary>
        /// <param name="message">The description of the problem that caused the exception</param>
        /// <param name="inner">The inner exception</param>
        public UserNotSignedInException(string message, Exception inner) : base(message, inner) { }
    }
}
