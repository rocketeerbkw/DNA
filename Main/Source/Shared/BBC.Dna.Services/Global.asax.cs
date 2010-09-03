using System;
using System.Web;
using System.Configuration;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Common;
using BBC.Dna.Users;
using BBC.Dna.Moderation;

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
            if (ConfigurationManager.AppSettings["MaintenanceMode"] == "1")
            {//do nothing if in maintenance
                return;
            }
            
            Statistics.InitialiseIfEmpty(/*TheAppContext*/);
            dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
            connectionString = ConfigurationManager.ConnectionStrings["database"].ConnectionString;
            readerCreator = new DnaDataReaderCreator(connectionString, dnaDiagnostics);

            ICacheManager cacheManager = null;
            try
            {
                cacheManager = CacheFactory.GetCacheManager("Memcached");
            }
            catch (Exception error)
            {
                dnaDiagnostics.WriteWarningToLog("BBC.Dna.Services.Application_Start", "Unable to use memcached cachemanager - falling back to static inmemory");
                dnaDiagnostics.WriteExceptionToLog(error);
                cacheManager = new StaticCacheManager();
            }


            siteList = new SiteList(readerCreator, dnaDiagnostics, cacheManager, null, null);//no sending signals from here
            var bannedEmails = new BannedEmails(readerCreator, dnaDiagnostics, cacheManager, null, null);//no sending signals from here
            var userGroups = new UserGroups(readerCreator, dnaDiagnostics, cacheManager, null, null);//no sending signals from here
            var profanityFilter = new ProfanityFilter(readerCreator, dnaDiagnostics, cacheManager, null, null);//no sending signals from here
        
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            if (ConfigurationManager.AppSettings["MaintenanceMode"] == "1")
            {//do nothing if in maintenance
                return;
            }
            siteList = SiteList.GetSiteList();
            _openTime = DateTime.Now;
            if (Request.Path.IndexOf("status.aspx") < 0)
            {
                Statistics.AddRawRequest();
            }

            if (!String.IsNullOrEmpty(Request.QueryString["action"]))
            {
                try
                {
                    SignalHelper.HandleSignal(Request.QueryString);
                }
                catch (Exception err)
                {//not dealt with 
                    dnaDiagnostics.WriteExceptionToLog(err);
                }
            }
        }

        protected void Application_EndRequest(object sender, EventArgs e)
        {
            if (ConfigurationManager.AppSettings["MaintenanceMode"] == "1")
            {//do nothing if in maintenance
                return;
            }
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