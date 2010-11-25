using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Xml;
using System.Runtime.Serialization;
using System.Diagnostics;
using BBC.Dna.Common;

namespace BBC.Dna.Objects
{ 
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName="RECOMMENDATIONS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName="RECOMMENDATIONS")]
    [DataContract(Name="recommendations")]
    public partial class Recommendations 
    {              
        /// <remarks/>
        [XmlAttribute(AttributeName="COUNT")]
        [DataMember(Name = "count")]
        public int Count { get; set; }
        
        /// <remarks/>
        [XmlAttribute(AttributeName="SKIPTO")]
        public int SkipTo { get; set; }
        
        /// <remarks/>
        [XmlAttribute(AttributeName="TOTAL")]
        public int Total { get; set; }

        [XmlArray(ElementName = "RECOMMENDATIONLIST")]
        [XmlArrayItem("RECOMMENDATION", IsNullable = false)]
        [DataMember(Name = "recommendationlist")]
        public List<Recommendation> RecommendationsList { get; set; }

        private DateElement LastUpdated { get; set; }      

        /// <summary>
        /// Gets Recommendations/Coming Up data from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static Recommendations CreateRecommendations(ICacheManager cache, IDnaDataReaderCreator readerCreator)
        {
            return CreateRecommendations(cache, readerCreator, false);
        }

        /// <summary>
        /// Gets Recommendations from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static Recommendations CreateRecommendations(ICacheManager cache, IDnaDataReaderCreator readerCreator, bool ignoreCache)
        {
            var recommendations = new Recommendations();

            //string key = recommendations.GetCacheKey();
            //check for item in the cache first
            /*
            if (!ignoreCache)
            {
                //not ignoring cache
                recommendations = (Recommendations)cache.GetData(key);
                if (recommendations != null)
                {
                    //check if still valid with db...
                    if (recommendations.IsUpToDate(readerCreator))
                    {
                        return recommendations;
                    }
                }
            }
            */
            //create from db
            recommendations = CreateRecommendationsFromDatabase(readerCreator);
            //add to cache
            //cache.Add(key, recommendations);

            return recommendations;
        }
        /// <summary>
        /// Creates the recommendations from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static Recommendations CreateRecommendationsFromDatabase(IDnaDataReaderCreator readerCreator)
        {
            Recommendations recommendations = null;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getacceptedentries"))
            {
                reader.Execute();

                // Make sure we got something back
                if (!reader.HasRows || !reader.Read())
                {
                    throw new Exception("Recommendations not found");
                }
                else
                {
                    recommendations = new Recommendations();
                    recommendations.RecommendationsList = new List<Recommendation>();
                    int count = 0;
                    do
                    {
                        Recommendation recommendation = new Recommendation();
                        recommendation.Subject = reader.GetStringNullAsEmpty("Subject");

                        recommendation.GuideStatus = reader.GetInt32NullAsZero("GuideStatus");
                        recommendation.AcceptedStatus = reader.GetByteNullAsZero("AcceptedStatus");

                        recommendation.Original = new ArticleIDs();

                        recommendation.Original.EntryId = reader.GetInt32NullAsZero("OriginalEntryID");
                        recommendation.Original.H2G2Id = reader.GetInt32NullAsZero("Originalh2g2ID");

                        recommendation.Edited = new ArticleIDs();

                        recommendation.Edited.EntryId = reader.GetInt32NullAsZero("EntryID");
                        recommendation.Edited.H2G2Id = reader.GetInt32NullAsZero("h2g2ID");

                        recommendation.Users = new List<UserElement>();

                        UserElement subEditor= new UserElement() { user = User.CreateUserFromReader(reader, "SubEditor") };
                        //User subEditor = User.CreateUserFromReader(reader, "SubEditor");
                        recommendation.Users.Add(subEditor);

                        UserElement scout = new UserElement() { user = User.CreateUserFromReader(reader, "Scout") };
                        //User scout = User.CreateUserFromReader(reader, "Scout");
                        recommendation.Users.Add(scout);

                        DateTime dateAllocated = DateTime.MinValue;
                        DateTime dateReturned = DateTime.MinValue;
                        bool existsDateAllocated = !reader.IsDBNull("DateAllocated");
                        bool existsDateReturned = !reader.IsDBNull("DateReturned");
                        if (existsDateAllocated)
                        {
                            dateAllocated = reader.GetDateTime("DateAllocated");
                        }
                        recommendation.DateAllocated = new DateElement(dateAllocated);

                        if (existsDateReturned)
                        {
                            dateReturned = reader.GetDateTime("DateReturned");
                        }
                        recommendation.DateReturned = new DateElement(dateReturned);

                        recommendations.RecommendationsList.Add(recommendation);
                        count++;

                    } while (reader.Read());

                    recommendations.Count = count;
                }
            }
            return recommendations;
        }
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType=true, TypeName="RECOMMENDATION")]
    [DataContract(Name = "recommendation")]
    public partial class Recommendation
    {
        /// <remarks/>
        [XmlElement(ElementName = "SUBJECT", Order = 0)]
        [DataMember(Name = "subject")]
        public string Subject { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "ACCEPTEDSTATUS", Order = 1)]
        [DataMember(Name = "acceptedstatus")]
        public int AcceptedStatus { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "GUIDESTATUS", Order = 2)]
        [DataMember(Name = "guidestatus")]
        public int GuideStatus { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "ORIGINAL", Order = 3)]
        [DataMember(Name = "original")]
        public ArticleIDs Original { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "EDITED", Order = 4)]
        [DataMember(Name = "edited")]
        public ArticleIDs Edited { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "USERS", Order = 5)]
        [DataMember(Name = "users")]
        public List<UserElement> Users { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "DATEALLOCATED", Order = 6)]
        [DataMember(Name = "dateallocated")]
        public DateElement DateAllocated { get; set; }

        /// <remarks/>
        [XmlElement(ElementName = "DATERETURNED", Order = 7)]
        [DataMember(Name = "datereturned")]
        public DateElement DateReturned { get; set; }
        
    }
    
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "ArticleIDs")]
    public partial class ArticleIDs
    {
        /// <remarks/>
        [XmlElement(ElementName = "ENTRYID")]
        public int EntryId;

        /// <remarks/>
        [XmlElement(ElementName = "H2G2ID")]
        public int H2G2Id;       
    }
    
}
