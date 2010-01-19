<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

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
    
    <div class="column">
      <div class="large-panel module">
        <h2>There has been a problem</h2>
        
        <p>Your last action triggered an error. Hopefully the report below will give you a better idea of what it was that caused it and how to continue. If you are having troubles gettign somewhere then don't hesitate to <a href="contact">contact us</a>.</p>
        
        <xsl:apply-templates select="ERROR" mode="object_error" />
      </div>
    </div>
    
  </xsl:template>

</xsl:stylesheet> 
