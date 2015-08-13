using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

using System.Runtime.Serialization;
using System.Runtime.Serialization.Json;
using System.IO;
using System.Text.RegularExpressions;
using Newtonsoft.Json;

namespace BBC.Dna.Moderation
{
    /// <summary>
    /// 
    /// </summary>
    public class ExternalLinkModeration : Context
    {
        public ExternalLinkModeration(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
            : base(dnaDiagnostics, dataReaderCreator, cacheManager, siteList)
        {
        }

        /// <summary>
        /// Add Link to Mod Queue
        /// </summary>
        /// <param name="link"></param>
        public void AddToModerationQueue(Uri uri, Uri callBackUri, String complaintText, String notes, int siteId)
        {
            using (IDnaDataReader reader = DnaDataReaderCreator.CreateDnaDataReader("addexlinktomodqueue"))
            {
                reader.AddParameter("uri", uri.ToString());
                reader.AddParameter("callbackuri", callBackUri.ToString());
                reader.AddParameter("siteid", siteId);
                if (complaintText != null && complaintText != String.Empty)
                    reader.AddParameter("complainttext", complaintText);
                if (notes != null && notes != string.Empty)
                    reader.AddParameter("notes", notes);
                reader.Execute();
            }
        }

        /// <summary>
        /// Adds the hash generated for the site to ExLinkModHashInternal table
        /// </summary>
        /// <param name="hash"></param>
        /// <param name="siteid"></param>
        public void AddToExLinkModHashInternal(Guid hash, int siteId)
        {
            using (IDnaDataReader reader = DnaDataReaderCreator.CreateDnaDataReader("createexlinkmodhashinternal"))
            {
                reader.AddParameter("hash", hash);
                reader.AddParameter("siteid", siteId);
                reader.Execute();
            }
        }

        /// <summary>
        /// Validate the hash string passed exists in ExLinkModHashInternal or not
        /// </summary>
        /// <param name="hash"></param>
        /// <param name="siteid"></param>
        public bool IsValidHash(string hash, int siteId)
        {
            bool isValid = false;

            using (IDnaDataReader reader = DnaDataReaderCreator.CreateDnaDataReader("validatehashinternal"))
            {
                reader.AddParameter("hash", hash);
                reader.AddParameter("siteid", siteId);
                reader.Execute();
                while (reader.HasRows && reader.Read())
                {
                    isValid = true;
                    break;
                }
            }

            return isValid;
        }

        /// <summary>
        /// Adds the JSON payload for a moderated external link to ExLinkModHashInternal
        /// </summary>
        /// <param name="hash"></param>
        /// <param name="siteid"></param>
        public void AddToExLinkModCallbackInternal(string hash, int siteId, ExLinkModCallbackItem exLinkModCallbackItem)
        {
            string payload = JsonConvert.SerializeObject(exLinkModCallbackItem);

            using (IDnaDataReader reader = DnaDataReaderCreator.CreateDnaDataReader("createexlinkmodcallbackinternal"))
            {
                reader.AddParameter("hash", hash);
                reader.AddParameter("siteid", siteId);
                reader.AddParameter("payload", payload);
                reader.Execute();
            }
        }

        /// <summary>
        /// Gets the JSON payload for a moderated external link from ExLinkModCallbackInternal
        /// </summary>
        /// <param name="siteid"></param>
        public IEnumerable<ExLinkModCallbackItem> GetCallbackItemInternal(int siteId)
        {
            var exLinkModCallbackItemList = new List<ExLinkModCallbackItem>();

            using (IDnaDataReader reader = DnaDataReaderCreator.CreateDnaDataReader("getcallbackitemsinternal"))
            {
                reader.AddParameter("siteid", siteId);
                reader.Execute();
                while (reader.HasRows && reader.Read())
                {
                    var jsonPayload = reader.GetString("payload");
                    var contract = JsonConvert.DeserializeObject<ExLinkModCallbackItem>(jsonPayload);
                    exLinkModCallbackItemList.Add(contract);
                }
            }

            return exLinkModCallbackItemList;
        }
    }
}
