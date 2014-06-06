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
using System.Windows.Forms;
using System.Xml;

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

        /// <summary>
        /// Getting twitter user details by scrapping using HtmlAgilityPack
        /// </summary>
        /// <param name="screenName"></param>
        /// <returns></returns>
        public TweetUsers GetUserDetailsByScrapping(string screenName)
        {
            TweetUsers userDetails = new TweetUsers();

            var proxyServer = ConfigurationSettings.AppSettings["proxyserver"].ToString();
            string uri = "http://twitter.com/" + screenName; //url hasdcoded as this is a temp fix

            Uri URL = new Uri(uri);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            try
            {
                webRequest.Timeout = 30000;

                webRequest.Proxy = new WebProxy(proxyServer);

                StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());

                string strResponse = responseReader.ReadToEnd();
                responseReader.Close();

                HtmlAgilityPack.HtmlDocument doc = new HtmlAgilityPack.HtmlDocument();
                doc.LoadHtml(strResponse);

                var twitterUserId = string.Empty;
                var twitterName = string.Empty;
                var twitterImage = string.Empty;

                var divNodes = doc.DocumentNode.SelectNodes("//div[@data-screen-name='" + screenName + "']");
                twitterUserId = divNodes[0].Attributes["data-user-id"].Value;
                twitterName = divNodes[0].Attributes["data-name"].Value;

                var imgNodes = doc.DocumentNode.SelectNodes("//img[@alt='" + twitterName + "']");
                twitterImage = imgNodes[0].Attributes["src"].Value;

                userDetails.id = twitterUserId;
                userDetails.Name = twitterName;
                userDetails.ScreenName = screenName;
                userDetails.ProfileImageUrl = twitterImage;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return userDetails;
        }

        #endregion
    }
}
