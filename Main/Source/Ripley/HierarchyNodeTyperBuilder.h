// HierarchyNodeTyperBuilder.h: interface for the CHierarchyNodeTyperBuilder class.
//
//////////////////////////////////////////////////////////////////////

#include "InputContext.h"
#include "InputContext.h"
#include "StoredProcedure.h"
#include "WholePage.h"
#include "User.h"
#include "TDVString.h"
#include "XMLBuilder.h"
#include "RefereeList.h"

class CHierarchyNodeTyperBuilder : public CXMLBuilder  
{
public:
	/*enum
	{
		UNTYPED = 1,
		ISSUE	= 2,
		LOCATION= 3
	}; */

	CHierarchyNodeTyperBuilder(CInputContext& inputContext);
	virtual ~CHierarchyNodeTyperBuilder();
	virtual bool Build(CWholePage* pPage);
	int GetTypeID(const TDVCHAR* pcTypeName);

protected:
	bool ErrorMessage(const TDVCHAR* sType, const TDVCHAR* sMsg);

private:
	// we really don't want anyone messing with these functions
	// so making them private
	bool TypeNodesHavingAncestor(const int iAncestor, const int iTypeID, const int iSiteID);
	bool AddNewType(const int iTypeID, const CTDVString& sDescription, const int iSiteID);

	bool AddNewTypeDefinition(const int iSiteID, CTDVString& sSuccess);
	bool TypeHierarchyNodes(const int iSiteID, CTDVString& sSuccess);

protected:

	CWholePage* m_pPage;
};
