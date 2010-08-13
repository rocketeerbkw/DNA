using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Sites
{
    [Serializable]
    public class SiteListCache
    {
        public SiteListCache()
        {
            Ids = new Dictionary<int, Site>();
            SiteOptionList = new SiteOptionList();
        }
        public Dictionary<int, Site> Ids;
        public SiteOptionList SiteOptionList;
    }
}
