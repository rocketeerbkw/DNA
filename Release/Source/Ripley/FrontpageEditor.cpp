// FrontpageEditor.cpp: implementation of the CFrontpageEditor class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ripleyserver.h"
#include "PageBody.h"
#include "FrontpageEditor.h"
#include "FrontPageLayout.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CFrontPageEditor::CFrontPageEditor(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CFrontPageEditor::~CFrontPageEditor()
{

}

bool CFrontPageEditor::Build(CWholePage* pPageXML)
{
	InitPage(pPageXML, "FRONTPAGE-EDITOR", true);
	CPageBody PageBody(m_InputContext);
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	int iSiteID = m_InputContext.GetSiteID();
	bool bFrontPagePreview = false;
	bool bErrorsFound = false;

	if(m_InputContext.GetIsInPreviewMode())
	{
		// flag it up if we're editing a MessageBoard config version
		// using the preview version will have
		//url: /FrontPageEditor?_previewmode=1
		bFrontPagePreview = true;
	}

	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pPageXML->SetPageType("ERROR");
		pPageXML->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot administer a site unless you are logged in as an Editor.</ERROR>");
		return true;
	}

	// Check to see if we're previewing or storing the page
	if (m_InputContext.ParamExists("Preview") || m_InputContext.ParamExists("Storepage"))
	{
		CTDVString sText;
		m_InputContext.GetParamString("bodytext", sText);

		CTDVString sDate;
		m_InputContext.GetParamString("date", sDate);

		CTDVString sError = CXMLObject::ParseXMLForErrors(sText);

		if (!sError.IsEmpty())
		{
			CTDVString sXML = "<FRONTPAGE-PREVIEW-PARSEERROR>";
			sXML << sError << "</FRONTPAGE-PREVIEW-PARSEERROR>";
			pPageXML->AddInside("H2G2",sXML);
			bErrorsFound = true;
		}
		else
		{
			CTDVString sXML = "<ARTICLE>";
			sXML << sText << "</ARTICLE>";
			pPageXML->AddInside("H2G2", sXML);

			if (m_InputContext.ParamExists("Storepage"))
			{
				CTDVDateTime dDate;
				if (sDate.IsEmpty() || dDate.ParseDateTime(sDate))
				{
					// Actually store it here...
					CStoredProcedure SP;
					m_InputContext.InitialiseStoredProcedureObject(&SP);
					
					if(!bFrontPagePreview)
					{
						SP.UpdateFrontpage(iSiteID, "frontpage", sText, pViewer->GetUserID(), sDate, NULL);
					}
					else
					{
						// Setup and initialise the frontpagelayout object
						CFrontPageLayout FPL(m_InputContext);
						if (!FPL.InitialisePageBody(m_InputContext.GetSiteID(),true))
						{
							// Get the last error from the object
							pPageXML->AddInside("H2G2","<ERROR TYPE='FRONTPAGEERROR'>" + FPL.GetLastErrorMessage() + "</ERROR>");
							bErrorsFound = true;
						}
						else
						{
							// Now set the new text and update the preview
							if (!FPL.SetFrontPageBodyText(sText))
							{
								// Get the last error from the object
								pPageXML->AddInside("H2G2","<ERROR TYPE='BODYUPDATE'>" + FPL.GetLastErrorMessage() + "</ERROR>");
								bErrorsFound = true;
							}

							// Update the preview
							bool bEditedByAnotherUser = false;
							CTDVString sEditKey;
							m_InputContext.GetParamString("EditKey", sEditKey);
							if (!FPL.UpdateFrontPagePreview(pViewer->GetUserID(), sEditKey, bEditedByAnotherUser) || bEditedByAnotherUser)
							{
								// We've either had an error or it's being edited by another user! Get the error from the objct
								pPageXML->AddInside("H2G2","<ERROR TYPE='UPDATEPREVIEW'>" + FPL.GetLastErrorMessage() + "</ERROR>");
								bErrorsFound = true;
							}
						}
					}
				}
				else
				{
					CTDVString sXML = "<FRONTPAGE-PREVIEW-PARSEERROR>The date you supplied was faulty.</FRONTPAGE-PREVIEW-PARSEERROR>";
					pPageXML->AddInside("H2G2",sXML);
					bErrorsFound = true;
				}
			}
		}

		CTDVString sSkin;
		m_InputContext.GetParamString("skin", sSkin);
		int iRegistered = 0;
		if (m_InputContext.ParamExists("registered"))
		{
			iRegistered = 1;
		}
		AddEditForm(pPageXML, "", sText, sSkin, sDate, iRegistered);
	}
	else
	{
		CTDVString sPageType;
		sPageType << "xmlfrontpage";
		if(bFrontPagePreview)
		{
			// get xmlfrontpagepreview instead
			sPageType << "preview";
		}
		PageBody.Initialise(sPageType, iSiteID);
		CTDVString sSubject;
		CTDVString sBody;
		PageBody.GetSubject(&sSubject);
		PageBody.GetBodyText(&sBody);
		AddEditForm(pPageXML, sSubject, sBody, "", "", 1);
		PageBody.AddInside("ARTICLE", "<PREVIEWREGISTERED>1</PREVIEWREGISTERED>");
		pPageXML->AddInside("H2G2", &PageBody);
	}

	// Check to see if we've been given a redirect? Only do this if we've had no errors!
	if (!bErrorsFound)
	{
		if (CheckAndUseRedirectIfGiven(pPageXML))
		{
			// return true as we've done the redirect, nothing else should be done!
			return true;
		}
	}

	return true;
}

bool CFrontPageEditor::AddEditForm(CWholePage *pPageXML, const TDVCHAR *pSubject, const TDVCHAR *pBody, const TDVCHAR *pSkin, const TDVCHAR* pDate, int iRegistered)
{
	CTDVString sSubject(pSubject);
	CTDVString sBody(pBody);
	CTDVString sDate(pDate);
	CXMLObject::EscapeAllXML(&sSubject);
	CXMLObject::EscapeAllXML(&sBody);
	CXMLObject::EscapeAllXML(&sDate);
	CTDVString sXML;
	sXML = "<FRONTPAGE-EDIT-FORM><SUBJECT>";
	sXML << sSubject << "</SUBJECT>";
	sXML << "<BODY>" << sBody << "</BODY>";
	sXML << "<REGISTERED>" << iRegistered << "</REGISTERED>";
	sXML << "<SKIN>" << pSkin << "</SKIN>";
	sXML << "<DATE>" << sDate << "</DATE>";
	sXML << "</FRONTPAGE-EDIT-FORM>";
	pPageXML->AddInside("H2G2", sXML);
	return true;
}
