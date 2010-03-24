// SmileyList.h: interface for the CSmileyList class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#if !defined(AFX_SMILEYLIST_H__C0FB3C9F_A5CD_11D4_8720_00A024998768__INCLUDED_)
#define AFX_SMILEYLIST_H__C0FB3C9F_A5CD_11D4_8720_00A024998768__INCLUDED_

#include <vector>
#include "TDVAssert.h"
#include "TDVString.h"

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/*
	class CSmileyList

	Author:		Kim Harries
	Created:	20/10/2000
	Inherits:	-
	Purpose:	A very simple container class providing the necessary methods
				for storing and retrieving a list of ascii-sequence/filename
				pairs for the smiley translations that will occur in forums
				and plain text entries.
*/

class CSmileyList
{
public:
	CSmileyList();
	virtual ~CSmileyList();

	int GetSize() const;
	bool IsEmpty() const;
	CTDVString GetAscii(int iIndex) const;
	CTDVString GetName(int iIndex) const;
	bool AddPair(const TDVCHAR* pAscii, const TDVCHAR* pName);
	void MakeEmpty();

//	bool SetAscii(int iIndex, const TDVCHAR* pAscii);
//	bool SetName(int iIndex, const TDVCHAR* pName);
//	bool SetPair(int iIndex, const TDVCHAR* pAscii, const TDVCHAR* pName);

private:
	class CSmileyPair
	{
	public:
		CTDVString	m_Ascii;
		CTDVString	m_Name;

		CSmileyPair(const TDVCHAR* pAscii, const TDVCHAR* pName) : m_Ascii(pAscii), m_Name(pName) {}
	} ;

	std::vector<CSmileyPair> m_Vector;
};

#endif // !defined(AFX_SMILEYLIST_H__C0FB3C9F_A5CD_11D4_8720_00A024998768__INCLUDED_)
