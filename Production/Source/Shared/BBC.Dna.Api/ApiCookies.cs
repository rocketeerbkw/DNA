using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel.Web;
using BBC.Dna.Users;
using BBC.Dna.Utils;
using System.Configuration;

namespace BBC.Dna.Api
{
    public class ApiCookies
    {
        /// <summary>
        /// Helper method for getting the signin cookie value. Either SSO2-UID or IDENTITY
        /// </summary>
        /// <param name="signInType">The type of signin cookie to get</param>
        /// <returns>The signin cookie value if found, empty if not</returns>
        public static string GetSignInCookieValue(SignInSystem signInType)
        {
            WebOperationContext webContext = WebOperationContext.Current;
            string cookiesstring = webContext.IncomingRequest.Headers["cookie"];
            string[] cookies = cookiesstring.Split(';');
            string cookie = "";
            foreach (string s in cookies)
            {
                if (signInType == SignInSystem.Identity)
                {
                    if (s.Trim().ToLower().StartsWith("identity") && !s.Trim().ToLower().StartsWith("identity-"))
                    {
                        cookie = s.Split('=')[1];
                        break;
                    }
                }
                else
                {
                    if (s.Trim().ToLower().StartsWith("sso2-uid"))
                    {
                        cookie = s.Split('=')[1];
                        break;
                    }
                }
            }
            return cookie;
        }

        /// <summary>
        /// Helper method for checking the BBCUID
        /// </summary>
        /// <param name="cookie">The cookie to check</param>
        /// <param name="result">The guid of cookie to check</param>
        /// <returns>The cookie value corrected</returns>
        public static bool CheckGUIDCookie(string cookie, ref Guid result)
        {
            if (cookie.Length < 64)
            {
                return false;
            }

            StringBuilder hashbuilder = new StringBuilder(32);
            StringBuilder uidbuilder = new StringBuilder(32);
            int i;
            for (i = 0; i < 64; i += 2)
            {
                hashbuilder.Append(cookie[i]);
                uidbuilder.Append(cookie[i + 1]);
            }
            string uid = uidbuilder.ToString();
            string hash = hashbuilder.ToString();

            // Now get the logged in status, if there are 
            string loggedIn = string.Empty;
            if (i < cookie.Length)
            {
                loggedIn = cookie[i++].ToString();
            }

            // Get the Browser info, making sure we unescape it!
            string sBrowserInfo = string.Empty;
            if (i < cookie.Length)
            {
                sBrowserInfo = Uri.UnescapeDataString(cookie.Substring(i));
            }

            string secretKey = ConfigurationManager.AppSettings["SecretKey"];
            // Now reencrypt the UID, LoggedIn and Browser Info to see if it matches the Hash value given
            string toHash = string.Concat(uid, loggedIn, sBrowserInfo, secretKey);
            string thehash = DnaHasher.GenerateHashString(toHash);
            thehash = DnaHasher.GenerateHashString(secretKey + thehash);
            if (thehash != hash)
            {
                return false;
            }

            for (int n = 0; n < uid.Length; n++)
            {
                if (uid[n] < '0' || uid[n] > 'f' || (uid[n] > '9' && uid[n] < 'a'))
                {
                    return false;
                }
            }
            result = new Guid(uid);
            return true;
        }
    }
}
