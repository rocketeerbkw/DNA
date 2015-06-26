using System;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Security.Cryptography.X509Certificates;
using System.ServiceModel;
using System.Text;
using System.Web.Configuration;

namespace BBC.Dna.SocialAPI
{
    public class BuzzClient : ClientBase<IBuzz>, IBuzz
    {
        #region method(s)

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
            var proxyServer = ConfigurationManager.AppSettings["proxyserver"];

            Uri URL = new Uri(uri);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

            try
            {
                webRequest.Timeout = 30000;
                AddTimingInfoLine("<* BUZZ CLIENT CERTIFICATE START *>");
                AddTimingInfoLine("Base URL           - " + uri);
                AddTimingInfoLine("Certificate details   - " + connectionDetails);
                if (!string.IsNullOrEmpty(proxyServer))
                {
                    webRequest.Proxy = new WebProxy(proxyServer);
                    AddTimingInfoLine("Proxy server       - " + proxyServer);
                }
                else
                {
                    AddTimingInfoLine("Proxy server       - Not Specified");
                }

                string[] details = connectionDetails.Split(';');
                var certificateName = details[1];

                X509Store store = new X509Store("My", StoreLocation.LocalMachine);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                X509Certificate certificate = null;
                bool gotDevCert = false;
                for (int i = 0; i <= 1 && !gotDevCert; i++)
                {
                    certificate = store.Certificates.Find(X509FindType.FindBySubjectName, certificateName, false)[i];
                    gotDevCert = certificate.Subject.ToLower().Contains("cn=" + certificateName.ToLower() + ",");
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

        private bool IsUriValid(string uri)
        {
            if (string.IsNullOrEmpty(uri)) return false;

            if (string.Equals(uri.Trim(), "", StringComparison.OrdinalIgnoreCase)) return false;

            if (!Uri.IsWellFormedUriString(uri, UriKind.RelativeOrAbsolute)) return false;

            return true;
        }

        /// <summary>
        /// Gets a list of profiles from Buzz
        /// </summary>
        /// <returns></returns>
        public BuzzTwitterProfiles GetProfiles()
        {
            var uri = ConfigurationManager.AppSettings["BuzzProfileListAPI"].ToString();

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
            profilesObject.Sort();

            return profilesObject;
        }

        /// <summary>
        /// Gets a specific profile from Buzz
        /// </summary>
        /// <param name="twitterProfileId"></param>
        /// <returns></returns>
        public BuzzTwitterProfile GetProfile(string twitterProfileId)
        {
            var uri = ConfigurationManager.AppSettings["BuzzProfileAPI"].ToString();

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
            var uri = ConfigurationManager.AppSettings["BuzzProfileAPI"].ToString();

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
                    resStatus = "OK";
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("400"))
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
