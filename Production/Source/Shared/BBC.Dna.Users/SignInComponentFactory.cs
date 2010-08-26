using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using DnaIdentityWebServiceProxy;

namespace BBC.Dna.Users
{
    /// <summary>
    /// Factory class
    /// </summary>
    public class SignInComponentFactory
    {
        /// <summary>
        /// This creates the specified sign in system component
        /// </summary>
        /// <param name="connectionString">The connection string for the component</param>
        /// <param name="signInSystem">Which signin system to create the component to talk to</param>
        /// <returns>The new signin component</returns>
        public static IDnaIdentityWebServiceProxy CreateSignInComponent(string connectionString, SignInSystem signInSystem)
        {
            try
            {
                if (signInSystem == SignInSystem.Identity)
                {
                    return new DnaIdentityWebServiceProxy.IdentityRestSignIn(connectionString, "");
                }
#if DEBUG
                else if (signInSystem == SignInSystem.DebugIdentity)
                {
                    return new DnaIdentityWebServiceProxy.IdentityDebugSigninComponent(connectionString);
                }
#endif
                else
                {
                    throw new Exception("SSO Signin model nolonger supported!!");
                }
            }
            catch (Exception Ex)
            {
                throw Ex;
            }
        }
    }
}
