using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using BBC.Dna;

namespace Tests
{
    /// <summary>
    /// Test Configuration.
    /// Manage files required for Test Configuration.
    /// Manages paths.
    /// The Test site h2g2UnitTesting is used for servicing requests with a test configuration.
    /// The dnapages virtual directory contains aspx pages. This directory is used to host ASP.NET.
    /// </summary>
    public class TestConfig 
    {
        private string _rootPath;
        private string _dnaPagesDir;
        private bool _copied = false;
        private static TestConfig _singleton;

        /// <summary>
        /// 
        /// </summary>
        private TestConfig()
        { 
        }

        /// <summary>
        /// Only have one config class.
        /// This allows clean up to occur once only during destruction.
        /// </summary>
        /// <returns></returns>
        public static TestConfig GetConfig()
        {
            if (_singleton == null)
            {
                _singleton = new TestConfig();
            }

            return _singleton;
        }

        /// <summary>
        /// Required to clean Up after copying config file.
        /// Dispose not called ?
        /// </summary>
        ~TestConfig()
        {
            CleanUp();
        }

        /// <summary>
        /// Locate the Test RipleyServer.xmlconf for testing.
        /// Ask IIs for the root path of h2g2UnitTesting site.
        /// Expect to find RipleyServer.xmlconf in root dir.
        /// </summary>
        /// <returns></returns>
        public string GetRipleyServerPath()
        {
            if (_rootPath != null)
            {
                return _rootPath;
            }

            IIsInitialise iis = IIsInitialise.GetIIsInitialise();
            string root = iis.GetWebSiteRoot("h2g2UnitTesting");
            if ( root == string.Empty )
            {
                throw new Exception("Unable to get path to ripleyserver.xmlconf because root path of h2g2UnitTesting site was not found.");
            }

            _rootPath = root + @"\";
            return _rootPath;
        }

        /// <summary>
        /// Get the physical path of the DnaPages Virtual Directory.
        /// </summary>
        /// <returns></returns>
        public string GetDnaPagesDir()
        {
            if (_dnaPagesDir != null)
            {
                return _dnaPagesDir;
            }

            IIsInitialise iis = IIsInitialise.GetIIsInitialise();
            string dnaPagesDir = iis.GetVDirPath("h2g2UnitTesting","dna", "dnapages");
            if (dnaPagesDir == string.Empty)
            {
                throw new Exception("Unable to find physical path of dnapages virtual directory");
            }
            _dnaPagesDir = dnaPagesDir + @"\";
            return _dnaPagesDir;
        }

        /// <summary>
        /// CopyConfig copies the RipleyServer.xmlconf file.
        /// This file is required in web root test site for processing IIS requests.
        /// It is also required in dnapages dir as thi sis used to host asp.net pages independently of IIS.
        /// </summary>
        /// <returns></returns>
        public void CopyRipleyServerConfig()
        {
            if (_copied)
            {
                return;
            }

            string root = GetRipleyServerPath();
            string dnapages = GetDnaPagesDir();

            //Copy Config from h2g2UnitTesting to dnapages.
            try
            {
                Console.Out.Write("Copying RipleyServer.xmlconf from " + root + " to " + dnapages);
                File.Copy(root + "RipleyServer.xmlconf", dnapages + "RipleyServer.xmlconf", true);
            }
            catch (Exception e)
            {
                throw new Exception("Unable to copy RipleyServer.xmlconf to dnapages:" + e.Message);
            }
            _copied = true;

            return;
        }

        /// <summary>
        /// CleanUp any configuration files as a result of testing.
        /// Delete RipleyServer.xmlconf from dnapages directory.
        /// </summary>
        /// <returns></returns>
        private void CleanUp()
        {
            string dnapages = GetDnaPagesDir();
            try
            {
                File.Delete(dnapages + "RipleyServer.xmlconf");
            }
            catch (Exception e)
            {
                //Dont throe error form a destrutor.
                Console.Out.Write("Unable to delete ripleyServer.xmlcong from dnapages dir:" + e.Message);
            }
        }

        /// <summary>
        /// Not Currently Requiring a Test Skin configuration so use default skin path.
        /// </summary>
        /// <returns></returns>
        public string GetSkinPath()
        {
            return Environment.GetEnvironmentVariable("ripleyserverpath");
        }
    }
}
