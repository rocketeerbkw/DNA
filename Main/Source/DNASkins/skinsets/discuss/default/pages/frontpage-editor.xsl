<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Used here to output the correct HTML for a BBC Homepage module
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE-EDITOR']" mode="page">
        
        <div class="column">
            <div class="module large-panel">
                <h2>Frontpage Editor</h2>
                <xsl:apply-templates select="FRONTPAGE-EDIT-FORM" mode="input_frontpage-edit-form" />
            </div>
        </div>
        
        
    </xsl:template>

</xsl:stylesheet>