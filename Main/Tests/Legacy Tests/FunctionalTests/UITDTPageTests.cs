using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// Test utility class UITDTPageTests.cs
    /// </summary>
    [TestClass]
    public class UITDTPageTests
    {
        private bool _setupRun = false;

        private DnaTestURLRequest _request = new DnaTestURLRequest("h2g2");
        private const string _schemaUri = "H2G2UITDTFlat.xsd";

        private string _uiTemplateID = "0";

        /// <summary>
        /// Set up function
        /// </summary>
        [TestInitialize]
        public void StartUp()
        {
            Console.WriteLine("StartUp()");
            if (!_setupRun)
            {
                Console.WriteLine("Setting up");
                _request.UseEditorAuthentication = true;
                _request.SetCurrentUserEditor();
                _setupRun = true;
            }
            Console.WriteLine("Finished Setup()");
        }

        /// <summary>
        /// Create Test01GetSupportedBuilders.
        /// </summary>
        [TestMethod]
        public void Test01GetSupportedBuilders()
        {
            Console.WriteLine("Test01GetSupportedBuilders");
            _request.RequestPage("UITDT?skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION") != null, "The UITemplateDefintion page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS") != null, "The UITemplateDefintion page has not been generated correctly - UISUPPORTEDBUILDERS!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/BUILDER") != null, "The UITemplateDefintion page has not been generated correctly - UISUPPORTEDBUILDERS/BUILDER!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/BUILDER[BUILDERNAME='TypedArticle']") != null, "The UITemplateDefintion page has not been generated correctly - BUILDERNAME='TypedArticle'!!!");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test01GetSupportedBuilders");

        }
        /// <summary>
        /// Create Test02GetSupportedBuildersWithSelectedBuilder.
        /// </summary>
        [TestMethod]
        public void Test02GetSupportedBuildersWithSelectedBuilder()
        {
            Console.WriteLine("Test02GetSupportedBuildersWithSelectedBuilder");
            _request.RequestPage("UITDT?selectedbuildername=TypedArticle&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION") != null, "The UITemplateDefintion page has not been generated!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS") != null, "The UITemplateDefintion page has not been generated correctly - UISUPPORTEDBUILDERS!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/BUILDER") != null, "The UITemplateDefintion page has not been generated correctly - UISUPPORTEDBUILDERS/BUILDER!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/BUILDER[BUILDERNAME='TypedArticle']") != null, "The UITemplateDefintion page has not been generated correctly - BUILDERNAME='TypedArticle'!!!");

            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/UISELECTEDBUILDER") != null, "The UITemplateDefintion page has not been generated correctly - UISUPPORTEDBUILDERS/UISELECTEDBUILDER!!!");
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/UISELECTEDBUILDER[BUILDERNAME='TypedArticle']") != null, "The UITemplateDefintion page has not been generated correctly - UISELECTEDBUILDER/BUILDERNAME='TypedArticle'!!!");
            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test02GetSupportedBuildersWithSelectedBuilder");

        }
        /// <summary>
        /// Create Test03CreateTemplate.
        /// </summary>
        [TestMethod]
        public void Test03CreateTemplate()
        {

            /* Available fields and their parameter inputs
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
            */

            Console.WriteLine("Test03CreateTemplate");
            _request.RequestPage("UITDT?action=create&uitemplateid=0&uitemplatename=Test" + DateTime.Now.ToString() + "&builderguid=" + Guid.NewGuid().ToString() + "&" + 
                "uifieldid=0&name=Subject&label=Subject&type=String&Description=Test&iskeyphrase=true" + 
                "&keyphrasenamespace=test&required=0&step=1&permissions=Standard&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION") != null, "The UITemplateDefintion page has not been generated!!!");

            XmlAttribute uiTemplateIDValue = ((XmlAttribute)xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UITEMPLATE/@UITEMPLATEID"));
            _uiTemplateID = uiTemplateIDValue.Value;


            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test03CreateTemplate");

        }
        /// <summary>
        /// Create TestGetSupportedBuildersWithSelectedBuilder.
        /// </summary>
        [TestMethod]
        public void Test04UpdateTemplate()
        {
            Test03CreateTemplate();
            Console.WriteLine("Test04UpdateTemplate");
            _request.RequestPage("UITDT?action=update&uitemplateid=" + _uiTemplateID + "&uitemplatename=Test" + DateTime.Now.ToString() + "&builderguid=" + Guid.NewGuid().ToString() + "&" +
                "uifieldid=0&name=NewSubject&label=NewSubject&type=String&Description=Test&iskeyphrase=true" +
                "&keyphrasenamespace=test&required=0&step=1&permissions=Standard&skin=purexml");

            XmlDocument xml = _request.GetLastResponseAsXML();
            Assert.IsTrue(xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION") != null, "The UITemplateDefintion page has not been generated!!!");

            XmlAttribute newuiTemplateIDValue = ((XmlAttribute)xml.SelectSingleNode("H2G2/UITEMPLATEDEFINITION/UITEMPLATE/@UITEMPLATEID"));
            string newuiTemplateID = newuiTemplateIDValue.Value;

            Assert.IsTrue(newuiTemplateID == _uiTemplateID, "Updated uiTemplateID id does not match");

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test04UpdateTemplate");

        }
    }
}
