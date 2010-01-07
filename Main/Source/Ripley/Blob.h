// Blob.h: interface for the CBlob class.
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


#if !defined(AFX_BLOB_H__71757000_F8D2_11D3_BD6D_00A02480D5F4__INCLUDED_)
#define AFX_BLOB_H__71757000_F8D2_11D3_BD6D_00A02480D5F4__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "CGI.h"

/*
	class CBlob

	Author:		Oscar Gillespie
	Created:	13/03/2000
	Inherits:	CXMLObject
	Purpose:	a nice CXMLObject subclass that has all the information
				it needs to know about where the blob (binary file) it represents
				can be found and displayed, including MIME type, server name,
				path name and filename. 
*/


class CBlob : public CXMLObject
{
public:
	CBlob(CInputContext& inputContext);
	virtual ~CBlob();

	bool Initialise(int iBlobID, const TDVCHAR* BGColour = NULL);
	bool Initialise(const TDVCHAR* pBlobName, const TDVCHAR* BGColour = NULL);
};

#endif // !defined(AFX_BLOB_H__71757000_F8D2_11D3_BD6D_00A02480D5F4__INCLUDED_)
