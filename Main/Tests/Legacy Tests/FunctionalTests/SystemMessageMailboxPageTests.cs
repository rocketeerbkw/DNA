using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;


namespace FunctionalTests
{
    /// <summary>
    /// This class tests the System Message Mailbox page
    /// /// </summary>
    [TestClass]
    public class SystemMessageMailboxPageTests
    {
        private bool _setupRun = false;

        private bool _messagesSent = false; //For tests in isolation

        private DnaTestURLRequest _request = new DnaTestURLRequest("mbnewsround");
        private const string _schemaUri = "H2G2SystemMessageMailboxFlat.xsd";

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
                _request.SignUserIntoSSOViaWebRequest(DnaTestURLRequest.usertype.SUPERUSER);
                _setupRun = true;
            }
            Console.WriteLine("Finished StartUp()");
        }
        /// <summary>
        /// Test that we can get System Message Mailbox page
        /// </summary>
        [TestMethod]
        public void Test01GetSystemMessageMailboxPage()
        {
            Console.WriteLine("Before SystemMessageMailboxPageTests - Test01GetSystemMessageMailboxPage");
            
            // now get the response
            _request.RequestPage("SMM?skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX") != null, "System Message Mailbox tag does not exist!");

            Console.WriteLine("After Test01GetSystemMessageMailboxPage");
        }

        /// <summary>
        /// Test that editors can get to other peoples pages
        /// </summary>
        [TestMethod]
        public void Test02EditorCanSeeOtherPeoplesSMMPage()
        {
            Console.WriteLine("Before Test02EditorCanSeeOtherPeoplesSMMPage");

            SetupSystemMessages();

            // now get the response
            _request.RequestPage("SMM?userid=6&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            XmlElement node = (XmlElement) xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX");


            Assert.IsTrue(node != null, "System Message Mailbox tag does not exist!");

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX[@USERID='6']") != null, "System Message Mailbox tag for user 6 does not exist!" + node.OuterXml);

            Assert.IsTrue(xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX[@TOTALCOUNT='2']") != null, "System Message Mailbox tag for user 6 does not contain correct count - 2!" + xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX/@TOTALCOUNT").InnerText);

            Console.WriteLine("After Test02EditorCanSeeOtherPeoplesSMMPage");
        }

        /// <summary>
        /// Test that the SMM page is XSLT compliant
        /// </summary>
        [TestMethod]
        public void Test03ValidateSystemMessageMailboxPage()
        {
            Console.WriteLine("Before Test03ValidateSystemMessageMailboxPage");

            SetupSystemMessages();

            // now get the response
            _request.RequestPage("SMM?userid=6&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml, _schemaUri);
            validator.Validate();

            Console.WriteLine("After Test03ValidateSystemMessageMailboxPage");
        }

        /// <summary>
        /// Test deleting System Messages
        /// </summary>
        [TestMethod]
        public void Test04DeleteSMM()
        {
            Console.WriteLine("Before Test04DeleteSMM");

            SetupSystemMessages();

            // now get the response
            _request.RequestPage("SMM?userid=6&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml = _request.GetLastResponseAsXML();

            XmlAttribute msgCountAttribute = (XmlAttribute) xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX/@TOTALCOUNT");

            int count = 0;
            Int32.TryParse(msgCountAttribute.Value, out count);

            XmlAttribute msgIDAttribute = (XmlAttribute)xml.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX/MESSAGE/@MSGID");

            int msgID = 0;
            Int32.TryParse(msgIDAttribute.Value, out msgID);

            // now get the response
            _request.RequestPage("SMM?userid=6&cmd=delete&msgid=" + msgID + "&skin=purexml");

            // Check to make sure that the page returned with the correct information
            XmlDocument xml2 = _request.GetLastResponseAsXML();

            Assert.IsTrue(xml2.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX") != null, "System Message Mailbox tag does not exist!");

            Assert.IsTrue(xml2.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX[@USERID='6']") != null, "System Message Mailbox tag for user 6 does not exist!");

            XmlAttribute msgAfterCountAttribute = (XmlAttribute)xml2.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX/@TOTALCOUNT");

            int afterCount = 0;
            Int32.TryParse(msgAfterCountAttribute.Value, out afterCount);

            Assert.IsTrue(xml2.SelectSingleNode("/H2G2/SYSTEMMESSAGEMAILBOX[@TOTALCOUNT='" + afterCount.ToString() + "']") != null, "System Message Mailbox tag for user 6 does not contain correct count! Before = " + count + " After = " + afterCount);
            
            Console.WriteLine("After Test04DeleteSMM");
        }

        private void SetupSystemMessages()
        {
            if (!_messagesSent)
            {
                DeleteJimsSystemMessages();

                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader reader = context.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("exec senddnasystemmessage 6, 57, 'Test system message mailbox one'");
                    reader.ExecuteDEBUGONLY("exec senddnasystemmessage 6, 57, 'Test system message mailbox two'");
                }
                _messagesSent = true;
            }
        }

        private void DeleteJimsSystemMessages()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("exec getuserssystemmessagemailbox 6, 57");
                if (reader.Read())
                {
                    do
                    {
                        int msgID = reader.GetInt32NullAsZero("MsgId");
                        using (IDnaDataReader reader2 = context.CreateDnaDataReader(""))
                        {
                            reader2.ExecuteDEBUGONLY("exec deletednasystemmessage " + msgID.ToString());
                        }
                    } while (reader.Read());
                }
            }
        }
    }
}