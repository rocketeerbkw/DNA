using System;
using System.Runtime.Serialization;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// Class to define the Open and Closing time (for a site)
    /// </summary>
    [Serializable]
    [DataContract(Name = "openCloseTime")]
    public class OpenCloseTime
    {
        /// <summary>
        /// Default Constructor for the OpenCloseTime object
        /// </summary>
        public OpenCloseTime()
        {
        }

        /// <summary>
        /// Constructor for the Open Close tiems object with initial values
        /// </summary>
        /// <param name="dayOfWeek">Day Of the Week</param>
        /// <param name="hour">Hour</param>
        /// <param name="minute">Minute</param>
        /// <param name="closed">If closed</param>
        public OpenCloseTime(int dayOfWeek, int hour, int minute, int closed)
        {
            DayOfWeek = dayOfWeek;
            Hour = hour;
            Minute = minute;
            Closed = closed;
        }

        /// <summary>
        /// Constructor from another Open Close Time object
        /// </summary>
        /// <param name="other">The other Open Close Time to create the new Open Close Time from</param>
        public OpenCloseTime(OpenCloseTime other)
        {
            DayOfWeek = other.DayOfWeek;
            Hour = other.Hour;
            Minute = other.Minute;
            Closed = other.Closed;
        }

        /// <summary>
        /// Public accessor for Day Of Week field
        /// </summary>
        [DataMember(Name = ("dayOfWeek"))]
        public int DayOfWeek { get; set; }

        /// <summary>
        /// Public accessor for Hour field
        /// </summary>
        [DataMember(Name = ("hour"))]
        public int Hour { get; set; }

        /// <summary>
        /// Public accessor for minute field
        /// </summary>
        [DataMember(Name = ("minute"))]
        public int Minute { get; set; }

        /// <summary>
        /// Public accessor for closed field
        /// </summary>
        [DataMember(Name = ("closed"))]
        public int Closed { get; set; }

        /// <summary>
        /// Function to compare this Open Close time against a given date time structure to see if 
        /// The open close time has already happened or not
        /// </summary>
        /// <param name="date">Passed in dat to check against</param>
        /// <returns>If the event has already happened</returns>
        public bool HasAlreadyHappened(DateTime date)
        {
            bool hasAlreadyHappened = false;

            //db code which contains c++ values has sunday = 1, monday =0 - c# has sunday =0, monday =1... so plus 1
            int dayOfWeek = 1+ (int) date.DayOfWeek;
            int hour = date.Hour;
            int minute = date.Minute;

            if ((dayOfWeek > DayOfWeek) ||
                (dayOfWeek == DayOfWeek && hour > Hour) ||
                (dayOfWeek == DayOfWeek && hour == Hour && minute >= Minute)
                )
            {
                hasAlreadyHappened = true;
            }
            else
            {
                hasAlreadyHappened = false;
            }

            return hasAlreadyHappened;
        }
    }
}