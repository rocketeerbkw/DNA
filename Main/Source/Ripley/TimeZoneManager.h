#pragma once

#include <set>

#define MAX_KEY_LENGTH 255
#define MAX_VALUE_NAME 16383
#define MAX_SIZE    255

struct regTZI
{
    long Bias;
    long StandardBias;
    long DaylightBias;
    SYSTEMTIME StandardDate; 
    SYSTEMTIME DaylightDate;
};

class CTimeZoneManager
{
public:
    static CTimeZoneManager* GetTimeZoneManager();

    void ConvertToLocalTime(SYSTEMTIME& utc, SYSTEMTIME& local);

private:
    TCHAR tcName[MAX_SIZE];
    TCHAR m_szDisplay[MAX_SIZE];
    TCHAR m_szDlt[MAX_SIZE];
    TCHAR m_szStd[MAX_SIZE];
    TCHAR m_szMapID[MAX_SIZE];
    regTZI m_regTZI;

    TIME_ZONE_INFORMATION m_CurTimeZone;

    static CTimeZoneManager* m_pInstance;

    CTimeZoneManager(void);
    ~CTimeZoneManager(void);

     void Initialise();
     void GetTimeZoneInformation(TIME_ZONE_INFORMATION& tz);

    void EnumerateTimeZones(std::set<CTDVString>& listTimeZones );
    void GetTimeZoneInformation(CTDVString name);
    void FillFromRegistry( BYTE* pValue, CTDVString sValueName, DWORD iValueSize);

};
