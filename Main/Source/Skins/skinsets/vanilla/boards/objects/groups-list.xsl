<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="GROUPS-LIST[GROUP]" mode="object_groups-list">
        
        <ul class="collections">
            <xsl:apply-templates select="GROUP" mode="object_group" />
        </ul>
        
    </xsl:template>
    
    <xsl:template match="GROUPS-LIST" mode="object_groups-list">
        <p>Thats very wrong, there are no DNA user groups.</p>
    </xsl:template>
    
</xsl:stylesheet>