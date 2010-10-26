using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Xml.Serialization;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// Class for Moderator Info
    /// </summary>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "ModeratorInfo")]
    public class ModeratorInfo
    {
        public ModeratorInfo()
        {
            Classes = new List<int>();
            Sites  = new List<ModeratorSite>();

        }

        //[XmlElementAttribute(Order = 0, ElementName = "USER")]
        //public User USER
        //{
        //    get;
        //    set;
        //}

        /// <remarks/>
        [XmlArrayAttribute(Order = 1, ElementName = "CLASSES")]
        [XmlArrayItemAttribute("CLASSID", IsNullable = false)]
        public List<int> Classes
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlArrayAttribute(Order = 2, ElementName = "SITES")]
        [XmlArrayItemAttribute("SITE", IsNullable = false)]
        public List<ModeratorSite> Sites
        {
            get;
            set;
        }

        [XmlArrayAttribute(Order = 3, ElementName = "ACTIONITEMS")]
        [XmlArrayItemAttribute("ACTIONITEM", IsNullable = false)]
        public List<ModeratorActionItem> ActionItems { get; set; }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "ISMODERATOR")]
        public int IsModerator
        {
            get;set;
        }


        /// <summary>
        /// Function to get the XML representation of the Moderator Info
        /// </summary>
        /// <param name="userID">userID.</param>
        public static ModeratorInfo GetModeratorInfo(IDnaDataReaderCreator creator, int userID, ISiteList siteList)
        {
            var moderatorInfo = new ModeratorInfo();

            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("getmoderatorinfo"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    if (dataReader.Read())
                    {
                        moderatorInfo.IsModerator = dataReader.GetInt32NullAsZero("IsModerator");

                        //User user = new User(InputContext);
                        //user.AddUserXMLBlock(dataReader, userID, moderator);

                        int curClassID = 0;
                        int curSiteID = 0;
                        do
                        {
                            int classID = dataReader.GetInt32NullAsZero("SiteClassID");
                            int siteID = dataReader.GetInt32NullAsZero("SiteID");

                            bool isNullClassID = dataReader.IsDBNull("SiteClassID");
                            bool isNullSiteID = dataReader.IsDBNull("SiteID");

                            if (!isNullClassID && curClassID != classID)
                            {
                                if (!moderatorInfo.Classes.Contains(classID))
                                {
                                    moderatorInfo.Classes.Add(classID);
                                }
                            }

                            if (!isNullSiteID && curSiteID != siteID)
                            {
                                ModeratorSite site = new ModeratorSite();
                                site.SiteId = siteID;
                                if (!isNullClassID)
                                {
                                    site.ClassId = classID;
                                }
                                try
                                {
                                    site.Type = siteList.GetSiteOptionValueInt(siteID, "General", "SiteType");
                                }
                                catch
                                {
                                    site.Type = (int)SiteType.Undefined;
                                }
                                moderatorInfo.Sites.Add(site);
                                curSiteID = siteID;
                            }
                        } while (dataReader.Read());

                        moderatorInfo.ActionItems = GetModeratorActionItems(creator, userID);

                    }
                }
            }
            return moderatorInfo;
        }

        /// <summary>
        /// Creates the action items for the given user.
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        static private List<ModeratorActionItem> GetModeratorActionItems(IDnaDataReaderCreator creator, int userId)
        {
            List<ModeratorActionItem> items = new List<ModeratorActionItem>();
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("fetchmoderationstatisticsperuserbytype"))
            {
                dataReader.AddParameter("userID", userId);
                dataReader.Execute();
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        int total = dataReader.GetInt32NullAsZero("total");
                        SiteType type = (SiteType)Enum.Parse(typeof(SiteType), dataReader.GetStringNullAsEmpty("sitetype"), true);

                        var item = items.Find(x => x.Type == type);
                        if (item == null)
                        {
                            items.Add(new ModeratorActionItem(){Total = total, Type = type});
                        }
                        else
                        {
                            item.Total += total;
                        }
                    }
                }
            }
            return items;
        }


    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "ModeratorSite")]
    public partial class ModeratorSite
    {
        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "SITEID")]
        public int SiteId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "CLASSID")]
        public int ClassId
        {
            get;
            set;
        }

        /// <remarks/>
        [XmlAttributeAttribute(AttributeName = "TYPE")]
        public int Type
        {
            get;
            set;
        }
    }
}
