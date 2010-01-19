#include "stdafx.h"
#include ".\UploadedObject.h"
#include "InputContext.h"

CUploadedObject::CUploadedObject(CInputContext& inputContext)
	:
	m_iId(0), 
	m_iUserId(0),
	m_InputContext(inputContext)
{
	m_SP.Initialise(m_InputContext);
}


CUploadedObject::~CUploadedObject(void)
{
}

