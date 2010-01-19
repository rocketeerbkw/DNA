<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	exclude-result-prefixes=" doc">
  <xsl:include href="includes.xsl"/>
  
  <xsl:output
    method="html"
    version="4.0"
    omit-xml-declaration="yes"
    standalone="yes"
    indent="yes"
    encoding="UTF-8"
  />
    <!-- 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
       -->
  <xsl:template match="H2G2">
		
    <!-- Output the HTML layout for this page -->
    <xsl:apply-templates select="." mode="page"/>

  </xsl:template>
</xsl:stylesheet>
