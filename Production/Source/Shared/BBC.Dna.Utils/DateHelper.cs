using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Api
{
    public static class DateHelper
    {
        private static DateTime epoch = new DateTime(1970, 1, 1, 0, 0, 0);

        public static string TimeAgoInWords(this DateTime fromTime, DateTime toTime, bool includeSeconds)
        {
            TimeSpan ts = (toTime - fromTime).Duration();

            int distanceInMinutes = (int)ts.TotalMinutes;
            int distanceInSeconds = (int)ts.TotalSeconds;

            string inWords = string.Empty;

            if (distanceInMinutes < 1)
            {
                if (includeSeconds)
                {
                    if (InRange(0, 4, distanceInSeconds))
                    {
                        inWords = "less than 5 seconds";
                    }
                    else if (InRange(5, 9, distanceInSeconds))
                    {
                        inWords = "less than 10 seconds";
                    }
                    else if (InRange(10, 19, distanceInSeconds))
                    {
                        inWords = "less than 20 seconds";
                    }
                    else if (InRange(20, 39, distanceInSeconds))
                    {
                        inWords = "half a minute";
                    }
                    else if (InRange(40, 59, distanceInSeconds))
                    {
                        inWords = "less than a minute";
                    }
                    else
                    {
                        inWords = "1 minuite";
                    }
                }
                else
                {
                    inWords = distanceInMinutes == 0 ? "less than a minute" : "1 minute";
                }
            }
            else
            {
                if (InRange(2, 44, distanceInMinutes))
                {
                    inWords = string.Format("{0} minutes", distanceInMinutes);
                }
                else if (InRange(45, 89, distanceInMinutes))
                {
                    inWords = "about 1 hour";
                }
                else if (InRange(90, 1439, distanceInMinutes))
                {
                    inWords = string.Format("about {0} hours", RoundedDistance(distanceInMinutes, 60));
                }
                else if (InRange(1440, 2879, distanceInMinutes))
                {
                    inWords = "1 day";
                }
                else if (InRange(2880, 43199, distanceInMinutes))
                {
                    inWords = string.Format("about {0} days", RoundedDistance(distanceInMinutes, 1440));
                }
                else if (InRange(43200, 86399, distanceInMinutes))
                {
                    inWords = "about 1 month";
                }
                else if (InRange(86400, 525599, distanceInMinutes))
                {
                    inWords = string.Format("about {0} months", RoundedDistance(distanceInMinutes, 43200));
                }
                else if (InRange(525600, 1051199, distanceInMinutes))
                {
                    inWords = "about 1 year";
                }
                else
                {
                    inWords = string.Format("over {0} years", RoundedDistance(distanceInMinutes, 525600));
                }
            }
            return inWords;
        }

        public static string TimeAgoInWordsFromNow(this DateTime toTime, bool includeSeconds)
        {
            return TimeAgoInWords(DateTime.Now, toTime, includeSeconds);
        }

        public static long MillisecondsSinceEpoch(this DateTime dateTime)
        {
            long msSinceEpoch = (long)(dateTime - epoch).TotalMilliseconds;
            return msSinceEpoch;
        }

        private static int RoundedDistance(int value, int dividedBy)
        {
            return (int)decimal.Round(Convert.ToDecimal(value / dividedBy), MidpointRounding.AwayFromZero);
        }

        private static bool InRange(int low, int high, int value)
        {
            return (value >= low && value <= high);
        }
    }
}
