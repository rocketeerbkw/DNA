<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="SUBMITREVIEWFORUM_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="SUBMITREVIEWFORUM_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_submitreviewforumheader"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="SUBMITREVIEWFORUM_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SUBMITREVIEWFORUM_SUBJECT">
		<xsl:choose>
			<xsl:when test="SUBMIT-REVIEW-FORUM/ERROR">
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:value-of select="$m_errorsubject"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="SUBMIT-REVIEW-FORUM/MOVEDTHREAD">
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:value-of select="$m_removefromreviewforumsubject"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="SUBMIT-REVIEW-FORUM/NEW-THREAD">
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:value-of select="$m_entrysubmittoreviewforumsubject"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:value-of select="$m_submitreviewforumsubject"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="c_srfpage">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM
	Purpose:	 Calls the correct container for the SUBMIT-REVIEW-FORUM object
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="c_srfpage">
		<xsl:choose>
			<xsl:when test="REVIEWFORUMS">
				<xsl:apply-templates select="." mode="reviewforums_srfpage"/>
			</xsl:when>
			<xsl:when test="NEW-THREAD">
				<xsl:apply-templates select="." mode="newthread_srfpage"/>
			</xsl:when>
			<xsl:when test="ERROR">
				<xsl:apply-templates select="." mode="error_srfpage"/>
			</xsl:when>
			<xsl:when test="MOVEDTHREAD">
				<xsl:apply-templates select="." mode="movedthread_srfpage"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="c_errormessage">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/ERROR
	Purpose:	 Calls the container for the ERROR object if there is one
	-->
	<xsl:template match="ERROR" mode="c_errormessage">
		<xsl:apply-templates select="." mode="r_errormessage"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_errormessage">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/ERROR
	Purpose:	 Creates the displayed ERROR message
	-->
	<xsl:template match="ERROR" mode="r_errormessage">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="c_submitform">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM
	Purpose:	 Calls the container for the form object
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="c_submitform">
		<form method="POST" action="{$root}SubmitReviewForum" xsl:use-attribute-sets="fSUBMIT-REVIEW-FORUM_c_submitform">
			<input type="HIDDEN" name="action" value="submitarticle"/>
			<input type="HIDDEN" name="h2g2id" value="{../ARTICLE/@H2G2ID}"/>
			<xsl:apply-templates select="." mode="r_submitform"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMS" mode="t_forumselect">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/REVIEWFORUMS
	Purpose:	 Creates the select review forum dropdown
	-->
	<xsl:template match="REVIEWFORUMS" mode="t_forumselect">
		<select name="reviewforumid" xsl:use-attribute-sets="sREVIEWFORUMS_t_forumselect">
			<option value="{FORUMNAME/@ID}" xsl:use-attribute-sets="oREVIEWFORUMS_t_forumselect">
				<xsl:value-of select="$m_dropdownpleasechooseone"/>
			</option>
			<option value="{FORUMNAME/@ID}" xsl:use-attribute-sets="oREVIEWFORUMS_t_forumselect">-----------------</option>
			<xsl:for-each select="FORUMNAME">
				<xsl:sort select="."/>
				<option value="{@ID}" xsl:use-attribute-sets="oREVIEWFORUMS_t_forumselect">
					<xsl:if test="@SELECTED">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="."/>
				</option>
			</xsl:for-each>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="t_responsetext">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM
	Purpose:	 Creates the response textarea
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="t_responsetext">
		<textarea name="response" xsl:use-attribute-sets="iSUBMIT-REVIEW-FORUM_t_responsetext">
			<xsl:value-of select="COMMENTS"/>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="t_submit">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM
	Purpose:	 Creates the submit button
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="t_submit">
		<input name="submit" xsl:use-attribute-sets="iSUBMIT-REVIEW-FORUM_t_submit"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="c_srfpage">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/ERROR
	Purpose:	 Calls the correct ERROR container
	-->
	<xsl:template match="ERROR" mode="c_srfpage">
		<xsl:choose>
			<xsl:when test="@TYPE='CHANGE-THIS'">
			</xsl:when>
			<xsl:when test="@TYPE='BADH2G2ID'">
				<xsl:apply-templates select="." mode="badh2g2id_error"/>
			</xsl:when>
			<xsl:when test="@TYPE='BADRFID'">
				<xsl:apply-templates select="." mode="badrfid_error"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="default_error"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="t_badh2g2idlink">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/ERROR
	Purpose:	 Creates the link back to the homepage
	-->
	<xsl:template match="ERROR" mode="t_badh2g2idlink">
		<a href="{$root}Frontpage" xsl:use-attribute-sets="mERROR_t_badh2g2idlink">
			Frontpage
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="t_badrfidlink">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/ERROR
	Purpose:	 Creates the link back to the homepage
	-->
	<xsl:template match="ERROR" mode="t_badrfidlink">
		<a href="{$root}Frontpage" xsl:use-attribute-sets="mERROR_t_badrfidlink">
			Frontpage
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="t_default">
	Author:		Andy Harris
	Context:      /H2G2/SUBMIT-REVIEW-FORUM/ERROR
	Purpose:	 Creates a link to leave the error page
	-->
	<xsl:template match="ERROR" mode="t_default">
		<a href="{$root}{LINK/@HREF}" xsl:use-attribute-sets="mERROR_t_defaultlink">
			<xsl:value-of select="LINK"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="fSUBMIT-REVIEW-FORUM_c_submitform"/>
	<xsl:attribute-set name="sREVIEWFORUMS_t_forumselect"/>
	<xsl:attribute-set name="oREVIEWFORUMS_t_forumselect"/>
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_responsetext">
		<xsl:attribute name="cols">15</xsl:attribute>
		<xsl:attribute name="rows">5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_submit">
		<xsl:attribute name="value"><xsl:value-of select="$m_submittoreviewforumbutton"/></xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="title"><xsl:value-of select="$alt_submittoreviewforumbutton"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
