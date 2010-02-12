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
                    activity = CommentActivityBase.CreateActivity(activityType, currentRow);
                    break;
                case 20:
                    activity = RevokeCommentActivity.CreateActivity(currentRow);
                    break;
                default:
                    activity = new UnexpectedActivity();
                    break;
            }
            return activity;
        }
    }
}
