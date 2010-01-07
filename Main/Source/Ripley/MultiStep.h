// MultiStep.h: interface for the CMultiStep class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_MULTISTEP_H__6A63A9AA_C24B_4436_8C20_A1856300CF49__INCLUDED_)
#define AFX_MULTISTEP_H__6A63A9AA_C24B_4436_8C20_A1856300CF49__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include <map>
#include <utility>

#include "TDVString.h"
#include "XMLError.h"
#include "XMLObject.h"

class CInputContext;
class CXMLTree;

using namespace std;

class multival;

typedef map<CTDVString,multival*> MULTIVALMAP;


class CMultiStep : public CXMLError
{
public:
	CMultiStep(CInputContext& inputContext, const TDVCHAR* sType, int iMaxNumElements = 50);
	virtual ~CMultiStep();

public:
	bool AddRequiredParam(const TDVCHAR* sRequiredParam, const TDVCHAR* sDefaultValue = "", bool bEscaped = false, bool bFileType = false, bool bRawInput = false);
	bool GetRequiredValue(const TDVCHAR* sRequiredParam, CTDVString& sValue, bool* pbEscaped = NULL, bool* pbRawInput = NULL);
	bool GetRequiredValue(const TDVCHAR* sRequiredParam, int &iValue, bool* pbEscaped = NULL, bool* pbRawInput = NULL);
	
	CTDVString GetRequiredValue(const TDVCHAR* sRequiredParam);
	int GetNumberOfElements();
	bool ProcessInput();
	bool ProcessedMSXML() { return (m_pInputTree != NULL); }
	
	void SetMSXMLSeed(const TDVCHAR* pMSXMLSeed);
	int GetCurrentStage();	
	bool GetElementValue(const TDVCHAR* sElementName, CTDVString& sElementVal, bool* pbEscaped = NULL, bool* pbRawInput = NULL);
	CTDVString GetElementValue(const TDVCHAR* sElementName);
	
	bool GetElementFromIndex(int iIndex,CTDVString& sName, CTDVString& sValue);
	void GetElementMapAsXML(CTDVString& sXML);
	void GetRequiredMapAsXML(CTDVString& sXML);
	
	bool ReadyToUse();
	bool IsCancelled();
	int GetNumErrors();
	bool GetAsXML(CTDVString& sXML);
	CTDVString GetAsXML();
	void SetType(const TDVCHAR* sType) {m_sType = sType;};
	void SetToCancelled() {m_bCancelled = true;};
	bool SetRequiredValue(const TDVCHAR* pRequiredParam, const TDVCHAR* pRequiredValue);
	bool SetElementValue(const TDVCHAR* pElementParam, const TDVCHAR* pElementValue);

	bool FillRequiredFromXML(const CTDVString& sXML);
	bool FillElementsFromXML(const CTDVString& sXML);
	bool FillElementFromXML(const CTDVString& sElement, const CTDVString& sXML );

	bool GetRequiredAsXML(const TDVCHAR* pRequiredName, CTDVString& sXML);
	bool GetElementAsXML(const TDVCHAR* pElementName, CTDVString& sXML);
	bool GetAllElementsAsXML(CTDVString& sXML);

	bool GetRequiredExtraInfoAction(int iIndex, CTDVString& sRequiredParam, int& nAction);
	bool GetElementExtraInfoAction(int iIndex, CTDVString& sRequiredParam, int& nAction);

	bool GetRequiredParameterAction(int iIndex, CTDVString& sParam, CTDVString& sAction);
	bool GetElementParameterAction(int iIndex, CTDVString& sParam, CTDVString& sAction);

	bool GetRequiredFileData(const TDVCHAR* sRequiredParam, const char **pBuffer, int& iLength, CTDVString& sMimeType, CTDVString *sFilename=NULL);

	void AppendRequiredCustomErrorXML(const TDVCHAR* pRequiredParam, const TDVCHAR* pErrorXML);
	void AppendElementCustomErrorXML(const TDVCHAR* pElementParam, const TDVCHAR* pErrorXML);

	bool GetElementNamespace(int iIndex, CTDVString& sParam, CTDVString& sNamespace);
	bool GetRequiredNamespace(int iIndex, CTDVString& sParam, CTDVString& sNamespace);

protected:
	void SetMultivalValue(multival* m,const TDVCHAR* pValue);
	void EnsureValueParses(CTDVString& sValue);
	void CreateElementMap();

	bool ProcessMSXML(CTDVString& sMSXML);
	void CreateMSXMLFromSeed(CTDVString& pMSXML);
	void GetRequiredForMSXML(CTDVString& sMSXML);
	void GetMapForMSXML(MULTIVALMAP& map, const TDVCHAR* pTagName, CTDVString& sMSXML);
	bool IsGuideML(CTDVString sXML);

	bool GetRequiredParamsFromInput();
	bool GetElementParamsFromInput();
	bool VerifyFinished();
	bool CheckCancelled();
	bool ParameterValidated(const multival* mv);
	bool ValidateParameterFromTree(multival* m, CXMLTree* pKey, const TDVCHAR* pName);
	bool ValidateRequiredParameter(const TDVCHAR* sRequiredName, multival* m);
	bool AppendValidationErrors(CTDVString& sXML,multival* m);
	bool ProcessMapAttrs(MULTIVALMAP& mMap,const TDVCHAR* pTagType);
	
	bool GenerateAsXML(const TDVCHAR* pName, const TDVCHAR* pValue, CTDVString& sXML, bool bEscaped, bool bRawInput);

	bool FillMapFromXML(MULTIVALMAP& map, const CTDVString& sXML);
	bool SetMapValue(MULTIVALMAP& map, const TDVCHAR* pRequiredParam,const TDVCHAR* pRequiredValue);
	bool GetMapValue(MULTIVALMAP& mMap, const TDVCHAR* sParam,CTDVString& sValue, bool* pbEscaped, bool* pbRawInput);
	multival* GetMapItem(MULTIVALMAP& mMap, const TDVCHAR* pItemName);

	void AppendMapCustomErrorXML(MULTIVALMAP& mMap, const TDVCHAR* pParam, const TDVCHAR* pErrorXML);

	void GetMapAsXML(MULTIVALMAP& map,const TDVCHAR* pTagName, CTDVString& sXML);

	bool GetExtraInfoAction(MULTIVALMAP& mMap,int iIndex, CTDVString& sRequiredParam, int& nAction);
	bool GetParameterAction(MULTIVALMAP& mMap,int iIndex, CTDVString& sRequiredParam, CTDVString& sAction);

	bool GetFileData(MULTIVALMAP& mMap, const TDVCHAR* sParam, const char **pBuffer, int& iLength, CTDVString& sMimeType, CTDVString *sFilename=NULL);

	int GetMAXFileSize();

public:
	//codes for how to validate the input values
	//add extra codes here when you think of them
	//NB: Don't forget to add a corresponding error message to pValidationErrors[] in multistep.cpp
	enum ValidationCodes {	MULTISTEP_VALCODE_NONE  = 0,
							MULTISTEP_VALCODE_EMPTY = 1 << 0,
							MULTISTEP_VALCODE_NEQ   = 1 << 1,
							MULTISTEP_VALCODE_PARSE = 1 << 2,
							MULTISTEP_VALCODE_CUSTOM= 1 << 3
							}; 

	enum ExtraInfoAction
	{
		MULTISTEP_EI_NONE   = 0,
		MULTISTEP_EI_ADD    = 1,
		MULTISTEP_EI_REMOVE = 2
	};

protected:

	
	//list of required params
	MULTIVALMAP m_RequiredMap;
	//list of elements
	MULTIVALMAP m_ElementMap;
	//type
	CTDVString m_sType;
	//finished flag
	bool  m_bFinished;
	//cancelled flag
	bool m_bCancelled;
	//numerrors
	int m_iNumErrors;
	//the current stage after processing
	int m_iCurrStage;
	//max number of elements
	int m_iMaxElements;
	//valid user flag
	bool m_bValidUser;
	//input xml
	CXMLTree* m_pInputTree;
	// A string that can seed the generation of MSXML, if it's not been supplied as a param
	CTDVString m_MSXMLSeed;

	CInputContext& m_InputContext;
};

class multival {
public:
	multival()
	{
		iValidationCodes   = CMultiStep::MULTISTEP_VALCODE_NONE;
		iValidationResults = CMultiStep::MULTISTEP_VALCODE_NONE;
		bEscaped = false;
		bFileType = false;
		nExtraInfoAction = CMultiStep::MULTISTEP_EI_NONE;
	}

	bool IsFileType()		    { return bFileType;	}
	void SetFileTypeFlag(bool b) { bFileType = b; }

	bool IsEscaped()		    { return bEscaped;	}
	void SetEscapedFlag(bool b) { bEscaped = b; }

	bool IsRawInput()		    { return bRawInput;	}
	void SetRawInputFlag(bool b) { bRawInput = b; }

	int  GetExtraInfoAction()       { return nExtraInfoAction; }
	void SetExtraInfoAction(int n)	{ nExtraInfoAction = n; }

	CTDVString GetParameterAction() { return sParameterAction; }
	void SetParameterAction( CTDVString sAction) { sParameterAction = sAction; }

	CTDVString GetParameterNamespace() { return sParameterNamespace; }
	void SetParameterNamespace( CTDVString sNamespace) { sParameterNamespace = sNamespace; }


	CTDVString GetValue() { return sValue; }
	void SetValue(const TDVCHAR* pStr)	{ sValue = pStr; }

	CTDVString GetValueEditable() { return sValueEditable; }
	void SetValueEditable(const TDVCHAR* pStr)	{ sValueEditable = pStr; }

	int  GetValidationCodes() const { return iValidationCodes; }
	void SetValidationCodes(int c)  { iValidationCodes = c; }

	int  GetValidationResults() const { return iValidationResults; }
	void SetValidationResults(int r)  { iValidationResults = r; }

	CTDVString GetParseErrors()				 { return sParseErrors; }
	void SetParseErrors(const TDVCHAR* pStr) { sParseErrors = pStr; }

	void AppendCustomErrorXML(const TDVCHAR* pErrorXML) { sCustomErrorXML += pErrorXML; }
	CTDVString GetCustomErrorXML() { return sCustomErrorXML; }

	const char **GetFileData(int &iLength)										{	iLength = iFileLength;
																				return pFileBuffer; }
	void SetFileData(const char **pNewFileBuffer, int iBufferLength)	{ 
																				iFileLength = iBufferLength;
																				pFileBuffer = pNewFileBuffer; 
																			}
/*
	std::vector<char> *GetFileData(int &iLength)								{	iLength = iFileLength;
																				return pFileBuffer; }
	void SetFileData(std::vector<char> *pNewFileBuffer, int iBufferLength)	{ 
																				iFileLength = iBufferLength;
																				pFileBuffer = pNewFileBuffer; 
																			}
*/
 
private:
	//value
	CTDVString sValue;
	//version of sValue that is editable
	CTDVString sValueEditable;

	//bitmask for what to validate against
	int iValidationCodes;
	//bitmask for results of validation
	int iValidationResults;

	//true if this field needs to be escaped (i.e. it's not GuideML)
	bool bEscaped;

	// If set to true, it lets the code know that the input is to be left alone and not escaped or altered
	bool bRawInput;

	// A value indictating the ExtraInfo action this param should take
	// Used by TypedArticle builder
	int nExtraInfoAction;

	//Generic Action for this param.
	CTDVString sParameterAction;

	//Namespace for this param
	CTDVString sParameterNamespace;

	// Contains parse errors, if any
	CTDVString sParseErrors;

	//true if this field is a special file entry type
	bool bFileType;

	// Contains the file data, if any
//	std::vector<char> *pFileBuffer;
	const char **pFileBuffer;
	int iFileLength;

	CTDVString sCustomErrorXML;
};

#endif // !defined(AFX_MULTISTEP_H__6A63A9AA_C24B_4436_8C20_A1856300CF49__INCLUDED_)

