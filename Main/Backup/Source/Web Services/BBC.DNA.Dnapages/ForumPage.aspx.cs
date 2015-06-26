using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using BBC.Dna;

public partial class ForumPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public ForumPage()
    {
    }

	public override string PageType
	{
		get {
            string _framePart = Request.QueryString["type"] == null ? String.Empty : Request.QueryString["type"];
            int _threadId = 0;
            Int32.TryParse(Request.QueryString["Thread"], out _threadId);

            string pageType = "THREADS";
            if (_threadId > 0)
            {
                pageType ="MULTIPOSTS";
            }

            /*
            //ProcessCommand base on type
            switch (_framePart.ToUpper())
            {
                case "FUP":
                    pageType = "TOPFRAME";
                    break;

                case "TEST":

                    break;

                case "FLFT":
                    pageType = "SIDEFRAME";
                    break;

                case "FSRC":
                    break;

                case "FTH":
                    pageType = "FRAMETHREADS";
                    break;

                case "FMSG":
                    pageType = "MESSAGEFRAME";
                    break;

                case "HEAD":
                    pageType = "THREADPAGE";
                    //TODO check out forumpage element?
                    break;

                case "FTHR":
                    break;

                case "BIGP":
                    break;

                case "SUBS":
                    break;

                default:
                    
                    break;
            }
        
            */
            
            return pageType; 
        }
	}
    
    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // Now create the forum object
        AddComponent(new ForumPageBuilder(_basePage));
    }
	public override bool IsHtmlCachingEnabled()
	{
		return GetSiteOptionValueBool("cache", "HTMLCaching");
	}

    public override bool IncludeTopFives
    {
        get
        {
            return true;
        }
    }

	public override int GetHtmlCachingTime()
	{
		return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
	}
}
