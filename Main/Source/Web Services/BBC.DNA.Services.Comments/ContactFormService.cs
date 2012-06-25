using System;
using System.Configuration;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using BBC.Dna.Api;
using BBC.Dna.Sites;
using Microsoft.ServiceModel.Web;

namespace BBC.Dna.Services
{
    [ServiceContract]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class ContactFormService : baseService
    {
        private readonly Comments contactFormComments;
        private readonly Contacts contacts;

        public ContactFormService()
            : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
            contactFormComments = new Comments(dnaDiagnostic, readerCreator, cacheManager, Global.siteList);
            contactFormComments.FilterBy = FilterBy.ContactFormPosts;
            string basePath = ConfigurationManager.AppSettings["ServerBasePath"];
            basePath = basePath.Remove(basePath.LastIndexOf("/")) + "/ContactFormService.svc";
            contactFormComments.BasePath = basePath;

            contacts = new Contacts(dnaDiagnostic, readerCreator, cacheManager, Global.siteList);
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
        public Stream CreateContactFormForSite(string siteName, ContactForm contactForm)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            try
            {
                contactFormComments.CallingUser = GetCallingUser(site);
                CommentForum commentForumData = contactFormComments.CreateContactForm(contactForm, site);
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
        public Stream CreateContactDetails(string contactFormId, string siteName, CommentInfo contactDetails)
        {
            ISite site = GetSite(siteName);
            if (site == null)
            {
                throw ApiException.GetError(ErrorType.UnknownSite);
            }

            try
            {
                contactFormComments.CallingUser = GetCallingUser(site);
                CommentForum contactForm = contactFormComments.GetCommentForumByUid(contactFormId, site);

                if (contactForm == null)
                {
                    throw ApiException.GetError(ErrorType.ForumUnknown);
                }

                CommentInfo contactInfo = contactFormComments.CreateComment(contactForm, contactDetails);
                
                // Send email here

                return GetOutputStream(contactInfo);
            }
            catch (ApiException ex)
            {
                throw new DnaWebProtocolException(ex);
            }
        }
    }
}