namespace BBC.Dna.Api
{
    public enum SortBy
    {
        /// <summary>
        /// The creation date of the item
        /// </summary>
        Created,
        LastPosted,
        PostCount,
        RatingValue
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