using BBC.Dna.Data;
using System.Xml;
using System.Xml.Serialization;
namespace BBC.Dna.Objects
{
    
    
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="RELATEDCLUBS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace="", IsNullable=false, ElementName="RELATEDCLUBS")]
    public partial class RelatedClubs
    {
        public RelatedClubs()
        {
            ClubMember = new System.Collections.Generic.List<RelatedClubsMember>();
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("CLUBMEMBER", Order = 0)]
        public System.Collections.Generic.List<RelatedClubsMember> ClubMember
        {
            get;
            set;
        }


        /// <summary>
        /// This methos gets the list of related clubs for a given article
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the related clubs for</param>
        static public RelatedClubs GetRelatedClubs(int h2g2ID, IDnaDataReaderCreator readerCreator)
        {
            RelatedClubs relatedClubs = new RelatedClubs();
            // Create a data reader to get all the clubs
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getrelatedclubs"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.Execute();
                // Add each club member in turn
                while (reader.Read())
                {
                    RelatedClubsMember member = new RelatedClubsMember();
                    member.ClubId = reader.GetInt32("ClubID");
                    member.Name = reader.GetString("Subject");
                    member.ExtraInfo = reader.GetString("ExtraInfo") ?? "";

                    relatedClubs.ClubMember.Add(member);
                    //ExtraInfo clubExtraInfo = new ExtraInfo();
                    //clubExtraInfo.TryCreate(reader.GetInt32("Type"), reader.GetString("ExtraInfo"));
                    //clubNode.AppendChild(ImportNode(clubExtraInfo.RootElement.FirstChild));
                    //if (reader.Exists("DateCreated"))
                    //{
                    //    XmlNode dateCreatedNode = AddElementTag(clubNode, "DATECREATED");
                    //    dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("DateCreated"), true));
                    //}
                    //if (reader.Exists("Lastupdated"))
                    //{
                    //    XmlNode dateCreatedNode = AddElementTag(clubNode, "LASTUPDATE");
                    //    dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("DateCreated"), true));
                    //}

                    // NEED TO ADD EDITOR, CLUBMEMBERS, LOCAL, EXTRAINFO, STRIPPED NAME... CHECK CLUB MEMBERS
                }
            }
            return relatedClubs;
        }

    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, TypeName="RELATEDCLUBSCLUBMEMBER")]
    public partial class RelatedClubsMember
    {
        public RelatedClubsMember()
        {
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "CLUBID")]
        public int ClubId
        {
            get;
            set;
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "NAME")]
        public string Name
        {
            get;
            set;
        }

        /// <remarks/>
        private string _extraInfo = string.Empty;
        [XmlIgnore]
        public string ExtraInfo
        {
            get { return _extraInfo; }
            set { _extraInfo = value; }
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAnyElement(Order = 2)]
        public XmlElement ExtraInfoElement
        {
            get
            {
                return ExtraInfoCreator.CreateExtraInfo(ExtraInfo);
            }
            set
            {
                ExtraInfo = value.OuterXml;
            }
        }
    }
}
