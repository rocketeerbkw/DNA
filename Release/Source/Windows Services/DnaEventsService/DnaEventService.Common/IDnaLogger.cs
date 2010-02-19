using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace DnaEventService.Common
{
    /// <summary>
    /// Interace to abstract logging
    /// </summary>
    public interface IDnaLogger
    {
        void Write(LogEntry log);
    }
}