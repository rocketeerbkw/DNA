using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Net;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using BBC.Dna;
using BBC.Dna.Page;

public partial class IPLookup : DnaWebPage
{
    public IPLookup()
    {
        UseDotNetRendering = true;
    }

    public override string PageType
    {
        get { return "IPLOOKUP"; }
    }

    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.EditorAndAbove;
        }
    }

    public override void OnPageLoad()
    {
        if (!IsDnaUserAllowed())
        {
            HideControls();
            Message.Text = "You do not have sufficient persmissions to view this page.";
            return;
        }

        if (!IsPostBack)
        {
            Message.Text = "Please enter a reason for looking up the IP Address associated with this thread posting";
            int postID = 0;
            bool parsed = int.TryParse(Request["id"], out postID);
            if (parsed)
            {
                ThreadEntryId.Value = postID.ToString();
            }
            else
            {
                Message.Text = "Invalid Post ID specified";
            }
            int modID = 0;
            parsed = int.TryParse(Request["modid"], out modID);
            if (parsed)
            {
                ModerationID.Value = modID.ToString();
            }
            else
            {
                Message.Text = "Invalud Moderation ID specified";
            }
        }
        else
        {
            Message.Text = "Submit Clicked!";
        }
    }

    private void HideControls()
    {
        Reason.Visible = false;
        Button1.Visible = false;
        ThreadEntryId.Visible = false;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        
        //HideControls();

        string reason = Reason.Text;
        if (reason.Length == 0)
        {
            Message.Text = "A reason must be entered to view the IP Address.";
            return;
        }
        int entryId;
        int modId;
        bool parsed = int.TryParse(ThreadEntryId.Value, out entryId);
        parsed = parsed & int.TryParse(ModerationID.Value, out modId);

        if (parsed)
        {
            IPAddressRequester ipLookup = new IPAddressRequester();
            Reason.Text = ipLookup.RequestIPAddress(entryId, reason, modId, _basePage);
            Message.Text = "The IP Address associated with entry " + entryId.ToString() + " is:-";
            Button1.Visible = false;
        }
    }
}
