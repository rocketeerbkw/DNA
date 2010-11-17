using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Data;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    /// <summary>
    /// StoredProcedureReader Tests class
    /// </summary>
    [TestClass]
    public class StoredProcedureReaderTests
    {
        /// <summary>
        /// Create data reader test
        /// </summary>
        [TestMethod]
        public void CreateDataReader()
        {
            Console.WriteLine("Before CreateDataReader");
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            string name = String.Empty;
            using (IDnaDataReader dataReader = context.CreateDnaDataReader(name))
            {
                Assert.IsInstanceOfType( dataReader,typeof(StoredProcedureReader));
            }
        }

        /// <summary>
        /// Test calling invalid stored procedure
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(SqlException))]
        public void InvalidStoredProcedureTest()
        {
            Console.WriteLine("Before InvalidStoredProcedureTest");
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("nonexistantstoredprocedure"))
                {
                    dataReader.Execute();
                }
            }
            catch (SqlException ex)
            {
                StringAssert.StartsWith(ex.Message, "Could not find stored procedure");
                throw;
            }
        }

        /// <summary>
        /// Test not supplying an expected parameter
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(SqlException))]
        public void NotSuppliedParameterExceptionTest()
        {
            Console.WriteLine("Before NotSuppliedParameterExceptionTest");
            string name = "fetchnewusers";
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader(name))
                {
                    dataReader.Execute();
                }
            }
            catch (SqlException ex)
            {
                string expected = string.Format("Procedure or Function '{0}' expects parameter", name);
                StringAssert.StartsWith( ex.Message.ToLower(),expected.ToLower());
                throw;
            }
        }

        /// <summary>
        /// Test to supply an incorrect parameter.
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(SqlException))]
        public void IncorrectSuppliedParameterExceptionTest()
        {
            Console.WriteLine("Before IncorrectSuppliedParameterExceptionTest");
            string paramName = "@somestupidparamname";           
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("finduserfromid"))
                {
                    dataReader.AddParameter(paramName, "");
                    dataReader.Execute();
                }
            }
            catch (SqlException ex)
            {
                string expected = string.Format("{0}", paramName);
                StringAssert.StartsWith( ex.Message,expected);
                throw;
            }
        }

        /// <summary>
        /// Test to read from a column not in the results.
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(IndexOutOfRangeException))]
        public void InvalidColumnNameTest()
        {
            Console.WriteLine("Before InvalidColumnNameTest");
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("finduserfromid"))
                {
                    dataReader.AddParameter("@userid", 6);
                    dataReader.Execute();
                    object obj = dataReader["notavalidcolname"];
                }
            }
            catch (IndexOutOfRangeException ex)
            {
                string expected = "notavalidcolname";
                StringAssert.StartsWith( ex.Message,expected);
                throw;
            }
        }

        /// <summary>
        /// Test to read from a column specified by out of range ordinal 
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(IndexOutOfRangeException))]
        public void InvalidOrdinalTest()
        {
            Console.WriteLine("Before InvalidOrdinalTest");
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("finduserfromid"))
                {
                    dataReader.AddParameter("@userid", 6);
                    dataReader.Execute();
                    dataReader.Read();
                    object obj = dataReader[1000];
                }
            }
            catch (IndexOutOfRangeException ex)
            {
                string expected = "Index was outside the bounds of the array";
                StringAssert.StartsWith( ex.Message,expected);
                throw;
            }
        }

        /// <summary>
        /// Test to cast a read value incorrectly.
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(InvalidCastException))]
        public void InvalidTypeGetTest()
        {
            Console.WriteLine("Before InvalidTypeGetTest");
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("finduserfromid"))
                {
                    dataReader.AddParameter("@userid", 6);
                    dataReader.Execute();
                    dataReader.Read();
                    Guid guid = dataReader.GetGuid(0);
                }
            }
            catch (InvalidCastException ex)
            {
                string expected = "Specified cast is not valid";
                StringAssert.StartsWith( ex.Message,expected);
                throw;
            }
        }

        /// <summary>
        /// Test to read past end of the results set.
        /// </summary>
        [TestMethod]
        [ExpectedException(typeof(InvalidOperationException))]
        public void ReadPastEndTest()
        {
            Console.WriteLine("Before ReadPastEndTest");
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("finduserfromid"))
                {
                    dataReader.AddParameter("@userid", 6);
                    dataReader.Execute();
                    for (; ; )
                    {
                        dataReader.Read();
                        object obj = dataReader[0];
                    }
                }
            }
            catch (InvalidOperationException ex)
            {
                string expected = "Invalid attempt to read when no data is present";
                StringAssert.StartsWith( ex.Message,expected);
                throw;
            }
        }

        /// <summary>
        /// Test for output paramters
        /// </summary>
        [TestMethod]
        public void OutputParameterTest()
        {
            Console.WriteLine("Before OutputParameterTest");
            try
            {
                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader dataReader = context.CreateDnaDataReader("checkuserpostfreq"))
                {
                    dataReader.AddParameter("@userid", 6);
                    dataReader.AddParameter("@siteid", 1);
                    dataReader.AddIntOutputParameter("@seconds");
                    dataReader.Execute();
                    int output;
                    Assert.IsFalse(dataReader.TryGetIntOutputParameter("@fred", out output));
                }
            }
            catch (IndexOutOfRangeException ex)
            {
                string expected = "An SqlParameter";
                StringAssert.StartsWith( ex.Message,expected);
                throw;
            }
        }
    }
}
