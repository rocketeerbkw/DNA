namespace BBC.Dna.Api
{
    public enum FilterBy
    {
        /// <summary>
        /// No filter
        /// </summary>
        None,

        /// <summary>
        /// Editor picks
        /// </summary>
        EditorPicks,

        /// <summary>
        /// A provided user list - comma seperated
        /// </summary>
        UserList,

        /// <summary>
        /// Which have posts within a certain time period
        /// </summary>
        PostsWithinTimePeriod,

        /// <summary>
        /// Only posts that belong to Contact Forms
        /// </summary>
        ContactFormPosts
    }
}