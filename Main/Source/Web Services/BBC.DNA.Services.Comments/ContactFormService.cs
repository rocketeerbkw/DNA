using System;
using System.Configuration;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using BBC.Dna.Api;
using BBC.Dna.Sites;
using Microsoft.ServiceModel.Web;
using BBC.Dna.Api.Contracts;

namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ContactFormService : baseService
    {
        private readonly Contacts contactFormComments;

        public ContactFormService()
            : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            contactFormComments = new Contacts(dnaDiagnostic, readerCreator, cacheManager, Global.siteList);
            contactFormComments.EmailServerAddress = Global.emailServerAddress;
            contactFormComments.FileCacheFolder = Global.fileCacheFolder;
            contactFormComments.FilterBy = FilterBy.ContactFormPosts;
            string basePath = ConfigurationManager.AppSettings["ServerBasePath"];
            basePath = basePath.Remove(basePath.LastIndexOf("/")) + "/ContactFormService.svc";
            contactFormComments.BasePath = basePath;
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/")]
        [WebHelp(Comment = "Get the contact forms for given sitename")]
        [OperationContract]
        public Stream GetContactFormsBySitename(string sitename)
        {
            ISite site = GetSite(sitename);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }
            CommentForumList commentForumList;
            try
            {
                switch (filterBy)
                {
                    case FilterBy.PostsWithinTimePeriod:
                        int timePeriod;
                        if (!Int32.TryParse(filterByData, out timePeriod))
                        {
                            timePeriod = 24;
                        }
                        commentForumList = contactFormComments.GetCommentForumListBySiteWithinTimeFrame(site, prefix, timePeriod);
                        break;

                    default:
                        commentForumList = contactFormComments.GetCommentForumListBySite(site, prefix);
                        break;
                }
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
            return GetOutputStream(commentForumList);
        }

        [WebInvoke(Method="POST", UriTemplate = "V1/site/{sitename}/")]
        [WebHelp(Comment = "Create a new contact form for the specified site")]
        [OperationContract]
        public Stream CreateContactFormForSite(string siteName, ContactForm newContactFormDetails)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            try
            {
                contactFormComments.CallingUser = GetCallingUser(site);
                ContactForm commentForumData = contactFormComments.CreateContactForm(newContactFormDetails, site);
                WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.Created;
                return GetOutputStream(commentForumData);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{siteName}/contactform/{contactFormId}/")]
        [WebHelp(Comment = "Create a new contact details in a given contact form")]
        [OperationContract]
        public Stream CreateContactDetails(string siteName, string contactFormId, ContactDetails newContactDetails)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            try
            {
                contactFormComments.CallingUser = GetCallingUser(site);
                ContactForm contactForm = contactFormComments.GetContactFormFromFormID(contactFormId, site);

                if (contactForm == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }

                if (contactForm.ContactEmail == null || contactForm.ContactEmail.Length == 0)
                {
                    throw ApiException.GetError(ErrorType.MissingContactEmail);
                }

                ContactDetails contactDetails = contactFormComments.CreateContactDetails(contactForm, newContactDetails);

                contactFormComments.SendDetailstoContactEmail(contactDetails, contactForm.ContactEmail);
                WebOperationContext.Current.OutgoingResponse.StatusCode = System.Net.HttpStatusCode.Created;
                return GetOutputStream(contactDetails);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }

        [WebInvoke(Method = "PUT", UriTemplate = "V1/site/{siteName}/contactform/{contactFormId}/")]
        [WebHelp(Comment = "Creates new Contact Detail, also creates the Contact Form if it doesn't exist")]
        [OperationContract]
        public Stream CreateCommentContactFormWithContact(string siteName, ContactForm ContactFormDetails, string contactFormId)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            try
            {
                if (contactFormId == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                } 
                
                ContactFormDetails.Id = contactFormId;
                ContactForm contactFormData = contactFormComments.CreateContactForm(ContactFormDetails, site);
                contactFormComments.CallingUser = GetCallingUserOrNotSignedInUser(site, contactFormData);

                if (ContactFormDetails.contactDetailsList != null &&
                    ContactFormDetails.contactDetailsList.contacts != null &&
                    ContactFormDetails.contactDetailsList.contacts.Count > 0)
                {
                    // check if there is a rating to add
                    ContactDetails contactDetails = contactFormComments.CreateContactDetails(contactFormData, (ContactDetails)ContactFormDetails.contactDetailsList.contacts[0]);
                    contactFormComments.SendDetailstoContactEmail(contactDetails, contactFormData.ContactEmail);
                    return GetOutputStream(contactDetails);
                }
                return GetOutputStream(contactFormData);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
    }
}