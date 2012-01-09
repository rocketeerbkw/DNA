using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;
using System.ServiceModel.Syndication;
using System.ServiceModel.Web;
using BBC.Dna.SocialAPI;
using System.Net;

namespace BBC.Dna.SocialAPI
{
    public class TwitterClient : ClientBase<ITwitter>, ITwitter
    {
        #region method(s)

        public TweetUsers GetUserDetails(string userName)
        {
            var proxyServer = ConfigurationSettings.AppSettings["proxyserver"].ToString();
            var twitterUser = ConfigurationSettings.AppSettings["TwitterUserName"].ToString();
            var twitterPassword = ConfigurationSettings.AppSettings["TwitterPassword"].ToString();

            using (WebChannelFactory<ITwitter> cfact = new WebChannelFactory<ITwitter>("TwitterClient"))
            {
                Uri proxyAddress = new Uri(proxyServer);
                WebRequest.DefaultWebProxy = new WebProxy(proxyAddress);
                cfact.Credentials.UserName.UserName = twitterUser;
                cfact.Credentials.UserName.Password = twitterPassword;
                ITwitter s = cfact.CreateChannel();
                return s.GetUserDetails(userName);
            }
        }

        #endregion
    }
}
