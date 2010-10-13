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
                                                                         TopicStatus.Preview, false);


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


                case "PUBLISHMESSAGEBOARD":
                    return PublishMessageBoard();

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

            // Check to see if we're creating a new topic element for an existing topic, or have been given bad data
            if (!String.IsNullOrEmpty(InputContext.GetParamStringOrEmpty("fptopiceditkey", "fptopiceditkey")))
            {
                element.FrontPageElement.Editkey = new Guid(InputContext.GetParamStringOrEmpty("fptopiceditkey", "fptopiceditkey"));
            }

            element.FrontPageElement.Title = HtmlUtils.RemoveAllHtmlTags(InputContext.GetParamStringOrEmpty("fp_title", "fp_title"));
            if (element.FrontPageElement.Title.Length == 0)
            {
                return new Error("TopicElementTitleMissing", "No topic element title given.");
            }

            element.FrontPageElement.Text = ExtractHtmlInput("fp_text");

            if (InputContext.GetParamStringOrEmpty("fp_templatetype", "fp_templatetype") == string.Empty)
            {
                element.FrontPageElement.ImageName = InputContext.GetParamStringOrEmpty("fp_imagename", "fp_imagename");
                if (element.FrontPageElement.ImageName.Length == 0)
                {
                    return new Error("ImageNameMissing", "No image name given.");
                }
                element.FrontPageElement.ImageAltText = InputContext.GetParamStringOrEmpty("fp_imagealttext", "fp_imagealttext");
                if (element.FrontPageElement.ImageAltText.Length == 0)
                {
                    return new Error("AltTextMissing", "No alt text given.");
                }
                element.FrontPageElement.Template = FrontPageTemplate.ImageAboveText;
            }
            else
            {
                element.FrontPageElement.ImageName = "";
                element.FrontPageElement.ImageAltText = "";
                element.FrontPageElement.Template = FrontPageTemplate.TextOnly;
            }
            element.Title = HtmlUtils.RemoveAllHtmlTags(InputContext.GetParamStringOrEmpty("topictitle","topictitle"));
            if (element.Title.Length == 0)
            {
                return new Error("TopicTitleMissing", "No topic title given.");
            }
            element.Description = ExtractHtmlInput("topictext");


            if (topicId == 0)
            {
                var result = element.CreateTopic(AppContext.ReaderCreator, InputContext.CurrentSite.SiteID, InputContext.ViewingUser.UserID);
                if (result.IsError())
                {
                    return result;
                }
                _topicPage.TopicElementList.Topics.Add(element);
                return new Result("TopicCreateSuccessful", "New topic created");
            }
            else
            {
                // Check to see if we need to create the element first before updating.
                if (element.FrontPageElement.Elementid == 0)
                {
                    var result = element.FrontPageElement.CreateFrontPageElement(AppContext.ReaderCreator, InputContext.CurrentSite.SiteID, InputContext.ViewingUser.UserID);
                    if (result.IsError())
                    {
                        return result;
                    }
                }

                var result2 = element.UpdateTopic(AppContext.ReaderCreator, InputContext.ViewingUser.UserID);
                if (result2.IsError())
                {
                    return result2;
                }
                return new Result("TopicUpdateSuccessful", "Existing topic editted");
            }
            
        }

        /// <summary>
        /// Helper to get valid html or escaped version
        /// </summary>
        /// <param name="querystringParam"></param>
        /// <returns></returns>
        private string ExtractHtmlInput(string querystringParam)
        {
            var paramStr = HtmlUtils.HtmlDecode(InputContext.GetParamStringOrEmpty(querystringParam, querystringParam));

            paramStr = paramStr.Replace("\r\n", "");
            return "<GUIDE>" + HtmlUtils.ParseHtmlToXmlElement(paramStr, "BODY").OuterXml + "</GUIDE>";
            
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
                try
                {
                    _siteConfig.EditKey = new Guid(InputContext.GetParamStringOrEmpty("editkey", "The editkey"));
                }
                catch 
                {
                    _siteConfig.EditKey = Guid.Empty;
                }
            }
            if(_siteConfig.EditKey == Guid.Empty)
            {
                return new Error("MissingEditKey","Unable to update due to missing edit key");
            }

            if (InputContext.DoesParamExist("HEADER_COLOUR", "header_colour"))
            {
                _siteConfig.V2Board.HeaderColour = InputContext.GetParamStringOrEmpty("HEADER_COLOUR", "header_colour").Trim();
                if(String.IsNullOrEmpty(_siteConfig.V2Board.HeaderColour))
                {
                    return new Error("InvalidHeaderColour", "Unable to update due to an invalid header colour.");
                }
            }

            if (InputContext.DoesParamExist("TOPICLAYOUT", "TOPICLAYOUT"))
            {
                _siteConfig.V2Board.TopicLayout = InputContext.GetParamStringOrEmpty("TOPICLAYOUT", "TOPICLAYOUT").Trim();
                if (String.IsNullOrEmpty(_siteConfig.V2Board.TopicLayout))
                {
                    return new Error("InvalidTopicLayout", "Unable to update due to an invalid topic layout.");
                }
            }

            if (InputContext.DoesParamExist("BANNER_SSI", "BANNER_SSI"))
            {
                _siteConfig.V2Board.BannerSsi = InputContext.GetParamStringOrEmpty("BANNER_SSI", "BANNER_SSI").Trim();
            }

            if (InputContext.DoesParamExist("HORIZONTAL_NAV_SSI", "HORIZONTAL_NAV_SSI"))
            {
                _siteConfig.V2Board.HorizontalNavSsi = InputContext.GetParamStringOrEmpty("HORIZONTAL_NAV_SSI", "HORIZONTAL_NAV_SSI").Trim();
            }

            if (InputContext.DoesParamExist("LEFT_NAV_SSI", "LEFT_NAV_SSI"))
            {
                _siteConfig.V2Board.LeftNavSsi = InputContext.GetParamStringOrEmpty("LEFT_NAV_SSI", "LEFT_NAV_SSI").Trim();
            }

            if (InputContext.DoesParamExist("WELCOME_MESSAGE", "WELCOME_MESSAGE"))
            {
                _siteConfig.V2Board.WelcomeMessage = HtmlUtils.ParseHtmlToXmlElement(InputContext.GetParamStringOrEmpty("WELCOME_MESSAGE", "WELCOME_MESSAGE"), "WELCOME_MESSAGE").InnerXml;
                if (String.IsNullOrEmpty(_siteConfig.V2Board.WelcomeMessage))
                {
                    return new Error("InvalidWelcomeMessage", "Unable to update due to an invalid welcome message.");
                }
            }

            if (InputContext.DoesParamExist("ABOUT_MESSAGE", "ABOUT_MESSAGE"))
            {
                _siteConfig.V2Board.AboutMessage = HtmlUtils.ParseHtmlToXmlElement(InputContext.GetParamStringOrEmpty("ABOUT_MESSAGE", "ABOUT_MESSAGE"), "ABOUT_MESSAGE").InnerXml;
                if (String.IsNullOrEmpty(_siteConfig.V2Board.AboutMessage))
                {
                    return new Error("InvalidAboutMessage", "Unable to update due to an invalid about message.");
                }
            }

            if (InputContext.DoesParamExist("OPENCLOSETIMES_TEXT", "OPENCLOSETIMES_TEXT"))
            {
                _siteConfig.V2Board.OpenclosetimesText = HtmlUtils.ParseHtmlToXmlElement(InputContext.GetParamStringOrEmpty("OPENCLOSETIMES_TEXT", "OPENCLOSETIMES_TEXT"), "OPENCLOSETIMES_TEXT").InnerXml;
                if (String.IsNullOrEmpty(_siteConfig.V2Board.OpenclosetimesText))
                {
                    return new Error("InvalidOpenCloseMessage", "Unable to update due to an invalid open/close message.");
                }
            }

            if (InputContext.DoesParamExist("FOOTER_COLOUR", "FOOTER_COLOUR"))
            {
                _siteConfig.V2Board.Footer.Colour = InputContext.GetParamStringOrEmpty("FOOTER_COLOUR", "FOOTER_COLOUR").Trim();
                if (String.IsNullOrEmpty(_siteConfig.V2Board.Footer.Colour))
                {
                    return new Error("InvalidFooterColour", "Unable to update due to an invalid footer colour.");
                }
            }

            if (InputContext.DoesParamExist("CSS_LOCATION", "CSS_LOCATION"))
            {
                _siteConfig.V2Board.CssLocation = InputContext.GetParamStringOrEmpty("CSS_LOCATION", "CSS_LOCATION").Trim();
            }

            if (InputContext.DoesParamExist("EMOTICON_LOCATION", "EMOTICON_LOCATION"))
            {
                _siteConfig.V2Board.EmoticonLocation = InputContext.GetParamStringOrEmpty("EMOTICON_LOCATION", "EMOTICON_LOCATION").Trim();
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
                    if (!String.IsNullOrEmpty(link.Trim()))
                    {
                        linkCollection.Add(link.Trim());
                    }
                }
                _siteConfig.V2Board.Footer.Links = linkCollection;

            }

            if (InputContext.DoesParamExist("MODULE_LINK", "MODULE_LINK"))
            {
                var links = InputContext.GetParamStringOrEmpty("MODULE_LINK", "MODULE_LINK").Split(',');
                var linkCollection = new StringCollection();
                foreach (var link in links)
                {
                    if (!String.IsNullOrEmpty(link.Trim()))
                    {
                        linkCollection.Add(link.Trim());
                    }
                }
                _siteConfig.V2Board.Modules.Links = linkCollection;

            }


            var result= _siteConfig.UpdateConfig(AppContext.ReaderCreator, updateLiveConfig);

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
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
        /// 
        /// </summary>
        /// <returns></returns>
        private BaseResult PublishMessageBoard()
        {
            MessageBoardPublishError error = new MessageBoardPublishError();
            if (String.IsNullOrEmpty(_siteConfig.V2Board.AboutMessage))
            {
                error.DesignErrors.Add("MissingAboutText");
            }
            if (String.IsNullOrEmpty(_siteConfig.V2Board.WelcomeMessage))
            {
                error.DesignErrors.Add("MissingWelcomeMessage");
            }
            if (_topicPage.TopicElementList.Topics.Count ==0)
            {
                error.DesignErrors.Add("MissingTopics");
            }
            if (error.AdminErrors.Count != 0 || error.DesignErrors.Count != 0)
            {
                foreach (string adminError in error.AdminErrors)
                {
                    InputContext.Diagnostics.WriteToLog("MBAdmin-AdminError", adminError);
                }
                foreach (string adminError in error.DesignErrors)
                {
                    InputContext.Diagnostics.WriteToLog("MBAdmin-DesignError", adminError);
                }
                return error;
            }

            BaseResult result = UpdateConfig(true);
            if (result.IsError())
            {
                return result;
            }
            result = TopicElement.MakePreviewTopicsActiveForSiteID(AppContext.ReaderCreator, InputContext.CurrentSite.SiteID, InputContext.ViewingUser.UserID);
            if (result.IsError())
            {
                return result;
            }

            result = InputContext.CurrentSite.UpdateEveryMessageBoardAdminStatusForSite(AppContext.ReaderCreator, MessageBoardAdminStatus.Unread);
            if (result.IsError())
            {
                return result;
            }

            //force to use new boards v2 skin
            result = InputContext.CurrentSite.AddSkinAndMakeDefault("vanilla", "boards_v2", "barlesque message board skin", false, AppContext.ReaderCreator);
            if (result.IsError())
            {
                InputContext.Diagnostics.WriteToLog(result.Type, ((Error)result).ErrorMessage);
            }

            AppContext.TheAppContext.TheSiteList.SendSignal(InputContext.CurrentSite.SiteID);

            return new Result("PublishMessageBoard", "Message board update successful.");
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