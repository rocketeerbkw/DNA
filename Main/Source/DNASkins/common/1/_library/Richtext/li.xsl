<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
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
    
    <xsl:template match="LI | li" mode="library_Richtext">
        <xsl:param name="escapeapostrophe"/>
        <li>
            <xsl:apply-templates mode="library_Richtext">
                <xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
            </xsl:apply-templates>
        </li>
    </xsl:template>
</xsl:stylesheet>