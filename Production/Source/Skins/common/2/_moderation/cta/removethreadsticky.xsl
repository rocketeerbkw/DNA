<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Provides simple mechanism to make a remove sticky thread
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="THREAD" mode="moderation_cta_removethreadsticky">
        <xsl:param name="subject"/>
        
        <a href="{$root}/NF{@FORUMID}?cmd=REMOVESTICKYTHREAD&amp;stickythreadid={@THREADID}">
            Unpin <span class="blq-hide"><xsl:text>:&#32;</xsl:text><xsl:value-of select="$subject"/></span> thread
        </a>
    </xsl:template>
    
</xsl:stylesheet>