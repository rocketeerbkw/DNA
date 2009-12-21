using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
    /// <summary>
    /// 
    /// </summary>
    [TestClass]
    public class ModerationReasonsTests
    {
        /// <summary>
        /// 
        /// </summary>
        [TestMethod]
        public void TestXmlForModClass()
        {
            Mockery mocks = new Mockery();
            IInputContext context = mocks.NewMock<IInputContext>();
            IDnaDataReader mockedReader = mocks.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Execute");
            Stub.On(mockedReader).Method("Dispose");
            IAction mockReaderResults = new MockedReaderResults(new object[] { true, false });
            Stub.On(mockedReader).Method("Read").Will(mockReaderResults);

            // Check Stored Procedure is called as expected.
            Expect.Once.On(mockedReader).Method("AddParameter").With("modclassid", 1);

            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("reasonid").Will(Return.Value(6));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("displayname").Will(Return.Value("DisplayName"));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("emailname").Will(Return.Value("EmailName"));
            Stub.On(mockedReader).Method("GetTinyIntAsInt").With("editorsonly").Will(Return.Value(0));

            ModerationReasons modReasons = new ModerationReasons(context);
            modReasons.GenerateXml(1);

            //Check XML.is as expected.
            XmlNode node = modReasons.RootElement.SelectSingleNode(@"MOD-REASONS");
            Assert.IsNotNull(node, "ModerationReasons Element Found");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS[@MODCLASSID='1']"), "Moderation Class Id");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/MOD-REASON[@DISPLAYNAME='DisplayName']"), "Displayname");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/MOD-REASON[@EMAILNAME='EmailName']"), "Emailname");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/MOD-REASON[@EDITORSONLY='0']"), "Editors Only");


            mocks.VerifyAllExpectationsHaveBeenMet();
        }

        /// <summary>
        /// Validates Moderation Reasons Xml.
        /// </summary>
        [TestMethod]
        public void TestXmlNoModClass()
        {
            Mockery mocks = new Mockery();
            IInputContext context = mocks.NewMock<IInputContext>();
            IDnaDataReader mockedReader = mocks.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Execute");
            Stub.On(mockedReader).Method("Dispose");
            IAction mockReaderResults = new MockedReaderResults(new object[] { true, false });
            Stub.On(mockedReader).Method("Read").Will(mockReaderResults);

            // Check Stored Procedure is called as expected.
            Expect.Never.On(mockedReader).Method("AddParameter").With("modclassid");

            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("reasonid").Will(Return.Value(6));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("displayname").Will(Return.Value("DisplayName"));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("emailname").Will(Return.Value("EmailName"));
            Stub.On(mockedReader).Method("GetTinyIntAsInt").With("editorsonly").Will(Return.Value(0));

            ModerationReasons modReasons = new ModerationReasons(context);
            modReasons.GenerateXml(0);

            //Check XML.is as expected.
            XmlNode node = modReasons.RootElement.SelectSingleNode(@"MOD-REASONS");
            Assert.IsNotNull(node, "ModerationReasons Element Found");
            Assert.IsNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/@MODCLASSID"), "Moderation Class Id");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/MOD-REASON[@DISPLAYNAME='DisplayName']"), "Displayname");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/MOD-REASON[@EMAILNAME='EmailName']"), "Emailname");
            Assert.IsNotNull(modReasons.RootElement.SelectSingleNode(@"MOD-REASONS/MOD-REASON[@EDITORSONLY='0']"), "Editors Only");


            mocks.VerifyAllExpectationsHaveBeenMet();
        }

        /// <summary>
        /// Verify Xml aainst Schema.
        /// </summary>
        [TestMethod]
        public void VerifyXmlWithSchema()
        {
            Mockery mocks = new Mockery();
            IInputContext context = mocks.NewMock<IInputContext>();
            
            IDnaDataReader mockedReader = mocks.NewMock<IDnaDataReader>();
            Stub.On(context).Method("CreateDnaDataReader").Will(Return.Value(mockedReader));
            Stub.On(mockedReader).Method("Execute");
            Stub.On(mockedReader).Method("Dispose");
            IAction mockReaderResults = new MockedReaderResults(new object[] { true, false });
            Stub.On(mockedReader).Method("Read").Will(mockReaderResults);

            Stub.On(mockedReader).Method("GetInt32NullAsZero").With("reasonid").Will(Return.Value(6));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("displayname").Will(Return.Value("DisplayName"));
            Stub.On(mockedReader).Method("GetStringNullAsEmpty").With("emailname").Will(Return.Value("EmailName"));
            Stub.On(mockedReader).Method("GetTinyIntAsInt").With("editorsonly").Will(Return.Value(0));

            ModerationReasons modReasons = new ModerationReasons(context);
            modReasons.ProcessRequest();

            DnaXmlValidator validator = new DnaXmlValidator(modReasons.RootElement.InnerXml, "Mod-Reasons.xsd");
            validator.Validate();
        }

        internal class MockedReaderResults : IAction
        {
            private int _rowCount = 0;
            private List<object> _values = new List<object>();

            public MockedReaderResults(object[] values)
            {
                foreach (object value in values)
                {
                    _values.Add(value);
                }
            }

            public void Invoke(NMock2.Monitoring.Invocation invocation)
            {
                invocation.Result = _values[_rowCount];
                _rowCount++;
                
            }

            public void DescribeTo(System.IO.TextWriter writer)
            {
                writer.Write("Reading a data line");
            }
        }
    }
}
