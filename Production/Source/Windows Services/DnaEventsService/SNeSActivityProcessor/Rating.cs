namespace Dna.SnesIntegration.ActivityProcessor
{
    public class Rating
    {
        public int Value
        {
            get; set;
        }

        public int MaxValue
        {
            get; set;
        }

        public override string ToString()
        {
            return string.Format("{0} out of {1}", Value, MaxValue);
        }
    }
}