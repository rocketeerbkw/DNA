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
        public BuzzTwitterProfiles GetProfiles()
        {
            HttpWebResponse response = null;
            var proxyServer = ConfigurationSettings.AppSettings["proxyserver"].ToString();
            var uri = ConfigurationSettings.AppSettings["BuzzProfileAPI"].ToString();

            Uri URL = new Uri(uri);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);

            webRequest.Timeout = 30000;
            
            webRequest.Proxy = new WebProxy(proxyServer);
            var connectionDetails = WebConfigurationManager.ConnectionStrings["IdentityURL"].ConnectionString;

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
            response = (HttpWebResponse)webRequest.GetResponse();

            Stream stream = response.GetResponseStream();
            DataContractJsonSerializer obj = new DataContractJsonSerializer(typeof(BuzzTwitterProfiles));

            BuzzTwitterProfiles profilesObject = obj.ReadObject(stream) as BuzzTwitterProfiles;

            return profilesObject;
        }
       
        #endregion
    }
}
