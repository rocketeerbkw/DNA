<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="FORUMTHREADPOSTS" mode="object_forumthreadposts">
        
        <h3><xsl:value-of select="FIRSTPOSTSUBJECT"/></h3>
        
        <ul class="collections forumthreadposts">
            <xsl:apply-templates select="POST" mode="object_post" />
        </ul>
        
    </xsl:template>
    
    <xsl:template match="FORUMTHREADPOSTS[@FROM and @TO][@FORUMPOSTCOUNT &lt; 1]" mode="object_forumthreadposts">
        
            html: '<p class="forumthreadposts">There have been no comments made here yet.</p>'
        
    </xsl:template>
        
        
    <xsl:template match="FORUMTHREADPOSTS[@FROM and @TO][@FORUMPOSTCOUNT > 0]" mode="object_forumthreadposts">
        
        'id': '<xsl:value-of select="POST[ position() = 1]/@INDEX + 1" />',
        'html': '<xsl:apply-templates select="POST[ position() = 1]" mode="object_post_comment" />'
        
    </xsl:template>
    
</xsl:stylesheet>