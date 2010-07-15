using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Collections;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{

    /// <summary>
    /// This class is used to get, add and remove banned emails
    /// </summary>
    public class BannedEmailsPageBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default construtor
        /// </summary>
        /// <param name="context">The inputcontext to create the object from</param>
        public BannedEmailsPageBuilder(IInputContext context)
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
                string email = InputContext.GetParamStringOrEmpty("email", "Get the email to update");
                if (!String.IsNullOrEmpty(email) && !EmailAddressFilter.IsValidEmailAddresses(email))
                {
                    AddErrorXml("InvalidEmail", "Invalid Email Address", RootElement);
                }
                else
                {
                    BannedEmails.GetObject().UpdateEmailDetails(email, false, true, InputContext.ViewingUser.UserID);
                    BannedEmails.GetObject().UpdateCacheAndSendSignal();
                }
            }
            else if (InputContext.DoesParamExist("togglesigninban", "Are we toggling the signin ban for an email"))
            {
                string email = InputContext.GetParamStringOrEmpty("email", "Get the email to update");
                if (!String.IsNullOrEmpty(email) && !EmailAddressFilter.IsValidEmailAddresses(email))
                {
                    AddErrorXml("InvalidEmail", "Invalid Email Address", RootElement);
                }
                else
                {
                    BannedEmails.GetObject().UpdateEmailDetails(email, false, true, InputContext.ViewingUser.UserID);
                    BannedEmails.GetObject().UpdateCacheAndSendSignal();
                }
            }
            else if (InputContext.DoesParamExist("remove", "Are we tring to remove an email"))
            {
                string email = InputContext.GetParamStringOrEmpty("NewEmail", "Are we tring to remove an email");
                if (!String.IsNullOrEmpty(email) && !EmailAddressFilter.IsValidEmailAddresses(email))
                {
                    AddErrorXml("InvalidEmail", "Invalid Email Address", RootElement);
                }
                else
                {
                    BannedEmails.GetObject().RemoveEmailFromBannedList(email);
                }
            }
            else if (InputContext.DoesParamExist("AddEmail", "Are we tring to remove an email"))
            {
                string email = InputContext.GetParamStringOrEmpty("NewEmail", "Get the new email address to add");
                bool complaintBanned = InputContext.GetParamStringOrEmpty("NewComplaintBanned", "Get the complaint banned setting").CompareTo("on") == 0;
                bool signInBanned = InputContext.GetParamStringOrEmpty("NewSignInBanned", "Get the signin banned setting").CompareTo("on") == 0;

                if (!String.IsNullOrEmpty(email) && !EmailAddressFilter.IsValidEmailAddresses(email))
                {
                    AddErrorXml("InvalidEmail", "Invalid Email Address", RootElement);
                }
                else
                {
                    BannedEmails.GetObject().AddEmailToBannedList(email, signInBanned, complaintBanned, InputContext.ViewingUser.UserID, InputContext.ViewingUser.UserName);
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
            foreach (BannedEmailDetails email in bannedEmails)
            {
                XmlNode bannedEmailNode = AddElementTag(bannedEmailsListNode, "BannedEmail");
                AddTextElement((XmlElement)bannedEmailNode, "Email", email.Email);
                AddTextElement((XmlElement)bannedEmailNode, "EscapedEmail", InputContext.UrlEscape(email.Email));
                AddTextElement((XmlElement)bannedEmailNode, "Editor", email.EditorName);
                AddIntElement(bannedEmailNode, "EditorId", email.EditorID);
                AddDateXml(email.DateAdded, bannedEmailNode, "DateAdded");
                AddIntElement(bannedEmailNode, "SignInBan", email.IsBannedFromSignIn ? 1 : 0);
                AddIntElement(bannedEmailNode, "ComplaintBan", email.IsBannedFromComplaints? 1 : 0);
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
                        bannedEMails.Add(new BannedEmailDetails(email, signInBanned, complainBanned, editorID, editorName, dateAdded));
                    }
                }
            }

            // Return the results
            return bannedEMails;
        }

    }
}
