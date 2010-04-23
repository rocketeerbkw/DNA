<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms THREAD elements belonging to a forum. 
        </doc:purpose>
        <doc:context>
            Can be used on ARTICLE AND USERPAGE
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="FORUMTHREADS[THREAD]" mode="object_forumthreads">
        <xsl:if test="$siteClosed = 'false'">
			<xsl:apply-templates select="." mode="library_newdiscussion_link" />
        </xsl:if>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreads" />
        
        <ul class="forumthreads">
          <xsl:apply-templates select="THREAD" mode="object_thread" />
        </ul>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreads" />
        
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
              <xsl:apply-templates select="MODERATIONSTATUS" mode="moderation_cta_moderationstatus"/>
            </xsl:with-param>
          </xsl:call-template>
        
    </xsl:template>
    
    
    <xsl:template match="FORUMTHREADS" mode="object_forumthreads">
        <xsl:if test="$siteClosed = 'false'">
           	<xsl:apply-templates select="." mode="library_newdiscussion_link" />
        </xsl:if>
        
        <p class="forumthreads">
            There have been no discussions started here yet.
        </p>
        
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
              <xsl:apply-templates select="MODERATIONSTATUS" mode="moderation_cta_moderationstatus"/>
            </xsl:with-param>
        </xsl:call-template>
        
        
    </xsl:template>
    
</xsl:stylesheet>