using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;
using System.Xml;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class HostDashboardBuilder : DnaInputComponent
    {
        private int _siteId = 0;
        private SiteType _type = 0;
        private int _userId = 0;//all
        private int _days = 7;//default to 7 days


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public HostDashboardBuilder(IInputContext context)
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
            GetQueryParameters();

            

            //get site stats
            DateTime startDate = DateTime.MinValue, endDate = DateTime.MinValue;
            GetDateRange(_days, ref startDate, ref endDate);

            //get moderator stats
            var moderatorInfo = ModeratorInfo.GetModeratorInfo(AppContext.ReaderCreator, _userId, InputContext.TheSiteList);
            var modStats = new ModStats(){Moderator = moderatorInfo};
            SiteSummaryStats stats;
            if (_siteId != 0)
            {
                modStats = ModStats.FetchModStatsBySite(AppContext.ReaderCreator, _userId, _siteId,
                    moderatorInfo, true, true);

                stats = SiteSummaryStats.GetStatsBySite(AppContext.ReaderCreator, _siteId, startDate, endDate);
            }
            else
            {
                modStats = ModStats.FetchModStatsBySiteType(AppContext.ReaderCreator, _userId, _type,
                   moderatorInfo, true, true);

                var statsUserId = _userId;
                if (InputContext.ViewingUser.IsSuperUser && statsUserId == InputContext.ViewingUser.UserID)
                {//use default user
                    statsUserId = 0;
                }

                stats = SiteSummaryStats.GetStatsByType(AppContext.ReaderCreator, _type, statsUserId, startDate, endDate);
            }
            SerialiseAndAppend(modStats, "");
            SerialiseAndAppend(stats, "");

            //check if only one site - then redirect
            if (moderatorInfo.Sites.Count == 1 && _siteId == 0)
            {
                var redirectUrl = string.Format("/dna/moderation/admin/hostdashboard?s_siteid={0}&s_type={1}", moderatorInfo.Sites[0].SiteId, (int)moderatorInfo.Sites[0].Type);
                if (_userId != 0)
                {
                    redirectUrl += "&s_userid=" + _userId.ToString();
                }
                RootElement.RemoveAll();
                XmlNode redirect = AddElementTag(RootElement, "REDIRECT");
                AddAttribute(redirect, "URL", redirectUrl);
                return;
            }

            //get sitelist
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            siteXml.CreateXmlSiteList(InputContext.TheSiteList);
            RootElement.AppendChild(ImportNode(siteXml.RootElement.FirstChild));


            SerialiseAndAppend(SiteTypeEnumList.GetSiteTypes(), "");


        }

        private void GetDateRange(int days, ref DateTime startDate, ref DateTime endDate)
        {
            days = days == 0 ? 1 : days;

            endDate = DateTime.Now.AddDays(-1);
            startDate = endDate.AddDays(days * -1);
        }

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = InputContext.GetParamIntOrZero("s_siteid", "siteid to display");
            if (InputContext.DoesParamExist("s_type", "type to display"))
            {
                _type = (SiteType)InputContext.GetParamIntOrZero("s_type", "type to display");
            }
            if(InputContext.DoesParamExist("s_days", "days of stats to display"))
            {
                _days = InputContext.GetParamIntOrZero("s_days", "days of stats to display");
            }

            _userId = InputContext.ViewingUser.UserID;
            if (InputContext.ViewingUser.IsSuperUser)
            {
                if (InputContext.DoesParamExist("s_userid", "test userid"))
                {
                    _userId = InputContext.GetParamIntOrZero("s_userid", "test userid");
                }
            }

            
        }
    }
}