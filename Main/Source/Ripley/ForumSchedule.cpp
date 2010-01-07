// ForumSchedule.cpp: implementation of the CForumSchedule class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "User.h"
#include "ForumSchedule.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CForumSchedule::CForumSchedule(CInputContext& inputContext)
:CXMLObject(inputContext)
{
}
CForumSchedule::~CForumSchedule()
{

}

/*********************************************************************************

	bool CForumSchedule::Create24SevenSchedule(CDNAIntArray& ForumIDList)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray ForumIDList by reference
        Outputs:	-
        Returns:	Success boolean
        Purpose:	Adds a 'twentyfourseven' schedule to the Database using the 
					appropriate StoredProcedure member function.

*********************************************************************************/

bool CForumSchedule::Create24SevenSchedule(CDNAIntArray& ForumIDList)
{
	CStoredProcedure SP;

	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	// delete all recurring events for the forum ids and 
	// where not recurring and always open

	// use date past
	CTDVDateTime dEventTime;
	dEventTime.SetFromString("00000000000000");
	// set event to not recurring and always open
	if(!SP.CreateForumEvent(ForumIDList, 1, dEventTime, 0, 7, 1))
	{
		return SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
	}

	return true;
}

/*********************************************************************************

	bool CForumSchedule::CreateDailyRecurSchedule(CDNAIntArray& ForumIDList, int iHoursOpen, int iHoursClose, int iMinsOpen, int iMinsClose)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray ForumIDList -passed by reference
					int iHoursOpen, int iMinutesOpen, int iHoursClose, int iMinutesClose
        Outputs:	-
        Returns:	Success bool
        Purpose:	Adds/Updates forum schedule events where the same opening and closing 
					times apply for all days of the week.

*********************************************************************************/

bool CForumSchedule::CreateDailyRecurSchedule(CDNAIntArray& ForumIDList, int iHoursOpen, int iHoursClose, int iMinsOpen, int iMinsClose)
{	
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	// delete all recurring events for the forum ids and 
	// where not recurring and always open

	// for open & close action types
	for(int a = 0; a <= 1; a++)
	{
		CTDVDateTime dEventTime = 0;
		if(a == 1)	// ie, action to open
		{
			dEventTime.SetTime(iHoursOpen, iMinsOpen, 0);
		}
		else		// ie, action to close
		{
			dEventTime.SetTime(iHoursClose, iMinsClose, 0);
		}

		if(!SP.CreateForumEvent(ForumIDList, a, dEventTime, 1, 7, 1))
		{
			return SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
		}
	}
	return true;
}

/*********************************************************************************

	bool CForumSchedule::CreateWeeklyRecurSchedule(CDNAIntArray& ForumIDList, CDNAIntArray& iHoursOpen, CDNAIntArray& iHoursClose, CDNAIntArray& iMinsOpen, CDNAIntArray& iMinsClose, CDNAIntArray& iClosedAllDay)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray& ForumIDList
					int arrays: int* piHoursOpen, int* piHoursClose, int* piMinsOpen, int* piMinsClose, int* piClosedAllDay
        Outputs:	-
        Returns:	Success boolean
        Purpose:	For each action type(ie open and close events) and each day of the 
					week create events in the DB

*********************************************************************************/

bool CForumSchedule::CreateWeeklyRecurSchedule(CDNAIntArray& ForumIDList, CDNAIntArray& iHoursOpen, CDNAIntArray& iHoursClose, CDNAIntArray& iMinsOpen, CDNAIntArray& iMinsClose, CDNAIntArray& iClosedAllDay)
{
	// get StoredProcedure object

	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	// for open & close action types
	for(int a = 0; a <= 1; a++)
	{
		// for each day in the week
		for(int i = 0; i <=6; i++)
		{
			// no need to make event cos the forum is closed
			// but delete any existing for the day
			if(iClosedAllDay[i] > 0)
			{
				// Delete the events for the forums that match closing, eventtype and daytype
				if(!SP.DeleteForumEventsMatching(ForumIDList, a, 0, i))
				{
					return  SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
				}

				// Delete the events for the forums that match opening, eventtype and daytype
				if(!SP.DeleteForumEventsMatching(ForumIDList, a, 1, i))
				{
					return  SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
				}

				continue;
			}

			CTDVDateTime dEventTime = 0;
			if(a == 1)	// ie, action to open
			{
				dEventTime.SetTime(iHoursOpen[i], iMinsOpen[i], 0);
			}
			else		// ie, action to close
			{
				dEventTime.SetTime(iHoursClose[i], iMinsClose[i], 0);
			}

			if(!SP.CreateForumEvent(ForumIDList, a, dEventTime, 1, i, 1))
			{
				return  SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
			}
		}
	}

	return true;
}


/*********************************************************************************

	bool CForumSchedule::SetActiveStatus(CDNAIntArray& ForumIDList, int active)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray& ForumIDList -list of forum ids
					int active
        Outputs:	-
        Returns:	Success boolean
        Purpose:	Calls a stored procedure to set the relevent event active status
					to the value of int active

*********************************************************************************/

bool CForumSchedule::SetActiveStatus(CDNAIntArray& ForumIDList, int active)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	if(!SP.SetForumActiveStatus(ForumIDList, active))
	{
		return  SetDNALastError("ForumSchedule", "SetForumActiveStatus", "Failed to set ForumSchedule active status");
	}

	return true;
}

/*********************************************************************************

	bool CForumSchedule::GetForumScheduleInfo(CDNAIntArray& ForumIDList, bool bNormalise,int* pCount)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray& ForumIDList -list of forum ids
					bool bNormalise - flag indicating whether a 'normalised' data set is required
        Outputs:	pCount = If not NULL, contains the number of schedule entries for the supplied Forum IDs
        Returns:	Success bool
        Purpose:	In batches of 20 forum ids all schedule data is obtained from the database.
					Call appropriate functionality according to the value of bNormalise.
					If less than 20 forum ids to be processed functionality is requested
					for all at a single go.

*********************************************************************************/

bool CForumSchedule::GetForumScheduleInfo(CDNAIntArray& ForumIDList, bool bNormalise, int* pCount)
{
	CTDVString sForums;
	bool bSuccess	= true;
	bool bDoneFirst	= false;

	CTDVString sXML;

	if (pCount != NULL)
	{
		*pCount = 0;
	}

	// we can't request more than 20 sets at a time from the DB so 
	// iterate through if there are more than 20

	if (ForumIDList.GetSize() == 0)
	{
		if(bNormalise)
		{
			bSuccess = bSuccess && BuildNormalisedScheduleInfoXML(ForumIDList, sXML, bDoneFirst, pCount);
		}
		else
		{
			bSuccess = bSuccess && BuildScheduleInfoXML(ForumIDList, sXML, pCount);
		}
	}
	else
	{
		for (int i=0; i < ForumIDList.GetSize(); i+=20)
		{
			CDNAIntArray BatchList;
			BatchList.SetSize(20, 1);

			for (int j = i, k = 0; j < ForumIDList.GetSize() && k < 20; j++,k++)
			{
				BatchList.SetAt(k,ForumIDList[j]);
			}

			if(bNormalise)
			{
				bSuccess = bSuccess && BuildNormalisedScheduleInfoXML(BatchList, sXML, bDoneFirst, pCount);
			}
			else
			{
				bSuccess = bSuccess && BuildScheduleInfoXML(BatchList, sXML, pCount);
			}
		}
	}

	// we have schedule data
	sXML.Prefix("<FORUMSCHEDULES><SCHEDULE>");
	sXML << "</SCHEDULE></FORUMSCHEDULES>";

	if(!CreateFromXMLText(sXML))
	{
		delete m_pTree;
		m_pTree = NULL;
		return SetDNALastError("ForumSchedule", "XML", "Failed to generate XML");
	}

	return bSuccess;
}

/*********************************************************************************

	bool CForumSchedule::BuildNormalisedScheduleInfoXML(CDNAIntArray& ForumIDList, CTDVString& sXML, bool& bDoneFirst)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray& ForumIDList -list of forum ids	
        Outputs:	CTDVString& sXML
					bool& bDoneFirst
        Returns:	Success bool
        Purpose:	Empties sXML if not empty 
					Constructs the 'normalised' set of schedule data.
					bDoneFirst is set to true after the first forum has been processed.
					

*********************************************************************************/

bool CForumSchedule::BuildNormalisedScheduleInfoXML(CDNAIntArray& ForumIDList, CTDVString& sXML, bool& bDoneFirst,int* pCount)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	if(!SP.GetForumEventInfo(ForumIDList))
	{
		//set error but don't return
		SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to get ForumSchedule data");
	}

	int iCount = 0;

	int iTempID = 0;
	CTDVString sForumIDs;
	CTDVString sScheduleStr;
	// get the date info as a datetime object
	CTDVDateTime dTime;
	dTime = SP.GetDateField("NextRun");

	if(SP.IsEOF())
	{
		// we have no schedule data
		// build the list of forums
		//BuildForumIDs(ForumIDList, sForumIDs);
		//sXML << sForumIDs;
	}
	else
	{
		int iCurrentID	= 0;
		int iNewID		= 0;
		while(!SP.IsEOF())
		{
			iCount++;

			int iNewID = SP.GetIntField("ForumID");
			if(iNewID != iCurrentID)
			{
				//must be new
				sForumIDs << "<FORUM ID='" << iNewID << "'/>";
				iCurrentID = iNewID;
			}    

			if(!bDoneFirst)
			{
				//populate the temp id if iterating through first forum in set
				iTempID = iCurrentID;
				// done, so make true
				bDoneFirst = 1;
			}

			if(iTempID == iCurrentID)
			{
				// get the date info as a datetime object
				CTDVString sHours, sMins;
				dTime = SP.GetDateField("NextRun");
				int iHours = dTime.GetHour();
				int iMins  = dTime.GetMinute();
				if(iHours < 10) sHours	<< "0"; 
				sHours << iHours;
				if(iMins < 10)	sMins	<< "0"; 
				sMins << iMins;

				//build the control string
				sScheduleStr << "<EVENT TYPE='" << SP.GetIntField("EventType") << "' ACTION='" << SP.GetIntField("Action") << "' ACTIVE='" << SP.GetIntField("Active")<< "'>";
				sScheduleStr << "<TIME DAYTYPE='" <<  SP.GetIntField("DayType") << "' HOURS='" << sHours << "' MINUTES='" << sMins << "'/>";
				sScheduleStr << "</EVENT>";
			}
			SP.MoveNext();
		}
		sXML << sForumIDs << sScheduleStr;
	}

	if (pCount != NULL)
	{
		*pCount += iCount;
	}

	return true;
}


/*********************************************************************************

	bool CForumSchedule::BuildScheduleInfoXML(CDNAIntArray& ForumIDList, CTDVString& sXML)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray& ForumIDList -list of forum ids	
        Outputs:	CTDVString& sXML
        Returns:	Success bool
        Purpose:	Empties sXML if not empty
					For each forum in the a requested data set the schedule XML data is
					constructed and added to the object

*********************************************************************************/

bool CForumSchedule::BuildScheduleInfoXML(CDNAIntArray& ForumIDList, CTDVString& sXML,int* pCount)
{
	// sXML should be emplty
	if(!sXML.IsEmpty())
	{
		sXML.Empty();
	}
	// get the data from the db for safety.
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	if(!SP.GetForumEventInfo(ForumIDList))
	{
		return SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
	}

	int iCount = 0;

	int iTemp = 0;
	CTDVString sTemp;

	if(SP.IsEOF())
	{
		// we have no schedule data
		sTemp << "<SCHEDULE>";

		// build the list of forums
		//BuildForumIDs(ForumIDList, sTemp);
		//sXML << sTemp;
	}
	else
	{
		while(!SP.IsEOF())
		{
			iCount++;

			int iCurrentID = SP.GetIntField("ForumID");
			if( iTemp != iCurrentID)	//ie. if new forum
			{
				if(iTemp > 0)
				{
					// close sTemp string
					sTemp << "</SCHEDULE>";
					
					// add sTemp to sXML
					sXML << sTemp;
					
					// empty sTemp to start again
					sTemp.Empty();
				}

				// reset iTemp to iCurrent
				iTemp = iCurrentID;

				// start new sTemp string
				sTemp << "<SCHEDULE>";
				sTemp << "<FORUM ID='" << iCurrentID << "'/>";
			}
			// deal with the individual schedule event
			sTemp << "<EVENT TYPE='" << SP.GetIntField("EventType") << "' ACTION='" << SP.GetIntField("Action") << "' ACTIVE='" << SP.GetIntField("Active") << "'>";
			
			// get the date info as a datetime object
			CTDVDateTime dTime;
			dTime = SP.GetDateField("NextRun");

			// munge the date string
			int iHours, iMins;
			CTDVString sHours, sMins;
			iHours = dTime.GetHour();
			iMins  = dTime.GetMinute();
			if(iHours < 10) sHours	<< "0"; 
			sHours << iHours;
			if(iMins < 10)	sMins	<< "0"; 
			sMins << iMins;

			int iDayType = SP.GetIntField("DayType");

			sTemp << "<TIME DAYTYPE='" << iDayType << "' HOURS='" << sHours << "' MINUTES='" << sMins << "'/>";

			sTemp << "</EVENT>";
			SP.MoveNext();
		}
		sXML << sTemp;
	}

	sXML << "</SCHEDULE>";

	if (pCount != NULL)
	{
		*pCount += iCount;
	}
	
	return true;
}

/*********************************************************************************

	bool CForumSchedule::BuildForumIDs(CDNAIntArray& ForumIDList, CTDVString& sForumIDs)

		Author:		Nick Stevenson
        Created:	20/04/2004
        Inputs:		CDNAIntArray& ForumIDList
        Outputs:	CTDVString& sForumIDs
        Returns:	-
        Purpose:	Empties sForumIDs if not empty
					Constructs the forum id xml elements and adds them to sForumIDs

*********************************************************************************/

bool CForumSchedule::BuildForumIDs(CDNAIntArray& ForumIDList, CTDVString& sForumIDs)
{
	if(!sForumIDs.IsEmpty())
	{
		sForumIDs.Empty();
	}

	int iSize = ForumIDList.GetSize();
	int i = 0;
	while(i < iSize)
	{
		sForumIDs << "<FORUM ID='" << ForumIDList[i] << "'/>";
		i++;
	}
	return true;
}

/*********************************************************************************

	bool CForumSchedule::DeleteSchedulesForForumID(CDNAIntArray& ForumIDList)

		Author:		Nick Stevnson
        Created:	27/04/2004
        Inputs:		CDNAIntArray& ForumIDList -ref to a list of forum ids
        Outputs:	-
        Returns:	success boolean
        Purpose:	For the ids in the list, the event data is sought from the database
					and the eventids extracted in order to call stored procedure to delete
					events.

*********************************************************************************/

bool CForumSchedule::DeleteSchedulesForForumID(CDNAIntArray& ForumIDList)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	if(!SP.GetForumEventInfo(ForumIDList))
	{
		return SetDNALastError("ForumSchedule", "GetForumEventInfo", "Failed to get forum schedule info");
	}

	CDNAIntArray iEvents;
	iEvents.SetSize(ForumIDList.GetSize(), 1);
	int i = 0;
	while(!SP.IsEOF())
	{
		iEvents.SetAt(i, SP.GetIntField("EventID"));
		i++;
		SP.MoveNext();
	}

	if(iEvents.GetSize() > 0)
	{
		if(!SP.DeleteForumEvents(iEvents))
		{
			return SetDNALastError("ForumSchedule", "DeleteForumEvents", "Failed to delete forum schedules");
		}
	}
	return true;
}

/*********************************************************************************

	bool CForumSchedule::GenerateSchedulesIfNewForums(CDNAIntArray& ForumIDList)

		Author:		Nick Stevenson
        Created:	07/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CForumSchedule::GenerateSchedulesIfNewForums(CDNAIntArray& ForumIDList, int iSiteID)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	if(!SP.GetNewUnScheduledForumIDsForSiteID(iSiteID))
	{
		return SetDNALastError("ForumSchedule", "GetForumEventInfo", "Failed to get forum schedule info");
	}

	int iFirstExisting = 0;
	if (SP.FieldExists("ExistingID"))
	{
		iFirstExisting = SP.GetIntField("ExistingID");
	}
	if(iFirstExisting <= 0)
	{
		//no existing schdules for the site, or no new topics so quit the function
		return true;
	}

	CDNAIntArray NewForumIDs;
	NewForumIDs.SetSize(0,1);
	while(!SP.IsEOF())
	{
		NewForumIDs.Add(SP.GetIntField("ForumID"));
		SP.MoveNext();
	}

	if(NewForumIDs.GetSize() > 0)
	{
		//bring forumScheduledEvents data up to date
		if(!GenerateDuplicateScheduledEventsForNewForums(iFirstExisting, NewForumIDs))
		{
			return SetDNALastError("ForumSchedule", "GenerateSchedulesIfNewForums", "Failed to generate duplicate schedules");
		}
	}
	return true;
}


/*********************************************************************************

	bool CForumSchedule::GenerateDuplicateScheduledEventsForNewForums(int iForumID, CDNAIntArray& ForumIDList)

		Author:		Nick Stevenson
        Created:	28/01/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CForumSchedule::GenerateDuplicateScheduledEventsForNewForums(int iForumID, CDNAIntArray& ForumIDList)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	if(!SP.GenerateDuplicateScheduledEventsForNewForums(iForumID, ForumIDList))
	{
		return SetDNALastError("ForumSchedule", "GetForumEventInfo", "Failed to get forum schedule info");
	}

	return true;
}


/*********************************************************************************

	bool CForumSchedule::CreateScheduleDirect(CDNAIntArray& ForumIDList, int iEventType, int iAction, int iActive, int iDayType, int iHours, int iMins)

		Author:		Mark Neves
        Created:	15/02/2005
        Inputs:		ForumIDList = list of forum IDs
					iEventType  = event type
					iAction = event action
					iActive = active state
					iDayType = day type
					iHours = hours
					iMins = minutes
        Outputs:	-
        Returns:	true if ok, false otherwise
        Purpose:	Provides a direct way of adding a schedule event for the given list
					of forums.

					Should only be used if you know what you are doing.

*********************************************************************************/

bool CForumSchedule::CreateScheduleDirect(CDNAIntArray& ForumIDList, int iEventType, int iAction, int iActive, int iDayType, int iHours, int iMins)
{
	CStoredProcedure SP;
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		return SetDNALastError("ForumSchedule", "InitStoredProcedure", "Failed to initialise the Stored Procedure");
	}

	CTDVDateTime dEventTime = 0;
	dEventTime.SetTime(iHours, iMins, 0);

	if(!SP.CreateForumEvent(ForumIDList, iAction, dEventTime, iEventType, iDayType, false))
	{
		return SetDNALastError("ForumSchedule", "CreateForumEvent", "Failed to set ForumSchedule data");
	}

	// All forums are expected to have the same active state
	SetActiveStatus(ForumIDList,iActive);

	return true;
}

