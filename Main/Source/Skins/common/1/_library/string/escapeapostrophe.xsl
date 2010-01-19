<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            String search and replace
        </doc:purpose>
        <doc:context>
            Skin wide
        </doc:context>
        <doc:notes>
            To use simply select the text and apply e.g.
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template name="library_string_escapeapostrophe">
        <xsl:param name="str"/>
        
        <xsl:call-template name="library_string_searchandreplace">
            <xsl:with-param name="str">
                <xsl:value-of select="$str"/>
            </xsl:with-param>
            <xsl:with-param name="search">
                <xsl:text>'</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="replace">
                <xsl:text>\'</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
   
</xsl:stylesheet>