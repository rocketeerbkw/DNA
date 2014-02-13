using System.Collections.Generic;
using DnaEventService.Common;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace DatabaseEmailProcessor.IntegrationTests
{
    public class TestLogger : IDnaLogger
    {
        public TestLogger()
        {
            TestLog = new List<LogEntry>();
        }

        public List<LogEntry> TestLog { get; set; }

        #region IDnaLogger Members

        public void Write(LogEntry log)
        {
            TestLog.Add(log);
        }

        #endregion
    }
}
