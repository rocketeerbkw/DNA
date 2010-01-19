<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
		Produces xhtml snippets
	-->
	<xsl:output method="xml" version="1.0" standalone="yes" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:include href="xhtml_frontpage.xsl"/>
	<xsl:include href="xhtml_dynamiclist.xsl"/>

    	<xsl:template match="H2G2[key('xmltype', 'xhtml')]">
    	       	<xsl:call-template name="type-check">
        		<xsl:with-param name="content">XHTML</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>
