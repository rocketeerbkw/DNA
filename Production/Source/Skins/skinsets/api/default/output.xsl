<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0" 
  xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
  exclude-result-prefixes="doc"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt">
    
    <doc:documentation>
        <doc:purpose>
            Kick off stylesheet called directly by DNA 
        </doc:purpose>
        <doc:context>
            n/a
        </doc:context>
        <doc:notes>
            Bridges the jump between the old skin architecture and the new.
        </doc:notes>
    </doc:documentation>

    <xsl:include href="../common/configuration.xsl"/>
    <xsl:include href="../configuration.xsl"/>
    
    <xsl:variable name="configuration" select="msxsl:node-set($skin)/configuration" />
    
    <xsl:include href="../common/1/includes.xsl" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="H2G2POST" mode="library_Post" />
		<xsl:apply-templates select="GUIDE/BODY" mode="library_GuideML" />
	</xsl:template>


</xsl:stylesheet>