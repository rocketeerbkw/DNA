using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

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

        /// <summary>
        /// Default constructor for the Member List component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MemberList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            string action = String.Empty;
            //Clean any existing XML.
            RootElement.RemoveAll();

            TryGetAction(ref action);
            if (action == "update")
            {
                TryUpdateMemberList();
            }
            else
            {
                TryCreateMemberList();
            }
        }
        /// <summary>
        /// Method called to try and create Member List, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has succeeded with out error</returns>
        private bool TryCreateMemberList()
        {
            bool checkAllSites = false;
            int userSearchType = 0;

            int userID = 0;
            string userEmail = String.Empty;
            string userName = String.Empty;
            string loginName = String.Empty;
            string userIPAddress = String.Empty;
            string userBBCUID = String.Empty;

            bool pageParamsOK = TryGetPageParams(ref userSearchType,
                                                    ref userID,
                                                    ref userEmail,
                                                    ref userName,
                                                    ref userIPAddress,
                                                    ref userBBCUID,
                                                    ref loginName,
                                                    ref checkAllSites);

            if (!pageParamsOK)
            {
                return false;
            }

            GetMemberListXml(userSearchType, 
                                userID, 
                                userEmail, 
                                userName, 
                                userIPAddress,
                                userBBCUID, 
                                loginName,
                                checkAllSites);

            return true;
        }
        /// <summary>
        /// Method called to try and update the Member from the Member List, 
        /// gathers the input params and updates the correct records in the DB 
        /// </summary>
        private void TryUpdateMemberList()
        {
            int userID = 0;
            int siteID = 0;
            int newPrefStatus = 0;
            int newPrefStatusDuration = 0;

            TryGetActionPageParams(ref userID,
                                    ref siteID,
                                    ref newPrefStatus,
                                    ref newPrefStatusDuration);

            UpdateModerationStatus(userID, siteID, newPrefStatus, newPrefStatusDuration, 0, 0);
        }

        /// <summary>
        /// Function to get the XML representation of the member list results (from cache if available)
        /// </summary>
        /// <param name="userSearchType">Method to search for users </param>
        /// <param name="userID">User ID to search for.</param>
        /// <param name="userEmail">User email to search for.</param>
        /// <param name="userName">User name to look for.</param>
        /// <param name="userIPAddress">User ip address to search for.</param>
        /// <param name="userBBCUID">User bbcuid to look for.</param>
        /// <param name="loginName">Login name to look for.</param>
        /// <param name="checkAllSites">Whether to bring back results for all sites</param>
         public void GetMemberListXml(int userSearchType, 
                                         int userID, 
                                         string userEmail, 
                                         string userName, 
                                         string userIPAddress,
                                         string userBBCUID, 
                                         string loginName, 
                                         bool checkAllSites)
        {
            //bool cached = GetMemberListCachedXml(userSearchType, userID, userEmail, userName, checkAllSites);

            //if (!cached)
            //{
            GenerateMemberListPageXml(userSearchType, 
                                        userID, 
                                        userEmail, 
                                        userName,
                                        userIPAddress,
                                        userBBCUID,
                                        loginName,
                                        checkAllSites);
            //}
        }

        /// <summary>
        /// Function to update the moderation status of a member list result
        /// </summary>
        /// <param name="userID">User ID of the users moderation status to update </param>
        /// <param name="siteID">Site ID to update the users moderation status on.</param>
        /// <param name="newPrefStatus">The value of the new moderation status</param>
        /// <param name="newPrefStatusDuration">The value of the duration of the new moderation status</param>
        /// <param name="applytoaltids">Flag whether to apply to all the alt ids for that user for that site</param>
        /// <param name="allprofiles">Flag whether to apply to all the alt ids for that user across all sites</param>
        public void UpdateModerationStatus(int userID, int siteID, int newPrefStatus, int newPrefStatusDuration, int applytoaltids, int allprofiles)
        {
            string storedProcedureName = @"updatetrackedmemberprofile";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("userid", userID)
                    .AddParameter("siteid", siteID)
                    .AddParameter("prefstatus", newPrefStatus)
                    .AddParameter("prefstatusduration", newPrefStatusDuration)
                    .AddParameter("usertags", "")
                    .AddParameter("applytoaltids", applytoaltids)
                    .AddParameter("allprofiles", allprofiles);

                dataReader.Execute();
            }
        }


        /// <summary>
        /// Function to update the moderation statuses of a list of member list accounts
        /// </summary>
        /// <param name="userIDList">List of User ID to update with the new moderation status</param>
        /// <param name="siteIDList">List of Site ID to update with the new moderation status</param>
        /// <param name="newPrefStatus">The value of the new moderation status</param>
        /// <param name="newPrefStatusDuration">The value of the duration of the new moderation status</param>
        public void UpdateModerationStatuses(ArrayList userIDList, ArrayList siteIDList, int newPrefStatus, int newPrefStatusDuration)
        {
            //New function to take lists of users and sites
            string storedProcedureName = @"updatetrackedmemberlist";
            string userIDs = @"";
            string siteIDs = @"";
            foreach (int userID in userIDList)
            {
                userIDs += userID.ToString();
                userIDs += "|";
            }
            //Remove the last one
            userIDs = userIDs.TrimEnd('|');

            foreach (int siteID in siteIDList)
            {
                siteIDs += siteID.ToString();
                siteIDs += "|";
            }
            //Remove the last one
            siteIDs = siteIDs.TrimEnd('|');

            //Set all the user id and siteid pairs to the passed in Status and duration
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("userIDs", userIDs)
                    .AddParameter("siteIDs", siteIDs)
                    .AddParameter("prefstatus", newPrefStatus)
                    .AddParameter("prefstatusduration", newPrefStatusDuration);
                dataReader.Execute();
            }
        }

        /// <summary>
        /// Function to update the moderation status of a member list result
        /// </summary>
        /// <param name="viewingUserID">Viewing User ID trying to update the moderation status</param>
        /// <param name="userID">User ID of the users moderation status to update </param>
        /// <param name="siteID">Site ID to update the users moderation status on.</param>
        /// <param name="newPrefStatus">The value of the new moderation status</param>
        /// <param name="newPrefStatusDuration">The value of the duration of the new moderation status</param>
        public void UpdateModerationStatusAcrossAllSites(int viewingUserID, int userID, int siteID, int newPrefStatus, int newPrefStatusDuration)
        {
            string storedProcedureName = @"updatememberprofilesacrosssites";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("viewinguserid", viewingUserID)
                    .AddParameter("userid", userID)
                    .AddParameter("siteid", siteID)
                    .AddParameter("prefstatus", newPrefStatus)
                    .AddParameter("prefstatusduration", newPrefStatusDuration);

                dataReader.Execute();
            }
        }

        /// <summary>
        /// Try to gets the params for the page
        /// </summary>
        /// <param name="userSearchType">Method to search for users </param>
        /// <param name="userID">User ID to search for.</param>
        /// <param name="userEmail">User email to search for.</param>
        /// <param name="userName">User name to look for.</param>
        /// <param name="userIPAddress">User ip address to search for.</param>
        /// <param name="userBBCUID">User bbcuid to look for.</param>
        /// <param name="loginName">Login name to look for.</param>
        /// <param name="checkAllSites">Whether to bring back results for all sites</param>
        /// <returns>Whether the Params were retrieved without error</returns>
        private bool TryGetPageParams(
            ref int userSearchType,
            ref int userID,
            ref string userEmail,
            ref string userName, 
            ref string userIPAddress,
            ref string userBBCUID,
            ref string loginName,
            ref bool checkAllSites)
        {
            userSearchType = InputContext.GetParamIntOrZero("usersearchtype", _docDnaUserSearchType);

            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            userEmail = InputContext.GetParamStringOrEmpty("useremail", _docDnaUserEmail);
            userName = InputContext.GetParamStringOrEmpty("username", _docDnaUserName);
            userIPAddress = InputContext.GetParamStringOrEmpty("useripaddress", _docDnaUserIPAddress);
            userBBCUID = InputContext.GetParamStringOrEmpty("userbbcuid", _docDnaUserBBCUID);
            loginName = InputContext.GetParamStringOrEmpty("loginname", _docDnaLoginName);

            checkAllSites = false;

            int allSites = InputContext.GetParamIntOrZero("checkallsites", _docDnaCheckAllSites);
            if (allSites == 1)
            {
                checkAllSites = true;
            }

            return true;
        }

        /// <summary>
        /// Try to gets the action params for the page
        /// </summary>
        /// <param name="userID">Method to search for users </param>
        /// <param name="siteID">User ID to search for.</param>
        /// <param name="newPrefStatus">new pref status.</param>
        /// <param name="newPrefStatusDuration">Duration for the pref status</param>
        private void TryGetActionPageParams(
            ref int userID,
            ref int siteID,
            ref int newPrefStatus,
            ref int newPrefStatusDuration)
        {
            userID = InputContext.GetParamIntOrZero("userID", _docDnaUserID);

            siteID = InputContext.GetParamIntOrZero("siteid", _docDnaSiteID);
            newPrefStatus = InputContext.GetParamIntOrZero("newprefstatus", _docDnaNewPrefStatus);
            newPrefStatusDuration = InputContext.GetParamIntOrZero("newprefstatusduration", _docDnaNewPrefStatusDuration);

        }

        /// <summary>
        /// Gets the action param if there is one
        /// </summary>
        /// <param name="action">The action param string</param>
        private void TryGetAction(ref string action)
        {
            action = InputContext.GetParamStringOrEmpty("action", _docDnaAction);
        }

        /// <summary>
        /// Calls the correct stored procedure given the inputs selected
        /// </summary>
        /// <param name="userSearchType">Method to search for users </param>
        /// <param name="userID">User ID to search for.</param>
        /// <param name="userEmail">User email to search for.</param>
        /// <param name="userName">User name to look for.</param>
        /// <param name="userIPAddress">User ip address to search for.</param>
        /// <param name="userBBCUID">User bbcuid to look for.</param>
        /// <param name="loginName">Login name to look for.</param>
        /// <param name="checkAllSites">Whether to bring back results for all sites</param>
        private void GenerateMemberListPageXml(
            int userSearchType,
            int userID,
            string userEmail,
            string userName,
            string userIPAddress,
            string userBBCUID,
            string loginName,
            bool checkAllSites)
        {
            string storedProcedureName = GetMemberListStoredProcedureName(userSearchType);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("viewinguserid", InputContext.ViewingUser.UserID);

                if (userSearchType == 0)
                {
                    dataReader.AddParameter("usertofindid", userID.ToString());
                }
                else if (userSearchType == 1)
                {
                    dataReader.AddParameter("email", userEmail);
                }
                else if (userSearchType == 2)
                {
                    dataReader.AddParameter("username", userName);
                }
                else if (userSearchType == 3)
                {
                    dataReader.AddParameter("ipaddress", userIPAddress);
                }
                else if (userSearchType == 4)
                {
                    dataReader.AddParameter("BBCUID", userBBCUID);
                }
                else if (userSearchType == 5)
                {
                    dataReader.AddParameter("LoginName", loginName);
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

                GenerateMemberListXml(dataReader, 
                                        userSearchType, 
                                        userID, 
                                        userEmail, 
                                        userName, 
                                        userIPAddress, 
                                        userBBCUID, 
                                        loginName,
                                        checkAllSites);
            }
        }

        /// <summary>
        /// With the returned data set generate the XML for the Member List page
        /// </summary>
        /// <param name="dataReader">Data set to turn into XML</param>
        /// <param name="userSearchType">Method to search for users </param>
        /// <param name="userSearchID">User ID to search for.</param>
        /// <param name="userEmail">User email to search for.</param>
        /// <param name="userName">User name to look for.</param>
        /// <param name="userIPAddress">User ip address to search for.</param>
        /// <param name="userBBCUID">User bbcuid to look for.</param>
        /// <param name="loginName">Login name to look for.</param>
        /// <param name="checkAllSites">Whether to bring back results for all sites</param>
        private void GenerateMemberListXml(
            IDnaDataReader dataReader,
            int userSearchType,
            int userSearchID,
            string userEmail,
            string userName,
            string userIPAddress,
            string userBBCUID,
            string loginName,
            bool checkAllSites)
        {
            int count = 0;

            XmlNode memberList = AddElementTag(RootElement, "MEMBERLIST");

            AddAttribute(memberList, "USERSEARCHTYPE", userSearchType);

            AddAttribute(memberList, "USERSEARCHID", userSearchID);
            AddAttribute(memberList, "USERSEARCHEMAIL", StringUtils.EscapeAllXmlForAttribute(userEmail));
            AddAttribute(memberList, "USERSEARCHNAME", StringUtils.EscapeAllXmlForAttribute(userName));
            AddAttribute(memberList, "USERSEARCHIPADDRESS", StringUtils.EscapeAllXmlForAttribute(userIPAddress));
            AddAttribute(memberList, "USERSEARCHBBCUID", StringUtils.EscapeAllXmlForAttribute(userBBCUID));
            AddAttribute(memberList, "USERSEARCHLOGINNAME", StringUtils.EscapeAllXmlForAttribute(loginName));

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
                        AddTextTag(userAccount, "USERSTATUSDESCRIPTION", dataReader.GetStringNullAsEmpty("USERSTATUSDESCRIPTION"));

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

                        AddIntElement(userAccount, "SSOUSERID", dataReader.GetInt32NullAsZero("SSOUserID"));
                        AddTextTag(userAccount, "IDENTITYUSERID", dataReader.GetStringNullAsEmpty("IdentityUserID"));

                        userAccounts.AppendChild(userAccount);

                        count++;
                        
                    } while (dataReader.Read());

                    memberList.AppendChild(userAccounts);
                }
            }

            AddAttribute(memberList, "COUNT", count);

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
    }
}
