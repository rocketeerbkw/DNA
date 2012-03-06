using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;

namespace BBC.Dna.Utils
{
	/// <summary>
	/// This is a helper class which decodes the contents of the BBC-UID cookie
	/// </summary>
	public class UidCookieDecoder
	{
		/// <summary>
		/// Decodes a BBC-UID cookie and returns the Guid from it
		/// </summary>
		/// <param name="cookie">string contents of the incoming cookie</param>
		/// <param name="secretkey">the secret key used to generate the hash for the cookie</param>
		/// <returns></returns>
		public static Guid Decode(string cookie, string secretkey)
		{
			Guid guid = new Guid();
			if (TryDecode(cookie, secretkey, ref guid))
			{
				return guid;
			}
			else
			{
                // Bug fix for Moderation - SPSMOD-205
                // If the decoding fails, create a GUID from the cookie anyway, as it's better to have some
                // value than none at all. 
                // The special case is when the cookie is set to the empty GUID.  This happens if an API request
                // cannot find the BBC-UID cookie (it uses the empty GUID as a default value).  In this case
                // leave it empty.

                if (!Guid.Empty.ToString().Equals(cookie))
                {
                    guid = DnaHasher.GenerateHash(cookie);
                    return guid;
                }
                else
                    return Guid.Empty;
			}
		}

		/// <summary>
		/// Tries to decode the BBC-UID cookie and indicates whether it was successful
		/// </summary>
		/// <param name="cookie">string contents of the incoming cookie</param>
		/// <param name="secretkey">the secret key used to generate the hash for the cookie</param>
		/// <param name="result">the resulting Guid</param>
		/// <returns>true if the cookie was valid, false otherwise</returns>
		public static bool TryDecode(string cookie, string secretkey, ref Guid result)
		{
			if (cookie.Length < 64)
			{
				return false;
			}

			StringBuilder hashbuilder = new StringBuilder(32);
			StringBuilder uidbuilder = new StringBuilder(32);
			int i;
			for (i = 0; i < 64; i += 2)
			{
				hashbuilder.Append(cookie[i]);
				uidbuilder.Append(cookie[i + 1]);
			}
			string uid = uidbuilder.ToString();
			string hash = hashbuilder.ToString();

			// Now get the logged in status, if there are 
			string loggedIn = string.Empty;
			if (i < cookie.Length)
			{
				loggedIn = cookie[i++].ToString();
			}

			// Get the Browser info, making sure we unescape it!
			string sBrowserInfo = string.Empty;
			if (i < cookie.Length)
			{
				sBrowserInfo = Uri.UnescapeDataString(cookie.Substring(i));
			}

			// Now reencrypt the UID, LoggedIn and Browser Info to see if it matches the Hash value given
			string toHash = string.Concat(uid, loggedIn, sBrowserInfo, secretkey);
			string thehash = DnaHasher.GenerateHashString(toHash);
			thehash = DnaHasher.GenerateHashString(secretkey + thehash);

			if (thehash != hash)
			{
				return false;
			}
			//        CTDVString sReHash;
			//CStoredProcedure::GenerateHash(sUID + sLoggedIn + 
			//    sBrowserInfo + theConfig.GetSecretKey(),sReHash);
			//CStoredProcedure::GenerateHash(theConfig.GetSecretKey() + sReHash,sReHash);

			//// Return the verdict
			//if (sReHash != sHash)
			//{
			//    sUID.Empty();
			//    return false;
			//}
			for (int n = 0; n < uid.Length; n++)
			{
				if (uid[n] < '0' || uid[n] > 'f' || (uid[n] > '9' && uid[n] < 'a'))
				{
					return false;
				}
			}
			result = new Guid(uid);
			return true;
			//// Markn 20-7-06
			//// The UID can sometimes have invalid characters in it.  This is a bug in the BBC's cookie creation code and will hopefully be fixed soon
			//// If we detect any non-hex chars, we get out quickly!
			//for (int n=0;n < sUID.GetLength(); n++)
			//{
			//    if (!isxdigit(sUID[n]))
			//    {
			//        sUID.Empty();
			//        return false;
			//    }
			//}

		}

		//private static string GenerateHash(string toHash)
		//{
		//    //return DnaHasher.GenerateHashString(toHash);
		//    MD5 hasher = MD5.Create();
		//    byte[] bytes = hasher.ComputeHash(Encoding.Default.GetBytes(toHash));
		//    string otherval = new Guid(bytes).ToString("N");
		//    StringBuilder hashed = new StringBuilder();
		//    for (int index = 0; index < bytes.Length; index++)
		//    {
		//        hashed.Append(bytes[index].ToString("x2"));
		//    }
		//    string thehash = hashed.ToString();
		//    return thehash;
		//}
	}
}
