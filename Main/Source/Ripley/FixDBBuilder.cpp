#include "stdafx.h"
#include "GuideEntry.h"
#include "FixDBBuilder.h"
#include "StoredProcedure.h"

/*********************************************************************************
class CGuideEntryXML : public CGuideEntry

Author:		Igor Loboda
Created:	11/05/2004
Purpose:	simply to get to the xml tree inside guide entry
*********************************************************************************/

class CGuideEntryXML : public CGuideEntry
{
	public:
		CGuideEntryXML(CInputContext& inputContext);
		bool BodyIsEmpty();
		bool GetDescription(CTDVString& description);
};


/*********************************************************************************
bool CGuideEntryXML::GetDescription(CTDVString& description)

Author:		Igor Loboda
Created:	11/05/2004
Outputs:	description - content of the description tag.
Returns:	false if an error occured
*********************************************************************************/

bool CGuideEntryXML::GetDescription(CTDVString& description)
{
	if (m_pTree == NULL)
	{
		return false;
	}
	
	CXMLTree* pDesc = m_pTree->FindFirstTagName("DESCRIPTION");
	if (pDesc != NULL)
	{
		// if okay then get the first child of this tag - i.e. the text node
		pDesc = pDesc->GetFirstChild();
	}

	if (pDesc != NULL)
	{
		description = pDesc->GetText();
		return true;
	}
	else
	{
		return false;
	}
}

CGuideEntryXML::CGuideEntryXML(CInputContext& inputContext)
:CGuideEntry(inputContext)
{
}


/*********************************************************************************
bool CGuideEntryXML::BodyIsEmpty()

Author:		Igor Loboda
Created:	11/05/2004
Returns:	true if non-empty body element can not be found in the xml tree
*********************************************************************************/

bool CGuideEntryXML::BodyIsEmpty()
{
	CXMLTree* pBodyEl = CGuideEntry::FindBodyTextNode();
	return pBodyEl == NULL;
}

CFixDBBuilder::CFixDBBuilder(CInputContext& inputContext)
:
CXMLBuilder(inputContext)
{

}

CFixDBBuilder::~CFixDBBuilder()
{

}


/*********************************************************************************
CWholePage* CFixDBBuilder::Build()

Author:		Igor Loboda
Created:	11/05/2004
*********************************************************************************/

bool CFixDBBuilder::Build(CWholePage* pPage)
{
	m_pPage = pPage;
	InitPage(m_pPage, "FIXDB", true);
	CUser* pViewer = m_InputContext.GetCurrentUser();
	
	//This builder can only be used by a logged in user
	
	if (pViewer == NULL)
	{
		m_pPage->SetError("NULL viewer in CFixDBBuilder::Build()");
		return true;
	}

	// Is the user mighty enough?
	if (!pViewer->GetIsSuperuser())
	{
		m_pPage->SetError("User doesn't have the necessary privileges");
		return true;
	}

	int iMode = m_InputContext.GetParamInt("mode");
	int ih2g2Id = m_InputContext.GetParamInt("h2g2id");

	m_pPage->AddInside("H2G2", "<FIXINFO/>");

	switch (iMode)
	{
		case 1:
			FixAutodescription(ih2g2Id);
		break;

		case 2:
			FixBREAKAndPARABREAKTags(ih2g2Id);
		break;

		default:
			m_pPage->SetError("Mode unsupported");
			return true;
		break;
	}

	if (ErrorReported())
	{
		m_pPage->AddInside("FIXINFO",GetLastErrorAsXMLString());
	}

	return true;
}


/*********************************************************************************
void CFixDBBuilder::FixAutodescription(int ih2g2Id)

Author:		Igor Loboda
Created:	11/05/2004
Inputs:		ih2g2Id - guide entry h2g2id. If <= 0 outputs description of this
				method does into xml tree
Purpose:	Checks that give guide entry has empty body. If not - exits and does nothing.
			Otherwise copies content of description tag (if found) into body. If extrainfo
			contains autodescription tag it is regenerated from body tag.
			Autodescription regeneration is to fix autodescriptions like this one:
			<EXTRAINFO><TYPE ID="4" /><DESCRIPTION>A very useful thing</DESCRIPTION>
			<AUTODESCRIPTION>&lt;GUIDE&gt;&lt;ADDRESS1&gt;The street&lt;/ADDRESS1&gt;
			&lt;ADDRESS2&gt; town&lt;/ADDRESS2&gt;&lt;ADDRESS3&gt; thing&amp;...
			</AUTODESCRIPTION></EXTRAINFO>
			which where generated because of a bug in CExtraInfo::GenerateAutoDescription
			for guide entries with empty body.

			To get the list of guide entries to be fixed run these:
			-list of entries with broken autodescription
			SELECT     ge.h2g2id
			FROM         GuideEntries ge
			WHERE     (PATINDEX('%AUTODESCRIPTION>&lt;%', ge.ExtraInfo) > 0)
			
			-list of entries type 4 with empty body tag
			SELECT     ge.h2g2id
			FROM         GuideEntries ge INNER JOIN
                      blobs b ON ge.blobid = b.blobid
			WHERE     ge.type = 4 AND (PATINDEX('%<BODY />%', b.text) > 0)
*********************************************************************************/

void CFixDBBuilder::FixAutodescription(int ih2g2Id)
{
	static CTDVString fixDescription = "<DESCRIPTION>BODYEMPTY means that the entry "
		"has empty BODY tag and "
		"needs to be fixed. The fix is to try to find DESCRIPTION element "
		"and copy it's content inside BODY tag. If DESCRIPTION element "
		"is found DESCRFOUND is 1. If BODY update succeedes BODYFIXED is 1. "
		"Another piece of data which might be fixed is autodescription inside "
		"extra info. If extra info contains autodescription HASAUTOD is 1 and "
		"autodescription is regenerated from BODY. If this succeedes AUTODFIXES is 1"
		"</DESCRIPTION>";

	if (ih2g2Id <= 0)
	{
		CTDVString result;
		result << "<FIXAUTODESCRIPTION>" 
			<< fixDescription
			<< "</FIXAUTODESCRIPTION>";
		m_pPage->AddInside("FIXINFO", result);
		return;
	}

	CGuideEntryXML guide(m_InputContext);
	if (!guide.Initialise(ih2g2Id, m_InputContext.GetSiteID()))
	{
		m_pPage->SetError("Failed to initialise using h2g2id");
		return;
	}
	
	bool bADFixed = false;
	bool bHasAD = false;
	bool bBodyUpdated = false;
	bool bDescriptionFound = false;

	bool bBodyEmpty = guide.BodyIsEmpty();
	if (bBodyEmpty)
	{
		CExtraInfo ei;
		guide.GetExtraInfo(ei);

		CTDVString sBodyText;
		guide.GetBody(sBodyText);

		CTDVString autodBody;	//autodescription will be generated from this

		CTDVString description;
		if (guide.GetDescription(description))
		{
			bDescriptionFound = true;

			//put text from description element into body

			CTDVString newBody;
			newBody << "<BODY>" << description << "</BODY>";
			autodBody = newBody;
			
			//copy description into body
			if (sBodyText.Replace("<BODY />", newBody)
				|| sBodyText.Replace("<BODY/>", newBody)
				|| sBodyText.Replace("<BODY></BODY>", newBody))
			{
				if (guide.UpdateBody(sBodyText))
				{
					bBodyUpdated = true;
				}
				else
				{
					m_pPage->SetError("unable to update guide body");
				}
			}
		}

		//part two: regenerate autodescription - only if the entry already has
		//autodescription
		bHasAD = ei.ExistsInfoItem("AUTODESCRIPTION");
		if (bHasAD)
		{
			//regenerate auto description
			ei.GenerateAutoDescription(autodBody);

			if (!guide.UpdateExtraInfoEntry(ei))
			{
				m_pPage->SetError("unable to update guide extra info");
			}
			else
			{
				bADFixed = true;
			}
		}
	}

	CTDVString result;
	result << "<FIXAUTODESCRIPTION>" 
		<< fixDescription
		<< "<BODYEMPTY>" << bBodyEmpty << "</BODYEMPTY>"
		<< "<DESCRFOUND>" << bDescriptionFound << "</DESCRFOUND>"
		<< "<HASAUTOD>" << bHasAD << "</HASAUTOD>"
		<< "<AUTODFIXED>" << bADFixed << "</AUTODFIXED>"
		<< "<BODYFIXED>" << bBodyUpdated << "</BODYFIXED>"
		<< "</FIXAUTODESCRIPTION>";
	m_pPage->AddInside("FIXINFO", result);
}


/*********************************************************************************

	bool CFixDBBuilder::FixBREAKAndPARABREAKTags(int ih2g2Id)

		Author:		Mark Neves
        Created:	04/10/2004
        Inputs:		ih2g2Id = The article that needs fixing
        Outputs:	-
        Returns:	true if no errors occurred, false otherwise
					(SetDNALastError() also called in error case)
        Purpose:	This function removes all occurrances of the BREAK and PARABREAK
					tags in the article specified

					The sites Collective & GetWriting used these special tags to get round
					a problem with BR handling in TypedArticle.  The BR handling has been
					fixed, so this function cleans up these articles.

					For each article, it does the following
					* Replaces existing BR tags with \r\n
					* Replaces each BREAK tag with a single BR tag
					* Replaces each PARABREAK tag with a two BR tags
					* Sets the PreProcessed flag to false (indictating it has proper BR handling)

					The resultant XML gives you information on the change.

					Changes are not committed to the database unless the URL has the 
					parameter 'commit=1'

					e.g.
						This shows you the changes to the article that will happen:
						http://www.bbc.co.uk/dna/ican/fix?mode=2&h2g2id=<>&skin=purexml

						This actually does that change
						http://www.bbc.co.uk/dna/ican/fix?mode=2&h2g2id=<>&skin=purexml&commit=1
						

*********************************************************************************/

bool CFixDBBuilder::FixBREAKAndPARABREAKTags(int ih2g2Id)
{
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);

	if (!SP.FetchGuideEntryDetails(ih2g2Id))
	{
		return SetDNALastError("CFixDBBuilder","FAIL","SP.FetchGuideEntryDetails failed");
	}

	bool bPreProcessed = (SP.GetIntField("PreProcessed") > 0);
	if (bPreProcessed == 0)
	{
		return SetDNALastError("CFixDBBuilder","FAIL","The article is not preprocessed.");
	}

	bool bCommitChanges = m_InputContext.ParamExists("commit");

	CTDVString sXML;
	CXMLObject XMLObject(m_InputContext);
	XMLObject.InitialiseXMLBuilder(&sXML,&SP);

	bool bOK = true;
	CTDVString sSiteID,sH2G2ID,sText;
	bOK = bOK && XMLObject.OpenXMLTag("ARTICLEFIXED");
	bOK = bOK && XMLObject.AddDBXMLTag("h2g2id","H2G2ID",false,false,&sH2G2ID);
	bOK = bOK && XMLObject.AddDBXMLTag("subject","SUBJECT");
	bOK = bOK && XMLObject.AddDBXMLTag("siteid","SITEID",false,false,&sSiteID);
	bOK = bOK && XMLObject.AddDBXMLTag("text","ORIGINALTEXT",false,false,&sText);

	if (bOK)
	{
		CTDVString sURL;
		m_InputContext.GetSiteRootURL(atoi(sSiteID),sURL);
		sURL = CTDVString("\nhttp://") << sURL << "A" << sH2G2ID << "\n";
		bOK = bOK && XMLObject.AddXMLTag("URL",sURL);
	}
	else
	{
		return SetDNALastError("CFixDBBuilder","FAIL","Tag creation failed");
	}

	sText.Replace("<BR />", "\r\n");
	sText.Replace("<BREAK />", "<BR />");
	sText.Replace("<BREAK/>", "<BR />");
	sText.Replace("<PARABREAK />", "<BR /><BR />");
	sText.Replace("<PARABREAK/>", "<BR /><BR />");
	bOK = bOK && XMLObject.AddXMLTag("NEWTEXT",sText);

	if (bCommitChanges)
	{
		CStoredProcedure SPUpdate;
		m_InputContext.InitialiseStoredProcedureObject(&SPUpdate);

		bOK = SPUpdate.BeginUpdateArticle(ih2g2Id);
		bOK = bOK && SPUpdate.ArticleUpdateBody(sText);
		bOK = bOK && SPUpdate.ArticleUpdatePreProcessed(false);
		if (bOK)
		{
			bOK = SPUpdate.DoUpdateArticle();
		}
		else
		{
			return SetDNALastError("CFixDBBuilder","FAIL","Update Article failed");
		}
	}

	bOK = bOK && XMLObject.CloseXMLTag("ARTICLEFIXED");

	m_pPage->AddInside("FIXINFO", sXML);

	if (!bOK)
	{
		return SetDNALastError("CFixDBBuilder","FAIL","Something unexpected when wrong");
	}

	return true;
}

