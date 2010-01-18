<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:doc="http://www.bbc.co.uk/dna/documentation" version="1.0" exclude-result-prefixes="doc">

  <doc:documentation>
    <doc:purpose>
      Page layout for an error page
    </doc:purpose>
    <doc:context>
      Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
    </doc:context>
    <doc:notes>
      This defines the error page layout, not to be confused with the error object...
    </doc:notes>
  </doc:documentation>
  
  <xsl:template match="/H2G2[@TYPE = 'ERROR']" mode="page">
    <xsl:comment> 
      An error occurred in DNA.
      "<xsl:value-of select="ERROR"/>"  
    </xsl:comment>
  </xsl:template>

</xsl:stylesheet>
