using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;

namespace updatesp
{
    class BuildConfiguration
    {
        public BuildConfiguration(string tfsBuildDefinition, string buildConfiguration, string updateConfigFile)
        {
            _tfsBuildDefinition = tfsBuildDefinition;
            _buildConfiguration = buildConfiguration;
            _updateConfigFile = updateConfigFile;
        }

        private string _tfsBuildDefinition;
        private string _buildConfiguration;
        private string _updateConfigFile;

        public string UpdateConfigFile { get { return _updateConfigFile; } }
    }
}
