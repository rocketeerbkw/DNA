using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BBC.Dna.Data;
using Rhino.Mocks;

namespace TestUtils.Mocks.Extentions
{
    public class DataReaderFactory
    {
        /// <summary>
        /// Creates a mocked datareader and loads it with row data ready to replay
        /// </summary>
        /// <param name="mocks">The mock repository object that all the tests are running with</param>
        /// <param name="procedureName">The name of the procedure you want to call</param>
        /// <param name="creator">The new DataReaderCreator object</param>
        /// <param name="reader">The new DataReader object</param>
        /// <param name="testRowData">A list of test row data to load the reader with</param>
        static public void CreateMockedDataBaseObjects(MockRepository mocks, string procedureName, out IDnaDataReaderCreator creator, out IDnaDataReader reader, List<TestDatabaseRow> testRowData)
        {
            reader = mocks.DynamicMock<IDnaDataReader>();

            if (testRowData != null)
            {
                reader.Stub(x => x.HasRows).Return(testRowData.Count > 0);

                Dictionary<string, Queue<object>> queuedData = new Dictionary<string, Queue<object>>();
                queuedData.Add("read", new Queue<object>());

                foreach (TestDatabaseRow o in testRowData)
                {
                    foreach (KeyValuePair<string, object> kv in o.paramAndValues)
                    {
                        string keyName = kv.Key;
                        object objectValue = kv.Value;

                        if (!queuedData.ContainsKey(keyName))
                        {
                            queuedData.Add(keyName, new Queue<object>());
                        }

                        queuedData[keyName].Enqueue(objectValue);
                    }
                    queuedData["read"].Enqueue(true);
                }
                queuedData["read"].Enqueue(false);

                QueueValuesToDataReaderCalls(reader, queuedData);
            }

            creator = mocks.DynamicMock<IDnaDataReaderCreator>();
            creator.Stub(x => x.CreateDnaDataReader(procedureName)).Return(reader);
            mocks.ReplayAll();
        }

        private static void QueueValuesToDataReaderCalls(IDnaDataReader reader, Dictionary<string, Queue<object>> queuedData)
        {
            // Add the queues to the relavent datareader calls
            foreach (KeyValuePair<string, Queue<object>> o in queuedData)
            {
                string keyName = o.Key;

                bool isDBNullCall = keyName.IndexOf("-isdbnull") > 0;
                keyName = keyName.Replace("-isdbnull", "");

                bool isGetStringCall = keyName.IndexOf("-getstring") > 0;
                keyName = keyName.Replace("-getstring", "");

                bool isGetInt32Call = keyName.IndexOf("-getint32") > 0;
                keyName = keyName.Replace("-getint32", "");

                Queue<object> queue = o.Value;

                if (queue != null && queue.Count > 0)
                {
                    Console.WriteLine(string.Format("Adding queue for {0} with count of {1}", keyName, queue.Count));
                    if (queue.ElementAt(0).GetType() == typeof(bool))
                    {
                        if (isDBNullCall)
                        {
                            reader.Stub(x => x.IsDBNull(keyName)).Return(true).WhenCalled(x => x.ReturnValue = queue.Dequeue());
                        }
                        else
                        {
                            reader.Stub(x => x.Read()).Return(true).WhenCalled(x => x.ReturnValue = queue.Dequeue());
                        }
                    }
                    else if (queue.ElementAt(0).GetType() == typeof(string))
                    {
                        if (isGetStringCall)
                        {
                            reader.Stub(x => x.GetString(keyName)).Return("").WhenCalled(x => x.ReturnValue = queue.Dequeue());
                        }
                        else
                        {
                            reader.Stub(x => x.GetStringNullAsEmpty(keyName)).Return("").WhenCalled(x => x.ReturnValue = queue.Dequeue());
                        }
                    }
                    else if (queue.ElementAt(0).GetType() == typeof(int))
                    {
                        if (isGetInt32Call)
                        {
                            reader.Stub(x => x.GetInt32(keyName)).Return(0).WhenCalled(x => x.ReturnValue = queue.Dequeue());
                        }
                        else
                        {
                            reader.Stub(x => x.GetInt32NullAsZero(keyName)).Return(0).WhenCalled(x => x.ReturnValue = queue.Dequeue());
                        }
                    }
                    else if (queue.ElementAt(0).GetType() == typeof(DateTime))
                    {
                        reader.Stub(x => x.GetDateTime(keyName)).Return(DateTime.Now).WhenCalled(x => x.ReturnValue = queue.Dequeue());
                    }
                }
            }
        }
    
        public class TestDatabaseRow
        {
            public List<KeyValuePair<string, object>> paramAndValues = new List<KeyValuePair<string, object>>();

            private void AddColumnValue(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key, value));
            }

            public void AddGetInt32ColumnValue(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key + "-getint32", value));
            }

            public void AddGetInt32NullAsZeroColumnValue(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key, value));
            }

            public void AddGetStringColumnValue(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key + "-getstring", value));
            }

            public void AddGetDateTimeColumnValue(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key, value));
            }

            public void AddGetBooleanColumnValue(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key, value));
            }

            public void AddIsDBNullCheck(string key, object value)
            {
                paramAndValues.Add(new KeyValuePair<string, object>(key + "-isdbnull", value));
            }
        }
    }
}
