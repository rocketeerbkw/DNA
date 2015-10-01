using System;
using System.Runtime.Serialization;

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

        [DataMember(Name = ("bbcuseridentity"), Order = 7)]
        public string BBCUserIdentity
        {
            get;
            set;
        }

    }

    [Serializable]
    [DataContract(Name = "ExLinkModCallbackItem", Namespace = "BBC.Dna.Moderation")]
    public class ExLinkModCallbackItem
    {
        public ExLinkModCallbackItem() { }

        [DataMember(Name = ("id"), Order = 1)]
        public int ModId
        {
            get;
            set;
        }

        [DataMember(Name = ("status"), Order = 2)]
        public string Decision
        {
            get;
            set;
        }

        [DataMember(Name = ("uri"), Order = 3)]
        public string Uri
        {
            get;
            set;
        }

        [DataMember(Name = ("notes"), Order = 4)]
        public string Notes
        {
            get;
            set;
        }

        [DataMember(Name = ("datecompleted"), Order = 5)]
        public string DateCompleted
        {
            get;
            set;
        }

        [DataMember(Name = ("reasontype"), Order = 6)]
        public string ReasonType
        {
            get;
            set;
        }

        [DataMember(Name = ("reasontext"), Order = 7)]
        public string ReasonText
        {
            get;
            set;
        }
    }
}
