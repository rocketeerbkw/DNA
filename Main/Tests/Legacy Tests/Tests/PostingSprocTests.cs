using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
	/// <summary>
	/// Tests for the posttoforum procedures, to ensure the renaming of the IgnoreThreadPostings fields hasn't broken anything
	/// </summary>
	[TestClass]
	public class PostingSprocTests
	{
		string _uid = "1234-0910-0920-0920-NEW";

		/// <summary>
		/// Tests for posting to forums (comment forums initially)
		/// </summary>
		[TestMethod]
		public void TestPosting()
		{
            SnapshotInitialisation.ForceRestore();
			// Test in Site ID 54 (mbcbbc) which has premod posting and process premod
			// Use a regular user
			// The moderator for this site is 1090564231

			//exec getcommentforum 
			//@uid=N'comments1_shtml12345',
			//@url=N'http://local.bbc.co.uk:8000/comments1.shtml',
			//@title=N'Comment Box New',
			//@siteid=18,
			//@frompostindex=0,
			//@topostindex=0,
			//@show=5,
			//@createifnotexists=1,
			//@duration=321,
			//@moderationstatus=3

			int commentForumID = 0;
			int moderatorUserId = 1090564231;
			int normalUserid = 1090501859;
            IInputContext context = DnaMockery.CreateDatabaseInputContext();

			// First ensure that the user we have posting has all the requisite masthead stuff

			//exec createnewuserfromuserid @userid=1090501859,@username='U1090501859',@email='',@siteid = 54
            using (IDnaDataReader reader = context.CreateDnaDataReader("createnewuserfromssoid"))
			{
				reader.AddParameter("@ssouserid", normalUserid)
				.AddParameter("@username", "U1090501859")
				.AddParameter("@email", "")
				.AddParameter("@siteid", 54);
				reader.Execute();
				Assert.IsTrue(reader.Read(), "Created user details returned a row");
				Assert.IsTrue(reader.GetInt32("UserID") == normalUserid, "User ID matches");
			}

			using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
			{
				GetCommentForum(reader);
				commentForumID = reader.GetInt32("ForumID");
				Assert.IsTrue(commentForumID >  0);
			}

			// Now we have the forum ID, we want to post a message to the forum

			string commenttext = "blah blah blah blardy blah";
			string hash = "B0E9D576-2371-F9BF-5BF8-C6203E80EB14";
			int thisPostId = CreateAComment(normalUserid, context, commenttext, hash);
			Assert.AreEqual(0, thisPostId,"Premod posting returns post ID of zero");

			ModeratePosts(moderatorUserId, normalUserid, context);

			// Now try posting two different posts to the same forum - should all return the same thread ID

			thisPostId = CreateAComment(normalUserid, context, "posting2", "B0E9D576-2371-F9BF-5BF8-C6203E12EB14");
			Assert.AreEqual(0, thisPostId, "Premod posting returns post ID of zero");
			thisPostId = CreateAComment(normalUserid, context, "posting3", "B0E9D576-3171-F9BF-5BF8-C6203E12EB14");
			Assert.AreEqual(0, thisPostId, "Premod posting returns post ID of zero");
			ModeratePosts(moderatorUserId, normalUserid, context);

			// Now get all posts from the forum
			using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
			{
				GetCommentForum(reader);
				commentForumID = reader.GetInt32("ForumID");
				Assert.IsTrue(commentForumID >  0);
				int thisThreadId = reader.GetInt32("ThreadID");
				int thisEntryId = reader.GetInt32("EntryID");
				int thisForumId = reader.GetInt32("ForumID");
				int postIndex = reader.GetInt32("PostIndex");
				while (reader.Read())
				{
					Assert.AreEqual(thisThreadId, reader.GetInt32("ThreadID"),"All thread IDs should be identical");
					Assert.IsTrue(postIndex - reader.GetInt32("PostIndex") == 1, "Expecting decrementing PostIndexes");
					Assert.IsTrue(thisEntryId > reader.GetInt32("EntryID"));
					thisThreadId = reader.GetInt32("ThreadID");
					thisEntryId = reader.GetInt32("EntryID");
					thisForumId = reader.GetInt32("ForumID");
					postIndex = reader.GetInt32("PostIndex");
				}
			}

			// Now try posting as a normal user in h2g2
			// exec dbo.posttoforum 
			//@userid = 1090494444,
			//@forumid = 19585,
			//@inreplyto = NULL,
			//@threadid = NULL,
			//@subject = 'zonky',
			//@content = 'zonk zonk',
			//@poststyle = 2,
			//@hash = 'c6f1c6d0-b7d2-8227-a1bb-958f179b0d5d',
			//@keywords = NULL,
			//@nickname = NULL,
			//@type = NULL,
			//@eventdate = NULL,
			//@forcemoderate = 0,
			//@ignoremoderation = 0,
			//@clubid = NULL,
			//@nodeid = NULL,
			//@ipaddress = NULL,
			//@keyphrases = '',
			//@allowqueuing = 1,
			//@bbcuid = '449206f2-35af-110c-a116-0003ba0c07a5',
			//@isnotable = 0
			//@iscomment = 0

			using (IDnaDataReader reader = context.CreateDnaDataReader("posttoforum"))
			{
				reader.AddParameter("@userid", normalUserid)
				.AddParameter("@forumid", 19585)	// Ask h2g2
				.AddParameter("@inreplyto", DBNull.Value)
				.AddParameter("@threadid",DBNull.Value)
				.AddParameter("@subject", "This is a new subject")
				.AddParameter("@content", "New posting content")
				.AddParameter("@poststyle", 2)
				.AddParameter("@keywords",DBNull.Value)
				.AddParameter("@hash", "c6f1c6d0-b7d2-8227-a1bb-958f179b0d5d")
				.AddParameter("@forcemoderate", 0)
				.AddParameter("@ignoremoderation", 0)
				.AddParameter("@keyphrases", "")
				.AddParameter("@allowqueuing", 1)
				.AddParameter("@bbcuid", "449206f2-35af-110c-a116-0003ba0c07a5")
				.AddParameter("@isnotable", 0)
				.AddParameter("@iscomment", 0);
				reader.Execute();
				Assert.IsTrue(reader.Read(),"Get a row posting to askh2g2");
				Assert.IsTrue(reader.GetInt32("ThreadID")> 0, "Thread > 0");
				Assert.IsTrue(reader.GetInt32("PostID") > 0,  "Post ID > 0");
			}

			// Now to write the tests for the case which currently fails
			// A normal user posts to a queued premoderated site
			// And it ends up with two posts with the same postindex and different threadIDs
			// So we can reuse the chunk of code above but just change the uid to create a new blank forum

			_uid = "1234-9829-6738-8237-NEW";

			using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
			{
				GetCommentForum(reader);
				commentForumID = reader.GetInt32("ForumID");
				Assert.IsTrue(commentForumID >  0);
			}

			thisPostId = CreateAComment(normalUserid, context, "posting2", "B0E9D576-2371-F9BF-5BF8-C6203E121114");
			Assert.AreEqual(0, thisPostId, "Premod posting returns post ID of zero");
			thisPostId = CreateAComment(normalUserid, context, "posting3", "B0E9D576-3171-F9BF-5BF8-C6203E125414");
			Assert.AreEqual(0, thisPostId, "Premod posting returns post ID of zero");
			ModeratePosts(moderatorUserId, normalUserid, context);

			// Before the bugfix, this next test would fail, because two threads were created in the forum
			using (IDnaDataReader reader = context.CreateDnaDataReader("getcommentforum"))
			{
				GetCommentForum(reader);
				commentForumID = reader.GetInt32("ForumID");
				Assert.IsTrue(commentForumID >  0);
				int thisThreadId = reader.GetInt32("ThreadID");
				int thisEntryId = reader.GetInt32("EntryID");
				int thisForumId = reader.GetInt32("ForumID");
				int postIndex = reader.GetInt32("PostIndex");
				while (reader.Read())
				{
					Assert.AreEqual(thisThreadId, reader.GetInt32("ThreadID"), "All thread IDs should be identical");
					Assert.IsTrue(postIndex - reader.GetInt32("PostIndex") == 1, "Expecting decrementing PostIndexes");
					Assert.IsTrue(thisEntryId > reader.GetInt32("EntryID"));
					thisThreadId = reader.GetInt32("ThreadID");
					thisEntryId = reader.GetInt32("EntryID");
					thisForumId = reader.GetInt32("ForumID");
					postIndex = reader.GetInt32("PostIndex");
				}
			}


		}

		private static void ModeratePosts(int moderatorUserId, int normalUserid, IInputContext inputContext)
		{
			using (IDnaDataReader reader = inputContext.CreateDnaDataReader("getmoderationposts"))
			{
				reader.AddParameter("@userid", moderatorUserId)
				.AddParameter("@alerts", 0)
				.AddParameter("@lockeditems", 0)
				.AddParameter("@issuperuser", 0)
				.AddParameter("@modclassid", 5)
				.AddParameter("@show", 10)
				.AddParameter("@fastmod", 0);
				reader.Execute();
				Assert.IsTrue(reader.Read(), "Expecting at least one post to moderate");
				do
				{
					int forumId = reader.GetInt32NullAsZero("ForumID");
					int threadId = reader.GetInt32NullAsZero("ThreadID");
					int postId = reader.GetInt32NullAsZero("EntryID");
					int modID = reader.GetInt32NullAsZero("ModID");
					using (IDnaDataReader subreader = inputContext.CreateDnaDataReader("moderatepost"))
					{
						subreader.AddParameter("@forumid", forumId)
						.AddParameter("@threadid", threadId)
						.AddParameter("@postid", postId)
						.AddParameter("@modid", modID)
						.AddParameter("@status", 3)
						.AddParameter("@notes", "")
						.AddParameter("@referto", 0)
						.AddParameter("@referredby", moderatorUserId)
						.AddParameter("@moderationstatus", 0);
						subreader.Execute();
						Assert.IsTrue(subreader.Read(), "moderatepost expects a single row");
						Assert.IsTrue(subreader.GetInt32NullAsZero("PostID") > 0, "PostID should be non-zero after processing");
						Assert.AreEqual(subreader.GetInt32NullAsZero("AuthorID"), normalUserid, "Testing that posting user IDs match");
						Assert.IsFalse(subreader.Read(), "Only expecting a single row of data");
					}

				} while (reader.Read());

			}
		}

		private int CreateAComment(int normalUserid, IInputContext inputContext, string commenttext, string hash)
		{
			int thisPostId = 0;
			using (IDnaDataReader reader = inputContext.CreateDnaDataReader("createcomment"))
			{
				//exec createcomment 
				//@uniqueid=N'comments1_shtml123456',
				//@userid=6,
				//@content=N'blardy blah blah',
				//@hash='B0E9D576-2371-F9BF-5BF8-C6203E80EB14',
				//@forcemoderation=0,
				//@ignoremoderation=1,
				//@isnotable=1
				reader.AddParameter("@uniqueid", _uid)
				.AddParameter("@userid", normalUserid)
                .AddParameter("@siteid", 54)
				.AddParameter("@content", commenttext)
				.AddParameter("@hash", hash)
				.AddParameter("@forcemoderation", "0")
				.AddParameter("@ignoremoderation", 0)
				.AddParameter("@isnotable", 0)
                .AddParameter("@poststyle", 2)
				.Execute();
				Assert.IsTrue(reader.Read(), "Checking that createcomment returns a row");
				thisPostId = reader.GetInt32("postid");
			}
			return thisPostId;
		}

		private void GetCommentForum(IDnaDataReader reader)
		{
			reader.AddParameter("@uid", _uid)
			.AddParameter("@url", "http://www.bbc.co.uk/comment.shtml")
			.AddParameter("@title", "Comment test")
			.AddParameter("@siteid", 54)
			.AddParameter("@frompostindex", 0)
			.AddParameter("topostindex", 0)
			.AddParameter("@show", 5)
			.AddParameter("@createifnotexists", 1)
			.AddParameter("@duration", 1000)
			.AddParameter("@moderationstatus", 3);
			reader.Execute();
			Assert.IsTrue(reader.Read(), "Checking that getcommentforum returns a row containing the forum details");
		}
	}
}
