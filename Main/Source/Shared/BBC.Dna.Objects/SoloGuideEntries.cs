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
    [XmlType(TypeName = "SOLOGUIDEENTRIES")]
    [DataContract(Name = "soloGuideEntries")]
    public class SoloGuideEntries : CachableBase<SoloGuideEntries>
    {
        public SoloGuideEntries()
        {
            SoloUsers = new List<SoloUser>();
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
        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = "count", Order = 3)]
        public int Count { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTAL")]
        [DataMember(Name = "total", Order = 4)]
        public int Total { get; set; }

        /// <remarks/>
        [XmlElement("SOLOUSERS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "soloUsers", Order = 5)]
        public List<SoloUser> SoloUsers { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the article subscriptions from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <returns></returns>
        public static SoloGuideEntries CreateSoloGuideEntriesFromDatabase(IDnaDataReaderCreator readerCreator, 
                                                                        int siteId, 
                                                                        int skip, 
                                                                        int show)
        {
            SoloGuideEntries soloGuideEntries = new SoloGuideEntries();
            int total = 0;
            int count = 0;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getsologuideentriescountuserlist"))
            {
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show + 1);

                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
                    if (reader.Read())
                    {
                        total = reader.GetInt32NullAsZero("TOTAL");

                        //The stored procedure returns one row for each article. 
                        do
                        {
                            count++;

                            //Paged List of Solo Users and their Counts.
                            //Delegate creation of XML to User class.
                            SoloUser solo = new SoloUser();

                            solo.User = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) };
                            solo.Count = reader.GetInt32NullAsZero("Count");
                            soloGuideEntries.SoloUsers.Add(solo);

                        } while (reader.Read());
                    }
                }
            }
            soloGuideEntries.Count = count;
            soloGuideEntries.Total = total;
            return soloGuideEntries;
        }
        /// <summary>
        /// Gets the solo guide entries user list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static SoloGuideEntries CreateSoloGuideEntries(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                int siteId)
        {
            return CreateSoloGuideEntries(cache, readerCreator, siteId, 0, 20, false);
        }
  
        /// <summary>
        /// Gets the solo guide entries user list  from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="siteID"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static SoloGuideEntries CreateSoloGuideEntries(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator, 
                                                int siteID, 
                                                int skip, 
                                                int show, 
                                                bool ignoreCache)
        {
            var soloGuideEntries = new SoloGuideEntries();

            string key = soloGuideEntries.GetCacheKey(siteID, skip, show);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                soloGuideEntries = (SoloGuideEntries)cache.GetData(key);
                if (soloGuideEntries != null)
                {
                    //check if still valid with db...
                    if (soloGuideEntries.IsUpToDate(readerCreator))
                    {
                        return soloGuideEntries;
                    }
                }
            }

            //create from db
            soloGuideEntries = CreateSoloGuideEntriesFromDatabase(readerCreator, siteID, skip, show);

            soloGuideEntries.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, soloGuideEntries);

            return soloGuideEntries;
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


        /// <remarks/>
        [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
        [System.SerializableAttribute()]
        [System.ComponentModel.DesignerCategoryAttribute("code")]
        [DataContract]
        public class SoloUser
        {
            /// <remarks/>
            [XmlElement("USER", Order = 6)]
            [DataMember(Name = "user")]
            public UserElement User
            {
                get;
                set;
            }

            /// <remarks/>
            [XmlElement("COUNT", Order = 7)]
            [DataMember(Name = "count")]
            public int Count
            {
                get;
                set;
            }
        }
    }
}
