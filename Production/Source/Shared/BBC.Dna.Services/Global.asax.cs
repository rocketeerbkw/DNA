using System;
using System.Web;
using System.Configuration;
using BBC.Dna.Groups;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;

namespace BBC.Dna.Services
{
    public class Global : HttpApplication
    {
        public static ISiteList siteList;
        public static DnaDiagnostics dnaDiagnostics;
        public static string connectionString = string.Empty;
        public static IDnaDataReaderCreator readerCreator;
        private DateTime _openTime;

        protected void Application_Start(object sender, EventArgs e)
        {
            //System.Diagnostics.Debugger.Launch();
            Statistics.InitialiseIfEmpty(/*TheAppContext*/);
            dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
            connectionString = ConfigurationManager.ConnectionStrings["database"].ConnectionString;
            readerCreator = new DnaDataReaderCreator(connectionString, dnaDiagnostics);
            siteList = SiteList.GetSiteList(readerCreator, dnaDiagnostics);
            ProfanityFilter.InitialiseProfanities(readerCreator, dnaDiagnostics);
            var userGroups = new UserGroups(readerCreator, dnaDiagnostics, null);
            userGroups.InitialiseAllUsersAndGroups();
            
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            _openTime = DateTime.Now;
            if (Request.Path.IndexOf("status.aspx") < 0)
            {
                Statistics.AddRawRequest();
            }

            // Check to see if we're being asked to recache the site data
            if (Request.QueryString["action"] == "recache-site" || Request.QueryString["_ns"] == "1")
            {
                siteList = SiteList.GetSiteList(readerCreator, dnaDiagnostics, true);
                //refresh profanity filter
                ProfanityFilter.InitialiseProfanities(readerCreator, dnaDiagnostics);
                var userGroups = new UserGroups(readerCreator, dnaDiagnostics, null);
                userGroups.InitialiseAllUsersAndGroups();
            }

            // Check to see if we're being asked to do a recache of groups
            if (Request.QueryString["action"] == "recache-groups")
            {
                int siteId;
                int userId;
                int.TryParse(Request.QueryString["userid"], out userId);
                int.TryParse(Request.QueryString["siteid"], out siteId);
                if (userId > 0 && siteId > 0)
                {
                    Groups.UserGroups.DropCachedGroupsForUser(CacheFactory.GetCacheManager(), userId, siteId);
                }
            }
        }

        protected void Application_EndRequest(object sender, EventArgs e)
        {
            TimeSpan requestTime = (DateTime.Now - _openTime);
            if (Request.Path.IndexOf("status.aspx") < 0)
            {//dont report on status page builds
                Statistics.AddRequestDuration((int)requestTime.TotalMilliseconds);
            }
        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }


    }
}