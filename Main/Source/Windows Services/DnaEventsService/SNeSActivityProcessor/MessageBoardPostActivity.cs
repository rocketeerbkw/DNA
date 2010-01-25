using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class MessageBoardPostActivity : CommentActivity
    {
        public MessageBoardPostActivity()
        {
        }

        public override void SetTitle(IDnaDataReader currentRow)
        {
            int postId = currentRow.GetInt32NullAsZero("PostId");
            string url = currentRow.GetString("DnaUrl") ?? "";
            int forumId = currentRow.GetInt32NullAsZero("ForumId");
            int threadId = currentRow.GetInt32NullAsZero("ThreadId");
            string activityHostNameUrl = "http://www.bbc.co.uk/dna/" + url;
            Contents.Url = activityHostNameUrl + "/F" + forumId.ToString() +
                "?thread=" + threadId.ToString() + "#p" + postId.ToString();

            Contents.Title =
                CommentActivity.CreateTitleString(currentRow, "posted", Contents.Url, activityHostNameUrl);
        }

        public override void SetObjectTitle(IDnaDataReader currentRow)
        {
            Contents.ObjectTitle = Contents.Title;
        }

        public override void SetObjectDescription(IDnaDataReader currentRow)
        {
            Contents.ObjectDescription = "";
        }

        public override void SetObjectUri(IDnaDataReader currentRow)
        {
            Contents.ObjectUri = currentRow.GetString("objectUri") ?? "";
        }
    }
}
