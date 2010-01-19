<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="TEAMLIST_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="TEAMLIST_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_teamlist"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="TEAMLIST_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="TEAMLIST_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_teamlist"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="c_teamlist">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Calls the correct container for the TEAMLIST object
	-->
	<xsl:template match="TEAMLIST" mode="c_teamlist">
		<xsl:apply-templates select="." mode="r_teamlist"/>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="t_clubname">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Creates the clubname link
	-->
	<xsl:template match="TEAMLIST" mode="t_clubname">
		<a href="{$root}G{CLUBINFO/@ID}" xsl:use-attribute-sets="mTEAMLIST_t_clubname">
			<xsl:value-of select="CLUBINFO/NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="c_teamlist">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST/TEAM
	Purpose:	 Calls the TEAM object container
	-->
	<xsl:template match="TEAM" mode="c_teamlist">
		<xsl:apply-templates select="." mode="r_teamlist"/>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="t_introduction">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST/TEAM
	Purpose:	 Creates the correct introductory text for the team
	-->
	<xsl:template match="TEAM" mode="t_introduction">
		<xsl:choose>
			<xsl:when test="@TYPE='MEMBER'">
				<xsl:copy-of select="$m_memberintro"/>
			</xsl:when>
			<xsl:when test="@TYPE='OWNER'">
				<xsl:copy-of select="$m_ownerintro"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="c_teamlist">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST/TEAM/MEMBER
	Purpose:	 Calls the container for the MEMBER object
	-->
	<xsl:template match="MEMBER" mode="c_teamlist">
		<xsl:apply-templates select="." mode="r_teamlist"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_username">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST/TEAM/MEMBER/USER
	Purpose:	 Creates the USER link
	-->
	<xsl:template match="USER" mode="t_username">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_username">
			<xsl:choose>
				<xsl:when test="not(USERNAME = '')">
					<xsl:value-of select="USERNAME"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$m_nousername"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="c_role">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST/TEAM/MEMBER/ROLE
	Purpose:	 Calls the container for the ROLE text if the user has one
	-->
	<xsl:template match="MEMBER" mode="c_role">
		<xsl:if test="ROLE">
			<xsl:apply-templates select="." mode="r_role"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="c_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Calls the correct container for the 'Previous page' link
	-->
	<xsl:template match="TEAMLIST" mode="c_previouspage">
		<xsl:choose>
			<xsl:when test="not(TEAM/@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_previouspage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_previouspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="c_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Calls the correct container for the 'Next page' link
	-->
	<xsl:template match="TEAMLIST" mode="c_nextpage">
		<xsl:choose>
			<xsl:when test="number(TEAM/@SKIPTO) + number(TEAM/@COUNT) &lt; TEAM/@TOTALMEMBERS">
				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="link_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Creates the 'Previous page' link
	-->
	<xsl:template match="TEAMLIST" mode="link_previouspage">
		<a href="{$root}Teamlist?id={TEAM/@ID}&amp;show={TEAM/@COUNT}&amp;skip={number(TEAM/@SKIPTO) - number(TEAM/@COUNT)}" xsl:use-attribute-sets="mTEAMLIST_link_previouspage">
			<xsl:copy-of select="$m_previousteammembers"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="link_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Creates the 'Next page' link
	-->
	<xsl:template match="TEAMLIST" mode="link_nextpage">
		<a href="{$root}Teamlist?id={TEAM/@ID}&amp;show={TEAM/@COUNT}&amp;skip={number(TEAM/@SKIPTO) + number(TEAM/@COUNT)}" xsl:use-attribute-sets="mTEAMLIST_link_nextpage">
			<xsl:copy-of select="$m_nextteammembers"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="text_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Creates the 'No previous page' text
	-->
	<xsl:template match="TEAMLIST" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviousteammembers"/>
	</xsl:template>
	<!--
	<xsl:template match="TEAMLIST" mode="text_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/TEAMLIST
	Purpose:	 Creates the 'No next page' text
	-->
	<xsl:template match="TEAMLIST" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextteammembers"/>
	</xsl:template>
</xsl:stylesheet>
