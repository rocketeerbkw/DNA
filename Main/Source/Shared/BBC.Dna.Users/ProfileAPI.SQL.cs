using System;
namespace DnaIdentityWebServiceProxy
{
    /// <summary>
    /// Partical class for the ProfileAPI SQL commands
    /// </summary>
    public partial class ProfileAPI : System.Object
    {
        /// <summary>
        /// Returns the last piece of timing information
        /// </summary>
        /// <returns>The information for the last timed logging</returns>
        public string GetLastTimingInfo()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }

        /// <summary>
        /// This function closes the read connection if it already open
        /// </summary>
        public void CloseConnections()
        {
            throw new NotSupportedException("The ProfileAPI is nolonger supported! Switch to using Identity.");
        }
    }
}
