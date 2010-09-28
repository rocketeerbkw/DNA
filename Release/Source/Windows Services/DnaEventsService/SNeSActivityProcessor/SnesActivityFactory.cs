using BBC.Dna.Data;
using Dna.SnesIntegration.ActivityProcessor.Activities;
using Dna.SnesIntegration.ActivityProcessor.DataReaderAdapters;

namespace Dna.SnesIntegration.ActivityProcessor
{
    public class SnesActivityFactory
    {
        public static ISnesActivity CreateSnesActivity(IDnaDataReader currentRow)
        {
            var openSocialActivity = new OpenSocialActivityDataReaderAdapter(currentRow);
            var eventData = new SnesEventDataReaderAdapter(currentRow);

            ISnesActivity activity;

            switch (eventData.ActivityType)
            {
                case 19:
                    activity = CommentActivityBase.CreateActivity(openSocialActivity, eventData);
                    break;
                case 20:
                    activity = RevokeCommentActivity.CreateActivity(openSocialActivity, eventData);
                    break;
                default:
                    activity = new UnexpectedActivity();
                    break;
            }
            return activity;
        }
    }
}
