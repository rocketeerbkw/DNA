<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Lists the articles found under a category
        </doc:purpose>
        <doc:context>
            Typically used on a category page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="TOPICLIST" mode="object_topiclist">
        
        <ul class="topiclist">
            
            <xsl:apply-templates select="TOPIC" mode="object_topic"/>
            
        </ul>
        
    </xsl:template>
    
</xsl:stylesheet>