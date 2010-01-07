#include "stdafx.h"
#include ".\topicbuilder.h"
#include ".\tdvassert.h"
#include ".\User.h"
#include ".\MultiStep.h"
#include ".\FrontPageLayout.h"
#include ".\SiteConfigPreview.h"

CTopicBuilder::CTopicBuilder(CInputContext& inputContext): 
CXMLBuilder(inputContext),
m_iSiteID(0), 
m_pWholePage(NULL),
m_Topic(inputContext)
{
	m_AllowedUsers = USER_EDITOR | USER_ADMINISTRATOR;
}

CTopicBuilder::~CTopicBuilder(void)
{

}

/*********************************************************************************

	bool CTopicBuilder::Build(CWholePage* pPage)

		Author:		David E
        Created:	15/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopicBuilder::Build(CWholePage* pPage)
{
	m_pWholePage = pPage;
	
	// Create and init the page
	bool bPageOk = true;
	bPageOk = InitPage(m_pWholePage, "TOPICBUILDER", false, false);
	if (!bPageOk)
	{
		TDVASSERT(false,"CTopicBuilder - Failed to create Whole Page object!");
		return false;
	}

	// Check to make sure we have a logged in user or editor
	CUser* pUser = m_InputContext.GetCurrentUser();

	//if unable to do so then report error 
	if (pUser == NULL)
	{
		// this operation requires a logged on user
		SetDNALastError("CTopicBuilder::Build", "UserNotLoggedIn", "User Not Logged In");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return true;
	}
	
	// Get the editor status, and check to make sure the current user matches the input or they are an editor!
	if (!pUser->GetIsEditor())
	{
		SetDNALastError("CTopicBuilder::Build","UserNotAuthorised","User Is Not Authorised");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return true;
	}

	// Get the current site id
	m_iSiteID = m_InputContext.GetSiteID();
	
	// Put the frontpage layout info intot the page as this dictates how many textboxes and sizes are allowed.
	CFrontPageLayout FPLayout(m_InputContext);
	CTDVString sFrontPageLayout;
	if (FPLayout.InitialisePageBody(m_iSiteID,true,true) && FPLayout.GetPageLayoutXML(sFrontPageLayout))
	{
		// add the object inside the FRONTPAGE element
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<FRONTPAGE></FRONTPAGE>");
		bPageOk = bPageOk && m_pWholePage->AddInside("FRONTPAGE", sFrontPageLayout);
	}
	else
	{
		// Set an error in the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2",FPLayout.GetLastErrorAsXMLString());
	}

	// Are we wanting to recache the topics lists
	if (m_InputContext.ParamExists("refreshcache"))
	{
		m_InputContext.RefreshTopicLists(m_iSiteID);
	}

	// Find out what page we're on		
	//determine if a page was specified	
	CTDVString sCurrentPage;	
	m_InputContext.GetParamString("page",sCurrentPage);
	if ( sCurrentPage.IsEmpty() )
	{
		sCurrentPage = "topiclist";
	}

	// Setup the page
	bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
	
	// Now put the Preview SiteConfig into the page xml
	CTDVString sSiteConfig;
	CSiteConfigPreview SiteConfig(m_InputContext);
	if (SiteConfig.GetPreviewSiteConfig(sSiteConfig,m_iSiteID))
	{
		// Insert into the page
		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2/TOPIC_PAGE",sSiteConfig);
	}

	if (!sCurrentPage.CompareText("topiclist") && !sCurrentPage.CompareText("createpage") && !sCurrentPage.CompareText("editpage") && !sCurrentPage.CompareText("positionpage"))
	{
		SetDNALastError("CTopicBuilder::Build", "InvalidPage", "The page parameter is invalid");
		m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
		return AddTopicListToPage();
	}

	bool bUseRedirect = false;

	//handle pages
	if (sCurrentPage.CompareText("topiclist"))
	{
		//determine if a valid cmd param was passed in 
		CTDVString sCmd = "";
		m_InputContext.GetParamString("cmd",sCmd);

		CTDVString sAction;
		CTDVString sObject;
		
		if (!sCmd.CompareText("") && !sCmd.CompareText("create") && !sCmd.CompareText("edit") && !sCmd.CompareText("delete") && !sCmd.CompareText("unarchive"))
		{
			SetDNALastError("CTopicBuilder::Build", "InvalidCmd", "The cmd parameter is invalid");
			m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			return AddTopicListToPage();
		}

		int iTopicID = 0;
		if (sCmd.CompareText("create"))
		{
			iTopicID = 0;
		}
		else if (sCmd.CompareText("edit") || sCmd.CompareText("delete") || sCmd.CompareText("move") || sCmd.CompareText("unarchive"))
		{
			//get the iTopicID for the underlying item if any
			if (!m_InputContext.ParamExists("topicid"))
			{
				SetDNALastError("CTopicBuilder::Build", "NoTopicID", "Topic ID param is not specified");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}						
			iTopicID = m_InputContext.GetParamInt("topicid");
		}

		//create cmd
		if (sCmd.CompareText("create"))
		{									
			CMultiStep Multi(m_InputContext, "TOPIC");
			Multi.AddRequiredParam("title","",true);
			Multi.AddRequiredParam("text");
			
			if (!Multi.ProcessInput())
			{
				SetDNALastError("CTopicBuilder::Build","BuildFailed","Failed to process input");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}

			if (Multi.ErrorReported())
			{
				SetDNALastError("CTopicBuilder::Build","BuildFailed","Mutil-step error reported");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}

			//obtain parameters
			CTDVString sTitle;
			
			bool bGotParams = true;
			bGotParams = bGotParams && Multi.GetRequiredValue("title", sTitle);
			
			CTDVString sText = "<GUIDE><BODY>";
			bGotParams = bGotParams && Multi.GetRequiredAsXML("TEXT", sText);
			bGotParams = bGotParams && Multi.GetAllElementsAsXML(sText);
			sText << "</BODY></GUIDE>";

			// BODGE!!! At this late stage this is the best we can do for now.
			// This will need replacing at some point! PLEASE!!!!
			sText.Replace("<TEXT>","");
			sText.Replace("</TEXT>","");

			//if validation fails 
			if ( (bGotParams && Multi.ReadyToUse() ) == false)
			{	
				//Recreate create page 
				sCurrentPage = "createpage";
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
				if ( Multi.ErrorReported() )
					SetDNALastError("TopicBuilder::Build","Parse Error",Multi.GetLastErrorAsXMLString()); 
				else
					SetDNALastError("TopicBuilder::Build","Bad Parameters","Missing required parameter(s)");

				//Add error into XML.
				m_pWholePage->AddInside("H2G2", GetLastErrorAsXMLString());
				m_pWholePage->AddInside("H2G2/TOPIC_PAGE", Multi.GetAsXML());
				return true;
			}	
						
			//now create				
			int iTopicLinkID  = 0;	
			if (!m_Topic.CreateTopic(iTopicID, m_iSiteID, pUser->GetUserID( ), sTitle, sText, CTopic::TS_PREVIEW, iTopicLinkID, false))
			{	
				//go back to the create page abnd display error				
				sCurrentPage = "createpage";
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
				CTDVString sXML;
				sXML << Multi.GetAsXML();
				m_pWholePage->AddInside("H2G2/TOPIC_PAGE", sXML);				

				// get the error if creatioh fails
				m_pWholePage->AddInside("H2G2",m_Topic.GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}						
			else
			{
				bUseRedirect = true;
			}

			//else continue, and put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");								
			
			AddJustDoneAction("created", sTitle);
		}									
		else if (sCmd.CompareText("edit"))
		{					
			//obtain parameters
			CMultiStep Multi(m_InputContext, "TOPIC");
			Multi.AddRequiredParam("title","",true);
			Multi.AddRequiredParam("text");
			Multi.AddRequiredParam("topicid");
			Multi.AddRequiredParam("editkey");

			if (!Multi.ProcessInput())
			{
				SetDNALastError("CTopicBuilder::Build","BuildFailed","Failed to process input");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());	
				return AddTopicListToPage();
			}

			if (Multi.ErrorReported())
			{
				SetDNALastError("CTopicBuilder::Build","BuildFailed","Mutil-step error reported");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}

			CTDVString sTitle;
			CTDVString sText; 
			CTDVString sEditKey;
			bool bGotParams = Multi.GetRequiredValue("title", sTitle);

			sText = "<GUIDE><BODY>";
			bGotParams = bGotParams && Multi.GetRequiredAsXML("TEXT", sText);
			bGotParams = bGotParams && Multi.GetAllElementsAsXML(sText);
			sText << "</BODY></GUIDE>";

			// BODGE!!! At this late stage this is the best we can do for now.
			// This will need replacing at some point! PLEASE!!!!
			sText.Replace("<TEXT>","");
			sText.Replace("</TEXT>","");

			bGotParams = bGotParams && Multi.GetRequiredValue("editkey", sEditKey);

			//if validation fails 
			if ( (bGotParams && Multi.ReadyToUse() ) == false)
			{	
				//Recreate Edit Page.		
				if ( !BuildEditPage() )
				{
					return AddTopicListToPage();
				}

				//Add error details to edit page.
				if ( Multi.ErrorReported() )
					SetDNALastError("CTopicBuilder::Build","Build",Multi.GetLastErrorAsXMLString());
				else
					SetDNALastError("CTopicBuilder::Build","Build","Bad Input parameters");
				return m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			}				

			//check that record was updated
			bool bEditKeyClash = false;
			if (!m_Topic.EditTopic(iTopicID, m_iSiteID,  pUser->GetUserID( ), sTitle, sText, CTopic::TS_PREVIEW, 1, sEditKey, bEditKeyClash))
			{	
				sCurrentPage = "editpage";
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
				
				CTDVString sXML;
				//sXML << "<TOPIC>";
				sXML << Multi.GetAsXML();
				//sXML << "</TOPIC>";
				m_pWholePage->AddInside("H2G2/TOPIC_PAGE", sXML);

				// get the error if creatioh fails
				m_pWholePage->AddInside("H2G2",m_Topic.GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}					
			else
			{
				bUseRedirect = true;
			}

			if ( bEditKeyClash )
			{
				sCurrentPage = "editpage";
				bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//				bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
				
				//refresh topic
				if (!m_Topic.GetTopicDetails(iTopicID))
				{	
					// get the error if this fails
					m_pWholePage->AddInside("H2G2",m_Topic.GetLastErrorAsXMLString());
					return AddTopicListToPage();
				}

				//now return xml
				m_pWholePage->AddInside("H2G2/TOPIC_PAGE", &m_Topic);											

				SetDNALastError("CTopic::EditTopic","EditedByAnotherEditor","Content was out of date, please try again");
				m_pWholePage->AddInside("H2G2", GetLastErrorAsXMLString());

				return AddTopicListToPage();
			}
		
			//else continue, and put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");					

			AddJustDoneAction("edited", sTitle);			
		}							
		else if (sCmd.CompareText("delete"))
		{						
			// Put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
			
			CTDVString sObject = "";
			m_Topic.GetTopicTitle(iTopicID, sObject);			
				
			//delete item
			if (!m_Topic.DeleteTopic(iTopicID))
			{
				// get the error from the topic object
				m_pWholePage->AddInside("H2G2", m_Topic.GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}
			else
			{
				bUseRedirect = true;
			}

			AddJustDoneAction("deleted", sObject);			
		}
		else if (sCmd.CompareText("unarchive"))
		{
			// We're wanting to unarchive a topic
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);

			CTDVString sObject = "";
			m_Topic.GetTopicTitle(iTopicID, sObject);			
				
			//delete item
			if (!m_Topic.UnArchiveTopic(iTopicID,pUser->GetUserID()))
			{
				// get the error from the topic object
				m_pWholePage->AddInside("H2G2", m_Topic.GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}
			else
			{
				bUseRedirect = true;
			}

			AddJustDoneAction("unarchive", sObject);
		}
		/*
		else if (sCmd.CompareText("move")== true)
		{					
			// Put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
	
			//get the value passed to the direction attribute
			if (m_InputContext.ParamExists("direction") == false)
			{
				SetDNALastError("CTopicBuilder::Build", "NoDirection", "Direction param is not specified");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return true;	
			}		
			int iDirection = m_InputContext.GetParamInt("direction");	
			
			//get the value passed to the editkey attribute
			if (m_InputContext.ParamExists("editkey") == false)
			{
				SetDNALastError("CTopicBuilder::Build", "NoEditKey", "editkey param is not specified");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return true;	
			}		
			CTDVString sEditKey = "";
			m_InputContext.GetParamString("editkey", sEditKey);	
			if (sEditKey.IsEmpty( ) )
			{
				SetDNALastError("CTopicBuilder::Build", "InvalidEditKey", "The EditKey parameter is invalid");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return true;	
			}

			bool bEditKeyClash;				
			if ( m_Topic.MoveTopicPositionally(iTopicID, iDirection, sEditKey, bEditKeyClash) == false)
			{
				// get the error from the topic object
				m_pWholePage->AddInside("H2G2", m_Topic.GetLastErrorAsXMLString());
				return true; 
			}					

			if ( bEditKeyClash ) 
			{
				SetDNALastError("CTopic::EditTopic","EditedByAnotherEditor","Content was out of date, please try again");
				m_pWholePage->AddInside("H2G2", GetLastErrorAsXMLString());
			}
			
			CTDVString sObject = "";
			m_Topic.GetTopicTitle(iTopicID, sObject);			
			AddJustDoneAction("moved", sObject);						
		}
		*/
		else if ( sCmd.CompareText("makeactive"))
		{
			// Put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
			
			CTDVString sObject = "";
			m_Topic.GetTopicTitle(iTopicID, sObject);			

			//make topic active
			if (!m_Topic.MakePreviewTopicActiveForSite(m_iSiteID, iTopicID, pUser->GetUserID()))
			{
				// get the error from the topic object
				m_pWholePage->AddInside("H2G2", m_Topic.GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}					
			else
			{
				bUseRedirect = true;
			}

			AddJustDoneAction("madeactive", sObject);						
		}
		else if (sCmd.IsEmpty())
		{
			// Put the CurrentPage into the XML
			bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//			bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
		}
		
		if ( bPageOk  && bUseRedirect )
		{
			//Call the redirect function
			if (CheckAndUseRedirectIfGiven(m_pWholePage))
			{
				// we've had a valid redirect! return
				return true;
			}
		}

		//return topic list
		return AddTopicListToPage();
	}		
	else if (sCurrentPage.CompareText("createpage"))
	{		
		// Put the CurrentPage into the XML
		bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");
		return true;
	}
	else if (sCurrentPage.CompareText("editpage"))
	{
		return BuildEditPage();
	}
	else if (sCurrentPage.CompareText("positionpage"))
	{
		// Put the CurrentPage into the XML
		bPageOk = bPageOk && m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE",sCurrentPage);
//		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");		

		//determine if a valid cmd param was passed in 
		CTDVString sCmd;
		m_InputContext.GetParamString("cmd",sCmd);

		CTDVString sAction;
		CTDVString sObject;
				
		if (sCmd.CompareText("move"))
		{			
			//get the iTopicID for the underlying item if any
			if (!m_InputContext.ParamExists("topicid"))
			{
				SetDNALastError("CTopicBuilder::Build", "NoTopicID", "Topic ID param is not specified");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}						
			int iTopicID = m_InputContext.GetParamInt("topicid");
			
			// Put the CurrentPage into the XML
			//bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");

			//get the value passed to the direction attribute
			if (!m_InputContext.ParamExists("direction"))
			{
				SetDNALastError("CTopicBuilder::Build", "NoDirection", "Direction param is not specified");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}		
			int iDirection = m_InputContext.GetParamInt("direction");	
			
			//get the value passed to the editkey attribute
			if (!m_InputContext.ParamExists("editkey"))
			{
				SetDNALastError("CTopicBuilder::Build", "NoEditKey", "editkey param is not specified");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}		

			CTDVString sEditKey;
			m_InputContext.GetParamString("editkey", sEditKey);	
			if (sEditKey.IsEmpty())
			{
				SetDNALastError("CTopicBuilder::Build", "InvalidEditKey", "The EditKey parameter is invalid");
				m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}

			bool bEditKeyClash;				
			if (!m_Topic.MoveTopicPositionally(iTopicID, iDirection, sEditKey, bEditKeyClash))
			{
				// get the error from the topic object
				m_pWholePage->AddInside("H2G2", m_Topic.GetLastErrorAsXMLString());
				return AddTopicListToPage();
			}					

			if ( bEditKeyClash ) 
			{
				SetDNALastError("CTopic::EditTopic","EditedByAnotherEditor","Content was out of date, please try again");
				m_pWholePage->AddInside("H2G2", GetLastErrorAsXMLString());
			}
			else
			{
				CTDVString sObject;
				m_Topic.GetTopicTitle(iTopicID, sObject);			
				AddJustDoneAction("moved", sObject);						
			}
		}

		//return topic list
		return AddTopicListToPage();
	}
	else
	{
		TDVASSERT(false, "Invalid condition");
		return true;
	}
}

/*********************************************************************************

	bool CTopicBuilder::BuildEditPage()

		Author:		Martinr
        Created:	26/08/2005
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	- Builds XML for the TOPICPAGE PAGE='editpage'

*********************************************************************************/
bool CTopicBuilder::BuildEditPage()
{
	// Put the CurrentPage into the XML
		bool bPageOk = m_pWholePage->SetAttribute("TOPIC_PAGE","PAGE","editpage");
//		bPageOk = bPageOk && m_pWholePage->AddInside("H2G2","<TOPIC_PAGE page='" + sCurrentPage + "'></TOPIC_PAGE>");		

		int iTopicID = 0;
		//get the iTopicID for the underlying item if any
		if (!m_InputContext.ParamExists("topicid"))
		{
			SetDNALastError("CTopicBuilder::Build", "NoTopicID", "Topic ID param is not specified");
			m_pWholePage->AddInside("H2G2",GetLastErrorAsXMLString());
			return AddTopicListToPage();
		}						

		iTopicID = m_InputContext.GetParamInt("topicid");
				
		//now edit
		if (!m_Topic.GetTopicDetails(iTopicID))
		{	
			// get the error if this fails
			m_pWholePage->AddInside("H2G2",m_Topic.GetLastErrorAsXMLString());
			return AddTopicListToPage();
		}

		CTDVString sTitle;
		CTDVString sText; 
		CTDVString sEditKey;
		m_Topic.GetTopicText(sText);

		// Create an instance of the multistep and seed it with the body text incase _msxml is not passed in!
		// The body text NEEDS <GUIDE> tags to work correctly, so use text here before we strip the tags off!
		CMultiStep Multi(m_InputContext, "TOPIC");
		Multi.SetMSXMLSeed(sText);

		sText.Replace("<GUIDE><BODY>","");
		sText.Replace("</BODY></GUIDE>","");

		m_Topic.GetTopicTitle(sTitle);
		m_Topic.GetTopicEditKey(sEditKey);

		Multi.AddRequiredParam("title",sTitle,true);
		Multi.AddRequiredParam("text",sText);
		Multi.AddRequiredParam("topicid",CTDVString(iTopicID));							
		Multi.AddRequiredParam("editkey",sEditKey);

		if (!Multi.ProcessInput())
		{
			TDVASSERT(false,"Failed to process multistep inputs!");
		}

		// Insert the MultiStep into the page
		CTDVString sXML;				
		sXML << Multi.GetAsXML();				
		m_pWholePage->AddInside("H2G2/TOPIC_PAGE", sXML);

		//now return xml
		m_pWholePage->AddInside("H2G2/TOPIC_PAGE", &m_Topic);											
		return true;
}

/*********************************************************************************

	bool CTopicBuilder::AddJustDoneAction ( CTDVString sAction, CTDVString sObject )

		Author:		David E
        Created:	15/12/2004
        Inputs:		-
        Outputs:	-
        Returns:	-
        Purpose:	-

*********************************************************************************/

bool CTopicBuilder::AddJustDoneAction ( CTDVString sAction, CTDVString sObject /*, bool bResult */)
{
	if ( sObject.IsEmpty( ) == false)
	{
		m_pWholePage->AddInside("H2G2/TOPIC_PAGE","<ACTION></ACTION>");
		m_pWholePage->AddInside("H2G2/TOPIC_PAGE/ACTION","<TYPE>" + sAction + "</TYPE>");
		m_pWholePage->AddInside("H2G2/TOPIC_PAGE/ACTION","<OBJECT>" + sObject + "</OBJECT>");
		//m_pWholePage->AddInside("H2G2/TOPIC_PAGE/ACTION","<RESULT> " + (bResult ? "OK" : "FALSE")  + "</RESULT>");
	}	
	return true;
}

/*********************************************************************************

	bool CTopicBuilder::AddTopicListToPage(void)

		Author:		Mark Howitt
        Created:	15/02/2005
        Inputs:		-
        Outputs:	-
        Returns:	true if added to the page ok, false if not
        Purpose:	Adds the topics list to the page

*********************************************************************************/
bool CTopicBuilder::AddTopicListToPage(void)
{
	// Get the topic object to get the list
	bool bOk = true;
	if (m_Topic.GetTopicsForSiteID(m_iSiteID, CTopic::TS_PREVIEW, true))
	{
		// Add the list to the page
		bOk = m_pWholePage->AddInside("H2G2/TOPIC_PAGE",&m_Topic);
	}
	else
	{
		// get the error from the topic object
		bOk = m_pWholePage->AddInside("H2G2",m_Topic.GetLastErrorAsXMLString());
	}
	return bOk;
}
