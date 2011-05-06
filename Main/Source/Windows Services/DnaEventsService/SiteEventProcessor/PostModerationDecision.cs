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
using System.Collections.Generic;

namespace Dna.SiteEventProcessor
{
    public class PostModerationDecision
    {

        public static string DataFormatFailed = "A <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was failed in moderation by <USER USERID=\"{7}\">{8}</USER> because it was deemed <NOTES>{9}</NOTES>";
        public static string DataFormatReferred = "A <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was referred by <USER USERID=\"{7}\">{8}</USER> because <NOTES>{9}</NOTES>";
        public static string DataFormatReject = "A complaint on <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was rejected by <USER USERID=\"{7}\">{8}</USER> because <NOTES>{9}</NOTES>";
        public static string DataFormatUpHeld = "A complaint on <POST FORUMID=\"{0}\" POSTID=\"{1}\" THREADID=\"{2}\" URL=\"{3}\">{4}</POST> by <USER USERID=\"{5}\">{6}</USER> was upheld by <USER USERID=\"{7}\">{8}</USER> because <NOTES>{9}</NOTES>";

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
            List<SiteEvent> siteEventList = new List<SiteEvent>();
            try
            {
                SiteEvent siteEvent1 = null;    
                siteEvent1 = new SiteEvent();
                siteEvent1.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEvent1.Date = new Date(dataReader.GetDateTime("DateCreated"));
            
                var statusId = dataReader.GetInt32NullAsZero("status");

                var type = "post";
                if (!string.IsNullOrEmpty(dataReader.GetStringNullAsEmpty("parenturl")))
                {
                    type = "comment";
                }
                
                switch ((ModerationDecisionStatus)statusId)
                {
                    case ModerationDecisionStatus.Fail:
                        siteEvent1.Type = SiteActivityType.ModeratePostFailed;
                        siteEvent1.ActivityData = new XElement("ACTIVITYDATA",
                          string.Format(DataFormatFailed,
                            dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                            dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"), type,
                            dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            dataReader.GetStringNullAsEmpty("ModReason"))
                            );
                        siteEvent1.UserId = dataReader.GetInt32NullAsZero("author_userid");
                        siteEventList.Add(siteEvent1);

                        if (dataReader.GetInt32NullAsZero("complainantid") != 0)
                        {//complaint upheld event
                            var siteEvent2 = new SiteEvent();
                            siteEvent2.SiteId = dataReader.GetInt32NullAsZero("siteid");
                            siteEvent2.Date = new Date(dataReader.GetDateTime("DateCreated"));
                            siteEvent2.Type = SiteActivityType.ComplaintPostUpHeld;
                            siteEvent2.ActivityData = new XElement("ACTIVITYDATA",
                              string.Format(DataFormatUpHeld,
                                dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                                dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"), type,
                                dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                                dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                                dataReader.GetStringNullAsEmpty("ModReason"))
                                );
                            siteEvent2.UserId = dataReader.GetInt32NullAsZero("complainantid");
                            siteEventList.Add(siteEvent2);
                        }
                        break;


                    case ModerationDecisionStatus.Referred:
                        siteEvent1.Type = SiteActivityType.ModeratePostReferred;
                        siteEvent1.ActivityData = new XElement("ACTIVITYDATA",
                         string.Format(DataFormatReferred,
                            dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                            dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"), type,
                            dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            dataReader.GetStringNullAsEmpty("Notes"))
                           );
                        siteEvent1.UserId = dataReader.GetInt32NullAsZero("author_userid");
                        siteEventList.Add(siteEvent1);
                        break;

                    case ModerationDecisionStatus.Passed:
                        if (dataReader.GetInt32NullAsZero("complainantid") != 0)
                        {//complaint rejected
                            siteEvent1.Type = SiteActivityType.ComplaintPostRejected;
                            siteEvent1.ActivityData = new XElement("ACTIVITYDATA",
                             string.Format(DataFormatReject,
                                dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                                dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"), type,
                                dataReader.GetInt32NullAsZero("author_userid"), dataReader.GetStringNullAsEmpty("author_username"),
                                dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                                dataReader.GetStringNullAsEmpty("Notes"))
                               );
                            siteEvent1.UserId = dataReader.GetInt32NullAsZero("complainantid");
                            siteEventList.Add(siteEvent1);
                        }
                        break;
                    default:
                        siteEventList = null;
                        break;
                }

                if (siteEventList != null)
                {
                    foreach (var siteEvent in siteEventList)
                    {
                        siteEvent.SaveEvent(creator);
                    }
                }
            }
            catch(Exception e)
            {
                siteEventList = null;
                SiteEventsProcessor.SiteEventLogger.LogException(e);
            }



            return null;
        }


       
    }
}

