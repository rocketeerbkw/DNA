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
    public class NewUserEvent
    {

        public static string DataFormat = "<USER USERID=\"{0}\">{1}</USER> joined <SITE ID=\"{2}\" />";


        public NewUserEvent()
        {
        }

        static public void ProcessNewUserEventActivity(IDnaDataReaderCreator DataReaderCreator)
        {
            using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getsiteevents_newuser"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    CreateNewUserEventActivity(reader, DataReaderCreator);
                }
            }
            
        }



        static public SiteEvent CreateNewUserEventActivity(IDnaDataReader dataReader, IDnaDataReaderCreator creator)
        {
            SiteEvent siteEvent = null;
            try
            {
                siteEvent = new SiteEvent();
                siteEvent.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEvent.Date = new Date(dataReader.GetDateTime("DateCreated"));
                siteEvent.Type = SiteActivityType.NewUserToSite;
           

                XmlDocument doc = new XmlDocument();
                doc.LoadXml("<ACTIVITYDATA>" + 
                            string.Format(DataFormat,
                            dataReader.GetInt32NullAsZero("user_userid"), dataReader.GetStringNullAsEmpty("user_username"),
                            dataReader.GetInt32NullAsZero("siteid"))
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

