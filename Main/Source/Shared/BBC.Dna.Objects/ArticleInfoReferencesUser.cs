using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "REFERENCESUSERLINK")]
    [DataContract (Name="referenceUser")]
    public partial class ArticleInfoReferencesUser
    {
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "USERID")]
        [DataMember (Name="userId")]
        public int UserId { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "USERNAME")]
        [DataMember(Name = "username")]
        public string Username { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "H2G2")]
        public string H2g2
        {
            get;
            set;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userIDs"></param>
        /// <returns></returns>
        static public List<ArticleInfoReferencesUser> CreateUserReferences(IDnaDataReaderCreator creator, List<int> userIDs)
        {
            List<ArticleInfoReferencesUser> users = new List<ArticleInfoReferencesUser>();
            using (IDnaDataReader reader = creator.CreateDnaDataReader("getusernames"))
            {
                for (int i = 1; i < 90 && userIDs.Count > 0; i++)
                {
                    reader.AddParameter("id" + i.ToString(), userIDs[0]);
                    userIDs.RemoveAt(0);
                }
                reader.Execute();

                while (reader.Read())
                {
                    ArticleInfoReferencesUser user = new ArticleInfoReferencesUser();
                    user.UserId = reader.GetInt32NullAsZero("UserID");
                    user.H2g2 = "U" + user.UserId.ToString();
                    user.Username = reader.GetStringNullAsEmpty("UserName");
                    users.Add(user);
                }
            }
            return users;
        }
    }
}
