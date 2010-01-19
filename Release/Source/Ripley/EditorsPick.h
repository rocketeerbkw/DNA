// EditorsPick.h: interface for the EditCategory class.
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
#if !defined(AFX_EDITORSPICK_H__85D4E8DF_291C_4BA8_A520_72750293851B__INCLUDED_)
#define AFX_EDITORSPICK_H__85D4E8DF_291C_4BA8_A520_72750293851B__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "XMLObject.h"

/*
CEditors Pick class - Builds Links XML for use in the Editors Pick Page.
Also processes Links selections.
Could be a separate Builder rather than an XMLObject.
Current use however is a specialist step in the textbox builder.
*/

class CEditorsPick : public CXMLObject
{
public:
	CEditorsPick(CInputContext& inputContext);
	~CEditorsPick(void);

	bool	Initialise( int iTextBoxID );
	bool	Process( int iTextBoxID );
};

#endif // !defined(AFX_EDITORSPICK_H__85D4E8DF_291C_4BA8_A520_72750293851B__INCLUDED_)