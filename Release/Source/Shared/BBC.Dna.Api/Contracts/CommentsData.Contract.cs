﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;

namespace BBC.Dna.Api
{
    [Serializable] [DataContract(Name = "commentsData")]
    public partial class CommentsData : PostsData
    {
        public CommentsData() { }
    }
}
