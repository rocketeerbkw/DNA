using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
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
        private TopicPage _topicPage;



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
            //Assemble page parts.
            RootElement.RemoveAll();
            if (InputContext.ViewingUser.IsSuperUser == false && InputContext.ViewingUser.IsEditor == false)
            {
                SerialiseAndAppend(new Error { Type = "Access Denied", ErrorMessage = "Access denied" }, "");
                return;
            }

            _siteConfig = SiteConfig.GetPreviewSiteConfig(InputContext.CurrentSite.SiteID, AppContext.ReaderCreator);
            _topicPage = new TopicPage { Page = "PREVIEW" };
            _topicPage.TopicElementList = TopicElementList.GetTopicListFromDatabase(AppContext.ReaderCreator,
                                                                         InputContext.CurrentSite.SiteID,
                                                                         TopicStatus.Preview);


            GetQueryParameters();
            var result = ProcessCommand();
            if(result != null)
            {
                SerialiseAndAppend(result, "");
            }

            
            var previewElement = AddElementTag(RootElement, "SITECONFIGPREVIEW");
            var editKeyElement = AddElementTag(previewElement, "EDITKEY");
            editKeyElement.InnerText = _siteConfig.EditKey.ToString();
            SerialiseAndAppend(_siteConfig, "/DNAROOT/SITECONFIGPREVIEW");


            SerialiseAndAppend(_topicPage, "");                
            
            
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
                    return UpdateConfig(true);

                case "UPDATETOPIC":
                    return UpdateTopic();

                case "UPDATETOPICPOSITIONS":
                    return UpdateTopicPositions();
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private BaseResult UpdateTopic()
        {
            TopicElement element;
            var topicId = InputContext.GetParamIntOrZero("topicid","topicid");
            if (topicId == 0)
            {
                element = new TopicElement{SiteId = InputContext.CurrentSite.SiteID};
            }
            else
            {
                
                element = _topicPage.TopicElementList.GetTopicElementById(topicId);

                if (element == null)
                {
                    return new Error("InvalidTopicId", "The topic id passed was invalid.");
                }
            }

            if (!String.IsNullOrEmpty(InputContext.GetParamStringOrEmpty("topiceditkey", "topiceditkey")))
            {
                element.Editkey = new Guid(InputContext.GetParamStringOrEmpty("topiceditkey", "topiceditkey"));
            }
            if (!String.IsNullOrEmpty(InputContext.GetParamStringOrEmpty("fptopiceditkey", "fptopiceditkey")))
            {
                element.FrontPageElement.Editkey = new Guid(InputContext.GetParamStringOrEmpty("fptopiceditkey", "fptopiceditkey"));
            }

            element.FrontPageElement.Title = InputContext.GetParamStringOrEmpty("fp_title", "fp_title");
            element.FrontPageElement.Text = InputContext.GetParamStringOrEmpty("fp_text", "fp_text");
            if (InputContext.GetParamStringOrEmpty("fp_templatetype", "fp_templatetype") == string.Empty)
            {
                element.FrontPageElement.ImageName = InputContext.GetParamStringOrEmpty("fp_imagename", "fp_imagename");
                element.FrontPageElement.ImageAltText = InputContext.GetParamStringOrEmpty("fp_imagealttext", "fp_imagealttext");
                element.FrontPageElement.Template = FrontPageTemplate.ImageAboveText;
            }
            else
            {
                element.FrontPageElement.ImageName = "";
                element.FrontPageElement.ImageAltText = "";
                element.FrontPageElement.Template = FrontPageTemplate.TextOnly;
            }
            element.Title = InputContext.GetParamStringOrEmpty("topictitle","topictitle");
            element.Description = "<GUIDE><BODY>" + InputContext.GetParamStringOrEmpty("topictext","topictext") + "</BODY></GUIDE>";

            if (topicId == 0)
            {
                var result = element.CreateTopic(AppContext.ReaderCreator, InputContext.CurrentSite.SiteID, InputContext.ViewingUser.UserID);
                if (result.GetType() == typeof(Error))
                {
                    return result;
                }
                _topicPage.TopicElementList.Topics.Add(element);
                return new Result("TopicCreateSuccessful", "New topic created");
            }
            else
            {
                var result = element.UpdateTopic(AppContext.ReaderCreator, InputContext.ViewingUser.UserID);
                if (result.GetType().Name == typeof(Error).Name)
                {
                    return result;
                }
                return new Result("TopicUpdateSuccessful", "Existing topic editted");
            }
            
        }

        /// <summary>
        /// Updates the config in the database
        /// </summary>
        /// <param name="updateLiveConfig"></param>
        /// <returns></returns>
        private BaseResult UpdateConfig(bool updateLiveConfig)
        {
            if (InputContext.DoesParamExist("editkey", "The editkey"))
            {
                _siteConfig.EditKey = new Guid(InputContext.GetParamStringOrEmpty("editkey", "The editkey"));
            }
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

            if (InputContext.DoesParamExist("TOPICLAYOUT", "TOPICLAYOUT"))
            {
                _siteConfig.V2Board.TopicLayout = InputContext.GetParamStringOrEmpty("TOPICLAYOUT", "TOPICLAYOUT");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.TopicLayout))
                {
                    return new Error("InvalidTopicLayout", "Unable to update due to an invalid topic layout.");
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

            if (InputContext.DoesParamExist("CSS_LOCATION", "CSS_LOCATION"))
            {
                _siteConfig.V2Board.CssLocation = InputContext.GetParamStringOrEmpty("CSS_LOCATION", "CSS_LOCATION");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.CssLocation))
                {
                    return new Error("InvalidCssLocation", "Unable to update due to an invalid CSS location.");
                }
            }

            if (InputContext.DoesParamExist("EMOTICON_LOCATION", "EMOTICON_LOCATION"))
            {
                _siteConfig.V2Board.EmoticonLocation = InputContext.GetParamStringOrEmpty("EMOTICON_LOCATION", "EMOTICON_LOCATION");
                if (String.IsNullOrEmpty(_siteConfig.V2Board.EmoticonLocation))
                {
                    return new Error("InvalidEmoticonLocation", "Unable to update due to an invalid emoticon location.");
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


            var result= _siteConfig.UpdateConfig(AppContext.ReaderCreator, updateLiveConfig);

            if (updateLiveConfig && result.Type == "SiteConfigUpdateSuccess")
            {
                InputContext.SendSignal("action=recache-site");
            }

            return result;
        }

        private BaseResult UpdateTopicPositions()
        {
            BaseResult lastResult = null;
            foreach (var topic in _topicPage.TopicElementList.Topics)
            {
                var field = String.Format("topic_{0}_position", topic.TopicId);
                if (InputContext.DoesParamExist(field, field))
                {
                    var position = InputContext.GetParamIntOrZero(field,field);
                    if (position > 0)
                    {
                        topic.FrontPageElement.Position = position;
                        topic.Position = position;
                        lastResult = topic.UpdateTopic(AppContext.ReaderCreator, InputContext.ViewingUser.UserID);
                    }
                }
            }

            var sortedTopics = from topic in _topicPage.TopicElementList.Topics
                                                 orderby topic.Position ascending
                                                 select topic;
            _topicPage.TopicElementList.Topics = sortedTopics.ToList<TopicElement>();

            return lastResult;
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _cmd = InputContext.GetParamStringOrEmpty("cmd", "Which command to execute.");

            
        }
    }
}