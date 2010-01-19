<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts LI nodes to HTML list item elements
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="LI" mode="library_GuideML">
        <li>
            <xsl:apply-templates mode="library_GuideML"/>
        </li>
    </xsl:template>
	
	<xsl:template match="LI" mode="library_GuideML_rss">
		<xsl:text>&#8226; </xsl:text><xsl:apply-templates mode="library_GuideML_rss"/>
	</xsl:template>
	
</xsl:stylesheet>