using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class MBAdminDesignBuilder : DnaInputComponent
    {
        private string _cmd = String.Empty;
        private SiteConfig _siteConfig;



        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public MBAdminDesignBuilder(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            if (InputContext.ViewingUser.IsSuperUser == false && InputContext.ViewingUser.IsEditor == false)
            {
                SerialiseAndAppend(new Error { Type = "Access Denied", ErrorMessage = "Access denied" }, "");
                return;
            }

            _siteConfig = SiteConfig.GetPreviewSiteConfig(InputContext.CurrentSite.SiteID, AppContext.ReaderCreator);

            GetQueryParameters();
            var result = ProcessCommand();
            if(result != null)
            {
                SerialiseAndAppend(result, "");
            }

            //Assemble page parts.
            RootElement.RemoveAll();
            var previewElement = AddElementTag(RootElement, "SITECONFIGPREVIEW");
            var editKeyElement = AddElementTag(previewElement, "EDITKEY");
            editKeyElement.InnerText = _siteConfig.EditKey.ToString();
            SerialiseAndAppend(_siteConfig, "/DNAROOT/SITECONFIGPREVIEW");
            
            
        }

        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private BaseResult ProcessCommand()
        {

            switch (_cmd.ToUpper())
            {
                case "UPDATEPREVIEW":
                    return UpdateConfig(false);
                    

                case "UPDATEPREVIEWANDLIVE":
                    return UpdateConfig(false);
            }
            return null;
        }

        /// <summary>
        /// Updates the config in the database
        /// </summary>
        /// <param name="updateLiveConfig"></param>
        /// <returns></returns>
        private BaseResult UpdateConfig(bool updateLiveConfig)
        {
            if(_siteConfig.EditKey == Guid.Empty)
            {
                return new Error("MissingEditKey","Unable to update due to missing edit key");
            }

            if (InputContext.DoesParamExist("HEADER_COLOUR", "header_colour"))
            {
                _siteConfig.V2Board.HeaderColour = InputContext.GetParamStringOrEmpty("HEADER_COLOUR", "header_colour");
                if(String.IsNullOrEmpty(_siteConfig.V2Board.HeaderColour))
                {
                    return new Error("InvalidHeaderColour", "Unable to update due to an invalid header colour.");
                }
            }

            if (InputContext.DoesParamExist("BANNER_SSI", "BANNER_SSI"))
            {
                _siteConfig.V2Board.BannerSsi = InputContext.GetParamStringOrEmpty("BANNER_SSI", "BANNER_SSI");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.BannerSsi))
                {
                    return new Error("InvalidBannerSSi", "Unable to update due to an invalid banner SSI location.");
                }
            }

            if (InputContext.DoesParamExist("HORIZONTAL_NAV_SSI", "HORIZONTAL_NAV_SSI"))
            {
                _siteConfig.V2Board.HorizontalNavSsi = InputContext.GetParamStringOrEmpty("HORIZONTAL_NAV_SSI", "HORIZONTAL_NAV_SSI");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.HorizontalNavSsi))
                {
                    return new Error("InvalidHorizontalNavSSi", "Unable to update due to an invalid horizontal navigation SSI location.");
                }
            }

            if (InputContext.DoesParamExist("LEFT_NAV_SSI", "LEFT_NAV_SSI"))
            {
                _siteConfig.V2Board.LeftNavSsi = InputContext.GetParamStringOrEmpty("LEFT_NAV_SSI", "LEFT_NAV_SSI");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.LeftNavSsi))
                {
                    return new Error("InvalidLeftNavSSi", "Unable to update due to an invalid left navigation SSI location.");
                }
            }

            if (InputContext.DoesParamExist("WELCOME_MESSAGE", "WELCOME_MESSAGE"))
            {
                _siteConfig.V2Board.WelcomeMessage = InputContext.GetParamStringOrEmpty("WELCOME_MESSAGE", "WELCOME_MESSAGE");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.WelcomeMessage))
                {
                    return new Error("InvalidWelcomeMessage", "Unable to update due to an invalid welcome message.");
                }
            }

            if (InputContext.DoesParamExist("ABOUT_MESSAGE", "ABOUT_MESSAGE"))
            {
                _siteConfig.V2Board.AboutMessage = InputContext.GetParamStringOrEmpty("ABOUT_MESSAGE", "ABOUT_MESSAGE");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.AboutMessage))
                {
                    return new Error("InvalidAboutMessage", "Unable to update due to an invalid about message.");
                }
            }

            if (InputContext.DoesParamExist("OPENCLOSETIMES_TEXT", "OPENCLOSETIMES_TEXT"))
            {
                _siteConfig.V2Board.OpenclosetimesText = InputContext.GetParamStringOrEmpty("OPENCLOSETIMES_TEXT", "OPENCLOSETIMES_TEXT");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.OpenclosetimesText))
                {
                    return new Error("InvalidOpenCloseMessage", "Unable to update due to an invalid open/close message.");
                }
            }

            if (InputContext.DoesParamExist("FOOTER_COLOUR", "FOOTER_COLOUR"))
            {
                _siteConfig.V2Board.Footer.Colour = InputContext.GetParamStringOrEmpty("FOOTER_COLOUR", "FOOTER_COLOUR");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.Footer.Colour))
                {
                    return new Error("InvalidFooterColour", "Unable to update due to an invalid footer colour.");
                }
            }

            if (InputContext.DoesParamExist("RECENTDISCUSSIONS_SUBMIT", "RECENTDISCUSSIONS_SUBMIT"))
            {
                _siteConfig.V2Board.Recentdiscussions =
                    InputContext.GetParamStringOrEmpty("RECENTDISCUSSIONS", "RECENTDISCUSSIONS") == "1";
            }

            if (InputContext.DoesParamExist("SOCIALTOOLBAR_SUBMIT", "SOCIALTOOLBAR_SUBMIT"))
            {
                _siteConfig.V2Board.Socialtoolbar =
                    InputContext.GetParamStringOrEmpty("SOCIALTOOLBAR", "SOCIALTOOLBAR") == "1";
            }

            if (InputContext.DoesParamExist("FOOTER_LINK", "FOOTER_LINK"))
            {
                var links = InputContext.GetParamStringOrEmpty("FOOTER_LINK", "FOOTER_LINK").Split(',');
                var linkCollection = new StringCollection();
                foreach(var link in links)
                {
                    if(!String.IsNullOrEmpty(link))
                    {
                        linkCollection.Add(link);
                    }
                }
                if(linkCollection.Count == 0)
                {
                    return new Error("InvalidFooterLinks", "Unable to update due to no valid footer links available.");
                }
                _siteConfig.V2Board.Footer.Links = linkCollection;

            }

            if (InputContext.DoesParamExist("MODULE_LINK", "MODULE_LINK"))
            {
                var links = InputContext.GetParamStringOrEmpty("MODULE_LINK", "MODULE_LINK").Split(',');
                var linkCollection = new StringCollection();
                foreach (var link in links)
                {
                    if (!String.IsNullOrEmpty(link))
                    {
                        linkCollection.Add(link);
                    }
                }
                if (linkCollection.Count == 0)
                {
                    return new Error("InvalidModuleLinks", "Unable to update due to no valid module links available.");
                }
                _siteConfig.V2Board.Modules.Links = linkCollection;

            }


            return _siteConfig.UpdateConfig(AppContext.ReaderCreator, updateLiveConfig);
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _cmd = InputContext.GetParamStringOrEmpty("cmd", "Which command to execute.");

            if(InputContext.DoesParamExist("editkey", "The editkey"))
            {
                _siteConfig.EditKey = new Guid(InputContext.GetParamStringOrEmpty("editkey", "The editkey"));
            }
        }
    }
}