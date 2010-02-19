using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;

namespace BBC.Dna.Objects
{
    public interface IDnaCachable
    {
        /// <summary>
        /// Check if the object is cachable
        /// </summary>
        /// <param name="readerCreator">Reader to use to verify object</param>
        /// <returns></returns>
        bool IsUpToDate(IDnaDataReaderCreator readerCreator);
    }
}
