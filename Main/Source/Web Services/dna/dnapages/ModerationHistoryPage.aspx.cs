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
using System.Xml;
using System.Drawing;
using System.Globalization;

using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Moderation;


public partial class ModerationHistoryPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Constructor for the Search For Users Page
    /// </summary>
    public ModerationHistoryPage()
    {
    }

    /// <summary>
    /// Page type for this page
    /// </summary>
    public override string PageType
    {
        get { return "MODERATION-HISTORY"; }
    }

    /// <summary>
    /// A page just for the editors and better
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.ModeratorAndAbove;
        }
    }

    /// <summary>
    /// Overridden OnPageLoad Event just checks that the user is allowed to view the page if not hide
    /// the controls and post the error message
    /// </summary>
    public override void OnPageLoad()
    {
        if (!IsDnaUserAllowed())
        {
            return;
        }

        AddComponent(new ModerationHistory(_basePage));

    }
}