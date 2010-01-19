<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="SEARCH_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="SEARCH_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:choose>
					<xsl:when test="not(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM = '')">
						<xsl:value-of select="$m_searchresultstitle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_searchpagetitle"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="SEARCH_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SEARCH_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="not(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM = '')">
						<xsl:value-of select="$m_searchresultstitle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_searchpagetitle"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="SEARCH" mode="c_searchform">
		<form method="get" action="{$root}Search" name="advsearch" xsl:use-attribute-sets="mSEARCH_c_searchform">
			<xsl:apply-templates select="." mode="r_searchform"/>
		</form>
	</xsl:template>
	<xsl:template match="SEARCH" mode="c_searchtype">
		<xsl:apply-templates select="." mode="r_searchtype"/>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_searcharticles">
		<input name="searchtype" value="article" type="radio" xsl:use-attribute-sets="mSEARCH_t_searcharticles">
			<xsl:if test="SEARCHRESULTS/@TYPE = 'ARTICLE' or FUNCTIONALITY/SEARCHARTICLES/@SELECTED = 1">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_searchusers">
		<input name="searchtype" value="user" type="radio" xsl:use-attribute-sets="mSEARCH_t_searchusers">
			<xsl:if test="SEARCHRESULTS/@TYPE = 'USER'">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_searchforums">
		<input name="searchtype" value="forum" type="radio" xsl:use-attribute-sets="mSEARCH_t_searchforums">
			<xsl:if test="SEARCHRESULTS/@TYPE = 'FORUM'">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="SEARCH" mode="c_resultstype">
		<xsl:apply-templates select="." mode="r_resultstype"/>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_allarticles">
		<input type="checkbox" value="1" name="shownormal" xsl:use-attribute-sets="mSEARCH_t_allarticles">
			<xsl:if test="FUNCTIONALITY/SEARCHARTICLES/@SELECTED = 1 and FUNCTIONALITY/SEARCHARTICLES/SHOWNORMAL = 1">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_submittedarticles">
		<input type="checkbox" value="1" name="showsubmitted" xsl:use-attribute-sets="mSEARCH_t_submittedarticles">
			<xsl:if test="FUNCTIONALITY/SEARCHARTICLES/@SELECTED = 1 and FUNCTIONALITY/SEARCHARTICLES/SHOWSUBMITTED = 1">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_editedarticles">
		<input type="checkbox" value="1" name="showapproved" xsl:use-attribute-sets="mSEARCH_t_editedarticles">
			<xsl:if test="FUNCTIONALITY/SEARCHARTICLES/@SELECTED = 1 and FUNCTIONALITY/SEARCHARTICLES/SHOWAPPROVED = 1">
				<xsl:attribute name="checked">1</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_searchinput">
		<input type="text" name="searchstring" xsl:use-attribute-sets="mSEARCH_t_searchinput"/>
	</xsl:template>
	<xsl:template match="SEARCH" mode="t_searchsubmit">
		<input name="dosearch" value="Search the Guide" border="0" xsl:use-attribute-sets="mSEARCH_t_searchsubmit"/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_c_searchform"/>
	<xsl:attribute-set name="mSEARCH_t_searcharticles"/>
	<xsl:attribute-set name="mSEARCH_t_searchusers"/>
	<xsl:attribute-set name="mSEARCH_t_searchforums"/>
	<xsl:attribute-set name="mSEARCH_t_allarticles"/>
	<xsl:attribute-set name="mSEARCH_t_submittedarticles"/>
	<xsl:attribute-set name="mSEARCH_t_editedarticles"/>
	<xsl:attribute-set name="mSEARCH_t_searchinput"/>
	<xsl:attribute-set name="mSEARCH_t_searchsubmit"/>
	<xsl:template match="SEARCHRESULTS" mode="c_search">
		<xsl:if test="SEARCHTERM">
			<xsl:choose>
				<xsl:when test="ARTICLERESULT or USERRESULT or FORUMRESULT or HIERARCHYRESULT">
					<xsl:apply-templates select="." mode="results_search"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="noresults_search"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SKIP" mode="c_previous">
		<xsl:choose>
			<xsl:when test="(. &gt; 0)">
				<xsl:apply-templates select="." mode="link_previous"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="nolink_previous"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="SKIP" mode="link_previous">
		<a xsl:use-attribute-sets="mSKIP_link_previous">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>Search?searchstring=<xsl:value-of select="../SAFESEARCHTERM"/>&amp;searchtype=<xsl:value-of select="../@TYPE"/>&amp;skip=<xsl:value-of select="number(.) - number(../COUNT)"/>&amp;show=<xsl:value-of select="../COUNT"/><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if></xsl:attribute>
			<xsl:value-of select="$m_prevresults"/>
		</a>
	</xsl:template>
	<xsl:template match="MORE" mode="c_more">
		<xsl:choose>
			<xsl:when test=". = 1">
				<xsl:apply-templates select="." mode="link_more"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="nolink_more"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="MORE" mode="link_more">
		<a xsl:use-attribute-sets="mMORE_link_more">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>Search?searchstring=<xsl:value-of select="../SAFESEARCHTERM"/>&amp;searchtype=<xsl:value-of select="../@TYPE"/>&amp;skip=<xsl:value-of select="number(../SKIP) + number(../COUNT)"/>&amp;show=<xsl:value-of select="../COUNT"/><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if><xsl:if test="../../FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if></xsl:attribute>
			<xsl:value-of select="$m_nextresults"/>
		</a>
	</xsl:template>
	<xsl:template match="ARTICLERESULT" mode="c_search">
		<xsl:apply-templates select="." mode="r_search"/>
	</xsl:template>
	<xsl:template match="SUBJECT" mode="t_subjectlink">
		<a href="{$root}A{../H2G2ID}" xsl:use-attribute-sets="mSUBJECT_t_subjectlink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="STATUS" mode="t_articlestatus">
		<xsl:choose>
			<xsl:when test=".=1">
				<xsl:value-of select="$m_EditedEntryStatusName"/>
			</xsl:when>
			<xsl:when test=".=9">
				<xsl:value-of select="$m_HelpPageStatusName"/>
			</xsl:when>
			<xsl:when test=".=4 or .=6 or .=11 or .=12 or .=13">
				<xsl:value-of select="$m_RecommendedEntryStatusName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_NormalEntryStatusName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="USERRESULT" mode="c_search">
		<xsl:apply-templates select="." mode="r_search"/>
	</xsl:template>
	<xsl:template match="USERNAME" mode="t_userlink">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_t_userlink"/>
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="FORUMRESULT" mode="c_search">
		<xsl:apply-templates select="." mode="r_search"/>
	</xsl:template>
	<xsl:template match="SUBJECT" mode="t_postlink">
		<a href="{$root}F{../FORUMID}?thread={../THREADID}&amp;post={../POSTID}#p{../POSTID}" xsl:use-attribute-sets="mSUBJECT_t_postlink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mSUBJECT_t_subjectlink"/>
	<xsl:attribute-set name="mUSERNAME_t_userlink"/>
	<xsl:attribute-set name="mSUBJECT_t_postlink"/>
	<xsl:attribute-set name="mSKIP_link_previous"/>
	<xsl:attribute-set name="mMORE_link_more"/>
</xsl:stylesheet>
