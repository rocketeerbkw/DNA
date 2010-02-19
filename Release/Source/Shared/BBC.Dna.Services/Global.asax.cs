using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Configuration;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;

namespace BBC.Dna.Services
{
    public class Global : System.Web.HttpApplication
    {
        public static ISiteList siteList;
        public static DnaDiagnostics dnaDiagnostics;
        public static string connectionString = string.Empty;
        public static IDnaDataReaderCreator ReaderCreator;
        private DateTime openTime;

        protected void Application_Start(object sender, EventArgs e)
        {
            //System.Diagnostics.Debugger.Launch();
            Statistics.InitialiseIfEmpty(/*TheAppContext*/);
            //TODO: refactor this to use dnadatareader fully
            dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
            connectionString = ConfigurationManager.ConnectionStrings["database"].ConnectionString;
            ReaderCreator = new DnaDataReaderCreator(connectionString, dnaDiagnostics);
            siteList = SiteList.GetSiteList(ReaderCreator, dnaDiagnostics);
            
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            openTime = DateTime.Now;
            if (Request.Path.IndexOf("status.aspx") < 0)
            {
                Statistics.AddRawRequest();
            }

            // Check to see if we're being asked to recache the site data
            if (Request.QueryString["action"] == "recache-site" || Request.QueryString["_ns"] == "1")
            {
                siteList = SiteList.GetSiteList(ReaderCreator, dnaDiagnostics, true);
            }

            // Check to see if we're being asked to do a recache of groups
            if (Request.QueryString["action"] == "recache-groups")
            {
                int siteID = 0;
                int userID = 0;
                int.TryParse(Request.QueryString["userid"], out userID);
                int.TryParse(Request.QueryString["siteid"], out siteID);
                if (userID > 0 && siteID > 0)
                {
                    Dna.Groups.UserGroups.DropCachedGroupsForUser(CacheFactory.GetCacheManager(), userID, siteID);
                }
            }
        }

        protected void Application_EndRequest(object sender, EventArgs e)
        {
            TimeSpan requestTime = (DateTime.Now - openTime);
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