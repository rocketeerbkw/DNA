// SiteOpenCloseSchedule.cpp: implementation of the CSiteOpenCloseSchedule class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "User.h"
#include "SiteOpenCloseSchedule.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteOpenCloseSchedule::CSiteOpenCloseSchedule(CInputContext& inputContext)
:CXMLObject(inputContext)
{
}

CSiteOpenCloseSchedule::~CSiteOpenCloseSchedule()
{
}

bool CSiteOpenCloseSchedule::GetSiteOpenCloseSchedule(int iSiteID)
{
	CTDVString sXML;
	bool bSuccess = m_InputContext.GetSiteScheduleAsXMLString(iSiteID,sXML);
	if (bSuccess)
	{
		// we have schedule data
		sXML.Prefix("<SCHEDULE>");
		sXML << "</SCHEDULE>";
	}

	if (bSuccess && !CreateFromXMLText(sXML))
	{
		delete m_pTree;
		m_pTree = NULL;
		return SetDNALastError("CSiteOpenCloseSchedule::GetSiteOpenCloseSchedule", "FailedToCreateXML", "Failed to generate XML");
	}
	return bSuccess;
}

bool CSiteOpenCloseSchedule::UpdateSchedule(int iSiteID, std::vector<CTDVString>& SQLParamVector)
{
	// get StoredProcedure object
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CSiteOpenCloseSchedule::UpdateSchedule", "FailedToInitialiseSP", "Failed to initialise the Stored Procedure");
	}

	if (!SP.UpdateSiteOpenCloseSchedule(iSiteID, SQLParamVector))
	{
		return SetDNALastError("CSiteOpenCloseSchedule::DeleteScheduledEvents", "FailedToUpdateSchedules", "Failed to Update Schedules");
	}
	return true;
}

bool CSiteOpenCloseSchedule::CreateDailyRecurSchedule(int iSiteID, int iRecurrentEventOpenHours, int iRecurrentEventCloseHours, int iRecurrentEventOpenMinutes, int iRecurrentEventCloseMinutes)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CSiteOpenCloseSchedule::CreateDailyRecurSchedule", "FailedToInitialiseSP", "Failed to initialise the Stored Procedure");
	}

	if (!SP.CreateDailyRecurSchedule(iSiteID, iRecurrentEventOpenHours, iRecurrentEventCloseHours, iRecurrentEventOpenMinutes, iRecurrentEventCloseMinutes))
	{
		return SetDNALastError("CSiteOpenCloseSchedule::DeleteScheduledEvents", "FailedToCreateDailyEvents", "Failed to create daily events");
	}
	return true;
}

bool CSiteOpenCloseSchedule::DeleteScheduledEvents(int iSiteID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("CSiteOpenCloseSchedule::DeleteScheduledEvents", "FailedToInitialiseSP", "Failed to initialise the Stored Procedure");
	}

	if (!SP.DeleteScheduledEvents(iSiteID))
	{
		return SetDNALastError("CSiteOpenCloseSchedule::DeleteScheduledEvents", "FailedToDeleteEvents", "Failed to delete events");
	}
	return true;
}