using System;
using System.Web;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace BBC.Dna.Services.Api
{
    /// <summary>
    /// Redirect module that allows specifying a set of .svc urls
    /// by stripping the svc extension off and accessing without it.
    /// 
    /// To use add any non-svc path segments (ie. service.svc should be service)
    /// to the ServiceMap below.
    /// 
    /// Note that any path that uses one of these service map entries needs to 
    /// end with a trailing backslash.
    /// </summary>
    public class ServiceRedirector : IHttpModule
    {

        static Regex regUrl = new Regex(@"(/dna/api)//{.+}//{.+}", RegexOptions.Compiled | RegexOptions.IgnoreCase);

        public void Dispose()
        {

        }

        public void Init(HttpApplication app)
        {
            app.BeginRequest += delegate
            {
                HttpContext ctx = HttpContext.Current;
                string path = ctx.Request.AppRelativeCurrentExecutionFilePath.ToLower();

                if (path.IndexOf(".") >= 0)
                {//contains path so don't rewrite
                    return;
                }

                //var urlStart = path.Substring

                /*foreach (string mapPath in ServiceMap)
                {
                    if (path.Contains("/" + mapPath + "/") || path.EndsWith("/" + mapPath))
                    {
                        string newPath = path.Replace("/" + mapPath + "/", "/" + mapPath + ".svc/");
                        ctx.RewritePath(newPath, null, ctx.Request.QueryString.ToString(), false);
                        return;
                    }
                }*/
            };
        }
    }
}