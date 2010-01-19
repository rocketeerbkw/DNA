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
    /// KeyValueData test class
    /// </summary>
    [TestClass]
    public class KeyValueDataTests
    {
        /// <summary>
        /// Test to make sure that we can set and get key value data
        /// </summary>
        [TestMethod]
        public void TestSetAndGetKeyValueData()
        {
            // Create a mocked database context
            IInputContext mockedContext = DnaMockery.CreateDatabaseInputContext();

            // Now create a TestInputComponent. See class definition below this class
            TestInputComponent testComponent = new TestInputComponent(mockedContext);

            // Now create some data to put into the database
            XmlNode error = testComponent.CreateElementNode("ERROR");
            testComponent.AddAttribute(error, "TYPE", "MyErrorType");
            testComponent.AddTextTag(error, "ERRORMESSAGE", "MyErrorMessage");
            testComponent.AddTextTag(error, "EXTRAINFO", "MyExtraInfo");

            // Add the data to the response
            string dataKey = testComponent.AddResponseKeyValueDataCookie("TESTING", error, "bbc.co.uk");
            Assert.IsTrue(dataKey.Length > 0, "Failed to get a valid data key from the keyvaluedata table");

            // Now try to get the data back from the database using the key we were just given
            XmlNode dataValueXml = testComponent.GetKeyValueData(dataKey);
            Assert.IsNotNull(dataValueXml, "Failed to get a valid xml object for the given data key");

            // Test to make sure we got back what we put in
            Assert.IsNotNull(dataValueXml.SelectSingleNode("/ERROR"), "Failed to find the base xml tag");
            Assert.IsNotNull(dataValueXml.SelectSingleNode("/ERROR/@TYPE"), "Failed to find the TYPE attribute");
            Assert.IsNotNull(dataValueXml.SelectSingleNode("/ERROR/ERRORMESSAGE"), "Failed to find the ERRORMESSAGE xml tag");
            Assert.IsNotNull(dataValueXml.SelectSingleNode("/ERROR/EXTRAINFO"), "Failed to find the EXTRAINFO xml tag");
            Assert.AreEqual("MyErrorType", dataValueXml.SelectSingleNode("/ERROR/@TYPE").InnerText, "The value did not match the one put in");
            Assert.AreEqual("MyErrorMessage", dataValueXml.SelectSingleNode("/ERROR/ERRORMESSAGE").InnerText, "The value did not match the one put in");
            Assert.AreEqual("MyExtraInfo", dataValueXml.SelectSingleNode("/ERROR/EXTRAINFO").InnerText, "The value did not match the one put in");
        }
    }

    /// <summary>
    /// Test class for testing basic DnaComponent functionality
    /// </summary>
    public class TestInputComponent : DnaInputComponent
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="context">The inputcontext that the component should work in</param>
        public TestInputComponent(IInputContext context)
            : base(context)
        {
        }
    }
}
