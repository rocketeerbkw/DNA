<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="H2G2[@TYPE = 'ERROR']" mode="page">
		<p class="error">An error has occurred.</p>
	</xsl:template>


  <xsl:template match="/H2G2/ERROR" mode="page">
    <p class="error">An error has occurred - <xsl:value-of select="ERRORMESSAGE"/></p>
  </xsl:template>

  <xsl:template match="/H2G2/RESULT" mode="page">
    <p class="error">
      <xsl:value-of select="MESSAGE"/>
    </p>
  </xsl:template>

</xsl:stylesheet>
