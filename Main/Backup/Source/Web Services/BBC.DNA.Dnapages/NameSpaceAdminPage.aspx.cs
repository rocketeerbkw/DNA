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
using BBC.Dna;
using BBC.Dna.Page;

public partial class NameSpaceAdminPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// The default constructor
    /// </summary>
    public NameSpaceAdminPage()
    {
        UseDotNetRendering = true;
    }

    /// <summary>
    /// Page type property
    /// </summary>
    public override string PageType
    {
        get { return "NAMESPACE-ADMIN"; }
    }

    /// <summary>
    /// Allowed users property
    /// </summary>
    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.EditorAndAbove; }
    }

    /// <summary>
    /// OnPageLoad method 
    /// </summary>
    public override void OnPageLoad()
    {
        // Set the VirtualUrl item in the context to the page name. This is done to get round the problems
        // with post backs
        Context.Items["VirtualUrl"] = "NameSpaceAdmin";

        // Display the namespaces for the site
        DisplayNameSpacesForSite();
    }

    /// <summary>
    /// Holds a list of the current textboxes holding the namespaces names
    /// </summary>
    private List<TextBox> displayNames = new List<TextBox>();

    /// <summary>
    /// Holds a list of the namespaces in the database
    /// </summary>
    private List<NameSpaceItem> databaseNameSpaces = null;

    /// <summary>
    /// Gets the current list of namespaces from the database
    /// </summary>
    /// <returns>The list of namespaces in the database</returns>
    private List<NameSpaceItem> GetDatabaseNameSpaces
    {
        get
        {
            // Check to see if we've already got the list
            if (databaseNameSpaces == null)
            {
                // Create the list and fill it
                NameSpaces siteNameSpaces = new NameSpaces(_basePage);
                databaseNameSpaces = siteNameSpaces.GetNameSpacesForSite(_basePage.CurrentSite.SiteID);
            }

            // return the current list
            return databaseNameSpaces;
        }
    }

    /// <summary>
    /// Displays all the namespaces for the current site
    /// </summary>
    private void DisplayNameSpacesForSite()
    {
        // Diaplay the name of the site that the namespaces belong to
        namespacelable.Text = "Namespaces for site " + _basePage.CurrentSite.SiteName;

        // Now populate the list with the current namespaces
        foreach (NameSpaceItem name in GetDatabaseNameSpaces)
        {
            // Add each item as a row to the table
            tblNameSpaces.Rows.Add(CreateNameSpaceTableItem(name));
        }

        // Set the table width and height depending on the number of items
        tblNameSpaces.Width = 400;
        if (tblNameSpaces.Rows.Count > 0)
        {
            tblNameSpaces.Height = tblNameSpaces.Rows.Count * (int)tblNameSpaces.Rows[0].Height.Value;
        }
        else
        {
            tblNameSpaces.Height = 0;
        }
    }

    /// <summary>
    /// Creates a table row that consists of a textbox for the name and rename, show phrases, delete buttons for a given name space item
    /// </summary>
    /// <param name="nameSpaceItem">The item that you want to insert into the table</param>
    /// <returns>The new table row to be inserted into the table</returns>
    private TableRow CreateNameSpaceTableItem(NameSpaceItem nameSpaceItem)
    {
        // Create the row
        TableRow newRow = new TableRow();
        newRow.ID = "namespaceitem" + nameSpaceItem.ID;

        // Now create the name cell
        TableCell nameCell = new TableCell();
        TextBox tbName = new TextBox();
        tbName.Width = 300;
        tbName.Text = nameSpaceItem.Name;
        tbName.ID = "Name" + nameSpaceItem.ID;
        tbName.EnableViewState = true;
        nameCell.Controls.Add(tbName);
        newRow.Cells.Add(nameCell);
        nameCell.Width = 300;
        displayNames.Add(tbName);

        // Add the rename link
        TableCell renameCell = new TableCell();
        Button btRename = new Button();
        btRename.Text = "Rename";
        btRename.ID = "Rename" + nameSpaceItem.ID;
        btRename.EnableViewState = true;
        btRename.Click += new EventHandler(OnRenameButtonClick);
        btRename.CommandArgument = "Name" + nameSpaceItem.ID;
        btRename.CommandName = "Rename";
        renameCell.Controls.Add(btRename);
        newRow.Cells.Add(renameCell);
        renameCell.Width = btRename.Width;

        // Add the show phrases button
        TableCell showCell = new TableCell();
        Button btShowPhrases = new Button();
        btShowPhrases.Text = "Show Phrases";
        btShowPhrases.ID = "Show" + nameSpaceItem.ID;
        btShowPhrases.EnableViewState = true;
        btShowPhrases.Click += new EventHandler(OnShowButtonClick);
        btShowPhrases.CommandArgument = "Show" + nameSpaceItem.ID;
        btShowPhrases.CommandName = "Show";
        showCell.Controls.Add(btShowPhrases);
        newRow.Cells.Add(showCell);
        renameCell.Width = btShowPhrases.Width;

        // Add the delete button
        TableCell deleteCell = new TableCell();
        Button btDelete = new Button();
        btDelete.Text = "Delete";
        btDelete.ID = "Delete" + nameSpaceItem.ID;
        btDelete.Click += new EventHandler(OnDeleteButtonClick);
        btDelete.CommandArgument = "Name" + nameSpaceItem.ID;
        btDelete.CommandName = "Delete";
        btDelete.OnClientClick = @"return confirm('Are you sure want to delete this namespace?');";
        deleteCell.Controls.Add(btDelete);
        newRow.Cells.Add(deleteCell);
        deleteCell.Width = btDelete.Width;

        // Return the new row
        return newRow;
    }

    /// <summary>
    /// The Event handler method for the renames button click
    /// </summary>
    /// <param name="sender">The button control that was clicked</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void OnRenameButtonClick(object sender, EventArgs e)
    {
        // Make sure the button that was clicked was a rename button
        Button btClicked = ((Button)sender);
        if (btClicked.CommandName.CompareTo("Rename") == 0)
        {
            // Now get the textbox that was defined in the command argument
            TextBox textBox = (TextBox)FindControl(btClicked.CommandArgument);
            if (textBox != null)
            {
                // Get the id of the namespace and rename the item with the text in the text box
                string cmdArg = btClicked.CommandArgument;
                int ID = Convert.ToInt32(cmdArg.Substring(4));

                // Check to make sure that we're not creating an existsing namespace
                if (CheckToMakeSureNameDoesNotAlreadyExist(textBox.Text))
                {
                    // Now put the textbox back to it's original value
                    string original = GetOriginalTextForTextBox(textBox.Text);
                    if (original != "")
                    {
                        // The name already exists!
                        textBox.Text = original;
                        txtWarning.Height = new Unit("26px");
                        txtWarning.Visible = true;
                        txtWarning.Text = "A namespace already exists with that name!";
                    }
                    return;
                }

                // Rename the namespace to it's new name
                NameSpaces siteNameSpaces = new NameSpaces(_basePage);
                siteNameSpaces.RenameNameSpaceForSite(_basePage.CurrentSite.SiteID, ID, textBox.Text);
            }
        }
    }

    /// <summary>
    /// Checks to make sure that we are not renaming or creating a namespace that already exists.
    /// </summary>
    /// <param name="newName">The new name that is being added</param>
    /// <returns>True if the name already exists, False if not</returns>
    private bool CheckToMakeSureNameDoesNotAlreadyExist(string newName)
    {
        // Now check to see if the name already exists.
        foreach (NameSpaceItem item in GetDatabaseNameSpaces)
        {
            // Check for a match
            if (item.Name.CompareTo(newName) == 0)
            {
                // Already exists
                return true;
            }
        }

        // Didn't find it
        return false;
    }

    /// <summary>
    /// Gets the original text for a textbox before the user changed it
    /// This will only find the first database not in the displayed list
    /// </summary>
    /// <param name="nameToFind">The current text for the textbox</param>
    /// <returns>The original string the text box had before it changed</returns>
    private string GetOriginalTextForTextBox(string nameToFind)
    {
        // Go though the list 
        foreach (NameSpaceItem currentNameSpace in GetDatabaseNameSpaces)
        {
            bool foundName = false;
            for (int i = 0; i < displayNames.Count && !foundName; i++)
            {
                foundName = currentNameSpace.Name.CompareTo(displayNames[i].Text) == 0;
            }

            if (!foundName)
            {
                return currentNameSpace.Name;
            }
        }

        // Did not find the original text!
        return "";
    }

    /// <summary>
    /// The event handler for the delete button clicks
    /// </summary>
    /// <param name="sender">The button control that was clicked</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void OnDeleteButtonClick(object sender, EventArgs e)
    {
        // Make sure the button clicked was a delete button
        Button btClicked = ((Button)sender);
        if (btClicked.CommandName.CompareTo("Delete") == 0)
        {
            // Now get the id from the command argument and delete the namespace from the database
            string cmdArg = btClicked.CommandArgument;
            int ID = Convert.ToInt32(cmdArg.Substring(4));
            NameSpaces siteNameSpaces = new NameSpaces(_basePage);
            siteNameSpaces.RemoveNameSpaceForSite(_basePage.CurrentSite.SiteID, ID);

            // Remove the row from the table that contains the namespace in question
            TableRow removeRow = (TableRow)FindControl("namespaceitem" + ID);
            if (removeRow != null)
            {
                tblNameSpaces.Rows.Remove(removeRow);
            }
        }
    }

    /// <summary>
    /// The event handler for the show phrases button clicks
    /// </summary>
    /// <param name="sender">The button controls that was clicked</param>
    /// <param name="e">Any arguments associated with the event</param>
    protected void OnShowButtonClick(object sender, EventArgs e)
    {
        // Check to make sure the button clicked was a show button
        Button btClicked = ((Button)sender);
        if (btClicked.CommandName.CompareTo("Show") == 0)
        {
            // Get the ID From the command argument and find the table row that is associated with the namespace item
            string cmdArg = btClicked.CommandArgument;
            int ID = Convert.ToInt32(cmdArg.Substring(4));
            TableRow nameSpaceRow = (TableRow)FindControl("namespaceitem" + ID);
            int index = tblNameSpaces.Rows.GetRowIndex(nameSpaceRow);

            // Get all the phrases for the item and insert it into the table under the namespace
            NameSpaces siteNameSpaces = new NameSpaces(_basePage);
            List<string> phrases = siteNameSpaces.GetPhrasesForNameSpaceItem(_basePage.CurrentSite.SiteID,ID);
            tblNameSpaces.Rows.AddAt(index + 1, CreatePhrasesForItem(ID, phrases));
        }
    }

    /// <summary>
    /// Creates a row to be inserted into the table that contains all the phrases for a given namespace id
    /// </summary>
    /// <param name="nameSpaceItem">The namespace item that you want the phrases for</param>
    /// <returns>The table row that contains the phrases</returns>
    private TableRow CreatePhrasesForItem(int ID, List<string> nameSpacePhrases)
    {
        // Create the row
        TableRow newRow = new TableRow();
        newRow.ID = "namespacephrases" + ID;

        // Now create the name cell
        TableCell nameCell = new TableCell();
        TextBox tbName = new TextBox();
        tbName.Height = 80;
        string phrases = "";
        if (nameSpacePhrases.Count == 0)
        {
            phrases = "(No Phrases!!!)";
        }
        else
        {
            for (int i = 0; i < nameSpacePhrases.Count; i++)
            {
                phrases += nameSpacePhrases[i];
                if (i < nameSpacePhrases.Count - 1)
                {
                    phrases += ", ";
                }
            }
        }
        tbName.Text = phrases;
        tbName.ID = "phrases" + ID;
        tbName.EnableViewState = true;
        tbName.Wrap = true;
        tbName.TextMode = TextBoxMode.MultiLine;
        nameCell.ColumnSpan = 4; 
        nameCell.Controls.Add(tbName);
        tbName.Width = new Unit("100%");
        newRow.Cells.Add(nameCell);
        return newRow;
    }

    /// <summary>
    /// The event handler for the create namespace button click
    /// </summary>
    /// <param name="sender">The button control that was clicked</param>
    /// <param name="e">Any arguments that are associated with the event</param>
    protected void btnCreate_Click(object sender, EventArgs e)
    {
        // Check to make sure that we are not creating an existsing namespace
        if (CheckToMakeSureNameDoesNotAlreadyExist(tbNewName.Text))
        {
            // The name already exists!
            txtWarning.Height = new Unit("26px");
            txtWarning.Visible = true;
            txtWarning.Text = "That namespace already exists!";
            return;
        }

        // Create a namespace object that will create the new namespace for the site
        NameSpaces siteNameSpaces = new NameSpaces(_basePage);
        int id = siteNameSpaces.AddNameSpaceForSite(_basePage.CurrentSite.SiteID, tbNewName.Text);
        tblNameSpaces.Rows.Add(CreateNameSpaceTableItem(new NameSpaceItem(tbNewName.Text,id)));
    }
}
