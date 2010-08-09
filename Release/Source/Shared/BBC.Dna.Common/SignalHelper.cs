using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.Specialized;
using BBC.Dna.Utils;

namespace BBC.Dna.Common
{
    public class SignalHelper
    {
        /// <summary>
        /// Collection of signalable objects
        /// </summary>
        static private Dictionary<string, ISignalBase> signalObjects = new Dictionary<string, ISignalBase>();

        /// <summary>
        /// adds the current object to the static dictionary of signal items
        /// </summary>
        /// <param name="type"></param>
        static public void AddObject(Type type, ISignalBase obj)
        {
            if (signalObjects.ContainsKey(type.ToString()))
            {
                signalObjects.Remove(type.ToString());
            }

            signalObjects.Add(type.ToString(), obj);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        static public object GetObject(Type type)
        {
            if (signalObjects.ContainsKey(type.ToString()))
            {
                return signalObjects[type.ToString()];
            }
            return null;
        }

        /// <summary>
        /// Handles the signal, checks if it the correct refresh required
        /// </summary>
        /// <param name="signalType"></param>
        /// <param name="args"></param>
        /// <returns></returns>
        static public void HandleSignal(NameValueCollection args)
        {
            bool signalHandled = false;
            string action = string.Empty;
            if (args != null && !String.IsNullOrEmpty(args["action"]))
            {
                
                foreach (var signalObj in signalObjects)
                {
                    var obj = (ISignalBase)signalObj.Value;
                    if (obj.HandleSignal(args["action"], args))
                    {
                        signalHandled = true;
                        break;
                    }
                }
                if (!signalHandled)
                {
                    throw new Exception("Signal not handled for following type:" + args["action"]);
                }
                
            }
            
            
        }

        /// <summary>
        /// 
        /// </summary>
        static public void ClearObjects()
        {
            signalObjects = new Dictionary<string, ISignalBase>();
        }

        /// <summary>
        /// Returns the status of the objects within the signal
        /// </summary>
        /// <returns></returns>
        static public SignalStatus GetStatus(IDnaDiagnostics dnaDiagnostics)
        {
            var signalStatus = new SignalStatus();

            foreach (var signalObj in signalObjects)
            {
                try
                {
                    var obj = (ISignalBase)signalObj.Value;
                    signalStatus.Members.Add(obj.GetStats(obj.GetType()));
                }
                catch (Exception e)
                {
                    dnaDiagnostics.WriteExceptionToLog(e);
                }
            }

            return signalStatus;
        }

    }
}

