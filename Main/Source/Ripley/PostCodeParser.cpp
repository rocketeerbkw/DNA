// postcodeutil.cpp: implementation of the CPostCodeParser class.
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
#include ".\postcodeparser.h"
#include "tdvassert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


/*********************************************************************************

	CPostCodeParser::CPostCodeParser(void)

		Author:		DE
        Created:	02/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

CPostCodeParser::CPostCodeParser(void)
{
	/*
		THIS IS THE CURRENT UK POSTCODE PATTERN 

		(	A[BL] | B[ABDHLNRST]? |C[ABFHMORTVW] | D[ADEGHLNTY] | E[CHNX]?
		|	F[KY]|G[LUY]? | H[ADGPRSUX] | I[GMPV] | JE | K[ATWY] | L[ADELNSU]? 
		|	M[EKL]? | N[EGNPRW]? | O[LX] | P[AEHLOR] | R[GHM] | S[AEGKLMNOPRSTWY]?
		|	T[ADFNQRSW] | UB | W[ACDFNRSV]? | YO | ZE
		)	\d(?:\d|[A-Z])? \d[A-Z]{2}
	*/

	int nIndex = 0;

	//handle A[BL]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('A', "BL");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle B[ABDHLNRST]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('B', "ABDHLNRST", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle C[ABFHMORTVW]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('C', "ABFHMORTVW");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle D[ADEGHLNTY]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('D', "ADEGHLNTY");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle E[CHNX]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('E', "CHNX", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle F[KY]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('F', "KY");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle G[LUY]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('G', "LUY", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle H[ADGPRSUX]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('H', "ADGPRSUX");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle I[GMPV]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('I', "GMPV");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle J[E]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('J', "E");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle K[ATWY]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('K', "ATWY");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle L[ADELNSU]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('L', "ADELNSU", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle M[EKL]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('M', "EKL", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle N[EGNPRW]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('N', "EGNPRW", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");

	//handle O[LX]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('O', "LX");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle P[AEHLOR]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('P', "AEHLOR");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle R[GHM]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('R', "GHM");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle S[AEGKLMNOPRSTWY]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('S', "AEGKLMNOPRSTWY", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle T[ADFNQRSW]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('T', "ADFNQRSW");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle U[B]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('U', "B");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle W[ACDFNRSV]?
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('W', "ACDFNRSV", true);
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle Y[O]
	m_arrayOfPostCodeTemplates[nIndex++]  = CPostCodeTemplate::Create('Y', "O");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
	
	//handle Z[E]
	m_arrayOfPostCodeTemplates[nIndex]  = CPostCodeTemplate::Create('Z', "E");
	TDVASSERT(nIndex < TEMPLATES_ARRAY_SIZE, "Array Index is out of bounds");
}

CPostCodeParser::~CPostCodeParser(void)
{
	
}

/*********************************************************************************

	CPostCodeTemplate& CPostCodeParser::CPostCodeTemplate::operator=( const CPostCodeTemplate& rhs)

		Author:		DE
        Created:	02/02/2005
        Inputs:		- const CPostCodeTemplate& rhs
        Outputs:	-
        Returns:	-CPostCodeTemplate object
        Purpose:	-Copy operator

*********************************************************************************/

CPostCodeParser::CPostCodeTemplate& CPostCodeParser::CPostCodeTemplate::operator=( const CPostCodeTemplate& rhs)
{
	this->m_sFirstLetter = rhs.m_sFirstLetter;
	this->m_sSecondLetterSet = rhs.m_sSecondLetterSet;
	this->m_bSecondLetterIsOptional = rhs.m_bSecondLetterIsOptional;
	return *this;
}

/*********************************************************************************

	CPostCodeTemplate CPostCodeTemplate::Create( const TDVCHAR sFirstLetter, const CTDVString sSecondLetterSet, const bool bSecondLetterIsOptional)

		Author:		DE
        Created:	02/02/2005
        Inputs:		-const TDVCHAR sFirstLetter, 
						-const CTDVString sSecondLetterSet, 
						-const bool bSecondLetterIsOptional
        Outputs:	-Returns an instance of a CPostCodeTemplate object initialsed with the supplied params
        Returns:	-Returns an instance of a CPostCodeTemplate object initialsed with the supplied params
        Purpose:	-Object Creator function

*********************************************************************************/

CPostCodeParser::CPostCodeTemplate CPostCodeParser::CPostCodeTemplate::Create( const TDVCHAR sFirstLetter, const CTDVString sSecondLetterSet, const bool bSecondLetterIsOptional)
{
	CPostCodeTemplate oPostCodeTemplate;
	oPostCodeTemplate.m_sFirstLetter = sFirstLetter;
	oPostCodeTemplate.m_sSecondLetterSet = sSecondLetterSet;
	oPostCodeTemplate.m_bSecondLetterIsOptional = bSecondLetterIsOptional;
	return oPostCodeTemplate;
}


/*********************************************************************************

	bool CPostCodeParser::IsPostCode (const CTDVString sInput) const

		Author:		DE
        Created:	02/02/2005
        Inputs:		-const CTDVString sInput
        Outputs:	-True if the supplied input string is a valid uk postcode, false otherwise
        Returns:	-True if the supplied input string is a valid uk postcode, false otherwise
        Purpose:	-Determines whether a given input string is a valid uk postcode

*********************************************************************************/

bool CPostCodeParser::IsPostCode (const CTDVString sInput) const
{
	CTDVString sStringToParse  = sInput;
		
	//make uppercase
	sStringToParse.MakeUpper(  );

	//if string is empty then return false
	if ( sStringToParse.IsEmpty( ))
	{
		return false;
	}
	
	//remove all spaces
	while ( sStringToParse.Replace(" ", ""));

	//do a rudimentry length check
	if ( sStringToParse.GetLength( ) < 5)
	{
		return false;
	}

	//if string is empty after spaces have been removed then return false
	if ( sStringToParse.IsEmpty( ))
	{
		return false;
	}
		
	//get the first letter of input string 
	TDVCHAR sFirstLetter = sStringToParse.GetAt(0);
	
	//if this letter is not an alphabet return false as it cant be a postcode
	if (_istalpha(sFirstLetter)==0)
	{
		return false;
	}

	//remove the first character from the input string 
	sStringToParse.RemoveLeftChars(1);

	//do more advanced checks
	return Matches(sFirstLetter, sStringToParse);
}

/*********************************************************************************

	bool CPostCodeParser::Matches(const TDVCHAR sFirstLetter, CTDVString sInput) const

		Author:		DE
        Created:	02/02/2005
        Inputs:		-const TDVCHAR sFirstLetter 
						-CTDVString sInput
        Outputs:	-True if the supplied input string is a valid uk postcode, false otherwise
        Returns:	-True if the supplied input string is a valid uk postcode, false otherwise
        Purpose:	-iterates through the list of postcode templates looking for a poosible match

*********************************************************************************/

bool CPostCodeParser::Matches(const TDVCHAR sFirstLetter, CTDVString sInput) const
{	
	for (int nCount=0; nCount < TEMPLATES_ARRAY_SIZE; nCount++)
	{
		//check if the first letter is a valid
		//it would be valid if there is an entry in m_arrayOfPostCodeTemplates
		if (m_arrayOfPostCodeTemplates[nCount].m_sFirstLetter == sFirstLetter)
		{
			//get entry in template list which matches
			CPostCodeTemplate oThisPostCodeTemplate = m_arrayOfPostCodeTemplates[nCount];

			//parse second char to determine validity
			if ( oThisPostCodeTemplate.m_bSecondLetterIsOptional == false)
			{
				//get the second letter of original input string 
				TDVCHAR sSecondLetter = sInput.GetAt(0);
				
				//remove the second character from the input string 
				sInput.RemoveLeftChars(1);

				//here second char is mandatory and must be an alpha present in  m_sSecondLetterSet
				if ( oThisPostCodeTemplate.m_sSecondLetterSet.Find(sSecondLetter) == -1)
				{
					return false;
				}				
			}
			else
			{
				//get the second letter of original input string 
				TDVCHAR sSecondLetter = sInput.GetAt(0);
				
				//here second char is not mandatory , it should either be
				//a digit or an alpha which must be present in m_sSecondLetterSet
				if ( oThisPostCodeTemplate.m_sSecondLetterSet.Find(sSecondLetter) != -1 )
				{
					//remove the second character from the input string 
					sInput.RemoveLeftChars(1);						
				}		
				else
				{
					//if this letter is an alpha return false as it should be a member of the m_sSecondLetterSet
					if (_istalpha(sSecondLetter))
					{
						return false;
					}
				}
			}

			//get the third letter of original input string 
			TDVCHAR sThirdLetter = sInput.GetAt(0);
				
			//remove the third character from the input string 
			sInput.RemoveLeftChars(1);

			//third char must be a digit
			if ( _istdigit(sThirdLetter)  < 1)
			{
				return false;
			}
			
			//special case such as ZE4LP, which is wrong
			if ( sInput.GetLength( ) < 3 )
			{
				return false;
			}


			//get the fourth letter of original input string 
			TDVCHAR sFourthLetter = sInput.GetAt(0);
						
			//fourth character can be an apha [A-Z]			
			if (_istalpha(sFourthLetter))
			{
				//if it is simply ignore
				//and remove the fourth character from the input string 
				sInput.RemoveLeftChars(1);
			}
			else 	if ( _istdigit(sThirdLetter))
			{
				//fourth character can be a digit if char[4] and char[5] and char[6] exist 
				if ( sInput.GetLength( ) == 4 )
				{
					//if it is simply ignore
					//and remove the fourth character from the input string 
					sInput.RemoveLeftChars(1);
				}
			}

			//get the fifth or fouth char (see above) of original input string 
			TDVCHAR sFifthLetter = sInput.GetAt(0);
				
			//remove the fifth or fouth char (see above) from the input string 
			sInput.RemoveLeftChars(1);

			//fifth or fouth char (see above) must be a digit
			if ( _istdigit(sFifthLetter) < 1)
			{
				return false;
			}
			
			//get the second-to-last char of original input string 
			TDVCHAR sSecondToLastLetter = sInput.GetAt(0);
						
			//this must be an apha [A-Z]			
			if (_istalpha(sSecondToLastLetter) == -1)
			{
				//last wo charaters must be apha			
				return false;
			}
		
			//remove the  second-to-last char from the input string 
			sInput.RemoveLeftChars(1);

			//at this point, there should only be a letter left 
			//if there is not then this is assumed not to be a postcode
			if ( sInput.GetLength( ) != 1 )
			{
				return false;
			}

			//get the last char of original input string 
			TDVCHAR sLastLetter = sInput.GetAt(0);
						
			//this must be an apha [A-Z]			
			if (_istalpha(sLastLetter) == -1)
			{
				//last wo charaters must be apha			
				return false;
			}

			//passed, must be a postcode
			return true;
		}
	}
	
	return false;
}

bool CPostCodeParser::IsCloseMatch(const CTDVString sInput) const
{
	CTDVString sStringToParse  = sInput;
		
	//make uppercase
	sStringToParse.MakeUpper(  );

	//if string is empty then return false
	if ( sStringToParse.IsEmpty( ))
	{
		return false;
	}
	
	//remove all spaces
	while ( sStringToParse.Replace(" ", ""));

	//do a rudimentry length check
	if ( sStringToParse.GetLength( ) < 5)
	{
		return false;
	}

	//if string is empty after spaces have been removed then return false
	if ( sStringToParse.IsEmpty( ))
	{
		return false;
	}
		
	//get the first letter of input string 
	TDVCHAR sFirstLetter = sStringToParse.GetAt(0);
	
	//if this letter is not an alphabet return false as it cant be a postcode
	if (_istalpha(sFirstLetter)==0)
	{
		return false;
	}

	
	//get the third letter of input string, must be a digit  
	TDVCHAR sThirdLetter = sStringToParse.GetAt(2);
	if ( _istdigit(sThirdLetter) < 1)
	{
		return false;
	}
	
	//do a rudimentry length check
	if ( sStringToParse.GetLength( ) > 7)
	{
		return false;
	}

	//get the second-to-last char of original input string 
	TDVCHAR sSecondToLastLetter = sInput.GetAt(sStringToParse.GetLength( )-2);
	
	//get the last char of original input string 
	TDVCHAR sLastLetter = sInput.GetAt(sStringToParse.GetLength( )-1);

	//these must be an apha [A-Z]			
	if ( (_istalpha(sSecondToLastLetter) == -1) || (_istalpha(sLastLetter) == -1) )
	{
		//last wo charaters must be apha			
		return false;
	}		
	
	return true;
}

