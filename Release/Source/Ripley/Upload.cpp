// Upload.cpp: implementation of the CUpload class.
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
#include "tdvassert.h"
#include "Upload.h"
#include "StoredProcedure.h"

/*********************************************************************************

	CUpload::CUpload(CInputContext& inputContext)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CUpload::CUpload(CInputContext& inputContext) : CXMLObject(inputContext)
{
}

/*********************************************************************************

	CUpload::~CUpload()

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

CUpload::~CUpload()
{
}

/*********************************************************************************

	bool CUpload::Add(int iTeamID,int iUserID,CTDVString& sFileName,int iFileType,int& iUploadID)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUpload::Add(int iTeamID,int iUserID,CTDVString& sFileName,int iFileType,int& iUploadID)
{
	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	bool bSuccess = false;
	if (!SP.AddNewUpload(iTeamID,iUserID,sFileName,iFileType,iUploadID,bSuccess))
	{
		return false;
	}

	return bSuccess;
}

/*********************************************************************************

	bool CUpload::UpdateStatus(int iUploadID,int iNewStatus)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUpload::UpdateStatus(int iUploadID,int iNewStatus)
{
	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	bool bSuccess = false;
	if (!SP.UpdateUploadStatus(iUploadID,iNewStatus,bSuccess))
	{
		return false;
	}

	return bSuccess;
}

/*********************************************************************************

	bool CUpload::GetUploadsForTeam(int iTeamID,CTDVString& sTeamUploadsXML)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUpload::GetUploadsForTeam(int iTeamID,CTDVString& sTeamUploadsXML)
{
	sTeamUploadsXML.Empty();

	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	bool bSuccess = false;
	if (!SP.GetUploadsForTeam(iTeamID,bSuccess))
	{
		return false;
	}

	if (bSuccess)
	{
		sTeamUploadsXML << "<TEAMUPLOADS>";
		GetUploadsAsXML(SP,sTeamUploadsXML);
		sTeamUploadsXML << "</TEAMUPLOADS>";
	}

	return bSuccess;
}

/*********************************************************************************

	bool CUpload::GetUploadsForUser(int iUserID,CTDVString& sUserUploadsXML)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUpload::GetUploadsForUser(int iUserID,CTDVString& sUserUploadsXML)
{
	sUserUploadsXML.Empty();

	CStoredProcedure SP;
	
	if (!m_InputContext.InitialiseStoredProcedureObject(&SP))
	{
		TDVASSERT(false, "No stored procedure created");
		return false;
	}

	bool bSuccess = false;
	if (!SP.GetUploadsForUser(iUserID,bSuccess))
	{
		return false;
	}

	if (bSuccess)
	{
		sUserUploadsXML << "<USERUPLOADS>";
		GetUploadsAsXML(SP,sUserUploadsXML);
		sUserUploadsXML << "</USERUPLOADS>";
	}

	return bSuccess;
}

/*********************************************************************************

	void CUpload::GetUploadsAsXML(CStoredProcedure& SP,CTDVString& sXML)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

void CUpload::GetUploadsAsXML(CStoredProcedure& SP,CTDVString& sXML)
{
	while (!SP.IsEOF())
	{
		sXML << "<UPLOAD>";

		CTDVString sFileName,sNotes;
		SP.GetField("filename",sFileName);
		SP.GetField("notes",sNotes);

		CTDVDateTime oDateUploaded;
		CTDVString sDateUploaded;
		oDateUploaded = SP.GetDateField("DateUploaded");
		oDateUploaded.GetAsXML(sDateUploaded);

		CTDVDateTime oLastStatusChange;
		CTDVString sLastStatusChange;
		if (!SP.IsNULL("LastStatusChange"))
		{
			oLastStatusChange = SP.GetDateField("LastStatusChange");
			oLastStatusChange.GetAsXML(sLastStatusChange);
		}

		sXML << "<TEAMID>"			<< SP.GetIntField("teamid")		<< "</TEAMID>";
		sXML << "<USERID>"			<< SP.GetIntField("userid")		<< "</USERID>";
		sXML << "<FILENAME>"		<< sFileName					<< "</FILENAME>";
		sXML << "<FILETYPE>"		<< SP.GetIntField("filetype")	<< "</FILETYPE>";
		sXML << "<NOTES>"			<< sNotes						<< "</NOTES>";
		sXML << "<STATUS>"			<< SP.GetIntField("status")		<< "</STATUS>";
		sXML << "<DATEUPLOADED>"	<< sDateUploaded				<< "</DATEUPLOADED>";
		sXML << "<LASTSTATUSCHANGE>" << sLastStatusChange			<< "</LASTSTATUSCHANGE>";

		sXML << "</UPLOAD>";

		SP.MoveNext();
	}
}


/*********************************************************************************

	bool CUpload::VerifyUserCanUpload(UserID)

	Author:		Mark Neves
	Created:	09/09/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CUpload::VerifyUserCanUpload(int iUserID)
{
	return true;
}

