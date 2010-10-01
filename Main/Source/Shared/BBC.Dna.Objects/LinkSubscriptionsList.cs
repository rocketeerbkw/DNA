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
    [XmlType(TypeName = "LINKSUBSCRIPTIONSLIST")]
    [DataContract(Name = "linkSubscriptionsList")]
    public class LinkSubscriptionsList : CachableBase<LinkSubscriptionsList>
    {
        public LinkSubscriptionsList()
        {
            Links = new List<Link>();
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
        [XmlElement("SUBSCRIBER")]
        [DataMember(Name = "subscriber", Order = 4)]
        public UserElement Subscriber { get; set; }

        /// <remarks/>
        [XmlElement("LINKS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "links", Order = 5)]
        public List<Link> Links { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the link subscriptions list from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="showPrivate"></param>
        /// <returns></returns>
        public static LinkSubscriptionsList CreateLinkSubscriptionsListFromDatabase(IDnaDataReaderCreator readerCreator,
                                                                        string identifier,
                                                                        int siteId,
                                                                        int skip,
                                                                        int show,
                                                                        bool showPrivate,
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
                        //1st Result set gets user details.
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

            LinkSubscriptionsList linkSubscriptions = new LinkSubscriptionsList();
            linkSubscriptions.Skip = skip;
            linkSubscriptions.Show = show;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getlinksubscriptionlist"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show + 1);
                reader.AddParameter("showprivate", showPrivate);

                reader.Execute();

                //1st Result set gets user details.
                if (reader.HasRows && reader.Read())
                {
                    linkSubscriptions.Subscriber = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader, "") };

                    reader.NextResult();

                    //Paged List of Links Subscriptions.
                    int count = 0;
                    while (reader.Read() && count < show)
                    {
                        //Delegate creation of XML to User class.
                        linkSubscriptions.Links.Add( Link.CreateLinkFromReader(reader));

                        ++count;
                    }

                    // Add More Attribute Indicating there are more rows.
                    if (reader.Read() && count > 0)
                    {
                        linkSubscriptions.More = 1;
                    }
                }
                else
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }
            return linkSubscriptions;
        }
        /// <summary>
        /// Gets the link subscriptions from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static LinkSubscriptionsList CreateLinkSubscriptionsList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteId)
        {
            return CreateLinkSubscriptionsList(cache, readerCreator, viewingUser, identifier, siteId, 0, 20, false, false, false);
        }

        /// <summary>
        /// Gets the link subscriptions from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="showPrivate"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static LinkSubscriptionsList CreateLinkSubscriptionsList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identifier,
                                                int siteID,
                                                int skip,
                                                int show,
                                                bool showPrivate,
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var linkSubscriptionsList = new LinkSubscriptionsList();

            string key = linkSubscriptionsList.GetCacheKey(identifier, siteID, skip, show, showPrivate, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                linkSubscriptionsList = (LinkSubscriptionsList)cache.GetData(key);
                if (linkSubscriptionsList != null)
                {
                    //check if still valid with db...
                    if (linkSubscriptionsList.IsUpToDate(readerCreator))
                    {
                        return linkSubscriptionsList;
                    }
                }
            }

            //create from db
            linkSubscriptionsList = CreateLinkSubscriptionsListFromDatabase(readerCreator, identifier, siteID, skip, show, showPrivate, byDnaUserId);

            linkSubscriptionsList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, linkSubscriptionsList);

            return linkSubscriptionsList;
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

