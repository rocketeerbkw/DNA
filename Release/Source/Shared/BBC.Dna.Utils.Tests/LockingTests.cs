using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using BBC.Dna;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;

namespace BBC.Dna.Utils.Tests
{
	/// <summary>
	/// tests for locking helper class
	/// </summary>
	[TestClass]
	public class LockingTests
	{
		private class myData
		{
			public int _delay = 0;
			public int _whichWork = 1;
			public bool _recache = false;
			public string message = ":message not set:";
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="data"></param>
		public void SecondThreadCode(object data)
		{
			Assert.IsInstanceOfType(data,new myData().GetType(), "data is wrong type of object");
			myData mydata = (myData)data;
			Console.WriteLine(":SecondThreadCode ({0})", mydata.message);
			Assert.IsNotNull(data, "Second thread: object is not null");
            if (mydata._delay > 0)
            {
                Thread.Sleep(mydata._delay);
            }
            if (mydata._whichWork == 2)
            {
                Console.WriteLine(":Doing second piece of work");
                Locking.InitialiseOrRefresh(sharedLock, SecondThreadWork, IsStringAssigned, mydata._recache, null);
            }
            else if (mydata._whichWork == 1)
            {
                Console.WriteLine(":Doing first piece of work");
                Locking.InitialiseOrRefresh(sharedLock, FirstThreadWork, IsStringAssigned, mydata._recache, null);
            }
            else
            {
                for (int i = 0; i < 10; i++)
                {
                    Locking.InitialiseOrRefresh(sharedLock, ThirdThreadWork, IsStringAssigned, mydata._recache, null);
                }
            }
            try
            {
                Console.WriteLine(":Finished second thread");
            }
            catch { }
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public bool IsStringAssigned()
		{
			return (syncstring == null);
		}

		/// <summary>
		/// 
		/// </summary>
		public void SecondThreadWork(object context)
		{
			Console.WriteLine("SecondThreadWork");
			Interlocked.Increment(ref _numSecond);
			syncstring = "SecondThreadWork";
		}

		/// <summary>
		/// 
		/// </summary>
        public void ThirdThreadWork(object context)
		{
			Console.WriteLine("ThirdThreadWork");
			Interlocked.Increment(ref _numFirst);
			Random rand = new Random();
			Thread.Sleep(rand.Next(70));
			syncstring = "ThirdThreadWork";
		}

		/// <summary>
		/// 
		/// </summary>
        public void FourthThreadWork(object context)
		{
			Console.WriteLine("FourthThreadWork");
			Interlocked.Increment(ref _numSecond);
			Random rand = new Random();
			Thread.Sleep(rand.Next(70));
			syncstring = "FourthThreadWork";
		}

		/// <summary>
		/// 
		/// </summary>
        public void FirstThreadWork(object context)
		{
			Console.WriteLine("FirstThreadWork");
			Interlocked.Increment(ref _numFirst);
			syncstring = "FirstThreadWork";
		}

		/// <summary>
		/// 
		/// </summary>
		private static object sharedLock = new object();
		private static string syncstring;
		private static int _numSecond = 0;
		private static int _numFirst = 0;

		/// <summary>
		/// 
		/// </summary>
		[TestMethod]
		public void Locktest()
		{
            Console.WriteLine("Locktest");

            myData data = new myData();
            data.message = ": 1 :";
            data._delay = 200;
            data._whichWork = 2;
            data._recache = false;
            Thread newThread = new Thread(new ParameterizedThreadStart(SecondThreadCode));
            newThread.Start(data);
            Locking.InitialiseOrRefresh(sharedLock, FirstThreadWork, IsStringAssigned, false, null);
            newThread.Join();
            Assert.IsNotNull(syncstring, "String still null after initialisation");
            Assert.AreEqual("FirstThreadWork", syncstring, "Failed after first attempt");
            syncstring = null;

            data.message = ": 2 :";
            data._whichWork = 1;
            newThread = new Thread(new ParameterizedThreadStart(SecondThreadCode));
            newThread.Start(data);
            Locking.InitialiseOrRefresh(sharedLock, SecondThreadWork, IsStringAssigned, false, null);
            newThread.Join();
            Assert.IsNotNull(syncstring, "String still null after initialisation");
            Assert.AreEqual("SecondThreadWork", syncstring, "Failed after second attempt");

            data.message = ": 3 :";
            syncstring = null;
            data._whichWork = 1;
            data._delay = 0;
            newThread = new Thread(new ParameterizedThreadStart(SecondThreadCode));
            newThread.Start(data);
            Thread.Sleep(100);
            Locking.InitialiseOrRefresh(sharedLock, SecondThreadWork, IsStringAssigned, false, null);
            newThread.Join();
            Assert.IsNotNull(syncstring, "String still null after initialisation");
            Assert.AreEqual("FirstThreadWork", syncstring, "Failed after second attempt");

            Assert.AreEqual(2, _numFirst, "First should have only run twice");
            Assert.AreEqual(1, _numSecond, "Second shold only have run first");

            data.message = ": 4 :";
            data._whichWork = 1;
            data._delay = 0;
            newThread = new Thread(new ParameterizedThreadStart(SecondThreadCode));
            newThread.Start(data);
            Thread.Sleep(100);
            Locking.InitialiseOrRefresh(sharedLock, SecondThreadWork, IsStringAssigned, false, null);
            newThread.Join();
            Assert.IsNotNull(syncstring, "String still null after initialisation");
            Assert.AreEqual("FirstThreadWork", syncstring, "Failed after second attempt");

            Assert.AreEqual(2, _numFirst, "First should have only run twice");
            Assert.AreEqual(1, _numSecond, "Second shold only have run first");

            data.message = ": 5 :";
            data._whichWork = 1;
            data._delay = 0;
            data._recache = true;
            newThread = new Thread(new ParameterizedThreadStart(SecondThreadCode));
            newThread.Start(data);
            Thread.Sleep(1000);
            Console.WriteLine("Calling from first thread");
            Locking.InitialiseOrRefresh(sharedLock, SecondThreadWork, IsStringAssigned, true, null);
            Console.WriteLine("Finished from first thread");
            newThread.Join();
            Assert.IsNotNull(syncstring, "String still null after initialisation");
            Assert.AreEqual("SecondThreadWork", syncstring, "Failed after second attempt");

            Assert.AreEqual(3, _numFirst, "First should have only run twice");
            Assert.AreEqual(2, _numSecond, "Second shold only have run first");

            for (int j = 0; j < 1; j++)
            {
                _numFirst = 0;
                _numSecond = 0;
                //syncstring = null;
                Console.WriteLine(" -- first = {0}, second = {1}", _numFirst, _numSecond);
                data._whichWork = 3;
                data._delay = 0;
                data._recache = true;
                newThread = new Thread(new ParameterizedThreadStart(SecondThreadCode));
                newThread.Start(data);
                for (int i = 0; i < 10; i++)
                {
                    Locking.InitialiseOrRefresh(sharedLock, FourthThreadWork, IsStringAssigned, true, null);
                }
                Console.WriteLine("first = {0}, second = {1}", _numFirst, _numSecond);
                //Assert.IsTrue(99 < (_numFirst + _numSecond), "Too few items");
                //Assert.IsTrue(150 > (_numFirst + _numSecond), "Too many items");
                Console.WriteLine("first = {0}, second = {1}", _numFirst, _numSecond);
            }
		}
	}
}
