using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Base page component. Used to create the page for any new Dna page
    /// </summary>
    public class WholePage : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">A refernce to the current DnaHttpContext.</param>
        public WholePage(IInputContext context) : base(context)
        {
        }

        /// <summary>
        /// Does the basic initialisation for the page. Creates the XML Document and adds the H2G2 root node with the current
        /// page type attribute. Also creates the Site xml
        /// </summary>
		/// <param name="pageType">The type of page that this component will represent. Used to set the TYPE attribute in the H2G2 Tag</param>
		/// <returns>True if ok, false if not</returns>
		public void InitialisePage(string pageType)
		{
			//InputContext.Diagnostics.WriteTimedEventToLog("WholePage", "Starting initialise whole page");
			// Initialise the root for the document
			XmlNode H2G2 = AddElementTag(RootElement, "H2G2");
			AddAttribute(H2G2, "TYPE", pageType);

			XmlNode viewingUser = AddElementTag(H2G2, "VIEWING-USER");
			AddInside(InputContext.ViewingUser, "VIEWING-USER");

			// Set up Server Name
			AddTextTag(H2G2, "SERVERNAME", Environment.MachineName);
			AddTextTag(H2G2, "USERAGENT", InputContext.UserAgent);

			if (InputContext.DoesParamExist("_sk", "Skin name passed in via the URL"))
			{
				AddTextTag(H2G2, "URLSKINNAME", InputContext.GetParamStringOrEmpty("_sk", "Skin name passed in via the URL"));
			}

			// Put the current date and time on the page
			H2G2.AppendChild(ImportNode(DnaDateTime.GetDateTimeAsNode(DateTime.Now)));
			//InputContext.Diagnostics.WriteTimedEventToLog("WholePage", "Finished initialise whole page");
			if (InputContext.CurrentSite != null)
			{
                H2G2.AppendChild(ImportNode(SiteXmlBuilder.GenerateSiteOptions(InputContext.CurrentSite, InputContext.IsPreviewMode())));
			}
		}

		/// <summary>
		/// Adds a TIMEFORPAGE element with the specified number of milliseconds
		/// </summary>
		/// <param name="milliseconds">Number of milliseconds the request has taken</param>
		public void AddTimeForPage(int milliseconds)
		{
			AddElement("H2G2", "TIMEFORPAGE", milliseconds.ToString());
		}

		private List<IDnaComponent> _componentList = new List<IDnaComponent>();

        /// <summary>
        /// Add a component to the whole page.
        /// </summary>
        /// <param name="component"></param>
		public void AddComponent(IDnaComponent component)
		{
			_componentList.Add(component);
		}

        /// <summary>
        /// Process the request for the whole page.
        /// </summary>
		public override void ProcessRequest()
		{
			foreach (IDnaInputComponent component in _componentList)
			{
				//InputContext.Diagnostics.WriteTimedEventToLog("Process", "Starting processing of " + component.GetType().Name);
				component.ProcessRequest();
				AddInside(component, "H2G2");
				//InputContext.Diagnostics.WriteTimedEventToLog("Process", "Finished processing of " + component.GetType().Name);
			}
		}

    }
}
