using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class HostDashboardUserActivityFeed : DnaInputComponent
    {
        private int _siteId = 0;
        private int _modClassId = 0;
        private int _userId = 0;
        private DateTime _startDate;
        private DateTime _endDate = DateTime.MaxValue;
        private int _startIndex = 0;
        private int _itemsPerPage = 100;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public HostDashboardUserActivityFeed(IInputContext context)
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

            if (_modClassId == 0)
            {
                if(_siteId == 0)
                {
                    AddErrorXml("NoSites", "No site data available", null);
                return;
                }
                //get moderator stats
                _modClassId = InputContext.TheSiteList.GetSite(_siteId).ModClassID;
            }
            ModerationClass modClass = ModerationClassListCache.GetObject().ModClassList.FirstOrDefault(x => x.ClassId == _modClassId);

            var userEventList = UserEventList.GetUserEventList(modClass, _startIndex,
                _itemsPerPage, _startDate, _endDate, AppContext.ReaderCreator, _userId);
            SerialiseAndAppend(userEventList, "");

            //get sitelist
            SiteXmlBuilder siteXml = new SiteXmlBuilder(InputContext);
            siteXml.CreateXmlSiteList(InputContext.TheSiteList);
            RootElement.AppendChild(ImportNode(siteXml.RootElement.FirstChild));


            SerialiseAndAppend(SiteTypeEnumList.GetSiteTypes(), "");


        }

       

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = 0;
            if (InputContext.DoesParamExist("s_siteid", "sites to display"))
            {
                _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");
            }

            if (InputContext.DoesParamExist("s_modclassid", "mod class to display"))
            {
                _modClassId = InputContext.GetParamIntOrZero("s_modclassid", "s_modclassid");
            }
            
            _startDate = DateTime.MinValue;
            if(InputContext.DoesParamExist("s_startdate", "date to start display"))
            {
                var startDateStr = InputContext.GetParamStringOrEmpty("s_startdate", "days of stats to display");
                if (!DateTime.TryParse(startDateStr, out _startDate))
                {
                    _startDate = DateTime.MinValue;
                }
            }

            if (InputContext.DoesParamExist("s_enddate", "date to start display"))
            {
                var endDateStr = InputContext.GetParamStringOrEmpty("s_enddate", "days of stats to display");
                if (!DateTime.TryParse(endDateStr, out _endDate))
                {
                    _endDate = DateTime.Now;
                }
            }
            

            if (InputContext.DoesParamExist("s_user", "test userid"))
            {
                _userId = InputContext.GetParamIntOrZero("s_user", "test userid");
            }
        

            if (InputContext.DoesParamExist("s_startindex", "startindex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startindex", "s_startindex");
            }

            if(InputContext.DoesParamExist("s_days", "amount of days to view"))
            {
                var days = InputContext.GetParamIntOrZero("s_days", "amount of days to view");
                if (days > 0)
                {
                    _endDate = DateTime.Now;
                    _startDate = _endDate.AddDays(days * -1);
                }
            }
        }
    }
}