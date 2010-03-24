using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// SubAllocationForm - creates form elements
    /// </summary>
    public class SubAllocationForm : DnaInputComponent
    {

        private const string _subAllocationTag = "SUB-ALLOCATION-FORM";

        /// <summary>
        /// Default constructor of SubAllocationForm
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SubAllocationForm(IInputContext context)
            : base(context)
        {
            
        }



        /// <summary>
        /// Gets the list of sub editors and their details and inserts the
		///		XML representation into this form object.
        /// </summary>
        /// <returns>true for success or false for failure</returns>
        public bool InsertSubEditorList()
        {
            RootElement.RemoveAll();
            AddElementTag(RootElement, "SUB-EDITORS");
            UserList userList = new UserList(InputContext);
            if (!userList.CreateSubEditorsList())
            {
                return false;
            }
            //add to document
            ImportAndAppend(userList.RootElement.FirstChild, "/DNAROOT/SUB-EDITORS");
            return true;

        }

        /// <summary>
        /// Submits the automatic allocation of the next iNumberToAllocate entries
        ///		from the accepted recommendations queue to this sub editor.
        /// </summary>
        /// <param name="subID">Sub editor user id</param>
        /// <param name="allocatorID">Allocator User ID</param>
        /// <param name="comments">Any comments about entries</param>
        /// <param name="entryIDs">Total number allocated -returned</param>
        /// <returns>Whether allocations submitted successfully</returns>
        public bool SubmitAllocation(int subID, int allocatorID, string comments, int[] entryIDs)
        {
            //if no entries then return false
            if (entryIDs == null || entryIDs.Length == 0)
                return false;

            //prepare XML Doc
            

            

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("AllocateEntriesToSub"))
            {
                //input entries to db
                dataReader.AddParameter("SubID", subID);
                dataReader.AddParameter("AllocatorID", allocatorID);
                if (String.IsNullOrEmpty(comments))
                {
                    dataReader.AddParameter("Comments", comments);
                }
                for (int i = 0; i < entryIDs.Length; i++)
                {
                    dataReader.AddParameter(String.Format("id{0}", i), entryIDs[i]);
                }
                dataReader.Execute();

                if(!dataReader.HasRows)
                    return false;

                //process allocation data and add XML
                XmlNode successfulAllocations = AddElementTag(RootElement, "SUCCESSFUL-ALLOCATIONS");
                XmlNode failedAllocations = AddElementTag(RootElement, "FAILED-ALLOCATIONS");
                int totalFailed     =0;
                int totalSuccess    =0;

                while(dataReader.Read())
                {
                    int userID = dataReader.GetInt32NullAsZero("SubEditorID");
                    if (userID != subID)
                    {//increment failed count and create allocation XML
                        totalFailed++;

                        XmlElement failedAllocation = CreateElement("ALLOCATION");
                        AddIntElement(failedAllocation, "H2G2-ID", dataReader.GetInt32NullAsZero("h2g2ID"));
                        AddTextElement(failedAllocation, "SUBJECT", dataReader.GetAmpersandEscapedStringNullAsEmpty("Subject"));

                        XmlElement userXML = CreateElement("USER");
                        AddIntElement(userXML, "USERID", userID);
                        AddTextElement(userXML, "USERNAME", dataReader.GetAmpersandEscapedStringNullAsEmpty("Username"));
                        failedAllocation.AppendChild(userXML);

                        AddIntElement(failedAllocation, "STATUS", dataReader.GetInt32NullAsZero("Status"));

                        if (!dataReader.IsDBNull("DateAllocated"))
                        {
                            XmlElement dateAllocated = CreateElement("DATE-ALLOCATED");
                            dateAllocated.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dataReader.GetDateTime("DateAllocated")));
                            failedAllocation.AppendChild(dateAllocated);
                        }

                        failedAllocations.AppendChild(failedAllocation);

                    }
                    else
                    {// otherwise increment the number of successful allocations
                        totalSuccess++;
                    }

                    
                }
                AddAttribute(successfulAllocations, "TOTAL", totalSuccess);
                AddAttribute(failedAllocations, "TOTAL", totalFailed);

            }
            return true;
        }

        /// <summary>
        /// Submits the automatic allocation of the next iNumberToAllocate entries
		///		from the accepted recommendations queue to this sub editor.
        /// </summary>
        /// <param name="subID">Sub editor user id</param>
        /// <param name="numberToAllocation">Number to allocation</param>
        /// <param name="allocatorID">Allocator User ID</param>
        /// <param name="comments">Any comments about entries</param>
        /// <param name="totalAllocated">Total number allocated -returned</param>
        /// <returns>Whether allocations submitted successfully</returns>
        public bool SubmitAutoAllocation(int subID, int numberToAllocation, int allocatorID, string comments, ref int totalAllocated)
        {
            //prepare XML Doc
            

            XmlNode subbedArticles = RootElement;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("AutoAllocateEntriesToSub"))
            {
                dataReader.AddParameter("SubID", subID);
                dataReader.AddParameter("AllocatorID", allocatorID);
                dataReader.AddParameter("NumberOfEntries", numberToAllocation);
                dataReader.AddParameter("Comments", comments);
                dataReader.Execute();
                if (dataReader.Read())
                {
                    totalAllocated = dataReader.GetInt32NullAsZero("TotalAllocated");
                }
                else
                {
                    return false;
                }
            }

            XmlNode successfulAllocations = AddElementTag(RootElement, "SUCCESSFUL-ALLOCATIONS");
            AddAttribute(successfulAllocations, "TOTAL", totalAllocated);

            XmlNode failedAllocations = AddElementTag(RootElement, "FAILED-ALLOCATIONS");
            AddAttribute(failedAllocations, "TOTAL", numberToAllocation - totalAllocated);
            return true;
        }

        /// <summary>
        /// Deallocates the specified entries from whichever sub editor they
        /// happen to be allocated to currently, so long as they have not
		///	already been returned.
        /// </summary>
        /// <param name="deallocatorID">user doing the deallocation</param>
        /// <param name="entryIDs">array of entry IDs to be deallocated</param>
        /// <param name="totalDeallocated">total number of entries in the array</param>
        /// <returns></returns>
        public bool SubmitDeallocation(int deallocatorID, int[] entryIDs, ref int totalDeallocated)
        {
            //if no entries then return false
            if (entryIDs == null || entryIDs.Length == 0)
                return false;

            //prepare XML Doc




            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("deallocateentriesfromsubs"))
            {
                dataReader.AddParameter("deallocatorid", deallocatorID);
                for (int i = 0; i < entryIDs.Length; i++)
                {
                    dataReader.AddParameter(String.Format("id{0}", i), entryIDs[i]);
                }
                dataReader.AddParameter("currentsiteid", InputContext.CurrentSite.SiteID);
                dataReader.Execute();

                //if nothing returned then fail
               

                //setup allocation elements and counters
                XmlNode successfulAllocations = AddElementTag(RootElement, "SUCCESSFUL-DEALLOCATIONS");
                XmlNode failedAllocations = AddElementTag(RootElement, "FAILED-DEALLOCATIONS");
                int totalFailed = 0;
                int totalSuccess = 0;


                if (dataReader.HasRows)
                {

                    // check the stauts of the entries returned to see if any couldn't be deallocated
                    // because they had already been returned
                    while (dataReader.Read())
                    {
                        // stauts should now be 1 = 'Accepted' or something went wrong
                        if (dataReader.GetInt32NullAsZero("Status") == 1)
                        {//success so increment
                            totalSuccess++;
                        }
                        else
                        {//add error xml
                            totalFailed++;

                            XmlElement failedAllocation = CreateElement("DEALLOCATION");
                            AddElement(failedAllocation, "H2G2-ID", dataReader.GetInt32NullAsZero("h2g2ID").ToString());
                            AddElement(failedAllocation, "SUBJECT", dataReader.GetAmpersandEscapedStringNullAsEmpty("sSubject"));
                            //get full user object
                            User user = new User(InputContext);
                            user.AddUserXMLBlock(dataReader, dataReader.GetInt32NullAsZero("userID"), failedAllocation);

                            AddElement(failedAllocation, "STATUS", dataReader.GetInt32NullAsZero("Status").ToString());
                            if (!dataReader.IsDBNull("DateAllocated"))
                            {
                                XmlElement dateAllocated = CreateElement("DATE-RETURNED");
                                dateAllocated.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dataReader.GetDateTime("DateReturned")));
                                failedAllocation.AppendChild(dateAllocated);
                            }
                        }
                        dataReader.NextResult();
                    }
                }
                else
                {//all deallocated so none returned
                    totalSuccess = entryIDs.Length;
                }
                AddAttribute(successfulAllocations, "TOTAL", totalSuccess);
                AddAttribute(failedAllocations, "TOTAL", totalFailed);
                totalDeallocated = totalSuccess;

                return true;
            }
        }

        /// <summary>
        /// Inserts the total number of subs who have not yet been notified of
		///		their most recent batch of allocations.
        /// </summary>
        /// <returns>true for success or false for failure</returns>
        public bool InsertNotificationStatus()
        {


            RootElement.RemoveAll();
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchUnnotifiedSubsTotal"))
            {
                dataReader.Execute();
                if (dataReader.HasRows && dataReader.Read())
                {
                    AddIntElement(RootElement, "UNNOTIFIED-SUBS", dataReader.GetInt32NullAsZero("Total"));
                }
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
