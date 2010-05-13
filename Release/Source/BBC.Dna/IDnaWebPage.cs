using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using BBC.Dna.Page;
using BBC.Dna.Utils;

namespace BBC.Dna
{
	/// <summary>
    /// The dna WebPage Interface. Impliments all calls needed by DNA from the System.Web.UI.Page.
	/// </summary>
	public interface IDnaWebPage
	{
		/// <summary>
		/// The Request object property
		/// </summary>
		IRequest Request { get; }

		/// <summary>
		/// The Response object property
		/// </summary>
		IResponse Response { get; }

		/// <summary>
		/// The Server object property
		/// </summary>
		IServerUtility Server { get; }

        /// <summary>
        /// The Page Type property
        /// </summary>
        string PageType { get; }

        /// <summary>
        /// The OnPageload method
        /// </summary>
        void OnPageLoad();

        /// <summary>
        /// The TimeStamp property
        /// </summary>
        DateTime Timestamp { get; }

        /// <summary>
        /// The Allowed Users property
        /// </summary>
        DnaBasePage.UserTypes AllowedUsers { get; }
        
        /// <summary>
        /// Defaultly includes the topfives in the current page. Override this to stop the inclusion.
        /// </summary>
        bool IncludeTopFives { get; }

        /// <summary>
        /// The IsHtmlCachingEnabled mthod
        /// </summary>
        /// <returns>True if enabled, false if not</returns>
        bool IsHtmlCachingEnabled();

        /// <summary>
        /// The GetHtmlCachingTime method
        /// </summary>
        /// <returns>The length of time that html is to be cached for (In seconds)</returns>
        int GetHtmlCachingTime();

        /// <summary>
        /// The dotnetrender method
        /// </summary>
        /// <param name="writer">The writer in which to render</param>
        void DotNetRender(HtmlTextWriter writer);

        /// <summary>
        /// Used to do any post processing of the request
        /// </summary>
        void OnPostProcessRequest();

        /// <summary>
        /// Used to update any xml data source controls
        /// </summary>
        void UpdateDataSourceControls();

        /// <summary>
        /// Used to add the controls that require the final whlepage xml to be their data source
        /// </summary>
        List<DnaXmlSourceDetails> DnaXmlDataSourceContolIDs { get; }

        /// <summary>
        /// The Must Be Secure property
        /// </summary>
        bool MustBeSecure { get; }
    }
}
