
using System.Diagnostics;   
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Web.Hosting; 
using System.Xml;
using System.Web;
using System;
using System.Runtime.Serialization;
using BBC.Dna.Page;
using NUnit.Framework;

namespace Tests
{
    /// <summary>
    /// Overide of SimpleWorker Request which in turn overrides HttpRequest.
    /// This class is passed to HTTPRunTime::ProcessRequest() and marks the start of the Http pipeline.
    /// HttpRunTime::ProcessRequest will use this class to create the HttpContext to service the request.
    /// Relevant Documentation: Host ASP.NET outside IIS:
    /// http://msdn.microsoft.com/msdnmag/issues/04/12/ServiceStation/
    /// Documentation http://www.west-wind.com/presentations/aspnetruntime/aspnetruntime.asp
    /// </summary>
    public class wwWorkerRequest : SimpleWorkerRequest
    {
        private byte[] _postData = null;
        private string _postContentType = "application/x-www-form-urlencoded";
        private string _cookies = "";

        /// <summary>
        /// String containing cookies.
        /// Expected to be in the form of ; separated name value pairs. cookiename=value;cookiename=value.......
        /// </summary>
        /// <param>Semi colon separated cookie name value pairs</param>
        public void SetCookies(string cookies)
        {
            _cookies = cookies;
        }

        /// <summary>
        /// This class creates an App Domaina for hosting ASP.NET 
        /// This allows requests to be tested in a test environment with a test configuration.
        /// </summary>
        public object ParameterData = null; // object to pass

        /// <summary>
        /// Constructor taking asp page, query string.
        /// <param name="Output">Output of processed asp page</param>
        /// <param name="Page">Page to process</param>
        /// <param name="QueryString">Input Parameters</param>
        /// </summary>
        public wwWorkerRequest(string Page, string QueryString, TextWriter Output)
            : base(Page, QueryString, Output) { }

        /// <summary>
        /// This method is called by ASP.NET when the HttpContext has been created and initialised from the worker process
        /// and just before the request is processed.
        /// This gives an opportunity for the HttpContext to be modified before processing or for data
        /// to be passed into the ASP.NET AppDomain prior to request processing
        /// <param name="callback">CallBack</param>
        /// <param name="extraData">HttpContext</param>
        /// </summary>
        public override void SetEndOfSendNotification(EndOfSendNotification callback, object extraData)
        {
            base.SetEndOfSendNotification(callback, extraData);

            //Set the cookie we want.
            //Another way to do this would be to override GetKnownRequestHandler(HttpWorkerRequest.CookieHeader) to return a cookie header.
            HttpContext context = extraData as HttpContext;
           
            if (this.ParameterData != null)
            {
                // *** Add any extra data here to the 
                //context.Items.Add("Content", this.ParameterData);
            }
        }

        /// <summary>
        /// Method Allows Post Data to be specified for the Request.
        /// </summary>
        public override String GetHttpVerbName()
        {
            if (this._postData == null)
            {
                return base.GetHttpVerbName();
            }
            return "POST";
        }

        /// <summary>
        /// Method is called by ASP.NET to get standard header info.
        /// If Post Header is requested return post data if specified.
        /// <param name="index">Framework Index for Post Header</param>
        /// </summary>
        public override string GetKnownRequestHeader(int index)
        {
            if (index == HttpWorkerRequest.HeaderContentLength)
            {
                if (this._postData != null)
                    return this._postData.Length.ToString();
            }
            else if (index == HttpWorkerRequest.HeaderContentType)
            {
                if (this._postData != null)
                    return this._postContentType;
            }
            else if (index == HttpWorkerRequest.HeaderCookie)
            {
                return _cookies;
            }
            return base.GetKnownRequestHeader(index);
        }

        /// <summary>
        /// Returns the actual post data if post header indicated.
        /// </summary>
        public override byte[] GetPreloadedEntityBody()
        {
            if (this._postData != null)
                return this._postData;
            return base.GetPreloadedEntityBody();
        }
    }

    /// <summary>
    /// This class creates an App Domaina for hosting ASP.NET 
    /// This allows requests to be tested in a test environment with a test configuration.
    /// This class will be created in the App Domain hosting ASP.NET by CreateApplicationHost. 
    /// This class is used to communicate with the App Domain hosting ASP.NET.
    /// Need to install assembly in physical path / bin dir or in GAC - Global Assembly Cache.
    /// </summary>
    public class Host : MarshalByRefObject
    {
        private StringWriter _outputWriter = null;
        private wwWorkerRequest _workerRequest = null;

        /// <summary>
        /// Gets the last response as a string
        /// </summary>
        public string ResponseString
        {
            get { return _outputWriter.ToString(); }
        }

        /// <summary>
        /// Gets the worker request object
        /// </summary>
        public string WorkerRequestHeader
        {
            get { return _workerRequest.GetKnownRequestHeader(0); }
        }

        /// <summary>
        /// Static method creates the AppDomain for hosting ASP.NET.
        /// This class acts as a bridge across to the ASP.NET App Domain.
        /// </summary>
        public static Host Create( string physicalDir )
        {   
            // return (Host)ApplicationHost.CreateApplicationHost(typeof(Host), "/", Directory.GetCurrentDirectory()); 
            Host host = (Host)ApplicationHost.CreateApplicationHost(typeof(Host),"/", physicalDir );

            return host;
        }

        /// <summary>
        /// Process Request in the ASP.NET App Domain.
        /// HttpRunTime.Processequest() marks the start of the HttpPipeLine.
        /// </summary>
        public void ProcessRequest(string page, string query, string cookies )
        {
            // Create the output writer
            if (_outputWriter != null)
            {
                _outputWriter.Dispose();
                _outputWriter = null;
            }
            _outputWriter = new StringWriter();

            // Now process the request
            if (_workerRequest != null)
            {
                _workerRequest = null;
            }
            _workerRequest = new wwWorkerRequest(page, query, _outputWriter);
            _workerRequest.SetCookies(cookies);
            HttpRuntime.ProcessRequest(_workerRequest);
        }

        /*public static void SetUp()
        {
            //Copy any test dll files to bin directory.
            Directory.CreateDirectory(tempBinPath);
            foreach (string file in Directory.GetFiles(tempPath, "*.dll"))
            {
                string newFile = Path.Combine(tempBinPath, Path.GetFileName(file));
                if (File.Exists(newFile))
                {
                    File.Delete(newFile);
                }
                File.Copy(file, newFile);
            }

            //Copy aspx files to current dir
            foreach (string file in Directory.GetFiles(aspxPath, "*.aspx"))
            {
                string newFile = Path.Combine(tempPath, Path.GetFileName(file));
                if (File.Exists(newFile))
                {
                    File.Delete(newFile);
                }

                File.Copy(file, newFile);
            }

            //Copy any dlls to bin directory
            foreach (string file in Directory.GetFiles(aspxPath, "*.dll"))
            {
                string newFile = Path.Combine(tempBinPath, Path.GetFileName(file));
                if (File.Exists(newFile))
                {
                    File.Delete(newFile);
                }

                File.Copy(file, newFile);
            }
        }*/

        /// <summary>
        /// Copy the test page to dnapages 
        /// The test page can then be requested and used where it is desirable to test within the AppDomain hosting ASP.NET.
        /// </summary>
        public bool CopyPage(string filename)
        {
            //Expect test page to be in tests dir and working dir to be tests/bin/[debug or release]
            string testpage = @"..\..\" + filename;
            FileInfo fileInfo = new FileInfo(testpage);
            fileInfo.IsReadOnly = false;
            if (fileInfo.Exists)
            {
                string file = fileInfo.FullName;
                string newFile = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, filename);
                if (File.Exists(newFile))
                {
                    RemovePage(filename);
                }
                File.Copy(fileInfo.FullName, newFile);
                File.Copy(fileInfo.FullName + ".cs", newFile + ".cs");
                return true;
            }
            return false;
        }

        /// <summary>
        /// Remove a test page from asp dir after completing test.
        /// </summary>
        public bool RemovePage(string filename)
        {
            string newFile = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, Path.GetFileName(filename));
            if (File.Exists(newFile))
            {
                File.SetAttributes(newFile, FileAttributes.Normal);
                File.Delete(newFile);

                //Delete code behind file 
                if (File.Exists(newFile + ".cs"))
                {
                    File.SetAttributes(newFile + ".cs", FileAttributes.Normal);
                    File.Delete(newFile + ".cs");
                }
                return true;
            }

            return false;
        }
    }
}

   


