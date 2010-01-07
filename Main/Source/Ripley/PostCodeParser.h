#include "tdvstring.h"

class CPostCodeParser
{
	class CPostCodeTemplate
	{
	public:
		TDVCHAR m_sFirstLetter;
		CTDVString m_sSecondLetterSet;
		bool m_bSecondLetterIsOptional;
	public:
		CPostCodeTemplate& operator=( const CPostCodeTemplate& rhs);
		static CPostCodeTemplate Create( const TDVCHAR sFirstLetter, const CTDVString sSecondLetterSet, const bool bSecondLetterIsOptional=false);
	};


	enum { 	TEMPLATES_ARRAY_SIZE = 23 };

public:
	CPostCodeParser(void);
	virtual ~CPostCodeParser(void);
protected:
	CPostCodeTemplate m_arrayOfPostCodeTemplates[TEMPLATES_ARRAY_SIZE];
	bool Matches(const TDVCHAR sFirstLetter, CTDVString sInput) const; 
public:
	bool IsPostCode (const CTDVString sInput) const;
	bool IsCloseMatch(const CTDVString sInput) const; 	
};
