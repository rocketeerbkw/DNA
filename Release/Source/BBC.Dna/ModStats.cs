using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    class ModStats
    {
        List<ModQueueStat> _stats = new List<ModQueueStat>();

        public List<ModQueueStat> Stats
        {
            get { return _stats; }
            set { _stats = value; }
        }

        public void Fetch(int userID, ModeratorInfo moderatorInfo, bool referrals, bool isFastMod)
        {
            using (IDnaDataReader dataReader = AppContext.TheAppContext.CreateDnaDataReader("fetchmoderationstatistics"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();

                CreateEmptyQueues(moderatorInfo, referrals, isFastMod);
            	
	            //replace empty items with actual queue data
	            while (dataReader.Read())
	            {
		            string state = dataReader.GetStringNullAsEmpty("state");
		            string objectType = dataReader.GetStringNullAsEmpty("type");
                    bool fastMod = (dataReader.GetInt32NullAsZero("fastmod") != 0);
                    int modClassId = dataReader.GetInt32NullAsZero("modclassid");

                    //the queue values
                    int total = dataReader.GetInt32NullAsZero("total");
                    int timeLeft = dataReader.GetInt32NullAsZero("timeleft");
		            DateTime minDateQueued = dataReader.GetDateTime("mindatequeued");

                    foreach(ModQueueStat oldModQueueStat in Stats)
                    {
                        if (oldModQueueStat.State == state &&
                            oldModQueueStat.ObjectType == objectType &&
                            oldModQueueStat.IsFastMod == fastMod &&
                            oldModQueueStat.ModClassId == modClassId)
                        {
                            oldModQueueStat.TimeLeft = timeLeft;
                            oldModQueueStat.MinDateQueued = minDateQueued;
                            oldModQueueStat.Total = total;
                        }
                    }
	            }
            }
        }

        private void CreateEmptyQueues(ModeratorInfo moderatorInfo, bool referrals, bool fastMod)
        {	
            Stats.Clear();
            for (int i = 0; i < moderatorInfo.ModeratorClasses.Count; i++)
            {
                int modClassID = moderatorInfo.ModeratorClasses[i];

                //forum posts and complaints
                Stats.Add(new ModQueueStat("queued", "forum", fastMod, modClassID));
                Stats.Add(new ModQueueStat("locked", "forum", fastMod, modClassID));
                Stats.Add(new ModQueueStat("queued", "forumcomplaint", fastMod, modClassID));
                Stats.Add(new ModQueueStat("locked", "forumcomplaint", fastMod, modClassID));

                if (referrals)
                {
                    //referred forum posts and complaints
                    Stats.Add(new ModQueueStat("queuedreffered", "forum", fastMod, modClassID));
                    Stats.Add(new ModQueueStat("lockedreffered", "forum", fastMod, modClassID));
                    Stats.Add(new ModQueueStat("queuedreffered", "forumcomplaint", fastMod, modClassID));
                    Stats.Add(new ModQueueStat("lockedreffered", "forumcomplaint", fastMod, modClassID));
                }

                //entries and complaints
                Stats.Add(new ModQueueStat("queued", "entry", fastMod, modClassID));
                Stats.Add(new ModQueueStat("locked", "entry", fastMod, modClassID));
                Stats.Add(new ModQueueStat("queued", "entrycomplaint", fastMod, modClassID));
                Stats.Add(new ModQueueStat("locked", "entrycomplaint", fastMod, modClassID));

                if (referrals)
                {
                    //referred entries and complaints
                    Stats.Add(new ModQueueStat("queuedreffered", "entry", fastMod, modClassID));
                    Stats.Add(new ModQueueStat("lockedreffered", "entry", fastMod, modClassID));
                    Stats.Add(new ModQueueStat("queuedreffered", "entrycomplaint", fastMod, modClassID));
                    Stats.Add(new ModQueueStat("lockedreffered", "entrycomplaint", fastMod, modClassID));
                }

                //nickname queues
                Stats.Add(new ModQueueStat("queued", "nickname", fastMod, modClassID));
                Stats.Add(new ModQueueStat("locked", "nickname", fastMod, modClassID));

                //general complaints
                Stats.Add(new ModQueueStat("queued", "generalcomplaint", fastMod, modClassID));
                Stats.Add(new ModQueueStat("locked", "generalcomplaint", fastMod, modClassID));

                //referred general complaints
                Stats.Add(new ModQueueStat("queuedreffered", "generalcomplaint", fastMod, modClassID));
                Stats.Add(new ModQueueStat("lockedreffered", "generalcomplaint", fastMod, modClassID));
            }
        }
    }
}
