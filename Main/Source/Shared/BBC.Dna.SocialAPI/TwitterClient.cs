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
            var proxyServer = ConfigurationManager.AppSettings["proxyserver"];
            var twitterUser = ConfigurationManager.AppSettings["TwitterUserName"];
            var twitterPassword = ConfigurationManager.AppSettings["TwitterPassword"];

            using (WebChannelFactory<ITwitter> cfact = new WebChannelFactory<ITwitter>("TwitterClient"))
            {
                if (IsUriValid(proxyServer))
                    WebRequest.DefaultWebProxy = new WebProxy(proxyServer);
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

            var proxyServer = ConfigurationManager.AppSettings["proxyserver"];
            string uri = "http://twitter.com/" + screenName; //url hasdcoded as this is a temp fix

            Uri URL = new Uri(uri);
            HttpWebRequest webRequest = (HttpWebRequest)HttpWebRequest.Create(URL);
            try
            {
                webRequest.Timeout = 30000;

                if (IsUriValid(proxyServer))
                    webRequest.Proxy = new WebProxy(proxyServer);

                StreamReader responseReader = new StreamReader(webRequest.GetResponse().GetResponseStream());

                string strResponse = responseReader.ReadToEnd();
                responseReader.Close();

                HtmlAgilityPack.HtmlDocument doc = new HtmlAgilityPack.HtmlDocument();
                doc.LoadHtml(strResponse);

                var twitterUserId = string.Empty;
                var twitterName = string.Empty;
                var twitterImage = string.Empty;

                var divNodes = doc.DocumentNode.SelectNodes("//div[@data-screen-name]");
                var goLoop = true;
                for (int i = 0; i < divNodes.Count && goLoop; i++)
                {
                    var node = divNodes[i];
                    if (node.Attributes["data-screen-name"].Value.Equals(screenName, StringComparison.OrdinalIgnoreCase))
                    {
                        twitterUserId = node.Attributes["data-user-id"].Value;
                        twitterName = node.Attributes["data-name"].Value;
                        screenName = node.Attributes["data-screen-name"].Value;

                        goLoop = false;
                    }
                }

                var imgNodes = doc.DocumentNode.SelectNodes("//img[@alt='" + twitterName + "']");
                if (imgNodes != null && imgNodes.Count > 0)
                {
                    twitterImage = imgNodes[0].Attributes["src"].Value;
                }

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

        private bool IsUriValid(string uri)
        {
            if (string.IsNullOrEmpty(uri)) return false;
            
            if (string.Equals(uri.Trim(), "", StringComparison.OrdinalIgnoreCase)) return false;

            if (Uri.IsWellFormedUriString("", UriKind.RelativeOrAbsolute)) return false;

            return true;
        }

        #endregion
    }
}
