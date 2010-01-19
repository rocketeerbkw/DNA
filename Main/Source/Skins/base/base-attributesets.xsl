<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--============================Pan DNA====================================-->
	<xsl:attribute-set name="linkatt"/>
	<xsl:attribute-set name="mUSER_default" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="forumposted"/>
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="face">arial,helvetica,sans-serif</xsl:attribute>
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	<!--============================Pan DNA====================================-->
	<!--============================ADDTHREADPAGE====================================-->
	<xsl:attribute-set name="mPOSTTHREADFORM_t_returntoconversation" use-attribute-sets="addthreadlinks"/>
	<!--============================ADDTHREADPAGE====================================-->
	<!--============================ARTICLEPAGE====================================-->
	<xsl:attribute-set name="mFOOTNOTE_object_articlefootnote" use-attribute-sets="guidemllinks"/>
	<xsl:attribute-set name="maFORUMID_t_addthread" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="maFORUMID_empty_article" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLEFORUM_r_viewallthreads" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_threadtitlelink" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_threaddatepostedlink" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLE_r_editbutton" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mH2G2ID_r_removeself" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mH2G2ID_r_recommendentry" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="nDISPLAY-RECOMMENDENTRY" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mSUBMITTABLE_r_submit-to-peer-review" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mEXTERNALLINK_r_bbcrefs" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mEXTERNALLINK_r_nonbbcrefs" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mENTRYLINK_r_articlerefs" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mUSERLINK_r_articlerefs" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="maVISIBLE_r_returntoeditors" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mUSER_r_researcherlist" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mUSER_r_articleeditor" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mH2G2ID_r_categoriselink" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLE_r_subscribearticleforum" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLE_r_unsubscribearticleforum" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLE_r_clip" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mANCESTOR_r_article" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLE_add_tag" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLE_edit_tag" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mARTICLEMEMBER_r_relatedarticlesAP" use-attribute-sets="articlepagelinks"/>
	<xsl:attribute-set name="mCLUBMEMBER_r_relatedclubsAP" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="articlepagelinks" use-attribute-sets="linkatt"/>
	<!--============================ARTICLEPAGE====================================-->
	<!--============================CATEGORYPAGE============================-->
	<xsl:attribute-set name="mNAME_t_nodename" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mSUBNODE_r_subnodename" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_articlename" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mNODEALIASMEMBER_r_category" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_nodealiasname" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_clubname" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mANCESTOR_r_category" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mSUBJECTMEMBER_r_issue" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_clubname" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mARTICLEMEMBER_r_issue" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mANCESTOR_r_issue" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mSUBNODE_r_nodealias" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mHIERARCHYDETAILS_r_clip" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="mHIERARCHYDETAILS_r_clipissue" use-attribute-sets="categorypagelinks"/>
	<xsl:attribute-set name="categorypagelinks" use-attribute-sets="linkatt"/>
	<!--============================CATEGORYPAGE============================-->
	<!--============================CLUBPAGE====================================-->
	<xsl:attribute-set name="mUSER_r_clubowners" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_r_clubmembers" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_r_promotetoowne" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mPOPULATION_r_editpermissions" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mPOPULATION_r_managerequests" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_r_promotetoowner" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_clubthreadtitlelink" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_clubthreaddatepostedlink" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mFORUMTHREADS_empty_club" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="vm_clubunregisteredmessage" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mJOURNALPOSTS_r_moreclubjournals" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mJOURNALPOSTS_r_addclubjournalentry" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_clubjournallastreply" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maTHREADID_r_removeclubjournalpost" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maPOSTID_t_discussclubjournalentry" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_clubjournalentriesreplies" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="maPOSTID_r_editpost" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_t_addclubcomment" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_t_clubcommentauthor" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mPOPULATION_r_editmembership" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBINFO_r_becomeowner" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_t_membershipname" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_r_editmember" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUB_r_clip" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mRESPONSE1_t_select" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mRESPONSE2_t_select" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="clubpagelinks" use-attribute-sets="linkatt"/>
	<!--============================CLUBPAGE====================================-->
	<!--============================EDITCATEGORYPAGE============================-->
	<xsl:attribute-set name="mEDITCATEGORY_r_renamesubject" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mDESCRIPTION_t_editcat" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mANCESTOR_r_editcat" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mEDITCATEGORY_t_addsubject" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mEDITCATEGORY_r_storenode" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mEDITCATEGORY_r_storelink" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mHIERARCHYDETAILS_c_addarticlepermission" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_clubname_ec" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_nodealiasname_ec" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mARTICLEMEMBER_r_movearticle" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mARTICLEMEMBER_r_deletearticle" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mARTICLEMEMBER_r_editcat" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mSUBJECTMEMBER_r_movesubject" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mNAME_t_nodename_ec" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mSUBNODE_r_subnodename_ec" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mSUBJECTMEMBER_r_deletesubject" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mCLUBMEMBER_r_moveclub" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mCLUBMEMBER_r_deleteclub" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mNODEALIASMEMBER_r_movesubjectlink" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="mNODEALIASMEMBER_r_deletesubjectlink" use-attribute-sets="editcategorypagelinks"/>
	<xsl:attribute-set name="editcategorypagelinks" use-attribute-sets="linkatt"/>
	<!--============================EDITCATEGORYPAGE============================-->
	<!-- ========================== EDIT MEMBERSHIP PAGE ==========================-->
	<xsl:attribute-set name="mH2G2ID_r_linktoarticle" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mPOPULATION_t_privatemessagemembers" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBINFO_r_joinclub" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mPOST_r_complainclubjournal" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mPOPULATION_r_editmembershiplink" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBACTIONLIST_t_returntoclub" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mACTIONUSER_t_nameofrequestor" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mACTIONUSER_t_nameofrequested" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBNAME_t_request" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBACTION_t_accept" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBACTION_t_reject" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCOMPLETEUSER_r_authoriser" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mACTIONUSER_t_inviteduser" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_t_name" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mMEMBER_t_editmembername" use-attribute-sets="clubpagelinks"/>
	<!-- ========================== EDIT MEMBERSHIP PAGE ==========================-->
	<!--============================FRONTPAGE====================================-->
	<xsl:attribute-set name="mTOP-FIVE-ARTICLE" use-attribute-sets="frontpagelinks"/>
	<xsl:attribute-set name="mTOP-FIVE-FORUM" use-attribute-sets="frontpagelinks"/>
	<xsl:attribute-set name="frontpagelinks" use-attribute-sets="linkatt"/>
	<!--============================FRONTPAGE====================================-->
	<!--============================INDEXPAGE====================================-->
	<xsl:attribute-set name="mSUBJECT_t_index" use-attribute-sets="indexpage"/>
	<xsl:attribute-set name="indexpage" use-attribute-sets="linkatt"/>
	<!--============================INDEXPAGE====================================-->
	<!--============================INFOPAGE====================================-->
	<xsl:attribute-set name="mUSER_t_info" use-attribute-sets="infopage"/>
	<xsl:attribute-set name="mRECENTCONVERSATION_t_info" use-attribute-sets="infopage"/>
	<xsl:attribute-set name="mRECENTARTICLE_t_info" use-attribute-sets="infopage"/>
	<xsl:attribute-set name="infopage" use-attribute-sets="linkatt"/>
	<!--============================INFOPAGE====================================-->
	<!--============================JOURNALPAGE====================================-->
	<xsl:attribute-set name="mLASTREPLYDATE_t_journalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="mCOUNT_t_journalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="mPOSTID_t_discusslinkjournalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="mTHREADID_r_removelinkjournalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="mJOURNAL_r_prevjournalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="mJOURNAL_r_nextjournalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="mJOURNAL_t_userpagelinkjournalpage" use-attribute-sets="journalpage"/>
	<xsl:attribute-set name="journalpage" use-attribute-sets="linkatt"/>
	<!--============================JOURNALPAGE====================================-->
	<!--============================MISCPAGE====================================-->
	<xsl:attribute-set name="mRETURN-TO_t_subscribepage" use-attribute-sets="miscpage"/>
	<xsl:attribute-set name="miscpage" use-attribute-sets="linkatt"/>
	<!--============================MISCPAGE====================================-->
	<!--============================MONTHPAGE====================================-->
	<xsl:attribute-set name="mSUBJECT_r_month" use-attribute-sets="monthpage"/>
	<xsl:attribute-set name="monthpage" use-attribute-sets="linkatt"/>
	<!--============================MONTHPAGE====================================-->
	<!--============================MOREARTICLESPAGE====================================-->
	<xsl:attribute-set name="mH2G2-ID_t_morearticlespage" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mSUBJECT_t_morearticlespage" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mSITEID_t_morearticlespage" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mARTICLES_r_previouspages" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mARTICLES_r_morepages" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mARTICLES_t_backtouserpage" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mARTICLES_t_showeditedlink" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mARTICLES_t_shownoneditedlink" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="mARTICLES_r_showcancelledlink" use-attribute-sets="morearticlespage"/>
	<xsl:attribute-set name="morearticlespage" use-attribute-sets="linkatt"/>
	<!--============================MOREARTICLESPAGE====================================-->
	<!--============================MOREPOSTSPAGE====================================-->
	<xsl:attribute-set name="mTHREADID_t_morepostssubject" use-attribute-sets="morepostspage"/>
  <xsl:attribute-set name="mPOSTS_morepostsPSlink" use-attribute-sets="morepostspage"/>
  <xsl:attribute-set name="mPOSTS_moderateuserlink" use-attribute-sets="morepostspage"/>
  <xsl:attribute-set name="morepostspage" use-attribute-sets="linkatt"/>
	<!--============================MOREPOSTSPAGE====================================-->
	<!--============================MULTIPOSTSPAGE====================================-->
	<xsl:attribute-set name="maPREVINDEX_r_clubpost" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maPREVINDEX_r_multiposts" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maNEXTINDEX_r_multiposts" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_multiposts" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maPOSTID_r_replytopost" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_clubpost" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maINREPLYTO_r_clubpost" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maFIRSTCHILD_r_multiposts" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maHIDDEN_r_complainmp" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_subcribemultiposts" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_gotobeginning" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_gotoprevious" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_gotonext" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_gotolatest" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_t_allthreads" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maPOSTID_r_editpost" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mFORUMSOURCE_privateuser_forumsource" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_c_allthreads"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_c_postblock"/>
	<xsl:attribute-set name="maPOSTID_r_failmessagelink" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="multipostspagelinks" use-attribute-sets="linkatt"/>
	<!--============================MULTIPOSTSPAGE====================================-->
	<!--============================MYCONVERSATIONSPOPUP============================-->
	<xsl:attribute-set name="mDATE_t_myconversations" use-attribute-sets="myconversationspopup"/>
	<xsl:attribute-set name="mPOST-LIST_t_myconversations" use-attribute-sets="myconversationspopup"/>
	<xsl:attribute-set name="maTHREADID_t_subject" use-attribute-sets="myconversationspopup"/>
	<xsl:attribute-set name="mPOST_t_lastuserpost" use-attribute-sets="myconversationspopup"/>
	<xsl:attribute-set name="mPOST_t_lastreply" use-attribute-sets="myconversationspopup"/>
	<xsl:attribute-set name="myconversationspopup" use-attribute-sets="linkatt"/>
	<!--============================MYCONVERSATIONSPOPUP============================-->
	<!--============================NEWUSERSPAGE====================================-->
	<xsl:attribute-set name="mUSERNAME_t_newusers" use-attribute-sets="newuserspage"/>
	<xsl:attribute-set name="newuserspage" use-attribute-sets="linkatt"/>
	<!--============================NEWUSERSPAGE====================================-->
	<!-- ========================== NOTICEBOARD PAGE ==========================-->
	<xsl:attribute-set name="noticeboardpagelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="mNOTICEVOTES_r_notice" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_notice" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_event" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_wanted" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_offer" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mPOSTID_r_complain" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mEVENT_r_eventsboard" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mNOTICEBOARD_t_returntonoticeboard" use-attribute-sets="noticeboardpagelinks"/>
	<!-- ========================== NOTICEBOARD PAGE ==========================-->
	<!--============================ONLINEPOPUP====================================-->
	<xsl:attribute-set name="mONLINEUSER_r_online" use-attribute-sets="onlinepopup"/>
	<xsl:attribute-set name="onlinepopup"/>
	<!--============================ONLINEPOPUP====================================-->
	<!--============================REVIEWFORUMPAGE============================-->
	<xsl:attribute-set name="mFOOTNOTE_object_reviewforum"/>
	<xsl:attribute-set name="mREVIEWFORUMTHREADS_c_postblock" use-attribute-sets="reviewforumpage"/>
	<xsl:attribute-set name="mREVIEWFORUMTHREADS_link_firstpage" use-attribute-sets="reviewforumpage"/>
	<xsl:attribute-set name="mREVIEWFORUMTHREADS_link_lastpage" use-attribute-sets="reviewforumpage"/>
	<xsl:attribute-set name="mREVIEWFORUMTHREADS_link_previouspage" use-attribute-sets="reviewforumpage"/>
	<xsl:attribute-set name="mREVIEWFORUMTHREADS_link_nextpage" use-attribute-sets="reviewforumpage"/>
	<xsl:attribute-set name="reviewforumpage" use-attribute-sets="linkatt"/>
	<!--============================REVIEWFORUMPAGE============================-->
	<!--============================SUBMITREVIEWFORUMPAGE============================-->
	<xsl:attribute-set name="mERROR_t_badh2g2idlink" use-attribute-sets="submitreviewforumpage"/>
	<xsl:attribute-set name="mERROR_t_badrfidlink" use-attribute-sets="submitreviewforumpage"/>
	<xsl:attribute-set name="mERROR_t_defaultlink" use-attribute-sets="submitreviewforumpage"/>
	<xsl:attribute-set name="submitreviewforumpage" use-attribute-sets="linkatt"/>
	<!--============================SUBMITREVIEWFORUMPAGE============================-->
	<!--============================TEAMLISTPAGE============================-->
	<xsl:attribute-set name="mTEAMLIST_t_clubname" use-attribute-sets="teamlistpage"/>
	<xsl:attribute-set name="mUSER_t_username" use-attribute-sets="teamlistpage"/>
	<xsl:attribute-set name="mTEAMLIST_link_previouspage" use-attribute-sets="teamlistpage"/>
	<xsl:attribute-set name="mTEAMLIST_link_nextpage" use-attribute-sets="teamlistpage"/>
	<xsl:attribute-set name="teamlistpage" use-attribute-sets="linkatt"/>
	<!--============================TEAMLISTPAGE============================-->
	<!--============================THREADSPAGE====================================-->
	<xsl:attribute-set name="mFORUMTHREADS_on_postblock"/>
	<xsl:attribute-set name="mFORUMTHREADS_off_postblock"/>
	<xsl:attribute-set name="mSUBJECT_t_threadspage"/>
	<xsl:attribute-set name="mTHREADID_r_movethreadgadget"/>
	<xsl:attribute-set name="mFORUMTHREADS_r_subscribe"/>
	<xsl:attribute-set name="mFORUMTHREADS_r_subscribe_unsub"/>
	<xsl:attribute-set name="mFORUMTHREADS_r_newconversation"/>
	<xsl:attribute-set name="mFORUMTHREADS_c_postblock"/>
	<xsl:attribute-set name="mFORUMTHREADS_link_firstpage"/>
	<xsl:attribute-set name="mFORUMTHREADS_link_lastpage"/>
	<xsl:attribute-set name="mFORUMTHREADS_link_previouspage"/>
	<xsl:attribute-set name="mFORUMTHREADS_link_nextpage"/>
	<xsl:attribute-set name="mTHREAD_r_hidethread"/>
	<xsl:attribute-set name="maSKIPTO_link_tpgotobeginning" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_tpgotoprevious" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_tpgotonext" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="maSKIPTO_link_tpgotolatest" use-attribute-sets="multipostspagelinks"/>
	<xsl:attribute-set name="mUSER_t_firstposttp"/>
	<xsl:attribute-set name="mUSER_t_lastposttp"/>
	<!--============================THREADSPAGE====================================-->
	<!--============================USERPAGE============================-->
	<xsl:attribute-set name="mH2G2-ID_r_editarticle" use-attribute-sets="recententrieslinks"/>
	<xsl:attribute-set name="maTHREADID_t_threadtitlelinkup" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="maTHREADID_t_threaddatepostedlinkup" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mENTRYLINK_r_userpagerefs" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mUSERLINK_r_userpagerefs" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mEXTERNALLINK_r_userpagerefsbbc" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mEXTERNALLINK_r_userpagerefsnotbbc" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mARTICLE-LIST_r_morearticles" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="nc_createnewarticle" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mH2G2-ID_t_userpage" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mSUBJECT_t_userpagearticle" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mARTICLE-LIST_r_moreeditedarticles" use-attribute-sets="recentpostslinks"/>
	<xsl:attribute-set name="mSUBJECT_t_privatemessage" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mDATEPOSTED_t_privatemessage" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mWATCHED-USER-LIST_r_deletemany" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mWATCHED-USER-LIST_r_friendsjournals" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mUSER_t_watcheduserpage" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mUSER_t_watcheduserjournal" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mUSER_r_watcheduserdelete" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mCLUBNAME_t_clublink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_t_userlink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="maACTIONID_t_acceptlink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="maACTIONID_t_rejectlink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mPAGE-OWNER_r_clip" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mPRIVATEFORUM_t_leavemessagelink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="userpagelinks" use-attribute-sets="linkatt"/>
	<!--============================USERPAGE============================-->
	<!--============================USERMYCLUBSPAGE============================-->
	<xsl:attribute-set name="mNAME_t_clubsummary"/>
	<xsl:attribute-set name="mOWNER_t_actions"/>
	<xsl:attribute-set name="mCLUB_t_editclub"/>
	<xsl:attribute-set name="mCLUB_t_viewclub"/>
	<!--============================USERMYCLUBSPAGE============================-->
	<!--============================WATCHEDUSERSPAGE============================-->
	<xsl:attribute-set name="mWATCHED-USER-LIST_r_wupdeletemany"/>
	<xsl:attribute-set name="mWATCHED-USER-LIST_r_wupfriendsjournals"/>
	<xsl:attribute-set name="mUSER_t_wupwatcheduserpage"/>
	<xsl:attribute-set name="mUSER_t_wupwatcheduserjournal"/>
	<xsl:attribute-set name="mUSER_r_wupwatcheduserdelete"/>
	<xsl:attribute-set name="mUSER_t_wupwatchinguserpage"/>
	<xsl:attribute-set name="mUSER_t_wupwatchinguserjournal"/>
	<xsl:attribute-set name="mWATCHED-USER-POSTS_t_backwatcheduserpage"/>
	<xsl:attribute-set name="mWATCHED-USER-POSTS_c_postblock"/>
	<xsl:attribute-set name="mWATCHED-USER-POSTS_link_firstpage"/>
	<xsl:attribute-set name="mWATCHED-USER-POSTS_link_lastpage"/>
	<xsl:attribute-set name="mWATCHED-USER-POSTS_link_previouspage"/>
	<xsl:attribute-set name="mWATCHED-USER-POSTS_link_nextpage"/>
	<!--============================WATCHEDUSERSPAGE============================-->
	<!--============================SMMPAGE============================-->
	<xsl:attribute-set name="maMSGID_t_deletesystemmessage"/>
	<!--============================SMMPAGE============================-->
</xsl:stylesheet>
