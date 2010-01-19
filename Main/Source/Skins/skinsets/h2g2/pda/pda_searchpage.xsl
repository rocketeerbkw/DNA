<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-searchpage.xsl"/>
	<xsl:template name="SEARCH_CSS">
		<!--LINK href="http://dev3.mh.bbc.co.uk/mobile/xhtml/h2g2/home.css" rel="stylesheet"/-->
		<xsl:choose>
			<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=72">
				<LINK href="{$csssource}life.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=73">
				<LINK href="{$csssource}uni.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=74">
				<LINK href="{$csssource}evy.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:otherwise>
				<LINK href="{$csssource}home.css" rel="stylesheet"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="found" select="/H2G2/SEARCH/SEARCHRESULTS/ARTICLERESULT"/>
	<!--

	-->
	<xsl:variable name="search_category">
		<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY">
			<xsl:text>&amp;category=</xsl:text>
			<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY"/>
		</xsl:if>
	</xsl:variable>
	<xsl:template name="SEARCH_MAINBODY">
		<xsl:variable name="found_not_found">
			<xsl:choose>
				<xsl:when test="$found">Found!</xsl:when>
				<xsl:otherwise>
					<xsl:text>Not Found!</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="50%" class="pageHead">
					<xsl:value-of select="concat('h2g2: ', $found_not_found)"/>
				</td>
				<td width="50%" class="pageHead" align="right">
					<a href="{$root}" class="homeLnk">Home</a>&nbsp;</td>
			</tr>
		</table>
		<!-- Search for a guide only -->
		<xsl:apply-templates select="/H2G2/SEARCH/SEARCHRESULTS" mode="me"/>
		<!--xsl:apply-templates select="/H2G2/SEARCH" mode="c_searchform"/-->
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="SEARCH" mode="r_searchform">
		<xsl:apply-templates select="." mode="t_searchinput"/>
		<br/>
		<xsl:apply-templates select="." mode="t_searchsubmit"/>
	</xsl:template>
	<!--
	
	-->
	<xsl:attribute-set name="mSEARCH_t_searchsubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<!--

	-->
	<xsl:template match="SEARCHRESULTS" mode="me">
		<div class="info">
			<xsl:choose>
				<xsl:when test="$found">
					<xsl:text>Results for: </xsl:text>
					<b>
						<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>
					</b>
					<br/>
				</xsl:when>
				<xsl:otherwise>
					
					<xsl:text>No results found.</xsl:text>
					<br/>
					<br/>
					<xsl:text>We're sorry, but your search for </xsl:text> 
					<xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>
					<xsl:text> didn't find any matches, but don't panic - this might be because of a technical error on our side, so apologies for the inconvenience.</xsl:text>
					<br/>
					<br/>
					<xsl:text>The Entries on h2g2 are written by people just like you - why not fill in the gaps and write one for us by visiting our website at http://www.bbc.co.uk/dna/h2g2/?</xsl:text>
					<br/>
					<br/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<xsl:if test="ARTICLERESULT[SCORE &gt;= 50][SITEID=1]">
			<div class="bandHi">
				<div class="bandHead">High</div>
				<xsl:apply-templates select="ARTICLERESULT[SCORE &gt;= 50][SITEID=1]" mode="pda"/>
			</div>
		</xsl:if>
		<xsl:if test="ARTICLERESULT[SCORE &gt;= 15 and SCORE &lt; 50][SITEID=1]">
			<div class="bandMed">
				<div class="bandHead">Medium</div>
				<xsl:apply-templates select="ARTICLERESULT[SCORE &gt;= 15 and SCORE &lt; 50][SITEID=1]" mode="pda"/>
			</div>
		</xsl:if>
		<xsl:if test="ARTICLERESULT[SCORE &lt; 15][SITEID=1]">
			<div class="bandLo">
				<div class="bandHead">Low</div>
				<xsl:apply-templates select="ARTICLERESULT[SCORE &lt; 15][SITEID=1]" mode="pda"/>
			</div>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$found and MORE=1 and not(ARTICLERESULT/SITEID != 1)">
				<div class="nextPage">
					<span class="chevron">&raquo;</span>
					<a href="{$root}Search?searchtype=article&amp;showapproved=1&amp;searchstring={SEARCHTERM}&amp;skip={SKIP + COUNT}&amp;show={COUNT}{$search_category}">Next</a>
					<xsl:value-of select="concat(' ', SKIP+1+COUNT, ' - ', SKIP+(COUNT*2))"/>
				</div>
				<div class="moreResults">Show: <a href="{$root}Search?searchtype=article&amp;showapproved=1&amp;searchstring={SEARCHTERM}&amp;show=10{$search_category}">10</a> | <a href="{$root}Search?searchtype=article&amp;searchstring={SEARCHTERM}&amp;showapproved=1&amp;show=20{$search_category}">20</a> | <a href="{$root}Search?searchtype=article&amp;showapproved=1&amp;searchstring={SEARCHTERM}&amp;show=30{$search_category}">30</a>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="srchBox">
					<form action="{$root}search">
						<xsl:text>Find in </xsl:text>
						<xsl:choose>
							<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=72">Life</xsl:when>
							<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=73">The Universe</xsl:when>
							<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=74">Everything</xsl:when>
						</xsl:choose>
						<br/>
						<!--xsl:call-template name="searchbox">
								<xsl:with-param name="category" select="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY"/>
								<xsl:with-param name="input_field_text" select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/>
							</xsl:call-template-->
						<input type="hidden" name="searchtype" value="article"/>
						<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY">
							<input type="hidden" name="category" value="{/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY}"/>
						</xsl:if>
						<input type="hidden" name="showapproved" value="1"/>
						<input type="hidden" name="show" value="7"/>
						<input type="text" size="20" name="searchstring">
							<xsl:if test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM) &gt; 0">
								<xsl:attribute name="value"><xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM"/></xsl:attribute>
							</xsl:if>
						</input>
						<br/>
						<input type="submit" value="Find it"/>
					</form>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="search_show_num" select="7"/>
	<!--
	
	-->
	<xsl:template match="ARTICLERESULT" mode="pda">
		<span class="chevron">&raquo;</span>
		<a href="{$root}A{H2G2ID}" class="bulletLnk">
			<xsl:value-of select="SUBJECT"/>
		</a>
		<br/>
	</xsl:template>
	<xsl:template match="ARTICLERESULT" mode="med"/>
	<xsl:template match="ARTICLERESULT" mode="low"/>
</xsl:stylesheet>
