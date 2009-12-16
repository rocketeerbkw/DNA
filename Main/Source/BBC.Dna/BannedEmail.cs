using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Collections;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// 
    /// </summary>
    public class BannedEmail
    {
        private string _email;
        private DateTime _dateAdded;
        private int _editorID;
        private string _editorName;
        private bool _signInBan;
        private bool _complainBan;

        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="eamil">The email that has been banned</param>
        /// <param name="dateAdded">The date when the email was banned</param>
        /// <param name="editorID">The id of the editor that hanned the email</param>
        /// <param name="editorName">The name of the editor that banned the email</param>
        /// <param name="signinBan">Set to true if this email is banned from being used for signing in</param>
        /// <param name="complainBan">Set to true if this email is banned from being used for complaining</param>
        public BannedEmail(string eamil, DateTime dateAdded, int editorID, string editorName, bool signinBan, bool complainBan)
        {
            _email = eamil;
            _dateAdded = dateAdded;
            _editorID = editorID;
            _editorName = editorName;
            _signInBan = signinBan;
            _complainBan = complainBan;
        }

        /// <summary>
        /// The email property
        /// </summary>
        public string Email
        {
            get { return _email;  }
        }

        /// <summary>
        /// The date added property
        /// </summary>
        public DateTime DateAdded
        {
            get { return _dateAdded;  }
        }

        /// <summary>
        /// The editor id property
        /// </summary>
        public int EditorID
        {
            get { return _editorID; }
        }

        /// <summary>
        /// The editor name property
        /// </summary>
        public string EditorName
        {
            get { return _editorName; }
        }

        /// <summary>
        /// Banned from signin property
        /// </summary>
        public bool BannedFromSignIn
        {
            get { return _signInBan; }
        }

        /// <summary>
        /// Banned from complaining property
        /// </summary>
        public bool BannedFromComplaining
        {
            get { return _complainBan; }
        }
    }

    /// <summary>
    /// This class is used to get, add and remove banned emails
    /// </summary>
    public class BannedEmails : DnaInputComponent
    {
        /// <summary>
        /// Default construtor
        /// </summary>
        /// <param name="context">The inputcontext to create the object from</param>
        public BannedEmails(IInputContext context)
            : base(context)
        {
        }

        private int _totalResults = 0;
        private int _show = 20;
        private int _skip = 0;
        private string _searchLetter = "";
        private int _searchType = 0;

        /// <summary>
        /// Get property for getting the total number of matching email for the last search result
        /// </summary>
        public int TotalEmails
        {
            get { return _totalResults; }
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            // Add the banned emails base node
            XmlNode bannedEmailsNode = AddElementTag(RootElement, "BannedEmails");

            // Get the current search values
            GetSearchDetails();

            // Check to see if we're doing any operations
            if (InputContext.DoesParamExist("togglecomplaintban", "Are we toggling the complaint ban for an email"))
            {
                // Get the email to toggle the setting for
                string email = InputContext.GetParamStringOrEmpty("email", "Get the email to update");
                if (email.Length == 0 || !email.Contains("@"))
                {
                    // Invalid email given
                }
                else
                {
                    UpdateBannedEmail(email, InputContext.ViewingUser.UserID, false, true);
                }
            }
            else if (InputContext.DoesParamExist("togglesigninban", "Are we toggling the signin ban for an email"))
            {
                // Get the email to toggle the setting for
                string email = InputContext.GetParamStringOrEmpty("email", "Get the email to update");
                if (email.Length == 0 || !email.Contains("@"))
                {
                    // Invalid email given
                }
                else
                {
                    UpdateBannedEmail(email, InputContext.ViewingUser.UserID, true, false);
                }
            }
            else if (InputContext.DoesParamExist("remove", "Are we tring to remove an email"))
            {
                string email = InputContext.GetParamStringOrEmpty("email", "Get the email to update");
                if (email.Length == 0 || !email.Contains("@"))
                {
                    // Invalid email given
                }
                else
                {
                    RemoveEmail(email);
                }
            }
            else if (InputContext.DoesParamExist("AddEmail", "Are we tring to remove an email"))
            {
                string newEmail = InputContext.GetParamStringOrEmpty("NewEmail", "Get the new email address to add");
                bool complaintBanned = InputContext.GetParamStringOrEmpty("NewComplaintBanned", "Get the complaint banned setting").CompareTo("on") == 0;
                bool signInBanned = InputContext.GetParamStringOrEmpty("NewSignInBanned", "Get the signin banned setting").CompareTo("on") == 0;
                
                if ( !EmailAddressFilter.IsValidEmailAddresses(newEmail) )
                {
                    // Invalid email given, need to report error.
                    // This check is to avoid non valid email characters accompanying the email / trailing whitespace etc.
                    AddErrorXml("InvalidEmail", "Invalid Email Address", RootElement);
                }
                else
                {
                    AddEmailToBannedList(newEmail, InputContext.ViewingUser.UserID, signInBanned, complaintBanned);
                }
            }

            // Show the current emails via the search criteria
            DisplayCurrentEmails(bannedEmailsNode);
        }

        private void DisplayCurrentEmails(XmlNode bannedEmailsNode)
        {
            // Get the requested list of emails
            XmlNode bannedEmailsListNode = AddElementTag(bannedEmailsNode, "BANNEDEMAILLIST");
            ArrayList bannedEmails = GetBannedEmails(_skip, _show, _searchType, _searchLetter, true, true, true);
            foreach (BannedEmail email in bannedEmails)
            {
                XmlNode bannedEmailNode = AddElementTag(bannedEmailsListNode, "BannedEmail");
                AddTextElement((XmlElement)bannedEmailNode, "Email", email.Email);
                AddTextElement((XmlElement)bannedEmailNode, "EscapedEmail", InputContext.UrlEscape(email.Email));
                AddTextElement((XmlElement)bannedEmailNode, "Editor", email.EditorName);
                AddIntElement(bannedEmailNode, "EditorId", email.EditorID);
                AddDateXml(email.DateAdded, bannedEmailNode, "DateAdded");
                AddIntElement(bannedEmailNode, "SignInBan", email.BannedFromSignIn ? 1 : 0);
                AddIntElement(bannedEmailNode, "ComplaintBan", email.BannedFromComplaining ? 1 : 0);
            }

            AddIntElement(bannedEmailsNode, "TotalEmails", _totalResults);
            AddIntElement(bannedEmailsNode, "Show", _show);
            AddIntElement(bannedEmailsNode, "skip", _skip);
            AddTextElement((XmlElement)bannedEmailsNode, "SearchLetter", _searchLetter);
            AddIntElement(bannedEmailsNode, "SearchType", _searchType);
        }

        /// <summary>
        /// This method gets all the search params from the url.
        /// </summary>
        private void GetSearchDetails()
        {
            // Get the search values form the URL. Set some defaults.
            // Get the show value
            if (InputContext.DoesParamExist("show", "Do we have the number of items to show?"))
            {
                _show = InputContext.GetParamIntOrZero("show", "Get the show value");
                if (_show == 0)
                {
                    _show = 20;
                }
            }

            // Get the skip
            if (InputContext.DoesParamExist("skip", "Do we have the number of items to skip?"))
            {
                _skip = InputContext.GetParamIntOrZero("skip", "Get the skip value");
            }

            // Workout which search type we're doing
            if (InputContext.DoesParamExist("ViewAll", "Are we viewing all items?"))
            {
                _searchType = 1;
            }
            else if (InputContext.DoesParamExist("ViewByLetter", "Are we wanting to search by letter?"))
            {
                _searchType = 1;
                _searchLetter = InputContext.GetParamStringOrEmpty("ViewByLetter", "Get the search letter");
            }
        }

        /// <summary>
        /// Gets the current banned emails from the database and returns them as an array of BannedEmail items
        /// </summary>
        /// <param name="skip">The number of emails to skip over before displaying</param>
        /// <param name="show">The number of emails to display</param>
        /// <param name="searchType">The type of search you want to use. (Defualt) Type 0 = Most Recent, Type 1 = By Letter</param>
        /// <param name="letter">The letter you want to search emails with. Only used by type 1 searches</param>
        /// <param name="showSignInBanEmails">Set to true if you want to include emails that are banned from signing in</param>
        /// <param name="showComplainBanEmails">Set to true if you want to include emails banned from complaining.</param>
        /// <param name="showAll">Set to true if you want to show all without filtering</param>
        /// <returns>An Array of the current baneed emails from the database</returns>
        public ArrayList GetBannedEmails(int skip, int show, int searchType, string letter, bool showSignInBanEmails, bool showComplainBanEmails, bool showAll)
        {
            // Create the list to return
            ArrayList bannedEMails = new ArrayList();

            // Check to see what type of search we're doing
            string searchProcedure = "GetBannedEmails";
            if (searchType == 1)
            {
                searchProcedure = "GetBannedEmailsStartingWithLetter";
            }

            // Create the data reader and call the get banned emails stored procedure
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader(searchProcedure))
            {
                // Execute and check to see if we have any emails
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show);
                if (searchType == 1)
                {
                    reader.AddParameter("letter", letter);
                }
                reader.AddParameter("ShowSignInBanned", Convert.ToInt32(showSignInBanEmails));
                reader.AddParameter("ShowComplaintBanned", Convert.ToInt32(showComplainBanEmails));
                reader.AddParameter("ShowAll", Convert.ToInt32(showAll));
                reader.Execute();
                if (reader.HasRows)
                {
                    // Add each email item to the banned list
                    string email;
                    DateTime dateAdded;
                    int editorID;
                    string editorName;
                    bool signInBanned;
                    bool complainBanned;
                    _totalResults = 0;

                    while (reader.Read())
                    {
                        email = reader.GetString("Email");
                        dateAdded = reader.GetDateTime("DateAdded");
                        editorID = reader.GetInt32("EditorID");
                        editorName = reader.GetString("EditorName");
                        signInBanned = reader.GetBoolean("SignInBanned");
                        complainBanned = reader.GetBoolean("ComplaintBanned");
                        if (_totalResults == 0)
                        {
                            _totalResults = reader.GetInt32("total");
                        }
                        bannedEMails.Add(new BannedEmail(email, dateAdded, editorID, editorName, signInBanned, complainBanned));
                    }
                }
            }

            // Return the results
            return bannedEMails;
        }

        /// <summary>
        /// Adds the given email to the banned email list
        /// </summary>
        /// <param name="emailToAdd">The email address you wnat to add to the list</param>
        /// <param name="editorID">The id of the user who added the email to the list</param>
        /// <param name="signInBanned">Set to true if the email is used to check for signin ban</param>
        /// <param name="complaintBanned">Set to true if email is used to check for complaint ban</param>
        /// <returns>True if the email was added, false if not</returns>
        public bool AddEmailToBannedList(string emailToAdd, int editorID, bool signInBanned, bool complaintBanned)
        {
            // Create the data reader
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("AddEmailToBannedList"))
            {
                // Add the email and execute
                reader.AddParameter("Email", emailToAdd);
                reader.AddParameter("EditorID", editorID);
                reader.AddParameter("SignInBanned", signInBanned);
                reader.AddParameter("ComplaintBanned", complaintBanned);
                reader.Execute();
                if (reader.HasRows && reader.Read())
                {
                    // Return the verdict
                    return reader.GetInt32("Duplicate") == 0;
                }
            }

            InputContext.Diagnostics.WriteWarningToLog("AddEmailToBannedList", "Failed to read the duplicate flag from the datbase");
            return false;
        }

        /// <summary>
        /// Updates the given banned email
        /// </summary>
        /// <param name="emailToUpdate">The email that you want to update</param>
        /// <param name="editorID">The id of the editor making the changes</param>
        /// <param name="toggleSignInBanned">A flag to state whether or not to toggle the signin banned status</param>
        /// <param name="toggleComplaintBanned">A flag to state whether or not to toggle the complaint banned status</param>
        public void UpdateBannedEmail(string emailToUpdate, int editorID, bool toggleSignInBanned, bool toggleComplaintBanned)
        {
            // Create the data reader
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("updatebannedemailsettings"))
            {
                // Add the values and execute
                reader.AddParameter("Email", emailToUpdate);
                reader.AddParameter("EditorID", editorID);
                reader.AddParameter("ToggleSignInBanned", toggleSignInBanned);
                reader.AddParameter("ToggleComplaintBanned", toggleComplaintBanned);
                reader.Execute();
            }
        }

        /// <summary>
        /// Removes the given email form the banned email list
        /// </summary>
        /// <param name="emailToRemove">The email you want to remove</param>
        public void RemoveEmail(string emailToRemove)
        {
            // Create the data reader
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("RemoveBannedEMail"))
            {
                // Add the email and execute
                reader.AddParameter("Email", emailToRemove);
                reader.Execute();
            }
        }
    }
}
