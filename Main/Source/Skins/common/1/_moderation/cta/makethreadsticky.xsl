<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Provides simple mechanism to make a sticky thread
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="THREAD" mode="moderation_cta_makethreadsticky">
        <xsl:param name="label" select="'Stick thread to front page'" />
        
        <a href="{$root}/FN{@FORUMID}?cmd=MAKETHREADSTICKY&amp;stickythreadid={@THREADID}">
            <xsl:value-of select="$label"/>
        </a>
    </xsl:template>
    
</xsl:stylesheet>