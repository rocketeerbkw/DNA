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
    
    
    <xsl:template match="TOPICLIST" mode="objects_post_forumtitle">
        <xsl:param name="forumid" />

        <xsl:choose>
	        <xsl:when test="TOPIC/FORUMID = $forumid">
	       		<xsl:value-of select="TOPIC[FORUMID = $forumid]/TITLE"></xsl:value-of>
	       	</xsl:when>
	       	<xsl:otherwise>
	       		<xsl:text>Archived threads</xsl:text>
	       	</xsl:otherwise>
       	</xsl:choose>
    </xsl:template>
    
    
    
</xsl:stylesheet>