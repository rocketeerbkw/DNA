using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Configuration;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// An implementation of IDnaDiagnostics that supports diagnostic output,
    /// such as writing to a log file
    /// </summary>
    public class DnaDiagnostics : IDnaDiagnostics
    {
        #region Static Methods
        private static DnaDiagnostics _default = null;
        public static DnaDiagnostics Default
        {
            get
            {
                if (_default == null)
                {
                    _default = new DnaDiagnostics(0, DateTime.Now);
                }
                return _default;
            }
        }
        #endregion


        /// <summary>
        /// <para>
        /// Should be called before any instances of this object are created or
        /// any of the other static methods are called
        /// </para>
        /// <para>
        /// Failing to call this will result in no log file output being written
        /// </para>
        /// </summary>
        /// <param name="inputLogFilePath">The folder to create log files in</param>
        public static void Initialise(string inputLogFilePath,  string listenerName)
        {
            TimestampTextWriterTraceListener.CreateListener(inputLogFilePath, listenerName);
        }

        /// <summary>
        /// Optionally call on application shut-down
        /// </summary>
        public static void Deinitialise()
        {
            TimestampTextWriterTraceListener.RemoveListener();
        }

        private static void Trace(string logLine)
        {
            System.Diagnostics.Trace.WriteLine(logLine);
        }

        /// <summary>
        /// Writes the header block to the log
        /// </summary>
        /// <param name="message">A message to accompany the header block</param>
        /// <remarks>Designed to be called once, at application start-up</remarks>
        public static void WriteHeader(string message)
        {
            Trace("");
            Trace("<!-- ==================================================== -->");
            Trace(TagHeaderStart);
            Trace(TagDateTime(DateTime.Now));
            Trace(TagMessage(message));
            Trace(TagHeaderEnd);
        }

        private int _requestId;
        private DateTime _requestStartTime;
        private DateTime _lastLogTimerEvent;
        private DateTime _lastSignInTimerEvent;

        /// <summary>
        /// <para>Creates a DnaDiagnostic object with a given request ID and request start time.</para>
        /// 
        /// <para>This constructor is designed to be used to provide diagnostics at the per-request level</para>
        /// </summary>
        /// 
        /// <param name="requestId">An ID that identifies the associated request</param>
        /// <param name="requestStart">The time the request started</param>
        /// 
        /// <remarks>
        /// The first time you call WriteTimedEventToLog() after construction, the "event time"
        /// written will be difference between the current time and the request start time
        /// </remarks>
        /// <see cref="WriteTimedEventToLog"/>
        public DnaDiagnostics(int requestId, DateTime requestStart)
        {
            _requestId = requestId;
            _requestStartTime = requestStart;
            _lastLogTimerEvent = requestStart;
            _lastSignInTimerEvent = requestStart;
        }

        /// <summary>
        /// Base helper method that does the high-level log line XML mark-up
        /// </summary>
        /// <param name="category">The category passed into the calling method</param>
        /// <param name="text">The text to log</param>
        private void WriteToLogBase(string category, string text)
        {
            string logLine = TagStartLog + TagRequestID(_requestId) + TagDateTime(DateTime.Now);
            logLine += TagCategory(category) + text + TagEndLog;
            Trace(logLine);
        }

        /// <summary>
        /// Writes the given message to the log
        /// </summary>
        /// <param name="category">A user-defined category that this message logically belongs to</param>
        /// <param name="message">The message to write.</param>
        public void WriteToLog(string category, string message)
        {
            WriteToLogBase(category, TagMessage(message));
        }

        /// <summary>
        /// Writes a warning to the log
        /// </summary>
        /// <remarks>
        /// <para>
        /// Warnings are events that you feel should be noted but don't cause problems with the functionality of DNA.
        /// </para>
        /// <para>
        /// Be sure that what you are reporting is really a warning, and not an Exception
        /// </para>
        /// </remarks>
        /// <param name="subcategory">The sub category for warning</param>
        /// <param name="message">The warning message to write</param>
        public void WriteWarningToLog(string subcategory, string message)
        {
            message = TagSubcategory(subcategory)+TagMessage(message);
            WriteToLogBase("Warning", message);
        }


        /// <summary>
        /// Writes a timed event to the log
        /// 
        /// This is similar to WriteToLog(), but also includes two times:
        ///     1) The current accumulative time since the IDnaDiagnostics object was created
        ///     2) The time since that last call to WriteTimedEventToLog()
        /// </summary>
        /// 
        /// <remarks>
        /// When using the InputContext.DnaDiagnostics object, time 1) equates to the total time for
        /// the current request
        /// </remarks>
        /// 
        /// <param name="category">A user-defined category that this message logically belongs to</param>
        /// <param name="message">The message to write.</param>
        /// <see cref="WriteToLog"/>
        public void WriteTimedEventToLog(string category, string message)
        {
            //Calc culmative request time.
            DateTime now = DateTime.Now;

            // Convert elapsed Ticks to milliseconds
            long requestTime = (now.Ticks - _requestStartTime.Ticks) / 10000;
            long lastEventTime = (now.Ticks - _lastLogTimerEvent.Ticks) / 10000;

            string text = TagMessage(message);
            text += TagRequestTime(requestTime) + TagEventTime(lastEventTime);

            WriteToLogBase(category,text);

            // Record the new last log timer event
            _lastLogTimerEvent = now;
        }

        /// <summary>
        /// Writes a timed event to the log
        /// 
        /// This is similar to WriteToLog(), but also includes two times:
        ///     1) The current accumulative time since the IDnaDiagnostics object was created
        ///     2) The time since that last call to WriteTimedSignInEventToLog()
        /// </summary>
        /// 
        /// <remarks>
        /// When using the InputContext.DnaDiagnostics object, time 1) equates to the total time for
        /// the current request
        /// </remarks>
        /// 
        /// <param name="signInMethod">The signin system to be timed</param>
        /// <param name="message">The message to write.</param>
        /// <see cref="WriteToLog"/>
        public void WriteTimedSignInEventToLog(string signInMethod, string message)
        {
            //Calc culmative request time.
            DateTime now = DateTime.Now;

            // Convert elapsed Ticks to milliseconds
            long requestTime = (now.Ticks - _requestStartTime.Ticks) / 10000;
            long lastEventTime = (now.Ticks - _lastSignInTimerEvent.Ticks) / 10000;

            string text = TagMessage(message);
            text += TagRequestTime(requestTime) + TagEventTime(lastEventTime);

            WriteToLogBase(signInMethod, text);

            // Record the new last log timer event
            _lastSignInTimerEvent = now;
        }


        /// <summary>
        /// Writes the exception to the log
        /// </summary>
        /// <param name="ex">The exception that was raised</param>
        public void WriteExceptionToLog(Exception ex)
        {
            string text = NL + TagExpType(ex) + NL + TagMessage(ex.ToString()) + NL;
            if (ex.Data != null)
            {
                foreach (DictionaryEntry de in ex.Data)
                {
                    text += TagExpData(de) + NL;
                }
            }
            WriteToLogBase("Exception", text);
        }

        /// <summary>
        /// Writes information about the given request to the log.
        /// </summary>
        /// <param name="request">An HttpRequest</param>
        public void WriteRequestToLog(IRequest request)
        {
            string url = request.RawUrl;
            string formData = request.Form.ToString();
            string ip = request.ServerVariables["REMOTE_HOST"];

            string text = TagUrl(url) + TagFormData(formData) + TagIp(ip);

            WriteToLogBase("Open", text);
        }

		/// <summary>
		/// <see cref="IDnaDiagnostics"/>
		/// </summary>
		public int ElapsedMilliseconds
		{
			get
			{
				return (int)((DateTime.Now.Ticks - _requestStartTime.Ticks) / 10000);
			}
		}

        #region Tagging implementation

        private const string TagStartLog = "<l>";
        private const string TagEndLog = "</l>";
        private const string TagHeaderStart = "<header>";
        private const string TagHeaderEnd = "</header>";

        private static string TagRequestID(int id)
        {
            return "<r>" + id.ToString() + "</r>";
        }

        private static string TagDateTime(DateTime dt)
        {
            return "<dt>" + dt.ToString("yyyy-MM-dd.HH:mm:ss") + "</dt>";
        }

        private static string TagCategory(string cat)
        {
            return "<cat>" + StringUtils.EscapeAllXml(cat) + "</cat>";
        }

        private static string TagSubcategory(string cat)
        {
            return "<subcat>" + StringUtils.EscapeAllXml(cat) + "</subcat>";
        }

        private static string TagMessage(string message)
        {
            return "<msg>" + StringUtils.EscapeAllXml(message) + "</msg>";
        }

        private static string TagRequestTime(long reqTime)
        {
            return "<reqt>" + reqTime.ToString() + "</reqt>";
        }

        private static string TagEventTime(long eventTime)
        {
            return "<eventt>" + eventTime.ToString() + "</eventt>";
        }

        private static string TagUrl(string url)
        {
            return "<url>" + StringUtils.EscapeAllXml(url) + "</url>";
        }

        private static string TagFormData(string formData)
        {
            if (formData.Length > 0)
            {
                return "<fd>" + StringUtils.EscapeAllXml(formData) + "</fd>";
            }

            return string.Empty;
        }

        private static string TagIp(string ip)
        {
            return "<ip>" + StringUtils.EscapeAllXml(ip) + "</ip>";
        }

        private static string TagExpType(Exception ex)
        {
            return "<extype>" + StringUtils.EscapeAllXml(ex.GetType().ToString()) + "</extype>";
        }

        private static string TagExpData(DictionaryEntry de)
        {
            string text = "<exdata key='" + StringUtils.EscapeAllXmlForAttribute(de.Key.ToString()) + "'>";
            text += StringUtils.EscapeAllXml(de.Value.ToString());
            text += "</exdata>";
            return text;
        }

        /// <summary>
        /// I got fed up writing System.Environment.NewLine!
        /// </summary>
        private string NL
        {
            get { return System.Environment.NewLine; }
        }

        #endregion
    }
}
