using BBC.Dna.Data;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class SnesActivityFactory
    {
        public static ISnesActivity CreateSnesActivity(IDnaDataReader currentRow)
        {
            var activityType = currentRow.GetInt32("ActivityType");
            ISnesActivity activity;

            switch (activityType)
            {
                case 19:
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
