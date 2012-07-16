﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.SocialAPI;
using BBC.Dna.Api;
using BBC.Dna.Users;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Xml.Linq;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Twitter Profile - A derived Dnacomponent object used for both creation and update
    /// </summary>
    public class TwitterProfile : DnaInputComponent
    {
        private int _siteId = 0;
        private int _userId = 0;
        private string _siteName = string.Empty;
        private string _profileId = string.Empty;
        private string _title = string.Empty;
        private string _users = string.Empty;
        private string _searchterms = string.Empty;
        private string _cmd = string.Empty;
        private string _pageAction = string.Empty;
        private bool _isActive = false;
        private bool _isTrustedUsersEnabled = false;
        private bool _isCountsEnabled = false;
        private bool _keywordCountsEnabled = false;
        private bool _isModerationEnabled = false;
        private List<string> twitterUserScreenNameList;

        IDnaDataReaderCreator readerCreator;
        IDnaDiagnostics dnaDiagnostic;

        /// <summary>
        /// Default constructor for the Twitter Create Profile component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public TwitterProfile(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Overloaded constructor that takes in the context, DnaDataReaderCreator and DnaDiagnostics
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dnaReaderCreator"></param>
        /// <param name="dnaDiagnostics"></param>
        public TwitterProfile(IInputContext context, IDnaDataReaderCreator dnaReaderCreator, IDnaDiagnostics dnaDiagnostics)
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

            var siteName = string.Empty;

            //Should be removed once the site list is filled up

            if (!string.IsNullOrEmpty(_siteName))
            {
                siteName = _siteName;
            }
            else
            {
                siteName = "Test Site";
            }
           
            GenerateTwitterProfilePageXml(siteName);

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
                case "CREATEUPDATEPROFILE":
                    return CreateUpdateProfileOnBuzz(siteName);
                
                case "GETPROFILE":
                    return GetProfileFromBuzz(_profileId);

                default:

                    break;
            }
            return null;
        }

        /// <summary>
        /// XML for Twitter create profile 
        /// </summary>
        public void GenerateTwitterProfilePageXml(string siteName)
        {
            XmlNode profileList = AddElementTag(RootElement, "TWITTERPROFILE");
            AddAttribute(profileList, "SITENAME", siteName);
        }

        /// <summary>
        /// Get specific profile details from Buzz
        /// </summary>
        /// <param name="twitterProfileId"></param>
        /// <returns></returns>
        private BaseResult GetProfileFromBuzz(string twitterProfileId)
        {
            BuzzClient client;
            BuzzTwitterProfile twitterProfile = null;
            try
            {
                client = new BuzzClient();
                twitterProfile = new BuzzTwitterProfile();

                twitterProfile = client.GetProfile(twitterProfileId);

                if (twitterProfile != null)
                {
                    var twitterUserIds = string.Join(",", twitterProfile.Users.ToArray());

                    twitterProfile.Users = GetTwitterScreenNamesFromDNA(twitterUserIds);

                    string str = StringUtils.SerializeToXmlReturnAsString(twitterProfile);

                    var actualXml = str.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
                    actualXml = actualXml.Replace("xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"BBC.Dna.SocialAPI\"", "").Trim();
                    actualXml = actualXml.Replace("xmlns:d2p1=\"http://schemas.microsoft.com/2003/10/Serialization/Arrays\"", "").Trim();
                    actualXml = actualXml.Replace("d2p1:string", "item");
                    //Making all the XML Nodes uppercase
                    actualXml = StringUtils.ConvertXmlTagsToUppercase(actualXml);

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(actualXml);
                    XmlNode appendNode = doc.DocumentElement;

                    ImportAndAppend(appendNode, "");
                    return new Result("TwitterProfileRetrieved", String.Format("Twitter profile, {0} retrieved successfully.", twitterProfileId));
                }
                else
                {
                    return new Error { Type = "GETTWITTERPROFILEINVALIDACTION", ErrorMessage = "Twitter Profile retrieval failed: " };
                }
            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);
                return new Error { Type = "GETTWITTERPROFILEINVALIDACTION", ErrorMessage = "Twitter Profile retrieval failed: " };
            }
        }

        /// <summary>
        /// Gets the twitter screennames from DNA
        /// </summary>
        /// <param name="userIdList"></param>
        /// <returns></returns>
        private List<string> GetTwitterScreenNamesFromDNA(string userIdList)
        {
            List<string> twitterScreenNames = new List<string>();

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("gettwitterscreennamefromtwitteruserid"))
            {
                dataReader.AddParameter("twitteruserids", userIdList);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        var twitterScreenName = dataReader.GetStringNullAsEmpty("TwitterScreenName");

                        if (false == string.IsNullOrEmpty(twitterScreenName))
                        {
                            twitterScreenNames.Add(twitterScreenName);
                        }
                    }
                }
            }

            return twitterScreenNames;
        }


        /// <summary>
        /// Twitter Profile creation on Buzz
        /// </summary>
        /// <param name="siteName"></param>
        /// <returns></returns>
        private BaseResult CreateUpdateProfileOnBuzz(string siteName)
        {
            BuzzTwitterProfile twitterProfile = null;
            var isProfileCreated = string.Empty;

            BuzzClient client;
            try
            {
                client = new BuzzClient();
                twitterProfile = new BuzzTwitterProfile();

                twitterProfile.SiteURL = siteName;

                List<string> twitterUserIds = new List<string>();
                var isValidUser = string.Empty;
                var userExists = false;

                #region Not required for the atheletes setup
                
                foreach (string tweetUserScreenName in twitterUserScreenNameList)
                {
                    Dictionary<bool, string> twitterUser = new Dictionary<bool,string>();
                    try
                    {
                        twitterUser = CheckUserExists(tweetUserScreenName);

                        foreach (var item in twitterUser)
                        {
                            userExists = Convert.ToBoolean(item.Key.ToString());
                            if (true == userExists)
                            {
                                twitterUserIds.Add(item.Value.ToString());
                            }
                            else
                            {
                                return new Error { Type = "TWITTERRETRIEVEUSERINVALIDACTION", ErrorMessage = "The following user is not registered in DNA yet, '" + tweetUserScreenName + "' " + isValidUser };

                            }
                        }
                    }
                    finally
                    {
                        twitterUser.Clear();
                        twitterUser = null;
                    }
                }
                

                twitterProfile.Users = twitterUserIds;

                #endregion

                twitterProfile.ProfileId = _profileId;
                twitterProfile.Title = _title;
                twitterProfile.SearchKeywords = _searchterms.Split(',').Where(x => x != " " && !string.IsNullOrEmpty(x)).Distinct().Select(p => p.Trim()).ToList();
                
                twitterProfile.ProfileCountEnabled = _isCountsEnabled;
                twitterProfile.ProfileKeywordCountEnabled = _keywordCountsEnabled;
                twitterProfile.ModerationEnabled = _isModerationEnabled;
                twitterProfile.TrustedUsersEnabled = _isTrustedUsersEnabled;

                twitterProfile.Active = _isActive;

                isProfileCreated = client.CreateUpdateProfile(twitterProfile);

            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);
            }

            if (isProfileCreated.Equals("OK"))
            {
                //Create and map commentforum
                Comments commentObj = new Comments(dnaDiagnostic,readerCreator, AppContext.DnaCacheManager, InputContext.TheSiteList);

                CommentForum commentForum = new CommentForum();
                commentForum.isContactForm = false;
                commentForum.SiteName = siteName;
                commentForum.ParentUri = "www.test.bbc.co.uk"; // going to be a free text
                commentForum.Id = _profileId;
                commentForum.Title = _title;

                CommentForum commentForumData = commentObj.CreateCommentForum(commentForum, InputContext.CurrentSite);

                if (commentForumData != null && commentForumData.Id == _profileId)
                {
                    if (string.IsNullOrEmpty(_pageAction))
                    {
                        return new Result("TwitterProfileCreated", String.Format("Twitter profile, {0} created successfully.", _profileId));
                    }
                    else
                    {
                        return new Result("TwitterProfileUpdated", string.Format("Twitter profile, {0} updated successfully.", _profileId));
                    }
                }
                else
                {
                    return new Error { Type = "COMMENTFORUMCREATIONINVALIDACTION", ErrorMessage = "Comment Forum creation failed: " + _profileId };
                }
                
            }
            else
            {
                return new Error { Type = "TWITTERPROFILECREATIONINVALIDACTION", ErrorMessage = "Twitter Profile creation failed: " + isProfileCreated };
            }
        }

        /// <summary>
        /// Check if the user already exists in DNA
        /// </summary>
        /// <param name="twitterUserName"></param>
        /// <returns></returns>
        private Dictionary<bool,string> CheckUserExists(string twitterUserName)
        {
            Dictionary<bool, string> UserExists = new Dictionary<bool, string>();

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("doestwitteruserexists"))
            {
                dataReader.AddParameter("twitterscreenname", twitterUserName);

                dataReader.Execute();

                if (dataReader.HasRows && dataReader.Read())
                {
                    var twitterUserExists = dataReader.GetStringNullAsEmpty("TwitterUserID"); 
                    if (twitterUserExists.Equals("NA"))
                    {
                        UserExists.Add(false, string.Empty);
                    }
                    else
                    {
                        UserExists.Add(true, twitterUserExists);
                    }
                }
            }

            return UserExists;
        }

        /// <summary>
        /// Checks if the user exists in Twitter.
        /// If Exists, returns the user details else returns exception
        /// </summary>
        /// <param name="twitterUserScreenName"></param>
        /// <returns></returns>
        private string IsValidTwitterUser(string twitterUserScreenName)
        {
            MemberList memberList = null;
            var twitterException = string.Empty;
            var _isValidTwitterScreenName = string.Empty;
            try
            {
                memberList = new MemberList(base.InputContext);

                TweetUsers tweetUser = memberList.RetrieveTweetUserDetails(twitterUserScreenName);
                
                if (tweetUser.TwitterResponseException != null)
                {
                    var twitterRateLimitException = "Rate limit exceeded.";
                    var twitterErrorNotFound = "The remote server returned an error: (404) Not Found.";
                    var twitterUnexpectedResponseException = "The remote server returned an unexpected response: (400) Bad Request.";

                    if (tweetUser.TwitterResponseException.Message.Contains(twitterRateLimitException))
                    {
                        twitterException = "Twitter Exception: Twitter API has reached its rate limit. Please try again later.";
                    }
                    else if (tweetUser.TwitterResponseException.Message.Equals(twitterErrorNotFound) ||
                        tweetUser.TwitterResponseException.InnerException.Message.Equals(twitterErrorNotFound))
                    {
                        twitterException = "Twitter Error: Searched user not found in Twitter";
                    }
                    else if (tweetUser.TwitterResponseException.Message.Equals(twitterUnexpectedResponseException))
                    {
                        twitterException = "Twitter Exception: " + tweetUser.TwitterResponseException.Message + " Please try again in few minutes.";
                    }
                    else
                    {
                        twitterException = "Twitter Exception: " + tweetUser.TwitterResponseException.Message;
                    }

                    _isValidTwitterScreenName = twitterException;
                }
                else
                {
                    _isValidTwitterScreenName = tweetUser.id;

                    //Creating the twitter user in DNA
                    ICacheManager cacheManager = CacheFactory.GetCacheManager();

                    var callingUser = new CallingTwitterUser(this.readerCreator, this.dnaDiagnostic, cacheManager);

                    //Create the twitter user and map it to DNA with site id 1
                    callingUser.CreateUserFromTwitterUser(1, tweetUser);
                    callingUser.SynchroniseSiteSuffix(tweetUser.ProfileImageUrl);
                }
           
            }
            finally
            {
                memberList = null;
            }
            return _isValidTwitterScreenName;
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
            }

            if (InputContext.DoesParamExist("title", "twitter profile title"))
            {
                _title = InputContext.GetParamStringOrEmpty("title", "twitter profile title");
            }

            if (InputContext.DoesParamExist("users", "Users associated to the twitter profile"))
            {
                _users = InputContext.GetParamStringOrEmpty("users", "Users associated to the twitter profile");
                twitterUserScreenNameList = _users.Split(',').Where(x => x != " " && !string.IsNullOrEmpty(x)).Distinct().Select(p => p.Trim()).ToList();
            }

            if (InputContext.DoesParamExist("searchterms", "search terms associated with the twitter profile"))
            {
                _searchterms = InputContext.GetParamStringOrEmpty("searchterms", "search terms associated with the twitter profile");
            }

            if (InputContext.DoesParamExist("active", "Active twitter profile"))
            {
                _isActive = Convert.ToBoolean(InputContext.GetParamStringOrEmpty("active", "Active twitter profile"));
            }

            if (InputContext.DoesParamExist("trustedusers", "trustedusers"))
            {
                _isTrustedUsersEnabled = Convert.ToBoolean(InputContext.GetParamStringOrEmpty("trustedusers", "trustedusers"));
            }
            
            if (InputContext.DoesParamExist("countsonly", "countsonly"))
            {
                _isCountsEnabled = Convert.ToBoolean(InputContext.GetParamStringOrEmpty("countsonly", "countsonly"));
            }

            if (InputContext.DoesParamExist("keywordcounts", "keywordcounts"))
            {
                _keywordCountsEnabled = Convert.ToBoolean(InputContext.GetParamStringOrEmpty("keywordcounts", "keywordcounts"));
            }

            if (InputContext.DoesParamExist("moderated", "moderated"))
            {
                _isModerationEnabled = Convert.ToBoolean(InputContext.GetParamStringOrEmpty("moderated", "moderated"));
            }

            if (InputContext.DoesParamExist("type", "sitename"))
            {
                _siteName = InputContext.GetParamStringOrEmpty("sitename", "sitename");
            }

            if(InputContext.DoesParamExist("action", "Command string for flow"))
            {
                _cmd = InputContext.GetParamStringOrEmpty("action", "Command string for flow");
            }

            if (InputContext.DoesParamExist("s_action", "page update action"))
            {
                _pageAction = InputContext.GetParamStringOrEmpty("s_action", "page update action");
            }

            _userId = InputContext.ViewingUser.UserID;
        }
    }
}
