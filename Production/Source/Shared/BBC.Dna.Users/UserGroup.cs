using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace BBC.Dna.Users
{
    [Serializable]
    [DataContract(Name = "group")]   
    public class UserGroup
    {
        public UserGroup(string name)
        {
            Name = name;
        }

        public UserGroup()
        {
        }

        [DataMember(Name = "name")]   
        public string Name { get; set; }

    }
}
