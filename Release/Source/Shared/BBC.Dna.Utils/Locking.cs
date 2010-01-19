using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace BBC.Dna
{
	/// <summary>
	/// Helper class for standardised locking mechanisms
	/// </summary>
	public class Locking
	{
		/// <summary>
		/// Delegate to be used for locking static data
		/// </summary>
		/// <returns>An object reference of a fully initialised object</returns>
		public delegate void InitialiseCode(object context);

		/// <summary>
		/// Delegate which indicates if the static data needs to be initialised
		/// </summary>
		/// <returns>true if it needs initialising, false otherwise</returns>
		public delegate bool DoesDataNeedInitialising();

		/// <summary>
		/// Call this method to safely initialise or refresh a static class or structure
		/// </summary>
		/// <param name="_lock">object used to synchronise threads</param>
		/// <param name="init">delegate function to call which initialises a data structure and returns it</param>
		/// <param name="emptyTest">Delegate function which tests the data to see if it's empty (null)</param>
		/// <param name="recache">true if we want to force an update</param>
        /// <param name="context">The context this was called under</param>
        public static void InitialiseOrRefresh(object _lock, InitialiseCode init, DoesDataNeedInitialising emptyTest, bool recache, object context)
		{
			if (recache || (emptyTest()))
			{
				if (Monitor.TryEnter(_lock))
				{
					try
					{
						init(context);
					}
					finally
					{
						Monitor.Exit(_lock);
					}
				}
				else
				{
					Monitor.Enter(_lock);
					Monitor.Exit(_lock);
				}
				if (emptyTest())
				{
					throw new Exception("Unable to initialise data");
				}
			}
		}
	}
}
