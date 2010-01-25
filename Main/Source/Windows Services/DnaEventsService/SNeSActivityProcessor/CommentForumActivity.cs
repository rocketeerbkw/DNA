using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Runtime.Serialization;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class CommentForumActivity : CommentActivity
    {
        public CommentForumActivity()
        {
        }

        public override void SetTitle(IDnaDataReader currentRow)
        {
            string activityHostNameUrl = "";
            int postId = currentRow.GetInt32NullAsZero("PostId");
            string blogUrl = currentRow.GetString("BlogUrl") ?? "";

            if (blogUrl.Length > 0)
            {
                activityHostNameUrl = blogUrl;
                Contents.Url = activityHostNameUrl + "#P" + postId.ToString();
            }

            Contents.Title =
                CommentActivity.CreateTitleString(currentRow, "posted", Contents.Url, activityHostNameUrl);
        }
        
        public override void SetObjectTitle(IDnaDataReader currentRow)
        {
            Contents.ObjectTitle = currentRow.GetString("ObjectTitle") ?? "";
        }

        public override void SetObjectDescription(IDnaDataReader currentRow)
        {
            Contents.ObjectDescription = "";
        }

        public override void SetObjectUri(IDnaDataReader currentRow)
        {
            Contents.ObjectUri = currentRow.GetString("ObjectUri") ?? "";
        }

      
    }
}
