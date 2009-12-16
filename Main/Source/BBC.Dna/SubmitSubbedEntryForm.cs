using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using System.Globalization;

namespace BBC.Dna
{
    /// <summary>
    /// SubmitSubbedEntryForm object
    /// </summary>
    public class SubmitSubbedEntryForm : DnaInputComponent
    {
        bool _isValidEntry = false;
        XmlElement _submitSubbedEntryForm = null;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public SubmitSubbedEntryForm(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Creates the XML for a blank subbed entry form.
        /// </summary>
        public void CreateBlankForm()
        {
            RootElement.RemoveAll();
            _submitSubbedEntryForm = AddElementTag(RootElement, "SUBBED-ENTRY-FORM");
            AddIntElement(_submitSubbedEntryForm, "H2G2ID", 0);
            AddTextTag(_submitSubbedEntryForm, "SUBJECT", "");
            AddTextTag(_submitSubbedEntryForm, "COMMENTS", "");
            XmlElement functions = AddElementTag(_submitSubbedEntryForm, "FUNCTIONS");
            AddTextTag(functions, "FETCH-ENTRY", "");
        }

        /// <summary>
        /// Creates the XML for a recommendation form for the entry with
		///		this entry ID.
        /// </summary>
        public void CreateFromh2g2ID(IUser user, int H2G2ID, string comments)
        {
            bool suitable = true;

            // if daft ih2g2ID value given or user then fail
            if (H2G2ID <= 0 || user.UserID == 0)
            {
                return;
            }
            RootElement.RemoveAll();
            _submitSubbedEntryForm = AddElementTag(RootElement, "SUBBED-ENTRY-FORM");

            if (!GuideEntry.ValidateH2G2ID(H2G2ID))
            {
		        // if ID is invalid then set the flag and put an error message in the XML
                _isValidEntry = false;
                AddErrorXml("INVALID-H2G2ID", H2G2ID.ToString(), _submitSubbedEntryForm);
                return;
            }

            // now check that the h2g2ID is valid and if so get the entry ID from it
            int entryID = H2G2ID / 10;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("FetchArticleSummary"))
            {
                dataReader.AddParameter("EntryID", entryID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    int h2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
                    string subject = dataReader.GetStringNullAsEmpty("Subject");
                    string editorName = dataReader.GetStringNullAsEmpty("EditorName");
                    int editorID = dataReader.GetInt32NullAsZero("EditorID");
                    int status = dataReader.GetInt32NullAsZero("Status");
                    bool isSubCopy = dataReader.GetBoolean("IsSubCopy");

                    int originalEntryID = dataReader.GetInt32NullAsZero("OriginalEntryID");


                    bool hasSubCopy = dataReader.GetBoolean("HasSubCopy");
                    int subCopyID = dataReader.GetInt32NullAsZero("SubCopyID");

                    int recommendationStatus = dataReader.GetInt32NullAsZero("RecommendationStatus");
                    int recommendedByScoutID = dataReader.GetInt32NullAsZero("RecommendedByScoutID");
                    string scoutName = dataReader.GetStringNullAsEmpty("RecommendedByUserName");

                    string retrievedComments = dataReader.GetStringNullAsEmpty("Comments");

                    // check that this entry is appropriate for recommendation and if not then
                    // assume it is valid then set to invalid if any problems found
                    _isValidEntry = true;
                    // give the reason why
                    // Entry not suitable reasons are:
                    //	- entry is already in edited guide
                    //	- entry is a key article
                    //	- entry is already recommended
                    //	- entry is deleted
                    //	- entry was written by the scout trying to recommend it
                    // only status value 3 (user entry, public) is actually suitable for recommendations

                    string errorType = "WRONG-STATUS";
                    if (!isSubCopy)
                    {
                        _isValidEntry = false;
                        AddErrorXml(errorType, "Not Sub-editors draft copy for Edited Entry", _submitSubbedEntryForm);
                        return;
                    }

                    // if here all okay then put the data into the form
                    AddIntElement(_submitSubbedEntryForm, "H2G2ID", h2g2ID);

                    // only add this data if the entry was suitable for recommending, since it might be
                    // from e.g. a deleted entry and hence should not be accessible
                    if (suitable)
                    {
                        AddTextTag(_submitSubbedEntryForm, "SUBJECT", subject);
                        XmlElement editor = AddElementTag(_submitSubbedEntryForm, "EDITOR");
                        XmlElement userTag = AddElementTag(editor, "USER");
                        AddIntElement(userTag, "USERID", editorID);
                        AddTextTag(userTag, "USERNAME", editorName);
                    }
                    AddTextTag(_submitSubbedEntryForm, "COMMENTS", retrievedComments);
                    // now put in XML saying which functions the form should provide
                    XmlElement functions = AddElementTag(_submitSubbedEntryForm, "FUNCTIONS");
                    AddElementTag(functions, "FETCH-ENTRY");
                    if (_isValidEntry)
                    {
                        AddElementTag(functions, "SUBMIT-ENTRY");
                    }
                }
            }
        }

        /// <summary>
        /// Submits the entry as finished with by the sub editor. Creates appropriate
		///		XML to report whether or not the submission was successful.
        /// </summary>
        public void SubmitSubbedEntry(IUser user, int H2G2ID, string comments)
        {
            bool invalidEntry = false;
            bool userNotSub = false;
            bool okay = false;
            int recommendationStatus = 0;
            DateTime dateReturned;

            // try creating the form for this data
            CreateFromh2g2ID(user, H2G2ID, comments);

            // then check that this was successful and the recommendation was a valid
            // one before proceeding
            if (_isValidEntry)
            {
                // call the SP method that submits an entry that has been subbed and needs to be returned to
				//the editors.
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("SubmitReturnedSubbedEntry"))
                {
                    dataReader.AddParameter("UserID", user.UserID);
                    dataReader.AddParameter("EntryID", H2G2ID / 10);
                    dataReader.AddParameter("Comments", comments);
                    dataReader.Execute();
                    // Check to see if we found anything
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        invalidEntry = dataReader.GetBoolean("InvalidEntry");
                        userNotSub = dataReader.GetBoolean("UserNotSub");
                        okay = dataReader.GetBoolean("Success");
                        recommendationStatus = dataReader.GetInt32NullAsZero("RecommendationStatus");
                        dateReturned = dataReader.GetDateTime("DateReturned");

                        // found invalid even before calling the SP
                        if (!_isValidEntry)
                        {
                            // add some extra error info inside the existing XML
                            AddErrorXml("INVALID-SUBMISSION", "Invalid Submission", _submitSubbedEntryForm);
                        }
                        // entry is not in the accepted recommendations
                        else if (invalidEntry)
                        {
                            // add some extra error info inside the existing XML
                            AddErrorXml("INVALID-ENTRY", "Entry is not in the list of accepted scout recommendations", _submitSubbedEntryForm);
                        }
                        // user is not the sub for this entry
                        else if (userNotSub)
                        {
                            // add an error message saying who recommnded it
                            AddErrorXml("NOT-SUB", "You are not the Sub Editor for this Entry", _submitSubbedEntryForm);
                        }
                        else if (recommendationStatus != 2)
                        {
                            string message;
                            // get the date in a simple format
                            CultureInfo culture = new CultureInfo("en-GB");      
                            switch (recommendationStatus)
                            {
                                case 0: message = "Recommendation has no status";
                                    break;
                                case 1: message = "Recommendation has not yet been allocated to a Sub Editor";
                                    break;
                                case 3: message = "Recommendation has already been submitted on " + dateReturned.ToString("dd-MM-yyyy", culture);
                                    break;
                                default: message = "Recommendation has wrong status";
                                    break;
                            }
                            AddErrorXml("WRONG-STATUS", message, _submitSubbedEntryForm);
                        }
                        // something unspecified went wrong
                        else if (!okay)
                        {
                            AddErrorXml("UNKNOWN", "An unspecified error occurred whilst processing the request.", _submitSubbedEntryForm);
                        }
                        // otherwise all okay!
                        else
                        {
                            // if submission successful then want to return a blank form so
                            // that they can submit more if they wish, so destroy current contents
                            // and create some more
                            CreateBlankForm();

                            // also want to put some XML in to indicate that recommendation was successful though
                            // stylesheet can then put whatever message is appropriate in
                            XmlElement submitted = AddElementTag(_submitSubbedEntryForm, "SUBMITTED");
                            AddAttribute(submitted, "H2G2ID", H2G2ID);
                        }                 
                    }
                }
            }
        }
    }
}
