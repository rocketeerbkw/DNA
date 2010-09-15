using System;
using System.ServiceModel;
using System.ServiceModel.Web;
using BBC.Dna.Sites;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using Microsoft.ServiceModel.Web;
using BBC.Dna.Moderation;

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
        public void CreateModerationItem(string sitename, ModerationItem modItem )
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
                    throw new  DnaWebProtocolException(System.Net.HttpStatusCode.Unauthorized, "User must be an editor", null);
                }
            }
            catch (DnaException ex)
            {
                throw new DnaWebProtocolException(System.Net.HttpStatusCode.InternalServerError, ex.Message, ex);
            }
            
        }

        
    }
}
