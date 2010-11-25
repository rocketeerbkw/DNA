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
    [XmlType(TypeName = "FRIENDSLIST")]
    [DataContract(Name = "friendsList")]
    public class FriendsList : CachableBase<FriendsList>
    {
        public FriendsList()
        {
           Friends = new List<UserElement>();
        }

        #region Properties
        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIP")]
        [DataMember(Name = "startIndex", Order = 1)]
        public int StartIndex { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SHOW")]
        [DataMember(Name = "itemsPerPage", Order = 2)]
        public int ItemsPerPage { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "MORE")]
        [DataMember(Name = "more", Order = 3)]
        public int More { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = "count", Order = 4)]
        public int Count { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTAL")]
        [DataMember(Name = "total", Order = 5)]
        public int Total { get; set; }

        /// <remarks/>
        [XmlElement("FRIENDS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "friends", Order = 6)]
        public List<UserElement> Friends { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the friends list from db (also know as watched users list)
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="startIndex"></param>
        /// <param name="itemsPerPage"></param>
        /// <returns></returns>
        public static FriendsList CreateFriendsListFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                        string identifier, 
                                                                        int siteId, 
                                                                        int startIndex, 
                                                                        int itemsPerPage, 
                                                                        bool byDnaUserId)
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

            FriendsList friends = new FriendsList();
            friends.StartIndex = startIndex;
            friends.ItemsPerPage = itemsPerPage;
            friends.Total = 0;
            int count = 0;

            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("fetchwatchedjournals"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("skip", startIndex);
                reader.AddParameter("show", itemsPerPage);

                reader.Execute();
                bool more = true;
                if (reader.HasRows && reader.Read())
                {
                    friends.Total = reader.GetInt32NullAsZero("Total");
                    //Paged List of Friends.
                    do
                    {
                        //Delegate creation of XML to User class.
                        friends.Friends.Add(new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) });

                        ++count;
                        more = reader.Read();

                    } while (more && count < itemsPerPage);

                    // Add More Attribute Indicating there are more rows.
                    if (more && count > 0)
                    {
                        friends.More = 1;
                    }
                }
                friends.Count = count;
            }
            return friends;
        }
        /// <summary>
        /// Creates the friends list from cache or db (also know as watched users list) if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static FriendsList CreateFriendsList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateFriendsList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, false, false);
        }
  
        /// <summary>
        /// Creates the friends list from cache or db (also know as watched users list) if not found in cache
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
        public static FriendsList CreateFriendsList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,
                                                string identifier, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var friendsList = new FriendsList();

            string key = friendsList.GetCacheKey(identifier, siteID, skip, show, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                friendsList = (FriendsList)cache.GetData(key);
                if (friendsList != null)
                {
                    //check if still valid with db...
                    if (friendsList.IsUpToDate(readerCreator))
                    {
                        return friendsList;
                    }
                }
            }

            //create from db
            friendsList = CreateFriendsListFromDatabase(readerCreator, identifier, siteID, skip, show, byDnaUserId);

            friendsList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, friendsList);

            return friendsList;
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
        /// Deletes a friend from their friends list
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="friendId"></param>
        /// <param name="byDnaUserId"></param>
        /// <returns></returns>
        public static void DeleteFriend(IDnaDataReaderCreator readerCreator,
                                        BBC.Dna.Users.ICallingUser viewingUser,
                                        string identifier,
                                        int siteId,
                                        int friendId,
                                        bool byDnaUserId)
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
            //You can't delete someone else's friends (unless you're an editor or superuser)
            if (viewingUser.UserID == dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("deletewatchedusers"))
                {
                    reader.AddParameter("userid", dnaUserId);
                    reader.AddParameter("currentsiteid", siteId);
                    reader.AddParameter("watch1", friendId);

                    reader.Execute();
                }
            }
            else
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }            
        }
        /// <summary>
        /// Adds a friend to their friends list
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteId"></param>
        /// <param name="newFriendId"></param>
        /// <param name="byDnaUserId"></param>
        /// <returns></returns>
        public static void AddFriend(IDnaDataReaderCreator readerCreator,
                                        BBC.Dna.Users.ICallingUser viewingUser,
                                        string identifier,
                                        int siteId,
                                        int newFriendId,
                                        bool byDnaUserId)
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
            //You can't add someone else's friends (unless you're an editor or superuser)
            if (viewingUser.UserID == dnaUserId || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.Editor) || viewingUser.IsUserA(BBC.Dna.Users.UserTypes.SuperUser))
            {
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("watchuserjournal"))
                {
                    reader.AddParameter("userid", dnaUserId);
                    reader.AddParameter("watcheduserid", newFriendId);
                    reader.AddParameter("siteid", siteId);

                    reader.Execute();
                }
            }
            else
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }
        }
    }
}
