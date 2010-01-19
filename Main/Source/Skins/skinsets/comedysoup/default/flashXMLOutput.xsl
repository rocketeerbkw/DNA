<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
    <!--
        Produces simplified xml for use by flash clients
    -->
	<xsl:include href="flashxml_articlesearch.xsl"/>	
  
  
    <xsl:template match="H2G2[key('xmltype', 'flash')]">
      <xsl:call-template name="type-check">
          <xsl:with-param name="content">FLASHXML</xsl:with-param>
      </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
