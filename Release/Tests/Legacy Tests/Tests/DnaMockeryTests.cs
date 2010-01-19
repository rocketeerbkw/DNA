using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NMock2;

namespace Tests
{
	/// <summary>
	/// Testing the Mocked version of our Input Contexts etc
	/// </summary>
	[TestClass]
	public class DnaMockeryTests
	{
		/// <summary>
		/// Testing the mocked data input context
		/// </summary>
		[TestMethod]
		public void TestDataContext()
		{
			IInputContext context = DnaMockery.CreateDatabaseInputContext();
			using (IDnaDataReader reader = context.CreateDnaDataReader("finduserfromid"))
			{
				reader.AddParameter("userid", 6);
				reader.Execute();
				Assert.IsTrue(reader.HasRows, "No rows returned");
				Assert.IsTrue(reader.Read(), "Failed to read a row");
				Assert.AreEqual(6, reader.GetInt32("userid"), "UserID Not 6");
			}
		}
	}
}
