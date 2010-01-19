<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="NOTICEBOARDLIST_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:variable name="m_noticeboardlist">
	Noticeboard list
	</xsl:variable>
	<xsl:variable name="m_noticeboardlistpagesubject">
	Noticeboard list
	</xsl:variable>
	<xsl:template name="NOTICEBOARDLIST_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_noticeboardlist"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="NOTICEBOARDLIST_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<!--xsl:template name="NOTICEBOARDLIST_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_noticeboardlistpagesubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template-->
	<xsl:template match="NOTICEBOARDLIST" mode="c_noticeboardlist">
		<xsl:apply-templates select="." mode="r_noticeboardlist"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_noticeboardlist">
		<xsl:apply-templates select="." mode="r_noticeboardlist"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_location">
		<xsl:apply-templates select="." mode="r_location"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_members">
		<xsl:apply-templates select="." mode="r_members"/>
	</xsl:template>
	<xsl:template match="NOTICEBOARD" mode="c_notices">
		<xsl:apply-templates select="." mode="r_notices"/>
	</xsl:template>
	<xsl:template match="NOTICES" mode="c_notice">
		<xsl:apply-templates select="." mode="r_notice"/>
	</xsl:template>
	<xsl:template match="NOTICE" mode="c_notice">
		<xsl:apply-templates select="." mode="r_notice"/>
	</xsl:template>
	
	<xsl:template match="NOTICEBOARDLIST" mode="c_previouspage">
	<xsl:choose>
			<xsl:when test="@SKIP = 0">
				<xsl:apply-templates select="." mode="text_previouspage"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:apply-templates select="." mode="link_previouspage"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	
	<xsl:template match="NOTICEBOARDLIST" mode="c_nextpage">
		<xsl:choose>
			<xsl:when test="number(@SKIP) + number(@SHOW) &lt; @TOTAL">

				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextpage"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>
