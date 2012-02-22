﻿using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;
using BBC.Dna.Common;
using BBC.Dna.Api;
using System.Xml.Linq;
using System.Collections.Generic;
using System.Xml;
using System.Text.RegularExpressions;

namespace BBC.Dna
{
    /// <summary>
    /// The ViewReadOnlyForumComments object
    /// </summary>
    public class ForumCommentsList : DnaInputComponent
    {
        private int _siteId = 0;
        private int _forumId = 0;
        //private SiteType? _type = null;
        private int _userId = 0;
        //private DateTime? _startDate =null;
        private int _startIndex = 0;
        //private int _itemsPerPage = 50;
        private bool _ignoreCache = false;

        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public ForumCommentsList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Assemble page parts.
            RootElement.RemoveAll();
            GetQueryParameters();

            if (_userId == 0)
            {
                return;
            }

            var siteName = string.Empty;
            if(_siteId != 0)
            {
                siteName = InputContext.TheSiteList.GetSite(_siteId).SiteName;
            }

            var commentsListObj = new Comments(InputContext.Diagnostics, AppContext.ReaderCreator, AppContext.DnaCacheManager, InputContext.TheSiteList);

            commentsListObj.StartIndex = _startIndex;

            var CommentsList = commentsListObj.GetCommentsListByForumId(_forumId, InputContext.CurrentSite);

            string str = StringUtils.SerializeToXmlReturnAsString(CommentsList);

            var actualXml = str.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
            actualXml = actualXml.Replace("xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"BBC.Dna.Api\"","").Trim();

            //Making all the XML Nodes uppercase
            actualXml = StringUtils.ConvertXmlTagsToUppercase(actualXml);

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(actualXml);
            XmlNode appendNode = doc.DocumentElement;

            XmlAttribute newForumIdAttr = doc.CreateAttribute("FORUMID");
            newForumIdAttr.Value = _forumId.ToString();
            appendNode.Attributes.Append(newForumIdAttr);

            XmlAttribute newSiteNameAttr = doc.CreateAttribute("SITENAME");
            newSiteNameAttr.Value = siteName;
            appendNode.Attributes.Append(newSiteNameAttr);

            ImportAndAppend(appendNode, "");
        }

       

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");

            _forumId = InputContext.GetParamIntOrZero("s_forumid", "s_forumid");
            
            _userId = InputContext.ViewingUser.UserID;
            if (InputContext.DoesParamExist("s_user", "test userid"))
            {
                _userId = InputContext.GetParamIntOrZero("s_user", "test userid");
            }

            if (InputContext.DoesParamExist("s_startindex", "startindex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startindex", "s_startindex");
            }

#if DEBUG
            _ignoreCache = InputContext.GetParamIntOrZero("ignorecache", "Ignore the cache") == 1;
#endif
        }

        #region GetViewReadOnlyCommentsXml

        private XmlDocument GetViewReadOnlyCommentsXml(CommentsList commentInfoList, int forumId, string siteName)
        {
            XmlDocument xmlDoc = new XmlDocument();
            XElement readOnlyElement = new XElement("READONLYCOMMENTS", 
                                             new XAttribute("FORUMID",forumId.ToString()),
                                             new XAttribute("SITENAME", siteName),
                                                from c in commentInfoList.comments
                                                select new XElement("COMMENTINFO", new XElement("uri",c.Uri.ToString()),
                                                    new XElement("TEXT",c.text.ToString()), new XElement("CREATED",c.Created.ToString()),
                                                    new XElement("USERID",c.User.UserId.ToString()), new XElement("USERNAME",c.User.DisplayName),
                                                    new XElement("ID", c.ID.ToString()), new XElement("POSTSTYLE", c.PostStyle.ToString()), 
                                                    new XElement("COMPLAINTURI",c.ComplaintUri.ToString()), new XElement("FORUMURI",c.ForumUri.ToString()),
                                                    new XElement("STATUS",c.hidden.ToString()), new XElement("ISEDITORPICK",c.IsEditorPick.ToString()),
                                                    new XElement("INDEX",c.Index.ToString()), new XElement("NERORATINGVALUE",c.NeroRatingValue.ToString()),
                                                    new XElement("TWEETID", c.TweetId.ToString())));

            using (XmlReader xmlReader = readOnlyElement.CreateReader())
            {
                xmlDoc = new XmlDocument();
                xmlDoc.Load(xmlReader);
            }

            return xmlDoc;

        }

        #endregion

    }
}
