// XMLStringUtils.cpp: implementation of the CXMLStringUtils class.
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
#include <string>
#include "XMLStringUtils.h"
#include "StoredProcedure.h"
#include "XMLObject.h"

/*********************************************************************************
void CXMLStringUtils::AddStrippedNameXML(CStoredProcedure& SP, const char* pFldName, CTDVString& sXML)
Author:		Igor Loboda
Created:	15/07/2004
Inputs:		SP - stored procedure object to use for getting field value
			pFldName - field to get data from
Outputs:	sXML - resulting xml
Purpose:	Gets given field from current row in SP. Stripps leading "a" or "the" and
			adds <STRIPPEDNAME> with the stripped value.
*********************************************************************************/

void CXMLStringUtils::AddStrippedNameXML(CStoredProcedure& SP, const char* pFldName, CTDVString& sXML)
{
	CTDVString sName;
	SP.GetField(pFldName, sName);
	AddStrippedNameXML(sName, sXML);
}


/*********************************************************************************
void CXMLStringUtils::AddStrippedNameXML(const char* pName, CTDVString& sXML)
Author:		Igor Loboda, David van Zijl
Created:	27/07/2004
Inputs:		sName - value of name to be stripped
Outputs:	sXML - resulting xml
Purpose:	Stripps leading "a" or "the" and adds <STRIPPEDNAME> with the stripped value.
*********************************************************************************/

void CXMLStringUtils::AddStrippedNameXML(const char* pName, CTDVString& sXML)
{
	CTDVString sName = pName;
	if (sName.FindText("a ") == 0)
	{
		sName.RemoveLeftChars(2);
	}
	else if (sName.FindText("the ") == 0)
	{
		sName.RemoveLeftChars(4);
	}
	CXMLObject::EscapeXMLText(&sName);

	sXML << "<STRIPPEDNAME>" << sName << "</STRIPPEDNAME>";
}

/*********************************************************************************

	bool CXMLStringUtils::AppendStatusTag(int iStatus,CTDVString& sXML)

	Author:		Mark Neves
	Created:	09/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	-

*********************************************************************************/

bool CXMLStringUtils::AppendStatusTag(int iStatus,CTDVString& sXML)
{
	bool bKnownStatus = true;
	CTDVString sStatusString = "";

	switch (iStatus)
	{
		case 0:  sStatusString = "No Status"; break;
		case 1:  sStatusString = "Edited"; break;
		case 2:  sStatusString = "User Entry, Private"; break;
		case 3:  sStatusString = "User Entry, Public"; break;
		case 4:  sStatusString = "Recommended"; break;
		case 5:  sStatusString = "Locked by Editor"; break;
		case 6:  sStatusString = "Awaiting Editing"; break;
		case 7:  sStatusString = "Cancelled"; break;
		case 8:  sStatusString = "User Entry, Staff-locked"; break;
		case 9:  sStatusString = "Key Entry"; break;
		case 10: sStatusString = "General Page"; break;
		case 11: sStatusString = "Awaiting Rejection"; break;
		case 12: sStatusString = "Awaiting Decision"; break;
		case 13: sStatusString = "Awaiting Approval"; break;

		default: sStatusString = "Unknown"; 
				 bKnownStatus = false;
				 break;
	}

	sXML << "<STATUS TYPE=\"" << iStatus << "\">" << sStatusString << "</STATUS>";

	return bKnownStatus;
}


/*********************************************************************************
void CXMLStringUtils::Split(const TDVCHAR* pStringToSplit, const TDVCHAR* pDelim, std::vector<CTDVString>& vResults)
Author:		David van Zijl
Created:	13/08/2004
Inputs:		pStringToSplit - String to split
			pDelim - delimiter to split on
Outputs:	vResults - vector to store results
Purpose:	Splits a string up into pieces and stores the result in a vector
*********************************************************************************/

void CXMLStringUtils::Split(const TDVCHAR* pStringToSplit, const TDVCHAR* pDelim, std::vector<CTDVString>& vResults)
{
	vResults.clear();

	CTDVParseString sWorking = pStringToSplit;
	int iEnd = 0;

	// Keep eating blocks of text to the left of the delimiter
	// and adding it to the vector
	//
	while (iEnd != -1 && sWorking.GetLength() > 0)
	{
		iEnd = sWorking.Find(pDelim);
		if (iEnd != -1)
		{
			// Found one
			//
			if (iEnd > 0) // ie string doesnt start with the delimiter
			{
				CTDVString newElement = sWorking.Left(iEnd);
				vResults.push_back(newElement);
			}
			sWorking.RemoveLeftChars(iEnd + 1);
		}
	}

	// What is left in sStringToSplit should now be delimiter-less
	//
	if (sWorking.GetLength() > 0)
	{
		CTDVString newElement = sWorking;
		vResults.push_back(newElement);
	}
}

void CXMLStringUtils::SplitCsvIntoInts(const TDVCHAR* pStringToSplit, std::vector<int>& vResults)
{
	vResults.clear();

	std::vector<CTDVString> vIntsAsStrings;
	Split(pStringToSplit, ",", vIntsAsStrings);

	// Transpose strings into integers
	//
	std::vector<CTDVString>::iterator i;

	for (i = vIntsAsStrings.begin(); i != vIntsAsStrings.end(); i++)
	{
		int iResult = atoi(*i);
		vResults.push_back(iResult);
	}
}
