using System;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;
using BBC.DNA.Moderation.Utils;
using BBC.Dna.Moderation;
using System.Xml;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using BBC.Dna.Objects;
using System.Xml.Linq;

namespace Dna.SiteEventProcessor
{
    public class ArticleModerationDecision
    {

        public static string DataFormatFailed = "An <ARTICLE h2g2id=\"{0}\">article</ARTICLE> by <USER USERID=\"{1}\">{2}</USER> was failed in moderation by <USER USERID=\"{3}\">{4}</USER> because it was deemed <NOTES>{5}</NOTES>";
        public static string DataFormatReferred = "An <ARTICLE h2g2id=\"{0}\">article</ARTICLE> by <USER USERID=\"{1}\">{2}</USER> was referred by <USER USERID=\"{3}\">{4}</USER> because <NOTES>{5}</NOTES>";

        public ArticleModerationDecision()
        {
        }


        static public void ProcessArticleModerationDecisionActivity(IDnaDataReaderCreator DataReaderCreator)
        {
        //Get Article Moderation Events
                using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getsiteevents_articlemoderationdecision"))
                {
                    reader.Execute();
                    while (reader.Read())
                    {
                        ArticleModerationDecision.CreateArticleModerationDecisionActivity(reader, DataReaderCreator);
                    }
                }
        }


        static public SiteEvent CreateArticleModerationDecisionActivity(IDnaDataReader dataReader, IDnaDataReaderCreator creator)
        {
            SiteEvent siteEventArticleModerationDecision = null;
            try
            {
                siteEventArticleModerationDecision = new SiteEvent();
                siteEventArticleModerationDecision.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEventArticleModerationDecision.Date = new Date(dataReader.GetDateTime("DateCreated"));
            
                var statusId = dataReader.GetInt32NullAsZero("statusid");

                
                switch ((ModerationDecisionStatus)statusId)
                {
                    case ModerationDecisionStatus.Fail:
                        siteEventArticleModerationDecision.Type = SiteActivityType.ModerateArticleFailed;
                        siteEventArticleModerationDecision.ActivityData = new XElement("ACTIVITYDATA",
                            string.Format(DataFormatFailed, dataReader.GetInt32NullAsZero("h2g2id"),
                            dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            dataReader.GetStringNullAsEmpty("ModReason")
                            ));

                        break;


                    case ModerationDecisionStatus.Referred:
                        siteEventArticleModerationDecision.Type = SiteActivityType.ModerateArticleReferred;
                        siteEventArticleModerationDecision.ActivityData = new XElement("ACTIVITYDATA",
                            string.Format(DataFormatReferred, dataReader.GetInt32NullAsZero("h2g2id"),
                            dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            dataReader.GetStringNullAsEmpty("Notes"))
                            );
                        break;

                    default:
                        siteEventArticleModerationDecision = null;
                        break;
                }
                siteEventArticleModerationDecision.UserId = 0;
                siteEventArticleModerationDecision.SaveEvent(creator);
            }
            catch(Exception e)
            {
                siteEventArticleModerationDecision = null;
                SiteEventsProcessor.SiteEventLogger.LogException(e);
            }

            return siteEventArticleModerationDecision;
        }


       
    }
}

