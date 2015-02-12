using System;
using System.Collections.Specialized;
using BBC.Dna.Data;
using BBC.Dna.Objects;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using System.Linq;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Moderation;
using BBC.Dna.Common;

namespace BBC.Dna
{
    /// <summary>
    /// The article object
    /// </summary>
    public class UserContributionsBuilder : DnaInputComponent
    {
        private int _siteId = 0;
        private SiteType? _type = null;
        private int _userId = 0;
        private DateTime? _startDate =null;
        private int _startIndex = 0;
        private int _itemsPerPage = 50;
        private bool _ignoreCache = false;


        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="context">An object that supports the IInputContext interface. basePage</param>
        public UserContributionsBuilder(IInputContext context)
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
            GetQueryParameters();

            if (_userId == 0)
            {
                return;
            }

            var siteName = string.Empty;
            if(_siteId != 0)
            {
                siteName = InputContext.TheSiteList.GetSite(_siteId).SiteName;
            }

            if (InputContext.CurrentSite.SiteName.ToLower() == "moderation")
            {
                _ignoreCache = true;
            }

            var userContributions = Contributions.GetUserContributions(CacheFactory.GetCacheManager(),
                AppContext.ReaderCreator, siteName, _userId.ToString(), _itemsPerPage, _startIndex,
                SortDirection.Descending, _type, "dnauserid",
                InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser, _ignoreCache, _startDate, false);


            SerialiseAndAppend(userContributions, "");
        }

       

        /// <summary>
        /// Fills private members with querystring variables
        /// </summary>
        private void GetQueryParameters()
        {
            _siteId = InputContext.GetParamIntOrZero("s_siteid", "s_siteid");
            
            if (InputContext.DoesParamExist("s_type", "type to display"))
            {
                _type = (SiteType)InputContext.GetParamIntOrZero("s_type", "type to display");
            }
            
            if(InputContext.DoesParamExist("s_startdate", "date to start display"))
            {
                var startDateStr = InputContext.GetParamStringOrEmpty("s_startdate", "days of stats to display");
                DateTime tempDate;
                if (DateTime.TryParse(startDateStr, out tempDate))
                {
                    _startDate = tempDate;
                }
                else
                {
                    _startDate = null;
                }
            }

            _userId = InputContext.ViewingUser.UserID;
            if (InputContext.DoesParamExist("s_user", "test userid"))
            {
                _userId = InputContext.GetParamIntOrZero("s_user", "test userid");
            }

            if (InputContext.DoesParamExist("s_startindex", "startindex"))
            {
                _startIndex = InputContext.GetParamIntOrZero("s_startindex", "s_startindex");
            }

#if DEBUG
            _ignoreCache = InputContext.GetParamIntOrZero("ignorecache", "Ignore the cache") == 1;
#endif
        }
    }
}