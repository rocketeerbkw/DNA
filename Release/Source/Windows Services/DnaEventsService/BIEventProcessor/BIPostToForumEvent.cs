using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace Dna.BIEventSystem
{
    public class BIPostToForumEvent : BIEvent
    {
        public int? ThreadEntryId { get; private set; }
        public int ModClassId { get; private set; }
        public int SiteId { get; private set; }
        public int ForumId { get; private set; }
        public int? ThreadId { get; private set; }
        public int UserId { get; private set; }
        public int? NextSibling { get; private set; }
        public int? Parent { get; private set; }
        public int? PrevSibling { get; private set; }
        public int? FirstChild { get; private set; }
        public DateTime DatePosted { get; private set; }
        public string Text { get; private set; }

        /// <summary>
        /// Risky can get set through a call to RecordPostToForumEvent in the RiskMod system
        /// </summary>
        public bool? Risky { get; private set; }

        IRiskModSystem RiskModSys { get; set; }

        public BIPostToForumEvent(IRiskModSystem riskModSys)
        {
            RiskModSys = riskModSys;
        }

        protected override void SetProperties(IDnaDataReader reader)
        {
            base.SetProperties(reader);

            ThreadEntryId = reader.GetInt32("ThreadEntryId");
            ModClassId = reader.GetInt32("ModClassId");
            SiteId = reader.GetInt32("SiteId");
            ForumId = reader.GetInt32("ForumId");
            ThreadId = reader.GetInt32("ThreadId");
            UserId = reader.GetInt32("UserId");
            NextSibling = reader.GetNullableInt32("NextSibling");
            Parent = reader.GetNullableInt32("Parent");
            PrevSibling = reader.GetNullableInt32("PrevSibling");
            FirstChild = reader.GetNullableInt32("FirstChild");
            DatePosted = reader.GetDateTime("DatePosted");
            Text = reader.GetString("text");
        }

        public override void Process()
        {
            bool? risky;

            if (RiskModSys.RecordPostToForumEvent(this, out risky))
            {
                this.Risky = risky;
                Processed = true;
            }
        }
    }
}
