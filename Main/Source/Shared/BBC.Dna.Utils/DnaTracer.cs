using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// DNA Tracer class. Currently encapsulates the Enerprise Lib version of Trace
    /// </summary>
    public class DnaTracer : IDnaTracer
    {
        private Tracer tracer = null;

        public DnaTracer(string traceNameSpace)
        {
            tracer = new Tracer(traceNameSpace);
        }

        public void Dispose()
        {
            if (tracer != null)
            {
                tracer.Dispose();
            }
        }

        public void Write(object message, string category)
        {
            Logger.Write(message, category);
        }

        public void Write(LogEntry logEntry)
        {
            Logger.Write(logEntry);
        }
    }
}
