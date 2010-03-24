using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data.Objects;
using BBC.Dna.Utils;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Sites;
using BBC.Dna.Data;
using BBC.Dna.Users;

namespace BBC.Dna.Api
{
    public class EditorPicks : Context
    {
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public EditorPicks(IDnaDiagnostics dnaDiagnostics, string connection)
            : base(dnaDiagnostics, connection)
        { }

        /// <summary>
        /// Constructor without dna diagnostic object
        /// </summary>
        public EditorPicks()
        { }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="site"></param>
        public void CreateEditorPick(int commentId )
        {
            using (StoredProcedureReader reader = CreateReader("createcommenteditorpick"))
            {
                reader.AddParameter("entryid", commentId);
                reader.Execute();
            }
        }

        /// <summary>
        /// Reads a specific forum by the UID
        /// </summary>
        /// <param name="uid">The specific form uid</param>
        /// <returns>The specified forum including comment data</returns>
        public void RemoveEditorPick(int commentId )
        {
            using (StoredProcedureReader reader = CreateReader("removecommenteditorpick"))
            {
                reader.AddParameter("entryid", commentId);
                reader.Execute();
            }

        }
    }
}
