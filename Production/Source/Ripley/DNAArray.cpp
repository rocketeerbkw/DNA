#include "stdafx.h"
#include ".\DNAArray.h"
#include ".\TDVAssert.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW

#endif

/*********************************************************************************

	CDNAIntArray::CDNAIntArray(void)

		Author:		Mark Howitt
        Created:	10/03/2004
		Info:		Simular to CArray

*********************************************************************************/
CDNAIntArray::CDNAIntArray(void) : m_pData(NULL), m_iSize(0), m_iMaxSize(0), m_iGrowBy(5)
{
}


/*********************************************************************************

	CDNAIntArray::CDNAIntArray(int iInitialSize, int iGrowBy = -1)

		Author:		Mark Howitt
        Created:	10/03/2004
        Inputs:		iInitialSize - The initial size of the array with no elements
					iGrowBy - The number of elements to grow the array when the 
								array reaches the maxsize limit

*********************************************************************************/
CDNAIntArray::CDNAIntArray(int iInitialSize, int iGrowBy) :	m_pData(NULL),
															m_iSize(iInitialSize),
															m_iMaxSize(iInitialSize),
															m_iGrowBy(5)
{
	// Make sure the grow value is valid
	if (m_iGrowBy > 0)
	{
		m_iGrowBy = iGrowBy;
	}

	// Now create a new array of the given size
	try
	{
		m_pData = new int[m_iMaxSize + m_iGrowBy];
	}
	catch (...)
	{
		m_pData = NULL;
		m_iSize = 0;
		m_iMaxSize = 0;
		TDVASSERT(false,"CDNAIntArray -Failed to create CDNAIntArray!");
	}

	// If we're ok, set the new elements to 0
	if (m_pData != NULL)
	{
		memset(m_pData,0,m_iSize * sizeof(int));
	}
}



/*********************************************************************************

	CDNAIntArray::~CDNAIntArray(void)

		Author:		Mark Howitt
        Created:	10/03/2004

*********************************************************************************/
CDNAIntArray::~CDNAIntArray(void)
{
	// Delete the array if it exists
	if (m_pData != NULL)
	{
		delete [] m_pData;
	}
}


/*********************************************************************************

	int CDNAIntArray::SetSize(int iSize, int iGrowBy = -1)

		Author:		Mark Howitt
        Created:	10/03/2004
        Inputs:		iSize - The Size of the array required
					iGrowBy - The amount of elements to grow the array if it needs to be resized.
        Returns:	The new size of the array.
        Purpose:	sets the array to a given size

*********************************************************************************/
int CDNAIntArray::SetSize(int iSize, int iGrowBy)
{
	// Update the growby if we've been given a valid one.
	if (iGrowBy > 0)
	{
		m_iGrowBy = iGrowBy;
	}

	// Check to see what we need to do
	if (m_pData == NULL && iSize > 0)
	{
		try
		{
			m_pData = new int[iSize];
		}
		catch (...)
		{
			TDVASSERT(false,"CDNAIntArray -Failed to create CDNAIntArray!");
			return 0;
		}
		m_iMaxSize = iSize;
		m_iSize = iSize;

		// If we're ok, set the new elements to 0
		if (m_pData != NULL)
		{
			memset(m_pData,0,m_iSize * sizeof(int));
		}
	}
	else if (iSize == 0)
	{
		// Delete the array and set everything to 0
		delete [] m_pData;
		m_pData = NULL;
		m_iMaxSize = 0;
		m_iSize = 0;
	}
	else if (iSize > m_iMaxSize)
	{
		// Create a New Array of the correct size
		int* pTemp = NULL;
		try
		{
			pTemp = new int[iSize];
		}
		catch (...)
		{
			TDVASSERT(false,"CDNAIntArray -Failed to create CDNAIntArray!");
			return 0;
		}

		// Initialise and copy the original data
		memset(pTemp,0,iSize * sizeof(int));
		memcpy(pTemp,m_pData,m_iSize * sizeof(int));

		// Set the maxsize to the new one.
		m_iMaxSize = iSize;
		m_iSize = iSize;

		// Delete the old array and set it to point at the new
		delete [] m_pData;
		m_pData = pTemp;
	}

	return m_iMaxSize;
}


/*********************************************************************************

	void CDNAIntArray::SetGrowBy(int iGrowBy)

		Author:		Mark Howitt
        Created:	10/03/2004
        Inputs:		iGrowBy - The number of elements to grow the array when
						it needs to be made bigger
        Purpose:	Sets the value of growby

*********************************************************************************/
void CDNAIntArray::SetGrowBy(int iGrowBy)
{
	// Make sure it's larger than 0!
	if (iGrowBy > 0)
	{
		m_iGrowBy = iGrowBy;
	}
}


/*********************************************************************************

	int CDNAIntArray::FreeExtra(void)

		Author:		Mark Howitt
        Created:	10/03/2004
        Returns:	The new Max Size of the array OR -1 if it fails
        Purpose:	Frees any memory not used by valid elements
					throws exceptions when things go wrong!

*********************************************************************************/
int CDNAIntArray::FreeExtra(void)
{
	// Create a New Array of the correct size
	int* pTemp = NULL;
	try
	{
		pTemp = new int[m_iSize];
	}
	catch (...)
	{
		TDVASSERT(false,"CDNAIntArray -Failed to create CDNAIntArray!");
		return 0;
	}

	// Set the maxsize to the new one.
	m_iMaxSize = m_iSize;

	// Now copy the old data into the new
	memcpy(pTemp,m_pData,m_iSize * sizeof(int));

	// Delete the old array and set it to point at the new
	delete [] m_pData;
	m_pData = pTemp;

	// Return the new maxsize
	return m_iMaxSize;
}

/*********************************************************************************

	void CDNAIntArray::RemoveAll(void)

		Author:		Mark Howitt
        Created:	10/03/2004
        Purpose:	Removes all the elements from the array. Done by setting
					the size of the array to 0.
					Call FreeExtra if you want to remove the allocated memory!

*********************************************************************************/
void CDNAIntArray::RemoveAll(void)
{
	// Set the actual size to 0
	m_iSize = 0;
}


/*********************************************************************************

	int CDNAIntArray::operator[](int iIndex) const

		Author:		Mark Howitt
        Created:	10/03/2004
        Inputs:		iIndex - An index into the array to which you want the element.
        Returns:	The value at the given index
        Purpose:	Returns the value of the element at the given index
					Throws execeptions if the index is out of range!

*********************************************************************************/
int CDNAIntArray::operator[](int iIndex) const
{
	// Make sure the index is within range!
	if (iIndex >= 0 && iIndex < m_iSize)
	{
		return m_pData[iIndex];
	}
	TDVASSERT(false,"CDNAIntArray::operator[] - Requested index out of range!");
	return 0;
}


/*********************************************************************************

	int& CDNAIntArray::operator[](int iIndex)

		Author:		Mark Howitt
        Created:	15/03/2004
		Inputs:		iIndex - An index into the array to which you want the element.
		Returns:	The value at the given index
		Purpose:	Returns the reference to the element at the given index
					Throws execeptions if the index is out of range!

*********************************************************************************/
int& CDNAIntArray::operator[](int iIndex)
{
	// Make sure the index is within range!
	if (iIndex >= 0 && iIndex < m_iSize)
	{
		return m_pData[iIndex];
	}
	TDVASSERT(false,"CDNAIntArray::operator[] - Requested index out of range!");
	throw 0;
}


/*********************************************************************************

	int CDNAIntArray::GetAt(int iIndex)

		Author:		Mark Howitt
		Created:	10/03/2004
		Inputs:		iIndex - An index into the array to which you want the element.
		Returns:	The value at the given index
		Purpose:	Returns the value of the element at the given index
					Throws execeptions if theindex is out of range!

*********************************************************************************/
int CDNAIntArray::GetAt(int iIndex)
{
	// Make sure the index is within range!
	if (iIndex >= 0 && iIndex < m_iSize)
	{
		return m_pData[iIndex];
	}
	TDVASSERT(false,"CDNAIntArray::operator[] - Requested index out of range!");
	return 0;
}


/*********************************************************************************

	bool CDNAIntArray::Add(int iValue)

		Author:		Mark Howitt
        Created:	10/03/2004
        Inputs:		iValue - The new value you want to add to the end of the array
		returns:	true if everything ok
        Purpose:	Adds a new element to the end of the array.
					Checks to see if the array size can hold another element,
					if not then creates a new array of the correct size before adding.

*********************************************************************************/
bool CDNAIntArray::Add(int iValue)
{
	// Check to see if we've run out of array space
	if (m_iSize >= m_iMaxSize || m_pData == NULL)
	{
		int* pTemp = NULL;
		try
		{
			pTemp = new int[m_iSize + m_iGrowBy];
		}
		catch (...)
		{
			TDVASSERT(false,"CDNAIntArray -Failed to create CDNAIntArray!");
			return false;
		}

		// Initialise and copy the original data
		memset(pTemp,0,(m_iSize + m_iGrowBy) * sizeof(int));
		memcpy(pTemp,m_pData,m_iSize * sizeof(int));

		// Set the maxsize to the new one.
		m_iMaxSize = m_iSize + m_iGrowBy;

		// Delete the old array and set it to point at the new
		delete [] m_pData;
		m_pData = pTemp;
	}

	// Now set the value for the new element
	m_pData[m_iSize++] = iValue;
	return true;
}

/*********************************************************************************

	bool CDNAIntArray::SetAt(int iIndex, int iValue)

		Author:		Mark Howitt
        Created:	10/03/2004
        Inputs:		iIndex - The index of the element you want to change
					iValue the new value for the element
		returns:	true if everything ok, false if not
        Purpose:	Sets the value of a given element.
					Throws exceptions if index out of range!

*********************************************************************************/
bool CDNAIntArray::SetAt(int iIndex, int iValue)
{
	// Check to see if we've run out of array space
	if (iIndex >= 0 && iIndex < m_iSize)
	{
		m_pData[iIndex] = iValue;
	}
	else
	{
		TDVASSERT(false,"CDNAIntArray::operator[] - Requested index out of range!");
		return false;
	}
	return true;
}


/*********************************************************************************

	bool CDNAIntArray::RemoveAt(int iIndex)

		Author:		Mark Howitt
        Created:	15/03/2004
        Inputs:		iIndex - the Index into the array you want to remove.
        Returns:	true - if removed ok, false if error.
        Purpose:	Removes an element at the given index. If the index value is
					invalid or the array has no size, then the function
					returns false.
					No memory is changed. Call FreeExtra if you want to delete
					unused memory.

*********************************************************************************/
bool CDNAIntArray::RemoveAt(int iIndex)
{
	// make sure we're have something to remove!
	if (m_iSize == 0)
	{
		TDVASSERT(false,"CDNAIntArray::RemoveAt - The array is empty!!");
		return false;
	}

	// Check to make sure we've been called with valid params
	if (iIndex >= m_iSize || iIndex < 0)
	{
		TDVASSERT(false,"CDNAIntArray::RemoveAt - Requested index out of range!");
		return false;
	}

	// Check to see if we're removing from the end, middle or beginning!
	if (iIndex == m_iSize - 1)
	{
		// remove from the end!
		m_iSize--;
	}
	else
	{
		// remove from the beginning or middle!
		memmove(&m_pData[iIndex],&m_pData[iIndex+1],m_iSize-iIndex);
		m_iSize--;
	}

	return true;
}


/*********************************************************************************

	void CDNAIntArray::RemoveEnd(void)

		Author:		Mark Howitt
        Created:	15/03/2004
        Purpose:	Removes the last element from the array.
					No memory is changed. Call FreeExtra if you want to delete
					unused memory.

*********************************************************************************/
void CDNAIntArray::RemoveEnd(void)
{
	// Check to see if we've got something to remove!
	if (m_iSize > 0)
	{
		// Just reduce the size of the array.
		m_iSize--;
	}
}
