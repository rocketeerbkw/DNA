using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// Test PollResultsTest
    /// </summary>
    [TestClass]
    public class PollResultsTest
    {
        private PollResults _pollResults;

        /// <summary>
        /// Constructor
        /// </summary>
        public PollResultsTest()
        {
            _pollResults = new PollResults();
        }

        /// <summary>
        /// Create PollResult 
        /// </summary>
        [TestMethod]
        public void CreatePollResult()
        {
            Assert.IsNotNull(_pollResults, "PollResults created.");
        }

        /// <summary>
        /// Add result
        /// </summary>
        [TestMethod]
        public void AddResults()
        {
            _pollResults.Add(Poll.UserStatus.USERSTATUS_LOGGEDIN, 1, "blah", "1");
            _pollResults.Add(Poll.UserStatus.USERSTATUS_LOGGEDIN, 2, "blah2", "2");
            _pollResults.Add(Poll.UserStatus.USERSTATUS_HIDDEN, 1, "hidden", "0");
            XmlElement xml = _pollResults.GetXml();

            DnaXmlValidator validator = new DnaXmlValidator(xml, "OptionList.xsd");
            validator.Validate();

            Assert.IsTrue(xml.OuterXml.Equals("<OPTION-LIST><USERSTATUS TYPE=\"1\"><OPTION INDEX=\"blah\" COUNT=\"1\" /><OPTION INDEX=\"blah2\" COUNT=\"2\" /></USERSTATUS><USERSTATUS TYPE=\"2\"><OPTION INDEX=\"hidden\" COUNT=\"0\" /></USERSTATUS></OPTION-LIST>"), "AddThreeResults: Xml is not what we were expecting"); 
        }
    }
}
