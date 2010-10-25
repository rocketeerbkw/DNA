using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Objects
{
    public class EmailAlertGroup
    {
        /// <summary>
        /// Checks if an item has a group alert
        /// </summary>
        /// <param name="reader"></param>
        /// <param name="groupId"></param>
        /// <param name="userId"></param>
        /// <param name="siteId"></param>
        /// <param name="itemType"></param>
        /// <param name="itemId"></param>
        static public void HasGroupAlertOnItem(IDnaDataReaderCreator readerCreator, ref int groupId, int userId, int siteId, EventItemTypes itemType, int itemId)
        {
            groupId =0;
            IDnaDataReader reader = null;
            switch (itemType)
            {
                case EventItemTypes.IT_FORUM: reader = readerCreator.CreateDnaDataReader("getforumgroupalertid"); reader.AddParameter("itemid", itemId); break;
                case EventItemTypes.IT_H2G2: reader = readerCreator.CreateDnaDataReader("getarticlegroupalertid"); reader.AddParameter("itemid", itemId); break;
                case EventItemTypes.IT_NODE: reader = readerCreator.CreateDnaDataReader("getnodegroupalertid"); reader.AddParameter("nodeid", itemId); break;
                case EventItemTypes.IT_THREAD: reader = readerCreator.CreateDnaDataReader("getthreadgroupalertid"); reader.AddParameter("threadid", itemId); break;
                case EventItemTypes.IT_CLUB: reader = readerCreator.CreateDnaDataReader("getclubgroupalertid"); reader.AddParameter("itemid", itemId); break;
                default: throw new NotImplementedException();
            }

            using (reader)
            {
                

                reader.AddParameter("userid", userId);
                reader.AddParameter("siteid", siteId);
                reader.Execute();
                if (reader.Read())
                {
                    groupId = reader.GetInt32NullAsZero("GroupID");
                }
            }
        }
    }
}

