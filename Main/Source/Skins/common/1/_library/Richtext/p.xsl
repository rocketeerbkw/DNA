<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts P nodes to HTML paragraphs
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="P | p" mode="library_Richtext">
        <xsl:param name="escapeapostrophe"/>
        <p>
            <xsl:apply-templates mode="library_Richtext">
                <xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>
</xsl:stylesheet>