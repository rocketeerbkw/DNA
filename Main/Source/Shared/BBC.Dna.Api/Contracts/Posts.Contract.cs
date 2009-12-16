using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [CollectionDataContract(Name = "posts", ItemName = "post")]
    public partial class Posts : List<PostInfo>
    {
    }
}
