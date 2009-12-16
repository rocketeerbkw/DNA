using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;


namespace BBC.Dna
{
    /// <summary>
    /// The typed article component is used to create and maintain articles
    /// It uses the new Dna Template Form system which is the C# replacement for the
    /// old C++ Multistep.
    /// </summary>
    public class TypedArticle : DnaFormComponent
    {
        /// <summary>
        /// Create the base node for the component
        /// </summary>
        private XmlNode _typedArticleNode = null;
        private UITemplate _template = null;

        /// <summary>
        /// The default contructor for the typed article component
        /// </summary>
        /// <param name="context">The input context for the current request</param>
        public TypedArticle(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Called by the dna framework so that the component can have a chance at processing the request
        /// </summary>
        public override void ProcessRequest()
        {
            // Start by creating the base node for the component
            _typedArticleNode = AddElementTag(RootElement, "TYPEDARTICLE");

            // Check to make sure the user is logged in
            if (!InputContext.ViewingUser.UserLoggedIn)
            {
                // We can only use typed article when the user is logged in
                AddErrorXml("User", "User not logged in", _typedArticleNode);
                return;
            }

            // Check template we need to use for this request
            int templateID = InputContext.GetParamIntOrZero("TemplateID", "Get the template to use for this request");
            if (templateID == 0)
            {
                // We've not been given a template id!
                AddErrorXml("TypedArticle", "No Template ID Given!", _typedArticleNode);
                return;
            }

            // Create the UITemplate to get the XML for the given template id
            _template = new UITemplate(InputContext);
            _template.UITemplateID = templateID;
            _template.LoadTemplate();
            if (_template.HasErrors)
            {
                // Invalid templateid given
                AddInside(_typedArticleNode, _template);
                return;
            }

            // Now check to see if we're creating, editing or updating
            if (InputContext.DoesParamExist("Update", "Are we updating an article"))
            {
                // We're submitting updates to the article
                AddAttribute(_typedArticleNode, "ACTION", "UPDATE");

                // Process the updated article data
                UpdateArticle();
            }
            else if (InputContext.DoesParamExist("Edit", "Are we editing an article"))
            {
                // We're about to edit an article
                AddAttribute(_typedArticleNode, "ACTION", "EDIT");

                // Add the current articles data to the template
                EditArticle();
            }
            else if (InputContext.DoesParamExist("Create", "Are we Creating an article"))
            {
                // We're about to edit an article
                AddAttribute(_typedArticleNode, "ACTION", "CREATE");

                // Add the current articles data to the template
                CreateArticle();
            }
            else
            {
                // Just show the field for the given template
                AddAttribute(_typedArticleNode, "ACTION", "");
            }

            // Put the keyphrase delimiter into the XML so the skins can let the user know
            string delimiter = NamespacePhrases.GetSiteDelimiterToken(InputContext);
            AddTextTag(_typedArticleNode, "KEYPHRASE-DELIMITER", delimiter);

            // Finish by adding the template's xml to this object
            AddInside(_typedArticleNode, _template);
        }

        /// <summary>
        /// Create the article with the params passed via the URL
        /// </summary>
        private void CreateArticle()
        {
            // Get all the field values from the URL ready to send to the validation
            List<KeyValuePair<string, string>> userValues = new List<KeyValuePair<string, string>>();
            Dictionary<string, UIField>.Enumerator fields = _template.UIFields.GetEnumerator();
            while (fields.MoveNext())
            {
                // Only add the fields if they exist in the URL params
                string fieldName = fields.Current.Value.Name;
                if (InputContext.DoesParamExist(fieldName, "Does template field value"))
                {
                    userValues.Add(new KeyValuePair<string, string>(fieldName, InputContext.GetParamStringOrEmpty(fieldName, "Get template field value")));
                }
            }

            // Now send the field values to the template to validate
            _template.ProcessParameters(userValues);
            if (!_template.Validate())
            {
                // Something did not validate! return to the create page
                return;
            }

            // OK, everything validates. Create the article in the database
            bool defaultCanRead = true;
            bool defaultCanWrite = true;
            if (_template.UIFields["WhoCanEdit"].ValueString.CompareTo("Me") == 0)
            {
                defaultCanWrite = false;
            }

            bool defaultCanChangePermissions = false;
            int style = 1;
            int h2g2ID = 0;

            // Get the status for the new article
            int status = GetStatusForArticle();

            // Get the text from the input and make sure that it parses correctly
            string bodyText = TryParseGuideBody();
            if (bodyText.Length == 0)
            {
                // Failed to parse the guide body
                return;
            }

            // Add the information to the database
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("createguideentry"))
            {
                reader.AddParameter("Subject", _template.UIFields["Title"].ValueString);
                reader.AddParameter("BodyText", bodyText);
                reader.AddParameter("ExtraInfo", "");
                reader.AddParameter("Editor", InputContext.ViewingUser.UserID);
                reader.AddParameter("Style", style);
                reader.AddParameter("Status", status);
                reader.AddParameter("TypeID", _template.UIFields["Type"].ValueInt);
                reader.AddParameter("Keywords", DBNull.Value);
                reader.AddParameter("Researcher", InputContext.ViewingUser.UserID);
                reader.AddParameter("SiteID", InputContext.CurrentSite.SiteID);
                reader.AddParameter("Submittable", _template.UIFields["Submittable"].ValueInt);
                reader.AddParameter("PreProcessed", 0);
                reader.AddParameter("CanRead", defaultCanRead ? 1 : 0);
                reader.AddParameter("CanWrite", defaultCanWrite ? 1 : 0);
                reader.AddParameter("CanChangePermissions", defaultCanChangePermissions ? 1 : 0);
                reader.AddParameter("ForumStyle", _template.UIFields["ArticleForumStyle"].ValueInt);
                reader.AddParameter("GroupNumber", DBNull.Value); // <-- This is the Club ID!!!

                // Create the hash for checking for duplicates
                StringBuilder source = new StringBuilder(_template.UIFields["Title"].ValueString + "<:>");
                source.Append(bodyText + "<:>");
                source.Append(InputContext.ViewingUser.UserID.ToString() + "<:>");
                source.Append(InputContext.CurrentSite.SiteID.ToString() + "<:>");
                source.Append(style.ToString() + "<:>");
                source.Append(_template.UIFields["Submittable"].ValueString + "<:>");
                source.Append(_template.UIFields["Type"].ValueString);
                reader.AddParameter("Hash", DnaHasher.GenerateHash(source.ToString()));

                // Execute and get the new id of the guide entry
                reader.Execute();
                if (reader.Read() || reader.HasRows)
                {
                    h2g2ID = reader.GetInt32("h2g2id");
                }
            }

            // Check to make sure we created the article correctly
            if (h2g2ID == 0)
            {
                // We've had a problem
                AddErrorXml("Create", "Failed to create the new article", _typedArticleNode);
                return;
            }

            // Check to see if the user has anyone subscribed to them.
            UpdateUserSubscriptions(h2g2ID);

            // Check to see if we're hidding the
            if (InputContext.ViewingUser.IsEditor)
            {
                // Check to see if we're trying to hide or unhide the article
                int hideArticle = _template.UIFields["HideArticle"].ValueInt;
                HideUnHideArticle(h2g2ID, hideArticle);
            }

            // Check to see if we need to set the archive flag
            int archive = _template.UIFields["Archive"].ValueInt;
            if (InputContext.ViewingUser.IsEditor && archive > 0)
            {
                // Archive the article
                SetArticleForumArchiveStatus(h2g2ID, true);
            }

            // Moderate the new article
            ArticleModeration moderation = new ArticleModeration(InputContext);
            moderation.ModerateArticle(InputContext.ViewingUser, InputContext.CurrentSite, h2g2ID, _template.ProfanityFilterState != ProfanityFilter.FilterState.Pass);

            // Add the redirect to the page
            AddRedirectForArticle(h2g2ID);

            // Add the keyphrases to the article if it has any
            AddKeyPhrasesToArticle(h2g2ID);

            AddIntElement(_typedArticleNode, "H2G2ID", h2g2ID);
        }

        /// <summary>
        /// Adds key phrases to the article from the users input
        /// </summary>
        /// <param name="h2g2ID">The h2g2 id of the article you want to add the key phrases to</param>
        private void AddKeyPhrasesToArticle(int h2g2ID)
        {
            // Now go through the fields getting all the ones marked as keyphrases
            string delimiter = NamespacePhrases.GetSiteDelimiterToken(InputContext);
            Dictionary<string, UIField>.Enumerator fields = _template.UIFields.GetEnumerator();
            List<TokenizedNamespacedPhrases> phrasesToParse = new List<TokenizedNamespacedPhrases>();
            while (fields.MoveNext())
            {
                UIField field = fields.Current.Value;
                if (field.IsKeyPhrase)
                {
                    // Add the phrase to the list
                    phrasesToParse.Add(new TokenizedNamespacedPhrases(field.KeyPhraseNamespace, field.RawValue, delimiter));
                }
            }

            // Did we have anything?
            if (phrasesToParse.Count > 0)
            {
                // Try to parse the string to get a list of phrases
                NamespacePhrases nsPhrases = new NamespacePhrases(InputContext);
                nsPhrases.AddNameSpacePhrasesToArticle(phrasesToParse, h2g2ID);
            }
        }

        /// <summary>
        /// Adds the redirect for the successful create/update
        /// </summary>
        private void AddRedirectForArticle(int h2g2ID)
        {
            // Check to see if we've been given a redirect
            string redirect;
            if (InputContext.DoesParamExist("Redirect","Have we been given a redirect?"))
            {
                redirect = InputContext.GetParamStringOrEmpty("Redirect", "Get the redirect for the page");
            }
            else
            {
                // No, Just redirect to the article page
                redirect = "A" + h2g2ID.ToString() + "?s_fromedit";
            }

            // Add the redirect to the page if we' get one
            if (redirect.Length > 0)
            {
                AddDnaRedirect(redirect);
            }
        }

        /// <summary>
        /// Sets the archive status for the article's forum
        /// </summary>
        /// <param name="h2g2ID">The h2g2id of the article you want to update</param>
        /// <param name="archive">A flag to state whether or not to archive</param>
        private void SetArticleForumArchiveStatus(int h2g2ID, bool archive)
        {
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("setarticleforumarchivestatus"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.AddParameter("ArchiveStatus", archive ? 1 : 0);
                reader.Execute();
            }
        }

        /// <summary>
        /// Sets the hidden status for the article
        /// </summary>
        /// <param name="h2g2ID">The h2g2ID of the article you want to update</param>
        /// <param name="hiddenStatus">The new hidden status of the article</param>
        private void HideUnHideArticle(int h2g2ID, int hiddenStatus)
        {
            // Check to see if we're hidding the article
            if (hiddenStatus > 0)
            {
                // Hide the article
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("HideArticle"))
                {
                    reader.AddParameter("EntryID", h2g2ID / 10);
                    reader.AddParameter("HiddenStatus", hiddenStatus);
                    reader.AddParameter("ModID", 0);
                    reader.AddParameter("TriggerID", 0);
                    reader.AddParameter("CalledBy", InputContext.ViewingUser.UserID);
                    reader.Execute();
                }
            }
            else
            {
                // Make sure the article is unhidden
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("UnHideArticle"))
                {
                    reader.AddParameter("EntryID", h2g2ID / 10);
                    reader.AddParameter("ModID", 0);
                    reader.AddParameter("TriggerID", 0);
                    reader.AddParameter("CalledBy", InputContext.ViewingUser.UserID);
                    reader.Execute();
                }
            }
        }

        /// <summary>
        /// Updates all users who are subscribed to the current user
        /// </summary>
        /// <param name="h2g2ID">The h2g2ID of the article you want to check against</param>
        private void UpdateUserSubscriptions(int h2g2ID)
        {
            // Check to see if the current user accepts subscriptions
            if (InputContext.ViewingUser.UserLoggedIn && InputContext.ViewingUser.AcceptSubscriptions)
            {
                // Update users subscriptions witht his new article
                using (IDnaDataReader reader = InputContext.CreateDnaDataReader("addarticlesubscription"))
                {
                    reader.AddParameter("h2g2id", h2g2ID);
                    reader.Execute();
                }
            }
        }

        /// <summary>
        /// Used to make sure that the input for the guide body parses correctly as valid XML
        /// </summary>
        /// <returns>A string that represents the XML for the guide body</returns>
        private string TryParseGuideBody()
        {
            XmlDocument bodyDoc = new XmlDocument();
            XmlNode guideBody = null;
            try
            {
                // Load the body text into an XmlDoc to parse
                bodyDoc.LoadXml(Entities.GetEntities() + "<GUIDE><BODY>" + _template.UIFields["Body"].RawValue + "</BODY></GUIDE>");
                guideBody = bodyDoc.SelectSingleNode("//GUIDE");
            }
            catch (XmlException ex)
            {
                AddErrorXml("GuideXML", "The body text contains invalid XML - " + ex.Message, _typedArticleNode);
                return "";
            }

            // Create the extra info block
            int type = _template.UIFields["Type"].ValueInt;
            ExtraInfo extraInfo = new ExtraInfo();
            extraInfo.TryCreate(type, "");

            // Now add all the non required fields to the Guide
            Dictionary<string, UIField>.Enumerator validFields = _template.UIFields.GetEnumerator();
            while (validFields.MoveNext())
            {
                // Check to see if we've got a non require field
                UIField currentField = validFields.Current.Value;
                if (!currentField.Required)
                {
                    // Add the field to the extra info
                    extraInfo.AddExtraInfoTagValue(currentField.Name, currentField.ValueString);

                    // Add the element to the 
                    XmlDocument fieldDoc = new XmlDocument();
                    try
                    {
                        // Load the text into an XmlDoc to parse
                        fieldDoc.LoadXml("<" + currentField.Name.ToUpper() + ">" + currentField.RawValue + "</" + currentField.Name.ToUpper() + ">");
                        XmlNode bodyNode = bodyDoc.SelectSingleNode("//BODY");
                        XmlNode importNode = bodyDoc.ImportNode(fieldDoc.FirstChild,true);
                        bodyDoc.DocumentElement.InsertAfter(importNode, bodyNode);
                    }
                    catch (XmlException ex)
                    {
                        AddErrorXml("GuideXML", "The " + currentField.Name + " contains invalid XML - " + ex.Message, _typedArticleNode);
                        return "";
                    }
                }
            }

            // Add the guidebody to the page
            _typedArticleNode.AppendChild(_typedArticleNode.OwnerDocument.ImportNode(guideBody,true));
            AddInside(_typedArticleNode, extraInfo);

            // Get the text to insert into the database
            return guideBody.OuterXml.ToString();
        }

        /// <summary>
        /// Gets the status from the template input, but also checks to see if the user is able to set the status
        /// to that value. If not the default status is returned, 3
        /// </summary>
        /// <returns>The current status of the article</returns>
        private int GetStatusForArticle()
        {
            // Set the default value
            int articleStatus = 3;

            // Now check to see if the user is allowed to set the value form the input
            if (InputContext.ViewingUser.IsEditor || InputContext.ViewingUser.IsSuperUser)
            {
                articleStatus = _template.UIFields["Status"].ValueInt;
            }

            // Return the result
            return articleStatus;
        }

        /// <summary>
        /// The edit article method. This is responsible for setting the template values with the article
        /// that we want to edit.
        /// </summary>
        private void EditArticle()
        {
            // Check to make sure we're been given an article to edit
            int h2g2ID = InputContext.GetParamIntOrZero("h2g2id", "Get the h2g2 id of the article to edit");
            if (h2g2ID == 0)
            {
                AddErrorXml("TypedArticle", "No article ID given", _typedArticleNode);
                return;
            }

            // TODO - Get the article from the database and populate the uitemplate with the data.
            // Make sure we get the optional values from the extra info block.
        }

        /// <summary>
        /// The update article method. This is responsible for updating the given article with the new values.
        /// </summary>
        private void UpdateArticle()
        {
            // Check to make sure we're been given an article to edit
            int h2g2ID = InputContext.GetParamIntOrZero("h2g2id", "Get the h2g2 id of the article to edit");
            if (h2g2ID == 0)
            {
                AddErrorXml("TypedArticle", "No article ID given", _typedArticleNode);
                return;
            }

            // TODO - Instead of create, update. The code should be very simular.
        }

        /// <summary>
        /// The get property that returns a list of the required form fields for the template builder
        /// </summary>
        public override List<UIField> GetRequiredFormFields
        {
            get
            {
                // Check to see if we've already created the required field list
                if (_requiredFields == null)
                {
                    // Create the list object
                    _requiredFields = new List<UIField>();

                    // Add the body required field
                    UIField bodyField = new UIField(InputContext);
                    bodyField.Name = "Body";
                    bodyField.Required = true;
                    bodyField.ValidateEmpty = true;
                    bodyField.Type = UIField.UIFieldType.String;
                    _requiredFields.Add(bodyField);

                    // Add the title required field
                    UIField titleField = new UIField(InputContext);
                    titleField.Name = "Title";
                    titleField.Escape = true;
                    titleField.Required = true;
                    titleField.ValidateEmpty = true;
                    titleField.Type = UIField.UIFieldType.String;
                    _requiredFields.Add(titleField);

                    // Add the body required field
                    UIField statusField = new UIField(InputContext);
                    statusField.Name = "Status";
                    statusField.DefaultValue = "3";
                    statusField.Required = true;
                    statusField.ValidateEmpty = true;
                    statusField.Type = UIField.UIFieldType.Number;
                    _requiredFields.Add(statusField);

                    // Add the submittable field
                    UIField submittableField = new UIField(InputContext);
                    submittableField.Name = "Submittable";
                    submittableField.DefaultValue = "0";
                    submittableField.Required = true;
                    submittableField.ValidateEmpty = true;
                    submittableField.Type = UIField.UIFieldType.Number;
                    _requiredFields.Add(submittableField);

                    // Add the Type field
                    UIField typeField = new UIField(InputContext);
                    typeField.Name = "Type";
                    typeField.DefaultValue = "1";
                    typeField.Required = true;
                    typeField.ValidateEmpty = true;
                    typeField.Type = UIField.UIFieldType.Number;
                    _requiredFields.Add(typeField);

                    // Add the Hide Article field
                    UIField hideArticleField = new UIField(InputContext);
                    hideArticleField.Name = "HideArticle";
                    hideArticleField.DefaultValue = "0";
                    hideArticleField.Required = true;
                    hideArticleField.ValidateEmpty = true;
                    hideArticleField.Type = UIField.UIFieldType.Number;
                    _requiredFields.Add(hideArticleField);

                    // Add the Archive Article field
                    UIField archiveArticleField = new UIField(InputContext);
                    archiveArticleField.Name = "Archive";
                    archiveArticleField.DefaultValue = "0";
                    archiveArticleField.Required = true;
                    archiveArticleField.ValidateEmpty = true;
                    archiveArticleField.Type = UIField.UIFieldType.Number;
                    _requiredFields.Add(archiveArticleField);

                    // Add the Who Can Edit field
                    UIField whoCanEditField = new UIField(InputContext);
                    whoCanEditField.Name = "WhoCanEdit";
                    whoCanEditField.DefaultValue = "Me";
                    whoCanEditField.Required = true;
                    whoCanEditField.ValidateEmpty = true;
                    whoCanEditField.Type = UIField.UIFieldType.String;
                    _requiredFields.Add(whoCanEditField);

                    // Add the ForumStyle field
                    UIField articleForumSytleField = new UIField(InputContext);
                    articleForumSytleField.Name = "ArticleForumStyle";
                    articleForumSytleField.DefaultValue = "1"; // <- We need to check the sites guestbook style here!
                    articleForumSytleField.Required = true;
                    articleForumSytleField.ValidateEmpty = true;
                    articleForumSytleField.Type = UIField.UIFieldType.Number;
                    _requiredFields.Add(articleForumSytleField);
                }
                return _requiredFields;
            }
        }

        List<UIField> _requiredFields = null;
    }
}
