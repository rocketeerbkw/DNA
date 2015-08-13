using System;
using System.ServiceModel;
using System.ServiceModel.Web;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using BBC.Dna.Moderation;
using System.IO;

namespace BBC.Dna.Services
{
    [ServiceContract]
    public class ModerationService : baseService
    {
        public ModerationService()
            : base(Global.connectionString, Global.siteList, Global.dnaDiagnostics)
        {
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/items/")]
        [WebHelp(Comment = "Create a new moderation item for the site concerned.")]
        [OperationContract]
        public void CreateModerationItem(string sitename, ModerationItem modItem)
        {
            try
            {
                ISite site = GetSite(sitename);
                CallingUser viewer = GetCallingUser(site);
                if (viewer.IsUserA(UserTypes.Editor))
                {
                    ExternalLinkModeration exLinkMod = new ExternalLinkModeration(base.dnaDiagnostic, base.readerCreator, base.cacheManager, base.siteList);

                    Uri source;
                    Uri callback;
                    if (Uri.TryCreate(modItem.Uri, UriKind.Absolute, out source) && Uri.TryCreate(modItem.CallBackUri, UriKind.Absolute, out callback))
                    {
                        exLinkMod.AddToModerationQueue(new Uri(modItem.Uri), new Uri(modItem.CallBackUri), modItem.ComplaintText, modItem.Notes, site.SiteID);
                    }
                    else
                    {
                        throw new DnaWebProtocolException(System.Net.HttpStatusCode.BadRequest, "Bad url format", null);
                    }
                }
                else
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "User must be an editor", null);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/posttoexlinkinternal/")]
        [WebHelp(Comment = "INTERNAL USE ONLY")]
        [OperationContract]
        public void CreateModerationItemInternal(string sitename, ModerationItem modItem)
        {
            try
            {
                ISite site = GetSite(sitename);
                CallingUser viewer = GetCallingUser(site);
                if (viewer.IsUserA(UserTypes.Editor))
                {
                    ExternalLinkModeration exLinkMod = new ExternalLinkModeration(base.dnaDiagnostic, base.readerCreator, base.cacheManager, base.siteList);

                    Guid keyHash = Guid.Empty;
                    string hashString = site.SiteID + "<:>" + viewer.IdentityUserID + "<:>" + modItem.Uri + "<:>" + DateTime.Now.ToString();
                    keyHash = DnaHasher.GenerateHash(hashString);
                    exLinkMod.AddToExLinkModHashInternal(keyHash, site.SiteID);

                    Uri source;
                    Uri callback;
                    string sourceURI = modItem.Uri + (modItem.Uri.IndexOf('?') > 0 ? "&" : "?") + "encryptionKey=" + keyHash;
                    string callbackURI = modItem.CallBackUri + (modItem.CallBackUri.IndexOf('?') > 0 ? "&" : "?") + "encryptionKey=" + keyHash;

                    if (Uri.TryCreate(sourceURI, UriKind.Absolute, out source) && Uri.TryCreate(callbackURI, UriKind.Absolute, out callback))
                    {
                        exLinkMod.AddToModerationQueue(new Uri(sourceURI), new Uri(callbackURI), modItem.ComplaintText, modItem.Notes, site.SiteID);
                    }
                    else
                    {
                        throw new DnaWebProtocolException(System.Net.HttpStatusCode.BadRequest, "Bad url format", null);
                    }
                }
                else
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "User must be an editor", null);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
        }

        [WebInvoke(Method = "POST", UriTemplate = "V1/site/{sitename}/posttocallbackiteminternal/")]
        [WebHelp(Comment = "INTERNAL USE ONLY")]
        [OperationContract]
        public void CreateCallbackItemInternal(string sitename, ExLinkModCallbackItem exLinkModCallbackItem)
        {
            try
            {
                ISite site = GetSite(sitename);
                CallingUser viewer = GetCallingUser(site);
                if (viewer.IsUserA(UserTypes.Editor))
                {
                    ExternalLinkModeration exLinkMod = new ExternalLinkModeration(base.dnaDiagnostic, base.readerCreator, base.cacheManager, base.siteList);
                    string hash = QueryStringHelper.GetQueryParameterAsString("encryptionKey", "");

                    if (exLinkMod.IsValidHash(hash, site.SiteID))
                    {
                        exLinkMod.AddToExLinkModCallbackInternal(hash, site.SiteID, exLinkModCallbackItem);
                    }
                    else
                    {
                        throw new DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "Invalid encryption key", null);
                    }
                }
                else
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "User must be an editor", null);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
        }

        [WebGet(UriTemplate = "V1/site/{sitename}/callbackiteminternal/")]
        [WebHelp(Comment = "INTERNAL USE ONLY")]
        [OperationContract]
        public Stream GetCallbackItemInternal(string sitename)
        {
            try
            {
                ISite site = GetSite(sitename);
                CallingUser viewer = GetCallingUser(site);
                if (viewer.IsUserA(UserTypes.Editor))
                {
                    ExternalLinkModeration exLinkMod = new ExternalLinkModeration(base.dnaDiagnostic, base.readerCreator, base.cacheManager, base.siteList);

                    var exLinkModCallbackItemList = exLinkMod.GetCallbackItemInternal(site.SiteID);
                    return GetOutputStream(exLinkModCallbackItemList);
                }
                else
                {
                    throw new DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "User must be an editor", null);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
        }
    }
}
