#include "stdafx.h"
#include "TDVString.h"
#include "TimeZoneManager.h"

CTimeZoneManager* CTimeZoneManager::m_pInstance = NULL;

CTimeZoneManager::CTimeZoneManager(void)
{
}


CTimeZoneManager::~CTimeZoneManager(void)
{
}


CTimeZoneManager* CTimeZoneManager::GetTimeZoneManager()
{
    if ( m_pInstance == NULL )
    {
        m_pInstance = new CTimeZoneManager();
        m_pInstance->Initialise();
    }
    return m_pInstance;
}


void CTimeZoneManager::ConvertToLocalTime(SYSTEMTIME& utc, SYSTEMTIME& local)
{
    ::SystemTimeToTzSpecificLocalTime(&m_CurTimeZone, &utc, &local);
}

/*********************************************************************************

	void CTimeZoneManager::Initialise

	Author:		Martin Robb
	Created:	02/05/2008
	Inputs:		- None
	Outputs:	-
	Returns:	-
	Purpose:	- Initialises time zone information. Timezone Information is gathered from the registry rather than
                  using the machines current timezone. This is because the servers are set to GMT and do not adjust for BST 
                  British Summer Time . Also this could allow times to be adjusted for clients in other countries.

*********************************************************************************/
void CTimeZoneManager::Initialise()
{
    TIME_ZONE_INFORMATION tzi;
    ::GetTimeZoneInformation(&tzi);

    TCHAR standardName[MAX_SIZE];
    WideCharToMultiByte( CP_ACP, 0, tzi.StandardName, -1,standardName, 256, NULL, NULL );

    //Find appropriate Time Zone Information from Registry
    //std::set<CTDVString> setTimeZones;
    //EnumerateTimeZones( setTimeZones );
    //std::set<CTDVString>::iterator iter =  setTimeZones.find(standardName);
    //if ( iter != setTimeZones.end() )
    {
        //Get Time Zone Info for current time zone
        GetTimeZoneInformation(standardName);

        //Populate Time Zone Information structure
        GetTimeZoneInformation(m_CurTimeZone);
    }
}

/*********************************************************************************

	void CTimeZoneManager::EnumerateTimeZones

	Author:		Martin Robb
	Created:	02/05/2008
	Inputs:		- None
	Outputs:	- setTimeZones
	Returns:	-
	Purpose:	- Examines Timezones in registry and populates set of available timezones.

*********************************************************************************/
void CTimeZoneManager::EnumerateTimeZones(std::set<CTDVString>& setTimeZones )
{
    //Open Time Zones Registry Key
    TCHAR szTimeZoneKey[] = _T("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Time Zones");
    HKEY hTimeZones;
    RegOpenKeyEx(HKEY_LOCAL_MACHINE, szTimeZoneKey, 0, KEY_READ, &hTimeZones);

    TCHAR    achKey[MAX_KEY_LENGTH];   // buffer for subkey name
    DWORD    cbName;                   // size of name string 
    TCHAR    achClass[MAX_PATH] = TEXT("");  // buffer for class name 
    DWORD    cchClassName = MAX_PATH;  // size of class string 
    DWORD    cSubKeys=0;               // number of subkeys 
    DWORD    cbMaxSubKey;              // longest subkey size 
    DWORD    cchMaxClass;              // longest class string 
    DWORD    cValues;              // number of values for key 
    DWORD    cchMaxValue;          // longest value name 
    DWORD    cbMaxValueData;       // longest value data 
    DWORD    cbSecurityDescriptor; // size of security descriptor 
    FILETIME ftLastWriteTime;      // last write time 
 
    DWORD i, retCode; 
 
    //TCHAR  achValue[MAX_VALUE_NAME]; 
    DWORD cchValue = MAX_VALUE_NAME; 
 
    // Get the class name and the value count. 
    retCode = RegQueryInfoKey(
        hTimeZones,                    // key handle 
        achClass,                // buffer for class name 
        &cchClassName,           // size of class string 
        NULL,                    // reserved 
        &cSubKeys,               // number of subkeys 
        &cbMaxSubKey,            // longest subkey size 
        &cchMaxClass,            // longest class string 
        &cValues,                // number of values for this key 
        &cchMaxValue,            // longest value name 
        &cbMaxValueData,         // longest value data 
        &cbSecurityDescriptor,   // security descriptor 
        &ftLastWriteTime);       // last write time 
 
    // Enumerate the subkeys, until RegEnumKeyEx fails.
    
    //Enumerate TimeZones
    if (cSubKeys)
    {
        printf( "\nNumber of subkeys: %d\n", cSubKeys);

        for (i=0; i<cSubKeys; i++) 
        { 
            cbName = MAX_KEY_LENGTH;
            retCode = RegEnumKeyEx(hTimeZones, i,
                     achKey, 
                     &cbName, 
                     NULL, 
                     NULL, 
                     NULL, 
                     &ftLastWriteTime); 
            if (retCode == ERROR_SUCCESS) 
            {
                setTimeZones.insert(achKey);

            }
        }
    } 
}


/*********************************************************************************

	void CTimeZoneManager::GetTimeZoneImformation

	Author:		Martin Robb
	Created:	02/05/2008
	Inputs:		- name - Name of Timezone registry key - name of specific timezone.
	Outputs:	-
	Returns:	-
	Purpose:	- Retrieves data from registry subkeys of given tmezone.

*********************************************************************************/
void CTimeZoneManager::GetTimeZoneInformation(CTDVString name)
{
    CTDVString sKey = _T("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Time Zones");
    sKey << "\\" << name;
    HKEY hKey;
    RegOpenKeyEx(HKEY_LOCAL_MACHINE, sKey, 0, KEY_READ, &hKey);

    TCHAR    achClass[MAX_PATH] = TEXT("");  // buffer for class name 
    DWORD    cchClassName = MAX_PATH;  // size of class string 
    DWORD    cSubKeys=0;               // number of subkeys 
    DWORD    cbMaxSubKey;              // longest subkey size 
    DWORD    cchMaxClass;              // longest class string 
    DWORD    cValues;              // number of values for key 
    DWORD    cchMaxValue;          // longest value name 
    DWORD    cbMaxValueData;       // longest value data 
    DWORD    cbSecurityDescriptor; // size of security descriptor 
    FILETIME ftLastWriteTime;      // last write time 
 
    DWORD i, retCode; 
 
    TCHAR  achValue[MAX_VALUE_NAME]; 
    DWORD cchValue = MAX_VALUE_NAME; 
 
    // Get the class name and the value count. 
    retCode = RegQueryInfoKey(
        hKey,                    // key handle 
        achClass,                // buffer for class name 
        &cchClassName,           // size of class string 
        NULL,                    // reserved 
        &cSubKeys,               // number of subkeys 
        &cbMaxSubKey,            // longest subkey size 
        &cchMaxClass,            // longest class string 
        &cValues,                // number of values for this key 
        &cchMaxValue,            // longest value name 
        &cbMaxValueData,         // longest value data 
        &cbSecurityDescriptor,   // security descriptor 
        &ftLastWriteTime);       // last write time 
 

    if (cValues) 
    {
        for (i=0, retCode=ERROR_SUCCESS; i<cValues; i++) 
        { 
            cchValue = MAX_VALUE_NAME; 
            achValue[0] = '\0'; 
            retCode = RegEnumValue(hKey, i, 
                achValue, 
                &cchValue, 
                NULL, 
                NULL,
                NULL,
                NULL);
 
            if (retCode == ERROR_SUCCESS ) 
            { 
                DWORD valueType;
                DWORD valueSize = MAX_SIZE;
                BYTE value[512];

                //TZI value is actuallly a structure.
                if (! strcmp(achValue,_T("TZI")))
                    valueSize = sizeof(regTZI);

                RegQueryValueEx(hKey, achValue, NULL, &valueType, value, &valueSize );
                FillFromRegistry(value, achValue, valueSize);
            } 
        }
    }
}

/*********************************************************************************

	void CTimeZoneManager::FillFromRegistry

	Author:		Martin Robb
	Created:	02/05/2008
	Inputs:		- pValue - Data from Registry
                - sValueName - Registry Key Name
                - iValueSize - Size of registry Data
	Outputs:	-
	Returns:	-
	Purpose:	- Copies data from registry values to internal structures.

*********************************************************************************/
void CTimeZoneManager::FillFromRegistry(BYTE* pValue, CTDVString sValueName, DWORD iValueSize)
{
    if ( sValueName.CompareText(_T("Display")) )
		memcpy(m_szDisplay, pValue, iValueSize);

    if ( sValueName.CompareText(_T("Dlt")) )
    memcpy(m_szDlt, pValue, iValueSize);

    if ( sValueName.CompareText(_T("Std")) )
    memcpy(m_szStd, pValue, iValueSize);

    if ( sValueName.CompareText(_T("MapID")) )
    memcpy(m_szMapID, pValue, iValueSize);

    //if ( sValueName.CompareText(_T("Index")) )
    //memcpy((BYTE*)&m_iIndex, pValue, iValueSize);

    if ( sValueName.CompareText(_T("TZI")) )
    memcpy((BYTE*)&m_regTZI, pValue, iValueSize);
}

void CTimeZoneManager::GetTimeZoneInformation(TIME_ZONE_INFORMATION& tz)
{
    tz.Bias = m_regTZI.Bias;
    tz.DaylightBias = m_regTZI.DaylightBias;
    tz.DaylightDate = m_regTZI.DaylightDate;
    MultiByteToWideChar(CP_ACP,0,m_szDlt,-1,tz.DaylightName,32);
    tz.StandardBias = m_regTZI.StandardBias;
    tz.StandardDate = m_regTZI.StandardDate;
    MultiByteToWideChar(CP_ACP,0,m_szStd,-1,tz.StandardName,32);
}
