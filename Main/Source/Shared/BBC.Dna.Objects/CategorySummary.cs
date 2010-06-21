using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(TypeName = "CATEGORYSUMMARY")]
    public class CategorySummary
    {


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "NODEID")]
        public int NodeID { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 1, ElementName = "TYPE")]
        public int Type { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 2, ElementName = "NODECOUNT")]
        public int NodeCount { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 3, ElementName = "ARTICLECOUNT")]
        public int ArticleCount { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 4, ElementName = "ALIASCOUNT")]
        public int AliasCount { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 5, ElementName = "NAME")]
        public string Name { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 6, ElementName = "STRIPPEDNAME")]
        public string StrippedName { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute(Order = 7, ElementName="SUBNODES")]
        [System.Xml.Serialization.XmlArrayItemAttribute("SUBNODE", IsNullable = false)]
        public System.Collections.Generic.List<CategorySummarySubnode> SubNodes { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("SORTORDER")]
        public int SortOrder { get; set; }


        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 8, ElementName = "TREELEVEL")]
        public int TreeLevel { get; set; }

        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 9, ElementName = "REDIRECTNODEID")]
        public int RedirectNodeID { get; set; }

        public virtual bool ShouldSerializeSUBNODES()
        {
            return SubNodes != null && SubNodes.Count > 0;
        }



        public static List<CategorySummary> GetCategoryAncestry(IDnaDataReaderCreator readerCreator, int categoryId)
        {
            List<CategorySummary> categorySummaries = new List<CategorySummary>();

            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getancestry"))
            {
                reader.AddParameter("catID", categoryId);
                reader.Execute();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        CategorySummary newCategorySummary = new CategorySummary();
                        newCategorySummary.NodeID = reader.GetInt32NullAsZero("AncestorID");
                        newCategorySummary.Type = reader.GetInt32NullAsZero("Type");
                        newCategorySummary.Name = reader.GetStringNullAsEmpty("DisplayName");
                        newCategorySummary.TreeLevel = reader.GetInt32NullAsZero("TreeLevel");
                        newCategorySummary.StrippedName = StringUtils.StrippedName(reader.GetStringNullAsEmpty("DisplayName"));                        
                        if (reader.DoesFieldExist("RedirectNodeID") && !reader.IsDBNull("RedirectNodeID"))
                        {
                            newCategorySummary.RedirectNodeID = reader.GetInt32NullAsZero("RedirectNodeID");
                        }
                        categorySummaries.Add(newCategorySummary);
                    }
                }
            }

            // the returned instance may have 0 items in the case of the root categories, but this is OK
            return categorySummaries;
        }


        public static List<CategorySummary> GetChildCategories(IDnaDataReaderCreator readerCreator, int nodeID)
        {
            List<CategorySummary> childCategories = new List<CategorySummary>();
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getsubjectsincategory"))
            {
                reader.AddParameter("nodeID", nodeID);
                reader.Execute();
                if (reader.HasRows)
                {                    
                    while (reader.Read())
                    {
                        CategorySummary newCategorySummary = new CategorySummary();
                        newCategorySummary.NodeID = reader.GetInt32NullAsZero("NodeID");
                        newCategorySummary.Type = reader.GetInt32NullAsZero("Type");
                        newCategorySummary.NodeCount = reader.GetInt32NullAsZero("NodeCount");
                        newCategorySummary.ArticleCount = reader.GetInt32NullAsZero("ArticleCount");
                        newCategorySummary.AliasCount = reader.GetInt32NullAsZero("AliasCount");
                        newCategorySummary.Name = reader.GetStringNullAsEmpty("DisplayName");
                        newCategorySummary.StrippedName = StringUtils.StrippedName(reader.GetStringNullAsEmpty("DisplayName"));
                        newCategorySummary.RedirectNodeID = reader.GetInt32NullAsZero("RedirectNodeID");
                        newCategorySummary.TreeLevel = reader.GetInt32NullAsZero("TreeLevel");

                        // Is this item a subnode?
                        bool isThisASubnode = (reader.DoesFieldExist("SubName") && !reader.IsDBNull("SubName"));
                        if (!isThisASubnode)                       
                        {
                            childCategories.Add(newCategorySummary);
                        }
                        else //isThisASubnode = true
                        {
                            // is there already a parent?
                            int parentNodeID = reader.GetInt32NullAsZero("NodeID");
                            CategorySummary parentCategorySummary = (from i in childCategories
                                                                     where i.NodeID == parentNodeID
                                                                     select i).FirstOrDefault();

                            // if there's no parent, then create one
                            if (parentCategorySummary == null)
                            {
                                parentCategorySummary = newCategorySummary;
                                childCategories.Add(parentCategorySummary);   
                            }

                            // ensure the parent exists before adding children
                            if (parentCategorySummary.SubNodes == null)
                            {
                                parentCategorySummary.SubNodes = new List<CategorySummarySubnode>();
                            }

                            //create and add the subnode
                            CategorySummarySubnode newSubnode = new CategorySummarySubnode();
                            newSubnode.ID = reader.GetInt32NullAsZero("SubNodeID");
                            newSubnode.Type = reader.GetInt32NullAsZero("SubNodeType");
                            newSubnode.Value = reader.GetStringNullAsEmpty("SubName");
                            parentCategorySummary.SubNodes.Add(newSubnode);
                        }
 
                    }
                }
            }
            // the returned instance may have 0 items, but this is OK
            return childCategories;
        }
    }
}
