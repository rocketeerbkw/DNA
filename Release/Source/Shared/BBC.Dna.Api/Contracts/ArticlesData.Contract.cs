using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "articlesData")]
    public partial class ArticlesData
    {
        [DataMember(Name = "startIndex", Order = 1)]
        public int StartIndex
        {
            get;
            set;
        }

        [DataMember(Name = "pages", Order = 2)]
        public int Pages
        {
            get;
            set;
        }

        [DataMember(Name = "itemsPerPage", Order = 3)]
        public int ItemsPerPage
        {
            get;
            set;
        }

        [DataMember(Name = "totalResults", Order = 4)]
        public int TotalResults
        {
            get;
            set;
        }

        [DataMember(Name = "user", Order = 5)]
        public User User
        {
            get;
            set;
        }

        [DataMember(Name = "articles", Order = 6)]
        public Articles Articles
        {
            get;
            set;
        }
    }
}
