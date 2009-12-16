using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.BannedEmails
{
    /// <summary>
    /// Simple cache for banned emails
    /// </summary>
    public class CachedEmailDetails : ICachedEmails
    {
        private Dictionary<string, BannedEmailDetails> _cachedEmailDetails;

        /// <summary>
        /// Default constructor
        /// </summary>
        public CachedEmailDetails()
        {
            _cachedEmailDetails = new Dictionary<string,BannedEmailDetails>();
        }

        /// <summary>
        /// Adds a new banned email to the cache
        /// </summary>
        /// <param name="details">The new email you want to add</param>
        public void AddBannedEmail(BannedEmailDetails details)
        {
            // Check to see if we already have the email in the list
            if (_cachedEmailDetails.Keys.Contains(details.EMail))
            {
                // Already exists, replace it with this one
                _cachedEmailDetails[details.EMail] = details;
            }
            else
            {
                // Just add it to the list
                _cachedEmailDetails.Add(details.EMail, details);
            }
        }

        /// <summary>
        /// Removes a banned email from the cache
        /// </summary>
        /// <param name="email">The email you want to remove</param>
        public void RemoveBannedEMail(string email)
        {
            // Check to see if we already have the email in the list
            if (_cachedEmailDetails.Keys.Contains(email))
            {
                _cachedEmailDetails.Remove(email);
            }
        }

        /// <summary>
        /// Gets the banned email details from the cache for the given email
        /// </summary>
        /// <param name="email">The email for the details to get</param>
        /// <returns>The details for the requested email if they exist, null if it does not</returns>
        public BannedEmailDetails GetCahcedBannedEmailDetails(string email)
        {
            // Check to see if we already have the email in the list
            if (_cachedEmailDetails.Keys.Contains(email))
            {
                // Already exists, replace it with this one
                return _cachedEmailDetails[email];
            }
            return null;
        }

        /// <summary>
        /// Get all the banned email from cache
        /// </summary>
        /// <returns>A list of all the banned email details</returns>
        public List<BannedEmailDetails> GetAllBannedEmails()
        {
            List<BannedEmailDetails> bannedEmails = new List<BannedEmailDetails>();
            Dictionary<string, BannedEmailDetails>.Enumerator email = _cachedEmailDetails.GetEnumerator();
            while (email.MoveNext())
            {
                bannedEmails.Add(email.Current.Value);
            }

            return bannedEmails;
        }
    }
}
