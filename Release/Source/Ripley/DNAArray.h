//
// DNAArray.h
//

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

/*********************************************************************************

	class CDNAIntArray

		Author:		Mark Howitt
        Created:	10/03/2004
        Purpose:	New Int Array class with minimum functionality

*********************************************************************************/
class CDNAIntArray
{
public:
	CDNAIntArray();
	CDNAIntArray(int iInitialSize, int iGrowBy = -1);
    virtual ~CDNAIntArray(void);

public:
	bool IsEmpty(void) { return m_iSize <= 0; }

	// Removes all elements from the array
	void RemoveAll(void);
	bool RemoveAt(int iIndex);
	void RemoveEnd(void);

	// Returns the number of elements in the array
	int GetSize(void) { return m_iSize; }

	// Sets the overall allocated memory for the arry
	int SetSize(int iSize,int iGrowBy = -1);
	void SetGrowBy(int iGrowBy);
	int FreeExtra(void);
	
	// Get Functions
	int operator[](int iIndex) const;
	int GetAt(int iIndex);

	// Add Function
	bool Add(int iValue);

	// Set Function
	bool SetAt(int iIndex, int iValue);
	int& operator[](int iIndex);

private:
	int* m_pData;
	int m_iSize;
	int m_iMaxSize;
	int m_iGrowBy;

	int m_iInvalid;
};
