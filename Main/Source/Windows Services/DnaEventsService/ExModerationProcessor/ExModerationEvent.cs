using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;

using BBC.Dna.Data;
using BBC.Dna.Api;
using Microsoft.Practices.EnterpriseLibrary.PolicyInjection;
using System.Runtime.Serialization.Json;
using System.IO;
using BBC.Dna.Utils;

namespace Dna.SnesIntegration.ExModerationProcessor
{
    class ExModerationEvent : MarshalByRefObject
    {
        public int ModId
        {
            get;
            set;
        }

        public string Notes
        {
            get;
            set;
        }

        public string Uri
        {
            get;
            set;
        }

        public string CallBackUri
        {
            get;
            set;
        }

        public int Decision
        {
            get;
            set;
        }

        public DateTime DateCompleted
        {
            get;
            set;
        }

        public String ToXml()
        {
            ModerationDecisionItem item = new ModerationDecisionItem();
            item.Id = ModId;
            item.Notes = Notes;
            item.Status = Enum.GetName(typeof(ModDecisionEnum), Decision);
            item.Uri = Uri;
            item.DateCompleted = DateCompleted.ToString();

            return StringUtils.SerializeToXml(item);
        }

        public String ToJSON()
        {
            ModerationDecisionItem item = new ModerationDecisionItem();
            item.Id = ModId;
            item.Notes = Notes;
            item.Status = Enum.GetName(typeof(ModDecisionEnum), Decision);
            item.Uri = Uri;
            item.DateCompleted = DateCompleted.ToString();

            return StringUtils.SerializeToJson(item);

        }

        public ExModerationEvent()
        {
        }

        public static ExModerationEvent CreateExModerationEvent(IDnaDataReader dataReader)
        {
            ExModerationEvent activity = PolicyInjection.Create<ExModerationEvent>();

            activity.ModId = dataReader.GetInt32NullAsZero("modid");
            activity.Notes = dataReader.GetString("notes") ?? "";
            activity.Uri = dataReader.GetString("uri") ?? "";
            activity.DateCompleted = dataReader.GetDateTime("datecompleted");
            activity.Decision = dataReader.GetInt32NullAsZero("status");
            activity.CallBackUri = dataReader.GetString("callbackuri") ?? "";

            return activity;
        }
    }
}

