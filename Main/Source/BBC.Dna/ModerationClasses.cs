using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Moderation;
using Microsoft.Practices.EnterpriseLibrary.Caching;

namespace BBC.Dna.Component
{
    /// <summary>
    /// Class for generating User Moderation Classes XML.
    /// </summary>
    public class ModerationClasses : DnaInputComponent
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public ModerationClasses(IInputContext context)
            : base(context)
        { }

        /// <summary>
        /// Produce User Moderation User Statuses XML from database.
        /// Caching the XML would be a good idea before this is included on lots of moderation pages.
        /// </summary>
        public override void ProcessRequest()
        {
            const bool ignoreCache = false;
            var cache = CacheFactory.GetCacheManager();

            ModerationClassList moderationClassList =
                ModerationClassList.GetAllModerationClasses(AppContext.ReaderCreator, cache, ignoreCache);
            SerialiseAndAppend(moderationClassList, "");
        }
    }
}
