// MultiStep.cpp: implementation of the CMultiStep class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "MultiStep.h"
#include "tdvassert.h"
#include "InputContext.h"

#define NUM_VALIDATION_CODES 4
static const TDVCHAR* pValidationErrors[NUM_VALIDATION_CODES] = 
	{	"VALIDATION-ERROR-EMPTY",
		"VALIDATION-ERROR-NEQ",
		"VALIDATION-ERROR-PARSE",
		"VALIDATION-ERROR-CUSTOM"
	};

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CMultiStep::CMultiStep(CInputContext& inputContext, const TDVCHAR* sType,int iMaxNumElements /*50*/)
:m_sType(sType),
 m_iMaxElements(iMaxNumElements),
 m_bFinished(false),
 m_bCancelled(false),
 m_iCurrStage(0),
 m_iNumErrors(0),
 m_bValidUser(false),
 m_pInputTree(NULL),
	m_InputContext(inputContext)
{

}

CMultiStep::~CMultiStep()
{
	//delete the required parameters
	MULTIVALMAP::iterator rit;
	for (rit = m_RequiredMap.begin();rit != m_RequiredMap.end();rit++)
	{
		delete rit->second;
	}

	//delete the element parameters
	MULTIVALMAP::iterator eit;
	for (eit = m_ElementMap.begin();eit != m_ElementMap.end(); eit++)
	{
		delete eit->second;
	}

	//delete the input tree if it exists
	delete m_pInputTree;
}

/*********************************************************************************

	bool CMultiStep::AddRequiredParam(const TDVCHAR* sRequiredParam, 
									  const TDVCHAR* sDefaultValue,
									  bool bEscaped
									  bool bFileType
									  bool bRawInput)

	Author:		Dharmesh Raithatha
	Created:	6/11/2003
	Inputs:		sRequiredParam - required parameter that you want to get
				sDefaultValue - the default value if it isn't supplied
				bEscaped - the param's default Escaped setting
				bFileType - the file type
				bRawInput - whether the field needs to be treated as raw input
	Outputs:	-
	Returns:	true if successfully added false otherwise
	Purpose:	Adds the requiredparam to the list and gives it a defualt value 
				so if it isn't in the input it will have a value.

*********************************************************************************/

bool CMultiStep::AddRequiredParam(const TDVCHAR* sRequiredParam, const TDVCHAR* sDefaultValue, bool bEscaped, bool bFileType, bool bRawInput)
{
	CTDVString s(sRequiredParam);

	//case insensitive for names
	s.MakeUpper();
	
	if (m_RequiredMap.find(s) == m_RequiredMap.end())
	{
		//create a new multival and set the error code 
		multival* m = new multival;
		if (m != NULL)
		{
			SetMultivalValue(m,sDefaultValue);
			m->SetEscapedFlag(bEscaped);
			m->SetRawInputFlag(bRawInput);
			m->SetFileTypeFlag(bFileType);

			pair<CTDVString,multival*> param(s,m);
			
			m_RequiredMap.insert(param);
			
			return true;
		}
		else
		{
				TDVASSERT(false,"CMultiStep::AddRequiredParam failed to create a multival");
		}
	}
	else
	{
		TDVASSERT(false,"CMultiStep::AddRequiredParam duplicate param");
	}

	return false;
}

/*********************************************************************************

	int CMultiStep::GetNumberOfElements()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	The number of elements that are to be collected
	Purpose:	Returns the total number of elements that are to be collected

*********************************************************************************/

int CMultiStep::GetNumberOfElements()
{
	return m_ElementMap.size();
}

/*********************************************************************************

	bool CMultiStep::ProcessInput()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		pInputContext - the current inputcontext
	Outputs:	-
	Returns:	true if successfully initialised 
	Purpose:	initialises the multistep given the input context. Call this after
				you have added the required params to the list.

*********************************************************************************/

bool CMultiStep::ProcessInput()
{
	CUser* pUser = m_InputContext.GetCurrentUser();
	
	//check if the user is present
	if (pUser == NULL)
	{
		m_iNumErrors++;
		m_bValidUser = false;
	}
	else
	{
		m_bValidUser = true;
	}

	//grab the xml input from _msxml
	CTDVString sMSXML;

	if (m_InputContext.ParamExists("_msxml"))
	{
		m_InputContext.GetParamString("_msxml",sMSXML,0);
	}
	else
	{
		CreateMSXMLFromSeed(sMSXML);
	}

	if (ProcessMSXML(sMSXML))
	{
		// Fill in the required params
		GetRequiredParamsFromInput();

		// Fill in the element params
		GetElementParamsFromInput();
	
		if (m_bValidUser)
		{
			VerifyFinished();
			CheckCancelled();
		}
	}

	//if it doesn't exist it will return 0
	m_iCurrStage = m_InputContext.GetParamInt("_msstage");
	
	return true;
}


/*********************************************************************************

	bool CMultiStep::ProcessMSXML(CTDVString& sMSXML)

		Author:		Mark Neves
        Created:	18/05/2004
        Inputs:		sMSXML = XML string defining the MSXML structure
        Outputs:	m_pInputTree points to the MSXML tree 
        Returns:	true if OK, false otherwise
        Purpose:	-

*********************************************************************************/

bool CMultiStep::ProcessMSXML(CTDVString& sMSXML)
{
	//you can't use this twice
	if (ProcessedMSXML())
	{
		return false;
	}

	m_pInputTree = CXMLTree::Parse(sMSXML);
		
	if (m_pInputTree == NULL)
	{
		//should always be valid xml
		TDVASSERT(false,"MULTISTEP::ProcessInput");
		return false;
	}
	
	// Scan through the tags, and process the attributes, updating the map items as it goes
	ProcessMapAttrs(m_RequiredMap,"REQUIRED");

	// Create the element map, and fill it with params from the input context
	// NB:  The 'REQUIRED' param map is created via calls to AddRequiredParam()
	CreateElementMap();

	// Scan through the tags, and process the attributes, updating the map items as it goes
	ProcessMapAttrs(m_ElementMap,"ELEMENT");
	
	return true;
}

/*********************************************************************************

	void CMultiStep::SetMSXMLSeed(const TDVCHAR* pMSXMLSeed)

		Author:		Mark Neves
        Created:	18/05/2004
        Inputs:		pMSXMLSeed = ptr to string to seed auto-generation MSXML
        Outputs:	-
        Returns:	-
        Purpose:	The "seed" for auto MSXML generation is basically the "<GUIDE>...</GUIDE>" 
					body text of an article.

*********************************************************************************/

void CMultiStep::SetMSXMLSeed(const TDVCHAR* pMSXMLSeed)
{
	if (pMSXMLSeed != NULL)
	{
		m_MSXMLSeed = pMSXMLSeed;
	}
}

/*********************************************************************************

	void CMultiStep::CreateMSXMLFromSeed(CTDVString& sMSXML)

		Author:		Mark Neves
        Created:	18/05/2004
        Inputs:		-
        Outputs:	sMSXML is filled with a MSXML structure
        Returns:	-
        Purpose:	Generates an MSXML structure (i.e. <MULTI-INPUT>...</MULTI-INPUT>)
					based on the body text seed set by a call to SetMSXMLSeed().

					If the multistep system doesn't recieve an _msxml parameter in the input
					context, it will attempt to create one using the seed string.

					The seed string is usually the body text of an article.  It looks through the
					tags within the body text, and creates an <ELEMENT> tag for each of them,
					unless it finds that a Required param has already been specified.  Required 
					params are added to sMSXML at the end as <REQUIRED> tags, using the function
					GetRequiredForMSXML()

					It also tries to determine if a tag's data is GuideML or has been escaped.
					It needs to know this, otherwise it won't population the <VALUE-EDITABLE>
					tag correctly.

*********************************************************************************/

void CMultiStep::CreateMSXMLFromSeed(CTDVString& sMSXML)
{
	sMSXML = "<MULTI-INPUT>";

	CXMLTree* pMSXMLTree = CXMLTree::Parse(m_MSXMLSeed);

	if (pMSXMLTree != NULL)
	{
		// Assume the "seed" text is a guide's body text
		CXMLTree* pNode = pMSXMLTree->FindFirstTagName("GUIDE", 0, false);
		if (pNode != NULL)
		{
			pNode = pNode->GetFirstChild();

			while (pNode != NULL)
			{
				CTDVString sName = pNode->GetName();

				// Examine the tag's XML to see if it's escaped text, or actual GuideML
				CTDVString sXML;
				pNode->OutputChildrenXMLTree(sXML);
				bool bEscaped = !IsGuideML(sXML);

				multival* m = GetMapItem(m_RequiredMap, sName);
				if (m == NULL)
				{
					// It's not in the Required map, so assume it's an ELEMENT tag
					sMSXML << "<ELEMENT NAME='" << sName << "' ESCAPED='" << bEscaped <<"'/>";
				}
				else
				{
					// Set the Escaped flag here.  This setting will materialise via the call
					// to GetRequiredForMSXML() at the end
					m->SetEscapedFlag(bEscaped);
				}

				// We want the next sibling node (we're not interested in the child nodes)
				pNode = pNode->FindNextNoChild();
			}
		}

		// We don't want memory leaks
		delete pMSXMLTree;
	}

	// Append the <REQUIRED> tags
	GetRequiredForMSXML(sMSXML);
	sMSXML << "</MULTI-INPUT>";
}


/*********************************************************************************

	bool CMultiStep::IsGuideML(CTDVString sXML)

		Author:		Mark Neves
        Created:	18/05/2004
        Inputs:		sXML = the text to examine
        Outputs:	-
        Returns:	true if this is GuideML, false otherwise
        Purpose:	Determines if the text given is Guide ML or not
					(should be moved to CXMLObject at some stage)

*********************************************************************************/

bool CMultiStep::IsGuideML(CTDVString sXML)
{
	bool bGuideML = false;

	// Have to remove BR tags, as they get inserted into escaped fields to preserve
	// CR/LN sequences.  If we leave them in, it'll look like GuideML when it ain't
//	sXML.Replace("<BR />","");

	// Create a tag and parse it as a piece of XML
	CTDVString sTag = CXMLObject::MakeTag("TAG",sXML);
	CXMLTree* pTree = CXMLTree::Parse(sTag);
	if (pTree != NULL)
	{
		CTDVString sText;
		pTree->GetTextContentsRaw(sText);

		// If the raw text content of the tree is different to the original text
		// (minus BR tags) then it contained XML tags, therefore can be assumed
		// to be GuideML
		bGuideML = !sText.CompareText(sXML);

		// No memory leaks please.
		delete pTree;
		pTree = NULL;
	}

	return bGuideML;
}

/*********************************************************************************

	bool CMultiStep::VerifyFinished()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		pInputContext - current inputcontext
	Outputs:	-
	Returns:	true if all the required params are present and element tags are
				present, will also set the m_bFinished flag if this is the case.
	Purpose:	verifies that the multistep process has actually finished if it 
				given the command via the input context

*********************************************************************************/

bool CMultiStep::VerifyFinished()
{
	m_bFinished = false;

	if (!m_InputContext.ParamExists("_msfinish"))
	{
		return false;
	}
	
	CTDVString sFinishVal;
	m_InputContext.GetParamString("_msfinish",sFinishVal);
	
	if (!sFinishVal.CompareText("yes"))
	{
		return false;
	}
	
	//go through all the required params and check that they are all ok

	MULTIVALMAP::iterator it;

	for (it = m_RequiredMap.begin();it != m_RequiredMap.end();it++)
	{
		if (!ParameterValidated(it->second))
		{
			return false;
		}
	}

	//go through the elements and check that they are all ok
	
	for (it = m_ElementMap.begin();it != m_ElementMap.end();it++)
	{
		//validation is defined by via the input tree
		if (!ParameterValidated(it->second))
		{
			return false;
		}
	}

	m_bFinished = true;
	
	return true;
}

/*********************************************************************************

	bool CMultiStep::CheckCancelled()

	Author:		Mark Neves
	Created:	01/08/2003
	Inputs:		pInputContext = an input context
	Outputs:	-
	Returns:	true if a param calle "_mscancel" exists
	Purpose:	Used to determine if the user has cancelled the multistep process.
				This is indictated via the UI by placing a param called "_mscancel"
				in the param list

*********************************************************************************/

bool CMultiStep::CheckCancelled()
{
	m_bCancelled = m_InputContext.ParamExists("_mscancel");
	return m_bCancelled;
}

/*********************************************************************************

	void CMultiStep::GetRequiredParamsFromInput()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		pInputContext - current input context 
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Gets the required params from the input context and sets the 
				appropriate values or errorcode. Ignores duplicates.

*********************************************************************************/

bool CMultiStep::GetRequiredParamsFromInput()
{
	if (m_RequiredMap.empty())
	{
		return false;
	}

	MULTIVALMAP::iterator it = m_RequiredMap.begin();

	for (it;it != m_RequiredMap.end();it++)
	{
		CTDVString sMapKey = it->first;
		multival* m = it->second;

		if (m_InputContext.ParamExists(sMapKey))
		{
			if (m_InputContext.ParamExists(sMapKey,1))
			{
				CTDVString sError = "in CMultiStep::GetRequiredParams duplicate param found - '";
				sError << sMapKey << "'";
				TDVASSERT(false,sError);
			}
			
			CTDVString sParam;
			m_InputContext.GetParamString(sMapKey,sParam);
			SetMultivalValue(m,sParam);

			ValidateRequiredParameter(sMapKey,m);	
		}
		else
		{
			//the parameter isn't supplied so we need to check if there is a default
			//if there isn't then we want to set the validation to NONE
			//if there is a default then we just let it through by setting 
			//both the codes and results to NONE
			
			//no default
			if (m->GetValue().IsEmpty())
			{
				m->SetValidationResults(MULTISTEP_VALCODE_NONE);
			}
			//we have a default.
			else
			{
				m->SetValidationResults(MULTISTEP_VALCODE_NONE);
				m->SetValidationCodes(MULTISTEP_VALCODE_NONE);
			}
		}
	}

	return true;
}

/*********************************************************************************

	void CMultiStep::GetElementParamsFromInput()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		pInputContext - current input context
	Outputs:	-
	Returns:	true if successful, false otherwise
	Purpose:	Gets the elements from the inputcontext. This is based on the 
				multistage process where elements come in the form of
				element = name, name=value. no duplicates and no overlaps with 
				the required params.

*********************************************************************************/

bool CMultiStep::GetElementParamsFromInput()
{
	int iIndex = 0;
	
	CTDVString sElement;
	CTDVString sElementXML;
	
	CXMLTree* pKey = m_pInputTree->FindFirstTagName("ELEMENT", 0, false);

	//if no node is found the root is returned which we need to check for
	//its alright to have no elements as this is defined by the stylesheet
	if (pKey == NULL)
	{
		return false;
	}

	while (pKey != NULL)
	{
		CTDVString sElement;

		//get the name of the element
		pKey->GetAttribute("NAME",sElement);
		sElement.MakeUpper();

		multival* m = GetMapItem(m_ElementMap,sElement);
		if (m != NULL && m_InputContext.ParamExists(sElement))
		{
			CTDVString sParam;
			m_InputContext.GetParamString(sElement,sParam);
			SetMultivalValue(m,sParam);

			ValidateParameterFromTree(m,pKey,sElement);
		}
		
		pKey = pKey->FindNextTagNode("ELEMENT");
	}

	return true;
}

/*********************************************************************************

	void CMultiStep::SetMultivalValue(multival* m,const TDVCHAR* pValue)

		Author:		Mark Neves
        Created:	29/03/2004
        Inputs:		m = ptr to a multival object
					pValue = ptr to string value
        Outputs:	-
        Returns:	-
        Purpose:	Sets the Value and ValueEditable members of m with pValue.
					The function does any necessary escaping of the value before
					assigning it to m's member vars.
					
*********************************************************************************/

void CMultiStep::SetMultivalValue(multival* m,const TDVCHAR* pValue)
{
	if (m != NULL && pValue != NULL)
	{
		CTDVString sValue(pValue), sValueEditable;
		if (m->IsEscaped())
		{
			CXMLObject::EscapeAllXML(&sValue);
			sValueEditable = sValue;
		}
		else if (m->IsRawInput())
		{
			sValueEditable = sValue;
			CXMLObject::EscapeAllXML(&sValueEditable);
		}
		else
		{
			CXMLObject::FixAmpersand(sValue);
			sValueEditable = sValue;
			CXMLObject::EscapeAllXML(&sValueEditable);
		}

		m->SetValue(sValue);
		m->SetValueEditable(sValueEditable);
	}
}


/*********************************************************************************

	bool CMultiStep::CreateElementMap()

		Author:		Mark Neves
        Created:	29/03/2004
        Inputs:		-
        Outputs:	m_ElementMap members created
        Returns:	-
        Purpose:	This iterates through all ELEMENT tags in this multistep object
					and creates a map entry for each one it finds

*********************************************************************************/

void CMultiStep::CreateElementMap()
{
	m_ElementMap.clear();

	CTDVString sElement;
	
	CXMLTree* pKey = m_pInputTree->FindFirstTagName("ELEMENT", 0, false);

	while (pKey != NULL)
	{
		//get the name of the element
		pKey->GetAttribute("NAME",sElement);
		sElement.MakeUpper();

		multival* m = new multival;
		pair<CTDVString,multival*> param(sElement,m);
		m_ElementMap.insert(param);

		pKey = pKey->FindNextTagNode("ELEMENT");
	}
}

/*********************************************************************************

	int CMultiStep::GetCurrentStage()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	returns the current stage
	Purpose:	returns the current stage

*********************************************************************************/

int CMultiStep::GetCurrentStage()
{
	return m_iCurrStage;
}

/*********************************************************************************

	bool CMultiStep::GetElementValue(const TDVCHAR* sElementName,CTDVString& sElementVal, bool* pbEscaped)

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		sElementName - name of the element 
				pbEscaped = ptr to receive the "Escaped" flag status, if you need it
	Outputs:	value of the element
	Returns:	true if element exists and has a value, false in any other case
	Purpose:	Returns the value of an element

*********************************************************************************/

bool CMultiStep::GetElementValue(const TDVCHAR* sElementName,CTDVString& sElementVal, bool* pbEscaped, bool* pbRawInput)
{
	return GetMapValue(m_ElementMap,sElementName,sElementVal, pbEscaped, pbRawInput);
}

/*********************************************************************************

	CTDVString CMultiStep::GetElementValue(const TDVCHAR* sElementName)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Same as the other GetElementValue(), just the return value is the
					param value.

*********************************************************************************/

CTDVString CMultiStep::GetElementValue(const TDVCHAR* sElementName)
{
	CTDVString sValue;
	GetElementValue(sElementName,sValue);
	return sValue;
}

/*********************************************************************************

	bool CMultiStep::GetRequiredValue(const TDVCHAR* sRequiredParam,CTDVString& sValue, bool* pbEscaped)

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		sRequiredParam - name of the requried parameter
				pbEscaped = ptr to receive the "Escaped" flag status, if you need it
	Outputs:	value of parameter if present
	Returns:	true if value present
	Purpose:	gets the value of the required parameter

*********************************************************************************/

bool CMultiStep::GetRequiredValue(const TDVCHAR* sRequiredParam,CTDVString& sValue, bool* pbEscaped, bool* pbRawInput)
{
	return GetMapValue(m_RequiredMap, sRequiredParam, sValue, pbEscaped, pbRawInput);
}

/*********************************************************************************

	CTDVString CMultiStep::GetRequiredValue(const TDVCHAR* sRequiredParam)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	Same as the other GetRequiredValue(), except the return value is
					the param value

*********************************************************************************/

CTDVString CMultiStep::GetRequiredValue(const TDVCHAR* sRequiredParam)
{
	CTDVString sValue;
	GetRequiredValue(sRequiredParam,sValue);
	return sValue;
}

/*********************************************************************************

	bool CMultiStep::GetMapValue(MULTIVALMAP& mMap, const TDVCHAR* sParam,CTDVString& sValue, bool* pbEscaped)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		mMap = the map in question
				sParam = the param in the map you want
				pbEscaped = ptr to receive the "Escaped" flag status, if you need it
	Outputs:	sValue = the value of that param
	Returns:	true if value present
	Purpose:	gets the value of the map parameter

*********************************************************************************/

bool CMultiStep::GetMapValue(MULTIVALMAP& mMap, const TDVCHAR* sParam, CTDVString& sValue, bool* pbEscaped, bool* pbRawInput)
{
	sValue.Empty();
	
	CTDVString s(sParam);
	s.MakeUpper();

	MULTIVALMAP::iterator it = mMap.find(s);
	if (it != mMap.end())
	{
		CTDVString sMapKey = it->first;
		multival* m = it->second;

		sValue = m->GetValue();
		if (pbEscaped != NULL)
		{
			*pbEscaped = m->IsEscaped();
		}

		if (pbRawInput != NULL)
		{
			*pbRawInput = m->IsRawInput();
		}
		return true;
	}

	return false;
}

/*********************************************************************************

	multival* CMultiStep::GetMapItem(MULTIVALMAP& mMap, const TDVCHAR* pItemName)

	Author:		Mark Neves
	Created:	10/02/2004
	Inputs:		mMap = the map in question
				pItemName = the name of the map item
	Outputs:	-
	Returns:	ptr to the map item, or NULL if not found
	Purpose:	Finds the map item given it's name

*********************************************************************************/

multival* CMultiStep::GetMapItem(MULTIVALMAP& mMap, const TDVCHAR* pItemName)
{
	multival* pMultival = NULL;

	CTDVString s(pItemName);
	s.MakeUpper();

	MULTIVALMAP::iterator it = mMap.find(s);
	if (it != mMap.end())
	{
		pMultival = it->second;
	}

	return pMultival;
}

/*********************************************************************************

	bool CMultiStep::GetRequiredValue(const TDVCHAR* sRequiredParam,int &iValue)

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		sRequiredParam - name of the required parameter
				pbEscaped = ptr to receive the "Escaped" flag status, if you need it
	Outputs:	value of parameter if present as int
	Returns:	true if value present
	Purpose:	gets the value of the required parameter as integer
*********************************************************************************/

bool CMultiStep::GetRequiredValue(const TDVCHAR* sRequiredParam, int &iValue, bool* pbEscaped, bool* pbRawInput)
{
	iValue = -1;
	CTDVString sVal;
	
	if (GetRequiredValue(sRequiredParam,sVal,pbEscaped,pbRawInput))
	{
		iValue = atoi(sVal);
		return true;
	}

	return false;
}

/*********************************************************************************

	void CMultiStep::GetRequiredMapAsXML(CTDVString& sXML)

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	sXML - string to insert string into
	Returns:	false if no requiredparams
	Purpose:	gets the required params as an xml string

*********************************************************************************/

void CMultiStep::GetRequiredMapAsXML(CTDVString& sXML)
{
	GetMapAsXML(m_RequiredMap,"MULTI-REQUIRED",sXML);
}

/*********************************************************************************

	void CMultiStep::GetElementMapAsXML(CTDVString& sXML)

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	sXML - String to fill with the xml of the elements
	Returns:	true if successful created the xml, false if no elements
	Purpose:	Returns the elements as a single xml string of the format

*********************************************************************************/

void CMultiStep::GetElementMapAsXML(CTDVString& sXML)
{
	GetMapAsXML(m_ElementMap,"MULTI-ELEMENT",sXML);
}

/*********************************************************************************

	void CMultiStep::GetMapAsXML(MULTIVALMAP& map,const TDVCHAR* pTagName, CTDVString& sXML)

	Author:		Markn
	Created:	29/03/2004
	Inputs:		map		= a map
				pTagName= name of the tag to put each map item in
	Outputs:	sXML - String to fill with the xml of the map
	Returns:	-
	Purpose:	Returns the map items as a single xml string of the format
					<[pTagName] NAME='[itemKey]'>
						<VALUE>[itemValue]</VALUE>
						<VALUE-EDITABLE>[itemEditableValue]</VALUE-EDITABLE>
					</[pTagName]>
					...

*********************************************************************************/

void CMultiStep::GetMapAsXML(MULTIVALMAP& map,const TDVCHAR* pTagName, CTDVString& sXML)
{
	if (pTagName == NULL)
	{
		return;
	}

	MULTIVALMAP::iterator it;

	for (it = map.begin();it != map.end();it++)
	{
		CTDVString sMapKey = it->first;
		multival* m = it->second;

		sXML << "<" << pTagName << " NAME='" << sMapKey << "'>";

		if (!ParameterValidated(m))
		{
			//put in errors according to the errors found
			AppendValidationErrors(sXML,m);
		}

		CTDVString sValue		  = m->GetValue();
		CTDVString sValueEditable = m->GetValueEditable();

		EnsureValueParses(sValue);

		sXML <<"<VALUE>"		  << sValue			<< "</VALUE>";
		sXML <<"<VALUE-EDITABLE>" << sValueEditable << "</VALUE-EDITABLE>";
		
		sXML << "</" << pTagName << ">";
	}
}

/*********************************************************************************

	void CMultiStep::GetRequiredForMSXML(CTDVString& sMSXML)

		Author:		Mark Neves
        Created:	18/05/2004
        Inputs:		-
        Outputs:	sMSXML is filled with a <MULTI-INPUT> structure
        Returns:	-
        Purpose:	See GetMapForMSXML()

*********************************************************************************/

void CMultiStep::GetRequiredForMSXML(CTDVString& sMSXML)
{
	GetMapForMSXML(m_RequiredMap,"REQUIRED",sMSXML);
}

/*********************************************************************************

	void CMultiStep::GetMapForMSXML(MULTIVALMAP& map,const TDVCHAR* pTagName, CTDVString& sMSXML)

		Author:		Mark Neves
        Created:	18/05/2004
        Inputs:		map = the map you want to use for the job
					pTagName = the name of the tags you want to generate
        Outputs:	sMSXML is filled with a <MULTI-INPUT> structure
        Returns:	-
        Purpose:	Appends tags of name pTagName to sMSXML, populating the NAME and ESCAPED
					attribs based on the map entries

*********************************************************************************/

void CMultiStep::GetMapForMSXML(MULTIVALMAP& map,const TDVCHAR* pTagName, CTDVString& sMSXML)
{
	if (pTagName == NULL)
	{
		return;
	}

	MULTIVALMAP::iterator it;

	for (it = map.begin();it != map.end();it++)
	{
		CTDVString sMapKey = it->first;
		multival* m = it->second;


		sMSXML << "<" << pTagName << " NAME='" << sMapKey << "' ESCAPED='" << m->IsEscaped() << "'/>";
	}
}

/*********************************************************************************

	void CMultiStep::EnsureValueParses(CTDVString& sValue)

		Author:		Mark Neves
        Created:	29/03/2004
        Inputs:		sValue
        Outputs:	sValue is emptied if sValue doesn't parse correctly
        Returns:	-
        Purpose:	This ensures that sValue will parse correctly.

					It's put inside a temp tag, then run through ParseXMLForErrors.
					If errors are detected, sValue is emptied

*********************************************************************************/

void CMultiStep::EnsureValueParses(CTDVString& sValue)
{
	CTDVString sTag = CXMLObject::MakeTag("TAG",sValue);
	CTDVString sParseErrors = CXMLObject::ParseXMLForErrors(sTag);
	if (!sParseErrors.IsEmpty())
	{
		sValue.Empty();
	}
}

/*********************************************************************************

	bool CMultiStep::GenerateAsXML(const TDVCHAR* pName, const TDVCHAR* pValue, CTDVString& sXML, bool bEscaped)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		pName	= the name of the tag
				pValue  = the value of the tag
				bEscaped= true if the tag should be escaped
	Outputs:	sXML = the GuideML version of a tag called pName, who's value is pValue
						or an escaped version, if bEscaped is true
	Returns:	true if ok, false if it had problems parsing the input
	Purpose:	Creates a GuideML bit of XML, with a tag name of pName, and a value of pValue

				If there are parsing problems, the LastError variables contain the parse errors

*********************************************************************************/

bool CMultiStep::GenerateAsXML(const TDVCHAR* pName, const TDVCHAR* pValue, CTDVString& sXML, bool bEscaped, bool bRawInput)
{
	CTDVString sParseErrors;
	if (!CXMLObject::GenerateAsGuideML(pName, pValue, sXML, sParseErrors))
	{
		return SetDNALastError("CMultiStep","PARSEERROR", sParseErrors, pName);
	}

	return true;
}

/*********************************************************************************

	bool CMultiStep::GetElementAsXML(const TDVCHAR* pElementName, CTDVString& sXML)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		pElementName = the name of the element
	Outputs:	sXML = the XML tag equivalent
	Returns:	true if OK, false otherwise
	Purpose:	Creates an XML version of the element.
				The element is either escaped, or converted to GuideML by GenerateAsGuideML()

*********************************************************************************/

bool CMultiStep::GetElementAsXML(const TDVCHAR* pElementName, CTDVString& sXML)
{
	CTDVString sElementValue;
	bool bEscaped = false;
	bool bRawInput = false;
	bool ok = GetElementValue(pElementName, sElementValue, &bEscaped, &bRawInput);
	ok = ok && GenerateAsXML(pElementName, sElementValue, sXML, bEscaped, bRawInput);
	return ok;
}

/*********************************************************************************

	bool CMultiStep::GetRequiredAsXML(TDVCHAR* pRequiredName, CTDVString& sXML)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		pRequiredName = the name of the element
	Outputs:	sXML = the GuideML tag equivalent
	Returns:	true if OK, false otherwise
	Purpose:	See GenerateAsGuideML()

*********************************************************************************/

bool CMultiStep::GetRequiredAsXML(const TDVCHAR* pRequiredName, CTDVString& sXML)
{
	CTDVString sRequiredValue;
	bool bEscaped = false;
	bool bRawInput = false;
	bool ok = GetRequiredValue(pRequiredName, sRequiredValue, &bEscaped, &bRawInput);
	ok = ok && GenerateAsXML(pRequiredName, sRequiredValue, sXML, bEscaped, bRawInput);
	return ok;
}

/*********************************************************************************

	bool CMultiStep::GetAllElementsAsXML(CTDVString& sXML)

	Author:		Mark Neves
	Created:	27/11/2003
	Inputs:		-
	Outputs:	sXML = the XML tag equivalent
	Returns:	true if OK, false otherwise
	Purpose:	Returns all Elements as XML
				The XML elements are either treated as GuideML, or escaped if they had the ESCAPED attribute
				set to 1
	
				See GetElementAsXML()

*********************************************************************************/

bool CMultiStep::GetAllElementsAsXML(CTDVString& sXML)
{
	bool ok = true;

	CTDVString sName, sValue;
	int iIndex = 0;
	while (ok && GetElementFromIndex(iIndex, sName, sValue))
	{
		ok = GetElementAsXML(sName,sXML);
		iIndex++;
	}

	return ok;
}


/*********************************************************************************

	bool CMultiStep::ReadyToUse()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if ready to create, false otherwise
	Purpose:	after processing the input call this to see if you can start 
				to use the values from the input.

*********************************************************************************/

bool CMultiStep::ReadyToUse()
{
	return m_bFinished && !m_bCancelled;
}

/*********************************************************************************

	bool CMultiStep::IsCancelled()

	Author:		Mark Neves
	Created:	30/07/2003
	Inputs:		-
	Outputs:	-
	Returns:	true if the user cancelled the operation, false otherwise
	Purpose:	If the user has cancelled the multistage process, this will
				return true.

*********************************************************************************/

bool CMultiStep::IsCancelled()
{
	return m_bCancelled;
}

/*********************************************************************************

	bool CMultiStep::GetAsXML(CTDVString& sXML)

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	sXML - the xml string of the current multistep process
	Returns:	true if string created false otherwise
	Purpose:	Returns the multistage result of processing the input as an
				xml string. The string contains information on whether the user
				is registered, the values of the required inputs, the values of 
				the elements, whether all the inputs has been received and the 
				current stage.

*********************************************************************************/

bool CMultiStep::GetAsXML(CTDVString& sXML)
{
	sXML.Empty();
	
	if (!ProcessedMSXML())
	{
		return false;
	}

	sXML = "<MULTI-STAGE TYPE='";
	sXML << m_sType << "'";

	if (!m_bValidUser)
	{
		sXML << " USER='NO'";
	}
		
	sXML << " STAGE='"; 
	if (m_iNumErrors == 0 && !m_bCancelled)
	{
		sXML << (m_iCurrStage+1);
	}
	else
	{
		sXML << m_iCurrStage;
	}

	sXML << "'";

	if (m_bCancelled)
	{
		sXML << " CANCEL='YES'";
	}
	else
	{
		if (m_bFinished)
		{
			sXML << " FINISH='YES'";
		}
	}

	sXML << ">";

	GetRequiredMapAsXML(sXML);
	GetElementMapAsXML(sXML);

	sXML << "</MULTI-STAGE>";

	return true;
}

/*********************************************************************************

	CTDVString CMultiStep::GetAsXML()

	Author:		Mark Neves
	Created:	04/12/2003
	Inputs:		-
	Outputs:	-
	Returns:	The multistep object as XML
	Purpose:	-

*********************************************************************************/

CTDVString CMultiStep::GetAsXML()
{
	CTDVString sXML;
	GetAsXML(sXML);
	return sXML;
}

/*********************************************************************************

	int CMultiStep::GetNumErrors()

	Author:		Dharmesh Raithatha
	Created:	6/10/2003
	Inputs:		-
	Outputs:	-
	Returns:	num of errors found
	Purpose:	returns the num of errors

*********************************************************************************/

int CMultiStep::GetNumErrors()
{
	return m_iNumErrors;
}

/*********************************************************************************

	bool CMultiStep::GetElementFromIndex(int iIndex,CTDVString& sName, CTDVString& sValue)

	Author:		Dharmesh Raithatha
	Created:	8/18/2003
	Inputs:		iIndex, index for the element
	Outputs:	sName - name of element
				sValue - value of element
	Returns:	true if value present at that index, false otherwise
	Purpose:	given an index it returns the element at that point in the list 
				of elements

*********************************************************************************/

bool CMultiStep::GetElementFromIndex(int iIndex,CTDVString& sName, CTDVString& sValue)
{
	if (iIndex < 0 || m_ElementMap.empty())
	{
		return false;
	}

	MULTIVALMAP::iterator it;
	int i = 0;
	for (it = m_ElementMap.begin(),i = 0;it != m_ElementMap.end();it++,i++)
	{
		if (i == iIndex)
		{
			sName = it->first;
			sValue = it->second->GetValue();
			return true;
		}
	}

	return false;
}

/*********************************************************************************

	bool CMultiStep::ParameterValidated(const multival* mv)

	Author:		Dharmesh Raithatha
	Created:	8/22/2003
	Inputs:		a multival
	Outputs:	-
	Returns:	true if the validated codes match the validated results
	Purpose:	checks if the multival has been validated

*********************************************************************************/

bool CMultiStep::ParameterValidated(const multival* mv)
{
	if (mv != NULL)
	{
		return (mv->GetValidationCodes() == mv->GetValidationResults());
	}

	return false;
}

/*********************************************************************************

	bool CMultiStep::ValidateRequiredParameter(const TDVCHAR* sRequiredName,multival* m)

	Author:		Dharmesh Raithatha
	Created:	8/22/2003
	Inputs:		sRequiredName - name of the required parameter
				a valid multival with the value set
	Outputs:	-
	Returns:	true if successfully processed false otherwise
	Purpose:	given the name of the required parameter, this method finds the node
				in the inputtree and then validates the parameter according to 
				validation rules

*********************************************************************************/

bool CMultiStep::ValidateRequiredParameter(const TDVCHAR* sRequiredName,multival* m)
{
	if (m == NULL)
	{
		return false;
	}
	
	CXMLTree* pRequired = m_pInputTree->FindFirstTagName("REQUIRED", 0, false);

	CTDVString sName;

	while(pRequired != NULL)
	{
		pRequired->GetAttribute("NAME",sName);

		if (sName.CompareText(sRequiredName))
		{
			ValidateParameterFromTree(m,pRequired,sRequiredName);
			return true;
		}

		pRequired = pRequired->FindNextTagNode("REQUIRED");
	}

	return false;
}

/*********************************************************************************

	bool CMultiStep::ValidateParameterFromTree(multival* m,CXMLTree* pKey,const TDVCHAR* pName)

	Author:		Dharmesh Raithatha
	Created:	8/22/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	given a multival and a XMLTree of the form 
				<ELEMENT NAME="Blah">
					<VALIDATE TYPE="EMPTY"/>
					<VALIDATE TYPE="LOCATION"/>
					...
				</ELEMENT>

				The method goes through each validation node sets the code on the 
				multival then sets the result on the matching result. This uses 
				the bitmask to store this. For each error encountered m_iNumErrors
				is incremented by 1.

*********************************************************************************/

bool CMultiStep::ValidateParameterFromTree(multival* m,CXMLTree* pKey,const TDVCHAR* pName)
{
	if (m == NULL || pKey == NULL)
	{
		return false;
	}

	CXMLTree* pValidate = pKey->FindFirstTagName("VALIDATE", pKey, false);

	CTDVString sType, sErrorMsg, sValue;

	while (pValidate != NULL)
	{
		if (pValidate->GetAttribute("TYPE",sType))
		{
			int flag = 0;
			bool bValid = false;

			if (sType.CompareText("EMPTY"))
			{
				flag = MULTISTEP_VALCODE_EMPTY;
				bValid = !(m->GetValue().IsEmpty());
			}
			else if (sType.CompareText("NEQ"))
			{
				flag = MULTISTEP_VALCODE_NEQ;
				if (pValidate->DoesAttributeExist("VALUE"))
				{
					pValidate->GetAttribute("VALUE",sValue);
					bValid = !(m->GetValue().CompareText(sValue));
				}
				else
				{
					sErrorMsg << "CMultiStep::ValidateParameterFromTree() - type " << sType << " needs a VALUE attr"; 
				}
			}

			m->SetValidationCodes(m->GetValidationCodes() | flag);

			if (bValid)
			{
				m->SetValidationResults(m->GetValidationResults() | flag);
			}
			else
			{
				m->SetValidationResults(m->GetValidationResults() & ~flag);
				m_iNumErrors++;
			}

			//add more tests here as required
		}
		else
		{
			//there should always be a type
			sErrorMsg << "CMultiStep::ValidateParameterFromTree() no Type attr found";
		}

		if (!sErrorMsg.IsEmpty())
		{
			return SetDNALastError("CMultiStep","ValidateTagError",sErrorMsg,pName);
		}

		pValidate = pValidate->FindNextTagNode("VALIDATE",pKey);
	}

	// For non-escaped input, always check that it parses OK.
	// If not, set the validation result to "fail", and fill in the parse error
	if (!m->IsEscaped() && !m->IsRawInput())
	{
		CTDVString sTag = CXMLObject::MakeTag(pName,m->GetValue());
		CTDVString sParseErrors = CXMLObject::ParseXMLForErrors(sTag);
		if (!sParseErrors.IsEmpty())
		{
			m->SetValidationCodes(m->GetValidationCodes() | MULTISTEP_VALCODE_PARSE);
			m->SetValidationResults(m->GetValidationResults() & ~MULTISTEP_VALCODE_PARSE);
			CXMLObject::StripTopLevelTagFromParseErrors(pName,sParseErrors);
			m->SetParseErrors(sParseErrors);
			m_iNumErrors++;
		}
	}

	return true;

}

/*********************************************************************************

	bool CMultiStep::AppendValidationErrors(const CTDVString& sXML,multival* m)

	Author:		Dharmesh Raithatha
	Created:	8/22/2003
	Inputs:		-
	Outputs:	-
	Returns:	-
	Purpose:	Given the current multival, this method goes through the 
				validation codes and produces xml for any errors that are found
				in the form
				<ERRORS>
				<ERROR TYPE='EMPTY'>
				<ERROR TYPE='LOCATION'>
				</ERRORS>
				...

*********************************************************************************/

bool CMultiStep::AppendValidationErrors(CTDVString& sXML,multival* m)
{
	assert (m != NULL);

	if (ParameterValidated(m))
	{
		return true;
	}

	//not the same so go through the errors and display them

	sXML << "<ERRORS>";

	int valCodes   = m->GetValidationCodes();
	int valResults = m->GetValidationResults();
	for (int i=0;i < NUM_VALIDATION_CODES;i++)
	{
		int bitcode = (1 << i);
		if ((valCodes & bitcode) != (valResults & bitcode))
		{
			sXML << "<ERROR TYPE='" << pValidationErrors[i] << "'>";
			switch (bitcode)
			{
				case MULTISTEP_VALCODE_PARSE:
					sXML << m->GetParseErrors();
					break;
				case MULTISTEP_VALCODE_CUSTOM:
					sXML << m->GetCustomErrorXML();
					break;
			}
			sXML << "</ERROR>";
		}
	}

	//Add extra ones here
	sXML << "</ERRORS>";

	return true;

}


/*********************************************************************************

	bool CMultiStep::SetMapValue(MULTIVALMAP& mMap, const TDVCHAR* pParam,const TDVCHAR* pValue)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		mMap = the map in question
				pParam = the param you want to set the value of
				sValue = the new value
	Outputs:	-
	Returns:	true if the param was found and the value set
	Purpose:	Sets the specified param with the given value

*********************************************************************************/

bool CMultiStep::SetMapValue(MULTIVALMAP& mMap, const TDVCHAR* pParam,const TDVCHAR* pValue)
{
	CTDVString sParam(pParam);
	sParam.MakeUpper();

	MULTIVALMAP::iterator it = mMap.find(sParam);

	if (it != mMap.end())
	{
		multival* m = it->second;
		SetMultivalValue(m,pValue);
		return true;
	}

	return false;
}

/*********************************************************************************

	bool CMultiStep::SetRequiredValue(const TDVCHAR* pRequiredParam,const TDVCHAR* pRequiredValue)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		pRequiredParam = the param you want to set the value of
				sRequiredValue = the new value
	Outputs:	-
	Returns:	true if the param was found and the value set
	Purpose:	Sets the specified param with the given value

*********************************************************************************/

bool CMultiStep::SetRequiredValue(const TDVCHAR* pRequiredParam,const TDVCHAR* pRequiredValue)
{
	return SetMapValue(m_RequiredMap,pRequiredParam,pRequiredValue);
}

/*********************************************************************************

	bool CMultiStep::SetElementValue(const TDVCHAR* pElementParam,const TDVCHAR* pElementValue)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		pElementParam = the param you want to set the value of
				sElementValue = the new value
	Outputs:	-
	Returns:	true if the param was found and the value set
	Purpose:	Sets the specified param with the given value

*********************************************************************************/

bool CMultiStep::SetElementValue(const TDVCHAR* pElementParam,const TDVCHAR* pElementValue)
{
	return SetMapValue(m_ElementMap,pElementParam,pElementValue);
}

/*********************************************************************************

	bool CMultiStep::FillMapFromXML(MULTIVALMAP& mMap, const CTDVString& sXML)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		mMap = the map in question
				sXML = the XML used to fill the map 
	Outputs:	-
	Returns:	true if the XML parsed ok, false otherwise
	Purpose:	Uses sXML to fill in values for the parameters that are in mMap.

				For each entry in mMap, it searches in sXML for the first tag of the same name.

				If it finds a tag of that name, it creates an editable text version of that 
				tag's tree, and sets the map's value with it

				It only returns false if it can't parse sXML.

				It will return true even if it doesn't find any tags with matching names

*********************************************************************************/

bool CMultiStep::FillMapFromXML( MULTIVALMAP& mMap, const CTDVString& sXML )
{
	// Get out quickly if map is empty
	if (mMap.empty())
	{
		return true;
	}

	CTDVString sParseErrors;
	sParseErrors = CXMLObject::ParseXMLForErrors(sXML);
	if (!sParseErrors.IsEmpty())
	{
		return SetDNALastError("CMultiStep","PARSEERROR", sParseErrors);
	}

	CXMLTree* pRoot = CXMLTree::ParseForInsert(sXML);
	CXMLTree* pFirstChild = NULL;
	if (pRoot != NULL)
	{
		pFirstChild = pRoot->GetFirstChild();
	}

	if (pFirstChild != NULL)
	{
		MULTIVALMAP::iterator it;

		for (it = mMap.begin();it != mMap.end();it++)
		{
			CTDVString sMapKey = it->first;
			multival* m = it->second;

			CTDVString sValue, sEditableText;
			bool bFound = CXMLObject::MakeGuideMLTextEditable(pFirstChild,sMapKey,sValue,sEditableText);

			if (bFound)
			{
				m->SetValue(sValue);

				if (m->IsEscaped())
				{
					sEditableText = sValue;
//					sEditableText.Replace("<BR />","\r\n");
				}

				m->SetValueEditable(sEditableText);
			}
//			else
//			{
//				CTDVString msg;
//				msg << "Minor warning: FillMapFromXML() didn't find matching node. Looking for " << sMapKey;
//				TDVASSERT(false,msg);
//			}
		}

		delete pRoot;
		pRoot = NULL;
	}

	return true;
}


/*********************************************************************************

	bool CMultiStep::FillElementsFromXML(const CTDVString& sXML)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		sXML = the XML used to fill the map 
	Outputs:	-
	Returns:	true if the XML parsed ok, false otherwise
	Purpose:	See FillMapForXML() for details

*********************************************************************************/

bool CMultiStep::FillElementsFromXML(const CTDVString& sXML)
{
	return FillMapFromXML(m_ElementMap,sXML);
}

/*********************************************************************************

	bool CMultiStep::FillRequiredFromXML(const CTDVString& sXML)

	Author:		Martin Robb
	Created:	29/01/2007
	Inputs:		sXML - XML to set as element value.
				sElement - Element to populate ( expected to match root element of XML )
	Outputs:	
	Returns:	true if the XML parsed ok, false otherwise
	Purpose:	Expects XML in the form <ELEMENTNAME>.......</ELEMENTNAME>
				The element ELEMENTNAME will have the value of the INNER XML.
				Similar to SetValue but populates eement value with XML.

*********************************************************************************/
bool CMultiStep::FillElementFromXML(const CTDVString& sElement, const CTDVString& sXML )
{
	CTDVString sParseErrors;
	sParseErrors = CXMLObject::ParseXMLForErrors(sXML);
	if (!sParseErrors.IsEmpty())
	{
		return SetDNALastError("CMultiStep","PARSEERROR", sParseErrors);
	}

	CXMLTree* pRoot = CXMLTree::ParseForInsert(sXML);

	MULTIVALMAP::iterator it = m_ElementMap.find(sElement);
	if ( it == m_ElementMap.end() )
	{
		return true;
	}
	multival* m = it->second;
	
	CTDVString sValue, sEditableText;
	if ( CXMLObject::MakeGuideMLTextEditable(pRoot,it->first,sValue,sEditableText) )
	{
		m->SetValue(sValue);

		if (m->IsEscaped())
		{
			sEditableText = sValue;
		}

		m->SetValueEditable(sEditableText);
	}

	delete pRoot;
	return true;
}

/*********************************************************************************

	bool CMultiStep::FillRequiredFromXML(const CTDVString& sXML)

	Author:		Mark Neves
	Created:	03/12/2003
	Inputs:		sXML = the XML used to fill the map 
	Outputs:	-
	Returns:	true if the XML parsed ok, false otherwise
	Purpose:	See FillMapForXML() for details

*********************************************************************************/

bool CMultiStep::FillRequiredFromXML(const CTDVString& sXML)
{
	return FillMapFromXML(m_RequiredMap,sXML);
}

/*********************************************************************************

	bool CMultiStep::ProcessMapAttrs(MULTIVALMAP& mMap,const TDVCHAR* pTagType)

	Author:		Mark Neves
	Created:	10/02/2004
	Inputs:		mMap = the map to process
				pTagType = The name of the tag elements to process
	Outputs:	-
	Returns:	true if OK, false otherwise
	Purpose:	Scan through the tags of name pTagType, and process the attributes that may be
				specified.
				Possible attributes:
					ESCAPED=1 - The data for this field should be escaped, rather than treated as GuideML

*********************************************************************************/

bool CMultiStep::ProcessMapAttrs(MULTIVALMAP& mMap,const TDVCHAR* pTagType)
{
	CXMLTree* pNode = m_pInputTree->FindFirstTagName("MULTI-INPUT", 0, false);
	if (pNode != NULL)
	{
		pNode = pNode->GetFirstChild(CXMLTree::T_NODE);
	}

	while (pNode != NULL)
	{
		CTDVString sTagType = pNode->GetName();
		if (sTagType.CompareText(pTagType))
		{
			CTDVString sName;
			pNode->GetAttribute("NAME",sName);
			multival* pMultival = GetMapItem(mMap, sName);
			if (pMultival != NULL)
			{
				//note: the value of the escape attribute of a node can 
				//depend of on the value of some other client paramemter
				//To Determine, which is which, check whether the escape attributes value is 1 or 0 
				//if it is, then the value should be taken literally as it it is, if it is not then query the parameter given as it's name
				//and determine the value of that aprameter (para, could be a checkbox or a radio box)
				bool bEscaped = false;
				CTDVString sEscapedValueParam;
				if  ( pNode->GetAttribute("ESCAPED", sEscapedValueParam) )
				{
					if (!sEscapedValueParam.IsEmpty())
					{
						if ( sEscapedValueParam.CompareText("0") || sEscapedValueParam.CompareText("1") )
						{
							bEscaped = sEscapedValueParam.CompareText("1") ;
						}
						else
						{
							bEscaped = (m_InputContext.GetParamInt(sEscapedValueParam) > 0);
						}
					}
				}
				pMultival->SetEscapedFlag(bEscaped);

				// Check to see if the parameter has been marked as raw input
				bool bRawInput = false;
				CTDVString sRawInputValueParam;
				if  ( pNode->GetAttribute("RAWINPUT", sRawInputValueParam) )
				{
					if (!sRawInputValueParam.IsEmpty())
					{
						if ( sRawInputValueParam.CompareText("0") || sRawInputValueParam.CompareText("1") )
						{
							bRawInput = sRawInputValueParam.CompareText("1") ;
						}
						else
						{
							bRawInput = (m_InputContext.GetParamInt(sRawInputValueParam) > 0);
						}
					}
				}
				pMultival->SetRawInputFlag(bRawInput);

				CTDVString sEI;
				pNode->GetAttribute("EI",sEI);
				int nAction = MULTISTEP_EI_NONE;
				if (sEI.CompareText("add"))
				{
					nAction = MULTISTEP_EI_ADD;
				}
				if (sEI.CompareText("remove"))
				{
					nAction = MULTISTEP_EI_REMOVE;
				}
				pMultival->SetExtraInfoAction(nAction);

				CTDVString sParameterAction;
				pNode->GetAttribute("action",sParameterAction);
				pMultival->SetParameterAction(sParameterAction);

				CTDVString sParameterNamespace;
				pNode->GetAttribute("phrasenamespace",sParameterNamespace);
				pMultival->SetParameterNamespace(sParameterNamespace);
			}
		}

		pNode = pNode->GetNextSibling();
	}

	return true;
}

/*********************************************************************************

	bool CMultiStep::GetRequiredExtraInfoAction(int iIndex,CTDVString& sRequiredParam,int& nAction)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		iIndex = the index of the required param
        Outputs:	sRequiredParam = the name of the param at index iIndex
					nAction = the action specified
        Returns:	true if param at index iIndex is found, false otherwise
        Purpose:	Gets the ExtraInfo action code for the param at index iIndex.
					Used to iterate through all Required params when applying
					the ExtraInfo action codes.

*********************************************************************************/

bool CMultiStep::GetRequiredExtraInfoAction(int iIndex,CTDVString& sRequiredParam,int& nAction)
{
	return GetExtraInfoAction(m_RequiredMap,iIndex,sRequiredParam,nAction);
}

/*********************************************************************************

	bool CMultiStep::GetElementExtraInfoAction(int iIndex,CTDVString& sElementParam,int& nAction)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		iIndex = the index of the Element param
        Outputs:	sElementParam = the name of the param at index iIndex
					nAction = the action specified
        Returns:	true if param at index iIndex is found, false otherwise
        Purpose:	Gets the ExtraInfo action code for the param at index iIndex.
					Used to iterate through all Element params when applying
					the ExtraInfo action codes.

*********************************************************************************/

bool CMultiStep::GetElementExtraInfoAction(int iIndex,CTDVString& sElementParam,int& nAction)
{
	return GetExtraInfoAction(m_ElementMap,iIndex,sElementParam,nAction);
}

/*********************************************************************************

	bool CMultiStep::GetExtraInfoAction(MULTIVALMAP& mMap,int iIndex,CTDVString& sParam,int& nAction)

		Author:		Mark Neves
        Created:	17/12/2004
        Inputs:		mMap = the map containing the params to search through
					iIndex = the index of the param
        Outputs:	sParam = the name of the param at index iIndex
					nAction = the action specified
        Returns:	true if param at index iIndex is found, false otherwise
        Purpose:	Gets the ExtraInfo action code for the param at index iIndex.

*********************************************************************************/

bool CMultiStep::GetExtraInfoAction(MULTIVALMAP& mMap,int iIndex,CTDVString& sParam,int& nAction)
{
	MULTIVALMAP::iterator it;

	for (it = mMap.begin();it != mMap.end() && iIndex >= 0;it++)
	{
		if (iIndex == 0)
		{
			sParam = it->first;
			multival* m = it->second;
			nAction = m->GetExtraInfoAction();
			return true;
		}
		iIndex--;
	}

	return false;
}



/*********************************************************************************

	bool CMultiStep::GetParameterAction(MULTIVALMAP& mMap,int iIndex,CTDVString& sParam,CTDVString& sAction)

		Author:		Martin Robb
        Created:	17/12/2004
        Inputs:		mMap = the map containing the params to search through
					iIndex = the index of the param
        Outputs:	sParam = the name of the param at index iIndex
					sAction = the action specified
        Returns:	true if param at index iIndex is found, false otherwise
        Purpose:	Allows an action to be specified in the attributes of an element eg ACTION='KEYPHRASE' for auto-tagging.
					This action can then be iinterpreted by a builder to perform etra processing for a field.

*********************************************************************************/

bool CMultiStep::GetParameterAction(MULTIVALMAP& mMap,int iIndex,CTDVString& sParam, CTDVString& sAction)
{
	MULTIVALMAP::iterator it;

	for (it = mMap.begin();it != mMap.end() && iIndex >= 0;it++)
	{
		if (iIndex == 0)
		{
			sParam = it->first;
			multival* m = it->second;
			sAction = m->GetParameterAction();
			return true;
		}
		iIndex--;
	}

	return false;
}

bool CMultiStep::GetElementParameterAction(int iIndex,CTDVString& sElementParam, CTDVString& sAction)
{
	return GetParameterAction(m_ElementMap,iIndex,sElementParam,sAction);
}

bool CMultiStep::GetRequiredParameterAction(int iIndex, CTDVString& sElementParam, CTDVString& sAction)
{
	return GetParameterAction(m_RequiredMap,iIndex,sElementParam,sAction);
}

bool CMultiStep::GetElementNamespace(int iIndex, CTDVString& sParam, CTDVString& sNamespace)
{
	MULTIVALMAP::iterator it;
	for(it = m_ElementMap.begin(); it != m_ElementMap.end() && iIndex >=0; it++)
	{
		if (iIndex == 0)
		{
			sParam = it->first;
			multival* m = it->second;
			sNamespace = m->GetParameterNamespace();
			return true;
		}
		iIndex--;
	}
	return false;
}

bool CMultiStep::GetRequiredNamespace(int iIndex, CTDVString& sParam, CTDVString& sNamespace)
{
	MULTIVALMAP::iterator it;
	for(it = m_RequiredMap.begin(); it != m_RequiredMap.end() && iIndex >=0; it++)
	{
		if (iIndex == 0)
		{
			sParam = it->first;
			multival* m = it->second;
			sNamespace = m->GetParameterNamespace();
			return true;
		}
		iIndex--;
	}
	return false;
}

/*********************************************************************************

	bool CMultiStep::GetFileData(MULTIVALMAP& mMap, const TDVCHAR* sParam, char **pBuffer, int& iLength, CTDVString& sMimeType)

		Author:		Steven Francis
        Created:	15/11/2005
        Inputs:		mMap = the map containing the params to search through
					sParam = the name of the filetype param searching for
        Outputs:	iLength = the length of the file
					sMimeType = the mimetype of the file
					pBuffer = the filebuffer itself
        Returns:	true if the file is ok to process, false otherwise
        Purpose:	Gets the GetFileFromParam puts the file data into the multi step

*********************************************************************************/
bool CMultiStep::GetFileData(MULTIVALMAP& mMap, const TDVCHAR* sParam, const char **pBuffer, int& iLength, CTDVString& sMimeType, CTDVString *sFilename)
{
	CTDVString s(sParam);
	s.MakeUpper();

	MULTIVALMAP::iterator it = mMap.find(s);
	if (it != mMap.end())
	{
		multival* m = it->second;

		if(!m_InputContext.GetParamFilePointer(sParam, pBuffer, iLength, sMimeType, sFilename))
		{
			CTDVString strError = "File Named section could not be found - ";
			strError << sParam;
			return SetDNALastError("CMultiStep", "GetFileData", strError);
		}

		// Make sure we actually have a file.
		if(iLength <= 0)
		{
			return SetDNALastError("CMultiStep", "GetFileData", "Zero Length File input.");
		}
		// Make sure file is not too big.
		else if(iLength > GetMAXFileSize())
		{
			return SetDNALastError("CMultiStep", "GetFileData", "File length greater than the maximum allowed.");
		}
		m->SetFileData(pBuffer, iLength);
	}
	return true;
}

/*********************************************************************************

	bool CMultiStep::GetRequiredFileDataFromParam(const TDVCHAR* sRequiredParam, char **pBuffer, int& iLength, CTDVString& sMimeType)

		Author:		Steven Francis
        Created:	15/11/2005
        Inputs:		sRequiredParam = the name of the required filetype param searching for
        Outputs:	iLength = the length of the file
					sMimeType = the mimetype of the file
					pBuffer = the filebuffer itself

        Returns:	true if the file is ok and retrieved , false otherwise
        Purpose:	Wrapper to get the Reuired file data

*********************************************************************************/
bool CMultiStep::GetRequiredFileData(const TDVCHAR* sRequiredParam, const char **pBuffer, int& iLength, CTDVString& sMimeType, CTDVString *sFilename)
{
	bool bOK = true;

	bOK = bOK && GetFileData(m_RequiredMap, sRequiredParam, pBuffer, iLength, sMimeType, sFilename);

	return bOK;
}
/*********************************************************************************

	bool CMultiStep::GetMAXFileSize()

	Author:		Steven Francis
	Created:	08/11/2005
	Inputs:		-
	Outputs:	-
	Returns:	int The maximum file size allowed
	Purpose:	Returns the MAX FileSize allowed - to allow to be made configurable
*********************************************************************************/
int CMultiStep::GetMAXFileSize()
{
	// 5megs = 5242880 bytes (http://www.google.co.uk/search?hl=en&q=bytes+in+5+megabytes)
	// 1.5megs = 1572864  bytes (http://www.google.co.uk/search?hl=en&q=bytes+in+1.5+megabytes)
	int iMaxSize = 1572864;

	return iMaxSize;
}

/*********************************************************************************

	void CMultiStep::AppendRequiredCustomErrorXML(const TDVCHAR* pRequiredParam,const TDVCHAR* pErrorXML)

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		pRequiredParam = name of the param to associate the custom error to
					pErrorXML = an XML block defining the custom error XML
		Outputs:	-
		Returns:	-
		Purpose:	See AppendMapCustomErrorXML()

*********************************************************************************/

void CMultiStep::AppendRequiredCustomErrorXML(const TDVCHAR* pRequiredParam,const TDVCHAR* pErrorXML)
{
	AppendMapCustomErrorXML(m_RequiredMap, pRequiredParam, pErrorXML);
}

/*********************************************************************************

	void CMultiStep::AppendRequiredCustomErrorXML(const TDVCHAR* pElementParam,const TDVCHAR* pErrorXML)

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		pElementParam = name of the param to associate the custom error to
					pErrorXML = an XML block defining the custom error XML
		Outputs:	-
		Returns:	-
		Purpose:	See AppendMapCustomErrorXML()

*********************************************************************************/

void CMultiStep::AppendElementCustomErrorXML(const TDVCHAR* pElementParam,const TDVCHAR* pErrorXML)
{
	AppendMapCustomErrorXML(m_ElementMap, pElementParam, pErrorXML);
}

/*********************************************************************************

		void CMultiStep::AppendMapCustomErrorXML(MULTIVALMAP& mMap, const TDVCHAR* pParam, const TDVCHAR* pErrorXML)

		Author:		Mark Neves
		Created:	12/02/2007
		Inputs:		mMap = the map the param belongs to
					pParam = name of the param to associate the custom error to
					pErrorXML = an XML block defining the custom error XML
		Outputs:	-
		Returns:	-
		Purpose:	Allows the client to attach custom error XML which will automatically
					get included in the MultiStep XML block.

					Once you have set a custom error, ReadyToUse() will always return false.

*********************************************************************************/

void CMultiStep::AppendMapCustomErrorXML(MULTIVALMAP& mMap, const TDVCHAR* pParam, const TDVCHAR* pErrorXML)
{
	CTDVString sParam(pParam);
	sParam.MakeUpper();

	MULTIVALMAP::iterator it = mMap.find(sParam);

	if (it != mMap.end())
	{
		multival* m = it->second;
		m->SetValidationCodes(m->GetValidationCodes() | MULTISTEP_VALCODE_CUSTOM);
		m->SetValidationResults(m->GetValidationResults() & ~MULTISTEP_VALCODE_CUSTOM);
		m->AppendCustomErrorXML(pErrorXML);

		// Call VerifyFinished() so that it will pick up on the fact an error has been set,
		// and hence ReadyToUse() will always return false.
		VerifyFinished();
	}
}
