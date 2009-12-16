using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace DnaEventService.Common
{
    public class DnaLogger : IDnaLogger
    {
        #region IDnaLogger Members

        void IDnaLogger.Write(Microsoft.Practices.EnterpriseLibrary.Logging.LogEntry log)
        {
            Logger.Write(log);
        }

        #endregion
    }
}
