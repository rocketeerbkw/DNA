using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Configuration;
using System.Transactions;
using BBC.Dna.Data;

namespace TheGuide.Database.UnitTests
{
    /// <summary>
    /// Summary description for GetIndexOfComment
    /// </summary>
    [TestClass]
    public class GetIndexOfComment
    {
        private int postId = 25;
        private string _connectionDetails;
        public GetIndexOfComment()
        {
            _connectionDetails = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;
        }

        

        [TestMethod]
        public void GetIndexOfComment_SortByCreatedSortDirectionDescending_ReturnsCorrectStartIndex()
        {
            var sortBy = "Created";
            var sortDirection = "Descending";
            var expectedStartIndex=0;

            ExecuteSP(sortBy, sortDirection, expectedStartIndex);
        }

        [TestMethod]
        public void GetIndexOfComment_SortByCreatedSortDirectionAscending_ReturnsCorrectStartIndex()
        {
            var sortBy = "Created";
            var sortDirection = "Ascending";
            var expectedStartIndex = 2;

            ExecuteSP(sortBy, sortDirection, expectedStartIndex);
        }

        [TestMethod]
        public void GetIndexOfComment_InvalidPostId_ReturnsEmptySet()
        {
            using (new TransactionScope())
            {

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    var sql = string.Format("exec getindexofcomment @postid={0}, @sortby='Created', @sortdirection='Ascending'", Int32.MaxValue - 1);

                    reader.ExecuteDEBUGONLY(sql);
                    Assert.IsFalse(reader.HasRows);
                    Assert.IsFalse(reader.Read());
                }
            }
        }

        private void ExecuteSP(string sortBy, string sortDirection, int expectedStartIndex)
        {
            using (new TransactionScope())
            {

                using (IDnaDataReader reader = StoredProcedureReader.Create("", _connectionDetails))
                {
                    var sql = string.Format("exec getindexofcomment @postid={0}, @sortby='{1}', @sortdirection='{2}'", postId, sortBy, sortDirection);

                    reader.ExecuteDEBUGONLY(sql);
                    Assert.IsTrue(reader.HasRows);
                    Assert.IsTrue(reader.Read());
                    Assert.AreEqual(expectedStartIndex, reader.GetInt32NullAsZero("startindex"));
                }
            }
        }

    }
}
