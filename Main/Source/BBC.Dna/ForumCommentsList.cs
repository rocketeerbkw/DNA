using BBC.Dna.Api;
using BBC.Dna.Common;
using BBC.Dna.Utils;
using System.Linq;
using System.Xml;
using System.Xml.Linq;

namespace BBC.Dna
{
    /// <summary>
    /// The ViewReadOnlyForumComments object
    /// </summary>
    public class ForumCommentsList : DnaInputComponent
    {
        private int _siteId = 0;
        private int _forumId = 0;
        private string _forumTitle = string.Empty;
        private int _userId = 0;
        private int _startIndex = 0;
        private bool _displayContactFormPosts = false;

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
            if (_siteId != 0)
            {
                siteName = InputContext.TheSiteList.GetSite(_siteId).SiteName;
            }

            var commentsListObj = new Comments(InputContext.Diagnostics, AppContext.ReaderCreator, AppContext.DnaCacheManager, InputContext.TheSiteList);

            commentsListObj.StartIndex = _startIndex;
            if (_displayContactFormPosts)
            {
                commentsListObj.FilterBy = FilterBy.ContactFormPosts;
                commentsListObj.SortDirection = SortDirection.Descending;
            }

            var CommentsList = commentsListObj.GetCommentsListByForumId(_forumId, InputContext.CurrentSite);

            string str = StringUtils.SerializeToXmlReturnAsString(CommentsList);

            var actualXml = str.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
            actualXml = actualXml.Replace(" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"BBC.Dna.Api\"", "").Trim();

            //Making all the XML Nodes uppercase
            actualXml = StringUtils.ConvertXmlTagsToUppercase(actualXml);

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(actualXml);
            XmlNode appendNode = doc.DocumentElement;

            if (_displayContactFormPosts)
            {
                RenderContactDetails(appendNode);
            }

            XmlAttribute newForumIdAttr = doc.CreateAttribute("FORUMID");
            newForumIdAttr.Value = _forumId.ToString();
            appendNode.Attributes.Append(newForumIdAttr);

            XmlAttribute newForumTitleAttr = doc.CreateAttribute("FORUMTITLE");
            newForumTitleAttr.Value = _forumTitle;
            appendNode.Attributes.Append(newForumTitleAttr);

            XmlAttribute newSiteNameAttr = doc.CreateAttribute("SITENAME");
            newSiteNameAttr.Value = siteName;
            appendNode.Attributes.Append(newSiteNameAttr);

            ImportAndAppend(appendNode, "");
        }

        private void RenderContactDetails(XmlNode contactList)
        {
            string body = "";
            string subject = "";
            string sentFrom = "";
            XmlNodeList details = contactList.SelectNodes("/COMMENTSLIST/COMMENTS/COMMENT");
            foreach (XmlNode detail in details)
            {
                XmlNode text = detail.FirstChild.NextSibling;
                Contacts.TryParseContactFormMessage(text.InnerText, false, ref subject, ref body, ref sentFrom);
                body = HtmlUtils.HtmlEncode(body);
                try
                {
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml("<TEXT>" + body.Trim().Replace("\n", "<br/>") + "</TEXT>");
                    text.InnerXml = doc.FirstChild.InnerXml;
                }
                catch
                {
                    text.InnerText = body;
                }
            }
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");

            _forumId = InputContext.GetParamIntOrZero("s_forumid", "s_forumid");

            _forumTitle = InputContext.GetParamStringOrEmpty("s_title", "s_title");

            _userId = InputContext.ViewingUser.UserID;
            if (InputContext.DoesParamExist("s_user", "test userid"))
            {
                _userId = InputContext.GetParamIntOrZero("s_user", "test userid");
            }

            if (InputContext.DoesParamExist("s_startindex", "startindex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startindex", "s_startindex");
            }

            if (InputContext.DoesParamExist("s_displaycontactformposts", "Display contact form posts?"))
            {
                _displayContactFormPosts = true;
            }
        }

        #region GetViewReadOnlyCommentsXml

        private XmlDocument GetViewReadOnlyCommentsXml(CommentsList commentInfoList, int forumId, string siteName)
        {
            XmlDocument xmlDoc = new XmlDocument();
            XElement readOnlyElement = new XElement("READONLYCOMMENTS",
                                             new XAttribute("FORUMID", forumId.ToString()),
                                             new XAttribute("SITENAME", siteName),
                                                from c in commentInfoList.comments
                                                select new XElement("COMMENTINFO", new XElement("uri", c.Uri.ToString()),
                                                    new XElement("TEXT", c.text.ToString()), new XElement("CREATED", c.Created.ToString()),
                                                    new XElement("USERID", c.User.UserId.ToString()), new XElement("USERNAME", c.User.DisplayName),
                                                    new XElement("ID", c.ID.ToString()), new XElement("POSTSTYLE", c.PostStyle.ToString()),
                                                    new XElement("COMPLAINTURI", c.ComplaintUri.ToString()), new XElement("FORUMURI", c.ForumUri.ToString()),
                                                    new XElement("STATUS", c.hidden.ToString()), new XElement("ISEDITORPICK", c.IsEditorPick.ToString()),
                                                    new XElement("INDEX", c.Index.ToString()), new XElement("NERORATINGVALUE", c.NeroRatingValue.ToString()),
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
