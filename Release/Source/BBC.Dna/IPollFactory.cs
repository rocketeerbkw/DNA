using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// Interface representing a PollFactory. Implement this to create polls.
    /// </summary>
    public interface IPollFactory
    {
        /// <summary>
        /// Creates poll entry in the database
        /// </summary>
        /// <returns>A poll</returns>
        Poll CreatePoll(IAppContext context, IUser viewingUser); 
    }
}
