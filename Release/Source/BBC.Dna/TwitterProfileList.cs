using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Linq;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.SocialAPI;
using BBC.Dna.Users;
using Microsoft.Practices.EnterpriseLibrary.Caching;


namespace BBC.Dna.Component
{
    /// <summary>
    /// Twitter Profile List - A derived Dnacomponent object
    /// </summary>
    public class TwitterProfileList : DnaInputComponent
    {
        private string _siteType = string.Empty;
        private string _cmd = string.Empty;
        private string _activeOnly = string.Empty;

        IDnaDataReaderCreator readerCreator;
        IDnaDiagnostics dnaDiagnostic;

        /// <summary>
        /// Default constructor for the Twitter Profile List component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public TwitterProfileList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Overloaded constructor that takes in the context, DnaDataReaderCreator and DnaDiagnostics
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dnaReaderCreator"></param>
        /// <param name="dnaDiagnostics"></param>
        public TwitterProfileList(IInputContext context, IDnaDataReaderCreator dnaReaderCreator, IDnaDiagnostics dnaDiagnostics)
            : base(context)
        {
            this.readerCreator = dnaReaderCreator;
            this.dnaDiagnostic = dnaDiagnostics;
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            string action = String.Empty;

            //Clean any existing XML.
            RootElement.RemoveAll();
            
            if (InputContext.ViewingUser == null || ((false == InputContext.ViewingUser.IsEditor) && (false == InputContext.ViewingUser.IsSuperUser)))
            {
                AddErrorXml("UNAUTHORIZED", "Editor permissions required", RootElement);
                return;
            }
            
            GetQueryParameters();

            var profileList = GenerateProfileList();

            if (false == string.IsNullOrEmpty(_activeOnly))
            {
                profileList = ProcessCommand(profileList, _siteType);
            }

            if (profileList == null)
            {
                BaseResult result = new Error { Type = "PROFILELISTFILTERACTION", ErrorMessage = "Profiles selection based on site type invalid." };
            }
            else
            {
                GenerateTwitterProfileListPageXml(profileList);

                GenerateTwitterSiteListXml();
            }
        }

        /// <summary>
        /// Filtered profile list based on the site type
        /// </summary>
        /// <param name="profileList">BuzzTwitterProfiles</param>
        /// <param name="siteType">BuzzSiteType</param>
        /// <returns></returns>
        private BuzzTwitterProfiles ProcessCommand(BuzzTwitterProfiles profileList, string siteType)
        {
            BuzzTwitterProfiles filteredProfileList = new BuzzTwitterProfiles();

            //Get active only profiles

            if (_activeOnly.ToUpper().Equals("ON"))
            {
                foreach (BuzzTwitterProfile profile in profileList)
                {
                    if (true == profile.Active.Value)
                    {
                        filteredProfileList.Add(profile);
                    }
                }
                if (_cmd.ToUpper().Equals("SITESPECIFICPROFILES"))
                {
                    filteredProfileList = GetSiteSpecificProfileList(filteredProfileList, siteType);
                }
            }
            else
            {
                filteredProfileList = profileList;

                if (_cmd.ToUpper().Equals("SITESPECIFICPROFILES"))
                {
                    filteredProfileList = GetSiteSpecificProfileList(filteredProfileList, siteType);
                }
            }
            
            return filteredProfileList;
        }

        /// <summary>
        /// Filter twitter profiles based on the site
        /// </summary>
        /// <param name="profileList"></param>
        /// <param name="siteType"></param>
        /// <returns></returns>
        private BuzzTwitterProfiles GetSiteSpecificProfileList(BuzzTwitterProfiles profileList, string siteType)
        {
            BuzzTwitterProfiles filteredProfileList = new BuzzTwitterProfiles();

            foreach (BuzzTwitterProfile profile in profileList)
            {
                if (profile.SiteURL.Equals(siteType))
                {
                    filteredProfileList.Add(profile);
                }
            }

            return filteredProfileList;
        }

        /// <summary>
        /// Twitter Sites filtered by the SiteType value 5
        /// </summary>
        private void GenerateTwitterSiteListXml()
        {
            Dictionary<int, BBC.Dna.Sites.Site> siteList = new Dictionary<int, BBC.Dna.Sites.Site>();

            foreach (BBC.Dna.Sites.Site site in InputContext.TheSiteList.Ids.Values)
            {
                int twitterSiteType = InputContext.GetSiteOptionValueInt(site.SiteID, "General", "SiteType");
                if (twitterSiteType == 5)
                {
                    if (false == siteList.ContainsKey(site.SiteID))
                    {
                        siteList.Add(site.SiteID, site);
                    }
                }
            }

            XmlNode sitesxml = AddElementTag(RootElement, "TWITTER-SITE-LIST");
            AddAttribute(sitesxml, "COUNT", siteList.Values.Count);
            foreach (BBC.Dna.Sites.Site site in siteList.Values)
            {
                XmlNode sitexml = AddElementTag(sitesxml, "SITE");
                AddAttribute(sitexml, "ID", site.SiteID);
                AddTextTag(sitexml, "NAME", site.SiteName);
                AddTextTag(sitexml, "DESCRIPTION", site.Description);
                AddTextTag(sitexml, "SHORTNAME", site.ShortName);
                AddTextTag(sitexml, "SSOSERVICE", site.SSOService);
                AddTextTag(sitexml, "MODERATIONSTATUS", ((int)site.ModerationStatus).ToString());
            }
            //RootElement.AppendChild(ImportNode(sitesxml.FirstChild));

            ////get sitelist
            //SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            //siteXml.CreateXmlSiteList(InputContext.TheSiteList);
            //RootElement.AppendChild(ImportNode(siteXml.RootElement.FirstChild));

            //SerialiseAndAppend(BBC.Dna.Sites.SiteTypeEnumList.GetSiteTypes(), "");
        }

       
        /// <summary>
        /// Integration with the BuzzApi and retrieves twitter profiles
        /// </summary>
        /// <returns></returns>
        private BuzzTwitterProfiles GenerateProfileList()
        {
            BuzzClient client;
            BuzzTwitterProfiles tweetProfiles = new BuzzTwitterProfiles();
            var response = string.Empty;
            try
            {
                client = new BuzzClient();

                tweetProfiles = client.GetProfiles();
            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);
            }
            return tweetProfiles;
        }


       
        /// <summary>
        /// List of twitter profiles
        /// </summary>
        private void GenerateTwitterProfileListPageXml(BuzzTwitterProfiles twitterProfiles)
        {
            XmlNode profileList = AddElementTag(RootElement, "TWITTERPROFILELIST");
            AddAttribute(profileList, "COUNT", twitterProfiles.Count);

            foreach (BuzzTwitterProfile profile in twitterProfiles)
            {
                XmlNode profileNode = null;

                profileNode = CreateElementNode("TWITTERPROFILE");

                AddAttribute(profileNode, "SITETYPE", profile.SiteURL);

                AddTextTag(profileNode, "PROFILEID", profile.ProfileId);
                AddTextTag(profileNode, "ACTIVESTATUS", profile.Active.HasValue ? profile.Active.Value.ToString() : string.Empty);
                AddTextTag(profileNode, "TRUSTEDUSERSTATUS", profile.TrustedUsersEnabled.HasValue ? profile.TrustedUsersEnabled.Value.ToString() : string.Empty);
                AddTextTag(profileNode, "PROFILECOUNTSTATUS", profile.ProfileCountEnabled.HasValue ? profile.ProfileCountEnabled.Value.ToString() : string.Empty);
                AddTextTag(profileNode, "PROFILEKEYWORDCOUNTSTATUS", profile.ProfileKeywordCountEnabled.HasValue ? profile.ProfileKeywordCountEnabled.Value.ToString(): string.Empty);
                AddTextTag(profileNode, "MODERATIONSTATUS", profile.ModerationEnabled.HasValue ? profile.ModerationEnabled.Value.ToString() : string.Empty);

                profileList.AppendChild(profileNode);
            }
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            if (InputContext.DoesParamExist("sitename", "sitename"))
            {
                _siteType = InputContext.GetParamStringOrEmpty("sitename", "sitename");
            }

            if (InputContext.DoesParamExist("action", "Command string for flow"))
            {
                _cmd = InputContext.GetParamStringOrEmpty("action", "Command string for flow");
            }

            if (InputContext.DoesParamExist("s_activeonly","active only profiles"))
            {
                _activeOnly = InputContext.GetParamStringOrEmpty("s_activeonly","active only profiles");
            }
        }
    }
}
