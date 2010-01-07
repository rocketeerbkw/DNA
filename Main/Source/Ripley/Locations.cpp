#include "stdafx.h"
#include "Locations.h"
#include "StoredProcedure.h"

CLocations::CLocations(CInputContext& inputContext) : CXMLObject(inputContext), m_bHasLocations(false)
{
}

CLocations::~CLocations(void)
{
}

bool CLocations::GetEntryLocations(int h2g2id)
{
	m_bHasLocations = true;
	CStoredProcedure SP;
	m_InputContext.InitialiseStoredProcedureObject(&SP);
		
	CTDVString sLocations;		
	CDBXMLBuilder xml;
	xml.Initialise(&sLocations, &SP);

	SP.GetArticleLocations(h2g2id);

	xml.OpenTag("MAP-LOCATIONS");
	while(!SP.IsEOF())
	{
		xml.OpenTag("MAP-LOCATION");
		xml.DBAddDoubleTag("Latitude");
		xml.DBAddDoubleTag("Longitude");
		xml.DBAddDateTag("DateCreated");
		xml.DBAddIntTag("ZoomLevel");
		xml.DBAddTag("Description");
		xml.DBAddTag("Title");
		xml.DBAddIntTag("Approved");
		xml.DBAddIntTag("User");
		xml.DBAddTag("SiteID");
		xml.DBAddIntTag("LocationID");
		xml.CloseTag("MAP-LOCATION");
		SP.MoveNext();
	}
	xml.CloseTag("MAP-LOCATIONS");
	
	return CreateFromXMLText(sLocations);
}

bool CLocations::HasLocations()
{
	return m_bHasLocations;
}
