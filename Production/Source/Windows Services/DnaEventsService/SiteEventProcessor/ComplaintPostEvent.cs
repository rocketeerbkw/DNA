﻿using System;
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
    public class ComplaintPostEvent
    {

        public static string DataFormat = "<ACTIVITYDATA><USER USERID=\"{0}\">{1}</USER> alerted a {2} on <POST FORUMID=\"{3}\" POSTID=\"{4}\" THREADID=\"{5}\" URL=\"{6}\">'{7}'</POST> because <NOTES>{8}</NOTES></ACTIVITYDATA>";
        

        public ComplaintPostEvent()
        {
        }

        static public void ProcessComplaintPostEventActivity(IDnaDataReaderCreator DataReaderCreator)
        {
            using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getsiteevents_complaintpost"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    CreateComplaintPostEventActivity(reader, DataReaderCreator);
                }
            }
            
        }



        static public SiteEvent CreateComplaintPostEventActivity(IDnaDataReader dataReader, IDnaDataReaderCreator creator)
        {
            SiteEvent siteEvent = null;
            try
            {
                siteEvent = new SiteEvent();
                siteEvent.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEvent.Date = new Date(dataReader.GetDateTime("DateCreated"));
                siteEvent.Type = SiteActivityType.ComplaintPost;

                var complainantUserName = dataReader.GetStringNullAsEmpty("complainantUserName");
                if (String.IsNullOrEmpty(complainantUserName))
                {
                    complainantUserName = "Anonymous";
                }
                var type = "post";
                if (!string.IsNullOrEmpty(dataReader.GetStringNullAsEmpty("parenturl")))
                {
                    type = "comment";
                }


                siteEvent.ActivityData = XElement.Parse(
                         string.Format(DataFormat,
                            dataReader.GetInt32NullAsZero("complaintantID_userid"), complainantUserName, type,
                            dataReader.GetInt32NullAsZero("forumid"), dataReader.GetInt32NullAsZero("postid"),
                            dataReader.GetInt32NullAsZero("threadid"), dataReader.GetStringNullAsEmpty("parenturl"),
                            dataReader.GetStringNullAsEmpty("subject"), dataReader.GetStringNullAsEmpty("complainttext"))
                           );
                siteEvent.UserId = dataReader.GetInt32NullAsZero("complaintantID_userid");
                siteEvent.SaveEvent(creator);
                 
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

