using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
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

            var profileList = CreateProfileList();

            bool checkAllSites = InputContext.ViewingUser.IsSuperUser;

            GenerateTwitterProfileListPageXml(profileList);

            RootElement.AppendChild(ImportNode(InputContext.ViewingUser.GetSitesThisUserIsEditorOfXML()));
        }

        private BuzzTwitterProfiles CreateProfileList()
        {
            BuzzTwitterProfiles profiles = new BuzzTwitterProfiles();

            BuzzTwitterProfile profile = new BuzzTwitterProfile();
            profile = CreateProfile("testsite", "grouptest1_group_4", false, false, true, true);
            profiles.Add(profile);

            profile = CreateProfile("testsite", "bbcdemotabs1", false, false, true, true);
            profiles.Add(profile);

            profile = CreateProfile("testsite", "bbcdemo1", false, false, false, false);
            profiles.Add(profile);

            return profiles;
        }

        private BuzzTwitterProfile CreateProfile(string siteType, string profileId, bool isProfileCountEnabled, bool isProfileKeywordCountEnabled,
            bool isModerationEnabled, bool isTrustedUserEnabled)
        {
            string[] userList = new string[2]{"1234","5678"};
            string[] keywordList = new string[2] { "mn", "was" };

            return new BuzzTwitterProfile()
            {
                SiteURL = siteType,
                Users = userList,
                ProfileId = profileId,
                SearchKeywords = keywordList,
                ProfileCountEnabled = isProfileCountEnabled,
                ProfileKeywordCountEnabled = isProfileKeywordCountEnabled,
                ModerationEnabled = isModerationEnabled,
                TrustedUsersEnabled = isTrustedUserEnabled
            };
        }

        /// <summary>
        /// Method called to try and create Member List, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has succeeded with out error</returns>
        private bool TryCreateTwitterProfileList()
        {
            bool checkAllSites = InputContext.ViewingUser.IsSuperUser;
            //int userSearchType = InputContext.GetParamIntOrZero("usersearchtype", _docDnaUserSearchType);
            string searchText = InputContext.GetParamStringOrEmpty("searchText", "User search text");

            if (String.IsNullOrEmpty(searchText))
            {
                return false;
            }


            //GenerateTwitterProfileListPageXml();

            return true;
        }

        /// <summary>
        /// List of profiles for a partiular site
        /// </summary>
        public void GenerateTwitterProfileListPageXml(BuzzTwitterProfiles twitterProfiles)
        {
            XmlNode profileList = AddElementTag(RootElement, "TWITTERPROFILELIST");
            AddAttribute(profileList, "COUNT", twitterProfiles.Count);

            foreach (BuzzTwitterProfile profile in twitterProfiles)
            {
                XmlNode profileNode = null;

                profileNode = CreateElementNode("TWITTERPROFILE");

                AddAttribute(profileNode, "SITETYPE", profile.SiteURL);

                AddTextTag(profileNode, "PROFILEID", profile.ProfileId);
                AddTextTag(profileNode, "ACTIVESTATUS", profile.Active.ToString());
                AddTextTag(profileNode, "TRUSTEDUSERSTATUS", profile.TrustedUsersEnabled.ToString());
                AddTextTag(profileNode, "PROFILECOUNTSTATUS", profile.ProfileCountEnabled.ToString());
                AddTextTag(profileNode, "PROFILEKEYWORDCOUNTSTATUS", profile.ProfileKeywordCountEnabled.ToString());
                AddTextTag(profileNode, "MODERATIONSTATUS", profile.ModerationEnabled.ToString());

                profileList.AppendChild(profileNode);
            }
        }
    }
}
