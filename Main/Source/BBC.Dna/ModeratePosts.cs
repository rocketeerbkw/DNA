using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Moderation;
using BBC.Dna.Data;
using BBC.Dna.Objects;

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
        public enum Status
        {
            /// <summary>
            /// 
            /// </summary>
            Unlocked = 0,
            /// <summary>
            /// 
            /// </summary>
            Refer = 2,
            /// <summary>
            /// 
            /// </summary>
            Passed = 3,
            /// <summary>
            /// 
            /// </summary>
            Failed = 4,
           
            // FailedWithEdit = 6,

            /// <summary>
            /// 
            /// </summary>
            PassedWithEdit = 8
        }

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


            bool useLIFOQueue = false;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("ismodclasslifoqueue"))
            {
                dataReader.AddParameter("modclassid", modClassId);
                dataReader.Execute();
                if (dataReader.HasRows && dataReader.Read())
                {
                    useLIFOQueue = dataReader.GetBoolean("LIFOQueue");
                }
            }

            string storedProcedureName = String.Empty;
            if (useLIFOQueue)
            {
                storedProcedureName = "getmoderationpostsmostrecentfirst";
            }
            else
            {
                storedProcedureName = "getmoderationposts";
            }

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                if (referrals)
                {
                    dataReader.AddParameter("status", Status.Refer);
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
                        AddAttribute(post, "MODERATIONID", dataReader.GetInt32NullAsZero("modid"));
                        AddAttribute(post, "THREADID", dataReader.GetInt32NullAsZero("threadid"));
                        AddAttribute(post, "FORUMID", dataReader.GetInt32NullAsZero("forumid"));
                        AddAttribute(post, "ISPREMODPOSTING", dataReader.GetTinyIntAsInt("ispremodposting"));
                        //AddAttribute(post, "MODCLASSID", dataReader.GetInt32NullAsZero("modclassid"));
                        AddIntElement(post, "MODERATION-STATUS", dataReader.GetInt32NullAsZero("threadmoderationstatus"));

                        int siteId = dataReader.GetInt32NullAsZero("siteid");
                        AddIntElement(post, "SITEID", siteId);
                        if (!dataReader.IsDBNull("topictitle"))
                        {
                            AddTextTag(post, "TOPICTITLE", dataReader.GetStringNullAsEmpty("topictitle"));
                        }
                        AddTextTag(post, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));

                        AddTextTag(post, "RAWTEXT", dataReader.GetStringNullAsEmpty("text"));
                        String translated = Translator.TranslateText(dataReader.GetStringNullAsEmpty("text"));
                        translated = translated.Replace("\r\n", "<BR/>");
                        AddXmlTextTag(post, "TEXT", translated );

                        String notes = dataReader.GetStringNullAsEmpty("notes");
                        notes = notes.Replace("\r\n", "<BR/>");
                        AddXmlTextTag(post, "NOTES", notes );

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
                Status decision = (Status) InputContext.GetParamIntOrZero("decision", i, "Moderation Decision");
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
                    bool create =  decision == Status.PassedWithEdit;
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
                if ( decision == Status.PassedWithEdit)
                {
                    Forum f = new Forum(InputContext);
                    String subject = InputContext.GetParamStringOrEmpty("editpostsubject",i, "Edit Post Subject");
                    String body = InputContext.GetParamStringOrEmpty("editposttext",i, "Edit Post Body");
                    int userId = InputContext.ViewingUser.UserID;
                    f.EditPost(userId, postId, subject,body, false, true);
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

        private void Update(int siteId, int forumId, int threadId, int postId, int modId, Status decision, String notes, int referId, int threadModStatus, bool sendEmail, String emailType, String customText)
        {
            Queue<String> complainantEmails = new Queue<string>();
            Queue<int> complainantIds = new Queue<int>();
            Queue<int> modIds = new Queue<int>();
            String authorEmail = "";
            int authorId = 0;
            int processed = 0;

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("moderatepost"))
            {
                dataReader.AddParameter("forumid", forumId);
                dataReader.AddParameter("threadid", threadId);
                dataReader.AddParameter("postid", postId);
                dataReader.AddParameter("modid", modId);
                dataReader.AddParameter("status", (int) decision);
                dataReader.AddParameter("notes", notes);
                dataReader.AddParameter("referto", referId);
                dataReader.AddParameter("referredby", InputContext.ViewingUser.UserID);
                dataReader.AddParameter("moderationstatus", threadModStatus);

                dataReader.Execute();

                while (dataReader.Read())
                {
                    authorEmail = dataReader.GetStringNullAsEmpty("authorsemail");
                    authorId = dataReader.GetInt32NullAsZero("authorid");
                    processed = dataReader.GetInt32NullAsZero("processed");
                    String complainantEmail = dataReader.GetStringNullAsEmpty("complaintsemail");
                    complainantEmails.Enqueue(complainantEmail);
                    complainantIds.Enqueue(dataReader.GetInt32NullAsZero("complainantId"));
                    modIds.Enqueue(dataReader.GetInt32NullAsZero("modid"));
                    postId = dataReader.GetInt32NullAsZero("postid");
                    threadId = dataReader.GetInt32NullAsZero("threadid");
                }
            }

            // Send Author Email if content failed or amended.
            if (sendEmail && (decision == Status.Failed || decision == Status.PassedWithEdit) )
            {
                SendAuthorEmail(decision, siteId, forumId, threadId, postId, authorId, authorEmail, emailType, customText);
            }

            //Send ComplainantEmails for a final decision only.
            if (decision == Status.Failed || decision == Status.Passed || decision == Status.PassedWithEdit)
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

        private void SendAuthorEmail(Status decision, int siteId, int forumId, int threadId, int postId, int authorId, String authorEmail, String emailType, String customText)
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
            EmailTemplate emailTemplate = new EmailTemplate(InputContext);
            if ( decision == Status.Failed )
            {
                emailTemplate.FetchEmailText(siteId, "ContentRemovedEmail", out emailSubject, out emailBody);
            }
            else if (decision == Status.PassedWithEdit)
            {
                emailTemplate.FetchEmailText(siteId, "ContentFailedAndEditedEmail", out emailSubject, out emailBody);
            }
            else
            {
                AddErrorXml("EMAIL", "Unable to send email: No email template.", RootElement);
                return;
            }


            String insertText;
            if (emailTemplate.FetchInsertText(siteId, emailType, out insertText))
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

        private void SendComplainantEmail(Status decision, int siteId, int modId, int complainantId, String complainantEmail, String customText)
        {
            String emailSubject = "";
            String emailBody = ""; ;
            EmailTemplate emailTemplate = new EmailTemplate(InputContext);
            if (decision == Status.Passed)
            {
                emailTemplate.FetchEmailText(siteId, "RejectComplaintEmail", out emailSubject, out emailBody);
            }
            else if ( decision == Status.PassedWithEdit)
            {
                emailTemplate.FetchEmailText(siteId, "UpholdComplaintEditEntryEmail", out emailSubject, out emailBody);
            }
            else if (decision == Status.Failed)
            {
                emailTemplate.FetchEmailText(siteId, "UpholdComplaintEmail", out emailSubject, out emailBody);
            }

            String reference = "P" + Convert.ToString(modId);
            emailBody = emailBody.Replace("++**reference_number**++", reference);
            emailSubject = emailSubject.Replace("++**reference_number**++", reference);

            if (decision == Status.Passed || decision == Status.PassedWithEdit)
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
