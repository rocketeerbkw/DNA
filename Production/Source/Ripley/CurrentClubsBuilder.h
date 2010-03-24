// CurrentClubsBuilder.h: interface for the CCurrentClubsBuilder class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_CURRENTCLUBSBUILDER_H__034C3CC9_489F_455F_B5F8_81AC691E7F15__INCLUDED_)
#define AFX_CURRENTCLUBSBUILDER_H__034C3CC9_489F_455F_B5F8_81AC691E7F15__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"
#include "ClubPageBuilder.h"

class CCurrentClubsBuilder : public CClubPageBuilder
{
public:
	CCurrentClubsBuilder(CInputContext& inputContext);
	virtual ~CCurrentClubsBuilder();

public:
	virtual bool Build(CWholePage* pPage);
};

#endif // !defined(AFX_CURRENTCLUBSBUILDER_H__034C3CC9_489F_455F_B5F8_81AC691E7F15__INCLUDED_)
