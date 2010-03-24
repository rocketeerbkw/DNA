using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More User Subscriptions Page object, holds the list of User Subscriptions of a user
    /// </summary>
    public class MoreUserSubscriptions : DnaInputComponent
    {
        private const string _docDnaSkip = @"The number of UserSubscriptions to skip.";
        private const string _docDnaShow = @"The number of UserSubscriptions to show.";
        private const string _docDnaUserID = @"User ID of the More User Subscriptions to look at.";

        private const string _docDnaUnsubscribeUserID = @"User ID of the user the needs to be unsubscribed.";
        private const string _docDnaAction = @"Action to take on this request on the More User Subscriptions page. 'subscribe' and 'unsubscribe are the only actions currently recognised";
        private const string _docDnaSubscribedToID = @"User ID of the User Subscriptions to remove.";

        string _cacheName = String.Empty;

		XmlElement _actionResult = null;

        /// <summary>
        /// Default constructor for the MoreUserSubscriptions component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public MoreUserSubscriptions(IInputContext context)
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

            bool skipCache = false;
            int userID = 0;
            int skip = 0;
            int show = 0;
            string action = String.Empty;
            int subscribedToID = 0;

            TryGetPageParams(ref userID, ref skip, ref show, ref action, ref subscribedToID);

            TryUpdateUserSubscription(action, userID, subscribedToID, ref skipCache);

            TryCreateMoreUserSubscriptionsXML(userID, skip, show, action, subscribedToID, skipCache);
        }
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of subscriptions to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the subscriptions.</param>
        /// <param name="subscribedToID">ID of the user for the subscription action.</param>
        private void TryGetPageParams(ref int userID, ref int skip, ref int show, ref string action, ref int subscribedToID)
        {
            userID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("show", _docDnaShow);

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
            subscribedToID = InputContext.GetParamIntOrZero("subscribedToID", _docDnaSubscribedToID);
        }

        /// <summary>
        /// Method called to update the user subscriptions. 
        /// </summary>
        /// <param name="action">The action to apply to the subscriptions.</param>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="subscribedToID">ID of the user for the subscription action.</param>
        /// <param name="skipCache">ref out parameter whether to skip the cache read.</param>
        private bool TryUpdateUserSubscription(string action, int userID, int subscribedToID, ref bool skipCache)
        {
            if (action == "unsubscribe")
            {
                skipCache = true;

                if (userID != InputContext.ViewingUser.UserID)
                {
                    return AddErrorXml("invalidparameters", "You can only update your own subscriptions.", null);
                }

                if (subscribedToID == 0)
                {
                    return AddErrorXml("invalidparameters", "Blank or No Subscribed To ID provided.", null);
                }

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("unsubscribefromuser"))
                {
                    dataReader.AddParameter("userid", userID);
                    dataReader.AddParameter("subscribedtoid", subscribedToID);
                    dataReader.Execute();
					_actionResult = CreateElement("ACTIONRESULT");
					AddAttribute(_actionResult, "ACTION", "unsubscribe");
					while (dataReader.Read())
					{
                        //Delegate generation of standardised User XML to User class.
                        int unsubscribedUserID = dataReader.GetInt32NullAsZero("userid");
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, unsubscribedUserID, _actionResult);
					}
                }
            }
            else if (action == "subscribe")
            {
                skipCache = true;

                if (InputContext.ViewingUser.UserID == 0 || !InputContext.ViewingUser.UserLoggedIn)
                {
                    return AddErrorXml("invalidparameters", "You must be logged in to subscribe to a user.", null);
                }

                if (userID != InputContext.ViewingUser.UserID)
                {
                    return AddErrorXml("invalidparameters", "You can only update your own subscriptions.", null);
                }

                if (subscribedToID == 0)
                {
                    return AddErrorXml("invalidparameters", "Blank or No Subscribed To ID provided.", null);
                }

                if (subscribedToID == InputContext.ViewingUser.UserID)
                {
                    return AddErrorXml("invalidparameters", "Users cannot subscribe to themselves.", null);
                }

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("subscribetouser"))
                {
                    dataReader.AddParameter("userid", InputContext.ViewingUser.UserID);
                    dataReader.AddParameter("authorid", subscribedToID);
                    dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                    dataReader.AddIntReturnValue();
                    dataReader.Execute();

                    if (dataReader.HasRows)
                    {
                        _actionResult = CreateElement("ACTIONRESULT");
                        AddAttribute(_actionResult, "ACTION", "subscribe");
                        while (dataReader.Read())
                        {
                            int subscribedUserID = dataReader.GetInt32NullAsZero("userid");
                            XmlNode usernode = AddElementTag(_actionResult, "USER");
                            AddIntElement(usernode, "USERID", subscribedUserID);
                            AddTextTag(usernode, "USERNAME", dataReader.GetStringNullAsEmpty("username"));
                        }
                    }
                    else 
                    {
                        dataReader.Close();
                        int returnValue;
                        dataReader.TryGetIntReturnValue(out returnValue);

                        //User has blocked all subscriptions
                        if (returnValue == 1)
                        {
                            return AddErrorXml("SubscribeError", "This user has blocked all subscriptions.", null);
                        }
                        //User has blocked the user trying to subscribe
                        else if (returnValue == 2)
                        {
                            return AddErrorXml("SubscribeError", "You cannot subscribe to this user.", null);
                        }
                        else
                        {
                            return AddErrorXml("SubscribeError", "You cannot subscribe to this user.", null);
                        }
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// Method called to try to create the TryCreateMoreUserSubscriptions, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of subscriptions to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the subscriptions.</param>
        /// <param name="subscribedToID">ID of the user for the subscription action.</param>
        /// <param name="skipCache">Whether to skip the cache read and always create the page.</param>
        /// <returns>Whether the search has suceeded with out error.</returns>
        private bool TryCreateMoreUserSubscriptionsXML(int userID, int skip, int show, string action, int subscribedToID, bool skipCache)
        {
            bool cached = false;
            GetCacheName(userID, skip, show);
            if (!skipCache)
            {
                cached = GetMoreUserSubscriptionsCachedXml(userID, skip, show);
            }
            if (!cached)
            {
                GenerateMoreUserSubscriptionsPageXml(userID, skip, show, action, subscribedToID);
            }
            return true;
        }

        /// <summary>
        /// Calls the User Subscription list class to generate the most recent UserSubscriptions
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of subscriptions to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="action">The action to apply to the subscriptions.</param>
        /// <param name="subscribedToID">ID of the user for the subscription action.</param>
        private void GenerateMoreUserSubscriptionsPageXml(int userID, int skip, int show, string action, int subscribedToID)
        {
            // all the XML objects we need to build the page
            UserSubscriptionsList userSubscriptionList = new UserSubscriptionsList(InputContext);

	        // get the users UserSubscription list
            userSubscriptionList.CreateUserSubscriptionsList(userID, InputContext.CurrentSite.SiteID, skip, show);

	        // Put in the wrapping <MoreUserSubscriptions> tag which has the user ID in it
            XmlElement moreUserSubscriptions = AddElementTag(RootElement, "MoreUserSubscriptions");
            AddAttribute(moreUserSubscriptions, "USERID", userID);
            AddAttribute(moreUserSubscriptions, "ACCEPTSUBSCRIPTIONS", Convert.ToInt32(userSubscriptionList.UserAcceptsSubscriptions));

            if (_actionResult != null)
			{
				moreUserSubscriptions.AppendChild(_actionResult);
			}

            AddInside(moreUserSubscriptions, userSubscriptionList);

            //FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "UserSubscriptions", _cacheName, moreUserSubscriptions.OuterXml);
        }

        /// <summary>
        /// Gets the Cache name 
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of subscriptions to skip</param>
        /// <param name="show">number to show</param>
        private void GetCacheName(int userID, int skip, int show)
        {
            _cacheName = "MUS-";
            _cacheName += userID + "-";
            _cacheName += skip + "-";
            _cacheName += show;
            _cacheName += ".xml";
        }

        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <param name="userID">The user of the subscriptions to get</param>
        /// <param name="skip">number of subscriptions to skip</param>
        /// <param name="show">number to show</param>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetMoreUserSubscriptionsCachedXml(int userID, int skip, int show)
        {
            //Clear any exisitng xml
            RootElement.RemoveAll();
			return false;

			//bool gotFromCache = false;

			////Try to get a cached copy.
			//DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(10);  // expire after 10 minutes
			//string moreUserSubscriptionsXML = String.Empty;

			//if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "UserSubscriptions", _cacheName, ref expiry, ref moreUserSubscriptionsXML))
			//{
			//    RipleyAddInside(RootElement, moreUserSubscriptionsXML);
			//    gotFromCache = true;
			//}

			//return gotFromCache;
        }
    }
}
