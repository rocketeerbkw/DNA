using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using System.Text.RegularExpressions;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Comments List - A derived DnaInputComponent object to get the list of comments for a user
    /// </summary>
    public class CommentsList : DnaInputComponent
    {
        /// <summary>
        /// Default Constructor for the Comments List object
        /// </summary>
        public CommentsList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Functions generates the Recent Comments List
        /// </summary>
        /// <param name="userID">The user of the comments to get</param>
        /// <param name="siteID">Site of the comments</param>
        /// <param name="skip">Number of comments to skip</param>
        /// <param name="show">Number of comments to show</param>
        /// <returns>Whether created ok</returns>
        public bool CreateRecentCommentsList(int userID, int siteID, int skip, int show)
        {
            // check object is not already initialised
            if (userID <= 0 || show <= 0)
            {
                return false;
            }

            bool showPrivate = false;
            if (InputContext.ViewingUser.UserID != 0 && InputContext.ViewingUser.UserLoggedIn && (userID == InputContext.ViewingUser.UserID || InputContext.ViewingUser.IsEditor))
            {
                showPrivate = true;
            }

            int count = show;

            XmlElement commentsList = AddElementTag(RootElement, "COMMENTS-LIST");
            AddAttribute(commentsList, "SKIP", skip);
            AddAttribute(commentsList, "SHOW", show);

            using (IDnaDataReader dataReader = GetUsersMostRecentComments(userID, siteID, skip, show+1, showPrivate))	// Get +1 so we know if there are more left
            {
                // Check to see if we found anything
                string userName = String.Empty;
                if (dataReader.HasRows && dataReader.Read())
                {
                    User user = new User(InputContext);
                    user.AddUserXMLBlock(dataReader, userID, commentsList);

                    XmlElement comments = CreateElement("COMMENTS");

                    do
                    {
                        // Setup the Comment Tag and Attributes
                        XmlElement comment = CreateElement("COMMENT");

                        AddIntElement(comment, "SiteID", dataReader.GetInt32NullAsZero("SiteID"));

                        // Add the Subject 
                        string subject = dataReader.GetStringNullAsEmpty("Subject");
                        AddXmlTextTag(comment, "SUBJECT", subject);

                        AddDateXml(dataReader, comment, "DatePosted", "DatePosted");

                        // Get the forumid and title
                        AddIntElement(comment, "POSTID", dataReader.GetInt32NullAsZero("EntryID"));
                        AddIntElement(comment, "ForumID", dataReader.GetInt32NullAsZero("ForumID"));
                        AddXmlTextTag(comment, "ForumTitle", dataReader.GetStringNullAsEmpty("ForumTitle"));
                        AddIntElement(comment, "ForumPostCount", dataReader.GetInt32NullAsZero("ForumPostCount"));
                        AddIntElement(comment, "ForumPostLimit", InputContext.GetSiteOptionValueInt("Forum", "PostLimit"));
                        AddTextTag(comment, "URL", dataReader.GetStringNullAsEmpty("URL"));
                        AddIntElement(comment, "PostIndex", dataReader.GetInt32NullAsZero("PostIndex"));

                        // Add the text, checking to see what style it is
                        int postStyle = dataReader.GetTinyIntAsInt("PostStyle");
                        string bodyText = dataReader.GetStringNullAsEmpty("Text");
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
                            //    temp = regex.Replace(temp, @"$1 ");
                            //}
                            //bodyText = temp;
                            bodyText = HtmlUtils.TryParseToValidHtml(temp);

                        }
                        AddElement(comment, "Text", bodyText);

                        AddDateXml(dataReader, comment, "ForumCloseDate", "ForumCloseDate");

                        // Finally close the COMMENT tag
                        comments.AppendChild(comment);
                        count--;

                    } while (count > 0 && dataReader.Read());	// dataReader.Read won't get called if count == 0

                    commentsList.AppendChild(comments);
					// See if there's an extra row waiting
					if (count == 0 && dataReader.Read())
					{
						AddAttribute(commentsList, "MORE", 1);
					}
                }
            }
            //AddAttribute(commentsList, "COUNT", count);

            return true;
        }

        /// <summary>
        /// Removes the Private comments from the list
        /// </summary>
        /// <param name="showPrivate">Whether to show the private posts</param>
        /// <returns></returns>
        void RemovePrivateComments(bool showPrivate)
        {
            if (!showPrivate)
            {
                XmlNodeList postList = RootElement.SelectNodes("COMMENT");
                foreach (XmlElement post in postList)
                {
                    if (post.GetAttribute("PRIVATE") == "1")
                    {
                        post.ParentNode.RemoveChild(post);
                    }
                }
            }
        }

        /// <summary>
        /// Does the correct call to the database to get the most recent comments
        /// </summary>
        /// <param name="userID">The user id to look for</param>
        /// <param name="siteId">SiteID of the comments to get</param>
        /// <param name="skip">The number of comments to skip</param>
        /// <param name="show">The number of comments to show</param>
        /// <param name="showUserHidden"></param>
        /// <returns></returns>
        IDnaDataReader GetUsersMostRecentComments(int userID, int siteId, int skip, int show, bool showUserHidden)
        {
            IDnaDataReader dataReader;

            dataReader = InputContext.CreateDnaDataReader("getusercommentsstats");

            dataReader.AddParameter("userid", userID);
            dataReader.AddParameter("siteid", siteId);
            dataReader.AddParameter("firstindex", skip);
			dataReader.AddParameter("lastindex", skip + show - 1);

            dataReader.Execute();

            return dataReader;
        }
    }
}
