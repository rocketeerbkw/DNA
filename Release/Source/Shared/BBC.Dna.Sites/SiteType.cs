using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace BBC.Dna.Sites
{

    public enum SiteType
    {        
        Undefined = 0,
        [XmlEnumAttribute]
        Blog = 1,
        [XmlEnumAttribute]
        Messageboard = 2,
        [XmlEnumAttribute]
        Community = 3,
        [XmlEnumAttribute]
        EmbeddedComments = 4,
        [XmlEnumAttribute]
        Twitter = 5
    }

    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "SITETYPE")]
    [XmlRootAttribute("SITETYPE", Namespace = "", IsNullable = false)]
    public class SiteTypeEnum
    {
        public SiteTypeEnum() { }
        [XmlText]
        public string Name { get; set; }

        [XmlAttribute (AttributeName="ID")]
        public int Id { get; set; }
    }


    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "SITETYPELIST")]
    [XmlRootAttribute("SITETYPELIST", Namespace = "", IsNullable = false)]
    public class SiteTypeEnumList
    {
        public SiteTypeEnumList() { }

        [System.Xml.Serialization.XmlArrayAttribute("SITETYPES", Order = 1)]
        [System.Xml.Serialization.XmlArrayItemAttribute("SITETYPE", IsNullable = false)]
        public SiteTypeEnum[] types { get; set; }

        static public SiteTypeEnumList GetSiteTypes()
        {
            SiteTypeEnumList list = new SiteTypeEnumList();
            list.types = new SiteTypeEnum[Enum.GetNames(typeof(SiteType)).Length - 1];

            int posArray = 0;
            foreach (SiteType type in Enum.GetValues(typeof(SiteType)))
            {
                if (type == SiteType.Undefined)
                {
                    continue;
                }
                list.types[posArray] = new SiteTypeEnum() { Id = posArray + 1, Name = type.ToString() };
                posArray++;
            }
            return list;
        }
    }



}
