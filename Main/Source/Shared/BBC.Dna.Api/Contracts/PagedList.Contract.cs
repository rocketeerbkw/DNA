using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(PagedList))]
    [Serializable] [DataContract (Namespace="BBC.Dna.Api")]
    public partial class PagedList : baseContract
    {
        [DataMember(Name = "itemsPerPage", Order = 1)]
        public int ItemsPerPage
        {
            get;
            set;
        }

        [DataMember(Name = "startIndex", Order = 2)]
        public int StartIndex
        {
            get;
            set;
        }

        [DataMember(Name = "totalCount", Order = 3)]
        public int TotalCount
        {
            get;
            set;
        }

        [DataMember(Name = "sortBy", Order = 4)]
        public SortBy SortBy
        {
            get;
            set;
        }

        [DataMember(Name = "sortDirection", Order = 5)]
        public SortDirection SortDirection
        {
            get;
            set;
        }

        /// <summary>
        /// Filtering is done on vote type. 
        /// </summary>
        [DataMember(Name = "filterBy", Order = 6, IsRequired = false)]
        public FilterBy FilterBy
        {
            get;
            set;
        }
    }
}
