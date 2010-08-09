using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;

namespace BBC.Dna.Common
{
    public interface ISignalBase
    {
        /// <summary>
        /// Looks for the correct signal in the list of known signals and passes information onto it for handling
        /// </summary>
        /// <param name="signalType"></param>
        /// <param name="args"></param>
        /// <returns></returns>
        bool HandleSignal(string signalType, NameValueCollection args);

        /// <summary>
        /// Returns the status of the object
        /// </summary>
        /// <returns></returns>
        SignalStatusMember GetStats(Type type);

    }
}
