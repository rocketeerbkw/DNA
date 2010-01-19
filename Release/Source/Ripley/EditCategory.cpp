// EditCategory.cpp: implementation of the EditCategory class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"
#include "tdvassert.h"
#include "EditCategory.h"
#include "GuideEntry.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CEditCategory::CEditCategory(CInputContext& inputContext)
:CXMLObject(inputContext), m_iSiteID(1)
{

}

CEditCategory::~CEditCategory()
{

}

/*********************************************************************************

	bool CEditCategory::Initialise()

	Author:		Dharmesh Raithatha
	Created:	7/26/01
	Inputs:		-
	Outputs:	-
	Returns:	true if successful
	Purpose:	returns a basic EditCategoryObject

*********************************************************************************/


bool CEditCategory::Initialise(int iSiteID)
{
	m_iSiteID = iSiteID;
	
	CTDVString xmltext = "";
	xmltext << "<EDITCATEGORY></EDITCATEGORY>";
	if (!CreateFromXMLText(xmltext))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CEditCategory::NavigateWithSubject(int iActiveSubjectID,int iCurrentNodeID,int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the id of the active subject node id,the current Node Id,
	Outputs:	New Destination in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the user navigate with
				a selected subject or if given zero does default navigation

*********************************************************************************/

bool CEditCategory::NavigateWithSubject(int iActiveSubjectID,int iCurrentNodeID,int &iDestinationNodeID)
{
	//set it to root as default
	iDestinationNodeID = 0;

	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"NavigateWithSubject"))
	{
		return false;
	}

	CTDVString xmltext = "<EDITCATEGORY>";

	if(iActiveSubjectID > 0)
	{
		CTDVString sDescription,sName;
		int iParentID;
		int ih2g2ID;
		CTDVString Synonyms;
		int iUserAdd;
		int iNodeID;
		int iTypeID;
		
		//get the information from the database about the ActiveSubjectId
		if (!SP.GetHierarchyNodeDetailsViaNodeID(iActiveSubjectID,&sName,&sDescription,&iParentID, &ih2g2ID, &Synonyms,&iUserAdd,&iNodeID, &iTypeID))
		{
			return false;
		}
		
		xmltext << "<ACTIVENODE activeid='" << iActiveSubjectID << "' type='subject'>" << sName << "</ACTIVENODE>";
	}
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeID = iCurrentNodeID;
	
	//make sure that we are operating on an empty tree
	Destroy();
	return CreateFromXMLText(xmltext);
}


/*********************************************************************************

	bool CEditCategory::NavigateWithArticle(int iH2G2ID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the id of the article,the current Node Id, the original position of the article
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the user navigate with
				a selected article or if given zero does default navigation

*********************************************************************************/

bool CEditCategory::NavigateWithArticle(int iH2G2ID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"NavigateWithArticle"))
	{
		return true;
	}
	
	CTDVString xmltext = "<EDITCATEGORY>";
	if(iH2G2ID > 0)
	{
		
		
		//get the Subject name of the H2G2ID
		if (!SP.FetchGuideEntryDetails(iH2G2ID))
		{
			SetDNALastError("CEditCategory::NavigateWithArticle","NavigateWithArticle","That article doesn't exist.","14");
			xmltext << GetLastErrorAsXMLString();
			//xmltext << "<ERROR type = '14'>That article doesn't exist</ERROR>";
		}
		else
		{
			CTDVString sName;
			SP.GetField("Subject",sName);
			int iType = SP.GetIntField("Type");
			xmltext << "<ACTIVENODE ACTIVEID='" << iH2G2ID << "' TYPE='article'" << " TYPEID='" << iType << "' DELNODE='" << iOriginalPosNodeID << "'>" << sName << "</ACTIVENODE>";
		}
	}
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeID = iCurrentNodeID;
	
	//make sure that we are operating on an empty tree
	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::NavigateWithClub(int iClubID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)

	Author:		Mark Neves
	Created:	7/7/03
	Inputs:		the id of the club,the current Node Id, the original position of the article
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the user navigate with
				a selected club or if given zero does default navigation

*********************************************************************************/

bool CEditCategory::NavigateWithClub(int iClubID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"NavigateWithClub"))
	{
		return true;
	}
	
	CTDVString xmltext = "<EDITCATEGORY>";
	if(iClubID > 0)
	{
		CTDVString sName;

		bool bSuccess = false;

		if (!SP.FetchClubDetailsViaClubID(iClubID,bSuccess))
		{
			SetDNALastError("Club","Database","An Error occurred while accessing the database");
			xmltext << GetLastErrorAsXMLString();
			return false;
		}

		if (!bSuccess)
		{
			CTDVString err = "That club ";
			err << iClubID << " doesn't exist";
			SetDNALastError("CEditCategory::NavigateWithClub","NavigateWithClub",err,"14");
			xmltext << GetLastErrorAsXMLString();
			//xmltext << "<ERROR type = '14'>That club " << iClubID << " doesn't exist</ERROR>";
		}
		else
		{
			SP.GetField("Name",sName);
			int iTypeID = SP.GetIntField("Type");
			xmltext << "<ACTIVENODE ACTIVEID='" << iClubID << "' TYPE='club'" << " TYPEID='" << iTypeID << "' DELNODE='" << iOriginalPosNodeID << "'>" << sName << "</ACTIVENODE>";
		}
	}
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeID = iCurrentNodeID;
	
	//make sure that we are operating on an empty tree
	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::NavigateWithALias(int iAliasID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the id of the alias node,the current Node Id, the original position of the article
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the user navigate with
				a selected alias or if given zero does default navigation

*********************************************************************************/

bool CEditCategory::NavigateWithAlias(int iAliasID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"NavigateWithAlias"))
	{
		return false;
	}
	
	CTDVString xmltext = "<EDITCATEGORY>";
	if(iAliasID > 0)
	{
		CTDVString sDescription,sName;
		int iParentID;
		int ih2g2ID;
		CTDVString Synonyms;
		int iUserAdd;	
		int iNodeID;
		int iTypeID;
		if (!SP.GetHierarchyNodeDetailsViaNodeID(iAliasID,&sName,&sDescription,&iParentID, &ih2g2ID, &Synonyms,&iUserAdd,&iNodeID,&iTypeID))
		{
			SetDNALastError("CEditCategory::NavigateWithAlias","NavigateWithAlias","That Alias doesn't exist","15");
			xmltext << GetLastErrorAsXMLString();
			//xmltext << "<ERROR type='15'>That alias doesn't exist</ERROR>";
		}
		else
		{
			xmltext << "<ACTIVENODE ACTIVEID='" << iAliasID << "' TYPE='alias'" << " DELNODE='" << iOriginalPosNodeID << "'>" << sName << "</ACTIVENODE>";
		}
	}
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeID = iCurrentNodeID;
	
	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::NavigateWithThread(int iThreadID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)

	Author:		Martin Robb
	Created:	26/04/05
	Inputs:		the id of the thread ,the current Node Id, the original position of the thread
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the user navigate with
				a selected thread / notice.

*********************************************************************************/

bool CEditCategory::NavigateWithThread(int iThreadID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"NavigateWithThread"))
	{
		return true;
	}
	
	CTDVString xmltext = "<EDITCATEGORY>";

	//Get Forum ID.
	int iForumID = 0;
	int iSiteID = 0;
	CTDVString sName;
	if ( iThreadID > 0 && !SP.GetForumSiteID(iForumID, iThreadID, iSiteID ) )
	{
		SetDNALastError("CEditCategory::NavigateWithThread","NavigateWithThread","An Error occurred while accessing stored procedure.");
		xmltext << GetLastErrorAsXMLString();
		return false;
	}

	if ( !SP.IsEOF() )
	{
		//Get Title of thread / Notice
		if ( !SP.ForumGetNoticeInfo(iForumID, iThreadID ) )
		{
			SetDNALastError("CEditCategory::NavigateWithThread","ForumGetNoticeInfo","An Error occurred while accessing stored procedure.");
			xmltext << GetLastErrorAsXMLString();
			return false;
		}
		
		if ( SP.IsEOF() ) 
		{
			SetDNALastError("CEditCategory::NavigateWithThread","ForumGetNoticeInfo","Notice does not exist.");
			xmltext << GetLastErrorAsXMLString();
		}
		else
		{
			SP.GetField("Subject",sName);
			xmltext << "<ACTIVENODE ACTIVEID='" << iThreadID << "' TYPE='THREAD'" << " DELNODE='" << iOriginalPosNodeID << "'>" << sName << "</ACTIVENODE>";
		}
	}
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeID = iCurrentNodeID;
	
	//make sure that we are operating on an empty tree
	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::NavigateWithUser(int iThreadID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)

	Author:		Martin Robb
	Created:	05/05/05
	Inputs:		the id of the user ,the current Node Id, the original position of the thread
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the user navigate nodes with a userId.

*********************************************************************************/

bool CEditCategory::NavigateWithUser(int iUserID, int iCurrentNodeID, int iOriginalPosNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"NavigateWithUser"))
	{
		return true;
	}
	
	CTDVString xmltext = "<EDITCATEGORY>";

	if ( iUserID > 0 && !SP.GetUserDetailsFromID(iUserID, m_InputContext.GetSiteID()) )
	{
		SetDNALastError("CEditCategory::NavigateWithUser","GetUserDetailsFromID","An Error occurred while executing stored procedure.");
		xmltext << GetLastErrorAsXMLString();
		return false;
	}

	if ( !SP.IsEOF() )
	{	
		CTDVString sName;
		SP.GetField("UserName",sName);
		xmltext << "<ACTIVENODE ACTIVEID='" << iUserID << "' TYPE='USER'" << " DELNODE='" << iOriginalPosNodeID << "'>" << sName << "</ACTIVENODE>";
	}
	else
	{
		SetDNALastError("CEditCategory::NavigateWithUser","GetUserDetailsFromID","User does not exist");
		xmltext << GetLastErrorAsXMLString();
	}
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeID = iCurrentNodeID;
	
	//make sure that we are operating on an empty tree
	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::NavigateToSameCategory(int iCurrentNodeID, int &iDestinationNodeID)

	Author:		Mark Neves
	Created:	08/07/2003
	Inputs:		the current Node Id, and the destination node
	Outputs:	Destination node is set to the current node
	Returns:	true if successful
	Purpose:	The purpose of this function is to navigate to the same category page once an operation
				is complete, or has has been aborted.
				Side effects are:
					- iDestinationNodeID is set to the value of iCurrentNodeID (i.e. stay on same category)
					- The XML is updated with an empty <EDITCATEGORY> tag, hence removing any active node
					  in the process

*********************************************************************************/

bool CEditCategory::NavigateToSameCategory(int iCurrentNodeID,int &iDestinationNodeID)
{
	// Set the destination to the current category
	iDestinationNodeID = iCurrentNodeID;

	// set XML to an empty <EDITCATEGORY> tag
	Destroy();
	CTDVString xmltext = "<EDITCATEGORY></EDITCATEGORY>";
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::RenameSubject(int iNodeId, int &iDestinationNodeId)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the current Node Id
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the xsl know to allow the
				User to rename a subject

*********************************************************************************/

bool CEditCategory::RenameSubject(int iNodeId, int &iDestinationNodeId)
{
	CTDVString xmltext = "<EDITCATEGORY>";
	xmltext <<"<EDITINPUT TYPE='renamesubject'>";
	xmltext << "</EDITINPUT>";
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeId = iNodeId;
	
	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool CEditCategory::ChangeDescription(int iNodeId, int &iDestinationNodeId)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the current Node Id
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the xsl know to allow the
				User to change the description

*********************************************************************************/

bool CEditCategory::ChangeDescription(int iNodeId, int &iDestinationNodeId)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"ChangeDescription"))
	{
		return false;
	}
	
	CTDVString xmltext = "<EDITCATEGORY>";
	CTDVString sDescription,sName;
	int iParentID;
	int ih2g2ID;
	CTDVString Synonyms;
	int iUserAdd;
	int iNodeID;
	int iTypeID;
	if (!SP.GetHierarchyNodeDetailsViaNodeID(iNodeId,&sName,&sDescription,&iParentID, &ih2g2ID, &Synonyms,&iUserAdd,&iNodeID, &iTypeID))
	{
		return false;
	}
	
	//this is to be displayed in a form so escape it so it displays properly.
	EscapeAllXML(&sDescription);

	xmltext <<"<EDITINPUT TYPE='changedescription'>";
	xmltext << sDescription << "</EDITINPUT>";
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeId = iNodeId;

	Destroy();
	return CreateFromXMLText(xmltext);
}


/*********************************************************************************

	bool CEditCategory::AddSubject(int iNodeId, int &iNewNodeId)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the current Node Id
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Creates an EditCategory XML Node that lets the xsl know to allow the
				User to add a subject

*********************************************************************************/

bool CEditCategory::AddSubject(int iNodeId, int &iDestinationNodeId)
{

	CTDVString xmltext = "<EDITCATEGORY>";
	xmltext <<"<EDITINPUT TYPE='addsubject'>";
	xmltext << "</EDITINPUT>";
	xmltext << "</EDITCATEGORY>";
	iDestinationNodeId = iNodeId;

	Destroy();
	return CreateFromXMLText(xmltext);
}

/*********************************************************************************

	bool StoreAlias(int iAliasID,int iNewNodeId,int iOldNodeId, int &iDestinationNodeId)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the aliasid, the node where it is to be stored, where the alias was originally
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Stores the alias at the new location and deletes from the previous location

*********************************************************************************/

bool CEditCategory::StoreAlias(int iAliasID,int iNewNodeID,int iOldNodeID, int &iDestinationNodeID)
{
	//add the new alias
	if (!DoAddAlias(iAliasID,iNewNodeID,iDestinationNodeID))
	{
		//start back at the root node
		if (NavigateWithAlias(iAliasID,iNewNodeID,iOldNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::StoreAlias","Store Alias","Unable to add the alias to the hierarchy","1" );
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '1'>Unable to add the alias to the hierarchy</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		else
		{
			return false;
		}
	}

	//now delete the old alias as we are moving the alias 
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"StoreAlias"))
	{
		return true;
	}

	if (!SP.DeleteAliasFromHierarchy(iAliasID,iOldNodeID))
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithAlias(iAliasID,iNewNodeID,iOldNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::StoreAlias", "DeleteAliasFromHierarchy","The alias has been moved but was not deleted from previous destination, please delete manually","3");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '3'>The alias has been moved but was not deleted from previous destination, please delete manually</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		else
		{
			return false;
		}
	}
	
	return NavigateToSameCategory(iNewNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool MoveSubject(int iActiveSubjectID,int iNodeID,int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the subject nodeid, the node where it is to be stored
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Moves the subject to the new position

*********************************************************************************/

bool CEditCategory::MoveSubject(int iActiveSubjectID,int iNodeID,int &iDestinationNodeID)
{

	//check that you are not storing within yourself as that will be freaky.

	if (iActiveSubjectID == iNodeID)
	{
		//start back at the root node
		if (NavigateWithSubject(iActiveSubjectID,0,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::MoveSubject","NavigateWithSubject","You cannot store a subject within itself","4");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '4'>You cannot store a subject within itself</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		else
		{
			return false;
		}
	}

	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"MoveSubject"))
	{
		return false;
	}

	//move the node to where 
	CTDVString sErrorReason;
	if (iNodeID > 0 && !SP.MoveHierarchyNode(iNodeID,iActiveSubjectID,sErrorReason))
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithSubject(iActiveSubjectID,iNodeID,iDestinationNodeID))
		{
			CTDVString sreason = "Unable to move node" ;
			sreason << sErrorReason;
			SetDNALastError("CEditCategory::MoveSubject","MoveHierarchyNode",sreason,"5");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror;
			//xmlerror << "<ERROR type = '5'>Unable to move node (" << sErrorReason << ")</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;

	}

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool StoreArticle(int iH2G2ID,int iNodeID,int iOldNodeID,int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the h2g2id, the node where it is to be stored, the node where it was
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Moves the article to the new position and deletes its reference from the
				old one
*********************************************************************************/

bool CEditCategory::StoreArticle(int iH2G2ID,int iNodeID,int iOldNodeID,int &iDestinationNodeID)
{
	//now delete the old alias as we are moving the alias 
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"StoreArticle"))
	{
		return true;
	}

	bool bSuccess = true;
	CUser* pViewingUser = m_InputContext.GetCurrentUser();
	if(iNodeID > 0 && !(SP.AddArticleToHierarchy(iNodeID,iH2G2ID, pViewingUser->GetUserID(), bSuccess) || !bSuccess) )
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithArticle(iH2G2ID,iNodeID,iOldNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::StoreArticle","AddArticleToHierarchy","Unable to move article","6");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '6'>Unable to move article</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;

	}

	//suceeded so delete from article from the old place

	if (iOldNodeID > 0 && (!SP.DeleteArticleFromHierarchy(iH2G2ID,iOldNodeID,bSuccess) || !bSuccess) )
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithArticle(iH2G2ID,iNodeID,iOldNodeID,iDestinationNodeID))
		{
			//CTDVString xmlerror = "<ERROR type = '7'>The article has been moved but was not deleted from previous destination, please delete manually</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			SetDNALastError("CEditCategory::StoreArticle","DeleteArticleFromHierarchy","The article has been moved but was not deleted from previous destination, please delete manually","7");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			return true;
		}
		else
		{
			return false;
		}
	}

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool StoreClub(int iClubID,int iNodeID,int iOldNodeID,int &iDestinationNodeID)

	Author:		Mark Neves
	Created:	8/7/03
	Inputs:		the clubid, the node where it is to be stored, the node where it was
	Outputs:	New Position in hierarchy to display at
	Returns:	false if fatal error occured, true otherwise
	Purpose:	Moves the club to the new position and deletes its reference from the
				old one
*********************************************************************************/

bool CEditCategory::StoreClub(int iClubID,int iNodeID,int iOldNodeID,int &iDestinationNodeID)
{
	CStoredProcedure SP;
		
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"StoreClub"))
	{
		return true;
	}

	if (iNodeID > 0 && iClubID > 0)
	{
		bool bSuccess = false;
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		if (!SP.AddClubToHierarchy(iNodeID,iClubID, pViewingUser->GetUserID(), bSuccess))
		{
			SetDNALastError("CEditCategory::StoreClub","Database","An Error occurred while accessing the database");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			return false;
		}

		if (!bSuccess)
		{
			SP.Release();  // Release as soon as no longer needed
			if (NavigateWithClub(iClubID,iNodeID,iOldNodeID,iDestinationNodeID))
			{
				SetDNALastError("CEditCategory::StoreClub","NavigateWithClub","Unable to move Club","6");
				AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
				//CTDVString xmlerror = "<ERROR type = '6'>Unable to move club</ERROR>";
				//AddInside("EDITCATEGORY",xmlerror);
			}
			return true;
		}
	}

	//suceeded so delete from article from the old place

	if (iOldNodeID > 0)
	{
		bool bSuccess = false;
		if (!SP.DeleteClubFromHierarchy(iClubID,iOldNodeID,bSuccess))
		{
			SetDNALastError("CEditCategory::StoreClub","Database","An Error occurred while accessing the database");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			return false;
		}

		if (!bSuccess)
		{
			SP.Release();  // Release as soon as no longer needed
			if (NavigateWithClub(iClubID,iNodeID,iOldNodeID,iDestinationNodeID))
			{
				SetDNALastError("CEditCategory::StoreClub","StoreClub","The club has been moved but was not deleted from previous destination, please delete manually","7");
				AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
				//CTDVString xmlerror = "<ERROR type = '7'>The club has been moved but was not deleted from previous destination, please delete manually</ERROR>";
				//AddInside("EDITCATEGORY",xmlerror);
			}
			return false;
		}
	}

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool AddNewArticle(int iH2G2ID,int iNodeID,int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	14/01/2002
	Inputs:		the h2g2id, the node where it is to be stored, the node where it was
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Adds an article to the node if it isnt already there
*********************************************************************************/

bool CEditCategory::AddNewArticle(int iH2G2ID,int iNodeID,int &iDestinationNodeID)
{
	//now delete the old alias as we are moving the alias 
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"AddNewArticle"))
	{
		return true;
	}


	if (iNodeID > 0 && CGuideEntry::IsValidChecksum(iH2G2ID))
	{
		bool bSuccess = true;
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		if(!(SP.AddArticleToHierarchy(iNodeID, iH2G2ID, pViewingUser->GetUserID(), bSuccess) && bSuccess) )
		{
			SP.Release();  // Release as soon as no longer needed
			if (NavigateToSameCategory(iNodeID,iDestinationNodeID))
			{
				SetDNALastError("CEditCategory::AddNewArticle","AddNewArticle","This article is already present","18");
				AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
				//CTDVString xmlerror = "<ERROR type = '18'>This article is already present</ERROR>";
				//AddInside("EDITCATEGORY",xmlerror);
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return NavigateToSameCategory(iNodeID,iDestinationNodeID);
		}
	}
	else
	{
		if (NavigateToSameCategory(iNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::AddNewArticle","AddNewArticle","Unvalid h2g2id","19");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '19'>Invalid h2g2id</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}

		return false;
	}

	return false;

}

/*********************************************************************************

	bool AddNewClub(int iClubID,int iNodeID,int &iDestinationNodeID,bool& bSuccess)

	Author:		Mark Neves
	Created:	7/7/03
	Inputs:		the clubid, the node where it is to be stored, the node where it was
	Outputs:	iDestinationNodeID - New Position in hierarchy to display at
				bSuccess Whether the club was added to that node
	Returns:	true if successful
	Purpose:	Adds a club to the node if it isnt already there
*********************************************************************************/

bool CEditCategory::AddNewClub(int iClubID,int iNodeID,int &iDestinationNodeID,bool& bSuccess)
{
	//now delete the old alias as we are moving the alias 
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"AddNewClub"))
	{
		return false;
	}

	CTDVString sXMLErrMsg;

	if (iNodeID > 0 && iClubID > 0)
	{
		bSuccess = false;
		CUser* pViewingUser = m_InputContext.GetCurrentUser();
		if(!SP.AddClubToHierarchy(iNodeID,iClubID,pViewingUser->GetUserID(), bSuccess))
		{
			SetDNALastError("CEditCategory","Database","An Error occurred while accessing the database");
			return false;
		}

		if (!bSuccess)
		{
			SetDNALastError("CEditCategory::AddNewClub","AddNewClub","This club is already present","18");
			sXMLErrMsg = GetLastErrorAsXMLString();
		}
	}
	else
	{
		CTDVString serr = "Invalid nodeid ";
		serr << iNodeID;
		SetDNALastError("CEditCategory::AddNewClub","AddNewClub",serr,"18");
		sXMLErrMsg = GetLastErrorAsXMLString();
	}

	SP.Release();  // Release as soon as no longer needed
	NavigateToSameCategory(iNodeID,iDestinationNodeID);

	if (sXMLErrMsg.GetLength() > 0)
	{
		AddInside("EDITCATEGORY",sXMLErrMsg);
	}

	return true;
}

/*********************************************************************************

	bool DoAddAlias(int iAliasID,int iNodeID,int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the aliasId, the node where it is to be stored
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Adds an alias reference in the given node in the hierarchy
*********************************************************************************/

bool CEditCategory::DoAddAlias(int iAliasID,int iNodeID,int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DoAddAlias"))
	{
		return false;
	}

	if(iNodeID > 0 && !SP.AddAliasToHierarchy(iNodeID,iAliasID))
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithSubject(iAliasID,iNodeID,iDestinationNodeID))
		{
			//CTDVString xmlerror = "<ERROR type = '8'>Unable to store alias</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			SetDNALastError("CEditCategory::DoAddAlias","DoAddAlias","Unable to store Alias","8");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			return true;
		}
		return false;
	}
	
	//success

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool DoAddSubject(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewSubject, int &iNewSubjectID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the nodeId you are at, the subject to add 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Adds a subject at the current spot
*********************************************************************************/

bool CEditCategory::DoAddSubject(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewSubject, int &iNewSubjectID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DoAddSubject"))
	{
		return false;
	}

	if(iNodeID > 0 && !SP.AddNodeToHierarchy(iNodeID,pNewSubject,iNewSubjectID,m_iSiteID) )
	{
		SP.Release();  // Release as soon as no longer needed
		bool bSuccess = AddSubject(iNodeID,iDestinationNodeID);
		if (bSuccess)
		{
			//CTDVString xmlerror = "<ERROR type = '9'>There is a subject that already has that name</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			SetDNALastError("CEditCategory::DoAddSubject","DoAddSubject","There is a subject that already has that name","9");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			return true;
		}
		return false;
		
	}
	
	//succeeded so navigate subject with no active node
	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool DoChangeDescription(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewDescription)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the nodeId you are at, the description 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Changes the description for a node
*********************************************************************************/

bool CEditCategory::DoChangeDescription(int iNodeID,int &iDestinationNodeID,const TDVCHAR* sNewDescription)
{	
	//make sure that the description is formatted correctly - bolt on guide tags before parsing
	CTDVString sDescription = "<GUIDE><BODY>";
		sDescription << sNewDescription << "</BODY></GUIDE>";

	CTDVString m_ParseErrorXML = CXMLObject::ParseXMLForErrors(sDescription);
	if (!m_ParseErrorXML.IsEmpty())
	{
		bool bSuccess = ChangeDescription(iNodeID,iDestinationNodeID);
		if (bSuccess)
		{
			//CTDVString xmlerror = "<ERROR type = '10'>You have entered invalid xml</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			SetDNALastError("CEditCategory::DoChangeDescription","DoChangeDescription","You have entered invalid xml","10");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			return true;
		}
		return false;
	}

	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DoChangeDescription"))
	{
		return false;
	}

	if (iNodeID > 0 && !SP.UpdateHierarchyDescription(iNodeID,sNewDescription,1))
	{
		SP.Release();  // Release as soon as no longer needed
		//cannot update the description so let the user try again and let them know that something went wrong
		bool bSuccess = ChangeDescription(iNodeID,iDestinationNodeID);
		if (bSuccess)
		{
			SetDNALastError("CEditCategory::DoChangeDescription","DoChangeDescription","Failed to change the description in the database","11");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '11'>Failed to change the description in the database</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;
	}
	
	//succeeded so navigate subject with no active node
	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool DoRenameSubject(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewSubjectName, const TDVCHAR* pNewSynonyms)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the nodeId you are at, the subject 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Changes the subject for a node
*********************************************************************************/

bool CEditCategory::DoRenameSubject(int iNodeID,int &iDestinationNodeID,const TDVCHAR* pNewSubjectName)
{	
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DoRenameSubject"))
	{
		return false;
	}

	//attempt to update the subject name but first escape it
	CTDVString sSubjectName = pNewSubjectName;

	//We shouldn't be escaping the content as it goes into the database
	//EscapeAllXML(&sSubjectName);

	if(iNodeID > 0 && !SP.UpdateHierarchyDisplayName(iNodeID,sSubjectName))
	{
		SP.Release();  // Release as soon as no longer needed
		//couldn't update so inform user
		bool bSuccess = RenameSubject(iNodeID,iDestinationNodeID);
		if (bSuccess)
		{
			SetDNALastError("CEditCategory::DoRenameSubject","DoRenameSubject","Unable to change the subject title","12");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '12'>Unable to change the subject name</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;

	}

	//succeeded so navigate subject with no active node
	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool CEditCategory::DoUpdateSynonyms(int iNodeID, const TDVCHAR* sSynonyms,
						int &iDestinationNodeID))

	Author:		Dharmesh Raithatha
	Created:	7/9/2003
	Inputs:		iNodeID - the node to associate the synonyms with
				sSynonyms - the synonyms as a single string of keywords/phrases
	Outputs:	iDestinationNodeID - the destionation node
	Returns:	true if successfull, false otherwise
	Purpose:	Updates the synonyms associated with the given node

*********************************************************************************/

bool CEditCategory::DoUpdateSynonyms(int iNodeID, const TDVCHAR* sSynonyms, 
									 int &iDestinationNodeID)
{
	
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DoUpdateSynonyms"))
	{
		return false;
	}

	bool bSuccess = false;

	bool bErr = SP.UpdateHierarchySynonyms(iNodeID,sSynonyms,bSuccess);
	SP.Release();  // Release as soon as no longer needed

	NavigateToSameCategory(iNodeID,iDestinationNodeID);

	if (!bErr || !bSuccess)
	{
		SetDNALastError("CEditCategory::DoUpdateSynonyms","DoUpdateSynonms","Unable to update the synonyms","20");
		AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
		//CTDVString xmlerror = "<ERROR type = '20'>Unable to update the synonyms</ERROR>";
		//AddInside("EDITCATEGORY",xmlerror);	
		
	} 

	return true;
}

/*********************************************************************************

	bool DeleteArticle(int iActiveArticleID, int iNodeID, int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the id of the active article,the nodeId you are at 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Deletes a reference to the article from that node
*********************************************************************************/

bool CEditCategory::DeleteArticle(int iActiveArticleID, int iNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DeleteArticle"))
	{
		return false;
	}

	bool bSuccess = true;
	if(iNodeID  > 0 && (!SP.DeleteArticleFromHierarchy(iActiveArticleID,iNodeID,bSuccess) || !bSuccess) )
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithSubject(iActiveArticleID,iNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::DeleteArticle","DeleteArticle","Unable to delete article","13");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '13'>Unable to delete article</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;
	}

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);

}
 
/*********************************************************************************

	bool DeleteClub(int iActiveClubID, int iNodeID, int &iDestinationNodeID)

	Author:		Mark Neves
	Created:	8/7/03
	Inputs:		the id of the active club,the nodeId you are at 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Deletes a reference to the club from that node
*********************************************************************************/

bool CEditCategory::DeleteClub(int iActiveClubID, int iNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
		
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DeleteClub"))
	{
		return false;
	}

	if(iNodeID  > 0)
	{
		bool bSuccess = false;
		if (!SP.DeleteClubFromHierarchy(iActiveClubID,iNodeID,bSuccess))
		{
			SetDNALastError("CEditCategory::DeleteClub","Database","An Error occurred while accessing the database");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			return false;
		}

		SP.Release();  // Release as soon as no longer needed

		if (bSuccess)
		{
			NavigateToSameCategory(iNodeID,iDestinationNodeID);
		}
		else
		{
			if (NavigateWithClub(iActiveClubID,iNodeID,iNodeID,iDestinationNodeID))
			{
				SetDNALastError("CEditCategory::DeleteClub","DeleteClub","Unable to delete club","22");
				AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
				//CTDVString xmlerror = "<ERROR type = '22'>Unable to delete club</ERROR>";
				//AddInside("EDITCATEGORY",xmlerror);
			}
		}
	}
	else
	{
		NavigateToSameCategory(iNodeID,iDestinationNodeID);
	}

	return true;
}
 
/*********************************************************************************

	bool DeleteSubject(int iActiveSubjectID, int iNodeID, int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the id of the active subject,the nodeId you are at 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Deletes the child node from the given node
*********************************************************************************/

bool CEditCategory::DeleteSubject(int iActiveSubjectID, int iNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;

	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DeleteSubject"))
	{
		return false;
	}
	//delete the subjects

	if(!SP.DeleteNodeFromHierarchy(iActiveSubjectID))
	{
		SP.Release();  // Release as soon as no longer needed
		if (NavigateWithSubject(iActiveSubjectID,iNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::DeleteSubject","DeleteSubject", "Unable to delete subject","14");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '14'>Unable to delete subject</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;
	}

	// Start by navigating to the same node
	NavigateToSameCategory(iNodeID,iDestinationNodeID);

	// Now add in the result XML
	CTDVString sResult;
	SP.GetField("Result",sResult);
	if (sResult.CompareText("HasDescendants"))
	{
		AddInside("EDITCATEGORY", GenerateResultXML(false,sResult));
	}

	return true;
}

/*********************************************************************************

	CTDVString CEditCategory::GenerateResultXML(bool bSuccess,const TDVCHAR* pReason)

		Author:		Mark Neves
        Created:	12/08/2005
        Inputs:		bSuccess = true if the result was good, false otherwise
					pReason = The reason for the result
        Outputs:	-
        Returns:	The XML that describes the inputs
        Purpose:	Centralised place for generating EDITCATEGORYRESULT tags

*********************************************************************************/

CTDVString CEditCategory::GenerateResultXML(bool bSuccess,const TDVCHAR* pReason)
{
	CTDVString sResult = "OK";
	if (!bSuccess)
	{
		sResult = "Failed";
	}

	return CXMLObject::MakeTag("EDITCATEGORYRESULT",
			CXMLObject::MakeTag("RESULT",sResult)+
			CXMLObject::MakeTag("REASON",CTDVString(pReason)));
}

/*********************************************************************************

	bool DeleteAlias(int iAliasID, int iNodeID, int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/06/2001
	Inputs:		the id of the alias,the nodeId you are at 
	Outputs:	New Position in hierarchy to display at
	Returns:	true if successful
	Purpose:	Deletes a reference to the article from that node
*********************************************************************************/

bool CEditCategory::DeleteAlias(int iAliasID, int iNodeID, int &iDestinationNodeID)
{
	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DeleteAlias"))
	{
		return false;
	}

	if(!SP.DeleteAliasFromHierarchy(iAliasID,iNodeID))
	{
		if (NavigateToSameCategory(iNodeID,iDestinationNodeID))
		{
			SetDNALastError("CEditCategory::DeleteAlias","DeleteAlias","Unable to delete alias","15");
			AddInside("EDITCATEGORY",GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '15'>Unable to delete article</ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}
		return false;
	}

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}

/*********************************************************************************

	bool CEditCategory::DoUpdateUserAdd(int iNodeID,int iUserAdd,int &iDestinationNodeID)

	Author:		Dharmesh Raithatha
	Created:	7/14/2003
	Inputs:		iNodeID - The node where the field is to be changed
				iUserAdd - the value of the useradd field
	Outputs:	iDestinationNodeID - the destinationnode for displaying
	Returns:	true handled successfully, false otherwise
	Purpose:	Updates the user add field. This sets the given node to either allow
				or disallow a normal user to add content to the node.

*********************************************************************************/

bool CEditCategory::DoUpdateUserAdd(int iNodeID,int iUserAdd,int &iDestinationNodeID)
{

	CStoredProcedure SP;
	
	// cleanup and return null if we can't get the stored procedure object
	if (!InitialiseStoredProcedureObject(&SP,"DoUpdateUserAdd"))
	{
		return false;
	}

	bool bSuccess = false;
	bool bOk = SP.DoUpdateUserAdd(iNodeID,iUserAdd,bSuccess);
	SP.Release();  // Release as soon as no longer needed

	if (!bOk || !bSuccess)
	{
		if ( NavigateToSameCategory(iNodeID,iDestinationNodeID) )
		{
			SetDNALastError("CEditCategory::DoUpdateUserAdd", "DoUpdateUserAdd","Unable to update the editable status of this node","21");
			AddInside("EDITCATEGORY", GetLastErrorAsXMLString());
			//CTDVString xmlerror = "<ERROR type = '21'>Unable to update the editable status of this node </ERROR>";
			//AddInside("EDITCATEGORY",xmlerror);
			return true;
		}

		return false;
	}

	return NavigateToSameCategory(iNodeID,iDestinationNodeID);
}



/*********************************************************************************

	bool CEditCategory::InitialiseStoredProcedureObject(CStoredProcedure* pSP,
						const TDVCHAR* pFuncName)

	Author:		Mark Neves
	Created:	08/07/2003
	Inputs:		pSP = ptr to the stored procedure object
				sFuncName = the name of the func that's initialising it
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Centralises the initialisation of SP objects for this class.

*********************************************************************************/

bool CEditCategory::InitialiseStoredProcedureObject(CStoredProcedure* pSP,const TDVCHAR* pFuncName)
{
	if (pSP != NULL && pFuncName != NULL)
	{
		if (!m_InputContext.InitialiseStoredProcedureObject(pSP))
		{
			CTDVString sMainMsg;
			sMainMsg << "Failed to create stored procedure in " << pFuncName;
			TDVASSERT(false, sMainMsg);

			SetDNALastError("CEditCategory::InitialiseStoredProcedureObject","InitialiseStoredProcedureObject","DatabaseError","2");
			if (!AddInside("EDITCATEGORY",GetLastErrorAsXMLString()))
			{
				AddInside("H2G2",GetLastErrorAsXMLString());
			}
			return false;
		}
		return true;
	}
	else
	{
		TDVASSERT(false, "NULL parameters passed in");
	}

	return false;
}

