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
using BBC.Dna.Common;

namespace BBC.Dna.Services
{
    public class status : Page
    {
        protected Label lblHostName;
        protected Label lbFileInfo;
        protected Table tblStats;
        protected Label lbDatabaseVersion;

        protected void Page_Load(object sender, EventArgs e)
        {
            int interval = 60;
            if (!Int32.TryParse(Request.QueryString["interval"], out interval))
            {
                interval = 60;
            }

            if (Request.QueryString["reset"] == "1")
            {
                Statistics.ResetCounters();
            }

            StatusUI statusUI = new StatusUI();
            statusUI.AddFileinfo(ref lbFileInfo);
            statusUI.AddDatabaseVersion(Global.readerCreator, ref lbDatabaseVersion);

            if (Request.QueryString["skin"] == "purexml")
            {
                XmlDocument xDoc = statusUI.OutputXML(interval, this, Global.dnaDiagnostics);
                Response.ContentType = "text/xml";
                Response.Clear();
                Response.Write(xDoc.InnerXml);
                Response.End();
            }
            else
            {
                statusUI.OutputHTML(interval, ref lblHostName, Request.ServerVariables["SERVER_NAME"], ref tblStats);
            }
        }
    }
}
