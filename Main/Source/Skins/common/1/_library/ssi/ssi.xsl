<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Output an ssi statement 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            todo: Expand library/ssi to later provide the ability to double escape ssi vars
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_ssi">
        <xsl:param name="statement"/>
        
        <xsl:comment>#<xsl:value-of select="$statement"/></xsl:comment>
        
    </xsl:template>
</xsl:stylesheet>