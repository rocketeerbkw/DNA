<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="USEREDIT_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="USEREDIT_HEADER">
		<xsl:choose>
			<xsl:when test="INREVIEW">
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_articleisinreviewtext"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_editpagetitle"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="USEREDIT_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="USEREDIT_SUBJECT">
		<xsl:choose>
			<xsl:when test="/H2G2/INREVIEW">
				<xsl:value-of select="$m_articleisinreviewtext"/>
			</xsl:when>
			<xsl:when test="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) = 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD != 0">
				<xsl:value-of select="$m_AddHomePageHeading"/>
			</xsl:when>
			<xsl:when test="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) = 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 0">
				<xsl:value-of select="$m_AddGuideEntryHeading"/>
			</xsl:when>
			<xsl:when test="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) != 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD != 0">
				<xsl:value-of select="$m_EditHomePageHeading"/>
			</xsl:when>
			<xsl:when test="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) != 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 0">
				<xsl:value-of select="$m_EditGuideEntryHeading"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_EditGuideEntryHeading"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="INREVIEW" mode="c_inreview">
	Author:		Tom Whitehouse
	Context:      /H2G2/INREVIEW
	Purpose:	 Calls the INREVIEW container 
	-->
	<xsl:template match="INREVIEW" mode="c_inreview">
		<xsl:apply-templates select="." mode="r_inreview"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_inputform">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Calls the ARTICLE-EDIT-FORM container and javascript 
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_inputform">
		<script language="JavaScript">
			<xsl:comment>
						submit=0;
						function runSubmit ()
						{
							submit+=1;
							if(submit>2) {alert("<xsl:value-of select="$m_donotpress"/>"); return (false);}
							if(submit>1) {alert("<xsl:value-of select="$m_atriclesubmitted"/>"); return (false);}
							return(true);
						}
					//</xsl:comment>
		</script>
		<xsl:apply-templates select="." mode="r_inputform"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-PREVIEW" mode="c_previewarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-PREVIEW
	Purpose:	 Calls the ARTICLE-PREVIEW container 
	-->
	<xsl:template match="ARTICLE-PREVIEW" mode="c_previewarticle">
		<xsl:apply-templates select="." mode="r_previewarticle"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_form">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the form element for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_form">
		<form method="post" onsubmit="return runSubmit()" title="Article Editing Form" xsl:use-attribute-sets="fARTICLE-EDIT-FORM_c_form">
			<xsl:apply-templates select="." mode="HiddenInputs"/>
			<xsl:apply-templates select="." mode="r_form"/>
			<xsl:attribute name="method">post</xsl:attribute>
			<xsl:attribute name="action"><xsl:value-of select="concat($root, 'Edit')"/></xsl:attribute>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="HiddenInputs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the hidden inputs for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="HiddenInputs">
		<input type="hidden" name="id">
			<xsl:attribute name="value"><xsl:value-of select="H2G2ID"/></xsl:attribute>
		</input>
		<input type="hidden" name="masthead">
			<xsl:attribute name="value"><xsl:value-of select="MASTHEAD"/></xsl:attribute>
		</input>
		<input type="hidden" name="format">
			<xsl:attribute name="value"><xsl:value-of select="FORMAT"/></xsl:attribute>
		</input>
		<input type="hidden" name="cmd" value="submit"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_premodmessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Calls the correct pre-moderation message container for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_premodmessage">
		<xsl:choose>
			<xsl:when test="$premoderated=1">
				<xsl:apply-templates select="." mode="user_premodmessage"/>
			</xsl:when>
			<xsl:when test="PREMODERATION=1">
				<xsl:apply-templates select="." mode="article_premodmessage"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_subjectbox">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the subject box for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_subjectbox">
		<input type="text" xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_subjectbox" name="subject">
			<xsl:attribute name="title"><xsl:value-of select="$m_GESubject"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="SUBJECT"/></xsl:attribute>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_bodybox">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the body text box for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_bodybox">
		<textarea xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_bodybox" name="body">
			<xsl:attribute name="title"><xsl:value-of select="$alt_contentofguideentry"/></xsl:attribute>
			<xsl:value-of select="CONTENT"/>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_selectskin">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the skin dropdown for the ARTICLE-EDIT-FORM
	-->
	<xsl:variable name="skinname"/>
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_selectskin">
		<xsl:param name="localskinname" select="$skinname"/>
		<select name="skin" xsl:use-attribute-sets="sARTICLE-EDIT-FORM_t_selectskin">
			<xsl:apply-templates select="msxsl:node-set($skinlist)/*">
				<xsl:with-param name="localskinname">
					<xsl:value-of select="$localskinname"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="SKINDEFINITION">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the each element in the skin dropdown for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="SKINDEFINITION">
		<xsl:param name="localskinname" select="$skinname"/>
		<option value="{NAME}" xsl:use-attribute-sets="oARTICLE-EDIT-FORM_t_selectskin">
			<xsl:if test="$localskinname = string(NAME)">
				<xsl:attribute name="SELECTED">1</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="DESCRIPTION"/>
		</option>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="c_move-to-site">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/SITEID
	Purpose:	 Creates the move to another site form and calls the container
	-->
	<xsl:template match="SITEID" mode="c_move-to-site">
		<xsl:if test="../FUNCTIONS/MOVE-TO-SITE">
			<form name="MoveToSiteForm" method="get">
				<input type="hidden" name="cmd" value="MoveToSite"/>
				<input type="hidden" name="moveObjectID" value="{../H2G2ID}"/>
				<xsl:apply-templates select="." mode="r_move-to-site"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_movetositelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/SITEID
	Purpose:	 Creates the site dropdown for the move to site form
	-->
	<xsl:template match="SITEID" mode="t_movetositelist">
		<xsl:variable name="currentSiteID" select="."/>
		<select name="SitesList" xsl:use-attribute-sets="sSITEID_t_movetositelist">
			<xsl:for-each select="/H2G2/SITE-LIST/SITE">
				<option value="{@ID}" xsl:use-attribute-sets="oSITEID_t_movetositelist">
					<xsl:if test="@ID = $currentSiteID">
						<xsl:attribute name="SELECTED"/>
					</xsl:if>
					<xsl:value-of select="SHORTNAME"/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_movetositesubmit">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/SITEID
	Purpose:	 Creates the submit button for the move to site form
	-->
	<xsl:template match="SITEID" mode="t_movetositesubmit">
		<input name="button" type="submit" value="Move" xsl:use-attribute-sets="iSITEID_t_movetositesubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="t_submitsetresearchers">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST
	Purpose:	 Creates the submit button for the set researchers area of the form
	-->
	<xsl:template match="USER-LIST" mode="t_submitsetresearchers">
		<input name="SetResearchers" xsl:use-attribute-sets="iUSER-LIST_t_submitsetresearchers"/>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="t_setresearcherscontent">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST
	Purpose:	 Creates the content area for the set researchers area of the form
	-->
	<xsl:template match="USER-LIST" mode="t_setresearcherscontent">
		<textarea name="ResearcherList" xsl:use-attribute-sets="iUSER-LIST_t_setresearcherscontent">
			<xsl:apply-templates select="USER" mode="c_editresearcher">
				<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_previewbutton">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM
	Purpose:	 Creates the preview button for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_previewbutton">
		<input title="{$alt_previewhowlook}" name="preview" xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_previewbutton"/>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/ADDENTRY" mode="c_addarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/ADDENTRY
	Purpose:	 Calls the container for the ADDENTRY button for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FUNCTIONS/ADDENTRY" mode="c_addarticle">
		<xsl:apply-templates select="." mode="r_addarticle"/>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/UPDATE" mode="c_updatearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/UPDATE
	Purpose:	 Calls the container for the UPDATE button for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FUNCTIONS/UPDATE" mode="c_updatearticle">
		<xsl:apply-templates select="." mode="r_updatearticle"/>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/ADDENTRY" mode="r_addarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/ADDENTRY
	Purpose:	 Creates the ADDENTRY button for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FUNCTIONS/ADDENTRY" mode="r_addarticle">
		<input name="addentry" xsl:use-attribute-sets="iADDENTRY_r_addarticle">
			<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD[.='1']"><xsl:value-of select="$m_addintroduction"/></xsl:when><xsl:otherwise><xsl:value-of select="$m_addguideentry"/></xsl:otherwise></xsl:choose></xsl:attribute>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/UPDATE" mode="r_updatearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/UPDATE
	Purpose:	 Creates the UPDATE button for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FUNCTIONS/UPDATE" mode="r_updatearticle">
		<input name="update" xsl:use-attribute-sets="iUPDATE_r_updatearticle">
			<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD[.='1']"><xsl:value-of select="$m_updateintroduction"/></xsl:when><xsl:otherwise><xsl:value-of select="$m_updateentry"/></xsl:otherwise></xsl:choose></xsl:attribute>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="STATUS" mode="c_articlestatus">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/STATUS
	Purpose:	 Calls the STATUS container (if allowed) for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="STATUS" mode="c_articlestatus">
		<xsl:if test="$test_IsEditor or ($superuser=1)">
			<xsl:apply-templates select="." mode="r_articlestatus"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EDITORID" mode="c_articleeditor">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/EDITORID
	Purpose:	 Calls the EDITORID container (if allowed) for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="EDITORID" mode="c_articleeditor">
		<xsl:if test="$test_IsEditor or ($superuser=1)">
			<xsl:apply-templates select="." mode="r_articleeditor"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM/STATUS" mode="r_articlestatus">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/STATUS
	Purpose:	 Creates the STATUS input area for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM/STATUS" mode="r_articlestatus">
		<input type="text" name="status" value="{.}" maxlength="5" xsl:use-attribute-sets="iSTATUS_r_articlestatus"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM/EDITORID" mode="r_articleeditor">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/EDITORID
	Purpose:	 Creates the EDITOR input area for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM/EDITORID" mode="r_articleeditor">
		<input type="text" name="editor" value="{.}" maxlength="15" xsl:use-attribute-sets="iEDITORID_r_articleeditor"/>
	</xsl:template>
	<!--
	<xsl:template match="HIDE" mode="c_hidearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/HIDE
	Purpose:	 Calls the HIDE container for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="HIDE" mode="c_hidearticle">
		<xsl:apply-templates select="." mode="r_hidearticle"/>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/HIDE" mode="r_hidearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/HIDE
	Purpose:	 Creates the HIDE input area for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FUNCTIONS/HIDE" mode="r_hidearticle">
		<input type="checkbox" name="Hide" value="1" xsl:use-attribute-sets="iHIDE_r_hidearticle">
			<xsl:if test="number(HIDDEN) = 1">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="SUBMITTABLE" mode="c_changesubmittable">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/CHANGE-SUBMITTABLE
	Purpose:	 Calls the CHANGE-SUBMITTABLE container for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="SUBMITTABLE" mode="c_changesubmittable">
		<xsl:if test="../FUNCTIONS/CHANGE-SUBMITTABLE">
			<xsl:apply-templates select="." mode="r_changesubmittable"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SUBMITTABLE" mode="r_changesubmittable">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/CHANGE-SUBMITTABLE
	Purpose:	 Creates the CHANGE-SUBMITTABLE input area for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="SUBMITTABLE" mode="r_changesubmittable">
		<input type="CHECKBOX" name="NotForReview" value="1" xsl:use-attribute-sets="iSUBMITTABLE_r_changesubmittable">
			<xsl:if test="number(.) = 0">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
		<input type="HIDDEN" name="CanSubmit" value="1"/>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="c_guidemlorother">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FORMAT
	Purpose:	 Calls the FORMAT (GuideML or text) container for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FORMAT" mode="c_guidemlorother">
		<xsl:apply-templates select="." mode="r_guidemlorother"/>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="t_submitreformat">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FORMAT
	Purpose:	 Creates the FORMAT submit button for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FORMAT" mode="t_submitreformat">
		<input type="submit" name="reformat" value="{$m_changestyle}" xsl:use-attribute-sets="iFORMAT_t_submitreformat"/>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="c_formatbuttons">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FORMAT
	Purpose:	 Calls the correct FORMAT buttons for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FORMAT" mode="c_formatbuttons">
		<xsl:choose>
			<xsl:when test='.="1"'>
				<xsl:apply-templates select="." mode="guideml_formatbuttons"/>
			</xsl:when>
			<xsl:when test='.="2"'>
				<xsl:apply-templates select="." mode="text_formatbuttons"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="guideml_formatbuttons">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FORMAT
	Purpose:	 Creates the GuideML FORMAT buttons for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FORMAT" mode="guideml_formatbuttons">
		<input type="radio" name="newformat" value="2" xsl:use-attribute-sets="iFORMAT_r_formatbuttons"/>
		<xsl:value-of select="$m_plaintext"/>
		<input type="radio" name="newformat" value="1" checked="yes" xsl:use-attribute-sets="iFORMAT_r_formatbuttons"/>
		<xsl:value-of select="$m_guideml"/>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="text_formatbuttons">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FORMAT
	Purpose:	 Creates the text FORMAT buttons for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="FORMAT" mode="text_formatbuttons">
		<input type="radio" name="newformat" value="2" checked="yes" xsl:use-attribute-sets="iFORMAT_r_formatbuttons"/>
		<xsl:value-of select="$m_plaintext"/>
		<input type="radio" name="newformat" value="1" xsl:use-attribute-sets="iFORMAT_r_formatbuttons"/>
		<xsl:value-of select="$m_guideml"/>
	</xsl:template>
	<!--
	<xsl:template match="HELP" mode="c_helplink">
	Author:		Tom Whitehouse
	Context:      /H2G2/HELP
	Purpose:	 Calls the HELP link container
	-->
	<xsl:template match="HELP" mode="c_helplink">
		<xsl:apply-templates select="." mode="r_helplink"/>
	</xsl:template>
	<!--
	<xsl:template match="HELP" mode="r_helplink">
	Author:		Tom Whitehouse
	Context:      /H2G2/HELP
	Purpose:	 Creates the HELP link
	-->
	<xsl:template match="HELP" mode="r_helplink">
		<a xsl:use-attribute-sets="mHELP_WritingGE">
			<xsl:attribute name="HREF"><xsl:choose><xsl:when test="/H2G2/HELP[@TOPIC='GuideML']"><xsl:value-of select="$m_WritingGuideMLHelpLink"/></xsl:when><xsl:when test="/H2G2/HELP[@TOPIC='PlainText']"><xsl:value-of select="$m_WritingPlainTextHelpLink"/></xsl:when></xsl:choose></xsl:attribute>
			<xsl:copy-of select="$alt_clickherehelpentry"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="c_researchers">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST
	Purpose:	 Calls the USER-LIST container if it is needed
	-->
	<xsl:template match="USER-LIST" mode="c_researchers">
		<xsl:if test="$test_ShowResearchers">
			<xsl:apply-templates select="." mode="r_researchers"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_showresearcher">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST/USER
	Purpose:	 Calls the USER container for the list of researchers
	-->
	<xsl:template match="USER" mode="c_showresearcher">
		<xsl:apply-templates select="." mode="r_showresearcher"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_showresearcher">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST/USER
	Purpose:	 Creates the USER text for the list of researchers
	-->
	<xsl:variable name="MaxUsernameChars">20</xsl:variable>
	<xsl:template match="USER" mode="r_showresearcher">
		<xsl:choose>
			<xsl:when test="string-length(USERNAME) &gt; $MaxUsernameChars">
				<xsl:value-of select="substring(USERNAME, 1, $MaxUsernameChars - 3)"/>...
					</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="USERNAME"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="c_editresearchers">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST
	Purpose:	 Calls the USER-LIST container for the editable list if it is needed
	-->
	<xsl:template match="USER-LIST" mode="c_editresearchers">
		<xsl:if test="$test_ShowResearchers">
			<xsl:apply-templates select="." mode="r_editresearchers"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_editresearcher">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST/USER
	Purpose:	 Calls the USER container for the editable list of researchers
	-->
	<xsl:template match="USER" mode="c_editresearcher">
		<xsl:apply-templates select="." mode="r_editresearcher"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_editresearcher">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/RESEARCHERS/USER-LIST/USER
	Purpose:	 Creates the USER text for the editable list of researchers
	-->
	<xsl:template match="USER" mode="r_editresearcher">
		<xsl:value-of select="USERID"/>
	</xsl:template>
	<!--
	<xsl:template match="DELETE" mode="c_deletearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/DELETE
	Purpose:	 Creates the DELETE form element and submit button container
	-->
	<xsl:template match="DELETE" mode="c_deletearticle">
		<form method="post" action="{$root}Edit" xsl:use-attribute-sets="fDELETE_c_deletearticle">
		  <xsl:attribute name="onsubmit">return confirm('<xsl:value-of select="$m_ConfirmDeleteEntry"/>')</xsl:attribute>
			<input type="hidden" name="id" value="{../../H2G2ID}"/>
			<input type="hidden" name="masthead" value="{../../MASTHEAD}"/>
			<input type="hidden" name="cmd" value="delete"/>
			<xsl:apply-templates select="." mode="r_deletearticle"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/DELETE" mode="r_deletearticle">|
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/DELETE
	Purpose:	 Creates the DELETE submit button
	-->
	<xsl:template match="FUNCTIONS/DELETE" mode="r_deletearticle">|
		<input name="button" xsl:use-attribute-sets="iDELETE_r_deletearticle"/>
	</xsl:template>
	<xsl:attribute-set name="fARTICLE-EDIT-FORM_c_form"/>
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_subjectbox"/>
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_bodybox"/>
	<xsl:attribute-set name="sARTICLE-EDIT-FORM_t_selectskin"/>
	<xsl:attribute-set name="oARTICLE-EDIT-FORM_t_selectskin"/>
	<xsl:attribute-set name="sSITEID_t_movetositelist"/>
	<xsl:attribute-set name="oSITEID_t_movetositelist"/>
	<xsl:attribute-set name="iSITEID_t_movetositesubmit"/>
	<xsl:attribute-set name="iUSER-LIST_t_submitsetresearchers"/>
	<xsl:attribute-set name="iUSER-LIST_t_setresearcherscontent"/>
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_previewbutton"/>
	<xsl:attribute-set name="iADDENTRY_r_addarticle"/>
	<xsl:attribute-set name="iUPDATE_r_updatearticle"/>
	<xsl:attribute-set name="iSTATUS_r_articlestatus"/>
	<xsl:attribute-set name="iEDITORID_r_articleeditor"/>
	<xsl:attribute-set name="iHIDE_r_hidearticle"/>
	<xsl:attribute-set name="iSUBMITTABLE_r_changesubmittable"/>
	<xsl:attribute-set name="iFORMAT_t_submitreformat"/>
	<xsl:attribute-set name="iFORMATbuttons"/>
	<xsl:attribute-set name="iFORMAT_r_formatbuttons"/>
	<xsl:attribute-set name="fDELETE_c_deletearticle"/>
	<xsl:attribute-set name="iDELETE_r_deletearticle">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">delete this article</xsl:attribute>
	</xsl:attribute-set>
	
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_makearchive">
	Author:		Wendy Mann
	Context:      /H2G2/ARTICLE-EDIT-FORM/
	Purpose:	Calls the make an archive checkbox
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="c_makearchive">
		<xsl:if test="$test_IsEditor or ($superuser=1)">
			<xsl:apply-templates select="." mode="r_makearchive"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_makearchive">
	Author:		Wendy Mann
	Context:     	 /H2G2/ARTICLE-EDIT-FORM/
	Purpose:	 Creates the ARCHIVE checkbox and the hidden field for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="t_makearchive">
	<input type="hidden" name="changearchive" value="1" />
	<xsl:choose>
	<xsl:when test="ARCHIVE=1">
			<input type="radio" name="archive" value="1" xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_makearchive" checked="checked" /> Yes 
			<input type="radio" name="archive" value="0" xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_makearchive" /> No				
	</xsl:when>
	<xsl:otherwise>
			<input type="radio" name="archive" value="1" xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_makearchive" /> Yes 
			<input type="radio" name="archive" value="0" xsl:use-attribute-sets="iARTICLE-EDIT-FORM_t_makearchive" checked="checked" /> No		
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_makearchive"/>
</xsl:stylesheet>
