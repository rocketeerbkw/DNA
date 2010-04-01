using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna.BannedEmails
{
    /// <summary>
    /// The banned emails service class
    /// </summary>
    public class BannedEmails
    {
        private ICacheManager _emailCache = null;
        private string _connectionDetails = null;
        private Dictionary<string,BannedEmailDetails> _bannedEmailsList = null;
        private string _bannedEmailsListCacheName = "DnaBannedEmailsList";
        private IDnaDataReaderCreator _dnaDataReaderCreator = null;
        private IDnaDiagnostics _dnaDiagnostics = null;

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="connectionDetails">The connection details ofr the database</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public BannedEmails(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching)
        {
            _dnaDataReaderCreator = dnaDataReaderCreator;
            _dnaDiagnostics = dnaDiagnostics;

            if (dnaDataReaderCreator == null)
            {
                _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
            }

            _emailCache = caching;
            if (_emailCache == null)
            {
                _emailCache = CacheFactory.GetCacheManager();
            }

            InitializeBannedList(false);
        }

        /// <summary>
        /// Initialize the banned list from the database
        /// </summary>
        /// <param name="forceRefresh">A flag to state that you want to force a refresh of the cache</param>
        private void InitializeBannedList(bool forceRefresh)
        {
            // Check to see if we need to fill the cache
            if (forceRefresh)
            {
                // Remove the cache and reset the list
                _emailCache.Remove(_bannedEmailsListCacheName);
                _bannedEmailsList = null;
            }
            else
            {
                // Try to get the list from the cache
                if (_emailCache.Contains(_bannedEmailsListCacheName))
                {
                    _bannedEmailsList = (Dictionary<string, BannedEmailDetails>)_emailCache[_bannedEmailsListCacheName];
                }
            }

            // Double check to make sure we actually got a list back
            if (_bannedEmailsList == null)
            {
                try
                {
                    _bannedEmailsList = new Dictionary<string,BannedEmailDetails>();
                    using (IDnaDataReader reader = CreateStoreProcedureReader("getbannedemails"))
                    {
                        reader.AddParameter("skip", 0);
                        reader.AddParameter("show", 2000);
                        reader.AddParameter("showsigninbanned", 0);
                        reader.AddParameter("showcomplaintbanned", 0);
                        reader.AddParameter("showall", 1);
                        reader.Execute();

                        // Go throught the list adding them to the cache
                        while (reader.Read())
                        {
                            string email = reader.GetString("email");
                            bool bannedFromSignIn = reader.GetBoolean("SignInBanned");
                            bool bannedFromComplaints = reader.GetBoolean("ComplaintBanned");
                            int editorID = reader.GetInt32("EditorID");
                            DateTime dateAdded = reader.GetDateTime("DateAdded");
                            _bannedEmailsList.Add(email,new BannedEmailDetails(email, bannedFromSignIn, bannedFromComplaints, editorID, dateAdded));
                        }
                        _emailCache.Add(_bannedEmailsListCacheName, _bannedEmailsList);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("BBC.Dna.BannedEmail.GetAllBannedEmails :: " + ex);
                }
            }
        }

        /// <summary>
        /// Use this method to refresh the cache
        /// </summary>
        public void RefreshCachedEmails()
        {
            // Just reinitialize with force refresh
            InitializeBannedList(true);
        }

        /// <summary>
        /// Checks to see the the given email is in the list of banned from signing in emails
        /// </summary>
        /// <param name="email">The email you want to check for</param>
        /// <returns>True if they are, false if not</returns>
        public bool IsEmailInBannedFromSignInList(string email)
        {
            try
            {
                // Get the details from the cache
                BannedEmailDetails emailDetails = _bannedEmailsList[email];

                // If we have the details and the flag is set, return true
                return emailDetails != null && emailDetails.IsBannedFromSignIn;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Checks to see the the given email is in the list of banned from complaining emails
        /// </summary>
        /// <param name="email">The email you want to check for</param>
        /// <returns>True if they are, false if not</returns>
        public bool IsEmailInBannedFromComplaintsList(string email)
        {
            // Get the details from the cache
            try
            {
                BannedEmailDetails emailDetails = _bannedEmailsList[email];

                // If we have the details and the flag is set, return true
                return emailDetails != null && emailDetails.IsBannedFromComplaints;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Creates a new stored procedure reader for the given procedure
        /// </summary>
        /// <param name="procedureName">The name of the procedure you want to call</param>
        /// <returns>A stored procedure reader ready to execute the given stored procedure</returns>
        private IDnaDataReader CreateStoreProcedureReader(string procedureName)
        {
            if (_dnaDataReaderCreator == null)
            {
                return new StoredProcedureReader(procedureName, _connectionDetails, _dnaDiagnostics);
            }
            else
            {
                return _dnaDataReaderCreator.CreateDnaDataReader(procedureName);
            }
        }

        /// <summary>
        /// Adds a new email to the list of banned emails
        /// </summary>
        /// <param name="email">The email you want to add to the list</param>
        /// <param name="bannedFromSignIn">A flag to state whether or not you want to ban the email from signing in</param>
        /// <param name="bannedFromComplaints">A flag to state whether or not you want to ban the email from complaining</param>
        /// <param name="editorID">The ID of the user updating the details</param>
        /// <returns>True if it was added ok, false if not</returns>
        public bool AddEmailToBannedList(string email, bool bannedFromSignIn, bool bannedFromComplaints, int editorID)
        {
            // Make sure the email is clean.
            email = email.Trim();

            // Make sure the email is roughly in the right format abc@def.ghi
            int atpos = email.IndexOf('@');
            int dotpos = email.IndexOf('.', atpos);
            if (atpos == 0 || dotpos == 0)
            {
                Console.WriteLine("The email is not formed correctly");
                return false;
            }

            try
            {
                using (IDnaDataReader reader = CreateStoreProcedureReader("AddEmailToBannedList"))
                {
                    reader.AddParameter("Email", email);
                    reader.AddParameter("EditorID", editorID);
                    reader.AddParameter("SignInBanned", bannedFromSignIn);
                    reader.AddParameter("ComplaintBanned", bannedFromComplaints);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        if (reader.GetInt32("Duplicate") == 0)
                        {
                            _bannedEmailsList.Add(email, new BannedEmailDetails(email, bannedFromSignIn, bannedFromComplaints, editorID, DateTime.Now));
                            _emailCache.Add(_bannedEmailsListCacheName, _bannedEmailsList);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("BBC.Dna.BannedEmail.AddEmailToBannedList :: " + ex);
                return false;
            }
            return true;
        }

        /// <summary>
        /// Removes a given email from the banned list
        /// </summary>
        /// <param name="email">The email you want to remove</param>
        public void RemoveEmailFromBannedList(string email)
        {
            using (IDnaDataReader reader = CreateStoreProcedureReader("RemoveBannedEMail"))
            {
                // Add the email and execute
                reader.AddParameter("Email", email);
                reader.Execute();
            }

            // Check to see if the email is in the list
            _bannedEmailsList.Remove(email);
            _emailCache.Add(_bannedEmailsListCacheName, _bannedEmailsList);
        }

        /// <summary>
        /// Updates the given email with the new signin and complaints details.
        /// </summary>
        /// <param name="email">The email you want to update</param>
        /// <param name="bannedFromSignIn">The new can signin status</param>
        /// <param name="bannedFromComplaints">The new can complain status</param>
        /// <param name="editorID">The ID of the user updating the details</param>
        /// <returns>True if it got updated, false if not</returns>
        public bool UpdateEmailDetails(string email, bool bannedFromSignIn, bool bannedFromComplaints, int editorID)
        {
            try
            {
                BannedEmailDetails details = _bannedEmailsList[email];
                if (details != null)
                {
                    using (IDnaDataReader reader = CreateStoreProcedureReader("updatebannedemailsettings"))
                    {
                        // Add the values and execute
                        reader.AddParameter("Email", email);
                        reader.AddParameter("EditorID", editorID);
                        reader.AddParameter("ToggleSignInBanned", details.IsBannedFromSignIn != bannedFromSignIn);
                        reader.AddParameter("ToggleComplaintBanned", details.IsBannedFromComplaints != bannedFromComplaints);
                        reader.Execute();
                    }

                    // Update the details and add them back to the cache
                    details.IsBannedFromComplaints = bannedFromComplaints;
                    details.IsBannedFromSignIn = bannedFromSignIn;
                    _emailCache.Add(_bannedEmailsListCacheName, _bannedEmailsList);
                }
                else
                {
                    // No details found for this email!
                    Console.WriteLine("BBC.Dna.BannedEmail.UpdateEmailDetails :: No details found for this email");
                    return false;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("BBC.Dna.BannedEmail.UpdateEmailDetails :: " + ex);
                return false;
            }
            return true;
        }

        /// <summary>
        /// Gets a list of all the banned emails
        /// </summary>
        /// <returns>A list of banned email details.</returns>
        public Dictionary<string,BannedEmailDetails> GetAllBannedEmails()
        {
            // Check to see if we've got a blank list, if so get the list from the database
            InitializeBannedList(false);

            // Return the list from the cache
            return _bannedEmailsList;
        }
    }
}
