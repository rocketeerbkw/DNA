using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// Test class for testing the status object.
    /// This class also demonstrates how to intergrate NMock and the different types of tests we write
    /// </summary>
    [TestClass]
    public class StatusComponentTest
    {
        // Setup a mockery and DataReader field
        Mockery _mock;
        IDnaDataReader _mockedDataReader;

        /// <summary>
        /// Sets up the tests mock and datareader objects
        /// </summary>
        [TestInitialize]
        public void SetUp()
        {
            // Create the mockery object
            _mock = new Mockery();

            // Now create a mocked DataReader. This will be returned by the mocked input context method CreateDnaDataReader
            _mockedDataReader = _mock.NewMock<IDnaDataReader>();

           

            // Ensure the Statistics object is initialised
            Statistics.ResetCounters();
        }

        /// <summary>
        /// Make sure the Verify Expetations gets called
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            // Finally, we need to make sure that all the Expectation were met.
            // If you want to see what happens when the expectations fail, try changing the exactly value for the CreateDnaDataReader mocked method
            _mock.VerifyAllExpectationsHaveBeenMet();
        }

        /// <summary>
        /// This test demonstrates how to write system tests. System tests are tests that test combinations of objects. Here the status object
        /// requires the database to see if it running or not. We are mocking up the inputcontext, but returning a real datareader from that mockery!
        /// </summary>
        [TestMethod]
        public void SystemTesting()
        {
            Console.WriteLine("SystemTesting");
            // First mockup the inputcontext that we'll use to create the status object
            IInputContext mockedInputContext = _mock.NewMock<IInputContext>();

            Stub.On(mockedInputContext).GetProperty("Diagnostics").Will(Return.Value(DnaDiagnostics.Default));

            // Now mockup the methods the status object requires from the InputContext
            // Mockup the GetParamIntOrZero method as a stub so it returns 60. Stubs don't care how many times they called or with what params!
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").Will(Return.Value(60));

            // Now mockup the CreateDnaDataReader as an Expect. Expectations are more fussy than Stubs as they do care how many times they
            // get called and with what values! If they get don't get called the correct number of times with the correct params, then
            // they fail the test!
            // First create the Datareader to return
           
            //DnaConfig config = new DnaConfig(System.Environment.GetEnvironmentVariable("RipleyServerPath") + @"\");
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader dataReader = context.CreateDnaDataReader("isdatabaserunning"))
            {
                //DnaConfig config = new DnaConfig(System.Environment.GetEnvironmentVariable("dnapages") + @"\");
                //config.Initialise();
                //IDnaDataReader dataReader = new StoredProcedureReader("isdatabaserunning", config.ConnectionString, null);
                Expect.Exactly(1).On(mockedInputContext).Method("CreateDnaDataReader").With("isdatabaserunning").Will(Return.Value(dataReader));

                // Mock up the CurrentServerName property of the inputcontext as a stub
                Stub.On(mockedInputContext).GetProperty("CurrentServerName").Will(Return.Value(Environment.MachineName));



                // Now create the status object using our new mocked up version of the input context
                Status status = new Status(mockedInputContext);

                // Call the process request method
                status.ProcessRequest();

                // Now check to make sure that the request did what we wanted it to. The database should be running!
                Assert.IsNotNull(status.RootElement.SelectSingleNode("//STATUS"), "Find status node came back null!!!");
                Assert.AreEqual("OK", status.RootElement.SelectSingleNode("//STATUS").InnerText, "Database is not running!!!");
            }
        }

        /// <summary>
        /// This test demonstrates how to write a unit test. The unit test only tests the code with in a single object.
        /// Any dependancies are Mocked up.
        /// </summary>
        [TestMethod]
        public void UnitTestStatusOK()
        {
            Console.WriteLine("UnitTestStatusOK");
            // First mockup the inputcontext that we'll use to create the status object
            IInputContext mockedInputContext = _mock.NewMock<IInputContext>();
            Stub.On(mockedInputContext).GetProperty("Diagnostics").Will(Return.Value(DnaDiagnostics.Default));

            // Now mockup the methods the status object requires from the InputContext
            // Mockup the GetParamIntOrZero method as a stub so it returns 60. Stubs don't care how many times they called or with what params!
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").Will(Return.Value(60));

            // Mock the HasRows property and Execue as an Expectation.
            Expect.Exactly(1).On(_mockedDataReader).GetProperty("HasRows").Will(Return.Value(true));
            Expect.Exactly(1).On(_mockedDataReader).Method("Execute").Will(Return.Value(null));
            Expect.Exactly(1).On(_mockedDataReader).Method("Dispose").Will(Return.Value(null));

            // Now get the mocked input context to return the mocked datareader when the CreateDnaDataReader method is called
            Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("isdatabaserunning").Will(Return.Value(_mockedDataReader));

            // Mock up the CurrentServerName property of the inputcontext as a stub
            Stub.On(mockedInputContext).GetProperty("CurrentServerName").Will(Return.Value(Environment.MachineName));

            // Now create the status object using our new mocked up version of the input context
            Status status = new Status(mockedInputContext);

            // Call the process request method
            status.ProcessRequest();

            // Now check to make sure that the request did what we wanted it to. The database should be running!
            Assert.IsNotNull(status.RootElement.SelectSingleNode("//STATUS"), "Find status node came back null!!!");
            Assert.AreEqual("OK", status.RootElement.SelectSingleNode("//STATUS").InnerText, "Database is not running!!!");
        }

        /// <summary>
        /// This test demonstrates how to write a unit test. The unit test only tests the code with in a single object.
        /// Any dependancies are Mocked up.
        /// </summary>
        [TestMethod]
        public void UnitTestStatusFailed()
        {
            Console.WriteLine("UnitTestStatusFailed");
            // First mockup the inputcontext that we'll use to create the status object
            IInputContext mockedInputContext = _mock.NewMock<IInputContext>();

            // Now mockup the methods the status object requires from the InputContext
            // Mockup the GetParamIntOrZero method as a stub so it returns 60. Stubs don't care how many times they called or with what params!
            Stub.On(mockedInputContext).Method("GetParamIntOrZero").Will(Return.Value(60));

            // Mock the HasRows property and Execue as an Expectation.
            Expect.Exactly(1).On(_mockedDataReader).GetProperty("HasRows").Will(Return.Value(false));
            Expect.Exactly(1).On(_mockedDataReader).Method("Execute").Will(Return.Value(null));
            Expect.Exactly(1).On(_mockedDataReader).Method("Dispose").Will(Return.Value(null));

            // Now get the mocked input context to return the mocked datareader when the CreateDnaDataReader method is called
            Stub.On(mockedInputContext).Method("CreateDnaDataReader").With("isdatabaserunning").Will(Return.Value(_mockedDataReader));

            // Mock up the CurrentServerName property of the inputcontext as a stub
            Stub.On(mockedInputContext).GetProperty("CurrentServerName").Will(Return.Value(Environment.MachineName));

            // Now create the status object using our new mocked up version of the input context
            Status status = new Status(mockedInputContext);

            // Call the process request method
            status.ProcessRequest();

            // Now check to make sure that the request did what we wanted it to. The database should be running!
            Assert.IsNull(status.RootElement.SelectSingleNode("//STATUS"), "Find status node came back null!!!");
        }
    }
}


