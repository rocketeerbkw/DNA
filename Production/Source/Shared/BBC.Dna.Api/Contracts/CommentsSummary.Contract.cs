using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [KnownType(typeof(CommentsSummary))]
    [Serializable] [DataContract(Name = "commentsSummary", Namespace = "BBC.Dna.Api")]
    public partial class CommentsSummary : baseContract
    {
        public CommentsSummary() { }

        [DataMember(Name = "total", Order = 1)]
        public int Total
        {
            get;
            set;
        }

        [DataMember(Name = ("uri"), Order = 2)]
        public string Uri
        {
            get;
            set;
        }

        [DataMember(Name = "editorPicksTotal", Order = 1)]
        public int EditorPicksTotal
        {
            get;
            set;
        }

    }
}
