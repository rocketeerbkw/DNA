#ifndef FIXDBBUILDER_H
#define FIXDBBUILDER_H

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLBuilder.h"

class CFixDBBuilder : public CXMLBuilder
{
	public:
		CFixDBBuilder(CInputContext& inputContext);
		virtual ~CFixDBBuilder();

	public:
		virtual bool Build(CWholePage* pPage);

	protected:
		void FixAutodescription(int ih2g2Id);
		bool FixBREAKAndPARABREAKTags(int ih2g2Id);

	protected:
		CWholePage* m_pPage;
};

#endif