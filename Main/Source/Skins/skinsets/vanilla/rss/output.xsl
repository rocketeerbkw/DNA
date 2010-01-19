<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns:dna="http://www.bbc.co.uk/dna" 
	exclude-result-prefixes="msxsl doc dna">
	
  	<xsl:include href="includes.xsl"/>
  
	<xsl:output
		method="xml"
		version="2.0"
		omit-xml-declaration="no"
		standalone="yes"
		indent="yes"/>
	
	<xsl:variable name="server">
		<xsl:choose>
			<xsl:when test="$configuration/host/url != ''" >
				<xsl:value-of select="$configuration/host/url"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>http://www.bbc.co.uk</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	
	<xsl:template match="H2G2">
		<rss version="2.0">
			<channel>
			<!-- Output the RSS layout for this page -->
				<xsl:apply-templates select="." mode="page"/>        
			</channel>
		</rss>
	</xsl:template>
	
</xsl:stylesheet>
