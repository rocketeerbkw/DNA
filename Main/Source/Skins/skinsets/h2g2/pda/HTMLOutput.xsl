<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-extra.xsl"/>
	<xsl:include href="pda_articlepage.xsl"/>
	<xsl:include href="pda_categorypage.xsl"/>
	<xsl:include href="pda_frontpage.xsl"/>
	<xsl:include href="pda_notfound.xsl"/>
	<xsl:include href="pda_searchpage.xsl"/>
	<xsl:variable name="pda_toolbar_images">http://www.bbc.co.uk/h2g2/skins/pda/images/</xsl:variable>
	<xsl:variable name="sitedisplayname">h2g2</xsl:variable>
	<xsl:variable name="root">/dna/h2g2/pda/</xsl:variable>
	<xsl:variable name="imagesource">http://www.bbc.co.uk/h2g2/skins/pda/images/</xsl:variable>
	<xsl:variable name="graphics">http://www.bbc.co.uk/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="csssource">http://www.bbc.co.uk/h2g2/skins/pda/css/</xsl:variable>
	<xsl:output method="xml" version="1.0" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO-8859-1" media-type="text/html"/>
	<xsl:template match="H2G2">
		<html>
			<head>
				<title>H2G2</title>
				<xsl:call-template name="insert-css"/>
				<LINK href="{$csssource}site.css" rel="stylesheet"/>
        <xsl:comment>#include virtual="/mobile/includes/subhead-inc_xhtml.sssi" </xsl:comment>
			</head>
			<META name="HandheldFriendly" content="True"/>
			<body bgcolor="#ffffff" alink="#0033CC" vlink="#0033CC" link="#0033CC" marginheight="0" marginwidth="0" leftmargin="0" topmargin="0">
				<!--<div class="bannerSml">
					<img src="{$pda_toolbar_images}banner.gif" width="90" height="9" alt="" border="0"/>
				</div>-->
				<div class="bannerBig">
					<img src="{$imagesource}banner-big.gif" width="103" height="20" alt="" border="0"/>
				</div>
				<xsl:call-template name="type-check">
					<xsl:with-param name="content" select="'MAINBODY'"/>
				</xsl:call-template>
				<div class="subFoot">
					<a href="{$root}mobile-faq" class="subFootLnk">Help</a> | <a href="{$root}Mobile-Costs" class="subFootLnk">Cost</a>
				</div>
				<div class="footer">
					<xsl:if test="/H2G2[@TYPE='SEARCH'] and /H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY">
						<span class="accessKey">[3]</span>
						<xsl:text> </xsl:text>
						<a href="{$root}C{/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY}" accesskey="3" class="footLnk">
							<xsl:choose>
								<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=72">Life</xsl:when>
								<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=73">The Universe</xsl:when>
								<xsl:when test="/H2G2/SEARCH/SEARCHRESULTS/WITHINCATEGORY=74">Everything</xsl:when>
							</xsl:choose>
						</a>
						<br/>
					</xsl:if>
					<xsl:if test="/H2G2[@TYPE='CATEGORY'] and (/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2])">
						<span class="accessKey">[3]</span>
						<xsl:text> </xsl:text>
						<xsl:choose>
							<xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NAME">
								<a href="{$root}C{/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID}" accesskey="3" class="footLnk">
									<xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NAME"/>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}C{/H2G2/HIERARCHYDETAILS/@NODEID}" accesskey="3" class="footLnk">
									<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
						<br/>
					</xsl:if>
					<xsl:if test="not(/H2G2[@TYPE='FRONTPAGE'])">
						
						<span class="accessKey">[2]</span>
						<xsl:text> </xsl:text>
						<a href="{$root}" accesskey="2" class="footLnk">h2g2 Home</a>
						<br/>
					</xsl:if>
					<span class="accessKey">[1]</span>
					<xsl:text> </xsl:text>
					<a href="http://www.bbc.co.uk/mobile/index.shtml" accesskey="1" class="footLnk">BBC Home</a>
					
					
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="searchbox">
		<xsl:param name="category" select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
		<xsl:param name="input_field_text"/>
		<form action="{$root}search">
			<input type="hidden" name="searchtype" value="article"/>
			<input type="hidden" name="category" value="{$category}"/>
			<input type="text" size="20" name="searchstring">
				<xsl:if test="string-length($input_field_text) &gt; 0">
					<xsl:attribute name="value"><xsl:value-of select="$input_field_text"/></xsl:attribute>
				</xsl:if>
			</input>
			<br/>
			<input type="submit" value="Find it"/>
		</form>
	</xsl:template>
	
</xsl:stylesheet>
