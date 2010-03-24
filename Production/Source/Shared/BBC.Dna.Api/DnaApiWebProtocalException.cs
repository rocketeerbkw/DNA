using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using Microsoft.ServiceModel.Web;
using System.ServiceModel.Web;

namespace BBC.Dna.Api
{
    public class DnaApiWebProtocalException
    {
        /// <summary>
        /// Throws a new WebProtocalException. Debug builds throw the exception along with the description and inner exception, release builds
        /// only throw the statusCode.
        /// </summary>
        /// <param name="statusCode">The status code you want the exception to contain</param>
        /// <param name="statusDescription">The description of the exception</param>
        /// <param name="innerException">The origninal exception you caught if any</param>
        public static void ThrowDnaApiWebProtocalException(HttpStatusCode statusCode, string statusDescription, Exception innerException)
        {
#if DEBUG
            // Throw with everything
            string error = statusDescription + "<br/>";
            if (innerException != null)
            {
                error += "<b>Error : </b>" + innerException.Message + "<br/>";
                error += "<b>Located : </b>" + innerException.StackTrace + "<br/><br/>";
                if (innerException.InnerException != null)
                {
                    error += "<b>Inner Exception</b><br/>";
                    error += "<b>Error : </b>" + innerException.InnerException.Message + "<br/>";
                    error += "<b>Located : </b>" + innerException.InnerException.StackTrace + "<br/>";
                }
            }
            throw new WebProtocolException(statusCode, statusDescription, innerException);
#else
            // Throw with status code only
            throw new WebProtocolException(statusCode, statusDescription, innerException);
#endif
        }
    }
}
