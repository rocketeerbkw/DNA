using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Objects
{

    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, TypeName = "CRUMBTRAILS")]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false, ElementName = "CRUMBTRAILS")]
    public partial class CrumbTrails
    {
        public CrumbTrails()
        {
            CrumbTrail = new List<CrumbTrail>();
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlElement(Order = 0, ElementName = "CRUMBTRAIL")]
        //[System.Xml.Serialization.XmlArrayItemAttribute("CRUMBTRAIL", IsNullable = false)]
        public List<CrumbTrail> CrumbTrail
        {
            get;
            set;
        }

        /// <summary>
        /// This method creates the Crumbtrail xml for a given article id
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the crumbtrail for</param>
        static public CrumbTrails CreateArticleCrumbtrail(int h2g2ID, IDnaDataReaderCreator readerCreator)
        {
            // Create the reader to get the details
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getarticlecrumbtrail"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.Execute();

                // Now create the crumbtrails from the results
                return GetCrumbtrailForItem(reader);
            }
        }

        /// <summary>
        /// This method creates the crumbtrail for a given item
        /// </summary>
        /// <param name="reader">The DnaDataReader that contains the crumbtrail result set.</param>
        static public CrumbTrails GetCrumbtrailForItem(IDnaDataReader reader)
        {
            CrumbTrails crumbTrialList = new CrumbTrails();
            bool startOfTrail = true;
            CrumbTrail crumbTrail = null;
            while (reader.Read())
            {
                // Check to see if we're at the top level
                int treeLevel = reader.GetInt32("TreeLevel");
                if (treeLevel == 0)
                {
                    startOfTrail = true;
                }

                // Check to see if we're starting a new trail
                if (startOfTrail)
                {
                    if (crumbTrail != null)
                    {//add the previous to the list
                        crumbTrialList.CrumbTrail.Add(crumbTrail);
                    }
                    //start new
                    crumbTrail = new CrumbTrail();
                    startOfTrail = false;
                }

                CrumbTrailAncestor ancestor = new CrumbTrailAncestor();
                ancestor.Name = reader.GetString("DisplayName");
                ancestor.NodeId = reader.GetInt32("NodeID");
                ancestor.TreeLevel = treeLevel;
                ancestor.NodeType = reader.GetInt32("Type");
                if (reader.Exists("RedirectNodeID") && !reader.IsDBNull("RedirectNodeID"))
                {
                    ancestor.RedirectNode = new CrumbTrialAncestorRedirect();
                    ancestor.RedirectNode.id = reader.GetInt32("RedirectNodeID");
                    ancestor.RedirectNode.value = reader.GetString("RedirectNodeName");
                }
                crumbTrail.Ancestor.Add(ancestor);
            }
            if (crumbTrail != null)
            {//add the previous to the list
                crumbTrialList.CrumbTrail.Add(crumbTrail);
            }
            return crumbTrialList;
        }

    }

}
