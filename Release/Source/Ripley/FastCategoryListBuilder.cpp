#include "stdafx.h"
#include ".\fastcategorylistbuilder.h"
#include ".\CategoryList.h"

CFastCategoryListBuilder::CFastCategoryListBuilder(CInputContext& inputContext) : CXMLBuilder(inputContext)
{
}

CFastCategoryListBuilder::~CFastCategoryListBuilder(void)
{
}

/*********************************************************************************

	CWholePage* CFastCategoryListBuilder::Build(void)

		Author:		Mark Howitt
        Created:	05/04/2004
        Inputs:		-
        Outputs:	-
        Returns:	A pointer to the page to be displayed
        Purpose:	Creates the fast category page

		URL :	cl?id=####	where #### is the GUID for a given list

		cl = FAST_CategoryList 

		THIS IS A FAST BUILDER!!! THIS MEANS IT IS DESIGNED TO HIT THE DATABASE
		AS LITTLE AS POSSIBLE!!! NO USER DETAILS ARE COLLECTED AND NO CALLS TO
		SSO ARE MADE!!!

*********************************************************************************/
bool CFastCategoryListBuilder::Build(CWholePage* pWholePage)
{
	// Setup some local variables
	bool bSuccess = true;
	CTDVString sError;

	// Create the page
	bSuccess = InitPage(pWholePage, "FASTCATEGORYLIST",false,false);

	// Check to see what mode we're in
	// Fast mode never gets any info on the user and is optimised to do as little
	// with the database as possible.
	if (m_InputContext.GetIsInFastBuilderMode())
	{
		// Get the GUID for the List
		CTDVString sGUID;
		if (!m_InputContext.GetParamString("id",sGUID))
		{
			// We need a GUID to get the lists!
			pWholePage->SetError("NoGUIDGiven");
			return true;
		}
		else
		{
			// Now get the categories associated with this id
			CCategoryList CatList(m_InputContext);
			if (!CatList.GetCategoryListForGUID(sGUID))
			{
				// We need a GUID to get the lists!
				bSuccess = bSuccess && pWholePage->AddInside("H2G2",CatList.GetLastErrorAsXMLString());
			}
			else
			{
				bSuccess = bSuccess && pWholePage->AddInside("H2G2",&CatList);
			}
		}
	}
	else
	{
		// We need a GUID to get the lists!
		pWholePage->SetError("FastBuilderCalledInNONFastMode");
		return true;
	}

	return bSuccess;	
}