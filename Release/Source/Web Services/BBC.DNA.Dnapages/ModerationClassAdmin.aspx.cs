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
using BBC.Dna.Page;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using BBC.Dna.Common;

public partial class ModerationClassAdmin : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// 
    /// </summary>
    public ModerationClassAdmin()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// The page type get property
    /// </summary>
    public override string PageType
    {
        get { return "MODERATIONCLASSADMIN"; }
    }

    /// <summary>
    /// 
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get
        {
            return DnaBasePage.UserTypes.EditorAndAbove;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override bool IsHtmlCachingEnabled()
        {
            return GetSiteOptionValueBool("cache", "HTMLCaching");
        }
    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    public override int GetHtmlCachingTime()
    {
        return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
    }

    /// <summary>
    /// 
    /// </summary>
    public override void OnPageLoad()
    {
        lblError.Visible = false;
        Context.Items["VirtualUrl"] = "ModerationClassAdmin";

        if (!_basePage.IsDnaUserAllowed() || ViewingUser == null || !ViewingUser.IsSuperUser )
        {
            lblError.Visible = true;
            lblError.Text = "Not Authorised - Administrator/Superuser pemissions required.";
            return;
        }
        
        //if (Page.IsPostBack)
        //    return;

        if (_basePage.DoesParamExist("cmd", "Command"))
        {
            String cmd = _basePage.GetParamStringOrEmpty("cmd", "Command");
            int modclassid = _basePage.GetParamIntOrZero("modclassid", "Moderation Class Id");
            if (cmd == "up")
            {
                //Decrement the sort order
                using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("updatemoderationclass"))
                {
                    dataReader.AddParameter("modclassid", modclassid);
                    dataReader.AddParameter("swapsortorder",-1);
                    dataReader.Execute();
                }
            }

            if (cmd == "down")
            {
                //Increment the sort order
                using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("updatemoderationclass"))
                {
                    dataReader.AddParameter("modclassid",modclassid);
                    dataReader.AddParameter("swapsortorder",1);
                    dataReader.Execute();
                }

            }
        }

         //Add a Header.
        TableRow header = new TableRow();
        header.CssClass = "infoBar";
        TableCell nameCell = new TableCell();
        nameCell.ColumnSpan = 1;
        nameCell.Text = "Name";

        TableCell descriptionCell = new TableCell();
        descriptionCell.ColumnSpan = 1;
        descriptionCell.Text = "Description";
        
        TableCell languageCell = new TableCell();
        languageCell.ColumnSpan = 1;
        languageCell.Text = "Language";

        TableCell policyCell = new TableCell();
        policyCell.ColumnSpan = 1;
        policyCell.Text = "Retrieval Policy";

        header.Cells.Add(nameCell);
        header.Cells.Add(descriptionCell);
        header.Cells.Add(languageCell);
        header.Cells.Add(policyCell);


        TableCell ordercell = new TableCell();
        ordercell.Text = "Display Order";
        ordercell.ColumnSpan = 2;
        header.Cells.Add(ordercell);
        tblModerationClasses.Rows.Add(header);

        cmbRetrievalPolicy.Items.Add(new ListItem("Standard", ((int)ModerationRetrievalPolicy.Standard).ToString()));
        cmbRetrievalPolicy.Items.Add(new ListItem("LIFO", ((int)ModerationRetrievalPolicy.LIFO).ToString()));
        cmbRetrievalPolicy.Items.Add(new ListItem("PriorityFirst", ((int)ModerationRetrievalPolicy.PriorityFirst).ToString()));

        using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("getmoderationclasslist"))
        {
            dataReader.Execute();
            while (dataReader.Read())
            {
                int modclassid = dataReader.GetInt32NullAsZero("modclassid");
                TableRow row = new TableRow();
                row.CssClass = "postContent";

                nameCell = new TableCell();
                nameCell.Text = dataReader.GetStringNullAsEmpty("name");

                descriptionCell = new TableCell();
                descriptionCell.Text = dataReader.GetStringNullAsEmpty("description");

                languageCell = new TableCell();
                languageCell.Text = dataReader.GetStringNullAsEmpty("ClassLanguage");

                policyCell = new TableCell();
                policyCell.Text = (Enum.Parse(typeof(ModerationRetrievalPolicy), dataReader.GetTinyIntAsInt("ItemRetrievalType").ToString())).ToString();
                
                TableCell upCell = new TableCell();
                HyperLink upLink = new HyperLink();
                upLink.NavigateUrl = "ModerationClassAdmin?modclassid=" + modclassid + "&cmd=up";
                upLink.Text = "Up";
                upCell.Controls.Add(upLink);

                TableCell downCell = new TableCell();
                HyperLink downLink = new HyperLink();
                downLink.NavigateUrl = "ModerationClassAdmin?modclassid=" + modclassid + "&cmd=down";
                downLink.Text = "Down";
                downCell.Controls.Add(downLink);

                row.Cells.Add(nameCell);
                row.Cells.Add(descriptionCell);
                row.Cells.Add(languageCell);
                row.Cells.Add(policyCell);
                row.Cells.Add(upCell);
                row.Cells.Add(downCell);
                tblModerationClasses.Rows.Add(row);

                ListItem item = new ListItem(dataReader.GetStringNullAsEmpty("name"),Convert.ToString(modclassid));
                cmbTemplate.Items.Add(item);
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAddModClass_Click(object sender, EventArgs e)
    {
        using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("createnewmoderationclass"))
        {
            dataReader.AddParameter("classname", txtName.Text);
            dataReader.AddParameter("description", txtDescription.Text);
            dataReader.AddParameter("Language", txtLanguage.Text);
            dataReader.AddParameter("itemretrievaltype", Int32.Parse(cmbRetrievalPolicy.Text));

            String basedOn = cmbTemplate.SelectedValue;
            dataReader.AddParameter("basedonclass", basedOn);

            dataReader.Execute();
            if (dataReader.Read())
            {
                lblError.Visible = true;
                lblError.Text = dataReader.GetStringNullAsEmpty("Reason");
            }

            //send signal
            var cache = (ModerationClassListCache)SignalHelper.GetObject(typeof(ModerationClassListCache));
            cache.SendSignal();
            //Refresh
            _basePage.Server.Transfer(_basePage.Request.RawUrl);
        }

    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnRefreshCaches_Click(object sender, EventArgs e)
    {
        //send signal
        var cache = (ModerationClassListCache)SignalHelper.GetObject(typeof(ModerationClassListCache));
        cache.SendSignal();
        //Refresh
        _basePage.Server.Transfer(_basePage.Request.RawUrl);
    }
}
