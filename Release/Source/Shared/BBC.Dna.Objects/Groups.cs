using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.ComponentModel;
using System.Xml.Serialization;
using System.Linq;
using System.Runtime.Serialization;
using BBC.Dna.Common;
using BBC.Dna.Users;


namespace BBC.Dna.Objects
{
    /// <remarks/>
    [GeneratedCode("System.Xml", "2.0.50727.3053")]
    [Serializable]
    [XmlType(AnonymousType = true, TypeName = "GROUPS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "GROUPS")]
    [DataContract]
    public class Groups
    {
        public Groups()
        {
            Group = new List<Group>();
        }

        /// <remarks/>
        [XmlElement("GROUP", Order = 0)]
        [DataMember(Name = ("group"))]
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
            var userGroups = (UserGroups)SignalHelper.GetObject(typeof(UserGroups));
            try
            {
                var groupList = userGroups.GetUsersGroupsForSite(userId, siteId);
                foreach (var group in groupList)
                {
                    groups.AddGroup(group.Name);
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
    [XmlType(AnonymousType = true, TypeName = "GROUPS")]
    [XmlRoot(Namespace = "", IsNullable = false, ElementName = "GROUP")]
    [DataContract]
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
        [DataMember]
        public string Name { get; set; }
    }
}