using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.BannedEmails
{
    /// <summary>
    /// The cached banned emails interface
    /// </summary>
    public interface ICachedEmails
    {
        /// <summary>
        /// Adds a new banned email to the cache
        /// </summary>
        /// <param name="details">The new email you want to add</param>
        void AddBannedEmail(BannedEmailDetails details);

        /// <summary>
        /// Removes a banned email from the cache
        /// </summary>
        /// <param name="email">The email you want to remove</param>
        void RemoveBannedEMail(string email);

        /// <summary>
        /// Gets the banned email details from the cache for the given email
        /// </summary>
        /// <param name="email">The email for the details to get</param>
        /// <returns></returns>
        BannedEmailDetails GetCahcedBannedEmailDetails(string email);

        /// <summary>
        /// Get all the banned email from cache
        /// </summary>
        /// <returns>A list of all the banned email details</returns>
        List<BannedEmailDetails> GetAllBannedEmails();
    }
}
