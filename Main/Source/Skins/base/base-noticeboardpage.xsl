<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="mNOTICEBOARD_t_createnotice" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mNOTICEBOARD_t_createevent" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mNOTICEBOARD_r_createalert" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mNOTICEBOARD_t_createwanted" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mNOTICEBOARD_t_createoffer" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:attribute-set name="mUSERNAME_r_single" use-attribute-sets="noticeboardpagelinks"/>
	<xsl:variable name="m_createnotice">
		<xsl:copy-of select="$m_createnoticetitle"/>
	</xsl:variable>
	<xsl:variable name="m_createevent">
		<xsl:copy-of select="$m_createeventtitle"/>
	</xsl:variable>
	<xsl:variable name="m_createalert">
		<xsl:copy-of select="$m_createalerttitle"/>
	</xsl:variable>
	<xsl:variable name="m_createwanted">
		<xsl:copy-of select="$m_createwantedtitle"/>
	</xsl:variable>
	<xsl:variable name="m_createoffer">
		<xsl:copy-of select="$m_createoffertitle"/>
	</xsl:variable>
	<xsl:variable name="m_noticeboardtitle">
		<xsl:choose>
			<xsl:when test="/H2G2/NOTICEBOARD/MODE = 'EVENTS'">
				<xsl:value-of select="/H2G2/NOTICEBOARD/EVENTS/EVENT/TITLE"/>
			</xsl:when>
			<xsl:otherwise>Noticeboard for <xsl:value-of select="/H2G2/NOTICEBOARD/LOCALAREAINFO/TITLE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="test_postcode" select="/H2G2/POSTCODER/RESULT_LIST/RESULT/POSTCODE"/>
	<!--
	<xsl:template name="NOTICEBOARD_HEADER">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="NOTICEBOARD_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:choose>
					<xsl:when test="/H2G2/NOTICEBOARD/ERROR='FailedToFindPostcodeMatch'">Unrecognised postcode</xsl:when>
					<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBNOTICE' or @TYPE='ADD-NBNOTICEPREVIEW']">
						<xsl:copy-of select="$m_createnoticetitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBEVENT' or @TYPE='ADD-NBEVENTPREVIEW']">
						<xsl:copy-of select="$m_createeventtitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBALERT' or @TYPE='ADD-NBALERTPREVIEW']">
						<xsl:copy-of select="$m_createalerttitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBWANTED' or @TYPE='ADD-NBWANTEDPREVIEW']">
						<xsl:copy-of select="$m_createwantedtitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBOFFER' or @TYPE='ADD-NBOFFERPREVIEW']">
						<xsl:copy-of select="$m_createoffertitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/NOTICEBOARD/TITLE">
						<xsl:copy-of select="$m_noticeboardtitle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_noticeboardtitle"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="NOTICEBOARD_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="NOTICEBOARD_SUBJECT">
		<xsl:choose>
		
			<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBNOTICE' or @TYPE='ADD-NBNOTICEPREVIEW']">
				<xsl:copy-of select="$m_createnoticetitle"/>
			</xsl:when>
			<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBEVENT' or @TYPE='ADD-NBEVENTPREVIEW']">
				<xsl:copy-of select="$m_createeventtitle"/>
			</xsl:when>
			<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBALERT' or @TYPE='ADD-NBALERTPREVIEW']">
				<xsl:copy-of select="$m_createalerttitle"/>
			</xsl:when>
			<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBWANTED' or @TYPE='ADD-NBWANTEDPREVIEW']">
				<xsl:copy-of select="$m_createwantedtitle"/>
			</xsl:when>
			<xsl:when test="/H2G2/NOTICEBOARD/MULTI-STAGE[@TYPE='ADD-NBOFFER' or @TYPE='ADD-NBOFFERPREVIEW']">
				<xsl:copy-of select="$m_createoffertitle"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ERROR" mode="c_noticedisplay">
		<xsl:apply-templates select="." mode="r_noticedisplay"/>
	</xsl:template>
	<xsl:template match="ERROR" mode="r_noticedisplay">
		<xsl:choose>
			<xsl:when test=".='FailedToFindPostcodeMatch'">
				you provided an unrecognised postcode
			</xsl:when>
			<xsl:when test=".='InvalidEventIDGiven'">
				Event does not exist
			</xsl:when>		
			<xsl:when test=".='FailedToFindNotice'">
				Notice does not exist
			</xsl:when>
			<xsl:when test=".='NoPostCodeGiven'">
				You need to <a href="{$root}postcode?civic=1&amp;s_view=change">set a postcode</a> to see this
			</xsl:when>	
			<xsl:when test="($registered!=1) or (.='UserMustBeLoggedInToDoActions')">
				In order to view the noticeboards you will need to <a href="{$sso_nonoticeregisterlink}">Register</a> or <a href="{$sso_nonoticesigninlink}">Sign in</a> to iCan. Then follow our step-by-step process.
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_create">
		<xsl:if test="MULTI-STAGE">
			<xsl:apply-templates select="." mode="r_create"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_display">
		<xsl:if test="not(MULTI-STAGE)">
			<xsl:choose>
				<xsl:when test="MODE='EVENTS'">
					<xsl:apply-templates select="." mode="single_display"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="full_display"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_noticeboard">
		<xsl:choose>
			<xsl:when test="NOTICES/NOTICE">
				<xsl:apply-templates select="." mode="full_noticeboard"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_noticeboard"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--xsl:template match="NOTICES" mode="c_noticeboard">
		<xsl:choose>
			<xsl:when test="NOTICE">
				<xsl:apply-templates select="." mode="full_noticeboard"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_noticeboard"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template-->
	<xsl:template match="NOTICE" mode="c_noticeboard">
		<xsl:choose>
			<xsl:when test="@TYPE='Notice'">
				<xsl:apply-templates select="." mode="notice_noticeboard"/>
			</xsl:when>
			<xsl:when test="@TYPE='Event'">
				<xsl:apply-templates select="." mode="event_noticeboard"/>
			</xsl:when>
			<xsl:when test="@TYPE='Alert'">
				<xsl:apply-templates select="." mode="alert_noticeboard"/>
			</xsl:when>
			<xsl:when test="@TYPE='Wanted'">
				<xsl:apply-templates select="." mode="wanted_noticeboard"/>
			</xsl:when>
			<xsl:when test="@TYPE='Offer'">
				<xsl:apply-templates select="." mode="offer_noticeboard"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="USERNAME" mode="c_notice">
		<xsl:apply-templates select="." mode="r_notice"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_notice">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_notice">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEVOTES" mode="c_notice">
		<xsl:apply-templates select="." mode="r_notice"/>
	</xsl:template>
	<xsl:template match="NOTICEVOTES" mode="r_notice">
		<a href="{$root}vote?action=add&amp;voteid={VOTEID}&amp;response=1&amp;type=2&amp;postcode={$test_postcode}" xsl:use-attribute-sets="mNOTICEVOTES_r_notice">
			<xsl:copy-of select="$m_votenoticeboard"/>
		</a>
	</xsl:template>
	<xsl:template match="USERNAME" mode="c_event">
		<xsl:apply-templates select="." mode="r_event"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_event">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_event">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="DATECLOSING" mode="c_dateofevent">
		<xsl:apply-templates select="." mode="r_dateofevent"/>
	</xsl:template>
	<xsl:template match="DATECLOSING" mode="r_dateofevent">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="c_wanted">
		<xsl:apply-templates select="." mode="r_wanted"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_wanted">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_wanted">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="USERNAME" mode="c_offer">
		<xsl:apply-templates select="." mode="r_offer"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_offer">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_offer">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="POSTID" mode="c_editnotice">
		<xsl:if test="$test_EditorOrModerator">
			<xsl:apply-templates select="." mode="r_editnotice"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="POSTID" mode="c_moderatehistorynotice">
		<xsl:if test="$test_EditorOrModerator">
			<xsl:apply-templates select="." mode="r_moderatehistorynotice"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="POSTID" mode="r_editnotice">
		<a href="{$root}EditPost?PostID={.}" target="_top" onClick="popupwindow('{$root}EditPost?PostID={.}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;">
			<xsl:copy-of select="$m_editpost"/>
		</a>
	</xsl:template>
	<xsl:template match="POSTID" mode="r_moderatehistorynotice">
		<a target="_top" href="{$root}ModerationHistory?PostID={.}">
			<xsl:value-of select="$m_moderationhistory"/>
		</a>
	</xsl:template>
	<xsl:template match="POSTID" mode="c_complainnotice">
		<xsl:apply-templates select="." mode="r_complainnotice"/>
	</xsl:template>
	<xsl:template match="POSTID" mode="r_complainnotice">
		<a href="{$root}/comments/UserComplaintPage?PostID={.}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('{$root}/comments/UserComplaintPage?PostID={.}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="mPOSTID_r_complain">
			<xsl:choose>
				<xsl:when test="../@TYPE='Offer'">
					<xsl:copy-of select="$m_complainoffer"/>
				</xsl:when>
				<xsl:when test="../@TYPE='Wanted'">
					<xsl:copy-of select="$m_complainwanted"/>
				</xsl:when>
				<xsl:when test="../@TYPE='Alert'">
					<xsl:copy-of select="$m_complainalert"/>
				</xsl:when>
				<xsl:when test="../@TYPE='Event'">
					<xsl:copy-of select="$m_complainevent"/>
				</xsl:when>
				<xsl:when test="../@TYPE='Notice'">
					<xsl:copy-of select="$m_complainnotice"/>
				</xsl:when>
			</xsl:choose>
		</a>
	</xsl:template>
	<xsl:template match="DATECLOSING" mode="c_dateofalert">
		<xsl:apply-templates select="." mode="r_dateofalert"/>
	</xsl:template>
	<xsl:template match="DATECLOSING" mode="r_dateofalert">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<xsl:template match="EVENTS" mode="c_eventsboard">
		<xsl:choose>
			<xsl:when test="EVENT">
				<xsl:apply-templates select="." mode="full_eventsboard"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_eventsboard"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EVENT" mode="c_eventsboard">
		<xsl:apply-templates select="." mode="r_eventsboard"/>
	</xsl:template>
	<!--xsl:template match="EVENT" mode="c_eventsboard">
		<xsl:choose>
			<xsl:when test="@TYPE='Event'">
				<xsl:apply-templates select="." mode="event_event"/>
			</xsl:when>
			<xsl:when test="@TYPE='Alert'">
				<xsl:apply-templates select="." mode="alert_event"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template-->
	<xsl:template match="EVENT" mode="r_eventsboard">
		<a href="{$root}NoticeBoard?aviewevent={THREADID}&amp;postcode={$test_postcode}" xsl:use-attribute-sets="mEVENT_r_eventsboard">
			<xsl:value-of select="TITLE"/>
		</a>
	</xsl:template>
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- **************************                Create a Notice                  **************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<!-- ************************************************************************************************** -->
	<xsl:variable name="noticefields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="eventfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										<ELEMENT NAME='YEAR'></ELEMENT>
										<ELEMENT NAME='MONTH'></ELEMENT>
										<ELEMENT NAME='DAY'></ELEMENT>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="alertfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										<ELEMENT NAME='YEAR'></ELEMENT>
										<ELEMENT NAME='MONTH'></ELEMENT>
										<ELEMENT NAME='DAY'></ELEMENT>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="wantedfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="offerfields"><![CDATA[<MULTI-INPUT>
										<REQUIRED NAME='TITLE'></REQUIRED>
										<REQUIRED NAME='BODY'></REQUIRED>
										</MULTI-INPUT>]]></xsl:variable>
	<xsl:template match="NOTICEBOARD" mode="c_form">
		<xsl:variable name="noticetype">
			<xsl:choose>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBNOTICE' or MULTI-STAGE/@TYPE='EDIT-NBNOTICE' or MULTI-STAGE/@TYPE='ADD-NBNOTICEPREVIEW' or MULTI-STAGE/@TYPE='EDIT-NBNOTICEPREVIEW'">Notice</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBEVENT' or MULTI-STAGE/@TYPE='EDIT-NBEVENT' or MULTI-STAGE/@TYPE='ADD-NBEVENTPREVIEW' or MULTI-STAGE/@TYPE='EDIT-NBEVENTPREVIEW'">Event</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBALERT' or NOTICEBOARD/MULTI-STAGE/@TYPE='ADD-NBALERTPREVIEW'">Alert</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBWANTED' or MULTI-STAGE/@TYPE='ADD-NBWANTEDPREVIEW'">Wanted</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBOFFER' or MULTI-STAGE/@TYPE='ADD-NBOFFERPREVIEW'">Offer</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="noticeboardfields">
			<xsl:choose>
				<xsl:when test="$noticetype='Notice'">
					<xsl:copy-of select="$noticefields"/>
				</xsl:when>
				<xsl:when test="$noticetype='Event'">
					<xsl:copy-of select="$eventfields"/>
				</xsl:when>
				<xsl:when test="$noticetype='Alert'">
					<xsl:copy-of select="$alertfields"/>
				</xsl:when>
				<xsl:when test="$noticetype='Wanted'">
					<xsl:copy-of select="$wantedfields"/>
				</xsl:when>
				<xsl:when test="$noticetype='Offer'">
					<xsl:copy-of select="$offerfields"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<form method="post" action="{$root}NoticeBoard">
			<input type="hidden" name="type" value="{$noticetype}"/>
			<input type="hidden" name="_msxml" value="{$noticeboardfields}"/>
			<!--input type="hidden" name="skin" value="purexml"/-->
			<!--input type="hidden" name="nodeid" value="{/H2G2/NOTICEBOARD/LOCALAREAINFO/NODEID}"/-->
			<input type="hidden" name="postcode" value="{$test_postcode}"/>
			<xsl:choose>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBNOTICE' or MULTI-STAGE/@TYPE='EDIT-NBNOTICE' or MULTI-STAGE/@TYPE='ADD-NBNOTICEPREVIEW' or MULTI-STAGE/@TYPE='EDIT-NBNOTICEPREVIEW'">
					<xsl:apply-templates select="." mode="notice_form"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBEVENT' or MULTI-STAGE/@TYPE='EDIT-NBEVENT' or MULTI-STAGE/@TYPE='ADD-NBEVENTPREVIEW' or MULTI-STAGE/@TYPE='EDIT-NBEVENTPREVIEW'">
					<xsl:apply-templates select="." mode="event_form"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBALERT' or NOTICEBOARD/MULTI-STAGE/@TYPE='ADD-NBALERTPREVIEW'">
					<xsl:apply-templates select="." mode="alert_form"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBWANTED' or MULTI-STAGE/@TYPE='ADD-NBWANTEDPREVIEW'">
					<xsl:apply-templates select="." mode="wanted_form"/>
				</xsl:when>
				<xsl:when test="MULTI-STAGE/@TYPE='ADD-NBOFFER' or MULTI-STAGE/@TYPE='ADD-NBOFFERPREVIEW'">
					<xsl:apply-templates select="." mode="offer_form"/>
				</xsl:when>
			</xsl:choose>
		</form>
	</xsl:template>
	<xsl:template match="ERROR" mode="c_noticeboard">
		<xsl:if test="string-length(.) &gt; 0">
			<xsl:apply-templates select="." mode="r_noticeboard"/>
		</xsl:if>
	</xsl:template>
	<xsl:variable name="m_invalidclosingdate">The date you have set was in the past.<br />Please set another date for your event. </xsl:variable>
	<xsl:template match="ERROR" mode="r_noticeboard">
		<xsl:choose>
			<xsl:when test=".='ClosingDateInvalid'">
				<xsl:copy-of select="$m_invalidclosingdate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_t_noticesubject">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_noticebody">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_noticesubject">
		<input type="text" name="title" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_noticebody">
		<textarea name="body" xsl:use-attribute-sets="iMULTI-STAGE_t_noticebody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!-- _________________________________________________ -->
	<xsl:attribute-set name="iMULTI-STAGE_t_eventsubject">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_eventbody">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_eventsubject">
		<input type="text" name="title" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_eventbody">
		<textarea name="body" xsl:use-attribute-sets="iMULTI-STAGE_t_eventbody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!-- _________________________________________________ -->
	<xsl:attribute-set name="iMULTI-STAGE_t_alertsubject">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_alertbody">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_alertsubject">
		<input type="text" name="title" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_alertbody">
		<textarea name="body" xsl:use-attribute-sets="iMULTI-STAGE_t_alertbody">
			<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!-- _________________________________________________ -->
	<xsl:attribute-set name="iMULTI-STAGE_t_wantedsubject">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_wantedbody">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_wantedsubject">
		<input type="text" name="title" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_wantedbody">
		<textarea name="body" xsl:use-attribute-sets="iMULTI-STAGE_t_wantedbody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!-- _________________________________________________ -->
	<xsl:attribute-set name="iMULTI-STAGE_t_offersubject">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_offerbody">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_offersubject">
		<input type="text" name="title" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_offerbody">
		<textarea name="body" xsl:use-attribute-sets="iMULTI-STAGE_t_offerbody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!-- _________________________________________________ -->
	<xsl:template match="NOTICEBOARD" mode="c_noticepreview">
		<xsl:if test="MULTI-STAGE/@TYPE='ADD-NBNOTICEPREVIEW' or MULTI-STAGE/@TYPE='EDIT-NBNOTICEPREVIEW'">
			<xsl:apply-templates select="." mode="r_noticepreview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_eventpreview">
		<xsl:if test="MULTI-STAGE/@TYPE='ADD-NBEVENTPREVIEW' or MULTI-STAGE/@TYPE='EDIT-NBEVENTPREVIEW'">
			<xsl:apply-templates select="." mode="r_eventpreview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_alertpreview">
		<xsl:if test="MULTI-STAGE/@TYPE='ADD-NBALERTPREVIEW'">
			<xsl:apply-templates select="." mode="r_alertpreview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_wantedpreview">
		<xsl:if test="MULTI-STAGE/@TYPE='ADD-NBWANTEDPREVIEW'">
			<xsl:apply-templates select="." mode="r_wantedpreview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_offerpreview">
		<xsl:if test="MULTI-STAGE/@TYPE='ADD-NBOFFERPREVIEW'">
			<xsl:apply-templates select="." mode="r_offerpreview"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="t_returntonoticeboard">
		<a href="{$root}NoticeBoard?postcode={$test_postcode}" xsl:use-attribute-sets="mNOTICEBOARD_t_returntonoticeboard">
			<xsl:copy-of select="$m_returntonoticeboardpage"/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="t_createnotice">
		<a xsl:use-attribute-sets="mNOTICEBOARD_t_createnotice">
			<xsl:attribute name="href"><xsl:call-template name="sso_notice_signin">
				<xsl:with-param name="type" select="'notice'"/>
			</xsl:call-template></xsl:attribute>
			<xsl:copy-of select="$m_createnotice"/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="t_createevent">
		<a xsl:use-attribute-sets="mNOTICEBOARD_t_createevent">
			<xsl:attribute name="href"><xsl:call-template name="sso_notice_signin">
				<xsl:with-param name="type" select="'event'"/>
			</xsl:call-template></xsl:attribute>

			<xsl:copy-of select="$m_createevent"/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_createalert">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_createalert"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_createalert">
		<a xsl:use-attribute-sets="mNOTICEBOARD_r_createalert">
			<xsl:attribute name="href"><xsl:call-template name="sso_notice_signin">
				<xsl:with-param name="type" select="'alert'"/>
			</xsl:call-template></xsl:attribute>
			<xsl:copy-of select="$m_createalert"/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="t_createwanted">
		<a xsl:use-attribute-sets="mNOTICEBOARD_t_createwanted">
			<xsl:attribute name="href"><xsl:call-template name="sso_notice_signin">
				<xsl:with-param name="type" select="'wanted'"/>
			</xsl:call-template></xsl:attribute>
			<xsl:copy-of select="$m_createwanted"/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="t_createoffer">
		<a xsl:use-attribute-sets="mNOTICEBOARD_t_createoffer">
			<xsl:attribute name="href"><xsl:call-template name="sso_notice_signin">
				<xsl:with-param name="type" select="'offer'"/>
			</xsl:call-template></xsl:attribute>
			<xsl:copy-of select="$m_createoffer"/>
		</a>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitnotice">
		<xsl:apply-templates select="." mode="r_submitnotice"/>
	</xsl:template>
	<xsl:template match="EVENTS" mode="c_single">
		<xsl:apply-templates select="." mode="r_single"/>
	</xsl:template>
	<xsl:template match="EVENT" mode="c_single">
		<xsl:apply-templates select="." mode="r_single"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="c_single">
		<xsl:apply-templates select="." mode="r_single"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="r_single">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_single">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitnotice">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewnotice">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitevent">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewevent">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitalert">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewalert">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitwanted">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewwanted">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitoffer">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iNOTICEBOARD_r_submitpreviewoffer">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="NOTICEBOARD" mode="r_submitnotice">
		<input name="acreate" xsl:use-attribute-sets="iNOTICEBOARD_r_submitnotice"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitpreviewnotice">
		<xsl:apply-templates select="." mode="r_submitpreviewnotice"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewnotice">
		<input name="apreview" xsl:use-attribute-sets="iNOTICEBOARD_r_submitpreviewnotice"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitevent">
		<xsl:apply-templates select="." mode="r_submitevent"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitevent">
		<input name="acreate" xsl:use-attribute-sets="iNOTICEBOARD_r_submitevent"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitpreviewevent">
		<xsl:apply-templates select="." mode="r_submitpreviewevent"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewevent">
		<input name="apreview" xsl:use-attribute-sets="iNOTICEBOARD_r_submitpreviewevent"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitalert">
		<xsl:apply-templates select="." mode="r_submitalert"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitalert">
		<input name="acreate" xsl:use-attribute-sets="iNOTICEBOARD_r_submitalert"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitpreviewalert">
		<xsl:apply-templates select="." mode="r_submitpreviewalert"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewalert">
		<input name="apreview" xsl:use-attribute-sets="iNOTICEBOARD_r_submitpreviewalert"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitwanted">
		<xsl:apply-templates select="." mode="r_submitwanted"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitwanted">
		<input name="acreate" xsl:use-attribute-sets="iNOTICEBOARD_r_submitwanted"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitpreviewwanted">
		<xsl:apply-templates select="." mode="r_submitpreviewwanted"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewwanted">
		<input name="apreview" xsl:use-attribute-sets="iNOTICEBOARD_r_submitpreviewwanted"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitoffer">
		<xsl:apply-templates select="." mode="r_submitoffer"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitoffer">
		<input name="acreate" xsl:use-attribute-sets="iNOTICEBOARD_r_submitoffer"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_submitpreviewoffer">
		<xsl:apply-templates select="." mode="r_submitpreviewoffer"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="r_submitpreviewoffer">
		<input name="apreview" xsl:use-attribute-sets="iNOTICEBOARD_r_submitpreviewoffer"/>
	</xsl:template>
</xsl:stylesheet>
