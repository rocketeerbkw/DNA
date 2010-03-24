using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// The ArticleMember component
    /// </summary>
    public class ArticleMember : DnaInputComponent
    {
        int _H2G2ID = 0;
        int _status = 0;
        string _name = String.Empty;

        DateTime _dateCreated = DateTime.MinValue;
        DateTime _lastUpdated = DateTime.MinValue;

        XmlElement _extraInfo;
        bool _includeStrippedName = false;

        bool _local = false;

        // Content rating stats
        int _pollID;
        int _voteCount;
        double _averageRating;

        // Editor 
        XmlElement _editor;

        //Media Asset info
        int _mediaAssetID = 0;
        int _contentType = 0;
        string _caption = String.Empty;
        int _mimeType = 0;
        int _ownerID = 0;
        string _extraElementXML = String.Empty;
        int _hidden = 0;
        string _externalLinkURL = String.Empty;

        XmlElement _crumbTrail;

        /// <summary>
        /// Default constructor for the Article Member component
        /// </summary>
        /// <param name="context">The inputcontext that the component is running in</param>
        public ArticleMember(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// H2G2ID
        /// </summary>
        public int H2G2ID
        {
            get { return _H2G2ID; }
            set { _H2G2ID = value; }
        }

        /// <summary>
        /// Status of the article
        /// </summary>
        public int Status
        {
            get { return _status; }
            set { _status = value; }
        }
        /// <summary>
        /// Name of the article
        /// </summary>
        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }
        /// <summary>
        /// Whether to include the stripped name or not
        /// </summary>
        public bool IncludeStrippedName
        {
            get { return _includeStrippedName; }
            set { _includeStrippedName = value; }
        }
        /// <summary>
        /// Date Created of the Article
        /// </summary>
        public DateTime DateCreated
        {
            get { return _dateCreated; }
            set { _dateCreated = value; }
        }
        /// <summary>
        /// Last Updated of the Article
        /// </summary>
        public DateTime LastUpdated
        {
            get { return _lastUpdated; }
            set { _lastUpdated = value; }
        }
        /// <summary>
        /// Articles extra info
        /// </summary>
        public XmlElement ExtraInfo
        {
            get { return _extraInfo; }
            set { _extraInfo = value; }
        }
        /// <summary>
        /// The Crumbtrail in XML
        /// </summary>
        public XmlElement CrumbTrail
        {
            get { return _crumbTrail; }
        }

        /// <summary>
        /// if the article is Local
        /// </summary>
        public bool Local
        {
            get { return _local; }
            set { _local = value; }
        }
        /// <summary>
        /// Sets the Content Rating stats
        /// </summary>
        /// <param name="pollID"></param>
        /// <param name="voteCount"></param>
        /// <param name="averageRating"></param>
        public void SetContentRatingStatistics(int pollID, int voteCount, double averageRating)
        {
            _pollID = pollID;
            _voteCount = voteCount;
            _averageRating = averageRating;
        }
        /// <summary>
        /// Sets the extra info xml from the string
        /// </summary>
        /// <param name="extraInfo"></param>
        public void SetExtraInfo(string extraInfo)
        {
            _extraInfo.RemoveAll();
            _extraInfo = CreateElement("ExtraInfo");
            XmlDocument extraInfoXml = new XmlDocument();
            extraInfoXml.LoadXml(extraInfo);
            _extraInfo.AppendChild(ImportNode(extraInfoXml.FirstChild));
        }
        /// <summary>
        /// Sets the extra info xml from the string and the type
        /// </summary>
        /// <param name="extraInfo"></param>
        /// <param name="type"></param>
        public void SetExtraInfo(string extraInfo, int type)
        {
            _extraInfo.RemoveAll();
            _extraInfo = CreateElement("ExtraInfo");
            ExtraInfo extraInfoObject = new ExtraInfo();
            extraInfoObject.TryCreate(type, extraInfo);
            _extraInfo.AppendChild(ImportNode(extraInfoObject.RootElement.FirstChild));
        }

        /// <summary>
        /// Sets the crumbtrail XML
        /// </summary>
        public void SetCrumbTrail()
        {
            _crumbTrail = CreateElement("Crumbtrail");
            Category category = new Category(InputContext);
            category.CreateArticleCrumbtrail(_H2G2ID);
            _crumbTrail.AppendChild(ImportNode(category.RootElement.FirstChild));
        }
        /// <summary>
        /// Sets the media Asset Info from the passed in params
        /// </summary>
        /// <param name="mediaAssetID"></param>
        /// <param name="contentType"></param>
        /// <param name="caption"></param>
        /// <param name="mimeType"></param>
        /// <param name="ownerID"></param>
        /// <param name="extraElementXML"></param>
        /// <param name="hidden"></param>
        /// <param name="externalLinkURL"></param>
        public void SetMediaAssetInfo(int mediaAssetID,
									    int contentType,
									    string caption,
									    int mimeType,
									    int ownerID,
									    string extraElementXML,
									    int hidden,
                                        string externalLinkURL)
        {
            _mediaAssetID = mediaAssetID;
		    _contentType = contentType;
		    _caption = caption;
		    _mimeType = mimeType;
		    _ownerID = ownerID;
		    _extraElementXML = extraElementXML;
		    _hidden = hidden;
            _externalLinkURL = externalLinkURL;
        }

        /// <summary>
        /// Sets the phrase list for the articlemember
        /// </summary>
        /// <param name="phraselist">List of phrases</param>
        public void SetPhraseList(List<Phrase> phraselist)
        {
 	        throw new Exception("The method or operation is not implemented.");
        }


        /// <summary>
        /// Function to generate the XML / load the Root Element from the internal data
        /// </summary>
        public void TryCreateXML()
        {
            if (H2G2ID == 0)
            {
                throw new Exception("Article Member must have a H2G2ID.");
            }

            XmlElement articleMember = AddElementTag(RootElement, "ARTICLEMEMBER");
            AddIntElement(articleMember, "H2G2ID", H2G2ID);
            AddTextTag(articleMember, "NAME", Name);
            if (IncludeStrippedName)
            {
                AddTextTag(articleMember, "STRIPPEDNAME", StringUtils.StrippedName(Name));
            }

            if (_editor != null)
            {
                articleMember.AppendChild(_editor.FirstChild);
            }

            XmlElement status = AddTextTag(articleMember, "STATUS", GetStatusDescription(_status));
            AddAttribute(status, "TYPE", _status);

            if (DateCreated != DateTime.MinValue)
            {
                AddDateXml(DateCreated, articleMember, "DATECREATED");
            }
            if (LastUpdated != DateTime.MinValue)
            {
                AddDateXml(LastUpdated, articleMember, "LASTUPDATED");
            }
            if (Local)
            {
                AddIntElement(articleMember, "LOCAL", 1);
            }
	        // Add Content Rating data if we have a cr poll for this article
            if (_pollID > 0)
            {
                //TODO ADD Poll stuff
            }
            if (InputContext.GetSiteOptionValueBool("MediaAsset", "ReturnInCategoryList"))
            {
               if (_mediaAssetID > 0)
                {
                    string FTPPath = String.Empty;
                    FTPPath = MediaAsset.GenerateFTPDirectoryString(_mediaAssetID);

                    XmlElement assetXML = AddElementTag(articleMember, "MEDIAASSET");
                    AddAttribute(assetXML, "MEDIAASSETID", _mediaAssetID);

                    AddTextElement(assetXML, "FTPPATH", FTPPath);
                    AddTextElement(assetXML, "CAPTION", _caption);
                    AddIntElement(assetXML, "MIMETYPE", _mimeType);
                    AddIntElement(assetXML, "CONTENTTYPE", _contentType);

                    //TODO : Need to add the keyphrases for the media asset here

                    //Extra extendedable element stuff removed for time being
                    XmlDocument extraelementinfo = new XmlDocument();
                    extraelementinfo.LoadXml("<EXTRAELEMENTXML>" + _extraElementXML + "</EXTRAELEMENTXML>");
                    assetXML.AppendChild(ImportNode(extraelementinfo.FirstChild));

                    /*XmlNode owner = AddElementTag(assetXML, "OWNER");
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, ownerID, owner);
                    assetXML.AppendChild(owner);
                   */

                    AddIntElement(assetXML, "HIDDEN", _hidden);

                    string externalLinkID = String.Empty;
                    string externalLinkType = String.Empty;
                    string flickrFarmPath = String.Empty;
                    string flickrServer = String.Empty;
                    string flickrID = String.Empty;
                    string flickrSecret = String.Empty;
                    string flickrSize = String.Empty;

                    MediaAsset.GetIDFromLink(_externalLinkURL,
                        ref externalLinkID,
                        ref externalLinkType,
                        ref flickrFarmPath,
                        ref flickrServer,
                        ref flickrID,
                        ref flickrSecret,
                        ref flickrSize);

                    AddTextElement(assetXML, "EXTERNALLINKURL", _externalLinkURL);
                    AddTextElement(assetXML, "EXTERNALLINKID", externalLinkID);
                    AddTextElement(assetXML, "EXTERNALLINKTYPE", externalLinkType);

                    if (externalLinkType == "Flickr")
                    {
                        XmlElement flickr = AddElementTag(assetXML, "FLICKR");
                        AddTextElement(flickr, "FARMPATH", flickrFarmPath);
                        AddTextElement(flickr, "SERVER", flickrServer);
                        AddTextElement(flickr, "ID", flickrID);
                        AddTextElement(flickr, "SECRET", flickrSecret);
                        AddTextElement(flickr, "SIZE", flickrSize);
                    }
                }
            }

        }

        private string GetStatusDescription(int status)
        {
            string statusDescription = String.Empty;

            switch (status)
            {
                case 0: statusDescription = "No Status"; break;
                case 1: statusDescription = "Edited"; break;
                case 2: statusDescription = "User Entry, Private"; break;
                case 3: statusDescription = "User Entry, Public"; break;
                case 4: statusDescription = "Recommended"; break;
                case 5: statusDescription = "Locked by Editor"; break;
                case 6: statusDescription = "Awaiting Editing"; break;
                case 7: statusDescription = "Cancelled"; break;
                case 8: statusDescription = "User Entry, Staff-locked"; break;
                case 9: statusDescription = "Key Entry"; break;
                case 10: statusDescription = "General Page"; break;
                case 11: statusDescription = "Awaiting Rejection"; break;
                case 12: statusDescription = "Awaiting Decision"; break;
                case 13: statusDescription = "Awaiting Approval"; break;

                default: statusDescription = "Unknown";
                    break;
            }
            return statusDescription;
        }

        /// <summary>
        /// Sets the editor XML from the given dataReader
        /// </summary>
        /// <param name="dataReader">DataReader contain the row with the editor user columns</param>
        public void SetEditor(IDnaDataReader dataReader)
        {
            string editor = dataReader.GetStringNullAsEmpty("editor");
            int editorID = 0;
            Int32.TryParse(editor, out editorID);

            _editor.RemoveAll();
            _editor = CreateElement("Editor");

            User editorUser = new User(InputContext);
            editorUser.AddPrefixedUserXMLBlock(dataReader, editorID, "editor", _editor);
        }
    }
}