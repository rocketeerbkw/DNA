// TopFives.cpp: implementation of the CTopFives class.
//
//////////////////////////////////////////////////////////////////////

/*

Copyright British Broadcasting Corporation 2001.

This code is owned by the BBC and must not be copied, 
reproduced, reconfigured, reverse engineered, modified, 
amended, or used in any other way, including without 
limitation, duplication of the live service, without 
express prior written permission of the BBC.

The code is provided "as is" and without any express or 
implied warranties of any kind including without limitation 
as to its fitness for a particular purpose, non-infringement, 
compatibility, security or accuracy. Furthermore the BBC does 
not warrant that the code is error-free or bug-free.

All information, data etc relating to the code is confidential 
information to the BBC and as such must not be disclosed to 
any other party whatsoever.

*/


#include "stdafx.h"
#include "tdvassert.h"
#include "TopFives.h"
#include "Category.h"
#include "TDVDateTime.h"
#include "TDVString.h"
#include "StoredProcedure.h"
#include "user.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CTopFives::CTopFives(CInputContext& inputContext) : m_bFetched(false), m_iSiteID(1), CXMLObject(inputContext)
{

}

CTopFives::~CTopFives()
{
	// No further destruction necessary - base class functionality only
}


bool CTopFives::AddTopFive(const TDVCHAR *pTopFiveName)
{
	return true;
}


/*********************************************************************************

	bool CTopFives::IsEmpty()

	Author:		Jim Lynn
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	true if this object has no tree information, false if it does
	Purpose:	Asks the TopFives object if it has XML information to provide.

*********************************************************************************/

bool CTopFives::IsEmpty()
{
	// It's not empty if any of the flags are on or there's a tree
	if (m_pTree != NULL)
	{
		return false;
	}
	else
	{
		return true;
	}
}

bool CTopFives::Destroy()
{
	// Call base class functionality
	return CXMLObject::Destroy();
}

/*********************************************************************************

	CXMLTree* CTopFives::ExtractTree()

	Author:		Jim Lynn
	Created:	02/03/2000
	Inputs:		-
	Outputs:	-
	Returns:	Tree representing the set of top fives we want
	Purpose:	Asks the database for the current top fives.

*********************************************************************************/

CXMLTree* CTopFives::ExtractTree()
{
	// If we haven't already fetched the topfives
	CXMLTree* pRootNode = m_pTree->FindFirstTagName("TOP-FIVES");
	pRootNode->DetachNodeTree();
	delete m_pTree;
	m_pTree = NULL;
	return pRootNode;
}

bool CTopFives::Initialise(int iSiteID, bool bNoCache, bool bRefreshCache)
{
	m_iSiteID = iSiteID;
	if (!m_bFetched)
	{
		CTDVDateTime dExpires(60*5);		// expire after 5 minutes
		CTDVString cachename="topfives-";
		cachename << m_iSiteID << ".xml";
		CTDVString sXML;
		bool bGotCache = false;
		
		// try to get a cached version and create object from that
		bGotCache = !bNoCache && CacheGetItem("topfives", cachename, &dExpires, &sXML);
		bGotCache = bGotCache && CreateFromCacheText(sXML);
		
		// if didn't get data from cache then get it from the DB
		// Actually do the fetching of the data
		if (!bGotCache)
		{
			// Create our stored procedure object
			CStoredProcedure SP;
			m_InputContext.InitialiseStoredProcedureObject(&SP);

			sXML = "<TOP-FIVES>";
			if (SP.GetSiteTopFives(m_iSiteID))
			{
				CCategory Cat(m_InputContext);

				CTDVString curgroup;
				while(!SP.IsEOF())
				{
					CTDVString sGroupName;
					SP.GetField("GroupName", sGroupName);

					CTDVString sGroupNameTemp =sGroupName;					
					CTDVString sTempCampaignEntry("MostRecentCampaignDiaryEntries");					
					CTDVString sTempComment("MostRecentComments");
					CTDVString sTempEvents("MostRecentEvents");					
					CTDVString sTempNotices("MostRecentNotice");
					
					sTempCampaignEntry.MakeLower();
					sTempComment.MakeLower();
					sGroupNameTemp.MakeLower( );

					bool bIsArticle=false;
					bool bIsClub=false;
					bool bIsUser=false;
					bool bIsTopic=false;
					bool bIsComment = sGroupNameTemp.CompareText(sTempComment);
					bool bIsCampaignEntry = sGroupNameTemp.CompareText(sTempCampaignEntry);
					bool bIsEvent = sGroupNameTemp.CompareText(sTempEvents);
					bool bIsNotice = sGroupNameTemp.CompareText(sTempNotices);

					if ( ( bIsComment == false) && ( bIsCampaignEntry == false)  && ( bIsEvent == false)   && ( bIsNotice == false) )
					{					
						bIsArticle = SP.IsNULL("ForumID");
						bIsClub	= !SP.IsNULL("ClubID");
						bIsUser	= !SP.IsNULL("UserID");
						bIsTopic = !SP.IsNULL("TopicID");						
					}

					int iNodeID = SP.GetIntField("NodeID");

					if (!curgroup.CompareText(sGroupName))
					{
						if (curgroup.GetLength() > 0)
						{
							sXML << "</TOP-FIVE>";
						}
						sXML << "<TOP-FIVE NAME='" << sGroupName << "'>";
						CTDVString sGroupDescription;
						SP.GetField("GroupDescription", sGroupDescription);
						sXML << "<TITLE>" << sGroupDescription << "</TITLE>";
						curgroup = sGroupName;
					}

					if(bIsClub)
					{
						int iClubID = SP.GetIntField("ClubID");
						CTDVString sSubject;
						SP.GetField("Title", sSubject);
						EscapeXMLText(&sSubject);
						sXML << "<TOP-FIVE-CLUB>";
						sXML << "<ClubID>" << iClubID << "</ClubID>";
						sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
						sXML << "</TOP-FIVE-CLUB>";
					}
					else if(bIsArticle && !bIsUser)
					{
						int ih2g2ID = SP.GetIntField("h2g2ID");
						CTDVString sSubject;
						SP.GetField("Subject", sSubject);
						EscapeXMLText(&sSubject);
						sXML << "<TOP-FIVE-ARTICLE>";
						sXML << "<H2G2ID>" << ih2g2ID << "</H2G2ID>";
						sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
						if (iNodeID)
						{
							sXML << "<NODEID>" << iNodeID << "</NODEID>";
							CTDVString sCatXML;
							if (Cat.GetCategoryAncestry(iNodeID,sCatXML))
							{
								sXML << sCatXML;
							}
						}

						//get extra info
						CTDVString sExtraInfo;
						SP.GetField("ExtraInfo", sExtraInfo);

						//get link item id
						int iLinkItemID = SP.GetIntField("LinkItemID");

						//get link item type
						CTDVString sLinkItemType;
						SP.GetField("LinkItemType", sLinkItemType);

						//get link item name
						CTDVString sLinkItemName;
						SP.GetField("LinkItemName", sLinkItemName);

						//get the updated date field
						CTDVDateTime dDateUpdated = SP.GetDateField("DateUpdated");
						CTDVString sDateUpdated = "";
						dDateUpdated.GetAsXML(sDateUpdated);

						//get the event date
						CTDVDateTime dEventDate = SP.GetDateField("EventDate");
						CTDVString sEventDate = "";
						dEventDate.GetAsXML(sEventDate);

						//put into xml						
						sXML << sExtraInfo;
						sXML << "<LINKITEMTYPE>" << sLinkItemType << "</LINKITEMTYPE>";
						sXML << "<LINKITEMID>" << sLinkItemType << "</LINKITEMID>";
						sXML << "<LINKITEMNAME>" << sLinkItemName << "</LINKITEMNAME>";
						sXML << "<DATEUPDATED>" << sDateUpdated << "</DATEUPDATED>";
						sXML << "<EVENTDATE>" << sEventDate << "</EVENTDATE>";

						//get item author id
						int iItemAuthorID = SP.GetIntField("ItemAuthorID");
						if (iItemAuthorID > 0)
						{
							CDBXMLBuilder XML;
							XML.Initialise(&sXML,&SP);
							XML.OpenTag("USER");
							XML.AddIntTag("USERID",iItemAuthorID);
							XML.DBAddTag("USERNAME");
							XML.DBAddTag("FIRSTNAMES",NULL,false);
							XML.DBAddTag("LASTNAME",NULL,false);
							XML.DBAddTag("USERTITLE","TITLE",false);
							XML.DBAddTag("SITESUFFIX",NULL,false);
							XML.DBAddTag("AREA",NULL,false);
							XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
							XML.CloseTag("USER");
/*
							CUser oUser (m_InputContext);
							if ( oUser.CreateFromID(iItemAuthorID) == true )
							{
								CTDVString sItemAuthorXML;
								oUser.GetAsString(sItemAuthorXML);
								sXML = sXML + sItemAuthorXML;
							}
*/
						}
						
						sXML << "</TOP-FIVE-ARTICLE>";
					}
					else if(bIsUser)
					{
						// Insert the user details into the xml
						InitialiseXMLBuilder(&sXML, &SP);
						bool bOk = OpenXMLTag("TOP-FIVE-ARTICLE");
						bOk = bOk && OpenXMLTag("USER");
						bOk = bOk && AddDBXMLIntTag("UserID",NULL,false);
						bOk = bOk && AddDBXMLTag("UserName",NULL,false);
						bOk = bOk && AddDBXMLTag("FirstNames",NULL,false);
						bOk = bOk && AddDBXMLTag("LastName",NULL,false);												
						bOk = bOk && AddDBXMLTag("Area",NULL,false);
						bOk = bOk && AddDBXMLIntTag("Status", NULL, false);
						bOk = bOk && AddDBXMLIntTag("TaxonomyNode", NULL, false);
						bOk = bOk && AddDBXMLIntTag("Journal", NULL, false);
						bOk = bOk && AddDBXMLIntTag("Active", NULL, false);							
						bOk = bOk && AddDBXMLTag("UserTitle",NULL,false);
						bOk = bOk && AddDBXMLTag("SiteSuffix",NULL,false);
						bOk = bOk && AddDBXMLTag("Title",NULL,false);
						bOk = bOk && CloseXMLTag("USER");
						bOk = bOk && CloseXMLTag("TOP-FIVE-ARTICLE");
						TDVASSERT(bOk,"TopFives::Initialise - Problems getting user article info from database");
					}
					else if (bIsCampaignEntry)
					{
						// Insert the user details into the xml
						InitialiseXMLBuilder(&sXML, &SP);
						bool bOk = OpenXMLTag("TOP-FIVE-CAMPAIGN-DIARY-ENTRY");
							bOk = bOk && AddDBXMLIntTag("ForumID",NULL,false);
							bOk = bOk && AddDBXMLIntTag("ThreadID",NULL,false);
							bOk = bOk && AddDBXMLIntTag("ClubID",NULL,false);
							bOk = bOk && AddDBXMLTag("Title",NULL,false);	
							
							CTDVString sSubject;
							SP.GetField("Subject", sSubject);
							if (SP.GetIntField("PostStyle") == 2)
							{
								CXMLObject::DoPlainTextTranslations(&sSubject);
							}

							sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
							bOk = bOk && AddDBXMLTag("ExtraInfo",NULL,false);															
							bOk = bOk && AddDBXMLTag("LinkItemType",NULL,false);	
							bOk = bOk && AddDBXMLIntTag("LinkItemID",NULL,false);	
							bOk = bOk && AddDBXMLTag("LinkItemName",NULL,false);								
							bOk = bOk && AddDBXMLDateTag("DateUpdated",NULL,false);	
							
							if ( bOk ) 
							{
								//get item author id
								int iItemAuthorID = SP.GetIntField("ItemAuthorID");							
								if (iItemAuthorID > 0)
								{
									CDBXMLBuilder XML;
									XML.Initialise(&sXML,&SP);
									XML.OpenTag("USER");
									XML.AddIntTag("USERID",iItemAuthorID);
									XML.DBAddTag("USERNAME");
									XML.DBAddTag("FIRSTNAMES",NULL,false);
									XML.DBAddTag("LASTNAME",NULL,false);
									XML.DBAddTag("USERTITLE","TITLE",false);
									XML.DBAddTag("SITESUFFIX",NULL,false);
									XML.DBAddTag("AREA",NULL,false);
									XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
									XML.CloseTag("USER");
/*
									CUser oUser (m_InputContext);
									if ( oUser.CreateFromID(iItemAuthorID) == true )
									{
										CTDVString sItemAuthorXML;
										oUser.GetAsString(sItemAuthorXML);
										sXML = sXML + sItemAuthorXML;
									}
*/
								}
							}
						bOk = CloseXMLTag("TOP-FIVE-CAMPAIGN-DIARY-ENTRY");
						TDVASSERT(bOk,"TopFives::Initialise - Problems getting MostRecentCampaignDiaryEntries info from database");
					}
					else if (bIsComment )
					{
						if ( SP.GetIntField("CommentId") > 0 )
						{
							// Insert the user details into the xml
							InitialiseXMLBuilder(&sXML, &SP);
							bool bOk = OpenXMLTag("TOP-FIVE-COMMENTS");
								bOk = bOk && AddDBXMLIntTag("ForumID",NULL,false);
								bOk = bOk && AddDBXMLIntTag("ThreadID",NULL,false);
								bOk = bOk && AddDBXMLIntTag("ClubID",NULL,false);
								bOk = bOk && AddDBXMLTag("Title",NULL,false);	
								
								CTDVString sSubject;
								SP.GetField("Subject", sSubject);
								if (SP.GetIntField("PostStyle") == 2)
								{
									CXMLObject::DoPlainTextTranslations(&sSubject);
								}

								sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
								bOk = bOk && AddDBXMLTag("ExtraInfo",NULL,false);	
								bOk = bOk && AddDBXMLDateTag("EventDate",NULL,false);															
								bOk = bOk && AddDBXMLTag("LinkItemType",NULL,false);	
								bOk = bOk && AddDBXMLIntTag("LinkItemID",NULL,false);	
								bOk = bOk && AddDBXMLTag("LinkItemName",NULL,false);								
								bOk = bOk && AddDBXMLDateTag("DateUpdated",NULL,false);	
								
								if ( bOk ) 
								{
									//get item author id
									int iItemAuthorID = SP.GetIntField("ItemAuthorID");							
									if (iItemAuthorID > 0)
									{
										CDBXMLBuilder XML;
										XML.Initialise(&sXML,&SP);
										XML.OpenTag("USER");
										XML.AddIntTag("USERID",iItemAuthorID);
										XML.DBAddTag("USERNAME");
										XML.DBAddTag("FIRSTNAMES",NULL,false);
										XML.DBAddTag("LASTNAME",NULL,false);
										XML.DBAddTag("USERTITLE","TITLE",false);
										XML.DBAddTag("SITESUFFIX",NULL,false);
										XML.DBAddTag("AREA",NULL,false);
										XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
										XML.CloseTag("USER");
/*
										CUser oUser (m_InputContext);
										if ( oUser.CreateFromID(iItemAuthorID) == true )
										{
											CTDVString sItemAuthorXML;
											oUser.GetAsString(sItemAuthorXML);
											sXML = sXML + sItemAuthorXML;
										}
*/
									}
								}

							bOk = CloseXMLTag("TOP-FIVE-COMMENTS");
							TDVASSERT(bOk,"TopFives::Initialise - Problems getting MostRecentComments info from database");
						}
					}
					else if (bIsEvent )
					{
						if ( SP.GetIntField("PostId") > 0 )
						{

							// Insert the user details into the xml
							InitialiseXMLBuilder(&sXML, &SP);
							bool bOk = OpenXMLTag("TOP-FIVE-EVENTS");
								bOk = bOk && AddDBXMLIntTag("ForumID",NULL,false);
								bOk = bOk && AddDBXMLIntTag("ThreadID",NULL,false);							
								bOk = bOk && AddDBXMLTag("Title",NULL,false);	
								
								CTDVString sSubject;
								SP.GetField("Subject", sSubject);
								if (SP.GetIntField("PostStyle") == 2)
								{
									CXMLObject::DoPlainTextTranslations(&sSubject);
								}

								sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
								bOk = bOk && AddDBXMLDateTag("EventDate",NULL,false);								
								bOk = bOk && AddDBXMLDateTag("DateUpdated",NULL,false);	
								
								if ( bOk ) 
								{
									//get item author id
									int iItemAuthorID = SP.GetIntField("ItemAuthorID");							
									if (iItemAuthorID > 0)
									{
										CDBXMLBuilder XML;
										XML.Initialise(&sXML,&SP);
										XML.OpenTag("USER");
										XML.AddIntTag("USERID",iItemAuthorID);
										XML.DBAddTag("USERNAME");
										XML.DBAddTag("FIRSTNAMES",NULL,false);
										XML.DBAddTag("LASTNAME",NULL,false);
										XML.DBAddTag("USERTITLE","TITLE",false);
										XML.DBAddTag("SITESUFFIX",NULL,false);
										XML.DBAddTag("AREA",NULL,false);
										XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
										XML.CloseTag("USER");
/*
										CUser oUser (m_InputContext);
										if ( oUser.CreateFromID(iItemAuthorID) == true )
										{
											CTDVString sItemAuthorXML;
											oUser.GetAsString(sItemAuthorXML);
											sXML = sXML + sItemAuthorXML;
										}
*/
									}
								}
							bOk = CloseXMLTag("TOP-FIVE-EVENTS");
							TDVASSERT(bOk,"TopFives::Initialise - Problems getting MostRecentEvents info from database");
						}
					}
					else if (bIsNotice )
					{
						if ( SP.GetIntField("PostId") > 0  )
						{
							// Insert the user details into the xml
							InitialiseXMLBuilder(&sXML, &SP);
							bool bOk = OpenXMLTag("TOP-FIVE-NOTICES");
								bOk = bOk && AddDBXMLIntTag("ForumID",NULL,false);
								bOk = bOk && AddDBXMLIntTag("ThreadID",NULL,false);							
								bOk = bOk && AddDBXMLTag("Title",NULL,false);	
								
								CTDVString sSubject;
								SP.GetField("Subject", sSubject);
								if (SP.GetIntField("PostStyle") == 2)
								{
									CXMLObject::DoPlainTextTranslations(&sSubject);
								}

								sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
								bOk = bOk && AddDBXMLDateTag("DateUpdated",NULL,false);	
								
								if ( bOk ) 
								{
									//get item author id
									int iItemAuthorID = SP.GetIntField("ItemAuthorID");														
									if (iItemAuthorID > 0)
									{
										CDBXMLBuilder XML;
										XML.Initialise(&sXML,&SP);
										XML.OpenTag("USER");
										XML.AddIntTag("USERID",iItemAuthorID);
										XML.DBAddTag("USERNAME");
										XML.DBAddTag("FIRSTNAMES",NULL,false);
										XML.DBAddTag("LASTNAME",NULL,false);
										XML.DBAddTag("USERTITLE","TITLE",false);
										XML.DBAddTag("SITESUFFIX",NULL,false);
										XML.DBAddTag("AREA",NULL,false);
										XML.DBAddIntTag("TAXONOMYNODE",NULL,false);
										XML.CloseTag("USER");
/*
										CUser oUser (m_InputContext);
										if ( oUser.CreateFromID(iItemAuthorID) == true )
										{
											CTDVString sItemAuthorXML;
											oUser.GetAsString(sItemAuthorXML);
											sXML = sXML + sItemAuthorXML;
										}
*/
									}
								}

							bOk = CloseXMLTag("TOP-FIVE-NOTICES");
							TDVASSERT(bOk,"TopFives::Initialise - Problems getting MostRecentNotices info from database");
						}
					}
					else
					{
						
						int iTopicID = SP.GetIntField("TopicID");
						CTDVString sForumType;
						//if a topic id exists we know we've dealing with topic top 5s
						if(iTopicID > 0)
						{
							sForumType << "TOPIC";
						}
						else
						{
							sForumType << "FORUM";
						}

						int iForumID = SP.GetIntField("ForumID");
						int iThreadID = SP.GetIntField("ThreadID");
						CTDVString sSubject;
						SP.GetField("Title", sSubject);
						EscapeXMLText(&sSubject);
						sXML << "<TOP-FIVE-" << sForumType << ">";
						sXML << "<FORUMID>" << iForumID << "</FORUMID>";
						if (iThreadID > 0)
						{
							sXML << "<THREADID>" << iThreadID << "</THREADID>";
						}
						sXML << "<SUBJECT>" << sSubject << "</SUBJECT>";
						sXML << "</TOP-FIVE-" << sForumType << ">";
					}
					SP.MoveNext();
					if (SP.IsEOF())
					{
						sXML << "</TOP-FIVE>";
					}
				}
			}
			sXML << "</TOP-FIVES>";
			CreateFromXMLText(sXML);

			if (bRefreshCache)
			{
				CTDVString StringToCache;
				//GetAsString(StringToCache);
				CreateCacheText(&StringToCache);
				CachePutItem("topfives", cachename, StringToCache);
			}
		}
	}
	return true;
}

void CTopFives::ClearCache(int iSiteID)
{

}
