#pragma once

#if defined (_ADMIN_VERSION)

#include "xmlbuilder.h"

#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "User.h"
#include "TDVString.h"
#include "XMLBuilder.h"
#include "ImageModeration.h"
#include "ModerationEmail.h"
#include "UploadedImage.h"


/*
	class CImageModerationBuilder

	Author:		Kim Harries
	Created:	01/02/2001
	Inherits:	CXMLBuilder
	Purpose:	Builds the XML for the page allowing staff to moderate forum
				postings.
*/

class CImageModerationBuilder : public CXMLBuilder  
{
	protected:

		class CFormParams
		{
			public:
				int m_iImageId;
				int m_iModId;
				int m_iStatus;
				int m_iReferTo;
				int m_iSiteId;
				CTDVString m_sEmailType;
				CTDVString m_sCustomText;
				CTDVString m_sNotes;

			public:
				CFormParams() : m_iImageId(0),  m_iModId(0), 
					m_iStatus(0), m_iReferTo(0), m_iSiteId(0) {;}
				void ReadFormParams(CInputContext& inputContext, int i);
		};

		CFormParams m_Form;
		CTDVString m_sCommand;
		CTDVString m_sErrorXML;
		CImageModeration m_ImageModeration;
		CModerationEmail m_Email;
		CUploadedImage m_Image;

		typedef map<int, const char*> CEmailNameMap;
		static CEmailNameMap m_AuthorEmailMap;
		static CEmailNameMap m_ComplainantEmailMap;

	public:
		CImageModerationBuilder(CInputContext& inputContext);
		~CImageModerationBuilder();
		bool Build(CWholePage* pPage);

	protected:

		bool ProcessSubmission(CUser* pViewer);
		bool CreateForm(CUser* pViewer,  CTDVString& sFormXml);
		bool EmailAuthor();
		bool EmailComplainant();
		const CSubst& GetEmailParams(bool bReferral, CSubst& subst);
		void ReadFormParams(int i);
		bool ValidateParameters();
};

#endif // _ADMIN_VERSION
