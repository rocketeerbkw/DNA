using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml;
using BBC.Dna.Api.Contracts;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

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

            if (newContactForm == null)
            {
                throw ApiException.GetError(ErrorType.InvalidContactEmail);
            }

            ContactForm contactForm = GetContactFormDetailFromFormID(newContactForm.Id, site);
            if (contactForm == null)
            {
                if (!newContactForm.allowNotSignedInCommenting || !SiteList.GetSiteOptionValueBool(site.SiteID, "CommentForum", "AllowNotSignedInCommenting"))
                {
                    if (CallingUser == null || !CallingUser.IsUserA(UserTypes.Editor))
                    {
                        throw ApiException.GetError(ErrorType.NotAuthorized);
                    }
                }

                if (newContactForm.ContactEmail == null)
                {
                    newContactForm.ContactEmail = site.ContactFormsEmail;
                }

                if (newContactForm.ContactEmail.Length == 0)
                {
                    throw ApiException.GetError(ErrorType.MissingContactEmail);
                }

                if (!EmailAddressFilter.IsValidEmailAddresses(newContactForm.ContactEmail) || !newContactForm.ContactEmail.ToLower().EndsWith("@bbc.co.uk"))
                {
                    throw ApiException.GetError(ErrorType.InvalidContactEmail);
                }

                newContactForm.ModerationServiceGroup = ModerationStatus.ForumStatus.Reactive;
                CreateForum(newContactForm, site);
                SetupContactFormDetails(newContactForm);
                contactForm = GetContactFormDetailFromFormID(newContactForm.Id, site);
            }
            return contactForm;
        }

        public bool SetContactFormEmailAddress(int contactFormID, string contactEmailAddress)
        {
            if (contactEmailAddress.Length > 0)
            {
                if (EmailAddressFilter.IsValidEmailAddresses(contactEmailAddress) && contactEmailAddress.ToLower().EndsWith("@bbc.co.uk"))
                {
                    try
                    {
                        SetupContactFormDetails(contactFormID, contactEmailAddress);
                    }
                    catch
                    {
                        return false;
                    }
                    return true;
                }
            }
            return false;
        }

        //private string GetContactFormEmailAddressForSite(int siteId)
        //{
        //    string emailAddress = "";
        //    using (IDnaDataReader reader = CreateReader("getcontactformemailaddressforsite"))
        //    {
        //        reader.AddParameter("siteid", siteId);
        //        reader.Execute();
        //        if (reader.HasRows && reader.Read())
        //        {
        //            emailAddress = reader.GetStringNullAsEmpty("contactemailaddress");
        //        }
        //    }

        //    return emailAddress;
        //}

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
                        contactForm.NotSignedInUserId = reader.GetInt32("NotSignedInUserId");
                        contactForm.allowNotSignedInCommenting = contactForm.NotSignedInUserId > 0;
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
            SetupContactFormDetails(commentForum.ForumID, commentForum.ContactEmail);
        }

        private void SetupContactFormDetails(int forumID, string contactEmail)
        {
            try
            {
                using (IDnaDataReader reader = CreateReader("setcommentforumascontactform"))
                {
                    reader.AddParameter("forumid", forumID);
                    reader.AddParameter("contactemail", contactEmail);
                    reader.Execute();
                }
            }
            catch (Exception ex)
            {
                ApiException exception = ApiException.GetError(ErrorType.ForumUnknown, ex.InnerException);
                throw exception;
            }
        }

        public void SendDetailstoContactEmail(ContactDetails contactDetails, string recipient, string sender)
        {
            string subject;
            string body;
            string failedBody;

            CreateEmailSubjectAndBodies(contactDetails, out subject, out body, out failedBody);
            SendEmailWithFailMessageOverride(sender, recipient, subject, body, "ContactDetails-", failedBody);
        }

        private static void CreateEmailSubjectAndBodies(ContactDetails contactDetails, out string subject, out string body, out string failedBody)
        {
            // Do the default thing
            subject = contactDetails.ForumUri;
            body = contactDetails.text;
            failedBody = "ID:" + contactDetails.ID + ", FORUM_URI:" + contactDetails.ForumUri;
            
            // See if we have a json message
            if (TyrParseJSONContactFormMessage(contactDetails, ref subject, ref body))
            {
                return;
            }

            if (TryParseXMLTextMessage(contactDetails, ref subject, ref body))
            {
                return;
            }
        }

        private static bool TyrParseJSONContactFormMessage(ContactDetails contactDetails, ref string subject, ref string body)
        {
            try
            {
                ContactFormMessage message = (ContactFormMessage)StringUtils.DeserializeJSONObject(contactDetails.text, typeof(ContactFormMessage));
                subject = HttpUtility.UrlDecode(message.Subject);
                body = "";
                foreach (KeyValuePair<string, string> content in message.Body.ToList<KeyValuePair<string, string>>())
                {
                    string messageLine = HttpUtility.UrlDecode(content.Key) + " : " + HttpUtility.UrlDecode(content.Value) + "\n";
                    body += messageLine;
                }

                return true;
            }
            catch { }
            return false;
        }

        private static bool TryParseXMLTextMessage(ContactDetails contactDetails, ref string subject, ref string body)
        {
            try
            {
                XmlDocument doc = new XmlDocument();
                doc.LoadXml(contactDetails.text);
                StringBuilder newBody = new StringBuilder();

                XmlNode currentNode = doc.FirstChild.SelectSingleNode("/message");
                if (currentNode != null)
                {
                    currentNode = currentNode.FirstChild;
                    while (currentNode != null)
                    {
                        if (currentNode.Name.ToLower() == "subject")
                        {
                            subject = currentNode.InnerText;
                        }
                        else
                        {
                            newBody.AppendLine(currentNode.Name + ":");
                            newBody.AppendLine(currentNode.InnerText);
                            newBody.AppendLine();
                        }

                        currentNode = currentNode.NextSibling;
                    }
                }

                if (newBody.Length > 0)
                {
                    body = newBody.ToString();
                }

                return true;
            }
            catch { }
            return false;
        }
    }
}
