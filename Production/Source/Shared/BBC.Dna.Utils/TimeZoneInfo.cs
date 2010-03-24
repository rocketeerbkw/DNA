using System;
using System.Collections;
using System.Text;
using System.Globalization;
using Microsoft.Win32;

namespace BBC.Dna.Utils
{


   /// <summary>
   /// Class for managing Time Zone Information.
   /// As the local machine may have settings that differ from standard for local time zone the time zone 
   /// information is retrieved from the registry.
   /// The TimeZoneInfo class is provided with .NET 3.5 where this class will have exceeded its usefulness.
    /// Class adapted from msdn class provided by Microsoft : http://blogs.msdn.com/bclteam/archive/2006/04/03/567119.aspx
   /// </summary>
    public class TimeZoneInfo {

        private String _displayName;
        private String _standardName;
        private String _daylightName;
        private Boolean _supportsDst;
        private TimeSpan _bias;
        private TimeSpan _daylightBias;
        private DateTime _standardTransitionTimeOfDay;
        private Int32 _standardTransitionMonth;
        private Int32 _standardTransitionWeek;
        private Int32 _standardTransitionDayOfWeek;
        private DateTime _daylightTransitionTimeOfDay;
        private Int32 _daylightTransitionMonth;
        private Int32 _daylightTransitionWeek;
        private Int32 _daylightTransitionDayOfWeek;

        private static TimeZoneInfo _instance = null;

        /// <summary>
        /// 
        /// </summary>
        private TimeZoneInfo() 
        {
        }

        /// <summary>
        /// This class is a singleton with a one-time initialisation.
        /// Return a correctly initialised TimeZoneInfo.
        /// </summary>
        /// <returns></returns>
        public static TimeZoneInfo GetTimeZoneInfo()
        {
            if (_instance == null)
            {
                _instance = new TimeZoneInfo();
                _instance.Initialise();
            }
            return _instance;
        }

        /// <summary>
        /// Initalise members to current time zone.
        /// Users local time zone is not used as wish to ignore user overrides.
        /// Front end servers are set to GMT and ignore BST .
        /// </summary>
        private void Initialise()
        {
            TimeZone current = TimeZone.CurrentTimeZone;
            TimeZoneInfo[] timeZones = GetTimeZonesFromRegistry();
            for (int i = 0; i < timeZones.Length; ++i)
            {
                if (timeZones[i].StandardName == current.StandardName)
                {
                     TimeZoneInfo localTimeZone = timeZones[i];

                    // Copy Data to current instance.
                    _displayName = localTimeZone._displayName;
                    _standardName = localTimeZone._standardName;
                    _daylightName = localTimeZone._daylightName;
                    _supportsDst = localTimeZone._supportsDst;
                    _bias = localTimeZone._bias;
                    _daylightBias = localTimeZone._daylightBias;
                    
                    _standardTransitionTimeOfDay = localTimeZone._standardTransitionTimeOfDay;
                    _standardTransitionMonth = localTimeZone._standardTransitionMonth;
                    _standardTransitionWeek = localTimeZone._standardTransitionWeek;
                    _standardTransitionDayOfWeek = localTimeZone._standardTransitionDayOfWeek;
                    
                    _daylightTransitionTimeOfDay = localTimeZone._daylightTransitionTimeOfDay;
                    _daylightTransitionMonth = localTimeZone._daylightTransitionMonth;
                    _daylightTransitionWeek = localTimeZone._daylightTransitionWeek;
                    _daylightTransitionDayOfWeek = localTimeZone._daylightTransitionDayOfWeek;

                }
            }


        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return DisplayName;
        }

        /// <summary>
        /// 
        /// </summary>
        public String DisplayName {
            get {
                return _displayName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public String StandardName {
            get {
                return _standardName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public String DaylightName {
            get {
                return _daylightName;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Boolean SupportsDaylightSavings {
            get {
                return _supportsDst;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public TimeSpan Bias {
            get {
                return _bias;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public TimeSpan DaylightBias {
            get {
                return _daylightBias;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public DateTime StandardTransitionTimeOfDay {
            get {
                return _standardTransitionTimeOfDay;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 StandardTransitionMonth {
            get {
                return _standardTransitionMonth;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 StandardTransitionWeek {
            get {
                return _standardTransitionWeek;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 StandardTransitionDayOfWeek {
            get {
                return _standardTransitionDayOfWeek;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public DateTime DaylightTransitionTimeOfDay {
            get {
                return _daylightTransitionTimeOfDay;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 DaylightTransitionMonth {
            get {
                return _daylightTransitionMonth;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 DaylightTransitionWeek {
            get {
                return _daylightTransitionWeek;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public Int32 DaylightTransitionDayOfWeek {
            get {
                return _daylightTransitionDayOfWeek;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private TimeZoneInfo[] GetTimeZonesFromRegistry() {

            ArrayList timeZoneList = new ArrayList();

            // Extract the information from the registry into an arraylist.
            String timeZoneKeyPath = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Time Zones";
            using (RegistryKey timeZonesKey = Registry.LocalMachine.OpenSubKey(timeZoneKeyPath)) {
                String[] zoneKeys = timeZonesKey.GetSubKeyNames();
                Int32 zoneKeyCount = zoneKeys.Length;
                for (Int32 i = 0; i < zoneKeyCount; i++) {
                    using (RegistryKey timeZoneKey = timeZonesKey.OpenSubKey(zoneKeys[i])) {
                        TimeZoneInfo newTimeZone = new TimeZoneInfo();
                        newTimeZone._displayName = (String)timeZoneKey.GetValue("Display");
                        newTimeZone._daylightName = (String)timeZoneKey.GetValue("Dlt");
                        newTimeZone._standardName = (String)timeZoneKey.GetValue("Std");
                        //newTimeZone.m_index = (Int32)timeZoneKey.GetValue("Index");
                        Byte[] bytes = (Byte[])timeZoneKey.GetValue("TZI");
                        newTimeZone._bias = new TimeSpan(0, BitConverter.ToInt32(bytes, 0), 0);
                        newTimeZone._daylightBias = new TimeSpan(0, BitConverter.ToInt32(bytes, 8), 0);
                        newTimeZone._standardTransitionMonth = BitConverter.ToInt16(bytes, 14);
                        newTimeZone._standardTransitionDayOfWeek = BitConverter.ToInt16(bytes, 16);
                        newTimeZone._standardTransitionWeek = BitConverter.ToInt16(bytes, 18);
                        newTimeZone._standardTransitionTimeOfDay = new DateTime(1, 1, 1,
                                                                    BitConverter.ToInt16(bytes, 20),
                                                                    BitConverter.ToInt16(bytes, 22),
                                                                    BitConverter.ToInt16(bytes, 24),
                                                                    BitConverter.ToInt16(bytes, 26));
                        newTimeZone._daylightTransitionMonth = BitConverter.ToInt16(bytes, 30);
                        newTimeZone._daylightTransitionDayOfWeek = BitConverter.ToInt16(bytes, 32);
                        newTimeZone._daylightTransitionWeek = BitConverter.ToInt16(bytes, 34);
                        newTimeZone._daylightTransitionTimeOfDay = new DateTime(1, 1, 1,
                                                                    BitConverter.ToInt16(bytes, 36),
                                                                    BitConverter.ToInt16(bytes, 38),
                                                                    BitConverter.ToInt16(bytes, 40),
                                                                    BitConverter.ToInt16(bytes, 42));
                        newTimeZone._supportsDst = (newTimeZone._standardTransitionMonth != 0);
                        timeZoneList.Add(newTimeZone);
                    }
                }
            }
            // Put the time zone infos into an array and sort them by the Index Property
            TimeZoneInfo[] timeZoneInfos = new TimeZoneInfo[timeZoneList.Count];
            Int32[] timeZoneOrders = new Int32[timeZoneList.Count];
            for (Int32 i = 0; i < timeZoneList.Count; i++) {
                TimeZoneInfo zoneInfo = (TimeZoneInfo)timeZoneList[i]; 
                timeZoneInfos[i] = zoneInfo;
                //timeZoneOrders[i] = zoneInfo.Index;
            }
            //Array.Sort(timeZoneOrders, timeZoneInfos);

            return timeZoneInfos;
        }

        private DateTime GetRelativeDate(int year, int month, int targetDayOfWeek, int numberOfSundays) {
            DateTime time;

            if (numberOfSundays <= 4) {
                //
                // Get the (numberOfSundays)th Sunday.
                //
                time = new DateTime(year, month, 1);

                int dayOfWeek = (int)time.DayOfWeek;
                int delta = targetDayOfWeek - dayOfWeek;
                if (delta < 0) {
                    delta += 7;
                }
                delta += 7 * (numberOfSundays - 1);

                if (delta > 0) {
                    time = time.AddDays(delta);
                }
            }
            else {
                //
                // If numberOfSunday is greater than 4, we will get the last sunday.
                //
                Int32 daysInMonth = DateTime.DaysInMonth(year, month);
                time = new DateTime(year, month, daysInMonth);
                // This is the day of week for the last day of the month.
                int dayOfWeek = (int)time.DayOfWeek;
                int delta = dayOfWeek - targetDayOfWeek;
                if (delta < 0) {
                    delta += 7;
                }

                if (delta > 0) {
                    time = time.AddDays(-delta);
                }
            }
            return time;
        }


        private DaylightTime GetDaylightTime(Int32 year, TimeZoneInfo zone) {
            TimeSpan delta = zone.DaylightBias;
            DateTime startTime = GetRelativeDate(year, zone.DaylightTransitionMonth, zone.DaylightTransitionDayOfWeek, zone.DaylightTransitionWeek);
            startTime = startTime.AddTicks(zone.DaylightTransitionTimeOfDay.Ticks);
            DateTime endTime = GetRelativeDate(year, zone.StandardTransitionMonth, zone.StandardTransitionDayOfWeek, zone.StandardTransitionWeek);
            endTime = endTime.AddTicks(zone.StandardTransitionTimeOfDay.Ticks);
            return new DaylightTime(startTime, endTime, delta);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <param name="zone"></param>
        /// <returns></returns>
        public Boolean GetIsDalightSavingsFromLocal(DateTime time, TimeZoneInfo zone) {
            if (!zone.SupportsDaylightSavings) {
                return false;
            }
            DaylightTime daylightTime = GetDaylightTime(time.Year, zone);

            // startTime and endTime represent the period from either the start of DST to the end and includes the 
            // potentially overlapped times
            DateTime startTime = daylightTime.Start - zone.DaylightBias;
            DateTime endTime = daylightTime.End;

            Boolean isDst = false;
            if (startTime > endTime) {
                // In southern hemisphere, the daylight saving time starts later in the year, and ends in the beginning of next year.
                // Note, the summer in the southern hemisphere begins late in the year.
                if (time >= startTime || time < endTime) {
                    isDst = true;
                }
            }
            else if (time>=startTime && time < endTime) {
                // In northern hemisphere, the daylight saving time starts in the middle of the year.
                isDst = true;
            }

            return isDst;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <param name="zone"></param>
        /// <returns></returns>
        public Boolean GetIsDalightSavingsFromUtc(DateTime time, TimeZoneInfo zone) {
            if (!zone.SupportsDaylightSavings) {
                return false;
            }

            // Get the daylight changes for the year of the specified time.
            TimeSpan offset = -zone.Bias;
            DaylightTime daylightTime = GetDaylightTime(time.Year, zone);

            // The start and end times represent the range of universal times that are in DST for that year.                
            // Within that there is an ambiguous hour, usually right at the end, but at the beginning in
            // the unusual case of a negative daylight savings delta.
            DateTime startTime = daylightTime.Start - offset;
            DateTime endTime = daylightTime.End - offset + zone.DaylightBias;

            Boolean isDst = false;
            if (startTime > endTime) {
                // In southern hemisphere, the daylight saving time starts later in the year, and ends in the beginning of next year.
                // Note, the summer in the southern hemisphere begins late in the year.
                isDst = (time < endTime || time >= startTime);
            }
            else {
                // In northern hemisphere, the daylight saving time starts in the middle of the year.
                isDst = (time >= startTime && time < endTime);
            }
            return isDst;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <returns></returns>
        private TimeSpan GetUtcOffsetFromLocal(DateTime time) {
            TimeSpan baseOffset = -Bias;
            Boolean isDaylightSavings = GetIsDalightSavingsFromLocal(time, this);
            TimeSpan finalOffset = baseOffset -= (isDaylightSavings ? DaylightBias : TimeSpan.Zero);
            return baseOffset;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <returns></returns>
        private TimeSpan GetUtcOffsetFromUtc(DateTime time) {
            TimeSpan baseOffset = -Bias;
            Boolean isDaylightSavings = GetIsDalightSavingsFromUtc(time, this);
            TimeSpan finalOffset = baseOffset -= (isDaylightSavings ? DaylightBias : TimeSpan.Zero);
            return baseOffset;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <returns></returns>
        public DateTime ConvertTimeZoneToUtc(DateTime time) {
            TimeSpan offset = GetUtcOffsetFromLocal(time);
            DateTime utcConverted = new DateTime(time.Ticks - offset.Ticks);
            return utcConverted;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="time"></param>
        /// <returns></returns>
        public DateTime ConvertUtcToTimeZone(DateTime time) {
            TimeSpan offset = GetUtcOffsetFromUtc(time);
            DateTime localConverted = new DateTime(time.Ticks + offset.Ticks);
            return localConverted;
        }

       
        //public static DateTime ConvertTimeZoneToTimeZone(DateTime time, TimeZoneInfo zoneSource, TimeZoneInfo zoneDestination) {
        //    DateTime utcConverted = ConvertTimeZoneToUtc(time, zoneSource);
        //    DateTime localConverted = ConvertUtcToTimeZone(utcConverted, zoneDestination);
        //    return localConverted;
       // }

    }

}
