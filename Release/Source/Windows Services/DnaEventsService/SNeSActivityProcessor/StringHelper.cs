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
        /// <param name="json">json string</param>
        /// <returns>Returns an object of class T on success, else null object</returns>
        public static T ObjectFromJson<T>(this string json) where T : class
        {
            try
            {
                using (var ms = new MemoryStream(Encoding.Unicode.GetBytes(json)))
                {
                    var ser = new DataContractJsonSerializer(typeof(T));
                    //var ms = new MemoryStream(Encoding.Unicode.GetBytes(json));
                    return ser.ReadObject(ms) as T;
                }
            }
            catch (Exception)
            {
                return null;
            }
            
        }   
   
        public static string JsonFromObject<T>(this object obj)
        {
            var ser = new DataContractJsonSerializer(typeof (T));
            var ms = new MemoryStream();
            ser.WriteObject(ms, obj);
            return Encoding.UTF8.GetString(ms.ToArray());
        }
    }
}