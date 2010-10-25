using BBC.Dna.Data;

namespace Dna.SnesIntegration.ActivityProcessor
{
    public class RatingDataReaderAdapter : Rating
    {
        public RatingDataReaderAdapter(IDnaDataReader dataReader)
        {
            Value = dataReader.GetTinyIntAsInt("Rating");
            MaxValue = dataReader.GetInt32("MaxValue");
        }
    }
}