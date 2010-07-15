using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Sites
{
	/// <summary>
	/// Interface for the SiteList object
	/// </summary>
	public interface ISiteList
	{

        /// <summary>
        /// Public accessor for site ids
        /// </summary>
        Dictionary<int, Site> Ids { get; }

		/// <summary>
		/// Return an ISite for the specified site
		/// </summary>
		/// <param name="id">Site ID</param>
		/// <param name="context">Context for this request</param>
		/// <returns></returns>
		ISite GetSite(int id);

		/// <summary>
		/// Return an ISite for the specified site
		/// </summary>
		/// <param name="name">site name</param>
		/// <param name="context">context for this request</param>
		/// <returns></returns>
		ISite GetSite(string name);

		/// <summary>
        /// Method to say whether this site is a message board
        /// </summary>
		/// <param name="siteID">ID of site</param>
		bool IsMessageboard(int siteID);
		        /// <summary>
        /// Gets the given bool site option for the current site
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
		bool GetSiteOptionValueBool(int siteId, string section, string name);

        /// <summary>
        /// Returns site options for a given site
        /// </summary>
        /// <param name="siteId">The id of the site to retrieve</param>
        /// <returns></returns>
        List<SiteOption> GetSiteOptionListForSite(int siteId);

        /// <summary>
        /// Gets the given int site option for the current site
        /// <see cref="SiteOptionList.GetValueInt"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        int GetSiteOptionValueInt(int siteId, string section, string name);

        /// <summary>
        /// Gets the given String site option for the current site
        /// <see cref="SiteOptionList.GetValueString"/>
        /// </summary>
        /// <param name="siteId">The site id</param>
        /// <param name="section">Site option section</param>
        /// <param name="name">Site option name</param>
        /// <returns></returns>
        /// <exception cref="SiteOptionNotFoundException"></exception>
        /// <exception cref="SiteOptionInvalidTypeException"></exception>
        string GetSiteOptionValueString(int siteId, string section, string name);

        /// <summary>
        /// The signal key the object is looking for
        /// </summary>
        void ReInitialise();

        /// <summary>
        /// 
        /// </summary>
        void SendSignal();

        /// <summary>
        /// 
        /// </summary>
        void SendSignal(int siteId);
	}
}
