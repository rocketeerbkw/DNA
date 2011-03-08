using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace DnaEventService.Common
{
    public class DnaLogger : IDnaLogger
    {
        #region IDnaLogger Members

        private object _locker = new object();

        void IDnaLogger.Write(LogEntry log)
        {
            lock (_locker)
            {
                Microsoft.Practices.EnterpriseLibrary.Logging.Logger.Write(log);
            }
        }

        #endregion
    }
}