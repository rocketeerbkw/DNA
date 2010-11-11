using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(TypeName = "LOCATION")]
    [DataContract(Name = "location")]
    public partial class Location
    {
        public Location()
        {
        }

        #region Properties

        /// <summary>
        /// Accessor for LocationID
        /// </summary>
        [XmlAttribute(AttributeName = "LOCATIONID")]
        [DataMember(Name = "locationId", Order = 1)]
        public int LocationId { get; set; }
        /// <summary>
        /// Accessor for Latitude
        /// </summary>
        [XmlElement(ElementName = "LATITUDE")]
        [DataMember(Name = "latitude", Order = 2)]
        public double Latitude { get; set; }

        /// <summary>
        /// Accessor for Longitude
        /// </summary>
        [XmlElement(ElementName = "LONGITUDE")]
        [DataMember(Name = "longitude", Order = 3)]
        public double Longitude { get; set; }

        /// <summary>
        /// Accessor for SiteID
        /// </summary>
        [XmlAttribute(AttributeName = "SITEID")]
        [DataMember(Name = "siteId", Order = 4)]
        public int SiteID { get; set; }

        /// <summary>
        /// Accessor for Created Date
        /// </summary>
        [XmlElement(ElementName = "CREATEDDATE")]
        [DataMember(Name = "createdDate", Order = 5)]
        public DateTime CreatedDate { get; set; }

         /// <summary>
        /// Accessor for Type
        /// </summary>
        [XmlAttribute(AttributeName = "TYPE")]
        [DataMember(Name = "type", Order = 6)]
        public int Type { get; set; }

        /// <summary>
        /// Accessor for Title
        /// </summary>
        [XmlElement(ElementName = "TITLE")]
        [DataMember(Name = "title", Order = 7)]
        public string Title { get; set; }

        /// <summary>
        /// Accessor for Description
        /// </summary>
        [XmlElement(ElementName = "DESCRIPTION")]
        [DataMember(Name = "description", Order = 8)]
        public string Description { get; set; }

        /// <summary>
        /// Accessor for OwnerID
        /// </summary>
        [XmlAttribute(AttributeName = "OWNERID")]
        [DataMember(Name = "ownerId", Order = 9)]
        public int OwnerID { get; set; }

        /// <summary>
        /// Accessor for ZoomLevel
        /// </summary>
        [XmlElement(ElementName = "ZOOMLEVEL")]
        [DataMember(Name = "zoomLevel", Order = 10)]
        public int ZoomLevel { get; set; }

        /// <summary>
        /// Accessor for GeoId
        /// </summary>
        [XmlElement(ElementName = "GEOID")]
        [DataMember(Name = "geoId", Order = 11)]
        public int GeoId { get; set; }


    #endregion


        public static Location CreateLocationFromReader(IDnaDataReader reader)
        {
            Location location = new Location();
            location.Description = reader.GetStringNullAsEmpty("description");
            location.Title = reader.GetStringNullAsEmpty("title");

            location.LocationId = reader.GetInt32NullAsZero("locationid");
            location.OwnerID = reader.GetInt32NullAsZero("ownerid");
            location.SiteID = reader.GetInt32NullAsZero("siteid");
            //location.GeoId = reader.GetInt32NullAsZero("GeoId");

            location.CreatedDate = reader.GetDateTime("CreatedDate");

            return location;
        }

    }
}
