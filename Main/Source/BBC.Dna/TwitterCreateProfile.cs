using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Linq;
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
        private string _siteName = string.Empty;
        private string _profileId = string.Empty;
        private string _title = string.Empty;
        private string _users = string.Empty;
        private string _searchterms = string.Empty;
        private string _cmd = string.Empty;
        private bool _isActive = false;
        private bool _isTrustedUsersEnabled = false;
        private bool _isCountsEnabled = false;
        private bool _keywordCountsEnabled = false;
        private bool _isModerationEnabled = false;

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


            if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsSuperUser)
            {
                AddErrorXml("INVALID PERMISSIONS", "Superuser permissions required", RootElement);
                return;
            }

            GetQueryParameters();

            var siteName = "Test Site";
            GenerateTwitterCreateProfilePageXml(siteName);

            BaseResult result = ProcessCommand(siteName);
            if (result != null)
            {
                SerialiseAndAppend(result, "");
            }
        }

        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private BaseResult ProcessCommand(string siteName)
        {
            switch (_cmd.ToUpper())
            {
                case "CREATEPROFILE":
                    return CreateProfileOnBuzz(siteName);

                default:

                    break;
            }
            return null;
        }

        /// <summary>
        /// XML for Twitter create profile 
        /// </summary>
        public void GenerateTwitterCreateProfilePageXml(string siteName)
        {
            XmlNode profileList = AddElementTag(RootElement, "TWITTERCREATEPROFILE");
            AddAttribute(profileList, "SITENAME", siteName);
        }

        private BaseResult CreateProfileOnBuzz(string siteName)
        {
            BuzzTwitterProfile twitterProfile = null;
            var isProfileCreated = string.Empty;

            BuzzClient client;
            try
            {
                client = new BuzzClient();
                twitterProfile = new BuzzTwitterProfile();

                twitterProfile.SiteURL = siteName;
                twitterProfile.Users = _users.Split(',').Where(x => x != " " && !string.IsNullOrEmpty(x)).Distinct().Select(p => p.Trim()).ToList();
                
                twitterProfile.ProfileId = _profileId;
                twitterProfile.SearchKeywords = _searchterms.Split(',').Where(x => x != " " && !string.IsNullOrEmpty(x)).Distinct().Select(p => p.Trim()).ToList();
               
                twitterProfile.ProfileCountEnabled = _isCountsEnabled;
                twitterProfile.ProfileKeywordCountEnabled = _keywordCountsEnabled;
                twitterProfile.ModerationEnabled = _isModerationEnabled;
                twitterProfile.TrustedUsersEnabled = _isTrustedUsersEnabled;

                isProfileCreated = client.CreateProfile(twitterProfile);

            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);
            }

            if (isProfileCreated.Equals("OK"))
            {
                return new Result("TwitterProfileCreated", String.Format("Twitter profile, {0} created successfully.", _profileId));
            }
            else
            {
                return new Error { Type = "TWITTERPROFILECREATIONINVALIDACTION", ErrorMessage = "Twitter Profile creation failed: " + isProfileCreated };
            }
        }

        private void GetQueryParameters()
        {
            if (InputContext.DoesParamExist("s_siteid", "s_siteid"))
            {
                _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");
            }

            if(InputContext.DoesParamExist("profileid","twitter profile id"))
            {
                _profileId = InputContext.GetParamStringOrEmpty("profileid","twitter profile id");
                _cmd = "CREATEPROFILE";
            }

            if (InputContext.DoesParamExist("title", "twitter profile title"))
            {
                _title = InputContext.GetParamStringOrEmpty("title", "twitter profile title");
            }

            if (InputContext.DoesParamExist("users", "Users associated to the twitter profile"))
            {
                _users = InputContext.GetParamStringOrEmpty("users", "Users associated to the twitter profile");
            }

            if (InputContext.DoesParamExist("searchterms", "search terms associated with the twitter profile"))
            {
                _searchterms = InputContext.GetParamStringOrEmpty("searchterms", "search terms associated with the twitter profile");
            }

            if (InputContext.DoesParamExist("active", "Active twitter profile"))
            {
                _isActive = InputContext.GetParamBoolOrFalse("active", "Active twitter profile");
            }

            if (InputContext.DoesParamExist("trustedusers", "trustedusers"))
            {
                _isTrustedUsersEnabled = InputContext.GetParamBoolOrFalse("trustedusers", "trustedusers");
            }
            
            if (InputContext.DoesParamExist("countsonly", "countsonly"))
            {
                _isCountsEnabled = InputContext.GetParamBoolOrFalse("countsonly", "countsonly");
            }

            if (InputContext.DoesParamExist("keywordcounts", "keywordcounts"))
            {
                _keywordCountsEnabled = InputContext.GetParamBoolOrFalse("keywordcounts", "keywordcounts");
            }

            if (InputContext.DoesParamExist("moderated", "moderated"))
            {
                _isModerationEnabled = InputContext.GetParamBoolOrFalse("moderated", "moderated");
            }

            if (InputContext.DoesParamExist("type", "sitename"))
            {
                _siteName = InputContext.GetParamStringOrEmpty("sitename", "sitename");
            }

            if(InputContext.DoesParamExist("action", "Command string for flow"))
            {
                _cmd = InputContext.GetParamStringOrEmpty("action", "Command string for flow");
            }
            _userId = InputContext.ViewingUser.UserID;
        }
    }
}
