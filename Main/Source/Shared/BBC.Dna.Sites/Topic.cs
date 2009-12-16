using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

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
        /// <param name="topicID">The id of the topic</param>
        /// <param name="title">The title of the topic</param>
        /// <param name="h2g2ID">The h2g2ID of the topic page</param>
        /// <param name="forumID">The forumid of the topic</param>
        /// <param name="status">The status of the topic. 0 - Live, 1 - Preview, 2 - Deleted, 3 - Archived Live, 4 - Archived Preview</param>
        public Topic(int topicID, string title, int h2g2ID, int forumID, int status)
        {
            _topicID = topicID;
            _title = title;
            _h2g2ID = h2g2ID;
            _forumID = forumID;
            _status = status;
        }

        private int _topicID = 0;
        private string _title = "";
        private int _h2g2ID = 0;
        private int _forumID = 0;
        private int _status;

        /// <summary>
        /// Get property for the topic id
        /// </summary>
        public int TopicID
        {
            get { return _topicID; }
        }

        /// <summary>
        /// The get property for the topic title
        /// </summary>
        public string Title
        {
            get { return _title; }
        }

        /// <summary>
        /// The get property for the h2g2ID for the topic page
        /// </summary>
        public int h2g2ID
        {
            get { return _h2g2ID; }
        }

        /// <summary>
        /// The get property for the forumid of the topic
        /// </summary>
        public int ForumID
        {
            get { return _forumID; }
        }

        /// <summary>
        /// The get proerty for the topic status. 0 - Live, 1 - Preview, 2 - Deleted, 3 - Archived Live, 4 - Archived Preview
        /// </summary>
        public int Status
        {
            get { return _status; }
        }
    }
}
