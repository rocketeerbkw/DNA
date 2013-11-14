using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(Conversation))]
    [Serializable]
    [DataContract(Name = "conversation", Namespace="BBC.Dna.Api")]
    public class Conversation
    {
        [DataMember(Name = "id")]
        public int Id { get; set; }

        [DataMember(Name = "title")]
        public string Title { get; set; }

        [DataMember(Name = "description")]
        public string Description { get; set; }

        [DataMember(Name = "commentDescription")]
        public int CommentCount { get; set; }

        [DataMember(Name = "startedBy")]
        public User StartedBy { get; set; }

        [DataMember(Name = "lastestReply")]
        public DateTimeHelper LatestReply { get; set; }

        [DataMember(Name = "conversationStatus")]
        public ConversationStatus ConversationStatus { get; set; }
    }
}
