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
            <p class="dna-boards-startanewdiscussion">
            	<a href="{$root}/AddThread?forum={@FORUMID}%26article={/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}" class="id-cta">
                    <xsl:call-template name="library_memberservice_require">
                        <xsl:with-param name="ptrt">
                            <xsl:value-of select="$root"/>
                            <xsl:text>/AddThread?forum=</xsl:text>
                            <xsl:value-of select="@FORUMID"/>
                        	<xsl:text>%26article=</xsl:text>
                            <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:text>Start a new discussion</xsl:text>
                </a>
            </p>
        </xsl:if>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreads" />
        
        <ul class="forumthreads">
            <xsl:choose>
                <xsl:when test="ORDERBY = 'latestpost'">
                    <xsl:apply-templates select="THREAD" mode="object_thread">
                        <xsl:sort select="DATEPOSTED/DATE/@SORT" order="descending"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="THREAD" mode="object_thread">
                        <xsl:sort select="FIRSTPOST/DATE/@SORT" order="descending"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
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
            <p class="dna-boards-startanewdiscussion">
            	<a href="{$root}/AddThread?forum={@FORUMID}%26article={/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}" class="id-cta">
                    <xsl:call-template name="library_memberservice_require">
                        <xsl:with-param name="ptrt">
                            <xsl:value-of select="$root"/>
                            <xsl:text>/AddThread?forum=</xsl:text>
                            <xsl:value-of select="@FORUMID"/>
                        	<xsl:text>%26article=</xsl:text>
                            <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    <xsl:text>Start a new discussion</xsl:text>
                </a>
            </p>
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