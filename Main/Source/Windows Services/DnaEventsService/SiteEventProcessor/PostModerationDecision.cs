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
    public class PostModerationDecision
    {

        public static string DataFormatFailed = "A <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was failed in moderation by <USER USERID=\"{7}\">{8}</USER> because it was deemed <NOTES>{9}</NOTES>";
        public static string DataFormatReferred = "A <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was referred by <USER USERID=\"{7}\">{8}</USER> because <NOTES>{9}</NOTES>";

        public PostModerationDecision()
        {
        }

        static public void ProcessPostModerationDecisionActivity(IDnaDataReaderCreator DataReaderCreator)
        {
            //Get Article Moderation Events
            using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getsiteevents_postmoderationdecision"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    CreatePostModerationDecisionActivity(reader, DataReaderCreator);
                }
            }
        }



        static public SiteEvent CreatePostModerationDecisionActivity(IDnaDataReader dataReader, IDnaDataReaderCreator creator)
        {
            SiteEvent siteEvent = null;
            try
            {
                siteEvent = new SiteEvent();
                siteEvent.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEvent.Date = new Date(dataReader.GetDateTime("DateCreated"));
            
                var statusId = dataReader.GetInt32NullAsZero("status");

                var type = "post";
                if (!string.IsNullOrEmpty(dataReader.GetStringNullAsEmpty("parenturl")))
                {
                    type = "comment";
                }
                
                switch ((ModerationDecisionStatus)statusId)
                {
                    case ModerationDecisionStatus.Fail:
                        siteEvent.Type = SiteActivityType.ModeratePostFailed;
                        siteEvent.ActivityData = new XElement("ACTIVITYDATA",
                          string.Format(DataFormatFailed,
                            dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                            dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"), type,
                            dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            dataReader.GetStringNullAsEmpty("ModReason"))
                            );

                        break;


                    case ModerationDecisionStatus.Referred:
                        siteEvent.Type = SiteActivityType.ModeratePostReferred;
                        siteEvent.ActivityData = new XElement("ACTIVITYDATA",
                         string.Format(DataFormatReferred,
                            dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                            dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"), type,
                            dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            dataReader.GetStringNullAsEmpty("Notes"))
                           );
                        break;

                    default:
                        siteEvent = null;
                        break;
                }

                if (siteEvent != null)
                {
                    siteEvent.SaveEvent(creator);
                }
            }
            catch(Exception e)
            {
                siteEvent = null;
                SiteEventsProcessor.SiteEventLogger.LogException(e);
            }

            

            return siteEvent;
        }


       
    }
}

