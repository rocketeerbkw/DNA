using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Component;
using System.Web.Caching;
using BBC.Dna.Utils;
using BBC.Dna.Moderation;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// 
    /// </summary>
    public class CommentForumListBuilder : DnaInputComponent
    {

        private const string _docDnaShow = @"The number of comment forums to show.";
        private const string _docDnaSkip = "The number of comment forums to skip";
        private const string _docDnaListNs = @"The prefix for a UID. Used to group related comment forums";
        private const string _docDnaListCount = @"The maxium number of comment forum details rows to return";
        private bool _skipUidProcessing = false;
        private bool _skipUrlProcessing = false;

        private bool _displayContactForms = false;

        private readonly ICacheManager _cache;
        private int _forumId = 1;
        private string _cmd = String.Empty;
        private int _termId;

        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="inputContext"></param>
        public CommentForumListBuilder(IInputContext inputContext)
            : base(inputContext)
        {

            _cache = CacheFactory.GetCacheManager();
        }

        /// <summary>
        /// 
        /// </summary>
        public bool SkipUidProcessing
        {
            set 
            { 
                _skipUidProcessing = value; 
            }
        }

        /// <summary>
        /// Property to indicate whether the dnahostpageurl parameter is used.
        /// </summary>
        public bool SkipUrlProcessing
        {
            set
            {
                _skipUrlProcessing = value;
            }
        }

        /// <summary>
        /// Method called to try and get the comment forum list. 
        /// </summary>
        public void TryGetCommentForumList()
        {
            int siteID = 0;
            string hostpageurl = String.Empty;
            int show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
            int skip = 0;
            int dnaUidCount = 0;
            string[] dnaUids;
            string dnaListNs = String.Empty;
            int dnaListCount = 0;

            GetPageParams(ref siteID, ref hostpageurl, ref skip, ref show, ref dnaUidCount, out dnaUids, ref dnaListNs, ref dnaListCount);

            BaseResult result = ProcessCommand(siteID, skip, show);
            if (result != null)
            {
                SerialiseAndAppend(result, "");
            }

            if (_displayContactForms)
            {
                // Hand over all work to the Contact forms builder
                ContactFormListBuilder contactForms = new ContactFormListBuilder(InputContext);
                ImportAndAppend(contactForms.GetContactFormsAsXml(),"");
            }
            else if (hostpageurl == String.Empty || _skipUrlProcessing == true)
            {
                if (dnaUidCount != 0 && _skipUidProcessing != true)
                {
                    GeneratePageXmlByDnaUids(dnaUids);
                }
                else if (dnaListNs.CompareTo("") != 0)
                {
                    GeneratePageXmlByPrefix(dnaListNs, dnaListCount, siteID);
                }
                else if (siteID == 0)
                {
                    GeneratePageXmlAll(skip, show);
                }
                else
                {
                    GeneratePageXmlBySite(siteID, skip, show);
                }
            }
			else if (hostpageurl.Length > 0)
			{
				GeneratePageXmlByUrl(hostpageurl, skip, show);
			}
        }

        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private BaseResult ProcessCommand(int siteID, int skip, int show)
        {
            switch (_cmd.ToUpper())
            {
                case "SHOWUPDATEFORM":
                    return null;//do nothing - this is just for the skins...

                case "UPDATETERMS":
                    {
                        BaseResult result = UpdateTerm();
                        if (result.IsError())
                        {
                            return result;
                        }
                        ProfanityFilter.GetObject().SendSignal();
                        return new Result("TermsUpdateSuccess & SiteRefreshSuccess", "Terms filter by Forum refresh initiated.");
                    }
            }
            return null;
        }


        /// <summary>
        /// Checks the parameters and updates the term passed in
        /// </summary>
        /// <returns></returns>
        private BaseResult UpdateTerm()
        {
            var forumId = InputContext.GetParamIntOrZero("forumid", "Forum ID");
            if (forumId == 0)   
            {
                return new Error { Type = "UPDATETERM", ErrorMessage = "Forum ID cannot be 0." };
            }
            var termText = InputContext.GetParamStringOrEmpty("termtext", "the text of the term");
            string[] terms = termText.Split('\n');
            terms = terms.Where(x => x != String.Empty).Distinct().ToArray();
            if (terms.Length == 0)
            {
                return new Error { Type = "UPDATETERMMISSINGTERM", ErrorMessage = "Terms text must contain newline delimited terms." };
            }
            var termReason = InputContext.GetParamStringOrEmpty("reason", "Reason for the term added.").Trim();
            if (string.IsNullOrEmpty(termReason))
            {
                return new Error { Type = "UPDATETERMMISSINGDESCRIPTION", ErrorMessage = "Term reason cannot be empty." };
            }
            string actionParam = string.Format("action_forumid_all");
            TermAction termAction;
            if (Enum.IsDefined(typeof(TermAction), InputContext.GetParamStringOrEmpty(actionParam, "Forum action value")))
            {
                termAction = (TermAction)Enum.Parse(typeof(TermAction), InputContext.GetParamStringOrEmpty(actionParam, "Forum action value"));
            }
            else
            {
                return new Error { Type = "UPDATETERMINVALIDACTION", ErrorMessage = "Terms action invalid." };
            }
            var termsLists = new TermsLists();
            var termList = new TermsList(forumId, false, true);
            foreach (var term in terms)
            {
                termList.Terms.Add(new TermDetails { Value = term, Action = termAction });
            }
            termsLists.Termslist.Add(termList);
            BaseResult error = termsLists.UpdateTermsInDatabase(InputContext.CreateDnaDataReaderCreator(), _cache, termReason.Trim(),
                                           InputContext.ViewingUser.UserID, false);

            if (error == null)
            {
                //Send email to the distribution list
                SendTermUpdateEmail(terms, forumId, termReason.Trim(), termAction, InputContext.ViewingUser.UserID);

                return new Result("TermsUpdateSuccess", String.Format("{0} updated successfully.", terms.Length == 1 ? "Term" : "Terms"));
            }

            return error;
        }

		/// <summary>
		/// This can be called on a page which needs lists of comments, like the BlogSummary pages
		/// It removes the logic for this type of data from the commentforumlist page which doesn't require
		/// those lists
		/// </summary>
		public void GetCommentListsFromUids()
		{
			int siteID = 0;
			string hostpageurl = String.Empty;
			int show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
			int skip = 0;
			int dnaUidCount = 0;
			string[] dnaUids;
			string dnaListNs = String.Empty;
			int dnaListCount = 0;

			GetPageParams(ref siteID, ref hostpageurl, ref skip, ref show, ref dnaUidCount, out dnaUids, ref dnaListNs, ref dnaListCount);
			if (dnaUidCount != 0)
			{
				GeneratePageXmlByDnaUids(dnaUids);
			}


			//if (hostpageurl.Length > 0)
			//{
			//    GeneratePageXmlByUrl(hostpageurl, skip, show);
			//}
		}

		/// <summary>
		/// If the dna_list_ns parameter exists, this will generate a list of recent posts
		/// and a list of recent threads commented on
		/// </summary>
		public void GetCommentListsFromUidPrefix()
		{
			int siteID = 0;
			string hostpageurl = String.Empty;
			int show = InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");
			int skip = 0;
			int dnaUidCount = 0;
			string[] dnaUids;
			string dnaListNs = String.Empty;
			int dnaListCount = 0;

			GetPageParams(ref siteID, ref hostpageurl, ref skip, ref show, ref dnaUidCount, out dnaUids, ref dnaListNs, ref dnaListCount);

			if (dnaListNs.Length > 0)
			{
				GeneratePageXmlByPrefix(dnaListNs, dnaListCount, siteID);
			}
		}

        /// <summary>
        /// Gets a comment forum list from a supplied uid prefix.
        /// </summary>
        /// <param name="dnaListNs">The prefix of the uid.</param>
        /// <param name="dnaListCount">The number of comment forums to retrieve.</param>
        /// <param name="siteID">Allow filtering on given site.</param>
        private void GeneratePageXmlByPrefix(string dnaListNs, int dnaListCount, int siteID)
        {
            string cacheKey = dnaListNs + Convert.ToString(siteID) + "Checker";

            object cacheChecker = InputContext.GetCachedObject(cacheKey);
            if (cacheChecker != null)
            {
                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Using cache - " + cacheKey);

                //use cached object
                object cacheData = InputContext.GetCachedObject(dnaListNs + Convert.ToString(siteID) + "CachedData");
                if (cacheData != null)
                {
                    RootElement.AppendChild(ImportNode((XmlNode)cacheData));
                }
            }
            else
            {
                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Not using cache - " + cacheKey);
                DateTime lastUpdated = DateTime.Now;
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getcommentforumcachedependencycheck"))
                {
                    dataReader.AddParameter("@prefix", dnaListNs + '%');
                    dataReader.AddParameter("@siteid", siteID);
                    dataReader.Execute();
                    if (dataReader.HasRows)
                    {
                        dataReader.Read();
                        lastUpdated = dataReader.GetDateTime("LastUpdated");
                    }
                }
                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Last updated - " + lastUpdated.ToString());

                object cachedDateObj = InputContext.GetCachedObject(dnaListNs + Convert.ToString(siteID) + "CachedDate");
                DateTime cachedDate = DateTime.MinValue;
                if (cachedDateObj != null)
                {
                    cachedDate = (DateTime)cachedDateObj;
                }

                InputContext.Diagnostics.WriteToLog("CFL by Prefix", "CachedDate - " + cachedDate.ToString());

                if (cachedDate < lastUpdated)
                {
                    InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Cached Date is less than last Updated - " + cacheKey);

                    InputContext.CacheObject(dnaListNs + Convert.ToString(siteID) + "CachedDate", lastUpdated, 10000000);
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getcommentforumlistbyuidprefix"))
                    {
                        dataReader.AddParameter("@prefix", dnaListNs + '%')
                            .AddParameter("@count", dnaListCount)
                            .AddParameter("@siteid", siteID);
                        dataReader.Execute();

                        GenerateCommentForumListXml(dataReader, 0, dnaListCount, 0, String.Empty);
                        InputContext.CacheObject(cacheKey, "checkString", 10);
                        InputContext.CacheObject(dnaListNs + Convert.ToString(siteID) + "CachedData", RootElement.FirstChild, 1000000);
                    }
                }
                else
                {
                    InputContext.Diagnostics.WriteToLog("CFL by Prefix", "Cached Date not less than last Updated - " + cacheKey);
                    
                    //use cached object
                    InputContext.CacheObject(cacheKey, "checkString", 10);
                    object cacheData = InputContext.GetCachedObject(dnaListNs + Convert.ToString(siteID) + "CachedData");
                    if (cacheData != null)
                    {
                        RootElement.AppendChild(ImportNode((XmlNode)cacheData));
                    }
                }
            }
        }

        /// <summary>
        /// Gets the complete comment forum list with skip and show from the database from the params and then generates the page xml
        /// </summary>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        private void GeneratePageXmlAll(int skip, int show)
        {
            string getCommentForumList = "getcommentforumlist";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForumList))
            {
                dataReader.AddParameter("@skip", skip)
                    .AddParameter("@show", show);

                dataReader.Execute();
                GenerateCommentForumListXml(dataReader, skip, show, 0, String.Empty);
            }
        }

        /// <summary>
        /// Gets the comment forum list by site id with skip and show from the database from the params and then generates the page xml
        /// </summary>
        /// <param name="siteID">site id of comment lists to return for</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        private void GeneratePageXmlBySite(int siteID, int skip, int show)
        {
            string getCommentForumList = "getcommentforumlistbysite";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForumList))
            {
                dataReader.AddParameter("@siteid", siteID)
                    .AddParameter("@skip", skip)
                    .AddParameter("@show", show);

                dataReader.Execute();
                GenerateCommentForumListXml(dataReader, skip, show, siteID, String.Empty);
            }
        }

        /// <summary>
        /// Gets the comment forum list by hostpageurl with skip and show from the database from the params and then generates the page xml
        /// </summary>
        /// <param name="hostpageurl">hostpage url to match comment lists for</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        private void GeneratePageXmlByUrl(string hostpageurl, int skip, int show)
        {
            string getCommentForumList = "getcommentforumlistbyurl";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(getCommentForumList))
            {
                dataReader.AddParameter("@url", hostpageurl)
                    .AddParameter("@skip", skip)
                    .AddParameter("@show", show);

                dataReader.Execute();
                GenerateCommentForumListXml(dataReader, skip, show, 0, hostpageurl);
            }
        }

        /// <summary>
        /// Get the comment from list from a collection of dnauids
        /// </summary>
        /// <param name="dnaUids">String Array containing the dnauids to return data for.</param>
        private void GeneratePageXmlByDnaUids(string[] dnaUids)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getcommentforumlistbydnauids"))
            {
                string sb = "";
                foreach (string s in dnaUids)
                {
                    sb += "<dnauid>" + StringUtils.EscapeAllXmlForAttribute(s) + "</dnauid>";
                }

                reader.AddParameter("@dnauids", sb.ToString());
                reader.Execute();
                GenerateCommentForumListXml(reader, 0, 200, 0, String.Empty);
            }
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="siteID">site id of comment lists to return for otherwise current site.</param>
        /// <param name="hostpageurl">hostpage url to match comment lists for</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        /// <param name="dnaUidCount">Number of dnauids specified to retrieve comment forum data for.</param>
        /// <param name="dnaUids">Array of dnauid values.</param>
        /// <param name="dnaListNs">Namespace prefix for the dna uid</param>
        /// <param name="dnaListCount">Count comment forum details to return related by the dna uid namespace</param>
        private void GetPageParams(ref int siteID, ref string hostpageurl, ref int skip, ref int show, ref int dnaUidCount, out string[] dnaUids, ref string dnaListNs, ref int dnaListCount)
        {
            //Default to current site unless stated.
            siteID = InputContext.CurrentSite.SiteID;
            if (InputContext.DoesParamExist("dnasiteid", "SiteID Filter"))
            {
                siteID = InputContext.GetParamIntOrZero("dnasiteid", @"Site ID filter of the all the Comment Forums to return");
            }

            hostpageurl = InputContext.GetParamStringOrEmpty("dnahostpageurl", @"Hostpageurl filter of all the Comment Forums to return");
            int defaultShow = 20;// InputContext.GetSiteOptionValueInt("CommentForum", "DefaultShow");

            dnaUidCount = InputContext.GetParamCountOrZero("u", "0, 1 or more dnauids");
                        
            dnaListNs = InputContext.GetParamStringOrEmpty("dnacommentforumlistprefix", _docDnaListNs);
            dnaListCount = InputContext.GetParamIntOrZero("dnalistcount", _docDnaListCount);
            if (dnaListNs != String.Empty && dnaListCount == 0)
            {
                dnaListCount = 10;
            }

            if (dnaUidCount > 0)
            {
                dnaUids = new string[dnaUidCount];
                for (int i = 0; i < dnaUidCount; i++)
                {
                    dnaUids[i] = InputContext.GetParamStringOrEmpty("u", i, "dnauid");
                }
            }
            else
            {
                dnaUids = new string[] { "" };
            }

            skip = InputContext.GetParamIntOrZero("dnaskip", _docDnaSkip);
            show = InputContext.GetParamIntOrZero("dnashow", _docDnaShow);
            if (show > 200)
            {
                show = 200;
            }
            else if (show < 1)
            {
                show = defaultShow;
            }

            if(InputContext.DoesParamExist("s_termid", "The id of the term to check"))
            {
                _termId = InputContext.GetParamIntOrZero("s_termid", "The id of the term to check");
            }

            if (InputContext.DoesParamExist("forumid", "Forum ID"))
            {
                _forumId = InputContext.GetParamIntOrZero("forumid", "Forum ID");
            }

            if (InputContext.DoesParamExist("action", "Command string for flow"))
            {
                _cmd = InputContext.GetParamStringOrEmpty("action", "Command string for flow");
            }

            if (InputContext.DoesParamExist("displaycontactforms", "display the contact forms?"))
            {
                _displayContactForms = true;
            }
        }

        /// <summary>
        /// Creates the XML fragment for the Comment CommentBoxForum List
        /// </summary>
        /// <param name="dataReader">The SP reader</param>
        /// <param name="skip">Number of comment forums to skip</param>
        /// <param name="show">Number of comment forums to show</param>
        /// <param name="requestedSiteIDFilter">The requested Site Id filter if present</param>
        /// <param name="requestedUrlFilter">The requested HostPageUrl filter if present</param>
        public void GenerateCommentForumListXml(IDnaDataReader dataReader, int skip, int show, int requestedSiteIDFilter, string requestedUrlFilter)
        {
            XmlNode commentForumList = CreateElementNode("COMMENTFORUMLIST");
            int commentForumListCount = 0;

            if (dataReader.HasRows)
            {
                if (dataReader.Read())
                {
                    commentForumListCount = dataReader.GetInt32NullAsZero("CommentForumListCount");
                }
            }

            AddAttribute(commentForumList, "COMMENTFORUMLISTCOUNT", commentForumListCount);
            AddAttribute(commentForumList, "SKIP", skip);
            AddAttribute(commentForumList, "SHOW", show);

            if (requestedUrlFilter == String.Empty)
            {
                AddAttribute(commentForumList, "REQUESTEDSITEID", requestedSiteIDFilter);
            }
            else
            {
                AddAttribute(commentForumList, "REQUESTEDURL", StringUtils.EscapeAllXmlForAttribute(requestedUrlFilter));
            }

            //int returnedCount = 20;
            int actualForumListCount = 0;
            if (commentForumListCount > 0)
            {
                do
                {
                    AddCommentForumListXML(dataReader, commentForumList);
                    actualForumListCount++;
					// returnedCount--;
                } while (/*returnedCount > 0 &&*/ dataReader.Read());
            }

            //TODO: Move this to the right place
            RootElement.AppendChild(commentForumList);
        }

        /// <summary>
        /// Generates the individual Comment CommentBoxForum Xml within the Comment CommentBoxForum List xml page
        /// </summary>
        /// <param name="dataReader">SP containing the comment forums</param>
        /// <param name="commentForumList">Parent node to attach to</param>
        private void AddCommentForumListXML(IDnaDataReader dataReader, XmlNode commentForumList)
        {
            // start creating the comment forum structure
            XmlNode commentForum = CreateElementNode("COMMENTFORUM");
            AddAttribute(commentForum, "UID", dataReader.GetStringNullAsEmpty("uid"));
            AddAttribute(commentForum, "FORUMID", dataReader.GetInt32NullAsZero("forumID").ToString());
            AddAttribute(commentForum, "FORUMPOSTCOUNT", dataReader.GetInt32NullAsZero("forumpostcount").ToString());
            AddAttribute(commentForum, "FORUMPOSTLIMIT", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
            AddAttribute(commentForum, "CANWRITE", dataReader.GetByteNullAsZero("CanWrite").ToString());

            AddTextTag(commentForum, "HOSTPAGEURL", dataReader.GetStringNullAsEmpty("url"));
            AddTextTag(commentForum, "TITLE", dataReader.GetStringNullAsEmpty("title"));
            AddTextTag(commentForum, "MODSTATUS", dataReader.GetByteNullAsZero("ModerationStatus"));
            AddTextTag(commentForum, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
            AddTextTag(commentForum, "FASTMOD", dataReader.GetInt32NullAsZero("fastmod"));

            if (dataReader.DoesFieldExist("DateCreated") && !dataReader.IsDBNull("DateCreated"))
            {
                DateTime dateCreated = dataReader.GetDateTime("DateCreated");
                AddElement(commentForum, "DATECREATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateCreated));
            }

            if (dataReader.DoesFieldExist("ForumCloseDate") && !dataReader.IsDBNull("ForumCloseDate"))
            {
                DateTime closeDate = dataReader.GetDateTime("ForumCloseDate");
                AddElement(commentForum, "CLOSEDATE", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, closeDate));
            }

            if (dataReader.DoesFieldExist("LastUpdated") && !dataReader.IsDBNull("LastUpdated"))
            {
                DateTime dateLastUpdated = dataReader.GetDateTime("LastUpdated");
                AddElement(commentForum, "LASTUPDATED", DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, dateLastUpdated));
            }

            int forumId = dataReader.GetInt32NullAsZero("forumID");
            //get terms admin object
            TermsFilterAdmin termsAdmin = TermsFilterAdmin.CreateForumTermAdmin(InputContext.CreateDnaDataReaderCreator(), _cache, forumId, true);
            XmlDocument termNodeDoc = SerialiseToXmlDoc(termsAdmin);
            string termNodeText = termNodeDoc.DocumentElement.InnerXml.ToString();
            AddXmlTextTag(commentForum, "TERMS", termNodeText);

            commentForumList.AppendChild(commentForum);
        }

        /// <summary>
        /// Send the email to the configured recipients once a term is added/updated
        /// </summary>
        /// <param name="terms"></param>
        /// <param name="forumId"></param>
        /// <param name="termReason"></param>
        /// <param name="termAction"></param>
        /// <param name="userId"></param>
        private void SendTermUpdateEmail(string[] terms, int forumId, string termReason, TermAction termAction, int userId)
        {
            #region local var(s) declaration

            var _forumTitle = string.Empty;
            var _forumURL = string.Empty;
            var _siteId = InputContext.CurrentSite.SiteID;
            var _emailSubject = string.Empty;
            var _emailBody = string.Empty;
            
            #region Terms Details

            var _emailCustomBody = string.Empty;
            var _termAction = string.Empty;

            var _strTerms = String.Join(",", terms.ToArray());

            _emailCustomBody += "\r\n" + "Terms    : " + _strTerms + "\r\n";
            _emailCustomBody += "Reason   : " + termReason + "\r\n";
            
            switch(termAction)
            {
                case TermAction.Refer:
                    _termAction = "Send to moderation";
                    break;
                case TermAction.ReEdit:
                    _termAction = "Ask to re-edit"; 
                    break;
                case TermAction.NoAction:
                    _termAction = "Terms deleted";
                    break;
            }

            _emailCustomBody += "Action   : " + _termAction + "\r\n";
            _emailCustomBody += "Author   : " + InputContext.ViewingUser.UserName + "\r\n";
            _emailCustomBody += "DateTime : " + System.DateTime.Now.ToString();

            #endregion

            var _sender = InputContext.ViewingUser.Email;

            var _recipient = System.Configuration.ConfigurationManager.AppSettings["ModerateEmailGroup"].ToString();
            _recipient += ";" + InputContext.CurrentSite.EditorsEmail;
            _recipient += ";" + InputContext.ViewingUser.Email;

            var _termsFilterLink = "https://ssl.bbc.co.uk/dna/moderation/admin/termsfilterimport";

            #endregion

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getcommentforumdetailsbyforumid"))
            {
                dataReader.AddParameter("@forumid", forumId);
                dataReader.Execute();
                if (true == dataReader.HasRows && true == dataReader.Read())
                {
                    _forumTitle = dataReader.GetStringNullAsEmpty("TITLE");
                    _forumURL = dataReader.GetStringNullAsEmpty("URL");
                }
            }
           
            EmailTemplates.FetchEmailText(InputContext.CreateDnaDataReaderCreator(), _siteId, "TermsAddedToCommentForumEmail", out _emailSubject, out _emailBody);
    
            _emailBody = _emailBody.Replace("++**forum_title**++", _forumTitle);
            _emailBody = _emailBody.Replace("++**forum_url**++", _forumURL);
            _emailBody = _emailBody.Replace("++**term_details**++", _emailCustomBody);
            _emailBody = _emailBody.Replace("++**terms_filter**++", _termsFilterLink);
            _emailBody = _emailBody.Replace("++**new_line**++", "\r\n");
            _emailSubject = _emailSubject.Replace("++**forum_title**++", _forumTitle);


            try
            {
                //Actually send the email.
                DnaMessage sendMessage = new DnaMessage(InputContext);
                sendMessage.SendEmailOrSystemMessage(userId, _recipient, _sender, _siteId, _emailSubject, _emailBody);
            }
            catch (DnaEmailException e)
            {
                AddErrorXml("EMAIL", "Unable to send email." + e.Message, RootElement);
            }
           
        }

    }
}
