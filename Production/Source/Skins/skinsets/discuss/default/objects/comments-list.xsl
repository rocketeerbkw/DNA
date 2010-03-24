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
    
    
    
    <xsl:template match="COMMENTS-LIST[COMMENTS]" mode="object_comments-list">
        
        <ul class="collections">
            <xsl:apply-templates select="COMMENTS/COMMENT" mode="object_comment" />
        </ul>
        
    </xsl:template>
    
    <xsl:template match="COMMENTS-LIST" mode="object_comments-list">
        <p>This user has not made any comments yet.</p>
    </xsl:template>
    
</xsl:stylesheet>