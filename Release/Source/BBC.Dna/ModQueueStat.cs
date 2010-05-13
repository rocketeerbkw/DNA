using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna
{
    class ModQueueStat
    {
        string _state;

        public string State
        {
            get { return _state; }
            set { _state = value; }
        }
        string _objectType;

        public string ObjectType
        {
            get { return _objectType; }
            set { _objectType = value; }
        }
        DateTime _minDateQueued;

        public DateTime MinDateQueued
        {
            get { return _minDateQueued; }
            set { _minDateQueued = value; }
        }
        bool _fastMod;

        public bool IsFastMod
        {
            get { return _fastMod; }
            set { _fastMod = value; }
        }
        int _modClassId;

        public int ModClassId
        {
            get { return _modClassId; }
            set { _modClassId = value; }
        }
        int _timeLeft;

        public int TimeLeft
        {
            get { return _timeLeft; }
            set { _timeLeft = value; }
        }
        int _total;

        public int Total
        {
            get { return _total; }
            set { _total = value; }
        }


        public ModQueueStat(string state, string objectType,
                DateTime minDateQueued, bool fastMod,
                int modClassId, int timeLeft, int total)
        {
            _state = state;
            _objectType = objectType;
            _minDateQueued = minDateQueued;
            _fastMod = fastMod;
            _modClassId = modClassId;
            _timeLeft = timeLeft;
            _total = total;
        }

        public ModQueueStat(string state, string objectType,
                bool fastMod, int modClassId)
        {
            _state = state;
            _objectType = objectType;
            _minDateQueued = DateTime.MinValue;
            _fastMod = fastMod;
            _modClassId = modClassId;
            _timeLeft = 0;
            _total = 0;
        }
    }
}
