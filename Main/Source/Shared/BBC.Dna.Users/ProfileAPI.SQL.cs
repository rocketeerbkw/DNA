using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Configuration;
using MySql.Data.MySqlClient;

namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// Partical class for the ProfileAPI SQL commands
    /// </summary>
    public partial class ProfileAPI : System.Object
    {
        // Database conntecion fields
        private string _readConfig = String.Empty;
        private string _writeConfig = String.Empty;
        private MySqlConnection _readConnection = null;
        private MySqlConnection _writeConnection = null;
        private string _requestAttribute = String.Empty;
        private Dictionary<string, string> _standardSql = null;

        /// <summary>
        /// Returns the last piece of timing information
        /// </summary>
        /// <returns>The information for the last timed logging</returns>
        public string GetLastTimingInfo()
        {
            return "Not Implemented";
        }

        /// <summary>
        /// This function closes the read connection if it already open
        /// </summary>
        public void CloseConnections()
        {
            // Check to make sure we're got an connection to close
            if (_readConnection != null)
            {
                _readConnection.Close();
            }
            if (_writeConnection != null)
            {
                _writeConnection.Close();
            }
        }

        /// <summary>
        /// Creates a reader for a given sql query
        /// </summary>
        /// <param name="sqlCommand">The sql command you want to execute</param>
        /// <returns>The reader for the sql query</returns>
        private MySqlDataReader GetDataReaderForReadSql(string sqlCommand)
        {
            // Create a connection if we don't have one
            if (_readConnection == null)
            {
                _readConnection = new MySqlConnection(_readConfig);
            }

            // Check to see if the connection is open? If not open it!
            if (_readConnection.State == ConnectionState.Closed)
            {
                _readConnection.Open();
            }

            // Now create the command and execute returning the reader
            using (MySqlCommand command = _readConnection.CreateCommand())
            {
                command.CommandText = sqlCommand;
                return command.ExecuteReader();
            }
        }

        /// <summary>
        /// Executes a given sql command with transactions
        /// </summary>
        /// <param name="sqlCommand">The command you want to execute</param>
        private void ExecuteTransactionalWriteSqlCommand(string sqlCommand)
        {
            // Create a connection if we don't have one
            if (_writeConnection == null)
            {
                _writeConnection = new MySqlConnection(_writeConfig);
            }
            _writeConnection.Open();

            MySqlTransaction transaction = _writeConnection.BeginTransaction();
            using (MySqlCommand command = new MySqlCommand(sqlCommand, _writeConnection, transaction))
            {
                // Execute, Commit and then close the connection
                command.ExecuteNonQuery();
                command.Transaction.Commit();
                _writeConnection.Close();
            }
        }

        /// <summary>
        /// Helper function for getting a bool result from a datareader.
        /// </summary>
        /// <param name="reader">The reader to get the result from</param>
        /// <param name="resultName">The name of the result that you want to get the value for</param>
        /// <param name="valueIfNull">The desired return value if the result is null</param>
        /// <returns>The value of the result OR the valueif null value</returns>
        private bool GetBoolResult(MySqlDataReader reader, string resultName, bool valueIfNull)
        {
            // Check to see if the result is null
            int resultIndex = reader.GetOrdinal(resultName);
            if (reader.IsDBNull(resultIndex))
            {
                // Return the valueIfNull
                return valueIfNull;
            }
            // Return the converted value
            return reader.GetBoolean(resultIndex);
        }

        /// <summary>
        /// Helper function for getting an int result from a datareader.
        /// </summary>
        /// <param name="reader">The reader to get the result from</param>
        /// <param name="resultName">The name of the result that you want to get the value for</param>
        /// <param name="valueIfNull">The desired return value if the result is null</param>
        /// <returns>The value of the result OR the valueif null value</returns>
        private int GetIntResult(MySqlDataReader reader, string resultName, int valueIfNull)
        {
            // Check to see if the result is null
            int resultIndex = reader.GetOrdinal(resultName);
            if (reader.IsDBNull(resultIndex))
            {
                // Return the valueIfNull
                return valueIfNull;
            }
            // Return the converted value
            return reader.GetInt32(resultIndex);
        }

        /// <summary>
        /// Helper function for getting a string result from a datareader.
        /// </summary>
        /// <param name="reader">The reader to get the result from</param>
        /// <param name="resultName">The name of the result that you want to get the value for</param>
        /// <param name="valueIfNull">The desired return value if the result is null</param>
        /// <returns>The value of the result OR the valueif null value</returns>
        private string GetStringResult(MySqlDataReader reader, string resultName, string valueIfNull)
        {
            // Check to see if the result is null
            int resultIndex = reader.GetOrdinal(resultName);
            if (reader.IsDBNull(resultIndex))
            {
                // Return the valueIfNull
                return valueIfNull;
            }
            // Return the converted value
            return reader.GetString(resultIndex);
        }


        /*/////////////////////////////////////////////////////////////////////////////////////////

            The following section lists all the sql commands that we currently use to contact SSO 
        
        /////////////////////////////////////////////////////////////////////////////////////////*/

        /// <summary>
        /// Initialises all the standard sql strings
        /// </summary>
        private void InitilialiseStandardSql()
        {
            _standardSql = new Dictionary<string, string>();
            _standardSql.Add("SQL_SERVICE", "s.id, s.service_name, s.description, s.require_secure_login_flag, s.url, s.min_age, s.max_age, s.tag, s.api_access, s.access_unregistered_users, s.auto_logout, s.create_date ");
            _standardSql.Add("SQL_USER_ID", "u.id, u.cud_id, u.user_name ");
            _standardSql.Add("SQL_SEL_USER", _standardSql["SQL_USER_ID"] + "," + "u.password, u.user_status_code, u.user_type_code, u.adminpassword, u.create_date, u.cookie_validation_mark ");
            _standardSql.Add("SQL_USER_STATUS", _standardSql["SQL_USER_ID"] + "," + "u.user_status_code, u.user_status_date, u.user_type_code, us.loggedin_flag, us.loggedin_change_date, us.create_date, us.online_status_code, us.online_status_date, u.agreement_accepted_flag global_agreement_accepted_flag, us.agreement_accepted_flag service_agreement_accepted_flag, us.last_login_date ");
            _standardSql.Add("SQL_USER_PROFILE_SHORT", "IF(IFNULL(up.attribute_key, -1) = -1, 0, 1) has_value, up.value_text attribute_value, up.validated_flag, up.validated_date, up.publicly_visible_flag, IF(IFNULL(sa.needs_validation, -1) = -1, 0, sa.needs_validation + 0) needs_validation, IF(IFNULL(sa.mandatory, -1) = -1, 0, sa.mandatory + 0) mandatory ");
            _standardSql.Add("SQL_USER_PROFILE", _standardSql["SQL_USER_PROFILE_SHORT"] + "," + "pa.attribute_key ");
        }

        private string sqlGetSetService
        {
            get
            {
                StringBuilder sql = new StringBuilder("SELECT " + _standardSql["SQL_SERVICE"]);
                sql.Append("FROM service s WHERE s.service_name = '" + _ssoService.ServiceName + "';");
                return sql.ToString();
            }
        }

        private string sqlGetSystemKeys
        {
            get { return "SELECT key1, key2 FROM system;"; }
        }

        private string SqlSelUserByCudId
        {
            get
            {
                StringBuilder sql = new StringBuilder("SELECT " + _standardSql["SQL_SEL_USER"]);
                sql.Append("FROM user u WHERE u.cud_id = '" + _ssoUser.CudID + "';");
                return sql.ToString();
            }
        }

        private string sqlSelUserStatus
        {
            get
            {
                StringBuilder sql = new StringBuilder("SELECT " + _standardSql["SQL_USER_STATUS"]);
                sql.Append("FROM user u LEFT JOIN user_service us ON u.id = us.user_id AND us.service_id = " + _ssoService.ServiceID + " WHERE u.id = " + _ssoUser.UserID + ";");
                return sql.ToString();
            }
        }

        private string sqlSelUserProfileValue
        {
            get
            {
                StringBuilder sql = new StringBuilder("SELECT " + _standardSql["SQL_USER_PROFILE"]);
                sql.Append("FROM user_profile up, service_attribute sa, profile_attribute pa ");
                sql.Append("WHERE up.user_id = " + _ssoUser.UserID + " AND up.attribute_key = sa.attribute_key ");
	            sql.Append("AND sa.service_id = " + _ssoService.ServiceID + " ");
                sql.Append("AND sa.attribute_key = '" + _requestAttribute + "' ");
	            sql.Append("AND pa.attribute_key = sa.attribute_key;");
                return sql.ToString();
            }
        }

        private string sqlSelUserRegisteredService
        {
            get { return "SELECT us.user_id, us.service_id FROM user u, user_service us WHERE u.id = " + _ssoUser.UserID + " AND us.user_id = u.id AND us.service_id = " + _ssoService.ServiceID + ";"; }
        }

        private string sSqlSelValidationProfile
        {
            get
            {
                StringBuilder sql = new StringBuilder("SELECT " + _standardSql["SQL_USER_PROFILE"]);
                sql.Append("FROM service_attribute sa LEFT JOIN user_profile up ON sa.attribute_key = up.attribute_key AND up.user_id = " + _ssoUser.UserID + ", ");
	            sql.Append("profile_attribute pa WHERE sa.service_id = " + _ssoService.ServiceID + " ");
                sql.Append("AND sa.needs_validation = 2 AND pa.attribute_key = sa.attribute_key ORDER BY sa.attribute_key;");
                return sql.ToString();
            }
        }

        private string sqlSelMustChangePassword
        {
            get { return "SELECT u.must_change_password_flag FROM user u WHERE id = " + _ssoUser.UserID + ";"; }
        }

        private string sqlSelMandatoryProfile
        {
            get
            {
	            StringBuilder sql = new StringBuilder("SELECT " + _standardSql["SQL_USER_PROFILE"]);
                sql.Append("FROM service_attribute sa LEFT JOIN user_profile up ON sa.attribute_key = up.attribute_key AND up.user_id = " + _ssoUser.UserID + ", ");
	            sql.Append("profile_attribute pa WHERE sa.service_id = " + _ssoService.ServiceID + " AND sa.mandatory = 2 ");
                sql.Append("AND pa.attribute_key = sa.attribute_key ORDER BY sa.attribute_key");
                return sql.ToString();
            }
        }

        private string sqlSetUserLoggedInForService
        {
            get
            {
                StringBuilder sql = new StringBuilder("UPDATE user_service SET loggedin_flag = 1, online_status_code = 'AVAILABLE', ");
                sql.Append("online_status_date = NOW(), last_login_date = login_date, login_date = NOW(), loggedin_change_date = NOW(), update_date = NOW() ");
                sql.Append("WHERE user_id = " + _ssoUser.UserID + " AND service_id = " + _ssoService.ServiceID + ";");
                return sql.ToString();
            }
        }

        private string sqlSetUserLoggedOutForService
        {
            get
            {
                StringBuilder sql = new StringBuilder("UPDATE user_service SET loggedin_flag = 0, online_status_code = 'AVAILABLE', ");
                sql.Append("online_status_date = NOW(), last_login_date = login_date, login_date = NOW(), loggedin_change_date = NOW(), update_date = NOW() ");
                sql.Append("WHERE user_id = " + _ssoUser.UserID + " AND service_id = " + _ssoService.ServiceID + ";");
                return sql.ToString();
            }
        }

        private string sqlSelAttInfo
        {
            get 
            {
                StringBuilder sql = new StringBuilder("SELECT pa.attribute_key, sa.needs_validation + 0 needs_validation,sa.mandatory + 0 mandatory, sa.provider_flag, ");
                sql.Append("pa.data_type_code, pa.log_change_event_flag, pa.system_attribute_flag FROM profile_attribute pa, service_attribute sa ");
                sql.Append("WHERE pa.attribute_key = sa.attribute_key AND sa.service_id = " + _ssoService.ServiceID + " AND sa.attribute_key = '" + _requestAttribute + "';");
                return sql.ToString();
            }
        }
    }
}
