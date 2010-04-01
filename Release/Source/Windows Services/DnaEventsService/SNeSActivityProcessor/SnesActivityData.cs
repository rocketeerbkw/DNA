using Dna.SnesIntegration.ActivityProcessor;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class SnesActivityData
    {
        public int EventId
        {
            get; set;
        }

        public int ActivityType
        {
            get; set;
        }

        public int IdentityUserId
        {
            get; set;
        }

        public DnaApplicationInfo AppInfo
        { 
            get; set;
        }

        public string BlogUrl
        {
            get; set;
        }

        public DnaUrlBuilder UrlBuilder
        {
            get; set;
        }

        public Rating Rating
        {
            get; set;
        }
    }
}