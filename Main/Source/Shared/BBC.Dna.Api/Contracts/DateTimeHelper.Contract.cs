using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


using System.Runtime.Serialization;
using BBC.Dna.Utils;

namespace BBC.Dna.Api
{
    [KnownType(typeof(DateTimeHelper))]
    [Serializable] [DataContract(Namespace = "BBC.Dna.Api")]
    public partial class DateTimeHelper : baseContract
    {
        private DateTime _dateTime;
        public DateTimeHelper(DateTime dateTime){
            //convert to current daylight savings time
            _dateTime = dateTime;
        }

        [DataMember(Name = "at", Order = 1)]
        public string At
        {
            get { return BBC.Dna.Utils.TimeZoneInfo.GetTimeZoneInfo().ConvertUtcToTimeZone(_dateTime).ToString("dd/MM/yyyy HH:mm:ss"); }
            set{}
        }

        [DataMember(Name = "ago", Order = 2)]
        public string Ago
        {
            get { return DnaDateTime.TryGetRelativeValueForPastDate(_dateTime.ToUniversalTime()); }
            set{}
        }
    }
}
