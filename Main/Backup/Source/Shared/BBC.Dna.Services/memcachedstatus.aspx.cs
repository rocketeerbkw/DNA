using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using System.Collections;

namespace BBC.Dna.Services
{
    public class memcachedStatus : System.Web.UI.Page
    {
        protected Label lblHostName;
        protected Label lblmemcachedStats;
        protected Table tblStats;


        protected void Page_Load(object sender, EventArgs e)
        {
            MemcachedCacheManager _cacheManager = null;
            if (Request.QueryString["resetMemcached"] == "1")
            {
                
                try
                {
                    _cacheManager = (MemcachedCacheManager)CacheFactory.GetCacheManager("Memcached");
                    _cacheManager.Flush();
                }
                catch { }
            }
            try
            {
                _cacheManager = (MemcachedCacheManager)CacheFactory.GetCacheManager("Memcached");
                Hashtable hshStats = _cacheManager.GetStats();

                foreach (string key in hshStats.Keys)
                {
                    lblmemcachedStats.Text += "<div style='float:left;'><table>";
                    lblmemcachedStats.Text += string.Format("<tr><td colspan=2><b>Server Address:{0}</b></td></tr>", key);
                    Hashtable serverStats = (Hashtable)hshStats[key];
                    foreach (string stat in serverStats.Keys)
                    {
                        lblmemcachedStats.Text += string.Format("<tr><td>{0}</td><td>{1}</td></tr>", stat, serverStats[stat].ToString());
                    }
                    lblmemcachedStats.Text += string.Format("<tr><td colspan=2>&nbsp;</td></tr>");
                    lblmemcachedStats.Text += "</table></div>";
                }


            }
            catch
            {
                lblmemcachedStats.Text = "memcached not in use.";
            }

        }
    }
}
