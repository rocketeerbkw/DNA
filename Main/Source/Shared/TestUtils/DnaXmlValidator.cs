using BBC.Dna.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using System.Xml.Schema;

namespace Tests
{
    /// <summary>
    /// Class containing the class to test the Xml Validation
    /// </summary>
    public class DnaXmlValidator
    {
        private XmlSchema _xmlSchema;
        private string _schemaUri;
        private StringReader _xml;
        private String _rawXml;
        private XmlReaderSettings _validationSettings;
        private XmlReader _validator;
        private static Dictionary<string, XmlSchema> _cachedSchemas = new Dictionary<string, XmlSchema>();

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="xml">XML to validate</param>
        /// <param name="schemaUri">Schema Uri</param>
        public DnaXmlValidator(string xml, string schemaUri)
        {
            _schemaUri = schemaUri;
            // set up the schema
            LoadSchema(schemaUri);

            // set up the xml reader
            _rawXml = xml;
            _xml = new StringReader(xml);

            // set up the settings for validating the xml
            _validationSettings = new XmlReaderSettings();
            _validationSettings.Schemas.Add(_xmlSchema);
            _validationSettings.IgnoreWhitespace = true;
            _validationSettings.ValidationFlags |= XmlSchemaValidationFlags.ProcessSchemaLocation;
            _validationSettings.ValidationFlags |= XmlSchemaValidationFlags.ReportValidationWarnings;
            _validationSettings.ValidationFlags |= XmlSchemaValidationFlags.ProcessInlineSchema;
            _validationSettings.ValidationType = ValidationType.Schema;
            try
            {
                _validationSettings.Schemas.Compile();
            }
            catch (XmlSchemaException e)
            {
                string s = e.SourceUri;
            }
            _validationSettings.ValidationEventHandler += new ValidationEventHandler(xmlReaderSettingsValidationEventHandler);
            _validationSettings.DtdProcessing = DtdProcessing.Prohibit;
            // set the the XmlReader for validation
            _validator = XmlReader.Create(_xml, _validationSettings);
        }

        private void LoadSchema(string schemaUri)
        {
            //string fullSchemaURI = @"http://local.bbc.co.uk:8081/schemas/" + schemaUri;
            //string fullSchemaURI = @"http://dnadev.national.core.bbc.co.uk/bbc.dna/schemas/" + schemaUri;


            if (_cachedSchemas.ContainsKey(schemaUri))
            {
                //Retrieve shema from cache.
                _xmlSchema = _cachedSchemas[schemaUri];
            }
            else
            {
                //Get Local Path of schema file.
                // Make sure that you specify the Schema directory name is Case correct.
                String path = IIsInitialise.GetIIsInitialise().GetVDirPath("h2g2UnitTesting", "Schemas");
                path = Path.Combine(path, schemaUri);

                _xmlSchema = new XmlSchema();
                //Uri ourUri = new Uri(fullSchemaURI);
                //WebRequest request = WebRequest.Create(ourUri);
                //request.Proxy = null;
                //WebResponse response = request.GetResponse();

                //Read Schema from local path. This allows relative includes within the schema files to be resolved correctly.
                _xmlSchema = XmlSchema.Read(new XmlTextReader(path), new ValidationEventHandler(xmlReaderSettingsValidationEventHandler));

                //Cache it.
                _cachedSchemas[schemaUri] = _xmlSchema;
            }
        }

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="xml">XML to validate</param>
        /// <param name="schemaUri">Schema URI</param>
        public DnaXmlValidator(XmlElement xml, string schemaUri)
            : this(xml.OuterXml, schemaUri)
        {
        }

        /// <summary>
        /// Handler for XML validation events - just re-throws validation exceptions.
        /// </summary>
        /// <param name="sender">Sender.</param>
        /// <param name="args">Information related to the ValidationEventHandler.</param>
        /// <exception cref="XmlSchemaException"></exception>
        private void xmlReaderSettingsValidationEventHandler(object sender, ValidationEventArgs args)
        {
            throw args.Exception;
        }

        /// <summary>
        /// Validates xml against schema. 
        /// </summary>
        /// <exception cref="XmlSchemaException"></exception>
        public void Validate()
        {
            Console.WriteLine("XmlValidate - Before Validating against " + _schemaUri);
            try
            {
                while (_validator.Read()) { }
            }
            catch (XmlSchemaException e)
            {
                throw new DnaException("Validation failed due to: " + e.Message + ".\nXml was:\n" + _rawXml);
            }
            Console.WriteLine("XmlValidate - After Validating");
        }
    }
}
