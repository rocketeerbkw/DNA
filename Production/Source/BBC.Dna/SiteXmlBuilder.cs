using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// Creates DNA style XML for site objects
    /// </summary>
    public class SiteXmlBuilder : DnaInputComponent
    {

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context">The current context</param>
        public SiteXmlBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Creates Site XML for site list
        /// </summary>
        /// <param name="sites">The site list</param>
        public void CreateXmlSiteList(ISiteList sites)
        {
            XmlNode sitesxml = AddElementTag(RootElement, "SITE-LIST");
            foreach (BBC.Dna.Sites.Site site in sites.Ids.Values)
            {
                XmlNode sitexml = AddElementTag(sitesxml, "SITE");
                AddAttribute(sitexml, "ID", site.SiteID);
                AddTextTag(sitexml, "NAME", site.SiteName);
                AddTextTag(sitexml, "DESCRIPTION", site.Description);
                AddTextTag(sitexml, "SHORTNAME", site.ShortName);
                AddTextTag(sitexml, "SSOSERVICE", site.SSOService);
            }
        }
        /// <summary>
        /// Public method to generate the Sites XML representation
        /// </summary>
        /// <param name="siteOptionListXml">an XMLNode representing its site options. Can be null</param>
        /// <param name="site">The site</param>
        /// <returns>The node representing the site data</returns>
        public XmlNode GenerateXml(XmlNode siteOptionListXml, ISite site)
        {
            RootElement.RemoveAll();

            return GenerateXml(siteOptionListXml, site, RootElement);
        }


        /// <summary>
        /// Public method to generate the Sites XML representation
        /// </summary>
        /// <param name="siteOptionListXml">an XMLNode representing its site options. Can be null</param>
        /// <param name="site">The site</param>
        /// <param name="element"> The element to add the xml to</param>
        /// <returns>The node representing the site data</returns>
        public XmlNode GenerateXml(XmlNode siteOptionListXml, ISite site, XmlElement element)
        {
            //RootElement.RemoveAll();

            XmlNode siteXML;
            siteXML = AddElementTag(element, "SITE");
            AddAttribute(siteXML, "ID", site.SiteID.ToString());
            AddTextTag(siteXML, "NAME", site.SiteName);
            AddTextTag(siteXML, "URLNAME", site.SiteName);
            AddTextTag(siteXML, "SHORTNAME", site.ShortName);
            AddTextTag(siteXML, "DESCRIPTION", site.Description);
            AddTextTag(siteXML, "SSOSERVICE", site.SSOService);
            AddTextTag(siteXML, "IDENTITYSIGNIN", site.UseIdentitySignInSystem ? "1" : "0");
            AddTextTag(siteXML, "IDENTITYPOLICY", site.IdentityPolicy);
            AddTextTag(siteXML, "MINAGE", site.MinAge);
            AddTextTag(siteXML, "MAXAGE", site.MaxAge);
            AddTextTag(siteXML, "MODERATIONSTATUS", ((int)site.ModerationStatus).ToString());
            AddIntElement(siteXML, "CLASSID", site.ModClassID);

            // Now add the open closing times to the xml
            Dictionary<string, XmlNode> dailySchedules = new Dictionary<string, XmlNode>();
            XmlNode openCloseTimes = AddElementTag(siteXML, "OPENCLOSETIMES");
            foreach (OpenCloseTime openCloseTime in site.OpenCloseTimes)
            {
                // Check to see if we hve already got a node for this day of the week
                XmlNode dayOfWeek = null;
                if (dailySchedules.ContainsKey(openCloseTime.DayOfWeek.ToString()))
                {
                    // Just get the node
                    dayOfWeek = dailySchedules[openCloseTime.DayOfWeek.ToString()];
                }
                else
                {
                    // We need to create it, and then add it to the list
                    dayOfWeek = AddElementTag(openCloseTimes, "OPENCLOSETIME");
                    AddAttribute(dayOfWeek, "DAYOFWEEK", openCloseTime.DayOfWeek.ToString());
                    dailySchedules.Add(openCloseTime.DayOfWeek.ToString(), dayOfWeek);
                }

                // Now check to see if it's an open or closing time
                XmlNode newTime = null;
                if (openCloseTime.Closed == 0)
                {
                    // Create an open time
                    newTime = AddElementTag(dayOfWeek, "OPENTIME");
                }
                else
                {
                    // Create a closing time
                    newTime = AddElementTag(dayOfWeek, "CLOSETIME");
                }

                // Now add the times to the new time
                AddTextTag(newTime, "HOUR", openCloseTime.Hour.ToString());
                AddTextTag(newTime, "MINUTE", openCloseTime.Minute.ToString());
            }

            XmlNode siteXMLClosed = AddElementTag(siteXML, "SITECLOSED");
            if (site.IsEmergencyClosed)
            {
                AddAttribute(siteXMLClosed, "EMERGENCYCLOSED", "1");
            }
            else
            {
                AddAttribute(siteXMLClosed, "EMERGENCYCLOSED", "0");
            }
            bool IsScheduledClosedNow = site.IsSiteScheduledClosed(DateTime.Now);
            if (IsScheduledClosedNow)
            {
                AddAttribute(siteXMLClosed, "SCHEDULEDCLOSED", "1");
            }
            else
            {
                AddAttribute(siteXMLClosed, "SCHEDULEDCLOSED", "0");
            }
            if (site.IsEmergencyClosed || IsScheduledClosedNow)
            {
                siteXMLClosed.InnerText = "1";
            }
            else
            {
                siteXMLClosed.InnerText = "0";
            }

            if (siteOptionListXml != null)
            {
                siteXML.AppendChild(ImportNode(siteOptionListXml));
            }

            return siteXML;
        }

        /// <summary>
        /// Create an Xml representation of the whole site list
        /// <param name="sites">The site list</param>
        /// </summary>
        /// <returns>XmlNode pointing to the root of the document</returns>
        public XmlNode GenerateAllSitesXml(ISiteList sites)
        {
            /*
             * <SITE-LIST>
                    <SITE ID="17">
                <NAME>1xtra</NAME>
                <DESCRIPTION>1xtra messageboard</DESCRIPTION>
                <SHORTNAME>1xtra</SHORTNAME>
                </SITE>
                    <SITE ID="3">
                <NAME>360</NAME>
                <DESCRIPTION>360</DESCRIPTION>
                <SHORTNAME>360</SHORTNAME>
                </SITE>
             * </SITE-LIST>
             */

            if (IsEmpty)
            {
                XmlElement root = AddElementTag(RootElement, "SITE-LIST");
                foreach (var id in sites.Ids.Values)
                {
                    GenerateXml(null, id, root);
                }
            }
            return RootElement;
        }

        /// <summary>
        /// Returns all the site options in XML format
        /// </summary>
        /// <param name="site">The site to read options from</param>
        /// <param name="preview">Use preview config or not</param>
        /// <returns>The XMl list of options</returns>
        public static XmlNode GenerateSiteOptions(ISite site, bool preview)
        {
            XmlDocument _siteConfigDoc = new XmlDocument();
            if (!preview)
            {
               
                if (site.Config.Length > 0)
                {
                    //HACK: Needs to be done properly.
                    site.Config = site.Config.Replace("&nbsp;", "&#160;");
                    site.Config = site.Config.Replace("&raquo;", "&#187;");
                    _siteConfigDoc.LoadXml(Entities.GetEntities() + site.Config);
                }
                else
                {
                    _siteConfigDoc.LoadXml("<SITECONFIG/>");
                }
            }
            else
            {
                var config = SiteConfig.GetPreviewSiteConfig(site.SiteID, AppContext.ReaderCreator);
                var xmlSiteConfig = StringUtils.SerializeToXmlUsingXmlSerialiser(config);
                _siteConfigDoc.LoadXml(Entities.ReplaceEntitiesWithNumericValues(xmlSiteConfig));
            }

            return _siteConfigDoc.SelectSingleNode("/SITECONFIG");
        }


        /// <summary>
        /// Generate a list of site options for all sites.
        /// Does not include Global Site Options for each site to avoid duplication of XML.
        /// </summary>
        /// <param name="sites"></param>
        /// <returns></returns>
        public XmlNode GetSiteOptionListXml(ISiteList sites)
        {
            if (RootElement.HasChildNodes)
            {
                RootElement.RemoveAll();
            }

            XmlNode siteOptionsListXml = AddElementTag(RootElement, "SITEOPTIONSLIST");

            foreach ( KeyValuePair<int, BBC.Dna.Sites.Site> site in sites.Ids)
            {
                XmlNode siteOptionsXml = AddElementTag(siteOptionsListXml, "SITEOPTIONS");
                AddAttribute(siteOptionsXml, "SITEID", site.Key);
                
                List<SiteOption> list = sites.GetSiteOptionListForSite(site.Key);
                foreach (SiteOption so in list)
                {
                    if (!so.IsGlobal)
                    {
                        XmlNode siteOptionXml = AddElementTag(siteOptionsXml, "SITEOPTION");
                        AddAttribute(siteOptionXml, "GLOBAL", Convert.ToInt32(so.IsGlobal));
                        AddTextTag(siteOptionXml, "SECTION", so.Section);
                        AddTextTag(siteOptionXml, "NAME", so.Name);
                        AddTextTag(siteOptionXml, "VALUE", so.GetRawValue());
                        AddTextTag(siteOptionXml, "TYPE", ((int)so.OptionType).ToString());
                        AddTextTag(siteOptionXml, "DESCRIPTION", so.Description);
                    }
                }
            }
            return siteOptionsListXml;
        }

        /// <summary>
        /// Returns a list of SiteOptions for the given site.
        /// If a site option is not defined for the given site, a SiteOption with site id of 0 is
        /// given in it's place
        /// </summary>
        /// <param name="siteId">A site id</param>
        /// <param name="sites">The site list</param>
        /// <returns>List of site options for the given site</returns>
        public XmlNode GetSiteOptionListForSiteXml(int siteId, ISiteList sites)
        {
            List<SiteOption> list = sites.GetSiteOptionListForSite(siteId);

            if (RootElement.HasChildNodes)
            {
                RootElement.RemoveAll();
            }

            XmlNode siteOptionsNode = AddElementTag(RootElement, "SITEOPTIONS");

            foreach (SiteOption so in list)
            {
                int global = 0;
                if (so.IsGlobal)
                {
                    global = 1;
                }

                XmlNode siteOptionXml = AddElementTag(siteOptionsNode, "SITEOPTION");
                AddAttribute(siteOptionXml, "GLOBAL", global);
                AddTextTag(siteOptionXml, "SECTION", so.Section);
                AddTextTag(siteOptionXml, "NAME", so.Name);
                AddTextTag(siteOptionXml, "VALUE", so.GetRawValue());
                AddTextTag(siteOptionXml, "TYPE", ((int)so.OptionType).ToString());
                AddTextTag(siteOptionXml, "DESCRIPTION", so.Description);
            }

            return siteOptionsNode;
        }
    }
}
