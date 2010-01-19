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
  
  <xsl:template match="/H2G2[@TYPE = 'KEYARTICLE-EDITOR']" mode="page">
    
    <div class="column">
      <div class="large-panel module">
        <h2>Named Articles</h2>
        
        <xsl:apply-templates select="KEYARTICLEFORM" mode="input_keyarticleform" />
      </div>
    </div>
    
    <div class="column">
      <div id="detail" class="small-panel module">
        <h2>Existing Names</h2>
        
        <xsl:apply-templates select="KEYARTICLELIST" mode="input_keyarticlelist" />
      </div>
    </div>
    
  </xsl:template>

</xsl:stylesheet> 
