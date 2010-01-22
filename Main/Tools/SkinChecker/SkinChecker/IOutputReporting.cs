using System;
using System.Collections.Generic;
using System.Text;

namespace SkinsChecker
{
    /// <summary>
    /// Interface for providing Output Reporting.
    /// </summary>
    public interface IOutputReporting
    {
        void WriteOutputText(string text);
        void SetRunningText(string text);
        string LogFileDirectory { get; }
    }
}
