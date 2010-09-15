using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

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
        public void AddToModerationQueue(Uri uri, Uri callBackUri, String complaintText, String notes, int siteId )
        {
            using (IDnaDataReader reader = DnaDataReaderCreator.CreateDnaDataReader("addexlinktomodqueue") )
            {
                reader.AddParameter("uri", uri.ToString());
                reader.AddParameter("callbackuri", callBackUri.ToString());
                reader.AddParameter("siteid", siteId);
                if ( complaintText != null && complaintText != String.Empty )
                    reader.AddParameter("complainttext", complaintText);
                if ( notes != null && notes != string.Empty )
                    reader.AddParameter("notes", notes);
                reader.Execute();
            }
        }
    }
}
