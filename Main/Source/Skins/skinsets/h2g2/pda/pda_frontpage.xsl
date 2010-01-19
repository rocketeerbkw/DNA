<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-frontpage.xsl"/>
	<xsl:template name="FRONTPAGE_CSS">
		<LINK href="{$csssource}home.css" rel="stylesheet" />
	</xsl:template>
	<!--

	-->
	<xsl:template name="FRONTPAGE_MAINBODY">
		<div class="siteHead">:: h2g2 Home ::</div>
		<div class="info">The Guide to Life, the Universe and Everything, written by people like you.<br/>
		</div>
		<div class="bandTour">
			<span class="chevron">&raquo;</span>
			<a href="{$root}mobile-faq">What is h2g2?</a>
		</div>
		<div class="bandLife">
			<span class="chevron">&raquo;</span>
			<a href="{$root}C72?s_show=search">Life</a>
		</div>
		<div class="bandUni">
			<span class="chevron">&raquo;</span>
			<a href="{$root}C73?s_show=search">Universe</a>
		</div>
		<div class="bandEvy">
			<span class="chevron">&raquo;</span>
			<a href="{$root}C74?s_show=search">Everything</a>
		</div>
		<!--div class="info">
			<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MOBILE" mode="me"/>
		</div-->
		<div class="srchBox">
			<form action="{$root}search">
				<xsl:text>Find an Entry...</xsl:text>
				<br/>
				<input type="hidden" name="searchtype" value="article"/>
				<input type="text" size="20" name="searchstring"/>
				<input type="hidden" name="showapproved" value="1"/>
				<input type="hidden" name="show" value="{$search_show_num}"/>
				<br/>
				<input type="submit" value="Find it"/>
			</form>
		</div>
		<div class="bandSurp">
			<span class="chevron">&raquo;</span>
			<a href="{$root}RandomEditedEntry">Surprise me!</a>
			<br/>
		</div>
		<div class="browseBar">New today:<br/>
		</div>
		<div class="browseList">
			<xsl:for-each select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[1]/BODY//LINK[text() | *[not(name()='PICTURE')]/text()][position() &lt; 4]">
				<xsl:apply-templates select="." mode="pda_frontpage"/>
			</xsl:for-each>
			<!--span class="chevron">&raquo;</span>
			<a href="entry.shtml">More</a>
			<br/-->
			<!--span class="chevron">&raquo;</span>
			<a href="entry.shtml" class="bulletLnk">Great Hot Drinks</a>
			<br/>
			<span class="chevron">&raquo;</span>
			<a href="entry.shtml" class="bulletLnk">Cyborgs in Science Fiction</a>
			<br/>
			<span class="chevron">&raquo;</span>
			<a href="entry.shtml">More</a>
			<br/-->
		</div>
	</xsl:template>
	<xsl:attribute-set name="mLINK">
		<xsl:attribute name="class">bulletLnk</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="LINK" mode="pda_frontpage">
		<span class="chevron">&raquo;</span>
		<xsl:apply-templates select="."/>
		<br/>
	</xsl:template>
	
	<!--
	
	-->
	<xsl:template match="MOBILE" mode="me">
		<xsl:apply-templates select="node()"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-ARTICLE">
		<a href="{$root}A{H2G2ID}">
			<xsl:value-of select="SUBJECT"/>
		</a>
		<br/>
	</xsl:template>
</xsl:stylesheet>
