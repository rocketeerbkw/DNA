using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Api;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
	/// <summary>
	/// Tests for the Cookie decoder class
	/// </summary>
	[TestClass]
    public class UriDiscoverabilityTests
	{
		
		/// <summary>
		/// Tests of the all the discoverability functions
		/// </summary>
		[TestMethod]
        public void UriDiscoverabilityTests_AllTypes()
		{
            string basePath = "http://www.bbc.co.uk";
            string commentForumId = "1c61beed-9702-4f68-bdc5-2074540be918";
            Dictionary<string, string> replacements = new Dictionary<string, string>();
            replacements.Add("commentforumid", commentForumId);
            string result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.CommentsByCommentForumId, replacements);
            Assert.IsTrue(result.IndexOf(commentForumId) >= 0);

            result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.CommentForum, null);
            Assert.IsTrue(result != string.Empty);

            replacements = new Dictionary<string, string>();
            replacements.Add("commentforumid", commentForumId);
            result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.CommentForumById, replacements);
            Assert.IsTrue(result.IndexOf(commentForumId) >= 0);

            string siteName = "h2g2";
            replacements = new Dictionary<string, string>();
            replacements.Add("sitename", siteName);
            result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.CommentForumBySiteName, replacements);
            Assert.IsTrue(result.IndexOf(siteName) >= 0);

            result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.Comments, null);
            Assert.IsTrue(result != string.Empty);

            replacements = new Dictionary<string, string>();
            replacements.Add("commentforumid", commentForumId);
            result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.CommentsByCommentForumId, replacements);
            Assert.IsTrue(result.IndexOf(commentForumId) >= 0);

            replacements = new Dictionary<string, string>();
            replacements.Add("sitename", "h2g2");
            replacements.Add("postid", "h2g2");
            string expectedResult = string.Format("{0}/dna/{1}/comments/UserComplaintPage?PostID={2}&s_start=1", basePath, replacements["sitename"], replacements["postid"]);
            result = UriDiscoverability.GetUriWithReplacments(basePath, UriDiscoverability.UriType.Complaint, replacements);
            Assert.IsTrue(expectedResult == result, "Expected result was:" + expectedResult+" but result was:" + result);
		}


        
	}
}
