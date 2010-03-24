// SkinDetails.cpp: implementation of the CSkinDetails class.
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
#include "ripleyserver.h"
#include "SkinDetails.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CSkinDetails::CSkinDetails()
{

}

CSkinDetails::~CSkinDetails()
{

}

bool CSkinDetails::GetDescription(CTDVString* oDescription)
{
	*oDescription = m_Description;
	return true;
}

bool CSkinDetails::GetName(CTDVString* oName)
{
	*oName = m_SkinName;
	return true;
}

CSkinDetails::CSkinDetails(const CSkinDetails &other) : m_SkinName(other.m_SkinName),
														m_Description(other.m_Description),
														m_bUseFrames(other.m_bUseFrames)
														
{

}

CSkinDetails::CSkinDetails(const TDVCHAR *pName, const TDVCHAR *pDescription, bool bUseFrames) 
: m_SkinName(pName),
m_Description(pDescription),
m_bUseFrames(bUseFrames)
{

}

bool CSkinDetails::GetUseFrames()
{
	return m_bUseFrames;
}
