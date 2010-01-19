#include "stdafx.h"
#include ".\moderatemediaassetsbuilder.h"
#include "stdafx.h"
#include "SiteData.h"
#include "WholePage.h"
#include "PageUI.h"
#include "TDVAssert.h"
#include "./emailtemplate.h"
#include "ModerationClasses.h"
#include "ModReasons.h"
#include "RefereeList.h"

#include "MediaAsset.h"
#include "MediaAssetSearchPhrase.h"
#include "MediaAssetModController.h"

//#if defined (_ADMIN_VERSION)

CModerateMediaAssetsBuilder::CModerateMediaAssetsBuilder( CInputContext& InputContext ) : CXMLBuilder(InputContext)
{
	m_AllowedUsers = USER_MODERATOR | USER_EDITOR | USER_ADMINISTRATOR;
}

CModerateMediaAssetsBuilder::~CModerateMediaAssetsBuilder(void)
{
}

bool CModerateMediaAssetsBuilder::Build( CWholePage* pWholePage)
{
	InitPage(pWholePage, "MEDIAASSET-MODERATION", true);
	bool bSuccess = true;

	// do an error page if not an editor or moderator
	// otherwise proceed with the process recommendation page
	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !(pViewer->GetIsEditor() || pViewer->GetIsModerator()))
	{
		bSuccess = bSuccess && pWholePage->SetPageType("ERROR");
		bSuccess = bSuccess && pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot perform moderation unless you are logged in as an Editor or Moderator.</ERROR>");
		return true;
	}

	//Process Actions.
	if ( ! Process(pWholePage,pViewer) )
	{
		SetDNALastError("CModerateMediaAssetsBuilder::Build","Build","Unable to process");
		pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
	}

	//Produce XML for page.

	// find out if we are processing referrals or not
	bool bReferrals = m_InputContext.GetParamInt("Referrals") == 1;
	bool bAlerts = m_InputContext.GetParamInt("Alerts") == 1;
	bool bLockedItems = m_InputContext.GetParamInt("Locked") == 1 && pViewer->GetIsSuperuser();
	bool bHeldItems = m_InputContext.GetParamInt("Held") == 1;
	int iShow = 10;
	if ( m_InputContext.ParamExists("show") )
		iShow = m_InputContext.GetParamInt("show");
	//bool bFastMod = m_InputContext.GetParamInt("fastmod") != 0;

	//Add Moderation Classes
	CModerationClasses modclasses(m_InputContext);
	if ( modclasses.GetModerationClasses() )
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",&modclasses);
	else if ( modclasses.ErrorReported() )
		bSuccess && bSuccess && pWholePage->AddInside("H2G2",modclasses.GetLastErrorAsXMLString() );

	//Add Moderation Failure - Reasons
	CModReasons reasons(m_InputContext);
	if ( reasons.GetModReasons(0) )
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",&reasons);

	//Add Refereee List
	CRefereeList referees(m_InputContext);
	if ( referees.FetchTheList() )
		bSuccess = bSuccess && pWholePage->AddInside("H2G2",&referees);

	//Add Site List
	CTDVString sSiteXML;
	bSuccess = bSuccess && m_InputContext.GetSiteListAsXML(&sSiteXML, 2);
	bSuccess = bSuccess && pWholePage->AddInside("H2G2", sSiteXML);

	CModerateMediaAssets moderate(m_InputContext);
	if ( !moderate.GetAssets( pViewer->GetUserID(), bAlerts, bReferrals, bLockedItems, bHeldItems, iShow ) )
		pWholePage->AddInside("H2G2",moderate.GetLastErrorAsXMLString() );
	else
		pWholePage->AddInside("H2G2",&moderate);

	TDVASSERT(bSuccess, "CModerateMediaAssetsBuilder::Build() failed");
	return bSuccess;
}

/*********************************************************************************

	bool CForumModerationPageBuilder::Process(CWholePage* pPage,CUser* pViewer)

	Author:		Kim Harries
	Created:	01/02/2001
	Inputs:		-
	Outputs:	-
	Returns:	true for success
	Purpose:	Processes any submission of moderation decisions made

*********************************************************************************/

bool CModerateMediaAssetsBuilder::Process(CWholePage* pPage, CUser* pViewer)
{
	bool	bAuthorEmailOK = false;
	bool	bComplainantEmailOK = false;
	bool	bSuccess = true;
	
	int			iAssetID = 0;
	int			iModID = 0;
	int			iStatus = 0;
	int			iReferTo = 0;
	int			iSiteID = -1;
	CTDVString	sNotes;
	int			i = 0;
	int			iThreadModStatus = 0;
	CTDVString	sEmailType;
	CTDVString	sCustomText;
	CTDVString	sMimeType;

	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	CModerateMediaAssets moderate(m_InputContext);
			
	CMediaAssetModController oMAModController(m_InputContext);

	// first get the total number of post IDs in the submission
	// - there should be an equal number of all the other parameters
	int iNumberOfAssets = m_InputContext.GetParamCount("ModID");
	int iProcessed = 0;
	for ( int i = 0; i < iNumberOfAssets; ++i )
	{
		if ( !bSuccess )
			break;

		// get the AssetID and corresponding decision, plus notes if any
		iModID = m_InputContext.GetParamInt("ModID", i);
		iStatus = m_InputContext.GetParamInt("Decision", i);
		iReferTo = m_InputContext.GetParamInt("ReferTo", i);
		iSiteID = m_InputContext.GetParamInt("SiteID", i);
		iAssetID = m_InputContext.GetParamInt("MediaAssetID", i);

		if (!m_InputContext.GetParamString("MimeType", sMimeType, i))
		{
			sMimeType = "";
		}
		
		if (!m_InputContext.GetParamString("Notes", sNotes, i))
		{
			sNotes = "";
		}

		if (!m_InputContext.GetParamString("EmailType", sEmailType, i))
		{
			sEmailType = "None";
		}

		CTDVString sCustomText;
		bool bSuccess = m_InputContext.GetParamString("CustomEmailText", sCustomText, i);

		// do an update for this post only if we have all necessary data
		if (iModID == 0 || iAssetID == 0 || ((iStatus == 4 || iStatus == 6) && sEmailType.CompareText("None")))
			continue;


		CTDVString	sAuthorsEmail;
		CTDVString sComplainantsEmail;
		int IsLegacy = 0;
		int iAuthorID = 0;
		int iComplainantID = 0; 
		if ( moderate.Update(iModID, iSiteID, pViewer->GetUserID(), iStatus, iReferTo, sNotes, sAuthorsEmail, sComplainantsEmail, iAuthorID, iComplainantID) )
		{
			iProcessed++;
			if ( !SendMailOrSystemMessage(iModID, iAssetID, iStatus, iSiteID, sNotes, sCustomText, sEmailType, sAuthorsEmail, sComplainantsEmail, iAuthorID, iComplainantID) )
			{
				pPage->AddInside("H2G2", GetLastErrorAsXMLString());
			}
		}
		else
		{
			pPage->AddInside("H2G2", moderate.GetLastErrorAsXMLString());
		}

		bool bComplaint = false;
		if (sComplainantsEmail.GetLength() > 0 || (m_InputContext.IsSystemMessagesOn(iSiteID) && iComplainantID > 0))
		{
			bComplaint = true;
		}

		if (iStatus == 3) //Pass - then allow the file to be seen by the world
		{
			if (!oMAModController.Approve(iAssetID, sMimeType, bComplaint))
			{
				//If something has gone wrong for this media asset 
				pPage->AddInside("H2G2", oMAModController.GetLastErrorAsXMLString());
				continue;
			}
		}
		else if (iStatus == 2) //Refer - then move the image to .mod on the ftp server (hide it)
		{
			if (!oMAModController.Requeue(iAssetID, sMimeType, bComplaint))
			{
				//If something has gone wrong for this media asset 
				pPage->AddInside("H2G2", oMAModController.GetLastErrorAsXMLString());
				continue;
			}
		}
		else if (iStatus == 4 || iStatus == 6) //Fail - then move the image to .fail on the ftp server (hide it)
		{
			if (!oMAModController.Reject(iAssetID, sMimeType, bComplaint))
			{
				//If something has gone wrong for this media asset 
				pPage->AddInside("H2G2", oMAModController.GetLastErrorAsXMLString());
				continue;
			}
		}

		if (bSuccess)
		{	
			CTDVString	sKeyPhrase;
			CTDVString	sKeyPhrasesToRemove="";
			//Get all the phrases that have been ticked to be disassociated, the param is built from the 
			//index of the asset we are moderating (I add one as it is passed in as the xsl position() which starts from 1)
			//and the name of the input field in the xsl
			CTDVString	sDisassociateListNumber = "DisassociateAssetPhrases" + CTDVString(i+1);
			int iKeyPhrasesToRemove = m_InputContext.GetParamCount(sDisassociateListNumber);
			for (int j = 0; j < iKeyPhrasesToRemove; j++)
			{
				m_InputContext.GetParamString(sDisassociateListNumber, sKeyPhrase, j);
				sKeyPhrasesToRemove = sKeyPhrasesToRemove + sKeyPhrase + "|";

			}
			if (iKeyPhrasesToRemove > 0)
			{
				CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
				CMediaAssetSearchPhrase oMediaAssetKeyPhrase(m_InputContext,delimit);

				oMediaAssetKeyPhrase.RemoveKeyPhrasesFromAsset(iAssetID, sKeyPhrasesToRemove);
			}
		}
	}

	//Create some Feedback XML.
	CTDVString sXML;
	sXML << "<FEEDBACK PROCESSED='" << iProcessed << "'/>";
	pPage->AddInside("H2G2",sXML); 
	return bSuccess;
}

bool CModerateMediaAssetsBuilder::SendEmail( int iModID, int iAssetID, int iStatus, int iSiteID, CTDVString sNotes, CTDVString sCustomText,  CTDVString sEmailType, CTDVString sAuthorsEmail, CTDVString sComplainantsEmail)
{
	CEmailTemplate Email(m_InputContext);

	CTDVString sModeratorsEmail;
	CTDVString sSiteShortName;
	m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
	m_InputContext.GetShortName(sSiteShortName, iSiteID);

	bool bSuccess = true;
	if ( (iStatus == 4 || iStatus == 6) && !sEmailType.CompareText("None"))
	{
		CTDVString sAuthorEmailSubject;
		CTDVString sAuthorEmailText;
		
		if (iStatus == 4)
		{
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"ContentRemovedEmail", sAuthorEmailSubject, sAuthorEmailText);
		}
		else if (iStatus == 6)
		{
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"ContentFailedAndEditedEmail", sAuthorEmailSubject, sAuthorEmailText);

		}

		// do any necessary translations
		CTDVString	sURL = "http://";
		CTDVString	sSiteRootURL;

		// construct the URL for the post
		m_InputContext.GetSiteRootURL(iSiteID,sSiteRootURL);
		sURL << sSiteRootURL << "MediaAsset?id=" << iAssetID << "&action=view";

		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if ( !SP.GetMediaAsset(iAssetID) )
		{
			CTDVString sErr = "Failed to retrieve details for media asset ";
			sErr << iAssetID;
			SetDNALastError("CModerateMediaAssetsBuilder::SendEmail","SendEmail",sErr);
			return false;
		}

		CTDVString sDescription, sCaption;
		SP.GetField("Description",sDescription);
		SP.GetField("Caption",sCaption);

		sAuthorEmailSubject.Replace("++**content_type**++", "Media Asset");
		sAuthorEmailText.Replace("++**content_type**++", "Media Asset");
		sAuthorEmailText.Replace("++**add_content_method**++", "resubmit");
		sAuthorEmailText.Replace("++**content_url**++", sURL);
		sAuthorEmailSubject.Replace("++**content_subject**++", sCaption);
		sAuthorEmailText.Replace("++**content_subject**++", sCaption);
		sAuthorEmailText.Replace("++**content_text**++", sDescription);

		CXMLObject::UnEscapeXMLText(&sAuthorEmailSubject);
		CXMLObject::UnEscapeXMLText(&sAuthorEmailText);

		if (bSuccess)
		{

			//Do replacements.
			if ( !sCustomText.IsEmpty() )
			{
				sAuthorEmailText.Replace("++**inserted_text**++", sCustomText);
			}
			else
			{
				CTDVString sInsertText;
				bSuccess = bSuccess && Email.FetchInsertText(iSiteID,sEmailType, sInsertText);
				CXMLObject::UnEscapeXMLText(&sInsertText);
				sAuthorEmailText.Replace("++**inserted_text**++", sInsertText);
			}
			
			// then send the email
			bSuccess = SendMail(sAuthorsEmail, sAuthorEmailSubject, sAuthorEmailText, sModeratorsEmail, sSiteShortName);
		}

		if(!bSuccess)
		{
			CTDVString sErrorXML = "Email failed to be sent to ";
			sErrorXML <<  sAuthorsEmail;
			SetDNALastError("CModerateMediaAssetsBuilder::SendEmail","SendEmail",sErrorXML);
		}
	}

	// Send Email to complainant if complaint.
	if (sComplainantsEmail.GetLength() > 0 &&  (iStatus == 3 || iStatus == 4 || iStatus == 6))
	{
		CTDVString sComplainantEmailSubject;
		CTDVString sComplainantEmailText;

		// get the appropriate email template depending on whether it is a pass or fail
		if (iStatus == 3)
		{
			// pass => complaint was overruled
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"RejectComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == 4)
		{
			// fail => complaint was upheld

			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"UpholdComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == 6)
		{
			// fail => complaint was upheld
		
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"UpholdComplaintEditEntryEmail", sComplainantEmailSubject, 
				sComplainantEmailText);
		}

		CXMLObject::UnEscapeXMLText(&sComplainantEmailSubject);
		CXMLObject::UnEscapeXMLText(&sComplainantEmailText);

		if ( bSuccess )
		{
			// do any necessary template substitutions
			// => just putting in the complaint reference number currently
			CTDVString	sRefNumber = "MA";
			sRefNumber << iModID;
			sComplainantEmailSubject.Replace("++**reference_number**++", sRefNumber);
			sComplainantEmailText.Replace("++**reference_number**++", sRefNumber);

			// Allow rejected complaints to have some custom text
			// For now re-using the 'CustomEmailText' field since it wouldn't have
			// been used to send something to the author.
			//
			if (iStatus == 3)
			{
				sComplainantEmailText.Replace("++**inserted_text**++", sCustomText);
			}

			// send the email
			bSuccess = bSuccess && SendMail(sComplainantsEmail, 
				sComplainantEmailSubject, sComplainantEmailText, 
				sModeratorsEmail, sSiteShortName);
		}

		if( !bSuccess )
		{
			CTDVString sErrorXML = "Email failed to be sent to complainant ";
			sErrorXML << sComplainantsEmail;
			SetDNALastError("CModerateMediaAssetsBuilder::SendEmail","SendEmail",sErrorXML);
		}
	}
	return bSuccess;
}

bool CModerateMediaAssetsBuilder::SendMailOrSystemMessage( int iModID, int iAssetID, int iStatus, int iSiteID, CTDVString sNotes, CTDVString sCustomText,  CTDVString sEmailType, CTDVString sAuthorsEmail, CTDVString sComplainantsEmail, int iAuthorID, int iComplainantID )
{
	CEmailTemplate Email(m_InputContext);

	CTDVString sModeratorsEmail;
	CTDVString sSiteShortName;
	m_InputContext.GetEmail(EMAIL_MODERATORS, sModeratorsEmail, iSiteID);
	m_InputContext.GetShortName(sSiteShortName, iSiteID);

	bool bSuccess = true;
	if ( (iStatus == 4 || iStatus == 6) && !sEmailType.CompareText("None"))
	{
		CTDVString sAuthorEmailSubject;
		CTDVString sAuthorEmailText;
		
		if (iStatus == 4)
		{
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"ContentRemovedEmail", sAuthorEmailSubject, sAuthorEmailText);
		}
		else if (iStatus == 6)
		{
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"ContentFailedAndEditedEmail", sAuthorEmailSubject, sAuthorEmailText);

		}

		// do any necessary translations
		CTDVString	sURL = "http://";
		CTDVString	sSiteRootURL;

		// construct the URL for the post
		m_InputContext.GetSiteRootURL(iSiteID,sSiteRootURL);
		sURL << sSiteRootURL << "MediaAsset?id=" << iAssetID << "&action=view";

		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		if ( !SP.GetMediaAsset(iAssetID) )
		{
			CTDVString sErr = "Failed to retrieve details for media asset ";
			sErr << iAssetID;
			SetDNALastError("CModerateMediaAssetsBuilder::SendEmail","SendEmail",sErr);
			return false;
		}

		CTDVString sDescription, sCaption;
		SP.GetField("Description",sDescription);
		SP.GetField("Caption",sCaption);

		sAuthorEmailSubject.Replace("++**content_type**++", "Media Asset");
		sAuthorEmailText.Replace("++**content_type**++", "Media Asset");
		sAuthorEmailText.Replace("++**add_content_method**++", "resubmit");
		sAuthorEmailText.Replace("++**content_url**++", sURL);
		sAuthorEmailSubject.Replace("++**content_subject**++", sCaption);
		sAuthorEmailText.Replace("++**content_subject**++", sCaption);
		sAuthorEmailText.Replace("++**content_text**++", sDescription);

		CXMLObject::UnEscapeXMLText(&sAuthorEmailSubject);
		CXMLObject::UnEscapeXMLText(&sAuthorEmailText);

		if (bSuccess)
		{

			//Do replacements.
			if ( !sCustomText.IsEmpty() )
			{
				sAuthorEmailText.Replace("++**inserted_text**++", sCustomText);
			}
			else
			{
				CTDVString sInsertText;
				bSuccess = bSuccess && Email.FetchInsertText(iSiteID,sEmailType, sInsertText);
				CXMLObject::UnEscapeXMLText(&sInsertText);
				sAuthorEmailText.Replace("++**inserted_text**++", sInsertText);
			}
			
			// then send the message to the author
			bSuccess = m_InputContext.SendMailOrSystemMessage(sAuthorsEmail, sAuthorEmailSubject, sAuthorEmailText, sModeratorsEmail, sSiteShortName, false, iAuthorID, iSiteID);
		}

		if(!bSuccess)
		{
			CTDVString sErrorXML = "Email failed to be sent to ";
			sErrorXML <<  sAuthorsEmail;
			SetDNALastError("CModerateMediaAssetsBuilder::SendEmail","SendEmail",sErrorXML);
		}
	}

	// Send Email to complainant if complaint.
	if ((sComplainantsEmail.GetLength() > 0 || (m_InputContext.IsSystemMessagesOn(iSiteID) && iComplainantID > 0)) &&  (iStatus == 3 || iStatus == 4 || iStatus == 6))
	{
		CTDVString sComplainantEmailSubject;
		CTDVString sComplainantEmailText;

		// get the appropriate email template depending on whether it is a pass or fail
		if (iStatus == 3)
		{
			// pass => complaint was overruled
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"RejectComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == 4)
		{
			// fail => complaint was upheld

			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"UpholdComplaintEmail", sComplainantEmailSubject, sComplainantEmailText);

		}
		else if (iStatus == 6)
		{
			// fail => complaint was upheld
		
			bSuccess = bSuccess && Email.FetchEmailText(iSiteID,
				"UpholdComplaintEditEntryEmail", sComplainantEmailSubject, 
				sComplainantEmailText);
		}

		CXMLObject::UnEscapeXMLText(&sComplainantEmailSubject);
		CXMLObject::UnEscapeXMLText(&sComplainantEmailText);

		if ( bSuccess )
		{
			// do any necessary template substitutions
			// => just putting in the complaint reference number currently
			CTDVString	sRefNumber = "MA";
			sRefNumber << iModID;
			sComplainantEmailSubject.Replace("++**reference_number**++", sRefNumber);
			sComplainantEmailText.Replace("++**reference_number**++", sRefNumber);

			// Allow rejected complaints to have some custom text
			// For now re-using the 'CustomEmailText' field since it wouldn't have
			// been used to send something to the author.
			//
			if (iStatus == 3)
			{
				sComplainantEmailText.Replace("++**inserted_text**++", sCustomText);
			}

			// send the email
			bSuccess = bSuccess && m_InputContext.SendMailOrSystemMessage(sComplainantsEmail, 
				sComplainantEmailSubject, sComplainantEmailText, 
				sModeratorsEmail, sSiteShortName, false, iComplainantID, iSiteID);
		}

		if( !bSuccess )
		{
			CTDVString sErrorXML = "Email failed to be sent to complainant ";
			sErrorXML << sComplainantsEmail;
			SetDNALastError("CModerateMediaAssetsBuilder::SendEmail","SendEmail",sErrorXML);
		}
	}
	return bSuccess;
}

bool CModerateMediaAssets::GetAssets( int iUserID, bool bAlerts, bool bReferrals, bool bLockedItems, bool bHeldItems, int iShow )
{
	bool bSuperUser  = m_InputContext.GetCurrentUser() && m_InputContext.GetCurrentUser()->GetIsSuperuser();

	//Get Posts for Moderation.
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	SP.GetModerationMediaAssets( iUserID, bSuperUser, bAlerts, bReferrals, bHeldItems, bLockedItems );

	CTDVString		sXML;
	InitialiseXMLBuilder(&sXML,&SP);

	OpenXMLTag("MEDIAASSETMODERATION", true );

	//These options are exclusive.
	if ( bAlerts )
		AddXMLIntAttribute("ALERTS",1, false);
	else if ( bReferrals )
		AddXMLIntAttribute("REFERRALS",1, false);

	//May be combined with other options.
	if ( bLockedItems )
		AddXMLIntAttribute("LOCKEDITEMS",1, false);

	AddXMLIntAttribute("COUNT", SP.IsEOF() ? 0 : SP.GetIntField("count"),true );

	while (!SP.IsEOF())
	{	
		OpenXMLTag("MEDIAASSET",true);

		CTDVString sFTPPath;
		int iMediaAssetID = SP.GetIntField("MediaAssetID");
		AddXMLIntAttribute("ID", iMediaAssetID);

		AddDBXMLIntAttribute("CONTENTTYPE", "ContentType", false, false);

		AddDBXMLIntAttribute("ModID","MODERATION-ID",true,true);

		AddDBXMLIntTag("modclassId");

		CMediaAsset::GenerateFTPDirectoryString(iMediaAssetID, sFTPPath);

		AddXMLTag("FTPPATH", sFTPPath);

		AddDBXMLIntTag("siteid");

		AddDBXMLTag("filename");
		AddDBXMLTag("caption");
		AddDBXMLTag("mimetype");
		AddDBXMLTag("Description");
		AddDBXMLIntTag("HIDDEN", NULL, false);

		CTDVString sMediaAssetKeyPhrases;
		CTDVString delimit = m_InputContext.GetCurrentSiteOptionString("KeyPhrases","DelimiterToken");
		CMediaAssetSearchPhrase oMediaAssetSearchPhrase(m_InputContext,delimit);
		oMediaAssetSearchPhrase.GetKeyPhrasesFromAsset(iMediaAssetID);
		oMediaAssetSearchPhrase.GetAsString(sMediaAssetKeyPhrases);
		AddXMLTag("", sMediaAssetKeyPhrases);

		if ( bLockedItems )
		{
			OpenXMLTag("LOCKED");
			AddDBXMLDateTag("DATELOCKED");
			OpenXMLTag("USER");
			AddDBXMLIntTag("LOCKEDBY","USERID");
			AddDBXMLTag("LOCKEDNAME","USERNAME");
			AddDBXMLTag("LOCKEDFIRSTNAMES", "FIRSTNAMES");
			AddDBXMLTag("LOCKEDLASTNAME","LASTNAME");
			AddDBXMLIntTag("STATUS");
			CloseXMLTag("USER");
			CloseXMLTag("LOCKED");
		}

		int iComplainantID;
		CTDVString sComplainantName;
		CTDVString sComplainantFirstNames;
		CTDVString sComplainantLastName;
		int iComplainantStatus;
		CTDVString sComplaintText;
		CTDVDateTime dDateSubmitted;
		if ( bAlerts )
		{
			iComplainantID = SP.GetIntField("ComplainantId");
			SP.GetField("ComplainantName",sComplainantName);
			SP.GetField("ComplainantFirstNames",sComplainantFirstNames);
			SP.GetField("ComplainantLastName", sComplainantLastName);
			iComplainantStatus = SP.GetIntField("ComplainantStatus");
			dDateSubmitted = SP.GetDateField("DateSubmitted");
			SP.GetField("ComplaintText",sComplaintText);

		}

		int iReferrerID;
		CTDVString sReferrerName;
		CTDVString sReferrerFirstNames;
		CTDVString sReferrerLastName;
		int iReferrerStatus;
		CTDVString sNotes;
		CTDVDateTime dDateReferred;
		if ( bReferrals )
		{
			iReferrerID = SP.GetIntField("ReferrerId");
			SP.GetField("ReferrerName",sReferrerName);
			SP.GetField("ReferrerFirstNames",sReferrerFirstNames);
			SP.GetField("ReferrerLastName", sReferrerLastName);
			iReferrerStatus = SP.GetIntField("ReferrerStatus");
			SP.GetField("Notes",sNotes);
			dDateReferred = SP.GetDateField("DateReferred");
		}

		bool bIsSiteEditor = SP.GetIntField("IsEditor") == 1;

		std::set<CTDVString> complainantmembertags;
		std::set<CTDVString> usermembertags;
		if ( bIsSiteEditor || bSuperUser )
		{
			OpenXMLTag("USER");
			AddDBXMLIntTag("USERID");
			AddDBXMLTag("USERNAME");
			AddDBXMLTag("FIRSTNAMES");
			AddDBXMLTag("LASTNAME");
			AddDBXMLIntTag("STATUS");
		}
		

		//Get Member Tags.
		int iModID = SP.GetIntField("ModID");
		while ( !SP.IsEOF() && (SP.GetIntField("ModID") == iModID) )
		{
			if ( !SP.IsNULL("UserMemberTag") ) 
			{
				CTDVString sUserMemberTag;
				SP.GetField("UserMemberTag",sUserMemberTag);
				if ( usermembertags.find(sUserMemberTag) == usermembertags.end() )
					usermembertags.insert(sUserMemberTag);
			}

			if ( !SP.IsNULL("ComplainantMemberTag") ) 
			{
				CTDVString sComplainantMemberTag;
				SP.GetField("ComplainantMemberTag",sComplainantMemberTag);
				if ( complainantmembertags.find(sComplainantMemberTag) == complainantmembertags.end() )
					complainantmembertags.insert(sComplainantMemberTag);
			}
			SP.MoveNext();
		}

		if ( !usermembertags.empty() )
		{
			OpenXMLTag("USERMEMBERTAGS");
			for ( std::set<CTDVString>::iterator iter = usermembertags.begin(); iter != usermembertags.end(); ++iter )
				AddXMLTag("USERMEMBERTAG",*iter);
			CloseXMLTag("USERMEMBERTAGS");
		}

		if ( bIsSiteEditor || bSuperUser ) 
			CloseXMLTag("USER");

		//Create the XML from the gathered data.
		if ( bAlerts )
		{
			OpenXMLTag("ALERT");

			//User Details only shown for editors.
			if ( bIsSiteEditor || bSuperUser ) 
			{
				OpenXMLTag("USER");
				AddXMLIntTag("USERID",iComplainantID);
				AddXMLTag("USERNAME",sComplainantName);
				AddXMLTag("FIRSTNAMES", sComplainantFirstNames);
				AddXMLTag("LASTNAME", sComplainantLastName);
				AddXMLIntTag("STATUS",iComplainantStatus);

				//Add the member tags.
				if ( !complainantmembertags.empty() ) 
				{
					OpenXMLTag("USERMEMBERTAGS");
					for ( std::set<CTDVString>::iterator iter = complainantmembertags.begin(); iter != complainantmembertags.end(); ++iter )
						AddXMLTag("USERMEMBERTAG",*iter);
					CloseXMLTag("USERMEMBERTAGS");
				}

				//DBAddTag("ComplainantMemberTag","MEMBERTAG",false);
				CloseXMLTag("USER");
			}
			AddXMLTag("TEXT",sComplaintText);
			AddXMLDateTag("DATEQUEUED",dDateSubmitted);
			CloseXMLTag("ALERT");
		}


		if ( bReferrals )
		{
			OpenXMLTag("REFERRED");

			//Only referrees / editors / superusers can see referred items - stored procedure checks permissions.
			OpenXMLTag("USER");
			AddXMLIntTag("USERID",iReferrerID);
			AddXMLTag("USERNAME",sReferrerName);
			AddXMLTag("FIRSTNAMES", sReferrerFirstNames);
			AddXMLTag("LASTNAME", sReferrerLastName);
			AddXMLIntTag("STATUS",iReferrerStatus);
			CloseXMLTag("USER");
			
			AddXMLTag("TEXT",sNotes);
			AddXMLDateTag("DATEREFERRED",dDateReferred);
			CloseXMLTag("REFERRED");
		}

		CloseXMLTag("MEDIAASSET");
	}

	CloseXMLTag("MEDIAASSETMODERATION");
	return CreateFromXMLText(sXML);
}

bool CModerateMediaAssets::Update(int iModID, int iSiteID, int iUserID, int iStatus, int iReferTo, const CTDVString& sNotes, CTDVString& sAuthorsEmail, CTDVString& sComplainantsEmail, int& iAuthorID, int& iComplainantID)
{
	bool bSuccess = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
	
	if ( !SP.ModerateMediaAsset(iModID, iStatus, sNotes, iReferTo, iUserID) )
	{
		CTDVString sErr = "Unable to update Moderation Item ";
		sErr << iModID;
		CTDVString dberr;
		int code;
		SP.GetLastError(&dberr, code);
		sErr << " - " << dberr;
		SetDNALastError("CModerateAssets::Update","Update",sErr );
		bSuccess = false;
	}

	//Output Params
	bSuccess = bSuccess && SP.GetField("AuthorsEmail", sAuthorsEmail);
	iAuthorID = SP.GetIntField("AuthorID"); 
	bSuccess = bSuccess && SP.GetField("ComplainantsEmail", sComplainantsEmail);
	iComplainantID = SP.GetIntField("ComplainantID"); 

	return bSuccess;
}

bool CModerateMediaAssets::UpdateOnArticleModID(int iArticleModID, int iUserID, int iStatus, int iReferTo, const CTDVString& sNotes, CTDVString& sAuthorsEmail, CTDVString& sComplainantsEmail)
{
	bool bSuccess = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.ModerateMediaAssetByArticleID(iArticleModID, iStatus, sNotes, iReferTo, iUserID))
	{
		bSuccess = false;
	}

	//sAuthorsEmail, sComplainantsEmail,
	return bSuccess;
}
//#endif // _ADMIN_VERSION

