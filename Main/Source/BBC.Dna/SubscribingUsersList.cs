using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;

namespace BBC.Dna
{
	/// <summary>
	/// Class to create a list of users subscribed to a paricular user's pages
	/// </summary>
	public class SubscribingUsersList : DnaInputComponent
	{
        bool _userAcceptsSubscriptions = false;
        
        /// <summary>
		/// Constructor
		/// </summary>
		/// <param name="context">Input context for this request</param>
		public SubscribingUsersList(IInputContext context)
			: base(context)
		{
		}

        /// <summary>
        /// Field for the _userAcceptsSubscriptions field whether the user that the list has been gather for Accepts Subscriptions
        /// </summary>
        public bool UserAcceptsSubscriptions
        {
            get { return _userAcceptsSubscriptions; }
        }

		/// <summary>
		/// Create the XML for the subscribedUsers list
		/// </summary>
		/// <param name="userID">ID of user whose list we want</param>
		/// <param name="skip">skip to this index in the list</param>
		/// <param name="show">show this many items in the list</param>
		/// <returns></returns>
		public bool CreateSubscribingUsersList(int userID, int skip, int show)
		{
			// check object is not already initialised
			if (userID <= 0 || show <= 0)
			{
				return false;
			}

			int count = show;

			XmlElement SubscribingUsersList = AddElementTag(RootElement, "SUBSCRIBINGUSERS-LIST");
			AddAttribute(SubscribingUsersList, "SKIP", skip);
			AddAttribute(SubscribingUsersList, "SHOW", show);

			using (IDnaDataReader dataReader = GetSubscribingUsersList(userID, skip, show + 1))	// Get +1 so we know if there are more left
			{
				// Check to see if we found anything
				string userName = String.Empty;
				if (dataReader.HasRows && dataReader.Read())
				{
					User subscribedTo = new User(InputContext);
                    subscribedTo.AddPrefixedUserXMLBlock(dataReader, userID, "subscribedTo", SubscribingUsersList);

                    _userAcceptsSubscriptions = dataReader.GetBoolean("SubscribedToAcceptSubscriptions");
                    
                    //Get the list from the second recordset
                    dataReader.NextResult();
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        XmlElement users = CreateElement("USERS");
                        do
                        {
                            User subscribingUser = new User(InputContext);
                            int subscribingUserID = dataReader.GetInt32NullAsZero("UserID");

                            subscribingUser.AddUserXMLBlock(dataReader, subscribingUserID, users);

                            count--;

                        } while (count > 0 && dataReader.Read());	// dataReader.Read won't get called if count == 0

                        SubscribingUsersList.AppendChild(users);

                        // See if there's an extra row waiting
                        if (count == 0 && dataReader.Read())
                        {
                            AddAttribute(SubscribingUsersList, "MORE", 1);
                        }
                    }
				}
			}
			//AddAttribute(UserSubscriptionsList, "COUNT", count);

			return true;
		}

		/// <summary>
		/// Does the correct call to the database to get the users the user is subscribed to.
		/// </summary>
		/// <param name="userID">The user id to look for</param>
		/// <param name="skip">The number of users to skip</param>
		/// <param name="show">The number of users to show</param>
		/// <returns>Data Reader</returns>
		IDnaDataReader GetSubscribingUsersList(int userID, int skip, int show)
		{
			IDnaDataReader dataReader;

			dataReader = InputContext.CreateDnaDataReader("getsubscribingusers");

            dataReader.AddParameter("userid", userID);
            dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
            dataReader.AddParameter("skip", skip);
			dataReader.AddParameter("show", show);

			dataReader.Execute();

			return dataReader;
		}
 
	}
}
