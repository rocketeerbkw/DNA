using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Component for management of a users blocked Subscriptions. 
    /// Blocked users cannot track the content of an author useing the subscription functionality.
    /// </summary>
    public class BlockedUserSubscriptions : DnaInputComponent
    {
        private const string _docDnaUserID = @"User ID of user whose list of blocked users is to be shown ";
        private const string _docDnaSkip = @"The number of UserSubscriptions to skip.";
        private const string _docDnaShow = @"The number of UserSubscriptions to show.";
        private const string _docDnaAction = @"Action to take on this request on the More User Subscriptions page. 'update' is the only action currently recognised";
		private const string _docDnaBlockedUser = @"User ID of the user to block or unblock";

		XmlElement _actionResult = null;
		
		/// <summary>
        /// Default constructor for the MoreUserSubscriptions component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public BlockedUserSubscriptions(IInputContext context)
            : base(context)
        {
        }

         /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            //Must be logged in.
            if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn)
            {
                //return error.
                AddErrorXml("invalidcredentials", "Must be logged in to view blocked subscriptions.", RootElement);
                return;
            }

            //Only allow a user to see their own blocked subscriptions.
            int authorId = InputContext.ViewingUser.UserID;
            int userId = 0;
            int skip = 0;
            int show = 0;
            string action = String.Empty;
			int blockedID = 0;

            TryGetPageParams(ref userId, ref skip, ref show, ref action, ref blockedID );

            //You can only see your own blocked user page. (editors and superusers too
            if (InputContext.ViewingUser.IsSuperUser || InputContext.ViewingUser.IsEditor || authorId == userId)
            {
                if (authorId == userId)
                {
                    //Process Action Here . Only the viewing user/author can update their own blocked user list
                    TryUpdateBlockedSubscriptions(action, authorId, blockedID);
                }

                GenerateBlockedUserSubscriptionsXml(userId, skip, show);
            }
            else
            {
                //return error.
                AddErrorXml("invalidcredentials", "You can only view your own blocked subscriptions.", RootElement);
                return;
            }

        }

        /// <summary>
        /// Gets params from the equest and validates input params.
        /// </summary>
        /// <param name="userId">User ID of user whose list is being shown</param>
        /// <param name="skip">Number of items to skip</param>
        /// <param name="show">Number of items to show</param>
        /// <param name="action">Action to perform</param>
		/// <param name="blockedID">ID of user to be blocked</param>
        private void TryGetPageParams(ref int userId, ref int skip, ref int show, ref string action, ref int blockedID )
        {
            userId = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);
			blockedID = InputContext.GetParamIntOrZero("blockedID", _docDnaBlockedUser);

            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = 25;
            }
            if (skip < 0)
            {
                skip = 0;
            }

            InputContext.TryGetParamString("dnaaction", ref action, _docDnaAction);
        }

        /// <summary>
        /// Generates XML for Blocked User Subscriptions.
        /// Allows the author to stop blocked users from tracking their content.
        /// </summary>
        /// <param name="userID">The ID of the user to get the list of blocked users for</param>
        /// <param name="skip">Number of blocked users to skip</param>
        /// <param name="show">Number of blocked users to show</param>
        private void GenerateBlockedUserSubscriptionsXml(int userID, int skip, int show)
        {
            XmlElement bannedUserSubscriptions = AddElementTag(RootElement, "BLOCKEDUSERSUBSCRIPTIONS");
            AddAttribute(bannedUserSubscriptions, "USERID", userID);
            bool userAcceptsSubscriptions = false;

			if (_actionResult != null)
			{
				bannedUserSubscriptions.AppendChild(_actionResult);
			}
            XmlElement bannedList = AddElementTag(bannedUserSubscriptions, "BLOCKEDUSERSUBSCRIPTIONS-LIST");
            AddAttribute(bannedList, "SKIP", skip);
            AddAttribute(bannedList, "SHOW", show);
            bannedUserSubscriptions.AppendChild(bannedList);
			XmlElement users = CreateElement("USERS");
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getblockedusersubscriptions"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", show + 1);
                dataReader.Execute();

                if (dataReader.HasRows && dataReader.Read())
                {
                    User blocker = new User(InputContext);
                    blocker.AddPrefixedUserXMLBlock(dataReader, userID, "Blocker", bannedList);

                    userAcceptsSubscriptions = dataReader.GetBoolean("BlockerAcceptSubscriptions");
                    AddAttribute(bannedUserSubscriptions, "ACCEPTSUBSCRIPTIONS", Convert.ToInt32(userAcceptsSubscriptions));

                    //Get the list from the second recordset
                    dataReader.NextResult();
                    if (dataReader.HasRows)
                    {
                        User user = new User(InputContext);
                        int count = show;
                        while (((count--) > 0) && dataReader.Read())
                        {
                            //Delegate generation of standardised User XML to User class.
                            int blockedUserId = dataReader.GetInt32NullAsZero("userid");
                            user.AddUserXMLBlock(dataReader, blockedUserId, users);
                        }
                        if (count <= 0 && dataReader.Read())
                        {
                            AddAttribute(bannedList, "MORE", 1);
                        }
                    }
                }
            }
			bannedList.AppendChild(users);

        }

        /// <summary>
        /// Adds user to blocked user subscriptions or removes them.
        /// </summary>
        /// <param name="action">Action to perform on the list</param>
        /// <param name="authorid">Author of the page thats doing the blocking</param>
        /// <param name="blockUnblockUserId">The user to block/unblock</param>
        private void TryUpdateBlockedSubscriptions(string action, int authorid, int blockUnblockUserId)
        {
            if (action == "blockusersubscription")
            {
                if (authorid != blockUnblockUserId)
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("blockusersubscription"))
                    {
                        dataReader.AddParameter("authorid", authorid);
                        dataReader.AddParameter("userid", blockUnblockUserId);
                        dataReader.Execute();
					    _actionResult = CreateElement("ACTIONRESULT");
					    AddAttribute(_actionResult, "ACTION", "blockuser");
					    while (dataReader.Read())
					    {
                            //Delegate generation of standardised User XML to User class.
                            int blockedUserID = dataReader.GetInt32NullAsZero("userid");
                            User user = new User(InputContext);
                            user.AddUserXMLBlock(dataReader, blockedUserID, _actionResult);
 					    }
                    }
                }
                else
                {
                    //Don't allow them to block themselves , just add error.
                    AddErrorXml("invalidcredentials", "You cannot block your own blocked subscriptions.", RootElement);
                }
            }
            else if (action == "unblockusersubscription")
            {
                if (authorid != blockUnblockUserId)
                {
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("unblockusersubscription"))
                    {
                        dataReader.AddParameter("authorid", authorid);
                        dataReader.AddParameter("userid", blockUnblockUserId);
                        dataReader.Execute();
					    _actionResult = CreateElement("ACTIONRESULT");
					    AddAttribute(_actionResult, "ACTION", "unblockuser");
					    while (dataReader.Read())
					    {
                            //Delegate generation of standardised User XML to User class.
                            int unblockedUserID = dataReader.GetInt32NullAsZero("userid");
                            User user = new User(InputContext);
                            user.AddUserXMLBlock(dataReader, unblockedUserID, _actionResult);
					    }
				    }
                }
                else
                {
                    //Don't allow them to unblock themselves , just add error.
                    AddErrorXml("invalidcredentials", "You cannot unblock your own blocked subscriptions.", RootElement);
                }
            }
            else if (action == "blocksubscriptions")
            {
                InputContext.ViewingUser.BeginUpdateDetails();
                InputContext.ViewingUser.SetAcceptSubscriptions(false);
                InputContext.ViewingUser.UpdateDetails();
				_actionResult = CreateElement("ACTIONRESULT");
				AddAttribute(_actionResult, "ACTION", "blocksubscriptions");
			}
            else if (action == "acceptsubscriptions")
            {
                InputContext.ViewingUser.BeginUpdateDetails();
                InputContext.ViewingUser.SetAcceptSubscriptions(true);
                InputContext.ViewingUser.UpdateDetails();
				_actionResult = CreateElement("ACTIONRESULT");
				AddAttribute(_actionResult, "ACTION", "unblocksubscriptions");
			}
        }
    }
}
