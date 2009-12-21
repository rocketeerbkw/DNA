using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;


namespace Tests
{
    /// <summary>
    /// Test class for the banned emails functionality
    /// </summary>
    [TestClass]
    public class UITemplateTests
    {
        int _createdUITemplateID = 0;
        string _uifieldid = "0";
        private const string _schemaUri = "UITemplate.xsd";

        string _testTemplateXML = @"<H2G2>
            <UITEMPLATE UITEMPLATEID='0'>
			    <NAME>My New Template</NAME>
			    <BUILDERGUID>4EE8FFB8-1A0B-40bf-9D22-34DE6915129A</BUILDERGUID>
			    <UIFIELDS>
				    <UIFIELD UIFIELDID='0'
					         ISKEYPHRASE='1'
					         REQUIRED='1'
					         ESCAPE='0'
					         RAWINPUT='0'
					         INCLUDEINGUIDEENTRY='0'
					         VALIDATEEMPTY='1'
					         VALIDATENOTEQUALTO='1'
					         VALIDATEPARSESOK='0'
					         VALIDATECUSTOM='0' 
                             STEP='1'>
					    <NAME>SUBJECT</NAME>
					    <LABEL>Title of the articleXXX</LABEL>
					    <TYPE>String</TYPE>
					    <DESCRIPTION>The title of the article</DESCRIPTION>
					    <KEYPHRASENAMESPACE>TITLE</KEYPHRASENAMESPACE>
					    <DEFAULTVALUE></DEFAULTVALUE>
					    <NOTEQUALTOVALUE></NOTEQUALTOVALUE>
					    <PERMISSIONS>Standard</PERMISSIONS>
				    </UIFIELD>
				    <UIFIELD UIFIELDID='0'
					         ISKEYPHRASE='0'
					         REQUIRED='1'
					         ESCAPE='0'
					         RAWINPUT='0'
					         INCLUDEINGUIDEENTRY='0'
					         VALIDATEEMPTY='1'
					         VALIDATENOTEQUALTO='1'
					         VALIDATEPARSESOK='0'
					         VALIDATECUSTOM='0'
                             STEP='1'>
					    <NAME>Description</NAME>
					    <LABEL>Description of the article2XXX</LABEL>
					    <TYPE>String</TYPE>
					    <DESCRIPTION>The Description of the article</DESCRIPTION>
					    <KEYPHRASENAMESPACE></KEYPHRASENAMESPACE>
					    <DEFAULTVALUE></DEFAULTVALUE>
					    <NOTEQUALTOVALUE></NOTEQUALTOVALUE>
					    <PERMISSIONS>Standard</PERMISSIONS>
				    </UIFIELD>
			    </UIFIELDS>
	        </UITEMPLATE>
        </H2G2>";
        
        
        /// <summary>
        /// Setup method
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
        }

        /// <summary>
        /// Test for creating a template
        /// </summary>
        [TestMethod]
        public void Test01CreateUITemplate()
        {
            Console.WriteLine("Before Test01CreateUITemplate");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("createuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("createuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = 0;
                XmlDocument templateDoc = new XmlDocument();
                templateDoc.LoadXml(_testTemplateXML);

                XmlElement test = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE"));
                test.SetAttribute("UITEMPLATEID", _createdUITemplateID.ToString());

                test = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE/NAME"));
                test.InnerText = test.InnerText + DateTime.Now.ToString();

                testUITemplate.SaveTemplate((XmlElement)templateDoc.FirstChild.FirstChild);
                _createdUITemplateID = testUITemplate.UITemplateID;

                DnaXmlValidator validator = new DnaXmlValidator(testUITemplate.RootElement.InnerXml, _schemaUri);
                validator.Validate();
            }
            Console.WriteLine("After Test01CreateUITemplate");
        }
        /// <summary>
        /// Test for getting a template
        /// </summary>
        [TestMethod]
        public void Test02GetUITemplate()
        {
            Console.WriteLine("Before Test02GetUITemplate");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = _createdUITemplateID;
                testUITemplate.LoadTemplate();

                DnaXmlValidator validator = new DnaXmlValidator(testUITemplate.RootElement.InnerXml, _schemaUri);
                validator.Validate();
            }
            Console.WriteLine("After Test02GetUITemplate");
        }
        /// <summary>
        /// Test for updating a template replacing the existing fields with new ones
        /// </summary>
        [TestMethod]
        public void Test03UpdateUITemplateReplacesFields()
        {
            Console.WriteLine("Before Test03UpdateUITemplateReplacesFields");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("updateuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("updateuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = _createdUITemplateID;
                XmlDocument templateDoc = new XmlDocument();
                templateDoc.LoadXml(_testTemplateXML);

                XmlElement test = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE"));
                test.SetAttribute("UITEMPLATEID", _createdUITemplateID.ToString());

                test = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE/NAME"));
                test.InnerText = test.InnerText + DateTime.Now.ToString();

                testUITemplate.SaveTemplate((XmlElement)templateDoc.FirstChild.FirstChild);
                _createdUITemplateID = testUITemplate.UITemplateID;

                XmlAttribute newfieldvalue = ((XmlAttribute)testUITemplate.RootElement.SelectSingleNode("./UITEMPLATE/UIFIELDS/UIFIELD/@UIFIELDID"));
                _uifieldid = newfieldvalue.Value;

                DnaXmlValidator validator = new DnaXmlValidator(testUITemplate.RootElement.InnerXml, _schemaUri);
                validator.Validate();
            }
            Console.WriteLine("After Test03UpdateUITemplateReplacesFields");
        }
        /// <summary>
        /// Test for updating a template updating the existing fields
        /// </summary>
        [TestMethod]
        public void Test04UpdateUITemplateUpdateFields()
        {
            Console.WriteLine("Before Test04UpdateUITemplateUpdateFields");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("updateuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("updateuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = _createdUITemplateID;
                XmlDocument templateDoc = new XmlDocument();
                templateDoc.LoadXml(_testTemplateXML);

                XmlElement test = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE"));
                test.SetAttribute("UITEMPLATEID", _createdUITemplateID.ToString());

                XmlElement field = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE/UIFIELDS/UIFIELD"));
                field.SetAttribute("UIFIELDID", _uifieldid);

                test = ((XmlElement)templateDoc.SelectSingleNode("H2G2/UITEMPLATE/NAME"));
                test.InnerText = test.InnerText + DateTime.Now.ToString();

                testUITemplate.SaveTemplate((XmlElement)templateDoc.FirstChild.FirstChild);
                _createdUITemplateID = testUITemplate.UITemplateID;

                XmlAttribute newfieldvalue = ((XmlAttribute)testUITemplate.RootElement.SelectSingleNode("./UITEMPLATE/UIFIELDS/UIFIELD/@UIFIELDID"));
                string newfieldid = newfieldvalue.Value;

                Assert.IsTrue(newfieldid == _uifieldid, "Updated uifield id does not match");

                DnaXmlValidator validator = new DnaXmlValidator(testUITemplate.RootElement.InnerXml, _schemaUri);
                validator.Validate();
            }
            Console.WriteLine("After Test04UpdateUITemplateUpdateFields");
        }
        /// <summary>
        /// Test for getting an incorrect template id 0
        /// </summary>
        [TestMethod]
        public void Test05GetUITemplateID0()
        {
            Console.WriteLine("Before Test05GetUITemplateID0");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = 0;
                testUITemplate.LoadTemplate();

                Assert.IsTrue(testUITemplate.HasErrors, "The template should return an error.");
            }
            Console.WriteLine("After Test05GetUITemplateID0");
        }
        /// <summary>
        /// Test for getting an incorrect template 999999999
        /// </summary>
        [TestMethod]
        public void Test06GetIncorrectUITemplate()
        {
            Console.WriteLine("Before Test06GetIncorrectUITemplate");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = mock.NewMock<IInputContext>();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the stored procedure reader for the UITemplate object
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader("getuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = 999999999;
                testUITemplate.LoadTemplate();

                Assert.IsTrue(testUITemplate.HasErrors, "The template should return an error.");
            }
            Console.WriteLine("After Test06GetIncorrectUITemplate");
        }

        /// <summary>
        /// Test for actually using the template
        /// </summary>
        [TestMethod]
        public void Test07GetUITemplateForValidationParamsOK()
        {
            Console.WriteLine("Before Test07GetUITemplateForValidationParamsOK");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = DnaMockery.CreateDatabaseInputContext();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            Stub.On(site).GetProperty("ModClassID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the site options for the new mocked site
            SiteOptionList siteOptionList = new SiteOptionList(mockedInputContext.Diagnostics, DnaMockery.DnaConfig.ConnectionString);
            siteOptionList.CreateFromDatabase();
            siteOptionList.SetValueBool(1, "Forum", "EmailAddressFilter", true);
            siteOptionList.SetValueBool(1, "General", "IsURLFiltered", true);

            // Stub the call to the siteoption
            Stub.On(mockedInputContext).Method("GetSiteOptionValueBool").With("Forum", "EmailAddressFilter").Will(Return.Value(true));
            // Stub the call to the siteoption
            Stub.On(mockedInputContext).Method("GetSiteOptionValueBool").With("General", "IsURLFiltered").Will(Return.Value(true));

            // Initialise the profanities object
            ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.DnaConfig.ConnectionString, null);

            using (IDnaDataReader reader = mockedInputContext.CreateDnaDataReader("getuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = _createdUITemplateID;
                testUITemplate.LoadTemplate();
                List<KeyValuePair<string, string>> parameters = new List<KeyValuePair<string, string>>();

                KeyValuePair<string, string> subject = new KeyValuePair<string, string>("SUBJECT", "TestSubject");
                parameters.Add(subject);
                KeyValuePair<string, string> description = new KeyValuePair<string, string>("Description", "TestDescription");
                parameters.Add(description);

                testUITemplate.ProcessParameters(parameters);

                testUITemplate.Validate();

                DnaXmlValidator validator = new DnaXmlValidator(testUITemplate.RootElement.InnerXml, _schemaUri);
                validator.Validate();
            }
            Console.WriteLine("After Test07GetUITemplateForValidationParamsOK");
        }
        /// <summary>
        /// Test for actually using the template with a profanity
        /// </summary>
        [TestMethod]
        public void Test08GetUITemplateForValidationParamsWithProfanity()
        {
            Console.WriteLine("Before Test08GetUITemplateForValidationParamsWithProfanity");

            //Create the mocked inputcontext
            Mockery mock = new Mockery();
            IInputContext mockedInputContext = DnaMockery.CreateDatabaseInputContext();
            //XmlDocument siteconfig = new XmlDocument();
            //siteconfig.LoadXml("<SITECONFIG />");
            ISite site = mock.NewMock<ISite>();
            //Stub.On(site).GetProperty("SiteConfig").Will(Return.Value(siteconfig.FirstChild));
            Stub.On(site).GetProperty("SiteID").Will(Return.Value(1));

            Stub.On(site).GetProperty("ModClassID").Will(Return.Value(1));

            BBC.Dna.User user = new BBC.Dna.User(mockedInputContext);
            Stub.On(mockedInputContext).GetProperty("ViewingUser").Will(Return.Value(user));
            Stub.On(mockedInputContext).GetProperty("CurrentSite").Will(Return.Value(site));

            // Create the site options for the new mocked site
            SiteOptionList siteOptionList = new SiteOptionList(mockedInputContext.Diagnostics, DnaMockery.DnaConfig.ConnectionString);
            siteOptionList.CreateFromDatabase();
            siteOptionList.SetValueBool(1, "Forum", "EmailAddressFilter", true);
            siteOptionList.SetValueBool(1, "General", "IsURLFiltered", true);

            // Stub the call to the siteoption
            Stub.On(mockedInputContext).Method("GetSiteOptionValueBool").With("Forum", "EmailAddressFilter").Will(Return.Value(true));
            // Stub the call to the siteoption
            Stub.On(mockedInputContext).Method("GetSiteOptionValueBool").With("General", "IsURLFiltered").Will(Return.Value(true));

            // Initialise the profanities object
            ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.DnaConfig.ConnectionString, null);

            using (IDnaDataReader reader = mockedInputContext.CreateDnaDataReader("getuitemplate"))
            {
                Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("getuitemplate").Will(Return.Value(reader));

                // Create a new UITemplate object and get the list of fields
                UITemplate testUITemplate = new UITemplate(mockedInputContext);
                testUITemplate.UITemplateID = _createdUITemplateID;
                testUITemplate.LoadTemplate();
                List<KeyValuePair<string, string>> parameters = new List<KeyValuePair<string, string>>();

                KeyValuePair<string, string> subject = new KeyValuePair<string, string>("SUBJECT", "TestSubject");
                parameters.Add(subject);
                KeyValuePair<string, string> description = new KeyValuePair<string, string>("Description", "TestDescription with fuck");
                parameters.Add(description);

                testUITemplate.ProcessParameters(parameters);

                testUITemplate.Validate();

                DnaXmlValidator validator = new DnaXmlValidator(testUITemplate.RootElement.InnerXml, _schemaUri);
                validator.Validate();
            }
            Console.WriteLine("After Test08GetUITemplateForValidationParamsWithProfanity");
        }
    }
}
