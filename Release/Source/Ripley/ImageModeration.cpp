#include "stdafx.h"
#include ".\imagemoderation.h"
#include "InputContext.h"
#include "ImageLibrary.h"
#include "UploadedImage.h"
#include "XMLObject.h"
#include "Config.h"

const int CImageModeration::PASS = 3;
const int CImageModeration::FAIL = 4;
const int CImageModeration::UNREFER = 5;
const int CImageModeration::FAILEDIT = 6;

CImageModeration::CImageModeration(CInputContext& inputContext)
	:
	m_InputContext(inputContext),
	m_ImageLibrary(inputContext)
{
	m_SP.Initialise(inputContext);
}

CImageModeration::~CImageModeration(void)
{
}

bool CImageModeration::FetchImageModerationBatch(int iUserID, 
	bool bComplaints, bool bReferrals)
{
	m_SP.StartStoredProcedure("getimagemoderationbatch");
	m_SP.AddParam("UserID", iUserID);
	m_SP.AddParam("Complaints", bComplaints);
	m_SP.AddParam("Referrals", bReferrals);
	m_SP.ExecuteStoredProcedure();
	return !m_SP.HandleError("CImageModeration::FetchImageModerationBatch");
}

bool CImageModeration::GetModerationBatchXml(int iUserId, 
	const char* pErrorXml, bool bComplaints,
	bool bReferrals, CTDVString& sXml)
{
	if (!FetchImageModerationBatch(iUserId, bComplaints, bReferrals))
	{
		return false;
	}

	// now build the form XML
	sXml << "<IMAGE-MODERATION-FORM TYPE='" << (bComplaints ? "COMPLAINTS" : "NEW")  << "' REFERRALS='" << bReferrals << "'>";
	if (pErrorXml && pErrorXml[0])
	{
		sXml << pErrorXml;
	}

	if (m_SP.IsEOF())
	{
		sXml << "<MESSAGE TYPE='EMPTY-QUEUE'/>";
	}

	CTDVString sImageLibraryPublicUrlBase = m_InputContext.GetImageLibraryPublicUrlBase();
	CTDVString sImageLibraryRawUrlBase = m_InputContext.GetImageLibraryRawUrlBase();
	CXMLObject::EscapeAllXML(&sImageLibraryPublicUrlBase);
	CXMLObject::EscapeAllXML(&sImageLibraryRawUrlBase);

	sXml << "<IMAGE-PUBLIC-URL-BASE>" << sImageLibraryPublicUrlBase <<
		"</IMAGE-PUBLIC-URL-BASE>";
	sXml << "<IMAGE-RAW-URL-BASE>" << sImageLibraryRawUrlBase <<
		"</IMAGE-RAW-URL-BASE>";

	bool bSuccess = true;
	while (bSuccess && !m_SP.IsEOF())
	{
		int iImageId = m_SP.GetIntField("ImageID");

		sXml << "<IMAGE>";
		sXml << "<MODERATION-ID>" << m_SP.GetIntField("ModID") << "</MODERATION-ID>";
		sXml << "<IMAGE-ID>" << m_SP.GetIntField("ImageID") << "</IMAGE-ID>";

		CTDVString sMime;
		m_SP.GetField("Mime", sMime);

		CTDVString sImageFileName;
		CUploadedImage::MakeFileName(sImageFileName, iImageId, sMime, m_InputContext);
		CXMLObject::EscapeAllXML(&sImageFileName);
		sXml << "<IMAGE-FILE-NAME>" << sImageFileName << "</IMAGE-FILE-NAME>";

		CTDVString sImageDescription;
		m_SP.GetField("Description", sImageDescription);
		CXMLObject::EscapeAllXML(&sImageDescription);
		sXml << "<IMAGE-DESCRIPTION>" << sImageDescription << "</IMAGE-DESCRIPTION>";

		sXml << "<MODERATION-STATUS>" << m_SP.GetIntField("Status") 
			<< "</MODERATION-STATUS>";

		CTDVString sNotes;
		m_SP.GetField("Notes", sNotes);
		CXMLObject::EscapeAllXML(&sNotes);
		sXml << "<NOTES>" << sNotes << "</NOTES>";

		sXml << "<COMPLAINANT-ID>" << m_SP.GetIntField("ComplainantID") 
			<< "</COMPLAINANT-ID>";

		CTDVString sCorrespondenceEmail;
		m_SP.GetField("CorrespondenceEmail", sCorrespondenceEmail);
		CXMLObject::EscapeAllXML(&sCorrespondenceEmail);
		sXml << "<CORRESPONDENCE-EMAIL>" << sCorrespondenceEmail << "</CORRESPONDENCE-EMAIL>";

		CTDVString sComplaintText;
		m_SP.GetField("ComplaintText", sComplaintText);
		CXMLObject::EscapeAllXML(&sComplaintText);
		sXml << "<COMPLAINT-TEXT>" << sComplaintText << "</COMPLAINT-TEXT>";

		sXml << "<SITEID>" << m_SP.GetIntField("SiteID") << "</SITEID>";

		// if referrals then output the referrers details
		if (bReferrals)
		{
			sXml << "<REFERRED-BY>";
			sXml << "<USER>";
			sXml << "<USERID>" << m_SP.GetIntField("ReferrerID") << "</USERID>";

			CTDVString sReferrerName;
			m_SP.GetField("ReferrerName", sReferrerName);
			sXml << "<USERNAME>" << sReferrerName << "</USERNAME>";

			sXml << "</USER>";
			sXml << "</REFERRED-BY>";
		}
		sXml << "</IMAGE>";
		m_SP.MoveNext();
	}
	sXml << "</IMAGE-MODERATION-FORM>";

	return true;
}


bool CImageModeration::UnreferImage(const CUploadedImage& image, 
	int iModId, const char* pNotes)
{
	return ModerateImage(image, iModId, UNREFER, pNotes, 0, 0);
}


bool CImageModeration::ModerateImage(const CUploadedImage& image, 
	int iModId,
	int iStatus, const char* pNotes, int iReferredBy, int iReferTo)
{
	m_SP.StartStoredProcedure("moderateimage");
	m_SP.AddParam("ImageID", image.GetId());
	m_SP.AddParam("ModID", iModId);
	m_SP.AddParam("Status", iStatus);
	m_SP.AddParam("Notes", (pNotes ? pNotes : ""));
	m_SP.AddParam("ReferTo", iReferTo);
	m_SP.AddParam("ReferredBy", iReferredBy);
	m_SP.ExecuteStoredProcedure();

	// get the details of the author and complainant
	m_SP.GetField("AuthorsEmail", m_sAuthorsEmail);
	m_iAuthorID = m_SP.GetIntField("AuthorID"); 
	m_SP.GetField("ComplainantsEmail", m_sComplainantsEmail);
	m_iComplainantID = m_SP.GetIntField("ComplainantID"); 

	if (m_SP.HandleError("CImageModeration::ModerateImage"))
	{
		return false;
	}

	if (iStatus == FAIL || iStatus == PASS || iStatus == FAILEDIT)
	{
		if (iStatus == FAIL)
		{
			return (m_ImageLibrary.Reject(image) == CImageLibrary::ERR_OK);
		}
		else
		{
			return (m_ImageLibrary.Approve(image) == CImageLibrary::ERR_OK);
		}
	}

	return true;
}