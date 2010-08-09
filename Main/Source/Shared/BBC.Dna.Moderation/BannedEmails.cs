using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using System.Configuration;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Text.RegularExpressions;
using BBC.Dna.Common;
using System.Collections.Specialized;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// The banned emails service class
    /// </summary>
    public class BannedEmails : SignalBase<BannedEmails>
    {
        private const string _signalKey = "recache-bannedEmails";

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="connectionDetails">The connection details ofr the database</param>
        /// <param name="caching">The caching object that the class can use for caching</param>
        public BannedEmails(IDnaDataReaderCreator dnaDataReaderCreator, IDnaDiagnostics dnaDiagnostics, ICacheManager caching, List<string> ripleyServerAddresses, List<string> dotNetServerAddresses)
            : base(dnaDataReaderCreator, dnaDiagnostics, caching, _signalKey, ripleyServerAddresses, dotNetServerAddresses)
        {
            
            InitialiseObject += new InitialiseObjectDelegate(InitializeBannedEmails);
            HandleSignalObject = new HandleSignalDelegate(HandleSignal);
            GetStatsObject = new GetStatsDelegate(GetBannedEmailsStats);
            CheckVersionInCache();
            //register object with main signal helper
            SignalHelper.AddObject(typeof(BannedEmails), this);
        }

        /// <summary>
        /// Returns the single static version
        /// </summary>
        /// <returns></returns>
        static public BannedEmails GetObject()
        {
           var obj = SignalHelper.GetObject(typeof(BannedEmails));
           if (obj != null)
           {
               return (BannedEmails)obj;
           }
           return null;
        }

        /// <summary>
        /// Initialize the banned list from the database - used as a delegate
        /// </summary>
        private void InitializeBannedEmails(params object[] args)
        {
            var bannedEmailsList = new BannedEmailsList();
            // Check to see if we need to fill the cache
            try
            {
                bannedEmailsList.bannedEmailsList = new Dictionary<string, BannedEmailDetails>();
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("getbannedemails"))
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
                        string editorName = reader.GetStringNullAsEmpty("EditorName");
                        DateTime dateAdded = reader.GetDateTime("DateAdded");
                        bannedEmailsList.bannedEmailsList.Add(email, new BannedEmailDetails(email, bannedFromSignIn, bannedFromComplaints, editorID, editorName, dateAdded));
                    }
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
            }

            AddToInternalObjects(GetCacheKey(), GetCacheKeyLastUpdate(), bannedEmailsList);
        }

        /// <summary>
        /// Delegate for handling a signal
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        private bool HandleSignal(NameValueCollection args)
        {
            InitializeBannedEmails();
            return true;
        }

        /// <summary>
        /// Returns list statistics
        /// </summary>
        /// <returns></returns>
        private NameValueCollection GetBannedEmailsStats()
        {
            var values = new NameValueCollection();

            var _object = GetObjectFromCache();
            values.Add("NumberOfBannedEmailsInList", _object.bannedEmailsList.Count.ToString());
            return values;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public BannedEmailsList GetObjectFromCache()
        {
            return (BannedEmailsList)GetCachedObject();
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
                var bannedEmails = GetObjectFromCache();
                // Get the details from the cache
                var emailDetails = bannedEmails.bannedEmailsList[email];

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
                var bannedEmails = GetObjectFromCache();
                // Get the details from the cache
                var emailDetails = bannedEmails.bannedEmailsList[email];

                // If we have the details and the flag is set, return true
                return emailDetails != null && emailDetails.IsBannedFromComplaints;
            }
            catch
            {
                return false;
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
        public bool AddEmailToBannedList(string email, bool bannedFromSignIn, bool bannedFromComplaints, int editorID, string editorName)
        {
            // Make sure the email is clean.
            email = email.Trim();
            if(!EmailAddressFilter.IsValidEmailAddresses(email))
            {
                _dnaDiagnostics.WriteToLog("AddEmailTobannedEmails","The email is not formed correctly");
                return false;
            }

            try
            {

                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("AddEMailToBannedList"))
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
                            var bannedEmails = GetObjectFromCache();
                            bannedEmails.bannedEmailsList.Add(email, new BannedEmailDetails(email, bannedFromSignIn, bannedFromComplaints, editorID, editorName, DateTime.Now));
                            AddToInternalObjects(GetCacheKey(), GetCacheKeyLastUpdate(), bannedEmails);
                            SendSignals();
                        }
                    }
                    else
                    {
                        throw new Exception("Incorrect return from AddEmailTobannedEmails sp");
                    }
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
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
            try
            {
                var emailObj = GetObjectFromCache().bannedEmailsList[email];
                using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("RemoveBannedEMail"))
                {
                    // Add the email and execute
                    reader.AddParameter("Email", email);
                    reader.Execute();
                }

                // Check to see if the email is in the list
                var bannedEmails = GetObjectFromCache();
                bannedEmails.bannedEmailsList.Remove(email);
                AddToInternalObjects(GetCacheKey(), GetCacheKeyLastUpdate(), bannedEmails);
                SendSignals();
            }
            catch(Exception e) 
            {
                _dnaDiagnostics.WriteExceptionToLog(e);
            }
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
                var bannedEmails = GetObjectFromCache();
                var details = bannedEmails.bannedEmailsList[email];
                if (details != null)
                {
                    using (IDnaDataReader reader = _readerCreator.CreateDnaDataReader("updatebannedemailsettings"))
                    {
                        // Add the values and execute
                        reader.AddParameter("Email", email);
                        reader.AddParameter("EditorID", editorID);
                        reader.AddParameter("ToggleSignInBanned", bannedFromSignIn);
                        reader.AddParameter("ToggleComplaintBanned", bannedFromComplaints);
                        reader.Execute();
                    }

                    // Update the details and add them back to the cache
                    details.IsBannedFromComplaints = bannedFromComplaints;
                    details.IsBannedFromSignIn = bannedFromSignIn;
                    
                }
                else
                {
                    // No details found for this email!
                    _dnaDiagnostics.WriteToLog("BBC.Dna.BannedEmail.UpdateEmailDetails", "No details found for this email");
                    return false;
                }
            }
            catch (Exception ex)
            {
                _dnaDiagnostics.WriteExceptionToLog(ex);
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
            //InitializebannedEmails(false);

            // Return the list from the cache
            return GetObjectFromCache().bannedEmailsList;
        }

        /// <summary>
        /// 
        /// </summary>
        public void UpdateCacheAndSendSignal()
        {
            SendSignals();
        }

        
    }
}
