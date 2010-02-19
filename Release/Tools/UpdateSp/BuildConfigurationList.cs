using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using Microsoft.Build.Utilities;
using Microsoft.Build.Framework;

namespace updatesp
{
    class BuildConfigurationList
    {
        private Dictionary<string, BuildConfiguration> _buildConfigurationList;

        public void InitialiseFromFile(string buildConfigurationsFile)
        {
            _buildConfigurationList = new Dictionary<string, BuildConfiguration>();

            XDocument xmlFile = XDocument.Load(buildConfigurationsFile);

            var updatespBuildConfigurations = from c in xmlFile.Elements("updatespBuildConfigurations").Elements("buildConfiguration") select c;

            foreach (XElement updatespBuildConfiguration in updatespBuildConfigurations)
            {
                string tfsBuildDefinition = updatespBuildConfiguration.Attribute("tfsBuildDefinition").Value;
                string buildConfiguration = updatespBuildConfiguration.Attribute("buildConfiguration").Value;
                string updatespConfigFile = updatespBuildConfiguration.Element("updatespConfigFile").Value;

                BuildConfiguration bc = new BuildConfiguration(tfsBuildDefinition, buildConfiguration, updatespConfigFile);

                string key = GenerateKey(tfsBuildDefinition, buildConfiguration);
                _buildConfigurationList.Add(key, bc);
            }
        }

        public BuildConfiguration GetMatchingBuildConfiguration(string tfsBuildDefinition, string buildConfiguration)
        {
            BuildConfiguration bc = null;
            string key = GenerateKey(tfsBuildDefinition,buildConfiguration);
            if (_buildConfigurationList.ContainsKey(key))
            {
                bc = _buildConfigurationList[GenerateKey(tfsBuildDefinition,buildConfiguration)];
            }
            return bc;
        }

        private string GenerateKey(string tfsBuildDefinition, string buildConfiguration)
        {
            return tfsBuildDefinition + ":" + buildConfiguration;
        }

    }
}
