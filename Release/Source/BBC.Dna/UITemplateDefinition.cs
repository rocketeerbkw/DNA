using System;
using System.Net;
using System.Globalization;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Web;
using System.Web.Configuration;
using System.Reflection;

namespace BBC.Dna.Component
{
    /// <summary>
    /// UITemplateDefinition - A derived DnaComponent object
    /// </summary>
    public class UITemplateDefinition : DnaInputComponent
    {
        private const string _docDnaAction = @"Action to perform with the template get, create or update.";

        private const string _docDnaUITemplateID = @"ID of this template, 0 if it is new";
        private const string _docDnaUITemplateName = @"Name of this template";
        private const string _docDnaBuilderGUID = @"Guid of the Builder associated with this template.";

        private const string _docDnaUIFieldID = @"UIFieldID of the field in question, 0 if it is new.";
        private const string _docDnaName = @"Name of the field in question.";
        private const string _docDnaLabel = @"Label of the field in question.";
        private const string _docDnaType = @"Type of the field in question.";
        private const string _docDnaDescription = @"Description of the field in question.";
        private const string _docDnaIsKeyPhrase = @"Whether the field in question is a KeyPhrase.";
        private const string _docDnaKeyPhraseNamespace = @"Namespace of the field in question.";
        private const string _docDnaRequired = @"Whether the field in question is a required field.";
        private const string _docDnaDefaultValue = @"Default Value of the field in question.";
        private const string _docDnaEscape = @"Whether the field in question needs to be escaped.";
        private const string _docDnaRawInput = @"Whether the field in question needs to be left alone.";
        private const string _docDnaIncludeInGuideEntry = @"Whether the field in question needs to be included in the Guide Entry.";
        private const string _docDnaValidateEmpty = @"Whether the field in question is validated as not being empty.";
        private const string _docDnaValidateParsesOK = @"Whether the field in question is validated as parsing ok.";
        private const string _docDnaValidateNotEqualTo = @"Whether the field in question is validated as not being equal to a value.";
        private const string _docDnaNotEqualToValue = @"The value that the field in question is validated as not being.";

        private const string _docDnaValidateCustom = @"Whether the field in question is validated in a custom way.";
        private const string _docDnaStep = @"The entry Step number the field is in.";
        private const string _docDnaPermissions = @"The level of permissions the user has in order to access this field.";

        private const string _docDnaSelectedBuilderName = @"The name of the selected supported builder name chosen to return the required fields.";

        private XmlElement _templateDefinition;

        string _action = String.Empty;
        string _selectedBuilderName = String.Empty;

        /// <summary>
        /// Default constructor for the UITemplateDefinition component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public UITemplateDefinition(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Used to process the current request.
        /// </summary>
        public override void ProcessRequest()
        {
            //Clean any existing XML.
            RootElement.RemoveAll();
            TryGetPageParams();
        }

        /// <summary>
        /// Gets the params for the page
        /// </summary>
        private void TryGetPageParams()
        {
            _action = InputContext.GetParamStringOrEmpty("action", _docDnaAction);
            _selectedBuilderName = InputContext.GetParamStringOrEmpty("selectedbuildername", _docDnaSelectedBuilderName);

            UITemplate uiTemplate = new UITemplate(InputContext);

            uiTemplate.UITemplateID = InputContext.GetParamIntOrZero("uitemplateid", _docDnaUITemplateID);

            if (_action == "create" || _action == "update")
            {
                uiTemplate.Name = InputContext.GetParamStringOrEmpty("uitemplatename", _docDnaUITemplateName);
                uiTemplate.BuilderGUID = new Guid(InputContext.GetParamStringOrEmpty("builderGUID", _docDnaBuilderGUID));

                int fieldCount = InputContext.GetParamCountOrZero("uifieldid", _docDnaUIFieldID);

                for (int i = 1; i < fieldCount+1; i++)
                {
                    UIField field = new UIField(InputContext);
                    field.UIFieldID = InputContext.GetParamIntOrZero("uifieldid", i, _docDnaUIFieldID);
                    field.Name = InputContext.GetParamStringOrEmpty("Name", _docDnaName);
                    field.Label = InputContext.GetParamStringOrEmpty("Label", _docDnaLabel);
                    try
                    {
                        field.Type = (UIField.UIFieldType)Enum.Parse(typeof(UIField.UIFieldType), InputContext.GetParamStringOrEmpty("Type", _docDnaType));
                    }
                    catch (Exception ex)
                    {
                        AddErrorXml("UIField Type Error", "UIFieldType not known or incorrect." + ex.Message, null);
                        field.Type = UIField.UIFieldType.Unknown;
                        return;
                    }
                    field.Description = InputContext.GetParamStringOrEmpty("Description", _docDnaDescription);
                    field.IsKeyPhrase = InputContext.GetParamBoolOrFalse("IsKeyPhrase", _docDnaIsKeyPhrase);
                    field.KeyPhraseNamespace = InputContext.GetParamStringOrEmpty("KeyPhraseNamespace", _docDnaKeyPhraseNamespace);
                    field.Required = InputContext.GetParamBoolOrFalse("Required", _docDnaRequired);
                    field.DefaultValue = InputContext.GetParamStringOrEmpty("DefaultValue", _docDnaDefaultValue);
                    field.Escape = InputContext.GetParamBoolOrFalse("Escape", _docDnaEscape);
                    field.RawInput = InputContext.GetParamBoolOrFalse("RawInput", _docDnaRawInput);
                    field.IncludeInGuideEntry = InputContext.GetParamBoolOrFalse("IncludeInGuideEntry", _docDnaIncludeInGuideEntry);
                    field.ValidateEmpty = InputContext.GetParamBoolOrFalse("ValidateEmpty", _docDnaValidateEmpty);
                    field.ValidateNotEqualTo = InputContext.GetParamBoolOrFalse("ValidateNotEqualTo", _docDnaValidateNotEqualTo);
                    field.ValidateParsesOK = InputContext.GetParamBoolOrFalse("ValidateParsesOK", _docDnaValidateParsesOK);
                    field.NotEqualToValue = InputContext.GetParamStringOrEmpty("NotEqualToValue", _docDnaNotEqualToValue);
                    field.ValidateCustom = InputContext.GetParamBoolOrFalse("ValidateCustom", _docDnaValidateCustom);
                    field.Step = InputContext.GetParamIntOrZero("Step", _docDnaStep);

                    try
                    {
                        field.Permissions = (UIField.UIFieldPermissions)Enum.Parse(typeof(UIField.UIFieldPermissions), InputContext.GetParamStringOrEmpty("Permissions", _docDnaPermissions));
                    }
                    catch (Exception ex)
                    {
                        AddErrorXml("UIFieldPermissions Error", "UIFieldPermissions not known or incorrect." + ex.Message, null);
                        field.Permissions = UIField.UIFieldPermissions.Standard;
                        return;
                    }

                    uiTemplate.AddField(field);
                }
            }

            GenerateUITemplatePageXml(uiTemplate);

            //Add the Builder UI TemplateEntry  supported required fields
            GenerateUISupportedTemplatePageXml();
        }

        /// <summary>
        /// Gets the template XML either from the ID for a get action or the returned XML from a create or update action
        /// </summary>
        /// <param name="uiTemplate">Template Data</param>
        private void GenerateUITemplatePageXml(UITemplate uiTemplate)
        {
            _templateDefinition = AddElementTag(RootElement, "UITEMPLATEDEFINITION");
            AddTextElement(_templateDefinition, "ACTION", _action);
            if (_action == "create" || _action == "update")
            {
                uiTemplate.StoreTemplateData();
                AddInside(_templateDefinition, uiTemplate);
            }
            else //if (_action == "view")
            {
                if (uiTemplate.UITemplateID > 0)
                {
                    uiTemplate.LoadTemplate();
                    AddInside(_templateDefinition, uiTemplate);
                }
            }
        }

        /// <summary>
        /// Gets the supported builders template XML with their required fields
        /// </summary>
        private void GenerateUISupportedTemplatePageXml()
        {
            Dictionary<string, List<UIField>> builderList = new Dictionary<string, List<UIField>>();
            Dictionary<string, Guid> builderGuidList = new Dictionary<string, Guid>();

            XmlElement supportedBuilderList;
            supportedBuilderList = AddElementTag(_templateDefinition, "UISUPPORTEDBUILDERS");

            // Find all the components that support the DnaForm system.
            List<Type> dnaFormComponents = new List<Type>();
            try
            {
                Assembly a = Assembly.GetExecutingAssembly();
                foreach (Type t in a.GetTypes())
                {
                    if (t.GetInterface("IDnaFormComponent") != null && !t.IsAbstract)
                    {
                        dnaFormComponents.Add(t);
                    }
                }
            }
            catch
            {
                string f = "failed!";
                f += "!";
            }

            if (dnaFormComponents.Count > 0)
            {
                foreach (Type s in dnaFormComponents)
                {
                    XmlElement builderElement = AddElementTag(supportedBuilderList, "BUILDER");

                    object o = Activator.CreateInstance(s, InputContext);
                    PropertyInfo pi = s.GetProperty("GetRequiredFormFields");
                    List<UIField> fields = (List<UIField>)pi.GetValue(o, null);
                    string builderName = s.Name;
                    
                    AddTextElement(builderElement, "BUILDERNAME", builderName);
                    AddTextElement(builderElement, "BUILDERGUID", s.GUID.ToString());
                    XmlElement fieldsElement = AddElementTag(builderElement, "UIFIELDS");
                    foreach (UIField field in fields)
                    {
                        fieldsElement.AppendChild(ImportNode(field.XML));
                    }

                    builderList.Add(builderName, fields);
                    builderGuidList.Add(builderName, s.GUID);
                }
            }

            if (_selectedBuilderName != String.Empty && builderList.ContainsKey(_selectedBuilderName))
            {
                Guid selectedBuilderGuid;
                builderGuidList.TryGetValue(_selectedBuilderName, out selectedBuilderGuid);

                XmlElement selectedBuilderElement = AddElementTag(supportedBuilderList, "UISELECTEDBUILDER");

                AddTextElement(selectedBuilderElement, "BUILDERNAME", _selectedBuilderName);
                AddTextElement(selectedBuilderElement, "BUILDERGUID", selectedBuilderGuid.ToString());

                XmlElement selectedBuilderFieldsElement = AddElementTag(selectedBuilderElement, "UIFIELDS");
                List<UIField> selectedBuilderFields;
                builderList.TryGetValue(_selectedBuilderName, out selectedBuilderFields);

                foreach (UIField selectedBuilderField in selectedBuilderFields)
                {
                    selectedBuilderFieldsElement.AppendChild(ImportNode(selectedBuilderField.XML));
                }
            }
        }
    }
}