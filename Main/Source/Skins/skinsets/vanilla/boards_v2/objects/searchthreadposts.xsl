<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="SEARCHTHREADPOSTS" mode="object_forumthreadposts">
        <xsl:apply-templates select="." mode="library_pagination_searchthreadposts" />
        
        <ul class="collections forumthreadposts" id="topofthreads">
            <xsl:apply-templates select="POST" mode="object_post_search" />
        </ul>
        
        <xsl:apply-templates select="." mode="library_pagination_searchthreadposts" />
        
        <a href="#topofthreads" class="backtotop">Back to top</a>
        
    </xsl:template>
    
    <xsl:template match="SEARCHTHREADPOSTS[@FROM and @TO][@FORUMPOSTCOUNT &lt; 1]" mode="object_forumthreadposts">
        <p class="dna-commentbox-nocomments">There have been no comments made here yet.</p>
    </xsl:template>
        
    <xsl:template match="FORUMTHREADPOSTS[@FROM and @TO][@FORUMPOSTCOUNT > 0]" mode="object_forumthreadposts">
        
        <xsl:apply-templates select="." mode="library_pagination_commentbox" />
        
        <ul class="collections forumthreadposts">
            <xsl:apply-templates select="POST[@INDEX > (parent::*/@FROM - 1) and @INDEX &lt; (parent::*/@TO + 1)]" mode="object_post_comment" >
                <xsl:sort select="DATEPOSTED/DATE/@SORT" order="ascending"/>
            </xsl:apply-templates>
        </ul>
        
        <xsl:apply-templates select="." mode="library_pagination_commentbox" />
        
        <p class="dna-commentbox-rss">
            <a href="{$root-xml}/acs?dnauid={@UID}">View these comments in RSS</a>
        </p>
        
    </xsl:template>
    
</xsl:stylesheet>