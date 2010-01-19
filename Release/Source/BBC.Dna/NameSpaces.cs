using System;
using System.Collections.Generic;
using System.Text;
using BBC.Dna;
using BBC.Dna.Data;

namespace BBC.Dna
{
    /// <summary>
    /// 
    /// </summary>
    public class NameSpaceItem
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="name"></param>
        /// <param name="id"></param>
        public NameSpaceItem(string name, int id)
        {
            _name = name;
            _id = id;
        }

        private string _name;
        private int _id;

        /// <summary>
        /// 
        /// </summary>
        public string Name
        {
            get { return _name; }
        }

        /// <summary>
        /// 
        /// </summary>
        public int ID
        {
            get { return _id; }
        }
    }
    
    /// <summary>
    /// 
    /// </summary>
    public class NameSpaces
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        public NameSpaces(IInputContext context)
        {
            _inputContext = context;
        }

        private IInputContext _inputContext;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteid"></param>
        /// <returns></returns>
        public List<NameSpaceItem> GetNameSpacesForSite(int siteid)
        {
            List<NameSpaceItem> namespaces = new List<NameSpaceItem>();
            List<string> phrases = new List<string>();

            // Create a reader to get the names from the database
            using (IDnaDataReader reader = _inputContext.CreateDnaDataReader("getnamespacesforsite"))
            {
                // now add the siteid and execute
                reader.AddParameter("siteid", siteid);
                reader.Execute();
                while (reader.Read())
                {
                    // Add all the namespaces to the list
                    namespaces.Add(new NameSpaceItem(reader.GetString("name"), reader.GetInt32("namespaceid")));
                }
            }

            return namespaces;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteid"></param>
        /// <param name="newNameSpace"></param>
        /// <returns></returns>
        public int AddNameSpaceForSite(int siteid, string newNameSpace)
        {
            // Create a reader to get the names from the database
            using (IDnaDataReader reader = _inputContext.CreateDnaDataReader("addnamespacetosite"))
            {
                // now add the siteid and execute
                reader.AddParameter("siteid", siteid);
                reader.AddParameter("namespace", newNameSpace);
                reader.Execute();
                if (reader.Read())
                {
                    return reader.GetInt32("NameSpaceID");
                }
            }
            return -1;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteid"></param>
        /// <param name="nameSpaceID"></param>
        /// <param name="newName"></param>
        public void RenameNameSpaceForSite(int siteid, int nameSpaceID, string newName)
        {
            // Create a reader to get the names from the database
            using (IDnaDataReader reader = _inputContext.CreateDnaDataReader("renamenamespace"))
            {
                // now add the siteid and execute
                reader.AddParameter("siteid", siteid);
                reader.AddParameter("namespaceid", nameSpaceID);
                reader.AddParameter("namespace", newName);
                reader.Execute();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteid"></param>
        /// <param name="nameSpaceID"></param>
        public void RemoveNameSpaceForSite(int siteid, int nameSpaceID)
        {
            using (IDnaDataReader reader = _inputContext.CreateDnaDataReader("deletenamespaceandassociatedlinks"))
            {
                // now add the siteid and execute
                reader.AddParameter("siteid", siteid);
                reader.AddParameter("namespaceid", nameSpaceID);
                reader.Execute();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="siteID"></param>
        /// <param name="nameSpaceID"></param>
        /// <returns></returns>
        public List<string> GetPhrasesForNameSpaceItem(int siteID, int nameSpaceID)
        {
            List<string> phrases = new List<string>();
            using (IDnaDataReader reader = _inputContext.CreateDnaDataReader("getphrasesfornamespace"))
            {
                // now add the siteid and execute
                reader.AddParameter("siteid", siteID);
                reader.AddParameter("namespaceid", nameSpaceID);
                reader.Execute();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        phrases.Add(reader.GetString("phrase"));
                    }
                }
            }
            return phrases;
        }
    }
}
