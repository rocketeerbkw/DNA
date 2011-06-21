using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using System.Transactions;

namespace TheGuide.Database.UnitTests
{
    public static class IDnaDataReaderExtensions
    {
        /// <summary>
        /// This will throw an exception if there is not an active ambient transaction
        /// </summary>
        private static void CheckActiveTransactionExists()
        {
            try
            {
                var t = Transaction.Current;
                var ti = t.TransactionInformation;
                var tis = ti.Status;

                if (tis != TransactionStatus.Active)
                {
                    throw new Exception("There must be an active ambient transaction");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("There must be an active ambient transaction", ex);
            }
        }

        public static void ExecuteWithinATransaction(this IDnaDataReader reader, string sql)
        {
            CheckActiveTransactionExists();

            reader.ExecuteDEBUGONLY(sql);
        }
    }
}
