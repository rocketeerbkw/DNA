using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ServiceModel;

namespace BBC.Dna.Groups
{
    [ServiceContract(Name = "UserGroups", Namespace = "BBC.Dna.Groups")]
    public interface IUserGroups
    {
        /// <summary>
        /// Adds a given user to a given group for a site
        /// </summary>
        /// <param name="userID">The users id to add to the group</param>
        /// <param name="groupName">The group name to add the user to</param>
        /// <param name="siteID">The id of the site to add the user to</param>
        /// <returns>True if they were added correctly, false if not</returns>
        [OperationContract(Name = "AddUserToGroup")]
        bool PutUserIntoGroup(int userID, string groupName, int siteID);

        /// <summary>
        /// Removes a user from a given group on a site
        /// </summary>
        /// <param name="userID">The users id to remove</param>
        /// <param name="groupName">The group name to remove from</param>
        /// <param name="siteID">The id of the site to remove the user from the group</param>
        [OperationContract(Name = "RemoveUserFromGroup")]
        void DeleteUserFromGroup(int userID, string groupName, int siteID);

        /// <summary>
        /// Gets all the groups that a user belongs to on a given site
        /// </summary>
        /// <param name="userID">The users id you want to get the groups for</param>
        /// <param name="siteID">The sites id you want to get the group info from</param>
        /// <returns></returns>
        [OperationContract(Name = "GetUsersGroupsForSite")]
        List<string> GetUsersGroupsForSite(int userID, int siteID);

        /// <summary>
        /// Creates a new group in the database
        /// </summary>
        /// <param name="groupName">The new group name you want to create</param>
        /// <returns>True if it was created, false if something went wrong</returns>
        [OperationContract(Name = "CreateNewGroup")]
        bool CreateNewGroup(string groupName, int userID);

        /// <summary>
        /// Deletes the given group in the database
        /// </summary>
        /// <param name="groupName">The name of the group you want to delete</param>
        /// <returns>True if it was deleted, false if something went wrong</returns>
        [OperationContract(Name = "DeleteGroup")]
        bool DeleteGroup(string groupName);

        /// <summary>
        /// Gets a list of all the current groups in the database
        /// </summary>
        /// <returns>The list of all group names</returns>
        [OperationContract(Name = "GetAllGroups")]
        List<string> GetAllGroups();
    }
}
