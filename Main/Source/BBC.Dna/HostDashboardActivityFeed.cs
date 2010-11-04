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
    public class HostDashboardActivityFeed : DnaInputComponent
    {
        private int[] _siteId = null;
        private int[] _type = null;
        private int _userId = 0;
        private DateTime _startDate;
        private int _startIndex = 0;
        private int _itemsPerPage = 100;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public HostDashboardActivityFeed(IInputContext context)
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



            //get moderator stats
            var moderatorInfo = ModeratorInfo.GetModeratorInfo(AppContext.ReaderCreator, _userId, InputContext.TheSiteList);
            SerialiseAndAppend(moderatorInfo, "");

            if (_siteId.Length == 0)
            {
                if (!InputContext.ViewingUser.IsSuperUser || _userId != InputContext.ViewingUser.UserID)
                {
                    _siteId = new int[moderatorInfo.Sites.Count];
                    for (int i = 0; i < _siteId.Length; i++)
                    {
                        _siteId[i] = moderatorInfo.Sites[i].SiteId;
                    }
                    if (_siteId.Length == 0)
                    {
                        AddErrorXml("NoSites", "No sites available for non-super user", null);
                        return;
                    }
                }
            }

            //show all if 0 in type list
            if (_type.Contains(0))
            {
                _type = new int[0];
            }

            var siteEventList = SiteEventList.GetSiteEventList(_siteId, _type, _startIndex,
                _itemsPerPage, _startDate, AppContext.ReaderCreator, InputContext.ViewingUser.IsSuperUser);
            SerialiseAndAppend(siteEventList, "");

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
            _siteId = new int[0];
            if (InputContext.DoesParamExist("s_siteid", "sites to display"))
            {
                var siteCount = InputContext.GetParamCountOrZero("s_siteid", "s_siteid");
                _siteId = new int[siteCount];
                for (int i = 0; i < siteCount; i++)
                {
                    _siteId[i] = InputContext.GetParamIntOrZero("s_siteid", i, "s_siteid");
                }
            }

            _type = new int[0];
            if (InputContext.DoesParamExist("s_type", "type to display"))
            {
                var typeCount = InputContext.GetParamCountOrZero("s_type", "type to display");
                _type = new int[typeCount];
                for (int i = 0; i < typeCount; i++)
                {
                    _type[i] = InputContext.GetParamIntOrZero("s_type", i, "s_type");
                }
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

            _userId = InputContext.ViewingUser.UserID;
            if (InputContext.ViewingUser.IsSuperUser)
            {
                if (InputContext.DoesParamExist("s_userid", "test userid"))
                {
                    _userId = InputContext.GetParamIntOrZero("s_userid", "test userid");
                }
            }

            if (InputContext.DoesParamExist("s_startindex", "startindex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startindex", "s_startindex");
            }
        }
    }
}