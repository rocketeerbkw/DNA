using System;
using System.Collections.Generic;
using System.Xml;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class containing code for the DNA voting system based on 
    /// (i.e. copied from ) Mark Howitts C++ CVote class
    /// </summary>
    public class Vote : DnaInputComponent
    {
        private int _voteID = 0;
        private string _voteName = String.Empty;
        private int _type = 0;
        private DateTime _createdDate = DateTime.MinValue;
        private DateTime _closingDate = DateTime.MinValue;
        private bool _isYesNoVoting = true;
        private int _ownerID = 0;

        /// <summary>
        /// External VoteTpe
        /// </summary>
        public enum VoteType
	    {
            /// <summary>
            /// Vote club type
            /// </summary>
		    VOTETYPE_CLUB = 1,
            /// <summary>
            /// Vote notice type
            /// </summary>
		    VOTETYPE_NOTICE = 2
	    };

        /// <summary>
        /// Class holds the the methods pertaining to Voting
        /// </summary>
        public Vote(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// VoteID Property
        /// </summary>
        public int VoteID
        {
            get
            {
                return _voteID;
            }
        }

        /// <summary>
        /// Vote Name Property
        /// </summary>
        public string VoteName
        {
            get
            {
                return _voteName;
            }
        }

        /// <summary>
        /// Type Property
        /// </summary>
        public int Type
        {
            get
            {
                return _type;
            }
        }

        /// <summary>
        /// CreatedDate Property
        /// </summary>
        public DateTime CreatedDate
        {
            get
            {
                return _createdDate;
            }
        }

        /// <summary>
        /// ClosingDate Property
        /// </summary>
        public DateTime ClosingDate
        {
            get
            {
                return _closingDate;
            }
        }
        /// <summary>
        /// IsYesNoVoting Property
        /// </summary>
        public bool IsYesNoVoting
        {
            get
            {
                return _isYesNoVoting;
            }
        }
        /// <summary>
        /// OwnerID Property
        /// </summary>
        public int OwnerID
        {
            get
            {
                return _ownerID;
            }
        }


        /// <summary>
        /// Clears the votes data
        /// </summary>
        public void ClearVote()
        {
	        _voteID = 0;
	        _voteName = String.Empty;
	        _type = 0;
	        _createdDate = DateTime.MinValue;
	        _closingDate = DateTime.MinValue;
	        _isYesNoVoting = true;
	        _ownerID = 0;
        }

        /// <summary>
        /// Resets the vote object and also changes to Database pointer if required.
        /// </summary>
        public void ResetVote()
        {
	        ClearVote();
        }

        /// <summary>
        /// Checks to see if the current vote is closed or not
        /// </summary>
        /// <returns>Whether the vote is closed</returns>
        bool IsVoteClosed()
        {
            bool IsClosed = false;

	        if (_createdDate == DateTime.MinValue)
	        {
		        throw new DnaException("Dates not setup!");
	        }
	        else if (_closingDate == DateTime.MinValue || _closingDate < _createdDate)
	        {
		        // The vote never closes
		        IsClosed = false;
	        }
	        else
	        {
		        // Check to see if the current date is greater than the closing.
		        // If so, the vote is closed!
		        IsClosed = _closingDate < DateTime.Now ? true : false;
	        }

	        return IsClosed;
        }

        /// <summary>
        /// Gets the pending and completed actions for a given club and returns the xml 
        /// to be inserted into the tree.
        /// </summary>
        /// <param name="type">The type of the vote. This defines if it lives on a club, article ..</param>
        /// <param name="closingDate">The date at which the voting stops. Can be NULL which means no closing date</param>
        /// <param name="ownerID"> The owner of the vote. This is OwnerMembers for Clubs for club votes!</param>
        /// <param name="useYesNoVoting">useYesNoVoting</param>
        /// <returns>The new VoteID for the created vote. 0 if the creation failed!</returns>
        public int CreateVote(int type, DateTime closingDate, int ownerID, bool useYesNoVoting)
        {
	        // Ensure the vote is clear before we start
	        ClearVote();

            string storedProcedureName = @"createnewvote";

            // Now create the vote with the given info
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
	            // Add the type
	            dataReader.AddParameter("itype", type);

	            if (closingDate > DateTime.Now)
	            {
		            dataReader.AddParameter("dclosedate", closingDate);
	            }
	            else
	            {
		            dataReader.AddParameter("dclosedate", null);
	            }

                if (useYesNoVoting == true)
                {
	                dataReader.AddParameter("iyesno", 1);
                }
                else
                {
	                dataReader.AddParameter("iyesno", 0);
                }
	            dataReader.AddParameter("iownerid", ownerID);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        // Setup the member variables from the stored procedure results.
                        _voteID = dataReader.GetInt32NullAsZero("VoteID");
                        _type = type;
                        _createdDate = dataReader.GetDateTime("DateCreated");
                        _closingDate = closingDate;
                        _isYesNoVoting = useYesNoVoting;
                        _ownerID = ownerID;
                    }
                }

            }
            // Return the unique vote id
            return _voteID;
        }

        /// <summary>
        /// Gets and Populates the Vote given a VoteID
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to get the details for.</param>
        /// <returns>true if details found. false if something failed</returns>
        public bool GetVote(int voteID)
        {
	        // Make sure the vote id is valid
	        if (voteID <= 0)
	        {
		        return false;
	        }

	        // Now call the stored procedure
            string storedProcedureName = @"getvotedetails";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("ivoteID", voteID);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
	                    // Clear the vote and setup from the result set
	                    ClearVote();
                        _voteID = dataReader.GetInt32NullAsZero("VoteID");
	                    _voteName = dataReader.GetStringNullAsEmpty("VoteName");
	                    _type = dataReader.GetInt32NullAsZero("Type");
	                    _createdDate = dataReader.GetDateTime("DateCreated");
	                    _closingDate = dataReader.GetDateTime("ClosingDate");
	                    _isYesNoVoting = dataReader.GetInt32NullAsZero("YesNoVoting") > 0 ? true : false;
	                    _ownerID = dataReader.GetInt32NullAsZero("OwnerID");
                    }
                }
            }

	        return true;
        }

        /// <summary>
        /// Gets all the users who have voted on a given vote with a given response.
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to get the users for.</param>
        /// <param name="response">The Response to match for.</param>
        /// <returns>true if ok, false if not</returns>
        public bool GetAllUsersWithResponse(int voteID, int response)
        {
            XmlElement visibleUsers = CreateElement("VisibleUsers");
	        // Get all the current users who have already voted with the same result
            string storedProcedureName = @"getallvotinguserswithresponse";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
	            // Add the VoteID and Response
	            dataReader.AddParameter("ivoteid", voteID)
	                        .AddParameter("iresponse", response)
	                        .AddParameter("isiteid", InputContext.CurrentSite.SiteID);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
	                    // Setup some local variables
	                    int hiddenUsersCount = 0;
	                    int visibleUsersCount = 0;

	                    // Go through the results adding the data to the XML
	                    do
	                    {
		                    // Get the user ID
		                    int userID = dataReader.GetInt32NullAsZero("UserID");
		                    if (userID == 0)
		                    {
			                    // We've got a anonymous user! These are always hidden!
			                    hiddenUsersCount++;
		                    }
		                    else
		                    {
			                    // Check to see if the user wanted to be hidden
			                    if (dataReader.GetInt32NullAsZero("Visible") > 0)
			                    {
                                    User user = new User(InputContext);
                                    user.AddUserXMLBlock(dataReader, userID, visibleUsers);
				                    visibleUsersCount++;
			                    }
			                    else
			                    {
				                    // Hidden user, just increment the count
				                    hiddenUsersCount++;
			                    }
		                    }

		                // Get the next entry
	                    }while(dataReader.Read());

	                    // Add the hidden users
	                    // Initialise the XML Builder
                    
                        XmlElement votingUsers = CreateElement("VotingUsers");
                        votingUsers.SetAttribute("Response", response.ToString());
	                    visibleUsers.SetAttribute("Count", visibleUsersCount.ToString());
                        votingUsers.AppendChild(visibleUsers);

                        XmlElement hiddenUsers = CreateElement("HiddenUsers");
	                    hiddenUsers.SetAttribute("Count", hiddenUsersCount.ToString());
                        votingUsers.AppendChild(hiddenUsers);	                    
                        visibleUsers.AppendChild(votingUsers);	                    
                    }
                }
                else
                {
		            throw new DnaException("Vote - FailedGettingUsersForVote - Failed to get the users alreay voted");
	            }
            }

	        return true;
        }

        /// <summary>
        /// Adds a users response to a given vote.
		/// The ThreadID is defaulted to 0 and if not zero then this function
		///	assumes that we are adding votes to the threadvotes.
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to add a response to</param>
        /// <param name="userID">the id of the user adding a response</param>
        /// <param name="BBCUID">The BBCID for the user. Can be empty if not known</param>
        /// <param name="response">The actual response </param>
        /// <param name="isVisible">a flag to say if the user wants to be anonymous</param>
        /// <param name="threadID">A ThreadID of a notice if voting on notices.</param>
        /// <returns>true if details found.</returns>
        public bool AddResponseToVote(int voteID, int userID, string BBCUID,
							          int response, bool isVisible, int threadID)
        {
            string storedProcedureName = @"addresponsetovote";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
	            // Add the VoteID
	            dataReader.AddParameter("ivoteid", voteID)
	                      .AddParameter("iuserid", userID);
	
	            // Add the UID to the param list
	            //string hash;
                //TODO GenerateHash
	            //StringUtils.GenerateHash(sBBCUID,sHash);
	            //if (!AddUIDParam(sHash))
	            //{
	            //	return false;
	            //}

	            dataReader.AddParameter("iresponse", response)
	                        .AddParameter("bvisible", isVisible ? 1 : 0)
                            .AddParameter("isiteid", InputContext.CurrentSite.SiteID);

	            if (threadID > 0)
	            {
		            dataReader.AddParameter("ithreadid", threadID);
	            }
	            else
	            {
		            dataReader.AddParameter("ithreadid", DBNull.Value);
	            }
                dataReader.Execute();
            }

	        return true;
        }

        /// <summary>
        /// Gets the object id from the voteid
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to add a response to</param>
        /// <param name="type">The type of object you want to get the id of.</param>
        /// <returns>A return id of the object found.</returns>
        public int GetObjectIDFromVoteID(int voteID, int type)
        {
            string storedProcedureName = String.Empty;
            int objectID = 0;

            // Set up the procedure
	        if (type == 1)//VoteType.VOTETYPE_CLUB)
	        {
		        storedProcedureName = @"getclubidfromvoteid";
	        }
	        else if (type == 2)//VoteType.VOTETYPE_NOTICE)
	        {
		        storedProcedureName = @"getthreadidfromvoteid";
	        }
	        else
	        {
		        throw new DnaException("Invalid Object type given to GetObjectIDFromVoteID!");
	        }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {

	            // Add the VoteID
	            dataReader.AddParameter("ivoteid", voteID);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
	                    // Get the ObjectID and return 
	                    objectID = dataReader.GetInt32NullAsZero("ObjectID");
                    }
                }
            }
 	        return objectID;
       }

        /// <summary>
        /// Adds a vote to the clubsvotes table.
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to add to the club table</param>
        /// <param name="clubID">the id of the club to add the vote to</param>
        /// <returns>ClubName</returns>
        public string AddVoteToClubTable(int voteID, int clubID)
        {
            string storedProcedureName = @"addvotetoclubtable";
            string clubName = String.Empty;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the ClubID and VoteID
                dataReader.AddParameter("iClubid", clubID)
                            .AddParameter("iVoteid", voteID);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
	                    clubName = dataReader.GetStringNullAsEmpty("Name");
                    }
                }
            }

	        return clubName;
        }

        /// <summary>
        /// Adds a vote to the threadsvotes table.
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to add to the threadvotes table</param>
        /// <param name="threadID">The id of the thread to add the vote to</param>
        public void AddVoteToThreadTable(int voteID, int threadID)
        {
            string storedProcedureName = @"addvotetothreadtable";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the ClubID and VoteID
                dataReader.AddParameter("iThreadid", threadID)
                            .AddParameter("iVoteid", voteID);

                dataReader.Execute();
            }
        }

        /// <summary>
        /// Checks to see if the user with a given ID and BBCUID has voted before.
        /// </summary>
        /// <param name="voteID">The id of the vote you want to check against.</param>
        /// <param name="userID">The id of the user you want to check for - Can be 0 for Non-Signed in users.</param>
        /// <param name="BBCUID">The UID for the current user.</param>
        /// <returns>Whether the user has already voted</returns>
        public bool HasUserAlreadyVoted(int voteID, int userID, string BBCUID)
        {
            string storedProcedureName = @"hasuseralreadyvoted2";
            bool hasAlreadyVoted = false;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the ClubID and VoteID
                dataReader.AddParameter("iVoteid", voteID)
                            .AddParameter("iUserid", userID)
                            .AddParameter("uid", BBCUID);

                // Add the UID to the param list
	            //string hash;
                //TODO GenerateHash
	            //StringUtils.GenerateHash(sBBCUID,sHash);
	            //if (!AddUIDParam(sHash))
	            //{
	            //	return false;
	            //}


                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        int alreadyVoted = dataReader.GetInt32NullAsZero("AlreadyVoted");
                        if (alreadyVoted == 1)
                        {
                            hasAlreadyVoted = true;
                        }
                    }
                }
            }
	        return hasAlreadyVoted;
        }

        /// <summary>
        /// States whether the given user can create a vote
        /// </summary>
        /// <param name="itemID">The id of the vote you want to check against.</param>
        /// <param name="voteType">The type of the vote. This defines if it lives on a club, article ..</param>
        /// <param name="userID">The id of the user you want to check for</param>
        /// <returns>Whether the user can create a vote</returns>
        public bool IsUserAuthorisedToCreateVote(int itemID, int voteType, int userID)
        {
            bool IsUserAuthorised = false;
            string storedProcedureName = @"IsUserAuthorisedToCreateVote";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the ClubID and VoteID
                dataReader.AddParameter("iItemID", itemID)
                            .AddParameter("iVoteType", voteType)
                            .AddParameter("iUserID", userID);

                // Add the UID to the param list
                //string hash;
                //TODO GenerateHash
                //StringUtils.GenerateHash(sBBCUID,sHash);
                //if (!AddUIDParam(sHash))
                //{
                //	return false;
                //}

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        int userAuthorised = dataReader.GetInt32NullAsZero("IsAuthorised");
                        if (userAuthorised == 1)
                        {
                            IsUserAuthorised = true;
                        }
                    }
                }
            }
            return IsUserAuthorised;
        }

        /// <summary>
        /// Removes the user vote for a given vote id
        /// </summary>
        /// <param name="voteID">The ID of the vote you want to remove the vote on.</param>
        /// <param name="userID">The Users id to remove the vote for.</param>
        public void RemoveUsersVote(int voteID, int userID)
        {
	        // Try to remove the given user
            string storedProcedureName = @"RemoveUsersVote";
            int removed = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the ClubID and VoteID
                dataReader.AddParameter("VoteID", voteID)
                            .AddParameter("UserID", userID);

                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        removed = dataReader.GetInt32NullAsZero("Removed");
                    }
                }
            }

            XmlElement removeVote = CreateElement("REMOVEVOTE");
            AddIntElement(removeVote, "Removed", removed);
            AddIntElement(removeVote, "VoteID", voteID);
            AddIntElement(removeVote, "UserID", userID);
        }

        /// <summary>
        /// Get all the items a user has voted for, fills out the Xml structure
        /// </summary>
        /// <param name="userID">id of the user whose votes are to be obtained</param>
        /// <param name="siteID">the id of the site - usually 16 for action network</param>
        public void GetVotesCastByUser( int userID, int siteID)
        {
            string storedProcedureName = @"getvotescastbyuser";
            XmlElement voteItems = CreateElement("VOTEITEMS");

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the userID and siteID
                dataReader.AddParameter("iuserid", userID)
                            .AddParameter("isiteid", siteID);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
		                int objectID=0;
		                int voteID=0;
                        string type = String.Empty;

                        do
                        {
                            XmlElement voteItem = CreateElement("VOTEITEM");

		                    objectID = dataReader.GetInt32("OBJECTID");
		                    voteID = dataReader.GetInt32("VOTEID");
                            type = dataReader.GetStringNullAsEmpty("TYPE");

                            AddIntElement(voteItem, "OBJECTID", objectID);
                            AddIntElement(voteItem, "VOTEID", voteID);
                            AddIntElement(voteItem, "FORUMID", dataReader.GetInt32NullAsZero("FORUMID"));
                            AddIntElement(voteItem, "RESPONSE", dataReader.GetInt32NullAsZero("RESPONSE"));
                            AddTextElement(voteItem, "TITLE", dataReader.GetStringNullAsEmpty("TITLE"));
                            AddTextElement(voteItem, "TYPE", type);
                            AddDateXml(dataReader, voteItem, "DATEVOTED", "DATEVOTED");
                            AddDateXml(dataReader, voteItem, "DATECREATED", "DATECREATED");
                            AddIntElement(voteItem, "CREATORID", dataReader.GetInt32NullAsZero("CREATORID"));
                            AddTextElement(voteItem, "CREATORUSERNAME", dataReader.GetStringNullAsEmpty("CREATORUSERNAME"));
                            voteItems.AppendChild(voteItem);

                            //int visible = 0;
                            //int hidden = 0;
                            type = type.ToLower();

			                if(type == @"notice")
			                {
                                /*
				                // NUMBER OF SUPPORTS				
                                CNotice notice(InputContext);
                                XmlElement noticeVotes = CreateElement("NOTICEVOTES");

				                if (notice.GetNumberOfSupportersForNotice(objectID,voteID,visible,hidden) && voteID > 0))
				                {					
                                    AddIntElement(noticeVotes, "VISIBLE", visible);
                                    AddIntElement(noticeVotes, "HIDDEN", hidden);
				                }
				                else
				                {
					                throw new DnaException("Notice - NoticeVotes - Failed to get the number of supporters for Notice");															
				                }
                                */
                            }

			                if(type == @"club")
			                {
                                //Yes Votes
                                XmlElement clubYesVotes = CreateElement("CLUBYESVOTES");
                               
			                    if (!FillVoteXml(clubYesVotes, voteID, 1))
			                    {					
				                    throw new DnaException("Club - GetYesVoteDetails - Failed to get the number of yes votes with response");										
			                    }

			                    // No Votes
                                XmlElement clubNoVotes = CreateElement("CLUBNOVOTES");

			                    if (!FillVoteXml(clubNoVotes, voteID, 0))
			                    {
				                    throw new DnaException("Club - GetNoVoteDetails - Failed to get the number of no votes with response");									
			                    }
			                }			
                        }while(dataReader.Read());
                    }
                }
	        }
        }

        /// <summary>
        /// Fills in the Vote details in the xml for the club votes
        /// </summary>
        /// <param name="clubVotes">The xml block to fill in</param>
        /// <param name="voteID">The vote id </param>
        /// <param name="response">response of the vote to fill in yes=1 no=0</param>
        /// <returns>completes ok</returns>
        protected bool FillVoteXml(XmlElement clubVotes, int voteID, int response)
        {
            string storedProcedureName = @"getnumberofvoteswithresponse";

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                // Add the voiteid and response
                dataReader.AddParameter("ivoteid", voteID)
                            .AddParameter("iresponse", response);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        AddIntElement(clubVotes, "VISIBLE", dataReader.GetInt32NullAsZero("Visible"));
                        AddIntElement(clubVotes, "HIDDEN", dataReader.GetInt32NullAsZero("Hidden"));
                    }
                }
            }
            return true;
        }
    }
}
