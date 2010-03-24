<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-searchpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="SEARCH_MAINBODY">
		<xsl:if test="$test_IsEditor = 1">
			<xsl:apply-templates select="SEARCH" mode="c_searchform"/>
			<xsl:apply-templates select="SEARCH/SEARCHRESULTS" mode="c_search"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SEARCH" mode="r_searchform">
		<xsl:apply-templates select="." mode="c_searchtype"/>
		<xsl:apply-templates select="." mode="c_resultstype"/>
		<xsl:apply-templates select="." mode="t_searchinput"/>
		<xsl:apply-templates select="." mode="t_searchsubmit"/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_c_searchform"/>
	<xsl:attribute-set name="mSEARCH_t_searchinput"/>
	<xsl:attribute-set name="mSEARCH_t_searchsubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="SEARCH" mode="r_searchtype">
		<xsl:copy-of select="$m_searcharticles"/>
		<xsl:apply-templates select="." mode="t_searcharticles"/>
		<br/>
		<xsl:copy-of select="$m_searchusers"/>
		<xsl:apply-templates select="." mode="t_searchusers"/>
		<br/>
		<xsl:copy-of select="$m_searchuserforums"/>
		<xsl:apply-templates select="." mode="t_searchforums"/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_t_searcharticles">
		<xsl:attribute name="onclick">document.advsearch.showapproved.disabled=false; document.advsearch.showsubmitted.disabled=false; document.advsearch.shownormal.disabled=false;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_searchusers">
		<xsl:attribute name="onclick">document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true; document.advsearch.shownormal.disabled=true;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_searchforums">
		<xsl:attribute name="onclick">document.advsearch.showapproved.disabled=true; document.advsearch.showsubmitted.disabled=true; document.advsearch.shownormal.disabled=true;</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="SEARCH" mode="r_resultstype">
		<xsl:copy-of select="$m_allresults"/>
		<xsl:apply-templates select="." mode="t_allarticles"/>
		<br/>
		<xsl:copy-of select="$m_recommendedresults"/>
		<xsl:apply-templates select="." mode="t_submittedarticles"/>
		<br/>
		<xsl:copy-of select="$m_editedresults"/>
		<xsl:apply-templates select="." mode="t_editedarticles"/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:attribute-set name="mSEARCH_t_allarticles">
		<xsl:attribute name="checked">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_submittedarticles">
		<xsl:attribute name="checked">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mSEARCH_t_editedarticles">
		<xsl:attribute name="checked">1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="SEARCHRESULTS" mode="noresults_search">
		<strong>
			<xsl:copy-of select="$m_searchresultstitle"/>
		</strong>
		<br/>
		<xsl:copy-of select="$m_searchresultsfor"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="SAFESEARCHTERM"/>
		<br/>
		<xsl:value-of select="$m_noresults"/>
	</xsl:template>
	<xsl:template match="SEARCHRESULTS" mode="results_search">
		<strong>
			<xsl:copy-of select="$m_searchresultstitle"/>
		</strong>
		<br/>
		<xsl:copy-of select="$m_searchresultsfor"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="SAFESEARCHTERM"/>
		<br/>
		<xsl:apply-templates select="ARTICLERESULT" mode="c_search"/>
		<xsl:apply-templates select="USERRESULT" mode="c_search"/>
		<xsl:apply-templates select="FORUMRESULT" mode="c_search"/>
		<xsl:apply-templates select="SKIP" mode="c_previous"/>
		<xsl:apply-templates select="MORE" mode="c_more"/>
	</xsl:template>
	<xsl:template match="SKIP" mode="nolink_previous">
		<xsl:value-of select="$m_noprevresults"/>
	</xsl:template>
	<xsl:template match="SKIP" mode="link_previous">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="MORE" mode="nolink_more">
		<xsl:value-of select="$m_nomoreresults"/>
	</xsl:template>
	<xsl:template match="MORE" mode="link_more">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="ARTICLERESULT" mode="r_search">
		<xsl:apply-templates select="SUBJECT" mode="t_subjectlink"/>
		<br/>
		<xsl:apply-templates select="STATUS" mode="t_articlestatus"/>
		<br/>
		<xsl:value-of select="SCORE"/>%
		<br/>
		<br/>
	</xsl:template>
	<xsl:template match="USERRESULT" mode="r_search">
		<xsl:apply-templates select="USERNAME" mode="t_userlink"/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template match="FORUMRESULT" mode="r_search">
		<xsl:apply-templates select="SUBJECT" mode="t_postlink"/>
		<br/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
