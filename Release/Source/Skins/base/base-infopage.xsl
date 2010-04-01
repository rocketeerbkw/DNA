<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="INFO_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="INFO_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_interestingfacts"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="INFO_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="INFO_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_h2g2stats"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="INFO" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO
	Purpose:	 Calls the container for the INFO object
	-->
	<xsl:template match="INFO" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTERS" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/PROLIFICPOSTERS
	Purpose:	 Checks to see if there are any PROLIFICPOSTERS
	-->
	<xsl:template match="PROLIFICPOSTERS" mode="c_info">
		<xsl:choose>
			<xsl:when test="PROLIFICPOSTER">
				<xsl:apply-templates select="." mode="r_info"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_noposters"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTER" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/PROLIFICPOSTERS/PROLIFICPOSTER
	Purpose:	 Calls the container for the PROLIFICPOSTER object
	-->
	<xsl:template match="PROLIFICPOSTER" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<!--
	<xsl:template match="COUNT" mode="t_average_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/PROLIFICPOSTERS/PROLIFICPOSTER/COUNT
	Purpose:	 Checks to see if the PROLIFICPOSTER has posted more than one post 
	-->
	<xsl:template match="COUNT" mode="t_average">
		<xsl:choose>
			<xsl:when test="number(.) = 1">
				<xsl:value-of select="$m_postaverage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_postsaverage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTERS" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/ERUDITEPOSTERS
	Purpose:	 Checks to see if there are any ERUDITEPOSTERS
	-->
	<xsl:template match="ERUDITEPOSTERS" mode="c_info">
		<xsl:choose>
			<xsl:when test="ERUDITEPOSTER">
				<xsl:apply-templates select="." mode="r_info"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_noposters"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTER" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/ERUDITEPOSTERS/ERUDITEPOSTER
	Purpose:	 Calls the container for the ERUDITEPOSTER object
	-->
	<xsl:template match="ERUDITEPOSTER" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/ERUDITEPOSTERS/ERUDITEPOSTER/ERUDITEPOSTER/USER
	Purpose:	 Creates the link to the USERs userpage
	-->
	<xsl:template match="USER" mode="t_info">
		<a href="{$root}U{./USERID}" xsl:use-attribute-sets="mUSER_t_info">
			<!-- <xsl:value-of select="./USERNAME"/> -->
			<xsl:apply-templates select="." mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATIONS" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/RECENTCONVERSATIONS
	Purpose:	 Checks to see if there are any RECENTCONVERSATIONS
	-->
	<xsl:template match="RECENTCONVERSATIONS" mode="c_info">
		<xsl:choose>
			<xsl:when test="RECENTCONVERSATION">
				<xsl:apply-templates select="." mode="r_info"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_nothreads"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATION" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/RECENTCONVERSATIONS/RECENTCONVERSATION
	Purpose:	 Calls the container for the RECENTCONVERSATION object
	-->
	<xsl:template match="RECENTCONVERSATION" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATION" mode="t_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/RECENTCONVERSATIONS/RECENTCONVERSATION
	Purpose:	 Creates the link to the conversation using the FIRSTSUBJECT
	-->
	<xsl:template match="RECENTCONVERSATION" mode="t_info">
		<a href="{$root}F{FORUMID}?thread={THREADID}" xsl:use-attribute-sets="mRECENTCONVERSATION_t_info">
			<xsl:value-of select="FIRSTSUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FRESHESTARTICLES" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/FRESHESTARTICLES
	Purpose:	 Checks to see if there are any RECENTARTICLEs
	-->
	<xsl:template match="FRESHESTARTICLES" mode="c_info">
		<xsl:choose>
			<xsl:when test="RECENTARTICLE">
				<xsl:apply-templates select="." mode="r_info"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_noarticles"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="RECENTARTICLE" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/FRESHESTARTICLES/RECENTARTICLE
	Purpose:	 Calls the container for the RECENTARTICLE object
	-->
	<xsl:template match="RECENTARTICLE" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENTARTICLE" mode="t_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/FRESHESTARTICLES/RECENTARTICLE
	Purpose:	 Creates the link to the RECENTARTICLE using the SUBJECT
	-->
	<xsl:template match="RECENTARTICLE" mode="t_info">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mRECENTARTICLE_t_info">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="STATUS" mode="t_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/FRESHESTARTICLES/RECENTARTICLE/STATUS
	Purpose:	 Chooses the correct STATUS text
	-->
	<xsl:template match="STATUS" mode="t_info">
		<xsl:choose>
			<xsl:when test=".='1'">
				<xsl:value-of select="$m_edited"/>
			</xsl:when>
			<xsl:when test=".='3'">
				<xsl:value-of select="$m_unedited"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_info">
	Author:		Andy Harris
	Context:      /H2G2/INFO/FRESHESTARTICLES//RECENTARTICLE/DATEUPDATED/DATE
	Purpose:	 Creates the DATE text
	-->
	<xsl:template match="DATE" mode="t_info">
		<xsl:apply-templates select="."/>
	</xsl:template>
</xsl:stylesheet>
