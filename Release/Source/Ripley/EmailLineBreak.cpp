#include "stdafx.h"
#include ".\emaillinebreak.h"

CLineBreakInserter::CLineBreakInserter(int iBreakAfterHint) : m_iBreakAfterHint(iBreakAfterHint)
{
}

CLineBreakInserter::~CLineBreakInserter(void)
{
}


const CTDVString& CLineBreakInserter::operator ()(CTDVString& sText) const
{
	// This method will insert additional line breaks into the input string.
	// 1. It will preserve all existing line breaks.
	// 2. Lines will be broken at the nearest space to the break after hint.

	// counter to the current position in the string
	int iCurPos = 0;
	// counter to the previous position, difference in the 2 allows
	// the length of the sub-string we're currently interested in to be found
	int iPrevPos = 0;
	int iLenSubStr = 0;
	// this will be the number of breaks reqd. in the current sub-string 
	int iNumBreaksReqd = 0;
	// length of the string - so we can tell when we get to the end
	int iLength = sText.GetLength();

	while (iCurPos < iLength)
	{
		// update previous position 
		iPrevPos = iCurPos;
		// find the next specified line break
		iCurPos = sText.Find("\n", iCurPos);
		//calc length of the sub-string
		iLenSubStr = iCurPos - iPrevPos;
		if (iLenSubStr > m_iBreakAfterHint)
		{
			int iPosSpace1 = iPrevPos;
			int iPosSpace2 = iPrevPos;
			// calculate the number of breaks reqd.
			iNumBreaksReqd = iLenSubStr / m_iBreakAfterHint;
			// if the sub-string is longer than the break after hint
			// extra line space will be need to be inserted.
			// keep going while breaks are reqd.
			while (iNumBreaksReqd)
			{
				iPosSpace1 = sText.Find(" ", iPrevPos);
				iPosSpace2 = sText.Find(" ", iPosSpace1);

				// find the space before the hint from the prev. pos
				if (iPosSpace2 - iPrevPos > m_iBreakAfterHint &&
					iPosSpace1 - iPrevPos > m_iBreakAfterHint)
				{
					// an individual string is longer than the hint length
					// will just have to break before and after
					// replace just the space 
					sText.SetAt(iPosSpace1, '\n');
					// replace from the insert point to the next space - i.e. only 
					sText.SetAt(iPosSpace2, '\n');
					iNumBreaksReqd--;
				}
				else if (iPosSpace2 - iPrevPos > m_iBreakAfterHint &&
					iPosSpace1 - iPrevPos <= m_iBreakAfterHint)
				{
					// ok enough text captured, can break here
					sText.SetAt(iPosSpace1, '\n');
					iNumBreaksReqd--;
				}
				else 
				{
					// update the counters
					iPrevPos = iPosSpace1;
				}		
			}
		}
	}
	return sText;
}