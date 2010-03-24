using System;
using System.IO;
using System.Runtime.Serialization.Json;
using System.Text;

namespace Dna.SnesIntegration.ActivityProcessor
{
    public static class StringHelper
    {
        /// <summary>
        /// Takes a string of json and deserializes it to an object of type T. (T must be a DataContract).
        /// </summary>
        /// <typeparam name="T">Class definition to deserialize to.</typeparam>
        /// <param name="s">json string</param>
        /// <returns>Returns an object of class T on success, else null object</returns>
        public static T ObjectFromJson<T>(this string s) where T : class
        {
            try
            {
                var ser = new DataContractJsonSerializer(typeof(T));
                var ms = new MemoryStream(Encoding.Unicode.GetBytes(s));
                return ser.ReadObject(ms) as T;
            }
            catch (Exception)
            {
                return null;
            }
            
        }      
    }
}