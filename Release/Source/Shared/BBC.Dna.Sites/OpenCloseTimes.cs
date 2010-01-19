using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace BBC.Dna.Sites
{
    /// <summary>
    /// Class to define the Open and Closing time (for a site)
    /// </summary>
    public class OpenCloseTime
    {
        private	int _dayOfWeek;
        private	int _hour;
        private	int _minute;
        private	int _closed;

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
            _dayOfWeek = dayOfWeek;
            _hour = hour;
            _minute = minute;
            _closed = closed;
        }

        /// <summary>
        /// Constructor from another Open Close Time object
        /// </summary>
        /// <param name="other">The other Open Close Time to create the new Open Close Time from</param>
        public OpenCloseTime(OpenCloseTime other)
        {
            _dayOfWeek = other.DayOfWeek;
            _hour = other.Hour;
            _minute = other.Minute;
            _closed = other.Closed;
        }

        /// <summary>
        /// Function to compare this Open Close time against a given date time structure to see if 
        /// The open close time has already happened or not
        /// </summary>
        /// <param name="date">Passed in dat to check against</param>
        /// <returns>If the event has already happened</returns>
	    public bool HasAlreadyHappened(DateTime date)
        {
            bool hasAlreadyHappened = false;

			int dayOfWeek = 1 + (int)date.DayOfWeek;
            int hour = date.Hour;
            int minute = date.Minute;

            if ((dayOfWeek > _dayOfWeek) ||
                (dayOfWeek == _dayOfWeek && hour > _hour) ||
                (dayOfWeek == _dayOfWeek && hour == _hour && minute >= _minute)
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

        /// <summary>
        /// Public accessor for Day Of Week field
        /// </summary>
        public int DayOfWeek
        {
          get 
          { 
              return _dayOfWeek; 
          }
          set 
          { 
              _dayOfWeek = value; 
          }
        }
        /// <summary>
        /// Public accessor for Hour field
        /// </summary>
        public int Hour
        {
          get 
          { 
              return _hour; 
          }
          set 
          { 
              _hour = value; 
          }
        }
        /// <summary>
        /// Public accessor for minute field
        /// </summary>
        public int Minute
        {
          get 
          { 
              return _minute;
          }
          set 
          { 
              _minute = value; 
          }
        }
        /// <summary>
        /// Public accessor for closed field
        /// </summary>
        public int Closed
        {
          get 
          { 
              return _closed; 
          }
          set 
          { 
              _closed = value; 
          }
        }
    }
}
