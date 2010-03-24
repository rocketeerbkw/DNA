#include "stdafx.h"
#include ".\emailaddressfilter.h"

CEmailAddressFilter::CEmailAddressFilter(void)
{
}

CEmailAddressFilter::~CEmailAddressFilter(void)
{
}

/*********************************************************************************

	bool CEmailAddressFilter::CheckForEmailAddresses()

		Author:		Martin Robb
        Created:	
        Inputs:		-
        Outputs:	True if email address found.
        Returns:	-
        Purpose:	This would be a good candidate for porting. The .NET library includes
					Regular Express support which would be ideal for this task.

*********************************************************************************/
bool CEmailAddressFilter::CheckForEmailAddresses( const TDVCHAR *pCheckString )
{
	CTDVString sCheck(pCheckString);
	bool bemailfound = false;
	int start = sCheck.FindText("@",0);
	while ( start >= 0 && start < sCheck.GetLength()-1 )
	{
		//Look at email domain to decide whether it might be an email address.
		if (  isalnum(sCheck.GetAt(start+1)) )
		{
			int end = sCheck.FindText(" ",start+1);
			if ( end <= 0 )
				end = sCheck.GetLength();
			
			CTDVString sDomain = sCheck.Mid(start+1,(end-(start+1)));
			if ( sDomain.Find(".") > 0 )
			{
				bemailfound  = true;
				break;
			}
		}
		start = sCheck.FindText("@",start+1);
	}

	return bemailfound;
}

