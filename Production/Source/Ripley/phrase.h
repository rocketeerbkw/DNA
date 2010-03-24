#ifndef _PHRASE_H
#define _PHRASE_H

class PHRASE
{
public:
	PHRASE( CTDVString nspace, CTDVString phrase, int PhraseNameSpaceId = 0 ) : m_NameSpace(nspace), m_Phrase(phrase), m_PhraseNameSpaceId(PhraseNameSpaceId)
	{}

	//Allow use in sorted containers. Sort By NameSpace then Phrase by combining name space and phrase.
	bool operator < ( const PHRASE& cmp ) const 
	{ 
		return ( m_NameSpace + m_Phrase ) < ( cmp.m_NameSpace + cmp.m_Phrase ); 
	}
	
	//Required by Comparison algorithms.
	bool operator == ( const PHRASE& cmp) const 
	{ 
		return ( m_NameSpace + m_Phrase ) == ( cmp.m_Phrase + cmp.m_NameSpace ) != 0; 
	}
	
	CTDVString	m_Phrase;
	CTDVString	m_NameSpace;
	int			m_PhraseNameSpaceId;
};

typedef	vector<PHRASE> SEARCHPHRASELIST;

#endif