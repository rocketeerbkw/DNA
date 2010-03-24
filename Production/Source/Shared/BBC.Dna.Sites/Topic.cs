namespace BBC.Dna.Sites
{
    /// <summary>
    /// The topic class
    /// </summary>
    public class Topic
    {
        /// <summary>
        /// The default constructor
        /// </summary>
        /// <param name="topicId">The id of the topic</param>
        /// <param name="title">The title of the topic</param>
        /// <param name="h2G2Id">The h2g2ID of the topic page</param>
        /// <param name="forumId">The forumid of the topic</param>
        /// <param name="status">The status of the topic. 0 - Live, 1 - Preview, 2 - Deleted, 3 - Archived Live, 4 - Archived Preview</param>
        public Topic(int topicId, string title, int h2G2Id, int forumId, int status)
        {
            TopicID = topicId;
            Title = title;
            h2g2ID = h2G2Id;
            ForumID = forumId;
            Status = status;
        }

        /// <summary>
        /// Get property for the topic id
        /// </summary>
        public int TopicID { get; private set; }

        /// <summary>
        /// The get property for the topic title
        /// </summary>
        public string Title { get; private set; }

        /// <summary>
        /// The get property for the h2g2ID for the topic page
        /// </summary>
        public int h2g2ID { get; private set; }

        /// <summary>
        /// The get property for the forumid of the topic
        /// </summary>
        public int ForumID { get; private set; }

        /// <summary>
        /// The get proerty for the topic status. 0 - Live, 1 - Preview, 2 - Deleted, 3 - Archived Live, 4 - Archived Preview
        /// </summary>
        public int Status { get; private set; }
    }
}