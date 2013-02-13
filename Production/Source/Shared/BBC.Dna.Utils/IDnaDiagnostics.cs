using System;
using Microsoft.Practices.EnterpriseLibrary.Logging;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// The interface for helping with all diagnostics within DNA
    /// Currently this only supports logging of significant event.  It could be easily
    /// extended to support program counters, statistics collection, etc.
    /// </summary>
    public interface IDnaDiagnostics
    {
        /// <summary>
        /// Writes the given message to the log
        /// </summary>
        /// <param name="category">A user-defined category that this message logically belongs to</param>
        /// <param name="message">The message to write.</param>
        void WriteToLog(string category, string message);

        /// <summary>
        /// Writes a warning to the log
        /// </summary>
        /// <remarks>
        /// <para>
        /// Warnings are events that you feel should be noted but don't cause problems with the functionality of DNA.
        /// They have the category "Warning", and a subcategory that you specify
        /// </para>
        /// <para>
        /// Be sure that what you are reporting is really a warning, and not an Exception
        /// </para>
        /// </remarks>
        /// <param name="subcategory">The sub category for warning</param>
        /// <param name="message">The warning message to write</param>
        void WriteWarningToLog(string subcategory, string message);

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
        void WriteTimedEventToLog(string category, string message);

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
        void WriteTimedSignInEventToLog(string signInMethod, string message);
        
        /// <summary>
        /// Writes the exception to the log
        /// </summary>
        /// <param name="ex">The exception that was raised</param>
        void WriteExceptionToLog(Exception ex);

        /// <summary>
        /// Writes information about the given request to the log.
        /// </summary>
        /// <param name="request">An HttpRequest</param>
        void WriteRequestToLog(IRequest request);

		/// <summary>
		/// The total elapsed time for this request in milliseconds
		/// </summary>
		int ElapsedMilliseconds
		{
			get;
		}

        /// <summary>
        /// The create Tracer Method. Used for tracing output
        /// </summary>
        /// <param name="traceNameSpace">The namespace you want the tracing to appear as</param>
        /// <returns>New Tracer object</returns>
        IDnaTracer CreateTracer(string traceNameSpace);
    }
}
