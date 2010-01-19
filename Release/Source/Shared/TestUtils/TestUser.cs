using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna;
using BBC.Dna.Component;
using BBC.Dna.Page;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace Tests
{
    /// <summary>
    /// Derive from the class to partially implement IUser, instead of implementing evert method
    /// <para>
    /// Used for unit tests
    /// </para>
    /// </summary>
    public class TestUser : DnaComponent, IUser
    {
        /// <summary>
        /// Constructor for TestUser obejct
        /// </summary>
        public TestUser()
        {
        }

        /// <summary>
        /// 
        /// </summary>
        public virtual void BeginUpdateDetails()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public virtual bool UpdateDetails()
        {
            throw new NotImplementedException();
        }


        /// <summary>
        /// This is the function that creates the viewing user.
        /// </summary>
        public virtual void CreateUser()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Gets the user data details and fills in the XML block
        /// </summary>
        public virtual void GetUserDetails()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// ShowFullDetails Property
        /// </summary>
        /// 
        public virtual bool ShowFullDetails 
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Users EMail Property
        /// </summary>
        public virtual string Email 
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// TeamID Property
        /// </summary>
        public virtual int TeamID
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Journal Property
        /// </summary>
        public virtual int Journal
        {
            get
            {
                throw new NotImplementedException();
            }
        }
 
        /// <summary>
        /// UserID Property
        /// </summary>
        public virtual int UserID 
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// UserLoggedIn Property
        /// </summary>
        public virtual bool UserLoggedIn 
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// User name property
        /// </summary>
        public virtual string LoginName 
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }
		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public virtual bool IsEditor
		{
			get
			{
                throw new NotImplementedException("Not Implemented");
			}
		}

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsSuperUser 
        { 
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsNotable 
        { 
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsReferee 
        { 
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsModerator 
        {
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsPreModerated
        {
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsPostModerated
        {
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// True if the user has editor privileges on the current site
        /// </summary>
        public virtual bool IsBanned
        {
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

        /// <summary>
        /// Is user auto sin binned.
        /// </summary>
        public virtual bool IsAutoSinBin 
        {
            get
            {
                throw new NotImplementedException("Not Implemented");
            }
        }

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public string UserName
		{
			get
			{
				throw new NotImplementedException("haven't implemented UserName");
			}
		}

        /// <summary>
        /// Sets the preferred skin value
        /// </summary>
        /// <param name="skin">Skin to set</param>
        public void SetPreferredSkinInDB(string skin)
        {
            throw new NotImplementedException("haven't SetPreferredSkinInDB");
        }

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public string FirstNames
		{
			get
			{
				throw new NotImplementedException("haven't implemented FirstNames");
			}
		}

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public string LastName
		{
			get
			{
				throw new NotImplementedException("haven't implemented LastName");
			}
		}

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool AcceptSubscriptions
        {
            get
            {
                throw new NotImplementedException("haven't implemented AcceptSubscriptions");
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public void SetAcceptSubscriptions(bool bAcceptSubscriptions)
        {
            throw new NotImplementedException("haven't implemented AcceptSubscriptions");
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public string PreferredSkin
        {
            get
            {
                throw new NotImplementedException("haven't implemented get PreferredSkin");
            }
            set
            {
                throw new NotImplementedException("haven't implemented set referredSkin");
            }
         }

        /// <summary>
        /// Public access to the user data dictionary object
        /// </summary>
        public Dictionary<string, object> UserData
        {
            get { throw new NotImplementedException("haven't implemented get userData"); }
        }

		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public bool IsScout
		{
			get
			{
				throw new NotImplementedException("Haven't implemented IsScout");
			}
		}
		/// <summary>
		/// <see cref="IUser"/>
		/// </summary>
		public bool IsSubEditor
		{
			get
			{
				throw new NotImplementedException("Haven't implemented IsSubEditor");
			}
		}
        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsTester
        {
            get
            {
                throw new NotImplementedException("Haven't implemented IsSubEditor");
            }
        }
        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsHost
        {
            get
            {
                throw new NotImplementedException("Haven't implemented IsSubEditor");
            }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public XmlElement GetSitesThisUserIsEditorOfXML()
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public string BbcUid
        {
            get { throw new NotImplementedException("The BbcUid property not implemented!"); }
        }

        /// <summary>
        /// <see cref="IUser"/>
        /// </summary>
        public bool IsGuardian
        {
            get { throw new NotImplementedException(); }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="h2g2ID"></param>
        /// <returns></returns>
        public bool HasSpecialEditPermissions(int h2g2ID)
        {
            throw new NotImplementedException("HasSpecialEditPermissions not implimented");
        }

        /// <summary>
        /// Used when updating a user's record. Can only be called after calling BeginUpdateDetails
        /// </summary>
        /// <param name="userName"></param>
        public void SetUsername(string userName)
        {
            throw new NotImplementedException("SetUsername not implimented");
        }

        /// <summary>
        /// Updates a value within the user data dictionary
        /// </summary>
        /// <param name="name">name of variable</param>
        /// <param name="value">object value</param>
        /// <returns>True if add to update reader</returns>
        public bool SetUserData(string name, object value)
        {
            throw new NotImplementedException("SetUserData not implimented");
        }

        /// <summary>
        /// Set a new SiteSuffix field. Can be called only after BeginUpdateDetails
        /// </summary>
        /// <param name="siteSuffix">New SiteSuffix</param>
        public void SetSiteSuffix(string siteSuffix)
        {
            throw new NotImplementedException("SetSiteSuffix not implimented");
        }

		#region IUser Members

		/// <summary>
		/// True if the user is a member of a volunteer group
		/// </summary>
		public bool IsVolunteer
		{
			get { throw new Exception("Haven't implemented IsVolunteer"); }
		}

		#endregion

        #region IUser Members


        public BBC.Dna.Objects.User ConvertUser()
        {
            throw new NotImplementedException();
        }

        #endregion
    }
	/// <summary>
	/// Tests for the DnaBasePage.UserTypes enum, just for sanity
	/// </summary>
	[TestClass]
	public class UserTypesTest
	{
		/// <summary>
		/// Test that all the enums work in a predicted way
		/// </summary>
		[TestMethod]
		public void TestEnums()
		{
			// Set up a few combinations of user types (as they might be specified in AllowedUsers)
			DnaBasePage.UserTypes anyUser = DnaBasePage.UserTypes.Any;
			DnaBasePage.UserTypes authenticated = DnaBasePage.UserTypes.Authenticated;
			DnaBasePage.UserTypes volunteer = DnaBasePage.UserTypes.Volunteer;
			DnaBasePage.UserTypes tester = DnaBasePage.UserTypes.Tester;
			DnaBasePage.UserTypes moderator = DnaBasePage.UserTypes.Moderator;
			DnaBasePage.UserTypes editor = DnaBasePage.UserTypes.Editor;
			DnaBasePage.UserTypes administrator = DnaBasePage.UserTypes.Administrator;

			DnaBasePage.UserTypes volunteerandabove = DnaBasePage.UserTypes.VolunteerAndAbove;
			DnaBasePage.UserTypes moderatorandabove = DnaBasePage.UserTypes.ModeratorAndAbove;
			DnaBasePage.UserTypes editorandaabove = DnaBasePage.UserTypes.EditorAndAbove;

			Assert.IsTrue((anyUser & DnaBasePage.UserTypes.Any) != 0, "Match with any user failed");
			Assert.IsTrue((authenticated & DnaBasePage.UserTypes.Authenticated) != 0, "Match with authenticated user failed");
			Assert.IsTrue((volunteer & DnaBasePage.UserTypes.Volunteer) != 0, "Match with volunteer failed");
			Assert.IsTrue((tester & DnaBasePage.UserTypes.Tester) != 0, "Match with tester failed");
			Assert.IsTrue((moderator & DnaBasePage.UserTypes.Moderator) != 0, "Match with any user failed");
			Assert.IsTrue((editor & DnaBasePage.UserTypes.Editor) != 0, "Match with any user failed");
			Assert.IsTrue((administrator & DnaBasePage.UserTypes.Administrator) != 0, "Match with any user failed");
			Assert.IsTrue((volunteerandabove & DnaBasePage.UserTypes.Volunteer) != 0, "Match with Volunteer failed");
			Assert.IsTrue((volunteerandabove & DnaBasePage.UserTypes.Moderator) != 0, "Match with Volunteer failed");
			Assert.IsTrue((volunteerandabove & DnaBasePage.UserTypes.Editor) != 0, "Match with Volunteer failed");
			Assert.IsTrue((volunteerandabove & DnaBasePage.UserTypes.Administrator) != 0, "Match with Volunteer failed");
			Assert.IsTrue((moderatorandabove & DnaBasePage.UserTypes.Moderator) != 0, "Match with any user failed");
			Assert.IsTrue((moderatorandabove & DnaBasePage.UserTypes.Editor) != 0, "Match with any user failed");
			Assert.IsTrue((moderatorandabove & DnaBasePage.UserTypes.Administrator) != 0, "Match with any user failed");
			Assert.IsTrue((editorandaabove & DnaBasePage.UserTypes.Editor) != 0, "Match with any user failed");
			Assert.IsTrue((editorandaabove & DnaBasePage.UserTypes.Administrator) != 0, "Match with any user failed");
        }
    }
}
