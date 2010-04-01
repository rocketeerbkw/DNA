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
    
    
    <xsl:template match="FORUMTHREADPOSTS" mode="object_forumthreadposts">
        <xsl:variable name="threadId" select="@THREADID"/>
        
        <xsl:call-template name="library_header_h4">
            <xsl:with-param name="text">
            	<xsl:value-of select="FIRSTPOSTSUBJECT"/>  
            </xsl:with-param>
        </xsl:call-template>
        
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
                <p class="dna-boards-moderation">
                    <xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@CANWRITE = 1]" mode="moderation_cta_closethread">
            						<xsl:with-param name="label" select="'Close discussion'" />
            					</xsl:apply-templates>
            					<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@CANWRITE = 0]" mode="moderation_cta_closethread">
            						<xsl:with-param name="label" select="'Open discussion'" />
            					</xsl:apply-templates>
                    <xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId]" mode="moderation_cta_movethread">
                    	<xsl:with-param name="label" select="'Move discussion'" />
                    </xsl:apply-templates>
                </p>
            </xsl:with-param>
        </xsl:call-template>
    	
    	<xsl:if test="@CANWRITE = 0">
        <div>
          <p class="closed">This discussion has been closed.</p>
        </div>
    	</xsl:if>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreadposts" />
        
        <ul class="collections forumthreadposts">
            <xsl:apply-templates select="POST" mode="object_post" />
        </ul>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreadposts" />
        
    </xsl:template>
    
    
    <xsl:template match="FORUMTHREADPOSTS[@FROM and @TO][@FORUMPOSTCOUNT &lt; 1]" mode="object_forumthreadposts">
        
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