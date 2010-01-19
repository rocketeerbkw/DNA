#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "User.h"
#include "TDVString.h"
#include "XMLBuilder.h"

class CIDifDocBuilder : public CXMLBuilder  
{
public:

	CIDifDocBuilder(CInputContext& inputContext);
	virtual ~CIDifDocBuilder();
	virtual bool Build(CWholePage* pPage);

protected:

	bool ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);
	bool GetEntryIDParams(CDNAIntArray& EntryIDParams);
	//bool CIDifDocBuilder::BuildEntryData(int iEntryID, CTDVString& sEntry);
	bool DisplayEntryData(int iEntryID);

	CWholePage* m_pPage;
};
