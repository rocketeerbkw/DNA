using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Moderation;
using System.Xml;
using BBC.Dna.Sites;
using BBC.Dna.Utils;

namespace BBC.Dna.Component
{
    /// <summary>
    /// The Moderation Email Management Component
    /// </summary>
    public class ModerationEmailManagementBuilder : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The context in which the component is being used</param>
        public ModerationEmailManagementBuilder(IInputContext context)
            : base(context)
        {
        }

        private string _pageStatus = "";
        private bool _actionProcessed = false;

        /// <summary>
        /// Process Request Override
        /// </summary>
        public override void ProcessRequest()
        {
            // Add the standard PageUI
            PageUI pageUI = new PageUI(InputContext.ViewingUser.UserID);
            AddInside(pageUI);

            // Get the current request params
            string nextAction = "default";
            _actionProcessed = false;
            string selectedTemplateType = "";
            string selectedInsert = "";

            string viewModeObject = InputContext.GetParamStringOrEmpty("view", "Get the current view object type");
            int viewModeObjectID = InputContext.GetParamIntOrZero("viewid", "Get the current view object id");
            string actionObjectName = InputContext.GetParamStringOrEmpty("emailtemplatename", "Get the email template name");
            int actionObjectTypeID = InputContext.GetParamIntOrZero("emailtemplateid", "Get the email template id");
            selectedTemplateType = actionObjectName;
            if (actionObjectName.Length == 0)
            {
                actionObjectName = InputContext.GetParamStringOrEmpty("insertname", "Get the insert name");
                actionObjectTypeID = InputContext.GetParamIntOrZero("insertid", "Get the insert id");
                selectedInsert = actionObjectName;
            }

            int siteID = InputContext.GetParamIntOrZero("siteid", "Get the requested siteid");
            int modClassID = InputContext.GetParamIntOrZero("modclassid", "Get the mod class id");

            EmailTemplateTypes eTemplateType = (viewModeObject == "site" || siteID > 0) ? EmailTemplateTypes.SiteTemplates : EmailTemplateTypes.ClassTemplates;

            // Process the action if given
            string action = "";
            if (InputContext.DoesParamExist("action", "Get the request action"))
            {
                action = ProcessAction(out nextAction, actionObjectName, modClassID, viewModeObjectID);
            }
            else if (InputContext.DoesParamExist("insertsaveandreturnhome", "save insert template and finish") || InputContext.DoesParamExist("insertsaveandcreatenew", "save insert template and create a new one"))
	        {
                CreateUpdateEmailInsert(ref actionObjectName, siteID, modClassID, ref eTemplateType, ref action);
            }
            else if (InputContext.DoesParamExist("insertcreate", "create a new insert"))
            {
                action = "createinsert";
                nextAction = "createinsert";
                _pageStatus = "Creating new insert";
                if (eTemplateType == EmailTemplateTypes.ClassTemplates)
                {
                    modClassID = viewModeObjectID;
                }
                else
                {
                    siteID = viewModeObjectID;
                }
            }
            
            if (InputContext.DoesParamExist("saveandcreatenew", "Save email template and create a new one") || InputContext.DoesParamExist("saveandreturnhome", "Save the email tmeplate and return to the home page"))
            {
                CreateUpdateEmailTemplate(modClassID, action);
            }
            else if (InputContext.DoesParamExist("createnewemail", "Setup for creating a new template"))
            {
                action = "createnewemail";
                nextAction = "createnewemail";
                _pageStatus = "Creating new template";
                if (eTemplateType == EmailTemplateTypes.ClassTemplates)
                {
                    modClassID = viewModeObjectID;
                }
                else
                {
                    siteID = viewModeObjectID;
                }
            }

            if (_actionProcessed)
            {
                UpdatePageViewForProcessedAction(ref nextAction, ref selectedTemplateType, ref selectedInsert, ref viewModeObject, ref viewModeObjectID, ref actionObjectName, ref actionObjectTypeID, siteID, modClassID, ref eTemplateType, ref action);
            }

            // Add the moderation page XML
            AddModerationPageXML(nextAction, selectedTemplateType, selectedInsert, modClassID, siteID);

            // Add the current view options to the page
            string displayMode = viewModeObject;
            if (action.Length > 0)
            {
                displayMode = action;
            }

            int currentEditObjectID = viewModeObjectID;
            if (actionObjectTypeID > 0)
            {
                currentEditObjectID = actionObjectTypeID;
            }

            if (viewModeObject == "site")
            {
                siteID = viewModeObjectID;
            }
            else
            {
                modClassID = viewModeObjectID;
            }

            AddModerationViewXML(modClassID, siteID, displayMode, currentEditObjectID);

            // Get all the email templates for the current requested object
            EmailTemplates emailTemplates = EmailTemplates.GetEmailTemplates(AppContext.ReaderCreator, eTemplateType, viewModeObjectID);
            SerialiseAndAppend(emailTemplates, "");

            // Get all the email inserts for the requested object
            EmailInserts emailInserts = EmailInserts.GetEmailInserts(AppContext.ReaderCreator, eTemplateType, viewModeObjectID);
            SerialiseAndAppend(emailInserts, "");

            // Add the current site list
            AddSiteListXML();

            // Add all the other default page XML objects
            AddDefaultEmailModerationDetailsXML();
        }

        /// <summary>
        /// Updates the page view params after an action has been processed
        /// </summary>
        /// <param name="nextAction">The next action to be preformed</param>
        /// <param name="selectedTemplateType">The current selected template</param>
        /// <param name="selectedInsert">The current select insert</param>
        /// <param name="viewModeObject">The view mode object</param>
        /// <param name="viewModeObjectID">The view mode object ID</param>
        /// <param name="actionObjectName">The object name the action was performed on</param>
        /// <param name="actionObjectTypeID">The id of the object that the action was performed</param>
        /// <param name="siteID">The site id used</param>
        /// <param name="modClassID">The mod class id used</param>
        /// <param name="eTemplateType">The current type of template being viewed</param>
        /// <param name="action">The new action</param>
        private void UpdatePageViewForProcessedAction(ref string nextAction, ref string selectedTemplateType, ref string selectedInsert, ref string viewModeObject, ref int viewModeObjectID, ref string actionObjectName, ref int actionObjectTypeID, int siteID, int modClassID, ref EmailTemplateTypes eTemplateType, ref string action)
        {
            if (siteID > 0)
            {
                viewModeObject = "site";
                viewModeObjectID = siteID;
                eTemplateType = EmailTemplateTypes.SiteTemplates;
            }
            else
            {
                viewModeObject = "class";
                viewModeObjectID = modClassID;
                eTemplateType = EmailTemplateTypes.ClassTemplates;
            }

            if (InputContext.DoesParamExist("insertsaveandcreatenew", "save insert template and create a new one"))
            {
                action = "createinsert";
                nextAction = "createinsert";
            }
            else if (InputContext.DoesParamExist("saveandcreatenew", "Save the email tmeplate and return to the home page"))
            {
                action = "createnewemail";
                nextAction = "createnewemail";
            }
            else
            {
                action = "";
                nextAction = "default";
            }

            actionObjectName = "";
            actionObjectTypeID = 0;
            selectedInsert = "";
            selectedTemplateType = "";
        }

        /// <summary>
        /// This method creates or updates email inserts
        /// </summary>
        /// <param name="actionObjectName">The name of the email insert to create/update</param>
        /// <param name="siteID">The siteid the insert belongs to</param>
        /// <param name="modClassID">The modclass the insert belongs to</param>
        /// <param name="eTemplateType">The type of view to add the insert to</param>
        /// <param name="action">The current action</param>
        private void CreateUpdateEmailInsert(ref string actionObjectName, int siteID, int modClassID, ref EmailTemplateTypes eTemplateType, ref string action)
        {
            string insertGroup = InputContext.GetParamStringOrEmpty("InsertGroup", "Get the group for the insert");
            string newInsertGroup = InputContext.GetParamStringOrEmpty("NewInsertGroup", "Get the name of the new insert group");
            string classInsertText = InputContext.GetParamStringOrEmpty("ClassInsertText", "The class insert text");
            string siteInsertText = InputContext.GetParamStringOrEmpty("SiteINsertText", "The site insert text");
            string duplicateIntoClass = InputContext.GetParamStringOrEmpty("DuplicateToClass", "Duplicate insert to modclass");
            string insertDescription = InputContext.GetParamStringOrEmpty("reasonDescription", "The insert description");
            string state = InputContext.GetParamStringOrEmpty("state", "The current state");

            actionObjectName = StringUtils.EscapeAllXml(actionObjectName);
            insertGroup = StringUtils.EscapeAllXml(insertGroup);
            newInsertGroup = StringUtils.EscapeAllXml(newInsertGroup);
            classInsertText = StringUtils.EscapeAllXml(classInsertText);
            siteInsertText = StringUtils.EscapeAllXml(siteInsertText);

            if (insertDescription.Length == 0)
            {
                throw new Exception("No description given for insert!");
            }

            string group = insertGroup;
            if (insertGroup.Length == 0)
            {
                group = newInsertGroup;
            }

            if (group.Length > 0)
            {
                if (duplicateIntoClass == "on")
                {
                    if (modClassID == 0)
                    {
                        throw new Exception("No mod class ID given to update!");
                    }

                    if (classInsertText.Length > 0)
                    {
                        if (state == "create")
                        {
                            EmailInserts.CreateModClassEmailInsert(AppContext.ReaderCreator, modClassID, actionObjectName, group, classInsertText, insertDescription);
                        }
                        else
                        {
                            EmailInserts.UpdateModClassEmailInsert(AppContext.ReaderCreator, modClassID, actionObjectName, group, classInsertText, insertDescription);
                        }
                    }
                    else
                    {
                        throw new Exception("No mod class specific insert provided");
                    }
                    action = "default";
                    eTemplateType = EmailTemplateTypes.ClassTemplates;
                }
                else
                {
                    if (siteID == 0)
                    {
                        throw new Exception("No site ID given to update!");
                    }

                    if (siteInsertText.Length > 0)
                    {
                        if (state == "create")
                        {
                            EmailInserts.CreateSiteEmailInsert(AppContext.ReaderCreator, siteID, actionObjectName, group, siteInsertText, insertDescription);
                        }
                        else
                        {
                            EmailInserts.UpdateSiteEmailInsert(AppContext.ReaderCreator, siteID, actionObjectName, group, siteInsertText, insertDescription);
                        }
                    }
                    else
                    {
                        throw new Exception("No site specific insert provided");
                    }
                }
            }
            else
            {
                throw new Exception("No insert groupname provided");
            }

            _actionProcessed = true;
        }

        /// <summary>
        /// Creates/Updates email templates
        /// </summary>
        /// <param name="modClassID">The modid for the template</param>
        /// <param name="action">The action being performed</param>
        private void CreateUpdateEmailTemplate(int modClassID, string action)
        {
            string name = InputContext.GetParamStringOrEmpty("Name", "The name of the templates");
            string body = InputContext.GetParamStringOrEmpty("body", "The body of the template");
            string subject = InputContext.GetParamStringOrEmpty("subject", "The subject of the template");

            name = StringUtils.EscapeAllXml(name);
            body = StringUtils.EscapeAllXml(body);
            subject = StringUtils.EscapeAllXml(subject);

            if (action == "save")
            {
                EmailTemplates.AddNewTemplate(AppContext.ReaderCreator, modClassID, name, subject, body);
            }
            else
            {
                EmailTemplates.UpdateTemplate(AppContext.ReaderCreator, modClassID, name, subject, body);
            }

            _actionProcessed = true;
        }

        /// <summary>
        /// Processes the action required on a template or insert
        /// </summary>
        /// <param name="nextAction">Out param of the next action to take</param>
        /// <param name="editItemName">THe name of the item being edited</param>
        /// <param name="modClassID">The current mod class the item lives in</param>
        /// <param name="viewModeObjectID">The current view mode object id</param>
        private string ProcessAction(out string nextAction, string editItemName, int modClassID, int viewModeObjectID)
        {
            string action = InputContext.GetParamStringOrEmpty("action", "get the requested action").ToLower();
            nextAction = action;
            
            // Now perform the action
            if (action == "removeemail")
            {
                nextAction = "default";
                if (modClassID == 0 || editItemName.Length == 0)
                {
                    _pageStatus = "Failed to remove email template";
                }
                else
                {
                    EmailTemplates.RemoveTemplate(AppContext.ReaderCreator, modClassID, editItemName);
                    _pageStatus = editItemName + " has been removed";
                }
                _actionProcessed = true;
            }
            else if (action == "editemail")
            {
                _pageStatus = editItemName + " being edited";
            }
            else if (action == "editinsert")
            {
                _pageStatus = editItemName + " being edited";
            }
            else if (action == "removeinsert")
            {
                _pageStatus = editItemName + " removed";
                if (modClassID > 0)
                {
                    EmailInserts.RemoveModClassEmailInsert(AppContext.ReaderCreator, viewModeObjectID, editItemName);
                }
                else
                {
                    EmailInserts.RemoveSiteEmailInsert(AppContext.ReaderCreator, viewModeObjectID, editItemName);
                }
                _actionProcessed = true;
            }
            else
            {
                InputContext.Diagnostics.WriteWarningToLog("MODERATION", "Unknow action requested to the email moderation system");
                _pageStatus = "Don't know what to do with action '" + action + "'!";
                nextAction = "default";
            }

            return action;
        }

        /// <summary>
        /// Creates and adds the basic site list information to the page
        /// </summary>
        private void AddSiteListXML()
        {
            XmlElement siteListXML = AddElementTag(RootElement, "SITE-LIST");
            AddAttribute(siteListXML, "TYPE", "ALLSITES");
            ISiteList siteList = InputContext.TheSiteList;
            foreach (var id in siteList.Ids.Keys)
            {
                ISite site = siteList.Ids[id];
                XmlElement siteXML = AddElementTag(siteListXML, "SITE");
                AddAttribute(siteXML, "ID", site.SiteID);
                AddIntElement(siteXML, "ID", site.SiteID);
                AddTextElement(siteXML, "NAME", site.ShortName);
                AddTextElement(siteXML, "SHORTNAME", site.ShortName);
                AddTextElement(siteXML, "URLNAME", site.SiteName);
                AddTextElement(siteXML, "DESCRIPTION", site.Description);
                AddIntElement(siteXML, "CLASSID", site.ModClassID);
            }
            RootElement.AppendChild(siteListXML);
        }

        /// <summary>
        /// Adds the current moderation view details to the page
        /// </summary>
        /// <param name="selectedModClass">The current mod class that's being requested</param>
        /// <param name="selectedSite">The current site that being requested</param>
        /// <param name="viewType">The type of view we're asking for</param>
        /// <param name="viewTypeID">The ID of the object we're trying to view</param>
        private void AddModerationViewXML(int selectedModClass, int selectedSite, string viewType, int viewTypeID)
        {
            XmlElement modViewXML = AddElementTag(RootElement, "MODERATOR-VIEW");
            AddAttribute(modViewXML, "VIEWTYPE", viewType);
            AddAttribute(modViewXML, "VIEWID", viewTypeID);
            AddAttribute(modViewXML, "SITEID", selectedSite);
            AddAttribute(modViewXML, "CLASSID", selectedModClass);
            RootElement.AppendChild(modViewXML);
        }

        /// <summary>
        /// Sets up the page details
        /// </summary>
        /// <param name="nextAction">The next action we need to make</param>
        /// <param name="selectedTemplateType">The selected template type</param>
        /// <param name="selectedInsert">The selected insert item</param>
        /// <param name="selectedModClass">The mod class being selected</param>
        /// <param name="selectedSite">The site id being used</param>
        private void AddModerationPageXML(string nextAction, string selectedTemplateType, string selectedInsert, int selectedModClass, int selectedSite)
        {
            XmlElement moderationPageXML = AddElementTag(RootElement, "MOD-EMAIL-PAGE");
            AddAttribute(moderationPageXML, "PAGE", nextAction);
            AddTextElement(moderationPageXML, "SELECTED-TEMPLATE", selectedTemplateType);
            AddTextElement(moderationPageXML, "SELECTED-INSERT", selectedInsert);
            AddTextElement(moderationPageXML, "PAGE-STATUS", _pageStatus);
            AddIntElement(moderationPageXML, "SELECTED-MOD-CLASS", selectedModClass);
            AddIntElement(moderationPageXML, "SELECTED-SITE", selectedSite);
        }

        /// <summary>
        /// Adds the default page XML Objects to the page
        /// </summary>
        private void AddDefaultEmailModerationDetailsXML()
        {
            // Get all the moderation classes
            ModerationClassList classList = ModerationClassList.GetAllModerationClasses(AppContext.ReaderCreator, AppContext.DnaCacheManager, true);
            SerialiseAndAppend(classList, "");

            // Get the email group inserts
            EmailInsertGroups emailGroups = EmailInsertGroups.GetEmailInsertGroups(AppContext.ReaderCreator);
            SerialiseAndAppend(emailGroups, "");

            // Get the current insert types
            InsertTypes types = InsertTypes.GetInsertTypes();
            SerialiseAndAppend(types, "");
        }
    }
}
