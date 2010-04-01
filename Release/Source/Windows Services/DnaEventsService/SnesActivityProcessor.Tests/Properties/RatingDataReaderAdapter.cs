using BBC.Dna.Data;

namespace Dna.SnesIntegration.ActivityProcessor
{
    class RatingDataReaderAdapter : Rating
    {
        public RatingDataReaderAdapter(IDnaDataReader dataReader)
        {
            Value = dataReader.GetTinyIntAsInt("Rating");
            MaxValue = dataReader.GetInt32("MaxValue");
        }
    }
}