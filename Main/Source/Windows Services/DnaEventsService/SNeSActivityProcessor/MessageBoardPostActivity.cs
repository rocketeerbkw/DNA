using System;
using System.Net;
using BBC.Dna.Data;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class MessageBoardPostActivity : CommentActivity
    {
        public override void SetTitle(IDnaDataReader currentRow)
        {
            int postId = currentRow.GetInt32NullAsZero("PostId");
            string url = currentRow.GetString("DnaUrl") ?? "";
            int forumId = currentRow.GetInt32NullAsZero("ForumId");
            int threadId = currentRow.GetInt32NullAsZero("ThreadId");
            string activityHostNameUrl = "http://www.bbc.co.uk/dna/" + url;
            Contents.Url = activityHostNameUrl + "/F" + forumId + "?thread=" + threadId + "#p" + postId;

            Contents.Title = CreateTitleString(currentRow, "posted", Contents.Url, activityHostNameUrl);
        }

        public override void SetObjectTitle(IDnaDataReader currentRow)
        {
            Contents.ObjectTitle = Contents.Title;
        }

        public override void SetObjectDescription(IDnaDataReader currentRow)
        {
            Contents.ObjectDescription = currentRow.GetString("objectDescription") ?? "";
        }

        public override void SetObjectUri(IDnaDataReader currentRow)
        {
            Contents.ObjectUri = currentRow.GetString("objectUri") ?? "";
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Post);
        }
    }
}
