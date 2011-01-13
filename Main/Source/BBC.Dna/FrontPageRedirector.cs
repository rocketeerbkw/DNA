using System;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Linq;
using System.Web;
using System.Xml;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class FrontPageRedirectorBuilder : DnaInputComponent
    {
        


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public FrontPageRedirectorBuilder(IInputContext context)
            : base(context)
        {

        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            var location = InputContext.GetSiteOptionValueString("General", "FrontPageLocation");
            var slashLocation = location.IndexOf("/");
            if(slashLocation != 0 && location.IndexOf(".aspx") >= 0)
            {//c# builder so server.
                HttpContext.Current.Server.Transfer(location);
                return;
            }

            if (slashLocation == 0 || location.IndexOf("http") == 0)
            {//leads with trailing slash...
                RootElement.RemoveAll();
                XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                AddAttribute(redirect, "URL", location);
                return;
            }

            //none so redirect to /home (c++ frontpage builder)
            var redirectUrl = string.Format("/dna/{0}/home",InputContext.CurrentSite.SiteName);
            if (InputContext.SkinSelector != null && InputContext.SkinSelector.SkinName != InputContext.CurrentSite.DefaultSkin)
            {//none standard skin in use
                redirectUrl = string.Format("/dna/{0}/{1}/home", InputContext.CurrentSite.SiteName, InputContext.SkinSelector.SkinName);
            }

            RootElement.RemoveAll();
            XmlNode redirectHome = AddElementTag(RootElement, "REDIRECT");
            AddAttribute(redirectHome, "URL", redirectUrl);
            
        }

    }
}