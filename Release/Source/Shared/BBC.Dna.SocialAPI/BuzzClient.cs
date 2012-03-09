using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Syndication;
using System.ServiceModel.Web;
using System.Net;

namespace BBC.Dna.SocialAPI
{
    public class BuzzClient : ClientBase<IBuzz>, IBuzz
    {
        #region method(s)

        public BuzzTwitterProfiles GetProfiles()
        {
            var proxyServer = ConfigurationSettings.AppSettings["proxyserver"].ToString();

            using (WebChannelFactory<IBuzz> cfact = new WebChannelFactory<IBuzz>("BuzzProfileClient"))
            {
                Uri proxyAddress = new Uri(proxyServer);
                WebRequest.DefaultWebProxy = new WebProxy(proxyAddress);
                
                IBuzz s = cfact.CreateChannel();
                return s.GetProfiles();
            }
        }

        #endregion
    }
}
