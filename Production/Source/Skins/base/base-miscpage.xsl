<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--=================SIMPLEPAGE==================-->
	<!--
	<xsl:template name="SIMPLEPAGE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="SIMPLEPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_h2g2"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="SIMPLEPAGE_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SIMPLEPAGE_SUBJECT">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/GUIDE">
				<xsl:call-template name="ARTICLE_SUBJECT"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ARTICLE/USERACTION" mode="subject"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USERACTION" mode="subject">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	Chooses the text for the subject
	-->
	<xsl:template match="USERACTION" mode="subject">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=1">
						<xsl:value-of select="$m_removenamesubjsuccess"/>
					</xsl:when>
					<xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=0">
						<xsl:value-of select="$m_removenamesubjfailure"/>
					</xsl:when>
					<xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=0">
						<xsl:value-of select="$m_entrynotdeletedsubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=1">
						<xsl:value-of select="$m_guideentrydeletedsubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=1">
						<xsl:value-of select="$m_guideentryrestoredsubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='EDITENTRY' and @REASON='nopermission' and @RESULT=0">
						<xsl:value-of select="$m_editpermissiondenied"/>
					</xsl:when>
					<xsl:when test="@TYPE='UNRECOGNISEDCOMMAND' and @RESULT=1">
						<xsl:value-of select="$m_unrecognisedcommandsubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='UNSPECIFIEDERROR' and @RESULT=1">
						<xsl:value-of select="$m_unspecifiederrorsubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=0 and @REASON='dberror'">
						<xsl:value-of select="$m_dberrorsubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='homepage'">
						<xsl:value-of select="$m_homepageerrorstatuschangesubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='notentry'">
						<xsl:value-of select="$m_notentryerrorstatuschangesubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='general'">
						<xsl:value-of select="$m_generalerrorstatuschangesubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='noarticle'">
						<xsl:value-of select="$m_noarticleerrorresearcherchangesubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='general'">
						<xsl:value-of select="$m_generalerrorresearcherchangesubj"/>
					</xsl:when>
					<xsl:when test="@TYPE='ARTICLEINREVIEW' and @RESULT=0 and @REASON='initialise'">
						<xsl:value-of select="$m_initialiseerrorarticleinreviewsubj"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="../SUBJECT"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="USERACTION" mode="t_simplepage">
	Author:		Andy Harris
	Context:      H2G2/USERACTION
	Purpose:	 Chooses the correct USERACTION text
	-->
	<xsl:template match="USERACTION" mode="t_simplepage">
		<xsl:choose>
			<xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=1">
				<xsl:call-template name="m_nameremovedfromresearchers"/>
			</xsl:when>
			<xsl:when test="@TYPE='REMOVESELFFROMRESEARCHERLIST' and @RESULT=0">
				<xsl:call-template name="m_namenotremovedfromresearchers"/>
			</xsl:when>
			<xsl:when test="@TYPE='DELETEGUIDEENTRY' and @REASON='nopermission' and @RESULT=0">
				<xsl:copy-of select="$m_nopermissiontodeleteentry"/>
			</xsl:when>
			<xsl:when test="@TYPE='DELETEGUIDEENTRY' and @REASON='dberror' and @RESULT=0">
				<xsl:value-of select="$m_dberrordeleteentry"/>
			</xsl:when>
			<xsl:when test="@TYPE='DELETEGUIDEENTRY' and @RESULT=1">
				<xsl:call-template name="m_guideentrydeleted"/>
			</xsl:when>
			<xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=1">
				<xsl:call-template name="m_guideentryrestored"/>
			</xsl:when>
			<xsl:when test="@TYPE='EDITENTRY' and @REASON='nopermission' and @RESULT=0">
				<xsl:call-template name="m_nopermissiontoedit"/>
			</xsl:when>
			<xsl:when test="@TYPE='UNRECOGNISEDCOMMAND' and @RESULT=1">
				<xsl:call-template name="m_unrecognisedcommand"/>
			</xsl:when>
			<xsl:when test="@TYPE='UNSPECIFIEDERROR' and @RESULT=1">
				<xsl:call-template name="m_unspecifiederror"/>
			</xsl:when>
			<xsl:when test="@TYPE='GUIDEENTRYRESTORED' and @RESULT=0 and @REASON='dberror'">
				<xsl:copy-of select="$m_dberrorguideundelete"/>
			</xsl:when>
			<xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='homepage'">
				<xsl:copy-of select="$m_homepageerrorstatuschange"/>
			</xsl:when>
			<xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='notentry'">
				<xsl:copy-of select="$m_notentryerrorstatuschange"/>
			</xsl:when>
			<xsl:when test="@TYPE='STATUSCHANGE' and @RESULT=0 and @REASON='general'">
				<xsl:copy-of select="$m_generalerrorstatuschange"/>
			</xsl:when>
			<xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='noarticle'">
				<xsl:copy-of select="$m_noarticleerrorresearcherchange"/>
			</xsl:when>
			<xsl:when test="@TYPE='RESEARCHERCHANGE' and @RESULT=0 and @REASON='general'">
				<xsl:copy-of select="$m_generalerrorresearcherchange"/>
			</xsl:when>
			<xsl:when test="@TYPE='ARTICLEINREVIEW' and @RESULT=0 and @REASON='initialise'">
				<xsl:copy-of select="$m_initialiseerrorarticleinreview"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--=================SIMPLEPAGE==================-->
	<!--=================ERRORPAGE==================-->
	<!--
	<xsl:template name="ERROR_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ERROR_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_errortitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="ERROR_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="ERROR_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_errorsubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="t_errorpage">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the error message
	-->
	<xsl:template match="ERROR" mode="t_errorpage">
		<xsl:choose>
			<xsl:when test="@TYPE = 'UNREGISTERED-USEREDIT'">
				<xsl:call-template name="m_unregistereduserediterror"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($m_followingerror, ' ')"/>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--=================ERRORPAGE==================-->
	<!--=================SUBSCRIBEPAGE==================-->
	<!--
	<xsl:template name="SUBSCRIBE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="SUBSCRIBE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_h2g2"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="SUBSCRIBE_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SUBSCRIBE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="SUBSCRIBE-RESULT/@TOTHREAD">
						<xsl:value-of select="$m_subthreadcomplete"/>
					</xsl:when>
					<xsl:when test="SUBSCRIBE-RESULT/@TOFORUM">
						<xsl:value-of select="$m_subforumcomplete"/>
					</xsl:when>
					<xsl:when test="SUBSCRIBE-RESULT/@JOURNAL">
						<xsl:value-of select="$m_journalremovecomplete"/>
					</xsl:when>
					<xsl:when test="SUBSCRIBE-RESULT/@FROMTHREAD">
						<xsl:value-of select="$m_unsubthreadcomplete"/>
					</xsl:when>
					<xsl:when test="SUBSCRIBE-RESULT/@FROMFORUM">
						<xsl:value-of select="$m_unsubforumcomplete"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_subrequestfailed"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="SUBSCRIBE-RESULT" mode="t_subscribepage">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subscribe result
	-->
	<xsl:template match="SUBSCRIBE-RESULT" mode="t_subscribepage">
		<xsl:choose>
			<xsl:when test="@TOTHREAD">
				<xsl:copy-of select="$m_subscribedtothread"/>
			</xsl:when>
			<xsl:when test="@TOFORUM">
				<xsl:copy-of select="$m_subscribedtoforum"/>
			</xsl:when>
			<xsl:when test="@FROMFORUM">
				<xsl:copy-of select="$m_unsubbedfromforum"/>
			</xsl:when>
			<xsl:when test="@FROMTHREAD">
				<xsl:choose>
					<xsl:when test="@FAILED">
						<xsl:value-of select="."/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@JOURNAL">
								<xsl:copy-of select="$m_journalremoved"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="$m_unsubscribedfromthread"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="RETURN-TO" mode="t_subscribepage">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the link for the 'Return' link
	-->
	<xsl:template match="RETURN-TO" mode="t_subscribepage">
		<a href="{$root}{URL}" xsl:use-attribute-sets="mRETURN-TO_t_subscribepage">
			<xsl:value-of select="DESCRIPTION"/>
		</a>
	</xsl:template>
	<!--=================SUBSCRIBEPAGE==================-->
	<!--=================LOGOUTPAGE==================-->
	<!--
	<xsl:template name="LOGOUT_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="LOGOUT_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_logoutheader"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="LOGOUT_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="LOGOUT_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_logoutsubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--=================LOGOUTPAGE==================-->
	<!--=================NOTFOUNDPAGE==================-->
	<!--
	<xsl:template name="NOTFOUND_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="NOTFOUND_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_h2g2"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="NOTFOUND_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="NOTFOUND_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_notfoundsubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--=================NOTFOUNDPAGE==================-->
	<!--=================SITECHANGE PAGE==================-->
		<!--
	<xsl:template name="SITECHANGE_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SITECHANGE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_leavingsitetitle"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<!--=================SITECHANGE PAGE==================-->
</xsl:stylesheet>
