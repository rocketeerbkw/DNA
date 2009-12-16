using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "user",Namespace = "BBC.Dna.Api")]
    public partial class User : baseContract
    {
        [DataMember(Name = "userId", Order = 1)]
        public int UserId
        {
            get;
            set;
        }

        [DataMember(Name = "displayName", Order = 2, IsRequired = false)]
        public string DisplayName
        {
            get;
            set;
        }

        [DataMember(Name = "editor", Order = 5, IsRequired = false)]
        public bool Editor
        {
            get;
            set;
        }

        /// <summary>
        /// Users journal page ID
        /// </summary>
        public int Journal = 0;

        /// <summary>
        /// Users status - 1 normal, 2 super user
        /// </summary>
        public int Status = 0;
    }
}
