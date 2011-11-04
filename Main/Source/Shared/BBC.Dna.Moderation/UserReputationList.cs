using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Xml.Schema;
using BBC.Dna.Objects;
using BBC.Dna.Common;

namespace BBC.Dna.Moderation
{
    [Serializable]
    [DataContract(Name = "userReputationList")]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "USERREPUTATIONLIST")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "USERREPUTATIONLIST")]
    public class UserReputationList
    {
        public UserReputationList()
        {
            Users = new List<UserReputation>();
        }

        [DataMember(Name = "modClassId")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName= "MODCLASSID")]
        public int modClassId { get; set; }

        [DataMember(Name = "days")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "DAYS")]
        public int days { get; set; }

        [DataMember(Name = "modStatus")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "MODSTATUS")]
        public int modStatus { get; set; }

        [DataMember(Name = "startIndex")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "STARTINDEX")]
        public int startIndex { get; set; }

        [DataMember(Name = "itemsPerPage")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "ITEMSPERPAGE")]
        public int itemsPerPage { get; set; }

        [DataMember(Name = "totalItems")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "TOTALITEMS")]
        public int totalItems { get; set; }

        [DataMember(Name = "sortBy")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "SORTBY")]
        public SortBy sortBy { get; set; }

        [DataMember(Name = "sortDirection")]
        [XmlAttribute(Form = XmlSchemaForm.Unqualified, AttributeName = "SORTDIRECTION")]
        public SortDirection sortDirection { get; set; }

        [DataMember(Name = "users")]
        [XmlArray(Form = XmlSchemaForm.Unqualified, Order = 1, ElementName = "USERS")]
        [XmlArrayItem(Form = XmlSchemaForm.Unqualified, ElementName = "USERREPUTATION")]
        public List<UserReputation> Users { get; set; }

         /// <summary>
        /// Generates user reputation object
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="modClass"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static UserReputationList GetUserReputationList(IDnaDataReaderCreator creator, int modClassId, int modStatus,
            int days, int startIndex, int itemsPerPage)
        {
            return GetUserReputationList(creator, modClassId, modStatus, days, startIndex, itemsPerPage, SortBy.Created, SortDirection.Ascending);
        }

        /// <summary>
        /// Generates user reputation object
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="modClass"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static UserReputationList GetUserReputationList(IDnaDataReaderCreator creator, int modClassId, int modStatus,
            int days, int startIndex, int itemsPerPage, SortBy sortBy, SortDirection sortDirection)
        {
            UserReputationList userRepList = new UserReputationList()
            {
                days = days,
                modClassId = modClassId,
                modStatus = modStatus,
                startIndex = startIndex,
                itemsPerPage = itemsPerPage,
                sortBy = sortBy,
                sortDirection = sortDirection
            };

            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getuserreputationlist"))
            {
                dataReader.AddParameter("modClassId", modClassId);
                dataReader.AddParameter("modStatus", modStatus);
                dataReader.AddParameter("startIndex", startIndex);
                dataReader.AddParameter("itemsPerPage", itemsPerPage);
                dataReader.AddParameter("days", days);
                dataReader.AddParameter("sortby", sortBy.ToString());
                dataReader.AddParameter("sortdirection", sortDirection.ToString());
                
                dataReader.Execute();

                while(dataReader.Read())
                {
                    var userRep = new UserReputation();
                    userRep.UserId = dataReader.GetInt32NullAsZero("userid");
                    userRep.ModClass = ModerationClassListCache.GetObject().ModClassList.FirstOrDefault(x => x.ClassId == dataReader.GetInt32NullAsZero("modclassid"));
                    userRep.CurrentStatus = (ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("currentstatus");
                    userRep.ReputationDeterminedStatus = (ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("ReputationDeterminedStatus");
                    userRep.ReputationScore = dataReader.GetInt16("accumulativescore");
                    userRep.LastUpdated = new DateElement(dataReader.GetDateTime("lastupdated"));
                    userRep.UserName = dataReader.GetStringNullAsEmpty("UserName");
                    
                    userRepList.Users.Add(userRep);
                    userRepList.totalItems = dataReader.GetInt32NullAsZero("total");
                }
            }
            return userRepList;
        }

    }
}
