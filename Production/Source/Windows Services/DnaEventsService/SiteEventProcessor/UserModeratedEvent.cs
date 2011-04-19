using System;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;
using BBC.DNA.Moderation.Utils;
using BBC.Dna.Moderation;
using System.Xml;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;

namespace Dna.SiteEventProcessor
{
    public class UserModeratedEvent
    {

        public static string DataFormat = "<USER USERID=\"{0}\">{1}</USER> was <MODERATIONSTATUS ID=\"{2}\">{3}</MODERATIONSTATUS> on <SITE ID=\"{4}\" /> by <USER USERID=\"{5}\">{6}</USER>{7} because <NOTES>{8}</NOTES>";


        public UserModeratedEvent()
        {
        }

        static public void ProcessUserModatedEventActivity(IDnaDataReaderCreator DataReaderCreator)
        {
            using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getsiteevents_usermoderation"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    CreateUserModatedEventActivity(reader, DataReaderCreator);
                }
            }
            
        }



        static public SiteEvent CreateUserModatedEventActivity(IDnaDataReader dataReader, IDnaDataReaderCreator creator)
        {
            SiteEvent siteEvent = null;
            try
            {
                siteEvent = new SiteEvent();
                siteEvent.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEvent.Date = new Date(dataReader.GetDateTime("DateCreated"));

                var duration = "";
                var moderationStatus = "";
                switch ((ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("status"))
                {
                    case ModerationStatus.UserStatus.Postmoderated:
                        siteEvent.Type =  SiteActivityType.UserModeratedPostMod;
                        moderationStatus = "postmoderated";
                        break;

                    case ModerationStatus.UserStatus.Premoderated:
                        siteEvent.Type =  SiteActivityType.UserModeratedPremod;
                        moderationStatus = "premoderated";
                        break;

                    case ModerationStatus.UserStatus.Restricted:
                        siteEvent.Type =  SiteActivityType.UserModeratedBanned;
                        moderationStatus = "banned";
                        break;

                     case ModerationStatus.UserStatus.Deactivated:
                        siteEvent.Type =  SiteActivityType.UserModeratedDeactivated;
                        moderationStatus = "deactivated";
                        break;

                     case ModerationStatus.UserStatus.Standard:
                        siteEvent.Type = SiteActivityType.UserModeratedStandard;
                        moderationStatus = "returned to normal";
                        break;

                    default:
                        throw new Exception("Unknown moderation status: " + ((ModerationStatus.UserStatus)dataReader.GetInt32NullAsZero("status")).ToString());
                }

                switch(dataReader.GetInt32NullAsZero("prefduration"))
                {
                    case 1440: duration = " for 1 day";break;
                    case 10080: duration = " for 1 week";break;
                    case 20160: duration = " for 2 weeks";break;
                    case 40320: duration = " for 1 month";break;
                    default:
                        if (dataReader.GetInt32NullAsZero("prefduration") > 0)
                        {
                            duration = " for " + dataReader.GetInt32NullAsZero("prefduration").ToString() + " hours"; 
                        }
                        break;
                }
            

                XmlDocument doc = new XmlDocument();
                doc.LoadXml("<ACTIVITYDATA>" + 
                            string.Format(DataFormat,
                            dataReader.GetInt32NullAsZero("user_userid"), dataReader.GetStringNullAsEmpty("user_username"),
                            dataReader.GetInt32NullAsZero("status"), moderationStatus, dataReader.GetInt32NullAsZero("siteid"),
                            dataReader.GetInt32NullAsZero("mod_userid"), dataReader.GetStringNullAsEmpty("mod_username"),
                            duration, dataReader.GetStringNullAsEmpty("modreason"))
                            + "</ACTIVITYDATA>");
                siteEvent.ActivityData = doc.DocumentElement;
                
            }
            catch(Exception e)
            {
                siteEvent = null;
                SiteEventsProcessor.SiteEventLogger.LogException(e);
            }

            if (siteEvent != null)
            {
                siteEvent.SaveEvent(creator);
            }

            return siteEvent;
        }


       
    }
}

