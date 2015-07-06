using Microsoft.Web.Administration;
using System;
using System.Linq;
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
            using (var serverManager = new ServerManager())
            {
                Site site = null;

                var h2g2Sites = serverManager.Sites.Where(s => s.Name.ToLower().Contains("h2g2"));

                switch (siteType)
                {
                    case webSiteType.main: site = h2g2Sites.First(s => s.Name.ToLower() == "h2g2"); break;

                    case webSiteType.test: site = h2g2Sites.First(s => s.Name.ToLower().Contains("test")); break;

                    default: break;
                }

                if (start)
                {
                    site.Start();
                }
                else
                {
                    site.Stop();
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
        /// Gets the root directory of the web site with the given name.
        /// </summary>
        /// <returns></returns>
        public string GetWebSiteRoot(string website)
        {
            try
            {
                using (var serverManager = new ServerManager())
                {
                    var site = serverManager.Sites.Single(s => s.Name.ToLower() == website.ToLower());

                    return site.Applications["/"].VirtualDirectories["/"].PhysicalPath;
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get root path of test web site " + e.Message);
            }
        }

        /// <summary>
        /// Get the Phyisical Path of the requested virtual directory.
        /// Used to get the phsical path of the dnapages virtual directory.
        /// </summary>
        /// <param name="vdirname"></param>
        /// <param name="website"></param>
        /// <returns></returns>
        public string GetVDirPath(string website, string vdirname)
        {
            try
            {
                using (var serverManager = new ServerManager())
                {
                    var site = serverManager.Sites.Single(s => s.Name.ToLower() == website.ToLower());

                    var virtualPath = "/" + vdirname;

                    var virtualDirectory = site.Applications["/"].VirtualDirectories[virtualPath];

                    if (virtualDirectory == null)
                    {
                        virtualDirectory = site.Applications["/dna"].VirtualDirectories[virtualPath];
                    }

                    if (virtualDirectory == null)
                    {
                        var message = string.Format("'{0}' virtual directory does not exists");

                        throw new Exception(message);
                    }

                    return virtualDirectory.PhysicalPath;
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get root path of test web site " + e.Message);
            }

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
                using (var serverManager = new ServerManager())
                {
                    var site = serverManager.Sites.Single(s => s.Name.ToLower() == website.ToLower());

                    var application = "/" + vdirname + "/" + childDirName;

                    return site.Applications[application].VirtualDirectories["/"].PhysicalPath;
                }
            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get path within test web site " + e.Message);
            }

        }
    }
}
