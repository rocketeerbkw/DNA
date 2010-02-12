using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using BBC.Dna.Data;
using System.Runtime.Serialization;
using DnaEventService.Common;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class CommentForumActivity : CommentActivityBase
    {
        public override void SetTitle(IDnaDataReader currentRow)
        {
            string activityHostNameUrl = "";
            int postId = currentRow.GetInt32NullAsZero("PostId");
            string blogUrl = currentRow.GetString("BlogUrl") ?? "";

            if (blogUrl.Length > 0)
            {
                activityHostNameUrl = blogUrl;
                Contents.Url = activityHostNameUrl + "#P" + postId;
            }

            Contents.Title =
                CreateTitleString(currentRow, "posted", Contents.Url, activityHostNameUrl);
        }
        
        public override void SetObjectTitle(IDnaDataReader currentRow)
        {
            Contents.ObjectTitle = currentRow.GetString("ObjectTitle") ?? "";
        }

        public override void SetObjectDescription(IDnaDataReader currentRow)
        {
            Contents.ObjectDescription = currentRow.GetString("Body") ?? "";
        }

        public override void SetObjectUri(IDnaDataReader currentRow)
        {
            Contents.ObjectUri = currentRow.GetString("ObjectUri") ?? "";
        }

        public override HttpStatusCode Send(IDnaHttpClient client)
        {
            return Send(client.Post);
        }
      
    }
}
