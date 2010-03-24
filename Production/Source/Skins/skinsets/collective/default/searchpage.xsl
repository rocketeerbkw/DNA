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
	<xsl:with-param name="message">SEARCH_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">searchpage.xsl</xsl:with-param>
	</xsl:call-template>
	
	<!-- DEBUG -->
	<!-- CALL FORM -->
	<!-- <div class="searchbox"><xsl:apply-templates select="SEARCH" mode="c_searchform"/></div> -->
	<!-- SEARCHBOX -->
	<div class="generic-u">
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
	<strong>advanced search</strong></xsl:element>
	<table cellspacing="0" cellpadding="0" border="0" width="595"><tr>
	<td><label for="category-search"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong class="brown">i am looking for:&nbsp;</strong></xsl:element></label></td>
	<td><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:call-template name="c_search_dna" /></xsl:element></td>
	<td>&nbsp;</td>
	<td align="right" class="category-b"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><a href="{$root}faqsgettingaround"><img src="{$imagesource}icons/help.gif" width="12" height="14" alt="" border="0" />&nbsp;i need help</a></xsl:element></td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	<td colspan="3" class="white"><xsl:element name="{$text.base}" use-attribute-sets="text.base">e.g. aphex twin, donnie darko, will self, bill viola, elephant, ross noble</xsl:element></td>
	</tr>
	</table>
	<!-- <xsl:apply-templates select="SEARCH" mode="c_searchform"/> -->	
	</div>
	<!-- CALL RESULTS -->
	<xsl:apply-templates select="SEARCH/SEARCHRESULTS" mode="c_search"/>

	<!-- SEARCHBOX -->
	<div class="generic-u">
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
	<strong>advanced search</strong></xsl:element>
	<table cellspacing="0" cellpadding="0" border="0" width="595"><tr>
	<td><label for="category-search"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong class="brown">i am looking for:&nbsp;</strong></xsl:element></label></td>
	<td><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:call-template name="c_search_dna" /></xsl:element></td>
	<td>&nbsp;</td>
	<td align="right" class="category-b"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><a href="{$root}faqsgettingaround"><img src="{$imagesource}icons/help.gif" width="12" height="14" alt="" border="0" />&nbsp;i need help</a></xsl:element></td>
	</tr>
	<tr>
	<td>&nbsp;</td>
	<td colspan="3" class="white"><xsl:element name="{$text.base}" use-attribute-sets="text.base">e.g. aphex twin, donnie darko, will self, bill viola, elephant, ross noble</xsl:element></td>
	</tr>
	</table>
	</div>
	</xsl:template>
	


	<xsl:template match="SEARCH" mode="r_searchform">
	    <xsl:apply-templates select="." mode="t_searchinput"/><br />
		<xsl:apply-templates select="." mode="c_searchtype"/><br />
		<xsl:apply-templates select="." mode="c_resultstype"/><br />
		<xsl:apply-templates select="." mode="t_searchsubmit"/><br />
	</xsl:template>
	
	<xsl:attribute-set name="mSEARCH_c_searchform"/>
	<xsl:attribute-set name="mSEARCH_t_searchinput"/>
	<xsl:attribute-set name="mSEARCH_t_searchsubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template match="SEARCH" mode="r_searchtype">
		<xsl:copy-of select="$m_searcharticles"/>
		<xsl:apply-templates select="." mode="t_searcharticles"/>
	
		<xsl:copy-of select="$m_searchusers"/>
		<xsl:apply-templates select="." mode="t_searchusers"/>
		
		<xsl:copy-of select="$m_searchuserforums"/>
		<xsl:apply-templates select="." mode="t_searchforums"/>

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
	
		<xsl:copy-of select="$m_recommendedresults"/>
		<xsl:apply-templates select="." mode="t_submittedarticles"/>
	
		<xsl:copy-of select="$m_editedresults"/>
		<xsl:apply-templates select="." mode="t_editedarticles"/>
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
	
	<!-- NO RESULTS -->
	<xsl:template match="SEARCHRESULTS" mode="noresults_search">
	    <!-- TITLE -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="generic-w"><strong><xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><xsl:copy-of select="$m_searchresultstitle"/></xsl:element></strong></td>
			<td align="right"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><img src="{$imagesource}/icons/content_by_editor.gif" width="8" height="10" border="0" alt="editor" />:by editor <img src="{$imagesource}/icons/content_by_member.gif" width="8" height="10" border="0" alt="member" />:by member</xsl:element></td>
		</tr>
		</table>

		<!-- SEARCH TERMS -->
		<div class="generic-w">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:copy-of select="$m_searchresultsfor"/>&nbsp;
		<strong><xsl:value-of select="SAFESEARCHTERM"/></strong>
		</xsl:element>
		</div>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<div class="generic-w">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:value-of select="$m_noresults"/></strong>
		</xsl:element>
		</div>
		
		</xsl:element>
		
		<xsl:element name="td" use-attribute-sets="column.3"></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
			<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_search" />
			<br />
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">other searches</strong>
				</xsl:element>
			</div>
			
			
			<div class="myspace-t">search bbc.co.uk for <a href="http://www.bbc.co.uk/cgi-bin/search/results.pl?tab=allbbc&amp;q={SAFESEARCHTERM}&amp;recipe=all&amp;scope=all"><xsl:value-of select="SAFESEARCHTERM"/></a></div>
			<div class="myspace-t">search the web for <a href="http://www.bbc.co.uk/cgi-bin/search/results.pl?tab=www&amp;q={SAFESEARCHTERM}&amp;recipe=all&amp;scope=all"><xsl:value-of select="SAFESEARCHTERM"/></a></div>
			<br />
			</div>
			
			<br />
		</xsl:element>
		</tr></table>
	</xsl:template>
	

	<!-- SEARCH RESULTS -->
	<xsl:template match="SEARCHRESULTS" mode="results_search">
	
    <!-- TITLE -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="generic-w"><strong><xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><xsl:copy-of select="$m_searchresultstitle"/></xsl:element></strong></td>
			<td align="right"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><img src="{$imagesource}/icons/content_by_editor.gif" width="8" height="10" border="0" alt="editor" />:by editor <img src="{$imagesource}/icons/content_by_member.gif" width="8" height="10" border="0" alt="member" />:by member</xsl:element></td>
		</tr>
		</table>

		
		<!-- SEARCH TERMS -->
		<div class="generic-w">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
<!-- 		<p><strong>We are currently experiencing problems with our search engine and it's possible some results may not appear. Try using the index links above. We apologise for any inconvenience.</strong></p> -->
		
		<xsl:copy-of select="$m_searchresultsfor"/>&nbsp;<strong><xsl:value-of select="SAFESEARCHTERM"/></strong></xsl:element>
		</div>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">

		<!-- PREVIOUS - NEXT -->
		<div class="next-back">
		<table width="395" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="search-a"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$arrow.left" />&nbsp;<xsl:apply-templates select="SKIP" mode="c_previous"/></xsl:element></td>
		<td class="search-a" align="right"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="MORE" mode="c_more"/>&nbsp;<xsl:copy-of select="$arrow.right" /></xsl:element></td>
		</tr>
		</table>
		</div>

		<!-- RESULTS -->		
		<xsl:apply-templates select="ARTICLERESULT[PRIMARYSITE=1]" mode="c_search"/>
		<xsl:apply-templates select="USERRESULT" mode="c_search"/>
		<xsl:apply-templates select="FORUMRESULT[PRIMARYSITE=1]" mode="c_search"/>
		
		<!-- PREVIOUS - NEXT -->
		<div class="next-back">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="search-a"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$arrow.left" />&nbsp;<xsl:apply-templates select="SKIP" mode="c_previous"/></xsl:element></td>
		<td class="search-a" align="right"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="MORE" mode="c_more"/>&nbsp;<xsl:copy-of select="$arrow.right" /></xsl:element></td>
		</tr>
		</table>
		</div>

		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"></xsl:element>
<xsl:element name="td" use-attribute-sets="column.2">
			<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_search" />
			<br />
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">other searches</strong>
				</xsl:element>
			</div>
			<div class="myspace-t">search bbc.co.uk for <a href="http://www.bbc.co.uk/cgi-bin/search/results.pl?tab=allbbc&amp;q={SAFESEARCHTERM}&amp;recipe=all&amp;scope=all"><xsl:value-of select="SAFESEARCHTERM"/></a></div>
			<div class="myspace-t">search the web for <a href="http://www.bbc.co.uk/cgi-bin/search/results.pl?tab=www&amp;q={SAFESEARCHTERM}&amp;recipe=all&amp;scope=all"><xsl:value-of select="SAFESEARCHTERM"/></a></div>
			<br />
			</div>
			<br />
		</xsl:element>
		</tr></table>
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
	

	<!-- RESULTS LAYOUT -->
	<xsl:template match="ARTICLERESULT" mode="r_search">
		<div>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::ARTICLERESULT) mod 2 = 1">search-page-h</xsl:when>
		</xsl:choose>
		</xsl:attribute>
		
		<div>
		<xsl:attribute name="class">
		<xsl:choose>
				<xsl:when test="STATUS=1">search-page-d</xsl:when>
				<xsl:when test="STATUS=3">search-page-c</xsl:when>
				<xsl:otherwise>search-page-f</xsl:otherwise>
		</xsl:choose>	
		</xsl:attribute>
		<div class="search-page">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<div class="brownlink"><xsl:apply-templates select="SUBJECT" mode="t_subjectlink"/></div>
			<!-- <xsl:apply-templates select="STATUS" mode="t_articlestatus"/>&nbsp; -->
			<div><span class="orange">
			<xsl:call-template name="article_subtype">
			<xsl:with-param name="status" select="STATUS" />
			</xsl:call-template>
			</span></div>
		</xsl:element>
		
		<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			<a href="{$root}A{H2G2ID}">http://www.bbc.co.uk<xsl:value-of select="concat($root,'A',H2G2ID)" /></a><br />
		</xsl:element>
		</div></div></div>

	</xsl:template>
	
	<xsl:template match="USERRESULT" mode="r_search">
		<div>
		<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::USERRESULT) mod 2 = 1">search-page-g</xsl:when>
			<xsl:otherwise>search-page-h</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<div class="search-page">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="USERNAME" mode="t_userlink"/>
		</xsl:element>
		</div></div>
	</xsl:template>
	
	<xsl:template match="FORUMRESULT" mode="r_search">
		<div>
		<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::FORUMRESULT) mod 2 = 1">search-page-g</xsl:when>
			<xsl:otherwise>search-page-h</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<div class="search-page">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="SUBJECT" mode="t_postlink"/>
		</xsl:element>
		</div></div>
	</xsl:template>
	

</xsl:stylesheet>
