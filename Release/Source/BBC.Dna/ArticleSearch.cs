using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Article Search - A derived DnaComponent object
    /// </summary>
    public class ArticleSearch : DnaInputComponent
    {
        private const string _googleUri = "http://maps.google.com/maps/geo?q=";
        private const string _googleKey = "ABQIAAAA4Xd5QHv5SqCWpzuVXvfBPhR5mJxxp2o6KSE3CNjdEdZtxz6WkhRDv-zP9BYRb3uaLcg07DRkOBWJ4Q";
        private const string _outputType = "csv"; // Available options: csv, xml, kml, json

        private const string _docDnaShow = @"The number of articles to show.";
        private const string _docDnaSkip = @"The number of articles to skip.";

        private const string _docDnaSiteID = @"Site ID filter param for the search.";
        private const string _docDnaArticleSortBy = @"Article sort by param for the search.";
        private const string _docDnaContentType = @"Content type filter param for the search.";

        private const string _docDnaDateSearchType = @"Date Search type param for the search.";
        private const string _docDnaTimeInterval = @"Date Time interval to search for.";

        private const string _docDnaStartDay = @"Start Day filter for the Article Search Page.";
        private const string _docDnaStartMonth = @"Start Month filter for the Article Search Page.";
        private const string _docDnaStartYear = @"Start Year filter for the Article Search Page.";

        private const string _docDnaEndDay = @"End Day filter for the Article Search Page.";
        private const string _docDnaEndMonth = @"End Month filter for the Article Search Page.";
        private const string _docDnaEndYear = @"End Year filter for the Article Search Page.";

        private const string _docDnaPhrase = @"Keywords filter for the Article Search Page.";
        private const string _docDnaNameSpace = @"NameSpace filter for the Article Search Page. Combination of pairs of namespaces and keyphrase";

        private const string _docDnaStartDate = @"Start Date filter for the Article Search Page.";
        private const string _docDnaEndDate = @"End Date filter for the Article Search Page.";

        private const string _docDnaArticleStatus = @"The Article Status of the article i.e Editorial Articles vs User Articles";
        private const string _docDnaArticleType = @"The Article Type of the article i.e 3001 User Pages";

        private const string _docDnaDescendingOrder = @"Whether the result set is returned sorted in ascending or descending order";

        private const string _docDnaLongitude = @"Latitude filter for a Location based Article Search Page.";
        private const string _docDnaLatitude = @"Longitude filter for a Location based Article Search Page.";
        private const string _docDnaRange = @"Range filter for a Location based Article Search Page.";

        private const string _docDnaFreeTextSearchCondition = @"The condition to do a free text search for the Article Search Page.";

        private const string _docDnaShowPhrases = @"The number of hotlist keyphrases to show.";
        private const string _docDnaSkipPhrases = @"The number of hotlist keyphrases to skip.";

        private const string _docDnaPostcode = @"Postcode filter for a Location based Article Search Page, we'll generate the lat long from this.";
        private const string _docDnaPlacename = @"Placename filter for a Location based Article Search Page, we'll generate the lat long from this.";
        private const string _docDnaLocationSearchType = @"Which type of location filter to use for a Location based Article Search Page.";
        
        private string _token = @" ";

        string _cacheName = String.Empty;

        string _totest = String.Empty;

        /// <summary>
        /// Default constructor for the ArticleSearch component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public ArticleSearch(IInputContext context)
            : base(context)
        {
            string delimiter = NamespacePhrases.GetSiteDelimiterToken(context);
            if (delimiter.Length > 0)
            {
                _token = delimiter.Substring(0, 1);
            }
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();
            TryArticleSearch();
        }

        /// <summary>
        /// Externally available Method called to try the Article Search, given the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <param name="asp">Class containing all the search parameters.</param>
        public void DoArticleSearchWithParams(ArticleSearchParams asp)
        {
            bool cached = GetArticleSearchCachedXml(asp);
            cached = false;

            if (!cached)
            {
                GenerateArticleSearchPageXml(asp);
            }

            bool generateHotlist = InputContext.GetSiteOptionValueBool("ArticleSearch", "GenerateHotlist");
            if (generateHotlist)
            {
                bool cachedHotlist = GetArticleSearchHotlistCachedXml();
                if (!cachedHotlist)
                {
                    GenerateKeyPhraseHotlist(asp.SiteID, asp.SkipPhrases, asp.ShowPhrases, asp.ContentType, asp.SortBy, asp.DateSearchType, asp.Phrases);
                }
            }
        }

        /// <summary>
        /// Method called to try the Article Search, gathers the input params, 
        /// gets the correct records from the DB and formulates the XML
        /// </summary>
        /// <returns>Whether the search has suceeded with out error</returns>
        private bool TryArticleSearch()
        {
            ArticleSearchParams asp = new ArticleSearchParams();

            bool pageParamsOK = TryGetPageParams(ref asp);

            if (!pageParamsOK)
            {
                return false;
            }

            bool cached = GetArticleSearchCachedXml(asp);

            if (!cached)
            {
                GenerateArticleSearchPageXml(asp);
            }

            bool generateHotlist = InputContext.GetSiteOptionValueBool("ArticleSearch", "GenerateHotlist");
            if (generateHotlist)
            {
                bool cachedHotlist = GetArticleSearchHotlistCachedXml();
                if (!cachedHotlist)
                {
                    GenerateKeyPhraseHotlist(asp.SiteID, asp.SkipPhrases, asp.ShowPhrases, asp.ContentType, asp.SortBy, asp.DateSearchType, asp.Phrases);
                }
            }

            return true;
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="asp">Class containing all the search parameters.</param>
        private bool TryGetPageParams(ref ArticleSearchParams asp)
        {
            int startDay = 0;
            int startMonth = 0;
            int startYear = 0;
            int endDay = 0;
            int endMonth = 0;
            int endYear = 0;

            string startDateText = String.Empty;
            string endDateText = String.Empty;

            //siteID = InputContext.GetParamIntOrZero("siteid", _docDnaSiteID);
            asp.SiteID = InputContext.CurrentSite.SiteID;

            int defaultShow = InputContext.GetSiteOptionValueInt("ArticleSearch", "DefaultShow");

            asp.Skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            asp.Show = InputContext.GetParamIntOrZero("show", _docDnaShow);
            if (asp.Show > 200)
            {
                asp.Show = 200;
            }
            else if (asp.Show < 1)
            {
                asp.Show = defaultShow;
            }

            asp.SkipPhrases = InputContext.GetParamIntOrZero("skipphrases", _docDnaSkipPhrases);
            asp.ShowPhrases = InputContext.GetParamIntOrZero("showphrases", _docDnaShowPhrases);
            if (asp.ShowPhrases > 200)
            {
                asp.ShowPhrases = 200;
            }
            else if (asp.ShowPhrases < 1)
            {
                asp.ShowPhrases = defaultShow;
            }
            if (asp.SkipPhrases < 1)
            {
                asp.SkipPhrases = 0;
            }

            asp.ContentType = InputContext.GetParamIntOrZero("contenttype", _docDnaContentType);
            asp.SortBy = InputContext.GetParamStringOrEmpty("articlesortby", _docDnaArticleSortBy);
            asp.DateSearchType = InputContext.GetParamIntOrZero("datesearchtype", _docDnaDateSearchType);

            asp.TimeInterval = InputContext.GetParamIntOrZero("timeinterval", _docDnaTimeInterval);

            startDay = InputContext.GetParamIntOrZero("startDay", _docDnaStartDay);
            startMonth = InputContext.GetParamIntOrZero("startMonth", _docDnaStartMonth);
            startYear = InputContext.GetParamIntOrZero("startYear", _docDnaStartYear);

            endDay = InputContext.GetParamIntOrZero("endDay", _docDnaEndDay);
            endMonth = InputContext.GetParamIntOrZero("endMonth", _docDnaEndMonth);
            endYear = InputContext.GetParamIntOrZero("endYear", _docDnaEndYear);

            startDateText = InputContext.GetParamStringOrEmpty("startDate", _docDnaStartDate);
            endDateText = InputContext.GetParamStringOrEmpty("endDate", _docDnaEndDate);

            asp.ArticleStatus = InputContext.GetParamIntOrZero("articlestatus", _docDnaArticleStatus);
            asp.ArticleType = InputContext.GetParamIntOrZero("articletype", _docDnaArticleType);

            int descendingOrderNum = InputContext.GetParamIntOrZero("descendingorder", _docDnaDescendingOrder);
            if (descendingOrderNum == 1)
            {
                asp.DescendingOrder = true;
            }
            else
            {
                asp.DescendingOrder = false;
            }

            DateTime startDate;
            DateTime endDate;

            if (asp.DateSearchType != 0)
            {
                DateRangeValidation dateValidation = new DateRangeValidation();
                DateRangeValidation.ValidationResult isValid;
                if (startDay == 0 && endDay == 0)
                {
                    isValid = ParseDateParams(startDateText, endDateText, out startDate, out endDate);
                }
                else
                {
                    isValid = ParseDateParams(startYear, startMonth, startDay, endYear, endMonth, endDay, out startDate, out endDate);
                }

                isValid = dateValidation.ValidateDateRange(startDate, endDate, asp.TimeInterval, false, false);

                if (isValid == DateRangeValidation.ValidationResult.VALID)
                {
                    asp.StartDate = dateValidation.LastStartDate;
                    asp.EndDate = dateValidation.LastEndDate;
                }
                else
                {
                    return AddErrorXml("invalidparameters", "Illegal date parameters (" + isValid.ToString() + ")", null);
                }
            }

            //Get Search phrases.
            if (InputContext.DoesParamExist("phrase", _docDnaPhrase))
            {
                asp.SearchPhraseList.Clear();

                string rawPhrases = String.Empty;
                for (int i = 0; i < InputContext.GetParamCountOrZero("phrase", _docDnaPhrase); i++)
                {
                    string phrase = InputContext.GetParamStringOrEmpty("phrase", i, _docDnaPhrase);
                    if (phrase.Contains(_token))
                    {
                        DnaStringParser paramParser = new DnaStringParser(phrase, _token.ToCharArray(), false, false, false);
                        ArrayList paramPhraseList = paramParser.ParseToArrayList();
                        foreach (string paramPhrase in paramPhraseList)
                        {
                            rawPhrases = rawPhrases + paramPhrase + "|";
                        }
                    }
                    else
                    {
                        rawPhrases = rawPhrases + phrase + "|";
                    }
                }

                string rawNameSpaces = String.Empty;
                for (int i = 0; i < InputContext.GetParamCountOrZero("namespace", _docDnaNameSpace); i++)
                {
                    string nameSpace = InputContext.GetParamStringOrEmpty("namespace", i, _docDnaNameSpace);
                    if (nameSpace.Contains(_token))
                    {
                        DnaStringParser paramParser = new DnaStringParser(nameSpace, _token.ToCharArray(), false, false, false);
                        ArrayList paramNameList = paramParser.ParseToArrayList();
                        foreach (string paramNameSpace in paramNameList)
                        {
                            rawNameSpaces = rawNameSpaces + paramNameSpace + "|";
                        }
                    }
                    else
                    {
                        rawNameSpaces = rawNameSpaces + nameSpace + "|";
                    }
                }

                char[] charsToTrim = new char[] { '|' };

                string parsedPhrases = String.Empty;
                //Now feed it into the DnaString Parser
                DnaStringParser phrasesParser = new DnaStringParser(rawPhrases, charsToTrim, true, true, false);
                parsedPhrases = phrasesParser.GetParsedString('|');
                ArrayList searchPhraseList = phrasesParser.ParseToArrayList();

                string parsedNameSpaces = String.Empty;
                //Now feed it into the DnaString Parser
                DnaStringParser nameSpaceParser = new DnaStringParser(rawNameSpaces, charsToTrim, true, true, false);
                parsedNameSpaces = nameSpaceParser.GetParsedString('|');
                ArrayList searchNameSpaceList = nameSpaceParser.ParseToArrayList();

                int phraseNumber = 0;
                foreach (string phraseText in searchPhraseList)
                {
                    Phrase phrase = new Phrase();
                    phrase.PhraseName = phraseText;
                    try
                    {
                        phrase.NameSpace = searchNameSpaceList[phraseNumber].ToString();
                    }
                    catch (ArgumentOutOfRangeException)
                    {
                        phrase.NameSpace = "";
                    }

                    asp.SearchPhraseList.Add(phrase);
                    phraseNumber++;
                }

                asp.Phrases = parsedPhrases.TrimEnd(charsToTrim);
                asp.NameSpaces = parsedNameSpaces.TrimEnd(charsToTrim);
            }

            //Get (Postcode or Placename or Latitude and Longitude) and Range for Search if they are there.
            if (InputContext.DoesParamExist("postcode", _docDnaPostcode) ||
                InputContext.DoesParamExist("placename", _docDnaPlacename) ||
                (InputContext.DoesParamExist("latitude", _docDnaLatitude) &&
                InputContext.DoesParamExist("longitude", _docDnaLongitude)) &&
                InputContext.DoesParamExist("range", _docDnaRange))
            {
                asp.Range = InputContext.GetParamDoubleOrZero("range", _docDnaRange);

                asp.LocationSearchType = InputContext.GetParamStringOrEmpty("locationsearchtype", _docDnaLocationSearchType);
                asp.PostCode = InputContext.GetParamStringOrEmpty("postcode", _docDnaPostcode);
                asp.Placename = InputContext.GetParamStringOrEmpty("placename", _docDnaPlacename);

                double latitude = InputContext.GetParamDoubleOrZero("latitude", _docDnaLatitude); 
                double longitude = InputContext.GetParamDoubleOrZero("longitude", _docDnaLongitude);
                if (asp.LocationSearchType == "postcode")
                {
                    GetLatLongFromPostCode(asp.PostCode, ref latitude, ref longitude);
                }
                else if (asp.LocationSearchType == "placename")
                {
                    GetLatLongFromPlacename(asp.Placename, ref latitude, ref longitude);
                }
                asp.Latitude = latitude;
                asp.Longitude = longitude;
            }

            //Get free text search condition for Search if it is there.
            if (InputContext.DoesParamExist("freetextsearch", _docDnaFreeTextSearchCondition))
            {
                asp.FreeTextSearchCondition = InputContext.GetParamStringOrEmpty("freetextsearch", _docDnaFreeTextSearchCondition);
            }

            return true;
        }

        private void GetLatLongFromPlacename(string placename, ref double latitude, ref double longitude)
        {
            Coordinate latlong = GetCoordinates(placename);
            latitude = latlong.Latitude;
            longitude = latlong.Longitude;
        }

        private void GetLatLongFromPostCode(string postcode, ref double latitude, ref double longitude)
        {
            Coordinate latlong = GetPostCodeCoordinates(postcode);
            latitude = latlong.Latitude;
            longitude = latlong.Longitude;
        }

        /// <summary>
        /// Calls the correct stored procedure given the inputs selected
        /// </summary>
        /// <param name="asp">Class containing all the search parameters.</param>
        private void GenerateArticleSearchPageXml(ArticleSearchParams asp)
        {
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getarticles_dynamic"))
            {
                dataReader.AddParameter("siteid", asp.SiteID)
                .AddParameter("firstindex", asp.Skip + 1) //Added as row number starts at 1
                .AddParameter("lastindex", asp.Skip + asp.Show);

                //Default sortbydatecreated.
                if (asp.SortBy == "Caption")
                {
                    dataReader.AddParameter("sortbycaption", 1);
                }
                else if (asp.SortBy == "Rating")
                {
                    dataReader.AddParameter("sortbyrating", 1);
                }
                else if (asp.SortBy == "StartDate")
                {
                    dataReader.AddParameter("sortbystartdate", 1);
                }
                else if (asp.SortBy == "EndDate")
                {
                    dataReader.AddParameter("sortbyenddate", 1);
                }
                else if (asp.SortBy == "ArticleZeitgeist")
                {
                    dataReader.AddParameter("sortbyarticlezeitgeist", 1);
                }
                else if (asp.SortBy == "PostCount")
                {
                    dataReader.AddParameter("sortbypostcount", 1);
                }
                else if (asp.SortBy == "Range")
                {
                    dataReader.AddParameter("sortbyrange", 1);
                }
                else if (asp.SortBy == "BookmarkCount")
                {
                    dataReader.AddParameter("sortbybookmarkcount", 1);
                }
                else if (asp.SortBy == "LastPosted")
                {
                    dataReader.AddParameter("sortbylastposted", 1);
                }
                else if (asp.SortBy == "LastUpdated")
                {
                    dataReader.AddParameter("sortbylastupdated", 1);
                }

                if (asp.Phrases != String.Empty)
                {
                    dataReader.AddParameter("keyphraselist", asp.Phrases);
                }
                if (asp.NameSpaces != String.Empty)
                {
                    dataReader.AddParameter("namespacelist", asp.NameSpaces);
                }
                if (asp.DateSearchType != 0 && asp.StartDate != DateTime.MinValue && asp.ContentType == -1)
                {
                    dataReader.AddParameter("startdate", asp.StartDate);
                    dataReader.AddParameter("enddate", asp.EndDate);
                    //if (timeInterval > 0)
                    //{
                    //    dataReader.AddParameter("timeinterval", timeInterval);
                    //}
                    if (asp.DateSearchType == 2)
                    {
                        dataReader.AddParameter("touchingdaterange", 1);
                    }
                }
                if (asp.ContentType != -1)
                {
                    dataReader.AddParameter("assettype", asp.ContentType);
                }

                if (asp.ArticleStatus != 0)
                {
                    dataReader.AddParameter("articlestatus", asp.ArticleStatus);
                }
                if (asp.ArticleType != 0)
                {
                    dataReader.AddParameter("articletype", asp.ArticleType);
                }

                if (asp.DescendingOrder)
                {
                    dataReader.AddParameter("descendingorder", 1);
                }
                else
                {
                    dataReader.AddParameter("descendingorder", 0);
                }

                if (asp.Latitude != 0.0)
                {
                    dataReader.AddParameter("latitude", asp.Latitude);
                    dataReader.AddParameter("longitude", asp.Longitude);
                    dataReader.AddParameter("range", asp.Range);
                }

                if (asp.FreeTextSearchCondition != String.Empty)
                {
                    dataReader.AddParameter("freetextsearchcondition", asp.FreeTextSearchCondition);
                }

                dataReader.Execute();
                GenerateArticleSearchXml(dataReader, asp);
            }
        }

        /// <summary>
        /// With the returned data set generate the XML for the Article Search page
        /// </summary>
        /// <param name="dataReader">The returned search resultset</param>
        /// <param name="asp">The Article Search Params</param>
        private void GenerateArticleSearchXml(IDnaDataReader dataReader, ArticleSearchParams asp)
        {
            RootElement.RemoveAll();
            XmlNode articleSearch = AddElementTag(RootElement, "ARTICLESEARCH");

            AddAttribute(articleSearch, "CONTENTTYPE", asp.ContentType);
            AddAttribute(articleSearch, "SORTBY", asp.SortBy);
            AddAttribute(articleSearch, "SKIPTO", asp.Skip);
            AddAttribute(articleSearch, "SHOW", asp.Show);
            AddAttribute(articleSearch, "DATESEARCHTYPE", asp.DateSearchType);
            AddAttribute(articleSearch, "TIMEINTERVAL", asp.TimeInterval);
            AddAttribute(articleSearch, "ARTICLESTATUS", asp.ArticleStatus);
            AddAttribute(articleSearch, "ARTICLETYPE", asp.ArticleType);
            AddAttribute(articleSearch, "LATITUDE", asp.Latitude);
            AddAttribute(articleSearch, "LONGITUDE", asp.Longitude);
            AddAttribute(articleSearch, "RANGE", asp.Range);
            AddAttribute(articleSearch, "POSTCODE", asp.PostCode);
            AddAttribute(articleSearch, "PLACENAME", asp.Placename);
            AddAttribute(articleSearch, "LOCATIONSEARCHTYPE", asp.LocationSearchType);

            //Add the new descending order attribute
            if (asp.DescendingOrder)
            {
                AddAttribute(articleSearch, "DESCENDINGORDER", 1);
            }
            else
            {
                AddAttribute(articleSearch, "DESCENDINGORDER", 0);
            }

            //Add the requested searchphraselist
            GeneratePhraseXml(asp.SearchPhraseList, (XmlElement)articleSearch);

            //Add Date Search Params if we are doing a date search
            if (asp.DateSearchType != 0)
            {
                AddDateXml(asp.StartDate, articleSearch, "DATERANGESTART");
                // Take a day from the end date as used in the database for UI purposes. 
                // E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
                // This gets used in the database but for display purposes we subtract a day from the database end date to return the 
                // original dates submitted by the user inorder to match their expectations.
                AddDateXml(asp.EndDate.AddDays(-1), articleSearch, "DATERANGEEND");
            }

            AddTextTag(articleSearch, "FREETEXTSEARCH", asp.FreeTextSearchCondition);

            XmlNode articles = AddElementTag(articleSearch, "ARTICLES");
            int total = 0;
            int count = 0;

            //Generate Hot-List from Search Results.
            PopularPhrases popularPhrases = null;
            if (InputContext.GetSiteOptionValueBool("articlesearch", "generatepopularphrases"))
            {
                popularPhrases = new PopularPhrases();
            }

            if (dataReader.HasRows)
            {
                // process first results set: the Article Key phrase results set
                Dictionary<int, ArrayList> articleKeyPhrases = new Dictionary<int, ArrayList>();
                ArrayList phraselist = new ArrayList();
                int h2g2ID = 0;

                if (dataReader.Read())
                {
                    int previousH2G2ID = 0;

                    do
                    {
                        h2g2ID = dataReader.GetInt32NullAsZero("H2G2ID");

                        if (h2g2ID != previousH2G2ID)
                        {
                            //New now have a new article so clean up the last one
                            if (previousH2G2ID != 0)
                            {
                                articleKeyPhrases.Add(previousH2G2ID, phraselist);
                                phraselist = new ArrayList();
                            }
                        }

                        //set the previous h2g2id to this one
                        previousH2G2ID = h2g2ID;

                        //Create fill an new Phrase object
                        Phrase nameSpacedPhrase = new Phrase();

                        String nameSpace = String.Empty;
                        String phraseName = dataReader.GetStringNullAsEmpty("phrase");

                        if (phraseName != String.Empty)
                        {
                            if (dataReader.Exists("namespace"))
                            {
                                nameSpace = dataReader.GetStringNullAsEmpty("namespace");
                            }
                            nameSpacedPhrase.NameSpace = nameSpace;
                            nameSpacedPhrase.PhraseName = phraseName;

                            //add it to the list
                            phraselist.Add(nameSpacedPhrase);

                            //Record Popular Phrases.
                            if (popularPhrases != null)
                            {
                                popularPhrases.AddPhrase(phraseName, nameSpace);
                            }
                        }

                    } while (dataReader.Read());
                }

                articleKeyPhrases.Add(h2g2ID, phraselist);

                dataReader.NextResult();

                if (dataReader.Read())
                {
                    total = dataReader.GetInt32NullAsZero("TOTAL");

                    //The stored procedure returns one row for each article. The article's keyphrases have been stored in articleKeyPhrases.
                    XmlNode article = CreateElementNode("ARTICLE");
                    do
                    {
                        count++;
                        h2g2ID = dataReader.GetInt32NullAsZero("H2G2ID");

                        //Start filling new article xml
                        AddAttribute(article, "H2G2ID", h2g2ID);

                        int editorID = dataReader.GetInt32NullAsZero("editor");
                        XmlNode editor = CreateElementNode("EDITOR");
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, editorID, editor);
                        article.AppendChild(editor);

                        AddTextTag(article, "STATUS", dataReader.GetInt32NullAsZero("status"));
                        AddXmlTextTag(article, "SUBJECT", dataReader.GetStringNullAsEmpty("SUBJECT"));
                        AddTextTag(article, "TYPE", dataReader.GetInt32NullAsZero("type"));

                        AddDateXml(dataReader, article, "DateCreated", "DATECREATED");
                        AddDateXml(dataReader, article, "LastUpdated", "LASTUPDATED");

                        //Add Extra Info XML where it exists.
                        string extraInfo = dataReader.GetAmpersandEscapedStringNullAsEmpty("EXTRAINFO");
                        if (extraInfo != string.Empty)
                        {

                            XmlDocument extraInfoXml = new XmlDocument();
                            extraInfoXml.LoadXml(extraInfo);
                            article.AppendChild(ImportNode(extraInfoXml.FirstChild));

                        }

                        AddTextTag(article, "NUMBEROFPOSTS", dataReader.GetInt32NullAsZero("ForumPostCount"));
                        AddDateXml(dataReader, article, "LASTPOSTED", "FORUMLASTPOSTED");
                        if (!dataReader.IsDBNull("StartDate"))
                        {
                            AddDateXml(dataReader, article, "StartDate", "DATERANGESTART");
                            // Take a day from the end date as stored in the database for UI purposes. 
                            // E.g. User submits a date range of 01/09/1980 to 02/09/1980. They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00. 
                            // This gets stored in the database but for display purposes we subtract a day from the database end date to return the 
                            // original dates submitted by the user inorder to match their expectations.
                            AddDateXml(dataReader.GetDateTime("EndDate").AddDays(-1), article, "DATERANGEEND");

                            AddTextTag(article, "TIMEINTERVAL", dataReader.GetInt32NullAsZero("TimeInterval"));
                        }


                        if (dataReader.DoesFieldExist("BookmarkCount"))
                        {
                            AddTextTag(article, "BOOKMARKCOUNT", dataReader.GetInt32NullAsZero("BookmarkCount"));
                        }

                        if (dataReader.DoesFieldExist("ZeitgeistScore"))
                        {
                            AddElement(article, "ZEITGEIST", "<SCORE>" + dataReader.GetDoubleNullAsZero("ZeitgeistScore") + "</SCORE>");
                        }

                        

                        #region LocationXML
                        //***********************************************************************
                        // Location Info
                        //***********************************************************************
                        if (dataReader.DoesFieldExist("Latitude") && !dataReader.IsDBNull("Latitude"))
                        {
                            AddTextTag(article, "LATITUDE", dataReader.GetDoubleNullAsZero("Latitude").ToString());
                            AddTextTag(article, "LONGITUDE", dataReader.GetDoubleNullAsZero("Longitude").ToString());
                            if (dataReader.DoesFieldExist("Distance"))
                            {
                                if (dataReader.GetDoubleNullAsZero("Distance") < 0.0001)
                                {
                                    AddTextTag(article, "DISTANCE", "0");
                                }
                                else
                                {
                                    AddTextTag(article, "DISTANCE", dataReader.GetDoubleNullAsZero("Distance").ToString());
                                }
                            }
                            AddTextTag(article, "LOCATIONTITLE", dataReader.GetString("LocationTitle"));
                            AddTextTag(article, "LOCATIONDESCRIPTION", dataReader.GetString("LocationDescription"));
                            AddTextTag(article, "LOCATIONZOOMLEVEL", dataReader.GetInt32NullAsZero("LocationZoomLevel").ToString());
                            AddTextTag(article, "LOCATIONUSERID", dataReader.GetInt32NullAsZero("LocationUserID").ToString());
                            AddDateXml(dataReader.GetDateTime("LocationDateCreated"), article, "LOCATIONDATECREATED");
                        }
                        //***********************************************************************
                        #endregion
                        //***********************************************************************
                        // Media Asset Info
                        //***********************************************************************
                        int mediaAssetID = dataReader.GetInt32NullAsZero("MediaAssetID");

                        if (mediaAssetID != 0)
                        {
                            AddMediaAssetXml(dataReader, article, mediaAssetID);
                        }
                        //***********************************************************************

                        AddPollXml(dataReader, article);

                        if (articleKeyPhrases.ContainsKey(h2g2ID))
                        {
                            GeneratePhraseXml(articleKeyPhrases[h2g2ID], (XmlElement)article);
                        }

                        XmlNode previousarticle = article.CloneNode(true);
                        articles.AppendChild(previousarticle);
                        article.RemoveAll();

                    } while (dataReader.Read());
                }
            }
            articleSearch.AppendChild(articles);
            AddAttribute(articleSearch, "COUNT", count);
            AddAttribute(articleSearch, "TOTAL", total);

            if (popularPhrases != null)
            {
                //Include popularPhrase statistics.
                XmlElement popularPhrasesXml = popularPhrases.GenerateXml();
                articleSearch.AppendChild(ImportNode(popularPhrasesXml));
            }

            FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "articlesearch", _cacheName, articleSearch.OuterXml);

            //articleSearch.OwnerDocument.Save(@"c:\TEMP\Articlesearch.xml");
        }

        /// <summary>
        /// AddPollXml - Delegates esponsibility of producing standard Poll Xml to the Poll Class.
        /// Only produces Poll Xml where a valid Poll exists in the resultset.
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="article">Parent node to add the xml to</param>
        private void AddPollXml(IDnaDataReader dataReader, XmlNode article)
        {
            int pollId = dataReader.GetInt32NullAsZero("CRPollID");
            if (pollId > 0)
            {
                PollContentRating poll = new PollContentRating(this.InputContext, this.InputContext.ViewingUser);

                poll.PollID = dataReader.GetInt32NullAsZero("CRPollID");
                poll.Hidden = dataReader.GetInt32NullAsZero("Hidden") != 0;
                int voteCount = dataReader.GetInt32NullAsZero("CRVoteCount");
                double avgRating = dataReader.GetDoubleNullAsZero("CRAverageRating");
                poll.SetContentRatingStatistics(voteCount, avgRating);
                XmlNode node = poll.MakePollXML(false);
                if (node != null)
                {
                    article.AppendChild(ImportNode(node));
                }
            }
        }

        /// <summary>
        /// Adds the MediaAsset XML data to the XML document
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="parent">parent to add the xml to</param>
        /// <param name="mediaAssetID">Media asset id in question</param>
        private void AddMediaAssetXml(IDnaDataReader dataReader, XmlNode parent, int mediaAssetID)
        {
            MediaAsset asset = new MediaAsset(InputContext);

            XmlNode node = asset.MakeXml(dataReader);
            if (node != null)
            {
                parent.AppendChild(ImportNode(node));
            }
        }

        /// <summary>
        /// Gets the name of the stored procedure to call for the hotlist gheneration
        /// </summary>
        /// <param name="contenttype">The content type to search for</param>
        /// <param name="searchDateType">The type of date search to do if any</param>
        /// <param name="phrases">The phrases to look for if any</param>
        /// <returns>String containing the name of the storedprocedure to call</returns>
        private static string GetArticleSearchHotlistStoredProcedureName(int contenttype, int searchDateType, string phrases)
        {
            string hotlistStoredProcedureName = String.Empty;

            if (phrases == String.Empty)
            {
                if (contenttype == -1)
                {
                    if (searchDateType == 0)
                    {
                        hotlistStoredProcedureName = "getkeyphrasearticlehotlist";
                    }
                    else if (searchDateType == 1)
                    {
                        hotlistStoredProcedureName = "getkeyphrasearticlehotlist";
                    }
                    else
                    {
                        hotlistStoredProcedureName = "getkeyphrasearticlehotlist";
                    }

                }
                else if (contenttype == 1)
                {
                    hotlistStoredProcedureName = "getkeyphrasearticleimageassethotlist";
                }
                else if (contenttype == 2)
                {
                    hotlistStoredProcedureName = "getkeyphrasearticleaudioassethotlist";
                }
                else if (contenttype == 3)
                {
                    hotlistStoredProcedureName = "getkeyphrasearticlevideoassethotlist";
                }
                else //contenttype = 0
                {
                    //Just get the articles with an media asset of any type
                    hotlistStoredProcedureName = "getkeyphrasearticlemediaassethotlist";
                }
            }
            else
            {
                if (contenttype == -1)
                {
                    if (searchDateType == 0)
                    {
                        hotlistStoredProcedureName = "getkeyphrasearticlehotlistwithphrase";
                    }
                    else if (searchDateType == 1)
                    {
                        hotlistStoredProcedureName = "getkeyphrasearticlehotlistwithphrase";
                    }
                    else
                    {
                        hotlistStoredProcedureName = "getkeyphrasearticlehotlistwithphrase";
                    }
                }
                else if (contenttype == 1)
                {
                    hotlistStoredProcedureName = "getkeyphrasearticleimageassethotlistwithphrase";
                }
                else if (contenttype == 2)
                {
                    hotlistStoredProcedureName = "getkeyphrasearticleaudioassethotlistwithphrase";
                }
                else if (contenttype == 3)
                {
                    hotlistStoredProcedureName = "getkeyphrasearticlevideoassethotlistwithphrase";
                }
                else //contenttype = 0
                {
                    //Just get the articles with an media asset of any type with that phrase
                    hotlistStoredProcedureName = "getkeyphrasearticlemediaassethotlistwithphrase";
                }
            }
            return hotlistStoredProcedureName;
        }

        /// <summary>
        /// Generates the Phrase XML from an ArrayList of phrases
        /// </summary>
        /// <param name="phraselist">list of phrases</param>
        /// <param name="parent">Element to attach the xml to</param>
        private void GeneratePhraseXml(ArrayList phraselist, XmlElement parent)
        {
            XmlElement phrases = AddElementTag(parent, "PHRASES");
            AddAttribute(phrases, "COUNT", phraselist.Count);
            AddAttribute(phrases, "DELIMITER", _token);

            foreach (Phrase phraseEntry in phraselist)
            {
                phraseEntry.AddPhraseXml(phrases);
            }
            parent.AppendChild(phrases);
        }



        /// <summary>
        /// Gets the XML from cache
        /// </summary>
        /// <param name="asp">Class containing all the search parameters.</param>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetArticleSearchCachedXml(ArticleSearchParams asp)
        {
            bool gotFromCache = false;

            _cacheName = "articlesearch-";

            //Create a cache name including the site, keyphrases, dateranges, if any, skip and show params.
            _cacheName += asp.SiteID.ToString();
            if (asp.ContentType != 0)
            {
                _cacheName += "-type" + asp.ContentType;
            }
            if (asp.ArticleStatus != 0)
            {
                _cacheName += "-artstatus" + asp.ArticleStatus;
            }
            if (asp.ArticleType != 0)
            {
                _cacheName += "-arttype" + asp.ArticleType;
            }
            if (asp.DateSearchType != 0)
            {
                _cacheName += "-datesearchtype-" + asp.DateSearchType;
                _cacheName += "-" + asp.StartDate.Year + "-" + asp.StartDate.Month + "-" + asp.StartDate.Day;
                _cacheName += "-" + asp.EndDate.Year + "-" + asp.EndDate.Month + "-" + asp.EndDate.Day;
                _cacheName += "-" + asp.TimeInterval;
            }
            _cacheName += (asp.Phrases.Length == 0 ? "" : "-")
                + asp.Phrases;

            _cacheName += (asp.NameSpaces.Length == 0 ? "" : "-")
                + asp.NameSpaces;

            if (asp.Latitude != 0.0 || asp.Longitude != 0.0 || asp.Range != 0.0)
            {
                _cacheName += "-lat" + asp.Latitude.ToString() + "-lon" + asp.Longitude.ToString() + "-rge" + asp.Range.ToString();
            }

            if (asp.FreeTextSearchCondition != String.Empty)
            {
                _cacheName += "-" + asp.FreeTextSearchCondition;
            }

            _cacheName += "-" + asp.Skip + "-" + asp.Show + (asp.SortBy.Length == 0 ? "" : "-") + asp.SortBy;

            _cacheName += "-" + asp.SkipPhrases + "-" + asp.ShowPhrases;


            if (asp.DescendingOrder)
            {
                _cacheName += "-desc";
            }
            else
            {
                _cacheName += "-asc";
            }
            _cacheName += ".xml";

            int articleSearchCacheTime = 10;

            try
            {
                articleSearchCacheTime = InputContext.GetSiteOptionValueInt("ArticleSearch", "CacheTime");
            }
            catch (SiteOptionNotFoundException Ex)
            {
                InputContext.Diagnostics.WriteToLog("Article Search", Ex.Message);
                articleSearchCacheTime = 10;
            }

            if (articleSearchCacheTime < 10)
            {
                articleSearchCacheTime = 10;
            }

            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(articleSearchCacheTime);  // expire after x minutes set in the siteoptions
            string articleSearchXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "articlesearch", _cacheName, ref expiry, ref articleSearchXML))
            {
                RipleyAddInside(RootElement, articleSearchXML);
                gotFromCache = true;
            }

            return gotFromCache;
        }

        /// <summary>
        /// Gets the cached hotlist information if there is any
        /// </summary>
        /// <returns>Whether we have got the XML from the File Cache</returns>
        private bool GetArticleSearchHotlistCachedXml()
        {
            bool gotFromCache = false;

            //Try to get a cached copy.
            DateTime expiry = DateTime.Now - TimeSpan.FromMinutes(10);  // expire after 10 minutes
            string articleKeyPhraseXML = String.Empty;

            if (FileCache.GetItem(AppContext.TheAppContext.Config.CachePath, "articlekeyphrase", _cacheName, ref expiry, ref articleKeyPhraseXML))
            {
                RipleyAddInside(RootElement, articleKeyPhraseXML);
                gotFromCache = true;
            }

            return gotFromCache;
        }

        /// <summary>
        /// Adds in the key phrase hotlist 
        /// </summary>
        /// <param name="siteID">Site id to run the searches against</param>
        /// <param name="skip">Number of articles to skip</param>
        /// <param name="show">Number of articles to show</param>
        /// <param name="contentType">Type of articles to articles to search for </param>
        /// <param name="sortBy">sortby option for the search</param>
        /// <param name="dateSearchType">Date search type</param>
        /// <param name="phrases">Key Phrases to search for</param>
        private void GenerateKeyPhraseHotlist(
            int siteID,
            int skip,
            int show,
            int contentType,
            string sortBy,
            int dateSearchType,
            string phrases)
        {
            //Add Hot Phrases.
            string storedHotlistProcedureName = GetArticleSearchHotlistStoredProcedureName(contentType, dateSearchType, phrases);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedHotlistProcedureName))
            {
                dataReader.AddParameter("siteid", siteID)
                .AddParameter("skip", skip)
                .AddParameter("show", skip + show);

                if (phrases != String.Empty)
                {
                    dataReader.AddParameter("keyphraselist", phrases);
                }
                if (sortBy == "Phrase")
                {
                    dataReader.AddParameter("sortbyphrase", 1);
                }

                dataReader.Execute();

                GenerateArticleSearchHotlistXml(dataReader, skip, show, contentType, sortBy);
            }

        }

        /// <summary>
        /// Adds in the key phrase hotlist 
        /// </summary>
        /// <param name="dataReader">Data set to turn into XML</param>
        /// <param name="skip">Number of articles to skip</param>
        /// <param name="show">Number of articles to show</param>
        /// <param name="contentType">Type of articles to articles to search for </param>
        /// <param name="sortBy">sortby option for the search</param>
        private void GenerateArticleSearchHotlistXml(IDnaDataReader dataReader,
            int skip,
            int show,
            int contentType,
            string sortBy)
        {
            int count = 0;
            XmlElement articleSearchHotlist = AddElementTag(RootElement, "ARTICLEHOT-PHRASES");

            AddAttribute(articleSearchHotlist, "CONTENTTYPE", contentType);
            AddAttribute(articleSearchHotlist, "SORTBY", sortBy);
            AddAttribute(articleSearchHotlist, "SKIP", skip);
            AddAttribute(articleSearchHotlist, "SHOW", show);

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    count = dataReader.GetInt32NullAsZero("Count");
                    do
                    {
                        XmlElement phrase = AddElementTag(articleSearchHotlist, "ARTICLEHOT-PHRASE");

                        string rawPhrase = dataReader.GetStringNullAsEmpty("phrase");

                        //If phrase contains token then quote.
                        string URLPhrase = rawPhrase;
                        if (rawPhrase.Contains(_token))
                        {
                            URLPhrase = "" + rawPhrase + "";
                        }

                        AddTextElement(phrase, "NAME", StringUtils.EscapeAllXml(rawPhrase));
                        AddTextElement(phrase, "TERM", Uri.EscapeDataString(URLPhrase));
                        AddTextElement(phrase, "RANK", (dataReader.GetDoubleNullAsZero("Rank")).ToString());

                    } while (dataReader.Read());
                }
            }
            AddAttribute(articleSearchHotlist, "COUNT", count.ToString());
            if (count > skip + show)
            {
                AddAttribute(articleSearchHotlist, "MORE", 1);
            }
            else
            {
                AddAttribute(articleSearchHotlist, "MORE", 0);
            }

            FileCache.PutItem(AppContext.TheAppContext.Config.CachePath, "articlekeyphrase", _cacheName, articleSearchHotlist.OuterXml);
        }

        /// <summary>
        /// Parses and prepares date range params for ArticleSearch.
        /// </summary>
        /// <param name="startDateText">Start date</param>
        /// <param name="endDateText">End date</param>
        /// <param name="startDate">Parsed start date</param>
        /// <param name="endDate">Parsed end date</param>
        /// <returns><see cref="DateRangeValidation.ValidationResult"/></returns>
        /// <remarks>If no endDateText is passed in then endDate is set to startDate + 1 day.</remarks>
        private DateRangeValidation.ValidationResult ParseDateParams(string startDateText, string endDateText, out DateTime startDate, out DateTime endDate)
        {
            CultureInfo ukCulture = new CultureInfo("en-GB");
            startDate = DateTime.MinValue;
            endDate = DateTime.MinValue;

            try
            {
                startDate = DateTime.Parse(startDateText, ukCulture);
            }
            catch (FormatException)
            {
                return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }
            catch (ArgumentException)
            {
                return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }

            // Has the user supplied and end date?
            bool createEndDate = endDateText.Length == 0;
            if (createEndDate)
            {
                // No end date passed in by user so create one using the start date.
                try
                {
                    endDate = startDate.AddDays(1);
                }
                catch (ArgumentOutOfRangeException)
                {
                    // can't create end date from start date.
                    return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
                }
            }
            else
            {
                // There is a user supplied end date so try to create it
                try
                {
                    endDate = DateTime.Parse(endDateText, ukCulture);

                    // DNA assumes that the dates passed into ArticleSearch by a user are inclusive. 
                    // 1 day is therefore added to the end date to represent what the user intended.
                    // E.g. searching for December 1999 they mean 01/12/1999 00:00 to 01/01/2000 00:00 not 01/12/1999 00:00 to 31/12/1999 00:00, which misses out the last 24 hours of the month.
                    endDate = endDate.AddDays(1);
                }
                catch (FormatException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
                catch (ArgumentOutOfRangeException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
                catch (ArgumentException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
            }
            return DateRangeValidation.ValidationResult.VALID;
        }

        /// <summary>
        /// Parses and prepares dates params for ArticleSearch.
        /// </summary>
        /// <param name="startYear">Start year</param>
        /// <param name="startMonth">Start month</param>
        /// <param name="startDay">Start day</param>
        /// <param name="endYear">End year</param>
        /// <param name="endMonth">End month</param>
        /// <param name="endDay">End day</param>
        /// <param name="startDate">Parsed start date</param>
        /// <param name="endDate">Parsed end date</param>
        /// <returns><see cref="DateRangeValidation.ValidationResult"/></returns>
        /// <remarks>If no endDay is passed in then endDate is set to startDate + 1 day.</remarks>
        private DateRangeValidation.ValidationResult ParseDateParams(int startYear, int startMonth, int startDay, int endYear, int endMonth, int endDay, out DateTime startDate, out DateTime endDate)
        {
            startDate = DateTime.MinValue;
            endDate = DateTime.MinValue;

            try
            {
                startDate = new DateTime(startYear, startMonth, startDay);
            }
            catch (ArgumentException)
            {
                return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
            }

            // Has the user supplied and end date?
            bool createEndDate = endDay == 0;
            if (createEndDate)
            {
                // No end date passed in by user so create one using the start date.
                try
                {
                    endDate = startDate.AddDays(1);
                }
                catch (ArgumentOutOfRangeException)
                {
                    // can't create end date from start date.
                    return DateRangeValidation.ValidationResult.STARTDATE_INVALID;
                }
            }
            else
            {
                // There is a user supplied end date so try to create it
                try
                {
                    endDate = new DateTime(endYear, endMonth, endDay);

                    // DNA assumes that the dates passed into ArticleSearch by a user are inclusive. 
                    // 1 day is therefore added to the end date to represent what the user intended.
                    // E.g. searching for December 1999 they mean 01/12/1999 00:00 to 01/01/2000 00:00 not 01/12/1999 00:00 to 31/12/1999 00:00, which misses out the last 24 hours of the month.
                    endDate = endDate.AddDays(1);
                }
                catch (ArgumentOutOfRangeException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
                catch (ArgumentException)
                {
                    return DateRangeValidation.ValidationResult.ENDDATE_INVALID;
                }
            }
            return DateRangeValidation.ValidationResult.VALID;
        }

        /// <summary>
        /// Coordiate structure. Holds Latitude and Longitude.
        /// </summary>
        public struct Coordinate
        {
            private double _latitude;
            private double _longitude;

            /// <summary>
            /// Constructor for the struct
            /// </summary>
            /// <param name="latitude">Starting latitude</param>
            /// <param name="longitude">Starting Longitude</param>
            public Coordinate(double latitude, double longitude)
            {
                _latitude = latitude;
                _longitude = longitude;
            }
            /// <summary>
            /// Accessor for the Latitude
            /// </summary>
            public double Latitude
            {
                get
                {
                    return _latitude;
                }
                set
                {
                    this._latitude = value;
                }
            }

            /// <summary>
            /// Accessor for the Longitude
            /// </summary>
            public double Longitude
            {
                get
                {
                    return _longitude;
                }
                set
                {
                    this._longitude = value;
                }
            }
        }

        /// <summary>
        /// Formats the uri string to call to get get the required info back
        /// </summary>
        /// <param name="address">The address to try and find</param>
        /// <returns>Uri to call to get the info back</returns>
        private Uri GetGeocodeUri(string address)
        {
            address = HttpUtility.UrlEncode(address);
            return new Uri(String.Format("{0}{1}&output={2}&key={3}", _googleUri, address, _outputType, _googleKey));
        }
        /// <summary>
        /// Gets a Coordinate from an address.
        /// </summary>
        /// <param name="address">An address.
        /// <remarks>
        /// <example>70 Dunbar Road, Wood Green, London, UK</example>
        /// </remarks>
        /// </param>
        /// <returns>A spatial coordinate that contains the latitude and longitude of the address.</returns>
        private Coordinate GetCoordinates(string address)
        {
            double latitude = 0.0;
            double longitude = 0.0;
            try
            {
                WebClient client = new WebClient();
                Uri uri = GetGeocodeUri(address);

                client.Proxy = new WebProxy(WebConfigurationManager.AppSettings["proxyserver"].ToString());

                string fullResponse = client.DownloadString(uri);

                /* The first number is the status code, 
                * the second is the accuracy, 
                * the third is the latitude, 
                * the fourth one is the longitude.
                */
                string[] geocodeInfo = fullResponse.Split(',');

                latitude = Convert.ToDouble(geocodeInfo[2]);
                longitude = Convert.ToDouble(geocodeInfo[3]);
            }
            catch (Exception Ex)
            {
                AddErrorXml("CoordinateError", "Location details could not be extracted from entry." + Ex.Message, RootElement);
            }

            return new Coordinate(latitude, longitude);
        }
        /// <summary>
        /// Formats the uri string to call to get get the required info back from PostCoder
        /// </summary>
        /// <param name="postcode">The postcode to try and find</param>
        /// <returns>Uri to call to get the info back</returns>
        private Uri GetPostCoderUri(string postcode)
        {
            //string postcoderUri = "http://ops-dev15.national.core.bbc.co.uk:1234/cgi-bin/whereilive/server/postcodedata.pl?customer=ican&loc=";
            //return new Uri(String.Format("{0}{1}", postcoderUri, postcode));


            string postcoderUri = "http://" + AppContext.TheAppContext.Config.PostcoderServer +
                                    AppContext.TheAppContext.Config.PostcoderPlace;

            postcode = HttpUtility.UrlEncode(postcode);

            postcoderUri = postcoderUri.Replace("--**placename**--", postcode);

            return new Uri(postcoderUri);
        }
        /// <summary>
        /// Gets a Coordinate from a postcode.
        /// </summary>
        /// <param name="postcode">An postcode</param>
        /// <returns>A spatial coordinate that contains the latitude and longitude of the postcode.</returns>
        private Coordinate GetPostCodeCoordinates(string postcode)
        {
            double latitude = 0.0;
            double longitude = 0.0;
            try
            {
                WebClient client = new WebClient();
                Uri uri = GetPostCoderUri(postcode);

                client.Proxy = new WebProxy(WebConfigurationManager.AppSettings["proxyserver"].ToString());

                string fullResponse = client.DownloadString(uri);

                XmlDocument postcoder = new XmlDocument();
                postcoder.LoadXml(fullResponse);

                int x = 0;
                int y = 0;
                x = Convert.ToInt32(postcoder.SelectSingleNode("/postcoder/result_list/result/co-ordinates/x").InnerXml);
                y = Convert.ToInt32(postcoder.SelectSingleNode("/postcoder/result_list/result/co-ordinates/y").InnerXml);

                OSGridToLatLong(x,y, ref latitude, ref longitude);
            }
            catch (Exception Ex)
            {
                AddErrorXml("CoordinateError", "Location details could not be extracted from entry." + Ex.Message, RootElement);
            }

            return new Coordinate(latitude, longitude);
        }

        /// <summary>
        /// Convert OS grid reference to geodesic co-ordinates
        /// </summary>
        /// <param name="easting"></param>
        /// <param name="northing"></param>
        /// <param name="latitude"></param>
        /// <param name="longitude"></param>
        protected void OSGridToLatLong(int easting, int northing, ref double latitude, ref double longitude)
        {
            //var gr = LatLong.gridrefLetToNum(gridRef);

            double a = 6377563.396;
            double b = 6356256.910;                                     // Airy 1830 major & minor semi-axes
            double F0 = 0.9996012717;                                   // NatGrid scale factor on central meridian
            double lat0 = 49 * Math.PI / 180;
            double lon0 = -2 * Math.PI / 180;                           // NatGrid true origin
            int N0 = -100000;
            int E0 = 400000;                                            // northing & easting of true origin, metres

            double e2 = 1 - (b * b) / (a * a);                          // eccentricity squared
            double n = (a - b) / (a + b);
            double n2 = n * n;
            double n3 = n * n * n;

            double lat = lat0;
            double M = 0;
            do
            {
                lat = (northing - N0 - M) / (a * F0) + lat;

                double Ma = (1 + n + (5 / 4) * n2 + (5 / 4) * n3) * (lat - lat0);
                double Mb = (3 * n + 3 * n * n + (21 / 8) * n3) * Math.Sin(lat - lat0) * Math.Cos(lat + lat0);
                double Mc = ((15 / 8) * n2 + (15 / 8) * n3) * Math.Sin(2 * (lat - lat0)) * Math.Cos(2 * (lat + lat0));
                double Md = (35 / 24) * n3 * Math.Sin(3 * (lat - lat0)) * Math.Cos(3 * (lat + lat0));
                M = b * F0 * (Ma - Mb + Mc - Md);                                       // meridional arc

            } while (northing - N0 - M >= 0.00001);  // ie until < 0.01mm

            double cosLat = Math.Cos(lat);
            double sinLat = Math.Sin(lat);
            double nu = a * F0 / Math.Sqrt(1 - e2 * sinLat * sinLat);                    // transverse radius of curvature
            double rho = a * F0 * (1 - e2) / Math.Pow(1 - e2 * sinLat * sinLat, 1.5);    // meridional radius of curvature
            double eta2 = nu / rho - 1;

            double tanLat = Math.Tan(lat);
            double tan2lat = tanLat * tanLat;
            double tan4lat = tan2lat * tan2lat;
            double tan6lat = tan4lat * tan2lat;
            double secLat = 1 / cosLat;
            double nu3 = nu * nu * nu;
            double nu5 = nu3 * nu * nu;
            double nu7 = nu5 * nu * nu;
            double VII = tanLat / (2 * rho * nu);
            double VIII = tanLat / (24 * rho * nu3) * (5 + 3 * tan2lat + eta2 - 9 * tan2lat * eta2);
            double IX = tanLat / (720 * rho * nu5) * (61 + 90 * tan2lat + 45 * tan4lat);
            double X = secLat / nu;
            double XI = secLat / (6 * nu3) * (nu / rho + 2 * tan2lat);
            double XII = secLat / (120 * nu5) * (5 + 28 * tan2lat + 24 * tan4lat);
            double XIIA = secLat / (5040 * nu7) * (61 + 662 * tan2lat + 1320 * tan4lat + 720 * tan6lat);

            double dE = (easting - E0);
            double dE2 = dE * dE;
            double dE3 = dE2 * dE;
            double dE4 = dE2 * dE2;
            double dE5 = dE3 * dE2;
            double dE6 = dE4 * dE2;
            double dE7 = dE5 * dE2;
            lat = lat - VII * dE2 + VIII * dE4 - IX * dE6;
            double lon = lon0 + X * dE - XI * dE3 + XII * dE5 - XIIA * dE7;

            latitude = lat * 180 / Math.PI;
            longitude = lon * 180 / Math.PI;
        }
    }
}
