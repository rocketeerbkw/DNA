using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml;
using System.Xml.Serialization;
using System.Runtime.Serialization;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using BBC.Dna.Sites;
using System.Web;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using System.Xml.Schema;
using BBC.Dna.Api;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(TypeName = "POSTLIST")]
    [DataContract(Name = "postList")]
    public class PostList : CachableBase<PostList>
    {
        public PostList()
        {
            Posts = new List<Post>();
        }

        #region Properties
        /// <remarks/>
        [XmlAttribute(AttributeName = "SKIP")]
        [DataMember(Name = "skip", Order = 1)]
        public int Skip { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "SHOW")]
        [DataMember(Name = "show", Order = 2)]
        public int Show { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "COUNT")]
        [DataMember(Name = "count", Order = 3)]
        public int Count { get; set; }

        /// <remarks/>
        [XmlAttribute(AttributeName = "MORE")]
        [DataMember(Name = "more", Order = 4)]
        public int More { get; set; }
        /// <remarks/>
        [XmlAttribute(AttributeName = "TOTAL")]
        [DataMember(Name = "total", Order = 5)]
        public int Total { get; set; }

        [XmlElement(Order = 2, ElementName = "USER")]
        [DataMember(Name = "user", Order = 8)]
        public UserElement User { get; set; }

        /// <remarks/>
        [XmlElement("POSTS", Form = XmlSchemaForm.Unqualified)]
        [DataMember(Name = "posts", Order = 6)]
        public List<Post> Posts { get; set; }

        /// <summary>
        /// Cache freshness variable
        /// </summary>
        [XmlIgnore]
        public DateTime LastUpdated { get; set; }

        #endregion


        /// <summary>
        /// Creates the Users conversation list from db
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <param name="dnaUserId"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="viewingUserId"></param>
        /// <returns></returns>
        public static PostList CreateUsersConversationListFromDatabase(IDnaDataReaderCreator readerCreator,
                                                                        int dnaUserId, 
                                                                        BBC.Dna.Sites.ISite site, 
                                                                        int skip, 
                                                                        int show,
                                                                        int viewingUserId)
        {
            PostList postList = new PostList();
            postList.Skip = skip;
            postList.Show = show;
            postList.Total = 0;

            int count = 0;
            // fetch all the lovely intellectual property from the database
            using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getalluserpostingstats4"))
            {
                reader.AddParameter("siteid", site.SiteID);
                reader.AddParameter("userid", dnaUserId);
                reader.AddParameter("skip", skip);
                reader.AddParameter("show", show);

                reader.Execute();

                if (reader.HasRows && reader.Read())
                {
/*                    if (skip > 0)
                    {
                        for (int i = 1; i < skip; i++)
                        {
                            reader.Read();
                        }
                    }
 * */
                    postList.User = new UserElement() { user = BBC.Dna.Objects.User.CreateUserFromReader(reader) };

                    bool more = true;
                    //The stored procedure returns one row for each post. 
                    do
                    {
                        count++;
                        //Delegate object creation to Post class.
                        Post post = Post.CreatePostFromReader(reader);
                        if (dnaUserId != viewingUserId)
                        {
                            post.Editable = 0;
                        }
                        else
                        {
                            //If the owner of the page is the viewer
                            post.LastPostCountRead = reader.GetInt32NullAsZero("LastPostCountRead");
                            if (post.YourLastPost > 0)
                            {
                                post.Editable = GetPostEditableAttribute(dnaUserId, viewingUserId, site.ThreadEditTimeLimit, post.MostRecent.Date.DateTime);
                            }
                            else
                            {
                                post.Editable = 0;
                            }

                        }
                        postList.Total = reader.GetInt32NullAsZero("Total");
                        postList.Posts.Add(post);

                        more = reader.Read();

                    } while (more && count < show);

                    // Add More Attribute Indicating there are more rows.
                    if (more && count > 0)
                    {
                        postList.More = 1;
                    }
                }
            }
            postList.Count = count;
            return postList;
        }
        /// <summary>
        /// Gets the users article list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteID"></param>
        /// <returns></returns>
        public static PostList CreateUsersConversationList(ICacheManager cache,
                                                IDnaDataReaderCreator readerCreator,
                                                Dna.Users.CallingUser viewingUser,
                                                BBC.Dna.Sites.ISite site,
                                                string identifier)
        {
            return CreateUsersConversationList(cache, readerCreator, viewingUser, site, identifier, 0, 20, false, false);
        }
  
        /// <summary>
        /// Gets the users conversation list from cache or db if not found in cache
        /// </summary>
        /// <param name="cache"></param>
        /// <param name="readerCreator"></param>
        /// <param name="viewingUser"></param>
        /// <param name="identifier"></param>
        /// <param name="siteId"></param>
        /// <param name="skip"></param>
        /// <param name="show"></param>
        /// <param name="byDnaUserId"></param>
        /// <param name="ignoreCache"></param>
        /// <returns></returns>
        public static PostList CreateUsersConversationList(ICacheManager cache, 
                                                IDnaDataReaderCreator readerCreator,
                                                Dna.Users.CallingUser viewingUser,
                                                BBC.Dna.Sites.ISite site,
                                                string identifier, 
                                                int skip, 
                                                int show, 
                                                bool byDnaUserId,
                                                bool ignoreCache)
        {
            int dnaUserId = 0;
            if (!byDnaUserId)
            {
                // fetch all the lovely intellectual property from the database
                using (IDnaDataReader reader = readerCreator.CreateDnaDataReader("getdnauseridfromidentityusername"))
                {
                    reader.AddParameter("identityusername", identifier);
                    reader.Execute();

                    if (reader.HasRows && reader.Read())
                    {
                        //1st Result set gets user details.
                        dnaUserId = reader.GetInt32NullAsZero("userid");
                    }
                    else
                    {
                        throw ApiException.GetError(ErrorType.UserNotFound);
                    }
                }
            }
            else
            {
                try
                {
                    dnaUserId = Convert.ToInt32(identifier);
                }
                catch (Exception)
                {
                    throw ApiException.GetError(ErrorType.UserNotFound);
                }
            }



            var postList = new PostList();
            bool viewingOwnConversations = false;
            int viewingUserId = 0;
            if (viewingUser != null)
            {
                viewingOwnConversations = dnaUserId == viewingUser.UserID;
                viewingUserId = viewingUser.UserID;
            }

            string key = postList.GetCacheKey(dnaUserId, site.SiteID, skip, show, viewingOwnConversations);
            //check for item in the cache first
            if (!ignoreCache)
            {
                //not ignoring cache
                postList = (PostList)cache.GetData(key);
                if (postList != null)
                {
                    //check if still valid with db...
                    if (postList.IsUpToDate(readerCreator))
                    {
                        return postList;
                    }
                }
            }

            //create from db
            postList = CreateUsersConversationListFromDatabase(readerCreator, dnaUserId, site, skip, show, viewingUserId);

            postList.LastUpdated = DateTime.Now;

            //add to cache
            cache.Add(key, postList);

            return postList;
        }

        /// <summary>
        /// Check with a light db call to see if the cache should expire
        /// </summary>
        /// <param name="readerCreator"></param>
        /// <returns>True if up to date and ok to use</returns>
        public override bool IsUpToDate(IDnaDataReaderCreator readerCreator)
        {
            return false;
        }


        private static long GetPostEditableAttribute(int postEditorId, int viewingUserId, int threadEditTimeLimit, DateTime dateCreated )
        {
	        // Get per-site timeout value
	        int timeout = threadEditTimeLimit;

	        if (timeout <= 0 || viewingUserId != postEditorId)
	        {
		        // Not editable
		        return 0;
	        }

	        long editable = 0;

	        DateTime currTime = DateTime.Now;
	        TimeSpan difference = currTime - dateCreated;
            long liMinutesLeft = (long)((double)timeout - difference.Minutes); // Make sure our result is rounded down

	        if (liMinutesLeft >= 0)
	        {
                editable = liMinutesLeft;
	        }

            return editable;
        }
    }
}
