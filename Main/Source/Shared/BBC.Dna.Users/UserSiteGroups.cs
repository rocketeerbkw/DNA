using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BBC.Dna.Users
{
    [Serializable]
    public class UserSiteGroups
    {
        /// <summary>
        /// 
        /// </summary>
        public UserSiteGroups()
        {
            UserGroupIds = new Dictionary<int, List<UserGroup>>();
        }

        public UserSiteGroups(int siteId)
        {
            SiteId = siteId;
            UserGroupIds = new Dictionary<int, List<UserGroup>>();
        }

        /// <summary>
        /// The current site id
        /// </summary>
        public int SiteId { get; set; }

        /// <summary>
        /// The matching group id
        /// </summary>
        public Dictionary<int, List<UserGroup>> UserGroupIds { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        public void AddUserGroup(int userId, string groupName)
        {
            if (!UserGroupIds.ContainsKey(userId))
            {
                UserGroupIds.Add(userId, new List<UserGroup>() { new UserGroup(groupName)});
                return;
            }

            var groupList = UserGroupIds[userId];
            if (!groupList.Exists(x => x.Name.ToUpper() == groupName.ToUpper()))
            {
                groupList.Add(new UserGroup(groupName));
            }

        }

        /// <summary>
        /// remove specific user id group combo
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        public void RemoveUserGroup(int userId, string groupName)
        {
            if (!UserGroupIds.ContainsKey(userId))
            {
                return;
            }
            UserGroupIds[userId].RemoveAll(x => x.Name.ToUpper() == groupName.ToUpper());
            
        }

        /// <summary>
        /// Returns if a user is a member of a certain group
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        /// <returns></returns>
        public bool IsUserMemberOfGroup(int userId, string groupName)
        {
            if (!UserGroupIds.ContainsKey(userId))
            {
                return false;
            }
            var groupList = UserGroupIds[userId];
            return groupList.Exists(x => x.Name.ToUpper() == groupName.ToUpper());

        }
    }
}
