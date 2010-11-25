using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Data
{
    /// <summary>
    /// Interface abstracting the creation of DnaDataReaders
    /// </summary>
    public interface IDnaDataReaderCreator
    {
        string ConnectionString { get; }
        IDnaDataReader CreateDnaDataReader(string name);
    }
}
