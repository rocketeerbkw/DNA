// Header file for CPollBuilder
// James Pullicino 
// Jan 05

#pragma once
#include "XMLBuilder.h"

/*********************************************************************************
	class CPollBuilder : public CXMLBuilder

		Author:		James Pullicino
        Created:	11/01/2005
        Purpose:	Handles URL input for all polls

*********************************************************************************/

class CPollBuilder : public CXMLBuilder
{
public: 
	CPollBuilder(CInputContext& inputContext);
	~CPollBuilder();

	virtual bool Build(CWholePage* pPage);
};
