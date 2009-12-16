using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [CollectionDataContract(Name = "articles", ItemName = "article")]
    public partial class Articles : List<ArticleInfo>
    {
    }
}
