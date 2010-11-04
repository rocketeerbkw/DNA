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

namespace Dna.SiteEventProcessor
{
    public class ComplaintArticleEvent
    {

        public static string DataFormat = "<USER USERID=\"{0}\">{1}</USER> alerted an article on <ARTICLE H2G2ID=\"{2}\">'{3}'</ARTICLE> because <NOTES>{4}</NOTES>";


        public ComplaintArticleEvent()
        {
        }

        static public void ProcessComplaintArticleEventActivity(IDnaDataReaderCreator DataReaderCreator)
        {
            using (IDnaDataReader reader = DataReaderCreator.CreateDnaDataReader("getsiteevents_complaintarticle"))
            {
                reader.Execute();
                while (reader.Read())
                {
                    CreateComplaintArticleEventActivity(reader, DataReaderCreator);
                }
            }
            
        }



        static public SiteEvent CreateComplaintArticleEventActivity(IDnaDataReader dataReader, IDnaDataReaderCreator creator)
        {
            SiteEvent siteEvent = null;
            try
            {
                siteEvent = new SiteEvent();
                siteEvent.SiteId = dataReader.GetInt32NullAsZero("siteid");
                siteEvent.Date = new Date(dataReader.GetDateTime("DateCreated"));
                siteEvent.Type = SiteActivityType.ComplaintArticle;

                var complainantUserName = dataReader.GetStringNullAsEmpty("complainantUserName");
                if (String.IsNullOrEmpty(complainantUserName))
                {
                    complainantUserName = "Anonymous";
                }
            
            
            
                XmlDocument doc = new XmlDocument();
                doc.LoadXml("<ACTIVITYDATA>" + 
                            string.Format(DataFormat,
                            dataReader.GetInt32NullAsZero("complaintantID_userid"), complainantUserName,
                            dataReader.GetInt32NullAsZero("h2g2id"), dataReader.GetStringNullAsEmpty("subject"),
                            dataReader.GetStringNullAsEmpty("complainttext"))
                            + "</ACTIVITYDATA>");
                siteEvent.ActivityData = doc.DocumentElement;
                
            }
            catch(Exception e)
            {
                siteEvent = null;
                LogUtility.LogException(e);
            }

            if (siteEvent != null)
            {
                siteEvent.SaveEvent(creator);
            }

            return siteEvent;
        }


       
    }
}

