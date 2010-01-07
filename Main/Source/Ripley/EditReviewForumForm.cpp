// EditReviewForumForm.cpp: implementation of the CEditReviewForumForm class.
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
#include "EditReviewForumForm.h"
#include "ReviewForum.h"
#include "GuideEntry.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CEditReviewForumForm::CEditReviewForumForm(CInputContext& inputContext)
:CXMLObject(inputContext)
{

}

CEditReviewForumForm::~CEditReviewForumForm()
{

}

/*********************************************************************************

	bool CEditReviewForumForm::CreateFromDB(int iReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	11/14/01
	Inputs:		iReviewForumID - 
	Outputs:	-
	Returns:	true if created from database or if it generated a proper error, 
				false, if it is a fatal problem
	Purpose:	Creates the EditReviewForumForm with data from the reviewforum

*********************************************************************************/

bool CEditReviewForumForm::CreateFromDB(int iReviewForumID, int iCurrentSiteID)
{
	CTDVString sXML = "<EDITREVIEWFORM>";
	CReviewForum mReviewForum(m_InputContext);
	
	bool bSuccess = true;

	if (!mReviewForum.InitialiseViaReviewForumID(iReviewForumID,true))
	{
		sXML << "<ERROR TYPE='BADID'>Invalid Review Forum ID</ERROR>";
		bSuccess = false;
	}

	if (bSuccess && mReviewForum.GetSiteID() != iCurrentSiteID)
	{
		sXML << "<ERROR TYPE='SITE'>This review forum does not belong to this site</ERROR>";
		bSuccess = false;
	}

	if (bSuccess)
	{
		CTDVString sReviewForumXML;
		mReviewForum.GetAsXMLString(sReviewForumXML);
		sXML << sReviewForumXML;
	}

	sXML << "</EDITREVIEWFORM>";
	
	if (!CreateFromXMLText(sXML))
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CEditReviewForumForm::RequestUpdate(int iReviewForumID,const CTDVString& sName,const CTDVString& sURL,bool bRecommendable,int iIncubateTime)

	Author:		Dharmesh Raithatha
	Created:	11/14/01
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Updates the review forum with the supplied data if it is valid, otherwise
				produces the form with valid error messages, false if it didn't handle the request

*********************************************************************************/

bool CEditReviewForumForm::RequestUpdate(int iReviewForumID,const CTDVString& sName,const CTDVString& sURL,bool bRecommendable,int iIncubateTime, int iCurrentSiteID)
{
	//check that the site the request is from is the same as the site for the reviewforum

	bool bSuccess = true;

	CTDVString sXML = "<EDITREVIEWFORM>";

	CReviewForum mReviewForum(m_InputContext);
	
	if (!mReviewForum.InitialiseViaReviewForumID(iReviewForumID,true))
	{
		sXML << "<ERROR TYPE='BADID'>The review forum id is invalid</ERROR>";
		bSuccess = false;
	}

	CTDVString sReviewForumXML;
	mReviewForum.GetAsXMLString(sReviewForumXML);

	if (bSuccess && mReviewForum.GetSiteID() != iCurrentSiteID)
	{
		sXML << "<ERROR TYPE='SITE'>This review forum does not belong to this site</ERROR>";
		bSuccess = false;
	}

	if (bSuccess)
	{
		if (!mReviewForum.Update(sName,sURL,bRecommendable,iIncubateTime))
		{
			sXML << "<ERROR TYPE='UPDATE'>Error occured while updating</ERROR>";
		}
		else
		{
			//get the updated string here and output 

			mReviewForum.GetAsXMLString(sReviewForumXML);
			
			sXML << "<SUCCESS TYPE='UPDATE'/>";
			sXML << sReviewForumXML;
		}		
	}
	else 
	{
		//if the update has failed then use the old review forum data
		if (!sReviewForumXML.IsEmpty())
		{
			sXML << sReviewForumXML;
		}
	}
	
	sXML << "</EDITREVIEWFORM>";
	if (!CreateFromXMLText(sXML))
	{
		return false;
	}

	return true;

}


/*********************************************************************************

	bool CEditReviewForumForm::DoAddNew(const CTDVString& sName,const CTDVString& sURL,bool bRecommendable,int iIncubateTime, int iCurrentSiteID, int iUserID)

	Author:		Dharmesh Raithatha
				Nick Stevenson
	Created:	01/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-
	
*********************************************************************************/

bool CEditReviewForumForm::DoAddNew(const CTDVString& sName,const CTDVString& sURL,bool bRecommendable,int iIncubateTime, int iCurrentSiteID, int iUserID)
{

	//check that the site the request is from is the same as the site for the reviewforum

	bool bSuccess = true;

	CTDVString sXML = "<EDITREVIEWFORM>";

	if (bSuccess && sName.IsEmpty())
	{
		sXML << "<ERROR TYPE='BADNAME'>The review forum name is invalid</ERROR>";
		bSuccess = false;
	}

	
	if (bSuccess && sURL.IsEmpty() || sURL.Find(" ") >= 0)
	{
		sXML << "<ERROR TYPE='BADURL'>The url name is invalid</ERROR>";
		bSuccess = false;
	}

	
	if (bSuccess && iIncubateTime < 0)
	{
		sXML << "<ERROR TYPE='BADINCUBATE'>The incubate time is invalid</ERROR>";
		bSuccess = false;
	}

	CReviewForum mReviewForum(m_InputContext);

	bool bUnique = false;
	bSuccess = bSuccess && mReviewForum.AreNamesUniqueWithinSite(sName,sURL,iCurrentSiteID,&bUnique);
	
	if (bSuccess && !bUnique)
	{
		sXML << "<ERROR TYPE='BADNAMES'>The names supplied already exist for this site</ERROR>";
		bSuccess = false;
	}

	//parameters are valid so add the new review forum
	if (bSuccess)
	{
		
		CTDVString sReviewForumXML;
		

		if (!mReviewForum.CreateAndInitialiseNewReviewForum(sName,sURL,iIncubateTime,bRecommendable,iCurrentSiteID, iUserID))
		{
			//failed to add so dump data back out with an error message
			sXML <<"<BLANKFORM></BLANKFORM>";
			sXML <<"<ERROR TYPE='ADDNEW'>There was an error while adding the review forum</ERROR>";
			mReviewForum.InitialiseFromData(0,sName,sURL,iIncubateTime,bRecommendable,NULL,iCurrentSiteID);
			
			mReviewForum.GetAsXMLString(sReviewForumXML);
			sXML << sReviewForumXML;
		}
		else
		{
			//success so put the review forum details into the update form
			sXML << "<SUCCESS TYPE='ADDNEW'/>";
			mReviewForum.GetAsXMLString(sReviewForumXML);
			sXML << sReviewForumXML;
		}
	}
	//an error occurred somewhere above with the parameters so just dump the info back out
	else
	{
		CReviewForum mReviewForum(m_InputContext);
		CTDVString sReviewForumXML;
		sXML <<"<BLANKFORM></BLANKFORM>";
		mReviewForum.InitialiseFromData(0,sName,sURL,iIncubateTime,bRecommendable,NULL,iCurrentSiteID);
		

		mReviewForum.GetAsXMLString(sReviewForumXML);
		sXML << sReviewForumXML;
	}
	
	sXML << "</EDITREVIEWFORM>";
	if (!CreateFromXMLText(sXML))
	{
		return false;
	}

	return true;
}
