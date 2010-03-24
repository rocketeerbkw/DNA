<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
  <xsl:include href="includes.xsl"/>
  
  <xsl:output
    method="xml"
    version="1.0"
    omit-xml-declaration="yes"
    standalone="yes"
    indent="no"
    encoding="ISO8859-1"
  />

  <xsl:template match="H2G2">
    <xsl:text>{</xsl:text>
    <xsl:apply-templates select="." mode="page"/>
    <xsl:text>}</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>
