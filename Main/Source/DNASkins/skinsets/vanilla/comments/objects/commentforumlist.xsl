<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a Commentforum list set
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="COMMENTFORUMLIST" mode="object_commentforumlist">
        
        <h2>Being Discussed Now</h2>
        
        <ul class="dna-list">
            <xsl:apply-templates select="COMMENTFORUM" mode="object_commentforum" >
                <xsl:sort select="LASTUPDATED/DATE/@SORT" order="descending"/>
            </xsl:apply-templates>
        </ul>
        
    </xsl:template>
</xsl:stylesheet>