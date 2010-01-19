<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
  <xsl:include href="../html/includes.xsl"/>
  
  <xsl:output
    method="html"
    version="4.0"
    omit-xml-declaration="yes"
    standalone="yes"
    indent="yes"
    encoding="ISO8859-1"
  />
  
  
	<xsl:variable name="abc" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="ABC" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
  
  <xsl:template match="H2G2">
    
        <!-- 
    <div class="dna-component">
    </div>
          
        -->    
        <!-- Output the HTML layout for this page -->
        <xsl:apply-templates select="." mode="page"/>
      

  </xsl:template>
  
</xsl:stylesheet>
