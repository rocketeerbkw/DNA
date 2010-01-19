

using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Component;
using BBC.Dna;

namespace BBC.Dna
{
    /// <summary>
    /// The page UI class. Used to put the users page preferences into the current page
    /// </summary>
    public class PageUI : DnaComponent
    {
        ///TODO: replace with BBC.Dna.Objects.PageUi version
        /// <summary>
        /// Default constructor
        /// </summary>
        /// <param name="userID">The id of the user you want to get the page UI for</param>
        public PageUI(int userID)
        {
            // Create the basic layout for the XML
            XmlNode pageUI = AddElementTag(RootElement, "PAGEUI");

            // Add the Site home tag
            XmlNode current = AddElementTag(pageUI, "SITEHOME");
            AddAttribute(current, "VISIBLE", "1");
            AddAttribute(current, "LINKHINT", "/");

            // Add the search tag
            current = AddElementTag(pageUI, "SEARCH");
            AddAttribute(current, "VISIBLE", "1");
            AddAttribute(current, "LINKHINT", "/search");

            // Add the dont panic tag
            current = AddElementTag(pageUI, "DONTPANIC");
            AddAttribute(current, "VISIBLE", "1");
            AddAttribute(current, "LINKHINT", "/dontpanic");

            if (userID > 0)
            {
                // Add the My Home tag
                current = AddElementTag(pageUI, "MYHOME");
                AddAttribute(current, "VISIBLE", "1");
                AddAttribute(current, "LINKHINT", "/U" + userID.ToString());

                // Add the Register tag
                current = AddElementTag(pageUI, "REGISTER");
                AddAttribute(current, "VISIBLE", "1");

                // Add the My Details tag
                current = AddElementTag(pageUI, "MYDETAILS");
                AddAttribute(current, "VISIBLE", "1");
                AddAttribute(current, "LINKHINT", "/UserDetails");

                // Add the Logout tag
                current = AddElementTag(pageUI, "LOGOUT");
                AddAttribute(current, "VISIBLE", "1");
                AddAttribute(current, "LINKHINT", "/Logout");
            }
            else
            {
                // Add the My Home tag
                current = AddElementTag(pageUI, "MYHOME");
                AddAttribute(current, "VISIBLE", "0");

                // Add the Register tag
                current = AddElementTag(pageUI, "REGISTER");
                AddAttribute(current, "VISIBLE", "1");
                AddAttribute(current, "LINKHINT", "/Register");

                // Add the My Details tag
                current = AddElementTag(pageUI, "MYDETAILS");
                AddAttribute(current, "VISIBLE", "0");
                AddAttribute(current, "LINKHINT", "");

                // Add the Logout tag
                current = AddElementTag(pageUI, "LOGOUT");
                AddAttribute(current, "VISIBLE", "0");
                AddAttribute(current, "LINKHINT", "");
            }

            // Add the Edit page tag
            current = AddElementTag(pageUI, "EDITPAGE");
            AddAttribute(current, "VISIBLE", "0");
            AddAttribute(current, "LINKHINT", "");

            // Add the Recomended entry tag
            current = AddElementTag(pageUI, "RECOMMEND-ENTRY");
            AddAttribute(current, "VISIBLE", "0");
            AddAttribute(current, "LINKHINT", "");

            // Add the Entry Submitted tag
            current = AddElementTag(pageUI, "ENTRY-SUBBED");
            AddAttribute(current, "VISIBLE", "0");
            AddAttribute(current, "LINKHINT", "");

            // Add the Discuss tag
            current = AddElementTag(pageUI, "DISCUSS");
            AddAttribute(current, "VISIBLE", "0");
            AddAttribute(current, "LINKHINT", "");

            // Generate the random number for the banner ad?
            Random rnd = new Random((int)DateTime.Now.Ticks);
            int random = rnd.Next();

            // Add the Main Banner tag
            current = AddElementTag(pageUI, "BANNER");
            AddAttribute(current, "NAME", "main");
            AddAttribute(current, "SEED", random);
            AddAttribute(current, "SECTION", "frontpage");

            // Add the Small Banner tag
            current = AddElementTag(pageUI, "BANNER");
            AddAttribute(current, "NAME", "small");
            AddAttribute(current, "SEED", random);
            AddAttribute(current, "SECTION", "frontpage");
        }

        /// <summary>
        /// Sets the visible state and link hint for a given UI Element
        /// </summary>
        /// <param name="elementName">The name of the UI Element yoiu want to update</param>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want to update this.</param>
        /// <returns>True if the element was updated, false if not</returns>
        private bool SetElementVisibility(string elementName, bool visible, string linkHint)
        {
            // Make sure the link hint does not start with a slash
            if (linkHint != null)
            {
                linkHint = linkHint.TrimStart('/');
            }

            // Find the element to update
            XmlNode element = RootElement.SelectSingleNode("//" + elementName);
            if (element != null)
            {
                // Set the visibility flag
                if (visible)
                {
                    element.Attributes["VISIBLE"].Value = "1";
                }
                else
                {
                    element.Attributes["VISIBLE"].Value = "0";
                }

                // Update the hint
                if (linkHint != null)
                {
                    element.Attributes["LINKHINT"].Value = linkHint;
                }
            }

            // Return the verdict
            return element != null;
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetSiteHomeVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("SITEHOME", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetDontPanicVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("DONTPANIC", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetSearchVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("SEARCH", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetMyHomeVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("MYHOME", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetRegisterVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("REGISTER", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetMyDetailsVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("MYDETAILS", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetLogoutVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("LOGOUT", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetEditPageVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("EDITPAGE", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetRecommendEntryVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("RECOMMEND-ENTRY", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetEntrySubbedVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("ENTRY-SUBBED", visible, linkHint);
        }

        /// <summary>
        /// Sets the visibility for the site home element.
        /// </summary>
        /// <param name="visible">The visibility state you want to set the element to</param>
        /// <param name="linkHint">The new link hint for the element. Set this to null if you dont want it updating.</param>
        /// <returns>True if the element was updated, false if not</returns>
        public bool SetDiscussVisibility(bool visible, string linkHint)
        {
            return SetElementVisibility("DISCUSS", visible, linkHint);
        }
    }
}
