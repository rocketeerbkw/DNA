using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel.Web;
using System.Web;

namespace BBC.Dna.Utils
{
    public class QueryStringHelper
    {
        public static bool GetQueryParameterAsBool(string parameterName, bool defaultValue)
        {
            WebOperationContext webContext = WebOperationContext.Current;
            bool retVal = defaultValue;

            try
            {
                retVal = bool.Parse(webContext.IncomingRequest.UriTemplateMatch.QueryParameters[parameterName]);
            }
            catch (Exception)
            {
            }
            return retVal;
        }

        public static int GetQueryParameterAsInt(string parameterName, int defaultValue)
        {
            WebOperationContext webContext = WebOperationContext.Current;
            int retVal = defaultValue;

            try
            {
                retVal = int.Parse(webContext.IncomingRequest.UriTemplateMatch.QueryParameters[parameterName]);
            }
            catch (Exception)
            {
            }
            return retVal;
        }

        public static string GetQueryParameterAsString(string parameterName, string defaultValue)
        {
            WebOperationContext webContext = WebOperationContext.Current;
            string retVal = defaultValue;

            try
            {
                string value = webContext.IncomingRequest.UriTemplateMatch.QueryParameters[parameterName];
                if (value != null)
                {
                    retVal = value;
                }
            }
            catch (Exception)
            {
            }
            return retVal;
        }

        /// <summary>
        /// Returns Cookie Value as integer
        /// </summary>
        /// <param name="parameterName">The parameter name</param>
        /// <param name="defaultValue">The defautl value</param>
        /// <returns>The cookie value or default</returns>
        public static int GetCookieValueAsString(string parameterName, int defaultValue)
        {
            int retVal = defaultValue;

            try
            {
                WebOperationContext webContext = WebOperationContext.Current;
                string cookiesstring = webContext.IncomingRequest.Headers["cookie"];
                string[] cookies = cookiesstring.Split(';');
                string cookie = "";
                foreach (string s in cookies)
                {
                    string[] cookieKV = s.Split('=');
                    if (cookieKV.Length == 2)
                    {
                        if (cookieKV[0].Trim().ToLower() == parameterName.ToLower())
                        {
                            cookie = cookieKV[1];
                            retVal = int.Parse(cookie);
                            break;
                        }
                    }
                 }
                
            }
            catch (Exception)
            {
            }
            return retVal;
        }

        /// <summary>
        /// Returns Cookie Value as integer
        /// </summary>
        /// <param name="parameterName">The parameter name</param>
        /// <param name="defaultValue">The defautl value</param>
        /// <returns>The cookie value or default</returns>
        public static string GetCookieValueAsString(string parameterName, string defaultValue)
        {
            string retVal = defaultValue;

            try
            {
                WebOperationContext webContext = WebOperationContext.Current;
                string cookiesstring = webContext.IncomingRequest.Headers["cookie"];
                string[] cookies = cookiesstring.Split(';');
                string cookie = "";
                foreach (string s in cookies)
                {
                    string[] cookieKV = s.Split('=');
                    if (cookieKV.Length == 2)
                    {
                        if (cookieKV[0].Trim().ToLower() == parameterName.ToLower())
                        {
                            cookie = cookieKV[1];
                            retVal = HttpUtility.UrlDecode(cookie);
                            break;
                        }
                    }
                }
                
            }
            catch (Exception)
            {
            }
            return retVal;
        }

        /// <summary>
        /// Returns Cookie Value as integer
        /// </summary>
        /// <param name="parameterName">The parameter name</param>
        /// <param name="defaultValue">The default value</param>
        /// <returns>The cookie value or default</returns>
        public static string GetHeaderValueAsString(string parameterName, string defaultValue)
        {
            string retVal = defaultValue;

            try
            {
                WebOperationContext webContext = WebOperationContext.Current;
                retVal = webContext.IncomingRequest.Headers[parameterName];
                

            }
            catch (Exception)
            {
            }
            return retVal;
        }
    }
}
