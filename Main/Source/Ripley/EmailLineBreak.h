#pragma once

#include "./tdvstring.h"

class CLineBreakInserter
{
public:
	CLineBreakInserter(int iBreakWhenHint);
	virtual ~CLineBreakInserter(void);

	const CTDVString& operator()(CTDVString& sText) const;

private:
	int m_iBreakAfterHint;
};
