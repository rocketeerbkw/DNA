using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;
using System.Net.Mail;
using System.Configuration;
using BBC.Dna.Users;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Api
{
    public class Contacts : Comments
    {
        public Contacts(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
            : base(dnaDiagnostics, dataReaderCreator, cacheManager, siteList)
        {
        }

        public ContactForm GetContactFormFromFormID(string contactFormId, ISite site)
        {
            return GetContactFormDetailFromFormID(contactFormId, site);
        }

        public ContactDetails CreateContactDetails(ContactForm contactForm, ContactDetails contactDetails)
        {
            return (ContactDetails)CreateComment(contactForm, contactDetails);
        }

        /// <summary>
        /// Creates a new contact form for a specificed site. If the contact form id already exists, then nothing will be created
        /// </summary>
        /// <param name="newContactForm">The new contact form object to create the contact form from</param>
        /// <param name="site">The site that the form should belong to</param>
        /// <returns>The contact form (either new or existing) which matches to the </returns>
        public ContactForm CreateContactForm(ContactForm newContactForm, ISite site)
        {
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            if (CallingUser == null || !CallingUser.IsUserA(UserTypes.Editor))
            {
                throw ApiException.GetError(ErrorType.NotAuthorized);
            }

            if (newContactForm == null)
            {
                throw ApiException.GetError(ErrorType.InvalidContactEmail);
            }

            if (newContactForm.ContactEmail == null || !EmailAddressFilter.IsValidEmailAddresses(newContactForm.ContactEmail))
            {
                throw ApiException.GetError(ErrorType.InvalidContactEmail);
            }

            ContactForm contactForm = GetContactFormDetailFromFormID(newContactForm.Id, site);
            if (contactForm == null)
            {
                newContactForm.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive;
                CreateForum(newContactForm, site);
                SetupContactFormDetails(newContactForm);
                contactForm = GetContactFormDetailFromFormID(newContactForm.Id, site);
            }
            return contactForm;
        }

        private ContactForm GetContactFormDetailFromFormID(string contactFormID, ISite site)
        {
            ContactForm contactForm = null;

            using (IDnaDataReader reader = CreateReader("getcontactformdetailfromformid"))
            {
                try
                {
                    reader.AddParameter("contactformid", contactFormID);
                    reader.AddParameter("sitename", site.SiteName);
                    reader.Execute();
                    if (reader.HasRows && reader.Read())
                    {
                        contactForm = new ContactForm();
                        contactForm.ContactEmail = reader.GetString("contactemail");
                        contactForm.ForumID = reader.GetInt32("forumid");
                        contactForm.Id = reader.GetString("contactformuid");
                        contactForm.ParentUri = reader.GetString("parenturi");
                        contactForm.Title = reader.GetString("title");
                        contactForm.SiteName = site.SiteName;
                        contactForm.isContactForm = true;
                    }
                }
                catch (Exception ex)
                {
                    throw new ApiException(ex.Message, ex.InnerException);
                }
            }

            return contactForm;
        }

        private void SetupContactFormDetails(ContactForm commentForum)
        {
            try
            {
                using (IDnaDataReader reader = CreateReader("setcommentforumascontactform"))
                {
                    reader.AddParameter("forumid", commentForum.ForumID);
                    reader.AddParameter("contactemail", commentForum.ContactEmail);
                    reader.Execute();
                }
            }
            catch (Exception ex)
            {
                ApiException exception = ApiException.GetError(ErrorType.ForumUnknown, ex.InnerException);
                throw exception;
            }
        }

        public void SendDetailstoContactEmail(ContactDetails contactDetails, string recipient)
        {
            string sender = SiteList.GetSite("h2g2").EditorsEmail;
            string subject = contactDetails.ForumUri;
            string body = contactDetails.text;

            try
            {
                MailMessage message = new MailMessage();
                message.From = new MailAddress(sender);

                foreach (string toAddress in recipient.Split(';'))
                    message.To.Add(new MailAddress(toAddress));

                message.Subject = subject;
                message.Body = body;

                SmtpClient client = new SmtpClient();
                //client.Host = "ops-fs0.national.core.bbc.co.uk";
                //client.Port = 25;
                //client.SendCompleted += new SendCompletedEventHandler(client_SendCompleted);
                //client.SendAsync(message, message);
                client.Send(message);
            }
            catch (Exception e)
            {
                WriteFailedEmailToFile(sender, recipient, subject, body, "ContactDetails-");
                DnaDiagnostics.WriteExceptionToLog(e);
            }
        }

        private void client_SendCompleted(object sender, System.ComponentModel.AsyncCompletedEventArgs e)
        {
            MailMessage message = (MailMessage)e.UserState;
            if (e.Error != null || e.Cancelled)
            {
                throw new ApiException("Failed");
            }
        }

        private void WriteFailedEmailToFile(string sender, string recipient, string subject, string body, string filenamePrefix)
        {
            string failedFrom = "From: " + sender + "\r\n";
            string failedRecipient = "Recipient: " + recipient + "\r\n";
            string failedEmail = failedFrom + failedRecipient + subject + "\r\n" + body;

            //Create filename out of date and random number.
            string fileName = filenamePrefix + DateTime.Now.ToString("yyyy-MM-dd-h:mm:ssffff");
            Random random = new Random(body.Length);
            fileName += "-" + random.Next().ToString() + ".txt";

            //string cacheFolder = ConfigurationManager.AppSettings["FileCacheFolder"];
            string cacheFolder = Environment.GetEnvironmentVariable("Temp");
            FileCaching.PutItem(DnaDiagnostics, cacheFolder, "failedmails", fileName, failedEmail);
        }
    }
}
