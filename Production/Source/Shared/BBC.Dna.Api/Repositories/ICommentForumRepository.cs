using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Api;

namespace BBC.Dna.Data
{
    public interface ICommentForumRepository
    {
        List<Conversation> GetConversationByCommentForumUid(string commentForumUid);
        Conversation CreateConversation(string commentForumUid, Conversation conversation);
    }
}
