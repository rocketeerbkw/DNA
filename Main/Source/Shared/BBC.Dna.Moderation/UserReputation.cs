using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Xml.Schema;

namespace BBC.Dna.Moderation
{
    [Serializable]
    [DataContract(Name = "userReputation")]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "USERREPUTATION")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "USERREPUTATION")]
    public class UserReputation
    {
        public UserReputation()
        {
        }

        [DataMember(Name = "currentStatus")]
        [XmlElementAttribute(Form = XmlSchemaForm.Unqualified, Order = 1, ElementName = "CURRENTSTATUS")]
        public ModerationStatus.UserStatus CurrentStatus { get; set; }

        [DataMember(Name = "reputationDeterminedStatus")]
        [XmlElementAttribute(Form = XmlSchemaForm.Unqualified, Order = 2, ElementName = "REPUTATIONDETERMINEDSTATUS")]
        public ModerationStatus.UserStatus ReputationDeterminedStatus { get; set; }

        [DataMember(Name = "reputationScore")]
        [XmlElementAttribute(Form = XmlSchemaForm.Unqualified, Order = 3, ElementName = "REPUTATIONSCORE")]
        public short ReputationScore { get; set; }

        [DataMember(Name = "moderationClass")]
        [XmlElementAttribute(Form = XmlSchemaForm.Unqualified, Order = 4, ElementName = "MODERATIONCLASS")]
        public ModerationClass ModClass { get; set; }

        [DataMember(Name = "userId")]
        [XmlElementAttribute(Form = XmlSchemaForm.Unqualified, Order = 5, ElementName = "USERID")]
        public int UserId { get; set; }

        /// <summary>
        /// Generates user reputation object
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="modClass"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public static UserReputation GetUserReputation(IDnaDataReaderCreator creator, ModerationClass modClass,
            int userId)
        {
            UserReputation userRep = new UserReputation() { ModClass = modClass, UserId = userId };

            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getuserreputation"))
            {
                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("modclassid", modClass.ClassId);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    userRep.CurrentStatus = (ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("currentstatus");
                    userRep.ReputationDeterminedStatus = (ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("ReputationDeterminedStatus");
                    userRep.ReputationScore = dataReader.GetInt16("accumulativescore");
                }
            }
            return userRep;
        }

    }
}
