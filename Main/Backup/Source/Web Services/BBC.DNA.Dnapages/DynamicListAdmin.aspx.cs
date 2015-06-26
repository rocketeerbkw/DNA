using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Xml;
using System.IO;

using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.DynamicLists;
using BBC.Dna.Data;

	/// <summary>
	/// Summary description for WebForm2.
	/// </summary>
public partial class DynamicListAdmin : BBC.Dna.Page.DnaWebPage
	{
		protected System.Web.UI.WebControls.Button BtnEdit;
		//protected System.Web.UI.WebControls.Table TblDynamicLists;

        public DynamicListAdmin()
        {
            UseDotNetRendering = true;
        }

        public override DnaBasePage.UserTypes AllowedUsers
        {
            get
            {
            return DnaBasePage.UserTypes.EditorAndAbove;
            }
        }

        public override string PageType
        {
            get { return "DYNAMICLISTADMIN"; }
        }

        public override bool IsHtmlCachingEnabled()
        {
            return GetSiteOptionValueBool("cache", "HTMLCaching");
        }

        public override int GetHtmlCachingTime()
        {
            return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
        }
	
		public override void  OnPageLoad()
		{
            Context.Items["VirtualUrl"] = "DynamicListAdmin";
            //UseDotNetRendering = true;

			if ( Page.IsPostBack )
				return;

            HyperLinkReActivate.Visible = false;
            lblError.Visible = false;
            if (!IsDnaUserAllowed())
            {
                lblError.Visible = true;
                lblError.Text = "Insufficient permissions - Editor Status Required";
                return;
            }

            if ( CurrentSite == null )
            {
                lblError.Visible = true;
                lblError.Text = "Site not Recognised.";
                return;
            }

            //Allow superusers to reactivate Dynamic Lists.
            if (_basePage.ViewingUser.IsSuperUser)
            {
                HyperLinkReActivate.Visible = true;
            }

			// Nice title
			lblTitle.Text += " " + CurrentSite.SiteName;
			
            //Add a Header.
            TableRow header = new TableRow();
            header.CssClass = "infoBar";
            TableCell headercell = new TableCell();
            headercell.ColumnSpan = 4;
            headercell.Text = "Dynamic Lists";
            header.Cells.Add(headercell);
            tblDynamicLists.Rows.Add(header);

            int ID = _basePage.GetParamIntOrZero("deleteId", "Dynamic List ID");
			if ( ID > 0 )
			{
                // Get details from DB
                using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("dynamiclistdeletelist"))
                {
                    dataReader.AddParameter("@Id", ID);
                    dataReader.Execute();
                }
			}

            if (_basePage.DoesParamExist("refresh", "Refresh cache"))
            {
                string name = _basePage.GetParamStringOrEmpty("refresh","Refresh File Cache");
                if (!AppContext.TheAppContext.FileCacheInvalidateItem("DynamicLists", name + ".txt"))
                {
                    lblError.Visible = true;
                    lblError.Text = "Unable to invalidate cache for " + name;
                }
            }

            //Regenerate Dynamic Lists
            ID = _basePage.GetParamIntOrZero("reactivatelists","Reactivate Dynamic Lists");
            if ( ID == 1 )
            {
                if (!_basePage.ViewingUser.IsSuperUser)
                {
                    lblError.Text = "Insufficient permissions - Superuser status required.";
                    lblError.Visible = true;
                    return;
                }

                //Mark active lists for republish.
                try
                {
                    using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("dynamiclistmarktorepublish"))
                    {
                        dataReader.Execute();
                    }

                    //Lists marked for publish shoul dbe dropped then republished.
                    dlistupdatesp dlist = new dlistupdatesp(_basePage);
                    dlist.Initialise();
                    dlist.Process();
                }
                catch (DynamicListException e)
                {
                    lblError.Text = e.Message;
                    lblError.Visible = true;
                }
            }

			// Publish
			ID = _basePage.GetParamIntOrZero("activateId","Dynamic List Id");
			if( ID > 0)
			{
                //Do the update
                try
                {
                    using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("dynamiclistmarktopublish"))
                    {
                        dataReader.AddParameter("@Id", ID);
                        dataReader.Execute();
                    }

                    //Goes through any lists marked for publish.
                    dlistupdatesp dlist = new dlistupdatesp(_basePage);
                    dlist.Initialise();
                    dlist.Process();
                }
                catch (DynamicListException e)
                {
                    lblError.Text = e.Message;
                    lblError.Visible = true;
                }
			}

			// Unpublish
			ID = _basePage.GetParamIntOrZero("deactivateId","Dynamic List Id");
            if ( ID > 0 )
            {
                try
                {
                //Do the update
                using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("dynamiclistmarktounpublish"))
                    {
                        dataReader.AddParameter("@Id", ID);
                        dataReader.Execute();
                    }

                    //Actually deactivate the dynamic list.
                    //Hangover from when activation / deactivation was a separate process.
                    dlistupdatesp dlist = new dlistupdatesp(_basePage);
                    dlist.Initialise();
                    dlist.Process();
                }
                catch (DynamicListException e)
                {
                    lblError.Text = e.Message;
                    lblError.Visible = true;
                }
            }

            // Get details from DB
            int icount = 0;
            string site = CurrentSite.SiteName;
            if ( site != string.Empty )
            {
                // Get details from DB
                using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("dynamiclistgetlists"))
                {
                    dataReader.AddParameter("@siteurlname", site);
                    dataReader.Execute();
                    while ( dataReader.Read() )
                    {
                        ++icount;

                        int id = dataReader.GetInt32("ID");      
                        string xml = dataReader.GetString("XML");

                        // Get publish state
                        int PublishState = dataReader.GetInt32("PublishState");

                        //Get Name from XML.
                        string name = "";
                        XmlDocument xmldoc = new XmlDocument();
                        xmldoc.LoadXml(xml);
                        XmlNode xmlNde;
                        if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/NAME")) != null)
                        {
                            name = xmlNde.InnerText;
                        }


                        TableRow row = new TableRow();
                        row.CssClass = "postContent";

                        TableCell cell1 = new TableCell();
                        cell1.Text = name;
                        row.Cells.Add(cell1);

                        TableCell cell2 = new TableCell();
                        HyperLink link = new HyperLink();
                        link.Text = "Edit";
                        link.NavigateUrl = "EditDynamicListDefinition" + "?id=" + Convert.ToString(id);
                        link.ToolTip = "Edit Dynamic List Definition. Re-activate List to publish edits to site.";
                        cell2.Controls.Add(link);
                        row.Cells.Add(cell2);

                        TableCell cell3 = new TableCell();

                        // Only allow delete if unpublished or waiting to be published
                        if (PublishState == 0 || PublishState == 1)
                        {
                            HyperLink deletelink = new HyperLink();
                            deletelink.Text = "Delete";
                            deletelink.NavigateUrl = "DynamicListAdmin" + "?deleteId=" + Convert.ToString(id);
                            deletelink.ToolTip = "Deletes Dynamic List Definition.";
                            cell3.Controls.Add(deletelink);
                        }

                        //Only allow cache refresh if activated and user is superuser.
                        if ( PublishState == 2 && ViewingUser.IsSuperUser)
                        {
                            HyperLink recache = new HyperLink();
                            recache.NavigateUrl = "DynamicListAdmin" + "?refresh=" + name;
                            recache.Text = "Refresh";
                            recache.ToolTip = "Refreshes Dynamic List Data.";
                            cell3.Controls.Add(recache);
                        }
                        row.Cells.Add(cell3);

                        TableCell cell4 = new TableCell();
                        HyperLink publishlink = new HyperLink();
                        if (PublishState == 0)
                        {
                            publishlink.Text = "Activate";
                            publishlink.NavigateUrl = "DynamicListAdmin" + "?activateId=" + Convert.ToString(id);
                            publishlink.ToolTip = "Publish the Dynamic List to the site. ";
                        }
                        else if (PublishState == 1)
                        {
                            publishlink.Text = "Activating...";
                            publishlink.NavigateUrl = "DynamicListAdmin" + "?checkstatusId=" + Convert.ToString(id);
                        }
                        else if (PublishState == 2)
                        {
                            publishlink.Text = "Deactivate";
                            publishlink.NavigateUrl = "DynamicListAdmin" + "?deactivateId=" + Convert.ToString(id);
                            publishlink.ToolTip = "Unpublish the Dynamic List from the site.";
                        }
                        else if (PublishState == 3)
                        {
                            publishlink.Text = "Deactivating...";
                            publishlink.NavigateUrl = "DynamicListAdmin" + "?checkstatusId=" + Convert.ToString(id);
                        }
                        else
                        {
                            publishlink.Text = "Unknown Status";
                            publishlink.NavigateUrl = "DynamicListAdmin" + "?checkstatusId=" + Convert.ToString(id);
                        }

                        cell4.Controls.Add(publishlink);
                        row.Cells.Add(cell4);

                        tblDynamicLists.Rows.Add(row);
                    }
                }
            }


			if ( icount == 0 )
			{
				TableRow row = new TableRow();
				TableCell nolists = new TableCell();
				nolists.ColumnSpan=4;
                nolists.Text = "No Dynamic Lists for site " + CurrentSite.SiteName;
				row.Cells.Add(nolists);
				tblDynamicLists.Rows.Add(row);
			}
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    

		}
		#endregion

		private void btNew_Click(object sender, System.EventArgs e)
		{
			Server.Transfer("EditDynamicListDefinition");
		}
	}
