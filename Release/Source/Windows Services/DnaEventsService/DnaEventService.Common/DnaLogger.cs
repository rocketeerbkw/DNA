using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace DnaEventService.Common
{
    public class DnaLogger : IDnaLogger
    {
        #region IDnaLogger Members

        void IDnaLogger.Write(LogEntry log)
        {
            Microsoft.Practices.EnterpriseLibrary.Logging.Logger.Write(log);
        }

        #endregion
    }
}