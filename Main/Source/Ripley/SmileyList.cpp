// SmileyList.cpp: implementation of the CSmileyList class.
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


#include "stdafx.h"
#include "SmileyList.h"
#include "TDVAssert.h"
#include "TDVString.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSmileyList::CSmileyList()
{
	// no special construction required
}

CSmileyList::~CSmileyList()
{
	// no special destruction required
}

/*********************************************************************************

	int CSmileyList::GetSize() const

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		-
	Outputs:	-
	Returns:	the current number of pairs in the list
	Purpose:	Returns the number of ascii-sequence/filename pairs currently in
				the list.

*********************************************************************************/

int CSmileyList::GetSize() const
{
	return m_Vector.size();
}

/*********************************************************************************

	bool CSmileyList::IsEmpty() const

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if the list is empty, false if not.
	Purpose:	Determines whether the stored list is empty or not.

*********************************************************************************/

bool CSmileyList::IsEmpty() const
{
	return m_Vector.empty();
}

/*********************************************************************************

	CTDVString CSmileyList::GetAscii(int iIndex) const

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		iIndex - the index of the ascii part to be retrieved
	Outputs:	-
	Returns:	The ascii sequence if the index is valid, or an empty string if not
	Purpose:	Retrieves the ascii part of the ascii/name pair for this index.

*********************************************************************************/

CTDVString CSmileyList::GetAscii(int iIndex) const
{
	if (iIndex < 0 || iIndex >= GetSize())
	{
		TDVASSERT(false, "index out of range in CSmileyList::GetAscii(...)");
		return "";
	}
	else
	{
		return m_Vector[iIndex].m_Ascii;
	}
}

/*********************************************************************************

	CTDVString CSmileyList::GetName(int iIndex) const

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		iIndex - the index of the name part to be retrieved
	Outputs:	-
	Returns:	The smiley filename if the index is valid, or an empty string if not
	Purpose:	Retrieves the name part of the ascii/name pair for this index.

*********************************************************************************/

CTDVString CSmileyList::GetName(int iIndex) const
{
	if (iIndex < 0 || iIndex >= GetSize())
	{
		TDVASSERT(false, "index out of range in CSmileyList::GetName(...)");
		return "";
	}
	else
	{
		return m_Vector[iIndex].m_Name;
	}
}

/*********************************************************************************

	bool CSmileyList::AddPair(const TDVCHAR* pAscii, const TDVCHAR* pName)

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		pAscii - the ascii sequence part for the new pair
				pName - the smiley filename part for the new sequence
	Outputs:	-
	Returns:	true if the pair is successfully added. Current implementation
				always returns true.
	Purpose:	Adds a new ascii-sequence/name pair to the end of the list. Hence
				pairs must be added in the order in which they should appear in the
				list. Order is important because when the translation is done ascii
				sequences that contain other ascii sequences must be done before the
				ones that they contain.

*********************************************************************************/

bool CSmileyList::AddPair(const TDVCHAR* pAscii, const TDVCHAR* pName)
{
	CSmileyPair temp(pAscii, pName);
	m_Vector.push_back(temp);
	return true;
}

/*********************************************************************************

	void CSmileyList::MakeEmpty()

	Author:		Kim Harries
	Created:	20/10/2000
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Makes the current list empty.

*********************************************************************************/

void CSmileyList::MakeEmpty()
{
	m_Vector.clear();
}
