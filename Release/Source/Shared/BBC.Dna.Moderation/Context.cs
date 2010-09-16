using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BBC.Dna.Utils;
using BBC.Dna.Data;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Sites;

namespace BBC.Dna.Moderation
{
    public class Context
    {
        public IDnaDiagnostics DnaDiagnostics { get; private set; }
        public ICacheManager CacheManager { get; private set; }
        public IDnaDataReaderCreator DnaDataReaderCreator { get; private set; }
        public ISiteList SiteList { get; private set; }

        public Context() { }

        public Context(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
        {
            DnaDiagnostics = dnaDiagnostics;
            DnaDataReaderCreator = dataReaderCreator;
            CacheManager = cacheManager;
            SiteList = siteList;
        }
    }
}
