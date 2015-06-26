using System;
using System.Xml;
using System.Web.UI;
using System.Web.UI.WebControls;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Sites;

public partial class MoveThreadPage : BBC.Dna.Page.DnaWebPage
{
    /// <summary>
    /// Default constructor.
    /// </summary>
    public MoveThreadPage()
    {
        UseDotNetRendering = true;
    }

    public override string PageType
    {
        get { return "MOVE-THREAD"; }
    }

    private MoveThread _moveThread;

    /// <summary>
    /// This function is where the page gets to create and insert all the objects required
    /// </summary>
    public override void OnPageLoad()
    {
        // See if we're wanting .net rendering?
        Context.Items["VirtualUrl"] = "NewMoveThread";

        // Now create the comment forum list object
        _moveThread = new MoveThread(_basePage);
        AddComponent(_moveThread);

        // Do any dotnet render stuff now
        if (UseDotNetRendering)
        {
            // Populate the move to forum list
            MoveToForumID.Items.Add(new ListItem("Choose Destination", "0"));
            foreach (Topic topic in _basePage.CurrentSite.GetLiveTopics())
            {
                MoveToForumID.Items.Add(new ListItem(topic.Title, topic.ForumId.ToString()));
            }
        }
    }

    public override bool IsHtmlCachingEnabled()
    {
        return false;
    }

    public override int GetHtmlCachingTime()
    {
        return GetSiteOptionValueInt("Cache", "HTMLCachingExpiryTime");
    }

    public override DnaBasePage.UserTypes AllowedUsers
    {
        get { return DnaBasePage.UserTypes.ModeratorAndAbove; }
    }

    /// <summary>
    /// Check to see if we need to update anything on the outcome of the components process request.
    /// </summary>
    public override void OnPostProcessRequest()
    {
        // Only update the controls if we're running in .net rendering
        if (UseDotNetRendering)
        {
            UpdateWebControls();
        }
    }

    /// <summary>
    /// DotNet Render only function! Updates the thread details controls.
    /// </summary>
    private void UpdateThreadDetailControls()
    {
        // Set the thread id and subject
        tbThreadSubject.Text = _moveThread.ThreadSubject;
        tbThreadID.Text = _moveThread.ThreadID.ToString();

        // Set the current and old forum information
        tbNewForumTitle.Text = _moveThread.CurrentForumTitle;
        tbNewForumID.Text = _moveThread.CurrentForumID.ToString();

        // Check to see if we've just moved the thread
        if (Request.DoesParamExist("Move", "Are we moving the thread?") && !_moveThread.HadErrors)
        {
            // Add the old forum details and the Undo button
            MoveThreadDetails.Visible = true;

            // Now set the old forum details
            OldForumID.Text = _moveThread.OldForumID.ToString();
            tbOldForumTitle.Text = _moveThread.OldForumTitle;

            // Tell the user that we've moved the thread
            SetMessageText("Thread moved to " + _moveThread.CurrentForumTitle, false);

            // Hide the move to forum controls
            MoveToDetails.Visible = false;
        }
        else if (Request.DoesParamExist("Undo", "Are we moving the thread?") && !_moveThread.HadErrors)
        {
            // Tell the user that we've moved the thread
            SetMessageText("Thread moved back to " + _moveThread.CurrentForumTitle, false);
        }
    }

    /// <summary>
    /// Updates the aspx controls on the page
    /// </summary>
    private void UpdateWebControls()
    {
        // Check for error messages
        string lastError = DisplayErrors();

        // Check to see if we need to add the get thread details controls
        if (lastError.CompareTo("No thread given") == 0)
        {
            // Add the controls
            AddGetThreadDetailControls();

            // Hide the other controls as they don't do anything at this stage
            ThreadDetails.Visible = false;
            MoveToDetails.Visible = false;
        }
        else if (lastError.CompareTo("User Not Authorised") == 0)
        {
            // Hide the controls as the user is not allowed to use the page
            ThreadDetails.Visible = false;
            MoveToDetails.Visible = false;
        }
        else
        {
            // Set the hidden threadID and ThreadModID
            ThreadID.Value = _moveThread.ThreadID.ToString();
            ThreadModID.Value = _moveThread.ThreadModID.ToString();
        }

        // Update the thread details controls
        UpdateThreadDetailControls();
    }

    /// <summary>
    /// DotNet Render only function! Checks to see if we have eror message and displays them to the user
    /// </summary>
    /// <returns>The text of the error message, or empty if none</returns>
    private string DisplayErrors()
    {
        // Check for the ERROR node in the xml
        XmlNode errorNode = DnaWebPageXml.SelectSingleNode("//ERROR");
        if (errorNode != null)
        {
            SetMessageText(errorNode.InnerText, true);
            return errorNode.InnerText;
        }
        return String.Empty;
    }

    /// <summary>
    /// Set the text of the message control and makes it visible
    /// </summary>
    /// <param name="text">The text that you want to set the message to</param>
    /// <param name="isError">A flag to state whether or not to make the text red for errors</param>
    private void SetMessageText(string text, bool isError)
    {
        // Get the message control
        MessagePH.Visible = true;

        // Make the control visible and set the text
        MessageText.Visible = true;
        MessageText.Text = text;

        // Do we need to change the colour?
        if (isError)
        {
            MessageText.ForeColor = System.Drawing.Color.Red;
        }
        else
        {
            MessageText.ForeColor = System.Drawing.Color.Green;
        }
    }

    /// <summary>
    /// DotNet Render only function! Adds the controls that allow the user to get the details
    /// for a thread via it's modid or thread id
    /// </summary>
    private void AddGetThreadDetailControls()
    {
        // No thread given, show the dialog to allow the user to type one in
        // Remove the hidden fields as we need to replace them with the inputs
        HiddenField threadID = (HiddenField)FindControl("ThreadID");
        if (threadID != null)
        {
            form1.Controls.Remove(threadID);
        }
        HiddenField threadModID = (HiddenField)FindControl("ThreadModID");
        if (threadModID != null)
        {
            form1.Controls.Remove(threadModID);
        }

        // Get the details for a thread via mod id
        Label modIDLabel = new Label();
        modIDLabel.Text = "Thread Mod ID: ";
        modIDLabel.Width = 150;
        TextBox modIDTextBox = new TextBox();
        modIDTextBox.ID = "ThreadModID";
        Button modIDButton = new Button();
        modIDButton.Text = "Get Details";
        GetDetailsPlaceHolder.Controls.Add(modIDLabel);
        GetDetailsPlaceHolder.Controls.Add(modIDTextBox);
        GetDetailsPlaceHolder.Controls.Add(modIDButton);

        LiteralControl br = new LiteralControl("<br />");
        GetDetailsPlaceHolder.Controls.Add(br);

        // Get the details for a thread via the threadid
        Label IDLabel = new Label();
        IDLabel.Text = "Thread ID: ";
        IDLabel.Width = 150;
        TextBox IDTextBox = new TextBox();
        IDTextBox.ID = "ThreadID";
        Button IDButton = new Button();
        IDButton.Text = "Get Details";
        GetDetailsPlaceHolder.Controls.Add(IDLabel);
        GetDetailsPlaceHolder.Controls.Add(IDTextBox);
        GetDetailsPlaceHolder.Controls.Add(IDButton);

        LiteralControl br2 = new LiteralControl("<br /><br />");
        GetDetailsPlaceHolder.Controls.Add(br2);

        GetDetailsPlaceHolder.Visible = true;
    }
}
