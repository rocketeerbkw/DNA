using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using BBC.Dna.Groups;
using System.Linq;

namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "GROUPS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "GROUPS")]
    public class Groups
    {
        public Groups()
        {
            Group = new List<Group>();
        }

        /// <remarks/>
        [XmlElement("GROUP", Order = 0)]
        public List<Group> Group { get; set; }

        public void AddGroup(string groupName)
        {
            var group = new Group {Name = groupName.ToUpper()};
            if (Group.Exists(x => x.Name == group.Name)) return;
            Group.Add(group);
        }

        public static Groups GetGroupsForUserBySiteId(int userId, int siteId)
        {
            var groups = new Groups();
            var userGroups = new UserGroups("", null);
            try
            {
                var groupList = userGroups.GetUsersGroupsForSite(userId, siteId);
                foreach (var name in groupList)
                {
                    groups.AddGroup(name);
                }
            }
            catch (Exception)
            {
//do nothing
            }
            return groups;
        }
    }

    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [DesignerCategory("code")]
    [XmlType(AnonymousType = true, TypeName = "GROUPS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "GROUP")]
    public class Group
    {
        public Group()
        {
        }

        public Group(string name)
        {
            Name = name;
        }

        /// <remarks/>
        [XmlElement("NAME")]
        public string Name { get; set; }
    }
}