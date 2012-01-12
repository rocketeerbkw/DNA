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
    /// Member List - A derived DnaComponent object
    /// </summary>
    public class MemberList : DnaInputComponent
    {
        private const string _docDnaUserSearchType = @"Method to search for users by.";

        private const string _docDnaCheckAllSites = @"Flag to return details for all sites.";

        private const string _docDnaUserID = @"User ID to search for.";
        private const string _docDnaUserEmail = @"User email to search for.";
        private const string _docDnaUserName = @"User name to look for.";
        private const string _docDnaLoginName = @"User name to look for.";
        private const string _docDnaUserIPAddress = @"User ip address to search for.";
        private const string _docDnaUserBBCUID = @"User BBCUID to look for.";

        private const string _docDnaAction = @"Action parameter.";

        private const string _docDnaSiteID = @"Site ID to apply the new pref status of the user for.";
        private const string _docDnaNewPrefStatus = @"New pref status for the user.";
        private const string _docDnaNewPrefStatusDuration = @"New pref status duration for the user (in days).";
                   
        string _cacheName = String.Empty;

        IDnaDataReaderCreator readerCreator;
        IDnaDiagnostics dnaDiagnostic;

        /// <summary>
        /// Default constructor for the Member List component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MemberList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Overloaded constructor that takes in the context, DnaDataReaderCreator and DnaDiagnostics
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dnaReaderCreator"></param>
        /// <param name="dnaDiagnostics"></param>
        public MemberList(IInputContext context, IDnaDataReaderCreator dnaReaderCreator, IDnaDiagnostics dnaDiagnostics)
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

            TryCreateMemberList();

            TryGetAction(ref action);
            if (!String.IsNullOrEmpty(action))
            {
                if (TryUpdateMemberList(action))
                {
                    RootElement.RemoveAll();
                    TryCreateMemberList();//get changes
                }
            }
        }

        /// <summary>
        /// Method called to try and create Member List, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has succeeded with out error</returns>
        private bool TryCreateMemberList()
        {
            bool checkAllSites = InputContext.ViewingUser.IsSuperUser;
            int userSearchType = InputContext.GetParamIntOrZero("usersearchtype", _docDnaUserSearchType);
            string searchText = InputContext.GetParamStringOrEmpty("searchText", "User search text");

            if (String.IsNullOrEmpty(searchText))
            {
                return false;
            }

            

            GenerateMemberListPageXml(userSearchType,
                                       searchText,
                                       checkAllSites);

            return true;
        }
        /// <summary>
        /// Method called to try and update the Member from the Member List, 
        /// gathers the input params and updates the correct records in the DB 
        /// </summary>
        private bool TryUpdateMemberList(string action)
        {
            List<int> userIDs = new List<int>();
            List<int> siteIDs = new List<int>();
            List<string> userNames = new List<string>();
            List<int> deactivatedUserIds = new List<int>();
            TryGetUserSiteList(ref userIDs, ref siteIDs, ref userNames, ref deactivatedUserIds);

            if (action.ToUpper() == "APPLYACTION")
            {
                int newPrefStatus = (int)Enum.Parse(typeof(BBC.Dna.Moderation.Utils.ModerationStatus.UserStatus), InputContext.GetParamStringOrEmpty("userStatusDescription", "new status"));                 
                int newPrefStatusDuration = InputContext.GetParamIntOrZero("duration", _docDnaNewPrefStatusDuration);
                bool hideAllContent = InputContext.DoesParamExist("hideAllPosts","hideAllPosts");
                string reason = InputContext.GetParamStringOrEmpty("reasonChange", "");
                if (string.IsNullOrEmpty(reason))
                {
                    AddErrorXml("EmptyReason", "Please provide a valid reason for this change for auditing purposes.", null);
                    return false;
                }
                var extraNotes = InputContext.GetParamStringOrEmpty("additionalNotes", "");
                if (!String.IsNullOrEmpty(extraNotes))
                {
                    reason += " - " + extraNotes; 
                }
                if (hideAllContent && newPrefStatus != 5)
                {
                    AddErrorXml("InvalidStatus", "To hide all content you must deactivate the users account.", null);
                    return false;
                }

                if (newPrefStatusDuration != 0 && (newPrefStatus != 2 && newPrefStatus != 1))
                {
                    AddErrorXml("UnableToSetDuration", "You cannot set a status duration when the status is not premoderation or postmoderation.", null);
                    return false;
                }

                if (newPrefStatus == 5)//deactivate account
                {
                    if (!InputContext.ViewingUser.IsSuperUser)
                    {
                        AddErrorXml("InsufficientPermissions", "You do not have sufficient permissions to deactivate users.", null);
                        return false;
                    }
                    ModerationStatus.DeactivateAccount(AppContext.ReaderCreator, userIDs, hideAllContent, reason, InputContext.ViewingUser.UserID);
                }
                else
                {
                    if (!InputContext.ViewingUser.IsSuperUser && deactivatedUserIds.Count > 0)
                    {
                        AddErrorXml("InsufficientPermissions", "You do not have sufficient permissions to reactivate users.", null);
                        return false;
                    }
                    else
                    if(deactivatedUserIds.Count > 0)
                    {
                        ModerationStatus.ReactivateAccount(AppContext.ReaderCreator, deactivatedUserIds, reason, InputContext.ViewingUser.UserID);
                    }
                    ModerationStatus.UpdateModerationStatuses(AppContext.ReaderCreator, userIDs, siteIDs, 
                        newPrefStatus, newPrefStatusDuration, reason, InputContext.ViewingUser.UserID);
                }
            }
            if (action.ToUpper() == "APPLYNICKNAMERESET")
            {
                ResetNickNamesForUsers(userIDs, siteIDs, userNames);
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userIDs"></param>
        /// <param name="siteIDs"></param>
        /// <param name="userNames"></param>
        /// <returns></returns>
        private bool ResetNickNamesForUsers(List<int> userIDs, List<int> siteIDs, List<string> userNames)
        {
            ModerateNickNames resetNickName = new ModerateNickNames(InputContext);
            for (int i = 0; i < userIDs.Count && i < siteIDs.Count && i < userNames.Count; i++)
            {
                if (!String.IsNullOrEmpty((string)userNames[i]))
                {
                    resetNickName.ResetNickName((string)userNames[i], (int)userIDs[i], (int)siteIDs[i]);
                }
            }
            return true;
        }

        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userIDs"></param>
        /// <param name="siteIDs"></param>
        /// <param name="userNames"></param>
        /// <param name="deactivatedUsers"></param>
        private void TryGetUserSiteList(ref List<int> userIDs, ref List<int> siteIDs, ref List<string> userNames, ref List<int> deactivatedUsers)
        {
            userIDs = new List<int>();
            siteIDs = new List<int>();
            userNames = new List<string>();
            deactivatedUsers = new List<int>();

            bool applyToAll = InputContext.DoesParamExist("applyToAll", "applyToAll");

            var users = RootElement.SelectNodes("MEMBERLIST/USERACCOUNTS/USERACCOUNT");
            for (int i = 0; i < users.Count; i++)
            {
                var userId = 0;
                var siteId = 0;
                var userName = users.Item(i).SelectSingleNode("USERNAME").InnerText;
                var deactivated = users.Item(i).SelectSingleNode("ACTIVE").InnerText == "0";

                if(Int32.TryParse(users.Item(i).Attributes["USERID"].Value, out userId) && Int32.TryParse(users.Item(i).SelectSingleNode("SITEID").InnerText, out siteId) )
                {
                    string formVar = string.Format("applyTo|{0}|{1}", userId, siteId);
                    if (applyToAll || InputContext.DoesParamExist(formVar, formVar))
                    {
                        userIDs.Add(userId);
                        siteIDs.Add(siteId);
                        userNames.Add(userName);
                        if (deactivated)
                        {
                            deactivatedUsers.Add(userId);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Gets the action param if there is one
        /// </summary>
        /// <param name="action">The action param string</param>
        private void TryGetAction(ref string action)
        {
            action = string.Empty;
            if (InputContext.DoesParamExist("ApplyNickNameReset", _docDnaAction))
            {
                action = "ApplyNickNameReset";
            }
            if (InputContext.DoesParamExist("ApplyAction", _docDnaAction))
            {
                action = "ApplyAction";
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userSearchType"></param>
        /// <param name="searchText"></param>
        /// <param name="checkAllSites"></param>
        public void GenerateMemberListPageXml(
            int userSearchType,
            string searchText,
            bool checkAllSites)
        {
            if (userSearchType == 0)
            {
                int userId = 0;
                if (!Int32.TryParse(searchText, out userId))
                {
                    AddErrorXml("InvalidUserID", "User Id should be a number", null);
                    return;
                }
            }

            if (userSearchType == 4)
            {
                try
                {
                    var guid = new Guid(searchText);
                }
                catch
                {
                    AddErrorXml("NotValidBBCUid", "A BBC Uid must be of the format 00000000-0000-0000-0000-000000000000",  null);
                    return;
                }

            }


            string storedProcedureName = GetMemberListStoredProcedureName(userSearchType);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                var twitterAPIException = string.Empty;
                var twitterException = string.Empty;

                dataReader.AddParameter("viewinguserid", InputContext.ViewingUser.UserID);

                if (userSearchType == 0)
                {
                    dataReader.AddParameter("usertofindid", searchText);
                }
                else if (userSearchType == 1)
                {
                    dataReader.AddParameter("email", searchText);
                }
                else if (userSearchType == 2)
                {
                    dataReader.AddParameter("username", searchText);
                }
                else if (userSearchType == 3)
                {
                    dataReader.AddParameter("ipaddress", searchText);
                }
                else if (userSearchType == 4)
                {
                    dataReader.AddParameter("BBCUID", searchText);
                }
                else if (userSearchType == 5)
                {
                    dataReader.AddParameter("LoginName", searchText);
                }
                else if (userSearchType == 6)
                {
                    dataReader.AddParameter("twitterscreenname", searchText);
                }
                if (checkAllSites)
                {
                    dataReader.AddParameter("checkallsites", 1);
                }
                else
                {
                    dataReader.AddParameter("checkallsites", 0);
                }

                dataReader.Execute();

                if (false == dataReader.HasRows && userSearchType == 6)
                {

                    twitterException = CreateRetrieveTwitterUser(searchText, dataReader);
                }

                GenerateMemberListXml(dataReader, 
                                        userSearchType, 
                                        searchText,
                                        checkAllSites,
                                        twitterException);
            }
        }

        /// <summary>
        /// This method creates and maps the twitter user to a DNA User ID and retrieve the created twitter user details
        /// </summary>
        /// <param name="searchText"></param>
        /// <param name="dataReader"></param>
        private string CreateRetrieveTwitterUser(string searchText, IDnaDataReader dataReader)
        {
            //TODO: Call the twitter api to get the user details
            TwitterClient client;
            TweetUsers tweetUser;
            //var twitterAPIException = string.Empty;
            var twitterException = string.Empty;
            try
            {
                client = new TwitterClient();
                tweetUser = new TweetUsers();

                tweetUser = client.GetUserDetails(searchText);

                // Create the twitter user with the associated dnauserid in DNA
                if (tweetUser != null)
                {
                    ICacheManager cacheManager = CacheFactory.GetCacheManager();

                    var callingUser = new CallingTwitterUser(this.readerCreator, this.dnaDiagnostic, cacheManager);

                    //Create the twitter user and map it to DNA with site id 1
                    callingUser.CreateUserFromTwitterUser(1, tweetUser.id, tweetUser.Name, tweetUser.ScreenName);
                    callingUser.SynchroniseSiteSuffix(tweetUser.ProfileImageUrl);

                    dataReader.Execute();
                }
            }
            catch (Exception ex)
            {
                InputContext.Diagnostics.WriteExceptionToLog(ex);

                var twitterRateLimitException = "Rate limit exceeded.";
                var twitterErrorNotFound = "The remote server returned an error: (404) Not Found.";
                var twitterUnexpectedResponseException = "The remote server returned an unexpected response: (400) Bad Request.";

                if (ex.Message.Contains(twitterRateLimitException))
                {
                    twitterException = "Twitter API has reached its rate limit. Please try again later.";
                }
                else if (ex.Message.Equals(twitterErrorNotFound) ||
                    ex.InnerException.Message.Equals(twitterErrorNotFound))
                {
                    twitterException = "Searched user not found in Twitter";
                }
                else if (ex.Message.Equals(twitterUnexpectedResponseException))
                {
                    twitterException = "Twitter Exception: " + ex.Message + " Please try again in few minutes.";
                }
                else
                {
                    twitterException = "Twitter Exception: " + ex.Message;
                }
            }

            return twitterException;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataReader"></param>
        /// <param name="userSearchType"></param>
        /// <param name="searchText"></param>
        /// <param name="checkAllSites"></param>
        /// <param name="twitterAPIException"></param>
        public void GenerateMemberListXml(
            IDnaDataReader dataReader,
            int userSearchType,
            string searchText,
            bool checkAllSites,
            string twitterAPIException)
        {
            int count = 0;

            XmlNode memberList = AddElementTag(RootElement, "MEMBERLIST");
            AddAttribute(memberList, "USERSEARCHTYPE", userSearchType.ToString());
            AddAttribute(memberList, "SEARCHTEXT", searchText);
            AddAttribute(memberList, "CHECKALLSITES", checkAllSites.ToString());
            

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    XmlNode userAccounts = AddElementTag(memberList, "USERACCOUNTS");

                    //int previousUserID = 0;
                    XmlNode userAccount = null;
                    do
                    {
                        int userID = dataReader.GetInt32NullAsZero("USERID");
                        /*if (userID != previousUserID)
                        {
                            if (userAccount != null)
                            {
                                userAccounts.AppendChild(userAccount);
                            }
                            userAccount = CreateElementNode("USERACCOUNT");
                            previousUserID = userID;
                        }*/
                        userAccount = CreateElementNode("USERACCOUNT");

                        //Start filling new user xml
                        AddAttribute(userAccount, "USERID", userID);
                        AddTextTag(userAccount, "SITEID", dataReader.GetInt32NullAsZero("SITEID"));

                        AddTextTag(userAccount, "USERNAME", dataReader.GetStringNullAsEmpty("USERNAME"));
                        AddTextTag(userAccount, "LOGINNAME", dataReader.GetStringNullAsEmpty("LOGINNAME"));
                        AddTextTag(userAccount, "EMAIL", dataReader.GetStringNullAsEmpty("EMAIL"));
                        AddTextTag(userAccount, "PREFSTATUS", dataReader.GetInt32NullAsZero("PREFSTATUS"));
                        AddTextTag(userAccount, "PREFSTATUSDURATION", dataReader.GetInt32NullAsZero("PREFSTATUSDURATION"));
                        AddTextTag(userAccount, "USERSTATUSDESCRIPTION", ((ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("PREFSTATUS")).ToString());
                        if (!dataReader.IsDBNull("DATEJOINED"))
                        {
                            AddDateXml(dataReader.GetDateTime("DATEJOINED"), userAccount, "DATEJOINED");
                        }
                        if (!dataReader.IsDBNull("PREFSTATUSCHANGEDDATE"))
                        {
                            DateTime prefStatusChangedDate = dataReader.GetDateTime("PREFSTATUSCHANGEDDATE");
                            AddDateXml(prefStatusChangedDate, userAccount, "PREFSTATUSCHANGEDDATE");
                        }
                        else
                        {
                            AddTextTag(userAccount, "PREFSTATUSCHANGEDDATE", "");
                        }

                        AddTextTag(userAccount, "SHORTNAME", dataReader.GetStringNullAsEmpty("SHORTNAME"));
                        AddTextTag(userAccount, "URLNAME", dataReader.GetStringNullAsEmpty("URLNAME"));

                        if (dataReader.DoesFieldExist("IPADDRESS") && dataReader.GetStringNullAsEmpty("IPADDRESS") != String.Empty)
                        {
                            AddTextTag(userAccount, "IPADDRESS", dataReader.GetStringNullAsEmpty("IPADDRESS"));
                        }
                        if (dataReader.DoesFieldExist("BBCUID") && dataReader.GetGuidAsStringOrEmpty("BBCUID") != String.Empty)
                        {
                            AddTextTag(userAccount, "BBCUID", dataReader.GetGuidAsStringOrEmpty("BBCUID"));
                        }

                        if (userSearchType == 6)
                        {
                            AddTextTag(userAccount, "TWITTERUSERID", dataReader.GetStringNullAsEmpty("TwitterUserID"));
                        }
                        else
                        {
                            AddIntElement(userAccount, "SSOUSERID", dataReader.GetInt32NullAsZero("SSOUserID"));
                        }
                        AddTextTag(userAccount, "IDENTITYUSERID", dataReader.GetStringNullAsEmpty("IdentityUserID"));
                        AddIntElement(userAccount, "ACTIVE", dataReader.GetInt32NullAsZero("STATUS") != 0 ? 1:0);
                        userAccounts.AppendChild(userAccount);

                        count++;
                        
                    } while (dataReader.Read());

                    memberList.AppendChild(userAccounts);
                }
            }

            AddAttribute(memberList, "COUNT", count);

            AddAttribute(memberList, "TWITTEREXCEPTION", twitterAPIException);

            //FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "memberlist", _cacheName, memberList.OuterXml);

            //memberList.OwnerDocument.Save(@"c:\TEMP\memberlist.xml");
        }

        /// <summary>
        /// Gets the name of the stored procedure to call from the passed in parameters
        /// </summary>
        /// <param name="userSearchType">The type of method used to search for the users</param>
        /// <returns>String containing the name of the storedprocedure to call</returns>
        private static string GetMemberListStoredProcedureName(int userSearchType)
        {
            string storedProcedureName = String.Empty;

            if (userSearchType == 0)
            {
                storedProcedureName = "SearchForUserViaUserID";
            }
            else if (userSearchType == 1)
            {
                storedProcedureName = "SearchForUserViaEmail";
            }
            else if (userSearchType == 2)
            {
                storedProcedureName = "SearchForUserViaUserName";
            }
            else if (userSearchType == 3)
            {
                storedProcedureName = "SearchForUserViaIPAddress";
            }
            else if (userSearchType == 4)
            {
                storedProcedureName = "SearchForUserViaBBCUID";
            }
            else if (userSearchType == 5)
            {
                storedProcedureName = "SearchForUserViaLoginName";
            }
            else if (userSearchType == 6)
            {
                storedProcedureName = "SearchForTwitterUserViaScreenName";
            }
            return storedProcedureName;
        }

        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <param name="userSearchType">Method to search for users </param>
        /// <param name="userID">User ID to search for.</param>
        /// <param name="userEmail">User email to search for.</param>
        /// <param name="userName">User name to look for.</param>
        /// <param name="userIPAddress">User ip address to search for.</param>
        /// <param name="userBBCUID">User bbcuid to look for.</param>
        /// <param name="loginName">Login name to look for.</param>
        /// <param name="checkAllSites">Whether to bring back results for all sites</param>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetMemberListCachedXml(
            int userSearchType,
            int userID,
            string userEmail,
            string userName,
            string userIPAddress,
            string userBBCUID,
            string loginName,
            bool checkAllSites)
        {
            bool gotFromCache = false;

            _cacheName = "memberlist-";
            _cacheName += "type" + userSearchType;

            //Create a cache name.
            if (userSearchType == 0)
            {
                _cacheName += "-userid-" + userID.ToString();
            }
            else if (userSearchType == 1)
            {
                _cacheName += "-useremail-" + StringUtils.MakeStringFileNameSafe(userEmail);
            }
            else //(userSearchType == 2)
            {
                _cacheName += "-username-" + StringUtils.MakeStringFileNameSafe(userName);
            }

            if (checkAllSites)
            {
                _cacheName += "-allsites";
            }
            _cacheName += ".xml";

            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(10);  // expire after 10 minutes
            string memberListXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "memberlist", _cacheName, ref expiry, ref memberListXML))
            {
                RipleyAddInside(RootElement, memberListXML);
                gotFromCache = true;
            }

            return gotFromCache;
        }


        
        /// <summary>
        /// Converts form string into prefstatus and hide all posts values
        /// </summary>
        /// <param name="newPrefStatusDescription"></param>
        /// <param name="newPrefStatusValue"></param>
        public void GetPrefStatusValueFromDescription(string newPrefStatusDescription, ref int newPrefStatusValue)
        {
            newPrefStatusValue = 0;

            switch (newPrefStatusDescription.ToUpper())
            {
                case "STANDARD":
                    newPrefStatusValue = 0;
                    break;
                case "PREMODERATE":
                    newPrefStatusValue = 1;
                    break;
                case "POSTMODERATE":
                    newPrefStatusValue = 2;
                    break;
                case "SEND FOR REVIEW":
                    newPrefStatusValue = 3;
                    break;
                case "RESTRICTED":
                    newPrefStatusValue = 4;
                    break;

                case "DEACTIVATE":
                    newPrefStatusValue = 5;
                    break;
                    
                default:
                    newPrefStatusValue = 0;
                    break;
            }
        }

        /// <summary>
        /// Returns the text to display for a given duration in seconds
        /// </summary>
        /// <param name="prefStatusDuration">The pref status duration value text</param>
        /// <returns>The associated pref status duration</returns>
        public string GetPrefStatusDurationDisplayText(string prefStatusDuration)
        {
            string newPrefStatusValue = String.Empty;

            switch (prefStatusDuration)
            {
                case "1440":
                    newPrefStatusValue = @"1 day";
                    break;
                case "10080":
                    newPrefStatusValue = @"1 week";
                    break;
                case "20160":
                    newPrefStatusValue = @"2 weeks";
                    break;
                case "40320":
                    newPrefStatusValue = @"1 month";
                    break;
                default:
                    newPrefStatusValue = @"no limit";
                    break;
            }
            return newPrefStatusValue;
        }

        
    }
}
