using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna;
using BBC.Dna.Component;
using System.Text.RegularExpressions;
using BBC.Dna.Utils;
using BBC.Dna.Api;

namespace BBC.Dna
{
    /// <summary>
    /// Class to build xml for a forum post
    /// </summary>
    public class ForumPost /*: DnaComponent*/
    {
        /// <summary>
        /// Method to generate POST XML and add to a parent node 
        /// </summary>
        /// <param name="reader">DataReader result of stored procedure returning forum post data.</param>
        /// <param name="component">DnaComponent to add posts to.</param>
        /// <param name="parentNode">Parent Node to xml the generated xml to.</param>
        /// <param name="context">The Input Context</param>
        public static void AddPostXml(IDnaDataReader reader, DnaComponent component, XmlNode parentNode, IInputContext context)
        {
            int hidden = 0;
            int inReplyTo = 0;
            int prevSibling = 0;
            int nextSibling = 0;
            int firstChild = 0;
            int userID = 0;
            int entryId = 0;
            int threadId = 0;
            int postIndex = 0;

            string subject = String.Empty;
            string datePosted = String.Empty;
            string bodyText = String.Empty;
            string hostPageUrl = String.Empty;
            string commentForumTitle = String.Empty;

            //get from db
            if (reader.DoesFieldExist("parent"))
            {
                inReplyTo = reader.GetInt32NullAsZero("parent");
            }
            if (reader.DoesFieldExist("prevSibling"))
            {
                prevSibling = reader.GetInt32NullAsZero("prevSibling");
            }
            if (reader.DoesFieldExist("nextSibling"))
            {
                nextSibling = reader.GetInt32NullAsZero("nextSibling");
            }
            if (reader.DoesFieldExist("firstChild"))
            {
                firstChild = reader.GetInt32NullAsZero("firstChild");
            }
            if (reader.DoesFieldExist("userID"))
            {
                userID = reader.GetInt32NullAsZero("userID");
            }
            if (reader.DoesFieldExist("hidden"))
            {
                hidden = reader.GetInt32NullAsZero("hidden");
            }

            subject = String.Empty;
            if (hidden == 3) // 3 means premoderated! - hidden!
            {
                subject = "Hidden";
            }
            else if (hidden > 0)
            {
                subject = "Removed";
            }
            else
            {
                subject = reader["subject"] as string;
                subject = StringUtils.EscapeAllXml(subject);
            }

            datePosted = String.Empty;
            if (reader["datePosted"] != DBNull.Value)
            {
                datePosted = reader["datePosted"].ToString();
            }

            bodyText = String.Empty;
            if (hidden == 3) // 3 means premoderated! - hidden!
            {
                bodyText = "This post has been hidden";
            }
            else if (hidden > 0)
            {
                bodyText = "This post has been Removed";
            }
            else
            {
                bodyText = reader.GetStringNullAsEmpty("text");
            }

            byte postStyle = reader.GetByteNullAsZero("postStyle");

            if (postStyle != 1)
            {
                bodyText = StringUtils.ConvertPlainText(bodyText);
            }
            else
            {
                //TODO Do we need Rich Post stuff for the post style??
                string temp = "<RICHPOST>" + bodyText.Replace("\r\n", "<BR />").Replace("\n", "<BR />") + "</RICHPOST>";
                //Regex regex = new Regex(@"(<[^<>]+)<BR \/>");
                //while (regex.Match(temp).Success)
                //{
                //    temp = regex.Replace(temp,@"$1 ");
                //}
                //bodyText = temp;
                bodyText = HtmlUtils.TryParseToValidHtml(temp);
            }

            if (reader.DoesFieldExist("hostpageurl"))
            {
                hostPageUrl = reader.GetStringNullAsEmpty("hostpageurl");
            }
            if (reader.DoesFieldExist("commentforumtitle"))
            {
                commentForumTitle = reader.GetStringNullAsEmpty("commentforumtitle");
            }

            if (reader.DoesFieldExist("entryID"))
            {
                entryId = reader.GetInt32NullAsZero("entryID");
            }

            if (reader.DoesFieldExist("threadID"))
            {
                threadId = reader.GetInt32NullAsZero("threadID");
            }

            if (reader.DoesFieldExist("postindex"))
            {
                postIndex = reader.GetInt32NullAsZero("postindex");
            }

            string canRead = String.Empty;
            if (reader.DoesFieldExist("canRead"))
            {
                canRead = reader.GetByteNullAsZero("canRead").ToString();
            }
            string canWrite = String.Empty;
            if (reader.DoesFieldExist("canWrite"))
            {
                canWrite = reader.GetByteNullAsZero("canWrite").ToString();
            }


            XmlNode post = component.CreateElementNode("POST");
            User user = new User(context);
            user.AddUserXMLBlock(reader, userID, post);

            AddPostXmlInternal(component, parentNode, context, hidden, inReplyTo, prevSibling, nextSibling, 
                firstChild, userID, subject, datePosted, bodyText, hostPageUrl, commentForumTitle, entryId, threadId,
                postIndex, canRead, canWrite, post.ChildNodes[0]);
        }

        /// <summary>
        /// Generates post xml for a comment forum and comment
        /// </summary>
        /// <param name="forum"></param>
        /// <param name="comment"></param>
        /// <param name="component"></param>
        /// <param name="parentNode"></param>
        /// <param name="context"></param>
        /// <param name="postIndex"></param>
        public static void AddCommentXml(CommentForum forum, CommentInfo comment, DnaComponent component, XmlNode parentNode, IInputContext context, int postIndex)
        {
            int hidden = (int)comment.hidden;
            
            //default threading to 0
            int inReplyTo = 0;
            int prevSibling = 0;
            int nextSibling = 0;
            int firstChild = 0;
            int threadId = 0;

            int userID = comment.User.UserId;
            int entryId = comment.ID;
            string canRead = forum.CanRead?"1":"0";
            string canWrite = (forum.CanWrite && !forum.isClosed) ?"1":"0";
            string subject = StringUtils.EscapeAllXml(forum.Title);
            if (hidden == 3) // 3 means premoderated! - hidden!
            {
                subject = "Hidden";
            }
            else if (hidden > 0)
            {
                subject = "Removed";
            }
            string datePosted = comment.Created.At;
            string bodyText = comment.FormatttedText;
            bodyText = System.Web.HttpUtility.HtmlDecode(bodyText);
            bodyText = HtmlUtils.TryParseToValidHtml("<RICHPOST>" + bodyText + "</RICHPOST>");
            string hostPageUrl = forum.ParentUri;
            string commentForumTitle = forum.Title;

            User user = new User(context);
            XmlNode userNode = component.ImportNode(user.GenerateUserXml(comment.User.UserId, comment.User.DisplayName, String.Empty, String.Empty, String.Empty
                , comment.User.Status, 0, true, 0.0, String.Empty, String.Empty, String.Empty, comment.User.Journal, DateTime.MinValue,
                0, 0, DateTime.MinValue, forum.ForumID, 0, 0, 0));

            AddPostXmlInternal(component, parentNode, context, hidden, inReplyTo, prevSibling, nextSibling,
                firstChild, userID, subject, datePosted, bodyText, hostPageUrl, commentForumTitle, entryId, threadId,
                postIndex, canRead, canWrite, userNode);
        }


        /// <summary>
        /// Internal actually generates the xml
        /// </summary>
        /// <param name="component"></param>
        /// <param name="parentNode"></param>
        /// <param name="context"></param>
        /// <param name="hidden"></param>
        /// <param name="inReplyTo"></param>
        /// <param name="prevSibling"></param>
        /// <param name="nextSibling"></param>
        /// <param name="firstChild"></param>
        /// <param name="userID"></param>
        /// <param name="subject"></param>
        /// <param name="datePosted"></param>
        /// <param name="bodyText"></param>
        /// <param name="hostPageUrl"></param>
        /// <param name="commentForumTitle"></param>
        /// <param name="entryId"></param>
        /// <param name="threadId"></param>
        /// <param name="postIndex"></param>
        /// <param name="canRead"></param>
        /// <param name="canWrite"></param>
        /// <param name="userNode"></param>
        private static void AddPostXmlInternal(DnaComponent component, XmlNode parentNode, 
            IInputContext context, int hidden, int inReplyTo, int prevSibling, int nextSibling, int firstChild, 
            int userID, string subject, string datePosted, string bodyText, string hostPageUrl, string commentForumTitle,
            int entryId, int threadId, int postIndex, string canRead, string canWrite, XmlNode userNode)
        {
            // start creating the post structure
            XmlNode post = component.CreateElementNode("POST");
            component.AddAttribute(post, "POSTID", entryId);
            component.AddAttribute(post, "THREAD", threadId);
            // We have an incrementing index field for the next and
            // previous buttons
            component.AddAttribute(post, "INDEX", postIndex);

            // This *might* be useful...
            if (inReplyTo > 0)
            {
                component.AddAttribute(post, "INREPLYTO", inReplyTo.ToString());
            }
            if (prevSibling > 0)
            {
                component.AddAttribute(post, "PREVSIBLING", prevSibling.ToString());
            }
            if (nextSibling > 0)
            {
                component.AddAttribute(post, "NEXTSIBLING", nextSibling.ToString());
            }
            if (firstChild > 0)
            {
                component.AddAttribute(post, "FIRSTCHILD", firstChild.ToString());
            }

            component.AddAttribute(post, "HIDDEN", hidden.ToString());

            // Add the CanRead and CanWrite For the thread
            if (!String.IsNullOrEmpty(canRead))
            {
                component.AddAttribute(post, "CANREAD", canRead);
            }
            if (!String.IsNullOrEmpty(canWrite))
            {
                component.AddAttribute(post, "CANWRITE", canWrite);
            }

            // TODO: Should we escape this text?
            component.AddTextTag(post, "SUBJECT", subject);

            XmlElement date = DnaDateTime.GetDateTimeAsElement(component.RootElement.OwnerDocument, datePosted);
            component.AddElement(post, "DATEPOSTED", date);

            //add user node
            post.AppendChild(userNode);

            XmlNode textnode = component.AddElement(post, "TEXT", bodyText);

            if (bodyText.Contains("http"))
            {
                XmlNodeList nodes = textnode.SelectNodes(".//text()[contains(.,'http')]");
                foreach (XmlNode node in nodes)
                {
                    // Split this node into: Everything before the URL, a LINK element,
                    // then everything after
                    DnaComponent.MakeLinksFromUrls(node);
                }
            }

            if (hostPageUrl != String.Empty)
            {
                component.AddTextElement((XmlElement)post, "HOSTPAGEURL", hostPageUrl);
            }
            if (commentForumTitle != String.Empty)
            {
                component.AddTextElement((XmlElement)post, "COMMENTFORUMTITLE", commentForumTitle);
            }


            parentNode.AppendChild(post);
        }

        
    }
}
