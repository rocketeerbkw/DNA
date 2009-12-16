using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// Class to store all Route Data
    /// </summary>
    public class Route : DnaInputComponent
    {
        /// <summary>
        /// Constructor for the Route class
        /// </summary>
        /// <param name="context"></param>
        public Route(IInputContext context)
            : base(context)
        {
        }

        int _routeID = 0;
        int _siteID = 0;
        DateTime _createdDate = DateTime.MinValue;
        string _description = String.Empty;
        string _title = String.Empty;
        int _ownerID = 0;
        int _describingArticleID = 0;

        string _gpsData = String.Empty;


        int _locationCount = 0;
        
        private ArrayList _locationData = new ArrayList();

        /// <summary>
        /// Accessor for LocationID
        /// </summary>
        public int RouteID
        {
            get { return _routeID; }
            set { _routeID = value; }
        }

        /// <summary>
        /// Accessor for SiteID
        /// </summary>
        public int SiteID
        {
            get { return _siteID; }
            set { _siteID = value; }
        }

        /// <summary>
        /// Accessor for Location Count
        /// </summary>
        public int LocationCount
        {
            get { return _locationCount; }
            set { _locationCount = value; }
        }

        /// <summary>
        /// Accessor for Locations
        /// </summary>
        public ArrayList Locations
        {
            get { return _locationData; }
            set { _locationData = value; }
        }

        /// <summary>
        /// Accessor for Created Date
        /// </summary>
        public DateTime CreatedDate
        {
            get { return _createdDate; }
            set { _createdDate = value; }
        }

        /// <summary>
        /// Accessor for Title
        /// </summary>
        public string Title
        {
            get { return _title; }
            set { _title = value; }
        }

        /// <summary>
        /// Accessor for Description
        /// </summary>
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }

        /// <summary>
        /// Accessor for OwnerID
        /// </summary>
        public int OwnerID
        {
            get { return _ownerID; }
            set { _ownerID = value; }
        }

        /// <summary>
        /// Accessor for DescribingArticleID
        /// </summary>
        public int DescribingArticleID
        {
            get { return _describingArticleID; }
            set { _describingArticleID = value; }
        }

        /// <summary>
        /// Accessor for GPSData
        /// </summary>
        public string GPSData
        {
            get { return _gpsData; }
            set { _gpsData = value; }
        }

        /// <summary>
        /// CreateRouteXML from a dataReader.
        /// Allows standard Route XML to be generated from different resultsets.
        /// </summary>
        /// <param name="dataReader"></param>
        /// <param name="includeLocations">Whether the locations need to be included or just route info</param>
        public void CreateRouteXML(IDnaDataReader dataReader, bool includeLocations)
        {
            int count = 0;
            XmlElement routeXML = (XmlElement) AddElementTag(RootElement, "ROUTE");

            if (dataReader.HasRows && dataReader.DoesFieldExist("RouteID"))
            {
                AddAttribute(routeXML, "ROUTEID", dataReader.GetInt32NullAsZero("RouteID").ToString());

                AddTextTag(routeXML, "ROUTETITLE", dataReader.GetStringNullAsEmpty("RouteTitle"));
                AddTextTag(routeXML, "ROUTEDESCRIPTION", dataReader.GetStringNullAsEmpty("RouteDescription"));
                AddTextTag(routeXML, "DESCRIBINGARTICLEID", dataReader.GetInt32NullAsZero("H2G2ID").ToString());
                AddTextTag(routeXML, "SUBJECT", dataReader.GetStringNullAsEmpty("Subject"));
                //AddTextTag(routeXML, "GPSTRACKDATALOCATION", dataReader.GetStringNullAsEmpty("GPSTRACKDATALOCATION"));

                if (includeLocations)
                {
                    XmlElement locations = AddElementTag(routeXML, "LOCATIONS");
                    if (dataReader.NextResult() && dataReader.Read())
                    {
                        do
                        {
                            count++;
                            XmlElement location = AddElementTag(locations, "LOCATION");
                            location.SetAttribute("LOCATIONID", dataReader.GetInt32NullAsZero("LocationID").ToString());
                            location.SetAttribute("ORDER", dataReader.GetInt32NullAsZero("Order").ToString());

                            AddTextTag(location, "LATITUDE", dataReader.GetDoubleNullAsZero("Latitude").ToString());
                            AddTextTag(location, "LONGITUDE", dataReader.GetDoubleNullAsZero("Longitude").ToString());
                            AddTextTag(location, "LOCATIONTITLE", dataReader.GetStringNullAsEmpty("LocationTitle"));
                            AddTextTag(location, "LOCATIONDESCRIPTION", dataReader.GetStringNullAsEmpty("LocationDescription"));
                            AddTextTag(location, "LOCATIONZOOMLEVEL", dataReader.GetInt32NullAsZero("LocationZoomLevel").ToString());
                            AddTextTag(location, "LOCATIONUSERID", dataReader.GetInt32NullAsZero("LocationUserID").ToString());
                            AddDateXml(dataReader.GetDateTime("LocationDateCreated"), location, "LOCATIONDATECREATED");
                        } while (dataReader.Read());
                    }
                    AddAttribute(locations, "COUNT", count.ToString());
                }
            }
        }    
    }
}
