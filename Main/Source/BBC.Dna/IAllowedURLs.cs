using System;
namespace BBC.Dna
{
    /// <summary>
    /// Interface for the allowed URLs (white list)
    /// </summary>
    public interface IAllowedURLs
    {
        /// <summary>
        /// Checks if the allowed url lists contains the string to check
        /// </summary>
        /// <param name="siteID">The site in question</param>
        /// <param name="stringToCheck">The string to check</param>
        /// <returns>true if it finds it</returns>
        bool DoesAllowedURLListContain(int siteID, string stringToCheck);

        /// <summary>
        /// Gets the Allowed URL list for a given site
        /// </summary>
        /// <param name="siteID">The site in question</param>
        /// <returns>The list of Allowed URLS for a Site</returns>
        System.Collections.Generic.List<string> GetAllowedURLList(int siteID);

        /// <summary>
        /// Called to Load all the Sites lists of allowed URLs
        /// </summary>
        /// <param name="context"></param>
        void LoadAllowedURLLists(IAppContext context);
    }
}
