using BBC.Dna.Data;
using BBC.Dna.Sites;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna.Api
{
    public class EditorPicks : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        /// <param name="dataReaderCreator"></param>
        public EditorPicks(IDnaDiagnostics dnaDiagnostics, IDnaDataReaderCreator dataReaderCreator, ICacheManager cacheManager, ISiteList siteList)
            : base(dnaDiagnostics, dataReaderCreator, cacheManager, siteList)
        {
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="commentId"></param>
        public void CreateEditorPick(int commentId)
        {
            using (IDnaDataReader reader = CreateReader("createcommenteditorpick"))
            {
                reader.AddParameter("entryid", commentId);
                reader.Execute();
            }
        }

        /// <summary>
        /// Reads a specific forum by the UID
        /// </summary>
        /// <returns>The specified forum including comment data</returns>
        public void RemoveEditorPick(int commentId)
        {
            using (IDnaDataReader reader = CreateReader("removecommenteditorpick"))
            {
                reader.AddParameter("entryid", commentId);
                reader.Execute();
            }
        }
    }
}