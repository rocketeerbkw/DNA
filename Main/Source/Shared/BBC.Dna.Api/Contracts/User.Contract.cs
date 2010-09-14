using System;
using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable]
    [DataContract(Name = "user", Namespace = "BBC.Dna.Api")]
    public class User : baseContract
    {
        /// <summary>
        /// Users journal page ID
        /// </summary>
        public int Journal { get; set; }

        /// <summary>
        /// Users status - 1 normal, 2 super user
        /// </summary>
        public int Status{ get; set;}

        [DataMember(Name = "userId", Order = 1)]
        public int UserId { get; set; }

        [DataMember(Name = "displayName", Order = 2, IsRequired = false)]
        public string DisplayName { get; set; }

        [DataMember(Name = "editor", Order = 5, IsRequired = false)]
        public bool Editor { get; set; }

        [DataMember(Name = "notable", Order = 6, IsRequired = false)]
        public bool Notable { get; set; }

        [DataMember(Name = "bbcId", Order = 7, IsRequired = false)]
        public string BbcId { get; set; }

        [DataMember(Name = "siteSpecificDisplayName", Order = 8, IsRequired = false)]
        public string SiteSpecificDisplayName { get; set; }
    }
}