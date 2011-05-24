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
using System.Xml.Linq;


namespace BBC.Dna.Moderation
{
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "USEREVENTLIST")]
    [XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "USEREVENTLIST")]
    public class UserEventList
    {
        public UserEventList()
        {
            UserEventObjList = new List<UserEvent>();
        }

        [XmlArray(Order = 1, ElementName = "USEREVENTLIST")]
        [XmlArrayItem(ElementName = "USEREVENT")]
        public List<UserEvent> UserEventObjList
        {
            get;
            set;
        }

        [XmlElement(Order = 2, ElementName = "MODERATIONCLASS")]
        public ModerationClass ModClass { get; set; }


        [XmlAttribute(AttributeName = "TOTALITEMS")]
        public int TotalItems { get; set; }

        [XmlAttribute(AttributeName = "STARTINDEX")]
        public long StartIndex { get; set; }

        [XmlAttribute(AttributeName = "ITEMSPERPAGE")]
        public int ItemsPerPage { get; set; }

        [XmlAttribute(AttributeName = "USERID")]
        public int UserId { get; set; }

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
        static public UserEventList GetUserEventList(ModerationClass modClass, int startIndex, int itemsPerPage,
            DateTime startDate, DateTime endDate, IDnaDataReaderCreator readerCreator, int userid)
        {
            var userEventList = new UserEventList()
            {
                ModClass = modClass,
                UserId = userid
            };

            using (var reader = readerCreator.CreateDnaDataReader("getuserevents"))
            {
                reader.AddParameter("modclassid", modClass.ClassId);
                reader.AddParameter("userid", userid);
                reader.AddParameter("itemsperpage", itemsPerPage);
                reader.AddParameter("startindex", startIndex);
                if(startDate != DateTime.MinValue)
                {
                    reader.AddParameter("startdate", startDate);
                }
                if(endDate != DateTime.MaxValue)
                {
                    reader.AddParameter("enddate", endDate);
                }
                reader.Execute();

                if (reader.Read())
                {
                    userEventList.TotalItems = reader.GetInt32NullAsZero("total");
                    userEventList.StartIndex = reader.GetLongNullAsZero("n") - 1;
                    userEventList.ItemsPerPage = itemsPerPage;
                    if (startDate != DateTime.MinValue)
                    {
                        userEventList.StartDate = new DateElement(startDate);
                    }
                    if (endDate != DateTime.MaxValue)
                    {
                        userEventList.EndDate = new DateElement(endDate);
                    }
                    do
                    {
                        var userEvent = new UserEvent();
                        userEvent.Type = (SiteActivityType)reader.GetInt32NullAsZero("typeid");
                        try
                        {
                            if (userEvent.Type == SiteActivityType.UserPost)
                            {
                                userEvent.ActivityData = XElement.Parse(string.Format("<ACTIVITYDATA>User posted {0} time{1}</ACTIVITYDATA>",
                                    reader.GetInt32NullAsZero("numberofposts")
                                    , reader.GetInt32NullAsZero("numberofposts") == 1 ? "" : "s"));
                            }
                            else
                            {
                                userEvent.ActivityData = XElement.Parse(reader.GetStringNullAsEmpty("activitydata"));
                            }
                            
                            
                        }
                        catch
                        {//skip a badly formatted element
                            continue;
                        }
                        userEvent.Date = new Date(reader.GetDateTime("eventdate"));

                        if (userEvent.Type == SiteActivityType.UserPost)
                        {
                            userEvent.Score = (int)reader.GetInt16("score") * reader.GetInt32NullAsZero("numberofposts");
                        }
                        else
                        {
                            userEvent.Score = (int)reader.GetInt16("score");
                        }
                        userEvent.AccummulativeScore = (int)reader.GetInt16("accumulativescore");

                        userEventList.UserEventObjList.Add(userEvent);
                    }
                    while (reader.Read());

                }
            }

            return userEventList;
        }
        

      

    }
}
