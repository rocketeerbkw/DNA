using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// UserComplaintPage Component
    /// </summary>
    public class UserComplaint : DnaInputComponent
    {
        private int _modId = 0;

        /// <summary>
        /// Default constructor for the MorePosts component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UserComplaint(IInputContext context)
            : base(context)
        {
        }

        private void GenerateXml()
        {
            XmlElement parent = AddElementTag(RootElement, "USERCOMPLAINT");
            if (_modId > 0)
            {
                AddAttribute(parent, "MODID", _modId);
            }

            bool editor = InputContext.ViewingUser != null && InputContext.ViewingUser.IsEditor;
            if (InputContext.DoesParamExist("postid", "Post Id"))
            {
                int postId = InputContext.GetParamIntOrZero("postid", "PostId");
                int threadId = 0;
                int forumId = 0;
                int authorId = 0;
                String subject;
                String authorName;
                int hidden = 0;
                AddAttribute(parent, "POSTID", postId);

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetchpostdetails"))
                {
                    dataReader.AddParameter("postid", postId);
                    dataReader.Execute();
                    if (dataReader.Read())
                    {
                        threadId = dataReader.GetInt32NullAsZero("threadid");
                        forumId = dataReader.GetInt32NullAsZero("forumid");
                        authorId = dataReader.GetInt32NullAsZero("userid");
                        authorName = dataReader.GetStringNullAsEmpty("username");
                        if (dataReader.IsDBNull("hidden") == false)
                            hidden = dataReader.GetTinyIntAsInt("hidden");
                        subject = dataReader.GetStringNullAsEmpty("subject");
                    }
                    else
                    {
                        AddErrorXml("NOTFOUND", "Post not found", RootElement);
                        return;
                    }
                }

                bool canRead = false;
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getthreadpermissions"))
                {
                    if (InputContext.ViewingUser != null)
                        dataReader.AddParameter("userid", InputContext.ViewingUser.UserID);
                    else
                        dataReader.AddParameter("userid", null);
                    dataReader.AddParameter("threadid", threadId);
                    dataReader.Execute();

                    if (dataReader.Read())
                    {
                        canRead = dataReader.GetTinyIntAsInt("canread") != 0;
                    }
                }

                if (!editor && (hidden > 0 || canRead == false))
                {
                    AddTextTag(parent, "SUBJECT", "HIDDEN");
                }
                else
                {
                    AddTextTag(parent, "SUBJECT", subject);
                }

                AddIntElement(parent, "THREADID", threadId);
                AddIntElement(parent, "FORUMID", forumId);
                XmlElement author = AddElementTag(parent, "AUTHOR");
                XmlElement user = AddElementTag(author, "USER");
                AddIntElement(user, "USERID", authorId);
                AddTextTag(user, "USERNAME", authorName);
                AddAttribute(parent, "HIDDEN", hidden);


            }
            else if (InputContext.DoesParamExist("h2g2id", "h2g2id"))
            {
                int h2g2Id = InputContext.GetParamIntOrZero("h2g2id", "h2g2Id");
                AddAttribute(parent, "H2G2ID", h2g2Id);

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("fetcharticledetails"))
                {
                    dataReader.AddParameter("entryid", h2g2Id / 10);
                    dataReader.Execute();

                    while (dataReader.Read())
                    {
                        Boolean hidden = dataReader.GetInt32NullAsZero("hidden") != 0;
                        if (!editor && hidden)
                            AddTextTag(parent, "SUBJECT", "HIDDEN");
                        else
                            AddTextTag(parent, "SUBJECT", dataReader.GetStringNullAsEmpty("subject"));
                        AddIntElement(parent, "STATUS", dataReader.GetInt32NullAsZero("status"));
                        AddIntElement(parent, "ENTRYID", dataReader.GetInt32NullAsZero("entryid"));
                        XmlElement author = AddElementTag(parent, "AUTHOR");
                        XmlElement user = AddElementTag(author, "USER");
                        AddIntElement(user, "USERID", dataReader.GetInt32NullAsZero("editor"));
                        AddTextTag(user, "USERNAME", dataReader.GetStringNullAsEmpty("editorname"));
                    }
                }

            }
            else if (InputContext.DoesParamExist("url", "URL"))
            {
                //General Complaint.
                AddAttribute(parent, "URL", InputContext.GetParamStringOrEmpty("url", "URL"));
            }
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            String email = InputContext.GetParamStringOrEmpty("email", "Email");
            if (IsBanned(email))
            {
                //Error
                this.AddErrorXml("EMAILNOTALLOWED", "Not allowed to complain", RootElement);
                return;
            }
            else if (InputContext.GetParamStringOrEmpty("action", "action") == "submit")
            {
                ProcessSubmission();
            }
            GenerateXml();
        }

        private void ProcessSubmission()
        {
            int userId = 0;
            if (InputContext.ViewingUser.UserLoggedIn)
            {
                userId = InputContext.ViewingUser.UserID;
            }

            String complaintText = InputContext.GetParamStringOrEmpty("complainttext", "ComplaintText");
            String complaintReason = InputContext.GetParamStringOrEmpty("complaintreason", "ComplaintReason");
            complaintText = complaintText.Trim();
            if (complaintText == string.Empty || complaintText.Length == 0)
            {
                this.AddErrorXml("COMPLAINTTEXT", "No complaint text", RootElement);
                return;
            }

            complaintReason = complaintReason.Trim();
            if (complaintReason == string.Empty || complaintText.Length == 0)
            {
                this.AddErrorXml("COMPLAINTREASON", "No complaint reason", RootElement);
                return;
            }


            String email = InputContext.GetParamStringOrEmpty("email", "email");
            if (email == String.Empty && InputContext.ViewingUser.UserLoggedIn)
            {
                email = InputContext.ViewingUser.Email;
            }

            // InputContext.TheSiteList.GetSiteOptionValueBool(InputContext.CurrentSite.SiteID, "General", "IsKidsSite") == false
            if (InputContext.ViewingUser.UserLoggedIn == false)
            {
                //Verify email address
                if (!EmailAddressFilter.IsValidEmailAddresses(email))
                {
                    AddErrorXml("EMAIL", "Invalid email address", RootElement);
                    return;
                }
            }

            if (InputContext.GetParamIntOrZero("h2g2id", "h2g2id") > 0)
            {
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("registerarticlecomplaint"))
                {
                    int h2g2Id = InputContext.GetParamIntOrZero("h2g2id", "h2g2id");
                    dataReader.AddParameter("complainantid", userId);
                    dataReader.AddParameter("correspondenceemail", email);
                    dataReader.AddParameter("h2g2id", h2g2Id);
                    dataReader.AddParameter("complainttext", complaintText);
                    dataReader.AddParameter("ipaddress", InputContext.IpAddress);
                    dataReader.AddParameter("bbcuid", InputContext.BBCUid);

                    //HashValue
                    Guid hash = DnaHasher.GenerateHash(Convert.ToString(userId) + ":" + email + ":" + Convert.ToString(h2g2Id) + ":" + complaintText);
                    dataReader.AddParameter("hash", hash);

                    dataReader.Execute();

                    // Send Email
                    if (dataReader.Read())
                    {
                        int modId = dataReader.GetInt32NullAsZero("modId");
                        if (modId == 0)
                        {
                            AddErrorXml("REGISTERCOMPLAINT", "Unable to register complaint", RootElement);
                            return;
                        }
                        _modId = modId;
                        SendEmail(complaintText, email, modId, 0, h2g2Id, "A" + Convert.ToString(h2g2Id));
                    }
                }
            }
            else if (InputContext.GetParamIntOrZero("postid", "postid") > 0)
            {
                int postId = InputContext.GetParamIntOrZero("postid", "PostId");
                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("registerpostingcomplaint"))
                {
                    dataReader.AddParameter("complainantid", userId);
                    dataReader.AddParameter("correspondenceemail", email);
                    dataReader.AddParameter("postid", postId);
                    dataReader.AddParameter("complainttext", complaintText);
                    dataReader.AddParameter("ipaddress", InputContext.IpAddress);
                    dataReader.AddParameter("bbcuid", InputContext.BBCUid);

                    //HashValue
                    Guid hash = DnaHasher.GenerateHash(Convert.ToString(userId) + ":" + email + ":" + Convert.ToString(postId) + ":" + complaintText);
                    dataReader.AddParameter("hash", hash);
                    dataReader.Execute();

                    // Send Email
                    if (dataReader.Read())
                    {
                        int modId = dataReader.GetInt32NullAsZero("modId");
                        _modId = modId;
                    }
                }

                if (_modId == 0)
                {
                    AddErrorXml("REGISTERCOMPLAINT", "Unable to register complaint", RootElement);
                    return;
                }

                if (InputContext.ViewingUser.IsEditor)
                {
                    if (InputContext.GetParamIntOrZero("hidepost", "Hide Post") > 0)
                    {
                        using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("hidepost"))
                        {
                            dataReader.AddParameter("postid", InputContext.GetParamIntOrZero("postid", "PostId"));
                            dataReader.AddParameter("hiddenid", 6);
                            dataReader.Execute();

                            if (dataReader.Read())
                            {
                                bool hidden = dataReader.GetTinyIntAsInt("hidden") > 0;
                                if (hidden == false)
                                {
                                    AddErrorXml("HIDEPOST", "Unable to hide post", RootElement);
                                }
                            }
                        }
                    }
                }
                SendEmail(complaintText, email, _modId, postId, 0, Convert.ToString(postId));
            }
            else if (InputContext.DoesParamExist("url", "url"))
            {
                String url = InputContext.GetParamStringOrEmpty("url", "url");
                if (!URLFilter.CheckForURL(url))
                {
                    this.AddErrorXml("URL", "Invalid URL specified", RootElement);
                    return;
                }

                using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("registergeneralcomplaint"))
                {
                    dataReader.AddParameter("complainantid", userId);
                    dataReader.AddParameter("url", url);
                    dataReader.AddParameter("correspondenceemail", email);
                    dataReader.AddParameter("complainttext", complaintText);
                    dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                    dataReader.AddParameter("ipaddress", InputContext.IpAddress);
                    dataReader.AddParameter("bbcuid", InputContext.BBCUid);

                    //HashValue
                    Guid hash = DnaHasher.GenerateHash(Convert.ToString(userId) + ":" + email + ":" + url + ":" + complaintText);
                    dataReader.AddParameter("hash", hash);

                    dataReader.Execute();

                    if (dataReader.Read())
                    {
                        int modId = dataReader.GetInt32NullAsZero("modId");
                        if (modId == 0)
                        {
                            AddErrorXml("REGISTERCOMPLAINT", "Unable to register complaint", RootElement);
                            return;
                        }
                        _modId = modId;
                        SendEmail(complaintText, email, modId, 0, 0, url);
                    }
                }
            }
        }

        private Boolean IsBanned(String email)
        {
            //Use users registered email in preference to supplied email if available.
            if (InputContext.ViewingUser != null && InputContext.ViewingUser.Email != String.Empty)
            {
                email = InputContext.ViewingUser.Email;
            }

            if (email == String.Empty)
                return false;

            Boolean isbanned = false;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("isemailbannedfromcomplaints"))
            {
                dataReader.AddParameter("email", email);
                dataReader.Execute();

                if (dataReader.Read())
                {
                    isbanned = dataReader.GetInt32NullAsZero("isbanned") != 0;
                }
            }
            return isbanned;
        }

        /// <summary>
        /// Send Email using Email template mechanism.
        /// </summary>
        /// <param name="complaintText"></param>
        /// <param name="email"></param>
        /// <param name="modId"></param>
        /// <param name="postId"></param>
        /// <param name="h2g2Id"></param>
        /// <param name="title"></param>
        private void SendEmail(string complaintText, string email, int modId, int postId, int h2g2Id, string title)
        {
            // do any necessary substitutions
            string emailSubject;
            string emailBody;
            int siteId = InputContext.CurrentSite.SiteID;
            int userId = InputContext.ViewingUser == null ? 0 : InputContext.ViewingUser.UserID;

            EmailTemplate emailTemplate = new EmailTemplate(InputContext);
            emailTemplate.FetchEmailText(siteId, "UserComplaintEmail", out emailSubject, out emailBody);

            if (string.IsNullOrEmpty(emailBody) || string.IsNullOrEmpty(emailSubject))
            {
                InputContext.Diagnostics.WriteWarningToLog("ComplaintSendEmail", 
                    string.Format("Missing email template: site={0}, type=UserComplaintEmail", siteId));
                SendErrorEmailToModerator(modId, InputContext.CurrentSite.ModeratorsEmail, postId, h2g2Id, title, complaintText);
                return;
            }

            String from = email;
            if (from == String.Empty)
                from = "Anonymous";

            if (InputContext.ViewingUser.UserLoggedIn)
            {
                from = InputContext.ViewingUser.UserName;
                if (InputContext.ViewingUser.IsEditor)
                    from += " (Editor)";
            }
            emailSubject = emailSubject.Replace("++**nickname**++", from);

            emailBody = emailBody.Replace("++**nickname**++", Convert.ToString(from));
            emailBody = emailBody.Replace("++**reference_number**++", Convert.ToString(modId));

            if (postId > 0)
            {
                emailBody = emailBody.Replace("++**content_type**++", "Post");
            }
            else if (h2g2Id > 0)
            {
                emailBody = emailBody.Replace("++**content_type**++", "Article");
            }
            else
            {
                emailBody = emailBody.Replace("++**content_type**++", "Item");
            }

            emailBody = emailBody.Replace("++**content_subject**++", title);


            emailBody = emailBody.Replace("++**inserted_text**++", complaintText);

            string moderatorEmail = InputContext.TheSiteList.GetSite(siteId).GetEmail(BBC.Dna.Sites.Site.EmailType.Moderators);

            try
            {
                
                //Actually send the email.
                DnaMessage sendMessage = new DnaMessage(InputContext);
                sendMessage.SendEmailOrSystemMessage(userId, email, moderatorEmail, siteId, emailSubject, emailBody);
            }
            catch (DnaEmailException e)
            {
                AddErrorXml("EMAIL", "Unable to send email." + e.Message, RootElement);
            }

        }

        /// <summary>
        /// Sends an imformative email to the moderator with the complaint details
        /// </summary>
        /// <param name="modId"></param>
        /// <param name="email"></param>
        /// <param name="postId"></param>
        /// <param name="h2g2Id"></param>
        /// <param name="url"></param>
        /// <param name="complaintText"></param>
        private void SendErrorEmailToModerator(int modId, string email, int postId, int h2g2Id, string url, String complaintText)
        {

            // Should use the email templaing system for this task.
            String from = email;
            if (from == String.Empty)
                from = "Anonymous";

            if (InputContext.ViewingUser != null)
            {
                from = InputContext.ViewingUser.UserName;
                if (InputContext.ViewingUser.IsEditor)
                    from += " (Editor)";
            }

            String emailSubject = "Error: Unable to send complaint receipt to user - missing template";
            String emailBody = "Complaint from: " + from + "\r\n";
            emailBody += "ModerationReference: " + Convert.ToString(modId) + "\r\n";
            if (postId > 0)
            {
                emailBody += " about post " + Convert.ToString(postId) + "\r\n";
            }
            else if (h2g2Id > 0)
            {
                emailBody += " about article " + Convert.ToString(h2g2Id) + "\r\n";
            }
            else
            {
                emailBody += " about page " + Convert.ToString(url) + "\r\n";
            }
            //if (hidden)
                //emailBody += " (HIDDEN)";
            emailBody += "\r\n\r\n";
            emailBody += complaintText;

            String moderatorEmail = InputContext.CurrentSite.ModeratorsEmail;
            int siteId = InputContext.CurrentSite.SiteID;

            int userId = 0;
            if (InputContext.ViewingUser != null)
                userId = InputContext.ViewingUser.UserID;

            try
            {
                //Actually send the email.
                DnaMessage sendMessage = new DnaMessage(InputContext);
                sendMessage.SendEmailOrSystemMessage(userId, email, email, siteId, emailSubject, emailBody);
            }
            catch (DnaEmailException e)
            {
                AddErrorXml("EMAIL", "Unable to send email." + e.Message, RootElement);
            }
        }
    }
}
