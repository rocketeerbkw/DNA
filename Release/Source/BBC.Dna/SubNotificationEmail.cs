using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class to store the SubNotificationEmail
    /// </summary>
    public class SubNotificationEmail : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the SubNotificationEmail component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SubNotificationEmail(IInputContext context)
            : base(context)
        {
        }

        ///<summary>
        /// Checks to see if this sub editor has any allocations that they have
		///	not yet been notified about, and if so builds the email to send
		///	in order to notify them.
        /// </summary>
        /// <param name="subID">user id of the sub to create the notification for</param>
        /// <param name="toSend">returned whether or not an email to send was created</param>
        /// <param name="emailAddress">the subs email address</param>
        /// <param name="emailSubject">the subject line for the email</param>
        /// <param name="emailText">the text of the email</param>
        public void CreateNotificationEmail(int subID, ref bool toSend, ref string emailAddress, ref string emailSubject, ref string emailText)
        {
            string subName = String.Empty;
            string authorName = String.Empty;
            string subject = String.Empty;
            int authorID = 0;
            int h2g2ID = 0;
            string batchDetails = String.Empty;

            toSend = false;
            RootElement.RemoveAll();

            XmlElement email = AddElementTag(RootElement, "EMAIL");
            AddAttribute(email, "TYPE", "SUB-NOTIFICATION");

            // call the SP to fetch all the allocations that the sub has not yet been notified of
            // this also updates these allocations status and the subs last notified date
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchAndUpdateSubsUnnotifiedAllocations"))
            {
                dataReader.AddParameter("SubID", subID);
                dataReader.AddParameter("currentsiteid", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    // set the email address and subject
                    toSend = true;
                    emailAddress = dataReader.GetStringNullAsEmpty("SubEmail");
                    subName = dataReader.GetStringNullAsEmpty("SubName");

                    AddTextTag(email, "EMAIL-ADDRESS", emailAddress);

                    //Add the user info with groups
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, subID, email);

                    // build up a string containing the details of the subs allocated batch
                    do
                    {
                        authorName = dataReader.GetStringNullAsEmpty("AuthorName");
                        authorID = dataReader.GetInt32NullAsZero("AuthorID");
                        subject = dataReader.GetStringNullAsEmpty("Subject");
                        h2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
                        batchDetails += "A" + h2g2ID + " '" + subject + "' by " + authorName + " (U" + authorID + ")\r\n";
                    }
                    while (dataReader.Read());

                    emailSubject = String.Empty;
                    emailText = String.Empty;

                    // fetch the template for the email
                    using (IDnaDataReader dataReader2 = InputContext.CreateDnaDataReader("fetchemailtext"))
                    {
                        dataReader2.AddParameter("SiteID", InputContext.CurrentSite.SiteID);
                        dataReader2.AddParameter("emailname", "SubAllocationsEmail");
                        dataReader2.Execute();

                        if (dataReader2.HasRows && dataReader2.Read())
                        {
                            emailSubject = dataReader2.GetStringNullAsEmpty("Subject");
                            emailText = dataReader2.GetStringNullAsEmpty("text");

                            // do any appropriate substitutions
                            emailSubject = emailSubject.Replace("++**sub_name**++", subName);
                            emailText = emailText.Replace("++**sub_name**++", subName);
                            emailText = emailText.Replace("++**batch_details**++", batchDetails);
                        }
                    }
                    AddTextTag(email, "SUBJECT", emailSubject);
                    AddTextTag(email, "TEXT", emailText);
                }
            }
        }

    }
}
