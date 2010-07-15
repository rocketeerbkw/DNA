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
    public class MBBackupRestore : DnaInputComponent
    {
        private string _cmd = String.Empty;
        private MessageBoardBackup _messageBoardBackup;
        


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public MBBackupRestore(IInputContext context)
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

            InitialiseBackup();


            GetQueryParameters();
            var result = ProcessCommand();
            if(result != null)
            {
                SerialiseAndAppend(result, "");
            }

            SerialiseAndAppend(_messageBoardBackup, "");

           
        }

        private void InitialiseBackup()
        {
            _messageBoardBackup = new MessageBoardBackup();
            _messageBoardBackup.SiteConfig = SiteConfig.GetPreviewSiteConfig(InputContext.CurrentSite.SiteID, AppContext.ReaderCreator);
            _messageBoardBackup.SiteConfig.LegacyElements = null;//wipe out old config
            _messageBoardBackup.TopicPage = new TopicPage { Page = "PREVIEW" };
            _messageBoardBackup.TopicPage.TopicElementList = TopicElementList.GetTopicListFromDatabase(AppContext.ReaderCreator,
                                                                         InputContext.CurrentSite.SiteID,
                                                                         TopicStatus.Preview, false);
        }

        /// <summary>
        /// Takes the cmd parameter from querystring and do the processing based on the result.
        /// </summary>
        private BaseResult ProcessCommand()
        {

            switch (_cmd.ToUpper())
            {
                case "BACKUP":
                    BackupBoard(); break;
                case "RESTORE":
                    return RestoreBoard();
            }
            return null;
        }

        private void BackupBoard()
        {
            var backupXml = StringUtils.SerializeToXmlUsingXmlSerialiser(_messageBoardBackup);
            
        }

        /// <summary>
        /// Deserialises and adds/updates topics
        /// </summary>
        /// <returns></returns>
        private BaseResult RestoreBoard()
        {
            var restoreXml = InputContext.GetParamStringOrEmpty("RestoreBoardText", "the object to restore");
            if (String.IsNullOrEmpty(restoreXml))
            {
                return new Error("RestoreBoard", "Empty xml to restore from.");
            }

            restoreXml = HtmlUtils.TryParseToValidHtml(restoreXml).Trim();

            MessageBoardBackup newMessageBoardBackup = null;
            try
            {

                newMessageBoardBackup = (MessageBoardBackup)StringUtils.DeserializeObjectUsingXmlSerialiser("<?xml version=\"1.0\"?>" + restoreXml.Trim(), typeof(MessageBoardBackup));
            }
            catch (Exception e)
            {
                InputContext.Diagnostics.WriteExceptionToLog(e);
                return new Error("RestoreBoardText", "Unable to deserialise XML - " + e.Message);
            }

            //update config first
            newMessageBoardBackup.SiteConfig.EditKey = _messageBoardBackup.SiteConfig.EditKey;//save edit key
            newMessageBoardBackup.SiteConfig.SiteId = InputContext.CurrentSite.SiteID;

            var result = newMessageBoardBackup.SiteConfig.UpdateConfig(AppContext.ReaderCreator, false);
            if (result.IsError())
            {
                return result;
            }

            //update topics
            foreach (var topic in newMessageBoardBackup.TopicPage.TopicElementList.Topics)
            {
                var existingTopic = _messageBoardBackup.TopicPage.TopicElementList.GetTopicElementById(topic.TopicId);
                if (existingTopic != null)
                {
                    topic.Editkey = existingTopic.Editkey;
                    topic.FrontPageElement.Editkey = existingTopic.FrontPageElement.Editkey;
                    result = topic.UpdateTopic(AppContext.ReaderCreator, InputContext.ViewingUser.UserID);
                }
                else
                {
                    topic.TopicId = 0;
                    topic.FrontPageElement.Elementid = 0;
                    result = topic.CreateTopic(AppContext.ReaderCreator, InputContext.CurrentSite.SiteID, InputContext.ViewingUser.UserID);
                }
                
                
                if (result.IsError())
                {
                    return result;
                }
            }

            return new Result("RestoreBoard", "Board restored correctly");
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