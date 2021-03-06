using Microsoft.Web.Administration;
using System;
using System.Configuration;
using System.Linq;
using System.ServiceProcess;


namespace Tests
{
    /// <summary>
    /// Class used to Initialise h2g2UnitTesting web site.
    /// Will do this once only.
    /// </summary>
    public class IIsInitialise : IDisposable
    {
        private static IIsInitialise _iisTestSite = new IIsInitialise();

        /// <summary>
        /// Private Constructor. Only 1 instance expected.
        /// </summary>
        static IIsInitialise()
        {
        }

        private static bool IsTestServerRemote()
        {
            return !string.IsNullOrEmpty(ConfigurationManager.AppSettings["testServer:isRemote"])
                && ConfigurationManager.AppSettings["testServer:isRemote"].Trim().ToLower() == "true";
        }


        private static ServerManager ServerManagerInstance()
        {
            var server = DnaTestURLRequest.CurrentServer;

            var remoteServer = server.Host;// +":" + server.Port;

            var isRemote = IsTestServerRemote();

            return isRemote ? ServerManager.OpenRemote(remoteServer) : new ServerManager();
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
            RestartMemCache();
        }


        /// <summary>
        /// Gets the root directory of the web site with the given name.
        /// </summary>
        /// <returns></returns>
        public string GetWebSiteRoot(string website)
        {
            try
            {
                using (var serverManager = ServerManagerInstance())
                {
                    var site = serverManager.Sites.Single(s => s.Name.ToLower() == website.ToLower());

                    var absolutePath = site.Applications["/"].VirtualDirectories["/"].PhysicalPath;

                    return ApplicationPath(absolutePath);
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
                using (var serverManager = ServerManagerInstance())
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

                    return ApplicationPath(virtualDirectory.PhysicalPath);
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
                using (var serverManager = ServerManagerInstance())
                {
                    var site = serverManager.Sites.Single(s => s.Name.ToLower() == website.ToLower());

                    var application = "/" + vdirname + "/" + childDirName;

                    var absolutePath = site.Applications[application].VirtualDirectories["/"].PhysicalPath;

                    return ApplicationPath(absolutePath);
                }

            }
            catch (Exception e)
            {
                throw new Exception("Error trying to get path within test web site " + e.Message);
            }
        }


        private string ApplicationPath(string absolutePath)
        {
            var isRemote = IsTestServerRemote();

            if (isRemote)
            {
                var subPath = absolutePath.Remove(0, 3);

                return string.Format(@"\\{0}\{1}", DnaTestURLRequest.CurrentServer.Host, subPath);
            }
            else
            {
                return absolutePath;
            }
        }

        public void Dispose()
        {
        }
    }
}