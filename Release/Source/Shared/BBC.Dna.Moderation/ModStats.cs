using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Data;
using BBC.Dna.Utils;
using System.Xml.Serialization;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using BBC.Dna.Common;
using BBC.Dna.Sites;
using BBC.Dna.Objects;

namespace BBC.Dna.Moderation
{
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "2.0.50727.3053")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [XmlTypeAttribute(AnonymousType = true, TypeName = "MODERATORHOME")]
    [XmlRootAttribute("MODERATORHOME", Namespace = "", IsNullable = false)]
    public class ModStats
    {
        public ModStats()
        {
            ModerationQueues = new List<ModQueueStat>();
        }
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Order = 0, ElementName = "MODERATOR")]
        public ModeratorInfo Moderator
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlArrayAttribute("MODERATIONQUEUES", Order = 1)]
        [System.Xml.Serialization.XmlArrayItemAttribute("MODERATION-QUEUE-SUMMARY", IsNullable = false)]
        public List<ModQueueStat> ModerationQueues
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute("USERID")]
        public int UserId
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "ISREFEREE")]
        public byte IsReferee
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "FASTMOD")]
        public byte FastMod
        {
            get;
            set;
        }

        /// <remarks/>
        [System.Xml.Serialization.XmlAttributeAttribute(AttributeName = "NOTFASTMOD")]
        public byte NotFastMod
        {
            get;
            set;
        }


        /// <summary>
        /// Returns the mod stats by a site type
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userID"></param>
        /// <param name="type"></param>
        /// <param name="moderatorInfo"></param>
        /// <param name="referrals"></param>
        /// <param name="isFastMod"></param>
        /// <returns></returns>
        public static ModStats FetchModStatsBySiteType(IDnaDataReaderCreator creator, int userID, SiteType type, ModeratorInfo moderatorInfo, bool referrals, bool isFastMod)
        {
            var modStats = new ModStats() { Moderator = moderatorInfo, UserId = userID, IsReferee = (byte)(referrals?1:0) };
            modStats.CreateBlankModQueueStat(referrals, isFastMod, 0);
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("fetchmoderationstatisticsbytype"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("type", (int)type);
                
                dataReader.Execute();

                //replace empty items with actual queue data
                while (dataReader.Read())
                {
                    string state = dataReader.GetStringNullAsEmpty("state");
                    string objectType = dataReader.GetStringNullAsEmpty("type");
                    bool fastMod = (dataReader.GetInt32NullAsZero("fastmod") != 0);
                    

                    //the queue values
                    int total = dataReader.GetInt32NullAsZero("total");
                    int timeLeft = dataReader.GetInt32NullAsZero("timeleft");
                    DateTime minDateQueued = DateTime.MinValue;
                    if (!dataReader.IsDBNull("mindatequeued"))
                    {
                        minDateQueued = dataReader.GetDateTime("mindatequeued");
                    }

                    if (total != 0)
                    {
                        var item = modStats.ModerationQueues.Find(x => (x.ObjectType.ToUpper() == objectType.ToUpper() && x.State.ToUpper() == state.ToUpper()));
                        if(item != null)
                        {
                            item.TimeLeft = timeLeft;
                            item.Total = total;
                            item.MinDateQueued = new Date(minDateQueued);
                        }
                    }
                }
            }
            return modStats;
        }

        /// <summary>
        /// Returns the mod stats by a site type
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userID"></param>
        /// <param name="type"></param>
        /// <param name="moderatorInfo"></param>
        /// <param name="referrals"></param>
        /// <param name="isFastMod"></param>
        /// <returns></returns>
        public static ModStats FetchModStatsBySite(IDnaDataReaderCreator creator, int userID, int siteId, ModeratorInfo moderatorInfo, bool referrals, bool isFastMod)
        {
            var modStats = new ModStats() { Moderator = moderatorInfo, UserId = userID, IsReferee = (byte)(referrals ? 1 : 0) };
            modStats.CreateBlankModQueueStat(referrals, isFastMod, 0);
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("fetchmoderationstatisticsbysite"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.AddParameter("siteId", siteId);

                dataReader.Execute();

                //replace empty items with actual queue data
                while (dataReader.Read())
                {
                    string state = dataReader.GetStringNullAsEmpty("state");
                    string objectType = dataReader.GetStringNullAsEmpty("type");
                    bool fastMod = (dataReader.GetInt32NullAsZero("fastmod") != 0);
                    

                    //the queue values
                    int total = dataReader.GetInt32NullAsZero("total");
                    int timeLeft = dataReader.GetInt32NullAsZero("timeleft");
                    DateTime minDateQueued = DateTime.MinValue;
                    if (!dataReader.IsDBNull("mindatequeued"))
                    {
                        minDateQueued = dataReader.GetDateTime("mindatequeued");
                    }

                    if (total != 0)
                    {
                        var item = modStats.ModerationQueues.Find(x => (x.ObjectType.ToUpper() == objectType.ToUpper() && x.State.ToUpper() == state.ToUpper()));
                        if(item != null)
                        {
                            item.TimeLeft = timeLeft;
                            item.Total = total;
                            item.MinDateQueued = new Date(minDateQueued);
                        }
                    }
                }
            }
            return modStats;
        }

        /// <summary>
        /// Returns the items grouped by modclassid
        /// </summary>
        /// <param name="creator"></param>
        /// <param name="userID"></param>
        /// <param name="moderatorInfo"></param>
        /// <param name="referrals"></param>
        /// <param name="isFastMod"></param>
        /// <returns></returns>
        public static ModStats FetchModStatsByModClass(IDnaDataReaderCreator creator, int userID, ModeratorInfo moderatorInfo, bool referrals, bool isFastMod)
        {
            var modStats = new ModStats() { Moderator = moderatorInfo, UserId = userID, IsReferee = (byte)(referrals ? 1 : 0) };
            modStats.CreateEmptyQueues(moderatorInfo, referrals, isFastMod);
            using (IDnaDataReader dataReader = creator.CreateDnaDataReader("fetchmoderationstatistics"))
            {
                dataReader.AddParameter("userID", userID);
                dataReader.Execute();

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

                    foreach (ModQueueStat oldModQueueStat in modStats.ModerationQueues)
                    {
                        if (oldModQueueStat.State == state &&
                            oldModQueueStat.ObjectType == objectType &&
                            oldModQueueStat.FastMod == (byte)(fastMod?1:0) &&
                            oldModQueueStat.ClassId == modClassId)
                        {
                            oldModQueueStat.TimeLeft = timeLeft;
                            oldModQueueStat.MinDateQueued = new Date(minDateQueued);
                            oldModQueueStat.Total = total;
                        }
                    }
	            }
            }
            return modStats;
        }

        /// <summary>
        /// Creates a cleared list of states for the user
        /// </summary>
        /// <param name="moderatorInfo"></param>
        /// <param name="referrals"></param>
        /// <param name="fastMod"></param>
        public void CreateEmptyQueues(ModeratorInfo moderatorInfo, bool referrals, bool fastMod)
        {
            ModerationQueues.Clear();
            for (int i = 0; i < moderatorInfo.Classes.Count; i++)
            {
                int modClassID = moderatorInfo.Classes[i];

                CreateBlankModQueueStat(referrals, fastMod, modClassID);
            }
        }

        private void CreateBlankModQueueStat(bool referrals, bool fastMod, int modClassID)
        {
            //forum posts and complaints
            ModerationQueues.Add(new ModQueueStat("queued", "forum", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("locked", "forum", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("queued", "forumcomplaint", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("locked", "forumcomplaint", fastMod, modClassID));

            if (referrals)
            {
                //referred forum posts and complaints
                ModerationQueues.Add(new ModQueueStat("queuedreffered", "forum", fastMod, modClassID));
                ModerationQueues.Add(new ModQueueStat("lockedreffered", "forum", fastMod, modClassID));
                ModerationQueues.Add(new ModQueueStat("queuedreffered", "forumcomplaint", fastMod, modClassID));
                ModerationQueues.Add(new ModQueueStat("lockedreffered", "forumcomplaint", fastMod, modClassID));
            }

            //entries and complaints
            ModerationQueues.Add(new ModQueueStat("queued", "entry", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("locked", "entry", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("queued", "entrycomplaint", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("locked", "entrycomplaint", fastMod, modClassID));

            if (referrals)
            {
                //referred entries and complaints
                ModerationQueues.Add(new ModQueueStat("queuedreffered", "entry", fastMod, modClassID));
                ModerationQueues.Add(new ModQueueStat("lockedreffered", "entry", fastMod, modClassID));
                ModerationQueues.Add(new ModQueueStat("queuedreffered", "entrycomplaint", fastMod, modClassID));
                ModerationQueues.Add(new ModQueueStat("lockedreffered", "entrycomplaint", fastMod, modClassID));
            }

            //nickname queues
            ModerationQueues.Add(new ModQueueStat("queued", "nickname", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("locked", "nickname", fastMod, modClassID));

            //general complaints
            ModerationQueues.Add(new ModQueueStat("queued", "generalcomplaint", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("locked", "generalcomplaint", fastMod, modClassID));

            //referred general complaints
            ModerationQueues.Add(new ModQueueStat("queuedreffered", "generalcomplaint", fastMod, modClassID));
            ModerationQueues.Add(new ModQueueStat("lockedreffered", "generalcomplaint", fastMod, modClassID));
        }
    }

}
