using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using BBC.Dna.Page;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Utils;

namespace BBC.Dna
{
    /// <summary>
    /// The Category component
    /// </summary>
    public class Category : DnaInputComponent, ICategory
    {
        const int MAX_CLOSE_ROWS = 500;
        const int SORT_LASTUPDATED = 1;

        const int MAX_ARTICLE_ROWS = 500;

        /// <summary>
        /// Enumeration of the Category Filter type
        /// </summary>
        public enum CategoryTypeFilter
        {
            /// <summary>
            /// None
            /// </summary>
            None,
            /// <summary>
            /// TypedArticle
            /// </summary>
            TypedArticle,
            /// <summary>
            /// Thread
            /// </summary>
            Thread,
            /// <summary>
            /// User
            /// </summary>
            User
        };

        private bool _includeStrippedNames = false;

        /// <summary>
        /// Default constructor for the category component
        /// </summary>
        /// <param name="context">The inputcontext that the component is running in</param>
        public Category(IInputContext context)
            : base(context)
        {
        }

        /// <summary>
        /// The include stripped names property
        /// </summary>
        public bool IncludeStrippedNames
        {
            set { _includeStrippedNames = value; }
        }

        /// <summary>
        /// This method creates the Crumbtrail xml for a given article id
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the crumbtrail for</param>
        public void CreateArticleCrumbtrail(int h2g2ID)
        {
            // Create the reader to get the details
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getarticlecrumbtrail"))
            {
                reader.AddParameter("h2g2ID",h2g2ID);
                reader.Execute();

                // Now create the crumbtrails from the results
                GetCrumbtrailForItem(reader);
            }
        }

        /// <summary>
        /// This method creates the crumbtrail for a given item
        /// </summary>
        /// <param name="reader">The DnaDataReader that contains the crumbtrail result set.</param>
        private void GetCrumbtrailForItem(IDnaDataReader reader)
        {
            XmlNode crumbtrailsNode = AddElementTag(RootElement, "CRUMBTRAILS");
            bool startOfTrail = true;
            XmlNode crumbtrailNode = null;
            while (reader.Read())
            {
                // Check to see if we're at the top level
                int treeLevel = reader.GetInt32("TreeLevel");
                if (treeLevel == 0)
                {
                    startOfTrail = true;
                }
                
                // Check to see if we're starting a new trail
                if (startOfTrail)
                {
                    crumbtrailNode = AddElementTag(crumbtrailsNode, "CRUMBTRAIL");
                    startOfTrail = false;
                }

                XmlNode ancestorNode = AddElementTag(crumbtrailNode, "ANCESTOR");
                AddIntElement(ancestorNode, "NODEID", reader.GetInt32("NodeID"));
                AddTextElement((XmlElement)ancestorNode, "NAME", reader.GetString("DisplayName"));
                AddIntElement(ancestorNode, "TREELEVEL", treeLevel);
                AddIntElement(ancestorNode, "NODETYPE", reader.GetInt32("Type"));
                if (reader.Exists("RedirectNodeID") && !reader.IsDBNull("RedirectNodeID"))
                {
                    XmlNode redirectNode = AddTextElement((XmlElement)ancestorNode, "REDIRECTNODE", reader.GetString("RedirectNodeName"));
                    AddAttribute(redirectNode,"ID", reader.GetInt32("RedirectNodeID"));
                }
            }
        }

        /// <summary>
        /// This methos gets the list of related clubs for a given article
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the related clubs for</param>
        public void GetRelatedClubs(int h2g2ID)
        {
            // Create a data reader to get all the clubs
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getrelatedclubs"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.Execute();

                XmlNode relatedClubsNode = AddElementTag(RootElement, "RELATEDCLUBS");
                
                // Add each club member in turn
                while (reader.Read())
                {
                    XmlNode clubNode = AddElementTag(relatedClubsNode, "CLUBMEMBER");
                    AddIntElement(clubNode, "CLUBID", reader.GetInt32("ClubID"));
                    AddTextElement((XmlElement)clubNode, "NAME", reader.GetString("Subject"));
                    ExtraInfo clubExtraInfo = new ExtraInfo();
                    clubExtraInfo.TryCreate(reader.GetInt32("Type"),reader.GetString("ExtraInfo"));
                    clubNode.AppendChild(ImportNode(clubExtraInfo.RootElement.FirstChild));
                    if (reader.Exists("DateCreated"))
                    {
                        XmlNode dateCreatedNode = AddElementTag(clubNode, "DATECREATED");
                        dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("DateCreated"), true));
                    }
                    if (reader.Exists("Lastupdated"))
                    {
                        XmlNode dateCreatedNode = AddElementTag(clubNode, "LASTUPDATE");
                        dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("DateCreated"), true));
                    }

                    // NEED TO ADD EDITOR, CLUBMEMBERS, LOCAL, EXTRAINFO, STRIPPED NAME... CHECK CLUB MEMBERS
                }
            }
        }

        /// <summary>
        /// This method gets all the related articles for a given article h2g2ID
        /// </summary>
        /// <param name="h2g2ID">The id of the article you want to get the related articles for</param>
        public void GetRelatedArticles(int h2g2ID)
        {
            // Create the datareader to get the articles
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getrelatedarticles"))
            {
                reader.AddParameter("h2g2ID", h2g2ID);
                reader.AddParameter("CurrentSiteID", 0);
                reader.Execute();

                XmlNode relatedArticlesNode = AddElementTag(RootElement, "RELATEDARTICLES");

                // Add each article in turn
                while (reader.Read())
                {
                    XmlNode relatedArticleNode = AddElementTag(relatedArticlesNode, "ARTICLEMEMBER");
                    AddIntElement(relatedArticleNode, "H2G2ID", h2g2ID);
                    string articleName = reader.GetString("Subject");
                    AddTextElement((XmlElement)relatedArticleNode, "NAME", articleName);
                    if (_includeStrippedNames)
                    {
                        string strippedName = StringUtils.StrippedName(articleName);
                        AddTextElement((XmlElement)relatedArticleNode, "STRIPPEDNAME", strippedName);
                    }
                    XmlNode userNode = AddElementTag(relatedArticleNode, "EDITOR");
                    User articleEditor = new User(InputContext);
                    articleEditor.AddPrefixedUserXMLBlock(reader, reader.GetInt32("Editor"), "Editor", userNode);
                    int status = reader.GetInt32("Status");
                    XmlNode statusNode = AddTextElement((XmlElement)relatedArticleNode, "STATUS", GuideEntry.GetDescriptionForStatusValue(status));
                    AddAttribute(statusNode, "TYPE", status);
                    ExtraInfo articleExtraInfo = new ExtraInfo();
                    int articleType = reader.GetInt32("Type");
                    int articleHidden = 0;
                    if (reader.Exists("Hidden") && !reader.IsDBNull("Hidden"))
                    {
                        articleHidden = reader.GetInt32("Hidden");
                    }
                    
                    // Create and add the article extra info
                    articleExtraInfo.TryCreate(articleType, reader.GetString("ExtraInfo"));
                    AddInside(relatedArticleNode, articleExtraInfo);

                    if (reader.Exists("DateCreated"))
                    {
                        XmlNode dateCreatedNode = AddElementTag(relatedArticleNode, "DATECREATED");
                        dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("DateCreated"), true));
                    }
                    if (reader.Exists("Lastupdated"))
                    {
                        XmlNode dateCreatedNode = AddElementTag(relatedArticleNode, "LASTUPDATE");
                        dateCreatedNode.AppendChild(DnaDateTime.GetDateTimeAsElement(RootElement.OwnerDocument, reader.GetDateTime("DateCreated"), true));
                    }

                    // NOW ADD KEYPHRASES, MEDIA ASSETS, POLLS
                }
            }
        }

        /// <summary>
        /// Gets the user crumb trail
        /// </summary>
        /// <param name="userID">The user to get the crumbtrail of</param>
        public void GetUserCrumbTrail(int userID)
        {
            // Create the datareader to get the articles
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getusercrumbtrail"))
            {
                reader.AddParameter("UserID", userID);
                reader.Execute();

                GetCrumbtrailForItem(reader);
            }
        }

        /// <summary>
        /// Builds ANCESTRY xml for given hierarchy node
        /// </summary>
        /// <param name="nodeID">The node ID in question</param>
        /// <returns>resulting xml element</returns>
        public XmlElement GetCategoryAncestry(int nodeID)
        {
            XmlElement ancestry = null;

            // Create the datareader to get the articles
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getancestry"))
            {
                reader.AddParameter("catID", nodeID);
                reader.Execute();

                if (reader.HasRows)
                {
                    ancestry = CreateElement("ANCESTRY");
                    while (reader.Read())
                    {
                        XmlElement ancestor = AddElementTag(ancestry, "ANCESTOR");
                        int ancestorID = reader.GetInt32NullAsZero("AncestorID");
                        AddIntElement(ancestor, "NODEID", ancestorID);

                        int ancestorTypeID = reader.GetInt32NullAsZero("Type");
                        AddIntElement(ancestor, "TYPE", ancestorID);

                        string ancestorName = reader.GetStringNullAsEmpty("DisplayName");
                        AddTextTag(ancestor, "NAME", ancestorID);

                        int treeLevel = reader.GetInt32NullAsZero("TreeLevel");
                        AddIntElement(ancestor, "TREELEVEL", ancestorID);

                        // Check to see if the node has a redirected
                        if (reader.DoesFieldExist("RedirectNodeID") && !reader.IsDBNull("RedirectNodeID"))
                        {
                            string displayName = reader.GetStringNullAsEmpty("RedirectNodeName");
                            XmlElement redirectNode = AddTextTag(ancestor, "REDIRECTNODE", displayName);
                            AddAttribute(redirectNode, "ID", reader.GetInt32NullAsZero("RedirectNodeID"));
                        }
                    }
                }
            }
            return ancestry;
        }

        /// <summary>
        /// Gets the subject members for a particular node id
        /// </summary>
        /// <param name="nodeID">The node ID in question</param>
        /// <returns>XML node with a list of Subjects for a node and it's subnodes</returns>
        public XmlElement GetSubjectMembersForNodeID(int nodeID)
        {
	        // Check the NodeID!
	        if (nodeID == 0)
	        {
		        throw new DnaException("Category - NoNodeIDGiven - Illegal NodeID (0)");
	        }

            XmlElement subjectMemberList = CreateElement("SUBJECTMEMBERLIST");
            // Now get the list for the given list id
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getsubjectsincategory"))
            {
                reader.AddParameter("nodeID", nodeID);
                reader.Execute();

                if (reader.HasRows)
                {
                    // Setup some local variables
                    int lastNodeID = 0;
                    int currentNodeID = 0;
                    bool addedSubNodes = false;
                    string subNodeName = String.Empty;

                    XmlElement subjectMember = null;
                    XmlElement subNodes = null;

                    while (reader.Read())
                    {
                        // Get the current nodeid
                        currentNodeID = reader.GetInt32NullAsZero("NodeID");
                        if (currentNodeID != lastNodeID)
                        {
                            if (lastNodeID != 0)
                            {
                                if (addedSubNodes)
                                {
                                    subjectMember.AppendChild(subNodes);
                                    addedSubNodes = false;
                                }
                                subjectMemberList.AppendChild(subjectMember);
                            }
                        }

                        subjectMember = CreateElement("SUBJECTMEMBER");
                        AddIntElement(subjectMember, "NODEID", reader.GetInt32NullAsZero("NODEID"));
                        AddIntElement(subjectMember, "TYPE", reader.GetInt32NullAsZero("TYPE"));
                        AddIntElement(subjectMember, "NODECOUNT", reader.GetInt32NullAsZero("NODEMEMBERS"));
                        AddIntElement(subjectMember, "ARTICLECOUNT", reader.GetInt32NullAsZero("ARTICLEMEMBERS"));
                        AddIntElement(subjectMember, "ALIASCOUNT", reader.GetInt32NullAsZero("NODEALIASMEMBERS"));
                        AddTextTag(subjectMember, "NAME", reader.GetStringNullAsEmpty("DISPLAYNAME"));

                        AddTextTag(subjectMember, "STRIPPEDNAME", StringUtils.StrippedName(reader.GetStringNullAsEmpty("DISPLAYNAME")));

                        AddIntElement(subjectMember, "REDIRECTNODEID", reader.GetInt32NullAsZero("REDIRECTNODEID"));

                        // Check to see if it's got any subnodes!
                        if (reader.DoesFieldExist("SubName") && !reader.IsDBNull("SubName"))
                        {
                            // If we haven't opened the Subnodes Tag, do so
                            if (!addedSubNodes)
                            {
                                addedSubNodes = true;
                                subNodes = CreateElement("SUBNODES");
                            }

                            XmlElement subNode = CreateElement("SUBNODE");
                            AddAttribute(subNode, "ID", reader.GetInt32NullAsZero("SubNodeID"));
                            AddAttribute(subNode, "TYPE", reader.GetInt32NullAsZero("SubNodeType"));
                            AddTextTag(subNode, "SUBNAME", reader.GetStringNullAsEmpty("SubName"));
                            subNodes.AppendChild(subNode);
                        }

                        // Set the last node and move to the next result
                        lastNodeID = currentNodeID;
                    }
                    // Check to see if we've reached the end of the results and need to close the subnodes!
                    if (lastNodeID != 0)
                    {
                        if (addedSubNodes)
                        {
                            subjectMember.AppendChild(subNodes);
                        }
                        subjectMemberList.AppendChild(subjectMember);
                    }
                }
            }
            return subjectMemberList;
        }
        /// <summary>
        /// Produce XML for users posts tagged to the specified node.
        /// </summary>
        /// <param name="nodeID">The node ID in question</param>
        /// <returns>An XML Element contain the list of users for a node</returns>
        public XmlElement GetUsersForNodeID(int nodeID)
        {
            // Check the NodeID!
            if (nodeID == 0)
            {
                throw new DnaException("Category - NoNodeIDGiven - Illegal NodeID (0)");
            }

            XmlElement userMemberList = CreateElement("USERMEMBERLIST");
            // Now get the list for the given list id
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getusersfornode"))
            {
                reader.AddParameter("nodeID", nodeID);
                reader.AddParameter("siteID", InputContext.CurrentSite.SiteID);
                reader.Execute();

                if (reader.HasRows)
                {
                    int userMemberCount = 0;
                    while (reader.Read())
                    {                      
                        User user = new User(InputContext);
                        int userID = reader.GetInt32NullAsZero("UserID");
                        user.AddUserXMLBlock(reader, userID, userMemberList);

                        userMemberCount++;
                    }
                    AddIntElement(userMemberList, "USERMEMBERCOUNT", userMemberCount);
                }
            }
            return userMemberList;
        }

        /// <summary>
        /// Returns the Node alias members for a given node id
        /// </summary>
        /// <param name="nodeID">The node ID in question</param>
        /// <returns>An XML Element contain the list of aliases for a node</returns>
        public XmlElement GetNodeAliasMembersForNodeID(int nodeID)
        {
	        // Check the NodeID!
	        if (nodeID == 0)
	        {
                throw new DnaException("Category - NoNodeIDGiven - Illegal NodeID (0)");
	        }

            XmlElement nodeAliasMemberList = CreateElement("NODEALIASMEMBERLIST");
            // Now get the alias member for the given node id
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("getaliasesinhierarchy"))
            {
                reader.AddParameter("nodeID", nodeID);
                reader.Execute();

                if (reader.HasRows)
                {
                    // Setup some local variables
                    int lastNodeID = 0;
                    int currentNodeID = 0;
                    bool addedSubNodes = false;
                    string subNodeName = String.Empty;

                    XmlElement nodeAliasMember = null;
                    XmlElement subNodes = null;

                    while (reader.Read())
                    {
                        // Get the current nodeid
                        currentNodeID = reader.GetInt32NullAsZero("LinkNodeID");
                        if (currentNodeID != lastNodeID)
                        {
                            if (lastNodeID != 0)
                            {
                                if (addedSubNodes)
                                {
                                    nodeAliasMember.AppendChild(subNodes);
                                    addedSubNodes = false;
                                }
                                nodeAliasMemberList.AppendChild(nodeAliasMember);
                            }
                        }

                        nodeAliasMember = CreateElement("NODEALIASMEMBER");
                        AddIntElement(nodeAliasMember, "LINKNODEID", reader.GetInt32NullAsZero("LINKNODEID"));
                        AddIntElement(nodeAliasMember, "NODECOUNT", reader.GetInt32NullAsZero("NODEMEMBERS"));
                        AddIntElement(nodeAliasMember, "ARTICLECOUNT", reader.GetInt32NullAsZero("ARTICLEMEMBERS"));
                        AddIntElement(nodeAliasMember, "ALIASCOUNT", reader.GetInt32NullAsZero("NODEALIASMEMBERS"));
                        AddTextTag(nodeAliasMember, "NAME", reader.GetStringNullAsEmpty("DISPLAYNAME"));

                        AddTextTag(nodeAliasMember, "STRIPPEDNAME", StringUtils.StrippedName(reader.GetStringNullAsEmpty("DISPLAYNAME")));

                        // Check to see if it's got any subnodes!
                        if (reader.DoesFieldExist("SubName") && !reader.IsDBNull("SubName"))
                        {
                            // If we haven't opened the Subnodes Tag, do so
                            if (!addedSubNodes)
                            {
                                addedSubNodes = true;
                                subNodes = CreateElement("SUBNODES");
                            }

                            XmlElement subNode = CreateElement("SUBNODE");
                            AddAttribute(subNode, "ID", reader.GetInt32NullAsZero("SubNodeID"));
                            AddTextTag(subNode, "SUBNAME", reader.GetStringNullAsEmpty("SubName"));
                            subNodes.AppendChild(subNode);
                        }

                        // Set the last node and move to the next result
                        lastNodeID = currentNodeID;
                    }
                    // Check to see if we've reached the end of the results and need to close the subnodes!
                    if (lastNodeID != 0)
                    {
                        if (addedSubNodes)
                        {
                            nodeAliasMember.AppendChild(subNodes);
                        }
                        nodeAliasMemberList.AppendChild(nodeAliasMember);
                    }
                }
            }
            return nodeAliasMemberList;
        }

        /// <summary>
        /// Builds Hierarchy xml from the given datareader
        /// </summary>
        /// <param name="reader">The datset to query</param>
        /// <returns>resulting xml element</returns>
        public XmlElement GetHierarchyDetails(IDnaDataReader reader)
        {
            XmlElement hierarchyDetails = CreateElement("HIERARCHYDETAILS");

            string description = reader.GetStringNullAsEmpty("Description");
            string synonyms = reader.GetStringNullAsEmpty("Synonyms");
            int H2G2ID = reader.GetInt32NullAsZero("h2g2id");
            int nodeID = reader.GetInt32NullAsZero("nodeid");

            int userAdd = reader.GetInt32NullAsZero("UserAdd");
            int parentID = reader.GetInt32NullAsZero("ParentID");
            int typeID = reader.GetInt32NullAsZero("Type");

            AddAttribute(hierarchyDetails, "NODEID", nodeID);
            if (parentID == 0)	//is root?
            {
                AddAttribute(hierarchyDetails, "ISROOT", 1);
            }
            else
            {
                AddAttribute(hierarchyDetails, "ISROOT", 0);
            }
            AddAttribute(hierarchyDetails, "USERADD", userAdd);
            AddAttribute(hierarchyDetails, "TYPE", typeID);

            string displayName = reader.GetStringNullAsEmpty("DisplayName");
            AddTextTag(hierarchyDetails, "DISPLAYNAME", displayName);

            if (nodeID > 0)
            {
                AddTextTag(hierarchyDetails, "DESCRIPTION", description);
                AddTextTag(hierarchyDetails, "SYNONYMS", synonyms);
                if (H2G2ID > 0)
                {
                    AddIntElement(hierarchyDetails, "H2G2ID", H2G2ID);
                }

                // Check to see if the node has a redirected
                if (reader.DoesFieldExist("RedirectNodeID") && !reader.IsDBNull("RedirectNodeID"))
                {
                    string RedirectNodeName = reader.GetStringNullAsEmpty("RedirectNodeName");
                    XmlElement redirectNode = AddTextTag(hierarchyDetails, "REDIRECTNODE", RedirectNodeName);
                    AddAttribute(redirectNode, "ID", reader.GetInt32NullAsZero("RedirectNodeID"));
                }
            }
            return hierarchyDetails;
        }


        /// <summary>
        /// Gets the hierarchy/category name for a given node id
        /// </summary>
        /// <param name="nodeID">The node ID in question</param>
        /// <returns>The category/hierarchy name</returns>
        public string GetHierarchyName(int nodeID)
        {
            string categoryName = String.Empty;

            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("gethierarchynodedetails2"))
            {
                reader.AddParameter("nodeID", nodeID);
                reader.Execute();

                if (reader.HasRows)
                {
                    if (reader.Read())
                    {
                        categoryName = reader.GetStringNullAsEmpty("DisplayName");
                    }
                }
            }
            return categoryName;
        }

        /// <summary>
        /// Gets the article members node for a given ID
        /// </summary>
        /// <param name="nodeID">The hierarchy node</param>
        /// <param name="type">The hierarchy node type</param>
        /// <param name="show">The number of rows to show</param>
        /// <param name="skip">The number of rows to skip</param>
        /// <param name="rows">The number of rows so far which is updated</param>
        /// <returns>Element containing the article members XML</returns>
        public XmlElement GetArticleMembersForNodeID(int nodeID, int type, int show, int skip, ref int rows)
        {
            // Check the NodeID!
            if (nodeID == 0)
            {
                throw new DnaException("Category - NoNodeIDGiven - Illegal NodeID (0)");
            }

            XmlElement nodeAliasMemberList = CreateElement("NODEALIASMEMBERLIST");

            int userTaxonomyNodeID = 0;
            // Now get the node articles for the given list id
            bool needMediaAssetInfo = false;
            bool includeKeyPhraseData = false;

            needMediaAssetInfo = InputContext.GetSiteOptionValueBool("MediaAsset", "ReturnInCategoryList");

            includeKeyPhraseData = InputContext.GetSiteOptionValueBool("KeyPhrases", "ReturnInCategoryList");

            string storedProcedureName = String.Empty;
            if (includeKeyPhraseData)
            {
                storedProcedureName = "getarticlesinhierarchynodewithkeyphrases";
            }
            else
            {
                if (InputContext.CurrentSite.IncludeCrumbtrail == 1)
                {
                    if (needMediaAssetInfo)
                    {
                        storedProcedureName = "getarticlesinhierarchynodewithlocalwithmediaassets";
                    }
                    else
                    {
                        storedProcedureName = "getarticlesinhierarchynodewithlocal";
                    }
                }
                else
                {

                    if (needMediaAssetInfo)
                    {
                        storedProcedureName = "getarticlesinhierarchynodewithmediaassets";
                    }
                    else
                    {
                        storedProcedureName = "getarticlesinhierarchynode";
                    }
                }
            }  

            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader(storedProcedureName))
            {
                dataReader.AddParameter("nodeid", nodeID);
                dataReader.AddParameter("type", type);
                dataReader.AddParameter("maxresults", skip + show);
                dataReader.AddParameter("currentsiteid", InputContext.CurrentSite.SiteID);

                if (includeKeyPhraseData)
                {
                    if (needMediaAssetInfo)
                    {
                        dataReader.AddParameter("showmediaassetdata", 1);
                    }
                    else
                    {
                        dataReader.AddParameter("showmediaassetdata", 0);
                    }
                }
                else
                {
                    dataReader.AddParameter("showcontentratingdata", 1);
                    if (InputContext.CurrentSite.IncludeCrumbtrail == 1)
                    {
                        userTaxonomyNodeID = 0;// InputContext.ViewingUser.TaxonomyNode;

                        dataReader.AddParameter("usernodeid", userTaxonomyNodeID);
                    }
                }  

                dataReader.Execute();

	            //Process the keyphrases DataSet first map of entry IDs to phrases
	            Dictionary<int, List<Phrase>> articleKeyPhrases = new Dictionary<int,List<Phrase>>(); 

	            if (includeKeyPhraseData)
	            {
		            List<Phrase> phraselist = new List<Phrase>();
		            int articleCount=0;
		            int prevEntryID=0;
		            int thisEntryID=prevEntryID;

		            if(dataReader.HasRows && dataReader.Read())
		            {
			            if (skip > 0)
			            {
				            //Skips the number of articles in the returned key phrases
				            do
				            {
					            thisEntryID = dataReader.GetInt32NullAsZero("EntryID");
					            if(prevEntryID == 0) //The first time
					            {
						            prevEntryID = thisEntryID;
					            }
					            if(thisEntryID != prevEntryID)
					            {
						            prevEntryID = thisEntryID;
						            articleCount++;
					            }
				            } while (dataReader.Read() && articleCount < skip);
			            }

			            prevEntryID = 0;
			            //Now generates the list of phrases matching the entry id of the article
			            do
			            {
				            thisEntryID = dataReader.GetInt32NullAsZero("EntryID");
				            if(prevEntryID == 0) //The first time
				            {
					            prevEntryID = thisEntryID;
				            }
				            if(thisEntryID != prevEntryID)
				            {
					            articleKeyPhrases.Add(prevEntryID, phraselist);
					            phraselist.Clear();
					            prevEntryID = thisEntryID;				
				            }

				            string phrase = "";
				            string phraseNamespace = "";
            				
				            if(dataReader.DoesFieldExist("Phrase") && !dataReader.IsDBNull("Phrase"))
				            {
					            phrase = dataReader.GetStringNullAsEmpty("Phrase");

					            if(dataReader.DoesFieldExist("Namespace") && !dataReader.IsDBNull("Namespace"))
					            {
                                    phraseNamespace = dataReader.GetStringNullAsEmpty("Namespace");
					            }
            					
					            Phrase phraseObject = new Phrase(phrase, phraseNamespace);

                                phraselist.Add(phraseObject);
				            }

			            } while (dataReader.Read());
		            }
                    //We have the keyphrases now move onto the next recordset with the actual articles
            		dataReader.NextResult();
	            }
            	
	            if (skip > 0)
	            {
                    //Read/skip over the skip number of rows so that the row that the first row that in the do below is 
                    //the one required
                    for (int i = 0; i < skip; i++)
                    {
                        dataReader.Read();
                    }
	            }

	            int thisType = 0;
	            int prevType = -1;
	            Dictionary<int,int> typeCounts = new Dictionary<int,int>();
	            if(dataReader.HasRows)
	            {
                    while(dataReader.Read() && show > 0)
                    {
                        nodeAliasMemberList.AppendChild(AddArticleMemberXML(dataReader, articleKeyPhrases));
                		
		                //Record the count for each type.
                        thisType = dataReader.GetInt32NullAsZero("Type");
                        if (prevType != thisType)
		                {
                            typeCounts[thisType] = dataReader.GetInt32NullAsZero("TypeCount");
                            prevType = thisType;
		                }

		                if ( skip > 0  )
		                {
			                show--;
			                if ( show == 0 )
			                {
				                break;
			                }
		                }				
	                }
                }

	            //Add the count information.
	            foreach(KeyValuePair<int,int> articleMemberCount in typeCounts)
	            {
                    XmlElement articleMemberCountXML = (XmlElement) AddTextTag(nodeAliasMemberList, "ARTICLEMEMBERCOUNT", articleMemberCount.Value);
                    AddAttribute(articleMemberCountXML, "TYPE", articleMemberCount.Key);

                    rows += articleMemberCount.Value;
	            }
            }
            return nodeAliasMemberList;
        }

        private bool GetHierarchyNodeArticles(int nodeID, int type, int p, bool p_4)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        private bool GetHierarchyNodeArticlesWithMediaAssets(int nodeID, int type, int p, bool p_4)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        private bool GetHierarchyNodeArticlesWithLocal(int nodeID, int type, int p, bool p_4, int userTaxonomyNodeID)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        private bool GetHierarchyNodeArticlesWithLocalWithMediaAssets(int nodeID, int type, int p, bool p_4, int userTaxonomyNodeID)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        private bool GetHierarchyNodeArticlesWithKeyPhrases(int nodeID, int type, object p, bool needMediaAssetInfo)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        internal void SetSortOrderForNodeMembers(XmlElement hierarchyNode, string p)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        /// <summary>
        /// Initialise the Category with just the ID , if it is a Node ID of H2G2ID and the site
        /// </summary>
        /// <param name="ID">ID to use</param>
        /// <param name="isIDaNodeID">Whether the ID is a Node ID (or H2G2ID)</param>
        /// <param name="siteID">Site ID</param>
        public void Initialise(int ID, bool isIDaNodeID, int siteID)
        {
            Initialise(ID, isIDaNodeID, siteID, CategoryTypeFilter.None, 0, 0, 0);
        }
        /// <summary>
        /// Initialise the Category 
        /// </summary>
        /// <param name="ID">ID to use</param>
        /// <param name="isIDaNodeID">Whether the ID is a Node ID (or H2G2ID)</param>
        /// <param name="siteID">Site ID</param>
        /// <param name="type">Filter Type</param>
        /// <param name="articleType">Article Type</param>
        /// <param name="show"></param>
        /// <param name="skip"></param>
        public void Initialise(int ID, bool isIDaNodeID, int siteID, CategoryTypeFilter type, int articleType, int show, int skip)
        {
            string description = String.Empty;
	        string synonyms = String.Empty;
	        int userAdd = 0;
	        int parentID = 0;
	        int typeID = 0;

	        //if the nodeId is zero then we actually want the root for the given site
            if (isIDaNodeID && ID == 0)
	        {
		        //get the proper nodeID from the table;
                ID = GetRootNodeFromHierarchy(siteID);
                if (ID == 0)
		        {
			        throw new DnaException("Category - Initialise - No rootnode for the given siteID");
		        }
	        }

            int nodeID = 0;
            string nodeName = String.Empty;
            int H2G2ID = 0;
            int baseLine = 0;

            XmlElement hierarchyDetails = GetHierarchyNodeDetails(ID, isIDaNodeID, ref nodeName, ref description,
                                                                    ref parentID, ref H2G2ID, ref synonyms, ref userAdd, ref nodeID, ref typeID,
			                                                        0, ref baseLine);

            if (hierarchyDetails == null)
            {
                Initialise(0, true, siteID);
            }

	        //Add ancestry ( parents ) information for this Node
	        hierarchyDetails.AppendChild(GetCategoryAncestry(nodeID));

            XmlElement members = AddElementTag(hierarchyDetails, "MEMBERS");
            
            members.AppendChild(GetSubjectMembersForNodeID(nodeID));

	        // Get Articles / Threads Tagged to Node.
	        int rows = 0;
	        if ( (type == CategoryTypeFilter.None ) || (type == CategoryTypeFilter.TypedArticle && GuideEntry.IsTypeOfArticle(articleType)) )
	        {
		        //If Show param not provided, return default max articles.
		        if ( show == 0 )
		        {
			        show = MAX_ARTICLE_ROWS;
		        }
		        members.AppendChild(GetArticleMembersForNodeID(nodeID, articleType,  show,  skip, ref rows ));
	        }

	        //Get Clubs ( Campaigns )  tagged to this Node
	        //if ( (type == CategoryTypeFilter.None ) || (type == CategoryTypeFilter.TypedArticle && GuideEntry.IsTypeOfClub(articleType)) )
	        //{
		    //    members.AppendChild(GetClubMembersForNodeID(nodeID, show,  skip));
	        //}

	        //Include Notice Board Posts tagged to this node.
	        //if ( type == CategoryTypeFilter.None || type == CategoryTypeFilter.Thread )
	        //{
		    //    members.AppendChild(GetNoticesForNodeID(nodeID));
	        //}

	        //Include Notice Board Posts tagged to this node.
	        if ( type == CategoryTypeFilter.None || type == CategoryTypeFilter.User  )
	        {
		         members.AppendChild(GetUsersForNodeID(nodeID));
	        }

	        //Create the Skip and Show XML
	        if ( skip > 0 )
	        {
                AddIntElement(members, "COUNT", show);
                AddIntElement(members, "SKIP", skip);

                if ( rows > (show + skip) )
		        {
                    AddIntElement(members, "MORE", 1);
		        }
		        else
		        {
                    AddIntElement(members, "MORE", 0);
		        }
	        }

            members.AppendChild(GetNodeAliasMembersForNodeID(nodeID));

	        if (InputContext.GetSiteOptionValueBool("Category", "IncludeCloseMembers"))
	        {
                members.AppendChild(GetHierarchyCloseMembers(nodeID, MAX_CLOSE_ROWS - rows));
	        }

	        // Action network does not use the sort information, so don't do the sort.
	        // Another reason for not doing this action is that it goes through 1.4 million iterations for 1598 items
	        // and takes upto one minute to complete all for nothing!!!
	        if ( siteID != 16)
	        {
		        SetSortOrderForNodeMembers(members, "MEMBERS");
	        }
        }

        private int GetRootNodeFromHierarchy(int siteID)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        private XmlElement GetHierarchyCloseMembers(int nodeID, int maxRows)
        {
	        // Check the NodeID!
	        if (nodeID == 0)
	        {
                throw new DnaException("Category - NoNodeIDGiven - Illegal NodeID (0)");
	        }

            XmlElement nodeCloseMemberList = CreateElement("CLOSEMEMBERS");
            // Now get the alias member for the given node id
            using (IDnaDataReader reader = InputContext.CreateDnaDataReader("GetTaggedContentForNode"))
            {
                reader.AddParameter("maxRows", maxRows);
                reader.AddParameter("nodeID", nodeID);
                reader.AddParameter("siteid", InputContext.CurrentSite.SiteID);
                reader.Execute();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string source = reader.GetStringNullAsEmpty("source");
                        if (source == "club")
                        {
                            //if (!AddClubMemberXML(SP, true, bMovedToNextRec))
                            //{
                            //    return false;
                            //}
                        }
                        else	//article
                        {
                            //Dictionary<int, List<Phrase>> akp = new Dictionary<int, List<Phrase>>();
                            //bool addedMember = AddArticleMemberXML(nodeCloseMemberList, akp);
                        }
                    }
                }
            }
            return nodeCloseMemberList;
        }

        private XmlElement GetHierarchyNodeDetails(int ID, bool isIDaNodeID, ref string nodeName, ref string description, ref int parentID, ref int h2g2ID, ref string synonyms, ref int userAdd, ref int nodeID, ref int typeID, int siteID, ref int baseLine)
        {
            XmlElement hierarchyDetails = null;
            using (IDnaDataReader dataReader = InputContext.CreateDnaDataReader("gethierarchynodedetails2"))
            {
	            if (isIDaNodeID)
	            {
		            dataReader.AddParameter("nodeid", ID);
	            }
	            else
	            {
		            dataReader.AddParameter("h2g2id", ID);
	            }
                dataReader.Execute();

                // Check to see if we found anything
                if (dataReader.HasRows && dataReader.Read())
                {
                    nodeName = dataReader.GetStringNullAsEmpty("DisplayName");
                    description = dataReader.GetStringNullAsEmpty("Description");

                    parentID = dataReader.GetInt32NullAsZero("ParentID");
                    h2g2ID = dataReader.GetInt32NullAsZero("h2g2ID");
                    userAdd = dataReader.GetInt32NullAsZero("userAdd");
                    nodeID = dataReader.GetInt32NullAsZero("nodeID");
                    typeID = dataReader.GetInt32NullAsZero("type");
                    baseLine = dataReader.GetInt32NullAsZero("baseLine");

                    synonyms = dataReader.GetStringNullAsEmpty("synonyms");

                    hierarchyDetails = GetHierarchyDetails(dataReader);
                }
            }
            return hierarchyDetails;
        }

        /// <summary>
        /// Builds ARTICLEMEMBER xml based on current row in dataReader
        /// </summary>
        /// <param name="dataReader">The data reader with the data</param>
        /// <param name="articleKeyPhraseMap">The map of article key phrases</param>
        /// <returns>XML Element contain the articlemember data</returns>
        XmlElement AddArticleMemberXML(IDnaDataReader dataReader, Dictionary<int, List<Phrase>> articleKeyPhraseMap)
        {
	        ArticleMember articleMember = new ArticleMember(InputContext);

            int H2G2ID = dataReader.GetInt32NullAsZero("h2g2id");
            string name = dataReader.GetStringNullAsEmpty("subject");
            string extraInfo = dataReader.GetStringNullAsEmpty("extrainfo");

            articleMember.H2G2ID = H2G2ID;
	        articleMember.Name = name;
	        articleMember.IncludeStrippedName = true;

	        // Get and Set editor data
            articleMember.SetEditor(dataReader);

            articleMember.Status = dataReader.GetInt32NullAsZero("status");
            if (dataReader.DoesFieldExist("type"))
	        {
                articleMember.SetExtraInfo(extraInfo, dataReader.GetInt32NullAsZero("type"));
	        }
	        else
	        {
                articleMember.SetExtraInfo(extraInfo);
	        }

            articleMember.DateCreated = dataReader.GetDateTime("datecreated");
            articleMember.LastUpdated = dataReader.GetDateTime("lastupdated");
        		

	        if (InputContext.CurrentSite.IncludeCrumbtrail == 1)
	        {
                if (dataReader.DoesFieldExist("type") && dataReader.GetInt32NullAsZero("type") > 0)
                {
			        articleMember.Local = true;
		        }
	        }

            if (dataReader.DoesFieldExist("CRPollID"))
	        {
                articleMember.SetContentRatingStatistics(dataReader.GetInt32NullAsZero("CRPollID"),
                    dataReader.GetInt32NullAsZero("CRVoteCount"),
                    dataReader.GetDoubleNullAsZero("CRAverageRating"));
	        }

            if (dataReader.DoesFieldExist("MediaAssetID"))
	        {
                string caption = dataReader.GetStringNullAsEmpty("Caption");
                string extraElementXML = dataReader.GetStringNullAsEmpty("ExtraElementXML");
                string externalLinkURL = dataReader.GetStringNullAsEmpty("ExternalLinkURL");

                articleMember.SetMediaAssetInfo(dataReader.GetInt32NullAsZero("MediaAssetID"),
                                                dataReader.GetInt32NullAsZero("ContentType"),
										        caption,
                                                dataReader.GetInt32NullAsZero("MimeType"),
                                                dataReader.GetInt32NullAsZero("OwnerID"),
										        extraElementXML,
                                                dataReader.GetInt32NullAsZero("Hidden"),
										        externalLinkURL);
	        }
        	
	        bool includeKeyPhraseData = InputContext.GetSiteOptionValueBool("KeyPhrases", "ReturnInCategoryList");
	        if (includeKeyPhraseData)
	        {
                int entryId = dataReader.GetInt32NullAsZero("entryid");
		        articleMember.SetPhraseList(articleKeyPhraseMap[entryId]);
	        }
            articleMember.TryCreateXML();

            return articleMember.RootElement;
        }
    }
}
