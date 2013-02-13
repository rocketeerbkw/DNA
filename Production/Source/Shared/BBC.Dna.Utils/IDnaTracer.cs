using System;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Tracer Interface
    /// </summary>
    public interface IDnaTracer : IDisposable
    {
        void Write(object message, string category);
        void Write(LogEntry logEntry);
    }
}
