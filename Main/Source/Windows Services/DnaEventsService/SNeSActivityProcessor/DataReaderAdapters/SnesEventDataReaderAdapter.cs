using BBC.Dna.Data;

namespace Dna.SnesIntegration.ActivityProcessor.DataReaderAdapters
{
    class SnesEventDataReaderAdapter : SnesActivityData
    {
        public SnesEventDataReaderAdapter(IDnaDataReader dataReader)
        {
            Rating = dataReader.IsDBNull("Rating") ? null : new RatingDataReaderAdapter(dataReader);
            AppInfo = new AppInfoDataReaderAdapter(dataReader);
            ActivityType = dataReader.GetInt32("ActivityType");
            EventId = dataReader.GetInt32("EventId");
            IdentityUserId = dataReader.GetString("IdentityUserId");
            BlogUrl = dataReader.IsDBNull("BlogUrl") ? null : dataReader.GetString("BlogUrl");

            UrlBuilder = new DnaUrlBuilder
                             {
                                 PostId = dataReader.GetInt32("PostId"),
                                 ForumId = dataReader.GetInt32("ForumId"),
                                 ThreadId = dataReader.GetInt32("ThreadId"),
                                 DnaUrl = dataReader.GetString("DnaUrl")
                             };
        }
    }
}