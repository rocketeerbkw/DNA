// SiteOpenCloseTime.cpp: implementation of the CSiteOpenCloseTime class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "SiteOpenCloseTime.h"
#include "TDVAssert.h"
#include "StoredProcedure.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSiteOpenCloseTime::CSiteOpenCloseTime (int pDayWeek, 
										int pHour, 
										int pMinute, 
										int pClosed)
										: 
										mDayWeek(pDayWeek), 
										mHour(pHour), 
										mMinute(pMinute), 
										mClosed(pClosed)
{

}
CSiteOpenCloseTime::~CSiteOpenCloseTime()
{

}

int CSiteOpenCloseTime::GetDayWeek()
{
	return mDayWeek;
}
int CSiteOpenCloseTime::GetHour()
{
	return mHour;
}
int CSiteOpenCloseTime::GetMinute()
{
	return mMinute;
}
int CSiteOpenCloseTime::GetClosed()
{
	return mClosed;
}
bool CSiteOpenCloseTime::HasAlreadyHappened(CTDVDateTime dDate, bool& bHasAlreadyHappened)
{
	int iDayOfWeek = dDate.GetDayOfWeek();	
	int iHour = dDate.GetHour(); 
	int iMinute = dDate.GetMinute(); 	

	if ((iDayOfWeek > mDayWeek) ||
		(iDayOfWeek == mDayWeek && iHour > mHour) ||
		(iDayOfWeek == mDayWeek && iHour == mHour && iMinute >= mMinute)
		)
	{
		bHasAlreadyHappened = true; 
	}
	else
	{
		bHasAlreadyHappened = false; 
	}
	
	return true; 
}
bool CSiteOpenCloseTime::GetAsXMLString(CTDVString& sXML)
{
	// sXML should be emplty
	if(!sXML.IsEmpty())
	{
		sXML.Empty();
	}

	sXML << "<EVENT ACTION='" << mClosed << "'>";

	sXML << "<TIME DAYTYPE='" << mDayWeek << "' HOURS='" << mHour << "' MINUTES='" << mMinute << "'/>";

	sXML << "</EVENT>";

	return true; 
}