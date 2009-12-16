using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// RecommendEntryForm object
    /// </summary>
    public class RecommendEntryForm : DnaInputComponent
    {
	    private enum ArticleUpdateBits
	    {
		    ARTICLEUPDATEEDITORID		= 2,	
		    ARTICLEUPDATESTATUS			= 4,
		    ARTICLEUPDATESTYLE			= 8,
		    ARTICLEUPDATEBODY			= 16,
		    ARTICLEUPDATEEXTRAINFO		= 32,
		    ARTICLEUPDATETYPE			= 64,
		    ARTICLEUPDATESUBMITTABLE	= 128,
		    ARTICLEUPDATESUBJECT		= 256,
		    ARTICLEUPDATEPREPROCESSED	= 512,
		    ARTICLEUPDATEPERMISSIONS	= 1024,
		    ARTICLEUPDATECLUBEDITORS	= 2048,
		    ARTICLEUPDATECONTENTSIGNIF	= 4096,
		    ARTICLEUPDATEDATECREATED	= 8192
	    };

        bool _isValidRecommendation = false;
        XmlElement _recommendEntryForm = null;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public RecommendEntryForm(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Creates the XML for a blank entry recommendation form.
        /// </summary>
        public void CreateBlankForm()
        {
            RootElement.RemoveAll();
            _recommendEntryForm = AddElementTag(RootElement, "RECOMMEND-ENTRY-FORM");
            AddIntElement(_recommendEntryForm, "H2G2ID", 0);
            AddTextTag(_recommendEntryForm, "SUBJECT", "");
            AddTextTag(_recommendEntryForm, "COMMENTS", "");
            XmlElement functions = AddElementTag(_recommendEntryForm, "FUNCTIONS");
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
            _recommendEntryForm = AddElementTag(RootElement, "RECOMMEND-ENTRY-FORM");

            if(!GuideEntry.ValidateH2G2ID(H2G2ID))
            {
		        // if ID is invalid then set the flag and put an error message in the XML
                _isValidRecommendation = false;
                AddErrorXml("INVALID-H2G2ID", H2G2ID.ToString(), _recommendEntryForm);
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
                    bool hasSubCopy = dataReader.GetBoolean("HasSubCopy");
                    int subCopyID = dataReader.GetInt32NullAsZero("SubCopyID");
                    int recommendedByScoutID = dataReader.GetInt32NullAsZero("RecommendedByScoutID");
                    string recommendedByUserName = dataReader.GetStringNullAsEmpty("RecommendedByUserName");

                    // check that this entry is appropriate for recommendation and if not then
                    // assume it is valid then set to invalid if any problems found
                    _isValidRecommendation = true;
                    // give the reason why
                    // Entry not suitable reasons are:
                    //	- entry is already in edited guide
                    //	- entry is a key article
                    //	- entry is already recommended
                    //	- entry is deleted
                    //	- entry was written by the scout trying to recommend it
                    // only status value 3 (user entry, public) is actually suitable for recommendations

                    string errorType = "WRONG-STATUS";
                    if (recommendedByScoutID > 0)
                    {
                        AddErrorXml("ALREADY-RECOMMENDED", "Entry has already been recommended by <LINK BIO='U" + recommendedByScoutID.ToString(), _recommendEntryForm);
                    }
                    else if (status != 3)
                    {
                        string errorMessage = String.Empty;
                        suitable = false;
                        _isValidRecommendation = false;

                        switch (status)
                        {
                            case 0: errorMessage = "No Status";
                                break;
                            case 1: errorMessage = "Already Edited";
                                break;
                            case 2: errorMessage = "Private Entry";
                                break;
                            case 4: errorMessage = "Already Recommended";
                                break;
                            case 5: errorMessage = "Already Recommended";
                                break;
                            case 6: errorMessage = "Already Recommended";
                                break;
                            case 7: errorMessage = "Deleted";
                                break;
                            case 8: errorMessage = "Already Recommended";
                                break;
                            case 9: errorMessage = "Key Article";
                                break;
                            case 10: errorMessage = "Key Article";
                                break;
                            case 11: errorMessage = "Already Recommended";
                                break;
                            case 12: errorMessage = "Already Recommended";
                                break;
                            case 13: errorMessage = "Already Recommended";
                                break;
                            default: errorMessage = "Invalid Status";
                                break;
                        }

                        AddErrorXml(errorType, errorMessage, _recommendEntryForm);
                    }
                    else if (isSubCopy)
                    {
                        suitable = false;
                        _isValidRecommendation = false;
                        AddErrorXml(errorType, "Sub-editors draft copy for Edited Entry", _recommendEntryForm);
                    }

                    // check that scout is not the author, but allow editors to recommend
                    // their own entries should they ever wish to
                    if (user.UserID == editorID && !user.IsEditor)
                    {
                        suitable = false;
                        _isValidRecommendation = false;
                        AddErrorXml("OWN-ENTRY", "Recommender is author", _recommendEntryForm);
                    }

                    //if the user is not an editor then check that the entry is recommendable
                    if (!user.IsEditor && !RecommendEntry(h2g2ID))
                    {
                        _isValidRecommendation = false;
                        AddErrorXml("NOT-IN-REVIEW", "Not in appropriate review forum", _recommendEntryForm);
                    }

                    // if here all okay then put the data into the form
                    AddIntElement(_recommendEntryForm, "H2G2ID", h2g2ID);

                    // only add this data if the entry was suitable for recommending, since it might be
                    // from e.g. a deleted entry and hence should not be accessible
                    if (suitable)
                    {
                        AddTextTag(_recommendEntryForm, "SUBJECT", subject);
                        XmlElement editor = AddElementTag(_recommendEntryForm, "EDITOR");
                        XmlElement userTag = AddElementTag(editor, "USER");
                        AddIntElement(userTag, "USERID", editorID);
                        AddTextTag(userTag, "USERNAME", editorName);
                    }
                    AddTextTag(_recommendEntryForm, "COMMENTS", comments);
                    // now put in XML saying which functions the form should provide
                    XmlElement functions = AddElementTag(_recommendEntryForm, "FUNCTIONS");
                    AddElementTag(functions, "FETCH-ENTRY");
                    if (_isValidRecommendation)
                    {
                        AddElementTag(functions, "RECOMMEND-ENTRY");
                    }
                }
            }
        }

        private bool RecommendEntry(int H2G2ID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchreviewforummemberdetails"))
            {
                dataReader.AddParameter("h2g2id", H2G2ID);
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    int reviewForumID = dataReader.GetInt32NullAsZero("ReviewForumID");
                    DateTime dateEntered = dataReader.GetDateTime("DateEntered");
                    DateTime dateNow = DateTime.Now;
                    TimeSpan dateDiff = dateNow - dateEntered;

		            ReviewForum reviewForum = new ReviewForum(InputContext);
                    reviewForum.InitialiseViaReviewForumID(reviewForumID, false);

                    if (reviewForum.IsInitialised)
		            {
			            if (reviewForum.IsRecommendable)
			            {
				            int incubateTime = reviewForum.IncubateTime;

                            if (dateDiff.Days >= incubateTime)
				            {
					            return true;
				            }
			            }
            			
		            }
                }
	        }

	        return false;

        }

        /// <summary>
        /// Submits the recommendatoin if it is a valid one. Creates appropriate
		///		XML to report whether or not the submission was successful.
        /// </summary>
        public void SubmitRecommendation(IUser user, int H2G2ID, string comments)
        {
            bool alreadyRecommended = false;
            bool wrongStatus = false;
            bool okay = false;

            int userID = 0;
            string username = String.Empty;

            // try creating the form for this data
            CreateFromh2g2ID(user, H2G2ID, comments);


            // then check that this was successful and the recommendation was a valid
            // one before proceeding
            if (_isValidRecommendation)
            {
                // call the SP method to send the scouts submission, then fetch any fields returned
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("StoreScoutRecommendation"))
                {
                    dataReader.AddParameter("ScoutID", user.UserID);
                    dataReader.AddParameter("EntryID", H2G2ID / 10);
                    dataReader.AddParameter("Comments", comments);
                    dataReader.Execute();
                    // Check to see if we found anything
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        alreadyRecommended = dataReader.GetBoolean("AlreadyRecommended");
                        wrongStatus = dataReader.GetBoolean("WrongStatus");
                        okay = dataReader.GetBoolean("Success");
                        userID = dataReader.GetInt32NullAsZero("UserID");
                        username = dataReader.GetStringNullAsEmpty("Username");


                        // recommendation found invalid even before calling the SP
                        if (!_isValidRecommendation)
                        {
                            // add some extra error info inside the existing XML
                            AddErrorXml("INVALID-RECOMMENDATION", "Invalid Recommendation", _recommendEntryForm);
                        }
                        // status of entry was wrong
                        else if (wrongStatus)
                        {
                            // add some extra error info inside the existing XML
                            AddErrorXml("WRONG-STATUS", "Entry is not a public user entry", _recommendEntryForm);
                        }
                        // entry already recommended
                        else if (alreadyRecommended)
                        {
                            // add an error message saying who recommnded it
                            AddErrorXml("ALREADY-RECOMMENDED", "Entry has already been recommended by <LINK BIO='U" + userID.ToString() + "'>" + username + "</LINK>", _recommendEntryForm);
                        }
                        // something unspecified went wrong
                        else if (!okay)
                        {
                            AddErrorXml("UNKNOWN", "An unspecified error occurred whilst processing the request.", _recommendEntryForm);
                        }
                        // otherwise all okay!
                        else
                        {
                            //also set the guidentry to unsubmittable - upto user to manually change it back
                            BeginUpdateRecommendableArticle(H2G2ID);

                            // if submission successful then want to return a blank form so
                            // that they can submit more if they wish, so destroy current contents
                            // and create some more
                            CreateBlankForm();

                            // also want to put some XML in to indicate that recommendation was successful though
                            // stylesheet can then put whatever message is appropriate in
                            XmlElement submitted = AddElementTag(_recommendEntryForm, "SUBMITTED");
                            AddAttribute(submitted, "H2G2ID", H2G2ID);
                        }                 
                    }
                }
            }
        }
 
        private void BeginUpdateRecommendableArticle(int H2G2ID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("updateguideentry"))
            {
                dataReader.AddParameter("EntryID", H2G2ID / 10);
                dataReader.AddParameter("Submittable", false);
                dataReader.Execute();
            }
        }
    }
}
