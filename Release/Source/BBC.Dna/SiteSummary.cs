using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Summary of the More User Subscriptions Page object, holds the list of User Subscriptions of a user
    /// </summary>
    public class SiteSummary : DnaInputComponent
    {

        /// <summary>
        /// Default constructor for the MoreLinks component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public SiteSummary(IInputContext context)
            : base(context)
        {
          
        }

        private void GenerateStatsXML( XmlNode summaryXML, int siteId, DateTime startDate, DateTime endDate, bool recalculateReport )
        {
            //Get Stats.
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmoderationbilling"))
            {
                if (siteId > 0)
                {
                    dataReader.AddParameter("siteid", siteId);
                }

                dataReader.AddParameter("startdate",startDate);
                dataReader.AddParameter("enddate",endDate);

                if (recalculateReport)
                {
                    dataReader.AddParameter("forcerecalculation", 1);
                }
                
                dataReader.Execute();

                XmlNode postSummaryListXml = AddElementTag(summaryXML, "POSTSUMMARYLIST");
                XmlNode articleSummaryListXml = AddElementTag(summaryXML, "ARTICLESUMMARYLIST");
                XmlNode generalSummaryListXml = AddElementTag(summaryXML, "GENERALSUMMARYLIST");

                // Add Result Data .
                while (dataReader.Read())
                {
                    XmlNode threadSummary = AddElementTag(postSummaryListXml, "POSTSUMMARY");
                    AddAttribute(threadSummary, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
                    AddIntElement(threadSummary,"POSTTOTAL",dataReader.GetInt32NullAsZero("threadtotal"));
                    AddIntElement(threadSummary, "POSTMODERATEDTOTAL", dataReader.GetInt32NullAsZero("threadmodtotal"));
                    AddIntElement(threadSummary, "POSTPASSED", dataReader.GetInt32NullAsZero("threadpassed"));
                    AddIntElement(threadSummary,"POSTFAILED", dataReader.GetInt32NullAsZero("threadfailed"));
                    AddIntElement(threadSummary,"POSTREFERRED", dataReader.GetInt32NullAsZero("threadreferred"));
                    AddIntElement(threadSummary,"POSTCOMPLAINT", dataReader.GetInt32NullAsZero("threadcomplaint"));

                    XmlNode articleSummary = AddElementTag(articleSummaryListXml,"ARTICLESUMMARY");
                    AddAttribute(articleSummary,"SITEID",dataReader.GetInt32NullAsZero("siteid"));
                    AddIntElement(articleSummary,"ARTICLEMODERATEDTOTAL",dataReader.GetInt32NullAsZero("articlemodtotal"));
                    AddIntElement(articleSummary, "ARTICLEPASSED", dataReader.GetInt32NullAsZero("articlepassed"));
                    AddIntElement(articleSummary, "ARTICLEFAILED", dataReader.GetInt32NullAsZero("articlefailed"));
                    AddIntElement(articleSummary, "ARTICLEREFERRED", dataReader.GetInt32NullAsZero("articlereferred"));
                    AddIntElement(articleSummary, "ARTICLECOMPLAINT", dataReader.GetInt32NullAsZero("articlecomplaint"));

                    XmlNode generalSummary = AddElementTag(generalSummaryListXml, "GENERALSUMMARY");
                    AddAttribute(generalSummary, "SITEID", dataReader.GetInt32NullAsZero("siteid"));
                    AddIntElement(generalSummary, "GENERALMODERATEDTOTAL", dataReader.GetInt32NullAsZero("generalmodtotal"));
                    AddIntElement(generalSummary, "GENERALPASSED", dataReader.GetInt32NullAsZero("generalpassed"));
                    AddIntElement(generalSummary, "GENERALFAILED", dataReader.GetInt32NullAsZero("generalfailed"));
                    AddIntElement(generalSummary, "GENERALREFERRED", dataReader.GetInt32NullAsZero("generalreferred"));

                }
            }

        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();

            XmlNode summaryXML = AddElementTag(RootElement, "SITESUMMARY");

            if (InputContext.ViewingUser == null || !InputContext.ViewingUser.IsSuperUser)
            {
                AddErrorXml("Invalid Permissions", "Superuser permissions required", RootElement);
                return;
            }

            int siteId = InputContext.GetParamIntOrZero("siteid","SiteId");
            if (siteId > 0)
            {
                //Add XML for selected site.
                ISite site = InputContext.TheSiteList.GetSite(siteId);
                SiteXmlBuilder siteXmlBuilder = new SiteXmlBuilder(InputContext);
                XmlNode siteXML = siteXmlBuilder.GenerateXml(null, site);
                siteXML = ImportNode(siteXML);
                summaryXML.AppendChild(siteXML);
            }

            bool recalculateReport = InputContext.GetParamIntOrZero("recalculate", "Recalculate Report") == 1;

            //Require Dates to produce site summary report.
            if (InputContext.DoesParamExist("startdate", "Start Date") && InputContext.DoesParamExist("enddate", "End Date"))
            {
                DateTime startDate;
                DateTime endDate;
                try
                {
                    startDate = DateTime.Parse(InputContext.GetParamStringOrEmpty("startdate", "StartDate"));
                    endDate = DateTime.Parse(InputContext.GetParamStringOrEmpty("enddate", "EndDate"));
                }
                catch(FormatException fe)
                {
                    this.AddErrorXml("Bad Format",fe.Message,RootElement);
                    return;
                }

                DateRangeValidation dateValidate = new DateRangeValidation();
                DateRangeValidation.ValidationResult result = dateValidate.ValidateDateRange(startDate, endDate, 1, false, true);
                if (result != DateRangeValidation.ValidationResult.VALID)
                {
                    XmlElement errorXML = dateValidate.GetLastValidationResultAsXmlElement(RootElement.OwnerDocument);
                    RootElement.AppendChild(errorXML);
                    return;
                }

                AddDateXml(startDate, summaryXML, "STARTDATE");
                AddDateXml(endDate, summaryXML, "ENDDATE");

                GenerateStatsXML(summaryXML, siteId, startDate, endDate, recalculateReport);
            }
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            siteXml.GenerateAllSitesXml(InputContext.TheSiteList);
            AddInside(RootElement, siteXml);
       
        }
    }
}

