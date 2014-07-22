using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using TestUtils;
using System.Xml;
//using BBC.Dna.Moderation;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Objects;

namespace BBC.Dna.Moderation.Tests
{
    /// <summary>
    ///This is a test class for TermDetailsTest and is intended
    ///to contain all TermDetailsTest Unit Tests
    ///</summary>
    [TestClass]
    public class TermDetailsTest
    {
        public MockRepository Mocks = new MockRepository();

        /// <summary>
        ///A test for Terms Constructor
        ///</summary>
        [TestMethod]
        public void TermDetailsConstructor_CorrectObject_ValidXml()
        {
            TermDetails target = CreateTermDetails();
            //var expected = "<TERMDETAILS xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" ID=\"0\" TERM=\"term\" REASON=\"no change\" UPDATEDDATE=\"\" USERID=\"0\" />";
            var expected = "<TERMDETAILS xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" ID=\"0\" ACTION=\"NoAction\" TERM=\"term\" MODCLASSID=\"0\" ForumID=\"0\" USERID=\"0\" FromModClass=\"false\"><REASON>no change</REASON><UPDATEDDATE /></TERMDETAILS>";
            XmlDocument xml = Serializer.SerializeToXml(target);
            Assert.AreEqual(expected, xml.SelectSingleNode("TERMDETAILS").OuterXml);
        }

        public static TermDetails CreateTermDetails()
        {
            return new TermDetails() { Id = 0, Value = "term", Reason = "no change", UpdatedDate = new DateElement(), UserID = 0 };
        }
    }
}
