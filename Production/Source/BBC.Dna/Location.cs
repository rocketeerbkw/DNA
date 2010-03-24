using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// Class to store all Location Data
    /// </summary>
    public class Location
    {
        int _locationID = 0;
        int _siteID = 0;
        double _latitude = 0.0;
        double _longitude = 0.0;
        DateTime _createdDate = DateTime.MinValue;
        string _description = String.Empty;
        string _title = String.Empty;
        int _ownerID = 0;
        int _zoomLevel = 0;
        int _type = 0;

        /// <summary>
        /// Accessor for LocationID
        /// </summary>
        public int LocationID
        {
            get { return _locationID; }
            set { _locationID = value; }
        }
        /// <summary>
        /// Accessor for Latitude
        /// </summary>
        public double Latitude
        {
            get { return _latitude; }
            set { _latitude = value; }
        }

        /// <summary>
        /// Accessor for Longitude
        /// </summary>
        public double Longitude
        {
            get { return _longitude; }
            set { _longitude = value; }
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
        /// Accessor for Created Date
        /// </summary>
        public DateTime CreatedDate
        {
            get { return _createdDate; }
            set { _createdDate = value; }
        }

         /// <summary>
        /// Accessor for Type
        /// </summary>
        public int Type
        {
            get { return _type; }
            set { _type = value; }
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
        /// Accessor for ZoomLevel
        /// </summary>
        public int ZoomLevel
        {
            get { return _zoomLevel; }
            set { _zoomLevel = value; }
        }
    }
}
