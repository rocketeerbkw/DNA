using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// Class for the allowed URLs (white list)
    /// </summary>
    public class AllowedURLs : BBC.Dna.IAllowedURLs
    {
        private static Dictionary<int, List<string>> _allowedURLsList = new Dictionary<int, List<string>>();
        
        /// <summary>
        /// Allowed URL List Class
        /// </summary>
        /// <param name="context">The context</param>
        public void LoadAllowedURLLists(IAppContext context)
        {
            string getAllowedURLListData = "getallallowedurls";
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(getAllowedURLListData))
            {
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    ProcessAllowedURLListData(dataReader, context);
                }
            }

        }

        private void ProcessAllowedURLListData(IDnaDataReader dataReader, IAppContext context)
        {
            int currentSiteID = 1;
            int siteID = 1;
            _allowedURLsList.Clear();

            //For each row/site in the database add it's details
            if (dataReader.Read())
            {
                siteID = dataReader.GetInt32NullAsZero("SiteID");
                currentSiteID = siteID;
                List<string> siteAllowedURLs = new List<string>();
                string allowedURL = dataReader.GetStringNullAsEmpty("URL").ToLower();
                siteAllowedURLs.Add(allowedURL);

                while (dataReader.Read())
                {
                    siteID = dataReader.GetInt32NullAsZero("SiteID");
                    if (siteID != currentSiteID)
                    {
                        _allowedURLsList.Add(currentSiteID, siteAllowedURLs);
                        siteAllowedURLs.Clear();
                        currentSiteID = siteID;
                    }
                    allowedURL = dataReader.GetStringNullAsEmpty("URL").ToLower();
                    siteAllowedURLs.Add(allowedURL); 
               }
               _allowedURLsList.Add(currentSiteID, siteAllowedURLs);
           }
        }

        /// <summary>
        /// Gets the list of allowed urls for a particular site
        /// </summary>
        /// <param name="siteID">The site of the list required</param>
        /// <returns>List of allowed URLs</returns>
        public List<string> GetAllowedURLList(int siteID)
        {
            if (_allowedURLsList.ContainsKey(siteID))
            {
                return _allowedURLsList[siteID];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Function to check the given sites allowed URL List for a particular string
        /// </summary>
        /// <param name="siteID">The site in question</param>
        /// <param name="stringToCheck">String to check</param>
        /// <returns>True if the value contains the string in the list</returns>
        public bool DoesAllowedURLListContain(int siteID, string stringToCheck)
        {
            bool isAllowed = false;
            if (_allowedURLsList.ContainsKey(siteID))
            {
                string trimmedCheck = stringToCheck.Replace("http://", "").TrimStart(' ').ToLower();
                foreach (string url in _allowedURLsList[siteID])
                {
                    if (trimmedCheck.StartsWith(url))
                    {
                        isAllowed = true;
                        break;
                    }
                }
            }
            return isAllowed;
        }
    }
}
