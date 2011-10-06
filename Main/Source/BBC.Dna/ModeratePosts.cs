using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Moderation;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.DNA.Moderation.Utils;
using System.Xml.Linq;

namespace BBC.Dna.Component
{
    /// <summary>
    /// 
    /// </summary>
    public class ModeratePosts : DnaInputComponent
    {
        

        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModeratePosts(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public override void ProcessRequest()
        {

            bool alerts = InputContext.GetParamBoolOrFalse("alerts", "Moderation Alerts");
            bool referrals = InputContext.GetParamBoolOrFalse("referrals", "Refered Items");
            bool locked = InputContext.GetParamBoolOrFalse("locked", "Locked Items");
            bool fastMod = InputContext.GetParamBoolOrFalse("fastmod", "!Fast Moderation");
            int modClassId = InputContext.GetParamIntOrZero("modclassid", "Moderation Class Id");
            int postId = InputContext.GetParamIntOrZero("postfilterid", "PostId Filter");
            int show = InputContext.GetParamIntOrZero("show", "Number of Items");
            if (show == 0)
            {
                show = 10;
            }

            // Process Input
            ProcessSubmission();

            if (InputContext.DoesParamExist("done","Redirect"))
            {
                String redir = InputContext.GetParamStringOrEmpty("redirect", "Redirect");
                //AddDnaRedirect("moderate?newstyle=1");
                XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                AddAttribute(redirect, "URL", redir);
                return;
            }

            // Generate XML
            GenerateXml(alerts, referrals, locked, fastMod, InputContext.ViewingUser.UserID, modClassId, postId, show);
            
            // Get a list of all the sites.
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            RootElement.AppendChild(ImportNode(siteXml.GenerateAllSitesXml(InputContext.TheSiteList).FirstChild));

            // Get a list of site options for all sites.
            RootElement.AppendChild(ImportNode(siteXml.GetSiteOptionListXml(InputContext.TheSiteList)));

            //Get Moderation Resons for current moderation class
            ModerationReasons modReasons = new ModerationReasons(InputContext);
            RootElement.AppendChild(ImportNode(modReasons.GenerateXml(modClassId)) );

            //Get Distress Messages for current Moderation Class
            ModerationDistressMessages mdm = new ModerationDistressMessages(InputContext);
            RootElement.AppendChild(ImportNode(mdm.GenerateXml(modClassId)));
            
        }

        /// <summary>
        /// Generates XML for ModeratePost page.
        /// </summary>
        private void GenerateXml( bool alerts, bool referrals, bool locked, bool fastMod, int userId, int modClassId, int postId, int show )
        {
            XmlElement postMod = AddElementTag(RootElement, "POSTMODERATION");
            AddAttribute(postMod, "MODCLASSID", modClassId);

            if (alerts)
            {
                AddAttribute(postMod, "ALERTS", 1);
            }
            if (referrals)
            {
                AddAttribute(postMod, "REFERRALS", 1);
            }
            if (locked)
            {
                AddAttribute(postMod, "LOCKEDITEMS", 1);
            }

            if (fastMod)
            {
                AddAttribute(postMod, "FASTMOD", 1);
            }

            string storedProcedureName = "getmoderationposts";
            if (modClassId > 0)
            {
                var moderationClassList = ModerationClassListCache.GetObject();
                var modClass = moderationClassList.ModClassList.First(x => x.ClassId == modClassId);

                if (modClass != null)
                {
                    switch(modClass.ItemRetrievalType)
                    {
                        case ModerationRetrievalPolicy.LIFO:
                            storedProcedureName = "getmoderationpostsmostrecentfirst"; break;
                        case ModerationRetrievalPolicy.PriorityFirst:
                            storedProcedureName = "getmoderationpostsfastmodfirst"; break;
                        default:
                            storedProcedureName = "getmoderationposts"; break;
                    }
                }
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                if (referrals)
                {
                    dataReader.AddParameter("status", ModerationItemStatus.Refer);
                }

                dataReader.AddParameter("userid", userId);
                dataReader.AddParameter("alerts", alerts);
                dataReader.AddParameter("lockeditems", locked);
                dataReader.AddParameter("issuperuser", InputContext.ViewingUser.IsSuperUser);
                dataReader.AddParameter("modclassid", modClassId);
                if (postId > 0)
                {
                    dataReader.AddParameter("postid", postId);
                }
                dataReader.AddParameter("duplicatecomplaints", postId > 0 && alerts);
                dataReader.AddParameter("show", show);
                dataReader.AddParameter("fastmod", fastMod);
                dataReader.Execute();

                if (!dataReader.HasRows)
                {
                    AddAttribute(postMod, "COUNT", 0);
                }

                if (dataReader.Read())
                {
                    AddAttribute(postMod, "COUNT", dataReader.GetInt32NullAsZero("count"));
                    do
                    {
                        XmlElement post = AddElementTag(postMod, "POST");

                        if (!dataReader.IsDBNull("commentforumurl"))
                        {
                            // Create a link to the comment forum to view item in context.
                            String commentForumUrl = dataReader.GetStringNullAsEmpty("commentforumurl");
                            int defaultShow = InputContext.GetSiteOptionValueInt(dataReader.GetInt32NullAsZero("siteid"), "commentforum", "defaultshow");
                            int postIndex = dataReader.GetInt32NullAsZero("postindex");
                            commentForumUrl += @"?dnafrom=" + postIndex + @"&dnato=" + Convert.ToString(postIndex + defaultShow - 1) + @"#P" + Convert.ToString(dataReader.GetInt32NullAsZero("entryid"));
                            AddAttribute(post, "COMMENTFORUMURL", commentForumUrl);
                        }

                        if (!dataReader.IsDBNull("parent"))
                        {
                            AddAttribute(post, "INREPLYTO", dataReader.GetInt32("parent"));
                        }

                        AddAttribute(post, "POSTID", dataReader.GetInt32NullAsZero("entryid"));

                        int modTermMappingId = 0;
                        modTermMappingId = Convert.ToInt32(dataReader.GetInt32NullAsZero("modid").ToString());

                        AddAttribute(post, "MODERATIONID", dataReader.GetInt32NullAsZero("modid"));
                        AddAttribute(post, "THREADID", dataReader.GetInt32NullAsZero("threadid"));
                        AddAttribute(post, "FORUMID", dataReader.GetInt32NullAsZero("forumid"));
                        AddAttribute(post, "ISPREMODPOSTING", dataReader.GetTinyIntAsInt("ispremodposting"));
                        AddAttribute(post, "ISPRIORITYPOST", dataReader.GetTinyIntAsInt("priority"));
                        //AddAttribute(post, "MODCLASSID", dataReader.GetInt32NullAsZero("modclassid"));
                        AddIntElement(post, "MODERATION-STATUS", dataReader.GetInt32NullAsZero("threadmoderationstatus"));

                        int siteId = dataReader.GetInt32NullAsZero("siteid");
                        AddIntElement(post, "SITEID", siteId);
                        if (!dataReader.IsDBNull("topictitle"))
                        {
                            AddTextTag(post, "TOPICTITLE", dataReader.GetStringNullAsEmpty("topictitle"));
                        }
                        AddTextTag(post, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));

                        AddTextTag(post, "RAWTEXT", StringUtils.StripInvalidXmlChars(dataReader.GetStringNullAsEmpty("text")));
                        
                        String translated = ThreadPost.FormatPost(dataReader.GetStringNullAsEmpty("text"), CommentStatus.Hidden.NotHidden, true, false);
                        if (!dataReader.IsDBNull("commentforumurl"))
                        {
                            translated = CommentInfo.FormatComment(dataReader.GetStringNullAsEmpty("text"), BBC.Dna.Api.PostStyle.Style.richtext, CommentStatus.Hidden.NotHidden, false);
                        }

                        IDnaDataReaderCreator creator = new DnaDataReaderCreator(AppContext.TheAppContext.Config.ConnectionString, AppContext.TheAppContext.Diagnostics);
                        var termsList = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, modTermMappingId, false);
                        if (termsList != null && termsList.Terms != null && termsList.Terms.Count > 0)
                        {
                            foreach (TermDetails termDetails in termsList.Terms)
                            {
                                if (true == translated.Contains(termDetails.Value))
                                {
                                    translated = translated.Replace(termDetails.Value, "<TERMFOUND ID=" + "\"" + termDetails.Id.ToString() + "\"" + "> " + termDetails.Value + "</TERMFOUND>");
                                }
                            }
                        }

                        //translated = translated.Replace("\r\n", "<BR/>");
                        AddXmlTextTag(post, "TEXT", translated );

                        String notes = dataReader.GetStringNullAsEmpty("notes");
                        notes = notes.Replace("\r\n", "<BR/>");
                        AddXmlTextTag(post, "NOTES", notes );

                        //Adds the term details to the Term node
                        //IDnaDataReaderCreator creator = new DnaDataReaderCreator(AppContext.TheAppContext.Config.ConnectionString, AppContext.TheAppContext.Diagnostics);
                        XmlElement termXml = AddElementTag(post, "TERMS");
                        //var termsList = TermsList.GetTermsListByThreadModIdFromThreadModDB(creator, modTermMappingId, false);
                        if (termsList.Terms.Count > 0)
                        {
                            foreach (TermDetails termDetails in termsList.Terms)
                            {
                                XmlNode termDetailsNode = SerialiseAndAppend(termDetails, "/DNAROOT/POSTMODERATION/POST");
                                termXml.AppendChild(termDetailsNode);
                            }
                        }


                        XmlElement lockedXml = AddElementTag(post, "LOCKED");
                        AddDateXml(dataReader.GetDateTime("datelocked"), lockedXml, "DATELOCKED");
                        XmlElement lockedUserXml = AddElementTag(lockedXml, "USER");
                        AddIntElement(lockedUserXml, "USERID", dataReader.GetInt32NullAsZero("lockedby"));
                        AddTextTag(lockedUserXml, "USERNAME", dataReader.GetStringNullAsEmpty("lockedname"));
                        AddTextTag(lockedUserXml, "FIRSTNAMES", dataReader.GetStringNullAsEmpty("lockedfirstnames"));
                        AddTextTag(lockedUserXml, "LASTNAME", dataReader.GetStringNullAsEmpty("lockedlastname"));

                        //Author Xml is restricted
                        if (InputContext.ViewingUser.IsSuperUser || InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsReferee)
                        {
                            XmlElement authorXml = AddElementTag(post, "USER");
                            int authorId = dataReader.GetInt32NullAsZero("userid");
                            AddIntElement(authorXml, "USERID", authorId);
                            AddTextTag(authorXml, "USERNAME", dataReader.GetStringNullAsEmpty("username"));
                            AddTextTag(authorXml, "FIRSTNAMES", dataReader.GetStringNullAsEmpty("firstnames"));
                            AddTextTag(authorXml, "LASTNAME", dataReader.GetStringNullAsEmpty("lastname"));
                            if ( !dataReader.IsDBNull("prefstatus"))
                            {
                                XmlElement statusXml = AddElementTag(authorXml, "STATUS");
                                AddAttribute(statusXml, "STATUSID", dataReader.GetInt32NullAsZero("prefstatus"));
                                AddAttribute(statusXml, "DURATION", dataReader.GetInt32NullAsZero("prefstatusduration"));
                                if ( !dataReader.IsDBNull("prefstatuschangeddate"))
                                {
                                    AddDateXml(dataReader.GetDateTime("prefstatuschangeddate"), statusXml, "STATUSCHANGEDDATE");
                                }
                            }

                            string groupsXml = UserGroupsHelper.GetUserGroupsAsXml(authorId, siteId, InputContext);
                            XmlDocument groups = new XmlDocument();
                            groups.LoadXml(groupsXml);
                            if (groups.HasChildNodes)
                            {
                                XmlNode importNode = ImportNode(groups.FirstChild);
                                authorXml.AppendChild(importNode);
                            }
                        }

                        if (alerts)
                        {
                            XmlElement alertXml = AddElementTag(post, "ALERT");
                            int complainantId = dataReader.GetInt32NullAsZero("complainantid");

                            XmlElement alertUserXml = AddElementTag(alertXml, "USER");
                            AddIntElement(alertUserXml, "USERID", complainantId);
                            AddTextTag(alertUserXml, "USERNAME", dataReader.GetStringNullAsEmpty("complainantname"));
                            AddTextTag(alertUserXml, "FIRSTNAMES", dataReader.GetStringNullAsEmpty("complainantfirstnames"));
                            AddTextTag(alertUserXml, "LASTNAME", dataReader.GetStringNullAsEmpty("complainantlastname"));
                            AddIntElement(alertUserXml, "COMPLAINANTIDVIAEMAIL", dataReader.GetInt32NullAsZero("ComplainantIDViaEmail"));
                            
                            if ( !dataReader.IsDBNull("complainantprefstatus"))
                            {
                                XmlElement status = AddElementTag(alertUserXml, "STATUS");
                                AddAttribute(status, "STATUSID", dataReader.GetInt32NullAsZero("complainantprefstatus"));
                                AddAttribute(status, "DURATION", dataReader.GetInt32NullAsZero("complainantprefstatusduration"));
                                if (!dataReader.IsDBNull("complainantprefstatuschangeddate"))
                                {
                                    AddDateXml(dataReader.GetDateTime("complainantprefstatuschangeddate"), alertUserXml, "STATUSCHANGEDDATE");
                                }
                            }

                            // Add Complainant Groups
                            string groupsXml = UserGroupsHelper.GetUserGroupsAsXml(complainantId, siteId, InputContext);
                            XmlDocument groups = new XmlDocument();
                            groups.LoadXml(groupsXml);
                            if (groups.HasChildNodes)
                            {
                                XmlNode importNode = ImportNode(groups.FirstChild);
                                alertUserXml.AppendChild(importNode);
                            }

                            AddTextTag(alertXml, "TEXT", dataReader.GetStringNullAsEmpty("complainttext"));
                            AddDateXml(dataReader.GetDateTime("datequeued"), alertXml, "DATEQUEUED");
                            AddIntElement(alertXml, "ALERTCOUNT", dataReader.GetInt32NullAsZero("complaintcount"));
                        }

                        if (referrals)
                        {
                            XmlElement referXml = AddElementTag(post, "REFERRED");
                            XmlElement referUserXml = AddElementTag(referXml, "USER");
                            AddIntElement(referUserXml, "USERID", dataReader.GetInt32NullAsZero("referrerid"));
                            AddTextTag(referUserXml, "USERNAME", dataReader.GetStringNullAsEmpty("referrername"));
                            AddTextTag(referUserXml, "FIRSTNAMES", dataReader.GetStringNullAsEmpty("referrerfirstnames"));
                            AddTextTag(referUserXml, "LASTNAME", dataReader.GetStringNullAsEmpty("referrerlastname"));
                            AddIntElement(referUserXml, "STATUS", dataReader.GetInt32NullAsZero("referrerstatus"));
                            AddDateXml(dataReader.GetDateTime("datereferred"), referXml, "DATEREFERRED");
                        }
                    } while (dataReader.Read());
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void ProcessSubmission()
        {
            int posts = InputContext.GetParamCountOrZero("postid", "PostId");
            for (int i = 0; i < posts; ++i)
            {
                int threadId = InputContext.GetParamIntOrZero("threadid", i, "ThreadId");
                int forumId = InputContext.GetParamIntOrZero("forumid", i, "ForumId");
                int postId = InputContext.GetParamIntOrZero("postid", i, "PostId");
                int modId = InputContext.GetParamIntOrZero("modid", i, "ModId");
                ModerationItemStatus decision = (ModerationItemStatus)InputContext.GetParamIntOrZero("decision", i, "Moderation Decision");
                int referId = InputContext.GetParamIntOrZero("referto", i, "Refer");
                int siteId = InputContext.GetParamIntOrZero("siteid", i, "SiteId");
                int threadModStatus = InputContext.GetParamIntOrZero("threadmoderationstatus", i, "Thread Moderation Status");

                bool sendEmail = InputContext.GetSiteOptionValueBool(siteId, "Moderation", "DoNotSendEmail") == false;
                String notes = InputContext.GetParamStringOrEmpty("notes",i, "Moderator Notes");
                String emailType = InputContext.GetParamStringOrEmpty("emailtype",i, "Email Template Insert Text");
                
                // Custom Email Text should be either removed URLs or a custom entry.
                String customText = InputContext.GetParamStringOrEmpty("customemailtext",i, "Custom Email Text");

                // Handle PreMod Postings
                bool preModPosting = false;
                if (postId == 0)
                {
                    bool create = decision == ModerationItemStatus.PassedWithEdit;
                    using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("checkpremodpostingexists"))
                    {
                        dataReader.AddParameter("modid", modId);
                        dataReader.AddParameter("create", create);
                        dataReader.Execute();

                        if (dataReader.Read())
                        {
                            preModPosting = dataReader.DoesFieldExist("modid");
                            if (create)
                            {
                                postId = dataReader.GetInt32NullAsZero("postid");
                                threadId = dataReader.GetInt32NullAsZero("threadid");
                            }
                        }
                    }
                }

                // Edit the post.
                if (decision == ModerationItemStatus.PassedWithEdit)
                {
                    String subject = InputContext.GetParamStringOrEmpty("editpostsubject",i, "Edit Post Subject");
                    String body = InputContext.GetParamStringOrEmpty("editposttext",i, "Edit Post Body");
                    int userId = InputContext.ViewingUser.UserID;
                    ModerationPosts.EditPost(AppContext.ReaderCreator, userId, postId, subject,body, false, true);
                }

                Update(siteId, forumId, threadId, postId, modId, decision, notes, referId, threadModStatus, sendEmail, emailType, customText);

                // Post Distress Message
                int distressID = InputContext.GetParamIntOrZero("distressmessageid", i, "Distress Message");
                if (distressID > 0)
                {
                    ModerationDistressMessages distressMessage = new ModerationDistressMessages(InputContext);
                    distressMessage.PostDistressMessage(distressID, siteId, forumId, threadId, postId);
                }
            }

        }

        /// <summary>
        /// Updates the moderation item and sends email for the decision
        /// </summary>
        /// <param name="siteId"></param>
        /// <param name="forumId"></param>
        /// <param name="threadId"></param>
        /// <param name="postId"></param>
        /// <param name="modId"></param>
        /// <param name="decision"></param>
        /// <param name="notes"></param>
        /// <param name="referId"></param>
        /// <param name="threadModStatus"></param>
        /// <param name="sendEmail"></param>
        /// <param name="emailType"></param>
        /// <param name="customText"></param>
        private void Update(int siteId, int forumId, int threadId, int postId, int modId, ModerationItemStatus decision, String notes, int referId, int threadModStatus, bool sendEmail, String emailType, String customText)
        {
            Queue<String> complainantEmails;
            Queue<int> complainantIds;
            Queue<int> modIds;
            String authorEmail;
            int authorId;
            ModerationPosts.ApplyModerationDecision(AppContext.ReaderCreator, forumId, ref threadId, ref postId, modId, 
                decision, notes, referId, threadModStatus, emailType, out complainantEmails, out complainantIds, 
                out modIds, out authorEmail, out authorId, InputContext.ViewingUser.UserID);

            // Send Author Email if content failed or amended.
            if (sendEmail && (decision == ModerationItemStatus.Failed || decision == ModerationItemStatus.PassedWithEdit))
            {
                SendAuthorEmail(decision, siteId, forumId, threadId, postId, authorId, authorEmail, emailType, customText);
            }

            //Send ComplainantEmails for a final decision only.
            if (decision == ModerationItemStatus.Failed || decision == ModerationItemStatus.Passed || decision == ModerationItemStatus.PassedWithEdit)
            {
                for (Queue<string>.Enumerator e = complainantEmails.GetEnumerator(); e.MoveNext(); )
                {
                    string complainantEmail = e.Current;
                    int complainantId = complainantIds.Dequeue();
                    int reference = modIds.Dequeue();
                    SendComplainantEmail(decision, siteId, reference, complainantId, complainantEmail, customText);
                }
            }
        }

        private void SendAuthorEmail(ModerationItemStatus decision, int siteId, int forumId, int threadId, int postId, int authorId, String authorEmail, String emailType, String customText)
        {

            String contentURL = @"http://www.bbc.co.uk/dna/" + InputContext.TheSiteList.GetSite(siteId).SiteName + @"/F" + Convert.ToString(forumId) + @"?thread=" + Convert.ToString(threadId) + "&post=" + Convert.ToString(postId) + @"#p" + Convert.ToString(postId);
            String subject = "";
            String body = "";
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchpostdetails"))
            {
                dataReader.AddParameter("postid", postId);
                dataReader.Execute();
                if (dataReader.Read())
                {
                    subject = dataReader.GetStringNullAsEmpty("subject");
                    body = dataReader.GetStringNullAsEmpty("text");
                }
            }

            String emailSubject = "";
            String emailBody = ""; ;
            if (decision == ModerationItemStatus.Failed)
            {
                EmailTemplates.FetchEmailText(AppContext.ReaderCreator, siteId, "ContentRemovedEmail", out emailSubject, out emailBody);
            }
            else if (decision == ModerationItemStatus.PassedWithEdit)
            {
                EmailTemplates.FetchEmailText(AppContext.ReaderCreator, siteId, "ContentFailedAndEditedEmail", out emailSubject, out emailBody);
            }
            else
            {
                AddErrorXml("EMAIL", "Unable to send email: No email template.", RootElement);
                return;
            }


            String insertText;
            if (EmailTemplates.FetchInsertText(AppContext.ReaderCreator, siteId, emailType, out insertText))
            {
                emailBody = emailBody.Replace("++**inserted_text**++", insertText);
                emailBody = emailBody.Replace("++**inserted_text**++", customText);
                emailBody = emailBody.Replace("++**content_type**++", "Posting");
                emailBody = emailBody.Replace("++**add_content_method**++", "post it");
                emailBody = emailBody.Replace("++**content_url**++", contentURL);
                emailBody = emailBody.Replace("++**content_subject**++", subject);
                emailBody = emailBody.Replace("++**content_text**++", body);
                emailSubject = emailSubject.Replace("++**content_type**++", "Posting");


                try
                {
                    //Actually send the email.
                    DnaMessage sendMessage = new DnaMessage(InputContext);
                    String sender = InputContext.TheSiteList.GetSite(siteId).ModeratorsEmail;
                    sendMessage.SendEmailOrSystemMessage(authorId, authorEmail, sender, siteId, emailSubject, emailBody);
                }
                catch (DnaEmailException e)
                {
                    AddErrorXml("EMAIL", "Unable to send email." + e.Message, RootElement);
                }
            }
            else
            {
                AddErrorXml("EMAIL", "Unable to send email: No email template reason.", RootElement);
            }
        }

        private void SendComplainantEmail(ModerationItemStatus decision, int siteId, int modId, int complainantId, String complainantEmail, String customText)
        {
            String emailSubject = "";
            String emailBody = ""; ;
            if (decision == ModerationItemStatus.Passed)
            {
                EmailTemplates.FetchEmailText(AppContext.ReaderCreator, siteId, "RejectComplaintEmail", out emailSubject, out emailBody);
            }
            else if (decision == ModerationItemStatus.PassedWithEdit)
            {
                EmailTemplates.FetchEmailText(AppContext.ReaderCreator, siteId, "UpholdComplaintEditEntryEmail", out emailSubject, out emailBody);
            }
            else if (decision == ModerationItemStatus.Failed)
            {
                EmailTemplates.FetchEmailText(AppContext.ReaderCreator, siteId, "UpholdComplaintEmail", out emailSubject, out emailBody);
            }

            String reference = "P" + Convert.ToString(modId);
            emailBody = emailBody.Replace("++**reference_number**++", reference);
            emailSubject = emailSubject.Replace("++**reference_number**++", reference);

            if (decision == ModerationItemStatus.Passed || decision == ModerationItemStatus.PassedWithEdit)
            {
                emailBody = emailBody.Replace("++**inserted_text**++", customText);
            }

            try
            {
                //Actually send the email.
                DnaMessage sendMessage = new DnaMessage(InputContext);
                String sender = InputContext.TheSiteList.GetSite(siteId).ModeratorsEmail;
                sendMessage.SendEmailOrSystemMessage(complainantId, complainantEmail, sender, siteId, emailSubject, emailBody);
            }
            catch (DnaEmailException e)
            {
                AddErrorXml("EMAIL", "Unable to send email." + e.Message, RootElement);
            }
        }
    }
}
