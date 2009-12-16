using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.BannedEmails
{
    /// <summary>
    /// Container class for a banned email details
    /// </summary>
    public class BannedEmailDetails
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="email">The email</param>
        /// <param name="isBannedFromSignin">A flag to state whether or not the email is banned from signing in</param>
        /// <param name="isBannedFromComplaints">A flag to state whether or not the email is banned from complaining</param>
        /// <param name="editorID">The id of the editor who added the eamil</param>
        /// <param name="dateAdded">The time at which the eamil was added to the list</param>
        public BannedEmailDetails(string email, bool isBannedFromSignin, bool isBannedFromComplaints, int editorID, DateTime dateAdded)
        {
            EMail = email;
            IsBannedFromSignIn = isBannedFromSignin;
            IsBannedFromComplaints = isBannedFromComplaints;
            EditorID = editorID;
            DateAdded = dateAdded;
        }

        /// <summary>
        /// The get/set property for the email address
        /// </summary>
        public string EMail
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the banned from signin flag
        /// </summary>
        public bool IsBannedFromSignIn
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the banned from complaining flag
        /// </summary>
        public bool IsBannedFromComplaints
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the date added value
        /// </summary>
        public DateTime DateAdded
        {
            get;
            set;
        }

        /// <summary>
        /// The get/set property for the editor id who added the email
        /// </summary>
        public int EditorID
        {
            get;
            set;
        }
    }
}
