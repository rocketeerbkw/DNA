using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(TypeName = "USERSUBSCRIPTIONSLIST")]
    [DataContract(Name = "userSubscriptionsList")]
    public class UserSubscriptionsList : CachableBase<UserSubscriptionsList>
    {
        public UserSubscriptionsList()
        {
           Users = new List<UserElement>();
        }

        #region Properties
        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIP")]
        [DataMember(Name = "skip", Order = 1)]
        public int Skip { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SHOW")]
        [DataMember(Name = "show", Order = 2)]
        public int Show { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "MORE")]
        [DataMember(Name = "more", Order = 3)]
        public int More { get; set; }

        /// <remarks/>
        [XmlElement("SUBSCRIBERACCEPTSSUBSCRIPTIONS")]
        [DataMember(Name = "subscriberAcceptsSubscriptions", Order = 4)]
        public bool SubscriberAcceptsSubscriptions { get; set; }

        /// <remarks/>
        [XmlElement("SUBSCRIBER")]
        [DataMember(Name = "subscriber", Order = 5)]
        public UserElement Subscriber { get; set; }

        /// <remarks/>
        [XmlElement("USERS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "users", Order = 6)]
        public List<UserElement> Users { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the user subscriptions list from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <returns></returns>
        public static UserSubscriptionsList CreateUserSubscriptionsListFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                        string identifier, 
                                                                        int siteId, 
                                                                        int skip, 
                                                                        int show, 
                                                                        bool byDnaUserId)
        {
            int dnaUserId = GetDnaUserIdFromIdentitifier(readerCreator, identifier, byDnaUserId);

            UserSubscriptionsList userSubscriptions = new UserSubscriptionsList();
            userSubscriptions.Skip = skip;
            userSubscriptions.Show = show;

            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("GetUsersSubscriptionList"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show);

                reader.Execute();

                //1st Result set gets user details.
                if (reader.HasRows && reader.Read())
                {
                    userSubscriptions.Subscriber = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "Subscriber") };

                    userSubscriptions.SubscriberAcceptsSubscriptions = reader.GetBoolean("SubscriberAcceptSubscriptions");
                    
                    reader.NextResult();

                    //Paged List of Users Subscriptions.
                    int count = 0;
                    while (reader.Read() && count < show)
                    {
                        //Delegate creation of XML to User class.
                        userSubscriptions.Users.Add(new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) });
           
                        ++count;
                    }

                    // Add More Attribute Indicating there are more rows.
                    if (reader.Read() && count > 0)
                    {
                        userSubscriptions.More = 1;
                    }
                }
                else
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }
            return userSubscriptions;
        }
        /// <summary>
        /// Gets the user subscriptions from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static UserSubscriptionsList CreateUserSubscriptionsList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateUserSubscriptionsList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, false, false);
        }
  
        /// <summary>
        /// Gets the user subscriptions from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static UserSubscriptionsList CreateUserSubscriptionsList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,
                                                string identifier, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var userSubscriptionsList = new UserSubscriptionsList();

            string key = userSubscriptionsList.GetCacheKey(identifier, siteID, skip, show, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                userSubscriptionsList = (UserSubscriptionsList)cache.GetData(key);
                if (userSubscriptionsList != null)
                {
                    //check if still valid with db...
                    if (userSubscriptionsList.IsUpToDate(readerCreator))
                    {
                        return userSubscriptionsList;
                    }
                }
            }

            //create from db
            userSubscriptionsList = CreateUserSubscriptionsListFromDatabase(readerCreator, identifier, siteID, skip, show, byDnaUserId);

            userSubscriptionsList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, userSubscriptionsList);

            return userSubscriptionsList;
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            // not used always get a new one for now
            return false;
        }
        /// <summary>
        /// Unsubscribe From a User
        /// </summary>
        /// <param name="readerCreator">DataReader Creator</param>
        /// <param name="viewingUser">User making the request</param>
        /// <param name="identifier">User ID or id username involved</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="userId">User to unsubscribe from</param>
        /// <param name="byDnaUserId"></param>
        public static void UnsubscribeFromUser(IDnaDataReaderCreator readerCreator,
                                        BBC.Dna.Users.CallingUser viewingUser,
                                        string identifier,
                                        int siteID,
                                        int userId,
                                        bool byDnaUserId)
        {
            int dnaUserId = GetDnaUserIdFromIdentitifier(readerCreator, identifier, byDnaUserId);

            //You can't unsubscribe someone else's users (unless you're an editor or superuser)
            if (viewingUser.UserID != dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }

            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("unsubscribefromuser"))
            {
                dataReader.AddParameter("userID", dnaUserId);
                dataReader.AddParameter("subscribedtoid", userId);
                dataReader.Execute();
            }
        }

        /// <summary>
        /// Subscribe To a User
        /// </summary>
        /// <param name="readerCreator">DataReader Creator</param>
        /// <param name="viewingUser">User making the request</param>
        /// <param name="identifier">User ID or id username involved</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="subscribedToID">User to subscribe toe</param>
        /// <param name="byDnaUserId"></param>
        public static void SubscribeToUser(IDnaDataReaderCreator readerCreator,
                                            BBC.Dna.Users.CallingUser viewingUser, 
                                            string identifier,
                                            int siteID,
                                            int subscribedToId,
                                            bool byDnaUserId)
        {
            int dnaUserId = GetDnaUserIdFromIdentitifier(readerCreator, identifier, byDnaUserId);

            //You can't unsubscribe someone else's users (unless you're an editor or superuser)
            if (viewingUser.UserID != dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }
            //You can't subscribe to yourself
            if (dnaUserId == subscribedToId)
            {
                throw ApiException.GetError(ErrorType.InvalidUserId);
            }
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("subscribetouser"))
            {
                dataReader.AddParameter("userID", dnaUserId);
                dataReader.AddParameter("authorid", subscribedToId);
                dataReader.AddParameter("siteid", siteID);
                dataReader.Execute();
                if (!dataReader.HasRows)
                {
                    dataReader.Close();
                    int returnValue;
                    dataReader.TryGetIntReturnValue(out returnValue);

                    //User has blocked all subscriptions
                    if (returnValue == 1)
                    {
                        throw ApiException.GetError(ErrorType.UserBlockedSubscriptions);
                    }
                    else
                    {
                        throw ApiException.GetError(ErrorType.CantSubscribe);
                    }
                }
            }
        }

        /// <summary>
        /// Gets the dnauserid from the identitifier
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="byDnaUserId"></param>
        /// <returns></returns>
        private static int GetDnaUserIdFromIdentitifier(IDnaDataReaderCreator readerCreator, string identifier, bool byDnaUserId)
        {
            int dnaUserId = 0;
            if (!byDnaUserId)
            {
                // fetch all the lovely intellectual property from the database
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getdnauseridfromidentityusername"))
                {
                    reader.AddParameter("identityusername", identifier);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        dnaUserId = reader.GetInt32NullAsZero("userid");
                    }
                    else
                    {
                        throw ApiException.GetError(ErrorType.UserNotFound);
                    }
                }
            }
            else
            {
                try
                {
                    dnaUserId = Convert.ToInt32(identifier);
                }
                catch (Exception)
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }
            return dnaUserId;
        }
    }
}
