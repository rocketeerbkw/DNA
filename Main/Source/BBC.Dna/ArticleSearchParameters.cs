using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace BBC.Dna
{
    /// <summary>
    /// Class to store all Article Search parameters
    /// </summary>
    public class ArticleSearchParams
    {
        /// <remarks name="siteID">Site id to run the searches against</remarks>
        /// <remarks name="skip">Number of articles to skip</remarks>
        /// <remarks name="show">Number of articles to show</remarks>
        /// <remarks name="skipphrases">Number of hotlist keyphrases to skip</remarks>
        /// <remarks name="showphrases">Number of hotlist keyphrases to show</remarks>
        /// <remarks name="contentType">Type of articles to articles to search for </remarks>
        /// <remarks name="sortBy">sortby option for the search</remarks>
        /// <remarks name="startDate">Start Date</remarks>
        /// <remarks name="endDate">End Date</remarks>
        /// <remarks name="timeInterval">Time Interval parameter</remarks>
        /// <remarks name="dateSearchType">Date search type</remarks>
        /// <remarks name="phrases">Key Phrases to search for</remarks>
        /// <remarks name="searchphraselist">ArrayList of Key Phrases to search for</remarks>
        /// <remarks name="articleStatus">The Status of the Article to search for</remarks>
        /// <remarks name="descendingOrder">Which way to perform the sort</remarks>
        /// <remarks name="postcode">Postcode to search for Articles around</remarks>
        /// <remarks name="placename">Placename to search articles around</remarks>
        /// <remarks name="articleType">The type of articles to search for</remarks>
        /// <remarks name="locationSearchType">The type of location search to perform</remarks>

        int _siteID = 0;
        int _skip = 0;
        int _show = 0;
        int _contentType = 0;
        string _sortBy = String.Empty;
        DateTime _startDate = DateTime.MinValue;
        DateTime _endDate = DateTime.MinValue;
        int _timeInterval = 0;
        int _dateSearchType = 0;
        string _phrases = String.Empty;
        string _namespaces = String.Empty;
        ArrayList _searchphraselist = new ArrayList();
        int _articleStatus = 0;
        bool _descendingOrder = true;
        int _articleType = 0;
        string _postcode = String.Empty;
        string _placename = String.Empty;
        string _locationSearchType = String.Empty;

        double _latitude = 0.0;
        double _longitude = 0.0;
        double _range = 0.0;

        string _freeTextSearchCondition = String.Empty;

        int _skipPhrases = 0;
        int _showPhrases = 0;

        /// <summary>
        /// Accessor for LocationSearchType
        /// </summary>
        public string LocationSearchType
        {
            get { return _locationSearchType; }
            set { _locationSearchType = value; }
        }
        /// <summary>
        /// Accessor for PostCode
        /// </summary>
        public string PostCode
        {
            get { return _postcode; }
            set { _postcode = value; }
        }
        /// <summary>
        /// Accessor for Placename
        /// </summary>
        public string Placename
        {
            get { return _placename; }
            set { _placename = value; }
        }

        /// <summary>
        /// Accessor for freeTextSearchConfition
        /// </summary>
        public string FreeTextSearchCondition
        {
            get { return _freeTextSearchCondition; }
            set { _freeTextSearchCondition = value; }
        }

        /// <summary>
        /// Accessor for Range
        /// </summary>
        public double Range
        {
            get { return _range; }
            set { _range = value; }
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
        /// Accessor for Skip
        /// </summary>
        public int Skip
        {
            get { return _skip; }
            set { _skip = value; }
        }

        /// <summary>
        /// Accessor for Show
        /// </summary>
        public int Show
        {
            get { return _show; }
            set { _show = value; }
        }

        /// <summary>
        /// Accessor for SkipPhrases
        /// </summary>
        public int SkipPhrases
        {
            get { return _skipPhrases; }
            set { _skipPhrases = value; }
        }

        /// <summary>
        /// Accessor for ShowPhrases
        /// </summary>
        public int ShowPhrases
        {
            get { return _showPhrases; }
            set { _showPhrases = value; }
        }

        /// <summary>
        /// Accessor for ContentType
        /// </summary>
        public int ContentType
        {
            get { return _contentType; }
            set { _contentType = value; }
        }

        /// <summary>
        /// Accessor for SortBy
        /// </summary>
        public string SortBy
        {
            get { return _sortBy; }
            set { _sortBy = value; }
        }

        /// <summary>
        /// Accessor for StartDate
        /// </summary>
        public DateTime StartDate
        {
            get { return _startDate; }
            set { _startDate = value; }
        }

        /// <summary>
        /// Accessor for EndDate
        /// </summary>
        public DateTime EndDate
        {
            get { return _endDate; }
            set { _endDate = value; }
        }

        /// <summary>
        /// Accessor for TimeInterval
        /// </summary>
        public int TimeInterval
        {
            get { return _timeInterval; }
            set { _timeInterval = value; }
        }

        /// <summary>
        /// Accessor for DateSearchType
        /// </summary>
        public int DateSearchType
        {
            get { return _dateSearchType; }
            set { _dateSearchType = value; }
        }

        /// <summary>
        /// Accessor for Phrases
        /// </summary>
        public string Phrases
        {
            get { return _phrases; }
            set { _phrases = value; }
        }

        /// <summary>
        /// Accessor for Namespaces
        /// </summary>
        public string NameSpaces
        {
            get { return _namespaces; }
            set { _namespaces = value; }
        }


        /// <summary>
        /// Accessor for SearchPhraseList
        /// </summary>
        public ArrayList SearchPhraseList
        {
            get { return _searchphraselist; }
            set { _searchphraselist = value; }
        }

        /// <summary>
        /// Accessor for ArticleStatus
        /// </summary>
        public int ArticleStatus
        {
            get { return _articleStatus; }
            set { _articleStatus = value; }
        }

        /// <summary>
        /// Accessor for DescendingOrder
        /// </summary>
        public bool DescendingOrder
        {
            get { return _descendingOrder; }
            set { _descendingOrder = value; }
        }

        /// <summary>
        /// Accessor for Article Type
        /// </summary>
        public int ArticleType
        {
            get { return _articleType; }
            set { _articleType = value; }
        }

    }
}
