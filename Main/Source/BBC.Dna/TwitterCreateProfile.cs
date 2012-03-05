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
    /// Twitter Create Profile - A derived Dnacomponent object
    /// </summary>
    public class TwitterCreateProfile : DnaInputComponent
    {
        private int _siteId = 0;
        private int _userId = 0;

        IDnaDataReaderCreator readerCreator;
        IDnaDiagnostics dnaDiagnostic;

        /// <summary>
        /// Default constructor for the Twitter Create Profile component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public TwitterCreateProfile(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Overloaded constructor that takes in the context, DnaDataReaderCreator and DnaDiagnostics
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dnaReaderCreator"></param>
        /// <param name="dnaDiagnostics"></param>
        public TwitterCreateProfile(IInputContext context, IDnaDataReaderCreator dnaReaderCreator, IDnaDiagnostics dnaDiagnostics)
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
            //GetQueryParameters();

            //if (_userId == 0)
            //{
            //    return;
            //}

            var siteName = "Test Site";
            //if (_siteId != 0)
            //{
                //siteName = InputContext.TheSiteList.GetSite(_siteId).SiteName;
            //}

            bool checkAllSites = InputContext.ViewingUser.IsSuperUser;

            GenerateTwitterCreateProfilePageXml(siteName);
        }

        /// <summary>
        /// XML for Twitter create profile 
        /// </summary>
        public void GenerateTwitterCreateProfilePageXml(string siteName)
        {
            XmlNode profileList = AddElementTag(RootElement, "TWITTERCREATEPROFILE");
            AddAttribute(profileList, "SITENAME", siteName);
        }


        private void GetQueryParameters()
        {
            _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");

            _userId = InputContext.ViewingUser.UserID;
        }
    }
}
