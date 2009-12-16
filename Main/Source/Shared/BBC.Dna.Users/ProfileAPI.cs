using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using System.Data;
using System.IO;
using System.Security.Cryptography;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Configuration;
using MySql.Data.MySqlClient;
using DnaIdentityWebServiceProxy;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// The ProfileAPI class that is used to connect to the SSO Database to check the users details
    /// </summary>
    public partial class ProfileAPI : IDnaIdentityWebServiceProxy, IDisposable
    {
        // Cookie Encryption fields
        private const int _minCookieLength = 66;
        static private string _encryptionKey1;
        static private string _encryptionKey2;

        // Service info
        private SSOService _ssoService = null;

        // User info
        private SSOUser _ssoUser = null;

        /// <summary>
        /// This property tell the caller that it uses profile api and sso
        /// </summary>
        public SignInSystem SignInSystemType
        {
            get { return SignInSystem.SSO; }
        }

        /// <summary>
        /// Basic Is Service Set property
        /// </summary>
        public bool IsServiceSet
        {
            get { return _ssoService.IsServiceSet; }
        }

        /// <summary>
        /// Basic Is user logged in property
        /// </summary>
        public bool IsUserLoggedIn
        {
            get { return GetIsUserLoggedIn(); }
        }

        /// <summary>
        /// Basic Is user signed in property
        /// </summary>
        public bool IsUserSignedIn
        {
            get { return _ssoUser.IsUsersignedIn; }
        }

        /// <summary>
        /// Login name property (distinct from the DNA username).
        /// </summary>
        public string LoginName
        {
            get { return _ssoUser.SSOUserName; }
        }

        /// <summary>
        /// User Id property
        /// </summary>
        public int UserID
        {
            get { return _ssoUser.UserID; }
        }

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="ProfileAPIReadConnectionDetails">The connection details for the profileAPI to connect with</param>
        /// <exception cref="ProfileAPIConnectionDetailsException">Cannot find one of the connection details needed</exception>
        public ProfileAPI(string ProfileAPIReadConnectionDetails)
        {
            _ssoService = new SSOService();
            _ssoUser = new SSOUser();
            InitilialiseStandardSql();
            _readConfig = ProfileAPIReadConnectionDetails;
            _writeConfig = ProfileAPIReadConnectionDetails;// ProfileAPIWriteConnectionDetails;
        }

        /// <summary>
        /// The dispose function
        /// </summary>
        public void Dispose()
        {
            // Make sure that the connections are closed
            CloseConnections();
        }

        /// <summary>
        /// Initialises the connection details for the web service
        /// </summary>
        /// <param name="connectionDetails">The url for the webservice</param>
        /// <param name="clientIPAddress">The IP address of the calling user</param>
        /// <returns>True if initialised, false if something went wrong</returns>
        public bool Initialise(string connectionDetails, string clientIPAddress)
        {
            return false;
        }

        private void SetLastError(string error)
        {
            // This will put the error into the logs
        }

        /// <summary>
        /// Sets the current service that you want to use
        /// </summary>
        /// <param name="serviceName">The name of the service that you want to use</param>
        /// <exception cref="ProfileAPIDataReaderException">The datareader was null or empty of results</exception>
        public void SetService(string serviceName)
        {
            // First of all, make sure that service info is initialised
            _ssoService.ResetDetails();

            // Get the read connection and check to make sure that the service is a valid one.
            _ssoService.ServiceName = serviceName.ToLower();

            // Set the service and get the datareder
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlGetSetService))
            {
                if (reader == null)
                {
                    // Problems! Reset the current service value and return
                    _ssoService.ResetDetails();
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sqlGetSetService");
                }

                // Check to see if we got anything back
                if (!reader.HasRows || !reader.Read())
                {
                    // Nothing found. Not a valid service name
                    _ssoService.ResetDetails();
                    throw new ProfileAPIDataReaderException("Failed to get results for sqlGetSetService");
                }

                // Get the service details
                _ssoService.ServiceID = reader.GetInt32(reader.GetOrdinal("id"));
                _ssoService.ServiceName = reader.GetString(reader.GetOrdinal("service_name"));
                _ssoService.MinAge = reader.GetInt32(reader.GetOrdinal("min_age"));
                _ssoService.MaxAge = reader.GetInt32(reader.GetOrdinal("max_age"));
                _ssoService.IsServiceSet = true;
            }
        }

        /// <summary>
        /// Helper function for getting a services min and max age
        /// </summary>
        /// <param name="serviceName">The urlname of the service you wnat to get the inof for</param>
        /// <param name="minAge">A reference to the field that will take the min age for the service</param>
        /// <param name="maxAge">A reference to the field that will take the max age for the service</param>
        /// <exception cref="ProfileAPIDataReaderException">Thrown if there was a sql reader problem</exception>
        public void GetServiceMinMaxAge(string serviceName, ref int minAge, ref int maxAge)
        {
            // First set the service
            SetService(serviceName);

            // Now set the values from the service info
            minAge = _ssoService.MinAge;
            maxAge = _ssoService.MaxAge;
        }

        /// <summary>
        /// Set the current user via their cookie value
        /// </summary>
        /// <param name="userCookie">The users cookie</param>
        /// <returns>True if they were set corrctly, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">The service was not set</exception>
        /// <exception cref="ProfileAPIDataReaderException">One of the Sql requests returned a null reader or no results</exception>
        public bool TrySetUserViaCookie(string userCookie)
        {
            // First of all, amke sure that the user info is initialised
            _ssoUser.ResetAllDetails();

            // Check to make sure that the service has been set
            if (!_ssoService.IsServiceSet)
            {
                // We need both of these before we can do anything!
                throw new ProfileAPIServiceException("Service not set");
            }

            // Check to make sure that we've been given a cookie!
            if (userCookie.Length < _minCookieLength)
            {
                // Not long enough! Not a valid cookie to process
                SetLastError("ProfileAPICookieException(Cookie does not meet minimum length criteria)");
                return _ssoUser.IsUsersignedIn;
            }

            // Set the userCookie to one given
            _ssoUser.Usercookie = userCookie;

            // Now Decypher the cookie to chack that it is valid
            string cookieValidationMark = String.Empty;
            try
            {
                // Decypher the cookie with the validation mark
                _ssoUser.IsUsersignedIn = DecypherCookie(ref cookieValidationMark);

                // Now validate the user via the database
                _ssoUser.IsUsersignedIn = _ssoUser.IsUsersignedIn && ValidateUser(cookieValidationMark);
            }
            catch (Exception)
            {
                // Not valid
                _ssoUser.ResetSignedInDetails();
                throw;
            }

            // User is now signed in
            return _ssoUser.IsUsersignedIn;
        }

        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="userName">The username you want to sign in with</param>
        /// <param name="password">The password for the user</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaUserNamePassword(string userName, string password)
        {
            // First of all, amke sure that the user info is initialised
            _ssoUser.ResetAllDetails();

            // Check to make sure that the service has been set
            if (!_ssoService.IsServiceSet)
            {
                // We need both of these before we can do anything!
                throw new ProfileAPIServiceException("Service not set");
            }

            try
            {
                _ssoUser.IsUsersignedIn = TrySetUserViaUserNamePassword(userName, password);
            }
            catch (Exception)
            {
                // Not valid
                _ssoUser.ResetSignedInDetails();
                throw;
            }

            // User is now signed in
            return _ssoUser.IsUsersignedIn;
        }
        
        /// <summary>
        /// Tries to set the user using their username and password
        /// </summary>
        /// <param name="cookie">The cookie value for the user</param>
        /// <param name="userName">The name of the user you are trying to set</param>
        /// <returns>True if user was set correctly, false if not</returns>
        public bool TrySetUserViaCookieAndUserName(string cookie, string userName)
        {
            return TrySetUserViaCookie(cookie);
        }

        /// <summary>
        /// Validates the user cookie
        /// </summary>
        /// <returns>True if they validated, false if not</returns>
        /// <param name="cookieValidationMark">The cookie validation flag taken from the cookie</param>
        private bool ValidateUser(string cookieValidationMark)
        {
            // Now get the details for the user
            using (MySqlDataReader reader = GetDataReaderForReadSql(SqlSelUserByCudId))
            {
                // Read the data and check for problems
                if (reader == null)
                {
                    // Problems!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for SqlSelUserByCudId");
                }

                // Check to see if we actually found the users details
                if (!reader.HasRows || !reader.Read())
                {
                    // Failed to find the user details in the database
                    SetLastError("ProfileAPIUserException(No details for user)");
                    return false;
                }

                // Check the cookie validation flag. Make sure it matches!
                bool matchingCookieMarks = reader.GetString(reader.GetOrdinal("cookie_validation_mark")).CompareTo(cookieValidationMark) == 0;
                if (!matchingCookieMarks)
                {
                    // Cookie validation marks don't match!
                    SetLastError("ProfileAPICookieException(Cookie validation mark does not match the one in the database)");
                    return false;
                }

                // Now make sure the users account is valid
                bool userRemoved = reader.GetString(reader.GetOrdinal("user_status_code")).ToUpper().CompareTo("REMOVED") == 0;
                if (userRemoved)
                {
                    // Users acoount has been cancelled!
                    SetLastError("ProfileAPIUserException(User account has been removed)");
                    return false;
                }

                // Now get the users details
                _ssoUser.UserID = reader.GetInt32(reader.GetOrdinal("id"));
                return true;
            }
        }

        /// <summary>
        /// Cookie decrypting and validation
        /// </summary>
        /// <returns>True if we decyphered cookie and it amtches the one passed in via the URL, false if not</returns>
        /// <param name="cookieValidationMark">The cookie validation mark from the current cookie</param>
        private bool DecypherCookie(ref string cookieValidationMark)
        {
            // First seperate the user signiture and key
            string signiture = String.Empty;
            char rememberUser = ' ';

            // Go through the first 64 chars
            for (int i = 0; i < _ssoUser.Usercookie.Length && cookieValidationMark.Length == 0; i += 2)
            {
                // The first 64 chars are the cudid and the signiture
                if (i < 64)
                {
                    signiture += _ssoUser.Usercookie[i];
                    _ssoUser.CudID += _ssoUser.Usercookie[i + 1];
                }
                else
                {
                    // Get the cookie validation mark and the remember user flag
                    rememberUser = _ssoUser.Usercookie[i];
                    cookieValidationMark = _ssoUser.Usercookie.Substring(i + 1);
                }
            }

            // Now get the cookie value by hash decyphering what's given
            string recalcCookie = ValidateCookie(rememberUser, cookieValidationMark);

            // Check to make sure that the re-calculated cookie matches the one supplied
            if (_ssoUser.Usercookie != recalcCookie)
            {
                _ssoUser.Usercookie = String.Empty;
                _ssoUser.CudID = String.Empty;
                SetLastError("ProfileAPICookieException(Cookie is invalid)");
                return false;
            }

            // Decyphered ok
            return true;
        }

        /// <summary>
        /// Calculates and returns a cookie for the current user
        /// </summary>
        /// <param name="remeberUser">A flag that states whether to remember the user</param>
        /// <param name="cookieValidationMark">Validation mark taken from the SSO2_UID</param>
        /// <returns>The cookie value for the current user and settings, Empty string if something went wrong</returns>
        private string ValidateCookie(char remeberUser, string cookieValidationMark)
        {
            // Check to make sure that we've been given a valid cudid
            if (_ssoUser.CudID.Length != 32)
            {
                // Invalid _ssoUser.CudID
                return String.Empty;
            }

            // Check to see if we've already got the encryption keys from the database.
            if (_encryptionKey1 == null || _encryptionKey2 == null)
            {
                // Get the encryption keys from the database. CAN WE KEEP THESE LOCAL AFTER WE GET THEM SO WE DON@T NEED TO DO THE EXTRA CALL!
                using (MySqlDataReader reader = GetDataReaderForReadSql(sqlGetSystemKeys))
                {
                    if (reader == null || !reader.HasRows)
                    {
                        // Failed to get the keys!
                        throw new ProfileAPIDataReaderException("Failed to get datareader for sqlGetSystemKeys");
                    }

                    // Read the results
                    reader.Read();
                    _encryptionKey1 = reader.GetString(0);
                    _encryptionKey2 = reader.GetString(1);
                }
            }

            // Now hash the values
            string cudIdBoolMark = _ssoUser.CudID;
            cudIdBoolMark += remeberUser;
            cudIdBoolMark += cookieValidationMark;
            string cudIdBoolMarkKey = cudIdBoolMark + _encryptionKey1;

            // This is one implementation of the abstract class MD5.
            // Create a new instance of the MD5CryptoServiceProvider object.
            MD5 md5Hasher = MD5.Create();

            // Convert the input string to a byte array and compute the hash.
            byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(cudIdBoolMarkKey));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder signiture1 = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                signiture1.Append(data[i].ToString("x2"));
            }

            // Convert the input string to a byte array and compute the hash.
            data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(_encryptionKey2 + signiture1));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            StringBuilder signiture2 = new StringBuilder();

            // Loop through each byte of the hashed data 
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                signiture2.Append(data[i].ToString("x2"));
            }

            // Now interleave the result with the cookieValue
            StringBuilder interleaved = new StringBuilder();
            for (int i = 0; i < 33; i++)
            {
                // Interleave the signiture we just created with the users cuid and then put the remeber me and validation mark on the end
                if (i < 32)
                {
                    interleaved.Append(signiture2[i]);
                    interleaved.Append(_ssoUser.CudID[i]);
                }
                else
                {
                    interleaved.Append(remeberUser);
                    interleaved.Append(cookieValidationMark);
                }
            }

            // Return the cookie that we've just generated
            return interleaved.ToString();
        }

        /// <summary>
        /// Checks the database to see if the user is currently logged in (NOT signed in!)
        /// </summary>
        /// <returns>true if logged in, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader, was empty or failed to read the results</exception>
        /// <exception cref="ProfileAPIUserException">Thrown if the user isn't signed in</exception>
        private bool GetIsUserLoggedIn()
        {
            // Check to make sure the service is set
            if (!_ssoService.IsServiceSet)
            {
                // Problems
                _ssoUser.ResetLoggedInDetails();
                throw new ProfileAPIServiceException("Service not set");
            }

            // Check to make sure that user is at least signed in
            if (!_ssoUser.IsUsersignedIn)
            {
                // Should be signed in before logging in
                throw new ProfileAPIUserException("User must be signed in before logging in");
            }

            // Check to see if the user is already logged in
            if (_ssoUser.IsUserLoggedIn)
            {
                // Already logged in!
                return true;
            }

            // Get a new read connection
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelUserStatus))
            {
                if (reader == null)
                {
                    // Not good!
                    _ssoUser.ResetLoggedInDetails();
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sqlSelUserStatus");
                }

                // Check to see if we got anything back
                if (!reader.HasRows || !reader.Read())
                {
                    // Problems
                    _ssoUser.ResetLoggedInDetails();
                    return false;
                }

                // Get the values required
                _ssoUser.SSOUserName = reader.GetString(reader.GetOrdinal("user_name"));
                _ssoUser.IsUsersAccountValid = (reader.GetString(reader.GetOrdinal("user_status_code")).CompareTo("VALID") == 0);
                _ssoUser.HasUserAgreedGlobalTerms = reader.GetBoolean(reader.GetOrdinal("global_agreement_accepted_flag"));
                _ssoUser.IsUserLoggedIn = GetBoolResult(reader, "loggedin_flag", false);
                _ssoUser.HasUserAgreedTermsForService = GetBoolResult(reader, "service_agreement_accepted_flag", false);
            }

            // Everything went ok.
            return _ssoUser.IsUserLoggedIn;
        }

        /// <summary>
        /// Logs the user out of the given service
        /// </summary>
        /// <exception cref="ProfileAPIDataReaderException">Thrown if there was a database problem</exception>
        public void LogoutUser()
        {
            // Check to see if they are already logged out
            if (!_ssoUser.IsUserLoggedIn)
            {
                // Nothing to do
                return;
            }

            // Now log them out
            ExecuteTransactionalWriteSqlCommand(sqlSetUserLoggedOutForService);
        }

        /// <summary>
        /// Sets the server cookie for testing
        /// </summary>
        /// <param name="cookie">The cookie for the identity server</param>
        public void SetIdentityServerCookie(Cookie cookie)
        {
            // do nothing
            return;
        }

        /// <summary>
        /// Logs the current user into the current service
        /// </summary>
        /// <returns>True if they were logged in, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">Thrown when the service is not set</exception>
        /// <exception cref="ProfileAPIUserException">Thrown for one of the following reasons...\n
        /// Not signed in.\n
        /// Not in the age range for the service.\n
        /// Not registered for the service.\n
        /// Failed to fill in all mandatory service attribute.\n
        /// One or more attribute have not been validated.\n
        /// Password has been blocked.\n
        /// Has been banned for the site.</exception>
        /// <exception cref="ProfileAPIDataReaderException">Thrown if there was a database problem</exception>
        public bool LoginUser()
        {
            // Check to see if they are already logged in for this service
            if (GetIsUserLoggedIn())
            {
                // Already logged in!
                return true;
            }

            // First check to make sure that the user is allowed to log into the service
            if (!CanUserLogIntoService())
            {
                // The user is not allowed to log into this service for some reason
                return false;
            }

            // Now update the database to set them as logged in
            ExecuteTransactionalWriteSqlCommand(sqlSetUserLoggedInForService);

            // We logged the user in
            return true;
        }

        /// <summary>
        /// Checks to see if the user is able to log into the current service
        /// </summary>
        /// <returns>True if they can, false if not</returns>
        public bool CanUserLogIntoService()
        {
            // Make sure that the service has been set
            if (!_ssoService.IsServiceSet || _ssoService.ServiceID == 0 || _ssoService.ServiceName.Length == 0)
            {
                throw new ProfileAPIServiceException("Service not set");
            }

            // Now make sure that the user is signed in
            if (!_ssoUser.IsUsersignedIn)
            {
                throw new ProfileAPIUserException("User must be signed in before logging in");
            }

            // Now see if the user is able to log into the service
            bool canLogIn = IsUserRegisteredWithService();

            // See if the user is within the age range for the service
            canLogIn = canLogIn && IsUserInAgeRangeForService();

            // See if the user is banned
            canLogIn = canLogIn && !IsUserBannedforService();

            // Check to see if the users password has been blocked
            canLogIn = canLogIn && !IsUserPasswordBlocked();

            // Check to see if the user is required to change their password
            canLogIn = canLogIn && !DoesUserNeedToChangePassword();

            // Check to make sure that the user has set all the manditory attributes for the current service
            canLogIn = canLogIn && AreManditoryServiceAttributesSet();

            // Check to see if the users details have all been validate dfor the current sewrvice
            canLogIn = canLogIn && AreUsersDetailsValidatedForService();

            // Return the verdict
            return canLogIn;
        }

        /// <summary>
        /// Checks to see if the current user can log into the given service
        /// </summary>
        /// <returns>True if they are register, false if not</returns>
        private bool IsUserRegisteredWithService()
        {
            // Make sure that the service has been set
            if (!_ssoService.IsServiceSet || _ssoService.ServiceID == 0 || _ssoService.ServiceName.Length == 0)
            {
                throw new ProfileAPIServiceException("Service not set");
            }

            // Check to see if the current user is registered with the service
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelUserRegisteredService))
            {
                if (reader == null)
                {
                    // Not good!
                    _ssoUser.HasUserAgreedTermsForService = false;
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sqlSelUserRegisteredService");
                }

                // Check to see if we got any data back. If we didn't, it means that the user has not registered with the service and cannot log into the service
                _ssoUser.HasUserAgreedTermsForService = (reader.HasRows && reader.Read());
            }
            return _ssoUser.HasUserAgreedTermsForService;
        }

        /// <summary>
        /// Check to see if the users age is within the services age range
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool IsUserInAgeRangeForService()
        {
            // See if the user can bypass the age check
            string bypassAge = GetUserAttributeOrNullIfNotExists("bypass_age_check_@");
            if (bypassAge != null && Convert.ToBoolean(bypassAge))
            {
                // The user can bypass the age check
                return true;
            }

            // Get the users age and check it against the service min / max range
            string userAge = GetUserAttributeOrNullIfNotExists("age");
            if (userAge == null)
            {
                return true;
            }

            // Now check to see if they are too old or too young
            int age = Convert.ToInt32(userAge);
            if (age < _ssoService.MinAge)
            {
                // The user is too young to log into this service
                return false;
            }
            if (age > _ssoService.MaxAge)
            {
                // The user is too old for the service!
                return false;
            }

            // If we got here then the user is within the age range for the sevice
            return true;
        }

        /// <summary>
        /// Checks to make sure the user has filled in all the mandatory attribute for the current service.
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool AreManditoryServiceAttributesSet()
        {
            // Check the database to make sure that the user has filled in all the needed details
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelMandatoryProfile))
            {
                if (reader == null)
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sSqlSelValidationProfile");
                }

                // Check to see if we have any results
                if (reader.HasRows)
                {
                    // Check all the results
                    while (reader.Read())
                    {
                        // Check to make sure it's not null and not empty
                        string attribute = reader.GetString(reader.GetOrdinal("attribute_value"));
                        if (attribute == null || attribute.Length == 0)
                        {
                            // Mandatory attribute not set
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// Check to see if the user has had all the manditory details validated for the current service
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool AreUsersDetailsValidatedForService()
        {
            // Get all the details that the service require to be validated and check to see if they are
            using (MySqlDataReader reader = GetDataReaderForReadSql(sSqlSelValidationProfile))
            {
                if (reader == null)
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sSqlSelValidationProfile");
                }

                // Check to see if we have any results
                if (reader.HasRows)
                {
                    // Check all the results
                    while (reader.Read())
                    {
                        // Check the validation
                        bool validated = reader.GetString(reader.GetOrdinal("validated_flag")).CompareTo("0") == 0;
                        if (validated)
                        {
                            // Not validated!
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// Checks to see if the user has their password blocked. Throws a User password blocked exception
        /// </summary>
        /// <returns>True if it is, false if not</returns>
        /// <exception cref="ProfileAPIUserException">The users password is blocked</exception>
        private bool IsUserPasswordBlocked()
        {
            // Get the users password blocked flag
            string passwordBlocked = GetUserAttributeOrNullIfNotExists("password_block");
            return (passwordBlocked != null && Convert.ToBoolean(passwordBlocked));
        }

        /// <summary>
        /// Checks to see if the user needs to change their password
        /// </summary>
        /// <returns>True if they do, false if not</returns>
        private bool DoesUserNeedToChangePassword()
        {
            // Get the change password flag for the current user
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelMustChangePassword))
            {
                if (reader == null)
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sSqlSelValidationProfile");
                }

                // Check to see if we've got any results
                bool userNeedsToChangePassword = false;
                if (reader.HasRows)
                {
                    // Read the first row
                    if (!reader.Read())
                    {
                        // Failed to read the first row!
                        throw new ProfileAPIDataReaderException("Failed to read data for sSqlSelValidationProfile");
                    }

                    // See if they need to change their password
                    userNeedsToChangePassword = (reader["must_change_password_flag"].ToString() == "1");
                }

                return userNeedsToChangePassword;
            }
        }

        /// <summary>
        /// Checks to make sure that use is not banned for the service or outright
        /// </summary>
        /// <returns>True if they are, false if not</returns>
        private bool IsUserBannedforService()
        {
            // Get the banned status for the user
            string warningLevel = GetUserAttributeOrNullIfNotExists("warning_level_@");
            return (warningLevel != null && warningLevel != "NONE");
        }

        /// <summary>
        /// Function for checking if a given service supports a given attribute
        /// </summary>
        /// <param name="serviceName">The name of the service you want to check against</param>
        /// <param name="attribute">The name of the attribute you want to check for</param>
        /// <returns>True if the attrbite exists, false if not</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader</exception>
        public bool DoesAttributeExistForService(string serviceName, string attribute)
        {
            // Make sure that the service has been set
            if (!_ssoService.IsServiceSet)
            {
                throw new ProfileAPIServiceException("Service not set");
            }

            // Set the requested attribute
            _requestAttribute = attribute.ToLower();
            bool attributeExists = false;

            // Now query the service
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelAttInfo))
            {
                if (reader == null)
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sqlSelAttInfo");
                }

                // Check to see if the requested attribute exists in the result set
                attributeExists = reader.HasRows;
            }

            // Ok, it exists
            return attributeExists;
        }

        /// <summary>
        /// Gets a given user attribute for the current service
        /// </summary>
        /// <param name="attributeName">The name of the attribute that you want to get</param>
        /// <returns>The value if found</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIUserException">The user has not signed in yet</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader, was empty or failed to read the results</exception>
        public string GetUserAttribute(string attributeName)
        {
            // Check to make sure that we're in a state that means we can access the user info
            if (!_ssoService.IsServiceSet)
            {
                // Problems
                throw new ProfileAPIServiceException("Service not set");
            }

            // Make sure that the user is signed in
            if (!_ssoUser.IsUsersignedIn)
            {
                // Not a valid state to be in
                throw new ProfileAPIUserException("Users not signed in");
            }

            // Set the requested attribute
            _requestAttribute = attributeName.ToLower();

            // Get a read connection and get the data
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelUserProfileValue))
            {
                if (reader == null)
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sqlSelUserProfileValue");
                }

                // Check to make sure we actually got a result
                if (!reader.HasRows || !reader.Read())
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to find attribute");
                }

                // Get the value requested and return
                return reader.GetString(reader.GetOrdinal("attribute_value"));
            }
        }

        /// <summary>
        /// Gets the requested attribute for the current user, or null if the attribute does not exist
        /// </summary>
        /// <param name="attributeName">The sttribute that you want to find</param>
        /// <returns>The value of the attribute or null if not found</returns>
        /// <exception cref="ProfileAPIServiceException">The service has not been set</exception>
        /// <exception cref="ProfileAPIUserException">The user has not signed in yet</exception>
        /// <exception cref="ProfileAPIDataReaderException">The Sql request returned a null datareader</exception>
        private string GetUserAttributeOrNullIfNotExists(string attributeName)
        {
            // Check to make sure that we're in a state that means we can access the user info
            if (!_ssoService.IsServiceSet)
            {
                // Problems
                throw new ProfileAPIServiceException("Service not set");
            }

            // Make sure that the user is signed in
            if (!_ssoUser.IsUsersignedIn)
            {
                // Not a valid state to be in
                throw new ProfileAPIUserException("Users not signed in");
            }

            // Set the requested attribute
            _requestAttribute = attributeName.ToLower();

            // Get a read connection and get the data
            using (MySqlDataReader reader = GetDataReaderForReadSql(sqlSelUserProfileValue))
            {
                if (reader == null)
                {
                    // Not good!
                    throw new ProfileAPIDataReaderException("Failed to get datareader for sqlSelUserProfileValue");
                }

                // Check to see if we got any results
                if (!reader.HasRows || !reader.Read())
                {
                    // Nothing found, return null
                    return null;
                }

                // Get the value requested and return
                return GetStringResult(reader, "attribute_value", null);
            }
        }

        /// <summary>
        /// Get the users cookie value
        /// </summary>
        public string GetCookieValue
        {
            get { return _ssoUser.Usercookie; }
        }

        /// <summary>
        /// Gets the last known error
        /// </summary>
        /// <returns>The error message</returns>
        public string GetLastError()
        {
            return "";
        }

        /// <summary>
        /// Gets the current list of all dna policies
        /// </summary>
        /// <returns>The list of dna policies, or null if non found</returns>
        public string[] GetDnaPolicies()
        {
            // This is an Identity only feature, but the class must support the interface.
            return new string[] { };
        }

        /// <summary>
        /// Gets the version number of the Interface
        /// </summary>
        /// <returns>The version number for this Interface</returns>
        public string GetVersion()
        {
            return "1.0.1.6 (ProfileAPI)";
        }
    }
}
