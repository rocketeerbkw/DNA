// ReviewSubmissionForum.cpp: implementation of the CReviewSubmissionForum class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ReviewSubmissionForum.h"
#include "Forum.h"
#include "GuideEntry.h"
#include "ReviewForum.h"
#include "tdvassert.h"
#include "ProfanityFilter.h"
#include "StoredProcedure.h"
#include "URLFilter.h"
#include "EmailAddressFilter.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CReviewSubmissionForum::CReviewSubmissionForum(CInputContext& inputContext)
:CXMLObject(inputContext)
{

}

CReviewSubmissionForum::~CReviewSubmissionForum()
{

}


/*********************************************************************************

	bool CReviewSubmissionForum::RequestSubmitArticle(int iH2G2ID,int iSiteID,
					const CTDVString& sSubmitterComments,int iSelectedReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	8/14/01
	Inputs:		iH2G2ID - Id of article that we want to submit
				iSiteID - SiteID that it came from 
				sSubmitterComments - text that is in the form - leave empty if no text
				iSelectedReviewForumID - the reviewForum that should be selected
				0 for default
	Outputs:	none
	Returns:	true if a valid xml object was generated, even error messages, 
				false otherwise
	Purpose:	Given the id, generates an xmlobject that contains information
				about valid forums that it can go into.

*********************************************************************************/

bool CReviewSubmissionForum::RequestSubmitArticle(int iH2G2ID, int iSiteID, const CTDVString& sSubmitterComments,int iSelectedReviewForumID)
{

	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		SetError("Database Error");
		return false;
	}

	CTDVString xmlText = "<SUBMIT-REVIEW-FORUM></SUBMIT-REVIEW-FORUM>";

	if (!CreateFromXMLText(xmlText))
	{
		SetError("XML Error");
		return false;
	}

	CTDVString sSubjectName;

	if (!mSP.GetEntrySubjectFromh2g2ID(iH2G2ID,sSubjectName))
	{
		return GracefulError("SUBMIT-REVIEW-FORUM","NO-ARTICLE","The entry doesn't exist","FRONTPAGE","Back to the frontpage");
	}

	CTDVString sURLFriendlyName;

	if (mSP.IsArticleInReviewForum(iH2G2ID,iSiteID))
	{
		CTDVString sArticle = "A";
		sArticle << iH2G2ID;
		return GracefulError("SUBMIT-REVIEW-FORUM","IN_FORUM","The entry is already in a Review Forum",sArticle,sArticle);
	}
	
	if (!mSP.GetReviewForums(iSiteID))
	{
		CTDVString sArticle = "A";
		sArticle << iH2G2ID;
		return GracefulError("SUBMIT-REVIEW-FORUM","NO_FORUM","There are no review forums for this site",sArticle,"Back to article");
	}
	
	CTDVString sReviewForumName;
	int iReviewForumID;
	
	
	CTDVString sArticleXML;
	sArticleXML << "<ARTICLE H2G2ID='" << iH2G2ID << "'>" << sSubjectName << "</ARTICLE>";
	
	if (!AddInside("SUBMIT-REVIEW-FORUM",sArticleXML))
	{
		SetError("XML Error");
		return false;
	}
	
	CTDVString reviewXML ="<REVIEWFORUMS>";;

	while (!mSP.IsEOF())
	{	
		mSP.GetField("ForumName",sReviewForumName);
		iReviewForumID = mSP.GetIntField("ReviewForumID");
		reviewXML << "<FORUMNAME ID='" << iReviewForumID << "'";
		if(iReviewForumID == iSelectedReviewForumID)
		{
			reviewXML << "selected='selected' ";
		}
		
		reviewXML <<">" << sReviewForumName << "</FORUMNAME>";
		mSP.MoveNext();
	}
	
	if (!sSubmitterComments.IsEmpty())
	{
		reviewXML << "<COMMENTS>" << sSubmitterComments <<"</COMMENTS>";
	}
	
	reviewXML << "</REVIEWFORUMS>";
	
	if (!AddInside("SUBMIT-REVIEW-FORUM",reviewXML))
	{
		SetError("XML Error");
		return false;
	}
	
	return true;
}

/*********************************************************************************

	bool CReviewSubmissionForum::SubmittedWithEmptyComments(int iH2G2ID, int iSiteID, const CTDVString& sSubmitterComments,int iSelectedReviewForumID)

	Author:		Dharmesh Raithatha
	Created:	11/6/01
	Inputs:		-
	Outputs:	-
	Returns:	true if successfully created form with no comment error message	
	Purpose:	Creates the form and adds the no comment error message

*********************************************************************************/

bool CReviewSubmissionForum::SubmittedWithEmptyComments(int iH2G2ID, int iSiteID, const CTDVString& sSubmitterComments,int iSelectedReviewForumID)
{
	if (RequestSubmitArticle(iH2G2ID,iSiteID,sSubmitterComments,iSelectedReviewForumID))
	{
		AddInside("REVIEWFORUMS","<ERROR TYPE='NO-COMMENT'>Please enter your comments in the text box</ERROR>");
	}
	else
	{
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CReviewSubmissionForum::SubmitArticle(int iH2G2ID, int iReviewForumID,int iSiteID,int iSubmitterID,const CTDVString& sComments)

	Author:		Dharmesh Raithatha
	Created:	11/6/01
	Inputs:		-
	Outputs:	-
	Returns:	true if article successfully submitted to the reviewforum or an error is produced in xml,false otherwise 
				call GetError to get an error message
	Purpose:	Submits an article to a review forum

*********************************************************************************/

bool CReviewSubmissionForum::SubmitArticle(CUser* pSubmitter,int iH2G2ID, int iReviewForumID,int iSiteID,const CTDVString& sComments)
{
	
	if (pSubmitter == NULL)
	{
		return GracefulError("SUBMIT-REVIEW-FORUM","NO_USERID","You have not logged in!","Login","Login");
	}

	if (sComments.IsEmpty())
	{
		return GracefulError("SUBMIT-REVIEW-FORUM","NO_COMMENT","There should be comments with this click back to back");
	}

	int iSubmitterID = pSubmitter->GetUserID();
	
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		SetError("Database error");
		return false;
	}
	
	CGuideEntry mGuideEntry(m_InputContext);

	if (!mGuideEntry.Initialise(iH2G2ID,0, NULL, true,true,false))
	{
		return GracefulError("SUBMIT-REVIEW-FORUM","NO-ARTICLE","The article doesn't exist","FRONTPAGE","Back to the frontpage");
	}

	//if the article is not submittable for review then override unless the current user is an editor
	if (!mGuideEntry.IsSubmittableForPeerReview() && !pSubmitter->GetIsEditor())
	{
		return GracefulError("SUBMIT-REVIEW-FORUM","NO_SUBMIT","This article is not for review","FRONTPAGE","Back to frontpage");
	}
	
	CTDVString sSubjectName;
	mGuideEntry.GetSubject(sSubjectName);
	int iEditorID = mGuideEntry.GetEditorID();
	
	CTDVString sSubject = "A";
	sSubject << iH2G2ID << " - " << sSubjectName;
	
	CTDVString sArticle = "A";
	sArticle << iH2G2ID;

	if (!mSP.GetUserFromUserID(iEditorID))
	{
		
		
		return GracefulError("SUBMIT-REVIEW-FORUM","NO-USER","Failed to get User details",sArticle,sSubject);
	}

	CTDVString sUserName;
	mSP.GetField("UserName",sUserName);

	CTDVString sEditedComments = "";
	sEditedComments << "Entry: " << sSubjectName << " - A" << iH2G2ID << "\n";
	sEditedComments << "Author: " << sUserName << " - U" << iEditorID <<"\n\n";
	sEditedComments << sComments;

	int iThreadID;
	int iPostID;
	int iForumID;
	CTDVString sError;

	if (!mSP.AddArticleToReviewForumMembers(iH2G2ID,iSubmitterID,iSiteID,iReviewForumID,sSubject,sEditedComments,&iForumID,&iThreadID,&iPostID,&sError))
	{
		SetError(sError);
		return false;
	}

	//set the lastupdatefield on the guideentry
	//this is done by a trigger so update a field to be the same as it already is
	
	mSP.ForceUpdateEntry(iH2G2ID);

	if(iSubmitterID != iEditorID)
	{
		NotifyAuthorOnPersonalSpace(iSubmitterID,iEditorID,sUserName,iH2G2ID,iSiteID,iReviewForumID,iForumID,iThreadID,iPostID,sSubjectName,sComments);
	}

	CTDVString xmlText = "<SUBMIT-REVIEW-FORUM>";
	xmlText << "<ARTICLE H2G2ID='" << iH2G2ID << "'>" << sSubjectName << "</ARTICLE>";
	xmlText << "<NEW-THREAD postid='" << iPostID << "' threadid='" << iThreadID <<"' forumid='" << iForumID << "'>";
	
	CReviewForum mReviewForum(m_InputContext);
	if (mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
	{
		CTDVString sReviewForumXML;
		mReviewForum.GetAsXMLString(sReviewForumXML);
		xmlText <<  sReviewForumXML;
	}
	xmlText << "</NEW-THREAD>";
	xmlText << "</SUBMIT-REVIEW-FORUM>";

	if (!CreateFromXMLText(xmlText))
	{
		SetError("XML Error");
		return false;
	}

	return true;
}

/*********************************************************************************

	bool CReviewSubmissionForum::NotifyAuthorOnPersonalSpace(int iSubmitterID,int iEditorID,const CTDVString& sUserName,int iH2G2ID,int iSiteID,int iReviewForumID,int iForumID,int iThreadID,int iPostID,const CTDVString &sSubject,const CTDVString &sComments)

	Author:		Dharmesh Raithatha
	Created:	11/6/01
	Inputs:		-
	Outputs:	-
	Returns:	true if successfully handled, false otherwise.
	Purpose:	Posts a message to the editor of an article that it has been submitted to a review forum

*********************************************************************************/

bool CReviewSubmissionForum::NotifyAuthorOnPersonalSpace(int iSubmitterID,int iEditorID,const CTDVString& sUserName,int iH2G2ID,int iSiteID,int iReviewForumID,int iForumID,int iThreadID,int iPostID,const CTDVString &sSubject,const CTDVString &sComments)
{
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		SetError("Database error");
		return false;
	}

	int iUserForumID = 0;

	if (!mSP.FetchPersonalSpaceForum(iEditorID, iSiteID, &iUserForumID))
	{
		SetError("Failed to send message to Personal Space");
		return false;
	}

	if (!mSP.GetUserFromUserID(iSubmitterID))
	{
		return GracefulError("SUBMIT-REVIEW-FORUM","NO-USER","Failed to get User details");
	}

	CTDVString sSubmitterName;
	mSP.GetField("UserName",sSubmitterName);

	CReviewForum mReviewForum(m_InputContext);
	if (!mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
	{
		SetError("Failed to initialise review forum");
		return false;
	}
	
	int iNewThreadID,iNewPostID;
	CTDVString sGeneratedSubject = "";

	
	
	sGeneratedSubject << "Your entry has been submitted to '" <<  mReviewForum.GetReviewForumName() << "'";

	CTDVString sGeneratedBody = "";

	sGeneratedBody << "Entry: " << sSubject << " - A" << iH2G2ID << " \n";
	sGeneratedBody << "Author: " << sUserName << " - U" << iEditorID <<" \n";
	sGeneratedBody << "Submitter: " << sSubmitterName << " - U" << iSubmitterID << "\n\n";

	sGeneratedBody << "This is an automated message.\n\n";

	sGeneratedBody << "Your entry above has been submitted to the Review Forum '" <<  mReviewForum.GetReviewForumName() << "'" 
				   << " by the Researcher named above. For more information about what happens next check out <./>ReviewForums-Next</.>.\n\n";
	
	sGeneratedBody << "You can see the discussion about your entry at " <<  "F" << iForumID << "?thread=" << iThreadID << "\n\n";

	sGeneratedBody << "If you'd rather your entry wasn't in this Review Forum then you can remove it by visiting "
				   << "<./>" << mReviewForum.GetURLFriendlyName() << "</.> and clicking on the relevant 'Remove' link."
				   << " To prevent it being put into a Review Forum in the future, please click on the 'Edit Entry' button and tick the 'Not for Review' box.\n\n";

	if (iForumID > 0)
	{
		// Check the user input for profanities!
		CProfanityFilter ProfanityFilter(m_InputContext);
		CProfanityFilter::FilterState filterState = 
			ProfanityFilter.CheckForProfanities(sGeneratedSubject + " " + sGeneratedBody);

		bool bForceModeration = false;
		if (filterState == CProfanityFilter::FailBlock)
		{
			return false;
		}
		else if (filterState = CProfanityFilter::FailRefer)
		{
			bForceModeration = true;
		}

		if(m_InputContext.IsCurrentSiteURLFiltered() && !(m_InputContext.GetCurrentUser()->GetIsEditor() || m_InputContext.GetCurrentUser()->GetIsNotable()))
		{
			CURLFilter oURLFilter(m_InputContext);
			CURLFilter::FilterState URLFilterState = oURLFilter.CheckForURLs(sGeneratedSubject + " " + sGeneratedBody);
			if (URLFilterState == CURLFilter::Fail)
			{
				//return immediately - these don't get submitted
				return false;
			}
		}

		//Filter for email addresses.
		if ( m_InputContext.IsCurrentSiteEmailAddressFiltered() && !(m_InputContext.GetCurrentUser()->GetIsEditor() || m_InputContext.GetCurrentUser()->GetIsNotable()))
		{
			CEmailAddressFilter emailfilter;
			if ( emailfilter.CheckForEmailAddresses(sGeneratedSubject + " " + sGeneratedBody) )
			{
				//SetDNALastError("CReviewSubmissionForum","EmailAddressFilter","Email Address Found.");
				return false;
			}
		}

		mSP.PostToForum(iSubmitterID, iUserForumID, NULL, NULL, sGeneratedSubject, sGeneratedBody, 2, 
			&iNewThreadID,&iNewPostID,NULL,NULL,bForceModeration );
		return true;
	}


	return true;

}

/*********************************************************************************

	bool CReviewSubmissionForum::RemoveThreadFromForum(CUser& mViewer,int iReviewForumID,int iH2G2ID)

	Author:		Dharmesh Raithatha
	Created:	11/6/01
	Inputs:		-
	Outputs:	-
	Returns:	true if successfully handled, false otherwise
	Purpose:	

*********************************************************************************/

bool CReviewSubmissionForum::RemoveThreadFromForum(CUser& mViewer,int iReviewForumID,int iH2G2ID, int* iThreadID,int* iForumID,bool *pbSuccessful,bool bHasPermission /*false*/)
{
	if (iReviewForumID <= 0 || iH2G2ID <= 0)
	{
		TDVASSERT(false,"Bad ReviewForum ID in CReviewSubmissionForum::RemoveThreadFromForum");
		
		*pbSuccessful = false;
		
		return GracefulError("SUBMIT-REVIEW-FORUM","RMBADID","Bad arguments for this action");
	}
	
	//Initialise the article
	
	CGuideEntry mGuideEntry(m_InputContext);
	
	if (!mGuideEntry.Initialise(iH2G2ID,0, false,true,false,false,false))
	{
		
		*pbSuccessful = false;
		
		return GracefulError("SUBMIT-REVIEW-FORUM","NOARTICLE","Failed to Get Article details");
	}
	
	//create a storedprocedure 
	
	CStoredProcedure mSP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&mSP))
	{
		
		*pbSuccessful = false;
		
		return GracefulError("SUBMIT-REVIEW-FORUM","DBERROR","A database error has occured");
	}
	
	//check the article is in review
	if (!mSP.FetchReviewForumMemberDetails(iH2G2ID))
	{
		
		*pbSuccessful = false;
		
		return GracefulError("SUBMIT-REVIEW-FORUM","BADH2G2ID","The article is not in a review forum");
	}
	
	int iSubmitterID = mSP.GetIntField("SubmitterID");
	int iPostID = mSP.GetIntField("PostID");
	*iThreadID = mSP.GetIntField("ThreadID");
	*iForumID = mSP.GetIntField("ForumID");
	int iActualReviewForumID = mSP.GetIntField("ReviewForumID");
	
	//make sure that we are in the right review forum for the article
	if (iReviewForumID != iActualReviewForumID)
	{
		
		*pbSuccessful = false;
		
		return GracefulError("SUBMIT-REVIEW-FORUM","BADRFID","The article is in a different review forum");
	}
	
	//Permission has been verified by the caller so don't check
	if (!bHasPermission)
	{
		//ok if you're an editor
		if (!mViewer.GetIsEditor())
		{
			//ok if you are the author
			if (!(mGuideEntry.GetEditorID() == mViewer.GetUserID()))
			{
				//ok if you are the submitter
				if (!(mViewer.GetUserID() == iSubmitterID))
				{
					
					*pbSuccessful = false;
					
					return GracefulError("SUBMIT-REVIEW-FORUM","BADUSER","You do not have permission to move the thread");
				}
			}
		}
	}
	
	//initialise the review forum
	CReviewForum mReviewForum(m_InputContext);
	
	if (!mReviewForum.InitialiseViaReviewForumID(iReviewForumID))
	{
		*pbSuccessful = false;	
		return GracefulError("SUBMIT-REVIEW-FORUM","NOREVIEW","Invalid Review Forum ID");
	}
	
	//move the thread	
	mSP.MoveThread(*iThreadID,mGuideEntry.GetForumID());
	
	if (!mSP.GetBoolField("Success"))
	{
		*pbSuccessful = false;	
		return GracefulError("SUBMIT-REVIEW-FORUM","NOMOVE","Failed to move thread to article");
	}
	
	if (!mSP.RemoveArticleFromPeerReview(iH2G2ID))
	{
		mSP.UndoThreadMove(*iThreadID,0);

		if (!mSP.GetBoolField("Success"))
		{
			*pbSuccessful = false;
			return GracefulError("SUBMIT-REVIEW-FORUM","HALFMOVE","The thread has been moved, but not from review");
		}
		else
		{
			*pbSuccessful = false;
			return GracefulError("SUBMIT-REVIEW-FORUM","NOMOVE","Failed to move thread to article");
		}
	}
	
	//Update the entry
	mSP.ForceUpdateEntry(iH2G2ID);
	
	//update the post details
	CTDVString sPostSubject,sPostText,sNewSubject;
	
	mSP.FetchPostDetails(iPostID);
	mSP.GetField("Subject",sPostSubject);
	mSP.GetField("Text",sPostText);
	
	sNewSubject = mReviewForum.GetReviewForumName();
	sNewSubject << ": " << sPostSubject;
	mSP.UpdatePostDetails(NULL,iPostID,sNewSubject,sPostText,NULL,false,false,true);
	
	//update the thread first subject details
	mSP.UpdateThreadFirstSubject(*iThreadID,sNewSubject);
	//post the success story
	
	CTDVString sArticleSubject; 
	mGuideEntry.GetSubject(sArticleSubject);
	
	CTDVString xmlText = "";
	xmlText << "<SUBMIT-REVIEW-FORUM><MOVEDTHREAD>"
		<< "<H2G2ID>" << iH2G2ID << "</H2G2ID>"
		<< "<SUBJECT>" << sArticleSubject << "</SUBJECT>"
		<< "<REVIEWFORUM ID='" << iReviewForumID << "'>"
		<< "<REVIEWFORUMNAME>" << mReviewForum.GetReviewForumName() << "</REVIEWFORUMNAME>"
		<< "<URLFRIENDLYNAME>" << mReviewForum.GetURLFriendlyName() << "</URLFRIENDLYNAME>"
		<< "</REVIEWFORUM></MOVEDTHREAD></SUBMIT-REVIEW-FORUM>";
	
	if (!CreateFromXMLText(xmlText))
	{
		*pbSuccessful = false;	
		return GracefulError("SUBMIT-REVIEW-FORUM","XMLERROR","There was an XML error");
	}
	
	*pbSuccessful = true;
	return true;
}

bool CReviewSubmissionForum::GracefulError(const TDVCHAR* pOuterTag,const TDVCHAR* pErrorType,const TDVCHAR* pErrorText/*=NULL*/,
										   const TDVCHAR* pLinkHref/*NULL*/,const TDVCHAR* pLinkBody/*NULL*/)
{

	if (pOuterTag == NULL || pErrorType == NULL)
	{
		SetError("An error ocurred and we were unable to fail gracefully");
		return false;
	}

	Destroy();

	CTDVString errorXML;
	errorXML << "<" << pOuterTag << ">";
	errorXML << "<ERROR TYPE='";
	errorXML << pErrorType << "'>";
	if (pErrorText != NULL)
	{
		errorXML << "<MESSAGE>" << pErrorText << "</MESSAGE>";
	}
	if (pLinkHref != NULL && pLinkBody != NULL)
	{
		errorXML << "<LINK HREF='" << pLinkHref << "'>" << pLinkBody << "</LINK>";
	}

	errorXML << "</ERROR>" << "</" << pOuterTag << ">";

	if(!CreateFromXMLText(errorXML))
	{
		SetError("XML Error");
		return false;
	}

	return true;

}

void CReviewSubmissionForum::SetError(const TDVCHAR* pErrorText)
{
	CTDVString sErrorText = pErrorText;
	EscapeXMLText(&sErrorText);
	m_sErrorText = sErrorText;
}

const CTDVString& CReviewSubmissionForum::GetError()
{
	return m_sErrorText;
}
