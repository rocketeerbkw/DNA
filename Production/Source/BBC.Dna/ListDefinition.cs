using System;
using System.Collections;
using System.Collections.Specialized;
using System.Xml;
using System.Resources;
using System.Reflection;
using System.Diagnostics;
using System.Collections.Generic;
using BBC.Dna.Component;

namespace BBC.Dna.DynamicLists
{
	/// <summary>
	/// Represents a table and its alias
	/// </summary>
	public sealed class TableEntry : Object
	{
        /// <summary>
        /// 
        /// </summary>
		public TableEntry(string Name, string Alias)
		{
			_Name = Name;
			_Alias = Alias;
            _IsSubSelect = false;
		}

        /// <summary>
        /// 
        /// </summary>
        public bool IsSubSelect
        {
            get { return _IsSubSelect; }
            set { _IsSubSelect = value; }
        }

        /// <summary>
        /// Name of table .
        /// </summary>
        public string Name
        {
            get { return _Name; }
        }

        /// <summary>
        /// Alias of table .
        /// </summary>
        public string Alias
        {
            get { return _Alias; }
        }

        /// <summary>
        /// 
        /// </summary>
		public override string ToString()
		{
			return this.Name + ' ' + this.Alias;
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool Equals(object obj)
		{
			TableEntry teobj = (TableEntry)obj;
			if((this.Name.ToLower() == teobj.Name.ToLower()) && (this.Alias.ToLower() == teobj.Alias.ToLower()))
			{
				return true;
			}
			else
			{
				return false;
			}
		}

        /// <summary>
        /// 
        /// </summary>
		public override int GetHashCode()
		{
			return this.ToString().GetHashCode();
		}


		/// <summary>
		/// Creates a fully qualified field in the form
		/// of tablealias.fieldname 
		/// </summary>
		/// <param name="FieldName">Name of the field</param>
		/// <returns>Populated FieldEntry object</returns>
		public FieldEntry MakeField(string FieldName)
		{
			return new FieldEntry(this, FieldName);
		}

        /// <summary>
        /// 
        /// </summary>
		private string _Name;

        /// <summary>
        /// 
        /// </summary>
		private string _Alias;

        /// <summary>
        /// Indicates whether this rtable is actually a sub select rather than a concrete table
        /// </summary>
        private bool _IsSubSelect;
	}

	/// <summary>
	/// Represents a fully qualified field
	/// </summary>
	public sealed class FieldEntry
	{
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Table"></param>
        /// <param name="FieldName"></param>
		public FieldEntry(TableEntry Table, string FieldName)
		{
			this.Table = Table;
			this.FieldName = FieldName;

			op = null;
		}

        /// <summary>
        /// 
        /// </summary>
		public FieldEntry(TableEntry TableLHS, string FieldNameLHS, string condition, TableEntry TableRHS, string FieldNameRHS)
		{
			this.Table = TableLHS;
			this.FieldName = FieldNameLHS;

			op = condition;
			this.TableRHS = TableRHS;
			this.FieldNameRHS = FieldNameRHS;
		}

        /// <summary>
        /// 
        /// </summary>
		public override string ToString()
		{
			if(this.TableRHS == null && this.FieldNameRHS == null)
			{
				return Table.Alias + "." + FieldName;
			}
			else
			{
				// (CASE WHEN a > b THEN a ELSE b END)
				return "(CASE WHEN " + Table.Alias + "." + FieldName + " " + op + " " + 
					TableRHS.Alias + "." + FieldNameRHS + " THEN " +
					Table.Alias + "." + FieldName + " ELSE "+
					TableRHS.Alias + "." + FieldNameRHS + " END)";
			}
		}

		private TableEntry Table, TableRHS;
		private string FieldName, FieldNameRHS;
		private string op;
	}

	/// <summary>
	/// Single condition (e.g 1 > 2)
	/// </summary>
	public sealed class ConditionEntry : Object
	{
		/// <summary>
		/// Constructs a condition with two string expressions
		/// </summary>
		/// <param name="expressionL">Left hand side expression</param>
		/// <param name="op">Right hand side expression</param>
		/// <param name="expressionR">operator</param>
		public ConditionEntry(string expressionL, string op, string expressionR)
		{
			this.expressionL = expressionL;
			this.op = op;
			this.expressionR = expressionR;
		}

		/// <summary>
		/// Constructs a condition with a field and a string expression
		/// Using this overload allows clients to identify fields. This is
		/// how Select fields are identified by filters
		/// </summary>
		/// <param name="fieldL"></param>
		/// <param name="op"></param>
		/// <param name="expressionR"></param>
		public ConditionEntry(FieldEntry fieldL, string op, string expressionR)
		{
			this.fieldL = fieldL;
			this.expressionL = fieldL.ToString();
			this.op = op;
			this.expressionR = expressionR;
		}

		/// <summary>
		/// Constructs a condition with a field and a string expression
		/// Using this overload allows clients to identify fields from values. 
		/// This is how Select fields are identified by filters
		/// </summary>
		/// <param name="fieldL"></param>
		/// <param name="op"></param>
		/// <param name="fieldR"></param>
		public ConditionEntry(FieldEntry fieldL, string op, FieldEntry fieldR)
		{
			this.fieldL = fieldL;
			this.expressionL = fieldL.ToString();
			this.op = op;
			this.fieldR = fieldR;
			this.expressionR = fieldR.ToString();
		}


        /// <summary>
        /// 
        /// </summary>
		public override string ToString()
		{
			return expressionL + " " + op + " " + expressionR;
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool Equals(object obj)
		{
			ConditionEntry ce = (ConditionEntry)obj;
			
			// Operator not equal
			if(ce.op.ToLower().CompareTo(this.op.ToLower()) != 0) 
				return false;

			// Compare expressions
			if((expressionL.ToLower().CompareTo(ce.expressionL.ToLower()) == 0 || expressionL.ToLower().CompareTo(ce.expressionR.ToLower()) == 0)
				&& (expressionR.ToLower().CompareTo(ce.expressionL.ToLower()) == 0 || expressionR.ToLower().CompareTo(ce.expressionR.ToLower()) == 0))
			{
				return true;
			}

			return false;
		}

        /// <summary>
        /// 
        /// </summary>
		public override int GetHashCode()
		{
			return this.ToString().GetHashCode();
		}
        /// <summary>
        /// 
        /// </summary>
		public string expressionL, op, expressionR;

        /// <summary>
        /// 
        /// </summary>
		public FieldEntry fieldL, fieldR;
	}

	/// <summary>
	/// Holds information about an inner join (table + conditions) 
	/// </summary>
	public sealed class InnerJoinEntry : Object
	{
        /// <summary>
        /// 
        /// </summary>
		public InnerJoinEntry(TableEntry JoinTable)
		{
			this.JoinTable = JoinTable;
			Conditions = new ArrayList();
		}

        /// <summary>
        /// 
        /// </summary>
		public InnerJoinEntry(TableEntry JoinTable, ConditionEntry Condition)
		{
			this.JoinTable = JoinTable;
			Conditions = new ArrayList();
			Conditions.Add(Condition);
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool Equals(object obj)
		{
			InnerJoinEntry ije = (InnerJoinEntry)obj;

			// Check tables for equality
			if(JoinTable.Equals(ije.JoinTable))
			{
				// Check conditions for equality
				if(Conditions.Count != ije.Conditions.Count) 
					return false;

				// Look for any conditions that are not equal
				foreach(ConditionEntry ce in ije.Conditions)
				{
					// On first one not found, it means we are not equal
					if(!Conditions.Contains(ce))
						return false;
				}

				return true;
			}
			else
			{
				return false;
			}
		}

        /// <summary>
        /// 
        /// </summary>
		public override int GetHashCode()
		{
			return this.ToString().GetHashCode();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string ToString()
		{
			return JoinTable.ToString();
		}


		/// <summary>
		/// Table+Alias of table to join to
		/// </summary>
		public TableEntry JoinTable;

		/// <summary>
		/// inner join conditions. 
		/// Populated by derived classes with ConditionEntry objects
		/// </summary>
		public ArrayList Conditions;
	}

	/// <summary>
	/// Base class for list filters
	/// </summary>
	public abstract class ListFilterBase : Object
	{
		/// <summary>
		/// Represents a single filter for the list
		/// </summary>
		/// <param name="ListType">Valid list type ("ARTICLES", "FORUMS", etc...)</param>
		public ListFilterBase(ListTypeBase ListType)
		{
			this.ListType = ListType;

			InnerJoins = new ArrayList();
			WhereConditions = new ArrayList();
		}

		/// <summary>
		/// Constructs where clause in the form
		/// "((x == y) AND (d == x))"
		/// </summary>
		/// <returns>SQL snippet for where clause</returns>
		public string GetWhereClause()
		{
            string WhereClause = "";
			for(int i = 0; i < WhereConditions.Count; i++)
			{
				WhereClause += "(" + WhereConditions[i].ToString() + ")";
				
				if(i+1 != WhereConditions.Count)
				{
					WhereClause += " AND ";
				}
			}
			return WhereClause;
		}

		/// <summary>
		/// Tells whether this filter is supported for the ListType
		/// </summary>
		/// <returns>true if supported, false otherwise</returns>
		public abstract bool IsSupported();

        /// <summary>
        /// List type class
        /// </summary>
		public ListTypeBase ListType;

		/// <summary>
		/// Collection of inner joins. Populated by derived classes.
		/// </summary>
		public ArrayList InnerJoins;

		/// <summary>
		/// Collection of WHERE clause conditions. They will
		/// be separated by AND. Populated by derived classes
		/// </summary>
		public ArrayList WhereConditions;
	}

	/// <summary>
	/// In most cases moderated items can be removed when we inner join in
	/// the ListType class. For all other cases, this filter is needed
	/// If we wanted moderation items to be optional, then all moderation conditions
	/// will have to be taken out of ListType class and put into here
	/// </summary>
	public sealed class ListFilterModeration : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
		public override bool IsSupported()
		{
			string ListTypeName = this.ListType.GetListTypeName().ToUpper();

			return(ListTypeName == "ARTICLES"
				|| ListTypeName == "CAMPAIGNDIARYENTRIES");
		}

        /// <summary>
        /// 
        /// </summary>
		public ListFilterModeration(ListTypeBase ListType): base(ListType)
		{
			if(!IsSupported()) return;

			string ListTypeName = this.ListType.GetListTypeName().ToUpper();
			if(ListTypeName == "ARTICLES")
			{
				this.WhereConditions.Add(new ConditionEntry(ListType.GetSelectTable().MakeField("hidden"), "is", "null"));
			}
			else if(ListTypeName == "CAMPAIGNDIARYENTRIES"
				|| ListTypeName == "THREADS")
			{
				this.WhereConditions.Add(new ConditionEntry(ListType.GetSelectTable().MakeField("VisibleTo"), "is", "null"));
				this.WhereConditions.Add(new ConditionEntry(ListType.GetSelectTable().MakeField("CanRead"), "=", "1"));
			}
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterSiteID : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return this.ListType.GetSiteIDField() != null;
		}

        /// <summary>
        /// 
        /// </summary>
		public ListFilterSiteID(ListTypeBase ListType) : base(ListType)
		{
			string FieldName = this.ListType.GetSiteIDField();
			
			if(FieldName == null) 
			{
				return;
			}

			WhereConditions.Add(new ConditionEntry(FieldName, "=", "@SiteID"));
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterVoteCount: ListFilterBase
    {   
        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return this.ListType.GetListTypeName().ToUpper() == "ARTICLES";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListFilterVoteCount(ListTypeBase ListType, int VoteCount) : base(ListType)
		{
			if(!IsSupported()) 
			{
				return;
			}
            
			TableEntry SelectTable = ListType.GetSelectTable();

			// Construct inner join
			// INNER JOIN PageVotes v ON v.ItemType = 1 AND v.ItemID = g.h2g2id
			TableEntry PageVotesTable = new TableEntry("PageVotes", "v");
			InnerJoinEntry ije = new InnerJoinEntry(PageVotesTable);
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemType"), "=", "1"));
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemID"), "=", SelectTable.MakeField("h2g2id")));
			InnerJoins.Add(ije);

			WhereConditions.Add(new ConditionEntry(PageVotesTable.MakeField("VoteCount"), ">", System.Convert.ToString(VoteCount)));

			// Select fields
			ListType.AddField(PageVotesTable, "VoteCount", "item/poll-list/poll/statistics/@votecount");
		}
	}

    /// <summary>
    /// 
    /// </summary>
    public sealed class ListFilterBookmarkCount : ListFilterBase
    {
        /// <summary>
        /// 
        /// </summary>
        public override bool IsSupported()
        {
            return this.ListType.GetListTypeName().ToUpper() == "ARTICLES";
        }

        /// <summary>
        /// 
        /// </summary>
        public ListFilterBookmarkCount(ListTypeBase ListType, int BookmarkCount)
            : base(ListType)
        {
            if (!IsSupported())
            {
                return;
            }

            TableEntry SelectTable = ListType.GetSelectTable();

            // Construct inner join
            // This table is actually a sub select not a concrete DB table.
            String subSelect = "( Select DestinationId, Count(destinationid) 'bookmarkcount' FROM Links GROUP BY DestinationId )";
            TableEntry LinksTable = new TableEntry(subSelect, "l");
            LinksTable.IsSubSelect = true;
            InnerJoinEntry ije = new InnerJoinEntry(LinksTable);
            ije.Conditions.Add(new ConditionEntry(LinksTable.MakeField("DestinationId"), "=", SelectTable.MakeField("h2g2id")));
            InnerJoins.Add(ije);

            WhereConditions.Add(new ConditionEntry(LinksTable.MakeField("bookmarkcount"), ">", System.Convert.ToString(BookmarkCount)));

            // Select fields
            ListType.AddField(LinksTable, "bookmarkcount", "item/bookmarkcount");
        }
    }

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterRating : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public ListFilterRating(ListTypeBase ListType, double AverageRating) : base(ListType)
		{
			if(!IsSupported()) return;

			// Get select table from list type class
			TableEntry SelectTable = ListType.GetSelectTable();

			// Construct inner join
			// INNER JOIN PageVotes v ON v.ItemType = 1 AND v.ItemID = g.h2g2id
			TableEntry PageVotesTable = new TableEntry("PageVotes", "v");
			InnerJoinEntry ije = new InnerJoinEntry(PageVotesTable);
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemType"), "=", "1"));
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemID"), "=", SelectTable.MakeField("h2g2id")));
			InnerJoins.Add(ije);

			// Construct condition WHERE Guide for ARTICLES type of list
			WhereConditions.Add(new ConditionEntry(PageVotesTable.MakeField("averagerating"), ">", System.Convert.ToString(AverageRating)));

			// Select fields
			ListType.AddField(PageVotesTable, "averagerating", "item/poll-list/poll/statistics/@averagerating");
		}
		
		/// <summary>
		/// Only supported for ARTICLES
		/// </summary>
		/// <returns>true if supported. false otherwise</returns>
		public override bool IsSupported()
		{
			return this.ListType.GetListTypeName().ToUpper() == "ARTICLES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterCategories : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public ListFilterCategories(ListTypeBase ListType, int [] Categories) : base(ListType)
		{
			// Get select table from list type class
			TableEntry SelectTable = ListType.GetSelectTable();
			
			// Convert catids into comma delimeted string
			string CategoriesSQL = "(";
			for(int i=0;i<Categories.Length;i++)
			{
				CategoriesSQL += Categories[i];
				if(i+1 != Categories.Length)
				{
					CategoriesSQL += ",";
				}
			}
			CategoriesSQL += ")";

			if(ListType.GetListTypeName().ToUpper() == "ARTICLES")
			{
				// INNER JOIN HierarchyXXXMembers ham on ham.h2g2id = g.h2g2id
				TableEntry HierarchyMembersTable = new TableEntry("HierarchyArticleMembers", "ham");
				InnerJoinEntry ije = new InnerJoinEntry(HierarchyMembersTable);
				ije.Conditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("entryid"), "=", SelectTable.MakeField("entryid")));
				InnerJoins.Add(ije);

				// WHERE ham.nodeid in (category ids)
				WhereConditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("nodeid"), "in", CategoriesSQL));

				// Select Field
				ListType.AddField(HierarchyMembersTable, "nodeid", "item/category/@nodeid");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CLUBS")
			{
				// INNER JOIN HierarchyXXXMembers ham on ham.h2g2id = g.h2g2id
				TableEntry HierarchyMembersTable = new TableEntry("HierarchyClubMembers", "hcm");
				InnerJoinEntry ije = new InnerJoinEntry(HierarchyMembersTable);
				ije.Conditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("clubid"), "=", SelectTable.MakeField("clubid")));
				InnerJoins.Add(ije);

				// WHERE ham.nodeid in (category ids)
				WhereConditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("nodeid"), "in", CategoriesSQL));

				// SiteID condition
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("siteid"), "=", "@SiteID"));

				// Status condition (club.status==open)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("status"), "=", "1"));

				// Canview (club.canview=1)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canview"), "=", "1"));

				ListType.AddField(HierarchyMembersTable, "nodeid", "item/category/@nodeid");
			}
			else if(ListType.GetListTypeName().ToUpper() == "TOPICFORUMS")
			{
				// inner join guideentries g on g.h2g2id=t.h2g2id
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");
				InnerJoinEntry ije1 = new InnerJoinEntry(GuideEntriesTable);
				ije1.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", SelectTable.MakeField("h2g2id")));
				InnerJoins.Add(ije1);

				// INNER JOIN HierarchyXXXMembers ham on ham.h2g2id = g.h2g2id
				TableEntry HierarchyMembersTable = new TableEntry("HierarchyArticleMembers", "ham");
				InnerJoinEntry ije = new InnerJoinEntry(HierarchyMembersTable);
				ije.Conditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("entryid"), "=", GuideEntriesTable.MakeField("entryid")));
				InnerJoins.Add(ije);

				// INNER JOIN on forums to get forum.canread
				TableEntry ForumsTable	= new TableEntry("Forums", "f");
				InnerJoins.Add(new InnerJoinEntry(ForumsTable, 
					new ConditionEntry(ForumsTable.MakeField("forumid"), "=", GuideEntriesTable.MakeField("forumid"))));
				
				// forum.canread=1
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("canread"), "=", "1"));
				
				// topicstatus = 0 (TS_LIVE)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("topicstatus"), "=", "0"));	

				// WHERE ham.nodeid in (category ids)
				WhereConditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("nodeid"), "in", CategoriesSQL));

				// SiteID condition
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("siteid"), "=", "@SiteID"));

				ListType.AddField(HierarchyMembersTable, "nodeid", "item/category/@nodeid");

			}
			else if(ListType.GetListTypeName().ToUpper() == "USERS")
			{
				// INNER JOIN HierarchyXXXMembers ham on ham.h2g2id = g.h2g2id
				TableEntry HierarchyMembersTable = new TableEntry("HierarchyUserMembers", "hum");
				InnerJoinEntry ije = new InnerJoinEntry(HierarchyMembersTable);
				ije.Conditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("userid"), "=", SelectTable.MakeField("userid")));
				InnerJoins.Add(ije);

				// INNER JOIN Hierarhcy h on h.nodeid = hum.nodeid
				TableEntry HierarchyTable = new TableEntry("Hierarchy", "h");
				InnerJoinEntry ije2 = new InnerJoinEntry(HierarchyTable);
				ije2.Conditions.Add(new ConditionEntry(HierarchyTable.MakeField("nodeid"), "=", HierarchyMembersTable.MakeField("nodeid")));
				InnerJoins.Add(ije2);

				// WHERE ham.nodeid in (category ids)
				WhereConditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("nodeid"), "in", CategoriesSQL));

				// SiteID condition
				//WhereConditions.Add(new ConditionEntry(HierarchyTable.MakeField("siteid"), "=", "@SiteID"));

				// Active
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("active"), "=", "1"));

				// Status
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("status"), "=", "1"));

				ListType.AddField(HierarchyMembersTable, "nodeid", "item/category/@nodeid");
			}
			else if(ListType.GetListTypeName().ToUpper() == "THREADS")
			{
				// Join on forums
				TableEntry ForumsTable = new TableEntry("Forums", "lfcForums");
				InnerJoins.Add(new InnerJoinEntry(ForumsTable, 
					new ConditionEntry(SelectTable.MakeField("ForumID").ToString(), "=", ForumsTable.MakeField("ForumID").ToString())));

				// Join on guideentries
				//TableEntry GuideEntriesTable =  new TableEntry("GuideEntries", "lfcGuideEntries");
				//InnerJoins.Add(new InnerJoinEntry(GuideEntriesTable,
				//	new ConditionEntry(GuideEntriesTable.MakeField("forumid").ToString(), "=", ForumsTable.MakeField("ForumID").ToString())));

				// Join on hierarchymembers
				TableEntry HierarchyMembersTable = new TableEntry("HierarchyThreadMembers", "htm");
				InnerJoinEntry ije = new InnerJoinEntry(HierarchyMembersTable);
				ije.Conditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("threadid"), "=", SelectTable.MakeField("threadid")));
				InnerJoins.Add(ije);

				// WHERE ham.nodeid in (category ids)
				WhereConditions.Add(new ConditionEntry(HierarchyMembersTable.MakeField("nodeid"), "in", CategoriesSQL));
							
				// SiteID
				//WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("siteid"), "=", "@SiteID"));

				// threads can read
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canread"), "=", "1"));

				// forum can read
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("canread"), "=", "1"));

				ListType.AddField(HierarchyMembersTable, "nodeid", "item/category/@nodeid");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CATEGORIES")
			{
				// Where parent = (n,n.n)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("parentid"), "in", CategoriesSQL));
				
				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("siteid"), "=", "@SiteID"));

				ListType.AddField("parentid", "item/category/@nodeid");
			}
			else
			{
				// not supported
				return;
			}
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			string ListType = this.ListType.GetListTypeName().ToUpper();

			return ListType == "ARTICLES"
				|| ListType == "TOPICFORUMS"
				|| ListType == "CLUBS"
				|| ListType == "USERS"
				|| ListType == "THREADS"
				|| ListType == "CATEGORIES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
    public sealed class ListFilterKeyPhrases : ListFilterBase
    {
        /// <summary>
        /// 
        /// </summary>
        public ListFilterKeyPhrases(ListTypeBase ListType, List<Phrase> keyphrases )
            : base(ListType)
        {
            if (keyphrases.Count == 0)
            {
                //No Keyphrases - nothing to do.
                return;
            }

            // Get select table from list type class
            TableEntry SelectTable = ListType.GetSelectTable();

            if (ListType.GetListTypeName().ToUpper() == "ARTICLES" )
            {
                //Create an Inner Join for each key phrase in the filter - the filter specifies and AND search
                TableEntry ArticleKeyPhrasesTable = new TableEntry("ArticleKeyPhrases", "akp");
          
                for ( int i = 0; i < keyphrases.Count; ++i )
                {
                    if (i == 0)
                    {
                        //Article Key Phrases
                        InnerJoinEntry ije = new InnerJoinEntry(ArticleKeyPhrasesTable);
                        ije.Conditions.Add(new ConditionEntry(ArticleKeyPhrasesTable.MakeField("entryID"), "=", SelectTable.MakeField("entryID")));
                        
                        //Additional Filter on SiteId to assist query performance
                        ije.Conditions.Add(new ConditionEntry(ArticleKeyPhrasesTable.MakeField("siteID"),"=", "@siteID"));
                        InnerJoins.Add(ije);
                    }
                    else
                    {
                        //Join on Article Key Phrases for each phrase.
                        TableEntry ArticleKeyPhrasesTable1 = new TableEntry("ArticleKeyPhrases", ArticleKeyPhrasesTable.Name + i);
                        InnerJoins.Add(new InnerJoinEntry(ArticleKeyPhrasesTable1,
                            new ConditionEntry(ArticleKeyPhrasesTable1.MakeField("entryID"), "=", ArticleKeyPhrasesTable.MakeField("entryID"))));
                        ArticleKeyPhrasesTable = ArticleKeyPhrasesTable1;
                    }

                    // Filter article including on each of the given key phrases
                    TableEntry phraseNameSpacesTable = new TableEntry("PhraseNameSpaces", "PhraseNameSpaces" + i);
                    TableEntry KeyPhrasesTable = new TableEntry("KeyPhrases", "KeyPhrases" + i);
                    

                    //Inner join on phrasenamespaces.
                    InnerJoinEntry pn = new InnerJoinEntry(phraseNameSpacesTable);
                    pn.Conditions.Add(new ConditionEntry(phraseNameSpacesTable.MakeField("phrasenamespaceid"), "=", ArticleKeyPhrasesTable.MakeField("phrasenamespaceID")));
                    InnerJoins.Add(pn);

                    Phrase phraseFilter = keyphrases[i];

                    //Inner join on key phrases
                    InnerJoinEntry kp = new InnerJoinEntry(KeyPhrasesTable);
                    kp.Conditions.Add(new ConditionEntry(KeyPhrasesTable.MakeField("phraseID"), "=", phraseNameSpacesTable.MakeField("phraseID")));
                    kp.Conditions.Add(new ConditionEntry(KeyPhrasesTable.MakeField("phrase"), "=", "'" + phraseFilter.PhraseName + "'"));
                    InnerJoins.Add(kp);

                    //Inner Join on NameSpaces if a namespace has been specified.
                    if (phraseFilter.NameSpace != string.Empty)
                    {
                        TableEntry nameSpacesTable = new TableEntry("NameSpaces", "NameSpaces" + i);
                        InnerJoinEntry n = new InnerJoinEntry(nameSpacesTable);
                        n.Conditions.Add(new ConditionEntry(nameSpacesTable.MakeField("namespaceid"), "=", phraseNameSpacesTable.MakeField("namespaceID")));
                        n.Conditions.Add(new ConditionEntry(nameSpacesTable.MakeField("name"), "=", "'" + phraseFilter.NameSpace + "'"));
                        InnerJoins.Add(n);
                    }
                }                
            }
            else if (ListType.GetListTypeName().ToUpper() == "THREADS")
            {

                //Create an Inner Join for each key phrase in the filter - the filter specifies and AND search
                TableEntry ThreadKeyPhrasesTable = new TableEntry("ThreadKeyPhrases", "tkp");
                for (int i = 0; i < keyphrases.Count; i++)
                {
                    //Do and Inner Join to get all the phrases for the given threadId
                     if (i == 0)
                     {
                         InnerJoinEntry ije = new InnerJoinEntry(ThreadKeyPhrasesTable);
                         ije.Conditions.Add( new ConditionEntry(ThreadKeyPhrasesTable.MakeField("ThreadID"), "=", SelectTable.MakeField("ThreadID")));
                         InnerJoins.Add(ije);
                     }
                     else
                     {
                         TableEntry ThreadKeyPhrasesTable1 = new TableEntry("ThreadKeyPhrases", ThreadKeyPhrasesTable.Name + i);
                         InnerJoins.Add(new InnerJoinEntry(ThreadKeyPhrasesTable1,
                             new ConditionEntry(ThreadKeyPhrasesTable1.MakeField("ThreadID"), "=", ThreadKeyPhrasesTable.MakeField("ThreadID"))));
                         ThreadKeyPhrasesTable = ThreadKeyPhrasesTable1;
                     }

                    // Filter thread including on each of the given key phrases
                    TableEntry KeyPhrasesTable = new TableEntry("KeyPhrases", "KeyPhrases" + i);
                    InnerJoinEntry ije2 = new InnerJoinEntry(KeyPhrasesTable);
                    ije2.Conditions.Add(new ConditionEntry(KeyPhrasesTable.MakeField("phraseID"), "=", ThreadKeyPhrasesTable.MakeField("phraseID")));
                    ije2.Conditions.Add(new ConditionEntry(KeyPhrasesTable.MakeField("phrase"), "=", "'" + keyphrases[i].PhraseName + "'" ));
                    InnerJoins.Add(ije2);
                }
            }
            else
            {
                // not supported
                return;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public override bool IsSupported()
        {
            string ListType = this.ListType.GetListTypeName().ToUpper();

            return ListType == "ARTICLES" || ListType == "THREADS";
        }
    }

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterSignificance : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ListType"></param>
        /// <param name="Score"></param>
		public ListFilterSignificance(ListTypeBase ListType, int Score) : base(ListType)
		{
			// Get select table from list type class
			TableEntry SelectTable = ListType.GetSelectTable();

			if(!IsSupported()) return;
			
			TableEntry ContentSignifTable;
			string IDField;

			// Choose ContentSignif table and id field
			if(this.ListType.GetListTypeName().ToUpper() == "ARTICLES")
			{
				ContentSignifTable = new TableEntry("ContentSignifArticle", "csa");
				IDField = "h2g2id";
			}
			else if (this.ListType.GetListTypeName().ToUpper() == "CLUBS")
			{
				ContentSignifTable = new TableEntry("ContentSignifClub", "csc");
				IDField = "Clubid";

				// Status condition (club.status==open)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("status"), "=", "1"));

				// Canview (club.canview=1)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canview"), "=", "1"));
			}
			else if (this.ListType.GetListTypeName().ToUpper() == "USERS")
			{
				ContentSignifTable = new TableEntry("ContentSignifUser", "csu");
				IDField = "Userid";

				// Active
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("active"), "=", "1"));

				// Status
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("status"), "=", "1"));
			}
			else if (this.ListType.GetListTypeName().ToUpper() == "THREADS")
			{
				ContentSignifTable = new TableEntry("ContentSignifThread", "csc");
				IDField = "ThreadID";
			}
			else if (this.ListType.GetListTypeName().ToUpper() =="CATEGORIES")
			{
				ContentSignifTable = new TableEntry("ContentSignifNode", "csn");
				IDField = "NodeID";
			}
			else if(this.ListType.GetListTypeName().ToUpper() == "CAMPAIGNDIARYENTRIES")
			{
				ContentSignifTable = new TableEntry("ContentSignifThread", "cst");
				IDField = "ThreadID";
			}
			else if (this.ListType.GetListTypeName().ToUpper() =="FORUMS")
			{
				ContentSignifTable = new TableEntry("ContentSignifForum", "csf");
				IDField = "ForumID";

				// CanRead
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canread"), "=", "1"));
			}
			else if (this.ListType.GetListTypeName().ToUpper() == "TOPICFORUMS")
			{
				// inner join guideentries g on g.h2g2id=t.h2g2id
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");
				InnerJoinEntry ije1 = new InnerJoinEntry(GuideEntriesTable);
				ije1.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", SelectTable.MakeField("h2g2id")));
				InnerJoins.Add(ije1);

				// inner join forums f on f.forumid=g.forumid
				TableEntry ForumsTable = new TableEntry("Forums", "f");
				InnerJoinEntry ije2 = new InnerJoinEntry(ForumsTable);
				ije2.Conditions.Add(new ConditionEntry(ForumsTable.MakeField("forumid"), "=", GuideEntriesTable.MakeField("forumid")));
				InnerJoins.Add(ije2);

				// forum.canread=1
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("canread"), "=", "1"));
				
				// topicstatus = 0 (TS_LIVE)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("topicstatus"), "=", "0"));
				
				ContentSignifTable = new TableEntry("ContentSignifForum", "csf");
				IDField = "ForumID";

				// INNER JOIN ContentSignifXXXXX csx on csx.[id] = selecttable.[id]
				InnerJoinEntry ije = new InnerJoinEntry(ContentSignifTable);
				ije.Conditions.Add(new ConditionEntry(ContentSignifTable.MakeField(IDField), "=", ForumsTable.MakeField(IDField)));
				InnerJoins.Add(ije);
			}
			else
			{
				// not supported
				return;
			}

			if (this.ListType.GetListTypeName().ToUpper() != "TOPICFORUMS") // TOPICFORUMS do things differently
			{
				// INNER JOIN ContentSignifXXXXX csx on csx.[id] = selecttable.[id]
				InnerJoinEntry ije = new InnerJoinEntry(ContentSignifTable);
				ije.Conditions.Add(new ConditionEntry(ContentSignifTable.MakeField(IDField), "=", SelectTable.MakeField(IDField)));
				InnerJoins.Add(ije);
			}

			// WHERE csx.Score = Score
			WhereConditions.Add(new ConditionEntry(ContentSignifTable.MakeField("Score"), ">", System.Convert.ToString(Score)));

			// @SiteID condition
			//WhereConditions.Add(new ConditionEntry(ContentSignifTable.MakeField("SiteID"), "=", "@SiteID"));

			// Select fields
			ListType.AddField(ContentSignifTable, "Score", "item/score");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			string ListType = this.ListType.GetListTypeName().ToUpper();

			return ListType == "ARTICLES"
				|| ListType == "TOPICFORUMS"
				|| ListType == "CLUBS"
				|| ListType == "USERS"
				|| ListType == "THREADS"
				|| ListType == "FORUMS"
				|| ListType == "CATEGORIES"
				|| ListType == "CAMPAIGNDIARYENTRIES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterDateUpdated : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ListType"></param>
        /// <param name="DaysAgo"></param>
		public ListFilterDateUpdated(ListTypeBase ListType, int DaysAgo) : base(ListType)
		{
			TableEntry SelectTable = ListType.GetSelectTable();

			// Convert date into SQL
			string DateVal = "DATEADD(day, -" + System.Convert.ToString(DaysAgo) + ", getdate())";

			if(ListType.GetListTypeName().ToUpper() == "ARTICLES" )
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("LastUpdated"), ">", DateVal ) );

				// Select fields
				ListType.AddField("LastUpdated", "item/date-updated");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CLUBS")
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("LastUpdated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("SiteID"), "=", "@SiteID" ) );
				
				// Status condition (club.status==open)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("status"), "=", "1"));

				// Canview (club.canview=1)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canview"), "=", "1"));

				ListType.AddField("LastUpdated", "item/date-updated");

			}
			else if(ListType.GetListTypeName().ToUpper() == "FORUMS")
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("LastUpdated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("SiteID"), "=", "@SiteID" ) );
				
				// CanRead
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canread"), "=", "1" ) );

				ListType.AddField("LastUpdated", "item/date-updated");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CATEGORIES")
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("LastUpdated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("SiteID"), "=", "@SiteID" ) );

				ListType.AddField("LastUpdated", "item/date-updated");
			}
			else  if(ListType.GetListTypeName().ToUpper() == "THREADS")
			{
				// inner join forums (for site id)
				TableEntry ForumsTable = new TableEntry("Forums", "f");
				InnerJoins.Add(new InnerJoinEntry(ForumsTable, 
					new ConditionEntry(ForumsTable.MakeField("forumid"), "=", SelectTable.MakeField("forumid"))));

				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("LastUpdated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("SiteID"), "=", "@SiteID" ) );

				ListType.AddField("LastUpdated", "item/date-updated");
			}
			else if(ListType.GetListTypeName().ToUpper() == "TOPICFORUMS")
			{
				// inner join guideentries g on g.h2g2id=t.h2g2id
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");
				InnerJoinEntry ije1 = new InnerJoinEntry(GuideEntriesTable);
				ije1.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", SelectTable.MakeField("h2g2id")));
				InnerJoins.Add(ije1);

				// inner join forums f on f.forumid=g.forumid
				TableEntry ForumsTable = new TableEntry("Forums", "f");
				InnerJoinEntry ije2 = new InnerJoinEntry(ForumsTable);
				ije2.Conditions.Add(new ConditionEntry(ForumsTable.MakeField("forumid"), "=", GuideEntriesTable.MakeField("forumid")));
				InnerJoins.Add(ije2);

				// forum.canread=1
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("canread"), "=", "1"));
				
				// topicstatus = 0 (TS_LIVE)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("topicstatus"), "=", "0"));	


				// WHERE forums.datecreates > date
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("LastUpdated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("SiteID"), "=", "@SiteID" ) );

				ListType.AddField(ForumsTable, "LastUpdated", "item/date-updated");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CAMPAIGNDIARYENTRIES")
			{
				WhereConditions.Add(
					new ConditionEntry(SelectTable.MakeField("LastPosted"), ">", DateVal));

				ListType.AddField(SelectTable, "LastPosted", "item/date-updated");
			}
			else
			{
				return;
			}
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			string ListType = this.ListType.GetListTypeName().ToUpper();

			return ListType == "ARTICLES"
				|| ListType == "TOPICFORUMS"
				|| ListType == "CLUBS"
				|| ListType == "THREADS"
				|| ListType == "FORUMS"
				|| ListType == "CATEGORIES"
				|| ListType == "CAMPAIGNDIARYENTRIES";
		}
	}

	/// <summary>
	/// Filter for "Date Created is more recent than..."
	/// </summary>
	public sealed class ListFilterDateCreated : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public ListFilterDateCreated(ListTypeBase ListType, int DaysAgo) : base(ListType)
		{
			// Get select table from list type class
			TableEntry SelectTable = ListType.GetSelectTable();
			
			// Convert date into SQL
			string DateVal;
			DateVal = "DATEADD(day, -" + System.Convert.ToString(DaysAgo) + ", getdate())";

			if(this.ListType.GetListTypeName().ToUpper() == "ARTICLES")
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("DateCreated"), ">", DateVal) );

				// Add fields
				ListType.AddField("DateCreated", "item/date-created");
			}
			else if (ListType.GetListTypeName().ToUpper() == "CLUBS")
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("DateCreated"), ">", DateVal ) );
				
				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("SiteID"), "=", "@SiteID" ) );
				
				// Status condition (club.status==open)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("status"), "=", "1"));

				// Canview (club.canview=1)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canview"), "=", "1"));

				ListType.AddField("DateCreated", "item/date-created");
			}
			else if (ListType.GetListTypeName().ToUpper() == "FORUMS")
			{
				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("DateCreated"), ">", DateVal ) );
				
				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("SiteID"), "=", "@SiteID" ) );

				// CanRead
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("canread"), "=", "1" ) );

				ListType.AddField("DateCreated", "item/date-created");
			}
			else if(ListType.GetListTypeName().ToUpper() == "THREADS")
			{
				// inner join forums (for site id)
				TableEntry ForumsTable = new TableEntry("Forums", "f");
				InnerJoins.Add(new InnerJoinEntry(ForumsTable, 
					new ConditionEntry(ForumsTable.MakeField("forumid"), "=", SelectTable.MakeField("forumid"))));

				// Where DateCreated > date
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("DateCreated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("SiteID"), "=", "@SiteID" ) );

				ListType.AddField("DateCreated", "item/date-created");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CATEGORIES")
			{
				// INNER JOIN GuideEntries g ON g.h2g2id = h.h2g2id
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");
				
				InnerJoinEntry ije = new InnerJoinEntry(GuideEntriesTable, 
					new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", SelectTable.MakeField("h2g2id")));

				InnerJoins.Add(ije);

				// Where g.DateCreated > date
				WhereConditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("DateCreated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("SiteID"), "=", "@SiteID" ) );

				ListType.AddField(GuideEntriesTable, "DateCreated", "item/date-created");
			}
			else if(ListType.GetListTypeName().ToUpper() == "TOPICFORUMS")
			{
				// inner join guideentries g on g.h2g2id=t.h2g2id
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");
				InnerJoinEntry ije1 = new InnerJoinEntry(GuideEntriesTable);
				ije1.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", SelectTable.MakeField("h2g2id")));
				InnerJoins.Add(ije1);

				// inner join forums f on f.forumid=g.forumid
				TableEntry ForumsTable = new TableEntry("Forums", "f");
				InnerJoinEntry ije2 = new InnerJoinEntry(ForumsTable);
				ije2.Conditions.Add(new ConditionEntry(ForumsTable.MakeField("forumid"), "=", GuideEntriesTable.MakeField("forumid")));
				InnerJoins.Add(ije2);

				// forum.canread=1
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("canread"), "=", "1"));
				
				// topicstatus = 0 (TS_LIVE)
				WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("topicstatus"), "=", "0"));


				// WHERE forums.datecreated > date
				WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("DateCreated"), ">", DateVal ) );

				// SiteID
				//WhereConditions.Add(new ConditionEntry(ForumsTable.MakeField("SiteID"), "=", "@SiteID" ) );

				ListType.AddField(ForumsTable, "DateCreated", "item/date-created");
			}
			else if(ListType.GetListTypeName().ToUpper() == "CAMPAIGNDIARYENTRIES")
			{
				WhereConditions.Add
					(new ConditionEntry(SelectTable.MakeField("DateCreated"), ">", DateVal));

				ListType.AddField(SelectTable, "DateCreated", "item/date-created");
			}
			else
			{
				return;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <returns></returns>
		public override bool IsSupported()
		{
			string ListType = this.ListType.GetListTypeName().ToUpper();

            return ListType == "ARTICLES"
                || ListType == "CLUBS"
                || ListType == "FORUMS"
                || ListType == "THREADS"
                || ListType == "CATEGORIES"
                || ListType == "TOPICFORUMS"
                || ListType == "CAMPAIGNDIARYENTRIES";
		}
	}


    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterArticleType : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public ListFilterArticleType(ListTypeBase ListType, int Type) : base(ListType)
		{
			if(!IsSupported()) return;

			// Get select table from list type class
			TableEntry SelectTable = ListType.GetSelectTable();

			WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("Type"), "=", System.Convert.ToString(Type)));

			// SiteID condition
			//WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("siteid"), "=", "@SiteID"));

			// Select field
			ListType.AddField("type", "item/article-item/@articletype");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName().ToUpper() == "ARTICLES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterArticleStatus : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public ListFilterArticleStatus(ListTypeBase ListType, int Status) : base(ListType)
		{
			if(!IsSupported()) return;

			// Get select table from list type class
			TableEntry SelectTable = ListType.GetSelectTable();

			// Status
			WhereConditions.Add(new ConditionEntry(SelectTable.MakeField("Status"), "=", System.Convert.ToString(Status)));

			// Add select field
			ListType.AddField("status", "item/article-item/@articlestatus");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName().ToUpper() == "ARTICLES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
    public sealed class ListFilterArticleDate : ListFilterBase
    {
        /// <summary>
        /// 
        /// </summary>
        public ListFilterArticleDate(ListTypeBase ListType, DateTime startdate, DateTime enddate )
            : base(ListType)
        {
            if (!IsSupported()) return;

            // Get select table from list type class
            TableEntry SelectTable = ListType.GetSelectTable();

            // Only pull out articles where their date range falls within date range given.
            TableEntry ArticleDateRange = new TableEntry("ArticleDateRange", "ad");
            InnerJoinEntry ije = new InnerJoinEntry(ArticleDateRange);
            ije.Conditions.Add(new ConditionEntry(ArticleDateRange.MakeField("entryID"), "=", SelectTable.MakeField("entryID")));
            ije.Conditions.Add(new ConditionEntry(ArticleDateRange.MakeField("startdate"), ">", "'" + startdate.ToString("yyyy-MM-dd HH:mm:ss") + "'"));
            ije.Conditions.Add(new ConditionEntry(ArticleDateRange.MakeField("enddate"), "<=", "'" + enddate.ToString("yyyy-MM-dd HH:mm:ss") + "'"));
            InnerJoins.Add(ije);

            ListType.AddField(ArticleDateRange.MakeField("startdate"), "item/date-articlestartdate");
            ListType.AddField(ArticleDateRange.MakeField("enddate"),"item/date-articleenddate");
        }

        /// <summary>
        /// 
        /// </summary>
        public override bool IsSupported()
        {
            return ListType.GetListTypeName().ToUpper() == "ARTICLES";
        }
    }

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterThreadType : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName() == "THREADS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListFilterThreadType(ListTypeBase ListType, string type) : base(ListType)
		{
			if(!IsSupported()) return;
			
			// Where THREAD.TYPE = 'type'
			WhereConditions.Add(new ConditionEntry(ListType.GetSelectTable().MakeField("Type").ToString(), "=", "'" + type + "'"));
            
			ListType.AddField(ListType.GetSelectTable().MakeField("Type"), "item/thread-item/type");
		}
	}

    /// <summary>
    /// Allows a uid prefix to be spcified to filter comment forums .
    /// WHERE uid LIKE @prefix%
    /// </summary>
    public sealed class ListFilterUIDPrefix : ListFilterBase
    {
        /// <summary>
        /// 
        /// </summary>
        public override bool IsSupported()
        {
            return ListType.GetListTypeName() == "COMMENTFORUMS";
        }

        /// <summary>
        /// 
        /// </summary>
        public ListFilterUIDPrefix(ListTypeBase ListType, string prefix)
            : base(ListType)
        {
            if (!IsSupported()) return;

            WhereConditions.Add(new ConditionEntry(ListType.GetSelectTable().MakeField("uid").ToString(), "LIKE", "'" + prefix + "%'"));
        }
    }

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListFilterEventDate : ListFilterBase
	{
        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName() == "THREADS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListFilterEventDate(ListTypeBase ListType, int DaysAgo) : base(ListType)
		{
			if(!IsSupported()) return;
			string DateVal;
			DateVal = "DATEADD(day, -" + System.Convert.ToString(DaysAgo) + ", getdate())";
			WhereConditions.Add(new ConditionEntry(ListType.GetSelectTable().MakeField("eventdate").ToString(), ">", DateVal));
            ListType.AddField(ListType.GetSelectTable().MakeField("eventdate"), "item/thread-item/eventdate");
		}
	}

	/// <summary>
	/// Filter for ORDERBY clause. Derive from this to create
	/// new ORDER BY clauses
	/// </summary>
	public abstract class OrderByBase
	{
		/// <summary>
		/// Constructs an OrderBy filter. Only one of these should be needed.
		/// </summary>
		/// <param name="ListType">Instance of ListTypeBase derived class</param>
		public OrderByBase(ListTypeBase ListType)
		{
			this.ListType = ListType;
			InnerJoins = new ArrayList();
		}

		/// <summary>
		/// Tells whether orderby filter is supported for ListType
		/// </summary>
		/// <returns></returns>
		public abstract bool IsSupported();

		/// <summary>
		/// Type of list we're working with
		/// </summary>
		public ListTypeBase ListType;

		/// <summary>
		/// Orderby field. Populated by derived classes
		/// </summary>
		public FieldEntry OrderByField;

		/// <summary>
		/// Collection of inner joins required for orderby. 
		/// Populated by derived classes.
		/// </summary>
		public ArrayList InnerJoins;
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class OrderByRating : OrderByBase
	{
        /// <summary>
        /// 
        /// </summary>
		public OrderByRating(ListTypeBase ListType) : base(ListType)
		{
			if(!IsSupported())
			{
				return;
			}

			// INNER JOIN PageVotes v ON v.ItemType = 1 AND v.ItemID = g.h2g2id
			TableEntry PageVotesTable = new TableEntry("PageVotes", "v");
			InnerJoinEntry ije = new InnerJoinEntry(PageVotesTable);
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemType"), "=", "1"));
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemID"), "=", ListType.GetSelectTable().MakeField("h2g2id")));
			InnerJoins.Add(ije);

			OrderByField = PageVotesTable.MakeField("AverageRating");
			ListType.AddField(OrderByField, "item/poll-list/poll/statistics/@averagerating");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			// Only supported for articles
			return ListType.GetListTypeName() == "ARTICLES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
    public sealed class OrderByBookmarkCount : OrderByBase
    {
        /// <summary>
        /// 
        /// </summary>
        public OrderByBookmarkCount(ListTypeBase ListType)
            : base(ListType)
        {
            if (!IsSupported())
            {
                return;
            }

            TableEntry SelectTable = ListType.GetSelectTable();

            // Need to Inner Join computed BookMark Count table in order to order by it.
            String subSelect = "( Select DestinationId, Count(destinationid) 'bookmarkcount' FROM Links GROUP BY DestinationId )";
            TableEntry LinksTable = new TableEntry(subSelect, "l");
            LinksTable.IsSubSelect = true;
            InnerJoinEntry ije = new InnerJoinEntry(LinksTable);
            ije.Conditions.Add(new ConditionEntry(LinksTable.MakeField("DestinationId"), "=", SelectTable.MakeField("h2g2id")));
            InnerJoins.Add(ije);

            OrderByField = LinksTable.MakeField("bookmarkcount");

            // Select fields
            ListType.AddField(OrderByField, "item/bookmarkcount");

        }

        /// <summary>
        /// 
        /// </summary>
        public override bool IsSupported()
        {
            // Only supported for articles
            return ListType.GetListTypeName() == "ARTICLES";
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public sealed class OrderByCommentForumPostCount : OrderByBase
    {
        /// <summary>
        /// 
        /// </summary>
        public OrderByCommentForumPostCount(ListTypeBase ListType, string dateCreated )
            : base(ListType)
        {
            if (!IsSupported())
            {
                return;
            }

            TableEntry SelectTable = ListType.GetSelectTable();

            // Need to Inner Join computed BookMark Count table in order to order by it.
            String subSelect = "( SELECT cf.forumid, COUNT(te.entryid) 'commentforumpostcount' FROM CommentForums cf INNER JOIN Forums f ON f.ForumId = cf.ForumId INNER JOIN Threads t ON t.forumid = f.forumid INNER JOIN ThreadEntries te ON te.threadid = t.threadid";


            string whereClause = string.Empty;
            if ( dateCreated != null && dateCreated != string.Empty )
            {
                subSelect += " WHERE te.DatePosted > DATEADD(day,-" + dateCreated + ",getdate())";
            }

            subSelect += " GROUP BY cf.ForumId )";

            TableEntry countsTable = new TableEntry(subSelect, "cfcount");
            countsTable.IsSubSelect = true;
            InnerJoinEntry ije = new InnerJoinEntry(countsTable);
            ije.Conditions.Add(new ConditionEntry(countsTable.MakeField("ForumId"), "=", SelectTable.MakeField("forumid")));
            InnerJoins.Add(ije);

            OrderByField = countsTable.MakeField("commentforumpostcount");

            // Select fields
            ListType.AddField(OrderByField, "item/commentforum-item/commentforumpostcount");

        }

        /// <summary>
        /// 
        /// </summary>
        public override bool IsSupported()
        {
            // Only supported for articles
            return ListType.GetListTypeName() == "COMMENTFORUMS";
        }
    }

    /// <summary>
    /// 
    /// </summary>
	public sealed class OrderByVoteCount : OrderByBase
	{
        /// <summary>
        /// 
        /// </summary>
		public OrderByVoteCount(ListTypeBase ListType) : base(ListType)
		{
			if(!IsSupported())
			{
				return;
			}

			// INNER JOIN PageVotes v ON v.ItemType = 1 AND v.ItemID = g.h2g2id
			TableEntry PageVotesTable = new TableEntry("PageVotes", "v");
			InnerJoinEntry ije = new InnerJoinEntry(PageVotesTable);
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemType"), "=", "1"));
			ije.Conditions.Add(new ConditionEntry(PageVotesTable.MakeField("ItemID"), "=", ListType.GetSelectTable().MakeField("h2g2id")));
			InnerJoins.Add(ije);

			OrderByField = PageVotesTable.MakeField("VoteCount");
			ListType.AddField(OrderByField, "item/poll-list/poll/statistics/@votecount");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			// Only supported for articles
			return ListType.GetListTypeName() == "ARTICLES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class OrderByEventDate : OrderByBase
    {   
        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName() == "THREADS";
		}

        /// <summary>
        /// 
        /// </summary>
		public OrderByEventDate(ListTypeBase ListType) : base(ListType)
		{
			if(!IsSupported())
			{
				return;
			}

			OrderByField = ListType.GetSelectTable().MakeField("EventDate");
			ListType.AddField(ListType.GetSelectTable().MakeField("EventDate"), "item/thread-item/eventdate");
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class OrderByDateCreated : OrderByBase
	{
        /// <summary>
        /// 
        /// </summary>
		public OrderByDateCreated(ListTypeBase ListType) : base(ListType)
		{
			if(!IsSupported())
			{
				return;
			}

			if(ListType.GetListTypeName() == "ARTICLES"
				|| ListType.GetListTypeName() == "CLUBS"
				|| ListType.GetListTypeName() == "THREADS"
				|| ListType.GetListTypeName() == "FORUMS"
				|| ListType.GetListTypeName() == "CAMPAIGNDIARYENTRIES")
			{
				OrderByField = ListType.GetSelectTable().MakeField("DateCreated");
			}
			else if(ListType.GetListTypeName() == "TOPICFORUMS")
			{
				OrderByField = ListType.GetSelectTable().MakeField("CreatedDate");
			}
			else if(ListType.GetListTypeName() == "CATEGORIES")
			{
				// join on guideentries
				TableEntry GuideEntriesTable = new TableEntry("Guideentries", "g");
				InnerJoins.Add(new InnerJoinEntry(GuideEntriesTable, 
					new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", ListType.GetSelectTable().MakeField("h2g2id"))));
				
				OrderByField = GuideEntriesTable.MakeField("DateCreated");
			}
			else if(ListType.GetListTypeName() == "USERS")
			{
				// datejoined
				OrderByField = ListType.GetSelectTable().MakeField("DateJoined");
			}

			ListType.AddField(OrderByField, "item/date-created");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName() == "ARTICLES"
				|| ListType.GetListTypeName() == "TOPICFORUMS"
				|| ListType.GetListTypeName() == "CLUBS"
				|| ListType.GetListTypeName() == "THREADS"
				|| ListType.GetListTypeName() == "CATEGORIES"
				|| ListType.GetListTypeName() == "USERS"
				|| ListType.GetListTypeName() == "FORUMS"
				|| ListType.GetListTypeName() == "CAMPAIGNDIARYENTRIES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class OrderByDateUpdated : OrderByBase
	{
        /// <summary>
        /// 
        /// </summary>
		public OrderByDateUpdated(ListTypeBase ListType) : base(ListType)
		{
			if(!IsSupported()) 
			{
				return;
			}
			
			if(ListType.GetListTypeName() == "CLUBS")
			{
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");

				OrderByField 
					= new FieldEntry(ListType.GetSelectTable(), "LastUpdated", ">", GuideEntriesTable, "LastUpdated");
			}
			else if(ListType.GetListTypeName() == "CAMPAIGNDIARYENTRIES"
				|| ListType.GetListTypeName() == "THREADS")
			{
				OrderByField = ListType.GetSelectTable().MakeField("LastPosted");
			}
			else
			{
				OrderByField = ListType.GetSelectTable().MakeField("LastUpdated");
			}
				
			ListType.AddField(OrderByField, "item/date-updated");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName() == "ARTICLES"
				|| ListType.GetListTypeName() == "TOPICFORUMS"
				|| ListType.GetListTypeName() == "CLUBS"
				|| ListType.GetListTypeName() == "THREADS"
				|| ListType.GetListTypeName() == "CATEGORIES"
				|| ListType.GetListTypeName() == "FORUMS"
				|| ListType.GetListTypeName() == "CAMPAIGNDIARYENTRIES";
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class OrderBySignificance : OrderByBase
	{
        /// <summary>
        /// 
        /// </summary>
		public OrderBySignificance(ListTypeBase ListType) : base(ListType)
		{
			TableEntry ContentSignifTable;
			TableEntry JoinTable;
			string IDField;

			// Choose ContentSignif table and id field
			if(ListType.GetListTypeName() == "ARTICLES")
			{
				JoinTable = ListType.GetSelectTable();
				ContentSignifTable = new TableEntry("ContentSignifArticle", "csa");
				IDField = "h2g2id";
			}
			else if (ListType.GetListTypeName() == "CLUBS")
			{
				JoinTable = ListType.GetSelectTable();
				ContentSignifTable = new TableEntry("ContentSignifClub", "csc");
				IDField = "Clubid";
			}
			else if (ListType.GetListTypeName() == "USERS")
			{
				JoinTable = ListType.GetSelectTable();
				ContentSignifTable = new TableEntry("ContentSignifUser", "csu");
				IDField = "Userid";
			}
			else if (ListType.GetListTypeName() == "THREADS")
			{
				JoinTable = ListType.GetSelectTable();
				ContentSignifTable = new TableEntry("ContentSignifThread", "csc");
				IDField = "ThreadID";
			}
			else if (ListType.GetListTypeName() == "CATEGORIES")
			{
				JoinTable = ListType.GetSelectTable();
				ContentSignifTable = new TableEntry("ContentSignifNode", "csn");
				IDField = "NodeID";
			}
			else if (ListType.GetListTypeName() == "FORUMS")
			{
				JoinTable = ListType.GetSelectTable();
				ContentSignifTable = new TableEntry("ContentSignifForum", "csf");
				IDField = "ForumID";
			}
			else if (ListType.GetListTypeName() == "TOPICFORUMS")
			{
				// Get forum

				// inner join guideentries g on g.h2g2id=t.h2g2id
				TableEntry GuideEntriesTable = new TableEntry("GuideEntries", "g");
				InnerJoinEntry ije1 = new InnerJoinEntry(GuideEntriesTable);
				ije1.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", ListType.GetSelectTable().MakeField("h2g2id")));
				InnerJoins.Add(ije1);

				// inner join forums f on f.forumid=g.forumid
				TableEntry ForumsTable = new TableEntry("Forums", "f");
				InnerJoinEntry ije2 = new InnerJoinEntry(ForumsTable);
				ije2.Conditions.Add(new ConditionEntry(ForumsTable.MakeField("forumid"), "=", GuideEntriesTable.MakeField("forumid")));
				InnerJoins.Add(ije2);
				
				ContentSignifTable = new TableEntry("ContentSignifForum", "csf");
				IDField = "ForumID";

				JoinTable = ForumsTable;
			}
			else
			{
				// SHould not come here
				return;
			}

			// INNER JOIN ContentSignifXXXXX csx on csx.[id] = selecttable.[id]
			InnerJoinEntry ije = new InnerJoinEntry(ContentSignifTable);
			ije.Conditions.Add(new ConditionEntry(ContentSignifTable.MakeField(IDField), "=", JoinTable.MakeField(IDField)));
			InnerJoins.Add(ije);

			OrderByField = ContentSignifTable.MakeField("Score");
			ListType.AddField(OrderByField, "item/score");
		}

        /// <summary>
        /// 
        /// </summary>
		public override bool IsSupported()
		{
			return ListType.GetListTypeName() == "ARTICLES"
				|| ListType.GetListTypeName() == "TOPICFORUMS"
				|| ListType.GetListTypeName() == "CLUBS"
				|| ListType.GetListTypeName() == "THREADS"
				|| ListType.GetListTypeName() == "CATEGORIES"
				|| ListType.GetListTypeName() == "USERS"
				|| ListType.GetListTypeName() == "FORUMS";
		}
	}


	/// <summary>
	/// Derive from this class to create a new list type
	/// Override abstract methods to return correct data for list type
	/// </summary>
	public abstract class ListTypeBase
	{
		/// <summary>
		/// Return inner joins required for this list type
		/// </summary>
		/// <returns></returns>
		public abstract ArrayList GetInnerJoins();
		
		/// <summary>
		/// Return fully qualified select fields for this list type
		/// </summary>
		/// <returns></returns>
		public StringCollection GetSelectFields()
		{
			return SelectFields;
		}

		/// <summary>
		/// Override to get select table for this list type
		/// </summary>
		/// <returns>select table</returns>
		public abstract TableEntry GetSelectTable();

		/// <summary>
		/// Override to return name of list type, e.g. "ARTICLES" or "CLUBS"
		/// </summary>
		/// <returns></returns>
		public abstract string GetListTypeName();

		/// <summary>
		/// Override to get name of xml resource for list type. return null
		/// if item has no xml.
		/// </summary>
		/// <returns></returns>
		public abstract string GetItemXmlResourceName();

		/// <summary>
		/// Override to return fully qualified name of field from
		/// where to get the SiteID
		/// </summary>
		/// <returns>tablealias.fieldname or null if no siteid</returns>
		public abstract string GetSiteIDField();

		/// <summary>
		/// XML doc to dictate the final format of dynamic list items. Maps
		/// field names to xml element/attrtibutes
		/// </summary>
		protected XmlDocument ItemXml;

		/// <summary>
		/// Fields to go into select list. Field aliases
		/// must be generated from the item index in the collection
		/// </summary>
		protected StringCollection SelectFields;

		/// <summary>
		/// Get item XML schema for this list
		/// </summary>
		/// <returns></returns>
		public XmlDocument GetXml()
		{
			return ItemXml;
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeBase()
		{
			// Item xml
			ItemXml = new XmlDocument();
			ItemXml.LoadXml("<item/>");
			SelectFields = new StringCollection();
		}

		/// <summary>
		/// Adds item/@itemid field
		/// </summary>
		/// <param name="field">Name of numeric id field</param>
		/// <returns>same as AddField</returns>
		public string AddFieldID(FieldEntry field)
		{
			return AddField(field, "item/@itemid");
		}

        /// <summary>
        /// 
        /// </summary>
		public string AddFieldDateCreated(FieldEntry field)
		{
			return AddField(field, "item/date-created");
		}

        /// <summary>
        /// 
        /// </summary>
		public string AddFieldDateUpdated(FieldEntry field)
		{
			return AddField(field, "item/date-updated");
		}

        /// <summary>
        /// 
        /// </summary>
		public string AddFieldTitle(FieldEntry field)
		{
			return AddField(field, "item/title");
		}

		/// <summary>
		/// Adds creator block
		/// </summary>
		/// <param name="UsersTable">Table from where to pull user fields</param>
		/// <returns>Field alias of IDField, or null if failed</returns>
		public string AddFieldCreator(TableEntry UsersTable)
		{
			string IDFieldAlias;

			if((IDFieldAlias = AddField(UsersTable, "UserID", "item/creator/user/userid")) == null)
			{
				return null;
			}
            
			// If any of these fail, function will still succeed, but userblock will
			// be incomplete
			AddField(UsersTable, "username", "item/creator/user/username");
			AddField(UsersTable, "firstnames", "item/creator/user/firstnames");
			AddField(UsersTable, "lastname", "item/creator/user/lastname");
			AddField(UsersTable, "area", "item/creator/user/area");
			AddField(UsersTable, "status", "item/creator/user/status");
			AddField(UsersTable, "taxonomynode", "item/creator/user/taxonomynode");
			AddField(UsersTable, "journal", "item/creator/user/journal");
			AddField(UsersTable, "active", "item/creator/user/active");
			
			return IDFieldAlias;
		}

        /// <summary>
        /// 
        /// </summary>
		public string AddField(FieldEntry field, string xpath)
		{
			return AddFieldorValue(field.ToString(), xpath);
			//return AddField(field.Table, field.FieldName, xpath);
		}

        /// <summary>
        /// 
        /// </summary>
		public string AddField(string name, string xpath)
		{
			return AddField(null, name, xpath);
		}

		/// <summary>
		/// Adds a hardcoded value to xml
		/// </summary>
		/// <param name="value">value</param>
		/// <param name="xpath">xpath</param>
		/// <returns></returns>
		public string AddValue(string value, string xpath)
		{
			return AddFieldorValue(value, xpath);
		}

		/// <summary>
		/// Adds a field or hardcoded value
		/// </summary>
		/// <param name="name">fully qualified field name or a value</param>
		/// <param name="xpath"></param>
		/// <returns></returns>
		private string AddFieldorValue(string name, string xpath)
		{
            // Add field. Alias of field will be its index in the collection.
            // This is an easy way to ensure unique field alias's, but also 
            // means that selectfields cannot be removed, re-ordered or added
            // without using the AddField method.
            int index = SelectFields.IndexOf(name);
            if ( index < 0 )
			    index = SelectFields.Add(name);
			
			// Locate node in xml
			XmlNode nde = ItemXml.SelectSingleNode(xpath);

			// If not found, add it
			if(nde == null)
			{
				nde = AddXmlNode(xpath);
			}

			// If not found/created, remove field from list
			if(nde == null)
			{
				SelectFields.RemoveAt(index);
				System.Diagnostics.Debugger.Log(1, "xml", xpath + "\r\n");
				//return null; //debug: for now we want to throw exception
			}

			// Set value of node/attribute to field alias
			nde.InnerText = System.Convert.ToString(index);

			// Return field alias
			return nde.InnerText;
		}

		/// <summary>
		/// Adds a field to the select list and populates xpath with an automatically
		/// generated field alias.
		/// </summary>
		/// <param name="table">Table where field comes from. If null, SelectTable is used.</param>
		/// <param name="name">Field name</param>
		/// <param name="xpath">XPath expression to populate with field alias</param>
		/// <returns>Field alias, or null if failed to add field (bad xpath?)</returns>
		public string AddField(TableEntry table, string name, string xpath)
		{
			// Get select table if none specified
			if(table == null)
			{
				table = GetSelectTable();
			}
			
			return AddFieldorValue(table.MakeField(name).ToString(), xpath);
		}

		private XmlNode AddXmlNode(string xpath)
		{
			string [] split = xpath.Split('/');
			
			string slast = "";

			foreach(string s in split)
			{
				string scurrent = slast + '/' + s;
				XmlNode nde = ItemXml.SelectSingleNode(scurrent);
				
				if(nde == null)
				{
					if(slast.Length == 0)	// root
					{
						XmlElement elem = ItemXml.CreateElement(s);
						ItemXml.DocumentElement.AppendChild(elem);
					}
					else if(s[0] == '@')	// Attribute
					{
						XmlNode nde2 = ItemXml.SelectSingleNode(slast);
						nde2.Attributes.Append(ItemXml.CreateAttribute(s.Substring(1)));
					}
					else					// element
					{
						XmlElement elem = ItemXml.CreateElement(s);
						XmlNode nde2 = ItemXml.SelectSingleNode(slast);
						nde2.AppendChild(elem);
					}
				}

				slast += '/' + s;
			}

			return ItemXml.SelectSingleNode(xpath);
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeArticles : ListTypeBase
	{
		private TableEntry SelectTable;
		private TableEntry UsersTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return SelectTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "article-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "ARTICLES";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeArticles()
		{
			SelectTable = new TableEntry("GuideEntries", "g");
			UsersTable = new TableEntry("Users", "u");

			// Add default fields //

			AddField("h2g2id", "item/@itemid");
			AddField("h2g2id", "item/article-item/@h2g2id");
			AddField("datecreated", "item/date-created");
			AddField("lastupdated", "item/date-updated");
			AddFieldTitle(new FieldEntry(SelectTable, "subject"));
            
			// item/creator
			AddField("editor", "item/creator/user/userid");
			AddField(UsersTable, "username", "item/creator/user/username");
			AddField(UsersTable, "firstnames", "item/creator/user/firstnames");
			AddField(UsersTable, "lastname", "item/creator/user/lastname");
			AddField(UsersTable, "area", "item/creator/user/area");
			AddField(UsersTable, "status", "item/creator/user/status");
			AddField(UsersTable, "taxonomynode", "item/creator/user/taxonomynode");
			AddField(UsersTable, "journal", "item/creator/user/journal");
			AddField(UsersTable, "active", "item/creator/user/active");

			// article-item
			AddField("subject", "item/article-item/subject");
			AddField("extrainfo", "item/article-item/extrainfo");

			// article-item/author
			AddField("editor", "item/article-item/author/user/userid");
			AddField(UsersTable, "username", "item/article-item/author/user/username");
			AddField(UsersTable, "firstnames", "item/article-item/author/user/firstnames");
			AddField(UsersTable, "lastname", "item/article-item/author/user/lastname");
			AddField(UsersTable, "area", "item/article-item/author/user/area");
			AddField(UsersTable, "status", "item/article-item/author/user/status");
			AddField(UsersTable, "taxonomynode", "item/article-item/author/user/taxonomynode");
			AddField(UsersTable, "journal", "item/article-item/author/user/journal");
			AddField(UsersTable, "active", "item/article-item/author/user/active");
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return SelectTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();
			
			// Join on users

			// INNER JOIN USERS ListTypeArticlesUsers ON Articles.Editor = ListTypeArticlesUsers.UserID
			InnerJoinEntry usersJoin = new InnerJoinEntry(UsersTable);
			usersJoin.Conditions.Add(new ConditionEntry(GetSelectTable().MakeField("Editor"), "=", UsersTable.MakeField("UserID")));
			al.Add(usersJoin);
			return al;
		}
	}

	/// <summary>
	/// Select fields and inner joins for Clubs list
	/// </summary>
	public sealed class ListTypeClubs : ListTypeBase
	{
		private TableEntry SelectTable;
		private TableEntry GuideEntriesTable;
		private TableEntry UsersTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return SelectTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "club-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "CLUBS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeClubs()
		{
			SelectTable			= new TableEntry("Clubs", "c");
			GuideEntriesTable	= new TableEntry("Guideentries", "g");
			UsersTable			= new TableEntry("Users", "u");

			// Add base fields
			AddFieldID(new FieldEntry(SelectTable, "clubid"));
			
			AddFieldDateCreated(new FieldEntry(GuideEntriesTable, "DateCreated"));
			AddFieldDateUpdated(new FieldEntry(SelectTable, "LastUpdated", ">", GuideEntriesTable, "LastUpdated"));
			AddFieldTitle(new FieldEntry(SelectTable, "name"));
			AddFieldCreator(UsersTable);

			// club-item fields
			AddField("clubid", "item/club-item/@clubid");
			AddField("name", "item/club-item/name");
			AddField(GuideEntriesTable, "extrainfo", "item/club-item/extrainfo");
			AddFieldAuthor();
        }

		private string AddFieldAuthor()
		{
			const string xxxitem = "club-item";

			string IDFieldAlias;
			
			if((IDFieldAlias = AddField(GuideEntriesTable, "editor", "item/" + xxxitem +"/author/user/userid")) == null)
			{
				return null;
			}
            
			// If any of these fail, function will still succeed, but userblock will
			// be incomplete
			AddField(UsersTable, "username", "item/" + xxxitem + "/author/user/username");
			AddField(UsersTable, "firstnames", "item/" + xxxitem + "/author/user/firstnames");
			AddField(UsersTable, "lastname", "item/" + xxxitem + "/author/user/lastname");
			AddField(UsersTable, "area", "item/" + xxxitem + "/author/user/area");
			AddField(UsersTable, "status", "item/" + xxxitem + "/author/user/status");
			AddField(UsersTable, "taxonomynode", "item/" + xxxitem + "/author/user/taxonomynode");
			AddField(UsersTable, "journal", "item/" + xxxitem + "/author/user/journal");
			AddField(UsersTable, "active", "item/" + xxxitem + "/author/user/active");
			
			return IDFieldAlias;
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return SelectTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();
			
			// INNER JOIN GuideEntries g ON g.h2g2id=c.h2g2id AND g.hidden null
			InnerJoinEntry GuideEntriesJoin = new InnerJoinEntry(GuideEntriesTable);
			GuideEntriesJoin.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", GetSelectTable().MakeField("h2g2id")));
			GuideEntriesJoin.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("hidden"), "is", "null"));

			// INNER JOIN Users u ON u.h2g2id=g.Editor
			InnerJoinEntry UsersJoin = new InnerJoinEntry(UsersTable, 
				new ConditionEntry(UsersTable.MakeField("UserID"), "=", GuideEntriesTable.MakeField("Editor")));

			al.Add(GuideEntriesJoin);
			al.Add(UsersJoin);

			return al;
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeForums : ListTypeBase
	{
		TableEntry ForumTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return ForumTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "forum-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "FORUMS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeForums()
		{
			ForumTable = new TableEntry("Forums", "f");

			// Add fields
			AddFieldID(new FieldEntry(ForumTable, "ForumID"));
			AddFieldDateCreated(new FieldEntry(ForumTable, "DateCreated"));
			AddFieldDateUpdated(new FieldEntry(ForumTable, "LastUpdated"));
			AddFieldTitle(new FieldEntry(ForumTable, "Title"));

			AddField("forumid", "item/forum-item/@forumid");
			AddField("ForumPostCount", "item/forum-item/@forumpostcount");
			AddField("LastPosted", "item/forum-item/date-lastposted");
			AddField("Title", "item/forum-item/title");
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return ForumTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();
            return al;
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeThreads : ListTypeBase
	{
		private TableEntry ThreadTable;
		private TableEntry ThreadEntriesTable;
		private TableEntry UsersTable;
		private TableEntry ForumsTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return ForumsTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "thread-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "THREADS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeThreads()
		{
			ThreadTable			= new TableEntry("Threads", "t");
			ThreadEntriesTable	= new TableEntry("ThreadEntries", "te");
			UsersTable			= new TableEntry("Users", "u");
			ForumsTable			= new TableEntry("Forums", "f");

			// Add fields
			AddFieldID(new FieldEntry(ThreadTable, "threadid"));
			AddFieldTitle(new FieldEntry(ThreadTable, "FirstSubject"));
			AddFieldDateCreated(new FieldEntry(ThreadTable, "DateCreated"));
			AddFieldDateUpdated(new FieldEntry(ThreadTable, "LastPosted"));
			AddFieldCreator(UsersTable);

			AddField("ThreadID", "item/thread-item/@threadid");
			AddField("ForumID", "item/thread-item/@forumid");
			AddField("FirstSubject", "item/thread-item/firstsubject");
			AddField("LastPosted", "item/thread-item/date-lastposted");
			AddField(ThreadEntriesTable, "text", "item/thread-item/text");
						
			AddFieldAuthor();
		}

		private string AddFieldAuthor()
		{
			const string xxxitem = "thread-item";

			string IDFieldAlias;
			
			if((IDFieldAlias = AddField(ThreadEntriesTable, "UserID", "item/" + xxxitem +"/author/user/userid")) == null)
			{
				return null;
			}
            
			// If any of these fail, function will still succeed, but userblock will
			// be incomplete
			AddField(UsersTable, "username", "item/" + xxxitem + "/author/user/username");
			AddField(UsersTable, "firstnames", "item/" + xxxitem + "/author/user/firstnames");
			AddField(UsersTable, "lastname", "item/" + xxxitem + "/author/user/lastname");
			AddField(UsersTable, "area", "item/" + xxxitem + "/author/user/area");
			AddField(UsersTable, "status", "item/" + xxxitem + "/author/user/status");
			AddField(UsersTable, "taxonomynode", "item/" + xxxitem + "/author/user/taxonomynode");
			AddField(UsersTable, "journal", "item/" + xxxitem + "/author/user/journal");
			AddField(UsersTable, "active", "item/" + xxxitem + "/author/user/active");
			
			return IDFieldAlias;
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return ThreadTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();

			// Join on Forums
			InnerJoinEntry ijeForums = new InnerJoinEntry(ForumsTable);
			ijeForums.Conditions.Add(new ConditionEntry(ForumsTable.MakeField("ForumID"), "=", ThreadTable.MakeField("ForumID")));
			al.Add(ijeForums);

			// Join on ThreadEntries
			InnerJoinEntry ije = new InnerJoinEntry(ThreadEntriesTable);
			ije.Conditions.Add(new ConditionEntry(ThreadEntriesTable.MakeField("ThreadID"), "=", ThreadTable.MakeField("ThreadID")));
			ije.Conditions.Add(new ConditionEntry(ThreadEntriesTable.MakeField("PostIndex"), "=", "0"));
			ije.Conditions.Add(new ConditionEntry(ThreadEntriesTable.MakeField("hidden"), "is", "null"));
			al.Add(ije);

			// Join on Users
			al.Add(new InnerJoinEntry(UsersTable, 
				new ConditionEntry(UsersTable.MakeField("UserID"), "=", ThreadEntriesTable.MakeField("UserID"))));
			
			return al;
		}
	}

    /// <summary>
    /// 
    /// </summary>
    public sealed class ListTypeCommentForums : ListTypeBase
    {
        private TableEntry CommentForumsTable;
        private TableEntry ForumsTable;

        /// <summary>
        /// 
        /// </summary>
        public override string GetSiteIDField()
        {
            return ForumsTable.MakeField("SiteID").ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        public override string GetItemXmlResourceName()
        {
            return "commentforum-item";
        }

        /// <summary>
        /// 
        /// </summary>
        public override string GetListTypeName()
        {
            return "COMMENTFORUMS";
        }

        /// <summary>
        /// 
        /// </summary>
        public ListTypeCommentForums()
        {
            CommentForumsTable = new TableEntry("CommentForums", "cf");
            ForumsTable = new TableEntry("Forums", "f");


            AddField(CommentForumsTable, "forumid", "item/commentforum-item/forumid");
            AddField(CommentForumsTable, "uid", "item/commentforum-item/uid");
            AddField(CommentForumsTable, "url", "item/commentforum-item/url");
            AddField(ForumsTable, "title", "item/commentforum-item/title");

        }

        /// <summary>
        /// 
        /// </summary>
        public override TableEntry GetSelectTable()
        {
            return CommentForumsTable;
        }

        /// <summary>
        /// 
        /// </summary>
        public override ArrayList GetInnerJoins()
        {
            ArrayList al = new ArrayList();

            // Join on Forums
            InnerJoinEntry ijeForums = new InnerJoinEntry(ForumsTable);
            ijeForums.Conditions.Add(new ConditionEntry(ForumsTable.MakeField("ForumID"), "=", CommentForumsTable.MakeField("ForumID")));
            al.Add(ijeForums);

            return al;
        }
    }

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeCategories : ListTypeBase
	{
		private TableEntry SelectTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return SelectTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "category-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "CATEGORIES";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeCategories()
		{
			SelectTable = new TableEntry("Hierarchy", "ltcHierarchy");

			// Add fields
			AddField("NodeID", "item/@itemid");
			AddField("DisplayName", "item/title");
			AddField("LastUpdated", "item/date-updated");

			AddField("NodeID", "item/category-item/@nodeid");
			AddField("NodeMembers", "item/category-item/@nodemembercount");
			AddField("DisplayName", "item/category-item/displayname");
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return SelectTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();
			return al;
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeUsers : ListTypeBase
	{
		TableEntry UsersTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return null;
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "user-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "USERS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeUsers()
		{
			UsersTable = new TableEntry("Users", "u");

			// Add fields
			AddFieldDateCreated(new FieldEntry(UsersTable, "DateJoined"));
			AddFieldID(new FieldEntry(UsersTable, "UserID"));
			AddFieldTitle(new FieldEntry(UsersTable, "username"));

            AddField("userid", "item/user-item/@userid");
			AddField("userid", "item/user-item/userid");
			AddField("UserName", "item/user-item/username");
			AddField("FirstNames", "item/user-item/firstnames");
			AddField("LastName", "item/user-item/lastname");
			AddField("area", "item/user-item/lastname");
			AddField("status", "item/user-item/status");
			AddField("taxonomynode", "item/user-item/taxonomynode");
			AddField("journal", "item/user-item/journal");
			AddField("active", "item/user-item/active");
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return UsersTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();
			return al;
		}
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeTopicForums : ListTypeBase
	{
		private TableEntry TopicsTable;
		private TableEntry GuideEntriesTable;
		private TableEntry ForumsTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return GuideEntriesTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "topic-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "TOPICFORUMS";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeTopicForums()
		{
			TopicsTable			= new TableEntry("Topics", "t");
			GuideEntriesTable	= new TableEntry("GuideEntries", "g");
			ForumsTable			= new TableEntry("Forums", "f");

			// Add fields
            AddFieldDateUpdated(new FieldEntry(ForumsTable, "LastPosted"));
			AddFieldID(new FieldEntry(TopicsTable, "TopicID"));
			AddFieldTitle(new FieldEntry(GuideEntriesTable, "Subject"));

			AddField("TopicID", "item/topic-item/@topicid");
			AddField(ForumsTable, "ForumPostCount", "item/topic-item/@forumpostcount");
			AddField(GuideEntriesTable, "forumid", "item/topic-item/@forumid");
			AddField(GuideEntriesTable, "subject", "item/topic-item/subject");
			AddField(ForumsTable, "LastPosted", "item/topic-item/date-lastposted");
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return TopicsTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();

			// Inner join on guideentries
			al.Add(new InnerJoinEntry(GuideEntriesTable, 
				new ConditionEntry(TopicsTable.MakeField("h2g2id"), "=", GuideEntriesTable.MakeField("h2g2id"))));
		
			// Inner join on forums
			InnerJoinEntry ije = new InnerJoinEntry(ForumsTable, 
				new ConditionEntry(ForumsTable.MakeField("forumid"), "=", GuideEntriesTable.MakeField("forumid")));


			al.Add(ije);

			return al;
		}
       
	}

    /// <summary>
    /// 
    /// </summary>
	public sealed class ListTypeCampaignDiaryEntries : ListTypeBase
	{
		private TableEntry ThreadTable;
		private TableEntry ClubTable;
		//private TableEntry GuideEntriesTable;
		private TableEntry ThreadEntriesTable;
		private TableEntry UsersTable;

        /// <summary>
        /// 
        /// </summary>
		public override string GetSiteIDField()
		{
			return ClubTable.MakeField("SiteID").ToString();
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetItemXmlResourceName()
		{
			return "campaigndiaryentry-item";
		}

        /// <summary>
        /// 
        /// </summary>
		public override string GetListTypeName()
		{
			return "CAMPAIGNDIARYENTRIES";
		}

        /// <summary>
        /// 
        /// </summary>
		public ListTypeCampaignDiaryEntries()
		{
			ThreadTable			= new TableEntry("Threads", "t");
			ClubTable			= new TableEntry("Clubs", "c");
			ThreadEntriesTable	= new TableEntry("ThreadEntries", "te");
			UsersTable			= new TableEntry("Users", "u");
			//GuideEntriesTable	= new TableEntry("GuideEntries", "g");

			// Add 'Standard' fields
			AddFieldCreator(UsersTable);
			AddFieldID(ThreadTable.MakeField("ThreadID"));
			AddFieldDateUpdated(ThreadTable.MakeField("LastPosted"));
			AddFieldDateCreated(ThreadTable.MakeField("DateCreated"));
			AddFieldTitle(ThreadTable.MakeField("FirstSubject"));
			
			// Add CampaignDiaryEntries specific fields
			AddField(ThreadTable, "ForumID", "item/campaign-diary-entry-item/forumid");
			AddField(ThreadTable, "ThreadID", "item/campaign-diary-entry-item/threadid");
			AddField(ClubTable, "ClubID", "item/campaign-diary-entry-item/clubid");
			AddField(ThreadTable, "FirstSubject", "item/campaign-diary-entry-item/title");
			AddField(ThreadTable, "FirstSubject", "item/campaign-diary-entry-item/subject");
			AddValue("'campaign'", "item/campaign-diary-entry-item/linkitemtype");
			AddField(ClubTable, "ClubID", "item/campaign-diary-entry-item/linkitemid");
			AddField(ClubTable, "Name", "item/campaign-diary-entry-item/linkitemname");
			AddField(ThreadTable, "LastPosted", "item/campaign-diary-entry-item/date-updated");
			AddFieldAuthor();
		}

        /// <summary>
        /// 
        /// </summary>
		private string AddFieldAuthor()
		{
			const string xxxitem = "campaign-diary-entry-item";

			string IDFieldAlias;
			
			if((IDFieldAlias = AddField(UsersTable, "UserID", "item/" + xxxitem +"/author/user/userid")) == null)
			{
				return null;
			}
            
			// If any of these fail, function will still succeed, but userblock will
			// be incomplete
			AddField(UsersTable, "username", "item/" + xxxitem + "/author/user/username");
			AddField(UsersTable, "firstnames", "item/" + xxxitem + "/author/user/firstnames");
			AddField(UsersTable, "lastname", "item/" + xxxitem + "/author/user/lastname");
			AddField(UsersTable, "area", "item/" + xxxitem + "/author/user/area");
			AddField(UsersTable, "status", "item/" + xxxitem + "/author/user/status");
			AddField(UsersTable, "taxonomynode", "item/" + xxxitem + "/author/user/taxonomynode");
			AddField(UsersTable, "journal", "item/" + xxxitem + "/author/user/journal");
			AddField(UsersTable, "active", "item/" + xxxitem + "/author/user/active");
			
			return IDFieldAlias;
		}

        /// <summary>
        /// 
        /// </summary>
		public override TableEntry GetSelectTable()
		{
			return ThreadTable;
		}

        /// <summary>
        /// 
        /// </summary>
		public override ArrayList GetInnerJoins()
		{
			ArrayList al = new ArrayList();

			// INNER JOIN CLUBS on CLUBS.JOURNAL = THREADS.FORUMID
			InnerJoinEntry ijeClubs = new InnerJoinEntry(ClubTable);
			ijeClubs.Conditions.Add(new ConditionEntry(ClubTable.MakeField("Journal"), "=", ThreadTable.MakeField("ForumID")));

			// There is no need to filter out posts on moderated articles
			// INNER JOIN GUIDENTRIES on GUIDENTRIES.h2g2id = CLUBS.h2g2id
			//InnerJoinEntry ijeGuideEntries = new InnerJoinEntry(GuideEntriesTable);
			//ijeGuideEntries.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("h2g2id"), "=", ClubTable.MakeField("h2g2id")));
			//ijeGuideEntries.Conditions.Add(new ConditionEntry(GuideEntriesTable.MakeField("hidden"), "is", "NULL"));

			// INNER JOIN THREADENTRIES on THREADENTRIES.ThreadID = THREADS.ThreadID AND THREADENTRIES.PostIndex=0
			InnerJoinEntry ijeThreadEntries = new InnerJoinEntry(ThreadEntriesTable);
			ijeThreadEntries.Conditions.Add(new ConditionEntry(ThreadEntriesTable.MakeField("ThreadID"), "=", ThreadTable.MakeField("ThreadID")));
			ijeThreadEntries.Conditions.Add(new ConditionEntry(ThreadEntriesTable.MakeField("PostIndex"), "=", "0"));
			ijeThreadEntries.Conditions.Add(new ConditionEntry(ThreadEntriesTable.MakeField("hidden"), "is", "null"));

			// JOIN USERS ON USERS.UserID = THREADENTRIES.UserID
			InnerJoinEntry ijeUsers = new InnerJoinEntry(UsersTable,
				new ConditionEntry(UsersTable.MakeField("UserID"), "=", ThreadEntriesTable.MakeField("UserID")));
			
			al.Add(ijeClubs);
			al.Add(ijeThreadEntries);
			al.Add(ijeUsers);

			return al;
		}
	}

	/// <summary>
	/// - Loads list definition XML
	/// - Create SQL out of list definition
	/// </summary>
	public sealed class ListDefinition
	{
        /// <summary>
        /// Xml Version of Dynamic List Definition.
        /// </summary>
        public float xmlVersion;

        /// <summary>
        /// Name (string id) of list
        /// </summary>
        public string xmlListName;

        /// <summary>
        /// List type
        /// </summary>
        public string xmlType;

        /// <summary>
        /// Filters
        /// </summary>
        public string xmlArticleType, xmlStatus, xmlRating, xmlScore, xmlLastUpdated, xmlDateCreated, xmlArticleStartDate, xmlArticleEndDate;
        
        /// <summary>
        /// 
        /// </summary>
        public string[] xmlCategories;
        
        /// <summary>
        /// 
        /// </summary>
        public  List<Phrase> xmlKeyPhrases;

        /// <summary>
        /// OrderBy
        /// </summary>
        public string xmlOrderBy;

        /// <summary>
        /// List length (TOP x)
        /// </summary>
        public string xmlLength;

        /// <summary>
        /// Number of votes
        /// </summary>
        public string xmlVoteCount;

        /// <summary>
        /// Bookmark count .
        /// </summary>
        public string xmlBookmarkCount;

        /// <summary>
        /// Type of thread ('notice', 'event')
        /// </summary>
        public string xmlThreadType;

        /// <summary>
        /// Number of days
        /// </summary>
        public string xmlEventDate;

        /// <summary>
        /// Name of site this list is for
        /// </summary>
        public string SiteURLName;

        /// <summary>
        /// UID prefix for Comment Forums.
        /// </summary>
        public string xmlUIDPrefix;

        /// <summary>
        /// 
        /// </summary>
		public ListDefinition(string SiteURLName, string sXML )
		{
			this.SiteURLName = SiteURLName;

			// Load list definition from xml
			XmlDocument xmldoc = new XmlDocument();
			xmldoc.LoadXml(sXML);
			XmlNode xmlNde;
			
			// name
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/NAME")) != null)
				xmlListName = xmlNde.InnerText;
			

			// LISTLENGTH
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/LISTLENGTH")) != null)
				xmlLength = xmlNde.InnerText;
			else
				xmlLength = "50";

			// TYPE
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/TYPE")) != null)
				xmlType = xmlNde.InnerText;

			// ARTICLETYPE
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/ARTICLETYPE")) != null)
				xmlArticleType = xmlNde.InnerText;

            //Article Date Range Start
            if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/ARTICLESTARTDATE")) != null)
                xmlArticleStartDate = xmlNde.InnerText;

            //Article Date Range End
            if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/ARTICLEENDDATE")) != null)
                xmlArticleEndDate = xmlNde.InnerText;

			// STATUS
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/STATUS")) != null)
				xmlStatus = xmlNde.InnerText;
			 
			// RATING
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/RATING")) != null)
				xmlRating = xmlNde.InnerText;

            // BookMarks
            if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/BOOKMARKCOUNT")) != null)
                xmlBookmarkCount = xmlNde.InnerText;

			// SIGNIFICANCE
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/SIGNIFICANCE")) != null)
				xmlScore = xmlNde.InnerText;

			// DATECREATED
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/DATECREATED")) != null)
				xmlDateCreated = xmlNde.InnerText;
			
			// LASTUPDATED
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/LASTUPDATED")) != null)
				xmlLastUpdated = xmlNde.InnerText;

			// SORTBY
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/SORTBY")) != null)
				xmlOrderBy = xmlNde.InnerText;

            // Comment Forum UID Prefix
            if ((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/COMMENTFORUMUIDPREFIX")) != null)
                xmlUIDPrefix = xmlNde.InnerText;

			// CATEGORIES/CATEGORY/ID
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/CATEGORIES")) != null)
			{
				XmlNodeList xmlNdeLst = xmlNde.SelectNodes("CATEGORY/ID");
				if(xmlNdeLst != null && xmlNdeLst.Count > 0)
				{
					xmlCategories = new string[xmlNdeLst.Count];
					int i=0;
					foreach(XmlNode xmlCatNde in xmlNdeLst)
					{
						xmlCategories[i++] = xmlCatNde.InnerText;
					}
				}
			}

            //Get Array of Key Phrases from XML
            if ( (xmlNde = xmldoc.SelectSingleNode(@"LISTDEFINITION/KEYPHRASES")) != null )
            {
                
                XmlNodeList xmlNdeLst = xmlNde.SelectNodes(@"PHRASE");
                if ( xmlNdeLst != null && xmlNdeLst.Count > 0 )
                {
                    xmlKeyPhrases = new List<Phrase>(xmlNdeLst.Count);
					foreach(XmlNode xmlPhraseNde in xmlNdeLst)
					{
                            
                        XmlNode nameNode = xmlPhraseNde.SelectSingleNode("NAME");
                        XmlNode nspaceNode = xmlPhraseNde.SelectSingleNode("NAMESPACE");

                        Phrase phrase = new Phrase();
                        if (nspaceNode != null)
                        {
                            phrase.NameSpace = nspaceNode.InnerText;
                        }

                        if (nameNode != null)
                        {
                            phrase.PhraseName = nameNode.InnerText;
                        }
                        else
                        {
                            //Legacy XML schema support.
                            phrase.PhraseName = xmlPhraseNde.InnerText;
                        }
                        
						xmlKeyPhrases.Add(phrase);
					}
                }
            }

			// VOTECOUNT
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/VOTECOUNT")) != null)
				xmlVoteCount = xmlNde.InnerText;

			// THREADTYPE
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/THREADTYPE")) != null)
				xmlThreadType = xmlNde.InnerText;

			// EVENTDATE
			if((xmlNde = xmldoc.SelectSingleNode("LISTDEFINITION/EVENTDATE")) != null)
				xmlEventDate = xmlNde.InnerText;
		}

		/// <summary>
		/// Creates appropriate list type
		/// </summary>
		/// <returns>A class derived from ListTypeBase</returns>
		private ListTypeBase GetListType(string ListType)
		{
			switch(ListType)
			{
				case "ARTICLES": return new ListTypeArticles();
				case "FORUMS": return new ListTypeForums();
				case "CLUBS": return new ListTypeClubs();
				case "THREADS": return new ListTypeThreads();
                case "COMMENTFORUMS": return new ListTypeCommentForums();
				case "CATEGORIES": return new ListTypeCategories();
				case "USERS": return new ListTypeUsers();
				case "TOPICFORUMS": return new ListTypeTopicForums();
				case "CAMPAIGNDIARYENTRIES": return new ListTypeCampaignDiaryEntries();
				default: return null;
			}
		}

		/// <summary>
		/// Creates array list of list filters based on xml input parameters
		/// </summary>
		/// <returns>ArrayList of ListFilterBase derived classes</returns>
		private ArrayList CreateListFilterCollection(ListTypeBase ListType)
		{
			ArrayList ListFilterCollection = new ArrayList();

			// Add common filters //

			// SiteID filter
			ListFilterSiteID lfsid = new ListFilterSiteID(ListType);
			if(lfsid.IsSupported())
			{
				ListFilterCollection.Add(lfsid);
			}

			// Moderation filter
			ListFilterModeration lfm = new ListFilterModeration(ListType);
			if(lfm.IsSupported())
			{
				ListFilterCollection.Add(lfm);
			}
			
			// Create filter classes based on what filters we have //

			if(xmlArticleType != null)
			{
				ListFilterArticleType lf = new ListFilterArticleType(ListType, System.Convert.ToInt32(xmlArticleType));
				
				// Only add if supported
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}				
			}

            //Add a filter for article date range.
            if (xmlArticleStartDate != null)
            {
                DateTime startDate, endDate;
                if (xmlArticleStartDate != null && DateTime.TryParse(xmlArticleStartDate, out startDate)
                    && xmlArticleEndDate != null && DateTime.TryParse(xmlArticleEndDate, out endDate))
                {
                    ListFilterArticleDate lfad = new ListFilterArticleDate(ListType, startDate, endDate);
                    if (lfad.IsSupported())
                    {
                        ListFilterCollection.Add(lfad);
                    }
                }
            }

			if(xmlStatus != null)
			{
				ListFilterArticleStatus lf = new ListFilterArticleStatus(ListType, System.Convert.ToInt32(xmlStatus));
				
				// Only add if supported
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

			// Averagerating filter
			if(xmlRating != null)
			{
				// Create Rating filter
				ListFilterRating lf = new ListFilterRating(ListType, System.Convert.ToDouble(xmlRating));
				
				// Only add if supported
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

			// Date Created
			if(xmlDateCreated != null)
			{
				ListFilterDateCreated lf = new ListFilterDateCreated(ListType, System.Convert.ToInt32(xmlDateCreated));

				// Only add if supported
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

			if(xmlScore != null)
			{
				ListFilterSignificance lf = new ListFilterSignificance(ListType, System.Convert.ToInt32(xmlScore));

				// Only add if supported
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

			if(xmlLastUpdated != null)
			{
				ListFilterDateUpdated lf = new ListFilterDateUpdated(ListType, System.Convert.ToInt32(xmlLastUpdated));

				// Only add if supported
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

            // Filter on UID Prefix - CommentForums only.
            if (xmlUIDPrefix != null)
            {
                ListFilterUIDPrefix lf = new ListFilterUIDPrefix(ListType, xmlUIDPrefix);
                if (lf.IsSupported())
                {
                    ListFilterCollection.Add(lf);
                }
            }

			if(xmlCategories != null)
			{
				int [] CategoryIDs = new int[xmlCategories.Length];
				for(int n=0;n<xmlCategories.Length;n++)
				{
					CategoryIDs[n] = System.Convert.ToInt32(xmlCategories[n]);
				}

				ListFilterCategories lf = new ListFilterCategories(ListType, CategoryIDs);

				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

            if ( xmlKeyPhrases != null && xmlKeyPhrases.Count > 0 )
            {
                ListFilterKeyPhrases kpf = new ListFilterKeyPhrases(ListType, xmlKeyPhrases);
                if ( kpf.IsSupported() )
                {
                    ListFilterCollection.Add(kpf);
                }
            }

			if(xmlVoteCount != null)
			{
				ListFilterVoteCount lf = new ListFilterVoteCount(ListType, System.Convert.ToInt32(xmlVoteCount));
				if(lf.IsSupported())
				{
					ListFilterCollection.Add(lf);
				}
			}

            if (xmlBookmarkCount != null)
            {
                ListFilterBookmarkCount lf = new ListFilterBookmarkCount(ListType, System.Convert.ToInt32(xmlBookmarkCount));
                if (lf.IsSupported())
                {
                    ListFilterCollection.Add(lf);
                }
            }

			if(xmlThreadType != null)
			{
				ListFilterThreadType lftt = new ListFilterThreadType(ListType, xmlThreadType);
				if(lftt.IsSupported())
				{
					ListFilterCollection.Add(lftt);
				}
			}

			if(xmlEventDate != null)
			{
				ListFilterEventDate lfed = new ListFilterEventDate(ListType, System.Convert.ToInt32(xmlEventDate));
				if(lfed.IsSupported())
				{
					ListFilterCollection.Add(lfed);
				}
			}
	
			return ListFilterCollection;
		}

		/// <summary>
		/// Creates order by class for type of list and sort option (xmlOrderBy)
		/// </summary>
		/// <param name="ListType"></param>
		/// <returns>New instance of OrderBy class, or null is no such orderby exists</returns>
		private OrderByBase CreateOrderByClass(ListTypeBase ListType)
		{
			// Create order by
			if(xmlOrderBy == "RATING")
			{
				return new OrderByRating(ListType);
			}
			else if(xmlOrderBy == "DATECREATED")
			{
				return new OrderByDateCreated(ListType);
			}
			else if(xmlOrderBy == "DATEUPDATED")
			{
				return new OrderByDateUpdated(ListType);
			}
			else if(xmlOrderBy == "SIGNIFICANCE")
			{
				return new OrderBySignificance(ListType);
			}
			else if(xmlOrderBy == "VOTECOUNT")
			{
				return new OrderByVoteCount(ListType);
			}
			else if(xmlOrderBy == "EVENTDATE")
			{
				return new OrderByEventDate(ListType);
			}
            else if (xmlOrderBy == "BOOKMARKCOUNT")
            {
                return new OrderByBookmarkCount(ListType);
            }
            else if (xmlOrderBy == "COMMENTCOUNT")
            {
                //Very Specific Order By - Order By Comment Count since datePosted.
                return new OrderByCommentForumPostCount( ListType, xmlDateCreated );
            }

			return null;
		}

		/// <summary>
		/// Creates and returns SQL representation of list definition
		/// </summary>
		public string ToSQL()
		{

			// Get list type class
			ListTypeBase ListType = GetListType(xmlType);
			if(ListType == null)
			{
				// This list type is not supported
				return null;
			}

			// Create list filter collection
			ArrayList ListFilterCollection = CreateListFilterCollection(ListType);
			if(ListFilterCollection == null)
			{
				// Something wrong
				return null;
			}

			// Create orderby class for list type
			OrderByBase OrderBy = CreateOrderByClass(ListType);

			// Get inner joins from filters, removing duplicates
			ArrayList InnerJoins = new ArrayList();
			foreach(ListFilterBase filter in ListFilterCollection)
			{
				foreach(InnerJoinEntry ije in filter.InnerJoins)
				{
					if(!InnerJoins.Contains(ije))
					{
						InnerJoins.Add(ije);
					}
				}
			}

			// Get default inner joins from listtype removing duplicates
			foreach(InnerJoinEntry ije in ListType.GetInnerJoins())
			{
				if(!InnerJoins.Contains(ije))
				{
					InnerJoins.Add(ije);
				}
			}


			// Get select fields
			StringCollection SelectFields = ListType.GetSelectFields();
			
			// Get inner joins from orderby, removing duplicates
			if(OrderBy != null && OrderBy.IsSupported())
			{
				foreach(InnerJoinEntry ije in OrderBy.InnerJoins)
				{
					if(!InnerJoins.Contains(ije))
					{
						InnerJoins.Add(ije);
					}
				}
			}

			// Construct select fields string
			string SelectFieldsSQL = "";
			for(int i=0;i<SelectFields.Count;i++)
			{
				SelectFieldsSQL += SelectFields[i] + " as '" + System.Convert.ToString(i) + "'";

				if(i+1 != SelectFields.Count)
				{
					SelectFieldsSQL += ",";
				}
			}

			// Build SQL //

			// CREATE PROCEDURE dlistXXXX
			string createProcedureSQL = "CREATE PROCEDURE dlist" + xmlListName + " @getxml int = 0 as\r\n";

            string noLockSQL = "SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED\r\n";
            
			// GetXML condition
            string getXMLSQL = "if (@getxml <> 0) begin\r\nSELECT xml = '" + ListType.GetXml().InnerXml + "'\r\nRETURN\r\nend\r\n";

			// @SiteID variable
			string siteIDSQL = "declare @SiteID int; set @SiteID = (select SiteID from Sites where URLName = '" + SiteURLName + "');";
			//string SiteIDSQL = "------------------------------[" + xmlType + "]------------------------------\r\n";

			// Select statement
			string SQL = createProcedureSQL + noLockSQL + getXMLSQL; 
			
			SQL += siteIDSQL + "SELECT ";						// SELECT
			SQL += "TOP " + xmlLength + " ";					// TOP n
			SQL += SelectFieldsSQL;								// fields
			SQL += " FROM ";									// FROM
			SQL += ListType.GetSelectTable().ToString();		// table
			
			foreach(InnerJoinEntry ije in InnerJoins)
			{
				string InnerJoin = " INNER JOIN ";				// INNER JOIN
                if (ije.JoinTable.IsSubSelect)
                {
                    //If computed table / subquuery dont do no locks
                    InnerJoin += ije.JoinTable.ToString() + " ON ";
                }
                else
                {
                    //Force No Locks.
                    InnerJoin += ije.JoinTable.ToString() + " WITH(NOLOCK) ON ";	// table WITH(NOLOCK) ON
                }

				// This should be somewhere else
				string WhereClause = "(";
				for(int i = 0; i < ije.Conditions.Count; i++)
				{
					WhereClause += "(" + ije.Conditions[i].ToString() + ")";	// X = Y
				
					if(i+1 != ije.Conditions.Count)
					{
						WhereClause += " AND ";
					}
				}
				WhereClause += ")";

				InnerJoin += WhereClause;

				SQL += InnerJoin;
			}
			
			// Construct where clause
			string WhereClauseSQL = "";
			for(int i=0;i<ListFilterCollection.Count;i++)
			{
				ListFilterBase filter = (ListFilterBase)ListFilterCollection[i];
                if (filter.GetWhereClause().Length > 0)
                {
                    if (WhereClauseSQL.Length > 0)
                    {
                        WhereClauseSQL += " AND ";
                    }
                    WhereClauseSQL += "(";
                    WhereClauseSQL += filter.GetWhereClause();
                    WhereClauseSQL += ")";
                }
			}

			if(WhereClauseSQL.Length != 0)
			{
				SQL += " WHERE ";
				SQL += WhereClauseSQL;									// WHERE expression
			}
			
			if(OrderBy != null && OrderBy.IsSupported())
			{
				SQL += " ORDER BY " + OrderBy.OrderByField.ToString() + " DESC";	// ORDER BY field
			}

			return SQL;
		}
	}
}
