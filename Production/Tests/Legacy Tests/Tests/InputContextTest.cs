using System;
using System.Collections.Generic;
using System.IO;
using System.Net; //HttpListener
using System.Text;
using System.Web.UI; //PageParser.
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
     /// <summary>
    /// Start the test by setting up the test bench.
    /// Make sure that the user is logged into the actionnetwork site via the URL
    /// </summary>
    [TestClass]
    public class InputContextTest
    {

        /// <summary>
        /// Start the test by setting up the test bench.
        /// Make sure that the user is logged into the actionnetwork site via the URL
        /// </summary>
        [TestInitialize]
        public void SetUP()
        {
            //temppath = System.Environment.GetEnvironmentVariable("SolutionDir");
        }

        /// <summary>
        /// Removes the Test Page used for this test.
        /// </summary>
        [TestCleanup]
        public void TearDown()
        {
            //Finished with testpage.aspx
            //asphost.RemovePage("TestPage.aspx");   
        }

        /// <summary>
        /// Start the test by setting up the test bench.
        /// Make sure that the user is logged into the actionnetwork site via the URL
        /// </summary>
        [Ignore]
        public void RequestTest()
        {
            /*Console.WriteLine("RequestTest");
            if (asphost == null)
            {
                Assert.Fail("Unable to create environment for hosting ASP.NET. Requires a dnapages environment variable indicating path to dnapages dir.");
                return;
            }
            if (!asphost.CopyPage("TestPage.aspx"))
            {
                Assert.Fail("Unable to copy TestPage.aspx to hosting directory ( dnapages )");
            }
           
            //asphost.AddCookieToRequest("SSO2-UID", "0465e40bc638441a2e9b6381816653cf1a1348ec78c360cba1871e0d8345ef4800");
            asphost.ProcessRequest("TestPage.aspx", "skin=purexml&testparam1=testparam1value&testparam2=64","");

            //Examine the Test Page results.
            XmlDocument xmldoc = new XmlDocument();
            try
            {
                xmldoc.LoadXml(asphost.ResponseString);
            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.Print(e.Message + "   " + asphost.ResponseString);
            }
            XmlNodeList tests = xmldoc.SelectNodes("H2G2/TESTRESULTS/TEST");
            foreach (XmlNode test in tests)
            {
                string name = test.Attributes["NAME"].Value;
                bool result = Convert.ToBoolean(test.InnerText);
                Assert.IsTrue(result, name);
            }*/
        }

        /// <summary>
        /// Test to create an Http Listener to process a request on port 8081.
        /// </summary>
        [Ignore]
        public void ListenerTest()
        {
            //Create a Web Server on port 8081 and listen for all requests on this port.
            //Requires XP or server 2003.
            if (HttpListener.IsSupported)
            {
                HttpListener listener = new HttpListener();
                listener.Prefixes.Add("http://+:8081/");
                listener.Start();

                //Make a Request to port 8081. Thi should be cached and picked up by a listener when available.
                DnaTestURLRequest request = new DnaTestURLRequest("haveyoursay");
                request.SetCurrentUserNormal();
                request.RequestPage("status.aspx");

                //This will block waiting for a request.
                HttpListenerContext ctx = listener.GetContext();  
                
            }
        }
    }

    /// <summary>
    /// Test Component
    /// Used to call public methods on Input Context within Asp hosting environment.
    /// XML is produced as a means of passing the results information accross App Domain boundary.
    /// The Test above then analyses the results. 
    /// </summary>
    public class InputContextTestComponent : DnaInputComponent
    {
        /// <summary>
        /// Default constructor for the Forum component
        /// </summary>
        /// <param name="context">The Context of the DnaPage the component is created in.</param>
        public InputContextTestComponent(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Test Component for InputContext Test.
        /// </summary>
        public override void ProcessRequest()
        {
             //Produce XML Indicating test results.
            XmlNode tests = AddElementTag(RootElement, "TESTRESULTS");

            //Do Tests on the Input Context public interface.
            bool result = InputContext.DoesParamExist("testparam1", "testparam1");
            XmlNode test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::DoesParamExist()");

            //Check Param Names
            result = true;
            List<string> paramnames = InputContext.GetAllParamNames();
            foreach ( string name in paramnames ) 
            {
                result = result && InputContext.DoesParamExist(name, name);
            }
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetAllParamNames()");

            string param1 = string.Empty;
            InputContext.TryGetParamString("testparam1",ref param1,"testparam1");
            result = (param1 == "testparam1value");
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::TryGetParamString()");

            string nonexistent = string.Empty;
            InputContext.TryGetParamString("nonexistent", ref nonexistent, "nonexistent");
            result = (nonexistent == string.Empty);
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::TryGetParamString() - Non Existent Parameter");

            param1 = InputContext.GetParamStringOrEmpty("testparam1", "testparam1");
            result = (param1 =="testparam1value");
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamStringOrEmpty()");
            
            nonexistent = InputContext.GetParamStringOrEmpty("nonexistent", "nonexistent");
            result = (nonexistent == string.Empty);
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamStringOrEmpty() - NonExistent Parameter");

            param1 = InputContext.GetParamStringOrEmpty("testparam1", 0, "testparam1");
            result = (param1 == "testparam1value");
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamStringOrEmpty() - Index 0");


            int testparam2 = InputContext.GetParamIntOrZero("testparam2", "testparam2");
            result = (testparam2 == 64);
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamIntOrZero()");

            int nonexistent2 = InputContext.GetParamIntOrZero("nonexistent", "nonexistent");
            result = ( nonexistent2 == 0 );
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamIntOrZero() - Non Existent Parameter");



            int testparam1count = InputContext.GetParamCountOrZero("testparam1", "testparam1");
            result = ( testparam1count == 1);
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamCount()");

            int testparam2count = InputContext.GetParamCountOrZero("testparam2", "testparam2");
            result = ( testparam2count == 1);
            test = AddElement(tests, "TEST", result.ToString());
            AddAttribute(test, "NAME", "InputContext::GetParamCount()");

        }

    }
}
