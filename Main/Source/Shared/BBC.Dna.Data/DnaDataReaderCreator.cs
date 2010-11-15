using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Data
{
    /// <summary>
    /// Class that implements IDnaDataReaderCreator
    /// </summary>
    public class DnaDataReaderCreator : IDnaDataReaderCreator
    {
        #region Private Properties
        /// <summary>
        /// Database connection string
        /// </summary>
        public string ConnectionString
        {
            get;
            private set;
        }

        /// <summary>
        /// Instance of IDnaDiagnostics, might be null
        /// </summary>
        private IDnaDiagnostics Diagnostics
        {
            get;
            set;
        }
        #endregion

        #region Constructors
        /// <summary>
        /// Create instance of DnaDataReaderCreator with connection string only.
        /// </summary>
        /// <param name="connectionString">Connection string to database</param>
        public DnaDataReaderCreator(string connectionString)
            : this(connectionString, null)
        {
        }

        /// <summary>
        /// Create instance of DnaDataReaderCreator with connection string and diagnostics
        /// </summary>
        /// <param name="connectionString">Connection string to database</param>
        /// <param name="diagnostics">Instance of object supporting IDnaDiagnostics</param>
        public DnaDataReaderCreator(string connectionString, IDnaDiagnostics diagnostics)
        {
            ConnectionString = connectionString;
            Diagnostics = diagnostics;
        }
        #endregion

        #region IDataReaderCreator Members

        /// <summary>
        /// Implementation of the CreateDnaDataReader method
        /// </summary>
        /// <param name="name">Name of the stored procedure</param>
        /// <returns></returns>
        IDnaDataReader IDnaDataReaderCreator.CreateDnaDataReader(string name)
        {
            return new StoredProcedureReader(name, ConnectionString, Diagnostics);
        }

        #endregion
    }
}
