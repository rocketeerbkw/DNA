<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts COLUMN nodes to H2G2 column divs
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            Allows editorial to add column content in GuideML without having to worry
            about HTML / CSS. 
            
            Generates:
                
                div class="span-2"
                    div
                    div
                    
            and so on.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="COLUMNS | columns" mode="library_GuideML">
        <div class="span-{count( child::COLUMN)}">
            <xsl:apply-templates mode="library_GuideML"/>
        </div>
    </xsl:template>
    
    <xsl:template match="COLUMN | columns" mode="library_GuideML">
        <div class="column">
            <xsl:apply-templates mode="library_GuideML"/>
        </div>
    </xsl:template>
</xsl:stylesheet>