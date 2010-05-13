using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using BBC.Dna.Data;
using Tests;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace TestUtils
{
    /// <summary>
    /// This class is used to create test users for tests
    /// </summary>
    public class TestUserCreator
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public TestUserCreator()
        {
        }

        /// <summary>
        /// The policies we can create the user against
        /// </summary>
        public enum IdentityPolicies
        {
            Adult,
            Kids,
            Over13,
            Schools,
            Blast
        }

        /// <summary>
        /// Gets the specified policy as a string
        /// </summary>
        /// <param name="policy">The policy you want as a string</param>
        /// <returns>The policy value</returns>
        public static string GetPolicyAsString(IdentityPolicies policy)
        {
            if (policy == IdentityPolicies.Adult)
            {
                return "http://identity/policies/dna/adult";
            }
            else if (policy == IdentityPolicies.Kids)
            {
                return "http://identity/policies/dna/kids";
            }
            else if (policy == IdentityPolicies.Over13)
            {
                return "http://identity/policies/dna/over13";
            }
            else if (policy == IdentityPolicies.Schools)
            {
                return "http://identity/policies/dna/schools";
            }
            else if (policy == IdentityPolicies.Blast)
            {
                return "http://identity/policies/dna/blast";
            }
            return "";
        }

        /// <summary>
        /// Request type
        /// </summary>
        public enum RequestVerb
        {
            POST,
            PUT,
            GET,
            DELETE
        }

        /// <summary>
        /// The different types of user accounts we use.
        /// </summary>
        /// <remarks>IdentityOnly means the user is not created in the database.</remarks>
        public enum UserType
        {
            IdentityOnly,
            Normal,
            SuperUser,
            Editor,
            Moderator,
            Notable
        }

        /// <summary>
        /// The different types of core attributes a user has
        /// </summary>
        public enum AttributeNames
        {
            UserName,
            DisplayName,
            Email,
            AgreedIdentityTermsAndConditions,
            LegacySSOID,
            FirstName,
            LastName,
            GuardianAgreedTermsAndConditions,
            GuardianEmail,
            GuardianEmailConfirmed
        }

        /// <summary>
        /// Dna specific attributes users can have
        /// </summary>
        public enum DnaAttributeNames
        {
            AgreedTermsAndConditionsAdult,
            AgreedTermsAndConditionsKids,
            AgreedTermsAndConditionsOver13,
            AgreedTermsAndConditionsSchools,
            UnderAgeRangeCheck
        }

        private static string _IdentityServerBaseUri = "https://api.stage.bbc.co.uk/idservices";

        public static string SetBaseIdentityURL
        {
            set
            {
                _IdentityServerBaseUri = value;
                _webServiceCertificationName = "dna";
            }
        }


        private static string _webServiceCertificationName = "dna live";
        private static string _proxy = "http://10.152.4.180:80";

        private static string _wrUserName = "username";
        private static string _wrPassword = "password";
        private static string _wrDateOfBirth = "date_of_birth";
        private static string _wrAgreementAcceptedFlag = "agreement_accepted_flag";
        private static string _wrGuardianAcceptedFlag = "guardian_agreement_accepted_flag";
        private static string _wrGuardianEmail = "guardian_email";
        private static string _wrGuardianEmailConfirmed = "guardian_email_validation_flag";
        private static string _wrdisplayName = "displayname";
        private static string _wremail = "email";
        private static string _wremailvalidated = "email_validation_flag";
        private static string _wrLegacySSOID = "legacy_user_id";
        private static string _wrFirstName = "firstname";
        private static string _wrLastName = "lastname";

        private static string _wrUnderAgeRangecheck = "server_side_age_policy_override";
        private static string _wrHouseRulesAdults = "houserules.adults";
        private static string _wrHouseRulesOver13 = "houserules.over13";
        private static string _wrHouseRulesSchools = "houserules.schools";
        private static string _wrHouseRulesKids = "houserules.kids";

        /// <summary>
        /// The last known error
        /// </summary>
        private static string _error;
        static public string GetLastError
        {
            get { return _error; }
        }

        /// <summary>
        /// The cert callback method
        /// </summary>
        /// <param name="sender">who sent the cert</param>
        /// <param name="certificate">the cert itself</param>
        /// <param name="chain">the chain the cert had to go through</param>
        /// <param name="sslPolicyErrors">any errors</param>
        /// <returns>True if we like the cert, false if not</returns>
        static public bool AcceptAllCertificatePolicy(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; }

        /// <summary>
        /// Creates/Registers a new Identity user
        /// </summary>
        /// <param name="userName">The name of the new user</param>
        /// <param name="password">The password the user account will use</param>
        /// <param name="dateOfBirth">The date of birth for the new user</param>
        /// <param name="email">The email address for the new user</param>
        /// <param name="displayName">Optional display name for the user. Leave blank if not needed</param>
        /// <param name="acceptedIdentityTCs">A flag to state whether or not the user has excepted the Identity T&Cs</param>
        /// <param name="policy">The policy that the user is being created for</param>
        /// <param name="acceptedPolicyTCs">A flag to state whether or no the user has accepted the policy T&Cs</param>
        /// <param name="legacySSOID"></param>
        /// <param name="cookie">Output value for the users cookie</param>
        /// <param name="secureCookie">Output value for the users secure cookie</param>
        /// <param name="userIdentityID"></param>
        /// <returns>True if created, false if not</returns>
        static public bool CreateIdentityUser(string userName, 
                                                string password, 
                                                string dateOfBirth, 
                                                string email, 
                                                string displayName, 
                                                bool acceptedIdentityTCs, 
                                                IdentityPolicies policy, 
                                                bool acceptedPolicyTCs, 
                                                int legacySSOID, 
                                                out Cookie cookie, 
                                                out Cookie secureCookie,
                                                out int userIdentityID)
        {
            ServicePointManager.ServerCertificateValidationCallback += AcceptAllCertificatePolicy;

            userIdentityID = 0;
            cookie = null;
            secureCookie = null;

            // Create a new user to do the tests with
            Dictionary<string, string> postParams = new Dictionary<string, string>();
            postParams.Add(_wrUserName, userName);
            postParams.Add(_wrPassword, password);
            postParams.Add(_wrDateOfBirth, dateOfBirth);
            postParams.Add(_wrAgreementAcceptedFlag, acceptedIdentityTCs ? "1" : "0");
            postParams.Add(_wremail, email);
            postParams.Add(_wremailvalidated, "1");
            if (policy != IdentityPolicies.Adult && acceptedIdentityTCs)
            {
                postParams.Add(_wrGuardianAcceptedFlag, "1");
                postParams.Add(_wrGuardianEmail, "parent_" + email);
                postParams.Add(_wrGuardianEmailConfirmed, "1");
            }

            if (displayName.Length > 0)
            {
                postParams.Add(_wrdisplayName, displayName);
            }
            if (legacySSOID > 0)
            {
                postParams.Add(_wrLegacySSOID, legacySSOID.ToString());
            }

            // Register the new user
            HttpWebResponse response = CallIdentityRestAPI("/users", postParams, null, RequestVerb.POST);
            if (response != null && response.StatusCode == HttpStatusCode.Created)
            {
                cookie = response.Cookies["IDENTITY"];
                secureCookie = response.Cookies["IDENTITY-HTTPS"];

                string[] cookieParams = cookie.Value.Split('|');
                userIdentityID = Convert.ToInt32(cookieParams[0]);
                response.Close();
            }
            else
            {
                response.Close();
                _error += ".\nFailed to create user.";
                return false;
            }

            // Now update a few of the core attributes
            List<Cookie> cookies = new List<Cookie>();
            cookies.Add(cookie);
            cookies.Add(secureCookie);
           
            // Now update the personal attribute for the policy T&Cs
            if (acceptedPolicyTCs)
            {
                postParams.Clear();
                if (policy == IdentityPolicies.Adult)
                {
                    postParams.Add(_wrHouseRulesAdults, "1");
                }
                else if (policy == IdentityPolicies.Over13)
                {
                    postParams.Add(_wrHouseRulesOver13, "1");
                }
                else if (policy == IdentityPolicies.Schools)
                {
                    postParams.Add(_wrHouseRulesSchools, "1");
                }
                else
                {
                    postParams.Add(_wrHouseRulesKids, "1");
                }

                response = CallIdentityRestAPI(string.Format("/users/{0}/applications/dna/attributes", userName), postParams, cookies, RequestVerb.POST);
                if (response == null || response.StatusCode != HttpStatusCode.Created)
                {
                    _error += ".\nFailed to set users policy details.";
                    response.Close();
                    return false;
                }
                response.Close();
            }

            return true;
        }

        /// <summary>
        /// Helper method for creating a new normal Identity user on the fly
        /// </summary>
        /// <param name="userName">The name you want the new user to have</param>
        /// <param name="password">The password for the account</param>
        /// <param name="dateOfBirth">The date of birth for the account. Format - "1989-12-31"</param>
        /// <param name="email">The email for the account</param>
        /// <param name="displayName">The display name for the account</param>
        /// <param name="acceptedIdentityTCs">A flag to whether or not the user has agreed the identity terms and conditions</param>
        /// <param name="policy">The policy the user is to be validated against</param>
        /// <param name="acceptedPolicyTCs">A flag stating whether or not the user has accepted the policy</param>
        /// <param name="cookie">Output value for the users cookie</param>
        /// <param name="secureCookie">Output value for the users secure cookie</param>
        /// <param name="identityUserID">Output value for the new users Identity UserID</param>
        /// <param name="dnaUserID">Output value for the new users DNA UserID</param>
        /// <returns>True if they were created ok, false if not</returns>
        public static bool CreateNewIdentityNormalUser(string userName, string password, string dateOfBirth, string email, string displayName, bool acceptedIdentiutyTCs, IdentityPolicies policy, bool acceptedPolicyTCs, out Cookie cookie, out Cookie secureCookie, out int userIdentityID, out int dnaUserID)
        {
            dnaUserID = 0;
            if (CreateIdentityUser(userName, password, dateOfBirth, email, displayName, true, policy, true, 0, out cookie, out secureCookie, out userIdentityID))
            {
                dnaUserID = CreateUserInDatabase(userName, email, displayName, userIdentityID);
            }
            return dnaUserID > 0;
        }

        /// <summary>
        /// Helper method for creating a new normal Identity user on the fly
        /// </summary>
        /// <param name="userName">The name you want the new user to have</param>
        /// <param name="password">The password for the account</param>
        /// <param name="dateOfBirth">The date of birth for the account. Format - "1989-12-31"</param>
        /// <param name="email">The email for the account</param>
        /// <param name="displayName">The display name for the account</param>
        /// <param name="policy">The policy the user is to be validated against</param>
        /// <param name="cookie">Output value for the users cookie</param>
        /// <param name="secureCookie">Output value for the users secure cookie</param>
        /// <param name="identityUserID">Output value for the new users Identity UserID</param>
        /// <param name="dnaUserID">Output value for the new users DNA UserID</param>
        /// <returns>True if they were created ok, false if not</returns>
        public static bool CreateNewIdentitySuperUser(string userName, string password, string dateOfBirth, string email, string displayName, IdentityPolicies policy, out Cookie cookie, out Cookie secureCookie, out int userIdentityID, out int dnaUserID)
        {
            dnaUserID = 0;
            if (CreateNewIdentityNormalUser(userName, password, dateOfBirth, email, displayName, true, policy, true, out cookie, out secureCookie, out userIdentityID, out dnaUserID))
            {
                SetUserAsSuperUserInDataBase(dnaUserID);
            }
            return dnaUserID > 0;
        }

        /// <summary>
        /// Helper method for creating a new normal Identity user on the fly
        /// </summary>
        /// <param name="userName">The name you want the new user to have</param>
        /// <param name="password">The password for the account</param>
        /// <param name="dateOfBirth">The date of birth for the account. Format - "1989-12-31"</param>
        /// <param name="email">The email for the account</param>
        /// <param name="displayName">The display name for the account</param>
        /// <param name="siteid">The site that you want to add the user as a notable</param>
        /// <param name="policy">The policy the user is to be validated against</param>
        /// <param name="cookie">Output value for the users cookie</param>
        /// <param name="secureCookie">Output value for the users secure cookie</param>
        /// <param name="identityUserID">Output value for the new users Identity UserID</param>
        /// <param name="dnaUserID">Output value for the new users DNA UserID</param>
        /// <returns>True if they were created ok, false if not</returns>
        public static bool CreateNewIdentityEditorUser(string userName, string password, string dateOfBirth, string email, string displayName, int siteid, IdentityPolicies policy, out Cookie cookie, out Cookie secureCookie, out int identityUserID, out int dnaUserID)
        {
            dnaUserID = 0;
            if (CreateNewIdentityNormalUser(userName, password, dateOfBirth, email, displayName, true, policy, true, out cookie, out secureCookie, out identityUserID, out dnaUserID))
            {
                if (dnaUserID > 0)
                {
                    return AddUserToGroupInDatabase(dnaUserID, "editor", siteid);
                }
            }
            return false;
        }

        /// <summary>
        /// Helper method for creating a new normal Identity user on the fly
        /// </summary>
        /// <param name="userName">The name you want the new user to have</param>
        /// <param name="password">The password for the account</param>
        /// <param name="dateOfBirth">The date of birth for the account. Format - "1989-12-31"</param>
        /// <param name="email">The email for the account</param>
        /// <param name="displayName">The display name for the account</param>
        /// <param name="siteid">The site that you want to add the user as a notable</param>
        /// <param name="policy">The policy the user is to be validated against</param>
        /// <param name="cookie">Output value for the users cookie</param>
        /// <param name="secureCookie">Output value for the users secure cookie</param>
        /// <param name="identityUserID">Output value for the new users Identity UserID</param>
        /// <param name="dnaUserID">Output value for the new users DNA UserID</param>
        /// <returns>True if they were created ok, false if not</returns>
        public static bool CreateNewIdentityModeratorUser(string userName, string password, string dateOfBirth, string email, string displayName, int siteid, IdentityPolicies policy, out Cookie cookie, out Cookie secureCookie, out int identityUserID, out int dnaUserID)
        {
            dnaUserID = 0;
            if (CreateNewIdentityNormalUser(userName, password, dateOfBirth, email, displayName, true, policy, true, out cookie, out secureCookie, out identityUserID, out dnaUserID))
            {
                if (dnaUserID > 0)
                {
                    return AddUserToGroupInDatabase(dnaUserID, "moderator", siteid);
                }
            }
            return false;
        }

        /// <summary>
        /// Helper method for creating a new normal Identity user on the fly
        /// </summary>
        /// <param name="userName">The name you want the new user to have</param>
        /// <param name="password">The password for the account</param>
        /// <param name="dateOfBirth">The date of birth for the account. Format - "1989-12-31"</param>
        /// <param name="email">The email for the account</param>
        /// <param name="displayName">The display name for the account</param>
        /// <param name="siteid">The site that you want to add the user as a notable</param>
        /// <param name="policy">The policy the user is to be validated against</param>
        /// <param name="cookie">Output value for the users cookie</param>
        /// <param name="secureCookie">Output value for the users secure cookie</param>
        /// <param name="identityUserID">Output value for the new users Identity UserID</param>
        /// <param name="dnaUserID">Output value for the new users DNA UserID</param>
        /// <returns>True if they were created ok, false if not</returns>
        public static bool CreateNewIdentityNotableUser(string userName, string password, string dateOfBirth, string email, string displayName, int siteid, IdentityPolicies policy, out Cookie cookie, out Cookie secureCookie, out int identityUserID, out int dnaUserID)
        {
            dnaUserID = 0;
            if (CreateNewIdentityNormalUser(userName, password, dateOfBirth, email, displayName, true, policy, true, out cookie, out secureCookie, out identityUserID, out dnaUserID))
            {
                if (dnaUserID > 0)
                {
                    return AddUserToGroupInDatabase(dnaUserID, "Notables", siteid);
                }
            }
            return false;
        }

        /// <summary>
        /// Creates the user in the database with the given details
        /// </summary>
        /// <param name="userName">The username of the user</param>
        /// <param name="email">The users email</param>
        /// <param name="displayName">The users display name</param>
        /// <param name="userIdentityID">The users Identity UserID</param>
        /// <returns>The new DNA UserID</returns>
        private static int CreateUserInDatabase(string userName, string email, string displayName, int userIdentityID)
        {
            int dnaUserID = 0;
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "EXEC dbo.createnewuserfromidentityid " + userIdentityID.ToString() + ",0,'" + userName + "','" + email + "',1,null,null";//,'" + displayName + "'";
                reader.ExecuteDEBUGONLY(sql);
                if (reader.Read())
                {
                    dnaUserID = reader.GetInt32NullAsZero("userid");
                }
            }
            return dnaUserID;
        }

        /// <summary>
        /// Sets the given user to be a superuser in the database
        /// </summary>
        /// <param name="dnaUserID">The userd DNA UserID</param>
        public static void SetUserAsSuperUserInDataBase(int dnaUserID)
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "UPDATE dbo.Users SET Status = 2 WHERE UserID = " + dnaUserID.ToString();
                reader.ExecuteDEBUGONLY(sql);
            }
        }

        /// <summary>
        /// Adds the given dna user to the given group for a given site in the database
        /// </summary>
        /// <param name="dnaUserID">The dnaUserID of the user you want to add to the group</param>
        /// <param name="groupname">The name of the greoup you want to add the user to</param>
        /// <param name="siteID">The siteid of the site you want to add them to</param>
        public static bool AddUserToGroupInDatabase(int dnaUserID, string groupname, int siteID)
        {
            using (IDnaDataReader reader = DnaMockery.CreateDatabaseInputContext().CreateDnaDataReader(""))
            {
                string sql = "SELECT GroupID FROM dbo.Groups WHERE Name = '" + groupname + "'";
                reader.ExecuteDEBUGONLY(sql);
                if (reader.Read())
                {
                    int groupID = reader.GetInt32NullAsZero("groupid");
                    if (groupID > 0)
                    {
                        sql = "INSERT INTO dbo.GroupMembers SELECT UserID = " + dnaUserID.ToString() + ",'" + groupID + "'," + siteID.ToString();
                        reader.ExecuteDEBUGONLY(sql);
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Helper method for deleting a test Identity User Account
        /// </summary>
        /// <param name="cookie">The users cookie</param>
        /// <param name="userName">The users loginname (Not displayname)</param>
        /// <returns>True if the account was deleted ok, false if not</returns>
        public static bool DeleteIdentityUser(Cookie cookie, string userName)
        {
            Dictionary<string, string> param = new Dictionary<string, string>();
            List<Cookie> cookies = new List<Cookie>();
            cookies.Add(cookie);
            param.Add("hard_delete", "1");
            HttpWebResponse r = TestUserCreator.CallIdentityRestAPI("/users/" + userName, param, cookies, TestUserCreator.RequestVerb.DELETE);
            if (r.StatusCode != HttpStatusCode.NoContent)
            {
                Assert.Fail("Failed to delete identity user! Status code = " + r.StatusCode.ToString());
                r.Close();
                return false;
            }
            r.Close();
            return true;
        }

        /// <summary>
        /// Sets a given DNA attribute with a given value in Identity
        /// </summary>
        /// <param name="loginName">The login name for the user you want to set attribute for</param>
        /// <param name="cookie">The users cookie</param>
        /// <param name="attributeName">The name of the attribute you want to change</param>
        /// <param name="value">The value you want to set it to</param>
        /// <returns>True if set ok, false if not</returns>
        public static bool SetDnaAttribute(string loginName, string cookie, DnaAttributeNames attributeName, string value)
        {
            List<Cookie> cookies = new List<Cookie>();
            cookies.Add(new Cookie("IDENTITY", cookie, "/", "api.stage.bbc.co.uk"));
            Dictionary<string, string> reqParams = new Dictionary<string, string>();

            string identityAttrib = "";
            if (attributeName == DnaAttributeNames.AgreedTermsAndConditionsAdult)
            {
                identityAttrib = _wrHouseRulesAdults;
            }
            else if (attributeName == DnaAttributeNames.AgreedTermsAndConditionsKids)
            {
                identityAttrib = _wrHouseRulesKids;
            }
            else if (attributeName == DnaAttributeNames.AgreedTermsAndConditionsOver13)
            {
                identityAttrib = _wrHouseRulesOver13;
            }
            else if (attributeName == DnaAttributeNames.AgreedTermsAndConditionsSchools)
            {
                identityAttrib = _wrHouseRulesSchools;
            }
            else if (attributeName == DnaAttributeNames.UnderAgeRangeCheck)
            {
                identityAttrib = _wrUnderAgeRangecheck;
            }

            reqParams.Add(identityAttrib, value);
            HttpWebResponse response = CallIdentityRestAPI(string.Format("/users/{0}/applications/dna/attributes", loginName), reqParams, cookies, RequestVerb.PUT);
            bool ok = true;
            if (response.StatusCode != HttpStatusCode.Accepted)
            {
                Assert.Fail("Failed to set the users attribute : " + identityAttrib + " with value : " + value);
                ok = false;
            }
            response.Close();
            return ok;
        }

        /// <summary>
        /// Sets a users appnamespaced attrbiute
        /// </summary>
        /// <param name="loginName">The users login name</param>
        /// <param name="cookie">The users cookie</param>
        /// <param name="attributeName">The name of the attribute to set</param>
        /// <param name="value">The value of the attribute</param>
        /// <param name="appNameSpace">The appnamespace in which the attribute belongs</param>
        /// <returns></returns>
        public static bool SetAppNamedSpacedAttribute(string loginName, string cookie, string attributeName, string value, string appNameSpace)
        {
            List<Cookie> cookies = new List<Cookie>();
            cookies.Add(new Cookie("IDENTITY", cookie, "/", "api.stage.bbc.co.uk"));
            Dictionary<string, string> reqParams = new Dictionary<string, string>();
            reqParams.Add(attributeName, value);

            HttpWebResponse response = CallIdentityRestAPI(string.Format("/users/{0}/applications/{1}/attributes", loginName, appNameSpace), reqParams, cookies, RequestVerb.PUT);
            bool ok = true;
            if (response.StatusCode != HttpStatusCode.Accepted)
            {
                Assert.Fail("Failed to set the users app(" + appNameSpace + ") name spaced attribute : " + attributeName + " with value : " + value);
                ok = false;
            }
            response.Close();
            return ok;
        }

        /// <summary>
        /// Sets a given core Identity attribute with a given value in Identity
        /// </summary>
        /// <param name="loginName">The login name for the user you want to set attribute for</param>
        /// <param name="cookie">The users cookie</param>
        /// <param name="attributeName">The name of the attribute you want to change</param>
        /// <param name="value">The value you want to set it to</param>
        /// <returns>True if set ok, false if not</returns>
        public static bool SetIdentityAttribute(string loginName, string cookie, AttributeNames attributeName, string value)
        {
            List<Cookie> cookies = new List<Cookie>();
            cookies.Add(new Cookie("IDENTITY", cookie, "/", "api.stage.bbc.co.uk"));
            Dictionary<string,string> reqParams = new Dictionary<string,string>();

            string identityAttrib = "";
            if (attributeName == AttributeNames.UserName)
            {
                identityAttrib = _wrUserName;
            }
            else if (attributeName == AttributeNames.DisplayName)
            {
                identityAttrib = _wrdisplayName;
            }
            else if (attributeName == AttributeNames.Email)
            {
                identityAttrib = _wremail;
            }
            else if (attributeName == AttributeNames.LegacySSOID)
            {
                identityAttrib = _wrLegacySSOID;
            }
            else if (attributeName == AttributeNames.FirstName)
            {
                identityAttrib = _wrFirstName;
            }
            else if (attributeName == AttributeNames.LastName)
            {
                identityAttrib = _wrLastName;
            }
            else if (attributeName == AttributeNames.GuardianAgreedTermsAndConditions)
            {
                identityAttrib = _wrGuardianAcceptedFlag;
            }
            else if (attributeName == AttributeNames.GuardianEmail)
            {
                identityAttrib = _wrGuardianEmail;
            }
            else if (attributeName == AttributeNames.GuardianEmailConfirmed)
            {
                identityAttrib = _wrGuardianEmailConfirmed;
            }
            else
            {
                return false;
            }

            reqParams.Add(identityAttrib ,value);
            HttpWebResponse response = CallIdentityRestAPI(string.Format("users/{0}/attributes", loginName), reqParams, cookies, RequestVerb.PUT);
            bool ok = true;
            if (response.StatusCode != HttpStatusCode.Accepted)
            {
                Assert.Fail("Failed to set the users attribute : " + identityAttrib + " with value : " + value);
                ok = false;
            }
            response.Close();
            return ok;
        }

        /// <summary>
        /// Helper method for calling identity
        /// </summary>
        /// <param name="identityRestCall">The call you want to make</param>
        /// <param name="postParams">The params to be sent with this request</param>
        /// <param name="cookies">any cookies you want to add to the request</param>
        /// <param name="verb">The type of request you want to make</param>
        /// <returns>http response for the call</returns>
        static public HttpWebResponse CallIdentityRestAPI(string identityRestCall, Dictionary<string, string> postParams, List<Cookie> cookies, RequestVerb verb)
        {
            // Setup the params 
            string urlParams = "";
            if (postParams != null)
            {
                foreach (KeyValuePair<string, string> s in postParams)
                {
                    if (urlParams.Length > 0)
                    {
                        urlParams += "&";
                    }
                    urlParams += s.Key + "=" + s.Value;
                }
            }

            // Create the full URL
            string fullURI = _IdentityServerBaseUri;
            if (!identityRestCall.StartsWith("/"))
            {
                fullURI += "/" + identityRestCall;
            }
            else
            {
                fullURI += identityRestCall;
            }

            // Console out the params we're using
            Console.WriteLine();
            Console.WriteLine("Identity URL : " + fullURI);
            Console.WriteLine("Params : " + urlParams);

            // If we're not doing a post request, then add the params to the url
            if (verb == RequestVerb.GET)
            {
                fullURI += "?" + urlParams;
            }

            Uri URL = new Uri(fullURI);

            // Create the new request object
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

            switch (verb)
            {
                case RequestVerb.DELETE:
                    webRequest.Method = "DELETE";
                    break;
                case RequestVerb.PUT:
                    webRequest.Method = "PUT";
                    break;
                case RequestVerb.POST:
                    webRequest.Method = "POST";
                    break;
                default:
                    webRequest.Method = "GET";
                    break;
            }
            Console.WriteLine("Method : " + webRequest.Method);
            
            webRequest.Accept = "application/xml";
            webRequest.Timeout = 1000 * 400;
            webRequest.Proxy = new WebProxy(_proxy);
            webRequest.CookieContainer = new CookieContainer();
            if (cookies != null)
            {
                Console.WriteLine("Cookies...");
                foreach (Cookie c in cookies)
                {
                    try
                    {
                        webRequest.CookieContainer.Add(c);
                        //webRequest.Headers.Add("Cookie",c.Name + "=" + c.Value);
                        Console.WriteLine(c.Name + " - " + c.Value);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
            }

            // Add the cert for the request
            X509Store store = new X509Store("My", StoreLocation.LocalMachine);
            store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
            X509Certificate _certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _webServiceCertificationName, false)[0];
            webRequest.ClientCertificates.Add(_certificate);

            // Now setup the correct method depending on the post flag
            if (verb != RequestVerb.GET)
            {
                webRequest.ContentType = "application/x-www-form-urlencoded";

                // Write the params to the body of the request
                ASCIIEncoding encoding = new ASCIIEncoding();
                byte[] bytes = encoding.GetBytes(urlParams);
                webRequest.ContentLength = bytes.Length;
                
                try
                {
                    Stream requestBody = webRequest.GetRequestStream();
                    requestBody.Write(bytes, 0, bytes.Length);
                    requestBody.Close();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Failed to get read stream - " + ex.Message);
                    throw (ex);
                }
            }

            // Now do the request itself.
            HttpWebResponse response = null;
            try
            {
                response = (HttpWebResponse)webRequest.GetResponse();
                if (response != null)
                {
                    Console.WriteLine("Response code : " + response.StatusCode.ToString());
                }
                else
                {
                    Console.WriteLine("No Response object");
                }
            }
            catch (WebException ex)
            {
                _error = ex.Message + "\n";
                if (ex.Response != null)
                {
                    StreamReader reader = new StreamReader(ex.Response.GetResponseStream(), Encoding.UTF8);
                    _error += reader.ReadToEnd();
                }
                Console.WriteLine(_error);
                Assert.Fail("Failed calling Identity Rest Interface with '" + identityRestCall + "' request.");
            }

            Console.WriteLine("Response cookies...");
            foreach (Cookie c in response.Cookies)
            {
                Console.WriteLine(c.Name + " - " + c.Value);
            }

            Console.WriteLine();
            return response;
        }
    }
}
