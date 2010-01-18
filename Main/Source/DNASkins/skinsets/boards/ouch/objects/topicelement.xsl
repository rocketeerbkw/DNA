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
    
    
    <xsl:template match="TOPICELEMENT" mode="object_topicelement">
        
        <xsl:call-template name="library_header_h3">
            <xsl:with-param name="text">
                <a href="F{/H2G2/TOPICLIST/TOPIC[TOPICID = current()/TOPICID]/FORUMID}">
                    <xsl:value-of select="TITLE" />
                </a>
            </xsl:with-param>
        </xsl:call-template>
        
        <xsl:if test="IMAGENAME and IMAGENAME != ''">
          <div class="topicimage">
          	<a href="F{/H2G2/TOPICLIST/TOPIC[TOPICID = current()/TOPICID]/FORUMID}">
            	<img src="/dnaimages/ouch/images/{IMAGENAME}" alt="{IMAGEALTTEXT}"/>
          	</a>
          </div>
        </xsl:if>
        
        <p class="replies">
            <xsl:choose>
                <xsl:when test="(FORUMPOSTCOUNT - 1) &lt; 1">
                    <span class="dna-invisible">There have been </span>
                    <span class="noreplies">
                        <xsl:text>no replies</xsl:text>
                    </span>
                </xsl:when>
                <xsl:when test="(FORUMPOSTCOUNT - 1) = 1">
                    <xsl:value-of select="FORUMPOSTCOUNT - 1" />
                    <xsl:text> reply</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="FORUMPOSTCOUNT - 1" />
                    <xsl:text> replies</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </p>
        
        <p>
            <xsl:apply-templates select="TEXT" mode="library_Richtext" />
        </p>
        
        
    </xsl:template>
    
</xsl:stylesheet>