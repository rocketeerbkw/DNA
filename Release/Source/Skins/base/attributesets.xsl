<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">
	<xsl:attribute-set name="sendtoafriendlink">
		<xsl:attribute name="href"><xsl:value-of select="concat('/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk', $root, $referrer)"/></xsl:attribute>
		<xsl:attribute name="onClick">popmailwin('http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk<xsl:value-of select="$root"/><xsl:value-of select="$referrer"/>','Mailer')</xsl:attribute>
		<xsl:attribute name="target">Mailer</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="staf_link">
		<!--xsl:attribute name="class">bbcpageServices</xsl:attribute-->
	</xsl:attribute-set>
	<xsl:attribute-set name="nPeopleTalking" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="mENTRYLINK_UI" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="mUSERLINK_UI" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="mEXTERNALLINK_BBCSitesUI" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="mEXTERNALLINK_NONBBCSitesUI" use-attribute-sets="mainfont"/>
	<xsl:attribute-set name="ArticleText" use-attribute-sets="mainfont"/>
	<!-- Sets the colour of all text content on an article page (ie not links) -->
	<!-- #################### -->
	<!--      Search page links        -->
	<!-- #################### -->
	<xsl:attribute-set name="nSearchFormSubmitImage"/>
	<xsl:attribute-set name="mSUBJECT_articleresult" use-attribute-sets="searchpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_UserResult" use-attribute-sets="searchpagelinks"/>
	<xsl:attribute-set name="mSUBJECT_forumresult" use-attribute-sets="searchpagelinks"/>
	<xsl:attribute-set name="mH2G2ID_link" use-attribute-sets="searchpagelinks"/>
	<!-- the following 2 dont follow naming convention due to no mode being put on the template -->
	<xsl:attribute-set name="SearchMoreLinkAttr" use-attribute-sets="searchpagelinks"/>
	<xsl:attribute-set name="SearchSkipLinkAttr" use-attribute-sets="searchpagelinks"/>	
	<xsl:attribute-set name="nalphaindex" use-attribute-sets="searchpagelinks"/>
	<!-- #################### -->
	<!--        General Furniture       -->
	<!-- #################### -->
	<xsl:attribute-set name="nm_welcomebackuser" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_welcomebackuser2line" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_lifelink" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_universelink" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_everythinglink" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_searchlink" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_copyright2" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_pagebottomcomplaint1" use-attribute-sets="furniturelinks"/>
	<xsl:attribute-set name="nm_pagebottomcomplaint2" use-attribute-sets="furniturelinks"/>
	<!-- #################### -->
	<!--             GuideML          -->
	<!-- #################### -->
	<xsl:attribute-set name="mA" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="maForumID_AddThread" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="mPOPUPCONVERSATIONS" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="mSUGLINK" use-attribute-sets="guidemllinks"/>
	<!-- text sets -->
	<!-- These are the GuideML Section on a User Page:  -->
	<xsl:attribute-set name="nm_pserrorowner" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagehidden1" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagehidden2" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagereferred" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagereferred2" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagependingpremoderation1" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagependingpremoderation2" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_legacyuserpageawaitingmoderation" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_userpagereferred1" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_psintroowner" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="mLINK" use-attribute-sets="guidemllinks"/>
	<!-- End of User Page section -->
	<xsl:attribute-set name="nm_registertodiscuss" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_articlehiddentext1" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_articlehiddentext2" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_articlereferredtext1" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_articlereferredtext2" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_articleawaitingpremoderationtext1" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_articleawaitingpremoderationtext2" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_legacyarticleawaitingmoderationtext" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_home_lue" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="nm_home_regdetails" use-attribute-sets="guidemllinks"/>
	<!-- #################### -->
	<!--            Journal Links            -->
	<!-- #################### -->
	<xsl:attribute-set name="mJOURNALPOSTS_clickformorejournals" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="ncreatenewjournalentry" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="maTHREADID_linktothread" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="maTHREADID_linktolatest" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="mJOURNALPOSTS_MoreJournal" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="nClickAddJournal" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="maPOSTID_DiscussJournalEntry" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="maTHREADID_JournalEntryReplies" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="maTHREADID_JournalLastReply" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="maTHREADID_JournalRemovePost" use-attribute-sets="journallinks">
		<xsl:attribute name="target">_top</xsl:attribute>
	</xsl:attribute-set>
	<!-- Text links -->
	<xsl:attribute-set name="nm_journalownerfull" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="nm_journalownerempty" use-attribute-sets="journallinks"/>
	<!-- #################### -->
	<!--      Recent-Posts Links     -->
	<!-- #################### -->
	<xsl:attribute-set name="mUSERID_MorePosts" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mPOST-LIST_MorePosts" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mDATE_LatestPost" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mDATE_LastUserPost" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mUSERID_MorePostsOtherSite" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mUSERID_MorePostsThisSite" use-attribute-sets="recentpostslinks"/>
	<!-- Text sets -->
	<xsl:attribute-set name="npostunsubscribe1" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="npostunsubscribe2" use-attribute-sets="recentpostslinks"/>
	<!-- #################### -->
	<!--      MOREPOSTS Links    -->
	<!-- #################### -->
	<xsl:attribute-set name="maUSERID_NewerPostings" use-attribute-sets="morepostslinks"/>
	<xsl:attribute-set name="maUSERID_OlderPostings" use-attribute-sets="morepostslinks"/>
	<xsl:attribute-set name="maPOSTS_ToPSpaceFromMP" use-attribute-sets="morepostslinks"/>
	<!-- #################### -->
	<!--      Recent-Entries Links    -->
	<!-- #################### -->
	<xsl:attribute-set name="mH2G2-ID_recententries" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="mH2G2-ID_UserEdit" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="mH2G2-ID_UserEditUndelete" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="mUSERID_clickformore" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="ncreatenewentry" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="mUSERID_MoreArticlesOtherSite" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="mUSERID_MoreArticlesThisSite" use-attribute-sets="recententrieslinks"/>

	<!-- text links -->
	<xsl:attribute-set name="nm_artownerempty" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="nm_artownerfull" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="nm_artownerempty" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="nm_editownerfull" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="nm_editownerempty" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="nm_editviewerfull" use-attribute-sets="recententrieslinks"/>
	<!-- #################### -->
	<!--      Userpage Article Forum Links     -->
	<!-- #################### -->
	<xsl:attribute-set name="maFORUMID_MoreConv" use-attribute-sets="userarticleforumlinks"/>
	<xsl:attribute-set name="maTHREADID_LinkOnSubject" use-attribute-sets="userarticleforumlinks"/>
	<xsl:attribute-set name="maTHREADID_LinkOnDatePosted" use-attribute-sets="userarticleforumlinks"/>
	<xsl:attribute-set name="maTHREADID_LinkOnSubjectAB" use-attribute-sets="userarticleforumlinks"/>

	
	<!-- #################### -->
	<!-- Conversation details' links    -->
	<!-- #################### -->
	<xsl:attribute-set name="mUSERNAME_multiposts" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maNEXTINDEX_multiposts1" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maNEXTINDEX_multiposts2" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maPREVINDEX_multiposts1" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maPREVINDEX_multiposts2" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maINREPLYTO_multiposts1" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maINREPLYTO_multiposts2" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maFIRSTCHILD_multiposts1" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maFIRSTCHILD_multiposts2" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maHIDDEN_multiposts" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maPOSTID_editpost" use-attribute-sets="convdetailslinks"/>
	<xsl:attribute-set name="maPOSTID_moderation" use-attribute-sets="convdetailslinks"/>
	<!-- #################### -->
	<!--      Thread content   -->
	<!-- #################### -->
	<xsl:attribute-set name="maPOSTID_ReplyToPost" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="mFORUMSOURCEARTICLE" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="mFORUMSOURCEJOURNAL" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="mFORUMSOURCEUSERPAGE" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="mFORUMSOURCEREVIEWFORUM" use-attribute-sets="convcontentlinks"/>
	<!-- Text sets -->
	<xsl:attribute-set name="nm_postawaitingmoderation" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="nm_postawaitingpremoderation" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="nm_postremoved" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="nm_posthasbeenpremoderated1" use-attribute-sets="convcontentlinks"/>
	<xsl:attribute-set name="nm_posthasbeenpremoderated2" use-attribute-sets="convcontentlinks"/>
	<!-- #################### -->
	<!--              Sidebars             -->
	<!-- #################### -->
	<xsl:attribute-set name="nLinkToUserDetails" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="maVISIBLE_EditEntry" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="nUserEditMasthead" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="mUSERID_Inspect" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="mH2G2ID_RemoveSelf" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="mEXTERNALLINK_justlink" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="mENTRYLINK_JustLink" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="nforumpostblocks" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="as_skiptobeginning" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="as_skiptoprevious" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="as_skiptonext" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="as_skiptoend" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="maFORUMID_returntothreads" use-attribute-sets="sidebarlinks"/> 
	<xsl:attribute-set name="maFORUMID_FirstToTalk" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="maFORUMID_subscribearticleforum" use-attribute-sets="sidebarlinks"/>
	<!-- Text sets -->
	<xsl:attribute-set name="nm_registerslug" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="nm_entrysidebarcomplaint1" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="nm_entrysidebarcomplaint2" use-attribute-sets="sidebarlinks"/>
	<xsl:attribute-set name="nm_forumpostingsdisclaimer" use-attribute-sets="sidebarlinks"/>
	<!-- #################### -->
	<!--                Useredit             -->
	<!-- #################### -->
	
	<!-- Text files -->	
	<xsl:attribute-set name="nm_recommendtext" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_usereditwarning" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_usereditpagehouserulesdisclaimer" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_unregistereduserediterror1" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_unregistereduserediterror2" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_unregistereduserediterror3" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_inreviewtextandlink1" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_inreviewtextandlink2" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_notforreview_explanation" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_guideentrydeleted" use-attribute-sets="usereditlinks"/>
	<xsl:attribute-set name="nm_guideentryrestored3" use-attribute-sets="usereditlinks"/>
	<!-- #################### -->
	<!--                Add thread        -->
	<!-- #################### -->
	<xsl:attribute-set name="nm_cantpostnotregistered1" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="nm_cantpostnotregistered2" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="nm_cantpostnotregistered3" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="nm_cantpostnotregistered4" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="nm_cantpostnoterms1" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="nm_cantpostnoterms2" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="nm_cantpostnoterms3" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="maFORUMID_ReturnToConv" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="maFORUMID_ReturnToConv1" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="mUSERID_UserName" use-attribute-sets="addthreadlinks">
		<xsl:attribute name="TARGET">_top</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSERID_UserName_Name" use-attribute-sets="forumposted"/>
	<xsl:attribute-set name="mRETURNTOH2G2ID" use-attribute-sets="addthreadlinks"/>
	<xsl:attribute-set name="mPOSTTHREADFORM_Subj" use-attribute-sets="mainfont">
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject">
		<xsl:attribute name="NAME">subject</xsl:attribute>
		<xsl:attribute name="type">text</xsl:attribute>
	</xsl:attribute-set>
	<!-- #################### -->
	<!--   Registration process      -->
	<!-- #################### -->
	<xsl:attribute-set name="nm_regwaittransfer" use-attribute-sets="regprocesslinks"/>
	<xsl:attribute-set name="nm_regconfirmation" use-attribute-sets="regprocesslinks"/>
	<xsl:attribute-set name="nm_regwaitwelcomepage" use-attribute-sets="regprocesslinks"/>
	<!-- #################### -->
	<!--         Register/Login          -->
	<!-- #################### -->
	<xsl:attribute-set name="mREGISTER-PASSTHROUGH_completed" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="vm_noconnection" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_regalready1" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_regalready2" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_registrationblurb" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_loginblurb" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_passwordintro" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_notcancelled" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_abouttocancelaccount" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_sorryrejectedterms" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_returninguserblurb1" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_returninguserblurb2" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_returninguserblurb3" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_returninguserblurb4" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_bbcregblurb1" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_bbcregblurb2" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_bbcregblurb3" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_bbcloginblurb" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_agreetoterms1" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_agreetoterms2" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_login_noaccnt" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="nm_login_accnt" use-attribute-sets="regloginlinks"/>
	<xsl:attribute-set name="mNEWREGISTER_error_font">
		<xsl:attribute name="color">red</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_InputLoginName" use-attribute-sets="iNEWREGISTER_LoginName">
		<xsl:attribute name="VALUE"><xsl:value-of select="/H2G2/NEWREGISTER/LOGINNAME"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Email" use-attribute-sets="iNEWREGISTER_Email_Base">
		<xsl:attribute name="VALUE"><xsl:value-of select="/H2G2/NEWREGISTER/EMAIL"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Remember" use-attribute-sets="iNEWREGISTER_Remember_Base">
		<xsl:attribute name="VALUE">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Terms" use-attribute-sets="iNEWREGISTER_Terms_Base">
		<xsl:attribute name="VALUE">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="as_m_noconnectionerror"/>
	<!-- #################### -->
	<!--        Share and Enjoy       -->
	<!-- #################### -->
	<xsl:attribute-set name="nm_sharealreadyjoined" use-attribute-sets="shareandenjoylinks"/>
	<xsl:attribute-set name="nm_shareunregistered" use-attribute-sets="shareandenjoylinks"/>
	<xsl:attribute-set name="nm_sharesuccess" use-attribute-sets="shareandenjoylinks"/>
	<!-- #################### -->
	<!--        Review Forum           -->
	<!-- #################### -->
	<xsl:attribute-set name="nm_submitarticlelast_text" use-attribute-sets="reviewforumlinks"/>
	<xsl:attribute-set name="nm_removefromreviewsuccesslink1" use-attribute-sets="reviewforumlinks"/>
	<xsl:attribute-set name="nm_removefromreviewsuccesslink2" use-attribute-sets="reviewforumlinks"/>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum1" use-attribute-sets="reviewforumlinks"/>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum2" use-attribute-sets="reviewforumlinks"/>
	<xsl:attribute-set name="nm_entrysubmittedtoreviewforum3" use-attribute-sets="reviewforumlinks"/>
	<!-- #################### -->
	<!--        Review Forum           -->
	<!-- #################### -->
	<xsl:attribute-set name="mTOP-FIVE-ARTICLE_generic" use-attribute-sets="topfiveslinks"/>
	<xsl:attribute-set name="mTOP-FIVE-FORUM_generic" use-attribute-sets="topfiveslinks"/>
	<!-- #################### -->
	<!--		INDEX		  -->
	<!-- #################### -->
	<xsl:attribute-set name="mH2G2ID_indexentry" use-attribute-sets="indexlinks"/>
	<xsl:attribute-set name="maSKIP_previndexlink" use-attribute-sets="indexlinks"/>
	<xsl:attribute-set name="maSKIP_nextindexlink" use-attribute-sets="indexlinks"/>
	<!-- #################### -->
	<!--		SIMPLEPAGE	       -->
	<!-- #################### -->
	<xsl:attribute-set name="mRETURN-TO" use-attribute-sets="simplepagelinks"/>
	<xsl:attribute-set name="nm_guideentryrestored1" use-attribute-sets="simplepagelinks"/>
	<xsl:attribute-set name="nm_guideentryrestored2" use-attribute-sets="simplepagelinks"/>
	<xsl:attribute-set name="nm_nameremovedfromresearchers" use-attribute-sets="simplepagelinks"/>
	<xsl:attribute-set name="nm_namenotremovedfromresearchers" use-attribute-sets="simplepagelinks"/>
	<xsl:attribute-set name="nm_notfoundbody1" use-attribute-sets="simplepagelinks"/>
	<xsl:attribute-set name="nm_notfoundbody2" use-attribute-sets="simplepagelinks"/>
	<!-- #################### -->
	<!--        Miscellaneous           -->
	<!-- #################### -->
	<xsl:attribute-set name="nm_ptwriteguideentry" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="nm_complaintpopupseriousnessproviso" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="nm_changepasswordexternal" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="nm_sitechangemessage" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="mDATE_MorePosts" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="nm_textonlylink" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="nm_mailtofriend" use-attribute-sets="linkatt"/>
	<!-- ############################### -->
	<!-- ############################## -->
	<!-- Attribute sets for 'logical containers' -->
	<!-- ############################### -->
	<!-- ############################## -->
	<xsl:attribute-set name="furniturelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="guidemllinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="convcontentlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="sidebarlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="usereditlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="addthreadlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="regprocesslinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="regloginlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="shareandenjoylinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="reviewforumlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="searchpagelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="simplepagelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="convdetailslinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="journallinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="recentpostslinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="userarticleforumlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="recententrieslinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="topfiveslinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="userdetailseditlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="indexlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="convlistlinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="morepostslinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="MoreArticles" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="WatchedUsers" use-attribute-sets="linkatt"/>

	<!-- Following is present for uploading purposes -->
	<xsl:attribute-set name="userpagelinks"/>
		
	
	<!-- #################################### -->
	<!-- Secure Attribute sets for Register/Login page -->
	<xsl:attribute-set name="fNEWREGISTER">
		<xsl:attribute name="method">post</xsl:attribute>
		<xsl:attribute name="action"><xsl:value-of select="$bbcregscript"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_LoginName">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="name">loginname</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Password">
		<xsl:attribute name="type">password</xsl:attribute>
		<xsl:attribute name="name">password</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Password2">
		<xsl:attribute name="type">password</xsl:attribute>
		<xsl:attribute name="name">password2</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Email_Base">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="name">email</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Remember_Base">
		<xsl:attribute name="type">checkbox</xsl:attribute>
		<xsl:attribute name="name">remember</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Terms_Base">
		<xsl:attribute name="type">checkbox</xsl:attribute>
		<xsl:attribute name="name">terms</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Register">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_newregisterbutton"/></xsl:attribute>
		<xsl:attribute name="name">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNEWREGISTER_Login">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_newloginbutton"/></xsl:attribute>
		<xsl:attribute name="name">submit</xsl:attribute>
	</xsl:attribute-set>

	<!-- #################### -->
	<!--        Post to Journal -->
	<!-- #################### -->
	<xsl:attribute-set name="asiPOSTJOURNALFORM_PreviewBtn">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">preview</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_previewjournal"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiPOSTJOURNALFORM_StoreBtn">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">post</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_storejournal"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="astaPOSTJOURNALFORM_Body">
		<xsl:attribute name="cols">70</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
		<xsl:attribute name="wrap">VIRTUAL</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiPOSTJOURNALFORM_Subject"/>

	<xsl:attribute-set name="asfPOSTJOURNALFORM">
		<xsl:attribute name="name">theForm</xsl:attribute>
		<xsl:attribute name="method">POST</xsl:attribute>
		<xsl:attribute name="action"><xsl:value-of select="$root"/>PostJournal</xsl:attribute>
	</xsl:attribute-set>

	<!-- #################### -->
	<!--        User Details Edit Form	-->
	<!-- #################### -->
	<xsl:attribute-set name="asfUSER-DETAILS-FORM">
		<xsl:attribute name="method">post</xsl:attribute>
		<xsl:attribute name="action"><xsl:value-of select="$root"/>UserDetails</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiUSER-DETAILS-FORM_UserNameInput">
		<xsl:attribute name="type">text</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiUSER-DETAILS-FORM_Email">
		<xsl:attribute name="type">text</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asftUSER-DETAILS-FORM_SkinList" use-attribute-sets="mainfont"/>

	<xsl:attribute-set name="asftUSER-DETAILS-FORM_PrefForumStyle" use-attribute-sets="mainfont"/>

	<xsl:attribute-set name="mUSERID_USER-DETAILS-FORM" use-attribute-sets="userdetailseditlinks"/>
	<xsl:attribute-set name="nm_changepasswordmessage" use-attribute-sets="userdetailseditlinks"/>

	<xsl:attribute-set name="asiUSER-DETAILS-FORM_Submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_updatedetails"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiUSER-DETAILS-FORM_NewPasswordConf">
		<xsl:attribute name="name">PasswordConfirm</xsl:attribute>
		<xsl:attribute name="type">password</xsl:attribute>
		<xsl:attribute name="value"></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiUSER-DETAILS-FORM_NewPassword">
		<xsl:attribute name="name">NewPassword</xsl:attribute>
		<xsl:attribute name="type">password</xsl:attribute>
		<xsl:attribute name="value"></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asiUSER-DETAILS-FORM_Password">
		<xsl:attribute name="name">Password</xsl:attribute>
		<xsl:attribute name="type">password</xsl:attribute>
		<xsl:attribute name="value"></xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="asftUSER-DETAILS-FORM_PrefMode" use-attribute-sets="mainfont"/>

	<!-- #################### -->
	<!--        THREADS_MAINBODY	-->
	<!-- #################### -->
	<xsl:attribute-set name="mFORUMTHREADS_Unsubscribe" use-attribute-sets="convlistlinks">
		<xsl:attribute name="target">_top</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="mFORUMTHREADS_Subscribe" use-attribute-sets="convlistlinks">
		<xsl:attribute name="target">_top</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="maFORUMID_THREADS_MAINBODY" use-attribute-sets="convlistlinks">
		<xsl:attribute name="target">_top</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="maTHREADID_movethreadgadget" use-attribute-sets="convlistlinks"/>

	<xsl:attribute-set name="maTHREADID_THREADS_MAINBODY" use-attribute-sets="convlistlinks"/>

	<xsl:attribute-set name="maTHREADID_THREADS_MAINBODY_Date" use-attribute-sets="convlistlinks"/>

	<!-- #################### -->
	<!--        FOOTNOTES	-->
	<!-- #################### -->
	<xsl:attribute-set name="mFOOTNOTE" use-attribute-sets="linkatt"/>

	<xsl:attribute-set name="asfINDEX_FOOTNOTE" use-attribute-sets="mainfont"/>

	<xsl:attribute-set name="asfFOOTNOTE_BottomText" use-attribute-sets="mainfont"/>

	<xsl:attribute-set name="mFOOTNOTE_display" use-attribute-sets="linkatt"/>

	<!-- #################### -->
	<!--        More Articles	-->
	<!-- #################### -->
	<xsl:attribute-set name="maUSERID_ShowEditedEntries" use-attribute-sets="MoreArticles"/>

	<xsl:attribute-set name="maUSERID_ShowGuideEntries" use-attribute-sets="MoreArticles"/>

	<xsl:attribute-set name="maUSERID_ShowCancelledEntries" use-attribute-sets="MoreArticles"/>

	<xsl:attribute-set name="maUSERID_FromMAToPS" use-attribute-sets="MoreArticles"/>

	<xsl:attribute-set name="maUSERID_OlderEntries" use-attribute-sets="MoreArticles"/>

	<xsl:attribute-set name="maUSERID_NewerEntries" use-attribute-sets="MoreArticles"/>

	<!-- #################### -->
	<!--        Watched Users -->
	<!-- #################### -->
	<xsl:attribute-set name="maUSERID_WatchUserBigDelete" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mUSERID_WatchUserPS" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mUSER_WatchUserJournal" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mUSERID_WatchUserDelete" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mUSER_WatchUserPosted" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mUSER_WatchUserPosted" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mWATCH-USER-POSTS_Previous" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mWATCH-USER-POSTS_Next" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mWATCH-USER-POSTS_Back" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mWATCH-USER-POSTS_Replies" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mWATCH-USER-POSTS_LastReply" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="mWATCHED-USER-LIST_FullList" use-attribute-sets="WatchedUsers"/>
	<xsl:attribute-set name="NextPreviousThread"/>
	<xsl:attribute-set name="mTHREAD_PreviousThread" use-attribute-sets="NextPreviousThread"/>
	<xsl:attribute-set name="mTHREAD_NextThread" use-attribute-sets="NextPreviousThread"/>

</xsl:stylesheet>
