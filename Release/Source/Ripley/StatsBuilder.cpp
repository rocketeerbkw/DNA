#include "stdafx.h"
#include "StatsBuilder.h"
#include "User.h"

CStatsBuilder::CStatsBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CStatsBuilder::~CStatsBuilder(void)
{
}

bool CStatsBuilder::Build(CWholePage* pWholePage)
{
	if (!InitPage(pWholePage, "STATISTICSREPORT",true))
	{
		return false;
	}

	CUser* pViewer = m_InputContext.GetCurrentUser();
	if (pViewer == NULL || !pViewer->GetIsEditor())
	{
		pWholePage->SetPageType("ERROR");
		pWholePage->AddInside("H2G2", "<ERROR TYPE='NOT-EDITOR'>You cannot view stats unless you are logged in as an Editor.</ERROR>");
		return true;
	}

	CTDVString type;
	m_InputContext.GetParamString("type", type);
	if (type.CompareText("postspertopic"))
	{
		CStoredProcedure SP;
		m_InputContext.InitialiseStoredProcedureObject(&SP);
		CTDVString date;
		int interval;
		CTDVString sInterval;
		m_InputContext.GetParamString("date",date);
		m_InputContext.GetParamString("interval",sInterval);
		// default to 'day'
		interval = 1;
		if (sInterval.CompareText("week"))
		{
			interval = 2;
		}
		if (sInterval.CompareText("month"))
		{
			interval = 3;
		}

		if (!SP.GetPostingStats(date,interval))
		{
			pWholePage->SetPageType("ERROR");
			pWholePage->AddInside("H2G2", "<ERROR TYPE='STATS-DB-ERROR'>There was a problem reading the statistics from the database</ERROR>");
			return true;
		}
		if (SP.IsEOF())
		{
			pWholePage->SetPageType("ERROR");
			pWholePage->AddInside("H2G2", "<ERROR TYPE='STATS-NO-RESULTS'>There are no results for that date and interval</ERROR>");
			return true;
		}

		// reconvert the interval type to cope with an incorrect interval string in the query string
		CTDVString sXML;
		sXML = "<POSTING-STATISTICS INTERVAL=";
		if (interval == 1)
		{
			sXML << "'day'";
		}
		if (interval == 2)
		{
			sXML << "'week'";
		}
		if (interval == 3)
		{
			sXML << "'month'";
		}
		sXML << ">";

		CTDVDateTime startdate = SP.GetDateField("startdate");
		CTDVDateTime enddate = SP.GetDateField("enddate");
		sXML << "<STARTDATE>";
		CTDVString dateXML;
		startdate.GetAsXML(dateXML);
		sXML << dateXML << "</STARTDATE>";
		enddate.GetAsXML(dateXML);
		sXML << "<ENDDATE>" << dateXML << "</ENDDATE>";
		
		// Now output the results
		while (!SP.IsEOF())
		{
			sXML << "<POSTINGS SITEID='" << SP.GetIntField("SiteID") << "' ";
			CTDVString sField;
			SP.GetField("URLName", sField);
			CXMLObject::EscapeAllXML(&sField);
			sXML << "URLNAME='" << sField << "' ";

			if (SP.IsNULL("ForumID"))
			{
				sXML << "ISMESSAGEBOARD='0' ";
			}
			else
			{
				sXML << "ISMESSAGEBOARD='1' ";
				sXML << "FORUMID='" << SP.GetIntField("ForumID") << "' ";
				SP.GetField("Title", sField);
				CXMLObject::EscapeAllXML(&sField);
				sField.Replace("'","&apos;");
				sXML << "TITLE='" << sField << "' ";
			}

			sXML << "TOTALPOSTS='" << SP.GetIntField("TotalPosts") << "' ";
			sXML << "TOTALUSERS='" << SP.GetIntField("TotalUsers") << "' ";

			sXML << "/>";
			SP.MoveNext();
		}
		sXML << "</POSTING-STATISTICS>";
		pWholePage->AddInside("H2G2", sXML);
		return true;
	}

	return false;
}