using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.DNA.Moderation.Utils
{
    public class AllowedUrls
    {
        private static Dictionary<int, List<string>> _allowedURLsList = new Dictionary<int, List<string>>();

        /// <summary>
        /// Allowed URL List Class
        /// </summary>
        /// <param name="context">The context</param>
        public void LoadAllowedURLLists(IDnaDataReaderCreator readerCreator)
        {

            string getAllowedURLListData = "getallallowedurls";
            using (IDnaDataReader dataReader = readerCreator.CreateDnaDataReader(getAllowedURLListData))
            {
                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    ProcessAllowedURLListData(dataReader);
                }
            }
        }

        private void ProcessAllowedURLListData(IDnaDataReader dataReader)
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
                isAllowed = _allowedURLsList[siteID].Any(trimmedCheck.StartsWith);
            }
            return isAllowed;
        }
    }
}
