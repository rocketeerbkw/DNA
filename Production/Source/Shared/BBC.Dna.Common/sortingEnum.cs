namespace BBC.Dna.Common
{
    public enum SortBy
    {
        /// <summary>
        /// The creation date of the item
        /// </summary>
        Created,
        LastPosted,
        PostCount,
        RatingValue,
        Term,
        ReputationScore
    }

    public enum SortDirection
    {
        /// <summary>
        /// Ascending
        /// </summary>
        Ascending,

        /// <summary>
        /// Descending
        /// </summary>
        Descending
    }
}