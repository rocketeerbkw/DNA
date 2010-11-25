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
    [XmlType(TypeName = "FOLLOWERSLIST")]
    [DataContract(Name = "followersList")]
    public class FollowersList : CachableBase<FollowersList>
    {
        public FollowersList()
        {
            Followers = new List<UserElement>();
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
        [XmlElement("FOLLOWERS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "followers", Order = 6)]
        public List<UserElement> Followers { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the followers list from db (also know as watched users list)
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="startIndex"></param>
        /// <param name="itemsPerPage"></param>
        /// <returns></returns>
        public static FollowersList CreateFollowersListFromDatabase(IDnaDataReaderCreator readerCreator,
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

            FollowersList followers = new FollowersList();
            followers.StartIndex = startIndex;
            followers.ItemsPerPage = itemsPerPage;
            followers.Total = 0;
            int count = 0;

            // fetch all the lovely intellectual property from the database watchingusers
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("watchingusers"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("skip", startIndex);
                reader.AddParameter("show", itemsPerPage);

                reader.Execute();
                bool more = true;
                if (reader.HasRows && reader.Read())
                {
                    followers.Total = reader.GetInt32NullAsZero("Total");
                    //Paged List of Followers.
                    do
                    {
                        //Delegate creation of XML to User class.
                        followers.Followers.Add(new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) });

                        ++count;
                        more = reader.Read();

                    } while (more && count < itemsPerPage);

                    // Add More Attribute Indicating there are more rows.
                    if (more && count > 0)
                    {
                        followers.More = 1;
                    }
                }
                followers.Count = count;
            }
            return followers;
        }
        /// <summary>
        /// Creates the followers list from cache or db (also know as watched users list) if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static FollowersList CreateFollowersList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateFollowersList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, false, false);
        }

        /// <summary>
        /// Creates the followers list from cache or db (also know as watched users list) if not found in cache
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
        public static FollowersList CreateFollowersList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteID,
                                                int skip,
                                                int show,
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var followersList = new FollowersList();

            string key = followersList.GetCacheKey(identifier, siteID, skip, show, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                followersList = (FollowersList)cache.GetData(key);
                if (followersList != null)
                {
                    //check if still valid with db...
                    if (followersList.IsUpToDate(readerCreator))
                    {
                        return followersList;
                    }
                }
            }

            //create from db
            followersList = CreateFollowersListFromDatabase(readerCreator, identifier, siteID, skip, show, byDnaUserId);

            followersList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, followersList);

            return followersList;
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
    }
}
