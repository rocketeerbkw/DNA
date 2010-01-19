<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Lists the articles found under a category
        </doc:purpose>
        <doc:context>
            Typically used on a category page
        </doc:context>
        <doc:notes>
            Appends the current category name (DISPLAYNAME) to the list
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="ANCESTRY" mode="object_ancestry">
        
        <ul class="collections ancestry">
            <xsl:apply-templates select="ANCESTOR" mode="object_ancestor">
                <xsl:sort data-type="number" select="TREELEVEL" order="ascending"/>
            </xsl:apply-templates>
            <li>
                <xsl:value-of select="parent::node()/DISPLAYNAME"/>
            </li>
        </ul>
        
    </xsl:template>
    
</xsl:stylesheet>