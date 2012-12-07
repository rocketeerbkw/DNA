using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Syndication;
using System.ServiceModel.Web;
using System.Net;
using System.IO;
using System.Runtime.Serialization;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Runtime.Serialization.Json;
using System.Web.Configuration;
using System.Diagnostics;

namespace BBC.Dna.SocialAPI
{
    public class BuzzClient : ClientBase<IBuzz>, IBuzz
    {
        #region method(s)
        /*
        public string GetProfiless()
        {
            var proxyServer = ConfigurationSettings.AppSettings["proxyserver"].ToString();
            var twitterUser = ConfigurationSettings.AppSettings["TwitterUserName"].ToString();
            var twitterPassword = ConfigurationSettings.AppSettings["TwitterPassword"].ToString();

            var response = string.Empty;

            using (WebChannelFactory<IBuzz> cfact = new WebChannelFactory<IBuzz>("BuzzProfileClient"))
            {
                Uri proxyAddress = new Uri(proxyServer);
                WebRequest.DefaultWebProxy = new WebProxy(proxyAddress);
                cfact.Credentials.UserName.UserName = "thiags01";
                cfact.Credentials.UserName.Password = "";
                
                X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                X509Certificate certificate = null;
                bool gotDevCert = false;
                var subjectName = string.Empty;
                for (int i = 0; i <= 1 && !gotDevCert; i++)
                {
                    certificate = store.Certificates.Find(X509FindType.FindBySubjectName, "dna", false)[i];
                    gotDevCert = certificate.Subject.ToLower().Contains("cn=" + "dna".ToLower() + ",");
                }
                cfact.Credentials.ClientCertificate.SetCertificate(certificate.Subject,StoreLocation.LocalMachine,StoreName.My);
                //X509Certificate certificate = store.Certificates.Find(X509FindType.FindBySubjectName, _certificateName, false)[0];
                //webRequest.ClientCertificates.Add(certificate);
                IBuzz s = cfact.CreateChannel();
                
                try
                {
                    //response = s.GetProfiles();
                }
                catch (Exception ex)
                {
                }
            }

            return response;
        }
        */

        private bool _traceOutput = true;
        private StringBuilder _callInfo = new StringBuilder();

        private void AddTimingInfoLine(string info)
        {
            if (_traceOutput)
            {
                _callInfo.AppendLine(info);
            }
            Trace.WriteLineIf(_traceOutput, info);
        }


        /// <summary>
        /// Request object formed with the certificate details
        /// </summary>
        /// <param name="uri"></param>
        /// <returns></returns>
        private HttpWebRequest GetWebRequestWithCertificateDetails(string uri)
        {
            var connectionDetails = WebConfigurationManager.ConnectionStrings["IdentityURL"].ConnectionString;
            var proxyServer = ConfigurationSettings.AppSettings["proxyserver"].ToString();

            Uri URL = new Uri(uri);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

            try
            {
                webRequest.Timeout = 30000;

                webRequest.Proxy = new WebProxy(proxyServer);

                AddTimingInfoLine("<* BUZZ CLIENT CERTIFICATE START *>");
                AddTimingInfoLine("Base URL           - " + uri);
                AddTimingInfoLine("Certificate details   - " + connectionDetails);
                AddTimingInfoLine("Proxy server       - " + proxyServer);

                string[] details = connectionDetails.Split(';');
                var certificateName = details[1];

                X509Store store = new X509Store(StoreName.My.ToString(), StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                X509Certificate certificate = null;
                bool gotDevCert = false;
                for (int i = 0; i <= 1 && !gotDevCert; i++)
                {
                    certificate = store.Certificates.Find(X509FindType.FindBySubjectName, certificateName, false)[i];
                    gotDevCert = certificate.Subject.ToLower().Contains("cn=" + certificateName + ",");
                }

                webRequest.ClientCertificates.Add(certificate);
            }
            catch (Exception e)
            {
                AddTimingInfoLine("ERROR!!! - " + e.Message);
            }
            AddTimingInfoLine("<* BUZZ CLIENT CERTIFICATE END *>");

            return webRequest;
        }

        /// <summary>
        /// Gets a list of profiles from Buzz
        /// </summary>
        /// <returns></returns>
        public BuzzTwitterProfiles GetProfiles()
        {
            var uri = ConfigurationSettings.AppSettings["BuzzProfileListAPI"].ToString();

            AddTimingInfoLine("<* BUZZ API CALL GET PROFILES START *>");
            AddTimingInfoLine("Base URL           - " + uri);

            HttpWebResponse response = null;

            HttpWebRequest webRequest = GetWebRequestWithCertificateDetails(uri);

            try
            {
                response = (HttpWebResponse)webRequest.GetResponse();
            }
            catch (Exception ex)
            {
                AddTimingInfoLine("BUZZ API CALL GET PROFILES ERROR!!! - " + ex.Message);
                throw ex;
            }
            Stream stream = response.GetResponseStream();

            AddTimingInfoLine("BUZZ API CALL GET PROFILES END");

            DataContractJsonSerializer obj = new DataContractJsonSerializer(typeof(BuzzTwitterProfiles));

            BuzzTwitterProfiles profilesObject = obj.ReadObject(stream) as BuzzTwitterProfiles;

            return profilesObject;
        }

        /// <summary>
        /// Gets a specific profile from Buzz
        /// </summary>
        /// <param name="twitterProfileId"></param>
        /// <returns></returns>
        public BuzzTwitterProfile GetProfile(string twitterProfileId)
        {
            var uri = ConfigurationSettings.AppSettings["BuzzProfileAPI"].ToString();

            uri += twitterProfileId;

            AddTimingInfoLine("<* BUZZ API CALL GET PROFILE START *>");
            AddTimingInfoLine("Base URL           - " + uri);


            HttpWebResponse response = null;

            HttpWebRequest webRequest = GetWebRequestWithCertificateDetails(uri);

            try
            {
                response = (HttpWebResponse)webRequest.GetResponse();
            }
            catch (Exception ex)
            {
                AddTimingInfoLine("BUZZ API CALL GET PROFILE ERROR!!! - " + ex.Message);
                throw ex;
            }
            Stream stream = response.GetResponseStream();

            AddTimingInfoLine("BUZZ API CALL GET PROFILE END");

            DataContractJsonSerializer obj = new DataContractJsonSerializer(typeof(BuzzTwitterProfile));

            BuzzTwitterProfile profileObject = obj.ReadObject(stream) as BuzzTwitterProfile;

            return profileObject;
        }

        /// <summary>
        /// Creates the twitter profile in Buzz
        /// </summary>
        /// <param name="twitterProfile"></param>
        /// <returns></returns>
        public string CreateUpdateProfile(BuzzTwitterProfile twitterProfile)
        {
            var resStatus = string.Empty;
            var uri = ConfigurationSettings.AppSettings["BuzzProfileAPI"].ToString();

            AddTimingInfoLine("<* BUZZ API CALL CREATE/UPDATE PROFILE START *>");
            AddTimingInfoLine("Base URL           - " + uri);

            HttpWebResponse response = null;

            HttpWebRequest webRequest = GetWebRequestWithCertificateDetails(uri);

            DataContractJsonSerializer jsonData = new DataContractJsonSerializer(typeof(BuzzTwitterProfile));
            MemoryStream mem = new MemoryStream();
            jsonData.WriteObject(mem, twitterProfile);
            string jsonserdata = Encoding.UTF8.GetString(mem.ToArray(), 0, (int)mem.Length);

            webRequest.Method = "POST";
            webRequest.ServicePoint.Expect100Continue = false;
            webRequest.ContentLength = mem.Length;
            webRequest.ContentType = "application/json; charset=utf-8";

            using (StreamWriter requestWriter = new StreamWriter(webRequest.GetRequestStream()))
            {
                requestWriter.Write(jsonserdata);
            }
           
            try
            {
                response = (HttpWebResponse)webRequest.GetResponse();
                resStatus = response.StatusDescription;

                if (resStatus.ToUpper().Equals("OK"))
                {
                    resStatus = "your profile has been created, now please contact the DNA team to activate it.";
                    //uri = ConfigurationSettings.AppSettings["BuzzProfileRestartIngest"].ToString();

                    //AddTimingInfoLine("<* BUZZ API CALL RESTART INGEST START *>");
                    //AddTimingInfoLine("Base URL           - " + uri);

                    //response = null;

                    //webRequest = GetWebRequestWithCertificateDetails(uri);
                    //webRequest.Method = "GET";
                    //try
                    //{
                    //    response = (HttpWebResponse)webRequest.GetResponse();
                    //    resStatus = response.StatusDescription;
                    //}
                    //catch (Exception ex)
                    //{
                    //    resStatus = ex.Message;
                    //    AddTimingInfoLine("BUZZ API CALL RESTART INGEST ERROR!!! - " + resStatus);
                    //}
                    //AddTimingInfoLine("<* BUZZ API CALL RESTART INGEST END *>");
                }
            }
            catch (Exception ex)
            {
                if(ex.Message.Contains("400"))
                {
                    resStatus = ex.Message + " Please check the profile request details.";

                }
                else if (ex.Message.Contains("500"))
                {
                    resStatus = ex.Message + " Problem with the gateway connection.";
                }

                AddTimingInfoLine("BUZZ API CALL CREATE/UPDATE PROFILE ERROR!!! - " + resStatus);
            }

            AddTimingInfoLine("<* BUZZ API CALL CREATE/UPDATE PROFILE END *>");

            return resStatus.ToUpper();
        }

        #endregion
    }
}
