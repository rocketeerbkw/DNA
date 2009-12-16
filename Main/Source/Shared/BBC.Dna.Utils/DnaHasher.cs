using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;

namespace BBC.Dna.Utils
{
    /// <summary>
    /// DnaHasher - class to create md5 one-way hash values to identify duplicate content.
    /// Given the same input, the generated hash will be identical.
    /// </summary>
    public class DnaHasher
    {
        /// <summary>
        /// GenerateCommentHashValue - Generate a hash value unique for a given content, uid and userid.
        /// </summary>
        /// <param name="content">comment body</param>
        /// <param name="uid">unique identifier of comment box</param>
        /// <param name="userID">userid of author</param>
        public static Guid GenerateCommentHashValue(string content, string uid, int userID)
        {
            string source = content + "<:>" + uid + "<:>" + userID.ToString();
            System.Text.UTF8Encoding utf8 = new System.Text.UTF8Encoding();
            MD5CryptoServiceProvider md5Hasher = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] hashedDataBytes = md5Hasher.ComputeHash(utf8.GetBytes(source));
            return new Guid(hashedDataBytes);
        }

		/// <summary>
		/// Generates a Guid of the MD5 hash for the input string
		/// </summary>
		/// <param name="content">string value to hash</param>
		/// <returns>Guid representing the 128bit hash value</returns>
		public static Guid GenerateHash(string content)
		{
			System.Text.UTF8Encoding utf8 = new System.Text.UTF8Encoding();
			MD5CryptoServiceProvider md5Hasher = new System.Security.Cryptography.MD5CryptoServiceProvider();
			byte[] hashedDataBytes = md5Hasher.ComputeHash(utf8.GetBytes(content));
			return new Guid(hashedDataBytes);
		}

		/// <summary>
		/// Generates a string version of an MD5 hash based on the input string
		/// </summary>
		/// <param name="content">string to hash</param>
		/// <returns>32 character hex string</returns>
		public static string GenerateHashString(string content)
		{
			// Important note:
			// I tried to use ToString("N") for this, but it doesn't work for our purposes
			// because it reorders the bytes, and the BBC-UID hashing code assumes
			// the bytes are output in order
			// So to make sure this method is suitable for use with the UID hashing we just
			// output to string manually
			byte[] bytes =  GenerateHash(content).ToByteArray();
			StringBuilder hashed = new StringBuilder();
			for (int index = 0; index < bytes.Length; index++)
			{
				hashed.Append(bytes[index].ToString("x2"));
			}
			return hashed.ToString();

		}
    }
}
