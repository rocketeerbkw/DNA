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
    
    
    <xsl:template match="TOPIC" mode="object_topic_title">
        <li>
            <xsl:call-template name="library_listitem_stripe" />
            <a href="{$root}/F{FORUMID}">
                <xsl:value-of select="TITLE" />
            </a>
        </li>
    </xsl:template>
    
    <xsl:template match="TOPIC[FORUMID = /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID]" mode="object_topic_title">
        <li>
            <xsl:call-template name="library_listitem_stripe" />
            <a href="{$root}/F{FORUMID}" class="current-section">
                <xsl:value-of select="TITLE" />
            </a>
        </li>
    </xsl:template>
    
</xsl:stylesheet>