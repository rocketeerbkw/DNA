using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Article SubscriptionsList List - A derived DnaInputComponent object to get the list of articles subscribed written by authors that have been subscribed to. 
    /// </summary>
    public class ArticleSubscriptionsList : DnaInputComponent
    {
        private string _token = @" ";
        
        private const int FIRSTCUT = 100000000;
        private const int SECONDCUT = 100000;
        private const int THIRDCUT = 100;
        
        /// <summary>
        /// Default Constructor for the UserSubscriptionsList object
        /// </summary>
        public ArticleSubscriptionsList(IInputContext context)
            : base(context)
        {
            string delimiter = NamespacePhrases.GetSiteDelimiterToken(context);
            if (delimiter.Length > 0)
            {
                _token = delimiter.Substring(0, 1);
            }
        }

        /// <summary>
        /// Functions generates the User Subscription List
        /// </summary>
        /// <param name="userID">The user requesting their subscriptions</param>
        /// <param name="siteID">The site the user is getting their subscriptions from</param>
        /// <param name="skip">number of articles to skip</param>
        /// <param name="show">number of articles to show</param>
        /// <returns>Success</returns>
        public bool CreateArticleSubscriptionsList(int userID, int siteID, int skip, int show)
        {
            RootElement.RemoveAll();
            XmlElement articleSubscriptionsList = AddElementTag(RootElement, "ARTICLESUBSCRIPTIONLIST");
            AddAttribute(articleSubscriptionsList, "SKIP", skip);
            AddAttribute(articleSubscriptionsList, "SHOW", show);

            XmlNode articles = AddElementTag(articleSubscriptionsList, "ARTICLES");
            int total = 0;
            int count = 0;

            using (IDnaDataReader dataReader = GetArticleSubscriptionList(userID, siteID, skip + 1, show))	// Add 1 to skip because row number starts at 1.
            {
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

                            AddXmlTextTag(article, "SUBJECT", dataReader.GetStringNullAsEmpty("SUBJECT"));
                            AddTextTag(article, "TYPE", dataReader.GetInt32NullAsZero("type"));
                            AddTextTag(article, "STATUS", dataReader.GetInt32NullAsZero("status"));

                            int editorID = dataReader.GetInt32NullAsZero("editor");
                            XmlNode editor = CreateElementNode("EDITOR");
                            User user = new User(InputContext);
                            user.AddUserXMLBlock(dataReader, editorID, editor);
                            article.AppendChild(editor);

                            //Add Extra Info XML where it exists.
                            string extraInfo = dataReader.GetAmpersandEscapedStringNullAsEmpty("EXTRAINFO");
                            if (extraInfo != string.Empty)
                            {
                                XmlDocument extraInfoXml = new XmlDocument();
                                extraInfoXml.LoadXml(extraInfo);
                                article.AppendChild(ImportNode(extraInfoXml.FirstChild));
                            }

                            AddDateXml(dataReader, article, "DateCreated", "DATECREATED");
                            AddDateXml(dataReader, article, "LastUpdated", "LASTUPDATED");

                            AddTextTag(article, "NUMBEROFPOSTS", dataReader.GetInt32NullAsZero("ForumPostCount"));

                            if (dataReader.DoesFieldExist("ZeitgeistScore"))
                            {
                                AddElement(article, "ZEITGEIST", "<SCORE>" + dataReader.GetDoubleNullAsZero("ZeitgeistScore") + "</SCORE>");
                            }

                            if (!dataReader.IsDBNull("StartDate"))
                            {
                                AddDateXml(dataReader, article, "StartDate", "DATERANGESTART");
                                DateTime articlesDateRangeEnd = dataReader.GetDateTime("EndDate");
                                if (InputContext.GetSiteOptionValueBool(dataReader.GetInt32NullAsZero("SiteID"), "GuideEntries", "InclusiveDateRange"))
                                {
                                    // take a minute from the end date as stored in the database so to match user's expectations. 
                                    // I.e. If SiteOption InclusiveDateRange is true user will have submitted a date range like 01/09/1980 to 02/09/1980
                                    // They mean for this to represent 2 days i.e. 01/09/1980 00:00 - 03/09/1980 00:00 but for display purposes expect the 
                                    // end date to be 02/09/1980. 02/09/1980 23:59 is therefore returned. 
                                    TimeSpan minute = new TimeSpan(0, 1, 0);
                                    AddDateXml(articlesDateRangeEnd.Subtract(minute), article, "DATERANGEEND");
                                }
                                else
                                {
                                    AddDateXml(articlesDateRangeEnd, article, "DATERANGEEND");
                                }

                                AddTextTag(article, "TIMEINTERVAL", dataReader.GetInt32NullAsZero("TimeInterval"));
                            }

                            if (dataReader.DoesFieldExist("Latitude") && !dataReader.IsDBNull("Latitude"))
                            {
                                AddTextTag(article, "LATITUDE", dataReader.GetDoubleNullAsZero("Latitude").ToString());
                            }
                            if (dataReader.DoesFieldExist("Longitude") && !dataReader.IsDBNull("Longitude"))
                            {
                                AddTextTag(article, "LONGITUDE", dataReader.GetDoubleNullAsZero("Longitude").ToString());
                            }
                            if (dataReader.DoesFieldExist("Distance") && !dataReader.IsDBNull("Distance"))
                            {
                                AddTextTag(article, "DISTANCE", dataReader.GetDoubleNullAsZero("Distance").ToString());
                            }

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
                articleSubscriptionsList.AppendChild(articles);
            }
            AddAttribute(articleSubscriptionsList, "COUNT", count);
            AddAttribute(articleSubscriptionsList, "TOTAL", total);

            return true;
        }

        /// <summary>
        /// Get articles written by users that have been subscribed to.
        /// </summary>
        /// <param name="userID">The user requesting their subscriptions</param>
        /// <param name="siteID">The site the user is getting their subscriptions from</param>
        /// <param name="skip">number of articles to skip</param>
        /// <param name="show">number of articles to show</param>
        /// <returns>Success</returns>
        IDnaDataReader GetArticleSubscriptionList(int userID, int siteID, int skip, int show)
        {
            IDnaDataReader dataReader;

            dataReader = InputContext.CreateDnaDataReader("getsubscribedarticles");

            dataReader.AddParameter("userid", userID);
            dataReader.AddParameter("siteid", siteID);
            dataReader.AddParameter("firstindex", skip);
            dataReader.AddParameter("lastindex", skip + show - 1);

            dataReader.Execute();

            return dataReader;
        }

        /// <summary>
        /// Adds the MediaAsset XML data to the XML document
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="parent">parent to add the xml to</param>
        /// <param name="mediaAssetID">Media asset id in question</param>
        private void AddMediaAssetXml(IDnaDataReader dataReader, XmlNode parent, int mediaAssetID)
        {
            // TODO: move this method into a MedaiAsset class - it's duplicated in ArticleSearch.cs.
            string FTPPath = String.Empty;

            XmlNode mediaAsset = CreateElementNode("MEDIAASSET");

            AddAttribute(mediaAsset, "MEDIAASSETID", mediaAssetID);

            AddAttribute(mediaAsset, "CONTENTTYPE", dataReader.GetInt32NullAsZero("ContentType"));

            GenerateFTPDirectoryString(mediaAssetID, ref FTPPath);
            AddTextTag(mediaAsset, "FTPPATH", FTPPath);

            AddTextTag(mediaAsset, "CAPTION", dataReader.GetStringNullAsEmpty("Caption"));

            int ownerID = dataReader.GetInt32NullAsZero("OwnerID");

            XmlNode owner = CreateElementNode("OWNER");
            User user = new User(InputContext);
            user.AddUserXMLBlock(dataReader, ownerID, owner);
            mediaAsset.AppendChild(owner);

            AddTextTag(mediaAsset, "MIMETYPE", dataReader.GetStringNullAsEmpty("Mimetype"));

            //Extra extendedable element stuff removed for time being
            XmlDocument extraelementinfo = new XmlDocument();
            extraelementinfo.LoadXml("<EXTRAELEMENTXML>" + dataReader.GetStringNullAsEmpty("EXTRAELEMENTXML") + "</EXTRAELEMENTXML>");
            mediaAsset.AppendChild(ImportNode(extraelementinfo.FirstChild));

            AddTextTag(mediaAsset, "HIDDEN", dataReader.GetInt32NullAsZero("Hidden"));

            string externalLinkID = String.Empty;
            string externalLinkType = String.Empty;

            string externalLinkURL = dataReader.GetStringNullAsEmpty("ExternalLinkURL");
            GetIDFromLink(externalLinkURL, ref externalLinkID, ref externalLinkType);

            AddTextTag(mediaAsset, "EXTERNALLINKTYPE", externalLinkType);
            AddTextTag(mediaAsset, "EXTERNALLINKURL", externalLinkURL);
            AddTextTag(mediaAsset, "EXTERNALLINKID", externalLinkID);

            parent.AppendChild(mediaAsset);
        }

        private void AddPollXml(IDnaDataReader dataReader, XmlNode article)
        {
            //<POLL POLLID="2311" POLLTYPE="3" HIDDEN="0">
            //    <STATISTICS AVERAGERATING="0.000000" VOTECOUNT="0" /> 
            //</POLL>

            int pollID = dataReader.GetInt32NullAsZero("CRPollID");
            if (pollID != 0)
            {
                XmlNode poll = CreateElementNode("POLL");
                AddAttribute(poll, "POLLID", pollID);
                AddAttribute(poll, "POLLTYPE", 3);
                AddAttribute(poll, "HIDDEN", 0);
                XmlNode statistics = CreateElementNode("STATISTICS");
                AddAttribute(statistics, "AVERAGERATING", dataReader.GetDoubleNullAsZero("CRAverageRating").ToString());
                AddAttribute(statistics, "VOTECOUNT", dataReader.GetInt32NullAsZero("CRVoteCount").ToString());
                poll.AppendChild(statistics);
                article.AppendChild(poll);
            }
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
        /// Method that will produce the FTP directory path from the Media Asset ID
        ///	This is for the limit of files within a unix folder to function well
        ///	we basically take the ID and divide it a number of times to get
        ///	sub directories
        /// </summary>
        /// <param name="mediaAssetID">The media asset id</param>
        /// <param name="FTPDirectory">The returned FTP Directory</param>
        /// <returns></returns>
        void GenerateFTPDirectoryString(int mediaAssetID, ref string FTPDirectory)
        {
            int firstCut = (mediaAssetID / FIRSTCUT);
            int secondCut = (mediaAssetID / SECONDCUT);
            int thirdCut = (mediaAssetID / THIRDCUT);

            FTPDirectory = firstCut + "/" + secondCut + "/" + thirdCut + "/";
        }

        /// <summary>
        /// Function to generate the ID from the URL Link checks against a YouTube or a Google Video Link
        /// </summary>
        /// <param name="inLink">The url to check</param>
        /// <param name="outID">The specific ID for the type for the site from the url</param>
        /// <param name="outType">The site the url and id is for</param>
        /// <returns>Whether we have a known link part</returns>
        bool GetIDFromLink(string inLink, ref string outID, ref string outType)
        {
            string youTubePreFix = @"http://www.youtube.com/watch?v=";
            string mySpaceVideoPreFix = @"http://vids.myspace.com/index.cfm?fuseaction=vids.individual&amp;videoid=";
            string googleVideoPreFix = @"http://video.google.com/videoplay?docid=";
            string googleVideoUKPreFix = @"http://video.google.co.uk/videoplay?docid=";

            GetExternalIDFromLink(inLink, googleVideoPreFix, ref outID);
            if (outID != String.Empty)
            {
                outType = "Google";
                return true;
            }

            GetExternalIDFromLink(inLink, googleVideoUKPreFix, ref outID);
            if (outID != String.Empty)
            {
                outType = "Google";
                return true;
            }

            GetExternalIDFromLink(inLink, youTubePreFix, ref outID);
            if (outID != String.Empty)
            {
                outType = "YouTube";
                return true;
            }

            GetExternalIDFromLink(inLink, mySpaceVideoPreFix, ref outID);
            if (outID != String.Empty)
            {
                outType = "MySpace";
                return true;
            }

            outType = "Unknown";
            return false;
        }

        /// <summary>
        /// Function to generate the External site ID from the URL Link and the external site prefix
        /// </summary>
        /// <param name="inLink">The raw link from the website</param>
        /// <param name="inPreFix">Extract the site info</param>
        /// <param name="outExternalID">Get the id of our specific object</param>
        /// <returns>Whether we can find an external link</returns>
        bool GetExternalIDFromLink(string inLink, string inPreFix, ref string outExternalID)
        {
            bool OK = false;
            string externalID = String.Empty;

            int startTypePos = inLink.IndexOf(inPreFix);
            if (startTypePos > -1)
            {
                startTypePos = startTypePos + inPreFix.Length;

                externalID = inLink.Substring(startTypePos);

                if (externalID != String.Empty)
                {
                    outExternalID = externalID;
                    OK = true;
                }
            }
            return OK;
        }
    }
}