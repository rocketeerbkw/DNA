using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data;
using System.Collections;
using System.Web.Caching;

namespace BBC.Dna.Data
{
    /// <summary>
    /// Provides a means of reading one or more forward-only streams of result sets obtained by executing a command at a DNA data source
    /// </summary>
    /// <remarks>The IDnaDataReader interface enables the creation of a DNA Data Reader class, which provides a means of reading one or more forward-only streams of result sets.
    /// An application does not directly create a DNA DataReader.</remarks>
    public interface IDnaDataReader : IDataReader, IEnumerable
    {
        /// <summary>
        /// Add a parameter to the Reader 
        /// </summary>
        /// <param name="paramName">Name of the parameter</param>
        /// <param name="paramValue">Value of the parameter</param>
        /// <returns>Current instance of the class implementing the IDnaDataReader interface.</returns>
		IDnaDataReader AddParameter(string paramName, object paramValue);

        /// <summary>
        /// Add an integer output parameter
        /// </summary>
        /// <param name="paramName">Name of the output parameter</param>
        /// <returns></returns>
        IDnaDataReader AddIntOutputParameter(string paramName);

        /// <summary>
        /// Add a char output parameter
        /// </summary>
        /// <param name="paramName">Name of the output parameter</param>
        /// <returns></returns>
        IDnaDataReader AddStringOutputParameter(string paramName);

        /// <summary>
        /// Add a boolean (bit) output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns></returns>
        IDnaDataReader AddBooleanOutputParameter(string name);

        /// <summary>
        /// Get the value of an specific integer output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <param name="value">Integer to hold the value</param>
        /// <returns>Returns true if successfully read, otherwise false</returns>
        bool TryGetIntOutputParameter(string name, out int value);

        /// <summary>
        /// Get the value of an specific integer output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        int GetIntOutputParameter(string name);

        /// <summary>
        /// Get the value of an specific int output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        int? GetNullableIntOutputParameter(string name);

        /// <summary>
        /// Get the value of an specific boolean output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        bool? GetNullableBooleanOutputParameter(string name);

        /// <summary>
        /// Get the value of a specific char output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <returns>The output param value</returns>
        string GetNullableStringOutputParameter(string name);

        /// <summary>
        /// Get the value of an specific string output parameter
        /// </summary>
        /// <param name="name">Name of the output parameter</param>
        /// <param name="value">String to hold the value</param>
        /// <returns>Returns true if successfully read, otherwise false</returns>
        bool TryGetStringOutputParameter(string name, out string value);

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        IDnaDataReader AddIntReturnValue();

        /// <summary>
        /// Gets the return value of the procedure call
        /// </summary>
        /// <param name="value">output param to receive the value</param>
        /// <returns>true if successful, false otherwise</returns>
        bool TryGetIntReturnValue(out int value);

        /// <summary>
        /// Gets the return value of the procedure call
        /// </summary>
        /// <param name="value"></param>
        /// <returns>The int return value</returns>
        int GetIntReturnValue();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        bool TryGetIntReturnValueNullAsZero(out int value);

        /// <summary>
        /// Execute method fetches the data.
        /// </summary>
        /// <returns>Current instance of the class implementing the IDnaDataReader interface.</returns>
        IDnaDataReader Execute();
		
        
        /// <summary>
        /// Calls the database with an adhoc query.
        /// Only ever used in unit tests
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        IDnaDataReader ExecuteDEBUGONLY(string sql);
        

        /// <summary>
        /// Get the value of the specified column as Boolean.
        /// </summary>
        /// <param name="name">Name of the column</param>
        /// <returns>bool value of the column.</returns>
        bool GetBoolean(string name);

        /// <summary>
        /// Gets the value of the column as a nullable Boolean
        /// </summary>
        /// <param name="name">Name of the column</param>
        /// <returns>nullable bool value of the column.</returns>
        bool? GetNullableBoolean(string name);

        /// <summary>
        /// Get the value of the specified column as Int32.
        /// </summary>
        /// <param name="name">Name of the column</param>
        /// <returns>Int32 value of the column.</returns>
        int GetInt32(string name);

		/// <summary>
		/// Gets the column value as a string
		/// </summary>
		/// <param name="name">name of the column</param>
		/// <returns>String value of the column</returns>
		string GetString(string name);

		/// <summary>
		/// Gets the column value as a DateTime
		/// </summary>
		/// <param name="name">name of column</param>
		/// <returns>DateTime value of column</returns>
		DateTime GetDateTime(string name);

		/// <summary>
		/// Gets the columns value as a string. will return an empty string if the column is null
		/// </summary>
		/// <param name="name">column name</param>
		/// <returns>sring value of column</returns>
		string GetStringNullAsEmpty(string name);

        /// <summary>
        /// Gets the columns value as a escaped string. will return an empty string if the column is null
        /// </summary>
        /// <param name="name">column name</param>
        /// <returns>escaped sring value of column</returns>
        string GetAmpersandEscapedStringNullAsEmpty(string name);
        
		/// <summary>
        /// Get the value of the specified column. Return null data as 0.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int32 value of the column.</returns>
        int GetInt32NullAsZero(string name);

        /// <summary>
        /// Get the value of the specified column as a Int32.
        /// If it's NULL, then null is returned
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int32 value of the column, or null</returns>
        int? GetNullableInt32(string name);

        /// <summary>
        /// Get the value of the specified column as Byte.
        /// </summary>
        /// <param name="name">Name of the column</param>
        /// <returns>Byte value of the column.</returns>
        byte GetByte(string name);

        /// <summary>
        /// Get the value of the tinyint in the specified column as an int
        /// </summary>
        /// <param name="name">Name of the column containing the tiny int</param>
        /// <returns>int value of the tinyint value for the column</returns>
        int GetTinyIntAsInt(string name);

        /// <summary>
        /// Get the value of the specified column. Return null data as 0.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Byte value of the column.</returns>
        byte GetByteNullAsZero(string name);
 
        /// <summary>
        /// Get the float value of the specified column. Return null data as 0.0F
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>float value of the column.</returns>
        float GetFloatNullAsZero(string name);

        /// <summary>
        /// Get the double value of the specified column. Return null data as 0.0
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Double value of the column.</returns>
        double GetDoubleNullAsZero(string name);

        /// <summary>
        /// Get the Int64/long value of the specified column. Return null data as 0L
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>Int64/long value of the column.</returns>
        long GetLongNullAsZero(string name);

        /// <summary>
        /// Gets a value that indicates whether a column has a non-existant or missing value.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>true if the specified field is set to null. Otherwise, false.</returns>
        bool IsDBNull(string name);

        /// <summary>
        /// Gets a value the indicates whether the reader has one or more rows.
        /// </summary>
        bool HasRows { get; }

        /// <summary>
        /// Gets a value the indicates whether the reader has one or more rows.
        /// </summary>
        bool Exists(string name);

		/// <summary>
		/// Returns true if the named field exists in the current row
		/// </summary>
		/// <param name="name">Name if field you want to search for</param>
		/// <returns></returns>
		bool DoesFieldExist(string name);

        /// <summary>
        /// Gets the value of the specified column in its native format.
        /// </summary>
        /// <param name="name">Name of the column.</param>
        /// <returns>The Object which will contain the field value upon return. </returns>
        object GetValue(string name);

        /// <summary>
        /// Gets the guid value as a string for a given column
        /// </summary>
        /// <param name="name">The name of the column you want to get the guid value from </param>
        /// <returns>The guid as a string OR empty if something went wrong</returns>
        string GetGuidAsStringOrEmpty(string name);

        /// <summary>
        /// Gets the guid value for a given column
        /// </summary>
        /// <param name="name">The name of the column you want to get the guid value from </param>
        /// <returns>The guid</returns>
        Guid GetGuid(string name);

        /// <summary>
        /// Gets the Xml stored in the given column in string format
        /// </summary>
        /// <param name="name">The name of the column to get the value from</param>
        /// <returns>The Xml in string format</returns>
        string GetXmlAsString(string name);

        /// <summary>
        /// Gets the name of the data type of this column
        /// </summary>
        /// <param name="name">The name of the column you're interested in</param>
        /// <returns>The name of the data type of that column </returns>
        string GetDataTypeName(string name);

		/// <summary>
		/// Tells the reader to create a SqlCacheDependency object for caching purposes
		/// </summary>
		bool CanCache { get; set; }

		/// <summary>
		/// get the cache dependency object created for this query
		/// </summary>
		SqlCacheDependency Dependency { get; }
    }
}
