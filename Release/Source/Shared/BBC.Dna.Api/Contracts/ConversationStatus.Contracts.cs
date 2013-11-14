using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(ConversationStatus))]
    [Serializable]
    [DataContract(Name = "conversationStatus", Namespace="BBC.Dna.Api")]
	public class ConversationStatus
	{
        [DataMember(Name="isClosed")]
        public bool IsClosed { get; set; }

        [DataMember(Name="isHidden")]
        public bool IsHidden { get; set; }
	}
}
