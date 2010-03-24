using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace BBC.Dna.Net.Security
{
    public class X509CertificateLoader
    {
        public static X509Certificate FindCertificate(string certifcateName)
        {
            ServicePointManager.ServerCertificateValidationCallback +=
                RemoteCertificateValidationCallback;

            var store = new X509Store(StoreName.My, StoreLocation.LocalMachine);
            store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);

            X509Certificate cert = store.Certificates.Find(
                    X509FindType.FindBySubjectName, certifcateName, false)[0];

            return cert;
        }

        public static bool RemoteCertificateValidationCallback(object sender,
                                                X509Certificate certificate,
                                                X509Chain chain,
                                                SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }


    }
}
