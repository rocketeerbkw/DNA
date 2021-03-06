﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using BBC.Dna.Objects;

namespace BBC.Dna.Objects
{

    /// <remarks/>
    public partial class ExtraInfoCreator
    {
        static public string CreateExtraInfo(int type)
        {
            return String.Format(@"<EXTRAINFO><TYPE ID=""{0}"" NAME=""{1}""/></EXTRAINFO>", type, Article.GetArticleTypeFromInt(type).ToString());
        }
    }
}
