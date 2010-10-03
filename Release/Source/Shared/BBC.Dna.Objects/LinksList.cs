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
    [XmlType(TypeName = "LINKSLIST")]
    [DataContract(Name = "linksList")]
    public class LinksList : CachableBase<LinksList>
    {
        public LinksList()
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
        [XmlElement("USER")]
        [DataMember(Name = "user", Order = 3)]
        public UserElement User { get; set; }

        /// <remarks/>
        [XmlElement("LINKS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "links", Order = 4)]
        public List<Link> Links { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the linkslist from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="userID"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="showPrivate"></param>
        /// <returns></returns>
        public static LinksList CreateLinksListFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                            string identityUserName, 
                                                            int siteID, 
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
                    reader.AddParameter("identityusername", identityUserName);
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
                    dnaUserId = Convert.ToInt32(identityUserName);
                }
                catch (Exception)
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }

            LinksList links = new LinksList();
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getmorelinks"))
            {
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("linkgroup", String.Empty);
                reader.AddParameter("showprivate", showPrivate);
                reader.AddParameter("siteid", siteID);

                // Get +1 so we know if there are more left
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show + 1);

                reader.Execute();

                //1st Result set gets user details.
                if (reader.HasRows && reader.Read())
                {
                    links.User = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) };
                    
                    reader.NextResult();

                    //Paged List of Links / Clippings / Bookmarks .
                    int count = 0;
                    while (reader.Read() && count < show)
                    {
                        //Delegate creation of XML to Link class.
                        links.Links.Add(Link.CreateLinkFromReader(reader));
                        ++count;
                    }

                    // Add More Attribute Indicating there are more rows.
                    if (reader.Read() && count > 0)
                    {
                        links.More = 1;
                    }
                }
                else
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }
            return links;
        }
        /// <summary>
        /// Gets the linkslist from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="userID"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static LinksList CreateLinksList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                User viewingUser,
                                                string identityUserName,
                                                int siteId)
        {
            return CreateLinksList(cache, readerCreator, null, identityUserName, siteId, 0, 20, false, false, false);
        }
  
        /// <summary>
        /// Gets the linkslist from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="userID"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="showPrivate"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static LinksList CreateLinksList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                User viewingUser,                                           
                                                string identityUserName, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool showPrivate,
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            var links = new LinksList();

            string key = links.GetCacheKey(identityUserName, siteID, skip, show, showPrivate, byDnaUserId);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                links = (LinksList)cache.GetData(key);
                if (links != null)
                {
                    //check if still valid with db...
                    if (links.IsUpToDate(readerCreator))
                    {
                        return links;
                    }
                }
            }

            //create from db
            links = CreateLinksListFromDatabase(readerCreator, identityUserName, siteID, skip, show, showPrivate, byDnaUserId);

            links.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, links);

            return links;
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
