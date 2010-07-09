using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "ONLINEUSERS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "ONLINEUSERS")]
    public class OnlineUsers : CachableBase<OnlineUsers>
    {
        #region Properties

        /// <remarks/>
        [XmlElement("WEIRD", Order = 0)]
        public string Weird { get; set; }

        /// <remarks/>
        [XmlElement("ONLINEUSER", Order = 1)]
        public List<OnlineUser> OnlineUser { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "THISSITE")]
        public int ThisSite { get; set; }

        /// <remarks/>
        [XmlAttribute("ORDER-BY")]
        public string OrderBy { get; set; }

        #endregion

        /// <summary>
        /// Gets the list of online users from cache or create from db
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="cache"></param>
        /// <param name="orderBy"></param>
        /// <param name="siteId"></param>
        /// <param name="currentSiteOnly"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static OnlineUsers GetOnlineUsers(IDnaDataReaderCreator creator, ICacheManager cache,
                                                 OnlineUsersOrderBy orderBy, int siteId, bool currentSiteOnly,
                                                 bool ignoreCache)
        {
            var users = new OnlineUsers();
            string cacheKey = users.GetCacheKey(siteId, currentSiteOnly);

            if (!ignoreCache)
            {
                users = (OnlineUsers) cache.GetData(cacheKey);
                if (users != null)
                {
                    return users;
                }
            }

            users = GetOnlineUsersFromDB(creator, orderBy, siteId, currentSiteOnly);

            if (users != null && users.OnlineUser != null && users.OnlineUser.Count > 0)
            {
//add to cache if filled - 20 minutes of cache will do
                cache.Add(cacheKey, users, CacheItemPriority.Normal, null, new AbsoluteTime(DateTime.Now.AddMinutes(20)));
            }
            return users;
        }


        /// <summary>
        /// Gets the list of users from the DB
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="orderBy"></param>
        /// <param name="siteId"></param>
        /// <param name="currentSiteOnly"></param>
        /// <returns></returns>
        public static OnlineUsers GetOnlineUsersFromDB(IDnaDataReaderCreator creator, OnlineUsersOrderBy orderBy, int siteId, bool currentSiteOnly)
        {
            OnlineUsers users;
            //get from DB
            // create a stored procedure to access the database
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("currentusers"))
            {
                dataReader.AddParameter("siteid", siteId);
                if (currentSiteOnly)
                {
                    dataReader.AddParameter("currentsiteonly", 1);
                }
                // attempt to query the database through the stored procedure
                // asking for a block listing all the online users 
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    users = new OnlineUsers
                                {
                                    ThisSite = currentSiteOnly ? 1 : 0,
                                    OrderBy = orderBy.ToString(),
                                    OnlineUser = new List<OnlineUser>()
                                };
                    // generate XML for each online user as we go
                    while (dataReader.Read())
                    {
                        // get a representation of the date a user joined and the current date
                        // and subtract the date joined from the current time giving a date span
                        TimeSpan howLongAgo = DateTime.Now - dataReader.GetDateTime("DateJoined");

                        var userInfo = new OnlineUserInfo();
                        userInfo.Editor = dataReader.GetInt32NullAsZero("Editor");
                        userInfo.UserId = dataReader.GetInt32NullAsZero("userID");
                        userInfo.Username = dataReader.GetString("UserName") ?? String.Empty;
                        if (userInfo.Username == String.Empty)
                        {
                            userInfo.Username = "Member " + userInfo.UserId;
                        }
                        //create user info
                        var user = new OnlineUser
                                       {
                                           DaysSinceJoined = howLongAgo.Days,
                                           User = userInfo
                                       };
                        //add to users object
                        users.OnlineUser.Add(user);
                    }
                }
                else
                {
                    users = new OnlineUsers
                                {
                                    Weird = "Nobody is online! Nobody! Not even you!"
                                };
                }
            }
            return users;
        }

        /// <summary>
        /// not used in this object
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return true;
        }
    }

    public enum OnlineUsersOrderBy
    {
        None,
        Id,
        Name
    }
}