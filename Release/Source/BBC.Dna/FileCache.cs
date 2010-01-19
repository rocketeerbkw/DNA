using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Utils;

namespace BBC.Dna
{
	/// <summary>
	/// A class to cache and retrieve string data from a filesystem cache.
	/// Compatible with the Ripley C++ file cache
	/// </summary>
	public class FileCache
	{
		/// <summary>
		/// Get a string from a file cache if it's newer than a given expiry date
		/// </summary>
		/// <param name="cacheRoot">path to the root of the cache directory</param>
		/// <param name="cacheName">Name of the subdirectory in which to look for this item</param>
		/// <param name="itemName">Name of the cache file to create</param>
		/// <param name="Expires">If the date on the file is older than this date, don't return the string. 
		/// This value will contain the actual date of the file on return from this method</param>
		/// <param name="Value">String containing the contents of this cache item</param>
		/// <returns>True if a valid item is returned from the cache, false if no item found or it's out of date</returns>
		public static bool GetItem(string cacheRoot, string cacheName, string itemName, ref DateTime Expires, ref string Value)
		{
			if (cacheRoot.Length == 0)
			{
				// Can't cache if we don't have a root directory
				return false;
			}

            string safeItemName = StringUtils.MakeStringFileNameSafe(itemName);

            string fullPath = Path.Combine(Path.Combine(cacheRoot, cacheName), safeItemName);

			//	WIN32_FIND_DATA FindFileData;
			FileInfo info = new System.IO.FileInfo(fullPath);

			bool gotCachedFile = false;

			if (info.Exists)
			{
				// Check the expiry date
				DateTime fileDate = info.LastWriteTime;
				//string sRes;
				//fileDate.GetAsXML(sRes);
				if (fileDate >= (Expires))
				{
					gotCachedFile = true;
                    try
                    {
                        using (StreamReader reader = new StreamReader(fullPath))
                        {
                            Value = reader.ReadToEnd();
                        }
                    }
                    catch (System.IO.IOException ex)
                    {
                        ex.Data["MethodName"] = "CacheGetItem";
                        AppContext.TheAppContext.Diagnostics.WriteExceptionToLog(ex);
                        return false;
                    }
				}
				Expires = fileDate;
			}
			else
			{
                AppContext.TheAppContext.Diagnostics.WriteWarningToLog("CacheGetItem", "Cannot find " + fullPath);
				return false;
			}

			if (gotCachedFile)
			{
				Statistics.AddCacheHit();
			}
			else
			{
				Statistics.AddCacheMiss();
			}
			return gotCachedFile;
		}

		/// <summary>
		/// Puts a string value into a file-based cache. Compatible with Ripley's caching methods
		/// </summary>
		/// <param name="cacheRoot">Directory root of the global file cache</param>
		/// <param name="cacheName">Name of subdirectory to cache in</param>
		/// <param name="itemName">Name of file to cache</param>
		/// <param name="Text">String value to store in cache (usualy XML but doesn't have to be</param>
		/// <returns>True if cached successfully. False otherwise.</returns>
		public static bool PutItem(string cacheRoot, string cacheName, string itemName, string Text)
		{
            if (cacheRoot.Length == 0)
			{
				// Can't cache if we don't have a root directory
				return false;
			}
            string safeItemName = StringUtils.MakeStringFileNameSafe(itemName);

            string cacheDir = Path.Combine(cacheRoot, cacheName);

            string fullPath = Path.Combine(cacheDir, safeItemName);


			bool directoryExists = false;

            try
            {
                DirectoryInfo hFind = new DirectoryInfo(cacheDir);

                if (hFind.Exists)
                {
                    directoryExists = true;
                }
                else
                {
                    directoryExists = Directory.CreateDirectory(cacheDir).Exists;	// Gosh that's so much simpler
                }
                if (directoryExists)
                {
                    using (StreamWriter writer = new StreamWriter(fullPath))
                    {
                        writer.Write(Text);
                    }
                }
                else
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                ex.Data["MethodName"] = "CachePutItem";
                AppContext.TheAppContext.Diagnostics.WriteExceptionToLog(ex);
                return false;
            }
		}

        /// <summary>
        /// Invalidates a file cache by setting 
        /// </summary>
        /// <param name="cacheRoot"></param>
        /// <param name="cacheName"></param>
        /// <param name="itemName"></param>
        /// <returns></returns>
        public static bool InvalidateItem( string cacheRoot, string cacheName, string itemName )
        {
            if (cacheRoot.Length == 0)
			{
				// Can't cache if we don't have a root directory
				return false;
			}

            string safeItemName = StringUtils.MakeStringFileNameSafe(itemName);

            //Check Directory Exists
            string cacheDir = Path.Combine(cacheRoot, cacheName);
            string fullPath = Path.Combine(cacheDir, safeItemName);

            FileInfo info = new System.IO.FileInfo(fullPath);

            if (!info.Exists)
            {
                return false;
            }

            //Invalidate by Taking a day off the LastWrite Time.
            //Deleting the file would also be a an option but would need to handle file in use scenario.
            if (info.LastWriteTime > DateTime.Now - new TimeSpan(1, 0, 0, 0, 0))
            {
                info.LastWriteTime = DateTime.Now - new TimeSpan(1, 0, 0, 0, 0);
            }
            return true;
        }
	}
}
