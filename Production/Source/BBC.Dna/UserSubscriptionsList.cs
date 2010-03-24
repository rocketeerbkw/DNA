using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// User SubscriptionsList List - A derived DnaInputComponent object to get the list of users subscribed to by a user
    /// </summary>
    public class UserSubscriptionsList : DnaInputComponent
    {
        bool _userAcceptsSubscriptions = false;

        /// <summary>
        /// Default Constructor for the UserSubscriptionsList object
        /// </summary>
        public UserSubscriptionsList(IInputContext context)
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
        /// Functions generates the User Subscription List
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="siteID">Site of the posts</param>
        /// <param name="skip">number of posts to skip</param>
        /// <param name="show">number to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateUserSubscriptionsList(int userID, int siteID, int skip, int show)
        {
            // check object is not already initialised
            if (userID <= 0 || show <= 0)
            {
                return false;
            }

            int count = show;

            XmlElement UserSubscriptionsList = AddElementTag(RootElement, "USERSUBSCRIPTION-LIST");
            AddAttribute(UserSubscriptionsList, "SKIP", skip);
            AddAttribute(UserSubscriptionsList, "SHOW", show);

            using (IDnaDataReader dataReader = GetUsersSubscriptionList(userID, siteID, skip, show + 1))	// Get +1 so we know if there are more left
            {
                // Check to see if we found anything Owner of the list record first 
                // then their list in the following recordset
                string userName = String.Empty;
                if (dataReader.HasRows && dataReader.Read())
                {
                    User subscriber = new User(InputContext);
                    subscriber.AddPrefixedUserXMLBlock(dataReader, userID, "Subscriber", UserSubscriptionsList);

                    _userAcceptsSubscriptions = dataReader.GetBoolean("SubscriberAcceptSubscriptions");

                    dataReader.NextResult();
                    if (dataReader.HasRows && dataReader.Read())
                    {
                        XmlElement users = CreateElement("USERS");
                        do
                        {
                            User subscribedTo = new User(InputContext);
                            int subscribedToID = dataReader.GetInt32NullAsZero("subscribedToID");

                            subscribedTo.AddUserXMLBlock(dataReader, subscribedToID, users);

                            count--;

                        } while (count > 0 && dataReader.Read());	// dataReader.Read won't get called if count == 0

                        UserSubscriptionsList.AppendChild(users);

                        // See if there's an extra row waiting
                        if (count == 0 && dataReader.Read())
                        {
                            AddAttribute(UserSubscriptionsList, "MORE", 1);
                        }
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// Does the correct call to the database to get the users the user is subscribed to.
        /// </summary>
        /// <param name="userID">The user id to look for</param>
        /// <param name="siteId">SiteID of the user subscription list to get</param>
        /// <param name="skip">The number of users to skip</param>
        /// <param name="show">The number of users to show</param>
        /// <returns>Data Reader</returns>
        IDnaDataReader GetUsersSubscriptionList(int userID, int siteId, int skip, int show)
        {
            IDnaDataReader dataReader;

            dataReader = InputContext.CreateDnaDataReader("GetUsersSubscriptionList");

            dataReader.AddParameter("userid", userID);
            dataReader.AddParameter("siteid", siteId);
            dataReader.AddParameter("skip", skip);
			dataReader.AddParameter("show", show);

            dataReader.Execute();

            return dataReader;
        }
    }
}