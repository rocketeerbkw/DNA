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
    [XmlType(TypeName = "BLOCKEDUSERSUBSCRIPTIONSLIST")]
    [DataContract(Name = "blockedUserSubscriptionsList")]
    public class BlockedUserSubscriptionsList : CachableBase<BlockedUserSubscriptionsList>
    {
        public BlockedUserSubscriptionsList()
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
        [XmlElement("BLOCKERACCEPTSSUBSCRIPTIONS")]
        [DataMember(Name = "blockerAcceptsSubscriptions", Order = 4)]
        public bool BlockerAcceptsSubscriptions { get; set; }

        /// <remarks/>
        [XmlElement("BLOCKER")]
        [DataMember(Name = "blocker", Order = 5)]
        public UserElement Blocker { get; set; }

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
        /// Creates the blocked user subscriptions list from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <returns></returns>
        public static BlockedUserSubscriptionsList CreateBlockedUserSubscriptionsListFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                        string identifier, 
                                                                        int siteId, 
                                                                        int skip, 
                                                                        int show, 
                                                                        bool byDnaUserId)
        {
            int dnaUserId = GetDnaUserIdFromIdentitifier(readerCreator, identifier, byDnaUserId);

            BlockedUserSubscriptionsList blockedUserSubscriptions = new BlockedUserSubscriptionsList();
            blockedUserSubscriptions.Skip = skip;
            blockedUserSubscriptions.Show = show;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getblockedusersubscriptions"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show);

                reader.Execute();

                //1st Result set gets user details.
                if (reader.HasRows && reader.Read())
                {
                    blockedUserSubscriptions.Blocker = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "Blocker") };

                    blockedUserSubscriptions.BlockerAcceptsSubscriptions = reader.GetBoolean("BlockerAcceptSubscriptions");
                    
                    reader.NextResult();

                    //Paged List of Users Subscriptions.
                    int count = 0;
                    while (reader.Read() && count < show)
                    {
                        //Delegate creation of XML to User class.
                        blockedUserSubscriptions.Users.Add(new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) });
           
                        ++count;
                    }

                    // Add More Attribute Indicating there are more rows.
                    if (reader.Read() && count > 0)
                    {
                        blockedUserSubscriptions.More = 1;
                    }
                }
                else
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }
            return blockedUserSubscriptions;
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
        public static BlockedUserSubscriptionsList CreateBlockedUserSubscriptionsList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateBlockedUserSubscriptionsList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, false, false);
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
        public static BlockedUserSubscriptionsList CreateBlockedUserSubscriptionsList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,
                                                string identifier, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var blockedUserSubscriptionsList = new BlockedUserSubscriptionsList();

            string key = blockedUserSubscriptionsList.GetCacheKey(identifier, siteID, skip, show, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                blockedUserSubscriptionsList = (BlockedUserSubscriptionsList)cache.GetData(key);
                if (blockedUserSubscriptionsList != null)
                {
                    //check if still valid with db...
                    if (blockedUserSubscriptionsList.IsUpToDate(readerCreator))
                    {
                        return blockedUserSubscriptionsList;
                    }
                }
            }

            //create from db
            blockedUserSubscriptionsList = CreateBlockedUserSubscriptionsListFromDatabase(readerCreator, identifier, siteID, skip, show, byDnaUserId);

            blockedUserSubscriptionsList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, blockedUserSubscriptionsList);

            return blockedUserSubscriptionsList;
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
        /// Unblock a User
        /// </summary>
        /// <param name="readerCreator">DataReader Creator</param>
        /// <param name="viewingUser">User making the request</param>
        /// <param name="identifier">User ID or id username involved</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="unblockUserId">User to unblcok</param>
        /// <param name="byDnaUserId"></param>
        public static void UnblockUser(IDnaDataReaderCreator readerCreator,
                                        BBC.Dna.Users.ICallingUser viewingUser,
                                        string identifier,
                                        int siteID,
                                        int unblockUserId,
                                        bool byDnaUserId)
        {
            int dnaUserId = GetDnaUserIdFromIdentitifier(readerCreator, identifier, byDnaUserId);

            //You can't unsubscribe someone else's users (unless you're an editor or superuser)
            if (viewingUser.UserID != dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }

            try
            {
                using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("unblockusersubscription"))
                {
                    dataReader.AddParameter("authorid", dnaUserId);
                    dataReader.AddParameter("user", unblockUserId);
                    dataReader.Execute();
                }
            }
            catch(Exception ex)
            {
                throw ApiException.GetError(ErrorType.InvalidUserId, ex);
            }
        }

        /// <summary>
        /// Block a User
        /// </summary>
        /// <param name="readerCreator">DataReader Creator</param>
        /// <param name="viewingUser">User making the request</param>
        /// <param name="identifier">User ID or id username involved</param>
        /// <param name="siteID">Site ID involved</param>
        /// <param name="blockUserId">User to block</param>
        /// <param name="byDnaUserId"></param>
        public static void BlockUser(IDnaDataReaderCreator readerCreator,
                                            BBC.Dna.Users.ICallingUser viewingUser,
                                            string identifier,
                                            int siteID,
                                            int blockUserId,
                                            bool byDnaUserId)
        {
            int dnaUserId = GetDnaUserIdFromIdentitifier(readerCreator, identifier, byDnaUserId);

            //You can't unsubscribe someone else's users (unless you're an editor or superuser)
            if (viewingUser.UserID != dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }
            //You can't block yourself
            if (dnaUserId == blockUserId)
            {
                throw ApiException.GetError(ErrorType.InvalidUserId);
            }
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader("blockusersubscription"))
            {
                dataReader.AddParameter("authorid", blockUserId);
                dataReader.AddParameter("userID", dnaUserId);
                dataReader.Execute();
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
