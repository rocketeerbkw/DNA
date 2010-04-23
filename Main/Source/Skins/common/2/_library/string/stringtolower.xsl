<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Lowercases a string
        </doc:purpose>
        <doc:context>
            Skin wide
        </doc:context>
        <doc:notes>
            To use simply select the text and apply e.g.
            
            xsl:apply-templates select="/H2G2/@TYPE" mode="library_string_stringtolower"
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="* | @*" mode="library_string_stringtolower">
        
        <xsl:value-of select="translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
        
    </xsl:template>
</xsl:stylesheet>