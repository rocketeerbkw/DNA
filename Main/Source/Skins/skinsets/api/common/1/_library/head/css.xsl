<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:properties common="true" />
        <doc:purpose>
            Transforms page specific stylesheet additions to relevant css import declaration
        </doc:purpose>
        <doc:context>
            Applied by index.xsl
        </doc:context>
        <doc:notes>
            Currently use @import, would be better if they were all 'link' elements
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="css/file" mode="structure">
        
        <style type="text/css">
            @import "<xsl:value-of select="$configuration/assetPaths/css"/>
            <xsl:value-of select="."/>"
        </style>
        
    </xsl:template>
</xsl:stylesheet>