using System;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna.Sites
{
    public class Context
    {
        public IDnaDiagnostics DnaDiagnostics { get; set; }

        public IDnaDataReaderCreator ReaderCreator { get; protected set; }

        /// <summary>
        /// Constructor with dna diagnostic object
        /// </summary>
        /// <param name="dnaDiagnostics"></param>
        public Context(IDnaDataReaderCreator readerCreator, IDnaDiagnostics dnaDiag)
        {
            ReaderCreator = readerCreator;
            DnaDiagnostics = dnaDiag;
            if (DnaDiagnostics == null)
            {
                DnaDiagnostics = new DnaDiagnostics(RequestIdGenerator.GetNextRequestId(), DateTime.Now);
            }
        }

    }
}