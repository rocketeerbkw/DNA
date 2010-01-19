using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Moderation;

namespace BBC.Dna.Moderation
{
    [KnownType(typeof(ModerationItem))]
    [DataContract(Name = "item", Namespace = "BBC.Dna.Moderation")]
    public partial class ModerationItem
    {
        public ModerationItem() { }

        [DataMember(Name = ("id"), Order = 1)]
        public int Id
        {
            get;
            set;
        }

        [DataMember(Name = ("uri"), Order = 2)]
        public String Uri
        {
            get;
            set;
        }

        [DataMember(Name = ("callbackuri"), Order = 3)]
        public String CallBackUri
        {
            get;
            set;
        }

        [DataMember(Name = ("mimetype"), Order = 4)]
        public String MimeType
        {
            get;
            set;
        }

        [DataMember(Name = ("complainttext"), Order = 5)]
        public String ComplaintText
        {
            get;
            set;
        }

        [DataMember(Name = ("notes"), Order = 6)]
        public String Notes
        {
            get;
            set;
        }

    }
}
