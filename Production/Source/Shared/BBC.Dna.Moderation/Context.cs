using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using BBC.Dna.Utils;
using BBC.Dna.Data;

namespace BBC.Dna.Moderation
{
    public class Context
    {
        protected IDnaDiagnostics _dnaDiagnostics=null;
        public IDnaDiagnostics dnaDiagnostics
        {
            get { return _dnaDiagnostics; }
            set { _dnaDiagnostics = value; }
        }

        protected string _connection;
        public string Connection
        {
            get { return _connection; }
        }
 
        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public Context(IDnaDiagnostics dnaDiagnostics, string connection)
        {
            _dnaDiagnostics = dnaDiagnostics;
            _connection = connection;
        }

        /// <summary>
        /// Constructor without dna diagnostic object
        /// </summary>
        public Context()
        {
            //create one for this request only if not passed.
            _dnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
        }


        /// <summary>
        /// Returns a data reader for database interactivity
        /// </summary>
        /// <param name="name">The sp name</param>
        /// <returns>A valid data reader</returns>
        public StoredProcedureReader CreateReader(string name)
        {
            if (String.IsNullOrEmpty(_connection))
                return StoredProcedureReader.Create(name, dnaDiagnostics);
            else
                return StoredProcedureReader.Create(name, _connection, dnaDiagnostics);
        }


    }
}
