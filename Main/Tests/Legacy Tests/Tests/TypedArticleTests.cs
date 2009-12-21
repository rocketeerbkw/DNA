using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;



namespace Tests
{
    /// <summary>
    /// The typed article tests
    /// </summary>
    [TestClass]
    public class TypedArticleTests
    {
        /// <summary>
        ///  Make sure the database is restored
        /// </summary>
        [TestInitialize]
        public void Setup()
        {
            SnapshotInitialisation.RestoreFromSnapshot();
            ProfanityFilter.ClearTestData();
        }

        /// <summary>
        /// Check that error is reported when no templateid is given
        /// </summary>
        [TestMethod]
        public void TestCorrectErrorForNoTemplateID()
        {
            // Create the mocked input context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the type article test object
            TypedArticle typedArticle = new TypedArticle(context);

            // Create the mocked editor for the article
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Create the stubs for the mocked params
            Stub.On(context).Method("GetParamIntOrZero").With("TemplateID", "Get the template to use for this request").Will(Return.Value(0));

            // Now get it to process the request
            typedArticle.ProcessRequest();

            // Now check the xml
            XmlNode testNode = typedArticle.RootElement.SelectSingleNode("//TYPEDARTICLE");
            Assert.IsNotNull(testNode.SelectSingleNode("//ERROR"), "No error was reported for invalid templateid");
            Assert.AreEqual("No Template ID Given!", testNode.SelectSingleNode("//ERROR").InnerText, "Incorrect error reported for invalid template id");
        }

        /// <summary>
        /// Check that error is reported when an invalid templateid is given
        /// </summary>
        [TestMethod]
        public void TestCorrectErrorForInvalidTemplateID()
        {
            // Create the mocked input context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the type article test object
            TypedArticle typedArticle = new TypedArticle(context);

            // Create the stubs for the mocked params
            Stub.On(context).Method("GetParamIntOrZero").With("TemplateID", "Get the template to use for this request").Will(Return.Value(42));

            // Create the mocked editor for the article
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Now get it to process the request
            typedArticle.ProcessRequest();

            // Now check the xml
            XmlNode testNode = typedArticle.RootElement.SelectSingleNode("//TYPEDARTICLE");
            Assert.IsNotNull(testNode.SelectSingleNode("//ERROR"), "No error was reported for invalid templateid");
            Assert.AreEqual("No template data returned, invalid UI Template ID.", testNode.SelectSingleNode("//ERROR").InnerText, "Incorrect error reported for invalid template id");
        }

        /// <summary>
        /// Check that the xml is correct for valid templateid and no action given
        /// </summary>
        [TestMethod]
        public void TestCorrectXMLForValidTemplateIDAndNoAction()
        {
            // Create the mocked input context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the type article test object
            TypedArticle typedArticle = new TypedArticle(context);

            // Create a test template to play with
            int templateID = CreateTestTemplateWithFields(context, typedArticle);

            // Create the stubs for the mocked params
            Stub.On(context).Method("GetParamIntOrZero").With("TemplateID", "Get the template to use for this request").Will(Return.Value(templateID));
            Stub.On(context).Method("DoesParamExist").With("Update", "Are we updating an article").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("Edit", "Are we editing an article").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("Create", "Are we Creating an article").Will(Return.Value(false));
            Stub.On(context).Method("GetSiteOptionValueString").With("KeyPhrases", "DelimiterToken").Will(Return.Value(" "));

            // Create the mocked editor for the article
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Now get it to process the request
            typedArticle.ProcessRequest();

            // Now check the xml
            XmlNode testNode = typedArticle.RootElement.SelectSingleNode("//TYPEDARTICLE");
            Assert.IsNull(testNode.SelectSingleNode("//ERROR"), "There should be no errors!");
            foreach (UIField field in typedArticle.GetRequiredFormFields)
            {
                Assert.AreEqual(field.Name, testNode.SelectSingleNode("//UIFIELD[NAME = '" + field.Name + "']/NAME").InnerText, "Failed to find the template field " + field.Name);
            }
            Assert.AreEqual("TestField", testNode.SelectSingleNode("//UIFIELD[NAME = 'TestField']/NAME").InnerText, "Failed to find the template test field");
            Assert.AreEqual("", testNode.Attributes["ACTION"].Value, "Incorrect action attribute found");
            Assert.IsNotNull(testNode.SelectSingleNode("//KEYPHRASE-DELIMITER"), "Failed to find the keyphrase delimiter string");
            Assert.AreEqual(" ", testNode.SelectSingleNode("//KEYPHRASE-DELIMITER").InnerText, "Incorrect keyphrase delimiter found");
        }

        /// <summary>
        /// Check that the xml is correct for valid templateid and create action given loged in as editor
        /// </summary>
        [TestMethod]
        public void TestCorrectXMLForValidTemplateIDAndCreateActionForEditor()
        {
            // Create the mocked input context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the type article test object
            TypedArticle typedArticle = new TypedArticle(context);

            // Create a test template to play with
            int templateID = CreateTestTemplateWithFields(context, typedArticle);

            // Create the stubs for the mocked params
            Stub.On(context).Method("GetParamIntOrZero").With("TemplateID", "Get the template to use for this request").Will(Return.Value(templateID));
            Stub.On(context).Method("DoesParamExist").With("Update", "Are we updating an article").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("Edit", "Are we editing an article").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("Create", "Are we Creating an article").Will(Return.Value(true));
            Stub.On(context).Method("GetSiteOptionValueString").With("KeyPhrases", "DelimiterToken").Will(Return.Value(" "));
            Stub.On(context).Method("DoesParamExist").With("Redirect", "Have we been given a redirect?").Will(Return.Value(false));
            Stub.On(context).GetProperty("CurrentServerName").Will(Return.Value(DnaTestURLRequest.CurrentServer));

            // Put some sample data into the params
            int i = 0;
            foreach (UIField field in typedArticle.GetRequiredFormFields)
            {
                Stub.On(context).Method("DoesParamExist").With(field.Name, "Does template field value").Will(Return.Value(true));
                if (field.Type == UIField.UIFieldType.String)
                {
                    Stub.On(context).Method("GetParamStringOrEmpty").With(field.Name, "Get template field value").Will(Return.Value("TestValue" + i.ToString()));
                }
                else if (field.Type == UIField.UIFieldType.Number && field.Name.CompareTo("HideArticle") == 0)
                {
                    Stub.On(context).Method("GetParamStringOrEmpty").With(field.Name, "Get template field value").Will(Return.Value("0"));
                }
                else if (field.Type == UIField.UIFieldType.Number)
                {
                    Stub.On(context).Method("GetParamStringOrEmpty").With(field.Name, "Get template field value").Will(Return.Value(i.ToString()));
                }
                i++;
            }

            Stub.On(context).Method("DoesParamExist").With("TestField", "Does template field value").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("TestField", "Get template field value").Will(Return.Value("http://www.google.com/doitagain"));

            Stub.On(context).Method("GetSiteOptionValueBool").With("General", "IsURLFiltered").Will(Return.Value(true));
            Stub.On(context).Method("GetSiteOptionValueBool").With("Forum", "EmailAddressFilter").Will(Return.Value(false));

            // Create a mocked site for the context
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", false);
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));

            // Initialise the profanities object
            ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.DnaConfig.ConnectionString, null);

            // Create the mocked editor for the article
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558353));
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsSuperUser").Will(Return.Value(false));
            Stub.On(mockedUser).GetProperty("AcceptSubscriptions").Will(Return.Value(false));
            Stub.On(mockedUser).Method("HasSpecialEditPermissions").WithAnyArguments().Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Now get it to process the request
            typedArticle.ProcessRequest();

            // Now check the xml
            XmlNode testNode = typedArticle.RootElement.SelectSingleNode("//TYPEDARTICLE");
            Assert.IsNull(testNode.SelectSingleNode("//ERROR"), "There should be no errors!");
            foreach (UIField field in typedArticle.GetRequiredFormFields)
            {
                Assert.AreEqual(field.Name, testNode.SelectSingleNode("//UIFIELD[NAME = '" + field.Name + "']/NAME").InnerText, "Failed to find the template field " + field.Name);
            }
            Assert.AreEqual("TestField", testNode.SelectSingleNode("//UIFIELD[NAME = 'TestField']/NAME").InnerText, "Failed to find the template test field");
            Assert.AreEqual("CREATE", testNode.Attributes["ACTION"].Value, "Incorrect action attribute found");

            Assert.IsNotNull(testNode.SelectSingleNode("./H2G2ID"), "Failed to find the h2g2 id of the new article");
            Assert.IsNotNull(testNode.SelectSingleNode("//KEYPHRASE-DELIMITER"), "Failed to find the keyphrase delimiter string");
            Assert.AreEqual(" ", testNode.SelectSingleNode("//KEYPHRASE-DELIMITER").InnerText, "Incorrect keyphrase delimiter found");
        }

        /// <summary>
        /// Check that the xml is correct for valid templateid and create action given with non validating values
        /// e.g. profanities
        /// </summary>
        [TestMethod]
        public void TestCorrectXMLForValidTemplateIDAndCreateActionWithNonValidatingValues()
        {
            // Create the mocked input context
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

            // Create the type article test object
            TypedArticle typedArticle = new TypedArticle(context);

            // Create a test template to play with
            int templateID = CreateTestTemplateWithFields(context, typedArticle);

            // Create the stubs for the mocked params
            Stub.On(context).Method("GetParamIntOrZero").With("TemplateID", "Get the template to use for this request").Will(Return.Value(templateID));
            Stub.On(context).Method("DoesParamExist").With("Update", "Are we updating an article").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("Edit", "Are we editing an article").Will(Return.Value(false));
            Stub.On(context).Method("DoesParamExist").With("Create", "Are we Creating an article").Will(Return.Value(true));
            Stub.On(context).Method("GetSiteOptionValueString").With("KeyPhrases", "DelimiterToken").Will(Return.Value(" "));
            Stub.On(context).Method("DoesParamExist").With("Redirect", "Have we been given a redirect?").Will(Return.Value(false));
            Stub.On(context).GetProperty("CurrentServerName").Will(Return.Value(DnaTestURLRequest.CurrentServer));

            // Put some sample data into the params
            int i = 0;
            foreach (UIField field in typedArticle.GetRequiredFormFields)
            {
                Stub.On(context).Method("DoesParamExist").With(field.Name, "Does template field value").Will(Return.Value(true));
                if (field.Name.CompareTo("Body") == 0)
                {
                    Stub.On(context).Method("GetParamStringOrEmpty").With(field.Name, "Get template field value").Will(Return.Value("fuck profanities!"));
                }
                else if (field.Type == UIField.UIFieldType.String)
                {
                    Stub.On(context).Method("GetParamStringOrEmpty").With(field.Name, "Get template field value").Will(Return.Value("TestValue" + i.ToString()));
                }
                else if (field.Type == UIField.UIFieldType.Number)
                {
                    Stub.On(context).Method("GetParamStringOrEmpty").With(field.Name, "Get template field value").Will(Return.Value(i.ToString()));
                }
                i++;
            }
            Stub.On(context).Method("DoesParamExist").With("TestField", "Does template field value").Will(Return.Value(true));
            Stub.On(context).Method("GetParamStringOrEmpty").With("TestField", "Get template field value").Will(Return.Value("Sample test data"));

            Stub.On(context).Method("GetSiteOptionValueBool").With("General", "IsURLFiltered").Will(Return.Value(false));
            Stub.On(context).Method("GetSiteOptionValueBool").With("Forum", "EmailAddressFilter").Will(Return.Value(false));

            // Create a mocked site for the context
            ISite mockedSite = DnaMockery.CreateMockedSite(context, 1, "h2g2", "h2g2", false);
            Stub.On(context).GetProperty("CurrentSite").Will(Return.Value(mockedSite));
            Stub.On(mockedSite).GetProperty("ModClassID").Will(Return.Value(1));

            // Initialise the profanities object
            ProfanityFilter.InitialiseProfanitiesIfEmpty(DnaMockery.DnaConfig.ConnectionString, null);

            // Create the mocked editor for the article
            IUser mockedUser = DnaMockery.CurrentMockery.NewMock<IUser>();
            Stub.On(mockedUser).GetProperty("UserLoggedIn").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("IsEditor").Will(Return.Value(true));
            Stub.On(mockedUser).GetProperty("UserID").Will(Return.Value(1090558353));
            Stub.On(mockedUser).GetProperty("AcceptSubscriptions").Will(Return.Value(false));
            Stub.On(mockedUser).Method("HasSpecialEditPermissions").WithAnyArguments().Will(Return.Value(true));
            Stub.On(context).GetProperty("ViewingUser").Will(Return.Value(mockedUser));

            // Now get it to process the request
            typedArticle.ProcessRequest();

            // Now check the xml
            XmlNode testNode = typedArticle.RootElement.SelectSingleNode("//TYPEDARTICLE");
            Assert.IsNotNull(testNode.SelectSingleNode("//ERROR"), "There should be errors!");
            Assert.AreEqual("Profanity Error", testNode.SelectSingleNode("//ERROR/@TYPE").InnerText, "We should have a profanities error!");
            foreach (UIField field in typedArticle.GetRequiredFormFields)
            {
                Assert.AreEqual(field.Name, testNode.SelectSingleNode("//UIFIELD[NAME = '" + field.Name + "']/NAME").InnerText, "Failed to find the template field " + field.Name);
            }
            Assert.AreEqual("TestField", testNode.SelectSingleNode("//UIFIELD[NAME = 'TestField']/NAME").InnerText, "Failed to find the template test field");
            Assert.AreEqual("CREATE", testNode.Attributes["ACTION"].Value, "Incorrect action attribute found");
            Assert.IsNotNull(testNode.SelectSingleNode("//KEYPHRASE-DELIMITER"), "Failed to find the keyphrase delimiter string");
            Assert.AreEqual(" ", testNode.SelectSingleNode("//KEYPHRASE-DELIMITER").InnerText, "Incorrect keyphrase delimiter found");
        }

        /// <summary>
        /// Creates a new template to test against
        /// </summary>
        /// <param name="context">The context to create the objects in</param>
        /// <param name="testTypedArticle">The test typed article object you want to get the required fields for</param>
        /// <returns>The id of the template</returns>
        private int CreateTestTemplateWithFields(IInputContext context, TypedArticle testTypedArticle)
        {
            // Create the UITemplate in the database
            UITemplate template = new UITemplate(context);

            // Get the required fields from the typed article builder
            foreach (UIField field in testTypedArticle.GetRequiredFormFields)
            {
                template.AddField(field);
            }

            // Now add the non required test element
            UIField testField = new UIField(context);
            testField.Name = "TestField";
            testField.Required = false;
            testField.Type = UIField.UIFieldType.String;
            testField.ValidateEmpty = true;
            testField.IsKeyPhrase = true;
            template.AddField(testField);

            // Store the data and return the new template id
            template.StoreTemplateData();
            return template.UITemplateID;
        }
    }
}
