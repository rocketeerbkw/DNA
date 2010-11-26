using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Moderation;
using BBC.Dna.Data;
using System.Xml.Serialization;
using BBC.Dna.Utils;
using BBC.Dna.Objects;
using BBC.Dna.Sites;


namespace BBC.Dna.Moderation
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "SITEEVENTLIST")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "SITEEVENTLIST")]
    public class SiteEventList
    {
        public SiteEventList()
        {
            SiteEvents = new List<SiteEvent>();
        }

        [XmlArray(Order = 1, ElementName = "SITEEVENTS")]
        [XmlArrayItem(ElementName = "SITEEVENT")]
        public List<SiteEvent> SiteEvents
        {
            get;
            set;
        }

        [XmlArray(Order = 2, ElementName = "SELECTEDTYPES")]
        [XmlArrayItem(ElementName = "TYPEID")]
        public int[] Types { get; set; }

        [XmlArray(Order = 3, ElementName = "SELECTEDSITEIDS")]
        [XmlArrayItem(ElementName = "SITEIDS")]
        public int[] Sites { get; set; }

        [XmlAttribute(AttributeName = "TOTALITEMS")]
        public int TotalItems { get; set; }

        [XmlAttribute(AttributeName = "STARTINDEX")]
        public long StartIndex { get; set; }

        [XmlAttribute(AttributeName = "ITEMSPERPAGE")]
        public int ItemsPerPage { get; set; }

        [XmlElement(ElementName = "STARTDATE", Order = 4)]
        public DateElement StartDate { get; set; }

        [XmlElement(ElementName = "ENDDATE", Order = 5)]
        public DateElement EndDate { get; set; }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteIds"></param>
        /// <param name="typeIds"></param>
        /// <param name="startIndex"></param>
        /// <param name="itemsPerPage"></param>
        /// <param name="startDate"></param>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        static public SiteEventList GetSiteEventList(int[] siteIds, int[] typeIds, int startIndex, int itemsPerPage,
            DateTime startDate, DateTime endDate, IDnaDataReaderCreator readerCreator, bool isSuperUser, SiteType siteType)
        {
            var siteEventList = new SiteEventList()
            {
                Sites = siteIds,
                Types = typeIds
            };

            if (siteIds.Length == 0 && !isSuperUser)
            {
                throw new Exception("Missing site list for non-super user");
            }

            var typeIdsDelimited = String.Join("|", typeIds.Select(p => p.ToString()).ToArray());
            var siteIdsDelimited = String.Join("|", siteIds.Select(p => p.ToString()).ToArray());

            using(var reader = readerCreator.CreateDnaDataReader("getsiteevents"))
            {
                reader.AddParameter("itemsperpage", itemsPerPage);
                reader.AddParameter("startindex", startIndex);
                reader.AddParameter("sitetype", siteType);
                if(startDate != DateTime.MinValue)
                {
                    reader.AddParameter("startdate", startDate);
                }
                if(endDate != DateTime.MaxValue)
                {
                    reader.AddParameter("enddate", endDate);
                }
            
                if (siteIds.Length > 0)
                {
                    reader.AddParameter("siteids", siteIdsDelimited);
                }
                if (typeIds.Length > 0)
                {
                    reader.AddParameter("typeids", typeIdsDelimited);
                }

                reader.Execute();

                if (reader.Read())
                {
                    siteEventList.TotalItems = reader.GetInt32NullAsZero("total");
                    siteEventList.StartIndex = reader.GetLongNullAsZero("n")-1;
                    siteEventList.ItemsPerPage = itemsPerPage;
                    if (startDate != DateTime.MinValue)
                    {
                        siteEventList.StartDate = new DateElement(startDate);
                    }
                    if (endDate != DateTime.MaxValue)
                    {
                        siteEventList.EndDate = new DateElement(endDate);
                    }

                    XmlDocument doc = new XmlDocument();
                    do
                    {
                        var siteEvent = new SiteEvent();
                        try
                        {
                            doc.LoadXml(reader.GetXmlAsString("activitydata"));
                            siteEvent.ActivityData = doc.DocumentElement;
                            
                        }
                        catch
                        {//skip a badly formatted element
                            continue;
                        }
                        siteEvent.Date = new Date(reader.GetDateTime("datetime"));
                        siteEvent.SiteId = reader.GetInt32NullAsZero("siteid");
                        siteEvent.Type = (SiteActivityType)reader.GetInt32NullAsZero("type");

                        siteEventList.SiteEvents.Add(siteEvent);
                    }
                    while (reader.Read());

                }
            }

            return siteEventList;
        }
        

      

    }
}
