using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using BBC.Dna.Component;
using System.Xml;
using BBC.Dna.Data;

namespace BBC.Dna.Component
{
    /// <summary>
    /// LinksList.
    /// List of user links/clippings/bookmarks created by the user.
    /// </summary>
    public class LinksList : DnaInputComponent
    {

        /// <summary>
        /// Default Constructor for the LinksList object
        /// </summary>
        public LinksList(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// Accesses DB and creates Links List.
        /// Links created by users.
        /// </summary>
        /// <param name="userID">The user of the links to get</param>
        /// <param name="siteID">Site of the links</param>
        /// <param name="skip">number of links to skip</param>
        /// <param name="show">number to show</param>
        /// <param name="showPrivate">Indicates whether private links should be included.</param>
        /// <returns>Whether created ok</returns>
        public bool CreateLinksList(int userID, int siteID, int skip, int show, bool showPrivate)
        {
            // check object is not already initialised
            if (userID <= 0 || show <= 0)
            {
                return false;
            }

            XmlElement list = AddElementTag(RootElement, "LINKS-LIST");
            AddAttribute(list, "SKIP", skip);
            AddAttribute(list, "SHOW", show);

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("getmorelinks"))
            {
                dataReader.AddParameter("userid", userID);
                dataReader.AddParameter("linkgroup", String.Empty);
                dataReader.AddParameter("showprivate", showPrivate);
                dataReader.AddParameter("siteid", InputContext.CurrentSite.SiteID);

                // Get +1 so we know if there are more left
                dataReader.AddParameter("skip", skip);
                dataReader.AddParameter("show", show + 1);

                dataReader.Execute();

                if (dataReader.HasRows)
                {
                    //1st Result set gets user details.
                    if (dataReader.Read())
                    {
                        User user = new User(InputContext);
                        user.AddUserXMLBlock(dataReader, userID, list);
                        dataReader.NextResult();
                    }

                    //Paged List of Links / Clippings / Bookmarks .
                    int count = 0;
                    Link link = new Link(InputContext);
                    while (dataReader.Read() && count < show)
                    {
                        //Delegate creation of XML to Link class.
                        link.CreateLinkXML(dataReader, list, true, false);
                        ++count;
                    }

                    // Add More Attribute Indicating there are more rows.
                    if (dataReader.Read() && count > 0)
                    {
                        AddAttribute(list, "MORE", 1);
                    }
                }
            }
            return true;
        }
    }
}