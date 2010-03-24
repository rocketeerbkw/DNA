#pragma once
#include "frontpageelement.h"

class CTextBoxElement :	public CFrontPageElement
{
public:
	CTextBoxElement(CInputContext& inputContext);
	virtual ~CTextBoxElement(void);

public:
	bool CreateNewTextBox(int iSiteID, int iEditorID, int& iNewTextBoxID, int iFrontPagePos = 0, CTDVString* pEditKey = NULL);
	bool DeleteTextBox(int iTextBoxID,int iUserID);

	bool GetTextBoxesForSiteID(int iSiteID, eElementStatus ElementStatus, int iActiveBoxID = 0);
	bool GetTextBoxDetails(int iTextBoxID);

	bool GetTextBoxesForPhrase( int iSiteId, const SEARCHPHRASELIST& phrases, eElementStatus elementstatus );

	bool SetTemplateType(int iTextBoxID, int iType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTitle(int iTextBoxID, const TDVCHAR* psTitle, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetText(int iTextBoxID, const TDVCHAR* psText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetPosition(int iTextBoxID, int iPosition, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageName(int iTextBoxID, const TDVCHAR* psImageName, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetTextBoxType(int iTextBoxID, int iBoxType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetBorderType(int iTextBoxID, int iBorderType, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageWidth(int iTextBoxID, int iImageWidth, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageHeight(int iTextBoxID, int iImageHeight, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetImageAltText(int iTextBoxID, const TDVCHAR* psImageAltText, bool bCommitChanges, int iUserID, const TDVCHAR* psEditKey);
	bool SetKeyPhrases ( int iTextBoxID, const SEARCHPHRASELIST& vPhrases );
	bool GetTextBoxTitle(CTDVString& sTitle, int iElementID = 0);
	bool GetTextBoxText(CTDVString& sText, int iElementID = 0);
	bool GetTextBoxImageName(CTDVString& sImageName, int iElementID = 0);
	bool GetTextBoxImageWidth(int& iImageWidth, int iElementID = 0);
	bool GetTextBoxImageHeight(int& iImageHeight, int iElementID = 0);
	bool GetTextBoxImageAltText(CTDVString& sImageAltText, int iElementID = 0);

	bool CommitTextBoxChanges(int iUserID, const TDVCHAR* psEditKey);
	bool MakePreviewTextBoxesActive(int iSiteID, int iEditorID, int iTextBoxID = 0);
	bool GetNumberOfTextBoxesForSiteID(int iSiteID, int& iNumberOfTextBoxes, eElementStatus ElementStatus = ES_PREVIEW);
protected:
	virtual bool CreateInternalXMLForElement(CDBXMLBuilder& XML);
};
