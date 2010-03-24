#ifndef SIMPLETEMPLATES_H
#define SIMPLETEMPLATES_H

#include <list>
#include <vector>
#include <set>
#include <map>

using namespace std;


/*********************************************************************************
class CSimplePtrList
Author:		Igor Loboda
Created:	7/1/2003
Purpose:	The template provides the subset of functionality available for <list> of
			pointers. Mainly the goal was to make it easier to use and wrap using SWIG.
			Instantiation: class CSimplePtrList<classname> - so the instance will be
			list of pointers to the given classname objects(classname*).
*********************************************************************************/

template <typename T> class CSimplePtrList
{
	protected:
		typedef T* TPtr;
		typedef list<TPtr> CList;
		typename CList::iterator m_It;
		CList m_List;
			
	public:
		CSimplePtrList();
		~CSimplePtrList();
		void Clear();
		unsigned long GetLength();
		T* GetFirst();
		T* GetNext();
		void Append(T* pItem);
};


/*********************************************************************************
CSimplePtrList::CSimplePtrList()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/
	
template <typename T> 	
CSimplePtrList<T>::CSimplePtrList()
{
	m_It = m_List.end();
}


/*********************************************************************************
CSimplePtrList::~CSimplePtrList()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/

template <typename T> 	
CSimplePtrList<T>::~CSimplePtrList()
{
	Clear();
}


/*********************************************************************************
void CSimplePtrList::Clear()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Purpose:	Calls delete on each item in the list and removes all items from the list.
*********************************************************************************/

template <typename T> 	
void CSimplePtrList<T>::Clear()
{
	m_It = m_List.begin();
	while (m_It != m_List.end())
	{
		delete (*m_It);
		m_It++;
	}

	m_List.clear();
	m_It = m_List.end();
}


/*********************************************************************************
unsigned long CSimplePtrList::GetLength()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	number of items in the list
*********************************************************************************/

template <typename T> 	
unsigned long CSimplePtrList<T>::GetLength()
{
	return m_List.size();
}


/*********************************************************************************
T* CSimplePtrList::GetFirst()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	pointer to the first item in the list or NULL if the list is empty
*********************************************************************************/

template <typename T> 	
T* CSimplePtrList<T>::GetFirst()
{
	m_It = m_List.begin();

	return GetNext();	
}


/*********************************************************************************
T* CSimplePtrList::GetNext()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	pointer to the next item in the list or NULL if the list is empty.
*********************************************************************************/

template <typename T> 	
T* CSimplePtrList<T>::GetNext()
{
	if (m_It == m_List.end())
	{
		return NULL;
	}

	T* item = *m_It;
	m_It++;
	return item;
}


/*********************************************************************************
void CSimplePtrList::Append()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Inputs:		pItem - pointer to add to the list. Nothing is added to the list if pItem is NULL.
Purpose:	Adds given pointer to the end of the list
*********************************************************************************/

template <typename T> 	
void CSimplePtrList<T>::Append(T* pItem)
{
	if (pItem)
	{
		m_List.insert(m_List.end(), pItem);
	}
}


/*********************************************************************************
class CSimplePtrVector
Author:		Igor Loboda
Created:	7/1/2003
Purpose:	The template provides the subset of functionality available for <vector> of
			pointers with sorting possibility. Mainly the goal was to make it easier 
			to use and wrap using SWIG.
			Instantiation: class CSimplePtrVector<classname, sorterclassname> - so the instance 
			will be vector of pointers to the given classname objects (classname*). sorterclassname
			should be class with public function of the following prototype:
			bool operator()(const classname*& a, const classname*& b) const; and it's better to
			do it this way:
			typedef classname* classnameptr;
			bool operator()(const classnameptr& a, const classnameptr& b) const;
			The instance of this class will be used to sort the vector.
*********************************************************************************/

template <typename T, typename Comp> class CSimplePtrVector
{
	protected:
		typedef T* TPtr;
		typedef vector<TPtr> CList;
		typename CList::iterator m_It;
		CList m_List;
			
	public:
		CSimplePtrVector();
		~CSimplePtrVector();
		void Clear();
		unsigned long GetLength();
		T* GetFirst();
		void Sort(Comp& sorter);
		T* GetNext();
		void Append(T* pItem);
};
			

/*********************************************************************************
CSimplePtrVector::CSimplePtrVector()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/

template <typename T, typename Comp>	
CSimplePtrVector<T, Comp>::CSimplePtrVector()
{
	m_It = m_List.end();
}

	

/*********************************************************************************
CSimplePtrVector::~CSimplePtrVector()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/
	
template <typename T, typename Comp>	
CSimplePtrVector<T, Comp>::~CSimplePtrVector()
{
	Clear();
}


/*********************************************************************************
void CSimplePtrVector::Clear()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Purpose:	Calls delete on each item in the vector and removes all items from the vector.
*********************************************************************************/

template <typename T, typename Comp>	
void CSimplePtrVector<T, Comp>::Clear()
{
	m_It = m_List.begin();
	while (m_It != m_List.end())
	{
		delete (*m_It);
		m_It++;
	}

	m_List.clear();
	m_It = m_List.end();
}


/*********************************************************************************
unsigned long CSimplePtrVector::GetLength()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	number of items in the vector
*********************************************************************************/

template <typename T, typename Comp>	
unsigned long CSimplePtrVector<T, Comp>::GetLength()
{
	return m_List.size();
}


/*********************************************************************************
T* CSimplePtrVector::GetFirst()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	pointer to the first item in the vector or NULL if the vector is empty
*********************************************************************************/

template <typename T, typename Comp>	
T* CSimplePtrVector<T, Comp>::GetFirst()
{
	m_It = m_List.begin();

	return GetNext();	
}

/*********************************************************************************
void CSimplePtrVector::Sort(Comp& sorter)
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Inputs:		sorter - object to use to sort the vector. Has to have public method:
			bool operator()(const T& a, const T& b) const;
Purpose:	sorts the vector
*********************************************************************************/

template <typename T, typename Comp>	
void CSimplePtrVector<T, Comp>::Sort(Comp& sorter)
{
	sort(m_List.begin(), m_List.end(), sorter);
}


/*********************************************************************************
T* CSimplePtrVector::GetNext()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	pointer to the next item in the vector or NULL if the vector is empty.
*********************************************************************************/

template <typename T, typename Comp>	
T* CSimplePtrVector<T, Comp>::GetNext()
{
	if (m_It == m_List.end())
	{
		return NULL;
	}

	T* item = *m_It;
	m_It++;
	return item;
}


/*********************************************************************************
void CSimplePtrVector::Append()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Inputs:		pItem - pointer to add to the vector. Nothing is added to the vector if pItem is NULL.
Purpose:	Adds given pointer to the end of the vector
*********************************************************************************/

template <typename T, typename Comp>	
void CSimplePtrVector<T, Comp>::Append(T* pItem)
{
	if (pItem)
	{
		m_List.insert(m_List.end(), pItem);
	}
}


/*********************************************************************************
class CSimplePtrSet
Author:		Igor Loboda
Created:	7/1/2003
Purpose:	The template provides the subset of functionality available for <set> of
			pointers. Mainly the goal was to make it easier to use and wrap using SWIG.
			Instantiation: class CSimplePtrSet<classname> - so the instance 
			will be set of pointers to the given classname objects (classname*).
*********************************************************************************/

template <typename T> class CSimplePtrSet
{
	protected:
		typedef T* TPtr;
		typedef set<TPtr> CSet;
		CSet m_Set;
		typename CSet::iterator m_It;
			
	public:
		CSimplePtrSet();
		~CSimplePtrSet();
		void Clear();
		unsigned long GetLength();
		T* GetFirst();
		T* GetNext();
		void Insert(T* pItem);
};
	

/*********************************************************************************
CSimplePtrSet::CSimplePtrSet()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/
	
template <typename T> 
CSimplePtrSet<T>::CSimplePtrSet()
{
	m_It = m_Set.end();
}

	

/*********************************************************************************
CSimplePtrSet::~CSimplePtrSet()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/

template <typename T> 	
CSimplePtrSet<T>::~CSimplePtrSet()
{
	Clear();
}


/*********************************************************************************
void CSimplePtrSet::Clear()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Purpose:	Calls delete on each item in the set and removes all items from the set.
*********************************************************************************/

template <typename T> 	
void CSimplePtrSet<T>::Clear()
{
	m_It = m_Set.begin();
	while (m_It != m_Set.end())
	{
		delete (*m_It);
		m_It++;
	}

	m_Set.clear();
	m_It = m_Set.end();
}


/*********************************************************************************
unsigned long CSimplePtrSet::GetLength()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	number of items in the set
*********************************************************************************/

template <typename T> 	
unsigned long CSimplePtrSet<T>::GetLength()
{
	return m_Set.size();
}


/*********************************************************************************
T* CSimplePtrSet::GetFirst()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	pointer to the first item in the set or NULL if the set is empty
*********************************************************************************/

template <typename T> 	
T* CSimplePtrSet<T>::GetFirst()
{
	m_It = m_Set.begin();

	return GetNext();	
}


/*********************************************************************************
T* CSimplePtrSet::GetNext()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	pointer to the next item in the set or NULL if the set is empty.
*********************************************************************************/

template <typename T> 	
T* CSimplePtrSet<T>::GetNext()
{
	if (m_It == m_Set.end())
	{
		return NULL;
	}

	T* item = *m_It;
	m_It++;
	return item;
}


/*********************************************************************************
void CSimplePtrSet::Insert()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Inputs:		pItem - pointer to add to the set. Nothing is added to the set if pItem is NULL.
*********************************************************************************/

template <typename T> 	
void CSimplePtrSet<T>::Insert(T* pItem)
{
	if (pItem)
	{
		m_Set.insert(pItem);
	}
}


/*********************************************************************************
class CSimpleSet
Author:		Igor Loboda
Created:	7/1/2003
Purpose:	The template provides the subset of functionality available for <set> of
			objects. Mainly the goal was to make it easier to use and wrap using SWIG.
			Instantiation: class CSimplePtrSet<classname> - so the instance 
			will be set of object of class classname.
*********************************************************************************/

template <typename T> class CSimpleSet
{
	protected:
		typedef set<T> CSet;
		CSet m_Set;
		typename CSet::iterator m_It;
			
	public:
		CSimpleSet();
		~CSimpleSet();
		void Clear();
		unsigned long GetLength();
		bool GetFirst(T& retValue);
		bool GetNext(T& retValue);
		void Insert(T& item);
};

	
/*********************************************************************************
CSimpleSet::CSimpleSet()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/
	
template <typename T> 	
CSimpleSet<T>::CSimpleSet()
{
	m_It = m_Set.end();
}

	

/*********************************************************************************
CSimpleSet::~CSimpleSet()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
*********************************************************************************/
	
template <typename T> 	
CSimpleSet<T>::~CSimpleSet()
{
	Clear();
}


/*********************************************************************************
void CSimpleSet::Clear()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Purpose:	Removes all items from the set.
*********************************************************************************/

template <typename T> 	
void CSimpleSet<T>::Clear()
{
	m_Set.clear();
}


/*********************************************************************************
unsigned long CSimpleSet::GetLength()
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Returns:	number of items in the set
*********************************************************************************/

template <typename T> 	
unsigned long CSimpleSet<T>::GetLength()
{
	return m_Set.size();
}


/*********************************************************************************
bool CSimpleSet::GetFirst(T& retValue)
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Outputs:	first item in the set
Returns:	true if item exist
*********************************************************************************/

template <typename T> 	
bool CSimpleSet<T>::GetFirst(T& retValue)
{
	m_It = m_Set.begin();

	return GetNext(retValue);
}


/*********************************************************************************
bool CSimpleSet::GetNext(T& retValue)
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Outputs:	next item in the set
Returns:	true if the item exists
*********************************************************************************/

template <typename T> 	
bool CSimpleSet<T>::GetNext(T& retValue)
{
	if (m_It == m_Set.end())
	{
		return false;
	}

	retValue = *m_It;
	m_It++;
	return true;
}


/*********************************************************************************
void CSimpleSet::Insert(T& item)
Author:		Igor Loboda
Created:	7/1/2003
Visibility:	public
Inputs:		item - item to add to the set.
*********************************************************************************/

template <typename T> 	
void CSimpleSet<T>::Insert(T& item)
{
	m_Set.insert(item);
}


/*********************************************************************************
class CSimplePtrMap
Author:		Igor Loboda
Created:	16/04/2003
Purpose:	The template provides the subset of functionality available for <map> of
			pointers. Mainly the goal was to make it easier to use and wrap using SWIG.
			Instantiation: class CSimplePtrMap<type1, type2> - so the instance 
			will be map of variables of type1 to pointers to the type2*.
*********************************************************************************/

template <typename TKey, typename T> class CSimplePtrMap
{
	protected:
		typedef T* TPtr;
		typedef map<TKey, TPtr> CMap;
		CMap m_Map;
		mutable typename CMap::const_iterator m_ConstIt;
			
	public:
			
		void Erase(const TKey& key);
		CSimplePtrMap();
		~CSimplePtrMap();
		void Clear();
		unsigned long GetLength() const;
		const T* GetFirst() const;
		const T* GetNext() const;
		T* GetFirst();
		T* GetNext();
		const T* Find(const TKey& key) const;
		T* Find(const TKey& key);		
		void Insert(TKey key, T* pItem);

	private:
		T* RealFind(const TKey& key) const;
		T* RealGetNext() const;
		T* RealGetFirst() const;
};

/*********************************************************************************
		CSimplePtrMap::CSimplePtrMap()
		Author:		Igor Loboda
		Created:	16/04/2003
		Visibility:	public
*********************************************************************************/
			
template <typename TKey, typename T> 
CSimplePtrMap<TKey, T>::CSimplePtrMap()
:
m_ConstIt(m_Map.end())
{
}

/*********************************************************************************
CSimplePtrMap::~CSimplePtrMap()
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
*********************************************************************************/
			
template <typename TKey, typename T> 
CSimplePtrMap<TKey, T>::~CSimplePtrMap()
{
	Clear();
}

template <typename TKey, typename T> 
T* CSimplePtrMap<TKey, T>::RealGetNext() const
{
	if (m_ConstIt == m_Map.end())
	{
		return NULL;
	}

	T* item = m_ConstIt->second;
	m_ConstIt++;
	return item;
}

template <typename TKey, typename T> 
T* CSimplePtrMap<TKey, T>::RealGetFirst() const
{
	m_ConstIt = m_Map.begin();

	return RealGetNext();	
}
		
/*********************************************************************************
CSimplePtrMap::Clear()
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Purpose:	Calls delete on each item in the map and removes all items from the map.
*********************************************************************************/

template <typename TKey, typename T> 
void CSimplePtrMap<TKey, T>::Clear()
{
	typename CMap::iterator m_It = m_Map.begin();
	while (m_It != m_Map.end())
	{
		delete m_It->second;
		m_It++;
	}

	m_Map.clear();
	m_It = m_Map.end();
}
		

/*********************************************************************************
void CSimplePtrMap::Erase(TKey key)
Author:		Igor Loboda
Created:	06/09/2004
Inputs:		key - value with this key is to be removed
Visibility:	public
*********************************************************************************/

template <typename TKey, typename T> 
void CSimplePtrMap<TKey, T>::Erase(const TKey& key)
{
	typename CMap::iterator findIt = m_Map.find(key);
	if (findIt != m_Map.end()) 
	{ 	
		delete findIt->second;
		m_Map.erase(findIt); 
	}
}

/*********************************************************************************
CSimplePtrMap::GetLength()
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Returns:	number of items in the map
*********************************************************************************/

template <typename TKey, typename T> 
unsigned long CSimplePtrMap<TKey, T>::GetLength() const
{
	return m_Map.size();
}


/*********************************************************************************
CSimplePtrMap::GetFirst()
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Returns:	pointer to the first item in the map or NULL if the map is empty
*********************************************************************************/

template <typename TKey, typename T> 
const T* CSimplePtrMap<TKey, T>::GetFirst() const
{
	return RealGetFirst();	
}
template <typename TKey, typename T> 
const T* CSimplePtrMap<TKey, T>::GetNext() const
{
	return RealGetNext();
}

template <typename TKey, typename T> 
T* CSimplePtrMap<TKey, T>::GetFirst()
{
	return RealGetFirst();	
}


/*********************************************************************************
CSimplePtrMap::GetNext()
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Returns:	pointer to the next item in the map or NULL if the map is empty.
*********************************************************************************/

template <typename TKey, typename T> 
T* CSimplePtrMap<TKey, T>::GetNext()
{
	return RealGetNext();
}


/*********************************************************************************
CSimplePtrMap::Find(TKey key)
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Inputs:		key - key to search for in the map
Returns:	pointer to map element or NULL if element with given key is not found
*********************************************************************************/

template <typename TKey, typename T> 
const T* CSimplePtrMap<TKey, T>::Find(const TKey& key) const
{
	return RealFind(key);
}

template <typename TKey, typename T> 
T* CSimplePtrMap<TKey, T>::Find(const TKey& key)
{
	return RealFind(key);
}


/*********************************************************************************
CSimplePtrMap::Insert(TKey key, T* pItem)
Author:		Igor Loboda
Created:	16/04/2003
Visibility:	public
Inputs:		key - key for the item
			pItem - pointer to add to the map. NULL is allowed and stored
*********************************************************************************/

template <typename TKey, typename T> 
void CSimplePtrMap<TKey, T>::Insert(TKey key, T* pItem)
{
	#ifdef __SUNPRO_CC
	m_Map.insert(CMap::value_type(key, pItem));
	#else
	m_Map.insert(typename CMap::value_type(key, pItem));
	#endif
}

template <typename TKey, typename T> 
T* CSimplePtrMap<TKey, T>::RealFind(const TKey& key) const
{
	typename CMap::const_iterator findIt = m_Map.find(key);
	if (findIt == m_Map.end())
	{
		return NULL;
	}

	T* item = findIt->second;
	return item;
}

#endif
