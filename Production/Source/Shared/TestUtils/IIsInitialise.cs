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

            //Memcached service
            ServiceController service = new ServiceController("memcached Server");
            TimeSpan timeout = TimeSpan.FromMilliseconds(10000);

            //Stop Default Site
            DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC/1");
            entry.Invoke("stop");

            //Stop the memcached service
            if (service.CanStop)
            {
                service.Stop();
                service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
            }

            //start memcached service
            if (service.Status != ServiceControllerStatus.Running)
            {
                service.Start();
                service.WaitForStatus(ServiceControllerStatus.Running, timeout);
            }

            //Start Test Site.
            entry = new DirectoryEntry("IIS://LocalHost/W3SVC/2");
            entry.Invoke("start");

            GetSites();
        }

        /// <summary>
        /// Displays Web Sites.
        /// Expecting Default web Sites to be site 1 and test site enumeration 2.
        /// </summary>
        private static void GetSites()
        {
           //Enumerate Sites.
            DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC");
           foreach (DirectoryEntry site in entry.Children)
           {
                if (site.SchemaClassName == "IIsWebServer")
                {
                    string ServerComment = site.Properties["ServerComment"].Value.ToString();
                    Console.WriteLine(ServerComment + " (" + site.Name + ")");
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
                DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC");
                foreach (DirectoryEntry site in entry.Children)
                {
                    if (site.SchemaClassName == "IIsWebServer")
                    {
                        string serverComment = site.Properties["ServerComment"].Value.ToString();
                        if (serverComment == website)
                        {
                            DirectoryEntry rootVDir = new DirectoryEntry("IIS://localhost/W3SVC/" + site.Name + "/Root");
                            string rootPath = rootVDir.Properties["Path"].Value.ToString();
                            return rootPath;
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
                DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC");
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
                                if ( vdir.Name == vdirname )
                                {
                                    return vdir.Properties["Path"].Value.ToString();
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
                DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC");
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
            catch (Exception e)
            {
                throw new Exception("Error trying to get path within test web site " + e.Message);
            }

            return string.Empty;
        }

        /// <summary>
        /// Enable the Default web Site and stop test web site.
        /// </summary>
        private void RestoreDefaultSite()
        {

            //Memcached service
            ServiceController service = new ServiceController("memcached Server");
            TimeSpan timeout = TimeSpan.FromMilliseconds(10000);


            /*IIsAdministrator iisadmin = new IIsAdministrator();
            IIsWebSite current = iisadmin.WebSites.ActiveWebSite;

            if ( current != null )
            {
                if (current == iisadmin.WebSites[0])
                {
                    return;
                }
                current.Stop();
            }

            IIsWebSite defaultsite = iisadmin.WebSites[0];
            defaultsite.Start();*/

            //Start Test Site.
            DirectoryEntry entry = new DirectoryEntry("IIS://LocalHost/W3SVC/2");
            entry.Invoke("stop");

            //Stop the memcached service
            if (service.CanStop)
            {
                service.Stop();
                service.WaitForStatus(ServiceControllerStatus.Stopped, timeout);
            }

            //start memcached service
            if (service.Status != ServiceControllerStatus.Running)
            {
                service.Start();
                service.WaitForStatus(ServiceControllerStatus.Running, timeout);
            }

            //Stop Default Site
            entry = new DirectoryEntry("IIS://LocalHost/W3SVC/1");
            entry.Invoke("start");
        }
    }
}
