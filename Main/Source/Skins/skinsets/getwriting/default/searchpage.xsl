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
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">searchpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		
	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->



	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
<!-- <xsl:apply-templates select="SEARCH" mode="c_searchform"/> -->
	<xsl:apply-templates select="SEARCH/SEARCHRESULTS" mode="c_search"/>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
		
	</xsl:element>
	</tr>
	</xsl:element>
<!-- end of table -->	

		<!-- SEARCHBOX -->
	<div class="searchback">
	<table cellspacing="0" cellpadding="0" border="0">
	<tr>
	<td rowspan="2" valign="top"><xsl:copy-of select="$icon.browse.brown" /></td>
	<td colspan="4">
	<div class="heading1">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Advanced Search
	</xsl:element>
	</div>
	
	<div class="searchtext">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Search the writing categories by keyword, user name, title or genre (e.g. poetry, scripts, etc.)
	</xsl:element>
	</div>
	</td>
	</tr>
	<tr>
	<td>
	<div class="searchtext">
	<label for="category-search">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">i am searching for:&nbsp;
	</xsl:element>
	</label>
	</div>
	</td>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:call-template name="c_search_dna" />
	</xsl:element>
	</td>
	</tr>
	</table>
	</div>


	
	<!-- removed for site pulldown -->
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
	<div class="PageContent">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:copy-of select="$m_searchresultstitle"/></strong>
		<hr class="line" />
		<xsl:copy-of select="$m_searchresultsfor"/>
		<xsl:text> </xsl:text>
		<strong><xsl:value-of select="SAFESEARCHTERM"/></strong>
		<br/>
		<xsl:value-of select="$m_noresults"/>
	</xsl:element>	
	</div>
	</xsl:template>
	<xsl:template match="SEARCHRESULTS" mode="results_search">
	<div class="PageContent">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:copy-of select="$m_searchresultstitle"/></strong>
		<hr class="line" />
		<xsl:copy-of select="$m_searchresultsfor"/>
		<xsl:text> </xsl:text>
		<strong><xsl:value-of select="SAFESEARCHTERM"/></strong>
		</xsl:element>
		<br/>
		<!-- PREVIOUS - NEXT -->
		<div class="prevnextbox">
		<table width="380" border="0" cellspacing="0" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="SKIP" mode="c_previous"/>
		</xsl:element>
		</td>
		<td align="right">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="MORE" mode="c_more"/>
		</xsl:element>
		</td>
		</tr>
		</table>
		</div>
		
		<div class="box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<xsl:apply-templates select="ARTICLERESULT[PRIMARYSITE=1]" mode="c_search"/>
		<xsl:apply-templates select="USERRESULT" mode="c_search"/>
		<xsl:apply-templates select="FORUMRESULT[PRIMARYSITE=1]" mode="c_search"/>
		</table>
		</div>
		
		<!-- PREVIOUS - NEXT -->
		<div class="prevnextbox">
		<table width="380" border="0" cellspacing="0" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="SKIP" mode="c_previous"/>
		</xsl:element>
		</td>
		<td align="right">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="MORE" mode="c_more"/>
		</xsl:element>
		</td>
		</tr>
		</table>
		</div>
		</div>
		

	</xsl:template>
	
	<xsl:template match="SKIP" mode="nolink_previous">
		<xsl:value-of select="$m_noprevresults"/>
	</xsl:template>
	<xsl:template match="SKIP" mode="link_previous">
	<!-- $m_prevresults -->
		<xsl:copy-of select="$previous.arrow" /><xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="MORE" mode="nolink_more">
		<xsl:value-of select="$m_nomoreresults"/>
	</xsl:template>
	<xsl:template match="MORE" mode="link_more">
	<!-- m_nextresults -->
		<xsl:apply-imports/><xsl:copy-of select="$next.arrow" />
	</xsl:template>
	
	<xsl:template match="ARTICLERESULT" mode="r_search">
	
	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::ARTICLERESULT) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>	
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="SUBJECT" mode="t_subjectlink"/></strong>
		
		</xsl:element>
		
		<xsl:call-template name="article_subtype">
		<xsl:with-param name="status" select="STATUS" />
		</xsl:call-template>
		</td>
		<td align="right">
		<xsl:call-template name="article_selected">
		<xsl:with-param name="status" select="STATUS" />
		</xsl:call-template>
		</td>
	</tr>
		
	</xsl:template>
	
	<xsl:template match="USERRESULT" mode="r_search">
	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::ARTICLERESULT) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>	
		<td>
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="USERNAME" mode="t_userlink"/></strong>
		</xsl:element>
		</td>
	</tr>
	</xsl:template>
	
	<xsl:template match="FORUMRESULT" mode="r_search">
	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::ARTICLERESULT) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>	
		<td>
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="SUBJECT" mode="t_postlink"/></strong><br/>
		</xsl:element>
		</td>
	</tr>		
	</xsl:template>
	
</xsl:stylesheet>
