<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Provides simple mechanism to display content depending whether a user is logged in or not. 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="THREAD[@CANWRITE = 1]" mode="moderation_cta_closethread">
        <xsl:param name="label" />
        <xsl:param name="subject" />
       
        <a href="{$root}/F{@FORUMID}?thread={@THREADID}&amp;cmd=closethread">
            <xsl:value-of select="$label"/> 
            <span class="blq-hide"><xsl:text>:&#32;</xsl:text><xsl:value-of select="$subject"/></span>
        </a>
    </xsl:template>
    
    
    <xsl:template match="THREAD[@CANWRITE = 0]" mode="moderation_cta_closethread">
        <xsl:param name="label" />
       <xsl:param name="subject" />

        <a href="{$root}/F{@FORUMID}?thread={@THREADID}&amp;cmd=reopenthread">
           <xsl:value-of select="$label"/> 
            <span class="blq-hide"><xsl:text>:&#32;</xsl:text><xsl:value-of select="$subject"/></span>
        </a>
    </xsl:template>
    
</xsl:stylesheet>