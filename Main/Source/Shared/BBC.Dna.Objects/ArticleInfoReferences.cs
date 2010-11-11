using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using System.Xml.Serialization;
using System.Runtime.Serialization;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "ARTICLEINFOREFERENCES")]
    [DataContract (Name="references")]
    public partial class ArticleInfoReferences
    {

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 0, ElementName = "ENTRIES")]
        [System.Xml.Serialization.XmlArrayItemAttribute("ENTRYLINK", IsNullable = false)]
        [DataMember (Name="entries", Order=1)]
        public System.Collections.Generic.List<ArticleInfoReferencesEntryLink> Entries
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 1, ElementName = "EXTERNAL")]
        [System.Xml.Serialization.XmlArrayItemAttribute("EXTERNALLINK", IsNullable = false)]
        [DataMember(Name = "externalLinks", Order = 2)]
        public System.Collections.Generic.List<ArticleInfoReferencesExternalLink> External
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 2, ElementName = "USERS")]
        [System.Xml.Serialization.XmlArrayItemAttribute("USERLINK", IsNullable = false)]
        [DataMember(Name = "users", Order = 3)]
        public System.Collections.Generic.List<ArticleInfoReferencesUser> Users
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 3, ElementName = "BBC")]
        [System.Xml.Serialization.XmlArrayItemAttribute("BBCLINK", IsNullable = false)]
        [DataMember(Name = "BBCLinks", Order = 4)]
        public System.Collections.Generic.List<ArticleInfoReferencesExternalLink> BBC
        {
            get;
            set;
        }

        static public ArticleInfoReferences CreateArticleInfoReferences(IDnaDataReaderCreator creator, XmlNode guideNode)
        {
            // Create the base node
            ArticleInfoReferences references = new ArticleInfoReferences()
            {
                Entries = new List<ArticleInfoReferencesEntryLink>(),
                External = new List<ArticleInfoReferencesExternalLink>(),
                Users = new List<ArticleInfoReferencesUser>(),
                BBC = new List<ArticleInfoReferencesExternalLink>()
            };


            // Now go through the body text extracting all References
            XmlNodeList linkNodes = guideNode.SelectNodes("//LINK");
            List<int> userIDs = new List<int>();
            List<int> articleIDs = new List<int>();
            int uniqueIndex = 0;
            foreach (XmlNode linkNode in linkNodes)
            {
                // Check to see if it's a link we're intrested in
                if (linkNode.Attributes["H2G2"] != null
                    || linkNode.Attributes["DNAID"] != null
                    || linkNode.Attributes["BIO"] != null)
                {
                    // Get the value from the attribute
                    string value = "";
                    if (linkNode.Attributes["H2G2"] != null)
                    {
                        value = linkNode.Attributes["H2G2"].Value;
                    }
                    else if (linkNode.Attributes["DNAID"] != null)
                    {
                        value = linkNode.Attributes["DNAID"].Value;
                    }
                    else if (linkNode.Attributes["BIO"] != null)
                    {
                        value = linkNode.Attributes["BIO"].Value;
                    }

                    // If we've got a value, get the id and add it to the correct list
                    if (value.Length > 0)
                    {
                        string type = value.Substring(0, 1);
                        value = value.Substring(1);
                        int typeID = 0;
                        Int32.TryParse((value.Split('?'))[0], out typeID);

                        if (type.CompareTo("U") == 0)
                        {
                            userIDs.Add(typeID);
                        }
                        else if (type.CompareTo("A") == 0 || type.CompareTo("P") == 0)
                        {
                            articleIDs.Add(typeID);
                        }
                    }
                }
                else if (linkNode.Attributes["HREF"] != null)
                {
                    ArticleInfoReferencesExternalLink exLink = new ArticleInfoReferencesExternalLink()
                    {
                        Index = uniqueIndex,
                        OffSite = linkNode.Attributes["HREF"].Value,
                    };
                    exLink.Title = linkNode.InnerText;
                    if (linkNode.Attributes["TITLE"] != null)
                    {
                        exLink.Title = linkNode.Attributes["TITLE"].Value;
                    }
                    if (exLink.OffSite.StartsWith("http://www.bbc.co.uk") || exLink.OffSite.StartsWith("www.bbc.co.uk"))
                    {
                        references.BBC.Add(exLink);
                    }
                    else
                    {
                        references.External.Add(exLink);
                    }
                    uniqueIndex++;
                }
            }

            // Keep going untill all IDs have been processed
            if (userIDs.Count > 0)
            {
                // Now add all the user References
                references.Users = ArticleInfoReferencesUser.CreateUserReferences(creator, userIDs);
            }

            // Now add all the article References
            if (articleIDs.Count > 0)
            {
                references.Entries = ArticleInfoReferencesEntryLink.CreateArticleReferences(articleIDs, creator);
            }

            return references;
        }
    }
}
