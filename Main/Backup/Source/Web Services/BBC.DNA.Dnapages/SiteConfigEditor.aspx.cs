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
using System.Collections.Generic;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Page;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Sites;

public partial class SiteConfigEditor : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// The default constructor
    /// </summary>
    public SiteConfigEditor()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// Page type property
    /// </summary>
    public override string PageType
    {
        get { return "SITECONFIG-EDITOR"; }
    }

    /// <summary>
    /// Allowed Editors property
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }

    private XmlDocument _configXmlDoc = null;
    private XmlNode _currentSiteConfig;
    private Dictionary<string, Dictionary<string, string>> _currentSectionStrings = new Dictionary<string, Dictionary<string, string>>();
    private string _editKey;
    private int _currentSiteID = 0;
    private bool _barlequeRedesign = false;
    private string _v2TagName = "V2_BOARDS";
    
    /// <summary>
    /// OnPageLoad method 
    /// </summary>
    public override void OnPageLoad()
    {
        // Set the VirtualUrl item in the context to the page name. This is done to get round the problems
        // with post backs
        Context.Items["VirtualUrl"] = "SiteConfigEditor";

        // Check to see if the user has permissions for this page
        if (!IsDnaUserAllowed())
        {
            // Hide the UI
            foreach (Control control in form1.Controls)
            {
                control.Visible = false;
            }

            // Tell the user.
            message.Text = "\n\rYou are not authorised to view this page!";
            message.Font.Bold = true;
            message.ForeColor = System.Drawing.Color.Red;
            message.Visible = true;
            return;
        }

        // Update the title of the page
        lbEditingSite.Text = "Editing site config for " + _basePage.CurrentSite.SiteName;

        // Make sure the message tetx is hidden.
        message.Visible = false;

        // Get the edit key and current site from the viewstate
        _editKey = (string)ViewState["EditKey"];
        _currentSiteID = Convert.ToInt32((string)ViewState["CurrentSiteID"]);
        btToggleMode.Visible = _basePage.GetSiteOptionValueBool("General", "IsMessageboard");

        if (ViewState["Mode"] == null)
        {
            _barlequeRedesign = _basePage.GetSiteOptionValueBool("General", "BarlequeMessageboard");
            ViewState.Add("Mode", _barlequeRedesign);
            if (_barlequeRedesign)
            {
                btToggleMode.Text = "Edit New MB Style";
            }
            else
            {
                btToggleMode.Text = "Edit Old MB Style";
            }
        }
        else
        {
            _barlequeRedesign = (bool)ViewState["Mode"];
        }
        
        // Get the config from the viewstate if it's valid
        if (ViewState["ConfigXmlDoc"] != null)
        {
            _configXmlDoc = new XmlDocument();
            _configXmlDoc.LoadXml((string)ViewState["ConfigXmlDoc"]);
        }

        // Get the currently edited sections
        if (ViewState["CurrentSections"] != null)
        {
            // Get the sections from the view state
            Dictionary<string, Dictionary<string, string>>.Enumerator sectionEnum = ((Dictionary<string, Dictionary<string, string>>)ViewState["CurrentSections"]).GetEnumerator();
            while (sectionEnum.MoveNext())
            {
                _currentSectionStrings.Add(sectionEnum.Current.Key, sectionEnum.Current.Value);
            }
        }

        // Check to see if we've got an edit key
        if (_editKey == null || _currentSiteID != _basePage.CurrentSite.SiteID)
        {
            // No. Get the siteconfig and edit key from the database. Update the drop with the config sections.
            GetCurrentSiteConfig();
            _currentSiteID = _basePage.CurrentSite.SiteID;

            // Put the current site and edit key into the viewstate
            ViewState["EditKey"] = _editKey;
            ViewState["CurrentSiteID"] = _currentSiteID.ToString();
        }

        // Make sure the buttons are enble correctly
        reloadPage.Visible = true;
        reloadPage.Enabled = false;
        if (_barlequeRedesign)
        {
            btAddSection.Visible = _basePage.ViewingUser.IsSuperUser;
            tbNewSection.Visible = _basePage.ViewingUser.IsSuperUser;
            Lable2.Visible = _basePage.ViewingUser.IsSuperUser;
            btRemove.Visible = _basePage.ViewingUser.IsSuperUser;
            btUpdateSection.Enabled = _basePage.ViewingUser.IsSuperUser;
        }
        else
        {
            btRemove.Enabled = (_currentSectionStrings.Count > 0);
            btUpdateSection.Enabled = (_currentSectionStrings.Count > 0);
        }
    }

    /// <summary>
    /// This method gets the site config and editkey from the database. It then re populates the drop down with the current sections
    /// </summary>
    private void GetCurrentSiteConfig()
    {
        // Get the current preview config and edit key
        using (IDnaDataReader reader = _basePage.CreateDnaDataReader("fetchpreviewsiteconfig"))
        {
            // Add the site id
            reader.AddParameter("SiteID", _basePage.CurrentSite.SiteID);
            reader.Execute();

            // Get the config and edit key
            if (reader.HasRows && reader.Read())
            {
                _editKey = reader.GetGuidAsStringOrEmpty("EditKey");
                XmlDocument xDoc = new XmlDocument();
                string siteConfig = reader.GetStringNullAsEmpty("Config");

                // Check to make sure we have a config for this site
                if (siteConfig.Length == 0)
                {
                    // Nothing in the database, setup the base tag
                    if (!_barlequeRedesign)
                    {
                        siteConfig = "<SITECONFIG></SITECONFIG>";
                    }
                    else
                    {
                        siteConfig = "<SITECONFIG><" + _v2TagName + "></" + _v2TagName + "></SITECONFIG>";
                    }
                }
                try
                {
                    xDoc.LoadXml(Entities.GetEntities() + siteConfig);
                    _currentSiteConfig = xDoc.ImportNode(xDoc.FirstChild.NextSibling, true);
                }
                catch (XmlException ex)
                {
                    // Had a problem parsing the siteconfig
                    message.Text = "\n\rThe following error occured - " + ex.Message;
                    message.Font.Bold = true;
                    message.ForeColor = System.Drawing.Color.Red;
                    message.Visible = true;
                    _basePage.Diagnostics.WriteExceptionToLog(ex);
                }
            }
        }

        // Check to make sure we got an edit key.
        if (_editKey == null)
        {
            // Tell the user.
            message.Text = "\n\rFailed to get an edit key for this site!";
            message.Font.Bold = true;
            message.ForeColor = System.Drawing.Color.Red;
            message.Visible = true;
        }
        else
        {
            // Now Initialise the dropdwon with the config
            PopulateDropDown();

            // Get the index of the select item and display the XML for that section
            Dictionary<string,string> selectedData;
            if (_currentSectionStrings.Count > 0 && _currentSectionStrings.TryGetValue(dlbConfigSections.SelectedItem.Text + "0", out selectedData))
            {
                dlbConfigSections.SelectedIndex = 0;
                string selectedText = "";
                selectedData.TryGetValue(dlbConfigSections.SelectedItem.Text, out selectedText);
                tbSectionXML.Text = selectedText;
            }
        }
    }

    /// <summary>
    /// Populates the dropdown with a list of the config sections
    /// </summary>
    private void PopulateDropDown()
    {
        // Parse the config for the top level elements
        //_currentSections.Clear();
        _currentSectionStrings.Clear();
        dlbConfigSections.Items.Clear();
        int index = 0;
        if (!_barlequeRedesign)
        {
            foreach (XmlNode element in _currentSiteConfig.ChildNodes)
            {
                Dictionary<string, string> data = new Dictionary<string, string>();
                data.Add(element.Name, element.InnerXml);
                _currentSectionStrings.Add(element.Name + index, data);
                //_currentSections.Add(element.Name + index, element);
                dlbConfigSections.Items.Add(element.Name.ToString());
                index++;
            }
        }
        else
        {
            XmlNode baseNode = _currentSiteConfig.SelectSingleNode("//" + _v2TagName);
            if (baseNode == null)
            {
                XmlNode newNode = _currentSiteConfig.OwnerDocument.CreateElement(_v2TagName);
                _currentSiteConfig.AppendChild(newNode);
                baseNode = _currentSiteConfig.SelectSingleNode("//" + _v2TagName);
            }
            foreach (XmlNode element in _currentSiteConfig.SelectSingleNode("//" + _v2TagName).ChildNodes)
            {
                Dictionary<string, string> data = new Dictionary<string, string>();
                data.Add(element.Name, element.InnerXml);
                _currentSectionStrings.Add(element.Name + index, data);
                //_currentSections.Add(element.Name + index, element);
                dlbConfigSections.Items.Add(element.Name.ToString());
                index++;
            }
        }

        // Get the XmlDocument so we can use it to create new nodes
        _configXmlDoc = _currentSiteConfig.OwnerDocument;
        ViewState["ConfigXmlDoc"] = _configXmlDoc.InnerXml;
        ViewState["CurrentSections"] = _currentSectionStrings;
    }

    /// <summary>
    /// Updates the edit box with the select sections XML
    /// </summary>
    /// <param name="sender">The object that sent the event</param>
    /// <param name="e">any arguments that are associated with the event</param>
    protected void dlbConfigSections_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Get the index of the select item and display the XML for that section
        Dictionary<string,string> sectionData;
        if (_currentSectionStrings.TryGetValue(dlbConfigSections.SelectedItem.Text + dlbConfigSections.SelectedIndex, out sectionData))
        {
            string data = "";
             sectionData.TryGetValue(dlbConfigSections.SelectedItem.Text, out data);
            tbSectionXML.Text = data;
        }
    }

    /// <summary>
    /// Updates the the current section with whatever is in the text box
    /// </summary>
    /// <param name="sender">The button that has been clicked</param>
    /// <param name="e">Any arguments associated with the event.</param>
    protected void btUpdateSection_Click(object sender, EventArgs e)
    {
        // Get the node that represents the currently selected section
        Dictionary<string, string> selectSection;
        if (_currentSectionStrings.TryGetValue(dlbConfigSections.SelectedItem.Text + dlbConfigSections.SelectedIndex, out selectSection))
        {
            // Check to see if there are any changes
            string sectionContent = tbSectionXML.Text;
            string updateString = "";
            selectSection.TryGetValue(dlbConfigSections.SelectedItem.Text, out updateString);
            if (updateString.CompareTo(sectionContent) != 0)
            {
                // Wrap the content in a tag for ease of processing
                sectionContent = "<" + dlbConfigSections.SelectedItem.Text + ">" + sectionContent + "</" + dlbConfigSections.SelectedItem.Text + ">";

                // Create a new document from the text
                XmlDocument xDoc = new XmlDocument();
                try
                {
                    // Make sure the new section parses correctly
                    xDoc.LoadXml(Entities.GetEntities() + sectionContent);
                    Dictionary<string, string> newData = new Dictionary<string, string>();
                    newData.Add(dlbConfigSections.SelectedItem.Text, tbSectionXML.Text);
                    _currentSectionStrings[dlbConfigSections.SelectedItem.Text + dlbConfigSections.SelectedIndex] = newData;
                    ViewState["CurrentSections"] = _currentSectionStrings;
                }
                catch (XmlException ex)
                {
                    // Had a problem creating the new section
                    message.Text = "\n\rThe following error occured - " + ex.Message;
                    message.Font.Bold = true;
                    message.ForeColor = System.Drawing.Color.Red;
                    message.Visible = true;
                    return;
                }

                // Tell the user.
                message.Text = "\n\rThe section '" + dlbConfigSections.SelectedItem.Text + "' has now been updated.";
                message.Font.Bold = true;
                message.ForeColor = System.Drawing.Color.Green;
                message.Visible = true;
                reloadPage.Enabled = true;
            }
        }
    }

    /// <summary>
    /// Handles the remove section button clicks
    /// </summary>
    /// <param name="sender">The button that was clicked</param>
    /// <param name="e">Any arguments associated with the event</param>
    protected void btRemove_Click(object sender, EventArgs e)
    {
        // Get the index of the section we're wanting to remove
        int index = dlbConfigSections.SelectedIndex;

        if (_currentSectionStrings.ContainsKey(dlbConfigSections.SelectedValue + index))
        {
            // Remove the section from the dropdown and dictionary
            string removeSection = dlbConfigSections.SelectedValue;
            _currentSectionStrings.Remove(dlbConfigSections.SelectedValue + index);
            dlbConfigSections.Items.RemoveAt(index);

            // Now update the current sections so that they take into account of the index values
            Dictionary<string, Dictionary<string, string>> updatedSections = new Dictionary<string, Dictionary<string, string>>();
            Dictionary<string, Dictionary<string, string>>.Enumerator sectionEnum = _currentSectionStrings.GetEnumerator();
            int i = 0;
            while (sectionEnum.MoveNext())
            {
                Dictionary<string, string> newData = sectionEnum.Current.Value;
                Dictionary<string, string>.Enumerator dataEnum = sectionEnum.Current.Value.GetEnumerator();
                if (dataEnum.MoveNext())
                {
                    updatedSections.Add(dataEnum.Current.Key + i, newData);
                    i++;
                }
            }

            // Now set the current sections to the update ones
            _currentSectionStrings.Clear();
            _currentSectionStrings = updatedSections;
            ViewState["CurrentSections"] = _currentSectionStrings;

            // Get the index of the select item and display the XML for that section
            Dictionary<string,string> sectionData;
            if (_currentSectionStrings.Count > 0 && _currentSectionStrings.TryGetValue(dlbConfigSections.SelectedItem.Text + dlbConfigSections.SelectedIndex, out sectionData))
            {
                dlbConfigSections.SelectedIndex = 0;
                string sectionText = "";
                sectionData.TryGetValue(dlbConfigSections.SelectedItem.Text, out sectionText);
                tbSectionXML.Text = sectionText;
            }

            // Tell the user.
            message.Text = "\n\rThe section '" + removeSection + "' has now been removed.";
            message.Font.Bold = true;
            message.ForeColor = System.Drawing.Color.Green;
            message.Visible = true;

            // Make sure the buttons are enble correctly
            btRemove.Enabled = (_currentSectionStrings.Count > 0);
            btUpdateSection.Enabled = (_currentSectionStrings.Count > 0);
            reloadPage.Enabled = true;
        }
    }

    /// <summary>
    /// Handles the Add section button click
    /// </summary>
    /// <param name="sender">The button that was clicked</param>
    /// <param name="e">Any arguments that were associated with the event</param>
    protected void btAddSection_Click(object sender, EventArgs e)
    {
        // Get the value from the new section textbox, create the node and insert it into the list
        string newSection = tbNewSection.Text.ToUpper();
        if (newSection.Length > 0)
        {
            Dictionary<string, string> data = new Dictionary<string, string>();
            data.Add(newSection, "");
            _currentSectionStrings.Add(newSection + dlbConfigSections.Items.Count, data);
            ViewState["CurrentSections"] = _currentSectionStrings;
            dlbConfigSections.Items.Add(newSection);
            dlbConfigSections.SelectedIndex = dlbConfigSections.Items.Count - 1;
            tbSectionXML.Text = "";
            tbNewSection.Text = "";

            // Tell the user.
            message.Text = "\n\rThe section '" + newSection + "' has now been added. Please update the sections data.";
            message.Font.Bold = true;
            message.ForeColor = System.Drawing.Color.Green;
            message.Visible = true;
        }

        // Make sure the buttons are enble correctly
        btRemove.Enabled = (_currentSectionStrings.Count > 0);
        btUpdateSection.Enabled = (_currentSectionStrings.Count > 0);
        reloadPage.Enabled = true;
    }

    /// <summary>
    /// Handles the finish and update button click
    /// </summary>
    /// <param name="sender">The button that was clicked</param>
    /// <param name="e">Any arguments associated with the event</param>
    protected void btUpdate_Click(object sender, EventArgs e)
    {
        // This is the bit where we update the preview and live siteconfig with the new changes
        XmlDocument newConfig = new XmlDocument();
        XmlNode root = newConfig.AppendChild(newConfig.CreateElement("SITECONFIG"));

        if (_barlequeRedesign)
        {
            foreach (XmlNode node in _configXmlDoc.FirstChild.NextSibling.ChildNodes)
            {
                if (node.Name != _v2TagName)
                {
                    root.AppendChild(newConfig.ImportNode(node, true));
                }
            }

            XmlNode newNode = newConfig.CreateElement(_v2TagName);
            root.AppendChild(newNode);
            root = newNode;
        }

        Dictionary<string, Dictionary<string, string>>.Enumerator sectionEnum2 = _currentSectionStrings.GetEnumerator();
        while (sectionEnum2.MoveNext())
        {
            Dictionary<string, string>.Enumerator dataEnum = sectionEnum2.Current.Value.GetEnumerator();
            if (dataEnum.MoveNext())
            {
                XmlDocument sectionDoc = new XmlDocument();
                sectionDoc.LoadXml(Entities.GetEntities() + "<" + dataEnum.Current.Key + ">" + dataEnum.Current.Value + "</" + dataEnum.Current.Key + ">");
                root.AppendChild(newConfig.ImportNode(sectionDoc.FirstChild.NextSibling, true));
            }
        }
        
        // Now update the site config
        _configXmlDoc.RemoveAll();
        _configXmlDoc.AppendChild(_configXmlDoc.ImportNode(newConfig.FirstChild, true));

        using (IDnaDataReader reader = _basePage.CreateDnaDataReader("UpdatePreviewAndLiveConfig"))
        {
            reader.AddParameter("SiteID", _basePage.CurrentSite.SiteID);
            reader.AddParameter("Config", _configXmlDoc.InnerXml.ToString());
            reader.AddParameter("EditKey", _editKey);
            reader.Execute();

            if (reader.HasRows && reader.Read())
            {
                message.Font.Bold = true;
                if (reader.GetInt32("ValidKey") == 0)
                {
                    // Tell the user we've just saved.
                    message.Text = "Your changes have not been applied! Someone has updated the config before you. Please make a note of your changes, reload the page and then re-apply your changes.";
                    message.ForeColor = System.Drawing.Color.Red;
                    reloadPage.Visible = true;
                }
                else
                {
                    AppContext.TheAppContext.TheSiteList.SendSignal(_basePage.CurrentSite.SiteID);

                    // Tell the user we've just saved.
                    message.Text = "\n\rThe site config has now been updated.";
                    message.ForeColor = System.Drawing.Color.Green;

                    // Finally reset the edit key as it will need to be reloaded
                    _editKey = null;
                    ViewState.Remove("EditKey");
                }

                // Make the message visable
                message.Visible = true;
                reloadPage.Enabled = false;
            }
        }
    }

    /// <summary>
    /// Handles the reload page button click
    /// </summary>
    /// <param name="sender">The button that was clicked</param>
    /// <param name="e">Any arguments associated with the event</param>
    protected void OnReloadPage(object sender, EventArgs e)
    {
        // Set the edit key to null and force a get of the current siteconfig and editkey from the database.
        _editKey = null;
        GetCurrentSiteConfig();

        // Hide the reload button as we've just done it
        reloadPage.Enabled = false;
    }

    protected void btToggleMode_CheckedChanged(object sender, EventArgs e)
    {
        if (_barlequeRedesign)
        {
            ViewState.Add("Mode", false);
            btToggleMode.Text = "Edit New Style MB";
            _barlequeRedesign = false;
        }
        else
        {
            ViewState.Add("Mode", true);
            btToggleMode.Text = "Edit Old Style MB";
            _barlequeRedesign = true;
        }

        // Set the edit key to null and force a get of the current siteconfig and editkey from the database.
        _editKey = null;
        GetCurrentSiteConfig();

        // Hide the reload button as we've just done it
        reloadPage.Enabled = false;
    }
}
