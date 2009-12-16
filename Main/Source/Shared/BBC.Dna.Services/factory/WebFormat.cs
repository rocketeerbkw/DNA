using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel.Web;
using BBC.Dna.Utils;
using BBC.Dna.Api;
using BBC.Dna.Sites;

namespace BBC.Dna.Services
{

    public class WebFormat
    {
        public enum format {
            //Xml format
            XML,
            /// <summary>
            /// The JavaScript Object Notation (JSON) format
            /// </summary>
            JSON,
            /// <summary>
            /// HTML format
            /// </summary>
            HTML,
            /// <summary>
            /// RSS format
            /// </summary>
            RSS,
            /// <summary>
            /// ATOM format
            /// </summary>
            ATOM, 
            ///Unknown or not specificed
            UNKNOWN};

        /// <summary>
        /// takes the input content type and quertystring and determines the output type and format
        /// </summary>
        /// <param name="inputContentType">The input content type - e.g. text/xml</param>
        /// <param name="outputContentType">The output content type - e.g text/xml</param>
        /// <param name="outputFormat">The format as an enum</param>
        public static void getReturnFormat(string inputContentType, ref string outputContentType, ref format outputFormat)
        {
            try
            {
                string queryFormat = QueryStringHelper.GetQueryParameterAsString("format", "").ToUpper();
                if (!String.IsNullOrEmpty(queryFormat))
                {
                    outputFormat = (format)Enum.Parse(typeof(format), queryFormat);
                }
            }
            catch
            {
                outputFormat = format.UNKNOWN;
                outputContentType = "";
                return;
            }

            if (outputFormat == format.UNKNOWN)
            {
                switch (inputContentType.ToLower())
                {
                    case "text/xml": outputFormat = format.XML; break;
                    case "application/rss xml": outputFormat = format.RSS; break;
                    case "application/atom xml": outputFormat = format.ATOM; break;
                    case "application/xml": outputFormat = format.XML; break;
                    case "application/json": outputFormat = format.JSON; break;
                    case "text/javascript": outputFormat = format.JSON; break;
                    case "text/html": outputFormat = format.HTML; break;
                    case "application/x-www-form-urlencoded": outputFormat = format.HTML; break;
                    default:
                        outputFormat = format.XML;
                        inputContentType = "text/xml";
                        break;
                }
            }

            if (String.IsNullOrEmpty(outputContentType))
            {
                switch (outputFormat)
                {
                    case format.XML: outputContentType = "text/xml"; break;
                    case format.JSON: outputContentType = "text/javascript"; break;
                    case format.HTML: outputContentType = "text/HTML"; break;
                    case format.RSS: outputContentType = "application/rss xml"; break;
                    case format.ATOM: outputContentType = "application/atom xml"; break;
                    default: outputContentType = "text/xml"; break;
                }
            }
            

        }

        /// <summary>
        /// Generates a PTRT with a given resultType
        /// </summary>
        /// <param name="error">The error</param>
        /// <returns>The PTRT</returns>
        public static string GetPtrtWithResponse(string errorCode)
        {
            string ptrt = QueryStringHelper.GetHeaderValueAsString("referer", "");
            string queryPtrt = QueryStringHelper.GetQueryParameterAsString("ptrt", "");
            if (!String.IsNullOrEmpty(queryPtrt))
            {//use a passed in ptrt if there
                ptrt = queryPtrt;
            }

            try
            {
                //return success on ptrt
                if (String.IsNullOrEmpty(ptrt))
                {//if no ptrt then use parentUri
                    return string.Empty;
                }
                string hashValue = String.Empty;
                if (ptrt.IndexOf("#") >= 0)
                {//get the #anchor and save for later
                    hashValue = ptrt.Substring(ptrt.IndexOf("#"), ptrt.Length - ptrt.IndexOf("#"));
                    ptrt = ptrt.Replace(hashValue, "");
                }
                if (ptrt.IndexOf("?") < 0)
                {//add ? if required
                    ptrt += "?";
                }
                else
                {
                    ptrt += "&";
                }
                ptrt += "resultCode=" + errorCode + hashValue;
            }
            catch
            {
                ptrt = string.Empty;
            }
            return ptrt;
        }
    }
}
