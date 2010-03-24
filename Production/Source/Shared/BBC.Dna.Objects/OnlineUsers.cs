using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System;
using Microsoft.Practices.EnterpriseLibrary.Caching.Expirations;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]

    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="ONLINEUSERS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace="", IsNullable=false, ElementName="ONLINEUSERS")]
    public partial class OnlineUsers
    {

        #region Properties
        /// <remarks/>
        [System.Xml.Serialization.XmlElement("WEIRD", Order = 0)]
        public string Weird
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("ONLINEUSER", Order = 1)]
        public System.Collections.Generic.List<OnlineUser> OnlineUser
        { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "THISSITE")]
        public int ThisSite
        { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("ORDER-BY")]
        public string OrderBy
        {
            get;
            set;
        } 
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
        static public OnlineUsers GetOnlineUsers(IDnaDataReaderCreator creator, ICacheManager cache,
            OnlineUsersOrderBy orderBy, int siteId, bool currentSiteOnly, bool ignoreCache)
        {
            OnlineUsers users = null;
            string cacheKey = GetCacheKey(siteId, currentSiteOnly);

            if (!ignoreCache)
            {
                users = (OnlineUsers)cache.GetData(cacheKey);
                if (users != null)
                {
                    return users;
                }
            }

            users = GetOnlineUsersFromDB(creator, orderBy, siteId, currentSiteOnly, users);

            if (users != null && users.OnlineUser != null && users.OnlineUser.Count > 0)
            {//add to cache if filled - 20 minutes of cache will do
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
        /// <param name="users"></param>
        /// <returns></returns>
        static public OnlineUsers GetOnlineUsersFromDB(IDnaDataReaderCreator creator, OnlineUsersOrderBy orderBy, int siteId, bool currentSiteOnly, OnlineUsers users)
        {
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
                    users = new OnlineUsers()
                    {
                        ThisSite = currentSiteOnly ? 1 : 0,
                        OrderBy = orderBy.ToString(),
                        OnlineUser = new System.Collections.Generic.List<OnlineUser>()
                    };
                    // generate XML for each online user as we go
                    while (dataReader.Read())
                    {
                        // get a representation of the date a user joined and the current date
                        // and subtract the date joined from the current time giving a date span
                        TimeSpan howLongAgo = DateTime.Now - dataReader.GetDateTime("DateJoined");

                        OnlineUserInfo userInfo = new OnlineUserInfo();
                        userInfo.Editor = dataReader.GetInt32NullAsZero("Editor");
                        userInfo.UserId = dataReader.GetInt32NullAsZero("userID");
                        userInfo.Username = dataReader.GetString("UserName") ?? String.Empty;
                        if (userInfo.Username == String.Empty)
                        {
                            userInfo.Username = "Member " + userInfo.UserId.ToString();
                        }
                        //create user info
                        OnlineUser user = new OnlineUser()
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
                    users = new OnlineUsers()
                    {
                        Weird = "Nobody is online! Nobody! Not even you!"
                    };
                }
            }
            return users;
        }

        /// <summary>
        /// Returns the cache key
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="currentSiteOnly"></param>
        /// <returns></returns>
        static public string GetCacheKey(int siteId, bool currentSiteOnly)
        {
            return string.Format("{0}|{1}|{2}", typeof(OnlineUser).AssemblyQualifiedName, siteId, currentSiteOnly);
            
        }
            
    }

    public enum OnlineUsersOrderBy
    {
        None,
        Id,
        Name
    }
    
    
    
    
}
