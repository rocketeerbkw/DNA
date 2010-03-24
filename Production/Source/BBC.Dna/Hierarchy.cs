using System;
using System.Text;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Web;
using System.Web.Caching;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Hierarchy - A derived DnaComponent object
    /// </summary>
    public class Hierarchy : DnaInputComponent
    {
        private const string GetHierarchyForAction = "gethierarchyforsite";
        private const string DocSiteID = @"SiteID to the return the hierarchy nodes for.";

        /// <summary>
        /// Default constructor for the Hierarchy component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public Hierarchy(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            int siteID = GetSiteIDFromParams();

            GetHierarchyForSite(siteID);

        }

        /// <summary>
        /// Gets Site ID from the Params
        /// </summary>
        /// <returns>The site id in the params</returns>
        private int GetSiteIDFromParams()
        {            
            int siteID = InputContext.GetParamIntOrZero("siteid", DocSiteID);
            if (siteID < 1)
            {
                siteID = InputContext.CurrentSite.SiteID;
            }

            return siteID;
        }

        /// <summary>
        /// Gets the hierarchy data for the Site
        /// </summary>
        /// <param name="siteID">Get the hierarchy for a given site</param>
        private void GetHierarchyForSite(int siteID)
        {
            XmlElement hierarchyNodes = null;
#if DEBUG
            if (!InputContext.DoesParamExist("d_nocache","Don't use the caching"))
            {
#endif
                hierarchyNodes = TryGetCachedXmlElementOrNull(siteID);
#if DEBUG
            }
#endif
            if (hierarchyNodes == null)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(GetHierarchyForAction))
                {
                    dataReader.AddParameter("@siteid", siteID);

                    dataReader.Execute();

                    // Check to make sure that we've got some data to play with
                    if (!dataReader.HasRows)
                    {
                        AddErrorXml("nohierarchydata", "No hierarchy data has been found.", null);
                        return;
                    }

                    // Now generate the xml for the posts
                    GenerateHierarchyForSiteXML(siteID, dataReader);
                }
            }
            else
            {
                Statistics.AddCacheHit();
                RootElement.AppendChild(ImportNode(hierarchyNodes));
            }
        }

        /// <summary>
        /// Generates the Xml structure containing the Hierarchy data
        /// </summary>
        /// <param name="siteID">Get the hierarchy for a given site</param>
        /// <param name="dataReader">Results from the database</param>
        private void GenerateHierarchyForSiteXML(int siteID, IDnaDataReader dataReader)
        {
            XmlElement hierarchyNodes = (XmlElement)RootElement.AppendChild(RootElement.OwnerDocument.CreateElement("HIERARCHYNODES"));
            hierarchyNodes.SetAttribute("SITEID", siteID.ToString());
            bool builtTopNode = false;
            // Got through the results building the tree
            while (dataReader.Read())
            {
                // Check to see if we've built the top level node yet
                if (!builtTopNode)
                {
                    XmlElement topElement = (XmlElement)AddElement(hierarchyNodes);
                    topElement.SetAttribute("NODEID", dataReader.GetInt32("ParentID").ToString());
                    topElement.SetAttribute("NAME", dataReader.GetString("ParentName").Trim());
                    topElement.SetAttribute("TREELEVEL", "0");
                    topElement.SetAttribute("TYPE", dataReader.GetInt32("Type").ToString());
                    builtTopNode = true;
                }

                int parentID = dataReader.GetInt32("ParentID");
                int treeLevel = dataReader.GetInt32("TreeLevel");
                XmlElement parent = (XmlElement)RootElement.SelectSingleNode("//NODE[@NODEID='" + parentID + "'][@TREELEVEL='" + (treeLevel - 1) + "']");
                if (parent == null)
                {
                    // Create the parent
                    parent = AddElement((XmlElement)RootElement.SelectSingleNode("LOCATION[@TREELEVEL='" + (treeLevel - 1) + "']"));
                    parent.SetAttribute("NODEID", parentID.ToString());
                    parent.SetAttribute("NAME", dataReader.GetString("ParentName").Trim());
                    int newTreeLevel = treeLevel - 1;
                    parent.SetAttribute("TREELEVEL", newTreeLevel.ToString());
                    parent.SetAttribute("TYPE", dataReader.GetInt32("ParentType").ToString());
                }

                XmlElement newElement = (XmlElement)AddElement(parent);
                newElement.SetAttribute("NODEID", dataReader.GetInt32("NodeID").ToString());
                newElement.SetAttribute("NAME", dataReader.GetString("DisplayName").Trim());
                newElement.SetAttribute("TREELEVEL", treeLevel.ToString());
                newElement.SetAttribute("TYPE", dataReader.GetInt32("Type").ToString());
            }

            AddCachedXmlElement(hierarchyNodes, siteID);
        }

        /// <summary>
        /// Helper function to create elements within the hierarchy nodes
        /// </summary>
        /// <param name="element">if given then attach the new element 'Node' to this</param>
        /// <returns>New Element (Node)</returns>
        private XmlElement AddElement(XmlElement element)
        {
            // Check to see if we need to create a new root node
            if (element == null)
            {
                XmlElement toplevel = (XmlElement) RootElement.SelectSingleNode("HIERARCHYNODES");
                return (XmlElement) toplevel.AppendChild(RootElement.OwnerDocument.CreateElement("NODE"));
            }
            else
            {
                return (XmlElement) element.AppendChild(RootElement.OwnerDocument.CreateElement("NODE"));
            }
        }

        /// <summary>
        /// Add the hierarchy nodes to the cache
        /// </summary>
        /// <param name="siteID">Adds the hierarchy for the given site</param>
        /// <param name="HierarchyNodes"></param>
        private void AddCachedXmlElement(XmlElement HierarchyNodes, int siteID)
        {
            string name = @"HierarchyXml-" + siteID.ToString();
            InputContext.CacheObject(name, HierarchyNodes, 24*60*60);
        }

        /// <summary>
        /// Gets the cached hierarchy nodes
        /// </summary>
        /// <param name="siteID">Get the hierarchy for the given site</param>
        /// <returns>The XmlElement containing the hierarchy nodes</returns>
        private XmlElement TryGetCachedXmlElementOrNull(int siteID)
        {
            string name = @"HierarchyXml-" + siteID.ToString();
            return (XmlElement) InputContext.GetCachedObject(name);
        }

    }
}