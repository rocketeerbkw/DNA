using System;
using System.Collections.Generic;
using System.Text;
using System.DirectoryServices;
using System.ServiceProcess;


namespace Tests
{
    /// <summary>
    /// Class used to Initialise h2g2UnitTesting web site.
    /// Will do this once only.
    /// </summary>
    public class IIsInitialise
    {
        private static IIsInitialise _iisTestSite = new IIsInitialise();

        /// <summary>
        /// Private Constructor. Only 1 instance expected.
        /// </summary>
        static IIsInitialise()
        {
            // Now workout what the machines name is. If it's ops-dna1, then we need to set the server to dnadev!
            String server = DnaTestURLRequest.CurrentServer;

            // Just make the server the machine name plus the rest
            if (server == "local.bbc.co.uk:8081")
            {
                //Going to need to switch to the h2g2UnitTesting web site.
                StartTestSite();
            }
            
        }

        ~IIsInitialise()
        {
            RestoreDefaultSite();
        }

        /// <summary>
        /// This class is a singleton.
        /// Use this method to get the only instance.
        /// </summary>
        /// <returns></returns>
        public static IIsInitialise GetIIsInitialise()
        {
            if (_iisTestSite == null)
            {
                _iisTestSite = new IIsInitialise();
            }
            return _iisTestSite;
        }

        private enum webSiteType { main, test };

        private static void StopWebSite(webSiteType siteType)
        {
            StopStartWebSite(siteType, false);
        }

        private static void StartWebSite(webSiteType siteType)
        {
            StopStartWebSite(siteType, true);
        }

        private static void StopStartWebSite(webSiteType siteType, bool start)
        {
            string entryName = "IIS://LocalHost/W3SVC/1";
            if (siteType == webSiteType.test)
            {
                entryName = "IIS://LocalHost/W3SVC/2";
            }

            using (var dirEntry = new DirectoryEntry(entryName))
            {
                if (start)
                {
                    dirEntry.Invoke("start");
                }
                else
                {
                    dirEntry.Invoke("stop");
                }
            }
        }

        private static void RestartMemCache()
        {
            // Memcached service
            using (ServiceController memCacheService = new ServiceController("memcached Server"))
            {
                if (memCacheService != null && memCacheService.Container != null)
                {
                    TimeSpan timeout = TimeSpan.FromMilliseconds(10000);

                    // Stop the memcached service
                    if (memCacheService.CanStop)
                    {
                        memCacheService.Stop();
                        memCacheService.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
                    }

                    // start memcached service
                    if (memCacheService.Status != ServiceControllerStatus.Running)
                    {
                        memCacheService.Start();
                        memCacheService.WaitForStatus(ServiceControllerStatus.Running, timeout);
                    }
                }
            }
        }

        public void RestartTestSite()
        {
            RestoreDefaultSite();
            StartTestSite();
        }

        /// <summary>
        /// Enables the h2g2UnitTesting web site.
        /// Disables current site first as XP only supports 1 active web site.
        /// Uses IISAdmin .NET tool to query web sites and start h2g2UnitTesting.
        /// Not required for Server / Server 2003 versions as they support multiple web sites.
        /// </summary>
        private static void StartTestSite()
        {
            // Stop Default Site
            StopWebSite(webSiteType.main);
            RestartMemCache();
            StartWebSite(webSiteType.test);
            GetSites();
        }

        /// <summary>
        /// Enable the Default web Site and stop test web site.
        /// </summary>
        private void RestoreDefaultSite()
        {
            StopWebSite(webSiteType.test);
            RestartMemCache();
            StartWebSite(webSiteType.main);
        }

        /// <summary>
        /// Displays Web Sites.
        /// Expecting Default web Sites to be site 1 and test site enumeration 2.
        /// </summary>
        private static void GetSites()
        {
            //Enumerate Sites.
            using (DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC"))
            {
                foreach (DirectoryEntry site in entry.Children)
                {
                    if (site.SchemaClassName == "IIsWebServer")
                    {
                        string ServerComment = site.Properties["ServerComment"].Value.ToString();
                        Console.WriteLine(ServerComment + " (" + site.Name + ")");
                    }
                }
            }
        }

        /// <summary>
        /// Gets the root directory of the web site with the given name.
        /// </summary>
        /// <returns></returns>
        public string GetWebSiteRoot( string website )
        {
            try
            {
                using (DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC"))
                {
                    foreach (DirectoryEntry site in entry.Children)
                    {
                        if (site.SchemaClassName == "IIsWebServer")
                        {
                            string serverComment = site.Properties["ServerComment"].Value.ToString();
                            if (serverComment == website)
                            {
                                using (DirectoryEntry rootVDir = new DirectoryEntry("IIS://localhost/W3SVC/" + site.Name + "/Root"))
                                {
                                    return rootVDir.Properties["Path"].Value.ToString();
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get root path of test web site " + e.Message);
            }

            return string.Empty;
        }

        /// <summary>
        /// Get the Phyisical Path of the requested virtual directory.
        /// Used to get the phsical path of the dnapages virtual directory.
        /// </summary>
        /// <param name="vdirname"></param>
        /// <param name="website"></param>
        /// <returns></returns>
        public string GetVDirPath(string website ,string vdirname)
        {
            try
            {
                using (DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC"))
                {
                    foreach (DirectoryEntry site in entry.Children)
                    {
                        if (site.SchemaClassName == "IIsWebServer")
                        {
                            string serverComment = site.Properties["ServerComment"].Value.ToString();
                            if (serverComment == website)
                            {
                                using (DirectoryEntry entries = site.Children.Find("Root", "IIsWebVirtualDir"))
                                {
                                    foreach (DirectoryEntry vdir in entries.Children)
                                    {
                                        if (vdir.Name == vdirname)
                                        {
                                            return vdir.Properties["Path"].Value.ToString();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get root path of test web site " + e.Message);
            }

            return string.Empty;
        }

        /// <summary>
        /// Get the Physical Path of the requested virtual directory.
        /// Used to get the phsical path of the dnapages virtual directory.
        /// </summary>
        /// <param name="vdirname">The directory name</param>
        /// <param name="website">The name of the website</param>
        /// <param name="childDirName">The child directory to look for</param>
        /// <returns></returns>
        public string GetVDirPath(string website, string vdirname, string childDirName)
        {
            try
            {
                using (DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC"))
                {
                    foreach (DirectoryEntry site in entry.Children)
                    {
                        if (site.SchemaClassName == "IIsWebServer")
                        {
                            string serverComment = site.Properties["ServerComment"].Value.ToString();
                            if (serverComment == website)
                            {
                                DirectoryEntry entries = site.Children.Find("Root", "IIsWebVirtualDir");
                                foreach (DirectoryEntry vdir in entries.Children)
                                {
                                    if (vdir.Name == vdirname)
                                    {
                                        DirectoryEntry childEntry = vdir.Children.Find(childDirName, "IIsWebVirtualDir");
                                        return childEntry.Properties["Path"].Value.ToString();
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get path within test web site " + e.Message);
            }

            return string.Empty;
        }
    }
}
