using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using BBC.Dna.Data;


namespace Dna.SnesIntegration.ActivityProcessor
{
    class SnesActivityFactory
    {
        public static ISnesActivity CreateSNeSActivity(IDnaDataReader currentRow)
        {
            int activityType = currentRow.GetInt32("ActivityType");
            ISnesActivity activity;

            switch (activityType)
            {
                case 5:
                    activity = CommentActivity.CreateActivity(activityType, currentRow);
                    break;
                default:
                    activity = null;
                    break;
            }
            return activity;
        }
    }
}
