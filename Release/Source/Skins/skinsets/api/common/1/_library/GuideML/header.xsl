<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts HEADER nodes to H3s
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="HEADER" mode="library_GuideML">
        <h3>
            <xsl:apply-templates mode="library_GuideML"/>
        </h3>
    </xsl:template>
	
	<xsl:template match="HEADER" mode="library_GuideML_rss">
		<xsl:apply-templates mode="library_GuideML_rss"/>
	</xsl:template>
	
</xsl:stylesheet>