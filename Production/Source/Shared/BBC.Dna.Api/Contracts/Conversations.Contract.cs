using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel.Syndication;

namespace BBC.Dna.Api
{
    [KnownType(typeof(CommentForum))]
    [Serializable]
    [DataContract(Name = "conversations", Namespace = "BBC.Dna.Api")]
    public class Conversations
    {
    }
}
