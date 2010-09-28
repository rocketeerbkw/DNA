using System;
using System.Xml;
using System.Collections.Generic;

namespace BBC.Dna.Objects
{
    /// <summary>
    /// The IUser interface
    /// </summary>
    public interface IUser
    {
        /// <summary>
        /// This is the function that creates the viewing user.
        /// </summary>
        void CreateUser();

        // <summary>
        // Gets the user data details and fills in the XML block
        // </summary>
        //void GetUserDetails();

        /// <summary>
        /// ShowFullDetails Property
        /// </summary>
        bool ShowFullDetails { get; set; }

        /// <summary>
        /// BeginUpdateUser() - Prepares user for update.
        /// </summary>
        /// <returns></returns>
        void BeginUpdateDetails();

        /// <summary>
        /// Updates changes to user since BeginUpdateDetails().
        /// </summary>
        bool UpdateDetails();

        /// <summary>
        /// Users EMail Property
        /// </summary>
        string Email { get; set;}

        /// <summary>
        /// UserID Property
        /// </summary>
        int UserId { get; set;}

        /// <summary>
        /// IdentityId Property
        /// </summary>
        string IdentityUserId { get; set; }

        /// <summary>
        /// IdentityUserName Property
        /// </summary>
        string IdentityUserName { get; set; }

        /// <summary>
        /// UserLoggedIn Property
        /// </summary>
        bool UserLoggedIn { get; set;}

        /// <summary>
        /// Login name property
        /// </summary>
        string LoginName { get; set;}

		/// <summary>
		/// True if the user has editor privileges on the current site
		/// </summary>
		bool IsEditor { get; set;}

        /// <summary>
        /// True if the user is a super user on the current site
        /// </summary>
        bool IsSuperUser { get; set;}

        /// <summary>
        /// True if the user is a notable on the current site
        /// </summary>
        bool IsNotable { get; set;}

        /// <summary>
		/// True if the user is a member of one of the volunteer groups
		/// </summary>
		bool IsVolunteer { get; set;}

        /// <summary>
        /// True if the user is a referee on the current site
        /// </summary>
        bool IsReferee { get; set;}

        /// <summary>
        /// True if the user is a moderator on the current site
        /// </summary>
        bool IsModerator { get; set;}

        /// <summary>
        /// True if the user is in Pre Moderation on the current site
        /// </summary>
        bool IsPreModerated { get; set;}

        /// <summary>
        /// True if the user has been banned from the current site
        /// </summary>
        bool IsBanned { get; set;}

        /// <summary>
        /// True if the user is in the Auto Sin Bin on the current site
        /// </summary>
        bool IsAutoSinBin { get; set;}

		/// <summary>
		/// Get the Username field
		/// </summary>
		string UserName { get; set;}

		/// <summary>
		/// FirstNames field for this user
		/// </summary>
		string FirstNames { get; set;}

		/// <summary>
		/// LastName field for this user
		/// </summary>
		string LastName { get; set;}

        /// <summary>
        /// A users preferred skin
        /// </summary>
        string PreferredSkin { get; set; }

        /// <summary>
        /// Public access to the user data dictionary object
        /// </summary>
        Dictionary<string, object> UserData
        { get; set;}

		/// <summary>
		/// Is the user a member of the Scouts group?
		/// </summary>
		bool IsScout { get; set;}

		/// <summary>
		/// Is the user a member of the subeditors group
		/// </summary>
		bool IsSubEditor { get; set;}

        /// <summary>
        /// Is the user a member of the testers group
        /// </summary>
        bool IsTester { get; set;}

        /// <summary>
        /// The users bbc uid from the cookie
        /// </summary>
        string BbcUid { get; set;}

        /// <summary>
        /// Returns whether a user accepts subscriptions to their content from other users.
        /// </summary>
        bool AcceptSubscriptions { get; set;}

        /// <summary>
        /// Sets whether a user accepts subscriptions to their content.
        /// </summary>
        /// <returns></returns>
        void SetAcceptSubscriptions(bool acceptSubscriptions );

        /// <summary>
        /// Sets the preferred skin value
        /// </summary>
        /// <param name="skin">Skin to set</param>
        void SetPreferredSkinInDB(string skin);

        /// <summary>
        /// Generates the SiteList of sites that the user is editor of
        /// </summary>
        XmlElement GetSitesThisUserIsEditorOfXML();

        /// <summary>
        /// Is the user a member of the guardian group
        /// </summary>
        bool IsGuardian { get; set;}

        /// <summary>
        /// Checks to see if the current user has special edit permissions for the given article
        /// </summary>
        /// <param name="h2g2ID">Id of the article you what to check for</param>
        /// <returns>True if they have, false if not</returns>
        bool HasSpecialEditPermissions(int h2g2ID);

        /// <summary>
        /// TeamID Property
        /// </summary>
        int TeamID { get; set;}

        /// <summary>
        /// Journal Property
        /// </summary>
        int Journal { get; set;}

        /// <summary>
        /// Used when updating a user's record. Can only be called after calling BeginUpdateDetails
        /// </summary>
        /// <param name="userName"></param>
        void SetUsername(string userName);

        /// <summary>
        /// Set a new SiteSuffix field. Can be called only after BeginUpdateDetails
        /// </summary>
        /// <param name="siteSuffix">New SiteSuffix</param>
        void SetSiteSuffix(string siteSuffix);

        /// <summary>
        /// Updates a value within the user data dictionary
        /// </summary>
        /// <param name="name">name of variable</param>
        /// <param name="value">object value</param>
        /// <returns>True if add to update reader</returns>
        bool SetUserData(string name, object value);

        /// <summary>
        /// True if the user is a host on the current site
        /// </summary>
        bool IsHost { get; set;}

        /// <summary>
        /// Converts BBC.Dna.User to BBC.Dna.Objects.User
        /// A hack until user objects are unified.
        /// </summary>
        /// <returns></returns>
        BBC.Dna.Objects.User ConvertUser();

        /// <summary>
        /// 
        /// </summary>
        List<Group> Groups { get; set; }

        int Status { get; set; }
        int TaxonomyNode { get; set; }
        string SiteSuffix { get; set; }
        string Area { get; set; }
        string Title { get; set; }
        int SubQuota { get; set; }
        int Allocations { get; set; }
        bool Active { get; set; }
        DateElement DateLastNotified { get; set; }
        DateElement DateJoined { get; set; }
        int ForumPostedTo { get; set; }
        int MastHead { get; set; }
        int SinBin { get; set; }
        int ForumId { get; set; }

        
        
    }
}
