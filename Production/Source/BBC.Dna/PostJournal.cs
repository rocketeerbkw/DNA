using System;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the PostJournal Page object
    /// </summary>
    public class PostJournal : DnaInputComponent
    {
        private const string _docDnaSubject = @"Subject of the journal post";
        private const string _docDnaBody = @"Body of the Journal Post.";
        private const string _docDnaPreview = @"Whether this is a preview.";
        private const string _docDnaPost = @"Whether this is to post.";
        private const string _docDnaProfanityTriggered = @"Whether the post contained a non allowed profanity.";
        private const string _docDnaNonAllowedURLsTriggered = @"Whether the post contained a non allowed URL address.";
        private const string _docDnaEmailAddressTriggered = @"Whether the post contained a non allowed email address.";
        private const string _docDnaStyle = @"Post Style.";

        /// <summary>
        /// Default constructor for the PostJournal component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public PostJournal(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            string body = String.Empty;
            string subject = String.Empty;

            bool preview = false;
            bool post = false;

            int postStyle = 0;
            int profanityTriggered = 0;
            int nonAllowedURLsTriggered = 0;
            int emailAddressTriggered = 0;


            TryGetPageParams(ref body, ref subject, ref preview, ref post, ref postStyle, ref profanityTriggered, ref nonAllowedURLsTriggered, ref emailAddressTriggered);

            TryCreatePostJournalXML(body, subject, preview, post, postStyle, profanityTriggered, nonAllowedURLsTriggered, emailAddressTriggered);
        }


        /// <summary>
        /// Functions generates the TryCreatePostJournal XML
        /// </summary>
        /// <param name="body"></param>
        /// <param name="subject"></param>
        /// <param name="preview"></param>
        /// <param name="post"></param>
        /// <param name="postStyle"></param>
        /// <param name="profanityTriggered"></param>
        /// <param name="nonAllowedURLsTriggered"></param>
        /// <param name="emailAddressTriggered"></param>
        private void TryCreatePostJournalXML(string body, string subject, bool preview, bool post, int postStyle, int profanityTriggered, int nonAllowedURLsTriggered, int emailAddressTriggered)
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            Forum forum = new Forum(InputContext);
                
            XmlElement previewBody = CreateElement("PREVIEWBODY");

            if (InputContext.ViewingUser.UserID == 0 || InputContext.ViewingUser.UserLoggedIn == false || InputContext.ViewingUser.IsBanned)
            {
                XmlElement postJournalFail = AddElementTag(RootElement, "POSTJOURNALUNREG");
                if (InputContext.ViewingUser.UserID != 0)
                {
                    AddAttribute(postJournalFail, "RESTRICTED", 1);
                    AddAttribute(postJournalFail, "REGISTERED", 1);
                }
                return;
            }
            else if ((post || preview) && (postStyle == 1))
            {
                XmlDocument previewDoc = new XmlDocument();
                try
                {
                    previewDoc.LoadXml(body);
                    XmlElement richPostText = AddElementTag(previewBody, "RICHPOST");
                    richPostText.AppendChild(ImportNode(previewDoc.FirstChild));
                }
                catch(System.Xml.XmlException ex)
                {
                    AddErrorXml("PARSE-ERROR", ex.Message, previewBody);
                    post = false;
                }               
            }
            XmlElement warning = null;

	        if ((post || preview) && (subject == String.Empty))
	        {
                //XmlElement warning = AddTextTag(addToJournal, "WARNING", "You must type a Subject for your Journal Entry");
                //AddAttribute(warning, "TYPE", "SUBJECT");

                warning = CreateElement("WARNING");
                AddAttribute(warning, "TYPE", "SUBJECT");
                warning.InnerText = "You must type a Subject for your Journal Entry.";
	        }
	        else if ((post || preview) && (body == String.Empty))
	        {
                warning = CreateElement("WARNING");
                AddAttribute(warning, "TYPE", "EMPTYBODY");
                warning.InnerText = "Your Journal Entry cannot be empty.";
	        }
	        else if ((post || preview) && (body.Length > 200*1024))
	        {
                warning = CreateElement("WARNING");
                AddAttribute(warning, "TYPE", "TOOLONG");
                warning.InnerText = "Your posting is too long.";
	        }
	        else if (postStyle != 1 && (post || preview)/* && /*(!StringUtils.ConvertPlainText(body, 200))*/)
	        {
                warning = CreateElement("WARNING");
                AddAttribute(warning, "TYPE", "TOOMANYSMILEYS");
                warning.InnerText = "Your posting contained too many smileys.";
	        }
            else if (post)
            {
                // TODO Actually post the page
                int userID = 0;
                int journalID = 0;
                string userName = String.Empty;

                userID = InputContext.ViewingUser.UserID;
                journalID = InputContext.ViewingUser.Journal;
                userName = InputContext.ViewingUser.UserName;

                bool profanityFound = false;
                bool nonAllowedURLsFound = false;
                bool emailAddressFound = false;

                //Try and post to the users journal
                forum.PostToJournal(userID, journalID, userName, subject,
                    body, InputContext.CurrentSite.SiteID, postStyle, ref profanityFound, ref nonAllowedURLsFound, ref emailAddressFound);

                if (profanityFound && profanityTriggered == 0)
                {
                    profanityTriggered = 1;
                }
                else if (nonAllowedURLsFound && nonAllowedURLsTriggered == 0)
                {
                    nonAllowedURLsTriggered = 1;
                }
                else if (emailAddressFound && emailAddressTriggered == 0)
                {
                    emailAddressTriggered = 1;
                }
                else
                {
                    string redirect = "U" + userID.ToString();
                    AddDnaRedirect(redirect);
                    return;
                }
            }

            XmlElement postJournalForm = AddElementTag(RootElement, "POSTJOURNALFORM");
            AddAttribute(postJournalForm, "STYLE", postStyle);
            AddAttribute(postJournalForm, "PROFANITYTRIGGERED", profanityTriggered);
            AddAttribute(postJournalForm, "NONALLOWEDURLSTRIGGERED", nonAllowedURLsTriggered);
            AddAttribute(postJournalForm, "NONALLOWEDEMAILSTRIGGERED", emailAddressTriggered);

            AddTextTag(postJournalForm, "SUBJECT", subject);
            AddTextTag(postJournalForm, "BODY", body);

            if (previewBody.HasChildNodes || subject.Length > 0)
            {
                if (postStyle != 1)
                {
                    previewBody.InnerText = body;
                }
                postJournalForm.AppendChild(previewBody);
            }

            if (warning != null)
            {
                postJournalForm.AppendChild(warning);
            }

            if (InputContext.CurrentSite.ModerationStatus == ModerationStatus.SiteStatus.PreMod)
            {
                AddIntElement(postJournalForm, "PREMODERATION", 1);
            }
            else if (InputContext.ViewingUser.IsPreModerated)
            {
                XmlElement preMod = AddIntElement(postJournalForm, "PREMODERATION", 1);
                AddAttribute(preMod, "USER", 1);
            }
        }
        
        /// <summary>
        /// Gets the params for the page
        /// </summary>
        /// <param name="body"></param>
        /// <param name="subject"></param>
        /// <param name="preview"></param>
        /// <param name="post"></param>
        /// <param name="postStyle"></param>
        /// <param name="profanityTriggered"></param>
        /// <param name="nonAllowedURLsTriggered"></param>
        /// <param name="emailAddressTriggered"></param>
        private void TryGetPageParams(ref string body,ref string subject,ref bool preview,ref bool post,ref int postStyle,ref int profanityTriggered,ref int nonAllowedURLsTriggered,ref int emailAddressTriggered)
        {

            body = InputContext.GetParamStringOrEmpty("subject", _docDnaSubject);
            subject = InputContext.GetParamStringOrEmpty("body", _docDnaBody);

            preview = InputContext.DoesParamExist("preview", _docDnaPreview);
            post = InputContext.DoesParamExist("post", _docDnaPost);
            postStyle = InputContext.GetParamIntOrZero("style", _docDnaStyle);
            profanityTriggered = InputContext.GetParamIntOrZero("profanitytriggered", _docDnaProfanityTriggered);
            nonAllowedURLsTriggered = InputContext.GetParamIntOrZero("nonallowedurltriggered", _docDnaNonAllowedURLsTriggered);
            emailAddressTriggered = InputContext.GetParamIntOrZero("nonallowedemailtriggered", _docDnaEmailAddressTriggered);

            if (postStyle < 1 || postStyle > 2)
            {
                postStyle = 2;
            }

        }
    }
}
