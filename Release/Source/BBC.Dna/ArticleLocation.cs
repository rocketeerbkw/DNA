using System;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Article Location
    /// </summary>
    public class ArticleLocation : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the Hierarchy component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ArticleLocation(IInputContext context)
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

            int articleID = InputContext.GetParamIntOrZero("articleID", "ID of article");

            try
            {
                string action = String.Empty;
                if (InputContext.TryGetParamString("dnaaction", ref action, "Action to take on this request."))
                {
                    if (action == "add")
                    {
                        double latitude = Convert.ToDouble(InputContext.GetParamStringOrEmpty("lat", "Latitude of item"));
                        double longitude = Convert.ToDouble(InputContext.GetParamStringOrEmpty("long", "Longitude of item"));
                        SetArticleLocation(articleID, latitude, longitude);
                    }

                    if (action == "delete")
                    {
                        int locationId = InputContext.GetParamIntOrZero("locationid", "Id of coordinate associated with guide entry");  
                        DeleteArticleLocation(articleID, locationId);
                    }
                }
            }
            catch (FormatException)
            {
                AddErrorXml("ProcessRequest", "We don't recognise those coordinates!", null);
            }

            GenerateArticleLocationXml(articleID); 
        }

        /// <summary>
        /// Generates Xml for article
        /// </summary>
        /// <param name="articleID"></param>
        /// <returns>Success</returns>
        private void GenerateArticleLocationXml(int articleID)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("GetGuideEntryLocation"))
            {
                dataReader.AddParameter("@h2g2id", articleID);
                
                dataReader.Execute();

                // Check to make sure that we've got some data to play with
                if (!dataReader.HasRows)
                {
                    AddErrorXml("GenerateArticleLocationXml", "We can't find that article!", null);
                }

                bool builtArticleNode = true; // article node already built 

                XmlNode articleNode = RootElement.SelectSingleNode("/DNAROOT/ARTICLE");
                if (articleNode == null)
                {
                    articleNode = AddElementTag(RootElement, "ARTICLE");
                    builtArticleNode = false;
                }

                // Got through the results building the tree
                while (dataReader.Read())
                {
                    if (!builtArticleNode)
                    {
                        AddAttribute(articleNode, "H2G2ID", articleID);
                        int siteID = dataReader.GetInt32NullAsZero("SiteID");
                        if (siteID != 0)
                        {
                            AddAttribute(articleNode, "SITEID", dataReader.GetInt32("SiteID"));
                        }
                        builtArticleNode = true;
                    }
                    
                    double latitude = dataReader.GetDoubleNullAsZero("Latitude"); 
                    double longitude = dataReader.GetDoubleNullAsZero("Longitude"); 

                    if (!(latitude == 0 && longitude == 0))
                    {
                        XmlNode newLocationNode = AddElementTag(articleNode, "LOCATION");
                        AddAttribute(newLocationNode, "ID", dataReader.GetInt32NullAsZero("ID").ToString());
                        AddAttribute(newLocationNode, "LAT", latitude.ToString());
                        AddAttribute(newLocationNode, "LONG", longitude.ToString());
                    }
                }
            }
        }

        /// <summary>
        /// Sets Article's location
        /// </summary>
        /// <param name="articleID"></param>
        /// <param name="latitude"></param>
        /// <param name="longitude"></param>
        /// <returns>Success</returns>
        private bool SetArticleLocation(int articleID, double latitude, double longitude)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("SetGuideEntryLocation"))
            {
                dataReader.AddParameter("@h2g2id", articleID);
                dataReader.AddParameter("@latitude", latitude);
                dataReader.AddParameter("@longitude", longitude);

                dataReader.Execute();

                // Check to make sure that we've got some data to play with
                if (!dataReader.HasRows)
                {
                    AddErrorXml("SetArticleLocation", "Could not set article's location.", null);
                    return false;
                }

                bool builtArticleNode = false;

                // Got through the results building the tree
                while (dataReader.Read())
                {
                    XmlNode articleNode = RootElement.SelectSingleNode("/DNAROOT/ARTICLE"); 
                    if (articleNode == null)
                    {
                        articleNode = AddElementTag(RootElement, "ARTICLE");
                    }

                    if (!builtArticleNode)
                    {
                        AddAttribute(articleNode, "H2G2ID", articleID);
                        AddAttribute(articleNode, "SITEID", dataReader.GetInt32("SiteID"));
                        builtArticleNode = true; 
                    }

                    XmlNode newLocationNode = AddElementTag(articleNode, "ADDEDLOCATION");

                    AddAttribute(newLocationNode, "ID", dataReader.GetInt32NullAsZero("ID").ToString());
                    AddAttribute(newLocationNode, "LAT", dataReader.GetDoubleNullAsZero("Latitude").ToString());
                    AddAttribute(newLocationNode, "LONG", dataReader.GetDoubleNullAsZero("Longitude").ToString());
                }

                return true; 
            }
        }

        /// <summary>
        /// Delete Article's location
        /// </summary>
        /// <param name="articleID"></param>
        /// <param name="locationId"></param>
        /// <returns>Success</returns>
        private bool DeleteArticleLocation(int articleID, int locationId)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("DeleteGuideEntryLocation"))
            {
                dataReader.AddParameter("@h2g2id", articleID);
                dataReader.AddParameter("@locationid", locationId);

                dataReader.Execute();

                // Check to make sure that we've got some data to play with
                if (!dataReader.HasRows)
                {
                    AddErrorXml("DeleteArticleLocation", "Could not delete article's location.", null);
                    return false;
                }

                bool builtArticleNode = true;

                XmlNode articleNode = RootElement.SelectSingleNode("/DNAROOT/ARTICLE");
                if (articleNode == null)
                {
                    articleNode = AddElementTag(RootElement, "ARTICLE");
                    builtArticleNode = false;
                }

                // Got through the results building the tree
                while (dataReader.Read())
                {
                    if (!builtArticleNode)
                    {
                        AddAttribute(articleNode, "H2G2ID", articleID);
                        AddAttribute(articleNode, "SITEID", dataReader.GetInt32("SiteID"));
                    }

                    XmlNode newLocationNode = AddElementTag(articleNode, "DELETEDLOCATION");

                    AddAttribute(newLocationNode, "ID", dataReader.GetInt32NullAsZero("ID").ToString());
                    AddAttribute(newLocationNode, "LAT", dataReader.GetDoubleNullAsZero("Latitude").ToString());
                    AddAttribute(newLocationNode, "LONG", dataReader.GetDoubleNullAsZero("Longitude").ToString());
                }

                return true;
            }
        }
    }
}
