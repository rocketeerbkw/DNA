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
    
    
    <xsl:template match="TOPICLIST" mode="object_topiclist">
    	<xsl:param name="topic-layout" />
        
        <ul>
            <xsl:attribute name="class">
            	<xsl:text>topiclist</xsl:text>
            	<xsl:value-of select="$topic-layout" />
            	<xsl:if test="/H2G2/TOPICELEMENTLIST/TOPICELEMENT/IMAGENAME and /H2G2/SITECONFIG/V2_BOARDS/TOPICLAYOUT != '1col'">
            		<xsl:text> topiclistimage</xsl:text>
            	</xsl:if>
            </xsl:attribute>
            <xsl:apply-templates select="TOPIC" mode="object_topic"/>
        </ul>
        
    </xsl:template>
    
</xsl:stylesheet>