using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;

namespace BBC.Dna.Component
{
    /// <summary>
    /// SubEditorAllocationPageBuilder
    /// </summary>
    public class SubEditorAllocationPageBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default constructor of SubEditorAllocationPageBuilder
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SubEditorAllocationPageBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //if not an editor then return an error
            if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsEditor)
            {
                AddErrorXml("NOT-EDITOR", "You cannot allocate recommended entries to sub editors unless you are logged in as an Editor.", RootElement);
                return;
            }

            string sCommand = InputContext.GetParamStringOrEmpty("Command","Gets command switch string");
            if (sCommand == String.Empty)
                sCommand = "View";

            RootElement.RemoveAll();
            XmlElement subAllFormXML = AddElementTag(RootElement, "SUB-ALLOCATION-FORM");
           

            switch(sCommand.ToUpper())
            {
                case "VIEW":
                    break;// do nothing for simple view requests

                case "NOTIFYSUBS"://if this is a notification request then send the notification emails
                    int totalSent=0;
                    SendNotificationEmails(ref totalSent);
                    break;

                default:
                    ProcessAllocationSubmission(sCommand);
                    
                    break;//TODO: else process any submission of allocated entries

            }

            
            // after doing any processing requests get all the data for the form
		    // now tell the form to get the other data it needs
            // - subs list, accepted recommendations list, and allocated recommendations list
            SubAllocationForm subAllForm = new SubAllocationForm(InputContext);
            subAllForm.InsertSubEditorList();
            ImportAndAppend(subAllForm.RootElement.FirstChild, "/DNAROOT/SUB-ALLOCATION-FORM");

           
            //get unallocation recommendation list
            ArticleList articleList = new ArticleList(InputContext);
            articleList.CreateUnallocatedRecommendationsList();
            AddElementTag(subAllFormXML, "UNALLOCATED-RECOMMENDATIONS");
            ImportAndAppend(articleList.RootElement.FirstChild, "/DNAROOT/SUB-ALLOCATION-FORM/UNALLOCATED-RECOMMENDATIONS");

            //get skip and show amounts
            int skip = InputContext.GetParamIntOrZero("skip","Amount of items in result set to skip");
            int show = InputContext.GetParamIntOrZero("show", "Amount of items in result set to show");
            if (show <= 0)
                show = 20;
            //get allocated recommendation list
            articleList.CreateAllocatedRecommendationsList(show, skip);
            AddElementTag(subAllFormXML, "ALLOCATED-RECOMMENDATIONS");
            ImportAndAppend(articleList.RootElement.FirstChild, "/DNAROOT/SUB-ALLOCATION-FORM/ALLOCATED-RECOMMENDATIONS");


            //insert the notification status
            subAllForm.InsertNotificationStatus();
            ImportAndAppend(subAllForm.RootElement.FirstChild, "/DNAROOT/SUB-ALLOCATION-FORM");

        }

        /// <summary>
        /// Checks to see if there is a submission of entry allocations to subs
		///		in this request, and processes it if there is.
        /// </summary>
        /// <param name="command">outlines what action to complete</param>
        /// <returns>True if any submission was process successfully (or there was none),
		///		false if something went wrong</returns>
        public bool ProcessAllocationSubmission(string command)
        {
            SubAllocationForm subAllForm = new SubAllocationForm(InputContext);
            if (!InputContext.ViewingUser.IsEditor)
                return false;

            int subID = InputContext.GetParamIntOrZero("SubID", "The passed sub-editor id");
            

            //define common variables
            int totalEntries = 0;
            int totalProcessed = 0;
            bool success = false;

            switch(command.ToUpper())
            {
                case "AUTOALLOCATE":
                    int numberToAllocate = InputContext.GetParamIntOrZero("Amount", "Amount to auto-allocate");
                    if (numberToAllocate <= 0)
                    {
                        AddErrorMessage("ZERO-AUTO-ALLOCATE", "No articles to allocate");
                        return false;
                    }
                    // make sure we have a sub ID and a positive number of entries to allocate
                    // if not then put some error XML in specifying the problem
                    
                    success= subAllForm.SubmitAutoAllocation(subID, numberToAllocate, InputContext.ViewingUser.UserID,
                        InputContext.GetParamStringOrEmpty("comment", "Sub-Editors comments"), ref totalProcessed);

                    if (success)
                    {
                        ImportAndAppend(subAllForm.RootElement.ChildNodes[0], "/DNAROOT/SUB-ALLOCATION-FORM");
                        ImportAndAppend(subAllForm.RootElement.ChildNodes[1], "/DNAROOT/SUB-ALLOCATION-FORM");

                    }

                    break;

                case "ALLOCATE":
                    if (subID <= 0)
                    {
                        AddErrorMessage("INVALID-SUBEDITOR-ID", "Invalid subeditor ID passed");
                        return false;
                    }
                    //get the entries to allocate
                    totalEntries = InputContext.GetParamCountOrZero("EntryID", "Total of entries passed in.");
                    if (totalEntries > 0)
                    {
                        int[] entryIDs = new int[totalEntries];
                        for (int counter = 0; counter < totalEntries; counter++)
                        {
                            entryIDs[counter] = InputContext.GetParamIntOrZero("EntryID", counter, "Entry ID to allocate");
                        }
                        success = subAllForm.SubmitAllocation(subID, InputContext.ViewingUser.UserID, InputContext.GetParamStringOrEmpty("comment", "Sub-Editors comments"),
                            entryIDs);

                        if (success)
                        {
                            ImportAndAppend(subAllForm.RootElement.ChildNodes[0], "/DNAROOT/SUB-ALLOCATION-FORM");
                            ImportAndAppend(subAllForm.RootElement.ChildNodes[1], "/DNAROOT/SUB-ALLOCATION-FORM");

                        }
                    }
                    else
                    {
                        //nothing selected so fail
                        AddErrorMessage("NO-ENTRIES-SELECTED", "No entries selected for allocation.");
                        return false;
                    }
                    break;

                case "DEALLOCATE":
                    //get deallocation entry ids
                    totalEntries = InputContext.GetParamCountOrZero("DeallocateID", "Amount to deallocate");
                    if (totalEntries > 0)
                    {
                        int[] entryIDs = new int[totalEntries];
                        for (int counter = 0; counter < totalEntries; counter++)
                        {
                            entryIDs[counter] = InputContext.GetParamIntOrZero("DeallocateID", counter, "Entry ID to deallocated");
                        }
                        success = subAllForm.SubmitDeallocation(InputContext.ViewingUser.UserID, entryIDs,
                            ref totalProcessed);

                        if (success)
                        {
                            ImportAndAppend(subAllForm.RootElement.ChildNodes[0], "/DNAROOT/SUB-ALLOCATION-FORM");
                            ImportAndAppend(subAllForm.RootElement.ChildNodes[1], "/DNAROOT/SUB-ALLOCATION-FORM");
                        }
                    }
                    else
                    {
                        //nothing selected so fail
                        AddErrorMessage("NO-ENTRIES-SELECTED", "No entries selected for allocation.");
                        return false;
                    }
                    break;
            }
            
            return success;

        }


        /// <summary>
        /// Sends out an email containing a summary of the new allocations made
		///		to each sub editor.
        /// </summary>
        /// <param name="totalSent">total number of emails sent returned</param>
        /// <returns>True if emails sent okay, false if not</returns>
        private bool SendNotificationEmails(ref int totalSent)
        {
            UserList userList = new UserList(InputContext);
            userList.CreateSubEditorsList();
            int[] userIDs = null;
            if (!userList.GetUserIDs(ref userIDs))
                return false;

            for (int counter = 0; counter < userIDs.Length; counter++)
            {
                string emailAddress = String.Empty, emailSubject = String.Empty, emailText = String.Empty;
                bool toSend =true;
                // create their notification email object
                SubNotificationEmail subnotificationEmail = new SubNotificationEmail(InputContext);
                subnotificationEmail.CreateNotificationEmail(userIDs[counter], ref toSend, ref emailAddress, ref emailSubject,
                    ref emailText);

                if(toSend)
                {// if we have an email to send then send it
                    InputContext.SendMailOrSystemMessage(emailAddress, emailSubject, emailText, InputContext.CurrentSite.EditorsEmail,
                        InputContext.CurrentSite.ShortName, false, userIDs[counter], InputContext.CurrentSite.SiteID);
                    totalSent++;
                }
            }
            if (totalSent == 0)
            {
                XmlNode subAllocateForm = RootElement.SelectSingleNode("SUB-ALLOCATION-FORM");
                XmlNode notifSent = AddElement(subAllocateForm, "NOTIFICATIONS-SENT","");//, dataReader.GetInt32NullAsZero("Total"));
                AddAttribute(notifSent, "TOTAL", totalSent);
            }
            else
            {
                XmlNode subAllocateForm = RootElement.SelectSingleNode("SUB-ALLOCATION-FORM");
                XmlNode notifSent = AddElement(subAllocateForm, "NOTIFICATIONS-SENT", "An error occurred whilst trying to send emails");//, dataReader.GetInt32NullAsZero("Total"));
                AddAttribute(notifSent, "TYPE", "EMAIL-FAILURE");
            }
            return true;

        }

        /// <summary>
        /// Adds XML specifying a particular error type to the form object.
        /// </summary>
        /// <param name="errorType">the string value to put in the type attribute of the
        ///			error XML</param>
        /// <param name="errorText">optional text to place inside the error tag, giving
        ///			further information on the error</param>
        /// <returns>true for success or false for failure</returns>
        public bool AddErrorMessage(string errorType, string errorText)
        {



            XmlNode errorXml = AddElement(RootElement, "ERROR", errorText);
            AddAttribute(errorXml, "TYPE", errorType);
            return true;
        }
    }
}
