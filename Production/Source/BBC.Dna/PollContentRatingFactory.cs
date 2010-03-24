using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;

namespace BBC.Dna
{
    /// <summary>
    /// ContentRating poll factory
    /// </summary>
    public class ContentRatingPollFactory : IPollFactory
    {
        /// <summary>
        /// Creates new poll
        /// </summary>
        /// <returns>A poll</returns>
        public Poll CreatePoll(IAppContext context, IUser viewingUser)
        {
            return new PollContentRating(context, viewingUser); 
        }
    }
}
