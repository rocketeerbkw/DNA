using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Rhino.Mocks;
using Rhino.Mocks.Constraints;
using Dna.BIEventSystem;
using DnaEventService.Common;

namespace DnaEventProcessorService.IntegrationTests
{
    [TestClass]
    public class BIEventProcessorIntegrationTests
    {
        private MockRepository _mocks = new MockRepository();

        [TestMethod]
        public void ProcessEvents_TestLogFile()
        {
            IDnaLogger logger = new DnaLogger();

            string logFile = @"Logs\BIEventProcessor\BIEventProcessor.log";
            Assert.IsFalse(File.Exists(logFile));

            BIEventProcessor bep = BIEventProcessor.CreateBIEventProcessor(logger, null, null, 1, false, false);

            var evRisk = _mocks.DynamicMock<BIPostNeedsRiskAssessmentEvent>(null, null);
            var evPost = _mocks.DynamicMock<BIPostToForumEvent>(new object[] { null });

            var eventList = new List<BIEvent>() { evRisk, evPost };

            _mocks.ReplayAll();

            bep.ProcessEvents(eventList);

            evRisk.AssertWasCalled(x => x.Process());
            evPost.AssertWasCalled(x => x.Process());

            Assert.IsTrue(File.Exists(logFile));
            File.Copy(logFile, logFile + ".copy");  // We have to copy it in order to read it, otherwise we get a share violation
            var lines = File.ReadAllLines(logFile + ".copy");

            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "Category: BIEventProcessor"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "EventId"));
            Assert.IsTrue(ArrayContainsLineThatStartsWith(lines, "EventType"));
        }

        private bool ArrayContainsLineThatStartsWith(string[] lines, string startsWith)
        {
            foreach (string s in lines)
            {
                if (s.StartsWith(startsWith))
                    return true;
            }
            return false;
        }
    }
}
