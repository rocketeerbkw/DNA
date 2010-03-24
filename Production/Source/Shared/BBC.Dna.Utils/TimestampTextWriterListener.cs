using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.IO;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// Our specialisation of TextWriterTraceListener for writing to log files
    /// </summary>
    public class TimestampTextWriterTraceListener : TextWriterTraceListener
    {
        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener()
            : base()
        {
        }

        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener(Stream stream)
            : base(stream)
        {
        }

        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener(string path)
            : base(path)
        {
        }

        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener(TextWriter writer)
            : base(writer)
        {
        }

        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener(Stream stream, string name)
            : base(stream, name)
        {
        }

        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener(string path, string name)
            : base(path, name)
        {
        }

        /// <summary>
        /// Calls base implementation
        /// </summary>
        /// <see cref="TextWriterTraceListener"/>
        public TimestampTextWriterTraceListener(TextWriter writer, string name)
            : base(writer, name)
        {
        }

        /// <summary>
        /// Helper function for creating the correctly formatted log file name
        /// </summary>
        /// <param name="rootPath">The folder the file lives in</param>
        /// <returns>The full file path for the current log file</returns>
        /// <remarks>The file name changes every hour currently</remarks>
        private static string CreateLogFileName(string rootPath)
        {
            return rootPath + "dnalog-" + DateTime.Now.ToString("yyyyMMddHH") + ".log";
        }

        private static Stream CreateStream(string logFile)
        {
            return System.IO.File.Open(logFile, FileMode.Append, FileAccess.Write, FileShare.ReadWrite);
        }

        private static string _rootPath;

        /// <summary>
        /// Creates an instance of TimestampTextWriterTraceListener, and registers as a Trace Listener
        /// </summary>
        /// <param name="rootPath">The folder to store log files</param>
        public static void CreateListener(string rootPath, string listenerName)
        {
            _rootPath = rootPath;

            string logFile = CreateLogFileName(rootPath);

            // Create a new text writer using the output stream, and add it to the trace listeners.
            System.Diagnostics.TextWriterTraceListener TextListener = new TimestampTextWriterTraceListener(logFile);
            TextListener.Name = listenerName;

            // We don't set the System.Diagnostics.TraceOptions.Timestamp in TraceOutputOptions because it is not implement
            // dispite what the documentation may say!

            Trace.Listeners.Add(TextListener);
            Trace.AutoFlush = true;
        }

        /// <summary>
        /// Removes the listener from the list of Trace listeners
        /// </summary>
        public static void RemoveListener()
        {
            Trace.Listeners.Remove("dnalogger");
        }

        private string _currentLogFile = String.Empty;

        /// <summary>
        /// Private object used solely for serialising the switching of the underlying log
        /// file before writing
        /// </summary>
        private object changeLogFileLock = new object();

        /// <summary>
        /// <para>Writes a line to the underlying log file</para>
        /// <para>
        /// If the underlying file needs to change, for example because it's gone passed a time boundary,
        /// the old file is closed, and the new one is created
        /// </para>
        /// </summary>
        /// <param name="message">The message to write to the log file</param>
        public override void WriteLine(string message)
        {
            string logFile = CreateLogFileName(_rootPath);

            lock (changeLogFileLock)
            {
                // Has the log file name changed?
                if (_currentLogFile != logFile)
                {
                    // Close down the old one ---- if we have one
                    TextWriter oldWriter = this.Writer;
                    if (oldWriter != null)
                    {
                        oldWriter.Close();
                    }

                    // Assign the new one
                    this.Writer = new StreamWriter(CreateStream(logFile));
                    _currentLogFile = logFile;
                }
            }

            base.WriteLine(message);
        }
    }
}
