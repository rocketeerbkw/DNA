using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Tests;
using BBC.Dna.Moderation.Utils.Tests;
using BBC.Dna.Moderation;
using BBC.Dna.Moderation.Utils;
using System.Xml;
using System.Collections.Specialized;

namespace BBC.Dna.Common.Tests
{
    /// <summary>
    /// Summary description for SignalHelperTests
    /// </summary>
    [TestClass]
    public class SignalHelperTests
    {
        private readonly MockRepository _mocks = new MockRepository();

        public SignalHelperTests()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        [TestInitialize]
        public void Initialise()
        {
            BannedEmailsTests.InitialiseMockBannedEmails();
            Assert.IsNotNull(SignalHelper.GetObject(typeof(BannedEmails)));
            ProfanityFilterTests.InitialiseProfanities();
            Assert.IsNotNull(SignalHelper.GetObject(typeof(ProfanityFilter)));
        }

        [TestMethod]
        public void GetStatus_ValidObjects_ReturnsCorrectStatObject()
        {
            var diag = _mocks.DynamicMock<IDnaDiagnostics>();
            _mocks.ReplayAll();
            var stats = SignalHelper.GetStatus(diag);

            Assert.IsNotNull(stats);
            Assert.AreNotEqual(0, stats.Members.Count);

            var xml = new XmlDocument();
            xml.LoadXml(StringUtils.SerializeToXmlUsingXmlSerialiser(stats));
            Assert.IsNotNull(xml.SelectSingleNode("/SIGNALSTATUS/SIGNALSTATUSMEMBER[NAME = 'BBC.Dna.Moderation.BannedEmails, BBC.Dna.Moderation, Version=1.0.0.1, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887']/NAME"));
            Assert.IsNotNull(xml.SelectSingleNode("/SIGNALSTATUS/SIGNALSTATUSMEMBER[NAME = 'BBC.Dna.Moderation.Utils.ProfanityFilter, BBC.DNA.Moderation.Utils, Version=1.0.0.0, Culture=neutral, PublicKeyToken=c2c5f2d0ba0d9887']/NAME"));
        }

        [TestMethod]
        public void ClearObjects_ReturnsAllObjectsCleared()
        {
            Assert.IsNotNull(SignalHelper.GetObject(typeof(BannedEmails)));
            SignalHelper.ClearObjects();
            Assert.IsNull(SignalHelper.GetObject(typeof(BannedEmails)));
        }

        [TestMethod]
        public void HandleSignal_WithoutArgs_DoesNothing()
        {
            bool expectionThrown = false;
            try
            {
                SignalHelper.HandleSignal(null);
            }
            catch (Exception)
            {
                expectionThrown = true;
            }
            Assert.IsFalse(expectionThrown);

        }

        [TestMethod]
        public void HandleSignal_WithoutUnknownAction_ThrowsException()
        {
            bool expectionThrown = false;
            NameValueCollection args = new NameValueCollection();
            args.Add("action", "notvalid");
            try
            {
                SignalHelper.HandleSignal(args);
            }
            catch (Exception e)
            {
                Assert.IsTrue(e.Message.IndexOf("notvalid") >= 0);
                expectionThrown = true;
            }
            Assert.IsTrue(expectionThrown);

        }
    }
}
