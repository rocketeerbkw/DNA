using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Data.SqlClient;
using System.IO;
using System.Configuration;
using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Data;


	/// <summary>
	/// Summary description for WebForm1.
	/// </summary>
public partial class EditDynamicListDefinition : BBC.Dna.Page.DnaWebPage
	{
		//protected System.Web.UI.HtmlControls.HtmlInputButton Submit1;

        private string[] months = { "january", "febuary", "march", "april", "may", "june", "july", "august", "september","october", "december" };

        public EditDynamicListDefinition()
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
            get { return "EDITDYNAMICLISTDEFINITION"; }
        }

        public override bool IsHtmlCachingEnabled()
        {
            return false;
        }

        public override int GetHtmlCachingTime()
        {
            return 0;
        }

        public override void OnPageLoad()
		{
            Context.Items["VirtualUrl"] = "EditDynamicListDefinition";
            //UseDotNetRendering = true;
			if ( Page.IsPostBack )
				return;

            CustomValidator.IsValid = true;
            if (!IsDnaUserAllowed())
            {
                CustomValidator.IsValid = false;
                return;
            }

			//Sort options
			cmbSort.Items.Add(new ListItem("Date Created","DATECREATED"));
			cmbSort.Items.Add(new ListItem("Date Updated","DATEUPDATED"));
			cmbSort.Items.Add(new ListItem("Rating","RATING"));
			cmbSort.Items.Add(new ListItem("Vote Count","VOTECOUNT"));
			cmbSort.Items.Add(new ListItem("Significance","SIGNIFICANCE"));
            cmbSort.Items.Add(new ListItem("Bookmark Count","BOOKMARKCOUNT"));
			cmbSort.Items.Add(new ListItem("Event Date","EVENTDATE"));
            cmbSort.Items.Add(new ListItem("PostCount (CommentForums)", "COMMENTCOUNT"));

			//Type 
			cmbType.Items.Add(new ListItem("Topics","TOPICFORUMS"));
			cmbType.Items.Add(new ListItem("Articles","ARTICLES"));
			cmbType.Items.Add(new ListItem("Forums","FORUMS"));
            cmbType.Items.Add(new ListItem("CommentForums","COMMENTFORUMS"));
			cmbType.Items.Add(new ListItem("Clubs","CLUBS"));
			cmbType.Items.Add(new ListItem("Threads","THREADS"));
			cmbType.Items.Add(new ListItem("Categories","CATEGORIES"));
			cmbType.Items.Add(new ListItem("Users","USERS"));
			cmbType.Items.Add(new ListItem("Campaign Diary Entries","CAMPAIGNDIARYENTRIES"));

			//Status options
			cmbStatus.Items.Add(new ListItem("All","ALL"));
			cmbStatus.Items.Add(new ListItem("Submittable - 1","1"));
			cmbStatus.Items.Add(new ListItem("Referred - 2","2"));
			cmbStatus.Items.Add(new ListItem("Pre-Moderation - 3","3"));
			cmbStatus.Items.Add(new ListItem("Considered/Submitted - 4","4"));
			cmbStatus.Items.Add(new ListItem("Locked by Editor - 5","5"));
			cmbStatus.Items.Add(new ListItem("Awaiting Approval - 6","6"));
			cmbStatus.Items.Add(new ListItem("Deleted - 7","7"));
			cmbStatus.Items.Add(new ListItem("User Entry Locked by Staff - 8","8"));
			cmbStatus.Items.Add(new ListItem("Key Article - 9","9"));
			cmbStatus.Items.Add(new ListItem("General Page - 10","10"));
			cmbStatus.Items.Add(new ListItem("Awaiting Rejection - 11","11"));
			cmbStatus.Items.Add(new ListItem("Awaiting Editors Decision - 12","12"));
			cmbStatus.Items.Add(new ListItem("Awaiting to go Official - 13","13"));

            int m = 1;
            foreach (string month in months)
            {
                cmbStartMonth.Items.Add(new ListItem(month, Convert.ToString(m)));
                cmbEndMonth.Items.Add(new ListItem(month, Convert.ToString(m)));
                ++m;
            }

            for (int i = 1900; i <= 2100; ++i)
            {
                cmbStartYear.Items.Add(new ListItem(Convert.ToString(i), Convert.ToString(i)));
                cmbEndYear.Items.Add(new ListItem(Convert.ToString(i), Convert.ToString(i)));
            }
            CalStartDate.VisibleDate = DateTime.Now;
            CalEndDate.VisibleDate = DateTime.Now;

            NameSpaces siteNameSpaces = new NameSpaces(_basePage);
            List<NameSpaceItem> namespaces = siteNameSpaces.GetNameSpacesForSite(_basePage.CurrentSite.SiteID);
            cmbNameSpaces.Items.Add(new ListItem("None",string.Empty));
            foreach (NameSpaceItem n in namespaces)
            {
                cmbNameSpaces.Items.Add(new ListItem(n.Name,n.Name));
            }

            //Record ID of List being edited.
            int id = Request.GetParamIntOrZero("id", "id");
            ViewState.Add("ID", id);

			// Get details for List Definition from DB
            using (IDnaDataReader dataReader = _basePage.CreateDnaDataReader("dynamiclistgetlist"))
            {
                dataReader.AddParameter("@listid", id);
                dataReader.Execute();
                
                if (dataReader.Read())
                {
                    string sXML = dataReader.GetString("XML");

                    //Parse XML 
                    XmlDocument xmldoc = new XmlDocument();
                    xmldoc.LoadXml(sXML);

                    //Name
                    XmlNode xmlNde;
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/NAME")) != null)
                        txtName.Text = xmlNde.InnerText;

                    //Rating
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/RATING")) != null)
                        txtRating.Text = xmlNde.InnerText;

                    //BookMarks
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/BOOKMARKCOUNT")) != null)
                        txtBookmarkCount.Text = xmlNde.InnerText;

                    //Status 
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/STATUS")) != null)
                        cmbStatus.SelectedValue = xmlNde.InnerText;

                    //Type
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/TYPE")) != null)
                        cmbType.SelectedValue = xmlNde.InnerText;

                    if ( (xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/COMMENTFORUMUIDPREFIX")) != null )
                        txtCommentForumUIDPrefix.Text = xmlNde.InnerText;

                    //ArticleType
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/ARTICLETYPE")) != null)
                        txtArticleType.Text = xmlNde.InnerText;

                    //Article Date Range Start
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/ARTICLESTARTDATE")) != null)
                    {
                        DateTime startdate = DateTime.Parse(xmlNde.InnerText);
                        CalStartDate.VisibleDate = startdate;
                        CalStartDate.SelectedDate = startdate;
                        lblStartDate.Text = startdate.ToString("dd/MM/yy");
                        cmbStartYear.SelectedValue = Convert.ToString(startdate.Year);
                        cmbStartMonth.SelectedValue = Convert.ToString(startdate.Month);
                    }
                    else
                    {
                        cmbStartYear.SelectedValue = Convert.ToString(DateTime.Now.Year);
                        cmbStartMonth.SelectedValue = Convert.ToString(DateTime.Now.Month);
                    }


                    //Article Date Range End
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/ARTICLEENDDATE")) != null)
                    {
                        DateTime enddate = DateTime.Parse(xmlNde.InnerText);

                        //The end date is midnight next day. 
                        //Date range is displayed inclusive so take off a day for display.
                        enddate = enddate.AddDays(-1);
                        CalEndDate.VisibleDate = enddate;
                        CalEndDate.SelectedDate = enddate;
                        lblEndDate.Text = enddate.ToString("dd/MM/yy");
                        cmbEndYear.SelectedValue = Convert.ToString(enddate.Year);
                        cmbEndMonth.SelectedValue = Convert.ToString(enddate.Month);
                    }
                    else
                    {
                        cmbEndYear.SelectedValue = Convert.ToString(DateTime.Now.Year);
                        cmbEndMonth.SelectedValue = Convert.ToString(DateTime.Now.Month);
                    }

                    //Significance
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/SIGNIFICANCE")) != null)
                        txtSignificance.Text = xmlNde.InnerText;

                    //Date Created
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/DATECREATED")) != null)
                        txtDateCreated.Text = xmlNde.InnerText;

                    //Last Updated
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/LASTUPDATED")) != null)
                        txtLastUpdated.Text = xmlNde.InnerText;

                    //Sort.
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/SORTBY")) != null)
                        cmbSort.SelectedValue = xmlNde.InnerText;

                    //ThreadType
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/THREADTYPE")) != null)
                        txtThreadType.Text = xmlNde.InnerText;

                    //Categories
                    XmlNode xmlCategories = xmldoc.SelectSingleNode("LISTDEFINITION/CATEGORIES");
                    if (xmlCategories != null)
                    {
                        for (int i = 0; i < xmlCategories.ChildNodes.Count; i++)
                        {
                            XmlNode category = xmlCategories.ChildNodes[i];
                            XmlNode nodeid = category.SelectSingleNode("ID");
                            XmlNode name = category.SelectSingleNode("NAME");
                            ListItem item = new ListItem(name.InnerText, nodeid.InnerText);
                            lstCategories.Items.Add(item);
                        }
                    }

                    //Key Phrases
                    XmlNodeList xmlKeyPhrases = xmldoc.SelectNodes("LISTDEFINITION/KEYPHRASES/PHRASE");
                    if (xmlKeyPhrases.Count > 0)
                    {
                        for (int i = 0; i < xmlKeyPhrases.Count; ++i)
                        {
                            XmlNode xmlName = xmlKeyPhrases[i].SelectSingleNode("NAME");
                            string name = string.Empty;
                            if (xmlName != null)
                            {
                                name = xmlName.InnerText;
                            }
                            else
                            {
                                //Legacy XML support.
                                name = xmlKeyPhrases[i].InnerText;
                            }

                            string nspace = string.Empty;
                            XmlNode xmlNameSpace = xmlKeyPhrases[i].SelectSingleNode("NAMESPACE");
                            if (xmlNameSpace != null)
                            {
                                nspace = xmlNameSpace.InnerText;
                            }
                            ListItem item = new ListItem( nspace == string.Empty ? name : nspace + ":" + name,nspace + "|" + name );
                            lstKeyPhrases.Items.Add(item);
                        }
                    }


                    // VoteCount
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/VOTECOUNT")) != null)
                        txtVoteCount.Text = xmlNde.InnerText;

                    // EventDate
                    if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/EVENTDATE")) != null)
                        txtEventDate.Text = xmlNde.InnerText;

                }
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
			this.ArticleTypeValidator.ServerValidate += new System.Web.UI.WebControls.ServerValidateEventHandler(this.ArticleTypeValidator_ServerValidate);
			this.DateValidator.ServerValidate += new System.Web.UI.WebControls.ServerValidateEventHandler(this.DateValidator_ServerValidate);
            this.UIDValidator.ServerValidate += new System.Web.UI.WebControls.ServerValidateEventHandler(this.UIDValidator_ServerValidate);
		}
		#endregion

		protected void btnUpdate_Click(object sender, System.EventArgs e)
		{
			//Check Page Passed Validation.
			if ( !Page.IsValid )
				return;

            if (!ViewingUser.IsEditor || ViewingUser.UserID == 0 || !ViewingUser.UserLoggedIn)
            {
                return;
            }

			XmlDocument xml = new XmlDocument();
			XmlElement root = xml.CreateElement("LISTDEFINITION");

			//Name field
			XmlElement name = xml.CreateElement("NAME");
			name.InnerText = txtName.Text;
			root.AppendChild(name);

			//Type
			XmlElement type = xml.CreateElement("TYPE");
			type.InnerText = cmbType.SelectedValue;
			root.AppendChild(type);

			//Add Typed Article ID
            if ( txtArticleType.Text.Length > 0 )
			{
				XmlElement articletype = xml.CreateElement("ARTICLETYPE");
				articletype.InnerText = txtArticleType.Text;
				root.AppendChild(articletype);
			}

            if ( CalStartDate.SelectedDates.Count > 0 )
            {
                DateTime startdate = CalStartDate.SelectedDate; 
                XmlElement element = xml.CreateElement("ARTICLESTARTDATE");
                element.InnerText = startdate.ToString("yyyy-MM-dd HH:mm:ss");
                root.AppendChild(element);
            }
          

            //Need to a add a day to the end date as it is displayed inclusive
            //Midnight of the next day marks the end date.
            if ( CalEndDate.SelectedDates.Count > 0 )
            {
                DateTime enddate = CalEndDate.SelectedDate;
                enddate = enddate.AddDays(1);
                XmlElement element = xml.CreateElement("ARTICLEENDDATE");
                element.InnerText = enddate.ToString("yyyy-MM-dd HH:mm:ss");
                root.AppendChild(element);
            }

			//Status
			if ( cmbStatus.SelectedValue != "ALL" )
			{
				XmlElement status = xml.CreateElement("STATUS");
				status.InnerText = cmbStatus.SelectedValue;
				root.AppendChild(status);
			}

            // Comment Forum UID Prefix
            if (txtCommentForumUIDPrefix.Text.Length > 0)
            {
                XmlElement uid = xml.CreateElement("COMMENTFORUMUIDPREFIX");
                uid.InnerText = txtCommentForumUIDPrefix.Text;
                root.AppendChild(uid);
            }

			//Rating Field
			if ( txtRating.Text.Length > 0 )
			{
				XmlElement rating = xml.CreateElement("RATING");
				rating.InnerText = txtRating.Text;
				root.AppendChild(rating);
			}

			//Significance
			if ( txtSignificance.Text.Length > 0 )
			{
				XmlElement significance = xml.CreateElement("SIGNIFICANCE");
				significance.InnerText = txtSignificance.Text;
				root.AppendChild(significance);
			}

            //Significance
            if (txtBookmarkCount.Text.Length > 0)
            {
                XmlElement bookmarks = xml.CreateElement("BOOKMARKCOUNT");
                bookmarks.InnerText = txtBookmarkCount.Text;
                root.AppendChild( bookmarks );
            }

			//Date Created
			if ( txtDateCreated.Text.Length > 0 )
			{
				XmlElement datecreated = xml.CreateElement("DATECREATED");
				datecreated.InnerText = txtDateCreated.Text;
				root.AppendChild(datecreated);
			}

			//Last Updated
			if ( txtLastUpdated.Text.Length > 0 )
			{
				XmlElement lastupdated = xml.CreateElement("LASTUPDATED");
				lastupdated.InnerText = txtLastUpdated.Text;
				root.AppendChild(lastupdated);
			}

			//Sort Field
			XmlElement sortby = xml.CreateElement("SORTBY");
			if ( cmbSort.SelectedIndex != -1 )
				sortby.InnerText = cmbSort.SelectedItem.Value;
			root.AppendChild(sortby);

			//Categories
			XmlElement categories = xml.CreateElement("CATEGORIES");
			foreach (ListItem item in lstCategories.Items)
			{
					XmlElement category = xml.CreateElement("CATEGORY");
					XmlElement ID = xml.CreateElement("ID");
					ID.InnerText = item.Value;
					category.AppendChild(ID);

					XmlElement categoryname = xml.CreateElement("NAME");
					categoryname.InnerText = item.Text;
					category.AppendChild(categoryname);

					categories.AppendChild(category);
			}

			// VoteCount
			if ( txtVoteCount.Text.Length > 0 )
			{
				XmlElement votecount = xml.CreateElement("VOTECOUNT");
				votecount.InnerText = txtVoteCount.Text;
				root.AppendChild(votecount);
			}

			root.AppendChild(categories);
			xml.AppendChild(root);

			//Version 
			XmlElement version = xml.CreateElement("VERSION");
            version.InnerText = System.Configuration.ConfigurationManager.AppSettings["version"];
			root.AppendChild(version);

			//List Length - fixed at 50.
			XmlElement listlength = xml.CreateElement("LISTLENGTH");
			listlength.InnerText= "50";
			root.AppendChild(listlength);

			//ThreadType
			if(txtThreadType.Text.Length > 0)
			{
				XmlElement threadtype = xml.CreateElement("THREADTYPE");
				threadtype.InnerText = txtThreadType.Text;
				root.AppendChild(threadtype);
			}

			//EventDate
			if ( txtEventDate.Text.Length > 0 )
			{
				XmlElement eventdate = xml.CreateElement("EVENTDATE");
				eventdate.InnerText = txtEventDate.Text;
				root.AppendChild(eventdate);
			}

            //Build up key phrases XML.
            XmlElement keyphrases = xml.CreateElement("KEYPHRASES");
            foreach (ListItem item in lstKeyPhrases.Items)
            {
                string[] phrasenamespace = item.Value.Split('|');
                if (phrasenamespace.Length == 2)
                {
                    //Phrase and namespace filter.
                    string nspace = phrasenamespace[0];
                    string phrase = phrasenamespace[1];
                    XmlElement phrasexml = xml.CreateElement("PHRASE");
                    XmlElement namexml = xml.CreateElement("NAME");
                    namexml.InnerText = phrase;
                    phrasexml.AppendChild(namexml);

                    XmlElement nspacexml = xml.CreateElement("NAMESPACE");
                    nspacexml.InnerText = nspace;
                    phrasexml.AppendChild(nspacexml);
                    keyphrases.AppendChild(phrasexml);
                }
                else
                {
                    valKeyPhrases.IsValid = false;
                    return;
                }
            }
            root.AppendChild(keyphrases);

            int id = 0;
            if ( ViewState["ID"] != null )
            {
                id = Convert.ToInt32(ViewState["ID"]);
            }

			if ( id == 0 )
			{
                using (IDnaDataReader dataReader = _basePage.CreateDnaDataReader("dynamiclistaddlist"))
                {
                    string urlname = CurrentSite.SiteName;
                    string listXml = xml.InnerXml;
                    string listName = txtName.Text;
                    dataReader.AddParameter("@siteurlname", urlname);
                    dataReader.AddParameter("name", listName);
                    dataReader.AddParameter("xml", listXml);
                    dataReader.AddIntOutputParameter("duplicate");

                    dataReader.Execute();

                    //Move to end of resultset for output parameter.
                    dataReader.NextResult();

                    int duplicate = 0;
                    dataReader.TryGetIntOutputParameter("duplicate", out duplicate );
                    if (duplicate == 1)
                    {
                        NameReqValidator.IsValid = false;
                        return;
                    }
                }
			}
			else
			{
				//Do Update 
                using (IDnaDataReader dataReader = _basePage.CreateDnaDataReader("dynamiclistupdatelist"))
                {
                    string urlname = CurrentSite.SiteName;
                    string listXml = xml.InnerXml;
                    string listName = txtName.Text;
                    
                    dataReader.AddParameter("ID",id);
                    dataReader.AddParameter("name",listName);
                    dataReader.AddParameter("xml", listXml);
                    dataReader.AddIntOutputParameter("duplicate");

                    //Execute and move to end of resultset.
                    dataReader.Execute();
                    dataReader.NextResult();
                        
                    int duplicate = 0;
                    dataReader.TryGetIntOutputParameter("duplicate",out duplicate);
                    if ( duplicate == 1 )
                    {
                        NameReqValidator.IsValid = false;
                        return;
                    }
                }
			}

            //Dont send request (HTTP 302) back to browser asking for redirect, do a server side redirect.
            Server.Transfer("DynamicListAdmin.aspx");
		}

		protected void btnCancel_Click(object sender, System.EventArgs e)
		{
            //Dont send request (HTTP 302) back to browser asking for redirect, do a server side redirect.
            Server.Transfer("DynamicListAdmin.aspx");
        }

		protected void btnAddCategory_Click(object sender, System.EventArgs e)
		{
			string snodeId = txtAddCategory.Text;

			if ( snodeId.Length == 0 || !Page.IsValid )
			{
				CategoryValidator.IsValid = false;
				return;
			}
			
			//Get Node from Database.
    using (IDnaDataReader dataReader = _basePage.CreateDnaDataReader("getHierarchyNodeDetails2"))
            {
                dataReader.AddParameter("@nodeId", snodeId);
                dataReader.Execute();

                if ( dataReader.Read() )
                {
                    int ordinal = dataReader.GetOrdinal("DisplayName");
                    string displayname = dataReader.GetString(ordinal);

                    ordinal = dataReader.GetOrdinal("NodeID");
                    int iid = dataReader.GetInt32(ordinal);
                    StringWriter writer = new StringWriter();
                    writer.Write(iid);
                    ListItem listitem = new ListItem(displayname, writer.ToString());
                    lstCategories.Items.Add(listitem);
                    dataReader.NextResult();
                }
            }
		}

		protected void btnRemoveCategory_Click(object sender, System.EventArgs e)
		{
			if ( lstCategories.SelectedIndex != -1 ) 
			{
				lstCategories.Items.RemoveAt(lstCategories.SelectedIndex);
			}
		}

        private void UIDValidator_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
        {
            args.IsValid = true;
            if (txtCommentForumUIDPrefix.Text != "")
            {
                if (cmbType.SelectedValue != "COMMENTFORUMS")
                {
                    args.IsValid = false;
                }
            }
        }

		private void ArticleTypeValidator_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			args.IsValid = true;
			
			if ( txtArticleType.Text != "" )
			{
				int articletype = -1;
				try
				{
					articletype = System.Convert.ToInt32(txtArticleType.Text);
				}
				catch ( System.FormatException)
				{	
				}

				string type = cmbType.SelectedValue;
				if ( type == "ARTICLES" )
				{
                    if ( (articletype < 1 || articletype > 1000) )
                    {
					    args.IsValid = false;
					    ArticleTypeValidator.Text = "Need to specify article type for an article  1 to 1000";
					    return;
                    }
				}
                else if ( type == "CLUBS" )
				{
                    if (articletype < 1001 ||  articletype > 2000)
                    {
					    args.IsValid = false;
					    ArticleTypeValidator.Text = "Need to specify article type for a club  1001 to 2000";
					    return;
                    }
				}
                else if ( type == "FORUMS" )
				{
                    if (articletype < 2001 ||  articletype > 3000)
                    {
					    args.IsValid = false;
					    ArticleTypeValidator.Text = "Need to specify article type for a review forum  2001 to 3000";
					    return;
                    }
				}
                else if ( type == "USERPAGES" )
				{
                    if ( (articletype < 3001 ||  articletype > 4000)  )
                    {
					    args.IsValid = false;
					    ArticleTypeValidator.Text = "Need to specify article type for a user page  3001 to 4000";
					    return;
                    }
				}
				else if ( type == "CATEGORIES"  )
				{
                    if ( (articletype < 4001 ||  articletype > 5000) )
                    {
					    args.IsValid = false;
					    ArticleTypeValidator.Text = "Need to specify article type for a category  4001 to 5000";
					    return;
                    }
				}
                else
                {
                    args.IsValid = false;
					ArticleTypeValidator.Text = "Article type not valid for type specified.";
					return;
                }
			}
		}

		private void DateValidator_ServerValidate(object source, System.Web.UI.WebControls.ServerValidateEventArgs args)
		{
			int datecreated = 0;
			if ( txtDateCreated.Text.Length > 0 )
			{
				try
				{
					datecreated = System.Convert.ToInt32(txtDateCreated.Text);
				}
				catch ( System.FormatException)
				{
					args.IsValid = false;
					DateValidator.Text = "Please enter number of days old.";
					return;
				}
			}

			int lastupdated = 0;
			if ( txtLastUpdated.Text.Length > 0 )
			{
				try
				{
					lastupdated = System.Convert.ToInt32(txtLastUpdated.Text);
				}
				catch ( System.FormatException)
				{
					args.IsValid = false;
					DateValidator.Text = "Please enter number of days old.";
					return;
				}
			}

			//Check that date Created is before Last Updated.
			if ( datecreated < lastupdated )
			{
				args.IsValid = false;
				DateValidator.Text="DateCreated should be before LastUpdated.";
			}
		}

		protected void btnAddKeyPhrase_Click(object sender, System.EventArgs e)
		{
            if (txtKeyPhrases.Text.Length > 0)
            {
                string nspace = string.Empty;
                if (cmbNameSpaces.SelectedValue != null && cmbNameSpaces.SelectedValue.Length > 0 )
                {
                    nspace = cmbNameSpaces.SelectedValue;
                }
           
                lstKeyPhrases.Items.Add(new ListItem(nspace == string.Empty ? txtKeyPhrases.Text : nspace + ":" + txtKeyPhrases.Text, nspace + "|" +  txtKeyPhrases.Text));
            }
		}

		protected void btnRemoveKeyPhrase_Click(object sender, System.EventArgs e)
		{
			if (lstKeyPhrases.SelectedIndex >= 0)
			{
                lstKeyPhrases.Items.RemoveAt(lstKeyPhrases.SelectedIndex);
			}
		}

    protected void cmbStartMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        CalStartDate.VisibleDate = new DateTime(Convert.ToInt32(cmbStartYear.SelectedValue), Convert.ToInt32(cmbStartMonth.SelectedValue), 1);
    }
    protected void cmbStartYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        CalStartDate.VisibleDate = new DateTime(Convert.ToInt32(cmbStartYear.SelectedValue), Convert.ToInt32(cmbStartMonth.SelectedValue), 1);
    }
    protected void cmbEndMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        int year = Convert.ToInt32(cmbEndYear.SelectedValue);
        int month = Convert.ToInt32(cmbEndMonth.SelectedValue);
        CalEndDate.VisibleDate = new DateTime(Convert.ToInt32(cmbEndYear.SelectedValue), Convert.ToInt32(cmbEndMonth.SelectedValue), 1);
    }
    protected void cmbEndYear_SelectedIndexChanged(object sender, EventArgs e)
    {
        int year = Convert.ToInt32(cmbEndYear.SelectedValue);
        int month = Convert.ToInt32(cmbEndMonth.SelectedValue);
        CalEndDate.VisibleDate = new DateTime(Convert.ToInt32(cmbEndYear.SelectedValue), Convert.ToInt32(cmbEndMonth.SelectedValue), 1);
    }
    protected void btnClearStartDate_Click(object sender, EventArgs e)
    {
        CalStartDate.SelectedDates.Clear();
        lblStartDate.Text = "No Start Date";
    }
    protected void btnClearEndDate_Click(object sender, EventArgs e)
    {
        CalEndDate.SelectedDates.Clear();
        lblEndDate.Text = "No End Date";
    }
    protected void CalStartDate_SelectionChanged(object sender, EventArgs e)
    {
        if (CalStartDate.SelectedDates.Count > 0)
        {
            lblStartDate.Text = CalStartDate.SelectedDate.ToString("dd/MM/yy");
        }
    }
    protected void CalEndDate_SelectionChanged(object sender, EventArgs e)
    {
        if (CalEndDate.SelectedDates.Count > 0)
        {
            lblEndDate.Text = CalEndDate.SelectedDate.ToString("dd/MM/yy");
        }
    }
}
