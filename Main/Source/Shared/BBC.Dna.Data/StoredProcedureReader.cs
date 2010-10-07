using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Diagnostics;
using System.Web.Caching;
using BBC.Dna.Utils;
using Microsoft.Practices.EnterpriseLibrary.Logging;
using System.Text;

namespace BBC.Dna.Data
{
    /// <summary>
    /// Class providing an IDnaDataReader interface for a stored procedure.
    /// </summary>
    sealed public class StoredProcedureReader : IDnaDataReader
    {
        #region Private Fields
        private SqlDataReader _dataReader = null;
        private string _name = string.Empty;
        private Dictionary<string, object> _parameters = new Dictionary<string, object>();
        private Dictionary<string, KeyValuePair<SqlDbType, object>> _outputParams = new Dictionary<string, KeyValuePair<SqlDbType, object>>();
        private string _connectionString = string.Empty;
        private SqlConnection _connection = null;
        private IDnaDiagnostics _dnaDiagnostics = null;
        private SqlCommand _cmd = null;
        private SqlParameter _returnValue = null;
        private SqlCacheDependency _dependency;
        private bool _canCache = false;
        private static bool _dependencyStarted = false;
        private static object _dependencyLock = new object();
        #endregion

        #region Static Methods
        /// <summary>
        /// Creates a reader using default querystring from config and dna Diagnostic object
        /// </summary>
        /// <param name="name">The stored procedure name</param>
        /// <returns>valid StoredProcedureReader object</returns>
        public static StoredProcedureReader Create(string name)
        {

            string connString = string.Empty;
            if (ConfigurationManager.ConnectionStrings["Database"] != null)
                connString = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;

            return Create(name, connString);
        }

        /// <summary>
        /// Creates a reader using default querystring from config
        /// </summary>
        /// <param name="name">The stored procedure name</param>
        /// <param name="dnaDiagnostics">The dna diagnostic object to be used for logging</param>
        /// <returns>valid StoredProcedureReader object</returns>
        public static StoredProcedureReader Create(string name, IDnaDiagnostics dnaDiagnostics)
        {
            string connString = string.Empty;
            if (ConfigurationManager.ConnectionStrings["Database"] != null)
                connString = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;

            return Create(name, connString, dnaDiagnostics);
        }

        /// <summary>
        /// Creates a reader using default dna Diagnostic object
        /// </summary>
        /// <param name="name">The stored procedure name</param>
        /// <param name="connectionString">The specific connection string to use</param>
        /// <returns>valid StoredProcedureReader object</returns>
        public static StoredProcedureReader Create(string name, string connectionString)
        {
            DnaDiagnostics dnaDiag = DnaDiagnostics.Default;

            return new StoredProcedureReader(name, connectionString, dnaDiag);
        }

        /// <summary>
        /// Creates a reader
        /// </summary>
        /// <param name="name">The stored procedure name</param>
        /// <param name="connectionString">The specific connection string to use</param>
        /// <param name="dnaDiagnostics">The dna diagnostic object to be used for logging</param>
        /// <returns>valid StoredProcedureReader object</returns>
        public static StoredProcedureReader Create(string name, string connectionString, IDnaDiagnostics dnaDiagnostics)
        {
            if (String.IsNullOrEmpty(connectionString) && ConfigurationManager.ConnectionStrings["Database"] != null)
                connectionString = ConfigurationManager.ConnectionStrings["Database"].ConnectionString;


            return new StoredProcedureReader(name, connectionString, dnaDiagnostics);
        }

        #endregion

        #region Constructor
        /// <summary>
        /// Constructor to create a reader to the named Stored Procedure with the given connection string
        /// </summary>
        /// <param name="name">Stored procedure name</param>
        /// <param name="connectionString">Connection string to the data source.</param>
        /// <param name="dnaDiagnostics">A diagnostics object for writing trace data to</param>
        public StoredProcedureReader(string name, string connectionString, IDnaDiagnostics dnaDiagnostics)
        {
            _name = name;
            _connectionString = connectionString;
            _dnaDiagnostics = dnaDiagnostics;
        }

        /// <summary>
        /// Constructor to create a reader to the named Stored Procedure with the given connection string. This doesn't take a IDiagnostics
        /// </summary>
        /// <param name="name">Stored procedure name</param>
        /// <param name="connectionString">Connection string to the data source</param>
        public StoredProcedureReader(string name, string connectionString)
            : this(name, connectionString, null)
        {
        }
        #endregion

        #region StoredProcedureReader extra methods
        /// <summary>
        /// Adds a parameter to the StoredProcedureReader.
        /// </summary>
        /// <param name="name">Name of the parameter. Must include @.</param>
        /// <param name="value">Value of the parameter.</param>
        /// <returns>The instance of the StoredProecureReader.</returns>
        public IDnaDataReader AddParameter(string name, object value)
        {
            _parameters.Add(name, value);
            return this;
        }

        /// <summary>
        /// Add an integer output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns></returns>
        public IDnaDataReader AddIntOutputParameter(string name)
        {
            KeyValuePair<SqlDbType, object> key = new KeyValuePair<SqlDbType, object>(SqlDbType.Int, new object());
            _outputParams.Add(name, key);
            return this;
        }

        /// <summary>
        /// Add a char output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns></returns>
        public IDnaDataReader AddStringOutputParameter(string name)
        {
            KeyValuePair<SqlDbType, object> key = new KeyValuePair<SqlDbType, object>(SqlDbType.VarChar, SqlDbType.VarChar);
            _outputParams.Add(name, key);
            return this;
        }

        /// <summary>
        /// Add a boolean (bit) output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns></returns>
        public IDnaDataReader AddBooleanOutputParameter(string name)
        {
            KeyValuePair<SqlDbType, object> key = new KeyValuePair<SqlDbType, object>(SqlDbType.Bit, new object());
            _outputParams.Add(name, key);
            return this;
        }

        /// <summary>
        /// Get the value of an specific integer output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <param name="value">Integer to hold the value</param>
        /// <returns>Returns true if successfully read, otherwise false</returns>
        public bool TryGetIntOutputParameter(string name, out int value)
        {
            try
            {
                value = (int)_cmd.Parameters[name].Value;
            }
            catch (InvalidCastException)
            {
                value = 0;
                return false;
            }
            catch (NullReferenceException)
            {
                value = 0;
                return false;

            }
            return true;
        }

        /// <summary>
        /// Get the value of an specific integer output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        public int GetIntOutputParameter(string name)
        {
            try
            {
                return (int)_cmd.Parameters[name].Value;
            }
            catch (Exception ex)
            {
                string msg = string.Format("GetIntOutputParameter failed with param {0} for call to {1}", name, _name);
                throw new Exception(msg, ex);
            }
        }

        /// <summary>
        /// Get the value of an specific boolean output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        public bool? GetNullableBooleanOutputParameter(string name)
        {
            try
            {
                if (DBNull.Value.Equals(_cmd.Parameters[name].Value))
                    return null;

                return (bool)_cmd.Parameters[name].Value;
            }
            catch (Exception ex)
            {
                string msg = string.Format("GetIntOutputParameter failed with param {0} for call to {1}", name, _name);
                throw new Exception(msg, ex);
            }
        }

        /// <summary>
        /// Get the value of a specific char output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        public string GetNullableStringOutputParameter(string name)
        {
            try
            {
                if (DBNull.Value.Equals(_cmd.Parameters[name].Value))
                    return null;
                
                return (string)_cmd.Parameters[name].Value;
            }
            catch (Exception ex)
            {
                string msg = string.Format("GetCharOutputParameter failed with param {0} for call to {1}", name, _name);
                throw new Exception(msg, ex);
            }
        }

        /// <summary>
        /// Get the value of an specific string output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <param name="value">String to hold the value</param>
        /// <returns>Returns true if successfully read, otherwise false</returns>
        public bool TryGetStringOutputParameter(string name, out string value)
        {
            try
            {
                value = (string)_cmd.Parameters[name].Value;
            }
            catch (InvalidCastException)
            {
                value = null;
                return false;
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public IDnaDataReader AddIntReturnValue()
        {
            _returnValue = new SqlParameter("RetVal", SqlDbType.Int);
            _returnValue.Direction = ParameterDirection.ReturnValue;
            return this;
        }

        /// <summary>
        /// Gets the return value of the procedure call
        /// </summary>
        /// <param name="value">output param to receive the value</param>
        /// <returns>true if successful, false otherwise</returns>
        public bool TryGetIntReturnValue(out int value)
        {
            try
            {
                value = (int)_returnValue.Value;
            }
            catch (InvalidCastException)
            {
                value = 0;
                return false;
            }
            return true;
        }

        /// <summary>
        /// Gets the return value of the procedure call
        /// </summary>
        /// <param name="value"></param>
        /// <returns>The int return value</returns>
        public int GetIntReturnValue()
        {
            try
            {
                return (int)_returnValue.Value;
            }
            catch (Exception ex)
            {
                string msg = string.Format("GetIntReturnValue failed for call to {0}",_name);
                throw new Exception(msg, ex);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool TryGetIntReturnValueNullAsZero(out int value)
        {
            if ((_returnValue == null) || (_returnValue.Value == null))
            {
                value = 0;
                return false;
            }

            try
            {
                value = (int)_returnValue.Value;
            }
            catch (InvalidCastException)
            {
                value = 0;
                return false;
            }
            return true;
        }

        /// <summary>
        /// Helper function that copes with the fact that _dnaDiagnostics can be null
        /// </summary>
        /// <param name="message">The message</param>
        private void WriteTimedEventToLog(string message)
        {
            if (_dnaDiagnostics != null)
            {
                _dnaDiagnostics.WriteTimedEventToLog("SP", message);
            }
        }

        /// <summary>
        /// Execute the stored procedure.
        /// </summary>
        /// <returns>The instance of the StoredProcedureReader.</returns>
        public IDnaDataReader Execute()
        {
            using (new Tracer(this.GetType().Namespace))
            {
                Logger.Write("Executing " + _name, this.GetType().Namespace);
                WriteTimedEventToLog("Executing " + _name);
                _connection = new SqlConnection(_connectionString);
                _connection.Open();
                _cmd = _connection.CreateCommand();
                _cmd.CommandTimeout = 0;
                _cmd.CommandType = CommandType.StoredProcedure;
                _cmd.CommandText = _name;

                foreach (KeyValuePair<string, object> param in _parameters)
                {
                    Logger.Write(new LogEntry() { Message = String.Format("Adding Parameter:{0} Value:{1}", param.Key, param.Value), Severity = TraceEventType.Verbose });
                    _cmd.Parameters.Add(new SqlParameter(param.Key, param.Value));
                }

                foreach (KeyValuePair<string, KeyValuePair<SqlDbType, object>> outParam in _outputParams)
                {
                    Logger.Write(new LogEntry() { Message = String.Format("Adding Out Parameter:{0} Value:{1}", outParam.Key, outParam.Value), Severity = TraceEventType.Verbose });

                    SqlParameter param = new SqlParameter(outParam.Key, outParam.Value.Value);
                    param.Direction = ParameterDirection.Output;
                    param.SqlDbType = outParam.Value.Key;
                    _cmd.Parameters.Add(param);
                }

                if (_returnValue != null)
                {
                    _cmd.Parameters.Add(_returnValue);
                }

                if (_canCache)
                {
                    if (!_dependencyStarted)
                    {
                        lock (_dependencyLock)
                        {
                            if (!_dependencyStarted)
                            {
                                SqlDependency.Start(_connectionString);
                            }
                            _dependencyStarted = true;
                        }
                    }
                    _dependency = new SqlCacheDependency(_cmd);
                }

                Logger.Write("Executed before " + _name, this.GetType().Namespace);
                _dataReader = _cmd.ExecuteReader();
                Logger.Write("Executed After " + _name, this.GetType().Namespace);
                WriteTimedEventToLog("Executed " + _name);

            }

            return this;
        }

        /// <summary>
        /// Tells the datareader to create a SqlCacheDependency object for this command
        /// </summary>
        public bool CanCache
        {
            get
            {
                return _canCache;
            }
            set
            {
                _canCache = value;
            }
        }

        /// <summary>
        /// Get the cache dependency object created for this query
        /// </summary>
        public SqlCacheDependency Dependency
        {
            get
            {
                return _dependency;
            }
        }

#if DEBUG
        /// <summary>
        /// Calls the database with an adhoc query.
        /// Only ever used in unit tests
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public IDnaDataReader ExecuteDEBUGONLY(string sql)
        {
            _connection = new SqlConnection(_connectionString);
            _connection.Open();
            SqlCommand cmd = _connection.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = sql;

            foreach (KeyValuePair<string, object> param in _parameters)
            {
                cmd.Parameters.Add(new SqlParameter(param.Key, param.Value));
            }

            _dataReader = cmd.ExecuteReader();
            WriteTimedEventToLog("Executed " + sql);

            return this;
        }
#else
        /// <summary>
        /// Calls the database with an adhoc query.
        /// Only ever used in unit tests
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public IDnaDataReader ExecuteDEBUGONLY(string sql)
        {
            throw new NotImplementedException();
        }

#endif



        /// <summary>
        /// <see cref="IDnaDataReader"/>
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public bool DoesFieldExist(string name)
        {
            string lower = name.ToLower();
            if (this.FieldCount == 0)
            {
                return false;
            }

            for (int i = 0; i < FieldCount; i++)
            {
                if (lower == this.GetName(i).ToLower())
                {
                    return true;
                }
            }
            return false;
        }
        #endregion

        #region IEnumerable implementation
        /// <summary>
        /// StoredProcedureReader enumerator
        /// </summary>
        /// <returns></returns>
        public IEnumerator GetEnumerator()
        {
            return _dataReader.GetEnumerator();
        }
        #endregion

        #region IDataReader implementation
        /// <summary>
        /// Gets a value that indicates the depth of the current row.
        /// </summary>
        public int Depth
        {
            get
            {
                return _dataReader.Depth;
            }
        }

        /// <summary>
        /// True if the reader is closed. False if it's still open.
        /// </summary>
        public bool IsClosed
        {
            get
            {
                return _dataReader.IsClosed;
            }
        }

        /// <summary>
        /// The number of records affected by the update, insert or delete action.
        /// </summary>
        public int RecordsAffected
        {
            get
            {
                return _dataReader.RecordsAffected;
            }
        }

        /// <summary>
        /// Closes the datareader
        /// </summary>
        public void Close()
        {
            _dataReader.Close();
        }

        /// <summary>
        /// Returns a DataTable that describes the column metadata of the reader.
        /// </summary>
        /// <returns></returns>
        public DataTable GetSchemaTable()
        {
            return _dataReader.GetSchemaTable();
        }

        /// <summary>
        /// Advances the reader to the next result.
        /// </summary>
        /// <returns></returns>
        public bool NextResult()
        {
            return _dataReader.NextResult();
        }


        /// <summary>
        /// Advances the reader to the next row.
        /// </summary>
        /// <returns></returns>
        public bool Read()
        {
            return _dataReader.Read();
        }
        #endregion

        #region IDataReader:IDataRecord implementation

        /// <summary>
        /// Gets the number of columns in the current row.
        /// </summary>
        public int FieldCount
        {
            get
            {
                return _dataReader.FieldCount;
            }
        }

        /// <summary>
        /// Gets the column located at the specified index. 
        /// </summary>
        /// <param name="i">The index of the column to get.</param>
        /// <returns>The column located at the specified index as an Object.</returns>
        public object this[int i]
        {
            get
            {
                return _dataReader[i];
            }
        }

        /// <summary>
        /// Gets the column located at the specified index.
        /// </summary>
        /// <param name="name">The name of the column to get.</param>
        /// <returns>The column located at the specified index as an Object.</returns>
        public object this[string name]
        {
            get
            {
                object retval = null;

                if (!IsDBNull(GetOrdinal(name)))
                {
                    retval = _dataReader[name];
                }
                return retval;
            }
        }

        /// <summary>
        /// Get the value of the specified column as a boolean.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Boolen value of the column.</returns>
        /// <exception cref="System.InvalidCastException"/>
        public bool GetBoolean(int i)
        {
            return _dataReader.GetBoolean(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Boolean.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int32 value of the column.</returns>
        public bool GetBoolean(string name)
        {
            // It seems a little like overkill to use exception handling here
            // since the convert can just as easily convert a true boolean
            // And we save the cost of the GetOrdinal call.
            return Convert.ToBoolean(_dataReader[name]);
            //try
            //{
            //    return _dataReader.GetBoolean(GetOrdinal(name));
            //}
            //catch (InvalidCastException)
            //{
            //    return Convert.ToBoolean(_dataReader[name]);
            //}
        }

        public bool? GetNullableBoolean(string name)
        {
            if (!IsDBNull(name))
            {
                return GetBoolean(name);
            }

            return null;
        }


        /// <summary>
        /// Get the value of the specified column as a byte.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Byte value of the column.</returns>
        public byte GetByte(int i)
        {
            return _dataReader.GetByte(i);
        }

        /// <summary>
        /// Get the value of the tinyint in the specified column as an int
        /// </summary>
        /// <param name="name">Name of the column containing the tiny int</param>
        /// <returns>int value of the tinyint value for the column</returns>
        public int GetTinyIntAsInt(string name)
        {
            try
            {
                return Convert.ToInt32(_dataReader.GetByte(GetOrdinal(name)));
            }
            catch (InvalidCastException)
            {
                return Convert.ToInt32(_dataReader[name]);
            }
        }


        /// <summary>
        /// Reads a stream of bytes from the specified column offset into the buffer as an array starting at the given buffer offset.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <param name="fieldoffset">The index within the field to begin the read operation.</param>
        /// <param name="buffer">The buffer into which to read the stream of bytes.</param>
        /// <param name="bufferoffset">The index for buffer to begin the write operation.</param>
        /// <param name="length">The maximum length to copy into the buffer.</param>
        /// <returns>The actual number of bytes read.</returns>
        public long GetBytes(int i, long fieldoffset, byte[] buffer, int bufferoffset, int length)
        {
            return _dataReader.GetBytes(i, fieldoffset, buffer, bufferoffset, length);
        }

        /// <summary>
        /// Get the value of the specified column as a char.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Char value of the column.</returns>
        public char GetChar(int i)
        {
            return _dataReader.GetChar(i);
        }

        /// <summary>
        /// Reads a stream of chars from the specified column offset into the buffer as an array starting at the given buffer offset.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <param name="fieldoffset">The index within the field to begin the read operation.</param>
        /// <param name="buffer">The buffer into which to read the stream of bytes.</param>
        /// <param name="bufferoffset">The index for buffer to begin the write operation.</param>
        /// <param name="length">The maximum length to copy into the buffer.</param>
        /// <returns>The actual number of chars read.</returns>
        public long GetChars(int i, long fieldoffset, char[] buffer, int bufferoffset, int length)
        {
            return _dataReader.GetChars(i, fieldoffset, buffer, bufferoffset, length);
        }

        /// <summary>
        /// Returns a DbDataReader for the requested column ordinal.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>DbDataReader for the requested column ordinal.</returns>
        public IDataReader GetData(int i)
        {
            return _dataReader.GetData(i);
        }

        /// <summary>
        /// Get the name of the source data type.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>The data type information for the specified field.</returns>
        public string GetDataTypeName(int i)
        {
            return _dataReader.GetDataTypeName(i);
        }

        /// <summary>
        /// Get the name of the source data type.
        /// </summary>
        /// <param name="name"><Name of column/param>
        /// <returns>The data type information for the specified field.</returns>
        public string GetDataTypeName(string name)
        {
            return _dataReader.GetDataTypeName(GetOrdinal(name));
        }

        /// <summary>
        /// Get the value of the specified column as a DateTime.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>DateTime value of the column.</returns>
        public DateTime GetDateTime(int i)
        {
            return _dataReader.GetDateTime(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Decimal.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Decimal value of the column.</returns>
        public decimal GetDecimal(int i)
        {
            return _dataReader.GetDecimal(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Double.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Double value of the column.</returns>
        public double GetDouble(int i)
        {
            return _dataReader.GetDouble(i);
        }

        /// <summary>
        /// Get the System.Type that is the Type of the object.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>System.Type of the column.</returns>
        public Type GetFieldType(int i)
        {
            return _dataReader.GetFieldType(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Float.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Float value of the column.</returns>
        public float GetFloat(int i)
        {
            return _dataReader.GetFloat(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Guid.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Guid value of the column.</returns>
        public Guid GetGuid(int i)
        {
            return _dataReader.GetGuid(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Int16.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Int16 value of the column.</returns>
        public short GetInt16(int i)
        {
            return _dataReader.GetInt16(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Int32.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Int32 value of the column.</returns>
        public int GetInt32(int i)
        {
            return _dataReader.GetInt32(i);
        }

        /// <summary>
        /// Get the value of the specified column as a Int32.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int32 value of the column.</returns>
        public int GetInt32(string name)
        {
            return _dataReader.GetInt32(GetOrdinal(name));
        }

        /// <summary>
        /// Get the value of the specified column as a Int32. Null values returned as 0.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int32 value of the column.</returns>
        public int GetInt32NullAsZero(string name)
        {
            int retval = 0;
            if (!IsDBNull(name))
            {
                retval = GetInt32(name);
            }
            return retval;
        }

        /// <summary>
        /// Get the value of the specified column as a Int32.
        /// If it's NULL, then null is returned
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int32 value of the column, or null</returns>
        public int? GetNullableInt32(string name)
        {
            if (!IsDBNull(name))
            {
                return GetInt32(name);
            }
            return null;
        }

        /// <summary>
        /// Get the value of the specified column as a float.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>float value of the column.</returns>
        public float GetFloat(string name)
        {
            return _dataReader.GetFloat(GetOrdinal(name));
        }

        /// <summary>
        /// Get the value of the specified column as a float. Null values returned as 0.0
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>float value of the column.</returns>
        public float GetFloatNullAsZero(string name)
        {
            float retval = 0.0F;
            if (!IsDBNull(name))
            {
                retval = GetFloat(name);
            }
            return retval;
        }

        /// <summary>
        /// Get the value of the specified column as a double.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>double value of the column.</returns>
        public double GetDouble(string name)
        {
            return _dataReader.GetDouble(GetOrdinal(name));
        }

        /// <summary>
        /// Get the value of the specified column as a double. Null values returned as 0.0
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>double value of the column.</returns>
        public double GetDoubleNullAsZero(string name)
        {
            double retval = 0.0;
            if (!IsDBNull(name))
            {
                retval = GetDouble(name);
            }
            return retval;
        }

        /// <summary>
        /// Get the value of the specified column as a Int64/long.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int64/long value of the column.</returns>
        public long GetLong(string name)
        {
            return _dataReader.GetInt64(GetOrdinal(name));
        }

        /// <summary>
        /// Get the value of the specified column as a Int64. Null values returned as 0.0
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int64/long value of the column.</returns>
        public long GetLongNullAsZero(string name)
        {
            long retval = 0L;
            if (!IsDBNull(name))
            {
                retval = GetLong(name);
            }
            return retval;
        }

        /// <summary>
        /// <see cref="IDnaDataReader.GetStringNullAsEmpty"/>
        /// </summary>
        public string GetStringNullAsEmpty(string name)
        {
            if (IsDBNull(name))
            {
                return String.Empty;
            }
            else
            {
                return GetString(name);
            }
        }

        /// <summary>
        /// <see cref="IDnaDataReader.GetAmpersandEscapedStringNullAsEmpty"/>
        /// </summary>
        public string GetAmpersandEscapedStringNullAsEmpty(string name)
        {
            if (IsDBNull(name))
            {
                return String.Empty;
            }
            else
            {
                return StringUtils.EscapeAmpersands(GetString(name));
            }
        }

        /// <summary>
        /// Gets the guid value for a given column
        /// </summary>
        /// <param name="name">The name of the column you want to get the guid value from </param>
        /// <returns>The guid</returns>
        public Guid GetGuid(string name)
        {
            if (IsDBNull(name))
            {
                return Guid.Empty;
            }
            else
            {
                Guid guid = GetGuid(GetOrdinal(name));
                return guid;
            }
        }

        /// <summary>
        /// Gets the guid value as a string for a given column
        /// </summary>
        /// <param name="name">The name of the column you want to get the guid value from </param>
        /// <returns>The guid as a string OR empty if something went wrong</returns>
        public string GetGuidAsStringOrEmpty(string name)
        {
            if (IsDBNull(name))
            {
                return String.Empty;
            }
            else
            {
                Guid guid = GetGuid(GetOrdinal(name));
                return guid.ToString();
            }
        }

        /// <summary>
        /// Get the value of the specified column as a Byte.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Byte value of the column.</returns>
        public byte GetByte(string name)
        {
            return _dataReader.GetByte(GetOrdinal(name));
        }

        /// <summary>
        /// Get the value of the specified column as a Byte. Null values returned as 0.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Byte value of the column.</returns>
        public byte GetByteNullAsZero(string name)
        {
            byte retval = 0;
            if (!IsDBNull(name))
            {
                retval = GetByte(name);
            }
            return retval;
        }

        /// <summary>
        /// Get the value of the specified column as a Int64.
        /// </summary>
        /// <param name="i">Name of the column.</param>
        /// <returns>Int64 value of the column.</returns>
        public long GetInt64(int i)
        {
            return _dataReader.GetInt64(i);
        }

        /// <summary>
        /// Get the name of the specified column.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>Name of the column.</returns>
        public string GetName(int i)
        {
            return _dataReader.GetName(i);
        }

        /// <summary>
        /// <see cref="IDnaDataReader"/>
        /// </summary>
        public DateTime GetDateTime(string name)
        {
            return GetDateTime(GetOrdinal(name));
        }

        /// <summary>
        /// Gets the column ordinal, given the name of the column.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Column ordinal.</returns>
        public int GetOrdinal(string name)
        {
            return _dataReader.GetOrdinal(name);
        }

        /// <summary>
        /// Gets the value of the specified column in its native format.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>The Object which will contain the field value upon return. </returns>
        public object GetValue(int i)
        {
            return _dataReader.GetValue(i);
        }

        /// <summary>
        /// Gets the value of the specified column in its native format.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>The Object which will contain the field value upon return. </returns>
        public object GetValue(string name)
        {
            return _dataReader.GetValue(_dataReader.GetOrdinal(name));
        }

        /// <summary>
        /// Gets all the attribute fields in the collection for the current record. 
        /// </summary>
        /// <param name="values">An array of Object to copy the attribute fields into. </param>
        /// <returns>The number of instances of Object in the array. </returns>
        public int GetValues(object[] values)
        {
            return _dataReader.GetValues(values);
        }

        /// <summary>
        /// Get the value of the specified column as a string.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>String value of the column</returns>
        public string GetString(int i)
        {
            return _dataReader.GetString(i);
        }

        /// <summary>
        /// Gets the column value as a string
        /// </summary>
        /// <param name="name">name of the column</param>
        /// <returns>String value of the column</returns>
        public string GetString(string name)
        {
            return _dataReader.GetString(_dataReader.GetOrdinal(name));
        }

        /// <summary>
        /// Gets a value that indicates whether the column has a non-existent or missing value.
        /// </summary>
        /// <param name="i">Zero-based column ordinal.</param>
        /// <returns>true if the specified field is set to null. Otherwise, false.</returns>
        public bool IsDBNull(int i)
        {
            return _dataReader.IsDBNull(i);
        }

        /// <summary>
        /// Gets a value that indicates whether the column has a non-existent or missing value.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>true if the specified field is set to null. Otherwise, false.</returns>
        public bool IsDBNull(string name)
        {
            return _dataReader.IsDBNull(GetOrdinal(name));
        }

        /// <summary>
        /// Gets a value the indicates whether the reader has one or more rows.
        /// </summary>
        public bool HasRows
        {
            get
            {
                return _dataReader.HasRows;
            }
        }

        /// <summary>
        /// Does the requested column exist in the return row
        /// </summary>
        public bool Exists(string name)
        {
            try
            {
                _dataReader.GetOrdinal(name);
                return true;
            }
            catch (IndexOutOfRangeException)
            {
                return false;
            }
        }

        /// <summary>
        /// Gets the Xml stored in the given column in string format
        /// </summary>
        /// <param name="name">The name of the column to get the value from</param>
        /// <returns>The Xml in string format</returns>
        public string GetXmlAsString(string name)
        {
            SqlXml xmlValue = _dataReader.GetSqlXml(_dataReader.GetOrdinal(name));
            return xmlValue.Value;
        }

        #endregion

        #region IDisposable implemention
        /// <summary>
        /// Release the resources consumed by the StoredProcedureReader.
        /// </summary>
        public void Dispose()
        {
            if (_dataReader != null)
            {
                _dataReader.Dispose();
            }

            if (_connection != null)
            {
                _connection.Dispose();
            }
        }
        #endregion
    }
}
