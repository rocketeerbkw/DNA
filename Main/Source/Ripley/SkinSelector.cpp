#include "stdafx.h"
#include "TDVString.h"
#include "InputContext.h"
#include "User.h"
#include "SkinSelector.h"


CSkinSelector::CSkinSelector(void) 
{
}

CSkinSelector::~CSkinSelector(void)
{
}


bool CSkinSelector::Initialise( CInputContext& InputContext )
{
    CTDVString sSkin;
    InputContext.GetSkin(&sSkin);

    InputContext.GetSkinSet(&m_SkinSet);

    int iSiteId = InputContext.GetSiteID();

    //Check if specified skin is OK.
    if ( !sSkin.IsEmpty() && InputContext.DoesSkinExistInSite(iSiteId, sSkin)  )
    {
        m_SkinName = sSkin;
        return true;
    }

     // Check if skin can be provided from vanilla skinset.
    if ( !sSkin.IsEmpty() )
    {
        CTDVString sStylesheet;
	    InputContext.GetStylesheetHomePath(sStylesheet);
	    sStylesheet += "\\Skins\\SkinSets\\vanilla\\" + sSkin + "\\output.xsl";
        if ( TestFileExists(sStylesheet) )
        {
            m_SkinSet = "vanilla";
            m_SkinName = sSkin;
            return true;
        }
    }


    // XML Skins / Feeds etc
    //if ( sSkin.CompareText("purexml") || sSkin.CompareText("xml") || sSkin.CompareText("ssi") || sSkin.Right(4).CompareText("-xml") || sSkin.Right(4).CompareText("-ssi") )
   // {
   //     return sSkin;
   // }

    // Fallback to users preferred skin.
    CUser* pViewingUser = InputContext.GetCurrentUser();
    if ( pViewingUser ) 
    {
		if ( pViewingUser->GetPrefSkin(&sSkin) && !sSkin.CompareText("default"))
        {
            if ( InputContext.DoesSkinExistInSite(iSiteId, sSkin) )
            {
                m_SkinName = sSkin;
                return true;
            }  
        }
    }

    // Fallback to Default Skin for Site
    InputContext.GetDefaultSkin(sSkin);
    if (  InputContext.DoesSkinExistInSite(iSiteId, sSkin) )
    {
        m_SkinName = sSkin;
        return true;
    }

    // Unable to find a suitable skin - Return vanilla default.
    CTDVString sStylesheet;
	InputContext.GetStylesheetHomePath(sStylesheet);
	sStylesheet += "\\Skins\\SkinSets\\vanilla\\html\\output.xsl";
    if ( TestFileExists(sStylesheet) )
    {
        m_SkinSet = "vanilla";
        m_SkinName = "html";
        return true;
    }


   return false;
}

CTDVString CSkinSelector::GetSkinName()
{
    return m_SkinName;
}

CTDVString CSkinSelector::GetSkinSet()
{
    return m_SkinSet;
}

bool CSkinSelector::IsXmlSkin( CTDVString skinname )
{
    if ( skinname == "xml" || skinname.Right(4) == "-xml" )
        return true;
    return false;
}

bool CSkinSelector::TestFileExists(const CTDVString& sFile)
{
    FILE* fp;
	fp = fopen(sFile, "r");
	if (fp == NULL)
	{
		return false;
	}
    fclose(fp);
	return true;
}
