using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class handling the building of the MediaAsset page and it's associated requests
    /// </summary>
    public class MediaAsset : DnaInputComponent
    {
        private int _mediaAssetID; 

        private const int FIRSTCUT = 100000000;
        private const int SECONDCUT = 100000;
        private const int THIRDCUT = 100;

        private const string _docDnaShow = @"The number of media assets to show.";
        private const string _docDnaSkip = @"The number of media assets to skip.";

        private const string _docDnaMediaAssetID = @"Media Asset ID param.";
        private const string _docDnaSiteID = @"Site ID filter param.";
        private const string _docDnaArticleSortBy = @"Media asset sort by param.";
        private const string _docDnaContentType = @"Content type filter param.";
        private const string _docDnaAction = @"Action to take on this request on the Media Assets page.";
        private const string _docDnaRPMAID = @"ReProcess Media Asset ID.";
        private const string _docDnaAddToLibrary = @"Whether the page needs to process a library media asset.";
        private const string _docDnaManualUpload = @"Whether the page needs to process a manual upload.";
        private const string _docDnaUpdateDataUploaded = @"Whether the page needs to update the data uploaded.";
        private const string _docDnaExternalLink = @"Whether the page needs to handle an external link.";
        private const string _docDnaUserID = @"User ID param to get the media assets for.";

        private XmlElement _builderRoot;

        /// <summary>
        /// Constructor for the Media Asset class
        /// </summary>
        /// <param name="context"></param>
        public MediaAsset(IInputContext context)
            : base(context)
        { 
        }

        /// <summary>
        /// Called by the dna framework so that the component can have a chance at processing the request
        /// </summary>
        public override void ProcessRequest()
        {
            RootElement.RemoveAll();

            MediaAssetParameters mediaAssetParams = new MediaAssetParameters();

            GetPageParams(mediaAssetParams);

            ProcessActions(mediaAssetParams);
        }

        private void ProcessActions(MediaAssetParameters mediaAssetParams)
        {
            _builderRoot = AddElementTag(RootElement, "MEDIAASSETBUILDER");

            if (InputContext.CurrentSite.IsEmergencyClosed || InputContext.CurrentSite.IsSiteScheduledClosed(DateTime.Now))
            {
                AddErrorXml("Site Closed", "Sites closed.", RootElement);
                return;
            }

            switch (mediaAssetParams.Action)
            {
                case MediaAssetParameters.MediaAssetAction.create:
                {
                    ProcessCreateUpdateAssets(mediaAssetParams);
                }
                break;
                case MediaAssetParameters.MediaAssetAction.update:
                {
                    ProcessCreateUpdateAssets(mediaAssetParams);
                }
                break;
                case MediaAssetParameters.MediaAssetAction.showusersassets:
                {
                    ProcessShowUsersMediaAssets(mediaAssetParams);   
                }
                break;
                case MediaAssetParameters.MediaAssetAction.showusersarticleswithassets :
                {
                    ProcessShowUsersArticlesWithMediaAssets(mediaAssetParams);
                }
                break;
                case MediaAssetParameters.MediaAssetAction.showftpuploadqueue : 
                {
                    ProcessShowFTPUploadQueue();
                }
                break;
                case MediaAssetParameters.MediaAssetAction.reprocessfaileduploads :
                {
                    ProcessReprocessFailedUploads(mediaAssetParams.Rpmaid);
                }
                break;
                default:
                {
                    ProcessView(mediaAssetParams);
                }
                break;
            }
        }

       private void ProcessCreateUpdateAssets(MediaAssetParameters mediaAssetParams)
        {
            if (!InputContext.ViewingUser.UserLoggedIn)
            {
                AddErrorXml("ProcessCreateUpdateAssets", "No logged in user", RootElement);
                return;
            }
        }

        private void GetPageParams(MediaAssetParameters mediaAssetParams)
        {
            int defaultShow = InputContext.GetSiteOptionValueInt("ArticleSearch", "DefaultShow");
            mediaAssetParams.MediaAssetID = InputContext.GetParamIntOrZero("ID", _docDnaMediaAssetID);
            mediaAssetParams.H2G2ID = InputContext.GetParamIntOrZero("h2g2id", _docDnaMediaAssetID);

            mediaAssetParams.Skip = InputContext.GetParamIntOrZero("skip", _docDnaSkip);
            mediaAssetParams.Show = InputContext.GetParamIntOrZero("show", _docDnaShow);
            if (mediaAssetParams.Show > 200)
            {
                mediaAssetParams.Show = 200;
            }
            else if (mediaAssetParams.Show < 1)
            {
                mediaAssetParams.Show = defaultShow;
            }
            mediaAssetParams.ContentType = InputContext.GetParamIntOrZero("contenttype", _docDnaContentType);
            mediaAssetParams.SortBy = InputContext.GetParamStringOrEmpty("sortby", _docDnaArticleSortBy);

            string action = String.Empty;

            InputContext.TryGetParamString("action", ref action, _docDnaAction);
            try
            {
                mediaAssetParams.Action = (MediaAssetParameters.MediaAssetAction)Enum.Parse(typeof(MediaAssetParameters.MediaAssetAction), action);
            }
            catch (Exception)
            {
                mediaAssetParams.Action = MediaAssetParameters.MediaAssetAction.view;
            }
            mediaAssetParams.AddToLibrary = InputContext.GetParamBoolOrFalse("AddToLibrary", _docDnaAddToLibrary);
            mediaAssetParams.IsManualUpload = InputContext.GetParamBoolOrFalse("manualupload", _docDnaManualUpload);
            mediaAssetParams.UpdateDataLoaded = InputContext.GetParamBoolOrFalse("updatedatauploaded", _docDnaUpdateDataUploaded);
            mediaAssetParams.IsExternalLink = InputContext.GetParamBoolOrFalse("externallink", _docDnaExternalLink);
            
            mediaAssetParams.Rpmaid = InputContext.GetParamIntOrZero("Rpmaid", _docDnaRPMAID);

            mediaAssetParams.UserID = InputContext.GetParamIntOrZero("userid", _docDnaUserID);
            if (mediaAssetParams.UserID == InputContext.ViewingUser.UserID)
            {
                mediaAssetParams.IsOwner = true;
            }
        }

        /// <summary>
        /// Public method to allow the caller to get the media asset info linked
		///		to an article's h2g2id,
		///		it is not a failure if no media asset id is retrieved ie no record exists
        /// </summary>
        /// <param name="H2G2ID"></param>
        /// <param name="mediaAssetID"></param>
        /// <param name="mimeType"></param>
        /// <param name="hidden"></param>
        public void GetArticlesAssets(int H2G2ID, ref int mediaAssetID, ref string mimeType, ref int hidden )
        {
            mediaAssetID = 0;

            // Get the information from the database
            using (IDnaDataReader datareader = InputContext.CreateDnaDataReader("getarticlesassets"))
            {
                datareader.AddParameter("h2g2id", H2G2ID);
                datareader.Execute();
                if (datareader.HasRows)
                {
                    if (datareader.Read())
                    {
                        mediaAssetID = datareader.GetInt32NullAsZero("MediaAssetID");
                        mimeType = datareader.GetStringNullAsEmpty("MimeType");
                        hidden = datareader.GetInt32NullAsZero("Hidden");
                    }
                }
	        }
        }

        private void ProcessReprocessFailedUploads(int mediaAssetID)
        {
            if (!InputContext.ViewingUser.UserLoggedIn)
            {
                AddErrorXml("ProcessReprocessFailedUploads", "No logged in user", RootElement);
                return;
            }
            if (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser)
            {
                // Add the information to the database
                using (IDnaDataReader datareader = InputContext.CreateDnaDataReader("reprocessfaileduploads"))
                {
                    datareader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                    if (mediaAssetID > 0)
                    {
                        datareader.AddParameter("mediaassetid", mediaAssetID);
                    }
                    datareader.Execute();

                    XmlElement uploadQueue = AddElementTag(RootElement, "MEDIAASSETUPLOADQUEUE");
                    AddTextElement(uploadQueue, "ACTION", "reprocessfaileduploads");

                    if (mediaAssetID > 0)
                    {
                        AddIntElement(uploadQueue, "MEDIAASSETID", mediaAssetID);
                    }
                    AddTextElement(uploadQueue, "RESULT", "SUCCESS");
                }
            }
            else
            {
                AddErrorXml("Incorrect Permissions", "Must be superuser or editor to reprocess the queue", RootElement);
            }
        }

        /// <summary>
        /// Processes the showftpuploadqueue action to view a
		///		list the status of the ftp upload queue
        /// </summary>
        public void ProcessShowFTPUploadQueue()
        {
            if (!InputContext.ViewingUser.UserLoggedIn)
            {
                AddErrorXml("ProcessShowFTPUploadQueue", "No logged in user", RootElement);
            }
            if (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser)
            {
                // Add the information to the database
                using (IDnaDataReader datareader = InputContext.CreateDnaDataReader("getftpuploadqueueforsite"))
                {
                    datareader.Execute();

                    XmlElement uploadQueue = AddElementTag(RootElement, "MEDIAASSETUPLOADQUEUE");
                    AddTextElement(uploadQueue, "ACTION", "showftpuploadqueue");

                    if (datareader.HasRows)
                    {
                        while (datareader.Read())
                        {
                            XmlElement mediaAsset = AddElementTag(uploadQueue, "MEDIAASSET");
                            int mediaAssetID = datareader.GetInt32NullAsZero("MEDIAASSETID");
                            AddAttribute(mediaAsset, "MEDIAASSETID", mediaAssetID);
                            AddIntElement(mediaAsset, "UPLOADSTATUS", datareader.GetInt32NullAsZero("UPLOADSTATUS"));
                            AddTextElement(mediaAsset, "MIMETYPE", datareader.GetStringNullAsEmpty("MIMETYPE"));
                            AddIntElement(mediaAsset, "SITEID", datareader.GetInt32NullAsZero("SITEID"));
                            AddTextElement(mediaAsset, "SERVER", datareader.GetStringNullAsEmpty("SERVER"));
                        }
                    }
                }
            }
            else
            {
                AddErrorXml("Incorrect Permissions", "Must be superuser or editor to look at the queue", RootElement);
            }
        }

        /// <summary>
        /// Public method to allow the caller to remove the media asset linked
		///		to an article's h2g2id
        /// </summary>
        /// <param name="H2G2ID"></param>
        public void RemoveLinkedArticleAsset(int H2G2ID)
        {
            RemoveLinkedArticlesAssets(H2G2ID);

            XmlElement removedMediaAsset = AddElementTag(RootElement, "MEDIAASSETINFO");
            AddTextElement(removedMediaAsset, "ACTION", "RemoveLinkedArticleAsset");
            AddIntElement(removedMediaAsset, "REMOVED", 1);
        }


        /// <summary>
        /// Gets the correct get users media assets depending on the content type
        /// </summary>
        /// <param name="contentType"></param>
        /// <returns>The SP name to call</returns>
        private string GetUsersMediaAssetsSP(int contentType)
        {
            string storedProcedureName = String.Empty;
            if (contentType == 1)
            {
                storedProcedureName = "getusersimageassets";
            }
            else if (contentType == 2)
            {
                storedProcedureName = "getusersaudioassets";
            }
            else if (contentType == 3)
            {
                storedProcedureName = "getusersvideoassets";
            }
            else // if (contentType == 0)
            {
                storedProcedureName = "getusersmediaassets";
            }
            return storedProcedureName;
        }

        /// <summary>
        /// Gets the correct get users articles with assets depending on the content type
        /// </summary>
        /// <param name="contentType"></param>
        /// <returns>The SP name to call</returns>
        string GetUsersArticlesWithMediaAssetsSP(int contentType)
        {
            string storedProcedureName = String.Empty;
            if (contentType == 1)
            {
                storedProcedureName = "getusersarticleswithimageassets";
            }
            else if (contentType == 2)
            {
                storedProcedureName = "getusersarticleswithaudioassets";
            }
            else if (contentType == 3)
            {
                storedProcedureName = "getusersarticleswithvideoassets";
            }
            else // if (contentType == 0)
            {
                storedProcedureName = "getusersarticleswithmediaassets";
            }
            return storedProcedureName;
        }

        /// <summary>
        /// Gets the correct get media asset SP depending on the content type
        /// </summary>
        /// <param name="contentType"></param>
        /// <returns>The SP name to call</returns>
        private string GetMediaAssetSP(int contentType)
        {
            string storedProcedureName = String.Empty;
            if (contentType == 1)
            {
                storedProcedureName = "getimageasset";
            }
            else if (contentType == 2)
            {
                storedProcedureName = "getaudioasset";
            }
            else if (contentType == 3)
            {
                storedProcedureName = "getvideoasset";
            }
            else // if (contentType == 0)
            {
                storedProcedureName = "getmediaasset";
            }
            return storedProcedureName;
        }

 
        /// <summary>
        /// Generate the XML page to show the as particular users Media Assets
        /// </summary>
        /// <param name="mediaAssetParams"></param>
        void ProcessShowUsersArticlesWithMediaAssets(MediaAssetParameters mediaAssetParams)
        {
            string storedProcedureName = GetUsersArticlesWithMediaAssetsSP(mediaAssetParams.ContentType);
            // Get the information from the database
            using (IDnaDataReader datareader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                datareader.AddParameter("userid", mediaAssetParams.UserID);
                datareader.AddParameter("firstindex", mediaAssetParams.Skip);
                datareader.AddParameter("lastindex", mediaAssetParams.Skip + mediaAssetParams.Show);

	            if ( mediaAssetParams.SortBy == "Caption" )
	            {
                    datareader.AddParameter("sortbycaption", 1);
	            }
	            else if ( mediaAssetParams.SortBy == "Rating" )
	            {
                    datareader.AddParameter("sortbyrating", 1);
	            }

	            if ( mediaAssetParams.IsOwner )
	            {
                    datareader.AddParameter("owner", 1);
	            }
                datareader.Execute();

                GenerateUsersArticleAssetsXML(datareader, mediaAssetParams);
            }
        }

        private void ProcessView(MediaAssetParameters mediaAssetParams)
        {
            if (mediaAssetParams.MediaAssetID > 0)
            {
                string storedProcedure = GetMediaAssetSP(mediaAssetParams.ContentType);

                using (IDnaDataReader datareader = InputContext.CreateDnaDataReader(storedProcedure))
                {
                    datareader.AddParameter("mediaassetid", mediaAssetParams.MediaAssetID);
                    datareader.Execute();

                    GenerateMediaAssetXML(datareader, mediaAssetParams);
                }
            }
            else
            {
                AddErrorXml("Incorrect Media Asset ID", "Zero or negative parameter passed in.", RootElement);
            }
        }

        private void ProcessShowUsersMediaAssets(MediaAssetParameters mediaAssetParams)
        {
            if (mediaAssetParams.UserID > 0)
            {
                string storedProcedure = GetUsersMediaAssetsSP(mediaAssetParams.ContentType);

                using (IDnaDataReader datareader = InputContext.CreateDnaDataReader(storedProcedure))
                {
                    datareader.AddParameter("userid", mediaAssetParams.UserID);
                    datareader.AddParameter("firstindex", mediaAssetParams.Skip);
                    datareader.AddParameter("lastindex", mediaAssetParams.Skip + mediaAssetParams.Show);
                    if (mediaAssetParams.SortBy == "Caption")
                    {
                        datareader.AddParameter("sortbycaption", 1);
                    }
                    if (mediaAssetParams.IsOwner)
                    {
                        datareader.AddParameter("owner", 1);
                    }
                    datareader.Execute();

                    GenerateUsersMediaAssetsXML(datareader, mediaAssetParams);
                }
            }
            else
            {
                AddErrorXml("Incorrect User ID", "Zero or negative parameter passed in.", RootElement);
            }
        }

        private void GenerateUsersMediaAssetsXML(IDnaDataReader dataReader, MediaAssetParameters mediaAssetParams)
        {
            int count = 0;
            int total = 0;
            bool more = false;

            XmlElement usersMediaAssets = AddElementTag(_builderRoot, "MEDIAASSETINFO");
            AddAttribute(usersMediaAssets, "CONTENTTYPE", mediaAssetParams.ContentType);
            AddAttribute(usersMediaAssets, "SORTBY", mediaAssetParams.SortBy);
            AddAttribute(usersMediaAssets, "SKIPTO", mediaAssetParams.Skip);
            AddAttribute(usersMediaAssets, "SHOW", mediaAssetParams.Show);
            AddTextElement(usersMediaAssets, "ACTION", "showusersassets");

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, mediaAssetParams.UserID, usersMediaAssets);

                    count = dataReader.GetInt32NullAsZero("COUNT");
                    total = dataReader.GetInt32NullAsZero("TOTAL");
                    if (total > mediaAssetParams.Skip + mediaAssetParams.Show)
                    {
                        more = true;
                    }

                    do
                    {
                        MakeXml(dataReader, usersMediaAssets);
                    } while (dataReader.Read());
                }
            }

            AddAttribute(usersMediaAssets, "COUNT", count);
            AddAttribute(usersMediaAssets, "TOTAL", total);
            AddAttribute(usersMediaAssets, "MORE", more);
        }

        private void GenerateUsersArticleAssetsXML(IDnaDataReader dataReader, MediaAssetParameters mediaAssetParams)
        {
            int count = 0;
            int total = 0;
            bool more = false;

            XmlElement articleAsset = AddElementTag(_builderRoot, "ARTICLEMEDIAASSETINFO");
            AddAttribute(articleAsset, "CONTENTTYPE", mediaAssetParams.ContentType);
            AddAttribute(articleAsset, "SORTBY", mediaAssetParams.SortBy);
            AddAttribute(articleAsset, "SKIPTO", mediaAssetParams.Skip);
            AddAttribute(articleAsset, "SHOW", mediaAssetParams.Show);
            AddTextElement(articleAsset, "ACTION", "showusersarticleswithassets");

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, mediaAssetParams.UserID, articleAsset);

                    count = dataReader.GetInt32NullAsZero("COUNT");
                    total = dataReader.GetInt32NullAsZero("TOTAL");
                    if (total > mediaAssetParams.Skip + mediaAssetParams.Show)
                    {
                        more = true;
                    }

                    do
                    {
                        XmlElement article = AddElementTag(articleAsset, "ARTICLE");
                        AddAttribute(article, "H2G2ID",  dataReader.GetInt32NullAsZero("H2G2ID"));

                        AddTextElement(article, "SUBJECT", dataReader.GetStringNullAsEmpty("SUBJECT"));

                        XmlDocument extrainfo = new XmlDocument();
                        extrainfo.LoadXml(dataReader.GetStringNullAsEmpty("EXTRAINFO"));
                        article.AppendChild(ImportNode(extrainfo.FirstChild));

                        AddDateXml(dataReader, article, "DateCreated", "DATECREATED");
                        AddDateXml(dataReader, article, "LastUpdated", "LASTUPDATED");

                        MakeXml(dataReader, article);

                    } while (dataReader.Read());
                }
            }

            AddAttribute(articleAsset, "COUNT", count);
            AddAttribute(articleAsset, "TOTAL", total);
            AddAttribute(articleAsset, "MORE", more);
        }

        /// <summary>
        /// Generates the XML for a call to view a particular media asset
        /// </summary>
        /// <param name="dataReader"></param>
        /// <param name="mediaAssetParams"></param>
        private void GenerateMediaAssetXML(IDnaDataReader dataReader, MediaAssetParameters mediaAssetParams)
        {
            XmlElement mediaAssetInfo = AddElementTag(_builderRoot, "MEDIAASSETINFO");
            AddTextElement(mediaAssetInfo, "ACTION", "View");
            AddIntElement(mediaAssetInfo, "ID", mediaAssetParams.MediaAssetID);
            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    MakeXml(dataReader, mediaAssetInfo);
                }
            }
        }







        /// <summary>
        /// Removes the the mediaasset ids for a given article (H2G2ID)
        /// </summary>
        /// <param name="H2G2ID"></param>
        void RemoveLinkedArticlesAssets(int H2G2ID)
        {
            // Add the information to the database
            using (IDnaDataReader datareader = InputContext.CreateDnaDataReader("removelinkedarticlesassets"))
            {
                datareader.AddParameter("h2g2id", H2G2ID);
                datareader.Execute();

            }
        }
        /// <summary>
        /// Calls the stored procedure to check the users upload limit 
	    ///        against the new file size (in essence whther to allow the upload or not)
        /// </summary>
        /// <param name="fileLength"></param>
        /// <param name="currentUserID"></param>
        /// <param name="totalUploadSize"></param>
        /// <param name="withinLimit"></param>
        /// <param name="nextLimitStartDate"></param>
        void CheckUsersFileUploadLimit(int fileLength, int currentUserID, ref int totalUploadSize, ref bool withinLimit, ref DateTime nextLimitStartDate)
        {
            // Add the information to the database
            using (IDnaDataReader datareader = InputContext.CreateDnaDataReader("checkusersfileuploadlimit"))
            {
                datareader.AddParameter("filelength", fileLength);
                datareader.AddParameter("userid", currentUserID);
                datareader.Execute();
                if (datareader.HasRows)
                {
                    if (datareader.Read())
                    {
                        totalUploadSize = datareader.GetInt32NullAsZero("TotalUploadSize");
                        withinLimit = datareader.GetBoolean("WithinLimit");
                        nextLimitStartDate = datareader.GetDateTime("NextLimitStartDate");
                    }
                }
            }
        }
        /// <summary>
        /// Generates the XML for the Media Asset object in the case
		/// of the user exceeding the upload limit
        /// </summary>
        /// <param name="fileLength">The length of the file</param>
        /// <param name="totalUploadSize">Total Upload Size</param>
        /// <param name="nextLimitStartDate">Start of the next upload limit period</param>
        void ExceedsUploadLimitErrorInfo(int fileLength, int totalUploadSize, DateTime nextLimitStartDate)
        {
            XmlElement exceededLimit = AddElementTag(_builderRoot, "EXCEEDEDUPLOADLIMITERRORINFO");
            AddIntElement(exceededLimit, "TOTALUPLOADSIZE", totalUploadSize);
            AddIntElement(exceededLimit, "FILELENGTH", fileLength);
            AddDateXml(nextLimitStartDate, exceededLimit, "NEXTLIMITSTARTDATE");
        }

        /// <summary>
        /// Selects the correct image suffix from the mimeType
        /// </summary>
        /// <param name="mimeType"></param>
        /// <param name="fileSuffix"></param>
        /// <returns>Whether the type is supported</returns>
        bool GetImageFormat(string mimeType, ref string fileSuffix)
        {
	        fileSuffix = "unidentified format";

	        if (mimeType == "image/jpeg" || mimeType == "image/pjpeg")
	        {
		        fileSuffix = ".jpg";
	        }
	        else if (mimeType == "image/gif")
	        {
		        fileSuffix = ".gif";
	        }
	        else if (mimeType == "image/bmp")
	        {
		        fileSuffix = ".bmp";
	        }
	        else if (mimeType == "image/png")
	        {
		        fileSuffix = ".png";
	        }
	        else
	        {
		        return false;
	        }
	        return true;
        }
        /// <summary>
        /// Selects the correct audio suffix from the mimeType
        /// </summary>
        /// <param name="mimeType"></param>
        /// <param name="fileSuffix"></param>
        /// <returns>Whether the type is supported</returns>
        bool GetAudioSuffix(string mimeType, ref string fileSuffix)
        {
            fileSuffix = "unidentified format";

            if (mimeType == "audio/mpeg" || mimeType == "audio/mp3")
            {
                fileSuffix = ".mp3";
            }
            else if (mimeType == "audio/mp2")
            {
                fileSuffix = ".mp2";
            }
            else if (mimeType == "audio/wav")
            {
                fileSuffix = ".wav";
            }
            else if (mimeType == "audio/aud")
            {
                fileSuffix = ".aud";
            }
            else if (mimeType == "audio/x-ms-wma")
            {
                fileSuffix = ".wma";
            }
            else
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// Selects the correct video suffix from the mimeType
        /// </summary>
        /// <param name="mimeType"></param>
        /// <param name="fileSuffix"></param>
        /// <returns>Whether the type is supported</returns>
        bool GetVideoSuffix(string mimeType, ref string fileSuffix)
        {
            fileSuffix = "unidentified format";

	        if (mimeType == "video/avi" || mimeType == "video/mpeg" || mimeType == "video/x-msvideo")
            {
                fileSuffix = ".avi";
            }
            else if (mimeType == "application/octet-stream" || mimeType == "video/quicktime")
            {
                fileSuffix = ".mov";
            }
            else if (mimeType == "application/vnd.rn-realmedia")
            {
                fileSuffix = ".rm";
            }
            else if (mimeType == "video/x-ms-wmv")
            {
                fileSuffix = ".wmv";
            }
            else if (mimeType == "application/x-shockwave-flash")
            {
                fileSuffix = ".swf";
            }
            else
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Calls the stored procedure to add the specified Asset onto the
		///		Moderation Queue
		///		NB - Deciding to now do this in the C# service after the asset has been
		///		processed and actually is available to be moderated/looked at.
		///		This may be needed at a later date to re-queue the media asset.
        ///  Re-added in port for completeness
        /// </summary>
        /// <param name="mediaAssetID"></param>
        /// <param name="siteID"></param>
        void QueueMediaAssetForModeration(int mediaAssetID, int siteID)
        {
            // Add the information to the database
            using (IDnaDataReader datareader = InputContext.CreateDnaDataReader("queuemediaassetformoderation"))
            {
                datareader.AddParameter("mediaassetid", mediaAssetID);
                datareader.AddParameter("siteid", siteID);
                datareader.Execute();
            }
        }

        /// <summary>
        /// Function to transpose dodgy mimetypes from the skin into the correct one.
		///        Only correct mimetypes to be stored in the database
        /// </summary>
        /// <param name="inMimeType"></param>
        /// <param name="fixedMimeType"></param>
        /// <returns></returns>
        void FixMimeType(string inMimeType, ref string fixedMimeType)
        {
	        string mimeType = inMimeType.ToUpper();

            if (mimeType == "MP3")
	        {
                fixedMimeType = "audio/mp3";
	        }
	        else if (mimeType == "MP2")
	        {
                fixedMimeType = "audio/mp2";
	        }
	        else if (mimeType == "MP1")
	        {
                fixedMimeType = "audio/mp1";
	        }
	        else if (mimeType == "IMAGE/JPG")
	        {
                fixedMimeType = "image/jpeg";
	        }
	        else if (mimeType == "AVI") 
	        {
                fixedMimeType = "video/avi";		 
	        }
	        else if (mimeType == "WAV") 
	        {
                fixedMimeType = "audio/wav";		 
	        }
	        else if (mimeType == "MOV") 
	        {
                fixedMimeType = "video/quicktime";		 
	        }
	        else if (mimeType == "RM") 
	        {
                fixedMimeType = "application/vnd.rn-realmedia";		 
	        }
	        else if (mimeType == "WMV") 
	        {
                fixedMimeType = "video/x-ms-wmv";		 
	        }
	        else
	        {
                fixedMimeType = inMimeType;
	        }
        }
        /// <summary>
        /// Makes the XML for a Media Asset from the datareader
        /// </summary>
        /// <param name="dataReader"></param>
        /// <returns></returns>
        public XmlNode MakeXml(IDnaDataReader dataReader)
        {
            return MakeXml(dataReader, RootElement);
        }

         /// <summary>
        /// Makes the XML for a Media Asset from the datareader and attache it to the parent element
        /// </summary>
        /// <param name="dataReader"></param>
        /// <param name="parent"></param>
        /// <returns></returns>
        public XmlNode MakeXml(IDnaDataReader dataReader, XmlElement parent)
        {
            _mediaAssetID = dataReader.GetInt32NullAsZero("mediaassetid");
            if (_mediaAssetID == 0)
            {
                return null;
            }

            int ownerID = dataReader.GetInt32NullAsZero("ownerid");
            int hidden = dataReader.GetInt32NullAsZero("hidden");
            int contentType = dataReader.GetInt32NullAsZero("contentType");
            int siteID = dataReader.GetInt32NullAsZero("siteID");

            string caption = dataReader.GetStringNullAsEmpty("caption");
            string filename = dataReader.GetStringNullAsEmpty("filename");
            string mediaassetdescription = dataReader.GetStringNullAsEmpty("description");
            string mimeType = dataReader.GetStringNullAsEmpty("mimetype");
            string externalLinkURL = dataReader.GetStringNullAsEmpty("externallinkurl");

            XmlElement assetXML = AddElementTag(parent, "MEDIAASSET");
            AddAttribute(assetXML, "MEDIAASSETID", _mediaAssetID);

            AddTextElement(assetXML, "FTPPATH", GenerateFTPDirectoryString());
            AddIntElement(assetXML, "SITEID", siteID);
            AddTextElement(assetXML, "CAPTION", caption);
            AddTextElement(assetXML, "FILENAME", filename);
            AddTextElement(assetXML, "MIMETYPE", mimeType);
            AddIntElement(assetXML, "CONTENTTYPE", contentType);

            //TODO : Need to add the keyphrases for the media asset here

            //Extra extendedable element stuff removed for time being
            XmlDocument extraelementinfo = new XmlDocument();
            extraelementinfo.LoadXml("<EXTRAELEMENTXML>" + dataReader.GetStringNullAsEmpty("EXTRAELEMENTXML") + "</EXTRAELEMENTXML>");
            assetXML.AppendChild(ImportNode(extraelementinfo.FirstChild));

            XmlNode owner = AddElementTag(assetXML,"OWNER");
            User user = new User(InputContext);
            user.AddUserXMLBlock(dataReader, ownerID, owner);
            assetXML.AppendChild(owner);

            AddTextElement(assetXML, "MEDIAASSETDESCRIPTION", mediaassetdescription);

            AddDateXml(dataReader, assetXML, "MADateCreated", "DATECREATED");
            AddDateXml(dataReader, assetXML, "MALastUpdated", "LASTUPDATED");

            AddIntElement(assetXML, "HIDDEN", hidden);

            string externalLinkID = String.Empty;
            string externalLinkType = String.Empty;
            string flickrFarmPath = String.Empty;
            string flickrServer = String.Empty;
            string flickrID = String.Empty;
            string flickrSecret = String.Empty;
            string flickrSize = String.Empty;

            GetIDFromLink(externalLinkURL, 
                ref externalLinkID, 
                ref externalLinkType,
                ref flickrFarmPath,
                ref flickrServer,
                ref flickrID,
                ref flickrSecret,
                ref flickrSize);

            AddTextElement(assetXML, "EXTERNALLINKURL", externalLinkURL);
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
                assetXML.AppendChild(flickr);
            }

            AddPollXml(dataReader, assetXML);

            return assetXML;

        }

        /// <summary>
        /// Method that will produce the FTP directory path from the Media Asset ID
        ///	This is for the limit of files within a unix folder to function well
        ///	we basically take the ID and divide it a number of times to get
        ///	sub directories
        /// </summary>
        /// <returns>FTP path</returns>
        private string GenerateFTPDirectoryString(  )
        {
            int firstCut = (_mediaAssetID / FIRSTCUT);
            int secondCut = (_mediaAssetID / SECONDCUT);
            int thirdCut = (_mediaAssetID / THIRDCUT);

            return firstCut + "/" + secondCut + "/" + thirdCut + "/";
        }

        /// <summary>
        /// Method that will produce the FTP directory path from a given Media Asset ID
        ///	This is for the limit of files within a unix folder to function well
        ///	we basically take the ID and divide it a number of times to get
        ///	sub directories
        /// </summary>
        /// <returns>FTP path</returns>
        public static string GenerateFTPDirectoryString(int mediaAssetID)
        {
            int firstCut = (mediaAssetID / FIRSTCUT);
            int secondCut = (mediaAssetID / SECONDCUT);
            int thirdCut = (mediaAssetID / THIRDCUT);

            return firstCut + "/" + secondCut + "/" + thirdCut + "/";
        }

        /// <summary>
        /// Function to generate the ID from the URL Link checks against a YouTube or a Google Video Link
        /// </summary>
        /// <param name="inLink">The url to check</param>
        /// <param name="outID">The specific ID for the type for the site from the url</param>
        /// <param name="outType">The site the url and id is for</param>
        /// <param name="outFlickrFarmPath">Will contain the first section of the flickr link with the farm number</param>
        /// <param name="outFlickrServer">Will contain the server number of the second part of the link</param>
        /// <param name="outFlickrID">Will contain the Flickr image ID</param>
        /// <param name="outFlickrSecret">Will contain the Flickr Secret number</param>
        /// <param name="outFlickrSize">Will contain the Flickr size parameter</param>
        /// <remarks> http://farm2.static.flickr.com/1097/1476511645_99659656ec_t.jpg</remarks>
        /// <returns>Whether we have a known link part</returns>
        public static bool GetIDFromLink(string inLink, ref string outID, ref string outType, ref string outFlickrFarmPath, ref string outFlickrServer, ref string outFlickrID, ref string outFlickrSecret, ref string outFlickrSize)
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

            if (TryGetExternalFlickrIDFromLink(inLink, 
                ref outFlickrFarmPath, 
                ref outFlickrServer, 
                ref outFlickrID, 
                ref outFlickrSecret, 
                ref outFlickrSize))
            {
                outType = "Flickr";
                outID = outFlickrID;
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
        public static bool GetExternalIDFromLink(string inLink, string inPreFix, ref string outExternalID)
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

        /// <summary>
        /// Function to generate the Flickr External image info from the Flick image Link
        /// </summary>
        /// <param name="inLink">The raw link from the website</param>
        /// <param name="outFlickrFarmPath">Will contain the first section of the flickr link with the farm number</param>
        /// <param name="outFlickrServer">Will contain the server number of the second part of the link</param>
        /// <param name="outFlickrID">Will contain the Flickr image ID</param>
        /// <param name="outFlickrSecret">Will contain the Flickr Secret number</param>
        /// <param name="outFlickrSize">Will contain the Flickr size parameter</param>
        /// <remarks> http://farm2.static.flickr.com/1097/1476511645_99659656ec_t.jpg</remarks>
        /// <remarks> [Server farm path]/[server]/[ID]_[Secret]_[size].jpg</remarks>
        /// <returns>Whether we can find we have found a correctly formed flickr link</returns>
        public static bool TryGetExternalFlickrIDFromLink(string inLink, ref string outFlickrFarmPath, ref string outFlickrServer, ref string outFlickrID, ref string outFlickrSecret, ref string outFlickrSize)
        {
            string flickrImagePreFix = @".static.flickr.com/";

            bool OK = false;

            try
            {
                int startFlickrTypePos = inLink.IndexOf(flickrImagePreFix);
                if (startFlickrTypePos > -1)
                {
                    int startServerPos = (startFlickrTypePos + flickrImagePreFix.Length);

                    int startFlickrIDPos = inLink.IndexOf('/', startServerPos + 1) + 1;
                    int startFlickrSecretPos = inLink.IndexOf('_', startFlickrIDPos + 1) + 1;
                    int startFlickrSize = inLink.IndexOf('_', startFlickrSecretPos + 1) + 1;

                    outFlickrFarmPath = inLink.Substring(0, startServerPos);

                    outFlickrServer = inLink.Substring(startServerPos, startFlickrIDPos - startServerPos - 1);
                    outFlickrID = inLink.Substring(startFlickrIDPos, startFlickrSecretPos - startFlickrIDPos - 1);
                    outFlickrSecret = inLink.Substring(startFlickrSecretPos, startFlickrSize - startFlickrSecretPos - 1);
                    outFlickrSize = inLink.Substring(startFlickrSize, 1);

                    if (outFlickrFarmPath != String.Empty && outFlickrServer != String.Empty && outFlickrID != String.Empty && outFlickrSecret != String.Empty && outFlickrSize != String.Empty)
                    {
                        OK = true;
                    }
                }
            }
            catch (ArgumentOutOfRangeException Ex)
            {
                //One of the index or subsstring arguments is outside the constraints of the original string so 
                //mal formed flickr link
                string exceptionMessage = Ex.Message;
                OK = false;
            }
            return OK;
        }

        /// <summary>
        /// AddPollXml - Delegates responsibility of producing standard Poll Xml to the Poll Class.
        /// Only produces Poll Xml where a valid Poll exists in the resultset.
        /// </summary>
        /// <param name="dataReader">Record set containing the data</param>
        /// <param name="parent">Parent node to add the xml to</param>
        private void AddPollXml(IDnaDataReader dataReader, XmlNode parent)
        {
            if (dataReader.DoesFieldExist("CRPollID"))
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
                        parent.AppendChild(ImportNode(node));
                    }
                }
            }
        }
    }
}
