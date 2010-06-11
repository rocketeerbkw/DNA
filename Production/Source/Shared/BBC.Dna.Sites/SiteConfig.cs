using System;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Sites
{
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlType(AnonymousType = true, TypeName = "SITECONFIG")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "SITECONFIG")]
    public class SiteConfig
    {
        public SiteConfig()
        {
            V2Board = new SiteConfigV2Board();
            EditKey = Guid.Empty;
        }

        [XmlAnyElement(Order=1)]
        public XmlElement[] LegacyElements { get; set; }

        /// <remarks/>
        [XmlElement(Order = 0, ElementName = "V2_BOARDS")]
        public SiteConfigV2Board V2Board { get; set; }

        [XmlIgnore]
        public int SiteId { get; set; }

        [XmlIgnore]
        public Guid EditKey { get; set; }

        /// <summary>
        /// Returns the object filles from the preview table.
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="readerCreator"></param>
        /// <returns></returns>
        public static SiteConfig GetPreviewSiteConfig(int siteId, IDnaDataReaderCreator readerCreator)
        {
            var siteConfig = new SiteConfig {SiteId = siteId};

            using(var reader = readerCreator.CreateDnaDataReader("fetchpreviewsiteconfig"))
            {
                reader.AddParameter("siteid", siteId);
                reader.Execute();
                if(reader.Read())
                {
                    siteConfig.EditKey = reader.GetGuid("editkey");
                    var siteConfigStr = reader.GetStringNullAsEmpty("config");
                    if(!string.IsNullOrEmpty(siteConfigStr))
                    {
                        var xmlSiteConfig = new XmlDocument();
                        xmlSiteConfig.LoadXml(Entities.GetEntities() + siteConfigStr);

                        /*var xmlV2Node = xmlSiteConfig.SelectSingleNode("//SITECONFIG/V2_BOARDS");
                        if(xmlV2Node != null)
                        {
                            siteConfig.V2Board = (SiteConfigV2Board)StringUtils.DeserializeObjectUsingXmlSerialiser(xmlV2Node.OuterXml, typeof(SiteConfigV2Board));
                        }*/

                        var elements = new List<XmlElement>();
                        foreach (XmlElement childNode in xmlSiteConfig.ChildNodes[1].ChildNodes)
                        {
                            if(childNode.Name == "V2_BOARDS")
                            {
                                siteConfig.V2Board = (SiteConfigV2Board)StringUtils.DeserializeObjectUsingXmlSerialiser(childNode.OuterXml, typeof(SiteConfigV2Board));
                            }
                            else
                            {
                                elements.Add(childNode);
                            }
                        }
                        siteConfig.LegacyElements = elements.ToArray();
                    }
                    
                }
            }
            return siteConfig;
        }

        /// <summary>
        /// Updates the configuration into the current preview
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="updateLiveConfig"></param>
        /// <returns></returns>
        public BaseResult UpdateConfig(IDnaDataReaderCreator readerCreator, bool updateLiveConfig)
        {
            var spName = "updatepreviewsiteconfig";
            if(updateLiveConfig)
            {
                spName = "updatepreviewandliveconfig";
            }

            using (var reader = readerCreator.CreateDnaDataReader(spName))
            {
                reader.AddParameter("siteid", SiteId);
                reader.AddParameter("config", StringUtils.SerializeToXmlUsingXmlSerialiser(this));
                reader.AddParameter("editkey", EditKey);
                reader.Execute();
                if(reader.Read())
                {
                    if(reader.DoesFieldExist("ValidKey"))
                    {
                        if(reader.GetInt32NullAsZero("ValidKey") == 0)
                        {
                            return new Error("SiteConfigUpdateInvalidKey",
                                             "The edit key used to update did not match the currently used key");
                        }
                    }
                }
            }
            //get the latest edit key
            var tempConfig = GetPreviewSiteConfig(SiteId, readerCreator);
            EditKey = tempConfig.EditKey;

            return new Result("SiteConfigUpdateSuccess", "Preview site config updated successfully");
        }
    }
}
