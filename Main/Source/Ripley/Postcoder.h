// Postcoder.h: interface for the CPostcoder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_POSTCODER_H__F52AC661_DF7C_4406_A15D_542E9DDAB031__INCLUDED_)
#define AFX_POSTCODER_H__F52AC661_DF7C_4406_A15D_542E9DDAB031__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

class CPostcoder : public CXMLObject  
{
public:
	CTDVString GetPostcodeFromCookie();
	bool UpdateUserPostCodeInfo(CTDVString& sPostCode, CTDVString& sArea, int iNodeID);
	bool PlaceHitPostcode(CTDVString& oPostcode, CTDVString& oLocalAuthorityID, CTDVString& oLocalAuthorityName, int& iNodeID);
	bool MakePlaceRequest(const TDVCHAR* pPlaceName, bool& bHitPostcode);
	CPostcoder(CInputContext& inputContext);
	virtual ~CPostcoder();
protected:
	CXMLTree* m_pResultTree;
};

#endif // !defined(AFX_POSTCODER_H__F52AC661_DF7C_4406_A15D_542E9DDAB031__INCLUDED_)
